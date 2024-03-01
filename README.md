# elastic4d
Para funcionamento do projeto, é necessário mover o arquivo **SampleResources.json** para o mesmo diretorio do executável.\
Ex.: Elastic4Delphi\Sample\Win32\Debug\
## Sample de envio de requisições para elasticsearch/opensearch
### AWS
```
  Elastic4DAWSRequest
    .AccessKey(FSampleResources.AccessKey)
    .CanonicalURI(FSampleResources.CanonicalURI)
    .CanonicalQuery(FSampleResources.CanonicalQuery)
    .Host(FSampleResources.Host)
    .Region(FSampleResources.Region)
    .Service(FSampleResources.Service)
    .SecretKey(FSampleResources.SecretKey)
    .Execute(FLog);
```
### LOCAL
```
  Elastic4DRequest
    .CanonicalURI(FSampleResources.CanonicalURI)
    .Host(FSampleResources.Host)
    .Execute(FLog);
```
## Lib para Autenticação de requisições (AWS Signature versão 4)
A lib é baseada na documentação disponibilizada pela AWS.\
Pode ser encontrada em:\
https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/create-signed-request.html
