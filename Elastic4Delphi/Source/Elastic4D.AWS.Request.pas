unit Elastic4D.AWS.Request;

interface

uses
  Elastic4D.AWS.Auth,
  Elastic4D.Interfaces,
  IPPeerClient,
  JSON,
  REST.Json,
  REST.Types,
  REST.Client,
  System.TimeSpan,
  System.SysUtils,
  System.DateUtils,
  System.Generics.Collections;

type
  TElastic4DAWSRequest = class(TInterfacedObject, IElastic4DAWSRequest)
  private
    FService: string;
    FHost: string;
    FRegion: string;
    FAccessKey: string;
    FSecretKey: string;
    FAmzDate: string;
    FDateStamp: string;
    FCanonicalHeaders: string;
    FSignedHeaders: string;
    FCanonicalURI: string;
    FCanonicalQuery: string;
    FUTCOffSet: Integer;

    procedure SetDateTime;
  public
    constructor Create;
    class function New: IElastic4DAWSRequest;

    function AccessKey(AValue: string): IElastic4DAWSRequest;
    function CanonicalURI(AValue: string): IElastic4DAWSRequest;
    function CanonicalQuery(AValue: string): IElastic4DAWSRequest;
    function Host(AValue: string): IElastic4DAWSRequest;
    function Region(AValue: string): IElastic4DAWSRequest;
    function Service(AValue: string): IElastic4DAWSRequest;
    function SecretKey(AValue: string): IElastic4DAWSRequest;

    function Execute(APayload: string): string;
  end;

implementation

{ TElastic4DAWSRequest }

function TElastic4DAWSRequest.AccessKey(AValue: string): IElastic4DAWSRequest;
begin
  Result := Self;
  FAccessKey := AValue;
end;

function TElastic4DAWSRequest.CanonicalQuery(AValue: string): IElastic4DAWSRequest;
begin
  Result := Self;
  FCanonicalQuery := AValue;
end;

function TElastic4DAWSRequest.CanonicalURI(AValue: string): IElastic4DAWSRequest;
begin
  Result := Self;
  FCanonicalURI := AValue;
end;

constructor TElastic4DAWSRequest.Create;
begin
  FSignedHeaders := 'host;x-amz-date';
  inherited Create;
end;

function TElastic4DAWSRequest.Execute(APayLoad: string): string;
var
  LClient: TRESTClient;
  LRequest: TRESTRequest;
  LResponse: TRESTResponse;
  LHeaders: TDictionary<string,string>;
  LJsonBody: TJSONObject;
  LJsonResponse: TJSONObject;
begin
  LJsonBody := nil;
  LHeaders := nil;
  LClient := TRESTClient.Create(nil);
  LRequest := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);
  try
    SetDateTime;
    LHeaders := TElastic4DAWSAuth.AuthorizationHeaders(
    FAccessKey,
    TElastic4DAWSAuth.CredencialScope(
      FDateStamp,
      FRegion,
      FService
    ),
    FSignedHeaders,
    TElastic4DAWSAuth.Signature(
      TElastic4DAWSAuth.StringToSign(
        FAmzDate,
        TElastic4DAWSAuth.CredencialScope(
          FDateStamp,
          FRegion,
          FService
        ),
        TElastic4DAWSAuth.CanonicalRequest(
          'POST',
          FCanonicalURI,
          FCanonicalQuery,
          FCanonicalHeaders,
          FSignedHeaders,
          APayLoad
        )
      ),
      TElastic4DAWSAuth.SigningKey(
        FDateStamp,
        FSecretKey,
        FRegion,
        FService
      )
    ),
    FamzDate);

    LClient.BaseURL := 'https://' + FHost + FCanonicalURI;

    LRequest.Client := LClient;
    LRequest.Response := LResponse;
    LRequest.Method := TRESTRequestMethod.rmPOST;
    LRequest.Params.AddItem('x-amz-date', LHeaders.Items['x-amz-date'],
      pkHTTPHEADER, [poDoNotEncode]);
    LRequest.Params.AddItem('Authorization', LHeaders.Items['Authorization'],
      pkHTTPHEADER, [poDoNotEncode]);

    LJsonBody := TJSonObject.ParseJSONValue(APayLoad) as TJSONObject;
    if Assigned(LJsonBody) then
      LRequest.Body.Add(LJsonBody.ToString, ctAPPLICATION_JSON);

    LRequest.Execute;

    LJsonResponse := LResponse.JSONValue as TJSONObject;
    Result := Format('Response(%s): %s', [LResponse.StatusCode.ToString,
      TJson.Format(LJsonResponse)]);
  finally
    LClient.Free;
    LRequest.Free;
    LResponse.Free;
    LHeaders.Free;
    if Assigned(LJsonBody) then
      LJsonBody.Free;
  end;
end;

function TElastic4DAWSRequest.Host(AValue: string): IElastic4DAWSRequest;
begin
  Result := Self;
  FHost := AValue;
end;

class function TElastic4DAWSRequest.New: IElastic4DAWSRequest;
begin
  Result := Self.Create;
end;

function TElastic4DAWSRequest.Region(AValue: string): IElastic4DAWSRequest;
begin
  Result := Self;
  FRegion := AValue;
end;

function TElastic4DAWSRequest.SecretKey(AValue: string): IElastic4DAWSRequest;
begin
  Result := Self;
  FSecretKey := AValue;
end;

function TElastic4DAWSRequest.Service(AValue: string): IElastic4DAWSRequest;
begin
  Result := Self;
  FService := AValue;
end;

procedure TElastic4DAWSRequest.SetDateTime;
begin
  FUtcOffset := TTimeZone.Local.GetUtcOffset(Now).Hours* -1;
  FAmzDate := FormatDateTime('YYYYMMDD''T''HHMMSS''Z''', IncHour(Now, FUtcOffset));
  FDateStamp := FormatDateTime('YYYYMMDD', IncHour(Now, FUtcOffset));

  FCanonicalHeaders := Format('host:%s'#10, [FHost]);
  FCanonicalHeaders := FCanonicalHeaders + Format('x-amz-date:%s', [FAmzDate]);
end;

end.
