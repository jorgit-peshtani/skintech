# 🚀 SkinTech - Complete Startup Guide

## ✅ Current Status

**Backend is RUNNING:** `python app.py` (Port 3000) ✅
- Using SQLite database: `backend/skintech.db`
- Contains 16 products
- Serves Web + Mobile apps

---

## 🎯 Architecture Overview

```
                    ONE DATABASE
              backend/skintech.db (SQLite)
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
   [app.py:3000]  [admin_app.py:3001] [app.py:3000]
        │              │              │
        ▼              ▼              ▼
  [Web Frontend]  [Desktop Admin]  [Mobile App]
```

**✅ All 3 apps use the SAME database file!**

---

## 🚀 How to Start Everything

### 1. Backend (Main API) - Already Running ✅
```bash
cd backend
python app.py
```
- Port: 3000
- Serves: Web + Mobile
- Database: SQLite

### 2. Admin Backend (Desktop)
```bash
# Open NEW terminal
cd backend
python admin_app.py
```
- Port: 3001
- Serves: Desktop Admin only
- Same database as main backend

### 3. Web Frontend
```bash
# Open NEW terminal
cd frontend
npm run dev
```
- Visit: http://localhost:5173
- View products, login, shop

### 4. Desktop Admin
```bash
# Open NEW terminal
cd desktop
npm run dev
```
- Admin panel for managing:
  - Users
  - Products
  - Orders

### 5. Mobile App
```bash
# Open NEW terminal  
cd mobile
npx expo start
```
- Scan QR code with Expo Go app
- Uses same backend as web

---

## 📊 What Each App Does

### 🌐 Web Frontend (Port 5173)
- **Users can:**
  - Browse 16 skincare products
  - Filter by category (Cleanser, Moisturiser, Sunscreen, Toner)
  - Search products
  - Login/Register
  - Add to cart
  - Scan product ingredients

### 🖥️ Desktop Admin (Port 5173 - Electron)
- **Admins can:**
  - View all users
  - Manage products (Create, Edit, Delete)
  - View and process orders
  - See dashboard statistics
  - Full database control

### 📱 Mobile App (Expo)
- **Users can:**
  - Browse products
  - Camera scanning
  - Login/Register
  - Shopping cart
  - Profile management

---

## 🗄️ Database Contents

**File:** `backend/skintech.db` (SQLite)

**Tables:**
- `users` - User accounts (web, mobile, desktop admins)
- `products` - 16 skincare products
- `orders` - Customer orders
- `reviews` - Product reviews
- `ingredients` - Ingredient safety database
- `scans` - Product scan history
- And more...

**Sample Products:**
- CeraVe Hydrating Cleanser ($14.99)
- La Roche-Posay Effaclar Gel ($18.50)
- The Ordinary Squalane Cleanser ($8.00)
- ... and 13 more

---

## ✅ Verify Everything Works

**Run the test:**
```bash
python test_database_architecture.py
```

**Should show:**
- ✅ Web API connected (16 products)
- ✅ Admin API connected (16 products)
- ✅ Same database confirmed

---

## 🔧 Quick Commands

```bash
# Start everything (run each in separate terminal)
cd backend && python app.py                # Main API
cd backend && python admin_app.py          # Admin API
cd frontend && npm run dev                 # Web
cd desktop && npm run dev                  # Desktop
cd mobile && npx expo start                # Mobile

# Test
python test_database_architecture.py       # Verify setup
```

---

## 🎯 URLs

- **Web Frontend:** http://localhost:5173
- **Web Products:** http://localhost:5173/products
- **Main API:** http://localhost:3000/api
- **Admin API:** http://localhost:3001/api/admin
- **Mobile:** Expo QR Code

---

## ✅ Current State

- ✅ Database created with 16 products
- ✅ Backend configured to use SQLite
- ✅ Web frontend has modern product page
- ✅ Desktop admin has full CRUD
- ✅ Mobile app ready
- ✅ All use same database

**Everything is ready to use!** 🎉
