# Responsabilidades

| Arquivo | Responsabilidade | Exemplo |
| --- | --- | --- |
| Dockerfile | Construir imagem e definir processo | Instalar Gunicorn, copiar código, CMD |
| Compose | Criar serviços e conectá-los | build, ports, networks, healthcheck, volumes |
| Nginx | Servir arquivos e encaminhar HTTP | location, proxy_pass |

```nginx
location /api/ {
    proxy_pass http://api:5000/;
}
```
A URI `/` de `proxy_pass` substitui o prefixo `/api/`: `/api/echo` chega como `/echo`. Sem a barra final (sem URI), o backend recebe `/api/echo` e retorna 404 neste contrato. Confirme com `curl -i http://localhost:8080/api/echo -H 'Content-Type: application/json' -d '{"message":"Hello Docker"}'`.

Essa substituição é definida na [documentação Nginx](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass).
