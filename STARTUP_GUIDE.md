# 🚀 SkinTech - Quick Start Scripts

## 📁 Batch Files Created

### 1. `start-web.bat` - Start Web Application
**What it does:**
- Starts Flask backend (port 3000)
- Starts React frontend (port 5173)

**Use when:** You want to run the website only

---

### 2. `start-desktop.bat` - Start Desktop Application
**What it does:**
- Starts Admin backend (port 3001)
- Starts Electron desktop app

**Use when:** You want to run the desktop admin panel only

---

### 3. `start-all.bat` - Start Everything
**What it does:**
- Starts main backend (port 3000)
- Starts admin backend (port 3001)
- Starts web frontend (port 5173)
- Starts desktop app

**Use when:** You want to run both web and desktop together

---

### 4. `stop-all.bat` - Stop All Processes
**What it does:**
- Kills all Node.js processes
- Kills all Python processes
- Kills all Electron processes

**Use when:** You want to stop everything at once

---

## 🎯 How to Use

### Option 1: Double-Click
Just double-click any `.bat` file in Windows Explorer

### Option 2: Run from Terminal
```bash
cd c:\Users\jpesh\Desktop\diploma\skintech

# Start web app
start-web.bat

# Start desktop app
start-desktop.bat

# Start everything
start-all.bat

# Stop everything
stop-all.bat
```

---

## 📊 What Runs Where

### Web App (`start-web.bat`)
```
Terminal 1: Flask Backend (http://localhost:3000)
Terminal 2: React Frontend (http://localhost:5173)
```

### Desktop App (`start-desktop.bat`)
```
Terminal 1: Admin Backend (http://localhost:3001)
Terminal 2: Electron Desktop
```

### Everything (`start-all.bat`)
```
Terminal 1: Flask Backend (http://localhost:3000)
Terminal 2: Admin Backend (http://localhost:3001)
Terminal 3: React Frontend (http://localhost:5173)
Terminal 4: Electron Desktop
```

---

## ⚡ Quick Reference

| File | What Starts | Ports | Best For |
|------|-------------|-------|----------|
| `start-web.bat` | Web only | 3000, 5173 | Testing website |
| `start-desktop.bat` | Desktop only | 3001 | Admin work |
| `start-all.bat` | Everything | 3000, 3001, 5173 | Full testing |
| `stop-all.bat` | Stops all | - | Cleanup |

---

## 🔧 Troubleshooting

**Problem:** Port already in use
**Fix:** Run `stop-all.bat` first, then try again

**Problem:** Python/Node not found
**Fix:** Make sure Python and Node.js are installed and in PATH

**Problem:** "Access denied"
**Fix:** Run as Administrator (right-click → "Run as administrator")

---

## 💡 Tips

1. **For development:** Use `start-all.bat` to test everything together
2. **For web only:** Use `start-web.bat` to save resources
3. **After done:** Always run `stop-all.bat` to clean up
4. **Each terminal stays open** so you can see logs and errors

---

## ✅ Created Files

- ✅ `start-web.bat`
- ✅ `start-desktop.bat`  
- ✅ `start-all.bat`
- ✅ `stop-all.bat`

**All ready to use!** Just double-click to start. 🚀
