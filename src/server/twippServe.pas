program twippServe;
{$mode objfpc}{$H+}

uses SysUtils, fphttpapp, httpdefs, httproute;

procedure routeMain(request: TRequest; response: TResponse);
begin
    response.Content := '<!DOCTYPE html><html><head><title>TwippsMain</title></head><body>twipps.com</body></html>';
end;

var 
    threaded: boolean;

begin
    {Registers routes for the handler to manage}
    HTTPRouter.RegisterRoute('/', @routeMain);
    writeln('----- Starting twippServe -----');

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