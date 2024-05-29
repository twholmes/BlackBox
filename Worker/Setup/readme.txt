REM ======================
REM Command line summary
REM ======================

REM Commandline: BlackBoxWorker.exe
REM [-Help <topic>] [-HelpRun] [-HelpSetup]
REM [-Setup] [-unzip] [-clean] [-days <num1>] [-months <num2>]

REM [-job <name.job.xml>] [-run, -list] [-guid, -noguid] [-local, -progdata, -reg, -env] [-debug]
REM [-JobID <jobID>] [-run, -list] [-guid, -noguid] [-local, -progdata, -reg, -env] [-debug]

REM [-task <name.task.xml>] [-run, -list] [-guid, -noguid] [-local, -progdata, -reg, -env] [-debug]

REM [-portalfile <fid>] [-load] [-validate] [-stage] [-process] [-publish] [-withdraw] [-archive] [-debug]
REM [-portaljob <jid>] [-run] [-debug]

REM [-Test]

REM Selectors:
REM [-all]
REM [-repeat]
REM [-item <n>]
REM [-uc <usecase>
REM [-rid <n>]"));
REM [-table <tablename>]

REM Options:
REM [-foldermode <local, progdata, reg, env>] [-local, -progdata, -reg, -env] [-guid, -noguid]
REM [-database, -nodatabase] [-csv, -nocsv]
REM [-runas] [-account <domain/user>] [-domain <domain>] [-user <user>] [-password <password>]
REM [-unzip] [-clean],[-days <num1>] [-months <num2>]
REM [-nowindow] [-verbose] [-debug] [-simulate] [-show]

REM =================================
REM Help job and task mode commands
REM =================================

REM Commandline: BlackBoxWorker.exe
REM [-job <name.job.xml>] [-run, -list] [-guid, noguid] [-local, -progdata, -reg, -env] [-debug]
REM [-task <name.task.xml>] [-run, -list] [-guid, -noguid] [-local, -progdata, -reg, -env] [-debug]

REM Directory switches:
REM [-local, -progdata, -reg, -env]

REM Control switches:
REM [-guid, -noguid(d)] [-verbose] [-debug] [-nowindow]

REM ===========================
REM Help portal mode commands
REM ===========================

REM Commandline: BlackBoxWorker.exe
REM   [-portalfile <fid>] [-load] [-validate] [-stage] [-process] [-publish] [-withdraw] [-archive] [-debug]
REM   [-portaljob <jid>] [-run] [-debug]

REM ===========================
REM Help setup command
REM ===========================

REM Commandline: BlackBoxWorker.exe -setup <setup-option>

REM Commandline: BlackBoxWorker.exe <csetup-option>
REM -ConvertXlsxCatalogToCat
REM -ConvertXlsxCatalogToXml
REM -ConvertCatCatalogToXml
REM -ConvertXmlCatalogToCat


REM ==============
REM EXAMPLES
REM ==============

Example: Cleanup task
BlackBoxWorker.exe -task cleanup.task.xml -run -local -debug

Example: Workday job
BlackBoxWorker.exe -job workday.job.xml -run -local -debug



Example: Create a named manifest by parsing a root directory
BlackBoxWorker.exe -catalog blackbox -local -debug

Example: Pack an archive from a named manifest
BlackBoxWorker.exe -pack blackbox -local -debug

Example: Unack an archive from a named manifest
BlackBoxWorker.exe -unpack blackbox -local -show -debug


Example: Test
BlackBoxWorker.exe -test xxx -env -debug


















REM use the following command to clear logs
REM netsh http flush logbuffer



