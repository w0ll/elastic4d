unit Elastic4D.Interfaces;

interface

uses
  System.SysUtils;

{$M+}

type
  IElastic4DRequest = interface
    ['{5121058C-D054-4CA2-99A1-070BBAB49BA3}']
    function CanonicalURI(AValue: string): IElastic4DRequest;
    function Host(AValue: string): IElastic4DRequest;

    function Execute(APayload: string): string;
  end;

  IElastic4DAWSRequest = interface
    ['{B4163D45-ABCC-4928-B23A-99C96BE276D8}']
    function AccessKey(AValue: string): IElastic4DAWSRequest;
    function CanonicalURI(AValue: string): IElastic4DAWSRequest;
    function CanonicalQuery(AValue: string): IElastic4DAWSRequest;
    function Host(AValue: string): IElastic4DAWSRequest;
    function Region(AValue: string): IElastic4DAWSRequest;
    function Service(AValue: string): IElastic4DAWSRequest;
    function SecretKey(AValue: string): IElastic4DAWSRequest;

    function Execute(APayload: string): string;
  end;

function Elastic4DRequest: IElastic4DRequest;
function Elastic4DAWSRequest: IElastic4DAWSRequest;

implementation

uses
  Elastic4D.Request,
  Elastic4D.AWS.Request;

function Elastic4DRequest: IElastic4DRequest;
begin
  Result := TElastic4DRequest.New;
end;

function Elastic4DAWSRequest: IElastic4DAWSRequest;
begin
  Result := TElastic4DAWSRequest.New;
end;

end.

