# Protocolo App ↔ Raspberry Pi

Transporte: WebSocket, `ws://<ip-do-pi>:8765`. Mensagens em JSON (UTF-8).

## 1. Handshake (obrigatório)
O app envia, logo após conectar:
{ "type": "hello", "token": "1234" }

- Sem token configurado no Pi: qualquer valor é aceito (pode ser "").
- Sucesso: Pi responde { "type": "hello_ok" }.
- Falha: { "type": "error", "reason": "unauthorized" } e fecha a conexão.

## 2. Pi → App: status (a cada ~0,5 s)
{
  "type": "status",
  "battery": 78,                  // 0-100
  "mode": "gesto",                // gesto | voz | app
  "state": "normal",              // normal | alerta | emergencia
  "obstacle": false,
  "obstacle_distance_cm": null,   // número quando há obstáculo
  "alerts": [],                   // lista de textos
  "ip": "192.168.0.123",
  "sensors": [
    { "name": "MPU-6050", "detail": "Movimento / Direção", "active": true },
    { "name": "Temperatura", "detail": "LM35", "active": true, "value": "22 °C" }
  ]
}

## 3. App → Pi: comando
{ "type": "command", "value": "frente" }
Valores: frente | tras | esquerda | direita | parar

Enquanto o botão estiver pressionado, o app reenvia o comando a cada 150 ms.

## 4. Regras de segurança (responsabilidade do Pi)
- Watchdog: movimento sem comando por mais de 500 ms => parar.
- `parar` tem efeito imediato.
- Cliente desconectado => parar.
- Obstáculo < 30 cm indo para frente => parada automática + alerta.
- O app nunca é a única proteção.