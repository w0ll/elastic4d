unit FSample;

interface

uses
  Elastic4D.Interfaces,
  FSample.Resources,
  FSample.Utils,
  IPPeerClient,
  JSON,
  REST.Json,
  REST.Types,
  REST.Client,
  System.DateUtils,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Generics.Collections,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Winapi.Windows,
  Winapi.Messages;

type
  TFForm = class(TForm)
    FMemoRequest: TMemo;
    FLabelRequisicao: TLabel;
    FButtonEnviarNFCe: TButton;
    FMemoResponse: TMemo;
    FLabelResponse: TLabel;
    FMemoResponseElastic: TMemo;
    FLabelResponseElastic: TLabel;
    FButtonListarNFCe: TButton;
    FButtonCEP: TButton;
    FEditCEP: TEdit;

    procedure FButtonEnviarNFCeClick(Sender: TObject);
    procedure FButtonListarNFCeClick(Sender: TObject);
    procedure FButtonCEPClick(Sender: TObject);
  private      
    FDataInicio: TDateTime;  
    FError: Boolean;  
    FErrorMessage: string; 
    FLogs: TList<string>;
    FLog: string;
    FMethod: string;
    FPath: string; 
    FRequest: string;
    FResponse: string;
    FStatus: string;

    function Token: string;
    function TempoDeExecucao: Integer;
                     
    procedure ConsultarCEP;
    procedure EnviarLog;
    procedure EmitirNFCe; 
    procedure Iniciar(ALog: string; AAcao: TMethod);
    procedure ListarNFCe;       
    procedure Log(AValue: string); overload;
    procedure Log(AValue: string; const AArgs: array of const); overload;
    procedure MontarLog;
  end;

var
  FForm: TFForm;

implementation

{$R *.dfm}

procedure TFForm.EnviarLog;
begin
  MontarLog;
  FMemoResponseElastic.Lines.Add(
    Elastic4DAWSRequest
      .AccessKey(FSampleResources.AccessKey)
      .CanonicalURI(FSampleResources.CanonicalURI)
      .CanonicalQuery(FSampleResources.CanonicalQuery)
      .Host(FSampleResources.Host)
      .Region(FSampleResources.Region)
      .Service(FSampleResources.Service)
      .SecretKey(FSampleResources.SecretKey)
      .Execute(FLog));

//  FMemoResponseElastic.Lines.Add(
//    Elastic4DRequest
//      .CanonicalURI(FSampleResources.CanonicalURI)
//      .Host(FSampleResources.Host)
//      .Execute(FLog));
end;

procedure TFForm.FButtonCEPClick(Sender: TObject);
begin
  Iniciar('consulta de CEP', ConsultarCEP);
end;

procedure TFForm.FButtonEnviarNFCeClick(Sender: TObject);
begin
  Iniciar('emissão de NFCe', EmitirNFCe);
end;

procedure TFForm.FButtonListarNFCeClick(Sender: TObject);
begin
  Iniciar('listagem de NFCe', ListarNFCe);
end;

procedure TFForm.Iniciar(ALog: string; AAcao: TMethod);
begin
  FError := False;
  FMemoResponse.Clear;
  FRequest := EmptyStr;
  FResponse := EmptyStr;
  FErrorMessage := EmptyStr;
  FMemoResponseElastic.Clear;
  FLogs := TList<string>.Create;
  try
    FDataInicio := Now;
    Log('Processo de %s inicializado', [ALog]);
    try
      AAcao;
    except
      on E: Exception do
        begin
          FError := True;
          FErrorMessage := E.Message;
          if FResponse <> EmptyStr then
            FMemoResponse.Lines.Add(Format('Response(%s): %s', [FStatus,
              TJson.Format(TJSONObject.ParseJSONValue(FResponse))]));

          EnviarLog;
          raise;
        end;
    end;
    EnviarLog;
  finally
    FLogs.Free;
  end;
end;

procedure TFForm.MontarLog;
var
  LLog: string;
  LJson: TJSONObject;
  LJsonLog: TJSONArray;
begin
  LJson := TJSONObject.Create;
  LJsonLog := TJSONArray.Create;
  try
    LJson
      .AddPair('executiondate', FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss', FDataInicio))
      .AddPair('executiontime', TJSONNumber.Create(TempoDeExecucao))
      .AddPair('error', TJSONBool.Create(FError))
      .AddPair('errormessage', ReplaceChar(FErrorMessage))
      .AddPair('path', FPath)
      .AddPair('method', FMethod)
      .AddPair('request', TJSONObject.ParseJSONValue(ReplaceChar(FRequest)))
      .AddPair('response', TJSONObject.ParseJSONValue(ReplaceChar(FResponse)));

    if FStatus <> EmptyStr then
      LJson.AddPair('status', TJSONNumber.Create(FStatus));

    for LLog in FLogs do
      LJsonLog.Add(LLog);

    LJson.AddPair('logs', LJSONLog);
    FLog := LJson.ToString;
  finally
    LJson.Free;
  end;
end;

procedure TFForm.ListarNFCe;
var
  LClient: TRESTClient;
  LRequest: TRESTRequest;
  LResponse: TRESTResponse;
  LJsonResponse: TJSONObject;
begin
  LClient := TRESTClient.Create(nil);
  LRequest := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);
  try
    Sleep(1000 + Random(2000));//BUSCA NO BANCO
    FMethod := 'GET';
    Log('Preparando listagem de NFCe pelo DocFiscAll');
    LClient.BaseURL := FSampleResources.ListarNFCeURL;
//    LClient.BaseURL := 'elastic4d';
    FPath := LClient.BaseURL;

    LRequest.Client := LClient;
    LRequest.Response := LResponse;
    LRequest.Method := TRESTRequestMethod.rmGET;
    LRequest.Params.AddItem('Authorization', 'Bearer ' + Token,
      pkHTTPHEADER, [poDoNotEncode]);
    LRequest.Params.AddItem('ambiente', 'taHomologacao', pkHTTPHEADER,
//    LRequest.Params.AddItem('ambiente', 'elastic4d', pkHTTPHEADER,
      [poDoNotEncode]);
    LRequest.Execute;

    LJsonResponse := LResponse.JSONValue as TJSONObject;
    FStatus := LResponse.StatusCode.ToString;
    if LResponse.StatusCode > 299 then
    begin
      FResponse := LJsonResponse.ToString;
      raise Exception.Create(FResponse);
    end;

    Log('Listagem de NFCe feita com sucesso');
    FMemoResponse.Lines.Add(Format('Response(%s): %s', [FStatus,
      TJson.Format(LJsonResponse)]));
  finally
    LClient.Free;
    LRequest.Free;
    LResponse.Free;
  end;
end;

procedure TFForm.Log(AValue: string; const AArgs: array of const);
begin
  Log(Format(AValue, AArgs));
end;

procedure TFForm.Log(AValue: string);
var
  LData: string;
begin
  LData := FormatDateTime('dd-MM-yyyy hh:mm:ss', Now);
  FLogs.Add(Format('%s: %s', [LData, AValue]));
end;

procedure TFForm.ConsultarCEP;
var
  LClient: TRESTClient;
  LRequest: TRESTRequest;
  LResponse: TRESTResponse;
  LJsonResponse: TJSONObject;
begin
  LClient := TRESTClient.Create(nil);
  LRequest := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);
  try
    FMethod := 'GET';
    Log('Preparando consulta de CEP pelo Viacep');
    LClient.BaseURL := Format('http://viacep.com.br/ws/%s/json/', [FEditCEP.Text]);
//    LClient.BaseURL := 'elastic4d';

    FPath := LClient.BaseURL;
    LRequest.Client := LClient;
    LRequest.Response := LResponse;
    LRequest.Method := TRESTRequestMethod.rmGET;
    LRequest.Execute;

    LJsonResponse := LResponse.JSONValue as TJSONObject;
    FStatus := LResponse.StatusCode.ToString;
    FResponse := LJsonResponse.ToString;
    if LResponse.StatusCode > 299 then
      raise Exception.Create(FResponse);

    Log('Consulta de CEP feita com sucesso');
    FMemoResponse.Lines.Add(Format('Response(%s): %s', [FStatus,
      TJson.Format(LJsonResponse)]));
  finally
    LClient.Free;
    LRequest.Free;
    LResponse.Free;
  end;
end;

procedure TFForm.EmitirNFCe;
var
  LClient: TRESTClient;
  LRequest: TRESTRequest;
  LResponse: TRESTResponse;
  LJsonResponse: TJSONObject;
  LJsonBody: TJSONObject;
begin
  LClient := TRESTClient.Create(nil);
  LRequest := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);
  try
    Sleep(1000 + Random(2000));//BUSCA NO BANCO
    FMethod := 'POST';
    Log('Preparando emissão da NFCe pelo DocFiscAll');
    LClient.BaseURL := FSampleResources.EmitirNFCeURL;
//    LClient.BaseURL := 'elastic4d';
    FPath := LClient.BaseURL;

    LRequest.Client := LClient;
    LRequest.Response := LResponse;
    LRequest.Method := TRESTRequestMethod.rmPOST;
    LRequest.Params.AddItem('Authorization', 'Bearer ' + Token,
      pkHTTPHEADER, [poDoNotEncode]);
    LRequest.Params.AddItem('ambiente', 'taHomologacao', pkHTTPHEADER,
//    LRequest.Params.AddItem('ambiente', 'elastic4d', pkHTTPHEADER,
      [poDoNotEncode]);

    FRequest := FMemoRequest.Lines.Text;
    LJsonBody := TJSONObject.ParseJSONValue(FRequest) as TJSONObject;
    LRequest.Body.Add(LJsonBody.ToString, ctAPPLICATION_JSON);
//    LRequest.Body.Add('elastic4d', ctAPPLICATION_JSON);
    LRequest.Execute;

    LJsonResponse := LResponse.JSONValue as TJSONObject;
    FStatus := LResponse.StatusCode.ToString;
    FResponse := LJsonResponse.ToString;
    if LResponse.StatusCode > 299 then
      raise Exception.Create(FResponse);

    Log('Emissão de NFCe feita com sucesso');
    FMemoResponse.Lines.Add(Format('Response(%s): %s', [FStatus,
      TJson.Format(LJsonResponse)]));
    Sleep(1000 + Random(2000));//REGISTRO NO BANCO
  finally
    LClient.Free;
    LRequest.Free;
    LResponse.Free;
  end;
end;

function TFForm.TempoDeExecucao: Integer;
begin
  Result := SecondsBetween(FDataInicio, Now);
end;

function TFForm.Token: string;
var
  LClient: TRESTClient;
  LRequest: TRESTRequest;
  LResponse: TRESTResponse;
  LJsonResponse: TJSONObject;
begin
  LClient := TRESTClient.Create(nil);
  LRequest := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);
  try
    Log('Preparando requisição para gerar token');
    LClient.BaseURL := FSampleResources.TokenURL;
//    LClient.BaseURL := 'elastic4d';

    LRequest.Client := LClient;
    LRequest.Response := LResponse;
    LRequest.Method := TRESTRequestMethod.rmPOST;
    LRequest.Body.Add(FSampleResources.TokenRequestBody, ctAPPLICATION_JSON);
//    LRequest.Body.Add('elastic4d', ctAPPLICATION_JSON);
    LRequest.Execute;

    LJsonResponse := LResponse.JSONValue as TJSONObject;
    if LResponse.StatusCode > 299 then
      raise Exception.Create('Erro ao gerar token de autenticação');

    Log('Geração do token feita com sucesso');
    Result := LJsonResponse.GetValue('token').ToString;
    Result := Result.Replace('"', EmptyStr);
  finally
    LClient.Free;
    LRequest.Free;
    LResponse.Free;
  end;
end;

end.
