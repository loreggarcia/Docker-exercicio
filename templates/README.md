# Como adaptar templates
Os Dockerfiles são padrões a copiar para contextos compatíveis, não projetos autossuficientes. Flask espera requirements.txt e app.py; Go espera go.mod e main.go; React espera package.json, package-lock.json, index.html, src/ e nginx.conf.

compose.frontend-api.yaml espera ./frontend e ./api. Copie nginx.reverse-proxy.conf para nginx.conf no contexto do frontend. Ajuste versões, portas e artefatos conscientemente. Os templates de escrita contêm perguntas para preservar autoria.
