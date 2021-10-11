{**************************************************************}
{****          Модуль для работы с реестром Windows.       ****}
{****                                                      ****}
{****            Автор модуля: Наумов Александр            ****}
{****                                                      ****}
{****             naumov_@mail.ru                          ****}
{****             http://www.mgclt.h16.ru                  ****}
{**** Май 2006                                             ****}
{**************************************************************}

unit Regedit;

interface

uses
windows;

{ Запись }
//Добавление строковой записи  [RootKey\SubKey] "Name"="Value"
Procedure RegWriteString(RootKey: cardinal; Subkey: PAnsiChar; Name: PChar; Value: PChar);
//Добавление DWORD записи  [RootKey\SubKey] "Name"=dword:Value
Procedure RegWriteInteger(RootKey: cardinal; Subkey: PAnsiChar; Name: PChar; Value: DWord);
//Добавление двоичной записи  [RootKey\SubKey] "Name"=hex:Value
Procedure RegWriteBinary(RootKey: cardinal; Subkey: PAnsiChar; Name: PChar; Value: DWord; const ValueSize: integer);

{ Чтение } 
//Чтение строкового значения
function GetRegistryString(const RootKey: HKEY; const Key, Name: String): String;
//Чтение двоичного значения
function GetRegistryBinary(const RootKey: HKEY; const Key, Name: String): Integer;
//Чтение значения DWORD
function GetRegistryDWord(const RootKey: HKEY; const Key, Name: String): Word;

{ Удаление }
//Удаление ключа    [-HKLM\Software\Microsoft]
//RootKey:HKLM  SubKey:Software Name:Microsoft
Procedure RegDelKey(RootKey: cardinal; Subkey: PAnsiChar; Name: PChar);
//Удаление параметра [-HKLM\Software\Microsoft]  -"Name"
//RootKey:HKLM  SubKey:Software\Microsoft Name:"Name"
Procedure RegDelValue(RootKey: cardinal; Subkey: PAnsiChar; Name: PChar);

{ Проверка }
//Существует ли ключ в реестре?
Function RegKeyExists(const RootKey: HKEY; const Key: String): bool;
//Существует ли параметр в реестре?
function RegValueExists(const RootKey: HKEY; const Key, Name: String): Boolean;

function RegGetValue(const RootKey: HKEY; const Key, Name: String;
         const ValueType: Cardinal; var RegValueType: Cardinal;
         var ValueBuf: Pointer; var ValueSize: Integer): Boolean;

implementation


Procedure RegWriteString(RootKey: cardinal; Subkey: PAnsiChar; Name: PChar; Value: PChar);
var
 key: hkey;
begin
 if RegCreateKey(RootKey,
                  SubKey,
                  key) = ERROR_SUCCESS then
   begin
    RegSetValueEx(key, Name, 0, REG_SZ, Value, Length(Value) + 1);
    RegCloseKey(key);
   end;
end;

Procedure RegWriteInteger(RootKey: cardinal; Subkey: PAnsiChar; Name: PChar; Value: DWord);
var
 key: hkey;
begin
 if RegCreateKey(RootKey,
                  SubKey,
                  key) = ERROR_SUCCESS then
   begin
    RegSetValueEx(key, Name, 0, REG_DWORD, @Value, SizeOf(Value));
    RegCloseKey(key);
   end;
end;

Procedure RegWriteBinary(RootKey: cardinal; Subkey: PAnsiChar; Name: PChar; Value: DWord; const ValueSize: integer);
var
 key: hkey;
begin
 if RegCreateKey(RootKey,
                  SubKey,
                  key) = ERROR_SUCCESS then
   begin
    RegSetValueEx(key, Name, 0, REG_BINARY, @Value, ValueSize);
    RegCloseKey(key);
   end;
end;

Procedure RegDelKey(RootKey: cardinal; Subkey: PAnsiChar; Name: PChar);
var
 key: hkey;
begin
 if RegCreateKey(RootKey,
                  SubKey,
                  key) = ERROR_SUCCESS then
   begin
    RegDeleteKey(key, Name);
    RegCloseKey(key);
   end;
end;

Procedure RegDelValue(RootKey: cardinal; Subkey: PAnsiChar; Name: PChar);
var
 key: hkey;
begin
 if RegCreateKey(RootKey,
                  SubKey,
                  key) = ERROR_SUCCESS then
   begin
    RegDeleteValue(key, Pointer(Name));
    RegCloseKey(key);
   end;
end;

Function RegKeyExists(const RootKey: HKEY; const Key: String): bool;
var Handle : HKEY;
begin
  if RegOpenKeyEx(RootKey, PChar(Key), 0, KEY_READ, Handle) = ERROR_SUCCESS then
    begin
      Result := True;
      RegCloseKey(Handle);
    end else
    Result := False;
end;

function RegValueExists(const RootKey: HKEY; const Key, Name: String): Boolean;
var Handle : HKEY;
begin
  if RegOpenKeyEx(RootKey, PChar(Key), 0, KEY_READ, Handle) = ERROR_SUCCESS then
    begin
      Result := RegQueryValueEx(Handle, Pointer(Name), nil, nil, nil, nil) = ERROR_SUCCESS;
      RegCloseKey(Handle);
    end else
    Result := False;
end;

function GetRegistryString(const RootKey: HKEY; const Key, Name: String): String;
var
 Handle: HKEY;
 DataType, DataSize: DWORD;
begin
 if RegOpenKeyEx(RootKey, PChar(Key), 0, KEY_QUERY_VALUE, Handle) <> ERROR_SUCCESS then Exit;
 if (RegQueryValueEx(Handle, PChar(Name), nil, @DataType, nil, @DataSize) <> ERROR_SUCCESS)
  or (DataType <> REG_SZ) then begin
   RegCloseKey(Handle);
   Exit;
  end;
 SetString(Result, nil, DataSize-1);
 RegQueryValueEx(Handle, PChar(Name), nil, @DataType, PByte(@Result[1]), @DataSize);
 RegCloseKey(Handle);
end;

function GetRegistryBinary(const RootKey: HKEY; const Key, Name: String): Integer;
var Buf   : Pointer;
    Size  : Integer;
    VType : Cardinal;
begin
  Result := 0;
  if not RegGetValue(RootKey, Key, Name, REG_BINARY, VType, Buf, Size) then
    exit;
  if (VType = REG_BINARY) and (Size >= Sizeof(Word)) then
    Result := PWord(Buf)^;
  FreeMem(Buf);
end;

function GetRegistryDWord(const RootKey: HKEY; const Key, Name: String): Word;
var Buf   : Pointer;
    Size  : Integer;
    VType : Cardinal;
begin
  Result := 0;
  if not RegGetValue(RootKey, Key, Name, REG_DWORD, VType, Buf, Size) then
    exit;
  if (VType = REG_DWORD) and (Size >= Sizeof(Word)) then
    Result := PWord(Buf)^;
  FreeMem(Buf);
end;

function RegGetValue(const RootKey: HKEY; const Key, Name: String;
         const ValueType: Cardinal; var RegValueType: Cardinal;
         var ValueBuf: Pointer; var ValueSize: Integer): Boolean;
var Handle  : HKEY;
    Buf     : Pointer;
    BufSize : Cardinal;
begin
  Result := False;
  ValueSize := 0;
  ValueBuf := nil;
  if RegOpenKeyEx(RootKey, PChar(Key), 0, KEY_READ, Handle) <> ERROR_SUCCESS then
    exit;
  BufSize := 0;
  RegQueryValueEx(Handle, Pointer(Name), nil, @RegValueType, nil, @BufSize);
  if BufSize <= 0 then
    exit;
  GetMem(Buf, BufSize);
  if RegQueryValueEx(Handle, Pointer(Name), nil, @RegValueType, Buf, @BufSize) = ERROR_SUCCESS then
    begin
      ValueBuf := Buf;
      ValueSize := Integer(BufSize);
      Result := True;
    end;
  if not Result then
    FreeMem(Buf);
  RegCloseKey(Handle);
end;

end.
