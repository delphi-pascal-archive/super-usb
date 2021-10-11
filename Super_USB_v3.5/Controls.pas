unit Lenin_Controls;

(***************************************)
(*  LENIN INC                          *)
(*  Online:  http://www.lenininc.com/  *)
(*  E-Mail:  lenin@zeos.net            *)
(*  Free for non commercial use.       *)
(***************************************)

interface

uses
  Windows, Messages, RichEdit, Lenin_Commctrl, Lenin_SysUtils, ShellAPI;

{ Window }
function SetNewFont(hWindow: HWND; FontSize, Weight: Integer; FontName: String): Boolean;
function EnableDlgItem(Dlg: HWND; ctrlID: Integer; bEnable: boolean): BOOL;
function Static_SetBitmap(hControl: HWND; ResId: Integer): Boolean;
function GetAssociatedIcon(FileName: String; IconIndex: Word): hIcon;
function GetAssociatedIconExt(const Extension: string; Small: Boolean): hIcon;

{ Menu }
function Menu_GetChecked(menu: HMENU; id: DWORD): Boolean;
procedure Menu_SetChecked(menu: HMENU; id: DWORD; check: Boolean);
function Menu_IsEnabled(menu: HMENU; id: DWORD): Boolean;
procedure Menu_SetEnabled(menu: HMENU; id: DWORD; enable: Boolean);

{ Edit }
//Определение текста в Edit
function Edit_GetText(hEdit: HWND): String;
//Установка текста в Edit
procedure Edit_SetText(hEdit: HWND; Text: String);
//Установка лимита текста
procedure Edit_SetLimitText(hEdit: HWND; Limit: Integer);
//Установка ввода пароля, маски пароля
procedure Edit_SetPassword(hEdit: HWND; Character: Char);
//Делаем компонент активным или не активным
function Edit_SetReadOnly(hEdit: HWND; ReadOnly: BOOL): Integer;


{ Resources }
//Установка значка на Button из ресурсов программы
//window style = BS_ICON
function Button_SetIcon(hButton: HWND; ResId, Width, Height: Integer): HWND;
//Установка картинки на Button из ресурсов программы
//window style = BS_BITMAP
function Button_SetBitmap(hButton: HWND; ResId, Width, Height: Integer): HWND;


{ CheckBox }
//Определяем состояние CheckBox
//0 = UnCheck; 1 = Check; 2 = Check and Grayed
function CheckBox_GetCheck(hCheckBox: HWND): Integer;
//Устанавливаем состояние CheckBox
//UnCheck = 0; Check = 1; Check and Grayed = 2
procedure CheckBox_SetCheck(hCheckBox: HWND; Check: Integer);

{ ListView }
//Получаем имя выбранного пункта ListView
function ListView_GetItemName(hListView: HWND): String;
//Разрешаем редактировать выбранный пункт ListView
procedure ListView_SetEditItem(hListView: HWND);
//Выбираем все файлы в ListView. Если fTurnSelection = True, уже отмеченные файлы не выбираем.
procedure ListView_SelectAllItems(hListView: HWND; fTurnSelection: boolean);

{ ListBox }
//Определение колличества пунктов в ListBox
function ListBox_GetItemCount(hListBox: HWND): Integer;
//Удаление определенного пункта в ListBox
procedure ListBox_DeleteItem(hListBox: HWND; Index: Integer);
//Удаление всех пунктов в ListBox
procedure ListBox_ClearItems(hListBox: HWND);
//Добавление пункта в ListBox
procedure ListBox_AddItem(hListBox: HWND; NewItem: String);
//Добавление пункта в определенное место в ListBox
procedure ListBox_InsertItem(hListBox: HWND; Index: Integer; NewItem: String);
//Определение имени выделеного пункта в ListBox
function ListBox_GetSelectedItem(hListBox: HWND): string;
//Определение номера выделеного пункта в ListBox
function ListBox_GetCountSelectedItem(hListBox: HWND): Integer;
//Определение имени пункта по номеру в ListBox
function ListBox_GetItem(hListBox: HWND; LbItem: Integer): string;
//Выделение всех пунктов в ListBox
procedure ListBox_SelAllItems(hListBox: HWND);
//Выбор пункта в ListBox
procedure ListBox_SelectedItem(hListBox: HWND; Index: Integer);

{ ComboBox }
//Определение колличества пунктов в ComboBox
function ComboBox_GetItemCount(hComboBox: HWND): Integer;
//Удаление определенного пункта в ComboBox
procedure ComboBox_DeleteItem(hComboBox: HWND; Index: Integer);
//Удаление всех пунктов в ComboBox
procedure ComboBox_ClearItems(hComboBox: HWND);
//Добавление пункта в ComboBox
procedure ComboBox_AddItem(hComboBox: HWND; NewItem: String);
//Добавление пункта в определенное место в ComboBox
procedure ComboBox_InsertItem(hComboBox: HWND; Index: Integer; NewItem: String);
//Определение имени выбранного пункта в ComboBox
function ComboBox_GetSelectedItem(hComboBox: HWND): string;
//Определение номера выбранного пункта в ComboBox
function ComboBox_GetCountSelectedItem(hComboBox: HWND): Integer;
//Определение имени пункта по номеру в ComboBox
function ComboBox_GetItem(hComboBox: HWND; LbItem: Integer): string;
//Выбор пункта в ComboBox по счету
procedure ComboBox_SelectedItem(hComboBox: HWND; Index: Integer);
//Выбор пункта в ComboBox по имени
procedure ComboBox_SelectedString(hComboBox: HWND; Text: String);
//Открытие пунктов ComboBox
procedure ComboBox_OpenItems(hComboBox: HWND);

{ Hot-Key }
procedure HotKey_SetHotKey(hHotKey: HWND; bVKHotKey: wParam; bfMods: lParam);
function HotKey_GetHotKey(hHotKey: HWND): WORD;
procedure HotKey_SetRules(hHotKey: HWND; fwCombInv: wParam; fwModInv: lParam);

{ Progress Bar }
//Установка минимальной и максимальной позиции ProgressBar
function Progress_SetRange(hProgress: HWND; nMinRange: wParam; nMaxRange: lParam): DWORD;
//Устанавливаем позицию ProgressBar
function Progress_SetPos(hProgress: HWND; nNewPos: wParam): Integer;
//Получаем позицию ProgressBar
function Progress_GetPos(hProgress: HWND): Integer;
function Progress_DeltaPos(hProgress: HWND; nIncrement: wParam): Integer;
//Установка шага продвижения ProgressBar
function Progress_SetStep(hProgress: HWND; nStepInc: wParam): Integer;
function Progress_StepIt(hProgress: HWND): Integer;
procedure Progress_SetLineColor(hProgress: HWND; Color: tCOLORREF);
procedure Progress_SetBarColor(hProgress: HWND; Color: tCOLORREF);

{ Rich Edit }
function RichEdit_Enable(hRichEdit: HWND; fEnable: Bool): BOOL;
function RichEdit_GetText(hRichEdit: HWND): String;
function RichEdit_GetTextLength(hRichEdit: HWND): Integer;
function RichEdit_SetText(hRichEdit: HWND; lpsz: PChar): BOOL;
procedure RichEdit_LimitText(hRichEdit: HWND; cchMax: wParam);
function RichEdit_GetLineCount(hRichEdit: HWND): Integer;
function RichEdit_GetLine(hRichEdit: HWND; line: wParam; lpch: LPCSTR): Integer;
procedure RichEdit_GetRect(hRichEdit: HWND; lprc: tRECT);
procedure RichEdit_SetRect(hRichEdit: HWND; lprc: tRECT);
function RichEdit_GetSel(hRichEdit: HWND): DWORD;
procedure RichEdit_SetSel(hRichEdit: HWND; ichStart, ichEnd: Integer);
procedure RichEdit_ReplaceSel(hRichEdit: HWND; lpszReplace: LPCSTR);
function RichEdit_GetModify(hRichEdit: HWND): BOOL;
procedure RichEdit_SetModify(hRichEdit: HWND; fModified: UINT);
function RichEdit_ScrollCaret(hRichEdit: HWND): BOOL;
function RichEdit_LineFromChar(hRichEdit: HWND; ich: Integer): Integer;
function RichEdit_LineIndex(hRichEdit: HWND; line: Integer): Integer;
function RichEdit_LineLength(hRichEdit: HWND; line: Integer): Integer;
procedure RichEdit_Scroll(hRichEdit: HWND; dv: wParam; dh: lParam);
function RichEdit_CanUndo(hRichEdit: HWND): BOOL;
function RichEdit_Undo(hRichEdit: HWND): BOOL;
procedure RichEdit_EmptyUndoBuffer(hRichEdit: HWND);
function RichEdit_GetFirstVisibleLine(hRichEdit: HWND): Integer;
function RichEdit_SetReadOnly(hRichEdit: HWND; fReadOnly: Boolean): BOOL;
procedure RichEdit_SetWordBreakProc(hRichEdit: HWND; lpfnWordBreak: Pointer);
function RichEdit_GetWordBreakProc(hRichEdit: HWND): Pointer;
function RichEdit_CanPaste(hRichEdit: HWND; uFormat: UINT): BOOL;
function RichEdit_CharFromPos(hRichEdit: HWND; x, y: Integer): DWORD;
function RichEdit_DisplayBand(hRichEdit: HWND; lprc: tRECT): BOOL;
procedure RichEdit_ExGetSel(hRichEdit: HWND; lpchr: TCharRange);
procedure RichEdit_ExLimitText(hRichEdit: HWND; cchTextMax: Dword);
function RichEdit_ExLineFromChar(hRichEdit: HWND; ichCharPos: Dword): Integer;
function RichEdit_ExSetSel(hRichEdit: HWND; ichCharRange: TCharRange): Integer;
function RichEdit_FindText(hRichEdit: HWND; fuFlags: UINT; lpFindText: tFINDTEXT): Integer;
function RichEdit_FindTextEx(hRichEdit: HWND; fuFlags: UINT; lpFindText: tFINDTEXT): Integer;
function RichEdit_FindWordBreak(hRichEdit: HWND; code: UINT; ichStart: Dword): Integer;
function RichEdit_FormatRange(hRichEdit: HWND; fRender: Boolean; lpFmt: tFORMATRANGE): Integer;
function RichEdit_GetCharFormat(hRichEdit: HWND; fSelection: Boolean; lpFmt: tCHARFORMAT): DWORD;
function RichEdit_GetEventMask(hRichEdit: HWND): DWORD;
function RichEdit_GetLimitText(hRichEdit: HWND): Integer;
function RichEdit_GetOleInterface(hRichEdit: HWND; ppObject: lParam): BOOL;
function RichEdit_GetOptions(hRichEdit: HWND): UINT;
function RichEdit_GetParaFormat(hRichEdit: HWND; lpFmt: tPARAFORMAT): DWORD;
function RichEdit_GetSelText(hRichEdit: HWND; lpBuf: LPSTR): Integer;
function RichEdit_GetTextRange(hRichEdit: HWND; lpRange: tTEXTRANGE): Integer;
function RichEdit_GetWordBreakProcEx(hRichEdit: HWND): Integer;
procedure RichEdit_HideSelection(hRichEdit: HWND; fHide: Boolean; fChangeStyle: Boolean);
procedure RichEdit_PasteSpecial(hRichEdit: HWND; uFormat: UINT);
function RichEdit_PosFromChar(hRichEdit: HWND; wCharIndex: wParam): DWORD;
procedure RichEdit_RequestResize(hRichEdit: HWND);
function RichEdit_SelectionType(hRichEdit: HWND): Integer;
function RichEdit_SetBkgndColor(hRichEdit: HWND; fUseSysColor: Boolean; clr: tCOLORREF): tCOLORREF;
function RichEdit_SetCharFormat(hRichEdit: HWND; uFlags: UINT; lpFmt: tCHARFORMAT): BOOL;
function RichEdit_SetEventMask(hRichEdit: HWND; dwMask: Dword): DWORD;
function RichEdit_SetOleCallback(hRichEdit: HWND; lpObj: lParam): BOOL;
function RichEdit_SetOptions(hRichEdit: HWND; fOperation: UINT; fOptions: UINT): UINT;
function RichEdit_SetParaFormat(hRichEdit: HWND; lpFmt: tPARAFORMAT): BOOL;
function RichEdit_SetTargetDevice(hRichEdit: HWND; hdcTarget: HDC; cxLineWidth: Integer): BOOL;
function RichEdit_SetWordBreakProcEx(hRichEdit: HWND; pfnWordBreakProcEx: Integer): Integer;
function RichEdit_StreamIn(hRichEdit: HWND; uFormat: UINT; lpStream: tEDITSTREAM): Integer;
function RichEdit_StreamOut(hRichEdit: HWND; uFormat: UINT; lpStream: tEDITSTREAM): Integer;

{ Status Bar }
function Status_GetBorders(hStatus: HWND; aBorders: lParam): BOOL;
function Status_GetParts(hStatus: HWND; nParts: wParam; aRightCoord: lParam): Integer;
function Status_GetRect(hStatus: HWND; iPart: wParam; lprc: lParam): BOOL;
function Status_GetText(hStatus: HWND; iPart: wParam): String;
function Status_GetTextLength(hStatus: HWND; iPart: wParam): DWORD;
procedure Status_SetMinHeight(hStatus: HWND; minHeight: wParam);
function Status_SetParts(hStatus: HWND; nParts: wParam; aWidths: lParam): BOOL;
function Status_SetText(hStatus: HWND; iPart: wParam; szText: LPSTR): BOOL;
function Status_Simple(hStatus: HWND; fSimple: Boolean): BOOL;

{ Tool Bar }
function ToolBar_AddBitmap(hToolBar: HWND; nButtons: wParam; lptbab: tTBADDBITMAP): Integer;
function ToolBar_AddButtons(hToolBar: HWND; uNumButtons: UINT; lpButtons: tTBBUTTON): BOOL;
function ToolBar_AddString(hToolBar: HWND; hst: HInst; idString: Word): Integer;
procedure ToolBar_AutoSize(hToolBar: HWND);
function ToolBar_ButtonCount(hToolBar: HWND): Integer;
procedure ToolBar_ButtonStructSize(hToolBar: HWND);
function ToolBar_ChangeBitmap(hToolBar: HWND; idButton: wParam; iBitmap: lParam): BOOL;
function ToolBar_CheckButton(hToolBar: HWND; idButton: wParam; fCheck: lParam): BOOL;
function ToolBar_CommandToIndex(hToolBar: HWND; idButton: wParam): Integer;
procedure ToolBar_Customize(hToolBar: HWND);
function ToolBar_DeleteButton(hToolBar: HWND; idButton: wParam): BOOL;
function ToolBar_EnableButton(hToolBar: HWND; idButton: wParam; fEnable: lParam): BOOL;
function ToolBar_GetBitmap(hToolBar: HWND; idButton: wParam): Integer;
function ToolBar_GetBitmapFlags(hToolBar: HWND): Integer;
function ToolBar_GetButton(hToolBar: HWND; idButton: wParam; lpButton: tTBBUTTON): BOOL;
function ToolBar_GetButtonText(hToolBar: HWND; idButton: wParam; lpszText: LPSTR): Integer;
function ToolBar_GetItemRect(hToolBar: HWND; idButton: wParam; lprc: tRECT): BOOL;
function ToolBar_GetRows(hToolBar: HWND): Integer;
function ToolBar_GetState(hToolBar: HWND; idButton: wParam): Integer;
function ToolBar_GetToolTips(hToolBar: HWND): HWND;
function ToolBar_HideButton(hToolBar: HWND; idButton: wParam; fShow: lParam): BOOL;
function ToolBar_Indeterminate(hToolBar: HWND; idButton: wParam; fIndeterminate: lParam): BOOL;
function ToolBar_InsertButton(hToolBar: HWND; idButton: wParam; lpButton: tTBBUTTON): BOOL;
function ToolBar_IsButtonChecked(hToolBar: HWND; idButton: wParam): Integer;
function ToolBar_IsButtonEnabled(hToolBar: HWND; idButton: wParam): Integer;
function ToolBar_IsButtonHidden(hToolBar: HWND; idButton: wParam): Integer;
function ToolBar_IsButtonIndeterminate(hToolBar: HWND; idButton: wParam): Integer;
function ToolBar_IsButtonPressed(hToolBar: HWND; idButton: wParam): Integer;
function ToolBar_PressButton(hToolBar: HWND; idButton: wParam; fPress: lParam): BOOL;
procedure ToolBar_SaveRestore(hToolBar: HWND; fSave: Boolean; ptbsp: tTBSAVEPARAMS);
function ToolBar_SetBitmapSize(hToolBar: HWND; dxBitmap, dyBitmap: Integer): BOOL;
function ToolBar_SetButtonSize(hToolBar: HWND; dxBitmap, dyBitmap: Integer): BOOL;
function ToolBar_SetCmdID(hToolBar: HWND; index, cmdId: UINT): BOOL;
procedure ToolBar_SetParent(hToolBar: HWND; hwndParent: HWND);
procedure ToolBar_SetRows(hToolBar: HWND; cRows: Integer; fLarger: Boolean; lprc: TRECT);
function ToolBar_SetState(hToolBar: HWND; idButton: wParam; fState: lParam): BOOL;
procedure ToolBar_SetToolTips(hToolBar: HWND; hwndToolTip: HWND);

{ Tool Tip }
procedure ToolTip_Activate(hToolTip: HWND; fActivate: Boolean);
function ToolTip_AddTool(hToolTip: HWND; lpti: pTOOLINFO): BOOL;
procedure ToolTip_DelTool(hToolTip: HWND; lpti: pTOOLINFO);
function ToolTip_EnumTools(hToolTip: HWND; iTool: wParam; lpti: pTOOLINFO): BOOL;
function ToolTip_GetCurrentTool(hToolTip: HWND; lpti: pTOOLINFO): BOOL;
procedure ToolTip_GetText(hToolTip: HWND; lpti: pTOOLINFO);
function ToolTip_GetToolCount(hToolTip: HWND): Integer;
function ToolTip_GetToolInfo(hToolTip: HWND; lpti: pTOOLINFO): BOOL;
function ToolTip_HitText(hToolTip: HWND; lphti: pTTHITTESTINFO): BOOL;
procedure ToolTip_NewToolRect(hToolTip: HWND; lpti: pTOOLINFO);
procedure ToolTip_RelayEvent(hToolTip: HWND; lpmsg: pMSG);
procedure ToolTip_SetDelayTime(hToolTip: HWND; uFlag: wParam; iDelay: lParam);
procedure ToolTip_SetToolInfo(hToolTip: HWND; lpti: pTOOLINFO);
procedure ToolTip_UpdateTipText(hToolTip: HWND; lpti: pTOOLINFO);
function ToolTip_WindowFromPoint(hToolTip: HWND; lppt: pPOINT): HWND;

{ Track Bar }
procedure TrackBar_ClearSel(hTrackBar: HWND; fRedraw: Boolean);
procedure TrackBar_ClearTics(hTrackBar: HWND; fRedraw: Boolean);
procedure TrackBar_GetChannelRect(hTrackBar: HWND; lprc: tRECT);
function TrackBar_GetLineSize(hTrackBar: HWND): Integer;
function TrackBar_GetNumTics(hTrackBar: HWND): Integer;
function TrackBar_GetPageSize(hTrackBar: HWND): Integer;
function TrackBar_GetPos(hTrackBar: HWND): Integer;
function TrackBar_GetPTics(hTrackBar: HWND): Integer;
function TrackBar_GetRangeMax(hTrackBar: HWND): Integer;
function TrackBar_GetRangeMin(hTrackBar: HWND): Integer;
function TrackBar_GetSelEnd(hTrackBar: HWND): Integer;
function TrackBar_GetSelStart(hTrackBar: HWND): Integer;
function TrackBar_GetThumbLength(hTrackBar: HWND): UINT;
procedure TrackBar_GetThumbRect(hTrackBar: HWND; lprc: tRECT);
function TrackBar_GetTic(hTrackBar: HWND; iTic: wParam): Integer;
function TrackBar_GetTicPos(hTrackBar: HWND; iTic: wParam): Integer;
function TrackBar_SetLineSize(hTrackBar: HWND; lLineSize: lParam): Integer;
function TrackBar_SetPageSize(hTrackBar: HWND; lPageSize: lParam): Integer;
procedure TrackBar_SetPos(hTrackBar: HWND; bPosition: Boolean; lPosition: Integer);
procedure TrackBar_SetRange(hTrackBar: HWND; bRedraw: Boolean; lMinimum, lMaximum: Integer);
procedure TrackBar_SetRangeMax(hTrackBar: HWND; bRedraw: Boolean; lMaximum: Integer);
procedure TrackBar_SetRangeMin(hTrackBar: HWND; bRedraw: Boolean; lMinimum: Integer);
procedure TrackBar_SetSel(hTrackBar: HWND; bRedraw: Boolean; lMinimum, lMaximum: Integer);
procedure TrackBar_SetSelEnd(hTrackBar: HWND; bRedraw: Boolean; lEnd: lParam);
procedure TrackBar_SetSelStart(hTrackBar: HWND; bRedraw: Boolean; lStart: lParam);
procedure TrackBar_SetThumbLength(hTrackBar: HWND; iLength: UINT);
function TrackBar_SetTic(hTrackBar: HWND; lPosition: Integer): BOOL;
procedure TrackBar_SetTicFreq(hTrackBar: HWND; wFreq: wParam; lPosition: Integer);

{ Up-Down}
function UpDown_CreateControl(hWin, hControl: HWND; ID, Min, Max, Value: Integer): HWND;
function UpDown_GetAccel(hUpDown: HWND; wAccels: WParam; lAccels: LParam): Integer;
function UpDown_GetBase(hUpDown: HWND): Integer;
function UpDown_GetBuddy(hUpDown: HWND): HWND;
function UpDown_GetPos(hUpDown: HWND): DWORD;
function UpDown_GetRange(hUpDown: HWND): DWORD;
function UpDown_SetAccel(hUpDown: HWND; wAccels: WParam; lAccels: LParam): BOOL;
function UpDown_SetBase(hUpDown: HWND; wBase: WParam): Integer;
function UpDown_SetBuddy(hUpDown, hBuddy: HWND): HWND;
function UpDown_SetPos(hUpDown: HWND; nPos: LParam): short;
//Установка минимальной и максимальной позиции UpDown
function UpDown_SetRange(hUpDown: HWND; nUpper, nLower: short): short;

implementation

//-------------------------------------------------------------------
// Menu Helper Macros
//-------------------------------------------------------------------
function Menu_GetChecked(menu: HMENU; id: DWORD): Boolean;
begin
 Result := (GetMenuState(menu, id, MF_BYCOMMAND) and MF_CHECKED) = MF_CHECKED;
end;

procedure Menu_SetChecked(menu: HMENU; id: DWORD; check: Boolean);
begin
 case check of
  True: CheckMenuItem(menu, id, MF_BYCOMMAND or MF_CHECKED);
  else CheckMenuItem(menu, id, MF_BYCOMMAND or MF_UNCHECKED);
 end;
end;

function Menu_IsEnabled(menu: HMENU; id: DWORD): Boolean;
begin
 result := (GetMenuState(menu, id, MF_BYCOMMAND) and MF_ENABLED) = MF_ENABLED;
end;

procedure Menu_SetEnabled(menu: HMENU; id: DWORD; enable: Boolean);
var
 mii: TMENUITEMINFO;
begin
 mii.cbSize := sizeof(mii);
 mii.fMask := MIIM_STATE;
 GetMenuItemInfo(menu, id, False, mii);
  case enable of
   True: mii.fState := mii.fState and (not MFS_DISABLED);
  else mii.fState := mii.fState or (MFS_DISABLED);
 end;
  mii.fMask := MIIM_STATE;
  SetMenuItemInfo(menu, id, False, mii);
end;

//-------------------------------------------------------------------
// Other Helper Macros
//-------------------------------------------------------------------
function GetAssociatedIconExt(const Extension: string; Small: Boolean): hIcon;
var
 Info: TSHFileInfo;
 Flags: Cardinal;
begin
 if Small
  then Flags := SHGFI_ICON or SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES
  else Flags := SHGFI_ICON or SHGFI_LARGEICON or SHGFI_USEFILEATTRIBUTES;
 SHGetFileInfo(PChar(Extension), FILE_ATTRIBUTE_NORMAL, Info, SizeOf(TSHFileInfo), Flags);
 Result := Info.hIcon;
end;

function GetAssociatedIcon(FileName: String; IconIndex: Word): hIcon;
begin
 Result := ExtractAssociatedIcon(HInstance, PChar(FileName), IconIndex);
end;

function Static_SetBitmap(hControl: HWND; ResId: Integer): Boolean;
var
 hBmp: hBitmap;
begin
 hBmp := LoadBitmap(hInstance, MAKEINTRESOURCE(ResId));
 Result := BOOL(SendMessage(hControl, STM_SETIMAGE, IMAGE_BITMAP, hBmp));
end;

function SetNewFont(hWindow: HWND; FontSize, Weight: Integer; FontName: String): Boolean;
var
 Fnt: hFont;
 DC: HDC;
begin
 DC := GetWindowDC(hWindow);
 Fnt := CreateFont(-MulDiv(FontSize, GetDeviceCaps(DC, LOGPIXELSY),
        72), 0, 0, 0, Weight, 0, 0, 0, ANSI_CHARSET or RUSSIAN_CHARSET,
        OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, PROOF_QUALITY,
        FIXED_PITCH or FF_MODERN, PChar(FontName));
 Result := BOOL(SendMessage(hWindow, WM_SETFONT, Fnt, Ord(True)));
end;

function EnableDlgItem(Dlg: HWND; ctrlID: Integer; bEnable: boolean): BOOL;
begin
 Result := EnableWindow(GetDlgItem(Dlg, ctrlID), bEnable);
end;

//-------------------------------------------------------------------
// Edit Helper Macros
//-------------------------------------------------------------------
//Определение текста в Edit
function Edit_GetText(hEdit: HWND): String;
var
 buffer: array[0..1024] of Char;
begin
 SendMessage(hEdit, WM_GETTEXT, SizeOf(buffer), Integer(@buffer));
 Result := buffer;
end;

//Установка текста в Edit
procedure Edit_SetText(hEdit: HWND; Text: String);
begin
 SendMessage(hEdit, WM_SETTEXT, 0, Integer(PChar(@Text[1])));
end;

procedure Edit_SetLimitText(hEdit: HWND; Limit: Integer);
begin
 SendMessage(hEdit, EM_SETLIMITTEXT, Limit, 0);
end;

procedure Edit_SetPassword(hEdit: HWND; Character: Char);
begin
 SendMessage(hEdit, EM_SETPASSWORDCHAR, Integer(Character), 0);
end;

function Edit_SetReadOnly(hEdit: HWND; ReadOnly: BOOL): Integer;
begin
 Result := SendMessage(hEdit, EM_SETREADONLY, Integer(ReadOnly), 0);
end;

//-------------------------------------------------------------------
// Resources Helper Macros
//-------------------------------------------------------------------
//Установка значка на Button из ресурсов программы
//window style = BS_ICON
function Button_SetIcon(hButton: HWND; ResId, Width, Height: Integer): HWND;
var
 Ico: hIcon;
begin
 Ico := LoadImage(hInstance, MAKEINTRESOURCE(ResId), IMAGE_ICON, Width, Height, LR_DEFAULTCOLOR);
 Result := SendMessage(hButton, BM_SETIMAGE, IMAGE_ICON, Ico);
end;

//Установка картинки на Button из ресурсов программы
//window style = BS_BITMAP
function Button_SetBitmap(hButton: HWND; ResId, Width, Height: Integer): HWND;
var
 Bmp: hBitmap;
begin
 Bmp := LoadImage(hInstance, MAKEINTRESOURCE(ResId), IMAGE_BITMAP, Width, Height, LR_DEFAULTCOLOR);
 Result := SendMessage(hButton, BM_SETIMAGE, IMAGE_BITMAP, Bmp);
end;

//-------------------------------------------------------------------
// CheckBox Helper Macros
//-------------------------------------------------------------------
//Определяем состояние CheckBox
//0 = UnCheck; 1 = Check; 2 = Check and Grayed
function CheckBox_GetCheck(hCheckBox: HWND): Integer;
begin
 Result := SendMessage(hCheckBox, BM_GETCHECK, 0, 0);
end;

//Устанавливаем состояние CheckBox
//UnCheck = 0; Check = 1; Check and Grayed = 2
procedure CheckBox_SetCheck(hCheckBox: HWND; Check: Integer);
begin
 SendMessage(hCheckBox, BM_SETCHECK, Check, 0);
end;

//-------------------------------------------------------------------
// ListView Helper Macros
//-------------------------------------------------------------------
//Получаем имя выбранного пункта ListView
function ListView_GetItemName(hListView: HWND): String;
var
 buf: array [0..MAX_PATH] of char;
 i: Integer;
begin
 i := ListView_GetNextItem(hListView, -1, LVNI_FOCUSED);
  if (i > -1) then begin
   ZeroMemory(@buf, sizeof(buf));
   ListView_GetItemText(hListView, i, 0, buf, sizeof(buf));
    if buf[0] <> #0 then Result := buf;
  end;
end;

//Разрешаем редактировать выбранный пункт ListView
procedure ListView_SetEditItem(hListView: HWND);
var
 i: Integer;
begin
 i := ListView_GetNextItem(hListView, -1, LVNI_FOCUSED);
  if (i > -1) then begin
   SetFocus(hListView);
   ListView_EditLabel(hListView, i);
  end;
end;

//Выбираем все файлы в ListView. Если fTurnSelection = True, уже отмеченные файлы не выбираем.
procedure ListView_SelectAllItems(hListView: HWND; fTurnSelection: boolean);
const
 fStateState : array [boolean] of cardinal = (0, LVIS_SELECTED);
var
 i: integer;
 uRes: UINT;
begin
 for i := 0 to ListView_GetItemCount(hListView) - 1 do begin
  uRes := ListView_GetItemState(hListView, i, LVIS_SELECTED);
  ListView_SetItemState(hListView, i, fStateState[(uRes and LVIS_SELECTED = 0) or not fTurnSelection], LVIS_SELECTED);
 end;
end;

//-------------------------------------------------------------------
// ListBox Helper Macros
//-------------------------------------------------------------------
//Определение колличества пунктов в ListBox
function ListBox_GetItemCount(hListBox: HWND): Integer;
begin
 Result := SendMessage(hListBox, LB_GETCOUNT, 0, 0);
end;

//Удаление определенного пункта в ListBox
procedure ListBox_DeleteItem(hListBox: HWND; Index: Integer);
begin
 SendMessage(hListBox, LB_DELETESTRING, Index, 0);
end;

//Удаление всех пунктов в ListBox
procedure ListBox_ClearItems(hListBox: HWND);
begin
 SendMessage(hListBox, LB_RESETCONTENT, 0, 0);
end;

//Добавление пункта в ListBox
procedure ListBox_AddItem(hListBox: HWND; NewItem: String);
begin
 SendMessage(hListBox, LB_ADDSTRING, 0, Integer(NewItem));
end;

//Добавление пункта в определенное место в ListBox
procedure ListBox_InsertItem(hListBox: HWND; Index: Integer; NewItem: String);
begin
 SendMessage(hListBox, LB_INSERTSTRING, Index, Integer(NewItem));
end;

//Определение имени выделеного пункта в ListBox
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

//Определение номера выделеного пункта в ListBox
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

//Определение имени пункта по номеру в ListBox
function ListBox_GetItem(hListBox: HWND; LbItem: Integer): string;
var
 l: Integer;
 buffer: PChar;
begin
 l := SendMessage(hListBox, LB_GETTEXTLEN, LbItem, 0);
 GetMem(buffer, l + 1);
 SendMessage(hListBox, LB_GETTEXT, LbItem, Integer(buffer));
 Result := StrPas(buffer);
 FreeMem(buffer);
end;

//Выделение всех пунктов в ListBox
procedure ListBox_SelAllItems(hListBox: HWND);
var
 CountItems, i: Integer;
begin
 CountItems := SendMessage(hListBox, LB_GETCOUNT, 0, 0);
  if CountItems = 0 then exit;
  for i := 0 to CountItems do
   SendMessage(hListBox, LB_SETSEL, Integer(true), i);
end;

//Выбор пункта
procedure ListBox_SelectedItem(hListBox: HWND; Index: Integer);
begin
 SendMessage(hListBox, LB_SETCURSEL, Index, 0);
end;

//-------------------------------------------------------------------
// ComboBox Helper Macros
//-------------------------------------------------------------------
//Определение колличества пунктов в ComboBox
function ComboBox_GetItemCount(hComboBox: HWND): Integer;
begin
 Result := SendMessage(hComboBox, CB_GETCOUNT, 0, 0);
end;

//Удаление определенного пункта в ComboBox
procedure ComboBox_DeleteItem(hComboBox: HWND; Index: Integer);
begin
 SendMessage(hComboBox, CB_DELETESTRING, Index, 0);
end;

//Удаление всех пунктов в ComboBox
procedure ComboBox_ClearItems(hComboBox: HWND);
begin
 SendMessage(hComboBox, CB_RESETCONTENT, 0, 0);
end;

//Добавление пункта в ComboBox
procedure ComboBox_AddItem(hComboBox: HWND; NewItem: String);
begin
 SendMessage(hComboBox, CB_ADDSTRING, 0, Integer(NewItem));
end;

//Добавление пункта в определенное место в ComboBox
procedure ComboBox_InsertItem(hComboBox: HWND; Index: Integer; NewItem: String);
begin
 SendMessage(hComboBox, CB_INSERTSTRING, Index, Integer(NewItem));
end;

//Определение имени выбранного пункта в ComboBox
function ComboBox_GetSelectedItem(hComboBox: HWND): string;
var
 Index, len: Integer;
 s: string;
 buffer: PChar;
begin
 Index := SendMessage(hComboBox, CB_GETCURSEL, 0, 0);
 len := SendMessage(hComboBox, CB_GETLBTEXTLEN, wParam(Index), 0);
 GetMem(buffer, len + 1);
 SendMessage(hComboBox, CB_GETLBTEXT, wParam(Index), lParam(buffer));
 SetString(s, buffer, len);
 FreeMem(buffer);
 Result := s;
end;

//Определение номера выбранного пункта в ComboBox
function ComboBox_GetCountSelectedItem(hComboBox: HWND): Integer;
var
 Index, len: Integer;
 s: string;
 buffer: PChar;
begin
 Index := SendMessage(hComboBox, CB_GETCURSEL, 0, 0);
 len := SendMessage(hComboBox, CB_GETLBTEXTLEN, wParam(Index), 0);
 GetMem(buffer, len + 1);
 SendMessage(hComboBox, CB_GETLBTEXT, wParam(Index), lParam(buffer));
 SetString(s, buffer, len);
 FreeMem(buffer);
 Result := Index;
end;

//Определение имени пункта по номеру в ComboBox
function ComboBox_GetItem(hComboBox: HWND; LbItem: Integer): string;
var
 l: Integer;
 buffer: PChar;
begin
 l := SendMessage(hComboBox, CB_GETLBTEXTLEN, LbItem, 0);
 GetMem(buffer, l + 1);
 SendMessage(hComboBox, CB_GETLBTEXT, LbItem, Integer(buffer));
 Result := StrPas(buffer);
 FreeMem(buffer);
end;

//Выбор пункта в ComboBox по счету
procedure ComboBox_SelectedItem(hComboBox: HWND; Index: Integer);
begin
 SendMessage(hComboBox, CB_SETCURSEL, Index, 0);
end;

//Выбор пункта в ComboBox по имени
procedure ComboBox_SelectedString(hComboBox: HWND; Text: String);
begin
 SendMessage(hComboBox, CB_SELECTSTRING, 0, Integer(Text));
end;

//Открытие пунктов ComboBox
procedure ComboBox_OpenItems(hComboBox: HWND);
begin
 SendMessage(hComboBox, CB_SHOWDROPDOWN, Integer(True), 0);
end;

//-------------------------------------------------------------------
// Hot-Key Helper Macros
//-------------------------------------------------------------------
procedure HotKey_SetHotKey(hHotKey: HWND; bVKHotKey: wParam; bfMods: lParam);
begin
 SendMessage(hHotKey, HKM_SETHOTKEY, MAKEWORD(bVKHotKey, bfMods), 0);
end;

function HotKey_GetHotKey(hHotKey: HWND): WORD;
begin
 Result := SendMessage(hHotKey, HKM_GETHOTKEY, 0, 0);
end;

procedure HotKey_SetRules(hHotKey: HWND; fwCombInv: wParam; fwModInv: lParam);
begin
 SendMessage(hHotKey, HKM_SETRULES, fwCombInv, MAKELPARAM(fwModInv, 0));
end;

//-------------------------------------------------------------------
// Progress Bar Helper Macros
//-------------------------------------------------------------------
//Установка минимальной и максимальной позиции ProgressBar
function Progress_SetRange(hProgress: HWND; nMinRange: wParam; nMaxRange: lParam): DWORD;
begin
 Result := SendMessage(hProgress, PBM_SETRANGE, 0, MAKELPARAM(nMinRange, nMaxRange));
end;

//Устанавливаем позицию ProgressBar
function Progress_SetPos(hProgress: HWND; nNewPos: wParam): Integer;
begin
 Result := SendMessage(hProgress, PBM_SETPOS, nNewPos, 0);
end;

//Получаем позицию ProgressBar
function Progress_GetPos(hProgress: HWND): Integer;
begin
 Result := SendMessage(hProgress, PBM_GETPOS, 0, 0);
end;

function Progress_DeltaPos(hProgress: HWND; nIncrement: wParam): Integer;
begin
 Result := SendMessage(hProgress, PBM_DELTAPOS, nIncrement, 0);
end;

//Установка шага продвижения ProgressBar
function Progress_SetStep(hProgress: HWND; nStepInc: wParam): Integer;
begin
 Result := SendMessage(hProgress, PBM_SETSTEP, nStepInc, 0);
end;

function Progress_StepIt(hProgress: HWND): Integer;
begin
 Result := SendMessage(hProgress, PBM_STEPIT, 0, 0);
end;

procedure Progress_SetLineColor(hProgress: HWND; Color: COLORREF);
begin
 SendMessage(hProgress, PBM_SETBKCOLOR, 0, Color);
end;

//Progress_SetBarColor(ProgressBar1.Handle, RGB(0, 100, 208));
procedure Progress_SetBarColor(hProgress: HWND; Color: COLORREF);
begin
 SendMessage(hProgress, PBM_SETBARCOLOR, 0, Color);
end;

//-------------------------------------------------------------------
// Rich Edit Control Helper Macros
//-------------------------------------------------------------------
function RichEdit_Enable(hRichEdit: HWND; fEnable: Bool): BOOL;
begin
 Result := EnableWindow(hRichEdit, fEnable);
end;

function RichEdit_GetText(hRichEdit: HWND): String;
var
 lpch: String;
begin
 GetWindowText(hRichEdit, PChar(lpch), SizeOf(lpch));
 Result := lpch;
end;

function RichEdit_GetTextLength(hRichEdit: HWND): Integer;
begin
 Result := GetWindowTextLength(hRichEdit);
end;

function RichEdit_SetText(hRichEdit: HWND; lpsz: PChar): BOOL;
begin
 Result := SetWindowText(hRichEdit, lpsz);
end;

procedure RichEdit_LimitText(hRichEdit: HWND; cchMax: wParam);
begin
 SendMessage(hRichEdit, EM_LIMITTEXT, cchMax, 0);
end;

function RichEdit_GetLineCount(hRichEdit: HWND): Integer;
begin
 Result := SendMessage(hRichEdit, EM_GETLINECOUNT, 0, 0);
end;

function RichEdit_GetLine(hRichEdit: HWND; line: wParam; lpch: LPCSTR): Integer;
begin
 Result := SendMessage(hRichEdit, EM_GETLINE, line, Integer(PChar(lpch)));
end;

procedure RichEdit_GetRect(hRichEdit: HWND; lprc: tRECT);
begin
 SendMessage(hRichEdit, EM_GETRECT, 0, Integer(@lprc));
end;

procedure RichEdit_SetRect(hRichEdit: HWND; lprc: tRECT);
begin
 SendMessage(hRichEdit, EM_SETRECT, 0, Integer(@lprc));
end;

function RichEdit_GetSel(hRichEdit: HWND): DWORD;
begin
 Result := SendMessage(hRichEdit, EM_GETSEL, 0, 0);
end;

procedure RichEdit_SetSel(hRichEdit: HWND; ichStart, ichEnd: Integer);
begin
 SendMessage(hRichEdit, EM_SETSEL, ichStart, ichEnd);
end;

procedure RichEdit_ReplaceSel(hRichEdit: HWND; lpszReplace: LPCSTR);
begin
 SendMessage(hRichEdit, EM_REPLACESEL, 0, Integer(PChar(lpszReplace)));
end;

function RichEdit_GetModify(hRichEdit: HWND): BOOL;
begin
 Result := LongBool(SendMessage(hRichEdit, EM_GETMODIFY, 0, 0));
end;

procedure RichEdit_SetModify(hRichEdit: HWND; fModified: UINT);
begin
 SendMessage(hRichEdit, EM_SETMODIFY, fModified, 0);
end;

function RichEdit_ScrollCaret(hRichEdit: HWND): BOOL;
begin
 Result := LongBool(SendMessage(hRichEdit, EM_SCROLLCARET, 0, 0));
end;

function RichEdit_LineFromChar(hRichEdit: HWND; ich: Integer): Integer;
begin
 Result := SendMessage(hRichEdit, EM_LINEFROMCHAR, ich, 0);
end;

function RichEdit_LineIndex(hRichEdit: HWND; line: Integer): Integer;
begin
 Result := SendMessage(hRichEdit, EM_LINEINDEX, line, 0);
end;

function RichEdit_LineLength(hRichEdit: HWND; line: Integer): Integer;
begin
 Result := SendMessage(hRichEdit, EM_LINELENGTH, line, 0);
end;

procedure RichEdit_Scroll(hRichEdit: HWND; dv: wParam; dh: lParam);
begin
 SendMessage(hRichEdit, EM_LINESCROLL, dh, dv);
end;

function RichEdit_CanUndo(hRichEdit: HWND): BOOL;
begin
 Result := LongBool(SendMessage(hRichEdit, EM_CANUNDO, 0, 0));
end;

function RichEdit_Undo(hRichEdit: HWND): BOOL;
begin
 Result := LongBool(SendMessage(hRichEdit, EM_UNDO, 0, 0));
end;

procedure RichEdit_EmptyUndoBuffer(hRichEdit: HWND);
begin
 SendMessage(hRichEdit, EM_EMPTYUNDOBUFFER, 0, 0);
end;

function RichEdit_GetFirstVisibleLine(hRichEdit: HWND): Integer;
begin
 Result := SendMessage(hRichEdit, EM_GETFIRSTVISIBLELINE, 0, 0);
end;

function RichEdit_SetReadOnly(hRichEdit: HWND; fReadOnly: Boolean): BOOL;
begin
 Result := LongBool(SendMessage(hRichEdit, EM_SETREADONLY, Integer(fReadOnly), 0));
end;

procedure RichEdit_SetWordBreakProc(hRichEdit: HWND; lpfnWordBreak: Pointer);
begin
 SendMessage(hRichEdit, EM_SETWORDBREAKPROC, 0, Integer(lpfnWordBreak));
end;

function RichEdit_GetWordBreakProc(hRichEdit: HWND): Pointer;
begin
 Result := Pointer(SendMessage(hRichEdit, EM_GETWORDBREAKPROC, 0, 0));
end;

function RichEdit_CanPaste(hRichEdit: HWND; uFormat: UINT): BOOL;
begin
 Result := LongBool(SendMessage(hRichEdit, EM_CANPASTE, uFormat, 0));
end;

function RichEdit_CharFromPos(hRichEdit: HWND; x, y: Integer): DWORD;
begin
 Result := SendMessage(hRichEdit, EM_CHARFROMPOS, 0, MAKELPARAM(x, y));
end;

function RichEdit_DisplayBand(hRichEdit: HWND; lprc: tRECT): BOOL;
begin
 Result := LongBool(SendMessage(hRichEdit, EM_DISPLAYBAND, 0, Integer(@lprc)));
end;

procedure RichEdit_ExGetSel(hRichEdit: HWND; lpchr: TCharRange);
begin
 SendMessage(hRichEdit, EM_EXGETSEL, 0, LPARAM(@lpchr));
end;

procedure RichEdit_ExLimitText(hRichEdit: HWND; cchTextMax: Dword);
begin
 SendMessage(hRichEdit, EM_EXLIMITTEXT, 0, cchTextMax);
end;

function RichEdit_ExLineFromChar(hRichEdit: HWND; ichCharPos: Dword): Integer;
begin
 Result := SendMessage(hRichEdit, EM_EXLINEFROMCHAR, 0, ichCharPos);
end;

function RichEdit_ExSetSel(hRichEdit: HWND; ichCharRange: TCharRange): Integer;
begin
 Result := SendMessage(hRichEdit, EM_EXSETSEL, 0, LPARAM(@ichCharRange));
end;

function RichEdit_FindText(hRichEdit: HWND; fuFlags: UINT; lpFindText: tFINDTEXT): Integer;
begin
 Result := SendMessage(hRichEdit, EM_FINDTEXT, fuFlags, LPARAM(@lpFindText));
end;

function RichEdit_FindTextEx(hRichEdit: HWND; fuFlags: UINT; lpFindText: tFINDTEXT): Integer;
begin
 Result := SendMessage(hRichEdit, EM_FINDTEXTEX, fuFlags, LPARAM(@lpFindText));
end;

function RichEdit_FindWordBreak(hRichEdit: HWND; code: UINT; ichStart: Dword): Integer;
begin
 Result := SendMessage(hRichEdit, EM_FINDWORDBREAK, code, ichStart);
end;

function RichEdit_FormatRange(hRichEdit: HWND; fRender: Boolean; lpFmt: tFORMATRANGE): Integer;
begin
 Result := SendMessage(hRichEdit, EM_FORMATRANGE, Integer(fRender), Integer(@lpFmt));
end;

function RichEdit_GetCharFormat(hRichEdit: HWND; fSelection: Boolean; lpFmt: tCHARFORMAT): DWORD;
begin
 Result := SendMessage(hRichEdit, EM_GETCHARFORMAT, Integer(fSelection), Integer(@lpFmt));
end;

function RichEdit_GetEventMask(hRichEdit: HWND): DWORD;
begin
 Result := SendMessage(hRichEdit, EM_GETEVENTMASK, 0, 0);
end;

function RichEdit_GetLimitText(hRichEdit: HWND): Integer;
begin
 Result := SendMessage(hRichEdit, EM_GETLIMITTEXT, 0, 0);
end;

function RichEdit_GetOleInterface(hRichEdit: HWND; ppObject: lParam): BOOL;
begin
 Result := LongBool(SendMessage(hRichEdit, EM_GETOLEINTERFACE, 0, ppObject));
end;

function RichEdit_GetOptions(hRichEdit: HWND): UINT;
begin
 Result := SendMessage(hRichEdit, EM_GETOPTIONS, 0, 0);
end;

function RichEdit_GetParaFormat(hRichEdit: HWND; lpFmt: tPARAFORMAT): DWORD;
begin
 Result := SendMessage(hRichEdit, EM_GETPARAFORMAT, 0, Integer(@lpFmt));
end;

function RichEdit_GetSelText(hRichEdit: HWND; lpBuf: LPSTR): Integer;
begin
 Result := SendMessage(hRichEdit, EM_GETSELTEXT, 0, Integer(@lpBuf));
end;

function RichEdit_GetTextRange(hRichEdit: HWND; lpRange: tTEXTRANGE): Integer;
begin
 Result := SendMessage(hRichEdit, EM_GETTEXTRANGE, 0, Integer(@lpRange));
end;

function RichEdit_GetWordBreakProcEx(hRichEdit: HWND): Integer;
begin
 Result := SendMessage(hRichEdit, EM_GETWORDBREAKPROCEX, 0, 0);
end;
//----------------- End Macros Copied from windowsx.h----------------

procedure RichEdit_HideSelection(hRichEdit: HWND; fHide: Boolean; fChangeStyle: Boolean);
begin
 SendMessage(hRichEdit, EM_HIDESELECTION, Integer(fHide), Integer(fChangeStyle));
end;

procedure RichEdit_PasteSpecial(hRichEdit: HWND; uFormat: UINT);
begin
 SendMessage(hRichEdit, EM_PASTESPECIAL, uFormat, 0);
end;

function RichEdit_PosFromChar(hRichEdit: HWND; wCharIndex: wParam): DWORD;
begin
 Result := SendMessage(hRichEdit, EM_POSFROMCHAR, wCharIndex, 0);
end;

procedure RichEdit_RequestResize(hRichEdit: HWND);
begin
 SendMessage(hRichEdit, EM_REQUESTRESIZE, 0, 0);
end;

function RichEdit_SelectionType(hRichEdit: HWND): Integer;
begin
 Result := SendMessage(hRichEdit, EM_SELECTIONTYPE, 0, 0);
end;

function RichEdit_SetBkgndColor(hRichEdit: HWND; fUseSysColor: Boolean; clr: tCOLORREF): tCOLORREF;
begin
 Result := SendMessage(hRichEdit, EM_SETBKGNDCOLOR, Integer(fUseSysColor), clr);
end;

function RichEdit_SetCharFormat(hRichEdit: HWND; uFlags: UINT; lpFmt: tCHARFORMAT): BOOL;
begin
 Result := LongBool(SendMessage(hRichEdit, EM_SETCHARFORMAT, uFlags, Integer(@lpFmt)));
end;

function RichEdit_SetEventMask(hRichEdit: HWND; dwMask: Dword): DWORD;
begin
 Result := SendMessage(hRichEdit, EM_SETEVENTMASK, 0, dwMask);
end;

function RichEdit_SetOleCallback(hRichEdit: HWND; lpObj: lParam): BOOL;
begin
 Result := LongBool(SendMessage(hRichEdit, EM_SETOLECALLBACK, 0, lpObj));
end;

function RichEdit_SetOptions(hRichEdit: HWND; fOperation: UINT; fOptions: UINT): UINT;
begin
 Result := SendMessage(hRichEdit, EM_SETOPTIONS, fOperation, fOptions);
end;

function RichEdit_SetParaFormat(hRichEdit: HWND; lpFmt: tPARAFORMAT): BOOL;
begin
 Result := LongBool(SendMessage(hRichEdit, EM_SETPARAFORMAT, 0, Integer(@lpFmt)));
end;

function RichEdit_SetTargetDevice(hRichEdit: HWND; hdcTarget: HDC; cxLineWidth: Integer): BOOL;
begin
 Result := LongBool(SendMessage(hRichEdit, EM_SETTARGETDEVICE, hdcTarget, cxLineWidth));
end;

function RichEdit_SetWordBreakProcEx(hRichEdit: HWND; pfnWordBreakProcEx: Integer): Integer;
begin
 Result := SendMessage(hRichEdit, EM_SETWORDBREAKPROCEX, 0, pfnWordBreakProcEx);
end;

function RichEdit_StreamIn(hRichEdit: HWND; uFormat: UINT; lpStream: tEDITSTREAM): Integer;
begin
 Result := SendMessage(hRichEdit, EM_STREAMIN, uFormat, Integer(@lpStream));
end;

function RichEdit_StreamOut(hRichEdit: HWND; uFormat: UINT; lpStream: tEDITSTREAM): Integer;
begin
 Result := SendMessage(hRichEdit, EM_STREAMOUT, uFormat, Integer(@lpStream));
end;

//-------------------------------------------------------------------
// Status Bar Helper Macros
//-------------------------------------------------------------------
function Status_GetBorders(hStatus: HWND; aBorders: lParam): BOOL;
begin
 Result := LongBool(SendMessage(hStatus, SB_GETBORDERS, 0, aBorders));
end;

function Status_GetParts(hStatus: HWND; nParts: wParam; aRightCoord: lParam): Integer;
begin
 Result := SendMessage(hStatus, SB_GETPARTS, nParts, aRightCoord);
end;

function Status_GetRect(hStatus: HWND; iPart: wParam; lprc: lParam): BOOL;
begin
 Result := LongBool(SendMessage(hStatus, SB_GETRECT, iPart, lprc));
end;

function Status_GetText(hStatus: HWND; iPart: wParam): String;
var
 buffer: array[0..1024] of Char;
begin
 SendMessage(hStatus, SB_GETTEXT, iPart, Longint(@buffer));
 Result := buffer;
end;

function Status_GetTextLength(hStatus: HWND; iPart: wParam): DWORD;
begin
 Result := SendMessage(hStatus, SB_GETTEXTLENGTH, iPart, 0);
end;

procedure Status_SetMinHeight(hStatus: HWND; minHeight: wParam);
begin
 SendMessage(hStatus, SB_SETMINHEIGHT, minHeight, 0);
end;

function Status_SetParts(hStatus: HWND; nParts: wParam; aWidths: lParam): BOOL;
begin
 Result := LongBool(SendMessage(hStatus, SB_SETPARTS, nParts, aWidths));
end;

function Status_SetText(hStatus: HWND; iPart: wParam; szText: LPSTR): BOOL;
begin
 Result := LongBool(SendMessage(hStatus, SB_SETTEXT, iPart, Integer(szText)));
end;

function Status_Simple(hStatus: HWND; fSimple: Boolean): BOOL;
begin
 Result := LongBool(SendMessage(hStatus, SB_SIMPLE, Integer(fSimple), 0));
end;

//-------------------------------------------------------------------
// Tool Bar Helper Macros
//-------------------------------------------------------------------
function ToolBar_AddBitmap(hToolBar: HWND; nButtons: wParam; lptbab: tTBADDBITMAP): Integer;
begin
 Result := SendMessage(hToolBar, TB_ADDBITMAP, nButtons, Integer(@lptbab));
end;

function ToolBar_AddButtons(hToolBar: HWND; uNumButtons: UINT; lpButtons: tTBBUTTON): BOOL;
begin
 Result := LongBool(SendMessage(hToolBar, TB_ADDBUTTONS, uNumButtons, Integer(@lpButtons)));
end;

function ToolBar_AddString(hToolBar: HWND; hst: HInst; idString: Word): Integer;
begin
 Result := SendMessage(hToolBar, TB_ADDSTRING, hst, MAKELONG(idString, 0));
end;

procedure ToolBar_AutoSize(hToolBar: HWND);
begin
 SendMessage(hToolBar, TB_AUTOSIZE, 0, 0);
end;

function ToolBar_ButtonCount(hToolBar: HWND): Integer;
begin
 Result := SendMessage(hToolBar, TB_BUTTONCOUNT, 0, 0);
end;

procedure ToolBar_ButtonStructSize(hToolBar: HWND);
begin
 SendMessage(hToolBar, TB_BUTTONSTRUCTSIZE, sizeof(tTBBUTTON), 0);
end;

function ToolBar_ChangeBitmap(hToolBar: HWND; idButton: wParam; iBitmap: lParam): BOOL;
begin
 Result := LongBool(SendMessage(hToolBar, TB_CHANGEBITMAP, idButton, iBitmap));
end;

function ToolBar_CheckButton(hToolBar: HWND; idButton: wParam; fCheck: lParam): BOOL;
begin
 Result := LongBool(SendMessage(hToolBar, TB_CHECKBUTTON, idButton, MAKELONG(fCheck, 0)));
end;

function ToolBar_CommandToIndex(hToolBar: HWND; idButton: wParam): Integer;
begin
 Result := SendMessage(hToolBar, TB_COMMANDTOINDEX, idButton, 0);
end;

procedure ToolBar_Customize(hToolBar: HWND);
begin
 SendMessage(hToolBar, TB_CUSTOMIZE, 0, 0);
end;

function ToolBar_DeleteButton(hToolBar: HWND; idButton: wParam): BOOL;
begin
 Result := LongBool(SendMessage(hToolBar, TB_DELETEBUTTON, idButton, 0));
end;

function ToolBar_EnableButton(hToolBar: HWND; idButton: wParam; fEnable: lParam): BOOL;
begin
 Result := LongBool(SendMessage(hToolBar, TB_ENABLEBUTTON, idButton, MAKELONG(fEnable, 0)));
end;

function ToolBar_GetBitmap(hToolBar: HWND; idButton: wParam): Integer;
begin
 Result := SendMessage(hToolBar, TB_GETBITMAP, idButton, 0);
end;

function ToolBar_GetBitmapFlags(hToolBar: HWND): Integer;
begin
 Result := SendMessage(hToolBar, TB_GETBITMAPFLAGS, 0, 0);
end;

function ToolBar_GetButton(hToolBar: HWND; idButton: wParam; lpButton: tTBBUTTON): BOOL;
begin
 Result := LongBool(SendMessage(hToolBar, TB_GETBUTTON, idButton, Integer(@lpButton)));
end;

function ToolBar_GetButtonText(hToolBar: HWND; idButton: wParam; lpszText: LPSTR): Integer;
begin
 Result := SendMessage(hToolBar, TB_GETBUTTONTEXT, idButton, Integer(lpszText));
end;

function ToolBar_GetItemRect(hToolBar: HWND; idButton: wParam; lprc: tRECT): BOOL;
begin
 Result := LongBool(SendMessage(hToolBar, TB_GETITEMRECT, idButton, Integer(@lprc)));
end;

function ToolBar_GetRows(hToolBar: HWND): Integer;
begin
 Result := SendMessage(hToolBar, TB_GETROWS, 0, 0);
end;

function ToolBar_GetState(hToolBar: HWND; idButton: wParam): Integer;
begin
 Result := SendMessage(hToolBar, TB_GETSTATE, idButton, 0);
end;

function ToolBar_GetToolTips(hToolBar: HWND): HWND;
begin
 Result := SendMessage(hToolBar, TB_GETTOOLTIPS, 0, 0);
end;

function ToolBar_HideButton(hToolBar: HWND; idButton: wParam; fShow: lParam): BOOL;
begin
 Result := LongBool(SendMessage(hToolBar, TB_HIDEBUTTON, idButton, MAKELONG(fShow, 0)));
end;

function ToolBar_Indeterminate(hToolBar: HWND; idButton: wParam; fIndeterminate: lParam): BOOL;
begin
 Result := LongBool(SendMessage(hToolBar, TB_INDETERMINATE, idButton, MAKELONG(fIndeterminate, 0)));
end;

function ToolBar_InsertButton(hToolBar: HWND; idButton: wParam; lpButton: tTBBUTTON): BOOL;
begin
 Result := LongBool(SendMessage(hToolBar, TB_INSERTBUTTON, idButton, Integer(@lpButton)));
end;

function ToolBar_IsButtonChecked(hToolBar: HWND; idButton: wParam): Integer;
begin
 Result := SendMessage(hToolBar, TB_ISBUTTONCHECKED, idButton, 0);
end;

function ToolBar_IsButtonEnabled(hToolBar: HWND; idButton: wParam): Integer;
begin
 Result := SendMessage(hToolBar, TB_ISBUTTONENABLED, idButton, 0);
end;

function ToolBar_IsButtonHidden(hToolBar: HWND; idButton: wParam): Integer;
begin
 Result := SendMessage(hToolBar, TB_ISBUTTONHIDDEN, idButton, 0);
end;

function ToolBar_IsButtonIndeterminate(hToolBar: HWND; idButton: wParam): Integer;
begin
 Result := SendMessage(hToolBar, TB_ISBUTTONINDETERMINATE, idButton, 0);
end;

function ToolBar_IsButtonPressed(hToolBar: HWND; idButton: wParam): Integer;
begin
 Result := SendMessage(hToolBar, TB_ISBUTTONPRESSED, idButton, 0);
end;

function ToolBar_PressButton(hToolBar: HWND; idButton: wParam; fPress: lParam): BOOL;
begin
 Result := LongBool(SendMessage(hToolBar, TB_PRESSBUTTON, idButton, MAKELONG(fPress, 0)));
end;

procedure ToolBar_SaveRestore(hToolBar: HWND; fSave: Boolean; ptbsp: tTBSAVEPARAMS);
begin
 SendMessage(hToolBar, TB_SAVERESTORE, Integer(fSave), Integer(@ptbsp));
end;

function ToolBar_SetBitmapSize(hToolBar: HWND; dxBitmap, dyBitmap: Integer): BOOL;
begin
 Result := LongBool(SendMessage(hToolBar, TB_SETBITMAPSIZE, 0, MAKELONG(dxBitmap, dyBitmap)));
end;

function ToolBar_SetButtonSize(hToolBar: HWND; dxBitmap, dyBitmap: Integer): BOOL;
begin
 Result := LongBool(SendMessage(hToolBar, TB_SETBUTTONSIZE, 0, MAKELONG(dxBitmap, dyBitmap)));
end;

function ToolBar_SetCmdID(hToolBar: HWND; index, cmdId: UINT): BOOL;
begin
 Result := LongBool(SendMessage(hToolBar, TB_SETCMDID, index, cmdId));
end;

procedure ToolBar_SetParent(hToolBar: HWND; hwndParent: HWND);
begin
 SendMessage(hToolBar, TB_SETPARENT, hwndParent, 0);
end;

procedure ToolBar_SetRows(hToolBar: HWND; cRows: Integer; fLarger: Boolean; lprc: TRECT);
begin
 SendMessage(hToolBar, TB_SETROWS, MAKEWPARAM(cRows, Integer(fLarger)), Integer(@lprc));
end;

function ToolBar_SetState(hToolBar: HWND; idButton: wParam; fState: lParam): BOOL;
begin
 Result := LongBool(SendMessage(hToolBar, TB_SETSTATE, idButton, MAKELONG(fState, 0)));
end;

procedure ToolBar_SetToolTips(hToolBar: HWND; hwndToolTip: HWND);
begin
 SendMessage(hToolBar, TB_SETTOOLTIPS, hwndToolTip, 0);
end;

//-------------------------------------------------------------------
// Tool Tip Helper Macros
//-------------------------------------------------------------------
procedure ToolTip_Activate(hToolTip: HWND; fActivate: Boolean);
begin
 SendMessage(hToolTip, TTM_ACTIVATE, Integer(fActivate), 0);
end;

function ToolTip_AddTool(hToolTip: HWND; lpti: pTOOLINFO): BOOL;
begin
 Result := LongBool(SendMessage(hToolTip, TTM_ADDTOOL, 0, Integer(lpti)));
end;

procedure ToolTip_DelTool(hToolTip: HWND; lpti: pTOOLINFO);
begin
 SendMessage(hToolTip, TTM_DELTOOL, 0, Integer(lpti));
end;

function ToolTip_EnumTools(hToolTip: HWND; iTool: wParam; lpti: pTOOLINFO): BOOL;
begin
 Result := LongBool(SendMessage(hToolTip, TTM_ENUMTOOLS, iTool, Integer(lpti)));
end;

function ToolTip_GetCurrentTool(hToolTip: HWND; lpti: pTOOLINFO): BOOL;
begin
 Result := LongBool(SendMessage(hToolTip, TTM_GETCURRENTTOOL, 0, Integer(@lpti)));
end;

procedure ToolTip_GetText(hToolTip: HWND; lpti: pTOOLINFO);
begin
 SendMessage(hToolTip, TTM_GETTEXT, 0, Integer(@lpti));
end;

function ToolTip_GetToolCount(hToolTip: HWND): Integer;
begin
 Result := SendMessage(hToolTip, TTM_GETTOOLCOUNT, 0, 0);
end;

function ToolTip_GetToolInfo(hToolTip: HWND; lpti: pTOOLINFO): BOOL;
begin
 Result := LongBool(SendMessage(hToolTip, TTM_GETTOOLINFO, 0, Integer(@lpti)));
end;

function ToolTip_HitText(hToolTip: HWND; lphti: pTTHITTESTINFO): BOOL;
begin
 Result := LongBool(SendMessage(hToolTip, TTM_HITTEST, 0, Integer(lphti)));
end;

procedure ToolTip_NewToolRect(hToolTip: HWND; lpti: pTOOLINFO);
begin
 SendMessage(hToolTip, TTM_NEWTOOLRECT, 0, Integer(lpti));
end;

procedure ToolTip_RelayEvent(hToolTip: HWND; lpmsg: pMSG);
begin
 SendMessage(hToolTip, TTM_RELAYEVENT, 0, Integer(lpmsg));
end;

procedure ToolTip_SetDelayTime(hToolTip: HWND; uFlag: wParam; iDelay: lParam);
begin
 SendMessage(hToolTip, TTM_SETDELAYTIME, uFlag, iDelay);
end;

procedure ToolTip_SetToolInfo(hToolTip: HWND; lpti: pTOOLINFO);
begin
 SendMessage(hToolTip, TTM_SETTOOLINFO, 0, Integer(lpti));
end;

procedure ToolTip_UpdateTipText(hToolTip: HWND; lpti: pTOOLINFO);
begin
 SendMessage(hToolTip, TTM_UPDATETIPTEXT, 0, Integer(lpti));
end;

function ToolTip_WindowFromPoint(hToolTip: HWND; lppt: pPOINT): HWND;
begin
 Result := SendMessage(hToolTip, TTM_WINDOWFROMPOINT, 0, Integer(@lppt));
end;

//-------------------------------------------------------------------
// Track Bar Helper Macros
//-------------------------------------------------------------------
procedure TrackBar_ClearSel(hTrackBar: HWND; fRedraw: Boolean);
begin
 SendMessage(hTrackBar, TBM_CLEARSEL, Integer(fRedraw), 0);
end;

procedure TrackBar_ClearTics(hTrackBar: HWND; fRedraw: Boolean);
begin
 SendMessage(hTrackBar, TBM_CLEARTICS, Integer(fRedraw), 0);
end;

procedure TrackBar_GetChannelRect(hTrackBar: HWND; lprc: tRECT);
begin
 SendMessage(hTrackBar, TBM_GETCHANNELRECT, 0, Integer(@lprc));
end;

function TrackBar_GetLineSize(hTrackBar: HWND): Integer;
begin
 Result := SendMessage(hTrackBar, TBM_GETLINESIZE, 0, 0);
end;

function TrackBar_GetNumTics(hTrackBar: HWND): Integer;
begin
 Result := SendMessage(hTrackBar, TBM_GETNUMTICS, 0, 0);
end;

function TrackBar_GetPageSize(hTrackBar: HWND): Integer;
begin
 Result := SendMessage(hTrackBar, TBM_GETPAGESIZE, 0, 0);
end;

function TrackBar_GetPos(hTrackBar: HWND): Integer;
begin
 Result := SendMessage(hTrackBar, TBM_GETPOS, 0, 0);
end;

function TrackBar_GetPTics(hTrackBar: HWND): Integer;
begin
 Result := SendMessage(hTrackBar, TBM_GETPTICS, 0, 0);
end;

function TrackBar_GetRangeMax(hTrackBar: HWND): Integer;
begin
 Result := SendMessage(hTrackBar, TBM_GETRANGEMAX, 0, 0);
end;

function TrackBar_GetRangeMin(hTrackBar: HWND): Integer;
begin
 Result := SendMessage(hTrackBar, TBM_GETRANGEMIN, 0, 0);
end;

function TrackBar_GetSelEnd(hTrackBar: HWND): Integer;
begin
 Result := SendMessage(hTrackBar, TBM_GETSELEND, 0, 0);
end;

function TrackBar_GetSelStart(hTrackBar: HWND): Integer;
begin
 Result := SendMessage(hTrackBar, TBM_GETSELSTART, 0, 0);
end;

function TrackBar_GetThumbLength(hTrackBar: HWND): UINT;
begin
 Result := SendMessage(hTrackBar, TBM_GETTHUMBLENGTH, 0, 0);
end;

procedure TrackBar_GetThumbRect(hTrackBar: HWND; lprc: tRECT);
begin
 SendMessage(hTrackBar, TBM_GETTHUMBRECT, 0, Integer(@lprc));
end;

function TrackBar_GetTic(hTrackBar: HWND; iTic: wParam): Integer;
begin
 Result := SendMessage(hTrackBar, TBM_GETTIC, iTic, 0);
end;

function TrackBar_GetTicPos(hTrackBar: HWND; iTic: wParam): Integer;
begin
 Result := SendMessage(hTrackBar, TBM_GETTICPOS, iTic, 0);
end;

function TrackBar_SetLineSize(hTrackBar: HWND; lLineSize: lParam): Integer;
begin
 Result := SendMessage(hTrackBar, TBM_SETLINESIZE, 0, lLineSize);
end;

function TrackBar_SetPageSize(hTrackBar: HWND; lPageSize: lParam): Integer;
begin
 Result := SendMessage(hTrackBar, TBM_SETPAGESIZE, 0, lPageSize);
end;

procedure TrackBar_SetPos(hTrackBar: HWND; bPosition: Boolean; lPosition: Integer);
begin
 SendMessage(hTrackBar, TBM_SETPOS, Integer(bPosition), lPosition);
end;

procedure TrackBar_SetRange(hTrackBar: HWND; bRedraw: Boolean; lMinimum, lMaximum: Integer);
begin
 SendMessage(hTrackBar, TBM_SETRANGE, Integer(bRedraw), MAKELONG(lMinimum, lMaximum));
end;

procedure TrackBar_SetRangeMax(hTrackBar: HWND; bRedraw: Boolean; lMaximum: Integer);
begin
 SendMessage(hTrackBar, TBM_SETRANGEMAX, Integer(bRedraw), lMaximum);
end;

procedure TrackBar_SetRangeMin(hTrackBar: HWND; bRedraw: Boolean; lMinimum: Integer);
begin
 SendMessage(hTrackBar, TBM_SETRANGEMIN, Integer(bRedraw), lMinimum);
end;

procedure TrackBar_SetSel(hTrackBar: HWND; bRedraw: Boolean; lMinimum, lMaximum: Integer);
begin
 SendMessage(hTrackBar, TBM_SETSEL, Integer(bRedraw), MAKELONG(lMinimum, lMaximum));
end;

procedure TrackBar_SetSelEnd(hTrackBar: HWND; bRedraw: Boolean; lEnd: lParam);
begin
 SendMessage(hTrackBar, TBM_SETSELEND, Integer(bRedraw), lEnd);
end;

procedure TrackBar_SetSelStart(hTrackBar: HWND; bRedraw: Boolean; lStart: lParam);
begin
 SendMessage(hTrackBar, TBM_SETSELSTART, Integer(bRedraw), lStart);
end;

procedure TrackBar_SetThumbLength(hTrackBar: HWND; iLength: UINT);
begin
 SendMessage(hTrackBar, TBM_SETTHUMBLENGTH, iLength, 0);
end;

function TrackBar_SetTic(hTrackBar: HWND; lPosition: Integer): BOOL;
begin
 Result := BOOL(SendMessage(hTrackBar, TBM_SETTIC, 0, lPosition));
end;

procedure TrackBar_SetTicFreq(hTrackBar: HWND; wFreq: wParam; lPosition: Integer);
begin
 SendMessage(hTrackBar, TBM_SETTICFREQ, wFreq, lPosition);
end; 

//-------------------------------------------------------------------
// Up / Down Control Helper Macros
//-------------------------------------------------------------------
function UpDown_CreateControl(hWin, hControl: HWND; ID, Min, Max, Value: Integer): HWND;
begin
 Result := CreateUpDownControl(WS_CHILD or WS_BORDER or WS_VISIBLE or
  UDS_WRAP or UDS_ARROWKEYS or UDS_ALIGNRIGHT or UDS_SETBUDDYINT,
   0, 0, 0, 0, hWin, ID, hInstance, hControl, Max, Min, Value);
end;

function UpDown_GetAccel(hUpDown: HWND; wAccels: WParam; lAccels: LParam): Integer;
begin
 Result := SendMessage(hUpDown, UDM_GETACCEL, wAccels, lAccels);
end;

function UpDown_GetBase(hUpDown: HWND): Integer;
begin
 Result := SendMessage(hUpDown, UDM_GETBASE, 0, 0);
end;

function UpDown_GetBuddy(hUpDown: HWND): HWND;
begin
 Result := SendMessage(hUpDown, UDM_GETBUDDY, 0, 0);
end;

function UpDown_GetPos(hUpDown: HWND): DWORD;
begin
 Result := LOWORD(SendMessage(hUpDown, UDM_GETPOS, 0, 0));
end;

function UpDown_GetRange(hUpDown: HWND): DWORD;
begin
 Result := DWORD(SendMessage(hUpDown, UDM_GETRANGE, 0, 0));
end;

function UpDown_SetAccel(hUpDown: HWND; wAccels: WParam; lAccels: LParam): BOOL;
begin
 Result := BOOL(SendMessage(hUpDown, UDM_SETACCEL, wAccels, lAccels));
end;

function UpDown_SetBase(hUpDown: HWND; wBase: WParam): Integer;
begin
 Result := SendMessage(hUpDown, UDM_SETBASE, wBase, 0);
end;

function UpDown_SetBuddy(hUpDown, hBuddy: HWND): HWND;
begin
 Result := SendMessage(hUpDown, UDM_SETBUDDY, hBuddy, 0);
end;

function UpDown_SetPos(hUpDown: HWND; nPos: LParam): short;
begin
 Result := SendMessage(hUpDown, UDM_SETPOS, 0, MAKELONG(nPos, 0));
end;

//Установка минимальной и максимальной позиции UpDown
function UpDown_SetRange(hUpDown: HWND; nUpper, nLower: short): short;
begin
 Result := SendMessage(hUpDown, UDM_SETRANGE, 0, MAKELONG(nUpper, nLower))
end;

end.
