# Quick Start - Desktop Admin Panel

## The Error You Saw

The error `ERR_FILE_NOT_FOUND` for `dist/index.html` happens because Electron was looking for production build files that don't exist yet. This is now fixed!

## How to Run (Fixed)

The desktop app needs both the **Vite dev server** and **Electron** running together.

### Option 1: Automatic Start (Recommended)

```bash
cd desktop
npm run dev
```

This will:
1. Start Vite dev server on `http://localhost:5174`
2. Wait for the server to be ready
3. Launch Electron automatically

### Option 2: Manual Start (For Debugging)

If automatic start has issues, run these in **separate terminals**:

**Terminal 1 - Start Vite:**
```bash
cd desktop
npm run dev:vite
```
Wait until you see: `Local: http://localhost:5174/`

**Terminal 2 - Start Electron:**
```bash
cd desktop
npm run dev:electron
```

## What Was Fixed

### Before (Broken):
- Electron tried to load from `dist/index.html` (doesn't exist in dev)
- `NODE_ENV` wasn't properly set

### After (Fixed):
- Electron detects development mode using `app.isPackaged`
- Loads from Vite dev server: `http://localhost:5174`
- Better error handling if Vite isn't running

## Troubleshooting

### "Failed to load dev server"

**Problem**: Vite dev server isn't running

**Solution**: Make sure Vite starts first
```bash
# Kill any existing processes
# Then run:
cd desktop
npm run dev
```

### Port 5174 already in use

**Problem**: Another app is using port 5174

**Solution 1**: Kill the process using that port
```bash
# Find the process
netstat -ano | findstr :5174

# Kill it (replace PID with actual number)
taskkill /PID <PID> /F
```

**Solution 2**: Change the port in `vite.config.js`:
```javascript
server: {
  port: 5175,  // Change to a different port
},
```
And update in `main.js` to match.

### Window opens but shows blank/error

**Problem**: Vite server not ready yet

**Solution**: The app should wait automatically. If not, manually start Vite first, wait for it to fully load, then start Electron.

## Login

Once the app opens:
- **Email**: `admin@skintech.com`
- **Password**: `admin123`

## Development Workflow

1. Start the app: `npm run dev`
2. Make changes to files in `src/renderer/`
3. App auto-reloads (hot module replacement)
4. Press `F12` for developer tools

## Building for Production

When ready to create an installer:

```bash
# Build the app first
npm run build

# Then create installer
npm run build:win   # Windows
npm run build:mac   # macOS
npm run build:linux # Linux
```

The installer will be in `dist-electron/`

## Quick Reference

| Command | Purpose |
|---------|---------|
| `npm run dev` | Start development mode |
| `npm run dev:vite` | Start only Vite server |
| `npm run dev:electron` | Start only Electron |
| `npm run build` | Build for production |
| `npm run build:win` | Create Windows installer |

Now try running `npm run dev` again - it should work! 🚀
