unit Elastic4D.Request;

interface

uses
  Elastic4D.AWS.Auth,
  Elastic4D.Interfaces,
  IPPeerClient,
  JSON,
  REST.Json,
  REST.Types,
  REST.Client,
  System.SysUtils,
  System.DateUtils,
  System.Generics.Collections;

type
  TElastic4DRequest = class(TInterfacedObject, IElastic4DRequest)
  private
    FCanonicalURI: string;
    FHost: string;
  public
    class function New: IElastic4DRequest;

    function CanonicalURI(AValue: string): IElastic4DRequest;
    function Host(AValue: string): IElastic4DRequest;

    function Execute(APayload: string): string;
  end;

implementation

{ TElastic4DRequest }

function TElastic4DRequest.Execute(APayLoad: string): string;
var
  LClient: TRESTClient;
  LRequest: TRESTRequest;
  LResponse: TRESTResponse;
  LJsonBody: TJSONObject;
  LJsonResponse: TJSONObject;
begin
  LJsonBody := nil;
  LClient := TRESTClient.Create(nil);
  LRequest := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);
  try
    LClient.BaseURL := 'http://' + FHost + FCanonicalURI;

    LRequest.Client := LClient;
    LRequest.Response := LResponse;
    LRequest.Method := TRESTRequestMethod.rmPOST;
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
    if Assigned(LJsonBody) then
      LJsonBody.Free;
  end;
end;

function TElastic4DRequest.Host(AValue: string): IElastic4DRequest;
begin
  Result := Self;
  FHost := AValue;
end;

function TElastic4DRequest.CanonicalURI(AValue: string): IElastic4DRequest;
begin
  Result := Self;
  FCanonicalURI := AValue;
end;

class function TElastic4DRequest.New: IElastic4DRequest;
begin
  Result := Self.Create;
end;

end.
