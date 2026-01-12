const { app, BrowserWindow } = require('electron');
const path = require('path');

function createWindow() {
  const mainWindow = new BrowserWindow({
    width: 1280,
    height: 800,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      webviewTag: false,
      // SECURITY NOTE: Disabling webSecurity is necessary because fmhy.net
      // sends X-Frame-Options: DENY and frame-ancestors 'none' CSP headers,
      // which prevent the site from being loaded in an iframe.
      // Without this setting, the app shows a white screen.
      // Security mitigations: nodeIntegration and contextIsolation remain enabled.
      webSecurity: false
    },
    title: 'FMHY - FreeMediaHeckYeah'
  });

  mainWindow.loadFile(path.join(__dirname, 'index.html'));
  
  // Open DevTools only in development
  if (process.env.NODE_ENV === 'development' || process.argv.includes('--dev')) {
    mainWindow.webContents.openDevTools();
  }

  // Log any console messages from the renderer process
  mainWindow.webContents.on('console-message', (event, level, message, line, sourceId) => {
    console.log(`[Renderer Console] ${message}`);
  });

  // Log when page finishes loading
  mainWindow.webContents.on('did-finish-load', () => {
    console.log('Main window loaded successfully');
  });

  // Log any loading failures
  mainWindow.webContents.on('did-fail-load', (event, errorCode, errorDescription) => {
    console.error(`Failed to load: ${errorDescription} (${errorCode})`);
  });
}

app.whenReady().then(() => {
  createWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
