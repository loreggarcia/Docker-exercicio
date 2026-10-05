# Build e execução
`docker compose build` produz imagens; `docker compose up` cria e inicia containers dessas imagens. Um estágio builder não é um serviço conversando com outro container. `COPY --from` transfere arquivos selecionados durante o build. Só na execução as requisições passam pela rede.

`RUN` executa durante a construção e grava uma camada. `CMD` define o comando padrão em execução; `ENTRYPOINT` define o executável principal. Use listas para encaminhar sinais ao processo principal (PID 1). Quando esse processo termina, o container para. Um container parado continua existindo até ser removido; veja `docker compose ps -a`.

Experimente `docker build --target builder -t echo-builder:local examples/03-minimal-runtime` e compare com a imagem final. Esse comando não inicia a aplicação.
