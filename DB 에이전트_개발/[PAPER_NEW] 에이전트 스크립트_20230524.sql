USE [msdb]
GO

/****** Object:  Job [[★ 취합_1] (0시 10분) 지역별 게재띠 변경여부 확인 후 온라인 광고 게재띠 갱신]    Script Date: 2023-05-24 오후 1:02:12 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:12 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[★ 취합_1] (0시 10분) 지역별 게재띠 변경여부 확인 후 온라인 광고 게재띠 갱신', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [지역별 게재띠 변경여부 확인 후 온라인 광고 게재띠 갱신]    Script Date: 2023-05-24 오후 1:02:12 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'지역별 게재띠 변경여부 확인 후 온라인 광고 게재띠 갱신', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE BAT_LAYOUTCODE_CHANGE_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'지역별 게재띠 변경여부 확인 후 온라인 광고 게재띠 갱신', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=126, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20160424, 
		@active_end_date=99991231, 
		@active_start_time=1000, 
		@active_end_time=235959, 
		@schedule_uid=N'223b819d-617b-4677-bf55-3d536b37df5d'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[★ 취합_2] (0시 30분) 기간계 원데이터 취합 외]    Script Date: 2023-05-24 오후 1:02:12 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:12 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[★ 취합_2] (0시 30분) 기간계 원데이터 취합 외', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [전산센터 신문데이터 이관]    Script Date: 2023-05-24 오후 1:02:12 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'전산센터 신문데이터 이관', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 줄광고 데이터 이관 (최초 데이터 덤프)
EXECUTE DBO.BAT_UNIFICATION_ONDAYLINEAD_PROC

-- 인천줄박스 광고 중복을 제거하자 (테스트)
EXEC PAPER_NEW.dbo.BAT_INCHON_LINEBOXAD_DUP_CLEAR_PROC', 
		@database_name=N'UNILINEDB_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [박스광고 가져오기]    Script Date: 2023-05-24 오후 1:02:12 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'박스광고 가져오기', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=3, 
		@retry_interval=3, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBO.BAT_DAILY_BOX_DATA_PROC
', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [연합광고 처리]    Script Date: 2023-05-24 오후 1:02:12 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'연합광고 처리', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE DBO.EDIT_YUNHAB_BOXAD_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [게재띠/인터넷코드 매칭]    Script Date: 2023-05-24 오후 1:02:12 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'게재띠/인터넷코드 매칭', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_BOXAD_FINDCODE_LAYOUTCODE_MAPPING_PROC
GO', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'박스광고 데이터 반영', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=126, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20090316, 
		@active_end_date=99991231, 
		@active_start_time=3000, 
		@active_end_time=235959, 
		@schedule_uid=N'b078442e-2c01-4618-aa56-adffaae64627'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[★ 취합_3] (0시 50분) 신문 줄/박스광고 가져오기]    Script Date: 2023-05-24 오후 1:02:13 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:13 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[★ 취합_3] (0시 50분) 신문 줄/박스광고 가져오기', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[게재띠취합_1] 게재띠코드 (전날)데이터 백업]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[게재띠취합_1] 게재띠코드 (전날)데이터 백업', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'TRUNCATE TABLE LAYOUTCLASS_TOT_BACKUP_TB;

INSERT INTO LAYOUTCLASS_TOT_BACKUP_TB
(BRANCHCODE, SORTID, CLASSLEVEL, LINECOUNT, SECTIONCODE, HEADERCODE, HEADER, VIEWTEXT, CLASSCODEIN, CLASSTAILCODEIN, CLASSCODEAND, LAYOUTCODE1IN, LAYOUTCODE2IN, LAYOUTCODE3IN, ZIPTEXT, CHKPOINTF, LAYOUTNOF, LAYOUTID, ADULT)
SELECT BRANCHCODE, SORTID, CLASSLEVEL, LINECOUNT, SECTIONCODE, HEADERCODE, HEADER, VIEWTEXT, CLASSCODEIN, CLASSTAILCODEIN, CLASSCODEAND, LAYOUTCODE1IN, LAYOUTCODE2IN, LAYOUTCODE3IN, ZIPTEXT, CHKPOINTF, LAYOUTNOF, LAYOUTID, ADULT
FROM PAPER_NEW.dbo.LAYOUTCLASS_TOT', 
		@database_name=N'LAYOUTCLASSDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[게재띠취합_2] 게재띠 코드(전체) 취합]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[게재띠취합_2] 게재띠 코드(전체) 취합', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_REFLECT_LAYOUTCLASS_TOT_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[게재띠취합_3] 성인분류 게재띠 Flag 체크]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[게재띠취합_3] 성인분류 게재띠 Flag 체크', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_HEADERCODE_ADULT_CHECK_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[게재띠취합_4] 검색용 게제띠 데이타 만들기]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[게재띠취합_4] 검색용 게제띠 데이타 만들기', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--EXECUTE dbo.BAT_LAYOUTCLASS_MAKE_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [신버젼 데이터 가져오기]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'신버젼 데이터 가져오기', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBO.BAT_DAILY_PAPER_DATA_NEW_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [신문내용 특수문자 제거]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'신문내용 특수문자 제거', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE BAT_LINEAD_SPECIAL_WORD_REPLACE_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [연합광고 추출]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'연합광고 추출', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE DBO.EDIT_YUNHAB_LINEAD_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [성인분류 광고 성인체크]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'성인분류 광고 성인체크', 
		@step_id=8, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--성인광고 FLAG 삽입
EXECUTE dbo.BAT_LINEAD_ADULT_CHECK_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [게재띠 명칭 갱신]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'게재띠 명칭 갱신', 
		@step_id=9, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'UPDATE A
   SET A.LAYOUTCODENAME = CAST(B.VIEWTEXT AS VARCHAR(55))
  FROM TEMP_PP_LINE_AD_ORG_TB AS A
  JOIN [LAYOUTCLASS_TOT] AS B
    ON B.BRANCHCODE = A.LAYOUT_BRANCH
   AND B.HEADERCODE = A.LAYOUTCODE
 WHERE A.VERSION = ''N''', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [영업데이터 수정일이 큰 데이터건 추출]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'영업데이터 수정일이 큰 데이터건 추출', 
		@step_id=10, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_UPDATE_TARGET_AD_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [줄/박스광고 좌표 대상 입력]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'줄/박스광고 좌표 대상 입력', 
		@step_id=11, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_MAP_GRID_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [영업광고 광고관리데이터 이관]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'영업광고 광고관리데이터 이관', 
		@step_id=12, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=5, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 금일자 게재 영업데이터(줄,박스)를 PP_AD_TB로 이관
EXECUTE dbo.BAT_PP_AD_TB_TRANS_PROC
', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [영업광고 복제]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'영업광고 복제', 
		@step_id=13, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_COPY_LINEAD_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [영업데이터 유관 데이터 처리]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'영업데이터 유관 데이터 처리', 
		@step_id=14, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=5, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_AD_RELATION_DATA_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'신문데이터 스케줄 반영일정', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=126, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20120117, 
		@active_end_date=99991231, 
		@active_start_time=5000, 
		@active_end_time=235959, 
		@schedule_uid=N'21cc096c-61c6-483b-ba32-0a367ae1b16d'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[★ 취합_4] (3시 2분) 게재데이터 이관]    Script Date: 2023-05-24 오후 1:02:13 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:13 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[★ 취합_4] (3시 2분) 게재데이터 이관', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [영업광고/온라인 게재데이터 최종 이관]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'영업광고/온라인 게재데이터 최종 이관', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=5, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE BAT_TRANS_PP_LINE_AD_TB_PROC
', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [비유효데이터 삭제 작업외 데이터 정리]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'비유효데이터 삭제 작업외 데이터 정리', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 사용자 광고 스크랩 정리 (종료된 광고에 대한 스크랩 내역 삭제)
EXECUTE dbo.BAT_DROP_USER_SCRAP_PROC;

-- 관리서브테이블 비유효데이터 삭제 작업
EXECUTE dbo.BAT_DEL_PP_AD_TB_BEFORE_6_MONTH_PAPER', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[미사용] 부동산써브에 신문줄광고 전송 --2018-09-11 제외처리]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[미사용] 부동산써브에 신문줄광고 전송 --2018-09-11 제외처리', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--EXECUTE dbo.BAT_DAILY_LINEAD_TO_SERVE_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [부동산써브 매물 이관]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'부동산써브 매물 이관', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_ADD_SERVE_LINEAD_COMMON_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [지도좌표 이관]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'지도좌표 이관', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=5, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_EDIT_MAP_POINT_TRANS_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [부동산전용_게재데이터_생성]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'부동산전용_게재데이터_생성', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=5, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBO.BAT_INPUT_LINE_AD_LAND_TB_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [부동산 중개업소홍보_게재데이터_ 생성]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'부동산 중개업소홍보_게재데이터_ 생성', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=5, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BAT_PP_LINE_AD_LAND_PROMOTION_TB_TRANS_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [부동산_직거래관리_데이터 추출]    Script Date: 2023-05-24 오후 1:02:13 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'부동산_직거래관리_데이터 추출', 
		@step_id=8, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BAT_PP_HOUSE_FILTER_DATA_TB_INPUT_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [분류별 줄광고수 갱신]    Script Date: 2023-05-24 오후 1:02:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'분류별 줄광고수 갱신', 
		@step_id=9, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 분류별 줄광고수 갱신 (전국판)
EXECUTE dbo.EXEC_CATEGORY_LINEAD_COUNT_PROC

-- 분류별 줄광고수 갱신 (지역판)
EXECUTE dbo.EXEC_CATEGORY_LINEAD_LOCAL_COUNT_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [알바천국 동시 구매 공고 이관]    Script Date: 2023-05-24 오후 1:02:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'알바천국 동시 구매 공고 이관', 
		@step_id=10, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_GATHER_PN_ALBA_AD_GOODS_PAPER_PUBLISH_TRANS_PROC', 
		@database_name=N'PARTNERSHIP', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [중개사법관련 업데이트]    Script Date: 2023-05-24 오후 1:02:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'중개사법관련 업데이트', 
		@step_id=11, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_UPDATE_ESTATE_LAW_ACTION_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[★ 취합_4] 게재데이터 이관', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=126, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20140424, 
		@active_end_date=99991231, 
		@active_start_time=30200, 
		@active_end_time=235959, 
		@schedule_uid=N'0701a092-a8d2-4415-9dc9-c0d6dc3b9faf'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[★ 취합_5] (4시 30분) 모바일 일배치 1.PAPER_NEW DATABASE RESTORE]    Script Date: 2023-05-24 오후 1:02:14 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:14 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[★ 취합_5] (4시 30분) 모바일 일배치 1.PAPER_NEW DATABASE RESTORE', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [PAPER_NEW MOBILE DATA RESET - JOB]    Script Date: 2023-05-24 오후 1:02:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'PAPER_NEW MOBILE DATA RESET - JOB', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=4, 
		@on_fail_step_id=5, 
		@retry_attempts=3, 
		@retry_interval=3, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC MOBILE_BAT_SET_MOBILEDATA', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [PAPER_NEW MOBILE DATA RESET - REALTY]    Script Date: 2023-05-24 오후 1:02:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'PAPER_NEW MOBILE DATA RESET - REALTY', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=4, 
		@on_fail_step_id=5, 
		@retry_attempts=3, 
		@retry_interval=3, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC MOBILE_BAT_SET_MOBILEDATA_REALTY', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [테마리스트 갱신]    Script Date: 2023-05-24 오후 1:02:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'테마리스트 갱신', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=4, 
		@on_fail_step_id=5, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC MOBILE_THEME_LIST_BATCH', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [기타 배치작업]    Script Date: 2023-05-24 오후 1:02:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'기타 배치작업', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=4, 
		@on_fail_step_id=5, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec MOBILE_BAT_SET_ETC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [작업실패에 따른 SMS 전송]    Script Date: 2023-05-24 오후 1:02:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'작업실패에 따른 SMS 전송', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01022170355'',''[FAIL BAT] PAPER_NEW DATABASE RESTORE'' -- 성소영
EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01087798662'',''[FAIL BAT] PAPER_NEW DATABASE RESTORE'' -- 조재성
EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01033931420'',''[FAIL BAT] PAPER_NEW DATABASE RESTORE'' -- 이근우
', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'일1회_0430시행', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20140128, 
		@active_end_date=99991231, 
		@active_start_time=43015, 
		@active_end_time=235959, 
		@schedule_uid=N'ea54a39a-62f4-4303-b55c-da210479c339'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[★ 취합_6]  (4시 50분) 제휴사 데이터 이관]    Script Date: 2023-05-24 오후 1:02:14 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:14 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[★ 취합_6]  (4시 50분) 제휴사 데이터 이관', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'- 알바천국
- 워크넷





', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [제휴사 모든 데이터 이관 (1차)]    Script Date: 2023-05-24 오후 1:02:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'제휴사 모든 데이터 이관 (1차)', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=2, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_GATHER_PN_PAPER_TRANS_PROC 1, 0', 
		@database_name=N'PARTNERSHIP', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'제휴사 모든 데이터 이관 (1차)', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20040404, 
		@active_end_date=99991231, 
		@active_start_time=45000, 
		@active_end_time=235959, 
		@schedule_uid=N'b158b355-7001-49a1-ad1d-693eb4c3d85b'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[★ 취합_6-1] (7시 30분, 12시 30분) 전문관 공고 가져오기]    Script Date: 2023-05-24 오후 1:02:15 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:15 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[★ 취합_6-1] (7시 30분, 12시 30분) 전문관 공고 가져오기', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [구인 전문관 공고 가져오기]    Script Date: 2023-05-24 오후 1:02:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'구인 전문관 공고 가져오기', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=2, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_FJ_구인_전문관_공고_가져오기_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [주요테이블 조각모음]    Script Date: 2023-05-24 오후 1:02:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'주요테이블 조각모음', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BAT_DBA_INDEX_DEFRAG_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [주요테이블 통계정보 업데이트]    Script Date: 2023-05-24 오후 1:02:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'주요테이블 통계정보 업데이트', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BAT_DBA_UPDATE_STATISTICS_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[구인] 전문관 공고 가져오기', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=5, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20171107, 
		@active_end_date=99991231, 
		@active_start_time=73000, 
		@active_end_time=150059, 
		@schedule_uid=N'f8b9060a-a457-46b4-a678-f3fbc7b89ca4'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[★ 취합_6-2] (7시36분) 무료 브랜드관 광고 가져오기]    Script Date: 2023-05-24 오후 1:02:15 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:15 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[★ 취합_6-2] (7시36분) 무료 브랜드관 광고 가져오기', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'무료 브랜드관 광고 가져오기', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [무료 브랜드관 광고 가져오기]    Script Date: 2023-05-24 오후 1:02:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'무료 브랜드관 광고 가져오기', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=2, 
		@retry_interval=3, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_BRAND_FREE_AD_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [브랜드관 메인 데이터 만들기]    Script Date: 2023-05-24 오후 1:02:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'브랜드관 메인 데이터 만들기', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=2, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_F_MAIN_BRAND_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'무료 브랜드관 광고 가져오기', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=4, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20140822, 
		@active_end_date=99991231, 
		@active_start_time=73600, 
		@active_end_time=73500, 
		@schedule_uid=N'25978c7b-ae2a-4473-a3fa-25f303b965c7'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[LOG 백업] [02:30]각종 LOG 백업]    Script Date: 2023-05-24 오후 1:02:15 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:15 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[LOG 백업] [02:30]각종 LOG 백업', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [부동산 다량등록권 공고 삭제 후 종료 2개월 지난 공고 백업 & 삭제]    Script Date: 2023-05-24 오후 1:02:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'부동산 다량등록권 공고 삭제 후 종료 2개월 지난 공고 백업 & 삭제', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
INSERT LOGDB.DBO.PP_AD_TB_HOUSE_DEL_BACKUP 
select * FROM PP_AD_TB WITH(NOLOCK)
where VERSION=''E''and GROUP_CD =13 and PAY_FREE = 1 
and DELYN =''Y'' and END_DT < GETDATE() -60

delete FROM PP_AD_TB 
where VERSION=''E''and GROUP_CD =13 and PAY_FREE = 1 
and DELYN =''Y'' and END_DT < GETDATE() -60', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [부동산써브 임시데이터 삭제]    Script Date: 2023-05-24 오후 1:02:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'부동산써브 임시데이터 삭제', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'delete FROM PP_AD_TB 
where VERSION=''C'' and GROUP_CD = 13 ', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [(미사용)통합검색 검색로그(쿠키) 백업 - SEARCH_USER_COOKIES_GROUP_TB]    Script Date: 2023-05-24 오후 1:02:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'(미사용)통합검색 검색로그(쿠키) 백업 - SEARCH_USER_COOKIES_GROUP_TB', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/* 
EXEC BAT_SEARCH_USER_COOKIES_GROUP_TB_BACKUP_PROC
*/', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [상세조회로그 삭제 (30일 이전) - PP_AD_READ_COUNT_LOG_TB]    Script Date: 2023-05-24 오후 1:02:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'상세조회로그 삭제 (30일 이전) - PP_AD_READ_COUNT_LOG_TB', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @A INT = 1
DECLARE @AA INT = 0 
WHILE @A <> 0 AND @AA < 200
BEGIN
SET ROWCOUNT 10000
DELETE  FROM MWDB.DBO.PP_AD_READ_COUNT_LOG_TB 
WHERE REG_DT < CONVERT(VARCHAR(10),GETDATE() -59,120) AND REG_DT >=CONVERT(VARCHAR(10),GETDATE() -60,120)

SET @A = @@ROWCOUNT 
SET @AA = @AA + 1
END

/* LOCK으로 인해 만건 단위로 삭제  한꺼번에 삭제시 200초 => 분리삭제시 100초 */', 
		@database_name=N'MWDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [요청게시판 회원 정보수정 문의 삭제]    Script Date: 2023-05-24 오후 1:02:16 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'요청게시판 회원 정보수정 문의 삭제', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'delete
 FROM dbo.BOARD_MAIN_TB
where bidx = 1
and code = 6
and regdt <getdate() - 90', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [부정 클릭 탐지 로그 테이블 1달전 데이터 삭제]    Script Date: 2023-05-24 오후 1:02:16 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'부정 클릭 탐지 로그 테이블 1달전 데이터 삭제', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [LOGDB].[dbo].[BAT_BAD_CLICK_IP_TB_DEL_PROC]', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'매일 2시반? 일정 변경 가능', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20160615, 
		@active_end_date=99991231, 
		@active_start_time=23000, 
		@active_end_time=235959, 
		@schedule_uid=N'edacb3af-d197-4687-9a21-e7aff44c3064'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[LOG] (월1회)어플 접속 로그 삭제]    Script Date: 2023-05-24 오후 1:02:16 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:16 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[LOG] (월1회)어플 접속 로그 삭제', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'아이폰/안드로이드 어플 접속 카운트 로그 자료 삭제(월 1회)', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [로그 데이타 삭제]    Script Date: 2023-05-24 오후 1:02:16 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'로그 데이타 삭제', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DEL_AP_ACCESS_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'어플 접속 로그 삭제', 
		@enabled=1, 
		@freq_type=16, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20130612, 
		@active_end_date=99991231, 
		@active_start_time=3000, 
		@active_end_time=235959, 
		@schedule_uid=N'37f13f4d-af2c-4b34-ac16-10061694e736'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[LOG] 리스트업 로그 삭제]    Script Date: 2023-05-24 오후 1:02:16 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:16 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[LOG] 리스트업 로그 삭제', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [리스트업 로그 삭제]    Script Date: 2023-05-24 오후 1:02:16 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'리스트업 로그 삭제', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 리스트업 로그

DELETE 
-- SELECT COUNT(*)
  FROM MWDB.DBO.LISTUP_LOG
 WHERE LINEADNO IN (
    SELECT LINEADNO
      FROM PP_AD_TB
     WHERE END_DT = CONVERT(VARCHAR(10), DATEADD(DAY, -30, GETDATE()), 120)
       AND GROUP_CD IN (13, 14)
)

-- 리스트업 에러 로그

DELETE 
-- SELECT COUNT(*)
  FROM MWDB.DBO.LISTUP_ERROR_LOG
 WHERE LINEADNO IN (
    SELECT LINEADNO
      FROM PP_AD_TB
     WHERE END_DT = CONVERT(VARCHAR(10), DATEADD(DAY, -30, GETDATE()), 120)
       AND GROUP_CD IN (13, 14)
)', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'리스트업 로그 삭제', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20160222, 
		@active_end_date=99991231, 
		@active_start_time=40533, 
		@active_end_time=235959, 
		@schedule_uid=N'f7f7dddd-54ae-4f44-bf06-d8a25312ee15'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[LOG] 부정클릭 모니터링 및 추출]    Script Date: 2023-05-24 오후 1:02:16 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:16 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[LOG] 부정클릭 모니터링 및 추출', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'LOGDB.DBO.BAT_BAD_CLICK_IP_TB_INS_PROC', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [부정클릭 IP 추출 분당 20회]    Script Date: 2023-05-24 오후 1:02:16 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'부정클릭 IP 추출 분당 20회', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'LOGDB.DBO.BAT_BAD_CLICK_IP_TB_INS_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'매일 5분단위', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=3, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20180629, 
		@active_end_date=99991231, 
		@active_start_time=300, 
		@active_end_time=235959, 
		@schedule_uid=N'c39337eb-c6d2-43a6-872f-ebe325e4c16d'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT] (00시 00분 매주) 에러로그 순환]    Script Date: 2023-05-24 오후 1:02:16 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:17 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT] (00시 00분 매주) 에러로그 순환', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1]    Script Date: 2023-05-24 오후 1:02:17 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec sp_cycle_errorlog', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=2, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20211220, 
		@active_end_date=99991231, 
		@active_start_time=100, 
		@active_end_time=235959, 
		@schedule_uid=N'77876b9c-261e-4567-9f45-d2f26b8203e7'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT] (05시10분) 로그삭제]    Script Date: 2023-05-24 오후 1:02:17 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:17 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT] (05시10분) 로그삭제', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'CFM\onsdb', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1.API_CALL_LOG_TB]    Script Date: 2023-05-24 오후 1:02:17 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1.API_CALL_LOG_TB', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_API_CALL_LOG_TB_PROC', 
		@database_name=N'PARTNERSHIP', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [2. MOBILE_PUSH_INFO_DETAIL]    Script Date: 2023-05-24 오후 1:02:17 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'2. MOBILE_PUSH_INFO_DETAIL', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_MOBILE_PUSH_INFO_DETAIL_PROC', 
		@database_name=N'MOBILE_SERVICE', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [3. MOBILE_PUSH_RESULT]    Script Date: 2023-05-24 오후 1:02:17 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'3. MOBILE_PUSH_RESULT', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_MOBILE_PUSH_RESULT_PROC', 
		@database_name=N'MOBILE_SERVICE', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [4.MOBILE_PUSH_RESULT_REALTIME]    Script Date: 2023-05-24 오후 1:02:17 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'4.MOBILE_PUSH_RESULT_REALTIME', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_MOBILE_PUSH_RESULT_REALTIME_PROC', 
		@database_name=N'MOBILE_SERVICE', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [5.MOBILE_FINDALL_CALL_CHECK]    Script Date: 2023-05-24 오후 1:02:17 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'5.MOBILE_FINDALL_CALL_CHECK', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_MOBILE_FINDALL_CALL_CHECK_PROC', 
		@database_name=N'MOBILE_STATISTICS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [6. PP_SESSION_COUNT_TB]    Script Date: 2023-05-24 오후 1:02:17 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'6. PP_SESSION_COUNT_TB', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_PP_SESSION_COUNT_TB_PROC', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [7. PP_AD_READ_COUNT_LOG_DATA_TB]    Script Date: 2023-05-24 오후 1:02:17 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'7. PP_AD_READ_COUNT_LOG_DATA_TB', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec BAT_DEL_PP_AD_READ_COUNT_LOG_DATA_TB_PROC', 
		@database_name=N'STATS_JOB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [8.MOBILE_JOB_TEMPSAVE_TB]    Script Date: 2023-05-24 오후 1:02:17 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'8.MOBILE_JOB_TEMPSAVE_TB', 
		@step_id=8, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_MOBILE_JOB_TEMPSAVE_TB_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [9. DEL_LISTUP_LOG]    Script Date: 2023-05-24 오후 1:02:17 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'9. DEL_LISTUP_LOG', 
		@step_id=9, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_LISTUP_LOG_PROC', 
		@database_name=N'MWDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [10.MT_WEBERROR_TB]    Script Date: 2023-05-24 오후 1:02:17 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'10.MT_WEBERROR_TB', 
		@step_id=10, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec BAT_MT_WEBERROR_TB_PROC', 
		@database_name=N'MWDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [11. PP_JOB_BANNER_HIT_LOG_TB]    Script Date: 2023-05-24 오후 1:02:17 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'11. PP_JOB_BANNER_HIT_LOG_TB', 
		@step_id=11, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_PP_JOB_BANNER_HIT_LOG_TB_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [12. MT_WEBERROR_404_TB]    Script Date: 2023-05-24 오후 1:02:17 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'12. MT_WEBERROR_404_TB', 
		@step_id=12, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_MT_WEBERROR_404_TB_PROC', 
		@database_name=N'MWDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [13. pkey 인서트]    Script Date: 2023-05-24 오후 1:02:17 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'13. pkey 인서트', 
		@step_id=13, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec BAT_PUT_PKEY_forDel_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [14. PP_LINE_AD_AREA_TB_LOG]    Script Date: 2023-05-24 오후 1:02:18 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'14. PP_LINE_AD_AREA_TB_LOG', 
		@step_id=14, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_PP_LINE_AD_AREA_TB_LOG_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [15. PP_LINE_AD_EXTEND_DETAIL_JOB_TB_LOG]    Script Date: 2023-05-24 오후 1:02:18 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'15. PP_LINE_AD_EXTEND_DETAIL_JOB_TB_LOG', 
		@step_id=15, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_PP_LINE_AD_EXTEND_DETAIL_JOB_TB_LOG_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [16. PP_LINE_AD_FINDCODE_TB_LOG]    Script Date: 2023-05-24 오후 1:02:18 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'16. PP_LINE_AD_FINDCODE_TB_LOG', 
		@step_id=16, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_PP_LINE_AD_FINDCODE_TB_LOG_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [17. PP_LINE_AD_EXTEND_DETAIL_TB_LOG]    Script Date: 2023-05-24 오후 1:02:18 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'17. PP_LINE_AD_EXTEND_DETAIL_TB_LOG', 
		@step_id=17, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_PP_LINE_AD_EXTEND_DETAIL_TB_LOG_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [18. PP_AD_SUBWAY_DATA_TB_LOG]    Script Date: 2023-05-24 오후 1:02:18 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'18. PP_AD_SUBWAY_DATA_TB_LOG', 
		@step_id=18, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_PP_AD_SUBWAY_DATA_TB_LOG_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [19. PP_AD_EC_DATA_JOB_TB_LOG]    Script Date: 2023-05-24 오후 1:02:18 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'19. PP_AD_EC_DATA_JOB_TB_LOG', 
		@step_id=19, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_PP_AD_EC_DATA_JOB_TB_LOG_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [20. PP_LOGO_OPTION_TB_LOG]    Script Date: 2023-05-24 오후 1:02:18 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'20. PP_LOGO_OPTION_TB_LOG', 
		@step_id=20, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_PP_LOGO_OPTION_TB_LOG_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [21. PP_JOB_AD_TEMPLATE_TB_LOG]    Script Date: 2023-05-24 오후 1:02:18 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'21. PP_JOB_AD_TEMPLATE_TB_LOG', 
		@step_id=21, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_PP_JOB_AD_TEMPLATE_TB_LOG_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [22. PP_JOB_ADVANTAGE_TB_LOG]    Script Date: 2023-05-24 오후 1:02:18 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'22. PP_JOB_ADVANTAGE_TB_LOG', 
		@step_id=22, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_PP_JOB_ADVANTAGE_TB_LOG_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [23. PP_AD_TB_LOG]    Script Date: 2023-05-24 오후 1:02:18 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'23. PP_AD_TB_LOG', 
		@step_id=23, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_PP_AD_TB_LOG_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [24.PP_CARDEALER_PR_TB 성파트장님02/24요청]    Script Date: 2023-05-24 오후 1:02:18 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'24.PP_CARDEALER_PR_TB 성파트장님02/24요청', 
		@step_id=24, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_PP_CARDEALER_PR_TB_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20220126, 
		@active_end_date=99991231, 
		@active_start_time=51100, 
		@active_end_time=235959, 
		@schedule_uid=N'4e88425b-e577-4dbe-9d49-44220e573b59'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT] (07시) 이벤트 참여자정보 파기]    Script Date: 2023-05-24 오후 1:02:18 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:18 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT] (07시) 이벤트 참여자정보 파기', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'CFM\onsdb', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1. 이벤트 참여자 정보 파기]    Script Date: 2023-05-24 오후 1:02:18 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1. 이벤트 참여자 정보 파기', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_MOBILE_EVENT_ENTRY_TB_PROC', 
		@database_name=N'MOBILE_SERVICE', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1.일정', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20220510, 
		@active_end_date=99991231, 
		@active_start_time=70100, 
		@active_end_time=235959, 
		@schedule_uid=N'43859b78-e441-40c5-94be-227cf73a91cf'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT] (11시) DB 프로파일링 모니터링 시작 - STEP1]    Script Date: 2023-05-24 오후 1:02:18 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:18 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT] (11시) DB 프로파일링 모니터링 시작 - STEP1', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'CPU 모니터링 추가 (매일 11:00 ~12:00)', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [BAT_PROFILER_MONITORING_CPU1000_PROC]    Script Date: 2023-05-24 오후 1:02:18 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'BAT_PROFILER_MONITORING_CPU1000_PROC', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BAT_PROFILER_MONITORING_CPU1000_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'오전11시 실행', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20160113, 
		@active_end_date=99991231, 
		@active_start_time=110000, 
		@active_end_time=235959, 
		@schedule_uid=N'8e95f833-d5df-4c02-8703-7a5545a5cb6c'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT] (12시 15분) DB 프로파일링 모니터링 중지 - STEP2]    Script Date: 2023-05-24 오후 1:02:18 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:18 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT] (12시 15분) DB 프로파일링 모니터링 중지 - STEP2', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'11시에 시작되는 CPU 모니터링 중지 처리 (최대 트래픽 시간 1시간 만 모니터링함)', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [트래킹 중지]    Script Date: 2023-05-24 오후 1:02:18 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'트래킹 중지', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_PROFILER_MONITORING_STOP_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'12시15분 중지', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20160113, 
		@active_end_date=99991231, 
		@active_start_time=121500, 
		@active_end_time=235959, 
		@schedule_uid=N'a35a2488-d43f-4e93-8a0d-507b5b0c0494'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT] (4시)PUSH스케쥴 (일단위통계테이블I,D)]    Script Date: 2023-05-24 오후 1:02:19 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:19 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT] (4시)PUSH스케쥴 (일단위통계테이블I,D)', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1.PUSH스케쥴]    Script Date: 2023-05-24 오후 1:02:19 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1.PUSH스케쥴', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_PUSH_REALTIME_STATS', 
		@database_name=N'MOBILE_SERVICE', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20220608, 
		@active_end_date=99991231, 
		@active_start_time=40100, 
		@active_end_time=235959, 
		@schedule_uid=N'a76b6f5f-88c1-40c4-816a-d5540b88aeca'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT] (매월 01일 오전_05시) 5년 이상 경과한 탈퇴회원 데이터 삭제]    Script Date: 2023-05-24 오후 1:02:19 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:19 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT] (매월 01일 오전_05시) 5년 이상 경과한 탈퇴회원 데이터 삭제', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'CFM\onsdb', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [DROP_BAK_TABLE]    Script Date: 2023-05-24 오후 1:02:19 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'DROP_BAK_TABLE', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC dbo.USP_DROP_BAK_TABLE', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [PAPER_NEW 삭제]    Script Date: 2023-05-24 오후 1:02:19 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'PAPER_NEW 삭제', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBA.dbo.USP_DEL_OUTMEMBER_PAPER_NEW', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [PAPER_REG 삭제]    Script Date: 2023-05-24 오후 1:02:19 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'PAPER_REG 삭제', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBA.dbo.USP_DEL_OUTMEMBER_PAPER_REG', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [작업결과count 메일 발송]    Script Date: 2023-05-24 오후 1:02:19 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'작업결과count 메일 발송', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE DBA
GO

DECLARE @result TABLE (
  TO_DEL_DATE DATE NOT NULL,
  DB_NAME varchar(20) NOT NULL,
  TABLE_NAME VARCHAR(50) NOT NULL,
  CNT int NOT NULL,
  JOB_EXEC_DATE DATETIME NOT NULL
)
DECLARE @resultHTML  NVARCHAR(MAX)
DECLARE @date date = GETDATE() 
DECLARE @subject NVARCHAR(100) 

SET @subject = N''[Job] 탈퇴회원 데이터 삭제 작업 결과 공유의 건['' + CONVERT(NVARCHAR(10), @date, 120) + '']''

INSERT @result
EXEC DBA.dbo.USP_SEL_OUTMEMBER_DEL_COUNT @date

SET @resultHTML =  
    N''<H4>탈퇴회원 데이터 삭제 작업 결과 Report [''+ CONVERT(NVARCHAR(10), @date, 120) + N'' ]</H4>'' +  
    N''<table border="1" cellpadding="0" width="100%">'' +  
    N''<tr><th>~까지삭제</th><th>DB Name</th>'' +  
    N''<th>Table Name</th><th>로우수</th><th>작업 일시</th></tr>'' +  
    CAST ( ( SELECT td = TO_DEL_DATE,       '''',  
                    td = DB_NAME, '''',  
                    td = TABLE_NAME, '''',  
                    td = CNT, '''',  
                    td = JOB_EXEC_DATE
              FROM @result as wo  
              FOR XML PATH(''tr''), TYPE   
    ) AS NVARCHAR(MAX) ) +  
    N''</table>'' ;  
--SELECT @resultHTML

EXEC msdb.dbo.sp_send_dbmail @profile_name = ''DBAMAIL''
	, @recipients = ''ciiciicii@mediawill.com; got@mediawill.com''
	, @subject = ''탈퇴회원 데이터 삭제 작업 결과''
	, @body_format = ''html''
	, @body = @resultHTML;
', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[MGMT] (매월 01일 오전 05시) 5년 이상 경과한 탈퇴회원 데이터 삭제', 
		@enabled=1, 
		@freq_type=16, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=16, 
		@freq_recurrence_factor=1, 
		@active_start_date=20201124, 
		@active_end_date=99991231, 
		@active_start_time=50000, 
		@active_end_time=235959, 
		@schedule_uid=N'bd6a5c05-246d-424d-8dc4-08faf272264e'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT] (매일 오전_05시 10분) DEVICE 정보 삭제]    Script Date: 2023-05-24 오후 1:02:19 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:19 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT] (매일 오전_05시 10분) DEVICE 정보 삭제', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'CFM\onsdb', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1. DEVICE 정보 삭제]    Script Date: 2023-05-24 오후 1:02:19 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1. DEVICE 정보 삭제', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec MOBILE_SERVICE.dbo.BAT_MOBILE_PUSH_DEVICE_INFO_DEL_PROC', 
		@database_name=N'MOBILE_SERVICE', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'DEVICE 정보 삭제', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20211125, 
		@active_end_date=99991231, 
		@active_start_time=51000, 
		@active_end_time=235959, 
		@schedule_uid=N'a4d3fb98-acec-46a0-ad81-5e1aa1730532'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT] (매일 오후 17시) 로그 테이블 (개인정보) 삭제]    Script Date: 2023-05-24 오후 1:02:19 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:19 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT] (매일 오후 17시) 로그 테이블 (개인정보) 삭제', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1. 벼룩시장 정기 메일 발송 로그 삭제]    Script Date: 2023-05-24 오후 1:02:19 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1. 벼룩시장 정기 메일 발송 로그 삭제', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_SEND_MAIL_DAILY_LOG_TB_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [2. 벼룩시장 맞춤 정보 메일 발송 로그 삭제]    Script Date: 2023-05-24 오후 1:02:20 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'2. 벼룩시장 맞춤 정보 메일 발송 로그 삭제', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_TEMP_FINDJOB_DAILY_SEND_MAIL_LOG_TB_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20220117, 
		@active_end_date=99991231, 
		@active_start_time=170000, 
		@active_end_time=235959, 
		@schedule_uid=N'55c6028b-7e32-43cf-a330-532d7bde255a'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT] DB 스케쥴 오류 취합 (10분간격)]    Script Date: 2023-05-24 오후 1:02:20 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:20 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT] DB 스케쥴 오류 취합 (10분간격)', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'EXEC PAPER_NEW.DBO.BAT_MT_DBJOB_FAILURE_TB_INS_PROC', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [DB스케쥴 오류 취합]    Script Date: 2023-05-24 오후 1:02:20 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'DB스케쥴 오류 취합', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC PAPER_NEW.DBO.BAT_MT_DBJOB_FAILURE_TB_INS_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'BAT_MT_DBJOB_FAILURE_TB_INS_PROC', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=10, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20140318, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'7b5fc17b-14da-4401-ab94-25153620d481'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT] RECCHARGE 테이블 모니터링(3분간격)]    Script Date: 2023-05-24 오후 1:02:20 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:20 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT] RECCHARGE 테이블 모니터링(3분간격)', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'1. PP_ECOMM_RECCHARGE_TB에 COMMENT에 결제금액 변조 관련 ROW가 발생하면 알림', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [3분 단위]    Script Date: 2023-05-24 오후 1:02:20 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'3분 단위', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_PP_ECOMM_RECCHARGE_TB_MONITORING_PROC ', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'3분단위', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=3, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20151222, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'9f367ffd-5046-4cdb-af07-721eb31f970b'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT] WEB 오류 모니터링 & 개인화 IP 필터링 추가(3분간격)]    Script Date: 2023-05-24 오후 1:02:20 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:20 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT] WEB 오류 모니터링 & 개인화 IP 필터링 추가(3분간격)', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'[MGMT] WEB 오류 모니터링 BAT_MT_WEBERROR_TB_MONITORING_PROC', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [3분 단위]    Script Date: 2023-05-24 오후 1:02:20 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'3분 단위', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BAT_MT_WEBERROR_TB_MONITORING_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [개인화 IP 필터링 대상 추출 & 추가]    Script Date: 2023-05-24 오후 1:02:20 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'개인화 IP 필터링 대상 추출 & 추가', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'LOGDB.DBO.BAT_PERSONAL_LINEAD_LOG_IPFILTER_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'3분단위', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=3, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20141128, 
		@active_end_date=99991231, 
		@active_start_time=40000, 
		@active_end_time=25959, 
		@schedule_uid=N'32f203ef-4e1e-49f8-95d3-a94aeb59008d'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT] 세션저장]    Script Date: 2023-05-24 오후 1:02:20 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:20 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT] 세션저장', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'DB세션 모니터링 스케쥴 / 보관주기 [3주]', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1]    Script Date: 2023-05-24 오후 1:02:21 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 현재 세션 저장
insert into dba.dbo.db_session_info
SELECT 
 getdate() [insert_time]
,SPID=s.session_id
,Blkd= r.blocking_session_id
, Elasped =r.total_elapsed_time/1000
, wait =r.wait_time/1000
, Start = r.start_time
, cpu_time = r.cpu_time/1000
, tx=r.open_transaction_count
,Login =s.login_name
, host_name =s.program_name
, host_name as host_name2
,dbname=db_name(r.database_id)
, sql=substring(s2.text,statement_start_offset/2, ((case when  statement_end_offset =-1 then (len(convert(nvarchar(max), s2.text))*2)  else statement_end_offset end)- statement_start_offset)/2)
,cmd=rtrim(r.command)
, status=convert(varchar(10),r.status)
--,
,type =r.last_wait_type
, wait_resource = rtrim(r.wait_resource),r.reads
, r.writes
, login_time= s.login_time
from sys.dm_exec_sessions s (nolock) join sys.dm_exec_requests r (nolock)
on s.session_id = r.session_id outer apply sys.dm_exec_sql_text(r.sql_handle) s2
where s.session_id >50
and r.status !=''backgroud'' and r.last_wait_type != ''SP_SERVER_DIAGNOSTICS_SLEEP''
;


/*
-- 모든 세션 저장
insert into dba.dbo.db_session_info
SELECT 
 getdate() [insert_time]
,SPID=s.session_id
,Blkd= r.blocking_session_id
, Elasped =r.total_elapsed_time/1000
, wait =r.wait_time/1000
, Start = r.start_time
, cpu_time = r.cpu_time/1000
, tx=r.open_transaction_count
,Login =s.login_name
, host_name =s.program_name
, host_name as host_name2
,dbname=db_name(r.database_id)
, sql=substring(s2.text,statement_start_offset/2, ((case when  statement_end_offset =-1 then (len(convert(nvarchar(max), s2.text))*2)  else statement_end_offset end)- statement_start_offset)/2)
,cmd=rtrim(r.command)
, status=convert(varchar(10),r.status)
--,
,type =r.last_wait_type
, wait_resource = rtrim(r.wait_resource),r.reads
, r.writes
, login_time= s.login_time
from sys.dm_exec_sessions s (nolock) left join sys.dm_exec_requests r (nolock)
on s.session_id = r.session_id outer apply sys.dm_exec_sql_text(r.sql_handle) s2
;
*/


-- 3주 경과된 데이터 삭제
delete from [dba].[dbo].[db_session_info]
where insert_time < dateadd(week, -3, getdate())
;', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20220921, 
		@active_end_date=99991231, 
		@active_start_time=60000, 
		@active_end_time=55900, 
		@schedule_uid=N'b16e8f0e-a5b5-4282-af74-3bfb5cad0845'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT](06시) DB Size 체크]    Script Date: 2023-05-24 오후 1:02:21 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 2023-05-24 오후 1:02:21 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT](06시) DB Size 체크', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'매일 6시에 DB별 Size 체크하여 Insert 함', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'CFM\onsdb', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [각 DB 별 사이즈 체크 및 Insert]    Script Date: 2023-05-24 오후 1:02:21 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'각 DB 별 사이즈 체크 및 Insert', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBA.dbo.USP_INS_DBSize', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [전체 DB File 정보 Insert]    Script Date: 2023-05-24 오후 1:02:21 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'전체 DB File 정보 Insert', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBA.dbo.USP_INS_DBFileSize', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'매일06시한번', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20201207, 
		@active_end_date=99991231, 
		@active_start_time=60000, 
		@active_end_time=235959, 
		@schedule_uid=N'3171a775-81cd-4b03-9d64-79ba7771a33d'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT](0시0분)계정트래킹]    Script Date: 2023-05-24 오후 1:02:21 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:21 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT](0시0분)계정트래킹', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [계정트래킹]    Script Date: 2023-05-24 오후 1:02:22 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'계정트래킹', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BAT_TRACESQL_DEV_PROC', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'계정트래킹', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20181219, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'b9316d8a-58d7-4b39-b35e-ef24f4605b2f'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT](매시 22분) 통계 업데이트 - PAPER_NEW - DB]    Script Date: 2023-05-24 오후 1:02:22 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:22 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT](매시 22분) 통계 업데이트 - PAPER_NEW - DB', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'[MGMT] 통계 업데이트 - PAPER_NEW - DB', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [PAPER_NEW 통계 수동 업데이트]    Script Date: 2023-05-24 오후 1:02:22 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'PAPER_NEW 통계 수동 업데이트', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBO.BAT_DBA_UPDATE_STATISTICS_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'통계 수동 업데이트 (주요 테이블)', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20181024, 
		@active_end_date=99991231, 
		@active_start_time=42200, 
		@active_end_time=23059, 
		@schedule_uid=N'1ec0f5d9-61be-4e17-a8d0-7478df652260'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT][DB모니터링] TRACE 수집_전체시간]    Script Date: 2023-05-24 오후 1:02:22 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:22 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT][DB모니터링] TRACE 수집_전체시간', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [TRACE 수집]    Script Date: 2023-05-24 오후 1:02:23 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'TRACE 수집', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
/*
-- Trace 종료
exec sp_trace_setstatus 6, 0	--지정한 추적을 중지
exec sp_trace_setstatus 6, 2	--지정한 추적을 닫고 서버에서 해당 정의를 삭제
go

-- 현재 Trace 정보 확인
SELECT * FROM ::fn_trace_getinfo(default)
*/
BEGIN

	DECLARE @rc INT
	DECLARE @TraceID INT
	DECLARE @TraceFileOver INT = 2
	DECLARE @MaxFileSize BIGINT = 300
	DECLARE @StopTime DATETIME = DATEADD(MI, 1, GETDATE())
	DECLARE @File NVARCHAR(245)
	DECLARE @on BIT = 1

	SET @StopTime = CONVERT(CHAR(10), GETDATE(), 121) + '' 23:59:59''		--종료시간
	SET @File = ''F:\Profiler\TraceSQL_'' + REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(24), GETDATE(), 120), '':'', ''''), ''-'', ''''), '' '', ''-'')

	-- Trace 생성                                                          
	EXEC @rc = sp_trace_create @TraceID OUTPUT, @TraceFileOver, @File, @MaxFileSize, @StopTime                               

	IF (@rc != 0) GOTO ERROR
	
	BEGIN TRY

		-- eventid(10) -  RPC:Completed - RPC(원격 프로시저 호출)가 완료되면 발생
		-- eventid(11) -  RPC:Starting - RPC(원격 프로시저 호출)가 시작되면 발생
		exec sp_trace_setevent @TraceID, 10, 1, @on				-- TextData	
		exec sp_trace_setevent @TraceID, 10, 2, @on				-- BinaryData
		exec sp_trace_setevent @TraceID, 10, 3, @on				-- DatabaseID
		exec sp_trace_setevent @TraceID, 10, 6, @on				-- NTUserName
		exec sp_trace_setevent @TraceID, 10, 8, @on				-- HostName
		exec sp_trace_setevent @TraceID, 10, 9, @on				-- ClientProcessID
		exec sp_trace_setevent @TraceID, 10, 10, @on			-- ApplicationName
		exec sp_trace_setevent @TraceID, 10, 11, @on			-- LoginName
		exec sp_trace_setevent @TraceID, 10, 12, @on			-- SPID
		exec sp_trace_setevent @TraceID, 10, 18, @on			-- CPU
		exec sp_trace_setevent @TraceID, 10, 16, @on			-- Reads
		exec sp_trace_setevent @TraceID, 10, 17, @on			-- Writes
		exec sp_trace_setevent @TraceID, 10, 13, @on			-- Duration
		exec sp_trace_setevent @TraceID, 10, 14, @on			-- StartTime
		exec sp_trace_setevent @TraceID, 10, 15, @on			-- EndTime
		exec sp_trace_setevent @TraceID, 10, 22, @on			-- ObjectID
		exec sp_trace_setevent @TraceID, 10, 25, @on			-- ServerName
		exec sp_trace_setevent @TraceID, 10, 27, @on			-- EventClass
		exec sp_trace_setevent @TraceID, 10, 35, @on			-- DatabaseName

		-- eventid(12) - SQL:BatchCompleted - Transact-SQL 일괄 처리가 완료되면 발생
		-- eventid(13) - SQL:BatchStarting - Transact-SQL 일괄 처리가 시작되면 발생
		exec sp_trace_setevent @TraceID, 12, 1, @on
		exec sp_trace_setevent @TraceID, 12, 2, @on
		exec sp_trace_setevent @TraceID, 12, 3, @on
		exec sp_trace_setevent @TraceID, 10, 6, @on
		exec sp_trace_setevent @TraceID, 12, 8, @on
		exec sp_trace_setevent @TraceID, 12, 9, @on
		exec sp_trace_setevent @TraceID, 12, 10, @on
		exec sp_trace_setevent @TraceID, 12, 11, @on
		exec sp_trace_setevent @TraceID, 12, 12, @on
		exec sp_trace_setevent @TraceID, 12, 18, @on
		exec sp_trace_setevent @TraceID, 12, 16, @on
		exec sp_trace_setevent @TraceID, 12, 17, @on
		exec sp_trace_setevent @TraceID, 12, 13, @on
		exec sp_trace_setevent @TraceID, 12, 14, @on
		exec sp_trace_setevent @TraceID, 12, 15, @on
		exec sp_trace_setevent @TraceID, 12, 22, @on
		exec sp_trace_setevent @TraceID, 12, 25, @on
		exec sp_trace_setevent @TraceID, 10, 27, @on
		exec sp_trace_setevent @TraceID, 10, 35, @on
                              
		-- 필요없는 명령어 필터링
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''exec sp_reset_connection%''
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''exec sp_execute%''
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''exec sp_unprepare%''
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''exec sp_oledb_ro_usrname%''
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''select collationname(0x1204D00000)%''
		--exec sp_trace_setfilter @TraceID, 11, 0, 0, N''sqlmonitor''		--column_ID = LoginName 지정
		exec sp_trace_setfilter @TraceID, 18, 0, 4, 1000					--column_ID = CPU
		--exec sp_trace_setfilter @TraceID, 3, 0, 0, 28					--column_ID = DatabaseID         

		/*                              
		exec sp_trace_setfilter @TraceID, 10, 0, 7, N''SQL Profiler''		--column_ID = ApplicationName                     
		exec sp_trace_setfilter @TraceID, 10, 0, 7, N''SQL 프로필러''                              
		exec sp_trace_setfilter @TraceID, 10, 0, 7, N''MS SQLEM''                              
		exec sp_trace_setfilter @TraceID, 12, 0, 4, 50					--column_ID = SPID                  
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''select 504%''		--column_ID = TextData                
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''select @@%''                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''SET TEXTSIZE%''                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''set showplan%''                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''set NOEXEC%''             
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''set nocount%''                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''set lock_timeout% ''                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''select IS_SRVROLEMEMBER%''                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''exec sp_reset%''                 
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''%sp_MS%''                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''%sp_help%''                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''%dbo.sysindexes%''                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''%dbo.syscolumns%''                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''%sysobjects%''                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''%dbo.sysusers%''                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''select SERVERPROPERTY%''                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''dbcc%''                              
		exec sp_trace_setfilter @TraceID, 1, 0, 7, N''exec sp_cursorfetch%''
		*/

		-- Trace 실행
		EXEC sp_trace_setstatus @TraceID, 1
		   
	END TRY
	BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT
			@ErrorMessage = ERROR_MESSAGE()
		,	@ErrorSeverity = ERROR_SEVERITY()
		,	@ErrorState = ERROR_STATE();

		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);

	END CATCH
                           

	SELECT ''ID='' + CAST(@TraceID AS VARCHAR(10))
	GOTO FINISH

	ERROR:                               
		SELECT ''Err='' + CAST(@rc AS VARCHAR(10))
	FINISH:                              
		RETURN

END

', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'sch', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170731, 
		@active_end_date=99991231, 
		@active_start_time=100, 
		@active_end_time=235959, 
		@schedule_uid=N'6a571243-7933-4ecf-841e-f3448c7a1c05'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT]개발계정 DB이관]    Script Date: 2023-05-24 오후 1:02:23 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:23 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT]개발계정 DB이관', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'STATS.DBO.BAT_TRACESQL_DEV_INS_LOG_PROC', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [개발계정 모니터링 DB이관]    Script Date: 2023-05-24 오후 1:02:23 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'개발계정 모니터링 DB이관', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'STATS.DBO.BAT_TRACESQL_DEV_INS_LOG_PROC', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'개발계정 DB이관 일정', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20190128, 
		@active_end_date=99991231, 
		@active_start_time=80000, 
		@active_end_time=235959, 
		@schedule_uid=N'5c6d5d34-bf96-4d60-97a7-1469b7730893'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MGMT_DBA](1분간격) DB 항목 모니터링 + 실행계획초기화]    Script Date: 2023-05-24 오후 1:02:23 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:23 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MGMT_DBA](1분간격) DB 항목 모니터링 + 실행계획초기화', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'''TRACKED TRANSACTIONS/SEC''
,''LOCK REQUESTS/SEC'' --_TOTAL
,''LOCK WAITS/SEC'' --_TOTAL
,''LOCK TIMEOUTS/SEC''
,''USER CONNECTIONS''
,USER ERRORS', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [모니터링 항목 데이터 추출 입력]    Script Date: 2023-05-24 오후 1:02:24 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'모니터링 항목 데이터 추출 입력', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_PP_PERFMON_TB_DATA_INS_PROC', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [실행계획초기화_확인(주요프로시져)]    Script Date: 2023-05-24 오후 1:02:24 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'실행계획초기화_확인(주요프로시져)', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBA_실행계획초기화_PROC', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'DB항목 모니터링 매분 실행', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20160118, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'723314ec-258f-486f-916d-acc0fe87abb6'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[MON] 부동산다량등록권 연장 후결제건 추출(미연장건)]    Script Date: 2023-05-24 오후 1:02:24 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:24 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[MON] 부동산다량등록권 연장 후결제건 추출(미연장건)', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'
select top 100 *FROM CY_CONTRACT_TB where CONTRACT_STAT = 2
 and REG_DT > GETDATE() -0.1
 and START_DT <GETDATE() 
', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [BAT_MON_CY_CONTRACT_TB_MISS_INFO_PROC]    Script Date: 2023-05-24 오후 1:02:24 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'BAT_MON_CY_CONTRACT_TB_MISS_INFO_PROC', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_MON_CY_CONTRACT_TB_MISS_INFO_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'부동산다량등록권 연장 누락', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=3, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20160211, 
		@active_end_date=99991231, 
		@active_start_time=5000, 
		@active_end_time=235959, 
		@schedule_uid=N'9bf7f67c-ad74-4423-8364-868e37e09afb'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[OLAP] (5시 40분) OLAP 데이터 이관 작업(약 10분 소요)]    Script Date: 2023-05-24 오후 1:02:24 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:24 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[OLAP] (5시 40분) OLAP 데이터 이관 작업(약 10분 소요)', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'OLAP 데이터 이관 작업으로 약 10분 소요
벼룩시장 DB서버에서 밀어주는 방식이 아닌 OLAP 서버에서 가져가는 작업
스케줄 중복 및 작업 진행 여부 확인 위한 로컬측에 스케줄 생성', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [OLAP 데이터 이관]    Script Date: 2023-05-24 오후 1:02:24 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'OLAP 데이터 이관', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'PRINT ''OLAP 데이터 이관 작업(약 10분 정도 소요 예정)''', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'OLAP 데이터 이관 작업(약 10분 정도 소요)', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20150629, 
		@active_end_date=99991231, 
		@active_start_time=54000, 
		@active_end_time=235959, 
		@schedule_uid=N'3419e528-c089-4125-aafa-bf6b7ccb1f0e'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[광고주인증] (0시 2분) 탈퇴회원에 대한 광고주인증 정보 삭제]    Script Date: 2023-05-24 오후 1:02:25 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:25 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[광고주인증] (0시 2분) 탈퇴회원에 대한 광고주인증 정보 삭제', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[광고주인증] 탈퇴회원에 대한 광고주인증 정보 삭제]    Script Date: 2023-05-24 오후 1:02:25 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[광고주인증] 탈퇴회원에 대한 광고주인증 정보 삭제', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_DROP_OUTMEMBER_ADAUTH_PROC', 
		@database_name=N'MWDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[광고주인증] 탈퇴회원에 대한 광고주인증 정보 삭제', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20150422, 
		@active_end_date=99991231, 
		@active_start_time=200, 
		@active_end_time=235959, 
		@schedule_uid=N'24aea8a6-da87-4ce8-8d9b-c4a88dc5eb4b'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[광고주인증] (0시 35분) 고객정보 가져오기]    Script Date: 2023-05-24 오후 1:02:25 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:25 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[광고주인증] (0시 35분) 고객정보 가져오기', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'매일 실행', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[광고주인증] 고객정보 가져오기]    Script Date: 2023-05-24 오후 1:02:25 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[광고주인증] 고객정보 가져오기', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 현재 운영
EXEC BAT_MW_CUSTOMER_PROC;

-- 광고주 인증 개편용 (오픈후 _NEW 제거한 명칭으로 변경)
--EXEC BAT_MW_CUSTOMER_NEW_PROC', 
		@database_name=N'MWDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[광고주인증] 고객정보 가져오기', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=19900101, 
		@active_end_date=99991231, 
		@active_start_time=3500, 
		@active_end_time=235959, 
		@schedule_uid=N'1998a63f-98b2-4468-a1f5-70c820889719'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[광고주인증] (5시) 줄광고 전체 데이터 누적]    Script Date: 2023-05-24 오후 1:02:25 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:25 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[광고주인증] (5시) 줄광고 전체 데이터 누적', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'매일 실행', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [줄광고 전체 데이터 누적]    Script Date: 2023-05-24 오후 1:02:26 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'줄광고 전체 데이터 누적', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 광고주 인증지역 게제데이터 누적
EXEC dbo.BAT_DAILY_MW_LINEAD_TOTAL_PROC;

-- 영업데이터 전체 누적
EXEC dbo.BAT_MW_LINE_AD_TOTAL_PROC', 
		@database_name=N'MWDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [광고주인증 유관 데이터 갱신]    Script Date: 2023-05-24 오후 1:02:26 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'광고주인증 유관 데이터 갱신', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_LINEAD_CUST_RELATION_PROC', 
		@database_name=N'MWDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'줄광고 전체 데이터 누적', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=126, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20091231, 
		@active_end_date=99991231, 
		@active_start_time=50000, 
		@active_end_time=235959, 
		@schedule_uid=N'ba24b5ee-78ce-4c80-aeb4-dec0e99b7890'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[광고주인증] (매월 1일 0시 30분) 6개월전 줄광고 전체 데이터 삭제]    Script Date: 2023-05-24 오후 1:02:26 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:26 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[광고주인증] (매월 1일 0시 30분) 6개월전 줄광고 전체 데이터 삭제', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[광고주인증] 6개월전 MW_LINEAD_TOTAL_TB 데이터 삭제]    Script Date: 2023-05-24 오후 1:02:26 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[광고주인증] 6개월전 MW_LINEAD_TOTAL_TB 데이터 삭제', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_MONTH_MW_LINEAD_TOTAL_DELETE_PROC', 
		@database_name=N'MWDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[광고주인증] 6개월전 MW_LINEAD_TOTAL_TB 데이터 삭제', 
		@enabled=1, 
		@freq_type=16, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20100201, 
		@active_end_date=99991231, 
		@active_start_time=3000, 
		@active_end_time=235959, 
		@schedule_uid=N'4bd1db7e-b1c2-465f-a0f4-d40e97da91f9'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[광고주인증] 누락된 고객정보 등록하기]    Script Date: 2023-05-24 오후 1:02:26 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:26 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[광고주인증] 누락된 고객정보 등록하기', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[광고주인증] 누락된 고객정보 등록하기]    Script Date: 2023-05-24 오후 1:02:27 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[광고주인증] 누락된 고객정보 등록하기', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'INSERT MW_CUSTOMER_TB
   (CUSTCODE,INPUTBRANCH,CUSTTYPE,ORDERNAME,INPAYNAME,SIMPLENAME,DDDNO,PHONETEXT,FIRSTSYSDATE,DMZIPCODE,DMADDRESS,TAXZIPCODE,TAXADDRESS,FINDALLID,LINETOTLEVEL,LINETOTAMOUNT,LINETOTSECTION,CUSTGRADE,CUSTCLASS,ADAMOUNT,EMPNAME,EMPPHONE,EMPFAX,INPUTCUST)     
  SELECT C.CUSTCODE,C.INPUTBRANCH,C.CUSTTYPE,C.ORDERNAME,C.INPAYNAME,C.SIMPLENAME,C.DDDNO,C.PHONETEXT,C.FIRSTSYSDATE,C.DMZIPCODE,C.DMADDRESS,C.TAXZIPCODE,C.TAXADDRESS,C.FINDALLID,C.LINETOTLEVEL,C.LINETOTAMOUNT,C.LINETOTSECTION,C.CUSTGRADE,C.CUSTCLASS,C.ADAMOUNT,C.EMPNAME,C.EMPPHONE,C.EMPFAX,CAST(C.INPUTBRANCH AS VARCHAR(3)) + CAST(C.CUSTCODE AS VARCHAR(9))  
    FROM UNIFICATION_S1.UNILINEDB1.dbo.V_CustCertify AS C
       LEFT JOIN MW_CUSTOMER_TB AS M
              ON C.CUSTCODE = M.CUSTCODE
             AND C.INPUTBRANCH = M.INPUTBRANCH
   WHERE C.CustCode < 60000000   -- 박스광고 광고주 제외
     AND M.CUSTCODE IS NULL', 
		@database_name=N'MWDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[구인] (05시 30분) 불량정보 포함 공고 마감 처리]    Script Date: 2023-05-24 오후 1:02:27 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:27 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[구인] (05시 30분) 불량정보 포함 공고 마감 처리', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'[구인] (05시 30분) 불량정보 포함 공고 마감 처리', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'CFM\onsdb', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [01. 불량 정보 포함 공고 마감 처리_(자동차 상품 서비스)]    Script Date: 2023-05-24 오후 1:02:27 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'01. 불량 정보 포함 공고 마감 처리_(자동차 상품 서비스)', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC PAPER_NEW.DBO.BAT_BAD_DATA_ADSTOP_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [02. 불량 정보 포함 구인 마감 처리]    Script Date: 2023-05-24 오후 1:02:27 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'02. 불량 정보 포함 구인 마감 처리', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC PAPER_NEW.DBO.BAT_BAD_DATA_JOB_STOP_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[구인] (05시 30분) 불량정보 포함 공고 마감 처리', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20211123, 
		@active_end_date=99991231, 
		@active_start_time=53000, 
		@active_end_time=235959, 
		@schedule_uid=N'd180fd65-d6e1-4e68-9084-4a6906d5fcd2'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[구인] (06:40분) 조회/지원수 갱신]    Script Date: 2023-05-24 오후 1:02:27 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:27 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[구인] (06:40분) 조회/지원수 갱신', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[구인] 조회/지원수 갱신]    Script Date: 2023-05-24 오후 1:02:28 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[구인] 조회/지원수 갱신', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_AD_STATISTICS_JOB_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[구인] 조회/지원수 갱신', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170724, 
		@active_end_date=99991231, 
		@active_start_time=64000, 
		@active_end_time=235959, 
		@schedule_uid=N'cfdd8a68-bd63-445c-925c-eccf30d0dd5d'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[구인] (0시 1분) 온라인영업권 데이터]    Script Date: 2023-05-24 오후 1:02:28 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:28 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[구인] (0시 1분) 온라인영업권 데이터', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'- 전일 구인 온라인영업권 데이터 누적
- 영업권 정책 반영

BAT_FJ_구인_온라인영업권_PROC
BAT_FJ_구인_온라인영업권_조회용_전화번호_PROC', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [온라인영업권 데이터]    Script Date: 2023-05-24 오후 1:02:28 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'온라인영업권 데이터', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=3, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_FJ_구인_온라인영업권_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [온라인영업권 조회용 전화번호]    Script Date: 2023-05-24 오후 1:02:28 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'온라인영업권 조회용 전화번호', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=3, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_FJ_구인_온라인영업권_조회용_전화번호_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [온라인영업권 정책]    Script Date: 2023-05-24 오후 1:02:28 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'온라인영업권 정책', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_FJ_구인_온라인영업권_정책_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [기간계조회용 영업권 전화번호 등록]    Script Date: 2023-05-24 오후 1:02:28 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'기간계조회용 영업권 전화번호 등록', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_OTHER_BRANCH_SEARCH_JOB_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'온라인영업권', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170609, 
		@active_end_date=99991231, 
		@active_start_time=100, 
		@active_end_time=235959, 
		@schedule_uid=N'8cb524e5-0ddb-40c0-8841-2b91b1f7fe5f'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[구인] (0시 20분) 기업회원 영업권 이관]    Script Date: 2023-05-24 오후 1:02:28 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:28 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[구인] (0시 20분) 기업회원 영업권 이관', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[구인] 기업회원 영업권 이관]    Script Date: 2023-05-24 오후 1:02:29 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[구인] 기업회원 영업권 이관', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_BUSINESS_RIGHTS_CUSTOMER_AUTO_REG_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[구인] 기업회원 영업권 이관', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170808, 
		@active_end_date=99991231, 
		@active_start_time=2000, 
		@active_end_time=235959, 
		@schedule_uid=N'd7008fca-e963-4170-92e0-c3f3fbf96903'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[구인] (0시32분) 모바일정보테이블업데이트]    Script Date: 2023-05-24 오후 1:02:29 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:29 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[구인] (0시32분) 모바일정보테이블업데이트', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1]    Script Date: 2023-05-24 오후 1:02:29 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_UPD_MOBILE_PUSH_DEVICE_INFO_PROC', 
		@database_name=N'MOBILE_SERVICE', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20220207, 
		@active_end_date=99991231, 
		@active_start_time=3200, 
		@active_end_time=235959, 
		@schedule_uid=N'39781f0e-a439-472d-bef5-2df38c1aa0d4'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[구인] (1시 3분)공고조회수 ROW 데이터 변환]    Script Date: 2023-05-24 오후 1:02:29 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:29 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[구인] (1시 3분)공고조회수 ROW 데이터 변환', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [공고조회수 ROW 데이터 변환]    Script Date: 2023-05-24 오후 1:02:29 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'공고조회수 ROW 데이터 변환', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=3, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_FJ_공고조회수_ROW_데이터_변환_PROC', 
		@database_name=N'STATS_JOB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [공고조회수 통계저장 (벼룩시장서비스팀 용/섹션별,등록구분별,디바이스별,분류별)- STATS_JOB]    Script Date: 2023-05-24 오후 1:02:29 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'공고조회수 통계저장 (벼룩시장서비스팀 용/섹션별,등록구분별,디바이스별,분류별)- STATS_JOB', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBO.BAT_일별공고조회수_PROC', 
		@database_name=N'STATS_JOB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'공고조회수 ROW 데이터 변환', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170908, 
		@active_end_date=99991231, 
		@active_start_time=10300, 
		@active_end_time=235959, 
		@schedule_uid=N'2d54d8c2-e962-4875-ad3d-8f2ab2c19366'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[구인] (매 10분) 이컴+직접등록 결제미매칭 체크]    Script Date: 2023-05-24 오후 1:02:29 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:30 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[구인] (매 10분) 이컴+직접등록 결제미매칭 체크', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[구인] (매 10분) 이컴+직접등록 결제미매칭 체크]    Script Date: 2023-05-24 오후 1:02:30 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[구인] (매 10분) 이컴+직접등록 결제미매칭 체크', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC dbo.BAT_신문줄이컴_동시상품_결제처리_미매칭확인', 
		@database_name=N'PAPERREG', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[구인] (매 10분) 이컴+직접등록 결제미매칭 체크', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=10, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170607, 
		@active_end_date=99991231, 
		@active_start_time=80000, 
		@active_end_time=190000, 
		@schedule_uid=N'72799b42-28f9-4385-a164-049df02479af'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[구인] (매시간 1분 간격) LISTUP 갱신 3:30 ~ 3:00]    Script Date: 2023-05-24 오후 1:02:30 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:30 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[구인] (매시간 1분 간격) LISTUP 갱신 3:30 ~ 3:00', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'구인구직 리스트업 갱신

오전 4시 시작, 오전 3시 끝으로 매시간 1분 간격으로 대상 공고 갱신', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[구인] LISTUP 갱신]    Script Date: 2023-05-24 오후 1:02:30 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[구인] LISTUP 갱신', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @NOW DATETIME

-- 해당 시간 것
SET @NOW = GETDATE()
EXEC BAT_FJ_구인_리스트업_갱신_PROC @NOW', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[구인] LISTUP 갱신', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170426, 
		@active_end_date=99991231, 
		@active_start_time=33000, 
		@active_end_time=30000, 
		@schedule_uid=N'52292a86-d69c-4c10-93ea-7f79b246b8d1'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[구인] (매시간 5분 간격) 구인구직 유료 상품 데이터 갱신]    Script Date: 2023-05-24 오후 1:02:30 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:30 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[구인] (매시간 5분 간격) 구인구직 유료 상품 데이터 갱신', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [구인구직 유료 상품 데이터 갱신]    Script Date: 2023-05-24 오후 1:02:31 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'구인구직 유료 상품 데이터 갱신', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_JOB_AD_GOODS_PROC;', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [모바일 상품 누락 보정 작업]    Script Date: 2023-05-24 오후 1:02:31 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'모바일 상품 누락 보정 작업', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_MOBILE_JOB_GOOD_TB_CORRECTION_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[구인] (매시간 5분 간격) 구인구직 유료 상품 데이터 갱신', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=5, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20161115, 
		@active_end_date=99991231, 
		@active_start_time=44100, 
		@active_end_time=25959, 
		@schedule_uid=N'f5519a26-b625-47fb-91f8-0eb82d0e82ec'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[구인] (매일 3시 35분) LISTUP 누락건 갱신]    Script Date: 2023-05-24 오후 1:02:31 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:31 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[구인] (매일 3시 35분) LISTUP 누락건 갱신', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'리스트업 누락 건 갱신 처리', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[구인] LISTUP 누락건 갱신]    Script Date: 2023-05-24 오후 1:02:31 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[구인] LISTUP 누락건 갱신', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=5, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBO.BAT_FJ_구인_리스트업_누락건_갱신_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[구인] LISTUP 누락건 갱신', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=4, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170426, 
		@active_end_date=99991231, 
		@active_start_time=33500, 
		@active_end_time=20000, 
		@schedule_uid=N'a9a661c3-2187-44f6-b26b-18081c4d2fa1'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[구인] 등록대행 단가 갱신]    Script Date: 2023-05-24 오후 1:02:31 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:31 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[구인] 등록대행 단가 갱신', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'CFM\onsdb', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[구인] 등록대행 단가 갱신]    Script Date: 2023-05-24 오후 1:02:32 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[구인] 등록대행 단가 갱신', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 등록대행 단가갱신
EXECUTE dbo.BAT_TRANS_AGENCY_AREAGROUP_PRICE_PROC ''M''
GO

-- ECOMM 단가갱신
EXECUTE dbo.BAT_TRANS_AGENCY_AREAGROUP_PRICE_PROC ''E''
GO', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[구인] 등록대행 단가 갱신', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20201013, 
		@active_end_date=99991231, 
		@active_start_time=10000, 
		@active_end_time=235959, 
		@schedule_uid=N'ea80c861-283c-4e94-9b11-e6aa83080469'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[구인] 온라인영업권 갱신 (From 윌리언트)]    Script Date: 2023-05-24 오후 1:02:32 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:32 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[구인] 온라인영업권 갱신 (From 윌리언트)', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'CFM\onsdb', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[구인] 온라인영업권 갱신 (From 윌리언트)]    Script Date: 2023-05-24 오후 1:02:32 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[구인] 온라인영업권 갱신 (From 윌리언트)', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC dbo.BAT_WILLIANT_GOODWILL_PROC', 
		@database_name=N'MWDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[구인] 온라인영업권 갱신 (From 윌리언트)', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20200902, 
		@active_end_date=99991231, 
		@active_start_time=21000, 
		@active_end_time=235959, 
		@schedule_uid=N'9afd9a95-b6d6-474b-af49-bfcb01ce4f90'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[구인] 키워드 검색광고 갱신]    Script Date: 2023-05-24 오후 1:02:32 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:32 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[구인] 키워드 검색광고 갱신', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'CFM\onsdb', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [키워드 검색광고 종료 및 구매알림톡발송]    Script Date: 2023-05-24 오후 1:02:32 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'키워드 검색광고 종료 및 구매알림톡발송', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_PP_JOB_KEYWORDSEARCH_TB_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'키워드 검색광고 종료 및 구매알림톡발송', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=10, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20210531, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'8e657577-adac-4743-be7e-42e607908e7c'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[구인구직팀] 이벤트 참여자 cnt]    Script Date: 2023-05-24 오후 1:02:32 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:32 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[구인구직팀] 이벤트 참여자 cnt', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1]    Script Date: 2023-05-24 오후 1:02:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'

DECLARE @DATE VARCHAR(10)
DECLARE @subject2 VARCHAR(100)
SET @DATE = SUBSTRING(CONVERT(VARCHAR(10),getdate()-1,120),6,5)
SET @subject2 =''[구인구직] 이벤트참여자 cnt ('' + @DATE +'')''



exec msdb.dbo.sp_send_dbmail
	@profile_name =''DBAMAIL'',
	@recipients =''got@mediawill.com;pjw2154@mediawill.com;ciiciicii@mediawill.com;yeahrim@mediawill.com;'',
	@query='' 
  
set nocount on
      select SUBSTRING(convert(varchar(10),getdate()-1,120),6,5) ''''날짜''''
            ,ISNULL(sum(case when DEVICE_TYPE is null then 1 end),0) ''''모웹''''
            ,ISNULL(sum(case when DEVICE_TYPE is not null then 1 end),0) ''''앱'''' 
            ,ISNULL(count(*),0) ''''합계'''' 
      from [MOBILE_SERVICE].dbo.[MOBILE_EVENT_ENTRY_TB] with(nolock)
      where EVENT_ID =''''20230323''''
      and REG_DT >= convert(varchar(10),getdate()-1,120)
      and REG_DT < convert(varchar(10),getdate(),120)

'',
	@subject=@subject2', 
		@database_name=N'MOBILE_SERVICE', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1', 
		@enabled=0, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20230413, 
		@active_end_date=20230502, 
		@active_start_time=85300, 
		@active_end_time=235959, 
		@schedule_uid=N'2f6331bb-0a88-41a9-ba63-8a3685d25cdd'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[구인구직팀](08시48분)개인화Position_code카운트]    Script Date: 2023-05-24 오후 1:02:33 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:33 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[구인구직팀](08시48분)개인화Position_code카운트', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1. 아이피중복]    Script Date: 2023-05-24 오후 1:02:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1. 아이피중복', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'SET NOCOUNT ON

DECLARE @DATE1 VARCHAR(10)
DECLARE @DATE2 VARCHAR(10)
DECLARE @DATE3 VARCHAR(10)
DECLARE @DATE4 VARCHAR(10)
DECLARE @DATE5 VARCHAR(10)
DECLARE @DATE6 VARCHAR(10)
DECLARE @DATE7 VARCHAR(10)
DECLARE @subject2 VARCHAR(100)
DECLARE @tableHTML  NVARCHAR(MAX) 
SET @DATE1 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-7,120),6,5)
SET @DATE2 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-6,120),6,5)
SET @DATE3 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-5,120),6,5)
SET @DATE4 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-4,120),6,5)
SET @DATE5 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-3,120),6,5)
SET @DATE6 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-2,120),6,5)
SET @DATE7 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-1,120),6,5)
SET @subject2 =''[구인구직팀] 개인화추천시스템 포지션코드 count ('' + @DATE1 + '' ~ '' + @DATE7 +'')''


SET @tableHTML =
	N''<H1>개인화추천시스템 포지션코드 count</H1>'' +
	N''<table border="1">'' +
	N''<tr><th>POSITION_CODE</th>'' +
	N''<th>''+@DATE1+''</th>'' +
	N''<th>''+@DATE2+''</th>'' +
  N''<th>''+@DATE3+''</th>'' +
	N''<th>''+@DATE4+''</th>'' +
	N''<th>''+@DATE5+''</th>'' +
  N''<th>''+@DATE6+''</th>'' +
	N''<th>''+@DATE7+''</th>'' +
  N''</tr>'' +
    CAST ( (
       select  td = a.POSITION_CODE, ''''
       , td = ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-7,120) THEN CNT END),0), ''''
       , td = ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-6,120) THEN CNT END),0), ''''
       , td = ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-5,120) THEN CNT END),0), ''''
       , td = ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-4,120) THEN CNT END),0), ''''
       , td = ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-3,120) THEN CNT END),0), ''''
       , td = ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-2,120) THEN CNT END),0), ''''
       , td = ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-1,120) THEN CNT END),0)
      from dba.dbo.temp_POSITIONCODE a left join (
      select CONVERT(VARCHAR(10),REG_DT,120)DATE,POSITION_CODE, COUNT(*)CNT
      from mwdb.dbo.PP_AD_READ_COUNT_LOG_TB WITH(NOLOCK)
      WHERE REG_DT >=CONVERT(VARCHAR(10),GETDATE()-7,120)
      AND REG_DT <CONVERT(VARCHAR(10),GETDATE(),120)
      GROUP BY CONVERT(VARCHAR(10),REG_DT,120),POSITION_CODE
      )b
      on a.POSITION_CODE = b.POSITION_CODE
      GROUP BY a.POSITION_CODE
      ORDER BY 1
              FOR XML PATH(''tr''), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N''</table>'' ;

EXEC msdb.dbo.sp_send_dbmail 
	@profile_name =''DBAMAIL'',
  @recipients=''got@mediawill.com;oyj@mediawill.com;pjw2154@mediawill.com;mgyu@mediawill.com;ciiciicii@mediawill.com;'',
    @subject = @subject2,
    @body = @tableHTML,
    @body_format = ''HTML'' ;




/*
SET NOCOUNT ON

DECLARE @DATE1 VARCHAR(10)
DECLARE @DATE2 VARCHAR(10)
DECLARE @subject2 VARCHAR(100)
SET @DATE1 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-7,120),6,5)
SET @DATE2 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-1,120),6,5)
SET @subject2 =''[구인구직팀] 개인화추천시스템 포지션코드 count ('' + @DATE1 + '' ~ '' + @DATE2 +'')''



exec msdb.dbo.sp_send_dbmail
	@profile_name =''DBA'',
	@recipients =''got@mediawill.com;artofmin@mediawill.com;lhs@mediawill.com;pjw2154@mediawill.com;'',
	@query='' select a.POSITION_CODE
, ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-7,120) THEN CNT END),0) ''''월''''
, ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-6,120) THEN CNT END),0) ''''화''''
, ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-5,120) THEN CNT END),0) ''''수''''
, ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-4,120) THEN CNT END),0) ''''목''''
, ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-3,120) THEN CNT END),0) ''''금''''
, ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-2,120) THEN CNT END),0) ''''토''''
, ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-1,120) THEN CNT END),0) ''''일''''
from dba.dbo.temp_POSITIONCODE a left join (
select CONVERT(VARCHAR(10),REG_DT,120)DATE,POSITION_CODE, COUNT(*)CNT
from mwdb.dbo.PP_AD_READ_COUNT_LOG_TB WITH(NOLOCK)
WHERE REG_DT >=CONVERT(VARCHAR(10),GETDATE()-7,120)
AND REG_DT <CONVERT(VARCHAR(10),GETDATE(),120)
GROUP BY CONVERT(VARCHAR(10),REG_DT,120),POSITION_CODE
)b
on a.POSITION_CODE = b.POSITION_CODE
GROUP BY a.POSITION_CODE
ORDER BY 1'',
	@subject=@subject2,
  @attach_query_result_as_file=1

*/', 
		@database_name=N'MWDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [2. 아이피중복제거]    Script Date: 2023-05-24 오후 1:02:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'2. 아이피중복제거', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'

 SET NOCOUNT ON

DECLARE @DATE1 VARCHAR(10)
DECLARE @DATE2 VARCHAR(10)
DECLARE @DATE3 VARCHAR(10)
DECLARE @DATE4 VARCHAR(10)
DECLARE @DATE5 VARCHAR(10)
DECLARE @DATE6 VARCHAR(10)
DECLARE @DATE7 VARCHAR(10)
DECLARE @subject2 VARCHAR(100)
DECLARE @tableHTML  NVARCHAR(MAX) 

SET @DATE1 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-7,120),6,5)
SET @DATE2 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-6,120),6,5)
SET @DATE3 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-5,120),6,5)
SET @DATE4 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-4,120),6,5)
SET @DATE5 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-3,120),6,5)
SET @DATE6 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-2,120),6,5)
SET @DATE7 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-1,120),6,5)
SET @subject2 =''[구인구직팀] 개인화추천시스템 포지션코드_IP중복제거 count ('' + @DATE1 + '' ~ '' + @DATE7 +'')''

SET @tableHTML =
	N''<H1>개인화추천시스템 포지션코드 count</H1>'' +
	N''<table border="1">'' +
	N''<tr><th>POSITION_CODE</th>'' +
	N''<th>''+@DATE1+''</th>'' +
	N''<th>''+@DATE2+''</th>'' +
  N''<th>''+@DATE3+''</th>'' +
	N''<th>''+@DATE4+''</th>'' +
	N''<th>''+@DATE5+''</th>'' +
  N''<th>''+@DATE6+''</th>'' +
	N''<th>''+@DATE7+''</th>'' +
  N''</tr>'' +
    CAST ( (
       select  td = a.POSITION_CODE, ''''
       , td = ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-7,120) THEN CNT END),0), ''''
       , td = ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-6,120) THEN CNT END),0), ''''
       , td = ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-5,120) THEN CNT END),0), ''''
       , td = ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-4,120) THEN CNT END),0), ''''
       , td = ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-3,120) THEN CNT END),0), ''''
       , td = ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-2,120) THEN CNT END),0), ''''
       , td = ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-1,120) THEN CNT END),0)
      from dba.dbo.temp_POSITIONCODE a left join (
                          SELECT [DATE], POSITION_CODE, COUNT(*) CNT
                          FROM (
                                  select CONVERT(VARCHAR(10),REG_DT,120)DATE,POSITION_CODE, client_ip
                                  from mwdb.dbo.PP_AD_READ_COUNT_LOG_TB WITH(NOLOCK)
                                  WHERE REG_DT >=CONVERT(VARCHAR(10),GETDATE()-7,120)
                                  AND REG_DT <CONVERT(VARCHAR(10),GETDATE(),120)
                                  GROUP BY CONVERT(VARCHAR(10),REG_DT,120),POSITION_CODE,client_ip
                                  )B
                          GROUP BY [DATE], POSITION_CODE
)b
on a.POSITION_CODE = b.POSITION_CODE
GROUP BY a.POSITION_CODE
ORDER BY 1
  FOR XML PATH(''tr''), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N''</table>'' ;

EXEC msdb.dbo.sp_send_dbmail 
	@profile_name =''DBAMAIL'',
  @recipients=''got@mediawill.com;oyj@mediawill.com;pjw2154@mediawill.com;mgyu@mediawill.com;ciiciicii@mediawill.com;'',
    @subject = @subject2,
    @body = @tableHTML,
    @body_format = ''HTML'' ;





/*

SET NOCOUNT ON

DECLARE @DATE1 VARCHAR(10)
DECLARE @DATE2 VARCHAR(10)
DECLARE @subject2 VARCHAR(100)
SET @DATE1 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-7,120),6,5)
SET @DATE2 = SUBSTRING(CONVERT(VARCHAR(10),getdate()-1,120),6,5)
SET @subject2 =''[구인구직팀] 개인화추천시스템 포지션코드_IP중복제거 count ('' + @DATE1 + '' ~ '' + @DATE2 +'')''


exec msdb.dbo.sp_send_dbmail
	@profile_name =''DBA'',
	@recipients =''got@mediawill.com;artofmin@mediawill.com;lhs@mediawill.com;pjw2154@mediawill.com;'',
	@query=''select a.POSITION_CODE
, ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-7,120) THEN CNT END),0) ''''월''''
, ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-6,120) THEN CNT END),0) ''''화''''
, ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-5,120) THEN CNT END),0) ''''수''''
, ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-4,120) THEN CNT END),0) ''''목''''
, ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-3,120) THEN CNT END),0) ''''금''''
, ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-2,120) THEN CNT END),0) ''''토''''
, ISNULL(MAX(CASE WHEN [DATE] =CONVERT(VARCHAR(10),GETDATE()-1,120) THEN CNT END),0) ''''일''''
from dba.dbo.temp_POSITIONCODE a left join (
                          SELECT [DATE], POSITION_CODE, COUNT(*) CNT
                          FROM (
                                  select CONVERT(VARCHAR(10),REG_DT,120)DATE,POSITION_CODE, client_ip
                                  from mwdb.dbo.PP_AD_READ_COUNT_LOG_TB WITH(NOLOCK)
                                  WHERE REG_DT >=CONVERT(VARCHAR(10),GETDATE()-7,120)
                                  AND REG_DT <CONVERT(VARCHAR(10),GETDATE(),120)
                                  GROUP BY CONVERT(VARCHAR(10),REG_DT,120),POSITION_CODE,client_ip
                                  )B
                          GROUP BY [DATE], POSITION_CODE
)b
on a.POSITION_CODE = b.POSITION_CODE
GROUP BY a.POSITION_CODE
ORDER BY 1'',
	@subject=@subject2,
  @attach_query_result_as_file=1
*/', 
		@database_name=N'MWDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=2, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20220404, 
		@active_end_date=99991231, 
		@active_start_time=84700, 
		@active_end_time=235959, 
		@schedule_uid=N'c9c0d245-271c-4c33-9695-5639a731c752'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[구인구직팀](매일09:10)브랜드관 게재수]    Script Date: 2023-05-24 오후 1:02:33 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:33 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[구인구직팀](매일09:10)브랜드관 게재수', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1.유료브랜드관]    Script Date: 2023-05-24 오후 1:02:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1.유료브랜드관', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
/*
SET NOCOUNT ON

DECLARE @DATE1 VARCHAR(10)
DECLARE @subject2 VARCHAR(100)
DECLARE @tableHTML  NVARCHAR(MAX) 
SET @DATE1 = SUBSTRING(CONVERT(VARCHAR(10),getdate(),120),6,5)




SET @subject2 =''[브랜드관] 입점 브랜드 ('' + @DATE1 + '')''


SET @tableHTML =
	N''<H1></H1>'' +
	N''<table border="1">'' +
	N''<tr><th>NO</th>'' +
  N''<th>BR_SEQ</th>'' +
	N''<th>브랜드명</th>'' +
	N''<th>게재공고수</th>'' +
  N''</tr>'' +
    CAST ( (
       select  td = NO, ''''
       , td = BR_SEQ, ''''
       , td = COMPANY_NAME, ''''
       , td = ISNULL(CNT,0)
FROM (
select *, ROW_NUMBER() OVER(ORDER BY BR_SEQ) [NO]
from (
  SELECT *
  FROM (
      SELECT A.BR_SEQ, A.COMPANY_NAME, b.CNT
           FROM PAPER_NEW.DBO.PP_BRAND_TB AS A
  LEFT JOIN (SELECT A.BR_SEQ, COUNT(*) AS CNT
            FROM PAPER_NEW.DBO.PP_BRAND_AD_TB AS A
            JOIN PAPER_NEW.DBO.PP_LINE_AD_TB AS B
            ON B.LINEADID = A.LINEADID
            AND B.INPUT_BRANCH = A.INPUT_BRANCH
            AND B.LAYOUT_BRANCH = A.LAYOUT_BRANCH
            GROUP BY A.BR_SEQ) AS B
  ON B.BR_SEQ = A.BR_SEQ
  LEFT JOIN (SELECT BR_SEQ, COUNT(*) AS CNT
            FROM PAPER_NEW.DBO.PP_BRAND_BRANCH_TB 
            WHERE CANCEL_YN = ''N''
            GROUP BY BR_SEQ) AS C
  ON C.BR_SEQ = A.BR_SEQ
  WHERE USE_YN =''Y''
  )A 
  WHERE CNT >0
)A
)A
ORDER BY NO
  FOR XML PATH(''tr''), TYPE 
      ) AS NVARCHAR(MAX) ) +
      N''</table>'' ;

EXEC msdb.dbo.sp_send_dbmail 
	@profile_name =''DBAMAIL'',
  @recipients=''got@mediawill.com;ciiciicii@mediawill.com;pjw2154@mediawill.com;mgyu@mediawill.com;ssy@mediawill.com;slhong@mediawill.com;hhs@mediawill.com;wskang@mediawill.com;difai2@mediawill.com;minbjkr@mediawill.com;mjlee@mediawill.com;wonwoo@mediawill.com;tjline@mediawill.com;sabana1234@mediawill.com;jsd0767@mediawill.com;'',
    @subject = @subject2,
    @body = @tableHTML,
    @body_format = ''HTML'' ;



*/




SET NOCOUNT ON

DECLARE @DATE1 VARCHAR(10)
DECLARE @subject2 VARCHAR(100)
DECLARE @tableHTML  NVARCHAR(MAX) 
SET @DATE1 = SUBSTRING(CONVERT(VARCHAR(10),getdate(),120),6,5)




SET @subject2 =''[브랜드관] 입점 브랜드 ('' + @DATE1 + '')''


SET @tableHTML =
	N''<H1></H1>'' +
	N''<table border="1">'' +
	N''<tr><th>NO</th>'' +
  N''<th>BR_SEQ</th>'' +
	N''<th>상호명</th>'' +
	N''<th>게재공고수</th>'' +
  N''</tr>'' +
    CAST ( (
       select  td = NO, ''''
       , td = BR_SEQ, ''''
       , td = BRAND_NAME, ''''
       , td = ISNULL(CNT,0)
FROM (
select *, ROW_NUMBER() OVER(ORDER BY BR_SEQ) [NO]
from (
  SELECT *
  FROM (
      SELECT A.BR_SEQ, A.BRAND_NAME, b.CNT
           FROM PAPER_NEW.DBO.PP_BRAND_TB AS A
  LEFT JOIN (SELECT A.BR_SEQ, COUNT(*) AS CNT
            FROM PAPER_NEW.DBO.PP_BRAND_AD_TB AS A
            JOIN PAPER_NEW.DBO.PP_LINE_AD_TB AS B
            ON B.LINEADID = A.LINEADID
            AND B.INPUT_BRANCH = A.INPUT_BRANCH
            AND B.LAYOUT_BRANCH = A.LAYOUT_BRANCH
            GROUP BY A.BR_SEQ) AS B
  ON B.BR_SEQ = A.BR_SEQ
  LEFT JOIN (SELECT BR_SEQ, COUNT(*) AS CNT
            FROM PAPER_NEW.DBO.PP_BRAND_BRANCH_TB 
            WHERE CANCEL_YN = ''N''
            GROUP BY BR_SEQ) AS C
  ON C.BR_SEQ = A.BR_SEQ
  WHERE USE_YN =''Y''
  )A 
  WHERE CNT >0
)A
)A
ORDER BY NO
  FOR XML PATH(''tr''), TYPE 
      ) AS NVARCHAR(MAX) ) +
      N''</table>'' ;

EXEC msdb.dbo.sp_send_dbmail 
	@profile_name =''DBAMAIL'',
  @recipients=''DE152757832635556580D@mediawill.com;got@mediawill.com;ciiciicii@mediawill.com;pjw2154@mediawill.com;wonwoo@mediawill.com;sw2003@mediawill.com;s990122@mediawill.com;jsd0767@mediawill.com;mammur@mediawill.com;lordkim@mediawill.com;kobbal@mediawill.com;jenny78@mediawill.com;ever3241@mediawill.com;kjnj8888@mediawill.com;tjline@mediawill.com;mjlee@mediawill.com;wd910512@mediawill.com;taekchon@mediawill.com;holsoo@mediawill.com;wskang@mediawill.com;difai2@mediawill.com;'',
    @subject = @subject2,
    @body = @tableHTML,
    @body_format = ''HTML'' ;
', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [2.무료브랜드관]    Script Date: 2023-05-24 오후 1:02:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'2.무료브랜드관', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
SET NOCOUNT ON

DECLARE @DATE1 VARCHAR(10)
DECLARE @subject2 VARCHAR(100)
DECLARE @tableHTML  NVARCHAR(MAX) 
SET @DATE1 = SUBSTRING(CONVERT(VARCHAR(10),getdate(),120),6,5)




SET @subject2 =''[브랜드관] 매핑 브랜드 ('' + @DATE1 + '')''


SET @tableHTML =
	N''<H1></H1>'' +
	N''<table border="1">'' +
	N''<tr><th>NO</th>'' +
  N''<th>BR_SEQ</th>'' +
	N''<th>상호명</th>'' +
	N''<th>게재공고수</th>'' +
  N''</tr>'' +
    CAST ( (
       select  td = NO, ''''
       , td = BR_FREE_SEQ, ''''
       , td = BRAND_NAME, ''''
       , td = ISNULL(CNT,0)
FROM (
select BR_FREE_SEQ,BRAND_NAME,CNT,ROW_NUMBER() OVER(ORDER BY a.BR_FREE_SEQ) [NO]
from (
  select A.BR_FREE_SEQ,BRAND_NAME,CNT
  FROM (
    SELECT A.BR_FREE_SEQ, A.BRAND_NAME
    FROM PAPER_NEW.DBO.PP_BRAND_FREE_TB AS A
    WHERE A.USE_YN = ''Y''
  ) A LEFT JOIN (

          SELECT B.BR_FREE_SEQ ,ISNULL(COUNT(*),0) AS CNT    
              FROM 
                (
                SELECT 
                  BR_FREE_SEQ,
                  LINEADID,
                  INPUT_BRANCH,
                  LAYOUT_BRANCH,
                  LINEADNO,
                  1 AS DISPLAY
                FROM 
                PAPER_NEW.DBO.PP_BRAND_FREE_AD_TB WITH(NOLOCK)
                UNION ALL
                SELECT
                  BR_FREE_SEQ,
                  LINEADID,
                  INPUT_BRANCH,
                  LAYOUT_BRANCH,
                  LINEADNO,
                  2 AS DISPLAY
                FROM PAPER_NEW.DBO.PP_BRAND_FREE_AD_DISPLAY_TB WITH(NOLOCK)
                )
               AS B 
              JOIN PAPER_NEW.DBO.PP_LINE_AD_TB AS C WITH(NOLOCK) ON C.LINEADID = B.LINEADID AND C.INPUT_BRANCH = B.INPUT_BRANCH AND C.LAYOUT_BRANCH = B.LAYOUT_BRANCH
              JOIN PAPER_NEW.DBO.PP_OPTION_TB AS F WITH(NOLOCK) ON F.LINEADID = B.LINEADID AND F.INPUT_BRANCH = B.INPUT_BRANCH AND F.LAYOUT_BRANCH = B.LAYOUT_BRANCH    
              LEFT JOIN PAPER_NEW.DBO.PP_FREE_AD_CONFIRM_TB G (NOLOCK) ON G.LINEADID = B.LINEADID AND G.INPUT_BRANCH = B.INPUT_BRANCH AND G.LAYOUT_BRANCH = B.LAYOUT_BRANCH
              LEFT JOIN PAPER_NEW.DBO.PP_COMPANY_INFO_JOB_VI K WITH(NOLOCK) ON C.CUID = K.CUID
              LEFT JOIN PAPER_NEW.DBO.PP_BRAND_FREE_AD_DISPLAY_TB L WITH(NOLOCK) ON L.LINEADNO = B.LINEADNO
              GROUP BY B.BR_FREE_SEQ 
              )B
        ON A.BR_FREE_SEQ = B.BR_FREE_SEQ
)A
WHERE CNT >0
)a
ORDER BY NO
  FOR XML PATH(''tr''), TYPE 
      ) AS NVARCHAR(MAX) ) +
      N''</table>'' ;

EXEC msdb.dbo.sp_send_dbmail 
	@profile_name =''DBAMAIL'',
  @recipients=''DE152757832635556580D@mediawill.com;got@mediawill.com;ciiciicii@mediawill.com;pjw2154@mediawill.com;wonwoo@mediawill.com;sw2003@mediawill.com;s990122@mediawill.com;jsd0767@mediawill.com;mammur@mediawill.com;lordkim@mediawill.com;kobbal@mediawill.com;jenny78@mediawill.com;ever3241@mediawill.com;kjnj8888@mediawill.com;tjline@mediawill.com;mjlee@mediawill.com;wd910512@mediawill.com;taekchon@mediawill.com;holsoo@mediawill.com;wskang@mediawill.com;difai2@mediawill.com;'',
    @subject = @subject2,
    @body = @tableHTML,
    @body_format = ''HTML'' ;


/*
SET NOCOUNT ON

DECLARE @DATE1 VARCHAR(10)
DECLARE @subject2 VARCHAR(100)
DECLARE @tableHTML  NVARCHAR(MAX) 
SET @DATE1 = SUBSTRING(CONVERT(VARCHAR(10),getdate(),120),6,5)




SET @subject2 =''[구인구직] 무료 브랜드관 ('' + @DATE1 + '')''


SET @tableHTML =
	N''<H1></H1>'' +
	N''<table border="1">'' +
	N''<tr><th>NO</th>'' +
  N''<th>BR_SEQ</th>'' +
	N''<th>브랜드명</th>'' +
	N''<th>게재공고수</th>'' +
  N''</tr>'' +
    CAST ( (
       select  td = NO, ''''
       , td = BR_FREE_SEQ, ''''
       , td = BRAND_NAME, ''''
       , td = ISNULL(CNT,0)
FROM (
select BR_FREE_SEQ,BRAND_NAME,CNT,ROW_NUMBER() OVER(ORDER BY a.BR_FREE_SEQ) [NO]
from (
  select A.BR_FREE_SEQ,BRAND_NAME,CNT
  FROM (
    SELECT A.BR_FREE_SEQ, A.BRAND_NAME
    FROM PAPER_NEW.DBO.PP_BRAND_FREE_TB AS A
    WHERE A.USE_YN = ''Y''
  ) A LEFT JOIN (

          SELECT B.BR_FREE_SEQ ,ISNULL(COUNT(*),0) AS CNT    
              FROM 
                (
                SELECT 
                  BR_FREE_SEQ,
                  LINEADID,
                  INPUT_BRANCH,
                  LAYOUT_BRANCH,
                  LINEADNO,
                  1 AS DISPLAY
                FROM 
                PAPER_NEW.DBO.PP_BRAND_FREE_AD_TB WITH(NOLOCK)
                UNION ALL
                SELECT
                  BR_FREE_SEQ,
                  LINEADID,
                  INPUT_BRANCH,
                  LAYOUT_BRANCH,
                  LINEADNO,
                  2 AS DISPLAY
                FROM PAPER_NEW.DBO.PP_BRAND_FREE_AD_DISPLAY_TB WITH(NOLOCK)
                )
               AS B 
              JOIN PAPER_NEW.DBO.PP_LINE_AD_TB AS C WITH(NOLOCK) ON C.LINEADID = B.LINEADID AND C.INPUT_BRANCH = B.INPUT_BRANCH AND C.LAYOUT_BRANCH = B.LAYOUT_BRANCH
              JOIN PAPER_NEW.DBO.PP_OPTION_TB AS F WITH(NOLOCK) ON F.LINEADID = B.LINEADID AND F.INPUT_BRANCH = B.INPUT_BRANCH AND F.LAYOUT_BRANCH = B.LAYOUT_BRANCH    
              LEFT JOIN PAPER_NEW.DBO.PP_FREE_AD_CONFIRM_TB G (NOLOCK) ON G.LINEADID = B.LINEADID AND G.INPUT_BRANCH = B.INPUT_BRANCH AND G.LAYOUT_BRANCH = B.LAYOUT_BRANCH
              LEFT JOIN PAPER_NEW.DBO.PP_COMPANY_INFO_JOB_VI K WITH(NOLOCK) ON C.CUID = K.CUID
              LEFT JOIN PAPER_NEW.DBO.PP_BRAND_FREE_AD_DISPLAY_TB L WITH(NOLOCK) ON L.LINEADNO = B.LINEADNO
              GROUP BY B.BR_FREE_SEQ 
              )B
        ON A.BR_FREE_SEQ = B.BR_FREE_SEQ
)A
WHERE CNT >0
)a
ORDER BY NO
  FOR XML PATH(''tr''), TYPE 
      ) AS NVARCHAR(MAX) ) +
      N''</table>'' ;

EXEC msdb.dbo.sp_send_dbmail 
	@profile_name =''DBAMAIL'',
  @recipients=''got@mediawill.com;ciiciicii@mediawill.com;pjw2154@mediawill.com;mgyu@mediawill.com;ssy@mediawill.com;slhong@mediawill.com;hhs@mediawill.com;wskang@mediawill.com;difai2@mediawill.com;minbjkr@mediawill.com;mjlee@mediawill.com;wonwoo@mediawill.com;tjline@mediawill.com;sabana1234@mediawill.com;jsd0767@mediawill.com;'',
    @subject = @subject2,
    @body = @tableHTML,
    @body_format = ''HTML'' ;
*/
', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20221024, 
		@active_end_date=99991231, 
		@active_start_time=90900, 
		@active_end_time=235959, 
		@schedule_uid=N'ebfbefb1-3f7d-4419-9daf-7efab1516bfa'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[대시보드] (00:00분) 개발팀 대시보드 데이터 취합]    Script Date: 2023-05-24 오후 1:02:33 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:33 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[대시보드] (00:00분) 개발팀 대시보드 데이터 취합', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'매일 0시에 전일자 개발팀용 대쉬보드 데이터를 취합하여 STATS 에 저장한다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1. 결제_결제형태별 현황]    Script Date: 2023-05-24 오후 1:02:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1. 결제_결제형태별 현황', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_개발대시보드_결제_결제형태별현황', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [2. 광고_광고조회수]    Script Date: 2023-05-24 오후 1:02:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'2. 광고_광고조회수', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_개발대시보드_광고_광고조회수', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [3. 광고_신규건수]    Script Date: 2023-05-24 오후 1:02:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'3. 광고_신규건수', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_개발대시보드_광고_신규건수', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [4. 광고_입사지원광고수]    Script Date: 2023-05-24 오후 1:02:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'4. 광고_입사지원광고수', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_개발대시보드_광고_입사지원광고수', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [5. 광고_지역별광고신규건수]    Script Date: 2023-05-24 오후 1:02:33 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'5. 광고_지역별광고신규건수', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_개발대시보드_광고_지역별광고신규건수', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [6. 상품별통계_등록권사용광고현황]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'6. 상품별통계_등록권사용광고현황', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_개발대시보드_상품별통계_등록권사용광고현황', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [7. 상품별통계_유료광고상품구매건수]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'7. 상품별통계_유료광고상품구매건수', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_개발대시보드_상품별통계_유료광고상품구매건수', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [8. 상품별통계_이력서열람]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'8. 상품별통계_이력서열람', 
		@step_id=8, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_개발대시보드_상품별통계_이력서열람', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [9. 이력서_이력서현황]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'9. 이력서_이력서현황', 
		@step_id=9, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_개발대시보드_이력서_이력서현황', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [10. 입사지원_입사지원수]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'10. 입사지원_입사지원수', 
		@step_id=10, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_개발대시보드_입사지원_입사지원수', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [11. 회원_회원별접속현황]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'11. 회원_회원별접속현황', 
		@step_id=11, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_개발대시보드_회원_회원별접속현황', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [12. 회원_회원현황]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'12. 회원_회원현황', 
		@step_id=12, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_개발대시보드_회원_회원현황', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [13. 결제_결제형태별 매출현황]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'13. 결제_결제형태별 매출현황', 
		@step_id=13, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_개발대시보드_결제_결제형태별매출현황', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'매일 0시 실행', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20160226, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'b541906a-fb7d-4034-93db-967901423fb2'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[대시보드] (01:50분) 벼룩시장 서비스팀 구인 대시보드 데이터 취합]    Script Date: 2023-05-24 오후 1:02:34 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:34 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[대시보드] (01:50분) 벼룩시장 서비스팀 구인 대시보드 데이터 취합', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'미디어윌 네트웍스 벼룩시장 서비스팀 대시보드 데이터 취합', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [0. 게재공고 백업]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'0. 게재공고 백업', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=2, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_게재공고_백업_PROC', 
		@database_name=N'STATS_JOB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1. 신규공고등록수]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1. 신규공고등록수', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_신규공고등록수_PROC', 
		@database_name=N'STATS_JOB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [2. 공고게재수]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'2. 공고게재수', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_일별공고게재수_PROC', 
		@database_name=N'STATS_JOB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [3. 회원데이터]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'3. 회원데이터', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_회원관련_PROC', 
		@database_name=N'STATS_JOB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [4. 상품별 매출 주문건수]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'4. 상품별 매출 주문건수', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--EXEC dbo.BAT_상품별_매출_주문건수_PROC', 
		@database_name=N'STATS_JOB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [5. 상품별 주무취소 금액 건수]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'5. 상품별 주무취소 금액 건수', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--EXEC dbo.BAT_상품별_주무취소_금액_건수_PROC', 
		@database_name=N'STATS_JOB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [6. 상품별 환불 금액/건수]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'6. 상품별 환불 금액/건수', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--EXEC dbo.BAT_상품별_환불_금액_건수_PROC', 
		@database_name=N'STATS_JOB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [7. 이력서 현황]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'7. 이력서 현황', 
		@step_id=8, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [dbo].[BAT_이력서현황_PROC]', 
		@database_name=N'STATS_JOB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [8. 입사지원 현황]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'8. 입사지원 현황', 
		@step_id=9, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [dbo].[BAT_입사지원현황_PROC]', 
		@database_name=N'STATS_JOB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [9. 업직종별 공고수]    Script Date: 2023-05-24 오후 1:02:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'9. 업직종별 공고수', 
		@step_id=10, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC dbo.BAT_업직종별공고수_PROC', 
		@database_name=N'STATS_JOB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'실행', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20161220, 
		@active_end_date=99991231, 
		@active_start_time=15000, 
		@active_end_time=235959, 
		@schedule_uid=N'788830a4-0a05-428c-9cc4-5d5c6493b08e'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[대시보드] (1시 5분) 매출 통계 RAW DATA_구인_부동산]    Script Date: 2023-05-24 오후 1:02:34 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:35 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[대시보드] (1시 5분) 매출 통계 RAW DATA_구인_부동산', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'대시보드 회원정보는 회원DB에서 호출됩니다.
MEMBERDB.DBO.BAT_MM_MEMBER_STAT_PROC 에서  BAT_DASHBOARD_DATA_MEMBER_STAT_INS_PROC 호출', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[신문_NEW] 구인 매출 통계 RAW DATA]    Script Date: 2023-05-24 오후 1:02:35 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[신문_NEW] 구인 매출 통계 RAW DATA', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=3, 
		@retry_interval=3, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_STATS_JOB_PAY_PROC', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[DASHBOARD]  DASHBOARD용 광고 데이터 생성]    Script Date: 2023-05-24 오후 1:02:35 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[DASHBOARD]  DASHBOARD용 광고 데이터 생성', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DASHBOARD_DATA_AD_CNT_STAT_INS_PROC -- DASHBOARD용 광고 데이터 생성
', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[DASHBOARD] 매출 데이터 처리]    Script Date: 2023-05-24 오후 1:02:35 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[DASHBOARD] 매출 데이터 처리', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BAT_DASHBOARD_DATA_SALE_STAT_INS_PROC', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[DASHBOARD] 온라인등록대행 매출 데이터 생성 (매일)]    Script Date: 2023-05-24 오후 1:02:35 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[DASHBOARD] 온라인등록대행 매출 데이터 생성 (매일)', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_DASHBOARD_DATA_SALES_AGENT_PROC', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[DASHBOARD] 온라인등록대행 수금기준으로 갱신 (매월1일)]    Script Date: 2023-05-24 오후 1:02:35 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[DASHBOARD] 온라인등록대행 수금기준으로 갱신 (매월1일)', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 매월 1일에 실행
IF DATEPART(day,GETDATE()) = 1
  BEGIN
    EXECUTE dbo.BAT_DASHBOARD_DATA_SALES_AGENT_COLLECT_PROC
  END', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[신문NEW] 부동산 매출통계 RAW  DATA]    Script Date: 2023-05-24 오후 1:02:35 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[신문NEW] 부동산 매출통계 RAW  DATA', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DASHBOARD_DATA_LAND_PAY_INS_PROC', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[DB PERFMON] DB 퍼포먼스 DASHBOARD 입력]    Script Date: 2023-05-24 오후 1:02:35 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[DB PERFMON] DB 퍼포먼스 DASHBOARD 입력', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BAT_DASHBOARD_PERFMON_INS_PROC', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[신문_NEW] 구인 매출 통계 RAW DATA', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20151023, 
		@active_end_date=99991231, 
		@active_start_time=10500, 
		@active_end_time=235959, 
		@schedule_uid=N'b036d9e1-7d4e-4845-a0f7-4fbf4903977c'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[대시보드] (23:59분) 부동산 상품별 게재현황]    Script Date: 2023-05-24 오후 1:02:35 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:35 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[대시보드] (23:59분) 부동산 상품별 게재현황', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'EXEC [STATS].[dbo].[BAT_부동산_상품별_일별_게재_현황]', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [부동산상품별 일별 게재현황]    Script Date: 2023-05-24 오후 1:02:35 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'부동산상품별 일별 게재현황', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N' EXEC [STATS].[dbo].[BAT_부동산_상품별_일별_게재_현황] ', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'부동산상품별 일별 게재현황', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20180612, 
		@active_end_date=99991231, 
		@active_start_time=235930, 
		@active_end_time=235959, 
		@schedule_uid=N'07c4669a-2117-41b0-913d-ab90d11076b1'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[매년 12월 정기 작업] 다음해 참조 데이터 추가]    Script Date: 2023-05-24 오후 1:02:35 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:35 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[매년 12월 정기 작업] 다음해 참조 데이터 추가', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'COPY 날짜 관련 테이블 추가', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1년 단위 작업]    Script Date: 2023-05-24 오후 1:02:35 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1년 단위 작업', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec BAT_COPY_YYYYMMDD_TB_INS_PROC', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'매 12월에 실행', 
		@enabled=1, 
		@freq_type=16, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=12, 
		@active_start_date=20181201, 
		@active_end_date=20301215, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'c61fd1f3-193b-4fb8-86c0-3f68c627e6a8'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[모바일] (0시 30분) 모바일 Device 정보 삭제]    Script Date: 2023-05-24 오후 1:02:36 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:36 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[모바일] (0시 30분) 모바일 Device 정보 삭제', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'모바일 Device 정보 삭제', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'CFM\onsdb', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[모바일] (0시 30분) 모바일 Device 정보 삭제_(탈퇴회원기준)]    Script Date: 2023-05-24 오후 1:02:36 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[모바일] (0시 30분) 모바일 Device 정보 삭제_(탈퇴회원기준)', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec MOBILE_SERVICE.DBO.BAT_MOBILE_PUSH_DEVICE_INFO_DEL_PROC', 
		@database_name=N'MOBILE_SERVICE', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[모바일] (0시 30분) 모바일 Device 정보 삭제_(탈퇴회원기준)', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20211122, 
		@active_end_date=99991231, 
		@active_start_time=3000, 
		@active_end_time=235959, 
		@schedule_uid=N'37069d5c-2b28-4929-8729-a58d9d5f9e5a'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[문자발송] (11시 05분) 문자 발송]    Script Date: 2023-05-24 오후 1:02:36 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:36 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[문자발송] (11시 05분) 문자 발송', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'1. 유료광고, 다량등록권 부동산 상품 미입금자 MMS 발송     ☞ BAT_LNAD_USERID_NOT_PAY_MMS_SEND_PROC
2. 유료광고, 정액권, 이력서열람 상품 미입금자 MMS 발송    ☞ BAT_JOB_USERID_NOT_PAY_MMS_SEND_PROC
3. 무료공고 게재 7일째 쿠폰발급/MMS 발송                       ☞ MWsms11 ☞ BAT_JOB_FREE_AD_7DAY_MMS_SEND_PROC
4. 부동산 개인 무료광고 마감 MMS 발송                            ☞ BAT_FINDALL_LAND_FREE_END_MMS_SEND_PROC
5. 구인구직 유료광고 상품 미입금자_결제후1일내_MMS 발송 ☞ BAT_JOB_USERID_VBANK_AFTER_1DAY_MMS_SEND_PROC
6. 부동산 유료광고 상품 미입금자_결제후1일내_MMS 발송    ☞ BAT_LAND_USERID_NOT_PAY_MMS_SEND_DAY1_PR', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1. 유료광고, 다량등록권 부동산 상품 미입금자 MMS 발송]    Script Date: 2023-05-24 오후 1:02:36 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1. 유료광고, 다량등록권 부동산 상품 미입금자 MMS 발송', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- [부동산] 유료광고 미입금 안내(온라인)
EXEC BAT_LNAD_USERID_NOT_PAY_MMS_SEND_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [2. 유료광고, 정액권, 이력서열람 상품 미입금자 MMS 발송]    Script Date: 2023-05-24 오후 1:02:36 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'2. 유료광고, 정액권, 이력서열람 상품 미입금자 MMS 발송', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 유료광고, 정액권, 이력서열람 상품 미입금자 MMS 발송
EXEC BAT_JOB_USERID_NOT_PAY_MMS_SEND_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [3. 무료공고 게재 7일째 쿠폰발급/MMS 발송]    Script Date: 2023-05-24 오후 1:02:36 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'3. 무료공고 게재 7일째 쿠폰발급/MMS 발송', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 무료공고 게재 7일째 쿠폰발급/MMS 발송
EXEC BAT_JOB_FREE_AD_7DAY_MMS_SEND_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [4. 부동산 개인 무료광고 마감 MMS 발송]    Script Date: 2023-05-24 오후 1:02:36 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'4. 부동산 개인 무료광고 마감 MMS 발송', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 부동산 개인회원 무료광고 종료 안내, 2016-12-31 무료광고종료 건 대상
-- 부동산 개인 무료광고 마감 MMS 발송
EXEC BAT_FINDALL_LAND_FREE_END_MMS_SEND_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [5. 구인구직 유료광고 상품 미입금자_결제후1일내_MMS 발송]    Script Date: 2023-05-24 오후 1:02:36 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'5. 구인구직 유료광고 상품 미입금자_결제후1일내_MMS 발송', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- [구인구직] (10시) 유료광고, 정액권, 이력서열람, 간편등록 상품 미입금자_결제후1일내_MMS 발송
EXEC BAT_JOB_USERID_VBANK_AFTER_1DAY_MMS_SEND_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [6. 부동산 유료광고 상품 미입금자_결제후1일내_MMS 발송]    Script Date: 2023-05-24 오후 1:02:36 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'6. 부동산 유료광고 상품 미입금자_결제후1일내_MMS 발송', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- [부동산] (10시) 유료광고 부동산 상품 미입금자_결제후1일내_MMS 발송
EXEC BAT_LAND_USERID_NOT_PAY_MMS_SEND_DAY1_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [7. 부동산 쿠폰사용 마감임박 MMS발송]    Script Date: 2023-05-24 오후 1:02:36 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'7. 부동산 쿠폰사용 마감임박 MMS발송', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 쿠폰사용 종료일이 7일 남았을때, 안내 MMS를 발송함.
EXEC BAT_FINDALL_COUPON_PUBLISH_END_DT_INFO_MMS_SEND_PROC 7', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [8. 구인/부동산 기업 휴면예정회원 쿠폰 발행 및 문자 발송]    Script Date: 2023-05-24 오후 1:02:36 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'8. 구인/부동산 기업 휴면예정회원 쿠폰 발행 및 문자 발송', 
		@step_id=8, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 구인/부동산 기업 휴면예정회원 쿠폰 발행 및 문자 발송
-- EXEC BAT_REST_MEMBER_COUPON_PUBLISH_LMS_SEND_PROC

-- 2019.07.01 김영훈대리 요청(FJ002-319)', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [9. 구인구직 쿠폰사용 마감임박(7일전) MMS발송]    Script Date: 2023-05-24 오후 1:02:36 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'9. 구인구직 쿠폰사용 마감임박(7일전) MMS발송', 
		@step_id=9, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_JOB_COUPON_PUBLISH_END_DT_INFO_MMS_SEND_PROC 7', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[문자발송] (11시 05분) 문자 발송', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20160708, 
		@active_end_date=99991231, 
		@active_start_time=110500, 
		@active_end_time=235959, 
		@schedule_uid=N'019811e1-95f8-4c3d-8b55-64dfe6b854b4'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[문자발송] (13시) 유료광고 마감 안내 카카오알림톡]    Script Date: 2023-05-24 오후 1:02:37 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:37 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[문자발송] (13시) 유료광고 마감 안내 카카오알림톡', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[구인] 구인종료공고 카카오 알림톡 발송]    Script Date: 2023-05-24 오후 1:02:37 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[구인] 구인종료공고 카카오 알림톡 발송', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_TODDAY_ENDAD_KKO_SEND_JOB_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[구인] 구인정액권 마감 7일전 카카오 알림톡 발송]    Script Date: 2023-05-24 오후 1:02:37 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[구인] 구인정액권 마감 7일전 카카오 알림톡 발송', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_7DAY_ENDFAT_KKO_SEND_JOB_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[구인] 이력서열람상품 마감 3,7일전 카카오 알림톡 발송]    Script Date: 2023-05-24 오후 1:02:37 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[구인] 이력서열람상품 마감 3,7일전 카카오 알림톡 발송', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_ENDRESUMEOPENPROD_KKO_SEND_JOB_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[구인] 이력서 공개기간 종료 안내 카카오 알림톡 발송]    Script Date: 2023-05-24 오후 1:02:37 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[구인] 이력서 공개기간 종료 안내 카카오 알림톡 발송', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_PRIV_ENDRESUMEOPEN_KKO_SEND_JOB_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[구인] 이력서 등록일이 3개월된건 카카오 알림톡 발송]    Script Date: 2023-05-24 오후 1:02:37 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[구인] 이력서 등록일이 3개월된건 카카오 알림톡 발송', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_3MONTH_PRIV_ENDRESUME_KKO_SEND_JOB_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[부동산] 부동산종료공고 카카오 알림톡 발송]    Script Date: 2023-05-24 오후 1:02:37 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[부동산] 부동산종료공고 카카오 알림톡 발송', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_TODDAY_ENDAD_KKO_SEND_LAND_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[부동산] 부동산 다량등록권 종료 카카오 알림톡 발송]    Script Date: 2023-05-24 오후 1:02:37 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[부동산] 부동산 다량등록권 종료 카카오 알림톡 발송', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_CONTRACT_TB_KKO_SEND_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'실행', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20161012, 
		@active_end_date=99991231, 
		@active_start_time=130000, 
		@active_end_time=235959, 
		@schedule_uid=N'7c0ec17e-628e-4dbd-9878-06139edf1586'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[벼룩시장] (매일 0시 20분) ECOMM 영업권정보 윌리언트 전송 데이터]    Script Date: 2023-05-24 오후 1:02:37 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:37 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[벼룩시장] (매일 0시 20분) ECOMM 영업권정보 윌리언트 전송 데이터', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'EXEC BAT_CM_ECOMM_영업권정보_윌리언트_PROC', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[벼룩시장] (매일 0시 20분) ECOMM 영업권정보 윌리언트 전송 데이터]    Script Date: 2023-05-24 오후 1:02:38 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[벼룩시장] (매일 0시 20분) ECOMM 영업권정보 윌리언트 전송 데이터', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=10, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_CM_ECOMM_영업권정보_윌리언트_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[벼룩시장부동산] (매일 0시 20분) ECOMM 영업권정보 윌리언트 전송 데이터]    Script Date: 2023-05-24 오후 1:02:38 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[벼룩시장부동산] (매일 0시 20분) ECOMM 영업권정보 윌리언트 전송 데이터', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_CM_ECOMM_영업권정보_윌리언트_LAND_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[부동산써브] (매일 0시 20분) ECOMM 영업권정보 윌리언트 전송 데이터]    Script Date: 2023-05-24 오후 1:02:38 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[부동산써브] (매일 0시 20분) ECOMM 영업권정보 윌리언트 전송 데이터', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_CM_ECOMM_영업권정보_윌리언트_부동산써브_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[벼룩시장] (매일 0시 20분) ECOMM 영업권정보 윌리언트 전송 데이터', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20200528, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'48cf3e07-af0a-45e9-8075-88a900b70ce9'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[부동산] (09:00분) 주간_라이브_통계_추출(온라인)]    Script Date: 2023-05-24 오후 1:02:38 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:38 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[부동산] (09:00분) 주간_라이브_통계_추출(온라인)', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'매주 월요일 구글 Sheet 작성 용,
벼부 일평균 신규 매물수
벼부 통계 데이터 추출용', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [주간_라이브_매물_(온라인)]    Script Date: 2023-05-24 오후 1:02:38 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'주간_라이브_매물_(온라인)', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 매주 월요일 구글 Sheet 작성 용,
-- 벼부 일평균 & 신규 매물수

exec [STATS].[DBO].[BAT_WK_LAND_ROW_TB_DATA_INS_PROC]', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[부동산] (09:00분) 주간_라이브_통계_추출(온라인)', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=2, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20201122, 
		@active_end_date=99991231, 
		@active_start_time=90000, 
		@active_end_time=235959, 
		@schedule_uid=N'57949a3d-9751-440e-9d35-ce2640195c61'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[부동산] (23:59분)일별_등록_수정통계]    Script Date: 2023-05-24 오후 1:02:38 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:38 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[부동산] (23:59분)일별_등록_수정통계', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [부동산_일별_등록_수정_현황]    Script Date: 2023-05-24 오후 1:02:39 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'부동산_일별_등록_수정_현황', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [STATS].[dbo].[BAT_부동산_일별_등록_수정_현황]', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'부동산_일별_등록_수정_현황', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20171031, 
		@active_end_date=99991231, 
		@active_start_time=235930, 
		@active_end_time=235959, 
		@schedule_uid=N'4db7d02f-cb2c-48a7-ae26-0c12bd513c3d'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문](30분) 메인 지역통계]    Script Date: 2023-05-24 오후 1:02:39 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:39 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문](30분) 메인 지역통계', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'BAT_PP_JOB_SUMMARY_MAIN_TITLE_TB_MAKE_STARTDT_PROC    BAT_PP_HOUSE_SUMMARY_MAIN_TITLE_TB_MAKE_PROC', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [메인SUMMARY 통계]    Script Date: 2023-05-24 오후 1:02:39 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'메인SUMMARY 통계', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec BAT_PP_JOB_SUMMARY_MAIN_TITLE_TB_MAKE_STARTDT_PROC  
exec BAT_PP_HOUSE_SUMMARY_MAIN_TITLE_TB_MAKE_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'매일되풀이 오전 4시부터', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=30, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20180725, 
		@active_end_date=99991231, 
		@active_start_time=41300, 
		@active_end_time=235959, 
		@schedule_uid=N'6997f74b-ba8d-4d94-8bd4-d9361b408e60'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (0시 12분) (관리자 통계_하루한번만) 광고 버젼별, 인터넷 분류별 광고 건수]    Script Date: 2023-05-24 오후 1:02:39 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:39 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (0시 12분) (관리자 통계_하루한번만) 광고 버젼별, 인터넷 분류별 광고 건수', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[신문_NEW] 광고 버젼별, 인터넷 분류별 광고 건수 (구인구직)]    Script Date: 2023-05-24 오후 1:02:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[신문_NEW] 광고 버젼별, 인터넷 분류별 광고 건수 (구인구직)', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=2, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC PUT_ST_VERSION_FINDCODE_ADCNT_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[신문_NEW] 광고 버젼별,인터넷 분류별 광고 건수 (부동산)]    Script Date: 2023-05-24 오후 1:02:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[신문_NEW] 광고 버젼별,인터넷 분류별 광고 건수 (부동산)', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'PUT_ST_VERSION_FINDCODE_ADCNT_HOUSE_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[신문_NEW] 일별 버젼별, 인터넷 분류별 광고 건수', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20131002, 
		@active_end_date=99991231, 
		@active_start_time=1200, 
		@active_end_time=235959, 
		@schedule_uid=N'ded57a4c-02e7-4ee3-808e-640c07e36cc7'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (0시 1분) LISTUP 중지]    Script Date: 2023-05-24 오후 1:02:40 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:40 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (0시 1분) LISTUP 중지', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'구인 광고옵션 게재종료일에 따른 LISTUP 중지', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [구인 광고옵션 게재종료일에 따른 LISTUP 중지]    Script Date: 2023-05-24 오후 1:02:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'구인 광고옵션 게재종료일에 따른 LISTUP 중지', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=3, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_LISTUP_STOP_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'구인 광고옵션 게재종료일에 따른 LISTUP 중지', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20131210, 
		@active_end_date=99991231, 
		@active_start_time=100, 
		@active_end_time=235959, 
		@schedule_uid=N'ca875a0c-8a59-4afd-8859-319b22c9ccac'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (0시 1분) 배너/스페셜광고 게재 변경]    Script Date: 2023-05-24 오후 1:02:40 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:40 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (0시 1분) 배너/스페셜광고 게재 변경', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [스페셜광고 게재변경]    Script Date: 2023-05-24 오후 1:02:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'스페셜광고 게재변경', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=2, 
		@retry_interval=10, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_F_SPECIAL_AD_MAIN_PUBLISH_FALG_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [배너 게재변경]    Script Date: 2023-05-24 오후 1:02:40 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'배너 게재변경', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=2, 
		@retry_interval=10, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_F_PP_BANNER_LAYOUT_TB_PROC ', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[신문_NEW] 배너/스페셜광고 게재변경', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20140514, 
		@active_end_date=99991231, 
		@active_start_time=100, 
		@active_end_time=235959, 
		@schedule_uid=N'7eb124ea-e1fb-4094-90a4-3d8df7698f5a'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (0시 2분) 자동차딜러홍보 게재상태 갱신]    Script Date: 2023-05-24 오후 1:02:41 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:41 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (0시 2분) 자동차딜러홍보 게재상태 갱신', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [자동차딜러홍보 게재상태 갱신]    Script Date: 2023-05-24 오후 1:02:41 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'자동차딜러홍보 게재상태 갱신', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'UPDATE PP_CARDEALER_PR_TB
SET PR_STATUS = ''C''
--SELECT PR_STATUS,PR_EDT,* FROM PP_CARDEALER_PR_TB
WHERE PR_EDT < CONVERT(VARCHAR(10),GETDATE(),120)
AND PR_STATUS <> ''C''', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'자동차딜러홍보 게재상태 갱신', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20160211, 
		@active_end_date=99991231, 
		@active_start_time=200, 
		@active_end_time=235959, 
		@schedule_uid=N'afedb18e-0a5a-449d-b012-687cb6f12ece'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (0시 30분) E-Comm광고 타점 조회_영업권]    Script Date: 2023-05-24 오후 1:02:41 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:41 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (0시 30분) E-Comm광고 타점 조회_영업권', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[신문_NEW] E-Comm광고 타점 조회]    Script Date: 2023-05-24 오후 1:02:41 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[신문_NEW] E-Comm광고 타점 조회', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE BAT_OTHER_BRANCH_SEARCH_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[신문_NEW] E-Comm광고 타점 조회', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20140217, 
		@active_end_date=99991231, 
		@active_start_time=3000, 
		@active_end_time=235959, 
		@schedule_uid=N'88fb5fef-9e5f-4656-8e40-85f7feee9b70'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (0시 7분) 수정공고 리스트 취합&삭제]    Script Date: 2023-05-24 오후 1:02:42 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:42 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (0시 7분) 수정공고 리스트 취합&삭제', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1.[신문_NEW] (0시 7분) 수정공고 리스트 취합&삭제]    Script Date: 2023-05-24 오후 1:02:42 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1.[신문_NEW] (0시 7분) 수정공고 리스트 취합&삭제', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=10, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_MODIFIED_ADLIST_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1.수정공고 스케쥴', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20220614, 
		@active_end_date=99991231, 
		@active_start_time=700, 
		@active_end_time=235959, 
		@schedule_uid=N'8cf75e55-025c-40c7-87c5-33d2b05f8b64'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (0시) 0시~3시 게재시간누락 광고 게재테이블 이관]    Script Date: 2023-05-24 오후 1:02:43 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:43 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (0시) 0시~3시 게재시간누락 광고 게재테이블 이관', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'0시~3시 게재시간누락 광고 Agent스케쥴 동작 전 게재테이블로 이관하여 광고 노출유도', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [온라인 이컴/등록대행 예약광고 게재테이블 이관]    Script Date: 2023-05-24 오후 1:02:43 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'온라인 이컴/등록대행 예약광고 게재테이블 이관', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBO.BAT_NEXTDAY_PUBLISH_AD_REG_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'온라인 이컴/등록대행 예약광고 게재테이블 이관', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20140813, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'1912057b-7c5b-453b-81a6-49747e87e4b5'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (0시) 부동산 다량등록권 계약 마감 & 연장 _ 신축빌라 포함]    Script Date: 2023-05-24 오후 1:02:43 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:43 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (0시) 부동산 다량등록권 계약 마감 & 연장 _ 신축빌라 포함', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'BAT_MULTI_REG_CHANGE_PROC', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [다량등록권 계약 마감 & 연장 스케쥴]    Script Date: 2023-05-24 오후 1:02:43 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'다량등록권 계약 마감 & 연장 스케쥴', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BAT_MULTI_REG_CHANGE_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'다량등록권 계약 마감 & 연장 스케쥴', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20140922, 
		@active_end_date=99991231, 
		@active_start_time=30, 
		@active_end_time=235959, 
		@schedule_uid=N'40c69202-41e7-4511-ab2e-e1470a51b104'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (1시 30분) 신문벼룩시장 탈퇴 회원 데이터 삭제]    Script Date: 2023-05-24 오후 1:02:44 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:44 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (1시 30분) 신문벼룩시장 탈퇴 회원 데이터 삭제', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[신문_NEW] 신문벼룩시장 탈퇴 회원 데이터 삭제]    Script Date: 2023-05-24 오후 1:02:44 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[신문_NEW] 신문벼룩시장 탈퇴 회원 데이터 삭제', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBO.BAT_OUT_MEMBER_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[신문_NEW] 신문벼룩시장 탈퇴 회원 데이터 삭제', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20091105, 
		@active_end_date=99991231, 
		@active_start_time=13000, 
		@active_end_time=235959, 
		@schedule_uid=N'96dd29d0-d4f1-4574-b7fa-eff059a00867'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (1시41분) 휴면 회원 결제,허위신고 개인정보 공백처리]    Script Date: 2023-05-24 오후 1:02:45 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:45 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (1시41분) 휴면 회원 결제,허위신고 개인정보 공백처리', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1. 휴면회원 결제,허위신고 테이블 개인정보 공백 처리]    Script Date: 2023-05-24 오후 1:02:45 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1. 휴면회원 결제,허위신고 테이블 개인정보 공백 처리', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC PAPER_NEW.dbo.BAT_REST_SEPARATION_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20220526, 
		@active_end_date=99991231, 
		@active_start_time=14100, 
		@active_end_time=235959, 
		@schedule_uid=N'5e8e72f6-71b5-4ac5-8a7d-9caf94edcdb0'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (23시) 취합전 신문데이터 백업 복사]    Script Date: 2023-05-24 오후 1:02:45 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:45 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (23시) 취합전 신문데이터 백업 복사', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[신문_NEW] 신버전 신문데이터 백업]    Script Date: 2023-05-24 오후 1:02:45 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[신문_NEW] 신버전 신문데이터 백업', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'TRUNCATE TABLE NEW_ONEDAYLINEAD_BACKUP_TB

INSERT INTO NEW_ONEDAYLINEAD_BACKUP_TB
(LINEADID, INPUTBRANCH, CLOSEBRANCH, EMPCODE, SYSEMPCODE, CUSTCODE, ADORDERNAME, PHONETEXT, URL, URLF, PHONEF, ENTRYDATE, MODIFYDATE, FIRSTSYSDATE, SYSDATE, CLASSCODE, CLASSTAIL1, CLASSTAIL2, CLASSTAIL3, CLASSTAIL4, DETAILADCODE, LAYOUTCODE1, LAYOUTCODE2, LAYOUTCODE3, LAYOUTCODE, CONTENT, HEADER, AMOUNT, TOTAMOUNT, RETURNAMOUNT, REFUNDAMOUNT, ISSUECOUNT, STARTISSUE, ENDISSUE, STARTDATE, ENDDATE, WEEKLAYOUT, PAYCHKF, CONFIRMF, ADTYPE, MERGENOF, COLEMPCODE, EXPBANKID, EXPNAME, EXPDATE, RECBANKID, RECNAME, RECDATE, RECAMOUNT, ZIPCODE, CANCELCODE, MODICODE, FREECODE, TAXF, UNIONF, LAYOUTSPEED, LAYOUTLINEBOX, LAYOUTCODENAME, LAYOUTSPEEDNAME, LAYOUTLINEBOXNAME, ADORDERPHONE, INPUTCUST, FRAMETYPE, PREFCLOSE)
SELECT 
LINEADID, INPUTBRANCH, CLOSEBRANCH, EMPCODE, SYSEMPCODE, CUSTCODE, ADORDERNAME, PHONETEXT, URL, URLF, PHONEF, ENTRYDATE, MODIFYDATE, FIRSTSYSDATE, SYSDATE, CLASSCODE, CLASSTAIL1, CLASSTAIL2, CLASSTAIL3, CLASSTAIL4, DETAILADCODE, LAYOUTCODE1, LAYOUTCODE2, LAYOUTCODE3, LAYOUTCODE, CONTENT, HEADER, AMOUNT, TOTAMOUNT, RETURNAMOUNT, REFUNDAMOUNT, ISSUECOUNT, STARTISSUE, ENDISSUE, STARTDATE, ENDDATE, WEEKLAYOUT, PAYCHKF, CONFIRMF, ADTYPE, MERGENOF, COLEMPCODE, EXPBANKID, EXPNAME, EXPDATE, RECBANKID, RECNAME, RECDATE, RECAMOUNT, ZIPCODE, CANCELCODE, MODICODE, FREECODE, TAXF, UNIONF, LAYOUTSPEED, LAYOUTLINEBOX, LAYOUTCODENAME, LAYOUTSPEEDNAME, LAYOUTLINEBOXNAME, ADORDERPHONE, INPUTCUST, FRAMETYPE, PREFCLOSE
 FROM NEW_ONEDAYLINEAD_TB', 
		@database_name=N'UNILINEDB_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[신문_NEW] 취합전 게재데이터 백업 복사', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20120710, 
		@active_end_date=99991231, 
		@active_start_time=230000, 
		@active_end_time=235959, 
		@schedule_uid=N'77a701bb-81ba-4354-b33e-fecfd19ce095'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (2시 5분) 배너 노출 카운트 갱신]    Script Date: 2023-05-24 오후 1:02:45 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:45 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (2시 5분) 배너 노출 카운트 갱신', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [배너 노출 로그 갱신]    Script Date: 2023-05-24 오후 1:02:45 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'배너 노출 로그 갱신', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/* LOGDB의 로우카운트의 합을 배너관리 테이블에 업데이트 함. */
EXEC BAT_BANNER_VIEW_COUNT_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [배너 노출 로그 갱신 2018]    Script Date: 2023-05-24 오후 1:02:45 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'배너 노출 로그 갱신 2018', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_BANNER_VIEW_COUNT_2018_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'매일 오전 2시 5분', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20151216, 
		@active_end_date=99991231, 
		@active_start_time=20500, 
		@active_end_time=235959, 
		@schedule_uid=N'ff2c6aab-1fc4-4888-b627-3a266af1899a'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (4시 40분) 광고취합 장애 체크/통보]    Script Date: 2023-05-24 오후 1:02:45 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:45 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (4시 40분) 광고취합 장애 체크/통보', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'줄/박스광고 취합 결과 개발담당자에게 SMS 통보
* 체크조건
금일자 시작 광고건수 카운터가 없으면 SMS 발송

-----
알바천국 데이터 이관 1차 취합 건수 0건 일경우 기획팀/개발팀 담당자에게 SMS 통보 



', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [알바천국 데이터 이관 장애 체크]    Script Date: 2023-05-24 오후 1:02:45 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'알바천국 데이터 이관 장애 체크', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/*

DECLARE @RDATE VARCHAR(8)
DECLARE @RTIME VARCHAR(6)
DECLARE @CNT INT

SET @RDATE = REPLACE(CONVERT(VARCHAR(10), GETDATE(), 120), ''-'', '''')
SET @CNT = 0


SELECT @CNT = COUNT(*)
  FROM PP_LINE_AD_TB (NOLOCK)
 WHERE VERSION = ''A''
   AND INPUT_BRANCH = 182
 
IF @CNT = 0
  BEGIN
  
    SET @RTIME = ''050000''
    
    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01033931420'',''[FA] 알바천국 데이터 이관 장애 발생'', ''FINDALL'', @RDATE, @RTIME    -- 이근우
    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01028519869'',''[FA] 알바천국 데이터 이관 장애 발생'', ''FINDALL'', @RDATE, @RTIME    -- 최봉기
    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01032134592'',''[FA] 알바천국 데이터 이관 장애 발생'', ''FINDALL'', @RDATE, @RTIME    -- 최병찬
   
  END

*/', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [주소테이블 카운트 체크]    Script Date: 2023-05-24 오후 1:02:45 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'주소테이블 카운트 체크', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/* CM_ZIPTXT_ORG에는 있고, CM_ZIPTXT_CODE에는 없는 주소가 있을 경우 문자 발송  */

DECLARE @CNT INT

SELECT @CNT = COUNT(*)
  FROM CM_ZIPTXT_ORG A
  LEFT JOIN CM_ZIPTXT_CODE B ON A.METRO = B.METRO AND A.CITY = B.CITY AND A.DONG = B.DONG
 WHERE B.METRO IS NULL


IF @CNT > 0
BEGIN
  EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01033931420'',''[FA] 주소테이블 카운트 틀림'', ''FINDALL''    -- 이근우
END', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [줄광고 장애 체크]    Script Date: 2023-05-24 오후 1:02:45 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'줄광고 장애 체크', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @CNT INT
SET @CNT = 0

SELECT @CNT = COUNT(*)
  FROM PP_LINE_AD_TB (NOLOCK)
 WHERE VERSION = ''N''
   AND CONVERT(VARCHAR(10),START_DT,120) = CONVERT(VARCHAR(10),GETDATE(),120)

IF DATEPART(dw,getdate()) <> 7 AND @CNT = 0	 -- 토요일 제외 (토요발행 지점이 없음)
  BEGIN
    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01028519869'',''영업줄광고 신규건 누락 (연휴기간중인 경우 무시)''  -- 최봉기
    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01033931420'',''영업줄광고 신규건 누락 (연휴기간중인 경우 무시)''  -- 이근우
    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01044555434'',''영업줄광고 신규건 누락 (연휴기간중인 경우 무시)''  -- 권준호
--    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01031273287'',''영업줄광고 신규건 누락 (연휴기간중인 경우 무시)''  -- 정헌수
  END', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [박스광고 장애 체크]    Script Date: 2023-05-24 오후 1:02:46 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'박스광고 장애 체크', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @TOTALCNT INT
DECLARE @CNT INT

SET @TOTALCNT = 0
SET @CNT = 0

SELECT @TOTALCNT = COUNT(*)
  FROM PP_LINE_AD_TB (NOLOCK)
  WHERE AD_KIND = ''B''

SELECT @CNT = COUNT(*)
  FROM PP_LINE_AD_TB (NOLOCK)
 WHERE  AD_KIND = ''B''
   AND CONVERT(VARCHAR(10),START_DT,120) = CONVERT(VARCHAR(10),GETDATE(),120)

IF DATEPART(dw,getdate()) <> 7 AND  @TOTALCNT = 0	-- 토요일 제외 (토요발행 지점이 없음)
  BEGIN
    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01028519869'',''영업박스광고 전체 누락''  -- 최봉기
    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01033931420'',''영업박스광고 전체 누락''  -- 이근우
    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01044555434'',''영업박스광고 전체 누락''  -- 권준호
--    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01031273287'',''영업박스광고 전체 누락''  -- 정헌수
  END

IF DATEPART(dw,getdate()) <> 7 AND @CNT = 0	-- 토요일 제외 (토요발행 지점이 없음)
  BEGIN
    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01028519869'',''영업박스광고 신규건 누락 (연휴기간중인 경우 무시)''  -- 최봉기
    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01033931420'',''영업박스광고 신규건 누락 (연휴기간중인 경우 무시)''  -- 이근우
    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01044555434'',''영업박스광고 신규건 누락 (연휴기간중인 경우 무시)''  -- 권준호
--    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01031273287'',''영업박스광고 신규건 누락 (연휴기간중인 경우 무시)''  -- 정헌수
  END
', 
		@database_name=N'PAPER_NEW', 
		@flags=8
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [좌표변환 장애 체크]    Script Date: 2023-05-24 오후 1:02:46 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'좌표변환 장애 체크', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @CNT INT
SET @CNT = 0

SELECT @CNT = COUNT(*)
  FROM PP_AD_MAP_POINT_TB (NOLOCK)
 WHERE GMAP_X <> ''0''
 
IF @CNT = 0
  BEGIN
    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01028519869'',''[FA] 좌표반환장애발생''  -- 최봉기
    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01033931420'',''[FA] 좌표반환장애발생''  -- 이근우
--    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01031273287'',''[FA] 좌표반환장애발생''  -- 정헌수
  END', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [부동산써브 매물 장애 체크]    Script Date: 2023-05-24 오후 1:02:46 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'부동산써브 매물 장애 체크', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @CNT INT
SET @CNT = 0

SELECT @CNT = COUNT(*)
  FROM PP_LINE_AD_TB (NOLOCK)
 WHERE INPUT_BRANCH = ''199''

IF @CNT = 0
  BEGIN
    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01044555434'',''[FA] 부동산써브 매물이관 장애발생''  -- 권준호
    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01063930923'',''[FA] 부동산써브 매물이관 장애발생''  -- 조민기
--    EXECUTE COMDB1.DBO.PUT_SENDSMS_PROC ''0230190213'',''FA SYSTEM'',''개발담당'',''01031273287'',''[FA] 부동산써브 매물이관 장애발생''  -- 정헌수
  END', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[신문_NEW] 광고취합 장애 체크/통보', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=126, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20140203, 
		@active_end_date=99991231, 
		@active_start_time=44000, 
		@active_end_time=235959, 
		@schedule_uid=N'65bf26fe-0f1d-4882-9b67-32a036693a10'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (6시 5분) 박스광고주 벼룩시장 정기구독 목록 추출]    Script Date: 2023-05-24 오후 1:02:46 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:46 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (6시 5분) 박스광고주 벼룩시장 정기구독 목록 추출', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[신문_NEW] 박스 광고주 벼룩시장 정기구독 추출]    Script Date: 2023-05-24 오후 1:02:46 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[신문_NEW] 박스 광고주 벼룩시장 정기구독 추출', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_PP_BOX_EPAPER_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[신문_NEW] 박스 광고주 벼룩시장 정기구독 추출', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20091201, 
		@active_end_date=99991231, 
		@active_start_time=60500, 
		@active_end_time=235959, 
		@schedule_uid=N'111ab51a-8033-4a08-b64f-df314393cea4'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (7시 41분) 위치정보로그 삭제]    Script Date: 2023-05-24 오후 1:02:46 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:46 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (7시 41분) 위치정보로그 삭제', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1. 위치정보 로그 삭제]    Script Date: 2023-05-24 오후 1:02:46 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1. 위치정보 로그 삭제', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_DEL_PP_LOCATION_INFO_LOG_PROC', 
		@database_name=N'MAGUSER', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1. 위치정보로그삭제', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20220607, 
		@active_end_date=99991231, 
		@active_start_time=74100, 
		@active_end_time=235959, 
		@schedule_uid=N'633bbe48-b043-40bd-ae0e-cd1ac3566171'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (9시 30분) 무료공고 게재 3일째 쿠폰발급/MMS 발송]    Script Date: 2023-05-24 오후 1:02:46 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:46 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (9시 30분) 무료공고 게재 3일째 쿠폰발급/MMS 발송', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[신문_NEW] (9시 30분) 무료공고 게재 7일째 쿠폰발급/MMS 발송]    Script Date: 2023-05-24 오후 1:02:46 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[신문_NEW] (9시 30분) 무료공고 게재 7일째 쿠폰발급/MMS 발송', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_JOB_FREE_AD_3DAY_MMS_SEND_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[신문_NEW] (9시 30분) 무료공고 게재 3일째 쿠폰발급/MMS 발송', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20180815, 
		@active_end_date=99991231, 
		@active_start_time=93000, 
		@active_end_time=235959, 
		@schedule_uid=N'11dd11a9-d896-44ff-8e01-c6856d1df155'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (매시간 10분 간격) 정액권 시간 예약건 게재 이관 확인]    Script Date: 2023-05-24 오후 1:02:46 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:46 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (매시간 10분 간격) 정액권 시간 예약건 게재 이관 확인', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[신문_NEW] 정액권 시간 예약건 게재 이관 확인]    Script Date: 2023-05-24 오후 1:02:46 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[신문_NEW] 정액권 시간 예약건 게재 이관 확인', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_CY_LINE_AD_FAT_TRANS_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[신문_NEW] 정액권 시간 예약건 게재 이관 확인', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=10, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20141122, 
		@active_end_date=99991231, 
		@active_start_time=50200, 
		@active_end_time=235800, 
		@schedule_uid=N'e99b7f46-5671-4ee4-83d3-aecb662655b2'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (매시간 13분) 구인광고 입사지원자 수]    Script Date: 2023-05-24 오후 1:02:46 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:46 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (매시간 13분) 구인광고 입사지원자 수', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'프론트 구인광고관리 입사지원 현황(입사지원자 수)', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [구인광고 입사지원자 카운트]    Script Date: 2023-05-24 오후 1:02:47 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'구인광고 입사지원자 카운트', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=2, 
		@retry_interval=3, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_APP_RESUME_COUNT_PROC
', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [구인광고 입사지원자 카운트 (지원타입별)]    Script Date: 2023-05-24 오후 1:02:47 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'구인광고 입사지원자 카운트 (지원타입별)', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=2, 
		@retry_interval=3, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC  DBO.BAT_LINEAD_APP_TYPE_COUNT_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'구인광고 입사지원 카운트', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20140319, 
		@active_end_date=99991231, 
		@active_start_time=41300, 
		@active_end_time=23000, 
		@schedule_uid=N'cc0d72f1-0d9e-4a1d-866c-bdd7201558d8'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (매시간 30분 간격) 신문 무료 광고 검수완료 목록 게제테이블 이관]    Script Date: 2023-05-24 오후 1:02:47 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:47 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (매시간 30분 간격) 신문 무료 광고 검수완료 목록 게제테이블 이관', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'--ECOMM 및 등록대행 무료 광고 검수완료 목록 게제테이블로 이동(row단위 처리)
EXEC BAT_FREEAD_LISTING_PROC', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ECOMM 및 등록대행 무료 광고 검수완료 목록 게제테이블로 이동]    Script Date: 2023-05-24 오후 1:02:47 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ECOMM 및 등록대행 무료 광고 검수완료 목록 게제테이블로 이동', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--ECOMM 및 등록대행 무료 광고 검수완료 목록 게제테이블로 이동(row단위 처리)
EXEC BAT_FREEAD_LISTING_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'ECOMM 및 등록대행 무료 광고 검수완료 목록 게제테이블로 이동', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=30, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20130911, 
		@active_end_date=99991231, 
		@active_start_time=60300, 
		@active_end_time=25900, 
		@schedule_uid=N'8f50c71e-710c-4dcb-b46d-f451a4d8ef7f'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] (월요일 0시 1분) 주말반영 게재테이블 백업]    Script Date: 2023-05-24 오후 1:02:47 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:47 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] (월요일 0시 1분) 주말반영 게재테이블 백업', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [부동산 랜덤키 업데이트]    Script Date: 2023-05-24 오후 1:02:47 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'부동산 랜덤키 업데이트', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BAT_LAND_ORD_RESET_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[신문_NEW] 주말반영 게재테이블 백업]    Script Date: 2023-05-24 오후 1:02:47 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[신문_NEW] 주말반영 게재테이블 백업', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=1, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DROP TABLE TEMP_WEEK_PP_LINE_AD_TB;
DROP TABLE TEMP_WEEK_PP_LINE_AD_AREA_1DAY_TB;
DROP TABLE TEMP_WEEK_PP_LINE_AD_EXTEND_DETAIL_HOUSE_1DAY_TB;
DROP TABLE TEMP_WEEK_PP_LINE_AD_EXTEND_DETAIL_JOB_1DAY_TB;
DROP TABLE TEMP_WEEK_PP_LINE_AD_FINDCODE_1DAY_TB;
DROP TABLE TEMP_WEEK_PP_LISTUP_ORDER_HOUSE_1DAY_TB;
DROP TABLE TEMP_WEEK_PP_LISTUP_ORDER_JOB_1DAY_TB;
DROP TABLE TEMP_WEEK_PP_MOBILE_LISTUP_ORDER_HOUSE_1DAY_TB;
DROP TABLE TEMP_WEEK_PP_MOBILE_LISTUP_ORDER_JOB_1DAY_TB;

SELECT *
 INTO TEMP_WEEK_PP_LINE_AD_TB
 FROM PP_LINE_AD_TB (NOLOCK)

SELECT *
INTO TEMP_WEEK_PP_LINE_AD_AREA_1DAY_TB
FROM PP_LINE_AD_AREA_1DAY_TB (NOLOCK)

SELECT *
INTO TEMP_WEEK_PP_LINE_AD_EXTEND_DETAIL_HOUSE_1DAY_TB
FROM PP_LINE_AD_EXTEND_DETAIL_HOUSE_1DAY_TB (NOLOCK)

SELECT *
INTO TEMP_WEEK_PP_LINE_AD_EXTEND_DETAIL_JOB_1DAY_TB
FROM PP_LINE_AD_EXTEND_DETAIL_JOB_1DAY_TB (NOLOCK)

SELECT *
INTO TEMP_WEEK_PP_LINE_AD_FINDCODE_1DAY_TB
FROM PP_LINE_AD_FINDCODE_1DAY_TB (NOLOCK)

SELECT *
INTO TEMP_WEEK_PP_LISTUP_ORDER_HOUSE_1DAY_TB
FROM PP_LISTUP_ORDER_HOUSE_1DAY_TB (NOLOCK)

SELECT *
INTO TEMP_WEEK_PP_LISTUP_ORDER_JOB_1DAY_TB
FROM PP_LISTUP_ORDER_JOB_1DAY_TB (NOLOCK)

SELECT *
INTO TEMP_WEEK_PP_MOBILE_LISTUP_ORDER_HOUSE_1DAY_TB
FROM PP_MOBILE_LISTUP_ORDER_HOUSE_1DAY_TB (NOLOCK)

SELECT *
INTO TEMP_WEEK_PP_MOBILE_LISTUP_ORDER_JOB_1DAY_TB
FROM PP_MOBILE_LISTUP_ORDER_JOB_1DAY_TB (NOLOCK)
', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[신문_NEW] 주말반영 게재테이블 백업', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=2, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20120901, 
		@active_end_date=99991231, 
		@active_start_time=100, 
		@active_end_time=235959, 
		@schedule_uid=N'8ddc06c6-8c53-4ef0-a8f6-198bd78a639b'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] 벼룩시장구인구직어플 PUSH 발송 로그 카운트]    Script Date: 2023-05-24 오후 1:02:47 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:47 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] 벼룩시장구인구직어플 PUSH 발송 로그 카운트', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[신문_NEW] 벼룩시장구인구직어플 PUSH 발송 로그 카운트]    Script Date: 2023-05-24 오후 1:02:48 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[신문_NEW] 벼룩시장구인구직어플 PUSH 발송 로그 카운트', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE BAT_APP_JOB_PUSH_LOG_COUNT_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[신문_NEW] 벼룩시장구인구직어플 PUSH 발송 로그 카운트', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=3, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20130524, 
		@active_end_date=99991231, 
		@active_start_time=84500, 
		@active_end_time=200000, 
		@schedule_uid=N'2e8fcd50-354f-4e18-9869-87c59b044cba'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] 벼룩시장구인구직어플 맞춤정보 발송 대상 선별]    Script Date: 2023-05-24 오후 1:02:48 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:48 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] 벼룩시장구인구직어플 맞춤정보 발송 대상 선별', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'맞춤정보 설정 값으로 발송대상 선별', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[신문_NEW] 벼룩시장구인구직어플 맞춤정보 발송 대상 선별]    Script Date: 2023-05-24 오후 1:02:48 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[신문_NEW] 벼룩시장구인구직어플 맞춤정보 발송 대상 선별', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE BAT_APP_JOB_CUSTOM_SET_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[신문_NEW] 벼룩시장구인구직어플 맞춤정보 발송 대상 선별', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=126, 
		@freq_subday_type=8, 
		@freq_subday_interval=3, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20130524, 
		@active_end_date=99991231, 
		@active_start_time=83000, 
		@active_end_time=200000, 
		@schedule_uid=N'a3300d27-ada6-4c1f-bc4c-c4f49dc6aa4c'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] 분류별 줄광고수 갱신]    Script Date: 2023-05-24 오후 1:02:48 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:48 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] 분류별 줄광고수 갱신', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[신문_NEW] 분류별 줄광고수 갱신]    Script Date: 2023-05-24 오후 1:02:48 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[신문_NEW] 분류별 줄광고수 갱신', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE EXEC_CATEGORY_LINEAD_COUNT_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[신문_NEW] 파인드코드 분류별 줄광고수 갱신 (지역판)]    Script Date: 2023-05-24 오후 1:02:48 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[신문_NEW] 파인드코드 분류별 줄광고수 갱신 (지역판)', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE EXEC_CATEGORY_LINEAD_LOCAL_COUNT_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[신문_NEW] 분류별 줄광고수 갱신', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=126, 
		@freq_subday_type=8, 
		@freq_subday_interval=3, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20141028, 
		@active_end_date=99991231, 
		@active_start_time=61000, 
		@active_end_time=191000, 
		@schedule_uid=N'4549612e-cc5f-407a-8562-5e9585561b49'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] 시간 예약건 게재 이관 (정액권 포함) (10분단위)]    Script Date: 2023-05-24 오후 1:02:49 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:49 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] 시간 예약건 게재 이관 (정액권 포함) (10분단위)', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'예약공고 건 해당 시간마다 게재 처리', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [예약공고 건 게재 이관]    Script Date: 2023-05-24 오후 1:02:49 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'예약공고 건 게재 이관', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE BAT_PP_AD_RESERVE_TB_PROC

--EXECUTE BAT_CY_LINE_AD_FAT_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[신문_NEW] 예약공고 건 게재 이관', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=10, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20140918, 
		@active_end_date=99991231, 
		@active_start_time=50030, 
		@active_end_time=1000, 
		@schedule_uid=N'e6d14195-2a26-4904-8939-c6dfad9c7a56'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_NEW] 지역별 구인구직,부동산 광고 갯수 (3시간단위)]    Script Date: 2023-05-24 오후 1:02:49 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:49 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_NEW] 지역별 구인구직,부동산 광고 갯수 (3시간단위)', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'지역별 줄광고 갯수', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [지역별 구인구직 줄광고 갯수]    Script Date: 2023-05-24 오후 1:02:50 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'지역별 구인구직 줄광고 갯수', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_AREA_JOB_AD_COUNT', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [지역별/분류별/타입별 부동산 갯수]    Script Date: 2023-05-24 오후 1:02:50 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'지역별/분류별/타입별 부동산 갯수', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=2, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec BAT_AREA_HOUSE_AD_COUNT', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[신문_NEW] 지역별 구인구직 광고 갯수 (3시간)', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=3, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20121106, 
		@active_end_date=99991231, 
		@active_start_time=60600, 
		@active_end_time=233059, 
		@schedule_uid=N'7475490d-2b42-4c82-98cf-52061b26974e'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[신문_제휴] (5시 30분) 벼룩시장 광고 API 제공]    Script Date: 2023-05-24 오후 1:02:50 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:50 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[신문_제휴] (5시 30분) 벼룩시장 광고 API 제공', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'벼룩시장 게재기준 광고를 매일 취합 후, PARTNERSHIP 데이터 베이스로 이관한다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [게재데이터 이관]    Script Date: 2023-05-24 오후 1:02:50 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'게재데이터 이관', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=3, 
		@retry_interval=5, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC GET_API_AD_DATA_PROC', 
		@database_name=N'PARTNERSHIP', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'매일 스케쥴', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20150403, 
		@active_end_date=99991231, 
		@active_start_time=53000, 
		@active_end_time=235959, 
		@schedule_uid=N'20036621-f0b5-4064-a69d-f0e2b974ef23'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[알바정보] 인기 알바 광고 가져오기(30분단위)]    Script Date: 2023-05-24 오후 1:02:50 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:50 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[알바정보] 인기 알바 광고 가져오기(30분단위)', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'인기 알바 광고 가져오기', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [인기 알바 광고 가져오기]    Script Date: 2023-05-24 오후 1:02:50 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'인기 알바 광고 가져오기', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=3, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_JOB_ALBA_FAVOR_AD_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[알바정보] 인기 알바 광고 가져오기', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=30, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20141104, 
		@active_end_date=99991231, 
		@active_start_time=34200, 
		@active_end_time=15959, 
		@schedule_uid=N'9cdd24c5-1f6a-4aaf-ab31-5243b6179123'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[알바정보] 지역별/직종별 광고 수(30분단위)]    Script Date: 2023-05-24 오후 1:02:50 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:50 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[알바정보] 지역별/직종별 광고 수(30분단위)', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [알바정보 지역별 광고 수]    Script Date: 2023-05-24 오후 1:02:51 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'알바정보 지역별 광고 수', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_JOB_AREA_ALBA_AD_COUNT', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [알바정보 직종별 광고 수]    Script Date: 2023-05-24 오후 1:02:51 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'알바정보 직종별 광고 수', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_JOB_CATEGORY_ALBA_AD_COUNT', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[알바정보] 지역별/직종별 광고 수', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=30, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20141104, 
		@active_end_date=99991231, 
		@active_start_time=34600, 
		@active_end_time=15959, 
		@schedule_uid=N'81c3d971-4ad0-41a0-b69e-196edf74e032'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[운영팀] (08:47) 무료공고 이용고객]    Script Date: 2023-05-24 오후 1:02:51 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:51 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[운영팀] (08:47) 무료공고 이용고객', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1]    Script Date: 2023-05-24 오후 1:02:51 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'SET NOCOUNT ON

DECLARE @STARTDATE VARCHAR(10)
DECLARE @ENDDATE VARCHAR(10)
DECLARE @tableHTML  NVARCHAR(MAX) 
DECLARE @subject2 VARCHAR(100)
SET @ENDDATE = CONVERT(VARCHAR(10),GETDATE(),120) 

SET @subject2 =''[운영팀] 무료 공고 이용 고객 '' + @ENDDATE 


SELECT * 
INTO #ECOMM_TEMP01
FROM
(
SELECT 
	A.CUID -- 회원번호
	,A.USER_ID
	,A.FIELD_6 -- 상호명
	,A.LINEADNO
	,A.END_DT
	,A.PHONE
	,ROW_NUMBER() OVER (PARTITION BY A.CUID ORDER BY A.END_DT DESC, A.LINEADID DESC) RANKING
FROM PAPER_NEW.DBO.PP_AD_TB A WITH(NOLOCK)
INNER JOIN PAPER_NEW.DBO.PP_OPTION_TB B WITH(NOLOCK) ON A.LINEADNO = B.LINEADNO
	WHERE A.REG_DT >= DATEADD(DD,-1,CONVERT(VARCHAR(10),GETDATE(),120)) AND A.REG_DT < CONVERT(VARCHAR(10),GETDATE(),120) -- 어제 기준
	AND A.[VERSION] = ''E''
	AND A.GROUP_CD = 14
	AND A.NEWMEDIA = 0
	AND B.OPT_START_DT IS NULL AND B.OPT_END_DT IS NULL
)A
WHERE RANKING = 1



-- 2. 무료 공고 중 마케팅 수신 동의만 추출
SELECT 
	A.USER_ID [ID]
	,A.FIELD_6 [상호]
	,A.END_DT [종료일자]
	,CASE WHEN A.PHONE = '''' OR A.PHONE IS NULL THEN B.HPHONE ELSE A.PHONE END [전화번호]
INTO #ECOMM_TEMP02
FROM #ECOMM_TEMP01 A
INNER JOIN [MEMBERDB].MWMEMBER.DBO.CST_MASTER B WITH(NOLOCK) ON A.CUID = B.CUID
INNER JOIN [MEMBERDB].MWMEMBER.DBO.CST_MARKETING_AGREEF_TB C WITH(NOLOCK) ON A.CUID=C.CUID
AND B.REST_YN=''N'' --- 휴면회원 제외
AND B.OUT_YN=''N''  --- 탈퇴회원 제외
AND B.BAD_YN=''N''  --- 불량회원 제외
AND C.AGREEF=1    --- 수신동의 및 마케팅 동의 1 비동의 0
AND NOT EXISTS  -- 기존 추출한 USERID는 제외
	( SELECT 1 FROM [DBA].[DBO].[PP_ECOME_FREE_AD_USERID_20230221] S1 WHERE S1.USER_ID = A.USER_ID)
ORDER BY 3 DESC


-- 3. USERID의 중복을 방지하기 위해 이력을 쌓는다..
INSERT INTO [DBA].[DBO].[PP_ECOME_FREE_AD_USERID_20230221]
SELECT ID, GETDATE() FROM #ECOMM_TEMP02


SET @tableHTML =
	N''<H1> </H1>'' +
	N''<table border="1">'' +
	N''<tr><th>ID</th>'' +
	N''<th>상호</th>'' +
  N''<th>종료일자</th>'' +
	N''<th>전화번호</th>'' +
	N''</tr>'' +
    CAST ( (
       SELECT td =  ID , ''''
,td =  상호  , ''''
,td =  종료일자 , ''''
,td =  전화번호
FROM 
(
     
        SELECT ID, 상호, 종료일자, 전화번호 FROM #ECOMM_TEMP02
  )a

    FOR XML PATH(''tr''), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N''</table>'' ;
EXEC msdb.dbo.sp_send_dbmail 
	@profile_name =''DBAMAIL'',
  @recipients=''got@mediawill.com;ciiciicii@mediawill.com;bomi1224@mediawill.com;jincheal2@mediawill.com;avoveall@mediawill.com;jy3225@mediawill.com;'',
    @subject = @subject2,
    @body = @tableHTML,
    @body_format = ''HTML'' ;


', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20230222, 
		@active_end_date=99991231, 
		@active_start_time=84700, 
		@active_end_time=235959, 
		@schedule_uid=N'1d02db94-5813-4109-a740-231b3c4c5a9f'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[운영팀] (09:08) 재계약 불발 건]    Script Date: 2023-05-24 오후 1:02:51 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:51 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[운영팀] (09:08) 재계약 불발 건', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1]    Script Date: 2023-05-24 오후 1:02:51 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'

DECLARE @DATE1 VARCHAR(10)
DECLARE @subject2 VARCHAR(100)
DECLARE @tableHTML  NVARCHAR(MAX) 
SET @DATE1 = SUBSTRING(CONVERT(VARCHAR(10),getdate(),120),6,5)




SET @subject2 =''[운영팀] 재계약 불발 건 ('' + @DATE1 + '')''



  DECLARE @YDATE VARCHAR(10)
  DECLARE @DATE VARCHAR(10)

  SET @YDATE =  CONVERT(VARCHAR(10),GETDATE()-1,120)
  SET @DATE =  CONVERT(VARCHAR(10),GETDATE(),120)

  

  ---정액권 제외

  SELECT c.cuid, C.LINEADID,C.REG_DT, C.USER_ID, C.ORDER_NAME, C.AREA_A, C.AREA_B, C.AREA_C, C.GROUP_CD        
        , CASE WHEN C.STANDARD_CNT > 0 THEN 
            CASE WHEN KW_OPT_CODE > 0 THEN C.PRNAMTOK ELSE 1 END
          ELSE C.PrnAmtOk END AS PrnAmtOk   
        , C.ChargeKind, C.START_DT, C.END_DT, C.INPUT_BRANCH, C.LAYOUT_BRANCH, C.CancelDate    
        , C.OPT_CODE, C.PrnAmt, C.ACCENT_OPT, C.COLOR_OPT    
        , C.PAYFREE, C.WLOCAL, C.PP_LINEADID, C.CNT    
        , C.DELYN, C.INIPAYTID, C.PUB_LOGO, C.DETAILADCODE    
        , C.FIELD_2, C.FIELD_4, C.FIELD_6, C.FIELD_9, C.RecDate, C.JOB_ORDER_DT, C.DISP_DT, C.MOBILE_ORDER_DT    
        , C.STATUS, C.TITLE, CONVERT(VARCHAR(10),C.OPT_START_DT,11) AS OPT_START_DT, CONVERT(VARCHAR(10),C.OPT_END_DT,11) AS OPT_END_DT, C.CONFIRM_DT, C.COMMENT    
        , C.MOBILE_OPT_CODE, C.FAT_NM, C.USE_CNT, C.FAT_REGIST_START_DT, C.FAT_REGIST_END_DT    
        , C.BR_SEQ, C.BRANCH_CODE, C.DISPLAY_OPT, C.IMPACT_LOGO, C.OPT_AREA, C.REG_SUB_BRANCH, C.PHONE , C.BANKNM, C.ACCOUNTNUM, C.COUPON_AMOUNT, C.IssueCount, C.LINEAMOUNT, C.STANDARD_CNT, C.RESERVE_START_DT, C.RESERVE_END_DT  , NULL AS HTML_FLAG     
    , '''' AS CODENM3    
    , '''' AS CODENM4    
    , 0 AS APP_ONLINE_CNT    
    , 0 AS APP_EMAIL_CNT    
    , 0 AS APP_SMS_CNT    
     , C.CNT_W, C.CNT_MW, C.CNT_MA_ANDROID, C.CNT_MA_IPHONE, C.APP_CNT_PC, C.APP_CNT_MO ,C.ENDYN  
        , C.LINEADNO    
        , CASE WHEN HOLD.STAT IS NOT NULL THEN ''보류'' ELSE '''' END + CASE WHEN HOLD.STAT = 0 THEN ''(잔여일 '' + CAST(HOLD.REMAINCOUNT AS VARCHAR) +''일)'' ELSE '''' END AS HOLDSTR    
        ,  ISNULL(HOLD.SEQ,0) AS HOLDSEQ    
        , FTG.LINEADNO AS FTG_LINEADNO    
        , C.UPRIGHT_AGREE  
        , C.FAT_ID_DP  
        , C.REGIST_ID_DP  
        , C.DISPLAY_GOODS_ID  
        , C.DISPLAY_GOODS_ID_CNT  
        , C.START_DT_DP  
        , C.END_DT_DP  
        , C.USE_CNT_DP  
        , C.USE_CNT_TOTAL_DP   , CASE WHEN C.KEYWORD_SEARCH_ADID IS NULL THEN '''' ELSE ''적용'' END AS KEYWORD_SEARCH_ADID  
        , C.KW_OPT_CODE
        , C.NEWAD_YN,mag_id
        into #temp011
          FROM CY_LINE_AD_MANAGE_JOB_VI AS C WITH(NOLOCK)    
          LEFT JOIN PP_AD_FREE_TO_GOOD_TB AS FTG WITH(NOLOCK) ON C.LINEADNO = FTG.LINEADNO    
          LEFT OUTER JOIN PP_AD_HOLDOFF_TB HOLD WITH(NOLOCK) ON HOLD.LINEADNO = C.LINEADNO 
                 
             
        WHERE 1 = 1  AND ((C.STATUS IS NULL AND C.ChargeKind IS NOT NULL AND C.PrnAmtOk = ''1'') OR C.OPT_CODE = 18 OR C.PAY_FREE = 1)  AND NOT EXISTS (SELECT LINEADNO FROM PP_BRAND_AD_TB AS H WITH(NOLOCK) WHERE H.LINEADID = C.LINEADID AND H.INPUT_BRANCH = C.INPUT_BRANCH AND H.LAYOUT_BRANCH = C.LAYOUT_BRANCH)  
        AND (C.OPT_END_DT >=  @YDATE AND C.OPT_END_DT < @DATE)    
        and fat_nm is null
------------------

select *
INTO #TEMP022
from (
        select cuid, USER_ID,LINEADID,
            CASE 
           WHEN PAPER_NEW.DBO.FN_INETOPTNAME
                (OPT_CODE,MOBILE_OPT_CODE, DISPLAY_OPT, GROUP_CD) IS NULL 
	         THEN ''무료''
	         ELSE PAPER_NEW.DBO.FN_INETOPTNAME
			          (OPT_CODE, MOBILE_OPT_CODE, DISPLAY_OPT, GROUP_CD) 
		        END ''상품명'', PRNAMT  , FIELD_6, LINEADNO, phone, OPT_END_DT, order_name, mag_id 
        from #temp011
)a
        where [상품명] <>''즉시등록''

  
  
  --------어제 오늘 결제 안한 사람

  
SELECT *
INTO #TEMP01
FROM (
  SELECT C.LINEADID,C.REG_DT,dbo.FN_GET_USERID_SECURE(C.USER_ID) AS USER_ID,dbo.FN_GET_USERNM_SECURE(C.ORDER_NAME,1,''M'') AS ORDER_NAME,
	  C.AREA_A,C.AREA_B,C.AREA_C,C.GROUP_CD,C.PrnAmtOk,C.ChargeKind,C.START_DT,C.END_DT,C.INPUT_BRANCH,C.LAYOUT_BRANCH,C.RecDate,C.CancelDate,C.OPT_CODE,C.PrnAmt,C.ACCENT_OPT,C.COLOR_OPT,C.INIPAYTID,C.PP_LINEADID,C.DETAILADCODE,C.MOBILE_OPT_CODE,NULL AS FAT_NM,NULL AS FAT_STATE,C.SERIAL,C.TaxBill_YN,C.DISPLAY_OPT,C.REG_SUB_BRANCH,C.COUPON_AMOUNT,C.IssueCount,C.LINEAMOUNT,C.DEL_YN,C.JUMINNO,C.COMMENT,C.LINEADNO,C.REST_AMT,C.CARDCODE,C.ENDYN,DBO.FN_GET_INFLOW_ROUTE(C.INFLOW_ROUTE) AS INFLOW_ROUTE,C.CUID,C.OPT_START_DT,C.OPT_END_DT,C.KEYWORD_SEARCH_ADID AS KEYWORDSEARCHADID, 0 AS KW_OPT_CODE, NULL AS NEWAD_YN
  FROM PP_MAG_ECOMM_PAY_LIST_VI C  WITH(NOLOCK)
  WHERE 1=1  AND C.ChargeKind IS NOT NULL AND C.PrnAmtOk = ''1'' 
  AND C.RecDate >=@YDATE --AND C.RecDate <''2023-02-21''
  UNION ALL
  SELECT DISTINCT B.REGIST_ID,B.REG_DT,B.USER_ID AS USER_ID
  ,'''' AS USERNAME,NULL AS AREA_A,NULL AS AREA_B,NULL AS AREA_C,NULL AS GROUP_CD,A.PRNAMTOK,A.CHARGEKIND,B.START_DT,B.END_DT,181 AS INPUT_BRANCH,B.LAYOUT_BRANCH,A.RECDATE,A.CANCELDATE,C.OPT_CODE,A.PRNAMT,NULL AS ACCENT_OPT,NULL AS COLOR_OPT,A.INIPAYTID,NULL AS PP_LINEADID,NULL AS DETAILADCODE,NULL AS MOBILE_OPT_CODE,C.FAT_NM + ''['' + CONVERT(VARCHAR(10), C.STANDARD_CNT) + ''회]'' AS FAT_NM,CASE WHEN B.DEL_YN = ''Y'' THEN ''사용종료'' WHEN A.PRNAMTOK = 1 AND B.START_DT > GETDATE() THEN ''사용전'' WHEN A.PRNAMTOK = 1 AND B.START_DT <= GETDATE() AND B.END_DT >= GETDATE() AND B.REM_CNT > 0 THEN ''사용중'' WHEN A.PRNAMTOK = 1 AND B.END_DT < GETDATE() OR B.REM_CNT = 0 THEN ''사용종료'' WHEN A.PRNAMTOK = 2 THEN ''사용종료'' WHEN A.PRNAMTOK = 0 AND B.END_DT > GETDATE() THEN ''사용전'' WHEN A.PRNAMTOK = 0 AND B.END_DT < GETDATE() THEN ''사용종료'' END AS FAT_STATE,A.SERIAL,A.TaxBill_YN,0 AS DISPLAY_OPT,B.REG_SUB_BRANCH,CUD.COUPON_AMOUNT,0 AS IssueCount,0 AS LINEAMOUNT,'''' AS DEL_YN,NULL AS JUMINNO,A.COMMENT, '''' AS LINEADNO,A.REST_AMT,A.CARDCODE, '''' AS ENDYN,DBO.FN_GET_INFLOW_ROUTE(A.INFLOW_ROUTE) AS INFLOW_ROUTE,B.CUID,B.START_DT AS OPT_START_DT,B.END_DT AS OPT_END_DT,NULL AS KEYWORDSEARCHADID, 0 AS KW_OPT_CODE, NULL AS NEWAD_YN
  FROM PP_ECOMM_RECCHARGE_TB A WITH(NOLOCK)
  JOIN CY_FAT_REGIST_TB B WITH(NOLOCK) ON A.ADID = B.REGIST_ID AND A.PRODUCT_GBN = 2
  JOIN CY_FAT_MASTER_TB C WITH(NOLOCK) ON B.FAT_ID = C.FAT_ID
  LEFT JOIN PP_COUPON_USE_DETAIL_TB AS CUD WITH(NOLOCK) ON CUD.RECCHARGE_SERIAL = A.SERIAL
  WHERE REGIST_GBN = 0 AND B.ISSTORAGE = 0
   AND ChargeKind IS NOT NULL AND PrnAmtOk = ''1'' AND RecDate >=  @YDATE --AND RecDate <''2023-02-21''

  UNION ALL 
  SELECT A.LINEADID
  ,B.REG_DT
  ,B.USER_ID AS USER_ID
  ,B.ORDER_NAME
  ,B.AREA_A
  ,B.AREA_B
  ,B.AREA_C
  ,B.GROUP_CD AS GROUP_CD
  ,PRNAMTOK AS PRNAMTOK
  ,CHARGEKIND AS CHARGEKIND
  ,A.START_DT AS START_DT
  ,A.END_DT AS END_DT
  ,A.INPUT_BRANCH
  ,A.LAYOUT_BRANCH
  ,RECDATE AS RECDATE
  ,CANCELDATE AS CANCELDATE
  ,ISNULL(O.OPT_CODE, 87) AS OPT_CODE
  ,ISNULL(PRNAMT, 0) AS PRNAMT
  ,NULL AS ACCENT_OPT
  ,NULL AS COLOR_OPT
  ,A.INIPAYTID
  ,C.LINEADID AS PP_LINEADID
  ,NULL AS DETAILADCODE
  ,ISNULL(O.MOBILE_OPT_CODE, 0) AS MOBILE_OPT_CODE
  ,NULL AS FAT_NM
  ,NULL AS FAT_STATE
  ,A.SERIAL AS SERIAL
  ,A.TAXBILL_YN
  ,0 AS DISPLAY_OPT
  ,0 AS REG_SUB_BRANCH
  ,CUD.COUPON_AMOUNT
  ,0 AS ISSUECOUNT
  ,0 AS LINEAMOUNT
  ,B.DELYN
  ,NULL AS JUMINNO
  ,A.COMMENT
  ,A.LINEADNO AS LINEADNO
  ,ISNULL(A.REST_AMT, 0) AS REST_AMT
  ,A.CARDCODE
  ,B.ENDYN
  ,DBO.FN_GET_INFLOW_ROUTE(A.INFLOW_ROUTE) AS INFLOW_ROUTE
  ,A.CUID
  ,A.START_DT AS OPT_START_DT
  ,A.END_DT AS OPT_END_DT
  ,A.KEYWORDSEARCHADID
  ,87 AS KW_OPT_CODE
  ,A.NEWAD_YN
    FROM V_PP_JOB_KEYWORDSEARCH_PAY AS A WITH(NOLOCK)
    JOIN PP_AD_TB AS B WITH(NOLOCK) ON B.LINEADNO = A.LINEADNO
    LEFT JOIN PP_OPTION_TB O WITH(NOLOCK) ON O.LINEADNO = B.LINEADNO
    LEFT JOIN PP_LINE_AD_TB AS C WITH(NOLOCK) ON C.LINEADNO = A.LINEADNO
    LEFT JOIN PP_COUPON_USE_DETAIL_TB AS CUD WITH(NOLOCK) ON CUD.RECCHARGE_SERIAL = A.SERIAL 
   WHERE 1=1  AND A.ChargeKind IS NOT NULL AND A.PrnAmtOk = ''1'' AND RecDate >= @YDATE
)A
----------
-------정액권

;WITH RESULT_TABLE AS (
  SELECT 
    F.REGIST_ID,          --등록번호

    F.USER_ID,
    F.MAG_REGIST_BRANCH,  --접수지점
    M.FAT_ID,              --상품번호
    M.FAT_NM,              --상품명
    CONVERT(VARCHAR(10), F.R_RECDATE, 111) AS RECDATE,            --결제일
    F.START_DT,            --시작일
    F.END_DT,              --종료일
    F.STANDARD_CNT,        --기준횟수
    ISNULL(CASE WHEN M.FAT_TYPE IN (1, 3) THEN (SELECT SUM(ISNULL(USE_CNT, 0)) FROM dbo.CY_FAT_AD_MAPPING_TB H WITH(NOLOCK) WHERE F.FAT_ID = H.FAT_ID AND F.REGIST_ID = H.REGIST_ID)
         WHEN M.FAT_TYPE = 2 THEN (SELECT SUM(ISNULL(USE_CNT_TOTAL, 0)) FROM dbo.CY_FAT_AD_DISPLAY_GOOD_TB H WITH(NOLOCK) WHERE F.FAT_ID = H.FAT_ID AND F.REGIST_ID = H.REGIST_ID)
    END, 0) AS USE_CNT,
    F.REM_CNT,            --잔여횟수
    F.R_SERIAL AS SERIAL,              --결제번호
    F.R_PRNAMT AS PRNAMT,              --결제금액
    F.REGIST_GBN,          --등록구분(0:E-COMM 1:등록대행)
    F.R_PRNAMTOK AS PRNAMTOK,            --결제상태(0:입금전, 1:결제완료, 2:결제취소)
    F.DEL_YN,
    F.COUPON_AMOUNT,    --쿠폰 금액
    F.MAG_REGIST_NM AS REG_ID,      --접수자 ID
    F.MAG_PROC_BRANCH,    --처리지점
    MM.COM_NM,         --회원 상호명
    F.CUID,
    F.ISSTORAGE,
    CASE WHEN WR.ADID_PPAD IS NULL THEN -1
                                  ELSE ISNULL(WR.adid_wills,0)
                                  END
    AS WILLS_ADID
    ,F.REG_TYPE
    ,F.SERVICEF
    ,F.SERVICE_REASON
    ,F.CUSTOMER_CD
    ,F.MINUS_POINT
    ,F.DISCOUNT_PRICE
    ,F.ORG_AMOUNT
    ,F.MW_ID
    ,F.MAG_CHARGE_GBN
	,WR.CUSTCODE
  , MAG_PROC_ID
  FROM CY_FAT_REGIST_TB_VI AS F  WITH (NOLOCK)
  JOIN CY_FAT_MASTER_TB AS M WITH(NOLOCK) ON F.FAT_ID = M.FAT_ID
  LEFT OUTER JOIN MEMBERDB.MWMEMBER.DBO.CST_MASTER AS CM WITH(NOLOCK) ON CM.CUID = F.CUID
  LEFT OUTER JOIN MEMBERDB.MWMEMBER.DBO.CST_COMPANY AS MM WITH(NOLOCK) ON CM.COM_ID = MM.COM_ID
  LEFT OUTER JOIN PP_AD_WILLS_RELATION_TB AS WR WITH(NOLOCK) ON WR.ADID_PPAD = F.REGIST_ID AND WR.ADTYPE = 2
 WHERE F.R_PRNAMTOK IN (1, 2)
   AND F.END_DT >= @YDATE AND F.END_DT < @DATE  AND F.REGIST_GBN = 0 ) 
   SELECT CUID, USER_ID, REGIST_ID, FAT_NM, PRNAMT, COM_NM, MAG_PROC_ID
   INTO #TEMP_CY_FAT
   FROM  RESULT_TABLE



SET @tableHTML =
	N''<H1></H1>'' +
	N''<table border="1">'' +
	N''<tr><th>계정</th>'' +
  N''<th>공고번호</th>'' +
	N''<th>상품명</th>'' +
	N''<th>금액</th>'' +
	N''<th>상호명</th>'' +
	N''<th>전화번호</th>'' +
	N''<th>고객명</th>'' +
	N''<th>담당자</th>'' +
  N''</tr>'' +
    CAST ( (
       select  td = USER_ID, ''''
       , td = LINEADID, ''''
       , td = [상품명], ''''
       , td = PrnAmt, ''''
       , td = [상호] , ''''
       , td = HPONE, ''''
       , td = USER_NM , ''''
       , td = MAG_NAME
FROM (

SELECT USER_ID, LINEADID, [상품명], PrnAmt, FIELD_6 [상호] 
, CASE WHEN PHONE IS NULL OR PHONE ='''' THEN HPHONE ELSE PHONE END HPONE, USER_NM
,ISNULL(CASE WHEN MAG_ID = ''avoveall123'' THEN ''김수경''
     WHEN MAG_ID = ''july3579'' THEN ''성시연''
     WHEN MAG_ID = ''bomi1224'' THEN ''신가은''
     WHEN MAG_ID = ''naeunha8589'' THEN ''하나은''
     WHEN MAG_ID = ''SOSUI'' THEN ''소시정'' 
     WHEN MAG_ID = ''jy2348'' THEN ''김지연''
     WHEN MAG_ID = ''ljs2'' THEN ''이진숙'' 
     WHEN MAG_ID = ''iii04'' THEN ''김수경''     
     END,'''') MAG_NAME
FROM (
 SELECT B.*
 FROM (
    SELECT * 
    FROM (
        SELECT CUID, USER_ID, LINEADID, 상품명, PRNAMT, FIELD_6 , PHONE
        , ROW_NUMBER() OVER(PARTITION BY USER_ID ORDER BY LINEADID) RANKING,mag_id
        FROM (
          SELECT CUID, USER_ID, LINEADID, 상품명, PRNAMT, FIELD_6 , PHONE, mag_id
          FROM #TEMP022-- 비정액권
          UNION ALL
          SELECT CUID, USER_ID, REGIST_ID, FAT_NM, PRNAMT, COM_NM ,'''', MAG_PROC_ID
          FROM #TEMP_CY_FAT --정액권
        )A
        )a
     WHERE RANKING =1
 
    ) b  LEFT JOIN #TEMP01 C
    ON B.CUID = C.CUID 
    WHERE C.LINEADID IS NULL
)a   LEFT OUTER JOIN MEMBERDB.MWMEMBER.DBO.CST_master AS MM WITH(NOLOCK) ON A.CUID = MM.CUID
   LEFT JOIN [MEMBERDB].MWMEMBER.DBO.CST_MARKETING_AGREEF_TB B WITH(NOLOCK) 
   ON B.CUID=A.CUID
       WHERE MM.REST_YN=''N'' --- 휴면회원 제외
	              AND MM.OUT_YN=''N''  --- 탈퇴회원 제외
                AND MM.BAD_YN=''N''  --- 불량회원 제외
                AND B.AGREEF=1    --- 수신동의 및 마케팅 동의 1 비동의 0
)a




  FOR XML PATH(''tr''), TYPE 
      ) AS NVARCHAR(MAX) ) +
      N''</table>'' ;

EXEC msdb.dbo.sp_send_dbmail 
	@profile_name =''DBAMAIL'',
  @recipients=''got@mediawill.com;ciiciicii@mediawill.com;avoveall@mediawill.com;jy3225@mediawill.com;jincheal2@mediawill.com;bomi1224@mediawill.com;'',
    @subject = @subject2,
    @body = @tableHTML,
    @body_format = ''HTML'' ;
', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20230222, 
		@active_end_date=99991231, 
		@active_start_time=90800, 
		@active_end_time=235959, 
		@schedule_uid=N'38a7e4e8-2d79-4189-8904-4995af0cf1d0'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[운영팀] (09시 15분) 운영팀원 신규매출 저장]    Script Date: 2023-05-24 오후 1:02:51 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:51 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[운영팀] (09시 15분) 운영팀원 신규매출 저장', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'CFM\onsdb', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1]    Script Date: 2023-05-24 오후 1:02:52 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC STATS.dbo.BAT_PUT_MANAGER_AMT_PROC', 
		@database_name=N'STATS', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20220222, 
		@active_end_date=99991231, 
		@active_start_time=91500, 
		@active_end_time=235959, 
		@schedule_uid=N'6e76b6ee-b93a-4f70-afda-45bd67dab3bf'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[운영팀] (17:02) 이컴 결제 고객 수]    Script Date: 2023-05-24 오후 1:02:52 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:52 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[운영팀] (17:02) 이컴 결제 고객 수', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'2023/04/17 운영팀 김종철 팀장님 요청사항
- 이컴 결제 고객 (구인/정액권/이력서 열람 및 상품/서비스 고객 수) 
- 총 고객수는 중복 제거 후매월 1일~ 당일 17:00 누적고객', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1]    Script Date: 2023-05-24 오후 1:02:52 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'SET NOCOUNT ON

DECLARE @REG_DT_FROM VARCHAR(10) = CONVERT(CHAR(7),GETDATE(),121)+''-01''
DECLARE @REG_DT_TO VARCHAR(10) = CONVERT(CHAR(10),GETDATE(),120)

DECLARE @tableHTML  NVARCHAR(MAX) 
DECLARE @subject2 VARCHAR(100)


SET @subject2 =''[운영팀] 이컴 결제 고객 수 '' + @REG_DT_FROM + ''~'' + @REG_DT_TO 


SET @tableHTML =
	N''<H1> </H1>'' +
	N''<table border="1">'' +
	N''<tr><th>구분</th>'' +
	N''<th>고객수</th>'' +
	N''</tr>'' +
    CAST ( (
       SELECT td =  구분 , ''''
,td =  고객수,  ''''
FROM 
(
     
        -- 구인/정액권 결제 내역
SELECT ''구인/정액권/이력서열람 결제 고객 수'' [구분], COUNT(DISTINCT(CUID)) [고객수] FROM
(
SELECT C.CUID
FROM PP_MAG_ECOMM_PAY_LIST_VI C  WITH(NOLOCK)		
WHERE 1=1  AND C.ChargeKind IS NOT NULL AND C.PrnAmtOk = ''1'' AND (C.REG_DT >= CONVERT(DATETIME, @REG_DT_FROM) AND C.REG_DT <= CONVERT(DATETIME, @REG_DT_TO + '' 23:59:59''))

UNION ALL
SELECT B.CUID
FROM PP_ECOMM_RECCHARGE_TB A WITH(NOLOCK)
JOIN CY_FAT_REGIST_TB B WITH(NOLOCK) ON A.ADID = B.REGIST_ID AND A.PRODUCT_GBN = 2
JOIN CY_FAT_MASTER_TB C WITH(NOLOCK) ON B.FAT_ID = C.FAT_ID
LEFT JOIN PP_COUPON_USE_DETAIL_TB AS CUD WITH(NOLOCK) ON CUD.RECCHARGE_SERIAL = A.SERIAL
WHERE REGIST_GBN = 0 AND B.ISSTORAGE = 0
AND ChargeKind IS NOT NULL AND PrnAmtOk = ''1'' AND (B.REG_DT >= CONVERT(DATETIME, @REG_DT_FROM) AND B.REG_DT <= CONVERT(DATETIME, @REG_DT_TO + '' 23:59:59''))

UNION ALL 
SELECT 
A.CUID
  FROM V_PP_JOB_KEYWORDSEARCH_PAY AS A WITH(NOLOCK) 
  JOIN PP_AD_TB AS B WITH(NOLOCK) ON B.LINEADNO = A.LINEADNO
  LEFT JOIN PP_OPTION_TB O WITH(NOLOCK) ON O.LINEADNO = B.LINEADNO
  LEFT JOIN PP_LINE_AD_TB AS C WITH(NOLOCK) ON C.LINEADNO = A.LINEADNO
  LEFT JOIN PP_COUPON_USE_DETAIL_TB AS CUD WITH(NOLOCK) ON CUD.RECCHARGE_SERIAL = A.SERIAL
 WHERE 1=1  AND A.ChargeKind IS NOT NULL AND A.PrnAmtOk = ''1'' AND (B.REG_DT >= CONVERT(DATETIME, @REG_DT_FROM) AND B.REG_DT <= CONVERT(DATETIME, @REG_DT_TO + '' 23:59:59''))

-- 이력서 열람 결제내역
UNION ALL
SELECT A.CUID  
FROM PP_RESUME_READ_GOODS_REGIST_TB AS A (NOLOCK)      
JOIN PP_RESUME_READ_GOODS_COMPANY_AUTH_TB AS B (NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID      
LEFT JOIN PP_ECOMM_RECCHARGE_TB AS D (NOLOCK) ON A.REGIST_ID = D.ADID AND D.PRODUCT_GBN = 6      
WHERE A.DEL_YN = ''N''      
	AND B.DEL_YN = ''N''
	AND ((A.ADGBN = 1 AND D.ChargeKind IS NOT NULL AND D.PrnAmtOk = ''1'') OR (A.ADGBN = 2)) 
	AND D.RecDate >= @REG_DT_FROM AND D.RecDate < DATEADD(DAY, 1,@REG_DT_TO)
)A

-- 자동차/상품 결제내역
UNION ALL
SELECT ''상품/자동차 결제 고객 수'' [구분], COUNT(DISTINCT(C.CUID)) [고객수]  
FROM PP_AD_TB C (NOLOCK)
JOIN PP_ECOMM_RECCHARGE_TB R (NOLOCK) ON R.ADID = C.LINEADID AND R.PRODUCT_GBN = 1
JOIN PP_OPTION_TB P (NOLOCK) ON P.LINEADID = C.LINEADID AND P.INPUT_BRANCH = C.INPUT_BRANCH AND P.LAYOUT_BRANCH = C.LAYOUT_BRANCH
LEFT OUTER JOIN PP_LINE_AD_TB AS PP (NOLOCK)ON PP.LINEADID = C.LINEADID AND PP.INPUT_BRANCH = C.INPUT_BRANCH AND PP.LAYOUT_BRANCH = C.LAYOUT_BRANCH
LEFT JOIN PAPERREG.DBO.TaxUser AS T (NOLOCK)
        ON T.CUID = C.CUID
    WHERE C.GROUP_CD NOT IN (13, 14) AND C.VERSION = ''E'' AND C.DELYN=''N'' 
	AND R.ChargeKind IS NOT NULL AND R.PrnAmtOk = ''1''
	AND (R.RecDate >= CONVERT(DATETIME, @REG_DT_FROM) AND R.RecDate <= CONVERT(DATETIME, @REG_DT_TO + '' 23:59:59''))
  )a

    FOR XML PATH(''tr''), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N''</table>'' ;
EXEC msdb.dbo.sp_send_dbmail 
	@profile_name =''DBAMAIL'',
   @recipients=''ciiciicii@mediawill.com;got@mediawill.com;jincheal2@mediawill.com;lesstar@mediawill.com;'',
    @subject = @subject2,
    @body = @tableHTML,
    @body_format = ''HTML'' ;', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20230418, 
		@active_end_date=99991231, 
		@active_start_time=170200, 
		@active_end_time=235959, 
		@schedule_uid=N'8f0ee9a2-c3fb-4f82-a4da-9704c0a9618c'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'2', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=65, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20230515, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'33c7414d-8f60-4c4c-bf74-65c46c05b6a8'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[운영팀] (매월1일)(0:05) 성과급 신규/재계약 구분용 데이터 생성]    Script Date: 2023-05-24 오후 1:02:52 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:52 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[운영팀] (매월1일)(0:05) 성과급 신규/재계약 구분용 데이터 생성', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'성과급 신규/재계약 구분용 데이터 생성', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [성과급 신규/재계약 구분용 데이터 생성]    Script Date: 2023-05-24 오후 1:02:52 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'성과급 신규/재계약 구분용 데이터 생성', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC UNILINEDB_NEW.dbo.BAT_INCENTIVE_DATA_PROC', 
		@database_name=N'UNILINEDB_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'성과급 신규/재계약 구분용 데이터 생성', 
		@enabled=1, 
		@freq_type=16, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20190628, 
		@active_end_date=99991231, 
		@active_start_time=500, 
		@active_end_time=235959, 
		@schedule_uid=N'2b1cb38a-c517-40fa-8f11-a46d9b631386'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[운영확인] (9시 5분) 벼룩시장 문자 발송 확인 문자]    Script Date: 2023-05-24 오후 1:02:52 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:52 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[운영확인] (9시 5분) 벼룩시장 문자 발송 확인 문자', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [SMS 발송 여부 확인]    Script Date: 2023-05-24 오후 1:02:53 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'SMS 발송 여부 확인', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC PUT_SENDSMS_PROC ''02-3019-1552'',''파인드올'',''최봉기'',''010-2851-9869'',''SMS 전송 확인 문자 발송'';
EXEC PUT_SENDSMS_PROC ''02-3019-1554'',''파인드올'',''이근우'',''010-3393-1420'',''SMS 전송 확인 문자 발송'';
', 
		@database_name=N'COMDB1', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'벼룩시장 문자 발송 확인 문자', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20161012, 
		@active_end_date=99991231, 
		@active_start_time=90500, 
		@active_end_time=235959, 
		@schedule_uid=N'360849f8-5de7-44e6-a6be-19b6e70f6c2d'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[이력서] (0시 30분) 수정일 자동업데이트]    Script Date: 2023-05-24 오후 1:02:53 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:53 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[이력서] (0시 30분) 수정일 자동업데이트', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[이력서] 수정일 자동업데이트]    Script Date: 2023-05-24 오후 1:02:53 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[이력서] 수정일 자동업데이트', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 자동업데이트 15일
UPDATE TB
   SET MOD_DT = GETDATE()
     -- 공개 마감일 업데이트는 유민건 과장 요청으로 중지, 2016-06-30
     --, OPEN_END_DT = CASE WHEN OPEN_END_DT < DATEADD(DAY, 30, GETDATE()) THEN DATEADD(MONTH, 3, OPEN_END_DT) ELSE OPEN_END_DT END     
-- SELECT RESUME_ID, MOD_DT, OPEN_END_DT, CASE WHEN OPEN_END_DT < DATEADD(DAY, 30, GETDATE()) THEN DATEADD(MONTH, 3, OPEN_END_DT) ELSE OPEN_END_DT END
  FROM PG_RESUME_MAIN_TB TB
 WHERE RESUME_ID IN (
        SELECT RESUME_ID
          FROM PG_RESUME_MAIN_TB
         WHERE OPEN_YN = ''Y''
           AND DEL_YN = ''N''
           AND AUTO_UPDATE = 15
           AND MOD_DT < CONVERT(VARCHAR(10), DATEADD(DAY, -13, GETDATE()), 120)
       )

-- 자동업데이트 30일
UPDATE TB
   SET MOD_DT = GETDATE()
     -- 공개 마감일 업데이트는 유민건 과장 요청으로 중지, 2016-06-30
     --, OPEN_END_DT = CASE WHEN OPEN_END_DT < DATEADD(DAY, 30, GETDATE()) THEN DATEADD(MONTH, 3, OPEN_END_DT) ELSE OPEN_END_DT END
-- SELECT RESUME_ID, MOD_DT, OPEN_END_DT, CASE WHEN OPEN_END_DT < DATEADD(DAY, 30, GETDATE()) THEN DATEADD(MONTH, 3, OPEN_END_DT) ELSE OPEN_END_DT END
  FROM PG_RESUME_MAIN_TB TB
 WHERE RESUME_ID IN (
        SELECT RESUME_ID
          FROM PG_RESUME_MAIN_TB
         WHERE OPEN_YN = ''Y''
           AND DEL_YN = ''N''
           AND AUTO_UPDATE = 30
           AND MOD_DT < CONVERT(VARCHAR(10), DATEADD(DAY, -28, GETDATE()), 120)
       )', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[이력서] 수정일 자동업데이트', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20150716, 
		@active_end_date=99991231, 
		@active_start_time=3000, 
		@active_end_time=235959, 
		@schedule_uid=N'4366a3f1-9708-4e5d-bb0a-2579db1a0ebe'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[이력서] (0시) 삭제/비공개 처리한지 1주일 경과된 이력서의 VNS 회수]    Script Date: 2023-05-24 오후 1:02:53 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:53 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[이력서] (0시) 삭제/비공개 처리한지 1주일 경과된 이력서의 VNS 회수', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [삭제/비공개 처리한지 1주일 경과된 이력서의 VNS 회수]    Script Date: 2023-05-24 오후 1:02:53 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'삭제/비공개 처리한지 1주일 경과된 이력서의 VNS 회수', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_PG_RESUME_VNS_WITHDRAW_1WEEK_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1회/1일', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20130723, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'1c9a83f0-cf94-4b2e-ab36-525bb862de6e'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[이력서] (0시) 열람기간 만료 체크하여 이력서 열람 차단 처리]    Script Date: 2023-05-24 오후 1:02:53 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:53 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[이력서] (0시) 열람기간 만료 체크하여 이력서 열람 차단 처리', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [열람기간 만료 체크하여 이력서 열람 차단 처리]    Script Date: 2023-05-24 오후 1:02:53 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'열람기간 만료 체크하여 이력서 열람 차단 처리', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_PG_RESUME_MAIN_TB_CLOSE_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1회/1일', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20130723, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'96b6f383-6ccc-4c88-b25e-a6a3e442ffd1'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[이력서] (0시) 이력서에 맵핑되지 않았는데 사용중으로 동록된 VNS번호 회수 처리]    Script Date: 2023-05-24 오후 1:02:53 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:53 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[이력서] (0시) 이력서에 맵핑되지 않았는데 사용중으로 동록된 VNS번호 회수 처리', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [이력서에 맵핑되지 않았는데 사용중으로 동록된 VNS번호 회수 처리]    Script Date: 2023-05-24 오후 1:02:54 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'이력서에 맵핑되지 않았는데 사용중으로 동록된 VNS번호 회수 처리', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=2, 
		@retry_interval=2, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_PG_RESUME_VNS_WITHDRAW_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1회/1일', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20130723, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'd6008e67-c419-4a87-a6cb-305a3c5c030d'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[이력서] (3시) 탈퇴회원 이력서 열람 차단 및 삭제 처리]    Script Date: 2023-05-24 오후 1:02:54 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:54 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[이력서] (3시) 탈퇴회원 이력서 열람 차단 및 삭제 처리', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [탈퇴회원 이력서 열람 차단 및 삭제 처리]    Script Date: 2023-05-24 오후 1:02:54 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'탈퇴회원 이력서 열람 차단 및 삭제 처리', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_탈퇴회원_이력서_열람_차단_및_삭제_처리_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1일 1회 실행', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20130809, 
		@active_end_date=99991231, 
		@active_start_time=30000, 
		@active_end_time=235959, 
		@schedule_uid=N'd61273f6-04a4-495e-9cfb-f20c3939b137'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[이력서] (매일 3시간 간격) 기업인증 신청 USER의 광고 건수]    Script Date: 2023-05-24 오후 1:02:54 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:54 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[이력서] (매일 3시간 간격) 기업인증 신청 USER의 광고 건수', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[이력서] 기업인증 신청 USER의 광고 건수]    Script Date: 2023-05-24 오후 1:02:54 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[이력서] 기업인증 신청 USER의 광고 건수', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=2, 
		@retry_interval=2, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_RESUME_READ_GOODS_USER_AD_COUNT_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[이력서] 기업인증 신청 USER의 광고 건수', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=3, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20150414, 
		@active_end_date=99991231, 
		@active_start_time=83500, 
		@active_end_time=195959, 
		@schedule_uid=N'55b81180-a78e-40ef-8362-5dc0e1d17995'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[이력서] 개인서비스 > 입사지원 內 기업 USER의 광고 취합]    Script Date: 2023-05-24 오후 1:02:54 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:54 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[이력서] 개인서비스 > 입사지원 內 기업 USER의 광고 취합', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[이력서] 개인서비스 > 입사지원 內 기업 USER의 광고 취합]    Script Date: 2023-05-24 오후 1:02:54 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[이력서] 개인서비스 > 입사지원 內 기업 USER의 광고 취합', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=2, 
		@retry_interval=2, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_RESUME_USER_AD_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[이력서] 개인서비스 > 입사지원 內 기업 USER의 광고 취합', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=6, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20150414, 
		@active_end_date=99991231, 
		@active_start_time=101200, 
		@active_end_time=235959, 
		@schedule_uid=N'1adc1616-8711-4fa9-91b0-37804c12eda7'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[임시] 사용률저장]    Script Date: 2023-05-24 오후 1:02:54 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:54 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[임시] 사용률저장', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1]    Script Date: 2023-05-24 오후 1:02:54 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec master..sp_MSforeachdb'' 

use [?]
insert into dba.dbo.fileusage
select db_name() dbname
,a.type_desc [type]
, a.name [file_name]
,fg.name filegroup_name
,a.physical_name file_location
,convert(decimal(10,2),a.size/128.0) filesize_mb
,convert(decimal(10,2),a.size/128.0-((size/128.0)-cast(fileproperty(a.name, ''''spaceused'''') as int)/128.0)) [usespace_mb]
,convert(decimal(10,2),a.size/128.0 - cast(fileproperty(a.name, ''''spaceused'''') as int)/128.0) [freespace_mb]
,convert(decimal(10,2),((a.size/128.0 - cast(fileproperty(a.name, ''''spaceused'''') as int)/128.0)/(a.size/128.0))*100) [freespace_%]
,100-convert(decimal(10,2),((a.size/128.0 - cast(fileproperty(a.name, ''''spaceused'''') as int)/128.0)/(a.size/128.0))*100) [usage_%]
, getdate()
from sys.database_files a left join sys.filegroups fg
on a.data_space_id = fg.data_space_id
order by a.type desc, a.name''

', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20220217, 
		@active_end_date=99991231, 
		@active_start_time=90300, 
		@active_end_time=235959, 
		@schedule_uid=N'950f1501-4531-4167-a34a-5168bfc1db68'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[임시] 프로시져 실행 여부 확인]    Script Date: 2023-05-24 오후 1:02:54 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:55 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[임시] 프로시져 실행 여부 확인', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'BAT_TEMP_PROC_EXEC_TIME_INFO', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [BAT_TEMP_PROC_EXEC_TIME_INFO]    Script Date: 2023-05-24 오후 1:02:55 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'BAT_TEMP_PROC_EXEC_TIME_INFO', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC BAT_TEMP_PROC_EXEC_TIME_INFO', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'BAT_TEMP_PROC_EXEC_TIME_INFO', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=3, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20160628, 
		@active_end_date=99991231, 
		@active_start_time=5000, 
		@active_end_time=235959, 
		@schedule_uid=N'1dcc292d-8e5f-44f7-af39-e2bfd76a18c8'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[임시]job오류메세지저장]    Script Date: 2023-05-24 오후 1:02:55 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:55 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[임시]job오류메세지저장', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1]    Script Date: 2023-05-24 오후 1:02:55 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'use msdb

declare @Date1 datetime
declare @Date2 datetime



set @Date1 = replace(convert(varchar(10),getdate()-3,120),''-'','''')
set @Date2 =replace(convert(varchar(10),getdate()+1,120),''-'','''')

insert into dba.dbo._sysjobs임시
SELECT A.name
       , A.description
       , B.step_name
       , message = REPLACE(B.message, ''. '', ''.'' + CHAR(10))
       , B.run_date
       , B.run_time
       , B.run_duration
  FROM msdb.dbo.sysjobs(NOLOCK) A
       INNER JOIN msdb.dbo.sysjobhistory(NOLOCK) B ON A.job_id = B.job_id
 WHERE B.run_status = 0
       AND B.step_id > 0
       AND B.run_date BETWEEN CONVERT(CHAR(8), @Date1, 112) AND CONVERT(CHAR(8), DATEADD(DAY, 1, @Date2), 112)



', 
		@database_name=N'msdb', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20230109, 
		@active_end_date=99991231, 
		@active_start_time=44600, 
		@active_end_time=235959, 
		@schedule_uid=N'6c53b7b3-27be-44d3-ad7c-a2c2bcb9ba2b'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[직접등록] 발행계획 갱신]    Script Date: 2023-05-24 오후 1:02:55 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:55 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[직접등록] 발행계획 갱신', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[직접등록] 발행계획 갱신]    Script Date: 2023-05-24 오후 1:02:55 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[직접등록] 발행계획 갱신', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'TRUNCATE TABLE IssuePlan;

INSERT 
  INTO IssuePlan 
    (BranchCode, ExpDate, IssueType, Issue, DayOfWeek)
SELECT BranchCode, ExpDate, IssueType, Issue, DayOfWeek
  FROM UNIFICATION_S1.FINDTRANS.dbo.IssuePlan', 
		@database_name=N'PAPERREG', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [[채용보고서] (4시 20분) 채용보고서 일일 데이터 취합]    Script Date: 2023-05-24 오후 1:02:55 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:55 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[채용보고서] (4시 20분) 채용보고서 일일 데이터 취합', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[채용보고서] (4시 20분) 채용보고서 일일 데이터 취합]    Script Date: 2023-05-24 오후 1:02:55 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[채용보고서] (4시 20분) 채용보고서 일일 데이터 취합', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.BAT_PP_JOB_RECRUIT_REPORT_PROC', 
		@database_name=N'LOGDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'[채용보고서] (4시 20분) 채용보고서 일일 데이터 취합', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20160311, 
		@active_end_date=99991231, 
		@active_start_time=42100, 
		@active_end_time=235959, 
		@schedule_uid=N'aa5a9d90-0b2b-4d77-8b8f-f7e7230f03eb'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [4. 구MIS 게재띠 가져오기]    Script Date: 2023-05-24 오후 1:02:55 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:55 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'4. 구MIS 게재띠 가져오기', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [제천 벼룩시장]    Script Date: 2023-05-24 오후 1:02:55 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'제천 벼룩시장', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBO.BAT_UPDATE_INTEGRATION_LAYOUTCLASS_PROC 53', 
		@database_name=N'LayoutClassDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [강릉 벼룩시장]    Script Date: 2023-05-24 오후 1:02:55 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'강릉 벼룩시장', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBO.BAT_UPDATE_INTEGRATION_LAYOUTCLASS_PROC 52', 
		@database_name=N'LayoutClassDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [춘천 벼룩시장]    Script Date: 2023-05-24 오후 1:02:55 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'춘천 벼룩시장', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBO.BAT_UPDATE_INTEGRATION_LAYOUTCLASS_PROC 37', 
		@database_name=N'LayoutClassDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [군산 벼룩시장]    Script Date: 2023-05-24 오후 1:02:55 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'군산 벼룩시장', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBO.BAT_UPDATE_INTEGRATION_LAYOUTCLASS_PROC 58', 
		@database_name=N'LayoutClassDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [익산 벼룩시장]    Script Date: 2023-05-24 오후 1:02:55 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'익산 벼룩시장', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBO.BAT_UPDATE_INTEGRATION_LAYOUTCLASS_PROC 50', 
		@database_name=N'LayoutClassDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [속초 벼룩시장]    Script Date: 2023-05-24 오후 1:02:55 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'속초 벼룩시장', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBO.BAT_UPDATE_INTEGRATION_LAYOUTCLASS_PROC 56', 
		@database_name=N'LayoutClassDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [원주 벼룩시장]    Script Date: 2023-05-24 오후 1:02:55 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'원주 벼룩시장', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBO.BAT_UPDATE_INTEGRATION_LAYOUTCLASS_PROC 38', 
		@database_name=N'LayoutClassDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'구MIS 게재띠 가져오기', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=126, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20090703, 
		@active_end_date=99991231, 
		@active_start_time=3000, 
		@active_end_time=235959, 
		@schedule_uid=N'c17095b4-da9a-4037-bceb-9f2ec4dad1f2'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [4. 신MIS 게재띠 가져오기]    Script Date: 2023-05-24 오후 1:02:55 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:55 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'4. 신MIS 게재띠 가져오기', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [신 MIS 게재띠 가져오기]    Script Date: 2023-05-24 오후 1:02:56 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'신 MIS 게재띠 가져오기', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec p_AllImportLayoutClassTotal', 
		@database_name=N'LayoutClassDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'신 MIS 게재띠 가져오기', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=126, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20020929, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'584822c7-a460-415f-ba77-3c4038dccddb'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [9. 온라인신문광고 LayoutCode UPDATE]    Script Date: 2023-05-24 오후 1:02:56 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:56 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'9. 온라인신문광고 LayoutCode UPDATE', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [9. 온라인신문광고 LayoutCode UPDATE]    Script Date: 2023-05-24 오후 1:02:56 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'9. 온라인신문광고 LayoutCode UPDATE', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC dbo.ProcUpdateLayoutCode', 
		@database_name=N'PaperReg', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'9. 온라인신문광고 LayoutCode UPDATE', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=126, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20070814, 
		@active_end_date=99991231, 
		@active_start_time=180000, 
		@active_end_time=235959, 
		@schedule_uid=N'50c30a33-b0f2-4e8f-9c5b-c2c433c11645'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [99__[우편번호] 갱신 처리]    Script Date: 2023-05-24 오후 1:02:56 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:56 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'99__[우편번호] 갱신 처리', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'[우편번호] 갱신 처리', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [우편번호 갱신]    Script Date: 2023-05-24 오후 1:02:56 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'우편번호 갱신', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE BAT_ZIPCODE_RENEW_PROC', 
		@database_name=N'PAPER_NEW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [syspolicy_purge_history]    Script Date: 2023-05-24 오후 1:02:56 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2023-05-24 오후 1:02:56 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'syspolicy_purge_history', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'설명이 없습니다.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Verify that automation is enabled.]    Script Date: 2023-05-24 오후 1:02:56 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Verify that automation is enabled.', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=1, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'IF (msdb.dbo.fn_syspolicy_is_automation_enabled() != 1)
        BEGIN
            RAISERROR(34022, 16, 1)
        END', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Purge history.]    Script Date: 2023-05-24 오후 1:02:56 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Purge history.', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC msdb.dbo.sp_syspolicy_purge_history', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Erase Phantom System Health Records.]    Script Date: 2023-05-24 오후 1:02:56 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Erase Phantom System Health Records.', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'PowerShell', 
		@command=N'if (''$(ESCAPE_SQUOTE(INST))'' -eq ''MSSQLSERVER'') {$a = ''\DEFAULT''} ELSE {$a = ''''};
(Get-Item SQLSERVER:\SQLPolicy\$(ESCAPE_NONE(SRVR))$a).EraseSystemHealthPhantomRecords()', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'syspolicy_purge_history_schedule', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20080101, 
		@active_end_date=99991231, 
		@active_start_time=20000, 
		@active_end_time=235959, 
		@schedule_uid=N'4c5d9cb1-2933-4948-a77e-a46327051cf8'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [WMI Response - DATABASE Growth Event]    Script Date: 2023-05-24 오후 1:02:56 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [REPL-Alert Response]    Script Date: 2023-05-24 오후 1:02:56 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'REPL-Alert Response' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'REPL-Alert Response'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'WMI Response - DATABASE Growth Event', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Sends notifications to DBA when DATABASE File Growth event(s) occur(s)', 
		@category_name=N'REPL-Alert Response', 
		@owner_login_name=N'CFM\onsdb', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Send e-mail in response to WMI alert(s)]    Script Date: 2023-05-24 오후 1:02:56 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Send e-mail in response to WMI alert(s)', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC msdb.dbo.sp_send_dbmail
    @profile_name = ''DBA'', 
    @recipients = ''lhs@mediawill.com'', 
    @body = ''File Name: $(ESCAPE_SQUOTE(WMI(FileName))); 
Start Time: $(ESCAPE_SQUOTE(WMI(STartTime))); 
Duration: $(ESCAPE_SQUOTE(WMI(Duration))); 
Application Name: $(ESCAPE_SQUOTE(WMI(ApplicationName))); 
Host Name: $(ESCAPE_SQUOTE(WMI(HostName))); 
Login Name: $(ESCAPE_SQUOTE(WMI(LoginName)));
Session Login Name: $(ESCAPE_SQUOTE(WMI(SessionLoginName)));'',
    @subject = ''Database file growth event - $(ESCAPE_SQUOTE(WMI(DatabaseName)))'' ;
', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Send e-mail in response to DB Size Report]    Script Date: 2023-05-24 오후 1:02:56 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Send e-mail in response to DB Size Report', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @xml NVARCHAR(MAX)
DECLARE @body NVARCHAR(MAX)

SET @xml = CAST((SELECT @@SERVICENAME AS ''td'','''',DBName AS ''td'',''''
				, CAST(Data AS varchar(10)) + ''MB / '' + CAST(Data_Free AS varchar(10)) + ''MB ('' + CAST(Data_Free_Percent AS varchar(10)) + ''%)'' AS ''td'',''''
				, CAST(Log AS varchar(10)) + ''MB / '' + CAST(Log_Free AS varchar(10)) + ''MB ('' + CAST(Log_Free_Percent AS varchar(10)) + ''%)'' AS ''td''
			FROM DBA.dbo.DBSize 
			WHERE InsDate > CAST(GETDATE() AS DATE)
			AND (Data_Free_Percent < 1 or Log_Free_Percent < 1)
			FOR XML PATH(''tr''), ELEMENTS ) AS NVARCHAR(MAX))


SET @body =''<html><body><H3>DB Size Report</H3>
<table border = 1> 
<tr>
<th> Server Name </th><th> DB Name </th> <th> Data MB / Free MB (Free%) </th> <th> Log MB / Free MB (Free%) </th></tr>''    
 
SET @body = @body + @xml +''</table></body></html>''

EXEC msdb.dbo.sp_send_dbmail
	@profile_name = ''DBA'',  
	@body = @body,
	@body_format =''HTML'',
	@recipients = ''lhs@mediawill.com'', 
	@subject = ''DB Size Report'';', 
		@database_name=N'msdb', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Logging Events]    Script Date: 2023-05-24 오후 1:02:56 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Logging Events', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'INSERT INTO DBA.dbo.DBFileGrowthEvents(
 FileType, DatabaseName, [FileName], FileGrowth_XML)
SELECT LEFT([type_desc],3), DB_NAME(database_id), [name]
 , ''<FileGrowth_Event>
 <FileGrowth_Event_Type>'' + [type_desc] + ''</FileGrowth_Event_Type>
 <Post_Time>'' + IsNull(CAST($(ESCAPE_NONE(WMI(PostTime))) as VARCHAR),'''') + ''</Post_Time>
 <Duration>'' + IsNull(CAST($(ESCAPE_NONE(WMI(Duration))) as VARCHAR),'''') + ''</Duration>
 <Database_Name>'' + DB_NAME(database_id) + ''</Database_Name>
 <File_Name>'' + [name] + ''</File_Name>
 <Physical_Name>'' + IsNull(physical_name,'''') + ''</Physical_Name>
 <File_Size_Mb>'' + IsNull(CAST([size] / 128 as VARCHAR),'''') + ''</File_Size_Mb>
 <NT_Domain_Name>'' + IsNull(''$(ESCAPE_SQUOTE(WMI(NTDomainName)))'','''') + ''</NT_Domain_Name>
 <Login_Name>'' + IsNull(''$(ESCAPE_SQUOTE(WMI(LoginName)))'','''') + ''</Login_Name>
 <Session_Login_Name>'' + IsNull(''$(ESCAPE_SQUOTE(WMI(SessionLoginName)))'','''') + ''</Session_Login_Name>
 <Host_Name>'' + IsNull(''$(ESCAPE_SQUOTE(WMI(HostName)))'','''') + ''</Host_Name>
 <Application_Name>'' + IsNull(''$(ESCAPE_SQUOTE(WMI(ApplicationName)))'','''') + ''</Application_Name>
</FileGrowth_Event>''
FROM master.sys.master_files
WHERE [name] = N''$(ESCAPE_SQUOTE(WMI(FileName)))'' 
 and database_id = $(ESCAPE_SQUOTE(WMI(DatabaseID)));
GO', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


