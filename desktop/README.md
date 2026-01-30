# SkinTech Desktop Admin Panel

Desktop control panel application for managing the SkinTech platform.

## Features

- 📊 **Dashboard** - Real-time statistics and overview
- 👥 **User Management** - View and manage all users
- 🛍️ **Product Management** - Add, edit, and manage products
- 📦 **Order Management** - Track and fulfill orders
- 🔬 **Scan Analytics** - View AI scanning statistics
- 🧪 **Ingredient Database** - Manage ingredient safety data
- ⚙️ **System Settings** - Configure application settings
- 📝 **Logs** - Monitor system logs and errors

## Quick Start

### Prerequisites
- Node.js installed
- Backend server running on `http://localhost:5000`

### Running the App

```bash
# From the skintech directory
start-desktop.bat

# Or manually:
cd desktop
npm run dev
```

### Login
- **Email**: `admin@skintech.com`
- **Password**: `admin123`

> Note: Only admin users can access this panel

## Development

### Project Structure
```
desktop/
├── src/
│   ├── main/           # Electron main process
│   ├── renderer/       # React UI
│   │   ├── components/ # Reusable components
│   │   ├── pages/      # Page components
│   │   └── services/   # API services
│   └── preload/        # Preload scripts
├── index.html          # Entry HTML
├── vite.config.js      # Vite configuration
└── package.json        # Dependencies
```

### Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run build:win` - Build Windows installer
- `npm run build:mac` - Build macOS installer
- `npm run build:linux` - Build Linux packages

## Building for Production

### Windows
```bash
npm run build:win
```
Output: `dist-electron/SkinTech Admin Setup.exe`

### macOS
```bash
npm run build:mac
```
Output: `dist-electron/SkinTech Admin.dmg`

### Linux
```bash
npm run build:linux
```
Output: `dist-electron/SkinTech Admin.AppImage`

## Technology Stack

- **Electron** - Desktop app framework
- **React** - UI framework
- **Vite** - Build tool and dev server
- **Axios** - HTTP client
- **Recharts** - Data visualization

## Admin API Requirements

The desktop app requires admin endpoints in the backend:

```
GET  /api/admin/stats/dashboard
GET  /api/admin/users
GET  /api/admin/products
GET  /api/admin/ingredients
GET  /api/admin/logs
```

> Note: Some features use mock data until backend endpoints are implemented

## Features Status

✅ Authentication (Login/Logout)
✅ Dashboard with Statistics
✅ Beautiful UI with Gradient Design
✅ Sidebar Navigation
🔄 User Management (Placeholder)
🔄 Product Management (Placeholder)
🔄 Order Management (Placeholder)
🔄 Scan Analytics (Placeholder)
🔄 Ingredient Database (Placeholder)
🔄 System Settings (Placeholder)
🔄 Logs Viewer (Placeholder)

## Troubleshooting

### "Cannot connect to backend"
Make sure the Flask backend is running:
```bash
cd backend
python app.py
```

### "Login failed"
- Ensure you're using admin credentials
- Check that the backend is accessible at `http://localhost:5000`

### Dev tools not showing
Press `F12` to toggle developer tools

## Next Steps

1. Implement remaining page components
2. Connect to real backend APIs
3. Add data tables and forms
4. Implement CRUD operations
5. Build production installers
