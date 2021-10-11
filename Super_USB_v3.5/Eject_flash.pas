unit Eject_flash;

interface

uses
windows;

const
setupapi = 'SetupApi.dll';

type
HDEVINFO = THandle;
PSP_DEVINFO_DATA = ^SP_DEVINFO_DATA;
SP_DEVINFO_DATA = packed record
cbSize: DWORD;
ClassGuid: TGUID;
DevInst: DWORD;
Reserved: DWORD;
end;

function SetupDiGetClassDevsA(ClassGuid: PGUID; Enumerator: PChar; hwndParent: HWND; Flags: DWORD): HDEVINFO; stdcall; external setupapi;
function SetupDiEnumDeviceInfo(DeviceInfoSet: HDEVINFO; MemberIndex: DWORD; DeviceInfoData: PSP_DEVINFO_DATA): boolean; stdcall; external setupapi;
function SetupDiDestroyDeviceInfoList(DeviceInfoSet: HDEVINFO): boolean; stdcall; external setupapi;
function CM_Get_Parent(pdnDevInst: PDWORD; dnDevInst: DWORD; ulFlags: DWORD): DWORD; stdcall; external setupapi;
function CM_Get_Device_ID_Size(pulLen: PDWORD; dnDevInst: DWORD; ulFlags: DWORD): DWORD; stdcall; external setupapi;
function CM_Get_Device_IDA(dnDevInst: DWORD; Buffer: PChar; BufferLen: DWORD; ulFlags: DWORD): DWORD; stdcall; external setupapi;
function CM_Locate_DevNodeA(pdnDevInst: PDWORD; pDeviceID: PChar; ulFlags: DWORD): DWORD; stdcall; external setupapi;
function CM_Request_Device_EjectA(dnDevInst: DWORD; pVetoType: Pointer; pszVetoName: PChar; ulNameLength: DWORD;
ulFlags: DWORD): DWORD; stdcall; external setupapi;
procedure EjectUSB();

implementation

function IsUSBDevice(DevInst: DWORD): boolean;
  function CompareMem(p1, p2: Pointer; len: DWORD): boolean;
  var
   i: DWORD;
  begin
   result := false;
    if len = 0 then exit;
     for i := 0 to len-1 do
      if PByte(DWORD(p1) + i)^ <> PByte(DWORD(p2) + i)^ then exit;
      result := true;
  end;
var
 IDLen: DWORD;
 ID   : PChar;
begin
try
 result := false;
 if (CM_Get_Device_ID_Size(@IDLen, DevInst, 0) <> 0) or (IDLen = 0) then exit;
 inc(IDLen);
 ID := GetMemory(IDLen);
 if ID = nil then exit;
 if (CM_Get_Device_IDA(DevInst, ID, IDLen, 0) <> 0) or (not CompareMem(ID, PChar('USBSTOR'), 7)) then
  begin
   FreeMemory(ID);
   exit;
  end;
 FreeMemory(ID);
 result := true;
except

end;
end;

procedure EjectUSB();
const
 GUID_DEVCLASS_DISKDRIVE: TGUID = (D1: $4D36E967; D2: $E325; D3: $11CE; D4: ($BF, $C1, $08, $00, $2B, $E1, $03, $18));
var
 hDevInfoSet: HDEVINFO;
 DevInfo    : SP_DEVINFO_DATA;
 i          : Integer;
 Parent     : DWORD;
 VetoName   : PChar;
begin
 DevInfo.cbSize := sizeof(SP_DEVINFO_DATA);
 hDevInfoSet := SetupDiGetClassDevsA(@GUID_DEVCLASS_DISKDRIVE, nil, 0, 2);
 if hDevInfoSet = INVALID_HANDLE_VALUE then exit;
 i := 0;
 while (SetupDiEnumDeviceInfo(hDevInfoSet, i, @DevInfo)) do
  begin
   if (IsUSBDevice(DevInfo.DevInst)) and (CM_Get_Parent(@Parent, DevInfo.DevInst, 0) = 0) then
    begin
     VetoName := GetMemory(260);
      if (CM_Request_Device_EjectA(Parent, nil, VetoName, 260, 0) <> 0) then
       begin
        if (CM_Locate_DevNodeA(@Parent, VetoName, 0) <> 0) then
         begin
          FreeMemory(VetoName);
          continue;
         end;
        FreeMemory(VetoName);
         if (CM_Request_Device_EjectA(Parent, nil, nil, 0, 0) <> 0) then continue;
       end;
      FreeMemory(VetoName);
      break;             
    end;
   inc(i);
  end;
  // SetupDiDestroyDeviceInfoList(hDevInfoSet);
end;


end.
