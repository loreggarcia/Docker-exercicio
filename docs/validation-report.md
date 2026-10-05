# Relatório de validação

Data: 05/10/2026. Conteúdo original criado para estudo independente. Os arquivos de referência foram localizados, extraídos somente em /tmp e inspecionados; nenhum conteúdo extraído nem ZIP foi incluído no repositório. Os originais foram preservados.

## Ambiente e limites
Docker Engine 29.7.2, Compose 5.4.0, Linux x86_64. Daemon acessado fora do sandbox após verificação autorizada. As primeiras tentativas de instalação locais falharam por DNS restrito; as tentativas com acesso de rede instalaram as dependências e geraram o lockfile corretamente.

Testes locais Python usaram Python 3.14 em venv temporário; os testes Docker usaram a base Python 3.12.12 definida nos Dockerfiles. Build local React usou Node 24.13.0; build Docker usou Node 22.14.0. Go foi testado localmente e no builder Go 1.24.2.

## Testes executados

| Verificação | Resultado observado |
| --- | --- |
| `docker compose config --format json` | 27 modelos passaram, incluindo template e arquivos deliberadamente incompletos/defeituosos |
| Contrato local Flask | quatro implementações testadas: básico, avançado, exercício Compose e cenário de dependência |
| Contrato local Go | testes passaram no exercício e na solução |
| Sintaxe | Bash, Python e JavaScript estático passaram |
| `pip check` no venv temporário | sem incompatibilidades de dependência |
| `npm ci` e `npm run build` | frontend React construído a partir do lockfile |
| `validate-basic.sh` no Docker | saúde e página, echo válido, mensagem vazia, JSON inválido, null, array, tipo incorreto e corpo ausente passaram |
| `validate-multistage.sh` no Docker | mesmos testes passaram; API saudável antes do início do frontend |
| Go por proxy Nginx, porta 8082 | saúde, echo válido e cinco entradas inválidas passaram; API UID 10001, sem porta publicada |
| Runtime mínimo | build passou; execução imprimiu `Olá, runtime mínimo!` e terminou |
| Solução Compose básico | construída e testada no navegador em 8081 |
| Solução de prontidão | API atrasada 12s; Compose aguardou saúde, up levou 16,7s e proxy respondeu 200 após iniciar |
| Links e contextos | links locais e Dockerfiles dos contextos verificados; exceções pedagógicas documentadas |
| Estrutura | scripts executáveis, sem diretórios de conteúdo vazios e sem binários, ZIPs ou arquivos .env |

`config` aceita `services: {}` nesta versão: isso não torna os exercícios executáveis. Ele também não detecta o contexto sem Dockerfile do cenário 07. Os READMEs explicam essas limitações.

Os validadores executaram `ps` e encerraram apenas seus projetos isolados. Os builds deixaram imagens e cache próprios no daemon; não houve prune nem remoção de imagens de terceiros. node_modules, dist e caches Python gerados localmente foram retirados da árvore de entrega; o lockfile foi preservado.

## Cenários deliberadamente defeituosos

| Cenário | Evidência de execução |
| --- | --- |
| 01: portas invertidas | porta 8090 sem resposta |
| 02: localhost no proxy | resposta 502 |
| 03: serviço com nome incompatível | Nginx Exited após timeout DNS; log `host not found in upstream` |
| 04: API no loopback | resposta 502 pelo proxy |
| 05: URI do proxy | resposta 404 |
| 06: API publicada | saúde acessível diretamente na porta 5000 do host |
| 07: contexto incorreto | build falhou sem Dockerfile |
| 08: processo principal | API Exited com código não zero e RuntimeError nos logs |
| 09: dependência alterada | restart manteve Gunicorn 23; rebuild instalou 22; arquivo original restaurado |
| 10: início sem saúde | primeira chamada 502, seguida de 200 após a API ficar pronta |

O primeiro teste do cenário 03 aguardou pouco para observar o timeout DNS; uma repetição com espera limitada confirmou o erro. O cenário 08 foi avaliado pelo exit code da API: seu encerramento também pode afetar o DNS e impedir Nginx de iniciar, portanto 502 não é um sintoma garantido.

A primeira checagem da solução 10 tentou HTTP logo após `up` e recebeu reset durante o início do Nginx. A repetição aguardou também a prontidão do frontend por até cinco segundos e passou. `service_healthy` verifica a dependência API, não o processo consumidor.

## QA dos frontends

Fluxo: página inicial → enviar mensagem → observar carregamento → receber resposta → enviar vazio → observar erro → reenviar válido → recuperar sucesso.

Browser plugin não disponível; utilizado Playwright temporário com Chrome local em modo headless. URLs: localhost:8081 (estático/Flask) e localhost:8082 (React/Go). Viewports: 1280×800 e 390×844.

| Checagem | Resultado |
| --- | --- |
| Identidade | título Echo App e heading corretos |
| Conteúdo | página significativa, sem tela vazia nem overlay de framework |
| Console | sem erros inesperados; resposta HTTP 400 esperada na entrada vazia |
| Carregamento | estado Enviando visível e botão desabilitado durante requisição |
| Interação | mensagem devolvida, erro em JSON apresentado e recuperação após reenvio |
| Mobile | sem overflow horizontal; captura inspecionada |
| Screenshots | desktop e mobile capturados em /tmp, fora do conteúdo distribuído |

Comando temporário de QA: `node /tmp/echo-browser-test/check.cjs 8081 8082`. Não é dependência do guia: o contrato pode ser repetido com os scripts versionados, e os READMEs trazem roteiro de teste manual.

## Não executado

- Firefox, Safari, ARM e Windows nativo: somente ambiente Linux x86_64 e Chrome disponíveis foram usados.
- Build do padrão C da documentação: o exemplo executável de runtime mínimo usa Go; C é um padrão alternativo documentado.
- Execução individual de todas as cópias de Compose corrigidas dos cenários: modelos e caminhos foram validados; os serviços comuns já foram exercitados pelos exemplos e soluções principais.
- Aplicação dos exercícios incompletos sem preenchimento: os placeholders são deliberados e não constituem aplicação executável.
- Fixação por digest, testes de carga, autenticação, TLS e persistência: não implementados no escopo da Echo App.

## Decisões
Rede padrão no básico; bridge com nome lógico echo-net no avançado; DNS api; só frontend publica portas; contrato idêntico em Flask e Go; React reutilizado pelo contexto de build. Runtime Go contém só binário e Python avançado recebe apenas venv e código sobre sua base. Registros 5C contêm perguntas, sem respostas prontas. Documentação usa fontes oficiais vinculadas nos respectivos conceitos.
