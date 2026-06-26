program twippServe;
{$mode objfpc}{$H+}

uses Classes, SysUtils, fphttpapp, httpdefs, httproute;

function fetchImage(imageID: int8): TFileStream;
var
    rStream: TFileStream; {images/fonts need a file stream since they are binaries}

begin
    case imageID of
    0:
        begin
            rStream := TFileStream.Create('../../web/images/banner.png',
             fmOpenRead or fmShareDenyWrite);
        end;
    else
        writeLn('Fetch Error: Requested imageID not found.');
    end;

    result := rStream;
end;

function fetchFont(fontID: int8): TFileStream;
var
    rStream: TFileStream;

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
             fmOpenRead or fmShareDenyWrite); {file manager open read; file manager deny write access, makes a lock() file or something similar}
        end;
    2:
        begin
            rStream := TFileStream.Create('../../web/fonts/Oswald-VariableFont_wght.ttf',
             fmOpenRead or fmShareDenyWrite); {file manager open read; file manager deny write access, makes a lock() file or something similar}
        end;
    else
        writeLn('Fetch Error: Requested fontID not found.');
    end;

    result := rStream;
end;

function fetchScript(scriptID: int8): string;
var
    rScript: string;
    stringList: TStringList;

begin
    stringList := TStringList.Create;

    try
    case scriptID of
    0:
        begin
            stringList.LoadFromFile('../../web/js/backgroundEffect.js');
            rScript := stringList.text;
        end;
    else
        writeln('Fetch Error: Requested scriptID not found.');
    end;

    finally
        stringList.Free;
    end;
    result := rScript;
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

procedure routeImageBanner(request: TRequest; response: TResponse);
const 
    imageID: int8 = 0;

var 
    imageStream: TFileStream;

begin
    response.Code := 200;
    response.CodeText := 'OK';
    response.ContentType := 'image/png';
    writeLn(request.ProtocolVersion + ' ' + request.Method + ' ' + IntToStr(response.Code) 
    + ' ' + response.CodeText + ': Serving imageID ' + IntToStr(imageID) + ' to ' + request.RemoteAddr);
    imageStream := fetchImage(imageID);
    response.ContentLength := imageStream.Size;
    response.ContentStream := imageStream;
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

procedure routeFontOswald(request: TRequest; response: TResponse);
const
    fontID: int8 = 2;

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

procedure routeBaseStyle(request: TRequest; response: TResponse);
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

procedure routeIndex(request: TRequest; response: TResponse);
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

procedure routeScriptBackground(request: TRequest; response: TResponse);
const 
    scriptID: int8 = 0;

begin 
    response.Code := 200;
    response.CodeText := 'OK';
    response.ContentType := 'text/javascript';
    writeLn(request.ProtocolVersion + ' ' + request.Method + ' ' + IntToStr(response.Code) 
    + ' ' + response.CodeText + ': Serving scriptID ' + IntToStr(scriptID) + ' to ' + request.RemoteAddr);
    response.Content := fetchScript(scriptID);
end;

var 
    threaded: boolean;

begin
    {Registers routes for the handler to manage}
    HTTPRouter.RegisterRoute('/', @routeIndex);
    writeln('----- Starting twippServe -----');

    {serves the background css}
    HTTPRouter.RegisterRoute('/css/baseStyle.css', @routeBaseStyle);

    {serves the fonts}
    HTTPRouter.RegisterRoute('/fonts/AlumniSansPinstripe-Regular.ttf', @routeFontASPR);
    HTTPRouter.RegisterRoute('/fonts/AlumniSansPinstripe-Italic.ttf', @routeFontASPI);
    HTTPRouter.RegisterRoute('/fonts/Oswald-VariableFont_wght.ttf', @routeFontOswald);

    {serves the images}
    HTTPRouter.RegisterRoute('/images/banner.png', @routeImageBanner);

    {serves the scripts}
    HTTPRouter.RegisterRoute('/js/backgroundEffect.js', @routeScriptBackground);

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