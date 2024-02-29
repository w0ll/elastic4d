{************************************************************}
{    Autenticação de requisições (AWS Signature versão 4)    }
{************************************************************}

{
  A unit é baseada na documentação disponibilizada pela AWS.
  Pode ser encontrada em:

  https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/create-signed-request.html
}

unit Elastic4D.AWS.Auth;

interface

uses
  Hash,
  JSON,
  System.SysUtils,
  System.DateUtils,
  System.Generics.Collections;

type
  TElastic4DAWSAuth = class
  public
    class function CanonicalRequest(AMethod, ACanonicalURI, ACanonicalQuery,
      ACanonicalHeaders, ASignedHeaders, APayLoad: string): string;
    class function StringToSign(AAmzDate, ACredencialScope, ACanonicalRequest: string): string;
    class function SigningKey(ADateStamp, ASecretKey, ARegion, AService: string): TBytes;
    class function Signature(AStringToSign: string; ASigningKey: TBytes): string;
    class function AuthorizationHeaders(AAccessKey, ACredencialScope, ASignedHeaders,
      ASignature, AAmzDate: string): TDictionary<string,string>;
    class function CredencialScope(ADateStamp, ARegion, AService: string): string;
  end;

implementation

{ TElastic4DAWSAuth }

class function TElastic4DAWSAuth.CanonicalRequest(AMethod, ACanonicalURI, ACanonicalQuery,
  ACanonicalHeaders, ASignedHeaders, APayLoad: string): string;
var
  LJson: TJSONObject;
  LPayLoad: string;
begin
  LJson := nil;
  try
    Result := Format('%s'#10, [AMethod]);
    Result := Result + Format('%s'#10, [ACanonicalURI]);
    Result := Result + Format('%s'#10, [ACanonicalQuery]);
    Result := Result + Format('%s'#10, [ACanonicalHeaders]);
    Result := Result + Format('%s'#10, ['']);
    Result := Result + Format('%s'#10, [ASignedHeaders]);

    LPayLoad := '';
    LJson := TJSonObject.ParseJSONValue(APayLoad) as TJSONObject;
    if Assigned(LJson) then
      LPayLoad := LJson.ToString;

    Result := Result + Format('%s', [THashSHA2.GetHashString(LPayLoad)]);
  finally
    if Assigned(LJson) then
      LJson.Free;
  end;
end;

class function TElastic4DAWSAuth.CredencialScope(ADateStamp, ARegion, AService: string): string;
begin
  Result := Format('%s/%s/%s/aws4_request', [ADateStamp, ARegion, AService]);
end;

class function TElastic4DAWSAuth.AuthorizationHeaders(AAccessKey, ACredencialScope, ASignedHeaders,
  ASignature, AAmzDate: string): TDictionary<string, string>;
var
  LAuthorizationHeader: string;
begin
  Result := TDictionary<string, string>.Create;
  LAuthorizationHeader := Format('%s Credential=%s/%s, SignedHeaders=%s, Signature=%s',
    ['AWS4-HMAC-SHA256', AAccessKey, ACredencialScope, ASignedHeaders, ASignature]);

  Result.Add('x-amz-date', AAmzDate);
  Result.Add('Authorization', LAuthorizationHeader);
end;

class function TElastic4DAWSAuth.Signature(AStringToSign: string; ASigningKey: TBytes): string;
begin
  Result := THash.DigestAsString(THashSHA2.GetHMACAsBytes(AStringToSign, ASigningKey));
end;

class function TElastic4DAWSAuth.SigningKey(ADateStamp, ASecretKey, ARegion, AService: string): TBytes;
var
  LDate: TBytes;
  LRegion: TBytes;
  LService: TBytes;
  LSigningKey: TBytes;
begin
  LDate := THashSHA2.GetHMACAsBytes(ADateStamp, 'AWS4' + ASecretKey);
  LRegion := THashSHA2.GetHMACAsBytes(ARegion, LDate);
  LService := THashSHA2.GetHMACAsBytes(AService, LRegion);
  LSigningKey := THashSHA2.GetHMACAsBytes('aws4_request', LService);

  Result :=  LSigningKey;
end;

class function TElastic4DAWSAuth.StringToSign(AAmzDate, ACredencialScope,
  ACanonicalRequest: string): string;
begin
  Result := Format('%s'#10, ['AWS4-HMAC-SHA256']);
  Result := Result + Format('%s'#10, [AAmzDate]);
  Result := Result + Format('%s'#10, [ACredencialScope]);
  Result := Result + Format('%s', [THashSHA2.GetHashString(ACanonicalRequest)]);
end;

end.
