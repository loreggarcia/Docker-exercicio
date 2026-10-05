# Persistência
A camada gravável do container permanece após `stop`, mas desaparece quando o container é removido. `docker compose down` remove containers e redes do projeto; volumes nomeados normalmente permanecem. `docker compose down -v` também remove volumes declarados e anônimos associados: use somente quando a perda dos dados for intencional. Volumes externos não são removidos pelo Compose.

Bind mount conecta um caminho do host, útil para editar código. Volume nomeado é gerenciado pelo Docker, adequado para dados duráveis. Montar sobre um diretório esconde os arquivos que a imagem já tinha naquele caminho.

Exemplo de fragmento para estudo (não necessário à Echo App):

```yaml
services:
  api:
    volumes:
      - ./api:/app:ro  # código local, desenvolvimento
      - echo-data:/data  # dados persistentes
volumes:
  echo-data:
```
Estes exemplos principais não armazenam mensagens. Acrescentar um volume não torna uma aplicação persistente se ela nunca gravar nele. Inspecione com `docker volume ls` e `docker volume inspect NOME`.
