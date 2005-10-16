; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "新酷音輸入法"
!define PRODUCT_VERSION "0.1.3"
!define PRODUCT_PUBLISHER "PCMan (洪任諭)"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor lzma

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"

Function .onInit
  ReadRegStr $0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion"
  StrCmp $0 "" NoAbort 0 
    MessageBox MB_ICONSTOP|MB_OK "偵測到已安裝 ${PRODUCT_NAME} $0，請先移除後再重新安裝。"
    Abort
  NoAbort:
FunctionEnd

BGGradient 0000FF 000000 FFFFFF

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!define MUI_LICENSEPAGE_RADIOBUTTONS
!insertmacro MUI_PAGE_LICENSE "License.txt"
; Directory page
; !insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_LINK_LOCATION "http://chewing.csie.net/"
!define MUI_FINISHPAGE_LINK "參觀新酷音輸入法網站： ${MUI_FINISHPAGE_LINK_LOCATION}"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "TradChinese"

; Reserve files
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "win32-chewing-${PRODUCT_VERSION}.exe"
InstallDir "$SYSDIR\IME\Chewing"
ShowInstDetails show
ShowUnInstDetails show

Function OnInstError
    MessageBox MB_ICONSTOP|MB_OK "安裝發生錯誤，請確定你有系統管理員權限，以及舊版不在執行中$\n$\n建議到控制台輸入法設定當中，移除舊版後重開機再安裝。"
    Abort
FunctionEnd

Section "MainSection" SEC01
  SetOutPath "$SYSDIR\IME\Chewing"
  SetOverwrite on
  File "Data\us_freq.dat"
  File /oname=ph_index.dat "Data\ph_index.dat.bin"
  File /oname=fonetree.dat "Data\fonetree.dat.bin"
  File "Data\dict.dat"
  File /oname=ch_index.dat "Data\ch_index.dat.bin"
  File "Data\statuswnd.bmp"
  File "License.txt"
  File "Installer\Release\Installer.exe"
  File "ChewingServer\Release\ChewingServer.exe"
  SetOutPath "$SYSDIR"
  File "ChewingIME\Release\Chewing.ime"
; File "..\libchewing\branches\win32\win32\Release\libchewing.dll"

  IfErrors 0 +2
    Call OnInstError

SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  CreateDirectory "$SMPROGRAMS\新酷音輸入法"
  CreateShortCut "$SMPROGRAMS\新酷音輸入法\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"

  Exec '"$SYSDIR\IME\Chewing\Installer.exe"'

  IfErrors 0 +2
    Call OnInstError

SectionEnd

;Function un.onError
;  MessageBox MB_ICONSTOP|MB_OK "解除安裝發生錯誤，請確定輸入法不在使用中$\n$\n建議到控制台輸入法設定當中檢查是否正確移除。"
;  Abort
;FunctionEnd

Function un.onUninstSuccess
;  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地從你的電腦移除。"
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "你確定要完全移除 $(^Name) ，其及所有的元件？" IDYES +2
  Abort
FunctionEnd

Section Uninstall

  FindWindow $0 "ChewingServer"
  SendMessage $0 ${WM_DESTROY} 0 0

  ExecWait '"$SYSDIR\IME\Chewing\Installer.exe" /uninstall'

;  Delete "$SYSDIR\libchewing.dll"
  Delete "$SYSDIR\Chewing.ime"
  Delete "$SYSDIR\IME\Chewing\License.txt"
  Delete "$SYSDIR\IME\Chewing\statuswnd.bmp"
  Delete "$SYSDIR\IME\Chewing\ch_index.dat"
  Delete "$SYSDIR\IME\Chewing\dict.dat"
  Delete "$SYSDIR\IME\Chewing\fonetree.dat"
  Delete "$SYSDIR\IME\Chewing\hash.dat"
  Delete "$SYSDIR\IME\Chewing\ph_index.dat"
  Delete "$SYSDIR\IME\Chewing\us_freq.dat"
  Delete "$SYSDIR\IME\Chewing\Installer.exe"
  Delete "$SYSDIR\IME\Chewing\ChewingServer.exe"

;  IfErrors 0 +2
;    Call un.onError

  Delete "$SMPROGRAMS\新酷音輸入法\Uninstall.lnk"

  RMDir "$SYSDIR\IME\Chewing"
  RMDir "$SMPROGRAMS\新酷音輸入法"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"

  Delete "$INSTDIR\uninst.exe"

  SetAutoClose true
SectionEnd