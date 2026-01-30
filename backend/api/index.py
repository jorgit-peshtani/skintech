from app import app

# Vercel serverless function handler
def handler(request):
    return app(request.environ, start_response)

# For local testing
if __name__ == "__main__":
    app.run()
