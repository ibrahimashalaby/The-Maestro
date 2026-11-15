FROM mcr.microsoft.com/powershell:latest

ENV POWERSHELL_TELEMETRY_OPTOUT=1
ENV MAESTRO_PUBLIC_MODE=true
WORKDIR /app

COPY outputs/server.ps1 outputs/load-env.ps1 outputs/index.html outputs/manifest.webmanifest outputs/service-worker.js ./
COPY outputs/icons/ ./icons/

EXPOSE 8080
CMD ["pwsh", "-NoLogo", "-NoProfile", "-File", "/app/server.ps1"]
