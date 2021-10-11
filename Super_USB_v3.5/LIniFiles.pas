unit LIniFiles;

(***************************************)
(*  LENIN INC                          *)
(*  Online:  http://www.lenininc.com/  *)
(*  E-Mail:  lenin@zeos.net            *)
(*  Free for non commercial use.       *)
(***************************************)

interface

uses
  Windows, SysUtils;

{INI File functions}

//String := IniReadString('C:\Msdos.sys', 'Paths', 'UninstallDir', '');
//Integer := IniReadInteger('C:\Msdos.sys', 'Options', 'BootMenuDefault', -1);

//IniWriteString('C:\Msdos.sys', 'Paths', 'UninstallDir', String);
//IniWriteInteger('C:\Msdos.sys', 'Options', 'BootMenuDefault', Integer);

{ Проверка }
//Существует ли параметр в INI файле?
function IniValueExists(const FFileName, Section, Ident: string): Boolean;

{ Чтение }
//Чтение строкового значения
function IniReadString(const FFileName, Section, Ident, Default: string): string;
//Чтение значения типа Integer
function IniReadInteger(const FFileName, Section, Ident: string; Default: Longint): Longint;
//Чтение значения типа Boolean
function IniReadBool(const FFileName, Section, Ident: string; Default: Boolean): Boolean;

{ Запись }
//Добавление строкового значения
function IniWriteString(const FFileName, Section, Ident, Value: string): Boolean;
//Добавление значения типа Integer
function IniWriteInteger(const FFileName, Section, Ident: string; Value: Longint): Boolean;
//Добавление значения типа Boolean
function IniWriteBool(const FFileName, Section, Ident: string; Value: Boolean): Boolean;

{ Удаление }
//Удаление параметра
function IniDeleteKey(const FFileName, Section, Ident: String): Boolean;
//Удаление всей секции
function IniEraseSection(const FFileName, Section: string): Boolean;

{ Другое }
//Обновление INI файла
function IniUpdateFile(const FFileName: string): Boolean;

{ DataTime }
function IniReadDataTime(const FFileName, Section, Ident, Default: string): TDateTime;
function IniWriteDataTime(const FFileName, Section, Ident: string; Dat: TDateTime): Boolean;

implementation

function IniEraseSection(const FFileName, Section: string): Boolean;
begin
 Result := WritePrivateProfileString(PChar(Section), nil, nil, PChar(FFileName));
end;

function IniReadString(const FFileName, Section, Ident, Default: string): string;
var
 Buffer: array[0..1023] of Char;
begin
 SetString(Result, Buffer, GetPrivateProfileString(PChar(Section),
  PChar(Ident), PChar(Default), Buffer, SizeOf(Buffer), PChar(FFileName)));
end;

function IniReadInteger(const FFileName, Section, Ident: string; Default: Longint): Longint;
var
 IntStr: string;
begin
 IntStr := IniReadString(PChar(FFileName), Section, Ident, '');
  if (Length(IntStr) > 2) and (IntStr[1] = '0') and
    ((IntStr[2] = 'X') or (IntStr[2] = 'x')) then
    IntStr := '$' + Copy(IntStr, 3, Maxint);
 Result := StrToIntDef(IntStr, Default);
end;

function IniReadBool(const FFileName, Section, Ident: string; Default: Boolean): Boolean;
begin
 Result := IniReadInteger(FFileName, Section, Ident, Ord(Default)) <> 0;
end;

function IniWriteString(const FFileName, Section, Ident, Value: string): Boolean;
begin
 Result := WritePrivateProfileString(PChar(Section), PChar(Ident), PChar(Value), PChar(FFileName));
end;

function IniWriteInteger(const FFileName, Section, Ident: string; Value: Longint): Boolean;
begin
 Result := IniWriteString(FFileName, Section, Ident, IntToStr(Value));
end;

function IniWriteBool(const FFileName, Section, Ident: string; Value: Boolean): Boolean;
const
 Values: array[Boolean] of string = ('0', '1');
begin
 Result := IniWriteString(FFileName, Section, Ident, Values[Value]);
end;

function IniDeleteKey(const FFileName, Section, Ident: String): Boolean;
begin
 Result := WritePrivateProfileString(PChar(Section), PChar(Ident), nil, PChar(FFileName));
end;

function IniValueExists(const FFileName, Section, Ident: string): Boolean;
begin
 if IniReadString(FFileName, Section, Ident, '') <> '' then
   Result := True else Result := False;
end;

function IniUpdateFile(const FFileName: string): Boolean;
begin
 Result := WritePrivateProfileString(nil, nil, nil, PChar(FFileName));
end;

{ DataTime }
function IniReadDataTime(const FFileName, Section, Ident, Default: string): TDateTime;
var
 Buffer: array[0..1023] of Char;
 s: String;
begin
 SetString(s, Buffer, GetPrivateProfileString(PChar(Section),
  PChar(Ident), PChar(Default), Buffer, SizeOf(Buffer), PChar(FFileName)));
 Result := StrToDateTime(s);
end;

function IniWriteDataTime(const FFileName, Section, Ident: string; Dat: TDateTime): Boolean;
begin
 Result := WritePrivateProfileString(PChar(Section), PChar(Ident), PChar(DateTimeToStr(Dat)), PChar(FFileName));
end;

end.
