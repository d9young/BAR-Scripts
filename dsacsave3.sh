#!/usr/bin/env sh
WKPID=$$
 
bteq << EOF
 
*** dsacsave.btq - Save DSAConnectionsTbl information.
 
*** .run file=logonrc.btq
.logon 127.0.0.1/dbc,dbc;
 
.set RECORDMODE off
.set FORMAT off
.set TITLEDASHES off
.set width 1024
 
*** save DDL
.os rm -f "dsac$WKPID.ddl"
.export report file="dsac$WKPID.ddl"
SHOW TABLE SYSBAR.DSAConnectionsTbl;
.export reset
.if errorcode<>0 then .quit 1
 
*** readable report
.set sidetitles on
.set foldline on
.os rm "dsac$WKPID.rpt"
.export report file="dsac$WKPID.rpt"
SELECT *
FROM SYSBAR.DSAConnectionsTbl
ORDER BY 1;
.export reset
.if errorcode<>0 then .quit 1
 
.set foldline off
.set sidetitles off
 
*** gen sql to re-populate table
.os rm -f "dsac$WKPID.sql"
.export report file="dsac$WKPID.sql"
SELECT  'INSERT INTO SYSBAR.DSAConnectionsTbl VALUES ('''
          ||TRIM(COALESCE(ActiveMQServer,''))
||''', '''||TRIM(COALESCE(Selector,''))
||''', '''||TRIM(COALESCE(SslJmsFlag,''))
||''', '''||TRIM(COALESCE(SslJmsKeyFName,''))
||''', '''||TRIM(COALESCE(SslJmsCertFName,''))
||''', '''||TRIM(COALESCE(SslJmsPassword,''))
||''', '''||TRIM(COALESCE(SslSktFlag,''))
||''', '''||TRIM(COALESCE(SslSktKeyFName,''))
||''', '''||TRIM(COALESCE(SslSktCertFName,''))
||''', '''||TRIM(COALESCE(SslSktPassword,''))
||''',   '||TRIM(COALESCE(JmsPortNumber,''))
||',   '''||TRIM(COALESCE(DscName,''))
||''', '''||TRIM(COALESCE(DsmainLoggingLevel,''))
||''', '''||TRIM(COALESCE(DSLJsonLoggingFlag,''))
||''', '''||TRIM(COALESCE(SslSktTruststoreFname,''))
||''');' (TITLE '')
FROM SYSBAR.DSAConnectionsTbl
ORDER BY 1;
.export reset
.if errorcode<>0 then .quit 1
.quit 0
 
EOF