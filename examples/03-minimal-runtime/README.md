# Runtime mínimo

```bash
docker build -t echo-minimal:local .
docker run --rm echo-minimal:local
```
Espere `Olá, runtime mínimo!` e término do processo. Compilador fica no builder. CGO_ENABLED=0 e GOOS=linux geram binário Linux sem dependência do runtime C; somente o binário é copiado para scratch.

scratch não possui shell: `docker run --entrypoint sh echo-minimal:local` falha. O processo principal termina normalmente e o container para; `--rm` remove esse container após terminar. Sem `--rm`, ele continua listado em `docker ps -a`. Não precisa de rede ou Compose. Binários não são versionados.
