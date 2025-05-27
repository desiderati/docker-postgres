### Know Issues

1) **Error ao inicializar o banco de dados: diretório de dados não acessível.**

   ```
   postgres  | initdb: could not change permissions of directory "/var/lib/postgresql/data": Operation not permitted
   ```

    - **Razão**: Provavelmente o volume mapeado `./data:/var/lib/postgresql/data` foi criado com as permissões
      erradas.

      Exemplo:

      ```yml
      volumes:
        - ./data:/var/lib/postgresql/data
      ```

    - **Resolução**: Executar os arquivos: **init.sh** e **postinstall.sh**.

      ```shell
      $ ./init.sh && ./postinstall.sh
      ```
