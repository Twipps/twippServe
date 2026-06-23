program twippServe;
{$mode objfpc}{$H+}

uses Classes, SysUtils, fphttpapp, httpdefs, httproute;

function fetchFont(fontID: int8): TFileStream;
var
    rStream: TFileStream; {fonts need a file stream since they are binaries}

begin
    case fontID of
    0:
        begin
            rStream := TFileStream.Create('../../web/fonts/AlumniSansPinstripe-Regular.ttf',
             fmOpenRead or fmShareDenyWrite);
        end;
    1:
        begin
            rStream := TFileStream.Create('../../web/fonts/AlumniSansPinstripe-Italic.ttf',
             fmOpenRead or fmShareDenyWrite);
        end;
    else
        writeLn('Fetch Error: Requested fontID not found.');
    end;

    result := rStream;
end;

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
            stringList.LoadFromFile('../../web/css/baseStyle.css');
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

{alumni sans pinstripe}
procedure routeFontASPR(request: TRequest; response: TResponse);
const
    fontID: int8 = 0;
    
var 
    fontStream: TFileStream;

begin
    response.Code := 200;
    response.CodeText := 'OK';
    response.ContentType := 'font/tff';
    writeLn(request.ProtocolVersion + ' ' + request.Method + ' ' + IntToStr(response.Code) 
    + ' ' + response.CodeText + ': Serving fontID ' + IntToStr(fontID) + ' to ' + request.RemoteAddr);
    fontStream := fetchFont(fontID);
    response.ContentLength := fontStream.Size;
    response.ContentStream := fontStream;
end;

{alumni sans pinstripe itallic}
procedure routeFontASPI(request: TRequest; response: TResponse);
const
    fontID: int8 = 1;

var 
    fontStream: TFileStream;

begin
    response.Code := 200;
    response.CodeText := 'OK';
    response.ContentType := 'font/tff';
    writeLn(request.ProtocolVersion + ' ' + request.Method + ' ' + IntToStr(response.Code) 
    + ' ' + response.CodeText + ': Serving fontID ' + IntToStr(fontID) + ' to ' + request.RemoteAddr);
    fontStream := fetchFont(fontID);
    response.ContentLength := fontStream.Size;
    response.ContentStream := fontStream;
end;

procedure routeBackgroundStyle(request: TRequest; response: TResponse);
const
    styleSheetID: int8 = 0;

begin
    response.Code := 200;
    response.CodeText := 'OK';
    response.ContentType := 'text/css'; {this is important so chrome knows what type it is}
    writeLn(request.ProtocolVersion + ' ' + request.Method + ' ' + IntToStr(response.Code) 
    + ' ' + response.CodeText + ': Serving styleSheetID ' + IntToStr(styleSheetID) + ' to ' 
    + request.RemoteAddr);
    response.Content := fetchStyle(styleSheetID);
end;

procedure routeMain(request: TRequest; response: TResponse);
const 
    routeID: int8 = 0;

begin
    response.Code := 200;
    response.CodeText := 'OK';
    response.ContentType := 'text/html';
    writeLn(request.ProtocolVersion + ' ' + request.Method + ' ' + IntToStr(response.Code) 
    + ' ' + response.CodeText + ': Serving pageID ' + IntToStr(routeID) + ' to ' + request.RemoteAddr);
    response.Content := fetchPage(routeID);
end;

var 
    threaded: boolean;

begin
    {Registers routes for the handler to manage}
    HTTPRouter.RegisterRoute('/', @routeMain);
    writeln('----- Starting twippServe -----');

    {serves the background css}
    HTTPRouter.RegisterRoute('/css/baseStyle.css', @routeBackgroundStyle);

    {serves the fonts}
    HTTPRouter.RegisterRoute('/fonts/AlumniSansPinstripe-Regular.ttf', @routeFontASPR);
    HTTPRouter.RegisterRoute('/fonts/AlumniSansPinstripe-Italic.ttf', @routeFontASPI);

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