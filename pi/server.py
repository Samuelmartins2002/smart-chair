#!/usr/bin/env python3
"""Servidor WebSocket do Smart Chair (simulador).

Roda no PC para testes e, depois, no Raspberry Pi. Na versão real, as
partes marcadas com TODO-PI trocam a simulação por sensores/motores.
"""
import asyncio
import json
import logging
import os
import random
import socket
import time

import websockets

HOST = os.getenv("CHAIR_HOST", "0.0.0.0")
PORT = int(os.getenv("CHAIR_PORT", "8765"))
TOKEN = os.getenv("CHAIR_TOKEN", "")  # vazio = sem autenticação

TICK_S = 0.1            # passo da simulação
STATUS_EVERY_S = 0.5    # frequência de envio do status
WATCHDOG_S = 0.5        # sem comando por este tempo => parar
SAFE_DISTANCE_CM = 30   # obstáculo mais perto => parada automática
VALID_COMMANDS = {"frente", "tras", "esquerda", "direita", "parar"}

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(message)s")
log = logging.getLogger("smart-chair")


def local_ip() -> str:
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("10.255.255.255", 1))  # não envia nada, só descobre a interface
        return s.getsockname()[0]
    except OSError:
        return "127.0.0.1"
    finally:
        s.close()


class ChairSim:
    """Estado da cadeira. TODO-PI: ler sensores reais e acionar motores."""

    def __init__(self) -> None:
        self.battery = 78.0
        self.mode = "gesto"
        self.command = "parar"
        self.temp = 22.0
        self.obstacle_cm = None
        self.ip = local_ip()
        self._last_cmd = time.monotonic()
        self._obstacle_until = 0.0
        self._alerts: dict[str, float] = {}

    def _alert(self, text: str, seconds: float = 3.0) -> None:
        self._alerts[text] = time.monotonic() + seconds

    def apply_command(self, value: str) -> None:
        if value not in VALID_COMMANDS:
            log.warning("comando inválido: %r", value)
            return
        if value != "parar":
            if self.battery <= 0:
                self._alert("Bateria esgotada")
                return
            if (
                value == "frente"
                and self.obstacle_cm is not None
                and self.obstacle_cm < SAFE_DISTANCE_CM
            ):
                self._alert("Parada automática: obstáculo")
                self.command = "parar"
                return
        if value != self.command:
            log.info("comando: %s", value)
        self.command = value
        self._last_cmd = time.monotonic()

    def stop(self, reason: str) -> None:
        if self.command != "parar":
            log.info("parando (%s)", reason)
        self.command = "parar"

    def tick(self, dt: float) -> None:
        now = time.monotonic()

        # Watchdog: sem comandos recentes => para
        if self.command != "parar" and now - self._last_cmd > WATCHDOG_S:
            self.stop("watchdog")
            self._alert("Watchdog: sem comandos, cadeira parada")

        # Obstáculos simulados (TODO-PI: ler ultrassônico)
        if self.obstacle_cm is not None and now > self._obstacle_until:
            self.obstacle_cm = None
        elif self.obstacle_cm is None:
            chance = 0.02 if self.command == "frente" else 0.002
            if random.random() < chance:
                self.obstacle_cm = round(random.uniform(15, 45), 1)
                self._obstacle_until = now + random.uniform(2, 4)

        # Parada automática
        if (
            self.command == "frente"
            and self.obstacle_cm is not None
            and self.obstacle_cm < SAFE_DISTANCE_CM
        ):
            self.stop("obstáculo")
            self._alert("Parada automática: obstáculo")

        # Bateria e temperatura
        moving = self.command != "parar"
        self.battery = max(0.0, self.battery - dt * (0.1 if moving else 0.02))
        if self.battery <= 0:
            self.stop("bateria esgotada")
        self.temp = min(35.0, max(18.0, self.temp + random.uniform(-0.05, 0.05)))

    def snapshot(self) -> dict:
        now = time.monotonic()
        alerts = []
        if self.obstacle_cm is not None:
            alerts.append("Obstáculo próximo")
        for text, until in list(self._alerts.items()):
            if until > now:
                alerts.append(text)
            else:
                del self._alerts[text]

        battery = int(self.battery)
        if battery <= 5:
            state = "emergencia"
        elif alerts:
            state = "alerta"
        else:
            state = "normal"

        return {
            "type": "status",
            "battery": battery,
            "mode": self.mode,
            "state": state,
            "obstacle": self.obstacle_cm is not None,
            "obstacle_distance_cm": self.obstacle_cm,
            "alerts": alerts,
            "ip": self.ip,
            "sensors": [
                {"name": "MPU-6050", "detail": "Movimento / Direção", "active": True},
                {"name": "Ultrassônico", "detail": "Detecção de obstáculos", "active": True},
                {"name": "Hall", "detail": "Rodas / Velocidade", "active": True},
                {"name": "Temperatura", "detail": "LM35", "active": True,
                 "value": f"{round(self.temp)} °C"},
            ],
        }


sim = ChairSim()
clients: set = set()


async def handler(ws) -> None:
    peer = ws.remote_address
    # Handshake: a 1ª mensagem do app deve ser {"type":"hello","token":"..."}
    try:
        msg = json.loads(await asyncio.wait_for(ws.recv(), timeout=5))
    except Exception:
        await ws.close(code=1008, reason="hello esperado")
        return
    if msg.get("type") != "hello" or (TOKEN and msg.get("token") != TOKEN):
        log.warning("conexão recusada: %s", peer)
        await ws.send(json.dumps({"type": "error", "reason": "unauthorized"}))
        await ws.close(code=1008, reason="unauthorized")
        return

    clients.add(ws)
    log.info("app conectado: %s", peer)
    try:
        await ws.send(json.dumps({"type": "hello_ok"}))
        async for raw in ws:
            try:
                data = json.loads(raw)
            except json.JSONDecodeError:
                continue
            if data.get("type") == "command":
                sim.apply_command(str(data.get("value", "")))
    except websockets.ConnectionClosed:
        pass
    finally:
        clients.discard(ws)
        log.info("app desconectado: %s", peer)
        if not clients:
            sim.stop("app desconectado")  # segurança


async def sim_loop() -> None:
    last_status = 0.0
    while True:
        await asyncio.sleep(TICK_S)
        sim.tick(TICK_S)
        now = time.monotonic()
        if clients and now - last_status >= STATUS_EVERY_S:
            websockets.broadcast(clients, json.dumps(sim.snapshot()))
            last_status = now


async def main() -> None:
    async with websockets.serve(handler, HOST, PORT):
        log.info("Smart Chair ouvindo em ws://%s:%d", sim.ip, PORT)
        log.info("Token: %s", "ativado" if TOKEN else "desativado")
        await sim_loop()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        log.info("encerrado")