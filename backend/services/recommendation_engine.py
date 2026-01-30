"""
Recommendation Engine
Uses collaborative filtering and content-based filtering to recommend products
"""

import numpy as np
from typing import List, Dict, Optional
from models import User, Product, UserProfile, Order, OrderItem, Review, db
from sqlalchemy import and_, or_
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import TfidfVectorizer

class RecommendationEngine:
    def __init__(self):
        """Initialize the recommendation engine"""
        self.tfidf_vectorizer = TfidfVectorizer(max_features=100)
    
    def get_personalized_recommendations(
        self, 
        user_id: int, 
        limit: int = 10
    ) -> List[Dict]:
        """
        Get personalized product recommendations for a user
        
        Args:
            user_id: User ID
            limit: Maximum number of recommendations
            
        Returns:
            List of recommended products with scores
        """
        user = User.query.get(user_id)
        if not user or not user.profile:
            return self.get_popular_products(limit)
        
        # Combine multiple recommendation strategies
        content_recs = self.content_based_recommendations(user_id, limit * 2)
        collaborative_recs = self.collaborative_filtering(user_id, limit * 2)
        
        # Merge and rank recommendations
        recommendations = self.merge_recommendations(
            content_recs, 
            collaborative_recs, 
            limit
        )
        
        return recommendations
    
    def content_based_recommendations(
        self, 
        user_id: int, 
        limit: int = 10
    ) -> List[Dict]:
        """
        Content-based filtering using user profile and preferences
        
        Args:
            user_id: User ID
            limit: Maximum number of recommendations
            
        Returns:
            List of recommended products
        """
        user = User.query.get(user_id)
        if not user or not user.profile:
            return []
        
        profile = user.profile
        recommendations = []
        
        # Get products matching user's skin type
        query = Product.query.filter(Product.is_active == True)
        
        if profile.skin_type:
            skin_type_value = profile.skin_type.value
            query = query.filter(
                Product.suitable_for_skin_types.contains([skin_type_value])
            )
        
        # Filter by user preferences (concerns)
        if profile.preferences and 'concerns' in profile.preferences:
            concerns = profile.preferences['concerns']
            for concern in concerns:
                query = query.filter(
                    Product.target_concerns.contains([concern])
                )
        
        # Get products user hasn't purchased yet
        purchased_product_ids = db.session.query(OrderItem.product_id).join(
            Order
        ).filter(
            Order.user_id == user_id,
            Order.payment_status == 'completed'
        ).distinct().all()
        
        purchased_ids = [pid[0] for pid in purchased_product_ids]
        
        if purchased_ids:
            query = query.filter(~Product.id.in_(purchased_ids))
        
        # Order by rating and stock
        products = query.filter(Product.stock_quantity > 0).limit(limit).all()
        
        for product in products:
            recommendations.append({
                'product': product.to_dict(),
                'score': self.calculate_content_score(product, profile),
                'reason': self.generate_recommendation_reason(product, profile)
            })
        
        # Sort by score
        recommendations.sort(key=lambda x: x['score'], reverse=True)
        
        return recommendations
    
    def calculate_content_score(self, product: Product, profile: UserProfile) -> float:
        """
        Calculate content-based recommendation score
        
        Args:
            product: Product object
            profile: User profile
            
        Returns:
            Score (0-1)
        """
        score = 0.0
        
        # Skin type match (40% weight)
        if profile.skin_type and product.suitable_for_skin_types:
            if profile.skin_type.value in product.suitable_for_skin_types:
                score += 0.4
        
        # Concern match (40% weight)
        if profile.preferences and 'concerns' in profile.preferences:
            user_concerns = set(profile.preferences['concerns'])
            product_concerns = set(product.target_concerns or [])
            
            if user_concerns and product_concerns:
                overlap = len(user_concerns & product_concerns)
                score += 0.4 * (overlap / len(user_concerns))
        
        # Product rating (20% weight)
        avg_rating = product.get_average_rating()
        if avg_rating > 0:
            score += 0.2 * (avg_rating / 5.0)
        
        return min(score, 1.0)
    
    def collaborative_filtering(self, user_id: int, limit: int = 10) -> List[Dict]:
        """
        Collaborative filtering based on similar users' purchases
        
        Args:
            user_id: User ID
            limit: Maximum number of recommendations
            
        Returns:
            List of recommended products
        """
        # Find similar users based on purchase history and ratings
        similar_users = self.find_similar_users(user_id, top_n=10)
        
        if not similar_users:
            return []
        
        # Get products that similar users liked but current user hasn't purchased
        user_purchased = db.session.query(OrderItem.product_id).join(
            Order
        ).filter(
            Order.user_id == user_id,
            Order.payment_status == 'completed'
        ).distinct().all()
        
        user_purchased_ids = [pid[0] for pid in user_purchased]
        
        # Get products from similar users
        similar_user_ids = [u['user_id'] for u in similar_users]
        
        recommended_products = db.session.query(
            Product,
            db.func.count(OrderItem.id).label('purchase_count'),
            db.func.avg(Review.rating).label('avg_rating')
        ).join(
            OrderItem
        ).join(
            Order
        ).outerjoin(
            Review, and_(Review.product_id == Product.id, Review.user_id.in_(similar_user_ids))
        ).filter(
            Order.user_id.in_(similar_user_ids),
            Order.payment_status == 'completed',
            Product.is_active == True,
            Product.stock_quantity > 0,
            ~Product.id.in_(user_purchased_ids) if user_purchased_ids else True
        ).group_by(
            Product.id
        ).order_by(
            db.desc('purchase_count'),
            db.desc('avg_rating')
        ).limit(limit).all()
        
        recommendations = []
        for product, purchase_count, avg_rating in recommended_products:
            score = self.calculate_collaborative_score(purchase_count, avg_rating or 0)
            recommendations.append({
                'product': product.to_dict(),
                'score': score,
                'reason': f"Popular among users with similar preferences ({purchase_count} purchases)"
            })
        
        return recommendations
    
    def find_similar_users(self, user_id: int, top_n: int = 10) -> List[Dict]:
        """
        Find users with similar profiles and purchase history
        
        Args:
            user_id: User ID
            top_n: Number of similar users to return
            
        Returns:
            List of similar users with similarity scores
        """
        user = User.query.get(user_id)
        if not user or not user.profile:
            return []
        
        # Get all users with profiles
        users_with_profiles = User.query.join(UserProfile).filter(
            User.id != user_id,
            User.is_active == True
        ).all()
        
        similar_users = []
        
        for other_user in users_with_profiles:
            similarity = self.calculate_user_similarity(user, other_user)
            if similarity > 0.3:  # Threshold
                similar_users.append({
                    'user_id': other_user.id,
                    'similarity': similarity
                })
        
        # Sort by similarity
        similar_users.sort(key=lambda x: x['similarity'], reverse=True)
        
        return similar_users[:top_n]
    
    def calculate_user_similarity(self, user1: User, user2: User) -> float:
        """
        Calculate similarity between two users
        
        Args:
            user1: First user
            user2: Second user
            
        Returns:
            Similarity score (0-1)
        """
        if not user1.profile or not user2.profile:
            return 0.0
        
        score = 0.0
        
        # Skin type match (50% weight)
        if user1.profile.skin_type == user2.profile.skin_type:
            score += 0.5
        
        # Concern overlap (50% weight)
        prefs1 = user1.profile.preferences or {}
        prefs2 = user2.profile.preferences or {}
        
        concerns1 = set(prefs1.get('concerns', []))
        concerns2 = set(prefs2.get('concerns', []))
        
        if concerns1 and concerns2:
            overlap = len(concerns1 & concerns2)
            union = len(concerns1 | concerns2)
            score += 0.5 * (overlap / union if union > 0 else 0)
        
        return score
    
    def calculate_collaborative_score(
        self, 
        purchase_count: int, 
        avg_rating: float
    ) -> float:
        """
        Calculate collaborative filtering score
        
        Args:
            purchase_count: Number of purchases by similar users
            avg_rating: Average rating
            
        Returns:
            Score (0-1)
        """
        # Normalize purchase count (assume max 10 purchases)
        purchase_score = min(purchase_count / 10.0, 1.0)
        
        # Normalize rating (0-5 scale)
        rating_score = avg_rating / 5.0 if avg_rating > 0 else 0.5
        
        # Weighted combination
        return 0.6 * purchase_score + 0.4 * rating_score
    
    def merge_recommendations(
        self, 
        content_recs: List[Dict], 
        collaborative_recs: List[Dict], 
        limit: int
    ) -> List[Dict]:
        """
        Merge recommendations from different strategies
        
        Args:
            content_recs: Content-based recommendations
            collaborative_recs: Collaborative filtering recommendations
            limit: Maximum number to return
            
        Returns:
            Merged and ranked recommendations
        """
        # Create a dictionary to combine scores
        product_scores = {}
        
        # Add content-based recommendations (60% weight)
        for rec in content_recs:
            product_id = rec['product']['id']
            product_scores[product_id] = {
                'product': rec['product'],
                'score': rec['score'] * 0.6,
                'reasons': [rec['reason']]
            }
        
        # Add collaborative recommendations (40% weight)
        for rec in collaborative_recs:
            product_id = rec['product']['id']
            if product_id in product_scores:
                product_scores[product_id]['score'] += rec['score'] * 0.4
                product_scores[product_id]['reasons'].append(rec['reason'])
            else:
                product_scores[product_id] = {
                    'product': rec['product'],
                    'score': rec['score'] * 0.4,
                    'reasons': [rec['reason']]
                }
        
        # Convert to list and sort
        recommendations = [
            {
                'product': data['product'],
                'score': data['score'],
                'reason': ' | '.join(data['reasons'])
            }
            for data in product_scores.values()
        ]
        
        recommendations.sort(key=lambda x: x['score'], reverse=True)
        
        return recommendations[:limit]
    
    def get_popular_products(self, limit: int = 10) -> List[Dict]:
        """
        Get popular products (fallback when no user data available)
        
        Args:
            limit: Maximum number of products
            
        Returns:
            List of popular products
        """
        products = Product.query.filter(
            Product.is_active == True,
            Product.stock_quantity > 0
        ).limit(limit).all()
        
        recommendations = []
        for product in products:
            avg_rating = product.get_average_rating()
            recommendations.append({
                'product': product.to_dict(),
                'score': avg_rating / 5.0 if avg_rating > 0 else 0.5,
                'reason': 'Popular product'
            })
        
        recommendations.sort(key=lambda x: x['score'], reverse=True)
        
        return recommendations
    
    def generate_recommendation_reason(
        self, 
        product: Product, 
        profile: UserProfile
    ) -> str:
        """
        Generate human-readable reason for recommendation
        
        Args:
            product: Product object
            profile: User profile
            
        Returns:
            Reason string
        """
        reasons = []
        
        if profile.skin_type and product.suitable_for_skin_types:
            if profile.skin_type.value in product.suitable_for_skin_types:
                reasons.append(f"Perfect for {profile.skin_type.value} skin")
        
        if profile.preferences and 'concerns' in profile.preferences:
            user_concerns = set(profile.preferences['concerns'])
            product_concerns = set(product.target_concerns or [])
            overlap = user_concerns & product_concerns
            
            if overlap:
                reasons.append(f"Targets your concerns: {', '.join(overlap)}")
        
        avg_rating = product.get_average_rating()
        if avg_rating >= 4.0:
            reasons.append(f"Highly rated ({avg_rating:.1f}/5)")
        
        if not reasons:
            reasons.append("Recommended for you")
        
        return ' | '.join(reasons)
