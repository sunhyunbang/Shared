<%
'*******************************************************************************************
' 단 위 업 무 명	: 공고 처리 공통 - 파일 업로드
' 작    성    자	: 최 봉 기 (virtualman@mediawill.com)
' 작    성    일	: 2013/07/31
' 수    정    자	:
' 수    정    일	:
' 내          용	:
' 주  의  사  항  :
'*******************************************************************************************
%>
<%
'------------------------------
' FileSystemObject
'------------------------------
Dim Fso
Dim FsoFile
Set Fso = Server.CreateObject("Scripting.FileSystemObject")

'############################### 추가 이미지 파일 업로드 및 DB 등록 처리 ###############################
Dim UPD_i
Dim UPD_ExImageFileName(4)
Dim UPD_tmpThumb(4)
Dim UPD_NewFileName : UPD_NewFileName = FnLineAdNo(PRC_ResultLineAdid,PRC_ReqInputBranch,PRC_LayoutBranch)
Dim UPD_TempPath    : UPD_TempPath    = fileDir + "Temp\"
Dim UPD_LoadAdImage(4)
Dim UPD_LoadAdImageExt(4)

If PRC_ExImgDelYN = "Y" Then    ' 추가이미지를 삭제했다면
  For UPD_i = 1 To 4
    UPD_ExImageFileName(UPD_i) = ""
  Next
Else
  For UPD_i = 1 To 4
    If Len(PRC_OrgUploadFile(UPD_i)) > 0 Then
      UPD_ExImageFileName(UPD_i) = SetFileMovePathName(USER_UPLOAD_JOB_IMG_PATH & "/Temp/" & PRC_OrgUploadFile(UPD_i), SetUploadFileFolder(USER_UPLOAD_JOB_AD_EXIMG_PATH) & UPD_NewFileName &"_"& UPD_i &"_"& CreateGUID() & "." & LCase(Right(PRC_OrgUploadFile(UPD_i),Len(PRC_OrgUploadFile(UPD_i))-InstrRev(PRC_OrgUploadFile(UPD_i),"."))), "C")  ' 웹 이미지 이동
    Else
      If Instr(Lcase(PRC_LoadAdUploadFile(UPD_i)),"/photolinead/") > 0 Then    '사진매물 이미지인 경우 파일처리 프로세스를 태우지 않고 기존값 유지
        UPD_ExImageFileName(UPD_i) = PRC_LoadAdUploadFile(UPD_i)
      Else
        ' 불러온 공고의 이미지 파일을 신규등록 공고로 파일 복사
        If Len(PRC_LoadAdUploadFile(UPD_i)) > 0 Then
          UPD_ExImageFileName(UPD_i) = SetFileMovePathName(PRC_LoadAdUploadFile(UPD_i), SetUploadFileFolder(USER_UPLOAD_JOB_AD_EXIMG_PATH) & FnLineAdNo(PRC_ResultLineAdid,PRC_ReqInputBranch,PRC_LayoutBranch) &"_"& UPD_i &"_"& CreateGUID() & "."& Right(PRC_LoadAdUploadFile(UPD_i),Len(PRC_LoadAdUploadFile(UPD_i))-Instr(PRC_LoadAdUploadFile(UPD_i),".")), "C")
        End If
      End If
    End If
  Next

End If
'############################### // 추가 이미지 파일 업로드 및 DB 등록 처리 ###############################

'############################### 플래티넘 로고(회사로고) 이미지 ###############################
Dim UPD_CompanyLogoImg        ' 플래티넘 로고(회사로고) 이미지
Dim UPD_CompanyMainLogoImg    ' 메인로고 이미지
Dim UPD_TempCompanyLogo       ' 임시 업로드 파일명
Dim UPD_SaveCompanyLogoImg    ' 저장처리변수
Dim UPD_Sql

' 삭제를 체크한 경우라면..
If PRC_ComLogoImgDel = "1" Then
  ' 검수대기 로고 Null 처리
  UPD_Sql = "EXECUTE EDIT_M_PP_LOGO_OPTION_TB_WAIT_PROC "& PRC_ResultLineAdid &","& PRC_ReqInputBranch &","& PRC_LayoutBranch &",'D'"
  ConnPaper.Execute UPD_Sql
End If

'response.write "PRC_CompanyLogo : " & PRC_CompanyLogo & "<Br>"
'response.write "PRC_CompanyOrgMainLogo : " & PRC_CompanyOrgMainLogo & "<Br>"
'response.End

' 업로드 이미지 또는 불러오기 이미지가 있는 경우
If FnLen(PRC_CompanyLogo) > 0 Or FnLen(PRC_CompanyOrgLogo) > 0 And PRC_ComLogoImgDel = "0" Then
			  

  ' 이미지 업로드 및 이미지 파일명 UPD_CompanyLogoImg 변수에 할당
  UPD_CompanyLogoImg = SetUploadFileFolder(USER_UPLOAD_JOB_PLATINUM_PATH) & FnLineAdNo(PRC_ResultLineAdid,PRC_ReqInputBranch,PRC_LayoutBranch) &"_Logo_"& CreateGUID() &".jpg"

	If FnLen(PRC_CompanyOrgLogo) > 0 Then
    UPD_CompanyLogoImg = SetFileMovePathName(PRC_CompanyOrgLogo, UPD_CompanyLogoImg, "C")
  End If

  '불러오기 시 메인 로고가 있는 경우
  If FnLen(PRC_CompanyOrgMainLogo) > 0 Then
    'UPD_CompanyMainLogoImg = SetUploadFileFolder(USER_UPLOAD_JOB_PLATINUM_PATH) & FnLineAdNo(PRC_ResultLineAdid,PRC_ReqInputBranch,PRC_LayoutBranch) &"_MainLogo_"& CreateGUID() &".jpg"
    'UPD_CompanyMainLogoImg = SetFileMovePathName(PRC_CompanyOrgMainLogo, UPD_CompanyMainLogoImg, "C")

    UPD_CompanyMainLogoImg = ""
  End If


	'----------------------------------------------
  '업로드 된 이미지의 파일용량 체크 - Start
  '----------------------------------------------
  Dim PRC_WaitLogoByte
  Dim PRC_MainLogoByte

  PRC_WaitLogoByte = 0
  PRC_MainLogoByte = 0
	'UPD_CompanyMainLogoImg = PRC_CompanyOrgMainLogo
	IF  FnLen(PRC_CompanyLogo) > 0 Then
		UPD_CompanyLogoImg = PRC_CompanyLogo
	
	END IF 

  If FnLen(UPD_CompanyLogoImg) > 0 Then
    PRC_WaitLogoByte = SetFileSiteByte(Server.MapPath(UPD_CompanyLogoImg))
  End If

  If FnLen(UPD_CompanyMainLogoImg) > 0 Then
    PRC_MainLogoByte = SetFileSiteByte(Server.MapPath(UPD_CompanyMainLogoImg))
  End If

  '----------------------------------------------
  '업로드 된 이미지의 파일용량 체크 - End
  '----------------------------------------------
  ' 플래티넘 이미지 등록 (DB처리)
  'UPD_Sql = "EXECUTE PUT_CM_PP_LOGO_WAIT_PROC "& PRC_ResultLineAdid &","& PRC_ReqInputBranch &","& PRC_LayoutBranch &",'"& UPD_CompanyLogoImg &"', '"& UPD_CompanyMainLogoImg &"',"& PRC_WaitLogoByte &","& PRC_MainLogoByte &", '"& PRC_LogoTemplate &"', '"& PRC_LogoComfirm &"', '"& UPD_LogoConfirmImg &"', '"& PRC_LogoComfirmUrl &"' "

  UPD_Sql = "EXECUTE PUT_CM_PP_LOGO_WAIT_PROC "& PRC_ResultLineAdid &","& PRC_ReqInputBranch &","& PRC_LayoutBranch &",'"& UPD_CompanyLogoImg &"', '"& UPD_CompanyMainLogoImg &"',"& PRC_WaitLogoByte &","& PRC_MainLogoByte

  '<-- S:전국판 플래티넘플러스 / 플래티넘 / 프리리엄플러스 / 스페셜플러스 건은 등록/수정 모두 로고 검수대기 처리 변경 (2014-02-07 신혜원 파트장요청) -->
  '1. 수정은 기존 프로세스 대로 검수대기 처리
  If PRC_ProcessType = "Modify" Then
    UPD_Sql = UPD_Sql &";EXECUTE EDIT_M_PP_LOGO_OPTION_TB_WAIT_PROC "& PRC_ResultLineAdid &","& PRC_ReqInputBranch &","& PRC_LayoutBranch &",'R' "
  '2. 등록 시 전국판이면서 플래티넘플러스/플래티넘/프리미엄플러스/프리미엄리스트/스페셜플러스/스피드파트타임상품/M프리미엄플러스/M프리미엄/M스페셜플러스/M포커스가 아닌 상품만 검수완료 처리
  ElseIf PRC_ProcessType = "Regist" Then
    If (PRC_InetArea And 1) And Not(PRC_InternetOpt = 12 Or PRC_InternetOpt = 29 Or PRC_InternetOpt = 53 Or PRC_InternetOpt = 55 Or PRC_InternetOpt = 56 Or PRC_InternetOpt = 57 Or PRC_InternetOpt = 65 Or PRC_InternetOpt = 72 Or PRC_InternetOpt = 73 Or PRC_InternetOpt = 74 Or PRC_InternetOpt = 75 Or PRC_InternetOpt = 76 Or PRC_InternetOpt = 87 Or PRC_MobileOpt = 3 Or PRC_MobileOpt = 4 Or PRC_MobileOpt = 5 Or PRC_MobileOpt = 7 Or PRC_MobileOpt = 10 Or PRC_MobileOpt = 11 Or PRC_MobileOpt = 13 Or PRC_MobileOpt = 14 Or PRC_MobileOpt = 15 Or PRC_MobileOpt = 16) Then
	 		If PRC_FormType = "PaperMod" Or PRC_FormType = "BoxAd" Then
        UPD_CompanyMainLogoImg = SetUploadFileFolder(USER_UPLOAD_JOB_PLATINUM_PATH) & FnLineAdNo(PRC_ResultLineAdid,PRC_ReqInputBranch,PRC_LayoutBranch) &"_MainLogo_"& CreateGUID() &".jpg"
	  	  UPD_CompanyMainLogoImg = SetFileMovePathName(UPD_CompanyLogoImg, UPD_CompanyMainLogoImg, "C")
        '----------------------------------------------
        '업로드 된 이미지의 파일용량 체크 - Start
        '----------------------------------------------
        PRC_MainLogoByte = SetFileSiteByte(Server.MapPath(UPD_CompanyMainLogoImg))
        '----------------------------------------------
        '업로드 된 이미지의 파일용량 체크 - End
        '----------------------------------------------
			 	UPD_Sql = UPD_Sql &";EXECUTE EDIT_M_PP_LOGO_OPTION_TB_COMFIRM_PROC "& PRC_ResultLineAdid &","& PRC_ReqInputBranch &","& PRC_LayoutBranch &",'"& UPD_CompanyLogoImg &"', '"& UPD_CompanyLogoImg &"',"& PRC_WaitLogoByte &","& PRC_MainLogoByte
			End If
		End If
  End If
   '<----------------------------------------------------------------------------------------------------------------------------------------------------------------------->
  'response.Write UPD_Sql
  'response.end
  ConnPaper.Execute UPD_Sql

End If

' 2015.03.02, 신혜원 파트장요청, 등록대행/줄/박스 수정 시 옵션이 기존과 현재가 틀리고, 전국판 플래티넘플러스/플래티넘/프리미엄플러스/프리미엄리스트/스페셜플러스/스피드파트타임상품/M프리미엄플러스/M프리미엄/M스페셜플러스/M포커스 옵션일 경우 로고를 검수대기로 변경
' 2016.01.08, 성소영과장 요청, 등록대행/줄/박스 => 등록대행/줄/박스/ECOMM 으로 변경되어 FormType값과 무관함
If PRC_ProcessType = "Modify" Then
  If (PRC_OptCode_Org <> PRC_InternetOpt And (PRC_InetArea And 1) And (PRC_InternetOpt = 12 Or PRC_InternetOpt = 29 Or PRC_InternetOpt = 53 Or PRC_InternetOpt = 55 Or PRC_InternetOpt = 56 Or PRC_InternetOpt = 57 Or PRC_InternetOpt = 65 Or PRC_InternetOpt = 72 Or PRC_InternetOpt = 73 Or PRC_InternetOpt = 74 Or PRC_InternetOpt = 75 Or PRC_InternetOpt = 76 Or PRC_InternetOpt = 87)) And (PRC_MOptCode_Org <> PRC_MobileOpt And (PRC_InetArea And 1) And (PRC_MobileOpt = 3 Or PRC_MobileOpt = 4 Or PRC_MobileOpt = 5 Or PRC_MobileOpt = 7 Or PRC_MobileOpt = 10 Or PRC_MobileOpt = 11 Or PRC_MobileOpt = 13 Or PRC_MobileOpt = 14 Or PRC_MobileOpt = 15 Or PRC_MobileOpt = 16)) Then
    UPD_Sql = "EXECUTE EDIT_M_PP_LOGO_OPTION_TB_WAIT_PROC "& PRC_ResultLineAdid &","& PRC_ReqInputBranch &","& PRC_LayoutBranch &",'R' "
    ConnPaper.Execute UPD_Sql
  End If
End If
'############################### // 플래티넘 로고(회사로고) 이미지 ###############################

'----------------------------------------------
'로고 확인 자료 - Start
'----------------------------------------------
Dim UPD_LogoConfirmImgPath      : UPD_LogoConfirmImgPath = USER_UPLOAD_JOB_IMG_PATH & "/LogoConfirm/"
Dim UPD_LogoConfirmImgTemp
Dim UPD_LogoConfirmMimeType
Dim UPD_LogoConfirmExtName
Dim UPD_LogoConfirmLen
Dim UPD_LogoConfirmImg
Dim UPD_LogoConfirmImgSave
Dim UPD_LogoConfirmImgDelYN     : UPD_LogoConfirmImgDelYN = "N"

'수정시
'1. 새로운 이미지를 선택했을 경우
'2. 구분값(PRC_LogoComfirm)이 변경 되었을 경우
'Response.Write "FnLen(PRC_LogoComfirmImgOrg) : " & FnLen(PRC_LogoComfirmImgOrg) & "<bR>"
'Response.Write "PRC_LogoComfirmOrg : " & PRC_LogoComfirmOrg & "<bR>"
'Response.Write "PRC_LogoComfirm : " & PRC_LogoComfirm & "<bR>"
If PRC_ProcessType = "Modify" And ((FnLen(PRC_LogoComfirmImgOrg) > 0 And FnLen(PRC_LogoComfirmImg) > 0) Or (FnLen(PRC_LogoComfirmImgOrg) > 0 And PRC_LogoComfirmOrg <> PRC_LogoComfirm)) Then
  UPD_LogoConfirmImgDelYN = "Y"
End If

'로고자료 이미지가 신규로 선택 되었을 경우
If FnLen(PRC_LogoComfirmImg) > 0 Then
  UPD_LogoConfirmMimeType = uploadForm("fileLogoConfirmImg").MimeType
  UPD_LogoConfirmExtName = uploadForm("fileLogoConfirmImg").FileExtension
  UPD_LogoConfirmLen = uploadForm("fileLogoConfirmImg").FileLen
  If (InStr(UPD_LogoConfirmMimeType, "image") > 0 )  Then
    '저장할 파일명 설정
    UPD_LogoConfirmImg = SetUploadFileFolder(UPD_LogoConfirmImgPath) & "LogoComfirm_"& CreateGUID() & "." & UPD_LogoConfirmExtName

    '임시폴더에 파일 업로드(저장)
    UPD_LogoConfirmImgTemp = uploadForm("fileLogoConfirmImg").Save(fileDir, false)

    '파일 용량 체크해서 리사이징
    If UPD_LogoConfirmLen > (50 * 1024) Then       ' 50KB 이상일 경우
      If true = objImage.SetSourceFile(UPD_LogoConfirmImgTemp) Then
        UPD_LogoConfirmImgSave = objImage.SaveasThumbnail(UPD_LogoConfirmImg, 600, 480, true, true)
      End If
    Else
      UPD_LogoConfirmImgSave = uploadForm("fileLogoConfirmImg").SaveAs(UPD_LogoConfirmImg, true)
    End If

    ' 원본(임시) 이미지 삭제
    uploadform.DeleteFile(UPD_LogoConfirmImgTemp)
  End If

'수정 시 로고자료 구분값이 홈페이지 일 경우
ElseIf PRC_ProcessType = "Modify" And Not (PRC_LogoComfirm = "명함" Or PRC_LogoComfirm = "간판사진") Then
  UPD_LogoConfirmImg = ""

'등록 시 신규로 선택 되지는 않았지만, 공고불러오기등으로 이전 로고자료에 이미지가 있었을 경우(로고자료 구분이 명함/간판사진)
ElseIf PRC_ProcessType = "Regist" And (PRC_LogoComfirm = "명함" Or PRC_LogoComfirm = "간판사진") And FnLen(PRC_LogoComfirmImgOrg) > 0 Then
  'UPD_LogoConfirmExtName = Right(PRC_LogoComfirmImgOrg, UBound(Split(PRC_LogoComfirmImgOrg, ".")) - 1)
  UPD_LogoConfirmExtName = Mid(PRC_LogoComfirmImgOrg, InStr(PRC_LogoComfirmImgOrg, ".") + 1)

  UPD_LogoConfirmImg = SetUploadFileFolder(UPD_LogoConfirmImgPath) & "LogoComfirm_"& CreateGUID() & "." & UPD_LogoConfirmExtName

  '기존 로고자료에서 복사
  UPD_LogoConfirmImg = SetFileMovePathName(PRC_LogoComfirmImgOrg, UPD_LogoConfirmImg, "C")
Else
  UPD_LogoConfirmImg = PRC_LogoComfirmImgOrg
End If
'Response.Write "PRC_LogoComfirmImgOrg : " & PRC_LogoComfirmImgOrg & "<bR>"
'Response.Write "PRC_LogoComfirmOrg : " & PRC_LogoComfirmOrg & "<bR>"
'Response.Write "PRC_LogoComfirm : " & PRC_LogoComfirm & "<bR>"
'Response.Write "UPD_LogoConfirmImgDelYN : " & UPD_LogoConfirmImgDelYN & "<bR>"
'Response.Write "UPD_LogoConfirmImg : " & UPD_LogoConfirmImg & "<bR>"
'Response.End

If PRC_LogoComfirm = "홈페이지" And Not (Left(PRC_LogoComfirmUrl, 7) = "http://" Or Left(PRC_LogoComfirmUrl, 8) = "https://") Then
  PRC_LogoComfirmUrl = "http://" & PRC_LogoComfirmUrl
End If

With objCmd
  .ActiveConnection = ConnPaper
  .CommandType = adCmdStoredProc
  .CommandText = "PUT_FJ_M_PP_LOGO_CONFIRM_DATA_PROC"

	If .Parameters.Count > 0 Then
		For PRC_ParamCnt = 0 to .Parameters.Count-1
			.Parameters.Delete(0)
		Next
	End If

  .Parameters.Append .CreateParameter("@LINEADID"           ,adInteger  ,adParamInput ,4    ,PRC_ResultLineAdid)
  .Parameters.Append .CreateParameter("@INPUT_BRANCH"       ,adTinyInt  ,adParamInput ,1    ,PRC_ReqInputBranch)
  .Parameters.Append .CreateParameter("@LAYOUT_BRANCH"      ,adTinyInt  ,adParamInput ,1    ,PRC_LayoutBranch)
  .Parameters.Append .CreateParameter("@LOGO_TEMPLATE"      ,adVarChar  ,adParamInput ,10   ,PRC_LogoTemplate)
  .Parameters.Append .CreateParameter("@LOGO_CONFIRM"       ,adVarChar  ,adParamInput ,10   ,PRC_LogoComfirm)
  .Parameters.Append .CreateParameter("@LOGO_CONFIRM_IMG"   ,adVarChar  ,adParamInput ,120  ,UPD_LogoConfirmImg)
  .Parameters.Append .CreateParameter("@LOGO_CONFIRM_URL"   ,adVarChar  ,adParamInput ,100  ,PRC_LogoComfirmUrl)
  .Execute
End With

' 오류체크
If err.number <> 0 Then    ' 오류가 발생한 경우
  ConnPaper.RollBackTrans ' 공고정보 입력에 대한 트렌젝션 롤백
  Call MsgBack("로고자료 처리 오류")
End If

' 기존 로고자료 삭제여부에 따라 삭제처리
If UPD_LogoConfirmImgDelYN = "Y" Then
 SetFileDeletePathName(PRC_LogoComfirmImgOrg)
End If

' 로고자료가 수정되었을 경우, 로고를 검수대기로 변경
If PRC_ProcessType = "Modify" Then
  If FnLen(PRC_LogoComfirmImg) > 0 OR PRC_LogoComfirmOrg <> PRC_LogoComfirm OR FnLen(PRC_CompanyLogo) > 0 OR PRC_Company <> PRC_CompanyOrg OR PRC_LogoTemplate <> PRC_LogoTemplateOrg OR PRC_Title <> PRC_TitleOrg Then '21.09.03 제목 변경시 로고검수 상태값 재수정으로 변경되도록 처리
    UPD_Sql = "EXECUTE EDIT_M_PP_LOGO_OPTION_TB_WAIT_PROC "& PRC_ResultLineAdid &","& PRC_ReqInputBranch &","& PRC_LayoutBranch &",'R' "
    ConnPaper.Execute UPD_Sql
  End If
End If

'----------------------------------------------
'로고 확인 자료 - End
'----------------------------------------------

Set FsoFile = Nothing
Set Fso     = Nothing

%>
