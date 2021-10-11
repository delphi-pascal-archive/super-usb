{**************************************************}
{* V 3.5                                          *}
{*                                                *}
{*        Автор программы: Александр Наумов       *}
{*        naumov_@mail.ru                         *}
{*        http://www.mgclt.h16.ru                 *}
{*        icq: 361 401 060                        *}
{*        OPEN SOURCES                            *}
{*        Работает на Win2k и WinXP               *} 
{*                                                *}
{*                                    август 2009 *}
{**************************************************}

program USB;

uses
  windows, TaskBar, Eject_flash, Regedit, SysUtils, messages, LIniFiles;

{$R Project1.res}

type
 TScreen = record
 w : integer;   // Ширина экрана
 h : integer;   // Высота экрана
end;

var
  WinClass   : TWndClass; // переменная класса TWndClass для создания главного окна
  hInst      : HWND;      // хандлер приложения
  Handle     : HWND;      // локальный хандлер
  Msg        : TMSG;      // сообщение
  hFont      : HWND;      // хандлер шрифта
  Bevel1     : HWND;      // TBevel
  Label1     : HWND;      // TLabel
  Label2     : HWND;      // TLabel
  Label3     : HWND;      // TLabel
  Label4     : HWND;      // TLabel
  Button1    : HWND;      // TButton
  ThreadExe  : cardinal;  // Поток открывающий фворму уделения приложений
  ThreadExeId: cardinal;  // Идентификатор потока открывающего форму удаления приложений
  Thread     : cardinal;  // Поток ожидающий завершения работы с флеш
  ThreadId   : cardinal;  // Идентификатор потока ожидающего завершения работы с флеш
  ThreadIco  : cardinal;  // Поток обновляюшия иконку в трее
  ThreadIcoId: cardinal;  // Идентификатор потока обновляющего иконку в трее
  status     : DWord;     // Переменная для получения состояния потока
  disp       : TScreen;   // Переменная для сохранения параметров экрана
  DeleteExe  : integer = 0;     // Информация о автоматическом удалении элемонтоф автозапуска
  DeleteAutR : char;      // Информация о возможности сканировать элементы автозапуска
  STL        : char;      // Информация о ворзможности писать лог (0 или 1)
  pass       : string;    // Переменная хранящая пароль
  upass      : string;    // Переменная хранящая универсальный пароль
  list       : array of string; // Переменная хранащая список приложения на флешке
  SE         : char;      // Переменная хранащяя возможность сканировать приложения на флеш

const
  menu_id_1 = 271;    // Exit code
  menu_id_2 = 272;    // Отключить  USB
  menu_id_3 = 273;    // О программе
  menu_id_4 = 274;    // Проверка на ошибки
  menu_id_5 = 275;    // Форматировать флешку
  menu_id_6 = 276;    // Открыть в эксплорер
  menu_id_9 = 279;    // Проверить на вирусы
  menu_id_10= 280;    // Окно настроек
  menu_id_11= 281;    // Окно блокировки USB
  menu_id_12= 282;    // Смена пароля

  AppVersion = 'Flash control 3.5';
  RegPath    = 'Software\FlashControl'; // Размещение настроек программы

procedure InitCommonControls; external 'comctl32.dll' name 'InitCommonControls';

function ShellExecute(hWnd: HWND; Operation, FileName, Parameters,
  Directory: PChar; ShowCmd: Integer): windows.HINST; stdcall; external 'shell32.dll' name 'ShellExecuteA';

procedure SaveToLog( MessageStr : String );   // Запись в лог
var
  iFileHandle      : integer;
  Str              : string;
  LogFilename      : String;
  Year, Month, Day : Word;
begin
try
if STL = '0' then begin
 DecodeDate(Now(), Year, Month, Day);
 LogFilename := 'c:\FlashControl.log';
 if ( FileExists(LogFilename) ) then
   begin
    iFileHandle := FileOpen(LogFileName, fmOpenReadWrite);
    FileSeek(iFileHandle,0,2);
   end
   else
    iFileHandle := FileCreate(LogFilename);
 Str:=DateTimeToStr(Now);
 Str := Str+' '+MessageStr+#13#10;
 FileWrite(iFileHandle,PChar(Str)^,Length(Str));
 FileClose(iFileHandle);
end;
except
MessageBox(Handle, PChar(SysErrorMessage(GetLastError)), 'Error!', 0);
end;
end;

procedure StopAutorun;  // Отключение автозапуска флешек
begin
  RegWriteInteger(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer', 'NoDriveTypeAutoRun', 255);
end;

procedure StartAutorun; // Включение автозапуска флешек
begin
  RegDelKey(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer', 'NoDriveTypeAutoRun');
end;

function ScanList(DriveName: char): integer;  // Сканирование приложений на флешке
var
SearchRec: TSearchRec;
I, i2 : Integer;
begin
 SetLength(list, 1);
 i2:=0;
 I := FindFirst(DriveName+':\*.exe', faHidden, SearchRec);
 while I = 0 do begin
   list[i2]:=DriveName+':\'+SearchRec.Name;
   SetLength(list, Length(list)+1);
   inc(i2);
   I := FindNext(SearchRec);
 end;
 FindClose(SearchRec) ;
 result:=i2;
end;

procedure ListBox_AddItem(hListBox: HWND; NewItem: String);
begin
 SendMessage(hListBox, LB_ADDSTRING, 0, Integer(NewItem));
end;

procedure ListBox_ClearItems(hListBox: HWND);
begin
 SendMessage(hListBox, LB_RESETCONTENT, 0, 0);
end;

procedure ListBox_SelectedItem(hListBox: HWND; Index: Integer);
begin
 SendMessage(hListBox, LB_SETCURSEL, Index, 0);
end;

function ComboBox_GetItemCount(hComboBox: HWND): Integer;
begin
 Result := SendMessage(hComboBox, CB_GETCOUNT, 0, 0);
end;

procedure ListBox_DeleteItem(hListBox: HWND; Index: Integer);
begin
 SendMessage(hListBox, LB_DELETESTRING, Index, 0);
end;

function ListBox_GetSelectedItem(hListBox: HWND): string;
var
 Index, len: Integer;
 s: string;
 buffer: PChar;
begin
 Index := SendMessage(hListBox, LB_GETCURSEL, 0, 0);
 len := SendMessage(hListBox, LB_GETTEXTLEN, wParam(Index), 0);
 GetMem(buffer, len + 1);
 SendMessage(hListBox, LB_GETTEXT, wParam(Index), lParam(buffer));
 SetString(s, buffer, len);
 FreeMem(buffer);
 Result := s;
end;

function ListBox_GetCountSelectedItem(hListBox: HWND): Integer;
var
 Index, len: Integer;
 s: string;
 buffer: PChar;
begin
 Index := SendMessage(hListBox, LB_GETCURSEL, 0, 0);
 len := SendMessage(hListBox, LB_GETTEXTLEN, wParam(Index), 0);
 GetMem(buffer, len + 1);
 SendMessage(hListBox, LB_GETTEXT, wParam(Index), lParam(buffer));
 SetString(s, buffer, len);
 FreeMem(buffer);
 Result := Index;
end;

function DlgProcHiden(hWin: HWND; uMsg: UINT; wp: WPARAM; lp: LPARAM): bool; stdcall;  // Форма отображение списка найденых приложений в корне флешки
var
i: integer;
status: dword;
begin
 Result := False;

  case uMsg of
   WM_INITDIALOG:
    begin

      ListBox_ClearItems(GetDlgItem(hWin, 1000));
      for i:=0 to Length(list)-1 do
      begin
        if list[i] <> '' then
          ListBox_AddItem(GetDlgItem(hWin, 1000), list[i]);
          ListBox_SelectedItem(GetDlgItem(hWin, 1000), 0);
      end;

    end;
   WM_COMMAND:
    begin
     case LoWord(wp) of
      1: begin
           SetFileAttributes(PChar(ListBox_GetSelectedItem(GetDlgItem(hWin, 1000))), 0);
           if DeleteFile(ListBox_GetSelectedItem(GetDlgItem(hWin, 1000))) = true then
             ListBox_DeleteItem(GetDlgItem(hWin, 1000), ListBox_GetCountSelectedItem(GetDlgItem(hWin, 1000)));
           ListBox_SelectedItem(GetDlgItem(hWin, 1000), ComboBox_GetItemCount(GetDlgItem(hWin, 1000)));
         end;
      2: begin
           SetLength(list, 0);
           FreeMem(list);
           GetExitCodeThread(ThreadExe, status);
           if status = STILL_ACTIVE then
             TerminateThread(ThreadExe, 0);
         end;
    end;
  end;
   WM_DESTROY, WM_CLOSE:
    begin

     ShowWindow(hWin, SW_HIDE);
    end;
 end;
end;

procedure DlgExe;
begin
  DialogBox(hInstance, 'HIDEN_EXE', 0, @DlgProcHiden);
end;

function AutorunExists(DriveName: char; param: bool): bool;  // Обнаружение и удаление элементов автозапуска
var
 ExeName: string;
 exei: integer;
 auto: integer;
 status: dword;
begin
try
DeleteExe:=1;
 if FileExists(DriveName+':\Autorun.inf') = true then
 begin
  Result:=True;
  if IniValueExists(DriveName+':\Autorun.inf', 'autorun', 'open') = true then
  begin
   ExeName:=IniReadString(DriveName+':\Autorun.inf', 'autorun', 'open', '');
   exei:=FileOpen(PChar(DriveName+':\'+ExeName),  fmShareExclusive);
  end;
  if IniValueExists(DriveName+':\Autorun.inf', 'autorun', 'shell\open\Command') = true then
   ExeName:=IniReadString(DriveName+':\Autorun.inf', 'autorun', 'shell\open\Command', '');
  if IniValueExists(DriveName+':\Autorun.inf', 'autorun', 'action') = true then
   ExeName:=IniReadString(DriveName+':\Autorun.inf', 'autorun', 'action', '');
  if IniValueExists(DriveName+':\Autorun.inf', 'autorun', 'shellexecute') = true then
   ExeName:=IniReadString(DriveName+':\Autorun.inf', 'autorun', 'shellexecute', '');
  SaveToLog('На съёмном диске обнаружен элемент автозауска. Возможно это вирус. Имя файла: '+DriveName+':\'+ExeName+'.');
  beep;
  RegWriteInteger(HKEY_CURRENT_USER, RegPath, 'CountVir',
                  GetRegistryDWord(HKEY_CURRENT_USER, RegPath, 'CountVir')+1);

  if DeleteAutR = '0' then
  begin

    if MessageBox(Handle, PChar('На съёмном диске найден элемент автозапуска!'+#13#10+
                           'Имя файла: '+DriveName+':\'+ExeName+#13#10+
                           'Произвести его удаление?'), AppVersion, MB_YESNO or MB_ICONEXCLAMATION) =6 then
    begin
      sleep(500);
      FileClose(exei);
      if DeleteFile(DriveName+':\'+ExeName) = true then
        SaveToLog('Элемент '+DriveName+':\'+ExeName+' успешно удалён!') else SaveToLog('Элемент '+ExeName+' удалить не удалось!');
      if DeleteFile(DriveName+':\Autorun.inf') = true then
        SaveToLog('Элемент "Autorun.inf" успешно удалён!')  else SaveToLog('Элемент "Autorun.inf" удалить не удалось!');
    end else begin
      SaveToLog('Удаление элемента автозапуска отменено пользователем!');
      FileClose(exei);
    end;

  end else begin
    sleep(500);
    FileClose(exei);
    if DeleteFile(DriveName+':\'+ExeName) = true then
     SaveToLog('Элемент '+DriveName+':\'+ExeName+' успешно удалён!') else SaveToLog('Элемент '+ExeName+' удалить не удалось!');
    if DeleteFile(DriveName+':\Autorun.inf') = true then
     SaveToLog('Элемент "Autorun.inf" успешно удалён!')  else SaveToLog('Элемент "Autorun.inf" удалить не удалось!');
  end;
 end else begin
   if param = true then
     MessageBox(Handle, 'На флеш-носителе элемонтов автозапуска на обнаружено!', AppVersion, MB_OK or MB_ICONEXCLAMATION);
 end;
 if SE = '1' then
   if ScanList(DriveName) > 0 then
   begin
     GetExitCodeThread(ThreadExe,Status);
      if ( Status <> STILL_ACTIVE ) then
       ThreadExe:=CreateThread(nil, 0, @DlgExe, nil, 0, ThreadExeId);
   end;

except
SaveToLog('Error = AutoruExists. ExeName: '+ExeName+'.');
end;
end;

procedure ShutDown; //процедура завершения программы
begin
try
  TaskBarDeleteIcon(Handle, 1);
 except
  SaveToLog('Error = ShutDown 1'); // 1
 end;
 try
  GetExitCodeThread(Thread, status);
  if status = STILL_ACTIVE then
   TerminateThread(Thread, 0);
  GetExitCodeThread(ThreadIco, status);
  if status = STILL_ACTIVE then
   TerminateThread(ThreadIco, 0);
  UnRegisterClass('TFlashMan', hInst); //удаление окна
  ExitProcess(hInst);                    //закрытие программы
except
SaveToLog('Error = ShutDown 2 ('+SysErrorMessage(GetLastError)+')');  // 2 (информация об ошибке)
end;
end;

function FlashExist(param: integer): bool; // Проверка наличия флешки или отключение её
var
 Root   : string;
 i      : integer;
 buff   : array [0..MAX_PATH] of char;
 params : string;
 h      : hwnd;
begin
try
 Root := '#:\';
 for i := 0 to 25 do begin
      Root[1] := Char(Ord('A') + i);
      if GetDriveType(Pchar(Root)) = DRIVE_REMOVABLE then begin
       if DeleteExe = 0 then
        AutorunExists(root[1], false);
         case param of
          1: WinExec(PChar('chkdsk '+Root+' /f'), SW_SHOWNORMAL);  // Проверка на ошибки
          2: EjectUSB();                                           // Отклбючить USB
          3: if MessageBox(Handle, PChar('ВНИМАНИЕ, ВСЕ ДАННЫЕ НА СЪЕМНОМ ДИСКЕ "'+Root+'"'+#13#10+
                              'БУДУТ УНИЧТОЖЕНЫ! ПРИСТУПИТЬ К ФОРМАТИРОВАНИЮ?'), AppVersion, MB_YESNO or MB_ICONQUESTION) = 6 then
             begin
              params:=Root[1]+Root[2]+'/fs:FAT32 /v: /x';
              GetSystemDirectory(buff, SizeOf(buff));
              ShellExecute(0, nil, PChar(buff+'\format'), PChar(params), nil, 1);
             /// repeat
               sleep(250);
               h:=FindWindow('ConsoleWindowClass', NIL);
               PostMessage(h, $0100, 13, 0);   // Посылаем окну нажатие клавиши Enter
               SaveToLog('Запущен процесс форамттирования диска '+Root);
            //  until h=0;
             end;
          4: ShellExecute(0, nil, PChar(Root), nil, nil, 1);  // Открыть в проводнике
          5: AutorunExists(root[1], true);                    // Проверка на вырусы
         end;

        result:= true;
        TaskBarModifyIcon(Handle, 1, NIF_ICON, LoadIcon(hInstance, 'DELICON'), AppVersion);
        exit;
      end;
 end;
TaskBarModifyIcon(Handle, 1, NIF_ICON, LoadIcon(hInstance, 'MAINICON'), AppVersion);
DeleteExe:=0;
result:=false;
except
SaveToLog('Error = FlashExists ('+SysErrorMessage(GetLastError)+')');
end;
end;

procedure DetectFlashEject;    // Поток ожидающий завершения работы с флеш
begin
try
 while FlashExist(0) = true do begin
  FlashExist(2);
  TaskBarModifyIcon(Handle, 1, NIF_ICON, LoadIcon(hInstance, nil), AppVersion);
  sleep(1500);
 end;
TerminateThread(Thread, 0);
except
SaveToLog('Error = DetectFlashEject ('+SysErrorMessage(GetLastError)+')');
end;
end;

procedure ResetIcon;    // Поток обновляющий иконку
begin                   // На случай перезапуска Explorer.exe, для восстановления иконки в трее
try
 While true do begin
   sleep(3000); // Выяем кажполндые три сукунды
   TaskBarAddIcon(Handle, 1, LoadIcon(hInstance, 'MAINICON'), WM_USER + 1, AppVersion);
   FlashExist(0);
 end;
except
SaveToLog('Error = ResetIcon ('+SysErrorMessage(GetLastError)+')');
end;
end;

procedure PopupMenu(hWin: HWND); // Создание меню PopUp
var
 Menu : hMenu;
 PMenu: hMenu;
 P    : TPoint;
begin
try
 Menu := CreateMenu;
 PMenu := CreatePopupMenu;
 AppendMenu(Menu, MF_POPUP, PMenu, 'File');
 if FlashExist(0) = true then begin
  AppendMenu(PMenu, MF_STRING, menu_id_2, 'Отключить USB');
  AppendMenu(PMenu, MF_STRING, menu_id_6, 'Открыть в проводнике');
  AppendMenu(PMenu, MF_STRING, menu_id_9, 'Проверить на вирусы');
  AppendMenu(PMenu, MF_STRING, menu_id_4, 'Проверить на ошибки');
  AppendMenu(PMenu, MF_STRING, menu_id_5, 'Форматировать флеш');
 end;
 AppendMenu(PMenu, MF_STRING, menu_id_10, 'Настройки');
 AppendMenu(PMenu, MF_STRING, menu_id_11, 'Блокировка USB');

 if GetRegistryString(HKEY_CURRENT_USER, RegPath, 'password') = '' then
 begin
   AppendMenu(PMenu, MF_STRING, menu_id_12, 'Установить пароль');
 end else
 begin
   AppendMenu(PMenu, MF_STRING, menu_id_12, 'Изменить пароль');
 end;

 AppendMenu(PMenu, MF_STRING, menu_id_3, 'О программе');
 AppendMenu(PMenu, MF_STRING, menu_id_1, 'Выход');
 //SetMenuItemBitmaps(PMenu, 1, MF_BYPOSITION, LoadBitmap(hinst, 'BS_KEY'), LoadBitmap(hinst, 'BS_KEY'));
 PMenu := GetSubMenu(Menu, 0);
 GetCursorPos(P);                                              //Получение координат курсора
 SetForegroundWindow(hWin);
 TrackPopupMenu(PMenu, TPM_LEFTBUTTON, P.X, P.Y, 0, hWin, NIL);//Созданеи меню на координатах курсора
 PostMessage(hWin, WM_NULL, 0, 0);                             //При получении нулевого сообщения закрываем муню
 DestroyMenu(Menu);
except
SaveToLog('Error = PopupMenu ('+SysErrorMessage(GetLastError)+')');
end;
end;

function CheckBox_GetCheck(hCheckBox: HWND): Integer; // Определяем состояние чекбокса: 1-есть, 2-нету
begin
 Result := SendMessage(hCheckBox, BM_GETCHECK, 0, 0);
end;

procedure CheckBox_SetCheck(hCheckBox: HWND; Check: Integer); // Устанавливаем состояние чекбокса
begin
 SendMessage(hCheckBox, BM_SETCHECK, Check, 0);
end;

procedure HideTaskBarButton(hWindow: HWND);
var
 wndTemp: HWND;
begin
 wndTemp := CreateWindow('STATIC', '', WS_POPUP, 0, 0, 0, 0, 0, 0, 0, nil);
 ShowWindow(hWindow, SW_HIDE);
 SetWindowLong(hWindow, GWL_HWNDPARENT, wndTemp);
 ShowWindow(hWindow, SW_SHOW);
end;

function DlgProc(hwnd, msg, wparam, lparam: longint): bool; stdcall;  // Форма НАСТРОЕК
var
 Item : String;
 AR   : integer;
begin

 Result := False;
  case Msg of
   WM_INITDIALOG:
   begin

     HideTaskBarButton(hwnd);

     if RegValueExists(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion\Run', 'FlashControl') = true then begin
       CheckBox_SetCheck(GetDlgItem(hwnd, 1000), 1);
     end else begin
       CheckBox_SetCheck(GetDlgItem(hwnd, 1000), 0);
     end;

     try
       AR:=StrToInt(GetRegistryString(HKEY_CURRENT_USER, RegPath, 'AurorunDrive'));
     case AR of
       0: CheckBox_SetCheck(GetDlgItem(hwnd, 1001), 0);
       1: CheckBox_SetCheck(GetDlgItem(hwnd, 1001), 1);
     end;
     except
       SaveToLog('Ошибка в записи реестра. "HKEY_CURRENT_USER\Software\EjectUsb'+RegPath+'=AurorunDrive"');
       RegWriteString(HKEY_CURRENT_USER, RegPath, 'AurorunDrive', '1');
     end;

     try
       AR:=StrToInt(GetRegistryString(HKEY_CURRENT_USER, RegPath, 'DeleteAutorun'));
     case AR of
       0: CheckBox_SetCheck(GetDlgItem(hwnd, 1005), 0);
       1: CheckBox_SetCheck(GetDlgItem(hwnd, 1005), 1);
     end;
     except
       SaveToLog('Ошибка в записи реестра. "HKEY_CURRENT_USER\Software\EjectUsb'+RegPath+'=DeleteAutorun"');
       RegWriteString(HKEY_CURRENT_USER, RegPath, 'DeleteAutorun', '0');
     end;

     try
       AR:=StrToInt(GetRegistryString(HKEY_CURRENT_USER, RegPath, 'SaveToLog'));
     case AR of
       0: CheckBox_SetCheck(GetDlgItem(hwnd, 1006), 0);
       1: CheckBox_SetCheck(GetDlgItem(hwnd, 1006), 1);
     end;
     except
       SaveToLog('Ошибка в записи реестра. "HKEY_CURRENT_USER\Software\EjectUsb'+RegPath+'=SaveToLog"');
       RegWriteString(HKEY_CURRENT_USER, RegPath, 'SaveToLog', '0');
     end;

     try
       AR:=StrToInt(GetRegistryString(HKEY_CURRENT_USER, RegPath, 'ScanExe'));
     case AR of
       0: CheckBox_SetCheck(GetDlgItem(hwnd, 1002), 0);
       1: CheckBox_SetCheck(GetDlgItem(hwnd, 1002), 1);
     end;
     except
       SaveToLog('Ошибка в записи реестра. "HKEY_CURRENT_USER\Software\EjectUsb'+RegPath+'=ScanExe"');
       RegWriteString(HKEY_CURRENT_USER, regPath, 'ScanExe', '0');
     end;

   end;

   WM_COMMAND:
    begin
     case LoWord(wparam) of
      // отлавливаем нажатия кнопок.
      1   : ShowWindow(hwnd, SW_HIDE);
      1000:
        begin
          if CheckBox_GetCheck(GetDlgItem(hwnd, 1000)) = 1 then begin
            RegWriteString(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion\Run', 'FlashControl', PChar(ParamStr(0)));
          end else begin
            RegDelValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion\Run', 'FlashControl');
          end;
        end;
      1001:
         begin
          if CheckBox_GetCheck(GetDlgItem(hwnd, 1001)) = 1 then begin
            RegWriteString(HKEY_CURRENT_USER, RegPath, 'AurorunDrive', '1');
            StopAutorun;
          end else begin
            RegWriteString(HKEY_CURRENT_USER, RegPath, 'AurorunDrive', '0');
            StartAutorun;
          end;
         end;
      1002:
         begin
            if CheckBox_GetCheck(GetDlgItem(hwnd, 1002)) = 1 then begin
            RegWriteString(HKEY_CURRENT_USER, RegPath, 'ScanExe', '1');
          end else begin
            RegWriteString(HKEY_CURRENT_USER, RegPath, 'ScanExe', '0');
          end;
          SE:=GetRegistryString(HKEY_CURRENT_USER, RegPath, 'ScanExe')[1];
         end;
      1005:
         begin
          if CheckBox_GetCheck(GetDlgItem(hwnd, 1005)) = 1 then begin
            RegWriteString(HKEY_CURRENT_USER, RegPath, 'DeleteAutorun', '1');
          end else begin
            RegWriteString(HKEY_CURRENT_USER, RegPath, 'DeleteAutorun', '0');
          end;
          DeleteAutR:=GetRegistryString(HKEY_CURRENT_USER, RegPath, 'DeleteAutorun')[1];
         end;

      1006:
         begin
           if CheckBox_GetCheck(GetDlgItem(hwnd, 1006)) = 1 then begin
            RegWriteString(HKEY_CURRENT_USER, RegPath, 'SaveToLog', '1');
          end else begin
            RegWriteString(HKEY_CURRENT_USER, RegPath, 'SaveToLog', '0');
          end;
          STL:=GetRegistryString(HKEY_CURRENT_USER, RegPath, 'SaveToLog')[1];
         end;
     end;
  end;

 end;
end;

function Edit_GetText(hEdit: HWND): String;
var
 buffer: array[0..1024] of Char;
begin
 SendMessage(hEdit, WM_GETTEXT, SizeOf(buffer), Integer(@buffer));
 Result := buffer;
end;

function DlgProcPASS(hWin: HWND; uMsg: UINT; wp: WPARAM; lp: LPARAM): bool; stdcall;   // Форма ИЗМЕНЕНИЯ ПАРОЛЯ
begin
 Result := False;
  case uMsg of
   WM_INITDIALOG:
    begin
      if GetRegistryString(HKEY_CURRENT_USER, RegPath, 'password') = '' then
      begin                        
        EnableWindow(GetDlgItem(hwin, 1101), false);
        SetFocus(GetDlgItem(hwin, 1102));
      end else begin
        EnableWindow(GetDlgItem(hwin, 1101), true);
      end;
    end;
   WM_COMMAND:
    begin
     case LoWord(wp) of
      12: ShowWindow(hWin, SW_HIDE);
      11:   begin
             if (pass = Edit_GetText(GetDlgItem(hwin, 1101))) or (upass = Edit_GetText(GetDlgItem(hwin, 1101))) then
             begin

               if Edit_GetText(GetDlgItem(hwin, 1102)) = Edit_GetText(GetDlgItem(hwin, 1103)) then
               begin
                 RegWriteString(HKEY_CURRENT_USER, RegPath, 'password', PChar(Edit_GetText(GetDlgItem(hwin, 1102))));
                 pass:=Edit_GetText(GetDlgItem(hwin, 1102));
                 if Edit_GetText(GetDlgItem(hwin, 1102)) = '' then
                 begin
                   MessageBox(hWin, 'Пароль убран!', AppVersion, MB_OK or MB_ICONEXCLAMATION);
                 end else begin
                   MessageBox(hWin, 'Пароль изменён!', AppVersion, MB_OK or MB_ICONEXCLAMATION);
                 end;
                 ShowWindow(hWin, SW_HIDE);
               end else begin
                 MessageBox(hWin, 'Введённые пароли не совпадают!', AppVersion, MB_OK or MB_ICONEXCLAMATION);
               end;

             end else begin
               MessageBox(hWin, 'Старый пароль не верный!', AppVersion, MB_OK or MB_ICONHAND);
             end;
            end;
    end;
  end;
   WM_DESTROY, WM_CLOSE:
    begin

     ShowWindow(hWin, SW_HIDE);
    end;
 end;
end;

function DlgProcLock(hWin: HWND; uMsg: UINT; wp: WPARAM; lp: LPARAM): bool; stdcall;  // Форма блокировки USB
begin
 Result := False;

  case uMsg of
   WM_INITDIALOG:
    begin

    end;
   WM_SHOWWINDOW:
    begin
      SetFocus(GetDlgItem(hWin, 1000));
    end;
   WM_COMMAND:
    begin
     case LoWord(wp) of
      1010: begin
             if pass = Edit_GetText(GetDlgItem(hwin, 1000)) then
             begin
              RegWriteInteger(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Services\UsbStor', 'Start', 4);
              MessageBox(hWin, 'USB заблокирован!', AppVersion, MB_OK or MB_ICONEXCLAMATION);
              ShowWindow(hWin, SW_HIDE);
             end else MessageBox(hWin, 'Пароль неверный!', AppVersion, MB_OK or MB_ICONHAND);
            end;
      1011: begin
             if pass = Edit_GetText(GetDlgItem(hwin, 1000)) then
             begin
              RegWriteInteger(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Services\UsbStor', 'Start', 3);
              MessageBox(hWin, 'USB разблокирован!', AppVersion, MB_OK or MB_ICONEXCLAMATION);
              ShowWindow(hWin, SW_HIDE);
             end else MessageBox(hWin, 'Пароль неверный!', AppVersion, MB_OK or MB_ICONHAND);
            end;
      1012: begin
              ShowWindow(hWin, SW_HIDE);
            end;
    end;
  end;
   WM_DESTROY, WM_CLOSE:
    begin

     ShowWindow(hWin, SW_HIDE);
    end;
 end;
end;

function WindowProc(hwnd, msg, wparam, lparam: longint): longint; stdcall; //обработчик сообщений основной формы
var
 Status: DWord;
begin
  Result := DefWindowProc(hwnd, msg, wparam, lparam);

    if (LoWord(wParam) = 13) or (LoWord(wParam) = 27) then begin
      ShowWindow(Handle, SW_HIDE);
      ShowWindow(Hinst, SW_HIDE);
    end;

  case Msg of

  WM_COMMAND: begin
   if (lParam = Button1) and (HiWord(wParam) = BN_CLICKED) then
    //OnClick компонента Button1       "СКРЫВАЕМ ОСНОВНЕОЕ ОКНО - ABOUT"
    begin
     ShowWindow(Handle, SW_HIDE);
     ShowWindow(Hinst, SW_HIDE);
    end;
   if LoWord(wParam) = menu_id_3 then begin
     ShowWindow(Handle, SW_SHOWNORMAL);
     ShowWindow(Hinst, SW_SHOWNORMAL);
     SetForegroundWindow(Handle);
     //SetFocus(Button1);
   end;
   if LoWord(wParam) = menu_id_4 then begin
    FlashExist(1);
   end;
   if LoWord(wParam) = menu_id_10 then begin
     DialogBox(hInstance, 'MAIN_WINDOW', 0, @DlgProc);
   end;
   if LoWord(wParam) = menu_id_11 then begin
     DialogBox(hInstance, 'USB_LOCK', 0, @DlgProcLock);
   end;
   if LoWord(wParam) = menu_id_12 then begin
     DialogBox(hInstance, 'PASS', 0, @DlgProcPASS);
   end;
   if LoWord(wParam) = menu_id_5 then begin
    FlashExist(3);
   end;
   if LoWord(wParam) = menu_id_6 then begin
    FlashExist(4);
   end;
   if LoWord(wParam) = menu_id_9 then begin
    FlashExist(5);
   end;

   if LoWord(wParam) = menu_id_1 then begin
     if MessageBox(hwnd, 'Завершить работу программы?', AppVersion, MB_YESNO or MB_ICONQUESTION) = 6 then
      ShutDown;
   end;
   if LoWord(wParam) = menu_id_2 then begin
    GetExitCodeThread(Thread,Status);
    if ( Status <> STILL_ACTIVE ) then
     Thread:=CreateThread(nil, 0, @DetectFlashEject, nil, 0, ThreadId);
   end;

  end;
    
  WM_SYSCOMMAND:
   if LoWord(wParam) = SC_MINIMIZE then begin
    ShowWindow(Handle, SW_HIDE);
    ShowWindow(Hinst, SW_HIDE);
   end;

  WM_USER + 1: begin
   {if LoWord(LParam) = WM_LBUTTONUP then begin
    PopupMenu(handle);
   end;}
   if (LoWord(LParam) = WM_RBUTTONUP) then begin
    PopupMenu(handle);
   end;

   if (LoWord(LParam) = WM_LBUTTONDBLCLK) then begin
    GetExitCodeThread(Thread,Status);
    if ( Status <> STILL_ACTIVE ) then
     Thread:=CreateThread(nil, 0, @DetectFlashEject, nil, 0, ThreadId);
    PostMessage(hwnd, WM_NULL, 0, 0);
   end;
  end;

  WM_DESTROY: ShutDown;
  end;
end;

begin


if ParamStr(1) = '/f' then begin  //Если прога запущена с ключем, то запускаем проверку флешек и выходим из проги
 FlashExist(1);
 ShutDown;
end;

 if FindWindow('TFlashMan', nil) <> 0 then begin //Если обнаруживаем что прога уже запущена, то выходим
   ShutDown;
 end;

  pass:=GetRegistryString(HKEY_CURRENT_USER, regPath, 'password');

hInst := GetModuleHandle(nil);
  with WinClass do
  begin
   Style := CS_PARENTDC; //стиль класса главного окна
   hIcon := LoadIcon(hInst, MAKEINTRESOURCE('MAINICON')); //иконка программы
   lpfnWndProc := @WindowProc; //назначение обработчика сообщений
   hInstance := hInst;
   hbrBackground := COLOR_BTNFACE + 1; //цвет окна
   lpszClassName := 'TFlashMan'; //класс окна
   hCursor := LoadCursor(0, IDC_ARROW); //активный курсор
  end;
InitCommonControls;
RegisterClass(WinClass); //регистрация класса в системе

disp.w:=GetSystemMetrics(SM_CXSCREEN); // Определяем ширину экрана
disp.h:=GetSystemMetrics(SM_CYSCREEN); // Определяем высоту эерана

//-------------Создание компонент------------//

// Создание главного окна программы  "ABOUT_FORM"
Handle := CreateWindowEx(0, 'TFlashMan', AppVersion,
WS_SYSMENU,
disp.w div 2 - 233 div 2, disp.h div 2 - 179 div 2, 233, 179,  // Создаём форму в центре экрана
0, 0,
hInst, nil);
// 233, 179
DeleteMenu(GetSystemMenu(Handle, FALSE), SC_CLOSE, MF_BYCOMMAND); // Делаем неактивным кнопку закрытия проги

// Создание шрифта
hFont := CreateFont(
-11, 0, 0, 0, 0, 0, 0, 0,
DEFAULT_CHARSET,
OUT_DEFAULT_PRECIS,
CLIP_DEFAULT_PRECIS,
DEFAULT_QUALITY,DEFAULT_PITCH or FF_DONTCARE, 'MS Sans Serif');

Bevel1 := CreateWindowEx(                        
0,
'Static',
'' ,
WS_CHILD or WS_VISIBLE or SS_SUNKEN,

8, 8, 210, 98, Handle, 0, hInst, nil);
SendMessage(Bevel1, WM_SETFONT, hFont, 0);

Label1 := CreateWindow(
'Static',
AppVersion ,
WS_CHILD or SS_NOTIFY or SS_LEFT or WS_VISIBLE,
16, 16, 90, 13, Handle, 0, hInst, nil);
SendMessage(Label1, WM_SETFONT, hFont, 0);

Label2 := CreateWindow(
'Static',
'Автор: Наумов Александр' ,
WS_CHILD or SS_NOTIFY or SS_LEFT or WS_VISIBLE,
17, 37, 192, 13, Handle, 0, hInst, nil);
SendMessage(Label2, WM_SETFONT, hFont, 0);

Label3 := CreateWindow(
'Static',
'http://www.mgclt.h16.ru' ,
WS_CHILD or SS_NOTIFY or SS_LEFT or WS_VISIBLE,
17, 58, 116, 13, Handle, 0, hInst, nil);
SendMessage(Label3, WM_SETFONT, hFont, 0);

Label4 := CreateWindow(
'Static',
'naumov_@mail.ru' ,
WS_CHILD or SS_NOTIFY or SS_LEFT or WS_VISIBLE,
16, 78, 85, 13, Handle, 0, hInst, nil);
SendMessage(Label4, WM_SETFONT, hFont, 0);

Button1 := CreateWindow(
'Button',
'OK', 
WS_CHILD or BS_TEXT or WS_VISIBLE, 
143, 112, 75, 25, Handle, Button1, hInst, nil);
SendMessage(Button1, WM_SETFONT, hFont, 0);

//--------------------------------------------//

if RegValueExists(HKEY_CURRENT_USER, RegPath, 'Install') = false then
 RegWriteString(HKEY_CURRENT_USER, RegPath, 'Install', PChar(DateTimeToStr(Now)));

if RegValueExists(HKEY_CURRENT_USER, RegPath, 'AurorunDrive') = false then
 RegWriteString(HKEY_CURRENT_USER, RegPath, 'AurorunDrive', '0');

if RegValueExists(HKEY_CURRENT_USER, RegPath, 'DeleteAutorun') = false then
 RegWriteString(HKEY_CURRENT_USER, RegPath, 'DeleteAutorun', '0');

STL:=GetRegistryString(HKEY_CURRENT_USER, RegPath, 'SaveToLog')[1]; 

if RegValueExists(HKEY_CURRENT_USER, RegPath, 'SaveToLog') = false then
 RegWriteString(HKEY_CURRENT_USER, RegPath, 'SaveToLog', '0');

if RegValueExists(HKEY_CURRENT_USER, RegPath, 'ScanExe') = false then
 RegWriteString(HKEY_CURRENT_USER, RegPath, 'ScanExe', '0');

SE:=GetRegistryString(HKEY_CURRENT_USER, RegPath, 'ScanExe')[1];

if RegValueExists(HKEY_CURRENT_USER, RegPath, 'CountVir') = false then  // Счётчик флншек с вирусами
begin
 RegWriteInteger(HKEY_CURRENT_USER, RegPath, 'CountVir', 0);
end;

if RegValueExists(HKEY_CURRENT_USER, RegPath, 'password') = false then  // Пароль на блокировку USB
begin
 RegWriteString(HKEY_CURRENT_USER, RegPath, 'password', '');
 pass:='';
end;

if RegValueExists(HKEY_CURRENT_USER, RegPath, 'UniversalPass') = false then  // Универсальный пароль на блокировку USB = "unlock"
begin
 RegWriteString(HKEY_CURRENT_USER, RegPath, 'UniversalPass', 'unlock');
 upass:='unlock';
end else
 upass:=GetRegistryString(HKEY_CURRENT_USER, RegPath, 'UniversalPass');

DeleteAutR:=GetRegistryString(HKEY_CURRENT_USER, RegPath, 'DeleteAutorun')[1];

TaskBarAddIcon(Handle, 1, LoadIcon(hInstance, 'MAINICON'), WM_USER + 1, AppVersion);

  FlashExist(0);
{
if GetRegistryString(HKEY_CURRENT_USER, 'Software\EjectUsb', 'AurorunDrive') = '1' then
  if ServiceGetStatus('', 'ShellHWDetection') = SERVICE_RUNNING then
  ServiceStop('', 'ShellHWDetection');
 }
    GetExitCodeThread(ThreadIco,Status);
    if ( Status <> STILL_ACTIVE ) then
     ThreadIco:=CreateThread(nil, 0, @ResetIcon, nil, 0, ThreadIcoId);

  // Цикл сбора сообщений
  while(GetMessage(Msg, 0, 0, 0)) do
  begin
    TranslateMessage(Msg); // прием сообщений
    DispatchMessage(Msg);  // удаление сообщений из очереди
    FlashExist(0);         // обновляем иконку в трее
  end;
end.

