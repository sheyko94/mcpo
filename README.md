# Demo

Running `docker compose up -d ` should run up all the local environment. This includes many services in charge of both monitoring and logging just like we do in Tangram. The aim of this project is to now on top add alerts that can be delivered to a Slack channel to get the on-call process a bit more automated. 

It is important to find the right metrics for Tangram and the right alerts for the teams - and leverage it in a self-service manner when possible.

As last step, research where can AI help us improve this process even further. 


## Backend

``` bash

curl http://localhost:8081/actuator/health # all healthy
curl http://localhost:8080/actuator/prometheus # prometheus metrics working
curl http://localhost:8080/hello # force network traffic 

```

## Grafana

https://grafana.com/docs/grafana-cloud/alerting-and-irm/alerting/

username admin
passowrd admin

## Prometheus

https://prometheus.io/docs/introduction/overview/

check scraping is working http://localhost:9090/targets

## FluentD

https://docs.fluentd.org/

## ElasticSearch

http://localhost:9200/

## Kibana

http://localhost:5601/app/home#/
