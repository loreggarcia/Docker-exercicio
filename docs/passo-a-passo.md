# Passo a passo de estudo e prática

Siga as etapas em ordem. Execute cada bloco no terminal indicado e confira o resultado antes de avançar. Os comandos usam Bash; no Windows, use WSL. A primeira construção precisa de internet e pode levar alguns minutos para baixar imagens e dependências.

## 1. Abrir o repositório e conferir o ambiente

Abra o terminal no diretório que contém sua cópia do repositório. Se a pasta se chama `Docker-exercicio`:

```bash
cd Docker-exercicio
```

Se estiver em outra máquina, use o caminho da sua cópia. Confira as ferramentas:

```bash
docker --version
docker compose version
docker info
curl --version
python3 --version
```

Os comandos devem mostrar versões e informações do ambiente. Se `docker info` falhar, confira se o Docker está iniciado e se seu usuário tem acesso ao daemon antes de continuar. Para investigar mensagens de erro, consulte o [guia de diagnóstico](07-debugging.md).

Valide os arquivos do repositório:

```bash
python3 scripts/validate-static.py
```

Confira a mensagem de validação dos modelos Compose, links e scripts. Esse teste verifica a configuração; o funcionamento será conferido nas próximas etapas.

## 2. Conhecer os três arquivos principais

Leia os arquivos em `examples/01-basic-compose`:

| Arquivo | O que procurar |
| --- | --- |
| `api/Dockerfile` | instalação de dependências, código copiado e comando Gunicorn |
| `frontend/Dockerfile` | Nginx, arquivos estáticos e configuração copiada |
| `compose.yaml` | serviços, contextos de build, publicação de porta e dependência |
| `frontend/nginx.conf` | encaminhamento de `/api/` para `api:5000` |

Use o documento de [responsabilidades](02-dockerfile-compose-nginx.md) para relacionar cada configuração ao seu propósito.

## 3. Construir e iniciar o exemplo básico

Partindo da raiz do repositório:

```bash
cd examples/01-basic-compose
docker compose config
docker compose up --build -d
docker compose ps -a
```

Confira se `frontend` e `api` aparecem em execução. O frontend deve publicar `8080` para a porta interna `80`. A API pode mostrar `5000/tcp`, mas deve permanecer sem um mapeamento como `0.0.0.0:5000->5000/tcp`.

Se houver um container parado ou falha na construção, examine:

```bash
docker compose logs --tail=50
```

Se a porta 8080 estiver ocupada, identifique o conflito com o guia de diagnóstico. Mantenha os processos de terceiros em execução e escolha uma porta livre no Compose, ajustando também a URL dos testes manuais.

## 4. Testar a saúde e o contrato da API

Ainda na pasta do exemplo básico:

```bash
curl -i http://localhost:8080/api/health
```

Espere status `200` e um JSON equivalente a:

```json
{"status":"ok","service":"api"}
```

Se a primeira chamada falhar logo após iniciar, aguarde alguns segundos e repita. O exemplo básico usa uma dependência simples; a etapa de prontidão é explicada no [guia de validação](08-validation-and-evidence.md).

Envie uma mensagem válida:

```bash
curl -i http://localhost:8080/api/echo \
  -H 'Content-Type: application/json' \
  -d '{"message":"Hello Docker"}'
```

Espere `200` e `{"message":"Hello Docker"}`. Depois, teste uma mensagem vazia:

```bash
curl -i http://localhost:8080/api/echo \
  -H 'Content-Type: application/json' \
  -d '{"message":""}'
```

Espere `400` e um JSON contendo `error`. Esse resultado comprova que a aplicação trata uma entrada inválida.

## 5. Testar pelo navegador

Abra **http://localhost:8080**:

1. Digite uma mensagem e clique em **Enviar**.
2. Confira a mensagem devolvida e o estado **Resposta recebida**.
3. Esvazie o campo e envie novamente.
4. Confira **Falha na requisição** e a explicação do erro.
5. Envie uma mensagem válida para conferir a recuperação.

O estado **Enviando…** pode aparecer muito rapidamente em uma rede local. Para observar o fluxo, abra as ferramentas de desenvolvimento do navegador e procure a requisição `/api/echo` na aba de rede.

## 6. Conferir a comunicação interna e encerrar

No terminal do exemplo básico:

```bash
docker compose exec frontend nslookup api
docker compose exec frontend wget -qO- http://api:5000/health
docker compose logs --tail=50 api
```

Confira a resolução do serviço e a resposta de saúde pela rede interna. Nos logs da API, observe as rotas recebidas. Relacione o teste via `/api/echo` à configuração Nginx que encaminha `/echo`.

Encerre este exemplo antes de iniciar o avançado, que também usa a porta 8080:

```bash
docker compose down
cd ../..
```

Você voltou à raiz do repositório.

## 7. Executar o exemplo multi-stage

Na raiz:

```bash
cd examples/02-multistage-web
docker compose config
docker compose up --build -d
docker compose ps
curl -i http://localhost:8080/api/health
```

Confira a API com estado `healthy`. Aguarde também o frontend começar a atender HTTP. Abra a mesma URL no navegador e repita o envio válido e inválido da etapa 5.

Leia os dois Dockerfiles e localize:

- frontend: Node produz `dist/`, que é copiado para Nginx;
- API: o builder prepara `/opt/venv`, que é copiado para o runtime Python;
- API: `USER appuser` define o usuário de execução;
- Compose: rede `echo-net`, healthcheck e condição `service_healthy`.

Use o [documento de multi-stage](04-multistage-build.md) para explicar quais arquivos atravessam os estágios. Encerre e volte à raiz:

```bash
docker compose down
cd ../..
```

## 8. Executar o runtime mínimo

Na raiz:

```bash
cd examples/03-minimal-runtime
docker build -t echo-minimal:local .
docker run --rm echo-minimal:local
cd ../..
```

Espere `Olá, runtime mínimo!`. O programa termina depois de imprimir; `--rm` remove o container dessa execução. No Dockerfile, identifique o compilador no builder e o único binário copiado para `scratch`.

## 9. Fazer os exercícios

Comece pelo [exercício de Compose](../exercises/01-complete-the-compose/README.md). Partindo da raiz:

```bash
cd exercises/01-complete-the-compose
```

Complete `compose.yaml` conforme os requisitos do README. Preencha `registro-5c.md` durante o trabalho. Valide com `config`, execute com `up --build -d` e faça os testes de saúde, mensagem válida e inválida usando a porta **8081**. Confira estado e logs; finalize com `docker compose down` e `cd ../..`.

Depois, siga o [exercício Go](../exercises/02-go-multistage/README.md): crie o Dockerfile multi-stage e o Compose, preserve o contrato e reutilize o frontend indicado. Seus testes usam a porta **8082**. Registre as decisões e encerre o projeto ao terminar.

Os arquivos iniciais são incompletos intencionalmente. Compare com as [soluções de referência](../reference-solutions/README.md) após formular e testar sua implementação. O [método 5C](09-method-5c.md) ajuda a distinguir hipótese, decisão e evidência.

## 10. Praticar diagnóstico

Escolha um dos [dez cenários](../exercises/03-debugging-scenarios/README.md). Por exemplo, na raiz:

```bash
cd exercises/03-debugging-scenarios/02-localhost-proxy
docker compose config
docker compose up --build -d
docker compose ps -a
curl -i http://localhost:8090/api/health
docker compose logs --tail=50
```

Uma falha é esperada. Leia o README do cenário, registre uma hipótese e use a [árvore de diagnóstico](07-debugging.md) para investigá-la. Após corrigir, repita os testes de saúde e echo e compare as evidências. Finalize:

```bash
docker compose down
cd ../../..
```

Execute um cenário de cada vez. O cenário 09 tem um procedimento adicional para reproduzir a alteração de dependência; siga seu README.

## 11. Repetir a validação automática

Na raiz, com os exemplos iniciados manualmente já encerrados:

```bash
python3 scripts/validate-static.py
./scripts/validate-basic.sh
./scripts/validate-multistage.sh
```

Execute os validadores Docker em sequência. Eles usam a porta 8080, criam projetos isolados, testam sucesso e erro e encerram seus próprios containers e redes.

Para os testes locais Flask, prepare um ambiente virtual:

```bash
python3 -m venv .venv
.venv/bin/pip install -r examples/01-basic-compose/api/requirements.txt
.venv/bin/python scripts/test-contract.py
```

Com Go 1.23 ou superior instalado, execute também:

```bash
./scripts/test-go.sh
```

Registre apenas os comandos que você executou e seus resultados observados. Consulte o [relatório de construção](validation-report.md) para ver o que foi validado nesta versão do guia.
