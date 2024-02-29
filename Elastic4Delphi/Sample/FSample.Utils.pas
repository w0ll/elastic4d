unit FSample.Utils;

interface

uses
  System.SysUtils;

function ReplaceChar(AValue: string): string;

implementation

function ReplaceChar(AValue: string): string;
begin
  Result := AValue
    .Replace(#9, EmptyStr)
    .Replace(#$A, EmptyStr)
    .Replace(#$D, EmptyStr)
    .Replace('\', EmptyStr)
    .Replace('\n', EmptyStr)
    .Replace('\t', EmptyStr)
    .Replace('\r', EmptyStr);
end;

end.
