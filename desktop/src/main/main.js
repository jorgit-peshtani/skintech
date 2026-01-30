const { app, BrowserWindow, Menu, ipcMain } = require('electron');
const path = require('path');

let mainWindow;

function createWindow() {
    mainWindow = new BrowserWindow({
        width: 1400,
        height: 900,
        minWidth: 1200,
        minHeight: 700,
        webPreferences: {
            nodeIntegration: false,
            contextIsolation: true,
            preload: path.join(__dirname, '../preload/preload.js')
        },
        icon: path.join(__dirname, '../../build/icon.png'),
        title: 'SkinTech Admin Control Panel',
        backgroundColor: '#1a1a2e',
    });

    // Load the app
    // Check if app is packaged (production) or not (development)
    const isDev = !app.isPackaged;

    if (isDev) {
        // Development mode - load from Vite dev server
        console.log('Running in DEVELOPMENT mode - loading from http://localhost:5174');
        mainWindow.loadURL('http://localhost:5174').catch((err) => {
            console.error('Failed to load dev server:', err);
            console.error('Make sure Vite is running: npm run dev:vite');
        });
        mainWindow.webContents.openDevTools();
    } else {
        // Production mode - load from built files
        console.log('Running in PRODUCTION mode - loading from dist folder');
        mainWindow.loadFile(path.join(__dirname, '../../dist/index.html'));
    }

    // Create the application menu
    createMenu();

    mainWindow.on('closed', () => {
        mainWindow = null;
    });
}

function createMenu() {
    const template = [
        {
            label: 'File',
            submenu: [
                {
                    label: 'Refresh',
                    accelerator: 'F5',
                    click: () => {
                        if (mainWindow) mainWindow.reload();
                    }
                },
                { type: 'separator' },
                {
                    label: 'Exit',
                    accelerator: 'Alt+F4',
                    click: () => {
                        app.quit();
                    }
                }
            ]
        },
        {
            label: 'View',
            submenu: [
                {
                    label: 'Toggle Developer Tools',
                    accelerator: 'F12',
                    click: () => {
                        if (mainWindow) mainWindow.webContents.toggleDevTools();
                    }
                },
                { type: 'separator' },
                { role: 'resetZoom' },
                { role: 'zoomIn' },
                { role: 'zoomOut' }
            ]
        },
        {
            label: 'Help',
            submenu: [
                {
                    label: 'About SkinTech Admin',
                    click: () => {
                        const { dialog } = require('electron');
                        dialog.showMessageBox(mainWindow, {
                            type: 'info',
                            title: 'About SkinTech Admin',
                            message: 'SkinTech Admin Control Panel',
                            detail: 'Version 1.0.0\n\nManage your SkinTech platform with ease.',
                            buttons: ['OK']
                        });
                    }
                }
            ]
        }
    ];

    const menu = Menu.buildFromTemplate(template);
    Menu.setApplicationMenu(menu);
}

// App lifecycle
app.whenReady().then(() => {
    console.log('Electron app starting...');
    createWindow();
});

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
        app.quit();
    }
});

app.on('activate', () => {
    if (mainWindow === null) {
        createWindow();
    }
});

// IPC handlers
ipcMain.handle('get-app-version', () => {
    return app.getVersion();
});

ipcMain.handle('get-app-path', () => {
    return app.getPath('userData');
});
