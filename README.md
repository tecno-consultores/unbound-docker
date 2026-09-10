# Unbound DNS Resolver en Docker

Este repositorio contiene una configuración optimizada para desplegar [Unbound](https://nlnetlabs.nl/projects/unbound/about/), un servidor DNS recursivo, con validación DNSSEC y caché de alto rendimiento, utilizando Docker y Docker Compose.

## Características Principales

* **Optimizado para Docker**: Utiliza la imagen `klutchell/unbound:latest` y está ajustado para respetar los límites de descriptores de archivos nativos de Docker (`outgoing-range: 460`, `num-queries-per-thread: 230`).
* **Alto Rendimiento y Caché**: Configurado con pre-obtención de registros (`prefetch: yes`), entrega de registros expirados mientras se actualizan (`serve-expired: yes`), y un TTL mínimo de 1 hora para garantizar respuestas DNS casi instantáneas.
* **Validación DNSSEC estricta**: Garantiza la autenticidad e integridad de las respuestas DNS (`harden-dnssec-stripped: yes`).
* **Privacidad y Seguridad**: Oculta la identidad y la versión del servidor, y protege tu red contra ataques de *DNS Rebinding* bloqueando la resolución de rangos de IP locales hacia el exterior.
* **Buffers de Red Mejorados**: Utiliza `cap_add: NET_ADMIN` en Docker Compose para permitir que Unbound incremente el tamaño de los búferes del kernel (`so-rcvbuf: 4m`).
* **Healthcheck Integrado**: El contenedor verifica automáticamente su propio estado realizando consultas locales mediante `dig` con validación DNSSEC.

## Archivos del Repositorio

* `docker-compose.yml`: Archivo de orquestación que define el contenedor, mapeo de puertos, volúmenes, capacidades del kernel y chequeos de salud.
* `unbound.conf`: Archivo de configuración principal del servidor, completamente tuneado y comentado.
* `root.hints`: Directorio de servidores raíz de Internet (actualizado a septiembre de 2026). Esencial para la resolución recursiva independiente.

## Requisitos Previos

* Docker
* Docker Compose

## Despliegue

1. Clona este repositorio o descarga los archivos en un mismo directorio de tu servidor.
2. **Importante:** Asegúrate de que `root.hints` y `unbound.conf` existan físicamente en el directorio como archivos de texto antes de ejecutar el contenedor. Si no existen, el mapeo de volúmenes de Docker fallará o creará carpetas vacías por error.
3. Levanta el servicio en segundo plano:

   ```bash
   docker-compose up -d
   ```

4. Revisa los registros para confirmar un inicio exitoso y sin advertencias de límites de puertos:

   ```bash
   docker-compose logs -f unbound
   ```

## Pruebas de funcionamiento

Una vez que el contenedor indique que está `healthy`, puedes probar la resolución DNS apuntando una consulta local al puerto 53:

```bash
dig @127.0.0.1 [www.google.com](https://www.google.com)
```

También puedes verificar que DNSSEC esté funcionando correctamente consultando un dominio de prueba:

```bash
dig @127.0.0.1 sigok.verteiltesysteme.net
```
