import bcrypt
import sys

def generate_hash(password):
    """
    Generates a bcrypt hash for a given string.
    Note: This is a standalone utility script.
    """
    # Generate a salt (default rounds is 12)
    salt = bcrypt.gensalt()
    # Hash the password
    hashed_password = bcrypt.hashpw(password.encode('utf-8'), salt)
    return hashed_password.decode('utf-8')

if __name__ == "__main__":
    print("--- SkinTech Bcrypt Hash Generator ---")
    
    if len(sys.argv) > 1:
        password = sys.argv[1]
    else:
        password = input("Enter the string to hash: ")
    
    if not password:
        print("Error: No input provided.")
        sys.exit(1)
        
    hashed = generate_hash(password)
    print(f"\nOriginal: {password}")
    print(f"Hash:     {hashed}")
    print("\n--------------------------------------")
