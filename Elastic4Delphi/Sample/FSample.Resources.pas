unit FSample.Resources;

interface

uses
  JSON,
  System.Classes,
  System.SysUtils;

type
  TSampleResources = class
  private
    FAccessKey: string;
    FCanonicalURI: string;
    FCanonicalQuery: string;
    FHost: string;
    FRegion: string;
    FService: string;
    FSecretKey: string;
    FListarNFCeURL: string;
    FEmitirNFCeURL: string;
    FTokenURL: string;
    FTokenRequestBody: string;
  public
    constructor Create;

    property AccessKey: string read FAccessKey write FAccessKey;
    property CanonicalURI: string read FCanonicalURI write FCanonicalURI;
    property CanonicalQuery: string read FCanonicalQuery write FCanonicalQuery;
    property Host: string read FHost write FHost;
    property Region: string read FRegion write FRegion;
    property Service: string read FService write FService;
    property SecretKey: string read FSecretKey write FSecretKey;
    property ListarNFCeURL: string read FListarNFCeURL write FListarNFCeURL;
    property EmitirNFCeURL: string read FEmitirNFCeURL write FEmitirNFCeURL;
    property TokenURL: string read FTokenURL write FTokenURL;
    property TokenRequestBody: string read FTokenRequestBody write FTokenRequestBody;
  end;

var
  FSampleResources: TSampleResources;

implementation

{ TSampleResources }

constructor TSampleResources.Create;
var
  LJson: TJSONObject;
  LArquivo: TStringList;
begin
  LArquivo := TStringList.Create;
  try
    LArquivo.LoadFromFile(ExtractFilePath(GetModuleName(HInstance)) + 'SampleResources.json');
    LJson := TJSONObject.ParseJSONValue(LArquivo.Text) as TJSONObject;
    try
      if Assigned(LJson) then
      begin
        try
          FAccessKey := LJson.GetValue('AccessKey').ToString.Replace('"', '');
          FCanonicalURI := LJson.GetValue('CanonicalURI').ToString.Replace('"', '');
          FCanonicalQuery := LJson.GetValue('CanonicalQuery').ToString.Replace('"', '');
          FHost := LJson.GetValue('Host').ToString.Replace('"', '');
          FRegion := LJson.GetValue('Region').ToString.Replace('"', '');
          FService := LJson.GetValue('Service').ToString.Replace('"', ''); 
          FSecretKey := LJson.GetValue('SecretKey').ToString.Replace('"', '');
          FListarNFCeURL := LJson.GetValue('ListarNFCeURL').ToString.Replace('"', '');
          FEmitirNFCeURL := LJson.GetValue('EmitirNFCeURL').ToString.Replace('"', '');
          FTokenURL := LJson.GetValue('TokenURL').ToString.Replace('"', '');
          FTokenRequestBody := (LJson.GetValue('TokenRequestBody') as TJSONObject).ToString;
        except
          raise;
        end;
      end;
    finally
      LJson.Free;
    end;
  finally
    LArquivo.Free;
  end;
end;

initialization
  FSampleResources := TSampleResources.Create;

finalization
  FSampleResources.Free;

end.

