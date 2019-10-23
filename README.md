[![Build status](https://github.com/navikt/syfoproxy/workflows/Deploy%20to%20dev%20and%20prod/badge.svg)](https://github.com/navikt/syfoproxy/workflows/Deploy%20to%20dev%20and%20prod/badge.svg)

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
[Vault](https://vault.adeo.no) og sett opp en ny secret med path `<appnavn>proxy/default`, lag en secret med navn 
`credentials.env` den skal ha følgende innhold: 

```.env
export SERVICE_GATEWAY_URL=<gateway-url>
export SERVICE_GATEWAY_KEY=<gateway-api-key>
```

### Sette opp ny proxy
- Legg til en mappe med samme navn som appen som skal proxyes. 
- Opprett `nais-dev.yaml` og `nais.yaml` i mappen.

Dette er naiserator-filene for proxyappen, og det er først og fremst hvilke ingresser den skal kunne nåes på som vil variere for de ulike proxyappene. Ingressene vil være 
forskjellig for dev og prod.

Etter filene er satt opp må det legges til et steg i bygg-pipelinen som deployer den nye proxyappen. Legg til et nytt
deploy-steg i `devdeploy.yaml` og `deploy.yaml` for dev og prod for å deploye den nye proxyappen.
