::nginx windows����װ������
::��windows����װ��winsw��nginx��װΪϵͳ����󣬴�ʱ���¼�������reload���������������ֱ�ӹ���Ҫ��system�û���ݹ���ͨ��psexec���Դﵽ��һĿ��
::ͨ��������������ʵ��nginxϵͳ����İ�װж�أ������͹ر�
::xiangyuecn��д��ѧϰnginx֮�ã���ûŪ����ô����nginx���ȰѰ�װ�����Ƚ���ˣ���Ȼ������һע��nginxҲ�Զ��ص���
::http://download.csdn.net/user/xiangyuecn
::2014-02-20

::˵����
::��1���ѡ�5���ڵ��ļ��ŵ�nginx��Ŀ¼���������start.bat����
::��2�������������Ȱ�װ����װ�ɹ��󽫻����ж�ع��ܣ�������������������Ҳ������������û�к����˵Ĵ���˵����
::��3����װ�����ɵ�winswXXX.xml�ļ�����ɾ���������޷�ж�غ�����
::��4������������winsw�����3��log�ļ�������ɾ��
::��5���˳�����
::		start.bat ���ű������ص�ַ��http://download.csdn.net/user/xiangyuecn
::		rolllog.vbs �����ļ������滻���½ű������ص�ַ��http://download.csdn.net/user/xiangyuecn
::		PsExec.exe ��system�û���ݹ���nginx�����ص�ַ��http://technet.microsoft.com/en-us/sysinternals/bb896649.aspx
::		winsw1.9.exe windows����װ�������ص�ַ��http://download.java.net/maven/2/com/sun/winsw/winsw/ ���ý��ܣ�https://kenai.com/projects/winsw/pages/ConfigurationSyntax
::	�⼸���ļ���ɣ�ȱһ����

@echo off

::���ò���---------------------------

::��ѡ�Ǹ�Ŀ¼����ģ�壬���ز�������
set nginxTxt=D:\Works\�ĵ�\���������ļ�\nginx\nginx-local.txt
if not exist %nginxTxt% (
	set nginxTxt=
)

::ִ��·��
set exe=nginx.exe
::�����ļ���
set confPath=conf/nginx.conf
::��װ��·������Ҫ��׺
set svsInstall=winsw1.9
::��������
set svs=Nginx

::ִ�в���---------------------------
color 8f

if "%1"=="" psexec -i -d -s %0 system %~d0 %~d0%~p0
if "%1"=="system" goto main
exit
:main
set dir=%3
set stack=
set stackErr=0
%2
cd %dir%

echo               *****˵�������뿴Դ���� by xiangyuecn ���ݺ���*****
echo.
if not "%msg%"=="" echo -------%msg%-------

set msg=
set datetime=%date:~0,10% %time:~0,8%
set isRun=false
set isInstall=true
sc query %svs%|findstr /c:"ָ���ķ���δ��װ">nul&&set isInstall=false
sc query %svs%|findstr /ic:"run">nul&&set isRun=true

if %isRun%==true (
	echo %datetime% %svs%����������...
) else (
	echo %datetime% %svs%����δ����xxx
)

echo ���Բ�����
if not %isRun%==true echo   1:����
if %isRun%==true (
	echo   2:ֹͣ
	echo   3:����
	echo.
	echo   4:���´���־��ˢ�����ݵ��ļ�
	echo.
	echo   5:���¼�������
)
echo   6:��ʱ���ؽ���־
echo        ���ڸ�Ŀ¼�½�nginx.txt�ļ���"%nginxTxt%"����ʽ(h)
echo.
echo   7:��������
echo.
echo   8:�˳�
echo.
if %isInstall%==false (
	echo   0:��װ����
) else (
	echo   0:ж�ط���/�ָ�%svsInstall%.xml����
)

set step=
set /p step=���������:
echo.

if "%step%"=="0" goto step_install
if "%step%"=="1" goto step_run
if "%step%"=="2" goto step_stop
if "%step%"=="3" goto step_reset
if "%step%"=="4" goto step_reopen
if "%step%"=="5" goto step_reload
if "%step%"=="6" goto step_rolllog
if "%step%"=="7" goto step_test
if "%step%"=="8" exit
if "%step%"=="h" goto rollloghelp

goto step_end

:rollloghelp
cls
echo	nginx.txt�ļ����ø�ʽ��
echo          log·������дʱ�����
echo              ��:logs/access_{y}{m}{d} {h}{M}{s}.log
echo              Ϊ:logs/access_20130306 122530.log
echo.
echo          ����֧�ֺ궨����滻
echo              DEF(��ʶ) ������=������ (��ʶ)END
echo              ������֧��^&��^<��^>��/��_��-���ո񡢻��С���ĸ�����֡�������ϣ������ݿ��Զ���
pause
goto step_end

:step_run
	if not %isRun%==true (
		echo ������...
		net start %svs%
		if errorlevel 1 (
			set stackErr=1
			set msg=������������ʧ�ܣ���
			pause
		) else (
			set isRun=true
			set msg=����������
		)
	)
	goto step_end

:step_stop
	if %isRun%==true (
		echo �ر���...
		net stop %svs%
		if errorlevel 1 (
			set stackErr=1
			set msg=�����رշ���ʧ�ܣ���
			pause
		) else (
			set isRun=false
			set msg=�ѹرշ���
		)
	)
	goto step_end

:step_reset
	if %isRun%==true (
		echo ������...
		
		set stack=step_reset_stop
		set stackErr=0
		goto step_stop
		:step_reset_stop
		if %stackErr%==0 (
			set stack=step_reset_run
			goto step_run
			:step_reset_run
			set stack=
		)
		
		if %stackErr%==0 (
			set msg=�����ɹ�
		) else (
			set msg=%msg%!!��������!!
		)
	)
	goto step_end

:step_reopen
	if %isRun%==true (
		echo �������´���־...
		%exe% -s reopen
		if errorlevel 1 (
			set stackErr=1
			set msg=�������´���־ʧ�ܣ���
			pause
		) else (
			set msg=�Ѿ����´���־
		)
	)
	goto step_end

:step_reload
	if %isRun%==true (
		echo ���ڼ�������...
		%exe% -s reload
		if errorlevel 1 (
			set stackErr=1
			set msg=!!���¼�������ʧ��!!
			pause
		) else (
			set msg=��ִ�����¼�������
		)
	)
	goto step_end

:step_rolllog
	if "%nginxTxt%"=="" (
		set tpPath=%dir%nginx.txt
	) else (
		set tpPath=%nginxTxt%
	)
	if not exist %tpPath% (
		set stackErr=1
		echo %tpPath%�����ڣ����ȴ������ļ�������Ϊnginx.conf�ĸ�������־�ļ�·�����ʱ�����
		pause
	) else (
		echo ���ڰ�ʱ���ؽ���־...
		
		cscript rolllog.vbs %tpPath% %dir%%confPath%
		if ERRORLEVEL 1 (
			set stackErr=1
			set ms=����ִ�а�ʱ���ؽ���־ʧ�ܣ���
			pause
		) else (
			set stack=step_rolllog_test
			set stackErr=0
			goto step_test
			:step_rolllog_test
			set stack=
			
			if %stackErr%==0 (
				set stack=step_rolllog_reload
				set stackErr=0
				goto step_reload
				:step_rolllog_reload
				set stack=
				
				if %stackErr%==0 (
					set msg=��ִ�а�ʱ���ؽ���־
				) else (
					echo.
				)
				goto step_rolllog_reload_exit
			) else (
				set msg=%msg%������ʱ���ؽ���־ʧ�ܣ���
			)
			:step_rolllog_reload_exit
			echo.
		)
	)
	goto step_end

:step_test
	echo ���ڲ�������...
	%exe% -t
	if errorlevel 1 (
		set stackErr=1
		set msg=����������Ч����
		pause
	) else (
		set msg=�Ѳ���������ã�������Ч
	)
	goto step_end

:step_install
	if %isInstall%==true goto step_uninstall
	echo ���ڰ�װ...

	set stack=step_install_getxml
	set stackErr=0
	goto fn_getInstallXML
	:step_install_getxml
	set stack=

	%svsInstall%.exe install
	set msg=��ִ�а�װ����״̬��ȷ��
	goto step_end

:step_uninstall
	set useUninstall=
	echo ȷ��ɾ������������y,�ָ���ɾ����h��
	set /p useUninstall=
	if "%useUninstall%"=="h" (
		set stack=step_uninstall_getxml
		set stackErr=0
		goto fn_getInstallXML
		:step_uninstall_getxml
		set stack=
		goto step_uninstall_getxml_exit
	) else (
		if "%useUninstall%"=="y" (
			set stack=step_uninstall_stop
			set stackErr=0
			goto step_stop
			:step_uninstall_stop
			set stack=
			
			if %stackErr%==0 (
				echo ����ж��...
				%svsInstall%.exe uninstall
				set msg=��ִ��ж�أ���״̬��ȷ��
			) else (
				set msg=%msg%����ж��ʧ�ܣ���
			)
		)
	)
	:step_uninstall_getxml_exit
	goto step_end

:step_end
	if "%stack%"=="" (
		cls
		goto main
	) else (
		goto %stack%
	)

:fn_getInstallXML
	echo ^<?xml version="1.0" encoding="GBK"?^>>%svsInstall%.xml
	echo ^<service^>>>%svsInstall%.xml
	echo 	^<!-->>%svsInstall%.xml
	echo 	��װ����>>%svsInstall%.xml
	echo 	cmd:^>winws.exe install>>%svsInstall%.xml
	echo 	ж�ط���>>%svsInstall%.xml
	echo 	cmd:^>winws.exe uninstall>>%svsInstall%.xml
	echo 	--^>>>%svsInstall%.xml
	echo 	^<id^>%svs%^</id^>>>%svsInstall%.xml
	echo 	^<name^>%svs%^</name^>>>%svsInstall%.xml
	echo 	^<description^>%svs%�����ɰ�װ����װ�����ñ���װ��ж��^</description^>>>%svsInstall%.xml
	echo 	^<!--��������--^>>>%svsInstall%.xml
	echo 	^<depend^>^</depend^>>>%svsInstall%.xml
	echo 	^<!--ִ�г���·��--^>>>%svsInstall%.xml
	echo 	^<executable^>%dir%%exe%^</executable^>>>%svsInstall%.xml
	echo 	^<!--��־Ŀ¼--^>>>%svsInstall%.xml
	echo 	^<logpath^>%dir%^</logpath^>>>%svsInstall%.xml
	echo 	^<!--��־��¼��ʽreset roll append--^>>>%svsInstall%.xml
	echo 	^<logmode^>append^</logmode^>>>%svsInstall%.xml
	echo 	^<!--��������--^>>>%svsInstall%.xml
	echo 	^<startargument^>-p %dir%^</startargument^>>>%svsInstall%.xml
	echo 	^<!--�رղ���--^>>>%svsInstall%.xml
	echo 	^<stopargument^>-p %dir% -s stop^</stopargument^>>>%svsInstall%.xml
	echo 	^<!--��ʾͼ�ν���>>%svsInstall%.xml
	echo 	^<interactive /^>>>%svsInstall%.xml
	echo 	--^>>>%svsInstall%.xml
	echo ^</service^>>>%svsInstall%.xml
	goto %stack%