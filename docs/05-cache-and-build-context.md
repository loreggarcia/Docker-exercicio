# Cache e contexto
Cada instrução pode gerar uma camada reutilizável. Copie `requirements.txt` antes de `app.py`: alterar código refaz apenas as camadas seguintes; alterar dependências invalida sua instalação e as camadas posteriores. O mesmo vale para package.json e package-lock.json antes de src/.

O contexto de `build` é o conjunto de arquivos disponível para COPY. COPY não alcança arquivos fora dele. Caminhos de build no Compose são relativos ao arquivo base de configuração. `.dockerignore` reduz envio de arquivos e exclui ambientes locais, node_modules e segredos.

```bash
docker compose build api
docker compose up -d --build api
```
`restart` não reconstrói imagens. Sem bind mount, alterações no host não chegam ao container existente. Use `--no-cache` apenas ao investigar cache; ele não corrige código nem contratos. Dependências fixadas e lockfile melhoram reprodutibilidade; tags ainda podem mudar, então digests são uma melhoria opcional após validar imagens.
