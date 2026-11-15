# Deploy Maestro on Railway

The Railway container uses the PowerShell HTTP service and listens on Railway's injected `PORT`. The service must run with `MAESTRO_PUBLIC_MODE=true`; public mode requires an app password and a separate session-signing secret. The app APIs are not exposed until the browser has signed in. User profiles, web trails, and chat history remain in each visitor's browser.

## Publish from this folder

1. Install Railway CLI from Railway's official instructions and sign in to the Railway account that should own this service.
2. Create a Railway project and an empty service, then link this local folder to that project with `railway link`.
3. Add the service variables listed below in Railway's Variables page. Enter each secret individually; do not import this computer's `.env` file.
4. Deploy this folder with `railway up`.
5. Set the service healthcheck path to `/health`, generate a Railway domain in the service's Networking settings, then open that HTTPS address.

The Dockerfile is detected at the workspace root. Railway supplies `PORT`; the PowerShell server binds to all container interfaces only in public mode. Railway public domains provide HTTPS. Railway's current public-networking guide documents generating a `*.up.railway.app` domain and its healthcheck guide documents the injected port behavior.

## Required service variables

- `MAESTRO_PUBLIC_MODE=true`
- `APP_ACCESS_PASSWORD` — a long, private password shared with the intended users.
- `APP_SESSION_SECRET` — a separate randomly generated value used to sign seven-day login cookies.
- `EXA_API_KEY` — the Exa key used for web search.
- `ANTHROPIC_API_KEY` — the Claude key used for LLM responses.
- `ANTHROPIC_MODEL=claude-sonnet-4-6`
- `LLM_PROVIDER=anthropic`

Do not add either API key to the repository, Docker image, or a public client bundle. Railway variables are injected at runtime. Avoid placing secrets in CLI command history; use the Railway dashboard's variable editor.

## Costs and access

Railway hosting and the Exa/Anthropic APIs may incur usage charges. Set account-level spending limits where available and check current rates before deployment. A generated Railway domain is public, but Maestro requires the shared access password before using the Exa or Claude endpoints.
