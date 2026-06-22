program twippServe;
{$mode objfpc}{$H+}

uses Classes, SysUtils, fphttpapp, httpdefs, httproute;

function fetchStyle(styleSheetID: int8): string;
var
    rCss: string;
    stringList: TStringList; {things in the std lib seem to start with T}

begin
    {create new obj}
    stringList := TStringList.Create;

    try
    case styleSheetID of
      0:
      begin
            stringList.LoadFromFile('../../web/css/backgroundStyle.css');
            rCss := stringList.Text;
        end;
    else
        writeLn('Fetch Error: Requested styleSheetID not found.');
    end;

    finally
    {free mem}
    stringList.Free;
    end;
    result := rCss;
end;

function fetchPage(pageID: int8): string;
var
    rHtml: string;
    stringList: TStringList; {things in the std lib seem to start with T}

begin
    {create new obj}
    stringList := TStringList.Create;

    try
    case pageID of
      0:
      begin
            stringList.LoadFromFile('../../web/html/twipp.html');
            rHtml := stringList.Text;
        end;
    else
        writeLn('Fetch Error: Requested pageID not found.');
    end;

    finally
    {free mem}
    stringList.Free;
    end;
    result := rHtml;
end;

procedure routeBackgroundStyle(request: TRequest; response: TResponse);
const
    styleSheetID: int8 = 0;

begin
    response.Code := 200;
    writeLn(request.Method + ': Serving styleSheetID ' + IntToStr(styleSheetID) + ' to ' + request.RemoteAddr);
    response.Content := fetchStyle(styleSheetID);
end;

procedure routeMain(request: TRequest; response: TResponse);
const 
    routeID: int8 = 0;

begin
    response.Code := 200;
    writeLn(request.Method + ': Serving pageID ' + IntToStr(routeID) + ' to ' + request.RemoteAddr);
    response.Content := fetchPage(routeID);
end;

var 
    threaded: boolean;

begin
    {Registers routes for the handler to manage}
    HTTPRouter.RegisterRoute('/', @routeMain);
    writeln('----- Starting twippServe -----');

    {serves the background css}
    HTTPRouter.RegisterRoute('/css/backSgroundStyle.css', @routeBackgroundStyle);

    {Sets up the port}
    Application.Port := 700;
    writeln(Format('Port: %d', [Application.Port])); {stord as a word; format is like printf}

    {Allows the application to multithread to handle concurrent requests}
    threaded := true;
    Application.Threaded := threaded;
    writeln(Format('Threaded: %s', [boolToStr(threaded)])); {-1: T, 0: F}

    {Prepares the application object; sets up handlers, internal state, platform specific handleing}
    Application.Initialize;

    writeln('----- Server Running -----');
    Application.Run;
end.

{Application.HostName := '';} {needs additional set up in sys32}
{Application.UseSSL := ;}
{writeln(Format('Host: %s', [Application.HostName]));}