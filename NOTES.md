# Notes

Thoughts and things of interest.

[Back to the main `README.md`](./README.md)

## Transfer Existing Rails DB to Elixir

- See: [Migrate from Rails to Phoenix](https://dev.to/ivmexx/migrate-from-rails-to-phoenix-2mmn)

  - Note that the "Dump Schema" section may be out of date. Instead, dump the schema using `pg_dump`

    ```sh
    pg_dump -h {host} -p {port} -U {posgres_username} -s {databse_name} > priv/repo/structure.sql
    ```

- See: [Connecting Two Databases using Ecto in elixir](https://medium.com/podiihq/connect-two-databases-using-ecto-1861116fbea2)

## SSL In Local Dev

See [https://www.freecodecamp.org/news/how-to-get-https-working-on-your-local-development-environment-in-5-minutes-7af615770eec/](https://www.freecodecamp.org/news/how-to-get-https-working-on-your-local-development-environment-in-5-minutes-7af615770eec/)

To create domain names in local, create domain names that end with `.localdev` like `eps.localdev`. In the `ect/hosts` file, add something like:

```hosts
127.0.0.1       eps.localdev
127.0.0.1       www.eps.localdev
```

Localhost can now be accessed at `eps.localdev`. For example, if the app is running on port 4000, access the app at `http://eps.localdev:4000`.

Once the steps in the above article have been completed run the following in the project root to generate the self signed certs:

```sh
mix phx.gen.cert
```

In the `config/dev.exs` file, uncomment the following lines in the endpoint configuration:

```elixir
https: [
    port: ssl_application_port,
    cipher_suite: :strong,
    keyfile: "priv/cert/selfsigned_key.pem",
    certfile: "priv/cert/selfsigned.pem"
  ],
```

WARNING: only use the generated certificate for testing in a closed network
environment, such as running a development server on `localhost`.
For production, staging, or testing servers on the public internet, obtain a
proper certificate, for example from [Let's Encrypt](https://letsencrypt.org).

NOTE: when using Google Chrome, open chrome://flags/#allow-insecure-localhost
to enable the use of self-signed certificates on `localhost`.

## Temporary Deployment

Once the new image has been built (tagged :latest) and pushed to the ECR, run this from the bastion:

```sh
for I in api-{a,b,c}01; do ssh ${I} sudo chef-client; done
```

```sh
parallel-chef --help
```

```sh
parallel-chef --node-pattern eps-dev-api.* uptime
```

```sh
parallel-chef --node-pattern eps-dev-api.* sudo chef-client
```

### For Alert API

```sh
parallel-chef --node-pattern eps-dev-alert-api.* sudo chef-client
```
