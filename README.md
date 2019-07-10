[![CircleCI](https://circleci.com/gh/navikt/syfoproxy.svg?style=svg)](https://circleci.com/gh/navikt/syfoproxy)

# Syfoproxy

## Om syfoproxy
Denne appen setter opp en proxy app med nginx. Prosjektet bygger og deployer et docker image som heter `syfoproxy` dette
imaget kjører opp en enkel nginx server som proxyer alle kall videre til en api-gateway url med en gateway key i header.
Keyen og urlen hentes fra `credentials.env` og blir templatet inn i configen for nginx serveren før den kjøres opp.


## Oppsett
### Api-gateway oppsett
For å sette opp api-gateway ressurser automatisk, bruk [restgw-iac](https://github.com/navikt/restgw-iac).

### Sette opp credentials for ny proxy
`credentials.env` filen må legges til i Vault for hver proxyapp. Dette gjøres ved å først lage en pull request til 
[vault-iac](https://github.com/navikt/vault-iac) prosjektet på navikt. Etter å ha lagt til appen der, gå til 
[Vault](https://vault.adeo.no) og sett opp en ny secret med path `<appnavn>prxy/default`, lag en secret med navn 
`credentials.env` den skal ha følgende innhold: 

```.env
export SERVICE_GATEWAY_URL=<gateway-url>
export SERVICE_GATEWAY_KEY=<gateway-api-key>
```

### Sette opp ny proxy
- Legg til en mappe med samme navn som appen som skal proxyes. 
- Opprett `dev-sbs.json` og `prod-sbs.json` i mappen.

```json
{
  "application_name": "<appnavn>proxy",
  "ingresses": [
    "https://<appnavn>proxy.nais.oera-q.local",
    "https://<appnavn>proxy-q.nav.no"
  ]
}
```

Denne filen bestemmer hvilket navn proxyappen skal ha og hvilke ingresser den skal kunne nåes på. Ingressene vil være 
forskjellig for dev og prod.

Etter filene er satt opp må det legges til et steg i bygg-pipelinen som deployer den nye proxyappen. Legg til et nytt
`run` steg under `jobs.deploy.steps` for dev og prod.

```yml
# <appnavn>
- run: 
  name: Create deployment request for <appnavn>proxy in development
  command: | deployment-cli deploy create \
      --cluster=dev-sbs \
      --repository=navikt/syfoproxy \
      --team=teamsykefravr \
      -r=nais.yaml \
      --version=$CIRCLE_SHA1 \
      --vars=<appnavn>/dev-sbs.json
- run:
  name: Create deployment request for <appnavn>proxy in prod
  command: | deployment-cli deploy create \
      --cluster=prod-sbs \
      --repository=navikt/syfoproxy \
      --team=teamsykefravr \
      -r=nais.yaml \
      --version=$CIRCLE_SHA1 \
      --vars=<appnavn>/prod-sbs.json
```
