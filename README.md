# Log Solutions

Testing logging solutions for microservices.

## Swarm + Loki + Promtail

Env is `deploy_1`, run the environment:

```sh
make deploy_1 env
```

Send some logs:

```sh
curl -X POST -d '{"message": "hello world"}' http://localhost:8080
```

Deploy to swarm:

```sh
docker swarm init

make deploy_1 env-swarm
```
