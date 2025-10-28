# Configuración CORS para Backend Node.js - OrdenaYa

## 🎯 **Configuración Actual**
- ✅ **IP configurada**: `192.168.1.20:3000`
- ✅ **Servidor responde**: Confirmado con curl
- ✅ **App configurada**: Usando IP real

## 🛠️ **Configuración CORS (Si es necesario)**

### **Para Express.js:**

```javascript
// En tu servidor Node.js
const express = require('express');
const cors = require('cors');
const app = express();

// Configuración CORS para desarrollo
const corsOptions = {
  origin: [
    'http://localhost:3000',
    'http://192.168.1.20:3000',
    'http://10.0.2.2:3000',
    // Agrega más orígenes si es necesario
  ],
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
  credentials: true
};

app.use(cors(corsOptions));

// O para desarrollo rápido (menos seguro):
// app.use(cors()); // Permite todos los orígenes

// Tus rutas
app.get('/api/ordenes', (req, res) => {
  // Tu lógica aquí
});

app.listen(3000, '0.0.0.0', () => {
  console.log('Servidor corriendo en http://0.0.0.0:3000');
  console.log('Accesible desde:');
  console.log('- http://localhost:3000');
  console.log('- http://192.168.1.20:3000');
});
```

### **Configuración del Host**

Asegúrate de que tu servidor esté configurado para escuchar en todas las interfaces:

```javascript
// ✅ Correcto - Escucha en todas las interfaces
app.listen(3000, '0.0.0.0', callback);

// ❌ Incorrecto - Solo localhost
app.listen(3000, 'localhost', callback);
app.listen(3000, '127.0.0.1', callback);
```

## 🔧 **Verificación de Configuración**

### **1. Verificar que el servidor escuche en todas las interfaces:**
```bash
netstat -an | findstr :3000
```

Deberías ver algo como:
```
TCP    0.0.0.0:3000           0.0.0.0:0              LISTENING
```

### **2. Verificar acceso desde la red:**
```bash
# Desde tu máquina
curl http://192.168.1.20:3000/api/ordenes

# Debería devolver los datos JSON
```

### **3. Verificar firewall (Windows):**
Si tienes problemas, verifica que el puerto 3000 esté abierto:
```bash
# Abrir puerto en Windows Firewall
netsh advfirewall firewall add rule name="Node.js Port 3000" dir=in action=allow protocol=TCP localport=3000
```

## 📱 **Configuración Flutter Actualizada**

La app ahora usa automáticamente:
```dart
// lib/core/config/api_config.dart
static const String? _customHost = '192.168.1.20'; // ✅ Tu IP

// URLs resultantes:
// Android: http://192.168.1.20:3000/api/ordenes
// iOS: http://192.168.1.20:3000/api/ordenes  
// Desktop: http://192.168.1.20:3000/api/ordenes
```

## 🚀 **Solución Rápida**

Si tu servidor Node.js no está configurado para CORS, agrega esto:

```javascript
// Solución rápida para desarrollo
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Accept');
  
  if (req.method === 'OPTIONS') {
    res.sendStatus(200);
  } else {
    next();
  }
});
```

## ✅ **Checklist de Verificación**

- ✅ Servidor corriendo en `0.0.0.0:3000`
- ✅ CORS configurado (si es necesario)
- ✅ Firewall permite puerto 3000
- ✅ App Flutter usa IP `192.168.1.20`
- ✅ Curl funciona desde IP real

**¡Con estos cambios, la aplicación debería conectar correctamente!** 🎉