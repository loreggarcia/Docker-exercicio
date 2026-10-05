# Artefatos entre estágios

| Padrão | Builder produz | Runtime recebe |
| --- | --- | --- |
| React → Nginx | `npm ci`, `npm run build`, dist/ | dist/ e configuração Nginx |
| Python → Python | venv com dependências | venv e app.py |
| Go → scratch | binário Linux estático | somente binário |
| C → scratch | binário estático | somente binário |

Os builders não são serviços. Compose usa o Dockerfile para construir imagens; ele não substitui multi-stage e o Dockerfile não define a rede de execução. O venv precisa de Python compatível na imagem final; use a mesma versão e família da base nos dois estágios. Bibliotecas nativas podem exigir dependências extras no runtime.

Padrão C alternativo (crie `hello.c` com um main que imprima uma frase):

```dockerfile
FROM alpine:3.21.3 AS builder
RUN apk add --no-cache build-base
WORKDIR /src
COPY hello.c .
RUN cc -static -Os -s hello.c -o /hello
FROM scratch
COPY --from=builder /hello /hello
ENTRYPOINT ["/hello"]
```
`scratch` não tem shell, certificados nem utilitários. Um binário dinâmico não funciona sem suas bibliotecas. Os exemplos mínimos não fazem TLS nem leitura de dados externos. Compare `docker image ls` e `docker history IMAGEM`; não presuma redução de tamanho sem medir.
