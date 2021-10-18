<%
'*******************************************************************************************
' 단 위 업 무 명	: 구인구직 공통 등록처리 공통 변수
' 작    성    자	: 최 봉 기 (virtualman@mediawill.com)
' 작    성    일	: 2013/07/23
' 수    정    자	: 김 성 준
' 수    정    일	: 2013/11/08
' 내          용	: 간편구인공고 등록번호 변수 추가
' 수    정    자	: 이 근 우 (stari@mediawill.com)
' 수    정    일	: 2013/11/24
' 수  정  내  용  : 옵션코드 변경에 따른 수정
' 수    정    자  : 김 성 준
' 수    정    일  : 2013/11/12
' 내          용  : 온라인입사지원여부 필드 추가
' 주  의  사  항  :
'*******************************************************************************************
%>
<%
'Dim PRC_                : PRC_                  = uploadForm("")
'************************************ 0. 공통 ************************************
Dim PRC_FreeRegCnt      : PRC_FreeRegCnt        = 0                                 ' 무료등록건수
Dim PRC_FreeRegCnt2     : PRC_FreeRegCnt2       = 0                                 ' 게재중인 무료등록건수
Dim PRC_ParamCnt
Dim PRC_Error           : PRC_Error             = 0                                 ' 오류여부 (0: 오류없음)
Dim PRC_ErrorDesc       : PRC_ErrorDesc         = ""                                ' 오류 내용

Dim PRC_FormType        : PRC_FormType          = getReplaceWord(uploadForm("hidFormType"))         ' 폼형태  ('PaperMod(줄광고 수정), Agency(등록대행), BoxAd(박스광고), Ecomm(이컴공고))
Dim PRC_SDFormType      : PRC_SDFormType        = GetEmptyChange(getReplaceWord(uploadForm("hidSDFormType")), "N") ' N:Ecomm, Y:영업관리-Ecomm
Dim RPC_ADKind          : RPC_ADKind            = "L"                               ' 공고종류 (L: 줄, B: 박스)
Dim PRC_Variety                                                                     ' 폼형태에 따른 공고 구분값 (게재이관 프로세스용)

Dim PRC_ReqLineAdid     : PRC_ReqLineAdid       = GetEmptyChange(getReplaceWord(uploadForm("hidReqLineAdid")),0)      ' 접수번호 (등록폼에서는 0으로 받음)
Dim PRC_ReqInputBranch  : PRC_ReqInputBranch    = getReplaceWord(uploadForm("hidReqInputBranch"))   ' 등록지점코드 (등록지점이 없는(신규등록) 경우 폼단에서 관리자 지점코드로 대체)
Dim PRC_MwPlus          : PRC_MwPlus            = getReplaceWord(uploadForm("hidMwPlus"))           ' MWPLUS를 통한 등록 여부
Dim PRC_ReturnUrl       : PRC_ReturnUrl         = getReplaceWord(uploadForm("hidReturnUrl"))        ' 리턴 경로
Dim PRC_ProcessType     : PRC_ProcessType       = getReplaceWord(uploadForm("hidProcessType"))      ' 처리형태 (Regist(등록), Modify(수정))
Dim PRC_ResultLineAdid  : PRC_ResultLineAdid    = 0                                 ' 등록프로시저를 통해 OutPut된 접수번호 (메인테이블 외에 하위 데이터저장은 PRC_ResultLineAdid로 처리해야함.)

Dim PRC_TempAdId        : PRC_TempAdId          = GetEmptyChange(getReplaceWord(uploadForm("TempAdId")), "")
Dim PRC_WiliantReqGbn   : PRC_WiliantReqGbn     = GetEmptyChange(getReplaceWord(uploadForm("WiliantReqGbn")), "")

Dim PRC_Recu_Term       : PRC_Recu_Term = 0     ' 모집 기간
Dim PRC_Opt_Term        : PRC_Opt_Term  = 0     ' 옵션 게재기간

Dim PRC_NMLineAdid      : PRC_NMLineAdid        = getReplaceWord(uploadForm("hidNMLineAdid"))       ' 신매체영업공고(EComm무료) 접수번호
Dim PRC_NMInputBranch   : PRC_NMInputBranch     = getReplaceWord(uploadForm("hidNMInputBranch"))    ' 신매체영업공고(EComm무료) 등록지점
Dim PRC_NMLayoutBranch  : PRC_NMLayoutBranch    = getReplaceWord(uploadForm("hidNMLayoutBranch"))   ' 신매체영업공고(EComm무료) 게재지점
Dim PRC_NMFlag          : PRC_NMFlag            = GetEmptyChange(getReplaceWord(uploadForm("hidNMFlag")),0)           ' 신매체영업공고(EcOMM무료) 여부 (0: 일반, 1: 신매체영업공고)

'************************************ 1. 공고등록 상단 ************************************
Dim PRC_UserId          : PRC_UserId            = Trim(getReplaceWord(uploadForm("txtUserId")))
Dim PRC_LayoutBranch    : PRC_LayoutBranch      = GetEmptyChange(getReplaceWord(uploadForm("hidLayoutBranch")),180)   ' GetEmptyChange(getReplaceWord(uploadForm("sltLayoutBranch")),180)
Dim PRC_LineCate_A      : PRC_LineCate_A        = getReplaceWord(uploadForm("sltLineCate_A"))
Dim PRC_LineCate_B      : PRC_LineCate_B        = getReplaceWord(uploadForm("sltLineCate_B"))
Dim PRC_LineCate_C      : PRC_LineCate_C        = getReplaceWord(uploadForm("sltLineCate_C"))
Dim PRC_CUID          	: PRC_CUID              = GetEmptyChange(Trim(getReplaceWord(uploadForm("hidCUID"))), null)
Dim PRC_LayoutCode

'************************************ 2. 기본정보 ************************************
Dim PRC_Company         : PRC_Company           = getReplaceWord(uploadForm("txtCompany"))
Dim PRC_CompanyOrg      : PRC_CompanyOrg        = getReplaceWord(uploadForm("hidCompany"))
Dim PRC_OrderName       : PRC_OrderName         = getReplaceWord(uploadForm("txtOrderName"))
Dim PRC_MWPhone1        : PRC_MWPhone1          = getReplaceWord(uploadForm("txtMWPhone1"))

's 전화번호 뒷자리 분리
Dim txtPhone1           : txtPhone1             = getReplaceWord(uploadForm("txtPhone1"))
If FnLen(txtPhone1) >= 8 Then
  txtPhone1 = LEFT(txtPhone1,4) & "-" & MID(txtPhone1,5,4)
ElseIf FnLen(txtPhone1) = 7 Then
  txtPhone1 = LEFT(txtPhone1,3) & "-" & MID(txtPhone1,4,4)
End If
'e 전화번호 뒷자리 분리
Dim PRC_Phone1          : PRC_Phone1            = getReplaceWord(uploadForm("sltPhone1")) & "-" & txtPhone1
Dim PRC_PhoneViewF1     : PRC_PhoneViewF1       = GetEmptyChange(getReplaceWord(uploadForm("chkPhone1_ViewF")),1)


's 전화번호 뒷자리 분리
Dim txtPhone2           : txtPhone2             = getReplaceWord(uploadForm("txtPhone2"))
If FnLen(txtPhone2) >= 8 Then
  txtPhone2 = LEFT(txtPhone2,4) & "-" & MID(txtPhone2,5,4)
ElseIf FnLen(txtPhone2) = 7 Then
  txtPhone2 = LEFT(txtPhone2,3) & "-" & MID(txtPhone2,4,4)
End If

Dim PRC_MWPhone2        : PRC_MWPhone2          = getReplaceWord(uploadForm("sltPhone2")) &"-"& txtPhone2

'e 전화번호 뒷자리 분리
Dim PRC_Phone2          : PRC_Phone2            = getReplaceWord(uploadForm("sltPhone2")) & "-" & txtPhone2
Dim PRC_PhoneViewF2     : PRC_PhoneViewF2       = GetEmptyChange(getReplaceWord(uploadForm("chkPhone2")),1) 'GetEmptyChange(getReplaceWord(uploadForm("chkPhoneViewF2")),1)

Dim PRC_Email           : If FnLen(getReplaceWord(uploadForm("txtEmail")(1))) > 0 Then PRC_Email = getReplaceWord(uploadForm("txtEmail")(1)) &"@"& getReplaceWord(uploadForm("txtEmail")(2)) End If
Dim PRC_EMailViewF      : PRC_EMailViewF        = GetEmptyChange(getReplaceWord(uploadForm("chkEMailViewF")),1)
Dim PRC_Url             : PRC_Url               = getReplaceWord(uploadForm("txtUrl"))
Dim PRC_CompanyLogo     : PRC_CompanyLogo       = getReplaceWord(uploadForm("hidLogoUploadFile"))
Dim PRC_MainBiz         : PRC_MainBiz           = getReplaceWord(uploadForm("txtMainBiz"))
Dim PRC_ComLogoImgDel   : PRC_ComLogoImgDel     = GetEmptyChange(getReplaceWord(uploadForm("hidCompanyLogoImgDel")),"0") ' 2020-07
Dim PRC_CompanyOrgLogo  : PRC_CompanyOrgLogo    = getReplaceWord(uploadForm("hidCompanyLogo"))
Dim PRC_CompanyOrgMainLogo  : PRC_CompanyOrgMainLogo    = getReplaceWord(uploadForm("hidCompanyMainLogo"))
Dim PRC_LogoTemplate    : PRC_LogoTemplate      = getReplaceWord(uploadForm("txtLogoTemplate"))
Dim PRC_LogoTemplateOrg : PRC_LogoTemplateOrg   = getReplaceWord(uploadForm("hidLogoTemplate"))
Dim PRC_LogoComfirm     : PRC_LogoComfirm       = GetEmptyChange(getReplaceWord(uploadForm("rdoLogoConfirm")), "")
Dim PRC_LogoComfirmImg  : PRC_LogoComfirmImg    = getReplaceWord(uploadForm("fileLogoConfirmImg"))
Dim PRC_LogoComfirmUrl  : PRC_LogoComfirmUrl    = GetEmptyChange(getReplaceWord(uploadForm("txtLogoConfirmUrl")), "")
Dim PRC_LogoComfirmOrg     : PRC_LogoComfirmOrg    = GetEmptyChange(getReplaceWord(uploadForm("hidLogoConfirm")), "")
Dim PRC_LogoComfirmImgOrg  : PRC_LogoComfirmImgOrg = getReplaceWord(uploadForm("hidLogoConfirmImg"))
Dim PRC_Phone
Dim PRC_HPhone

Dim PRC_Ci_AreaA        : PRC_Ci_AreaA          = getReplaceWord(uploadForm("selJobArea_A_1"))
Dim PRC_Ci_AreaB        : PRC_Ci_AreaB          = getReplaceWord(uploadForm("selJobArea_B_1"))
Dim PRC_Ci_AreaC        : PRC_Ci_AreaC          = getReplaceWord(uploadForm("selJobArea_C_1"))
Dim PRC_Ci_AreaDetail   : PRC_Ci_AreaDetail     = getReplaceWord(uploadForm("hidCI_ADDRESS_DETAIL"))
Dim PRC_Ci_ZipId        : PRC_Ci_ZipId          = 0

Dim PRC_Ci_Bizno        : PRC_Ci_Bizno          = getReplaceWord(uploadForm("txtBizno"))

'************************************ 3. 모집정보 ************************************
Dim PRC_Title           : PRC_Title             = getReplaceWord(uploadForm("txtTitle"))
Dim PRC_TitleOrg				: PRC_TitleOrg					= getReplaceWord(uploadForm("hidTitle"))
Dim PRC_Findcode1       : PRC_Findcode1         = GetEmptyChange(getReplaceWord(uploadForm("hidFindcode1")),0)
Dim PRC_Findcode2       : PRC_Findcode2         = GetEmptyChange(getReplaceWord(uploadForm("hidFindcode2")),0)
Dim PRC_Findcode3       : PRC_Findcode3         = GetEmptyChange(getReplaceWord(uploadForm("hidFindcode3")),0)
Dim PRC_Findcode4       : PRC_Findcode4         = GetEmptyChange(getReplaceWord(uploadForm("hidFindcode4")),0)
Dim PRC_Findcode5       : PRC_Findcode5         = GetEmptyChange(getReplaceWord(uploadForm("hidFindcode5")),0)
Dim PRC_Findcode6       : PRC_Findcode6         = GetEmptyChange(getReplaceWord(uploadForm("hidFindcode6")),0)
Dim PRC_Findcode7       : PRC_Findcode7         = GetEmptyChange(getReplaceWord(uploadForm("hidFindcode7")),0)
Dim PRC_Findcode8       : PRC_Findcode8         = GetEmptyChange(getReplaceWord(uploadForm("hidFindcode8")),0)
Dim PRC_Findcode9       : PRC_Findcode9         = GetEmptyChange(getReplaceWord(uploadForm("hidFindcode9")),0)
Dim PRC_Findcode10      : PRC_Findcode10        = GetEmptyChange(getReplaceWord(uploadForm("hidFindcode10")),0)
Dim PRC_WorkMain        : PRC_WorkMain          = GetEmptyChange(getReplaceWord(uploadForm("chkWorkMain")),0)
Dim PRC_WorkSub         : PRC_WorkSub           = GetEmptyChange(getReplaceWord(uploadForm("chkWorkSub")),0)
Dim PRC_WorkOut         : PRC_WorkOut           = GetEmptyChange(getReplaceWord(uploadForm("chkWorkOut")),0)
Dim PRC_PartTime        : PRC_PartTime          = GetEmptyChange(getReplaceWord(uploadForm("chkPartTime")),0)
Dim PRC_WorkAppoint     : PRC_WorkAppoint       = GetEmptyChange(getReplaceWord(uploadForm("chkWorkAppoint")),0)
Dim PRC_WorkFreelancer  : PRC_WorkFreelancer    = GetEmptyChange(getReplaceWord(uploadForm("chkWorkFreelancer")),0)

Dim PRC_AreaA_1         : PRC_AreaA_1           = GetEmptyChange(getReplaceWord(uploadForm("selJobArea_A_1")),"0")
Dim PRC_AreaB_1         : PRC_AreaB_1           = GetEmptyChange(getReplaceWord(uploadForm("selJobArea_B_1")),"0")
Dim PRC_AreaC_1         : PRC_AreaC_1           = GetEmptyChange(getReplaceWord(uploadForm("selJobArea_C_1")),"0")
Dim PRC_AreaDetail_1    : PRC_AreaDetail_1      = getReplaceWord(uploadForm("txtADDRESS_DETAIL"))
Dim PRC_AreaValue1

Dim PRC_AreaA_2         : PRC_AreaA_2           = GetEmptyChange(getReplaceWord(uploadForm("selJobArea_A_2")),"0")
Dim PRC_AreaB_2         : PRC_AreaB_2           = GetEmptyChange(getReplaceWord(uploadForm("selJobArea_B_2")),"0")
Dim PRC_AreaC_2         : PRC_AreaC_2           = GetEmptyChange(getReplaceWord(uploadForm("selJobArea_C_2")),"0")
Dim PRC_AreaDetail_2    : PRC_AreaDetail_2      = getReplaceWord(uploadForm("txtAreaDetail_2"))
Dim PRC_AreaValue2

Dim PRC_AreaA_3         : PRC_AreaA_3           = GetEmptyChange(getReplaceWord(uploadForm("selJobArea_A_3")),"0")
Dim PRC_AreaB_3         : PRC_AreaB_3           = GetEmptyChange(getReplaceWord(uploadForm("selJobArea_B_3")),"0")
Dim PRC_AreaC_3         : PRC_AreaC_3           = GetEmptyChange(getReplaceWord(uploadForm("selJobArea_C_3")),"0")
Dim PRC_AreaDetail_3    : PRC_AreaDetail_3      = getReplaceWord(uploadForm("txtAreaDetail_3"))
Dim PRC_AreaValue3

Dim PRC_ResultArea

Dim PRC_HomeF           : PRC_HomeF             = GetEmptyChange(getReplaceWord(uploadForm("chkHomeF")),0)

'외근직 추가입력
Dim PRC_OutF           : PRC_OutF             = GetEmptyChange(getReplaceWord(uploadForm("locationopt3")),0)

Dim PRC_SubwayF         : PRC_SubwayF           = GetEmptyChange(getReplaceWord(uploadForm("hidSubwayF")),0)

Dim PRC_UniversityF     : PRC_UniversityF       = getReplaceWord(uploadForm("rdoUniversityF"))
Dim PRC_Point_X         : PRC_Point_X           = GetEmptyChange(getReplaceWord(uploadForm("hidPoint_X")),0)
Dim PRC_Point_Y         : PRC_Point_Y           = GetEmptyChange(getReplaceWord(uploadForm("hidPoint_Y")),0)
Dim PRC_GPoint_X        : PRC_GPoint_X          = GetEmptyChange(getReplaceWord(uploadForm("hidGPoint_X")),0)
Dim PRC_GPoint_Y        : PRC_GPoint_Y          = GetEmptyChange(getReplaceWord(uploadForm("hidGPoint_Y")),0)

Dim PRC_RV_PANOID       : PRC_RV_PANOID         = GetEmptyChange(getReplaceWord(uploadForm("hidRV_PANOID")),Null)
Dim PRC_RV_ANGLEID      : PRC_RV_ANGLEID        = GetEmptyChange(getReplaceWord(uploadForm("hidRV_ANGLEID")),Null)

Dim PRC_MAP_VIEW_YN     : PRC_MAP_VIEW_YN				= GetEmptyChange(getReplaceWord(uploadForm("chkMAP_VIEW_YN")),"Y")


Dim PRC_SubWayCode_C_1  : PRC_SubWayCode_C_1    = getReplaceWord(uploadForm("sltSubWayCode_C_1"))
Dim PRC_SubwayGate_1    : PRC_SubwayGate_1      = getReplaceWord(uploadForm("txtSubwayGate_1"))
Dim PRC_SubwayEtc_1     : PRC_SubwayEtc_1       = getReplaceWord(uploadForm("txtSubwayEtc_1"))
Dim PRC_SubWayValue1

IF PRC_SubWayCode_C_1 <> "" THEN
	PRC_SubwayF = 1
END IF

Dim PRC_SubWayCode_C_2  : PRC_SubWayCode_C_2    = getReplaceWord(uploadForm("sltSubWayCode_C_2"))
Dim PRC_SubwayGate_2    : PRC_SubwayGate_2      = getReplaceWord(uploadForm("txtSubwayGate_2"))
Dim PRC_SubwayEtc_2     : PRC_SubwayEtc_2       = getReplaceWord(uploadForm("txtSubwayEtc_2"))
Dim PRC_SubWayValue2

Dim PRC_SubWayCode_C_3  : PRC_SubWayCode_C_3    = getReplaceWord(uploadForm("sltSubWayCode_C_3"))
Dim PRC_SubwayGate_3    : PRC_SubwayGate_3      = getReplaceWord(uploadForm("txtSubwayGate_3"))
Dim PRC_SubwayEtc_3     : PRC_SubwayEtc_3       = getReplaceWord(uploadForm("txtSubwayEtc_3"))
Dim PRC_SubWayValue3

Dim PRC_SubWayCode_C_4  : PRC_SubWayCode_C_4    = getReplaceWord(uploadForm("sltSubWayCode_C_4"))
Dim PRC_SubwayGate_4    : PRC_SubwayGate_4      = getReplaceWord(uploadForm("txtSubwayGate_4"))
Dim PRC_SubwayEtc_4     : PRC_SubwayEtc_4       = getReplaceWord(uploadForm("txtSubwayEtc_4"))
Dim PRC_SubWayValue4

Dim PRC_SubWayCode_C_5  : PRC_SubWayCode_C_5    = getReplaceWord(uploadForm("sltSubWayCode_C_5"))
Dim PRC_SubwayGate_5    : PRC_SubwayGate_5      = getReplaceWord(uploadForm("txtSubwayGate_5"))
Dim PRC_SubwayEtc_5     : PRC_SubwayEtc_5       = getReplaceWord(uploadForm("txtSubwayEtc_5"))
Dim PRC_SubWayValue5

Dim PRC_DISTANCE1				:	PRC_DISTANCE1					= getReplaceWord(uploadForm("sltDISTANCE1"))
Dim PRC_DISTANCE2				:	PRC_DISTANCE2					= getReplaceWord(uploadForm("sltDISTANCE2"))
Dim PRC_DISTANCE3				:	PRC_DISTANCE3					= getReplaceWord(uploadForm("sltDISTANCE3"))
Dim PRC_DISTANCE4				:	PRC_DISTANCE4					= getReplaceWord(uploadForm("sltDISTANCE4"))
Dim PRC_DISTANCE5				:	PRC_DISTANCE5					= getReplaceWord(uploadForm("sltDISTANCE5"))

Dim PRC_UniversityCode_B_1  : PRC_UniversityCode_B_1  = getReplaceWord(uploadForm("sltUniversityCode_B_1"))
Dim PRC_UniversityCode_B_2  : PRC_UniversityCode_B_2  = getReplaceWord(uploadForm("sltUniversityCode_B_2"))
Dim PRC_UniversityCode_B_3  : PRC_UniversityCode_B_3  = getReplaceWord(uploadForm("sltUniversityCode_B_3"))
Dim PRC_UniversityCode_B_4  : PRC_UniversityCode_B_4  = getReplaceWord(uploadForm("sltUniversityCode_B_4"))
Dim PRC_UniversityCode_B_5  : PRC_UniversityCode_B_5  = getReplaceWord(uploadForm("sltUniversityCode_B_5"))

Dim PRC_UniversityEtc_1     : PRC_UniversityEtc_1       = getReplaceWord(uploadForm("txtUniversityEtc_1"))
Dim PRC_UniversityEtc_2     : PRC_UniversityEtc_2       = getReplaceWord(uploadForm("txtUniversityEtc_2"))
Dim PRC_UniversityEtc_3     : PRC_UniversityEtc_3       = getReplaceWord(uploadForm("txtUniversityEtc_3"))
Dim PRC_UniversityEtc_4     : PRC_UniversityEtc_4       = getReplaceWord(uploadForm("txtUniversityEtc_4"))
Dim PRC_UniversityEtc_5     : PRC_UniversityEtc_5       = getReplaceWord(uploadForm("txtUniversityEtc_5"))

Dim PRC_UniversityValue1
Dim PRC_UniversityValue2
Dim PRC_UniversityValue3
Dim PRC_UniversityValue4
Dim PRC_UniversityValue5

Dim PRC_PayKind         : PRC_PayKind           = GetEmptyChange(getReplaceWord(uploadForm("sltPayF")),0)
Dim PRC_PayType         : PRC_PayType           = Cint(GetEmptyChange(getReplaceWord(uploadForm("chkPayType1")),0)) + Cint(GetEmptyChange(getReplaceWord(uploadForm("chkPayType2")),0)) + Cint(GetEmptyChange(getReplaceWord(uploadForm("chkPayType3")),0)) + Cint(GetEmptyChange(getReplaceWord(uploadForm("chkPayType4")),0))
Dim PRC_PayFrom         : PRC_PayFrom           = GetEmptyChange(getReplaceWord(uploadForm("txtPay")),0)
Dim PRC_PayTo           : PRC_PayTo             = GetEmptyChange(getReplaceWord(uploadForm("txtPay")),0)
Dim PRC_PayPossible     : PRC_PayPossible       = GetEmptyChange(getReplaceWord(uploadForm("chkPayPossible")),0)
Dim PRC_UprightAgree    : PRC_UprightAgree      = GetEmptyChange(getReplaceWord(uploadForm("chkUprightAgree")),0)
Dim PRC_PayCompanyRules : PRC_PayCompanyRules   = GetEmptyChange(getReplaceWord(uploadForm("chkPayCompanyRules")),0)
Dim PRC_PayCompanyRulesEtc : PRC_PayCompanyRulesEtc = GetEmptyChange(getReplaceWord(uploadForm("txtPayCompanyRulesEtc")),"")



Dim PRC_FaxF              : PRC_FaxF             = GetEmptyChange(getReplaceWord(uploadForm("chkFaxF")), 1)

Dim txtFax
If FnLen(getReplaceWord(uploadForm("txtFax"))) >= 8 Then
  txtFax = LEFT(getReplaceWord(uploadForm("txtFax")),4) & "-" & MID(getReplaceWord(uploadForm("txtFax")),5,4)
ElseIf FnLen(getReplaceWord(uploadForm("txtFax"))) = 7 Then
  txtFax = LEFT(getReplaceWord(uploadForm("txtFax")),3) & "-" & MID(getReplaceWord(uploadForm("txtFax")),4,4)
End If

Dim PRC_Fax               : PRC_Fax              = Replace(getReplaceWord(uploadForm("sltFAX")) &"-"& txtFax, "--", "")
Dim PRC_DayWeek           : PRC_DayWeek          = GetEmptyChange(getReplaceWord(uploadForm("rdoDayWeek")), 0) ' 근무요일 월~금 등
Dim PRC_DayWeekOption     : PRC_DayWeekOption    = GetEmptyChange(getReplaceWord(uploadForm("txtDayWeekOption")), 0) ' 근무요일 2교대,3교대,격주휴무 등 값
Dim PRC_DayWeekOptionEtc  : PRC_DayWeekOptionEtc = GetEmptyChange(getReplaceWord(uploadForm("txtDayWeekOptionEtc")), "") ' 근무일 관련 내용 text

Dim PRC_WorkTimeFrom    : PRC_WorkTimeFrom      = GetEmptyChange(getReplaceWord(uploadForm("hidWorkTimeFrom")),Null) ' 근무시간 직접선택시 시작시간
Dim PRC_WorkTimeTo      : PRC_WorkTimeTo        = GetEmptyChange(getReplaceWord(uploadForm("hidWorkTimeTo")),Null)   ' 근무시간 직접선택시 종료시간

Dim PRC_WorkTimeF       : PRC_WorkTimeF         = GetEmptyChange(getReplaceWord(uploadForm("chkWorkTimeF")),1) ' 근무시간 협의가능여부
Dim PRC_WorkTimeDisplay       : PRC_WorkTimeDisplay         = GetEmptyChange(getReplaceWord(uploadForm("chkWorkTimeF")),0) ' 옛날 데이터 총 근무시간 노출여부

Dim PRC_AddressJibun        : PRC_AddressJibun        = getReplaceWord(uploadForm("hidADDRESS_JIBUN")) ' 근무지 지번주소
Dim PRC_AddressRoad         : PRC_AddressRoad         = getReplaceWord(uploadForm("txtADDRESS_ROAD")) ' 근무지 도로명주소
Dim PRC_AddressDetail       : PRC_AddressDetail       = getReplaceWord(uploadForm("txtADDRESS_DETAIL")) ' 근무지 상세주소
Dim PRC_AddressAreaCode    : PRC_AddressAreaCode			= GetEmptyChange(getReplaceWord(uploadForm("hidAddressAreaCode")), 0)
Dim PRC_AddtextTitle       : PRC_AddtextTitle				= GetEmptyChange(getReplaceWord(uploadForm("txtAddtextTitle")), "")
Dim PRC_AddtextContents    : PRC_AddtextContents			= GetEmptyChange(getReplaceWord(uploadForm("txtAddtextContents")), "")
Dim PRC_DayWeekOption2      : PRC_DayWeekOption2      = GetEmptyChange(getReplaceWord(uploadForm("hidDayWeekOption2")), 0) ' 근무요일 비트연산
Dim PRC_RestTimeF           : PRC_RestTimeF           = GetEmptyChange(getReplaceWord(uploadForm("chkRestTimeF")), 1) ' 휴게시간 포함여부 0:노출, 1:비노출
Dim PRC_RealWorkTime        : PRC_RealWorkTime        = GetEmptyChange(getReplaceWord(uploadForm("hidReal_WorkTime")), 0) ' 실제 근무시간
Dim PRC_RealWorkTimeDisplay : PRC_RealWorkTimeDisplay = GetEmptyChange(getReplaceWord(uploadForm("chkReal_WorkTime_Display")), 0) ' 실제 근무시간 노출여부
Dim PRC_CiAddressJibun      : PRC_CiAddressJibun      = getReplaceWord(uploadForm("hidCI_ADDRESS_JIBUN")) '회사 주소 지번
Dim PRC_CiAddressRoad       : PRC_CiAddressRoad       = GetEmptyChange(getReplaceWord(uploadForm("txtCI_ADDRESS_ROAD")),"") ' 회사 주소 도로명
Dim PRC_CiAddressDetail     : PRC_CiAddressDetail     = getReplaceWord(uploadForm("hidCI_ADDRESS_DETAIL")) ' 회사주소 상세
Dim PRC_WorktimeCode        : PRC_WorktimeCode        = GetEmptyChange(getReplaceWord(uploadForm("chkWorktimeCode")), 0) ' 근무시간 코드
Dim PRC_PaytoOverF          : PRC_PaytoOverF          = GetEmptyChange(getReplaceWord(uploadForm("chkPaytoOverF")), 0) '급여 이상지급 여부
Dim PRC_WorkTakeCharge      : PRC_WorkTakeCharge      = GetEmptyChange(getReplaceWord(uploadForm("txtWork_Take_Charge")),"")' 담당업무
Dim PRC_Company_URL					: PRC_Company_URL					= GetEmptyChange(getReplaceWord(uploadForm("txtCompany_URL")),"")' 근무지 홈페이지 URL

Dim PRC_Sex             : PRC_Sex               = GetEmptyChange(getReplaceWord(uploadForm("rdoSex")),0)
Dim PRC_AgeF            : PRC_AgeF              = GetEmptyChange(getReplaceWord(uploadForm("rdoAgeF")),0)
Dim PRC_AgeFrom         : PRC_AgeFrom           = GetEmptyChange(getReplaceWord(uploadForm("sltAgeFrom")),0)
Dim PRC_AgeTo           : PRC_AgeTo             = GetEmptyChange(getReplaceWord(uploadForm("sltAgeTo")),0)
Dim PRC_AgeOldValue     : PRC_AgeOldValue       = Cint(GetEmptyChange(getReplaceWord(uploadForm("chkAge1")),0)) + Cint(GetEmptyChange(getReplaceWord(uploadForm("chkAge2")),0)) + Cint(GetEmptyChange(getReplaceWord(uploadForm("chkAge3")),0)) + Cint(GetEmptyChange(getReplaceWord(uploadForm("chkAge4")),0)) + Cint(GetEmptyChange(getReplaceWord(uploadForm("chkAge5")),0)) + Cint(GetEmptyChange(getReplaceWord(uploadForm("chkAge6")),0))
Dim PRC_AgeSub1         : PRC_AgeSub1           = GetEmptyChange(getReplaceWord(uploadForm("chkSubAge1")),0)
Dim PRC_AgeSub2         : PRC_AgeSub2           = GetEmptyChange(getReplaceWord(uploadForm("chkSubAge2")),0)
Dim PRC_AgeSub3         : PRC_AgeSub3           = GetEmptyChange(getReplaceWord(uploadForm("chkSubAge3")),0)
Dim PRC_EduLevel        : PRC_EduLevel          = GetEmptyChange(getReplaceWord(uploadForm("sltEduLevel")),0)
Dim PRC_EduLevelValue		: PRC_EduLevelValue     = GetEmptyChange(getReplaceWord(uploadForm("academy")),0)
'Dim PRC_CareerF_Rdo     : PRC_CareerF_Rdo       = GetEmptyChange(getReplaceWord(uploadForm("rdoCareerF")),1)
Dim PRC_CareerF_Chk     : PRC_CareerF_Chk       = Cint(GetEmptyChange(getReplaceWord(uploadForm("chkCareerF1")),0)) '+ Cint(GetEmptyChange(getReplaceWord(uploadForm("chkCareerF2")),0))
Dim PRC_CareerFrom      : PRC_CareerFrom        = GetEmptyChange(getReplaceWord(uploadForm("sltCareerFrom")),0)
Dim PRC_CareerTo        : PRC_CareerTo          = GetEmptyChange(getReplaceWord(uploadForm("sltCareerTo")),0)
Dim PRC_CareerFValue		: PRC_CareerFValue      = Cint(GetEmptyChange(getReplaceWord(uploadForm("rdoCareerF")),0)) + Cint(GetEmptyChange(getReplaceWord(uploadForm("rdoCareerF1")),0)) + Cint(GetEmptyChange(getReplaceWord(uploadForm("rdoCareerF2")),0))

Dim PRC_Field3          : PRC_Field3            = getReplaceWord(uploadForm("txtField3"))
'Dim PRC_EcValue1       : PRC_EcValue1          = getReplaceWord(uploadForm("chkEcValue"))

Dim PRC_EcValue1        : PRC_EcValue1          = getReplaceWord(uploadForm("hidEcValue")(1))
Dim PRC_EcValue2        : PRC_EcValue2          = getReplaceWord(uploadForm("hidEcValue")(2))
Dim PRC_EcValue3        : PRC_EcValue3          = getReplaceWord(uploadForm("hidEcValue")(3))
Dim PRC_EcValue4        : PRC_EcValue4          = getReplaceWord(uploadForm("hidEcValue")(4))
Dim PRC_EcValue5        : PRC_EcValue5          = getReplaceWord(uploadForm("hidEcValue")(5))
Dim PRC_EcValue6        : PRC_EcValue6          = getReplaceWord(uploadForm("hidEcValue")(6))
Dim PRC_EcValue7        : PRC_EcValue7          = getReplaceWord(uploadForm("hidEcValue")(7))
Dim PRC_EcValue8        : PRC_EcValue8          = getReplaceWord(uploadForm("hidEcValue")(8))
Dim PRC_EcValue9        : PRC_EcValue9          = getReplaceWord(uploadForm("hidEcValue")(9))
Dim PRC_EcValue10       : PRC_EcValue10         = getReplaceWord(uploadForm("hidEcValue")(10))
Dim PRC_EcValue11       : PRC_EcValue11         = getReplaceWord(uploadForm("hidEcValue")(11))
Dim PRC_EcValue12       : PRC_EcValue12         = getReplaceWord(uploadForm("hidEcValue")(12))
Dim PRC_EcValue13       : PRC_EcValue13         = getReplaceWord(uploadForm("hidEcValue")(13))
Dim PRC_EcValue14       : PRC_EcValue14         = getReplaceWord(uploadForm("hidEcValue")(14))
Dim PRC_EcValue15       : PRC_EcValue15         = getReplaceWord(uploadForm("hidEcValue")(15))
Dim PRC_EcValue16       : PRC_EcValue16         = getReplaceWord(uploadForm("hidEcValue")(16))
Dim PRC_EcValue17       : PRC_EcValue17         = getReplaceWord(uploadForm("hidEcValue")(17))
Dim PRC_EcValue18       : PRC_EcValue18         = getReplaceWord(uploadForm("hidEcValue")(18))
Dim PRC_EcValue19       : PRC_EcValue19         = getReplaceWord(uploadForm("hidEcValue")(19))
Dim PRC_EcValue20       : PRC_EcValue20         = getReplaceWord(uploadForm("hidEcValue")(20))
Dim PRC_ServicePeriod   : PRC_ServicePeriod     = GetEmptyChange(getReplaceWord(uploadForm("sltServicePeriod")),100)  ' 값이 없을 경우 100으로 대체 (프로시저단에서 Null값 처리)

IF PRC_WorkSub = 0 AND PRC_PartTime = 0 THEN
	PRC_ServicePeriod = 100
END IF

Dim PRC_JOB_BENEFIT     : PRC_JOB_BENEFIT       = GetEmptyChange(getReplaceWord(uploadForm("hd_job_benefit")), 0)   ' 복리후생 추가(2015.05.21)

Dim PRC_JOB_ADVANTAGE		: PRC_JOB_ADVANTAGE			= GetEmptyChange(getReplaceWord(uploadForm("chkADVANTAGE")), "")   ' 지원자성향 추가(2020.08.18)


'************************************ 4. 접수내용 ************************************
Dim PRC_StartDate       : PRC_StartDate         = GetEmptyChange(getReplaceWord(uploadForm("txtStartDate")),getReplaceWord(uploadForm("hidStartDT")))
Dim PRC_EndDate					: PRC_EndDate						= GetEmptyChange(getReplaceWord(uploadForm("txtEndDate")),getReplaceWord(uploadForm("hidEndDT")))
Dim PRC_FatStartDate    : PRC_FatStartDate      = getReplaceWord(uploadForm("hidFatStartDate"))
Dim PRC_RecuitEndDate   : PRC_RecuitEndDate     = getReplaceWord(uploadForm("txtRecuitEndDate"))
Dim PRC_RegularempF     : PRC_RegularempF       = GetEmptyChange(getReplaceWord(uploadForm("chkRegularempF")),0)
Dim PRC_CtPhone         : PRC_CtPhone           = GetEmptyChange(getReplaceWord(uploadForm("chkCtPhone")),0)
Dim PRC_CtEmail         : PRC_CtEmail           = GetEmptyChange(getReplaceWord(uploadForm("chkCtEmail")),0)
Dim PRC_CtSMS           : PRC_CtSMS             = GetEmptyChange(getReplaceWord(uploadForm("chkCtSMS")),0)
Dim PRC_CtUrl           : PRC_CtUrl             = GetEmptyChange(getReplaceWord(uploadForm("chkCtUrl")),0)
' 홈페이지 지원이 아닐경우 URL 빈값 DEFAULT값이 HTTPS:// 이기 때문에
IF PRC_CtUrl = "0" Then
	PRC_Url = ""
END IF

Dim PRC_CtVisit         : PRC_CtVisit           = GetEmptyChange(getReplaceWord(uploadForm("chkCtVisit")),0)
Dim PRC_CtOnline        : PRC_CtOnline          = GetEmptyChange(getReplaceWord(uploadForm("chkCtOnline")),0)
Dim PRC_SubMitDoc       : PRC_SubMitDoc         = Cint(GetEmptyChange(getReplaceWord(uploadForm("chkSubmitDoc1")),0)) + Cint(GetEmptyChange(getReplaceWord(uploadForm("chkSubmitDoc2")),0))

'************************************ 5. 줄/박스광고 내용 ************************************
Dim PRC_Contents        : PRC_Contents          = getReplaceWord(uploadForm("txtContents"))

'************************************ 6. 상세내용 ************************************
Dim PRC_txtExContents_TextArea  : PRC_txtExContents_TextArea  = getReplaceWord(uploadForm("txtExContents_TextArea"))
Dim PRC_HtmlFlag        : PRC_HtmlFlag          = getReplaceWord(uploadForm("rdoHtmlFlag"))
Dim PRC_txtExContents   : PRC_txtExContents     = getReplaceWord(uploadForm("txtExContents"))
Dim PRC_TmpFileCode     : PRC_TmpFileCode       = getReplaceWord(uploadForm("hidTmpFileCode"))
Dim PRC_TmpFileUploadYN : PRC_TmpFileUploadYN   = getReplaceWord(uploadForm("hidTmpFileUploadYN"))
Dim PRC_ExImgDelYN      : PRC_ExImgDelYN        = getReplaceWord(uploadForm("hidExImgDelYN"))
Dim PRC_PartnerFlag     : PRC_PartnerFlag       = GetEmptyChange(getReplaceWord(uploadForm("chkPartnerFlag")),"0")
Dim PRC_FederationFlag  : PRC_FederationFlag    = GetEmptyChange(getReplaceWord(uploadForm("chkFederationFlag")),0)
Dim PRC_KinfaFlag       : PRC_KinfaFlag         = GetEmptyChange(getReplaceWord(uploadForm("chkKinfaFlag")),0)
Dim PRC_SeniortvFlag    : PRC_SeniortvFlag      = GetEmptyChange(getReplaceWord(uploadForm("chkSeniortvFlag")),0)
Dim PRC_ThemeID         : PRC_ThemeID           = GetEmptyChange(getReplaceWord(uploadForm("sltThemeID")),0)

Dim PRC_OrgUploadFile(4)
Dim PRC_LoadAdUploadFile(4)

PRC_OrgUploadFile(1)    = getReplaceWord(uploadForm("hidOrgUploadFile")(1))
PRC_OrgUploadFile(2)    = getReplaceWord(uploadForm("hidOrgUploadFile")(2))
PRC_OrgUploadFile(3)    = getReplaceWord(uploadForm("hidOrgUploadFile")(3))
PRC_OrgUploadFile(4)    = getReplaceWord(uploadForm("hidOrgUploadFile")(4))

PRC_LoadAdUploadFile(1) = getReplaceWord(uploadForm("hidLoadAdUploadFile")(1))
PRC_LoadAdUploadFile(2) = getReplaceWord(uploadForm("hidLoadAdUploadFile")(2))
PRC_LoadAdUploadFile(3) = getReplaceWord(uploadForm("hidLoadAdUploadFile")(3))
PRC_LoadAdUploadFile(4) = getReplaceWord(uploadForm("hidLoadAdUploadFile")(4))

'************************************ 6-2. 상세내용 NEW 템플릿 ************************************
Dim PRC_TopImgIDX					: PRC_TopImgIDX				= GetEmptyChange(getReplaceWord(uploadForm("hidOldCheckValue")),0)
Dim PRC_NewTemplateIDX		: PRC_NewTemplateIDX	= GetEmptyChange(getReplaceWord(uploadForm("template")),0)
Dim PRC_COMMENT1					: PRC_COMMENT1				= getReplaceWord(uploadForm("txtComment1"))
Dim PRC_COMMENT2					: PRC_COMMENT2				= getReplaceWord(uploadForm("txtComment2"))
Dim PRC_COMMENT3					: PRC_COMMENT3				= getReplaceWord(uploadForm("txtComment3"))
Dim PRC_TEMP_TITLE				: PRC_TEMP_TITLE			= getReplaceWord(uploadForm("txtTemplateTitle"))
Dim PRC_NewExContents			: PRC_NewExContents   = SetNewEditorConvert(getReplaceWord(uploadForm("hidNew_EX_Contents")))


'************************************ 7. 유료상품선택 ************************************
Dim PRC_OrgStartDt        : PRC_OrgStartDt        = getReplaceWord(uploadForm("hidOrgStartDt"))
Dim PRC_OrgEndDt          : PRC_OrgEndDt          = getReplaceWord(uploadForm("hidOrgEndDt"))

Dim PRC_OptStartDt        : PRC_OptStartDt        = GetEmptyChange(getReplaceWord(uploadForm("txtOptStartDt")),getReplaceWord(uploadForm("hidOptStartDT")))
Dim PRC_OptEndDt          : PRC_OptEndDt          = GetEmptyChange(getReplaceWord(uploadForm("txtOptEndDt")),getReplaceWord(uploadForm("hidOptEndDT")))

Dim PRC_ReserveYN_Org
Dim PRC_ReserveYN         : PRC_ReserveYN         = getReplaceWord(uploadForm("hidOrgReserveYN"))
Dim PRC_ReserveStartDT    : PRC_ReserveStartDT    = ""
Dim PRC_ReserveEndDT      : PRC_ReserveEndDT      = ""
Dim PRC_ReserveHour       : PRC_ReserveHour       = GetEmptyChange(getReplaceWord(uploadForm("sltReserveHour")),0)
Dim PRC_ReserveMin        : PRC_ReserveMin        = GetEmptyChange(getReplaceWord(uploadForm("sltReserveMin")),0)
Dim PRC_OptPrefClose      : PRC_OptPrefClose      = GetEmptyChange(getReplaceWord(uploadForm("chkOptPrefClose")),0)
Dim PRC_OptPremium        : PRC_OptPremium        = GetEmptyChange(getReplaceWord(uploadForm("chkOptPremium")),0)
Dim PRC_OptLineBox        : PRC_OptLineBox        = GetEmptyChange(getReplaceWord(uploadForm("chkOptLineBox")),0)
Dim PRC_OptSpeed          : PRC_OptSpeed          = GetEmptyChange(getReplaceWord(uploadForm("chkOptSpeed")),0)
Dim PRC_OptPaper
Dim PRC_OptAccent         : PRC_OptAccent         = GetEmptyChange(getReplaceWord(uploadForm("chkOptAccent")),0)
Dim PRC_OptColor          : PRC_OptColor          = GetEmptyChange(getReplaceWord(uploadForm("chkOptColor")),0)
Dim PRC_OptBg             : PRC_OptBg             = GetEmptyChange(getReplaceWord(uploadForm("chkOptBg")),0)
Dim PRC_OptBgType         : PRC_OptBgType         = GetEmptyChange(getReplaceWord(uploadForm("rdoOptBg")),0)
Dim PRC_OptBgValue
Dim PRC_OptIcon           : PRC_OptIcon           = GetEmptyChange(getReplaceWord(uploadForm("chkOptIcon")),0)
Dim PRC_OptIconType       : PRC_OptIconType       = GetEmptyChange(getReplaceWord(uploadForm("rdoOptIcon")),0)
Dim PRC_OptIconValue
Dim PRC_InternetOpt       : PRC_InternetOpt       = Cint(GetEmptyChange(getReplaceWord(uploadForm("rdoOpt")),0))
Dim PRC_AlbaOpt           : PRC_AlbaOpt           = Cint(GetEmptyChange(getReplaceWord(uploadForm("rdoAlbaOpt")),0))
Dim PRC_FatOpt            : PRC_FatOpt            = Cint(GetEmptyChange(getReplaceWord(uploadForm("hidFatOpt")),0))
Dim PRC_ConbineOpt        : PRC_ConbineOpt        = Cint(GetEmptyChange(getReplaceWord(uploadForm("chkCombine")),0))
Dim PRC_OptCode_Org       : PRC_OptCode_Org       = Cint(GetEmptyChange(getReplaceWord(uploadForm("hidOptCode_Org")),0))
Dim PRC_MOptCode_Org      : PRC_MOptCode_Org      = Cint(GetEmptyChange(getReplaceWord(uploadForm("hidMobileOptCode_Org")),0))
'Dim PRC_GoodsAreaViewFlag : PRC_GoodsAreaViewFlag = GetEmptyChange(getReplaceWord(uploadForm("hidGoodsAreaViewFlag")),"Y")
Dim PRC_StartDateModifyF : PRC_StartDateModifyF = GetEmptyChange(getReplaceWord(uploadForm("hidStartDateModifyF")),"0")

Dim PRC_i
Dim PRC_DisplayOpt
Dim PRC_DisplayOptTmp     : PRC_DisplayOptTmp     = GetEmptyChange(getReplaceWord(uploadForm("chkDisplayOpt")),0)
Dim PRC_DisplayIconType   : PRC_DisplayIconType   = GetEmptyChange(getReplaceWord(uploadForm("rdoDisplayOptIcon")),0)
Dim PRC_MobileOpt         : PRC_MobileOpt         = GetEmptyChange(getReplaceWord(uploadForm("rdoMobileOpt")),0)

Dim PRC_FreeReg           : PRC_FreeReg           = 0 'GetEmptyChange(getReplaceWord(uploadForm("rdoFreeReg")),0)

''2020-09-23
'IF Len(getReplaceWord(uploadForm("rdoOpt"))) > 0  Then
'	IF getReplaceWord(uploadForm("rdoOpt")) = 0 Then
'		PRC_FreeReg = 1
'	END IF
'END IF

Dim PRC_InetArea          : PRC_InetArea          = "3" ' 등록폼 개선 후 3으로 픽스 "0"
Dim PRC_InetArea1         : PRC_InetArea1         = GetEmptyChange(getReplaceWord(uploadForm("chkInetArea1")),0)
Dim PRC_InetArea2         : PRC_InetArea2         = GetEmptyChange(getReplaceWord(uploadForm("chkInetArea2")),0)
Dim PRC_RegKind           : PRC_RegKind           = GetEmptyChange(getReplaceWord(uploadForm("rdoRegKind")),0)
Dim PRC_ChargeKind        : PRC_ChargeKind        = getReplaceWord(uploadForm("rdoChargeKind"))
Dim PRC_ChargeRecNm       : PRC_ChargeRecNm       = getReplaceWord(uploadForm("txtRecNm"))
Dim PRC_IPrice            : PRC_IPrice            = GetEmptyChange(getReplaceWord(uploadForm("txtIPrice")),0)
Dim PRC_PPrice            : PRC_PPrice            = GetEmptyChange(getReplaceWord(uploadForm("txtPPrice")),0)
Dim PRC_MagCmt            : PRC_MagCmt            = getReplaceWord(uploadForm("txtMagCmt"))

'키워드검색상품 변수
Dim PRC_KeywordList       : PRC_KeywordList       = GetEmptyChange(getReplaceWord(uploadForm("hidKeyword_List")),"")
Dim PRC_KeywordTerm       : PRC_KeywordTerm       = GetEmptyChange(getReplaceWord(uploadForm("hidKeyword_Term")),0)
Dim PRC_Keyword_Discount_Price    : PRC_Keyword_Discount_Price    = GetEmptyChange(getReplaceWord(uploadForm("KeywordSearch_DcPrice")),0)
Dim PRC_Keyword_OPT_CODE

If Trim(PRC_InetArea1) = "1" Then
  PRC_InetArea = "3"
ElseIf PRC_InetArea1 = "0" And PRC_InetArea2 > "0" Then
  PRC_InetArea = PRC_InetArea2
End If

If PRC_AlbaOpt > 0 And PRC_InternetOpt = 0 Then
  PRC_InternetOpt = PRC_AlbaOpt
End If

PRC_ReserveYN_Org = PRC_ReserveYN

'Response.Write "PRC_OptStartDt : " & PRC_OptStartDt & "<Br>"
'Response.Write "PRC_ReserveHour : " & PRC_ReserveHour & "<Br>"
'Response.Write "PRC_ReserveMin : " & PRC_ReserveMin & "<Br>"
'Response.Write "PRC_ProcessType : " & PRC_ProcessType & "<Br>"
'Response.Write "PRC_OrgStartDt : " & PRC_OrgStartDt & "<Br>"
'Response.Write "PRC_ReserveYN : " & PRC_ReserveYN & "<Br><Br>"

Dim strIsBoolReserve
strIsBoolReserve = isBoolReserve(PRC_OptStartDt, PRC_ReserveHour, PRC_ReserveMin, PRC_ProcessType, PRC_OrgStartDt,  PRC_ReserveYN)

'If MagID = "stari" Then
'Response.Write "strIsBoolReserve : " & strIsBoolReserve & "<br>"
'Response.Write "PRC_ReserveYN : " & PRC_ReserveYN & "<Br>"
'Response.Write "PRC_OptStartDt : " & PRC_OptStartDt & "<Br>"
'Response.Write "PRC_ReserveStartDT : " & PRC_ReserveStartDT & "<Br>"
'Response.Write "PRC_ReserveEndDT : " & PRC_ReserveEndDT & "<Br><Br>"
'End If

'If strIsBoolReserve = "1" Or strIsBoolReserve = "5" Then
'  PRC_ReserveYN = "Y"
'  PRC_ReserveStartDT = PRC_OptStartDt & " " & Right("0" & PRC_ReserveHour, 2) & ":" & Right("0" & PRC_ReserveMin, 2)
'  PRC_ReserveEndDT = PRC_OptEndDt
'ElseIf strIsBoolReserve = "4" Then
'  PRC_ReserveStartDT = PRC_OrgStartDt
'  Response.Write "PRC_ReserveStartDT11 : " & PRC_ReserveStartDT & "<Br>"
'  PRC_ReserveStartDT = PRC_OptStartDt & " " & Right("0" & PRC_ReserveHour, 2) & ":" & Right("0" & PRC_ReserveMin, 2)
'  Response.Write "PRC_ReserveStartDT22 : " & PRC_ReserveStartDT & "<Br>"
'  PRC_ReserveEndDT = PRC_OptEndDt
'End If

'If PRC_ProcessType = "Regist" And strIsBoolReserve = "1" Or strIsBoolReserve = "5" Then
If strIsBoolReserve = "1" Or strIsBoolReserve = "5" Then
  PRC_ReserveYN = "Y"
  PRC_ReserveStartDT = PRC_OptStartDt & " " & Right("0" & PRC_ReserveHour, 2) & ":" & Right("0" & PRC_ReserveMin, 2)
  PRC_ReserveEndDT = PRC_OptEndDt
ElseIf PRC_ReserveYN = "Y" Then
  PRC_ReserveStartDT = PRC_OptStartDt & " " & Right("0" & PRC_ReserveHour, 2) & ":" & Right("0" & PRC_ReserveMin, 2)
  PRC_ReserveEndDT = PRC_OptEndDt
End If

'If MagID = "stari" Then
'Response.Write "PRC_ReserveYN : " & PRC_ReserveYN & "<Br>"
'Response.Write "PRC_ReserveStartDT : " & PRC_ReserveStartDT & "<Br>"
'Response.Write "PRC_ReserveEndDT : " & PRC_ReserveEndDT & "<Br><Br>"
'Response.End
'End If

'************************************************************************************************************
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
' 게재지역이 지역 일 경우
' 스피드핫, 스피드포인트, 스피드리스트 값을 옵션코드에 맞게 변경
' 이유 : 이 세개의 옵션 object가 전국에도 동일하게 object가 존재하여 게재지역이 지역일 경우에 object 값이 틀림
'************************************************************************************************************
If PRC_InetArea = "2" Then
  If PRC_InternetOpt = 107 Then
    PRC_InternetOpt = 7
  End If

  If PRC_InternetOpt = 104 Then
   PRC_InternetOpt = 4
  End If

  If PRC_InternetOpt = 134 Then
    PRC_InternetOpt = 34
  End If
End If

'If PRC_ProcessType = "Modify" And (PRC_OptCode_Org > 0 Or PRC_MOptCode_Org > 0) And PRC_ReserveYN_Org = "Y" Then
'  If PRC_InternetOpt = 0 And PRC_MobileOpt = 0 And PRC_FreeReg = 1 Then
'    If PRC_FormType = "Agency" Then
'      MsgTargetLocation "유료 예약공고는 무료공고로 변경할 수 없습니다.", "/onlinemanage/Agency_ModForm.asp?LineAdid=" & PRC_ReqLineAdid & "&InputBranch=" & PRC_ReqInputBranch & "&LayoutBranch=" & PRC_LayoutBranch
'    ElseIf PRC_FormType = "Ecomm" Then
'      MsgTargetLocation "유료 예약공고는 무료공고로 변경할 수 없습니다.", "/emanage/ModForm.asp?LineAdid=" & PRC_ReqLineAdid & "&InputBranch=" & PRC_ReqInputBranch & "&LayoutBranch=" & PRC_LayoutBranch
'    End If
'  End If
'End If

' 유료게재기간이 지난 공고 또는 판매종료 상품인 경우, 원래 코드로 변경
'If PRC_ProcessType = "Modify" And PRC_GoodsAreaViewFlag = "N" Then
' 예전 마이그레이션 정책 때문에 원래 코드를 넣어 줬는데 주석 처리 20200925.
'If PRC_GoodsAreaViewFlag = "N" Then
''  PRC_InternetOpt = PRC_OptCode_Org
''  PRC_MobileOpt = PRC_MOptCode_Org
'End If

' 수정일 경우, 상품 변경이 없으므로 원래 값 그대로 적용
If PRC_ProcessType = "Modify" Then
  PRC_InternetOpt = PRC_OptCode_Org
  PRC_MobileOpt = PRC_MOptCode_Org
End If

'키워드 검색 광고에 전달하는 OPTCODE
If PRC_InternetOpt > 0 Or PRC_MobileOpt > 0 Then
	If PRC_InternetOpt > 0 Then
		PRC_Keyword_OPT_CODE = PRC_InternetOpt
	Else 
		PRC_Keyword_OPT_CODE = PRC_MobileOpt
	End If
Else 
	PRC_Keyword_OPT_CODE = 87 '키워드만 구매하는 경우
End If



'Response.Write "PRC_InternetOpt : " & PRC_InternetOpt & "<br>"
'Response.Write "PRC_MobileOpt : " & PRC_MobileOpt & "<br>"
'Response.End

'************************************ 8. 간편 등록 공고 ************************************
Dim PRC_SimpleAdRegId       : PRC_SimpleAdRegId         = getReplaceWord(uploadForm("hidSimpleAdRegId"))  '기존 간편등록광고(기존 임시 유지)
Dim PRC_NEW_SAR_REGIDX      : PRC_NEW_SAR_REGIDX        = getReplaceWord(uploadForm("hid_SAR_REGIDX"))    '신규 간편등록광고 접수(Simple Ad Reception)(2016.02.16)
Dim Temp_PRC_RecuitEndDate

'************************************ 9. 브랜드관 공고정보 *********************************
Dim PRC_BRAND_BRANCH_CODE : PRC_BRAND_BRANCH_CODE = GetEmptyChange(getReplaceWord(uploadForm("hidBranchCode")),"")
If PRC_BRAND_BRANCH_CODE <> "" Then PRC_InternetOpt = 18 End If
'Response.Write "PRC_BRAND_BRANCH_CODE Print : " &PRC_BRAND_BRANCH_CODE& "<br />"

'************************************ 10. 쿠폰정보 *********************************
Dim PRC_CouponUsed      : PRC_CouponUsed        = GetEmptyChange(getReplaceWord(uploadForm("sltCoupon")),0)
'쿠폰 선택 확인여부 2020-09-23
IF PRC_CouponUsed <> "" THEN
 PRC_CouponUsed = 1
END IF
Dim PRC_Coupon          : PRC_Coupon            = GetEmptyChange(getReplaceWord(uploadForm("hidCoupon")),0)

'************************************ 11. 등록유형에 따른 추가입력 정보 *********************************
Dim PRC_MWPLUS_AD_NO      : PRC_MWPLUS_AD_NO      = GetEmptyChange(getReplaceWord(uploadForm("txtMWPLUS_AD_NO")),"")
Dim PRC_Service_Approval  : PRC_Service_Approval  = GetEmptyChange(getReplaceWord(uploadForm("txtService_Approval")),"")
Dim PRC_Service_Reason    : PRC_Service_Reason    = GetEmptyChange(getReplaceWord(uploadForm("txtService_Reason")),"")

Dim PRC_CustomerCD        : PRC_CustomerCD        = getReplaceWord(uploadForm("txtCustomerCD"))
Dim PRC_MinusPoint        : PRC_MinusPoint        = GetEmptyChange(getReplaceWord(uploadForm("txtMinusPoint")),0)
Dim PRC_Discount_Price    : PRC_Discount_Price    = GetEmptyChange(getReplaceWord(uploadForm("txtDiscountPrice")),0)
Dim PRC_Discount_Reason   : PRC_Discount_Reason   = GetEmptyChange(getReplaceWord(uploadForm("txtDiscountReason")),Null)
Dim PRC_CustCode          : PRC_CustCode          = GetEmptyChange(getReplaceWord(uploadForm("hidCustCode")),Null)  '고객코드 필수에 따른 hidden 값

'************************************ 12. 보류 공고 재등록 *********************************
Dim PRC_HOLDOPT      : PRC_HOLDOPT      = GetEmptyChange(getReplaceWord(uploadForm("holdopt")),"")
Dim PRC_HOLDLINEADNO : PRC_HOLDLINEADNO = GetEmptyChange(getReplaceWord(uploadForm("HOLDLINEADNO")),"")

'************************************ 13. 결합(스팟)상품 *********************************
Dim PRC_SOptCode      : PRC_SOptCode      = GetEmptyChange(getReplaceWord(uploadForm("hidSpOptCode")),0)
Dim PRC_SpotAdF       : PRC_SpotAdF       = GetEmptyChange(getReplaceWord(uploadForm("hidSpotAdF")),"0")


'************************************ 14. 지역특가: 지역그룹 *********************************
Dim PRC_AreaGroup     : PRC_AreaGroup     = GetEmptyChange(getReplaceWord(uploadForm("rdoAreaGroup")),Null)

'Response.Write "PRC_AreaGroup: "& PRC_AreaGroup & "<br>"
'response.write "PRC_MWPLUS_AD_NO : " & PRC_MWPLUS_AD_NO & "<br>"
'response.write "PRC_Service_Approval : " & uploadForm("txtService_Approval") & "<br>"
'response.write "PRC_Service_Reason : " & PRC_Service_Reason & "<br>"
'response.write "PRC_CustomerCD : " & PRC_CustomerCD & "<br>"
'response.write "PRC_MinusPoint : " & PRC_MinusPoint & "<br>"
'response.write "PRC_IPrice : " & PRC_IPrice & "<br>"
'response.end

'************************ 정액권 적용 (2017.08.31) ************************
Dim PRC_FATF              : PRC_FATF              = GetEmptyChange(getReplaceWord(uploadForm("rdoFATF")),0)
Dim PRC_FATVAL            : PRC_FATVAL            = GetEmptyChange(getReplaceWord(uploadForm("sltFAT")),"")
Dim PRC_FATDateTerm       : PRC_FATDateTerm       = GetEmptyChange(getReplaceWord(uploadForm("sltOptDateTerm")),0)
Dim PRC_FAT_ID
Dim PRC_FAT_RegistID
Dim PRC_FAT_OptCode

' 정액권 사용시 관련값 보정
If PRC_FATF = "1" And PRC_FATVAL <> "" Then
  PRC_FAT_RegistID    = split(PRC_FATVAL,"|")(0)
  PRC_FAT_OptCode     = split(PRC_FATVAL,"|")(2)
  PRC_FAT_ID          = split(PRC_FATVAL,"|")(3)

  PRC_ReqInputBranch  = 181
  PRC_InetArea        = "3"
  PRC_InternetOpt     = PRC_FAT_OptCode
  PRC_IPrice          = 0
  PRC_PPrice          = 0   
    
  If PRC_Keyword_OPT_CODE <> "87" Then 
    PRC_ChargeKind      = 0 
  End If
End If

'무료등록인 경우
If PRC_ProcessType = "Regist" And (PRC_InternetOpt = 0 And PRC_MobileOpt = 0) Then
  PRC_FreeReg     = 1
  PRC_ChargeKind  = 0
End If
%>
<%
'************************************  값 정리 ************************************
'0. PRC_Phone = "PRC_Phone1, PRC_Phone2"
'1. PRC_PayKind = 0 이면   PRC_PayFrom, PRC_PayTo 값을 빈값으로
'2. PRC_PayKind > 0 이면 값에 따라  PRC_PayFrom, PRC_PayTo 값을 액면금액으로 변환
'3. PRC_AgeF에 따라 어떤값으로 저장할지 분기 (
'   0: PRC_AgeFrom, PRC_AgeTo, PRC_AgeOldValue값을 0으로
'   1: PRC_AgeFrom, PRC_AgeTo 저장/PRC_AgeOldValue = 0
'   2: PRC_AgeFrom, PRC_AgeTo 를 0으로 / PRC_AgeOldValue 저장
'4. PRC_EduLevelValue '학력
'   0: 무관, 1: 고졸이상, 2: 초대졸이상, 3: 대졸이상
'5. PRC_RegularempF = 1
'   PRC_StartDate = 오늘날짜
'   PRC_EndDate = 유료: 옵션종료일자, 무료: 현재날짜 + 4일
'6. PRC_HtmlFlag
'   0 : PRC_txtExContents = PRC_txtExContents_TextArea
'   1 : PRC_txtExContents = PRC_txtExContents
'7. PRC_TmpFileUploadYN = "Y" 파일 업로드 처리
'   PRC_TmpFileCode로 통해 임시 저장된 파일 추출하여 복사 및 Rename
'8. PRC_OptBg = 1: PRC_OptBgValue = PRC_OptBgType, 0: PRC_OptBg = 0
'9. PRC_OptIcon = 1: PRC_OptIconValue = PRC_OptIconType, 0: PRC_OptIconValue = 0
'10. PRC_ChargeKind = 2 Or 3 : PRC_ChargeRecNm = ""
%>
<%'************************************  공고등록 진행 제약조건 ************************************
' 폼타입(PRC_FormType)값이 누락되었다면 진행하지 말자!
If FnLen(PRC_FormType) = 0 Then
  Response.Write "************************ 폼타입(hidFormType)값이 정의되지 않았습니다. (PaperMod(줄광고 수정), Agency(등록대행), BoxAd(박스광고), Ecomm(이컴공고)) ************************"
  Response.End
End If

Dim intFreeTerm : intFreeTerm = 9 '무료공고 기간(오늘포함 10일)
Dim intFreeDirectTerm : intFreeDirectTerm = 20 '즉시등록 공고 기간(오늘 미포함 20일)
' 폼형태에 따른 공고 형태 (게재이관 프로세스용)
If PRC_FormType = "PaperMod" Then
  PRC_Variety = "X"
ElseIf PRC_FormType = "Agency" Then
  PRC_Variety = "D"
ElseIf PRC_FormType = "BoxAd" Then
  PRC_Variety = "X"
  RPC_ADKind = "B"              ' 박스 광고인 경우 RPC_ADKind = "B"로
ElseIf PRC_FormType = "Ecomm" Then
  PRC_RegKind = "4" '이컴 공고면 등록유형이 Ecomm 기본으로
  PRC_Variety = "E"
  intFreeTerm = 9 '무료공고 기간(이컴일경우 오늘포함 9일)
  '정액권 사용 공고가 아닌 경우에만 180 으로
  If PRC_ReqInputBranch <> 181 And PRC_ReqInputBranch <> 81 Then
  	PRC_ReqInputBranch = 180      ' E-Comm 공고인 경우 InputBranch = 180 으로
  End If
End if

' 공고 형태(PRC_Variety)값이 누락되었다면 진행하지 말자!
If FnLen(PRC_Variety) = 0 Then
  Response.Write "************************ PRC_Variety 값이 정의되지 않았습니다. ************************"
  Response.End
End If
%>
<%'************************************  값 정리 ************************************
' 매핑된 아이디가 없을 경우 CUID 초기화 (2016.12.24 최봉기)
If FnLen(PRC_UserId) = 0 Then
 PRC_CUID = Null
End If

' 연락처
If FnLen(Replace(PRC_Phone1,"-","")) = 0 Then PRC_Phone1 = "" End If
If FnLen(Replace(PRC_Phone2,"-","")) = 0 Then PRC_Phone2 = "" End If
If FnLen(Replace(PRC_MWPhone2,"-","")) = 0 Then PRC_MWPhone2 = "" End If

If PRC_FormType = "PaperMod" Or PRC_FormType = "BoxAd" Then   ' 전화번호 : 줄/박스(영업데이터) 수정인 경우

  PRC_Phone = PRC_MWPhone1        ' 우선 연락처1을 넣는다.    (2013.09.13 배현민 대리 요청에 의해 연락처1의 값만 받는다.)

  PRC_HPhone = PRC_Phone2 'PRC_MWPhone2

	PRC_Phone1 = ""       '영업데이터는 연락처1,2를 사용하지 않으므로 빈값으로 (2013.09.13 배현민 대리 요청)
	PRC_Phone2 = ""       '영업데이터는 연락처1,2를 사용하지 않으므로 빈값으로 (2013.09.13 배현민 대리 요청)

Else      ' 나머지 등록폼인 경우

  PRC_Phone = getPhoneReg(PRC_Phone1, PRC_Phone2, PRC_PhoneViewF1, PRC_PhoneViewF2, "PHONE")
  PRC_HPhone = getPhoneReg(PRC_Phone1, PRC_Phone2, PRC_PhoneViewF1, PRC_PhoneViewF2, "MOBILE")

End If

' 게재띠
If FnLen(PRC_LineCate_C) = 0 Then
  If FnLen(PRC_LineCate_B) = 0 Then
    PRC_LayoutCode = getFillCipher(PRC_LineCate_A,10,"0")
  Else
    PRC_LayoutCode = getFillCipher(PRC_LineCate_B,10,"0")
  End If
Else
  PRC_LayoutCode = getFillCipher(PRC_LineCate_C,10,"0")
End If

' 인근 지하철
IF PRC_SubwayF = 1 Then
  If FnLen(PRC_SubWayCode_C_1) > 0 Then PRC_SubWayValue1 =  PRC_SubWayCode_C_1 &"|"& PRC_SubwayGate_1 &"|"& Replace(PRC_SubwayEtc_1,"|","") Else PRC_SubWayValue1 = "" End If
  If FnLen(PRC_SubWayCode_C_2) > 0 Then PRC_SubWayValue2 =  PRC_SubWayCode_C_2 &"|"& PRC_SubwayGate_2 &"|"& Replace(PRC_SubwayEtc_2,"|","") Else PRC_SubWayValue2 = "" End If
  If FnLen(PRC_SubWayCode_C_3) > 0 Then PRC_SubWayValue3 =  PRC_SubWayCode_C_3 &"|"& PRC_SubwayGate_3 &"|"& Replace(PRC_SubwayEtc_3,"|","") Else PRC_SubWayValue3 = "" End If
  If FnLen(PRC_SubWayCode_C_4) > 0 Then PRC_SubWayValue4 =  PRC_SubWayCode_C_4 &"|"& PRC_SubwayGate_4 &"|"& Replace(PRC_SubwayEtc_4,"|","") Else PRC_SubWayValue4 = "" End If
  If FnLen(PRC_SubWayCode_C_5) > 0 Then PRC_SubWayValue5 =  PRC_SubWayCode_C_5 &"|"& PRC_SubwayGate_5 &"|"& Replace(PRC_SubwayEtc_5,"|","") Else PRC_SubWayValue5 = "" End If
Else
  PRC_SubWayValue1 = ""
  PRC_SubWayValue2 = ""
  PRC_SubWayValue3 = ""
  PRC_SubWayValue4 = ""
  PRC_SubWayValue5 = ""
End IF

' 인근 대학
'IF PRC_UniversityF = "1" Then
'  If FnLen(PRC_UniversityCode_B_1) > 0 Then PRC_UniversityValue1 =  PRC_UniversityCode_B_1 &"|"& Replace(PRC_UniversityEtc_1,"|","") Else PRC_UniversityValue1 = "" End If
'  If FnLen(PRC_UniversityCode_B_2) > 0 Then PRC_UniversityValue2 =  PRC_UniversityCode_B_2 &"|"& Replace(PRC_UniversityEtc_2,"|","") Else PRC_UniversityValue2 = "" End If
'  If FnLen(PRC_UniversityCode_B_3) > 0 Then PRC_UniversityValue3 =  PRC_UniversityCode_B_3 &"|"& Replace(PRC_UniversityEtc_3,"|","") Else PRC_UniversityValue3 = "" End If
'  If FnLen(PRC_UniversityCode_B_4) > 0 Then PRC_UniversityValue4 =  PRC_UniversityCode_B_4 &"|"& Replace(PRC_UniversityEtc_4,"|","") Else PRC_UniversityValue4 = "" End If
'  If FnLen(PRC_UniversityCode_B_5) > 0 Then PRC_UniversityValue5 =  PRC_UniversityCode_B_5 &"|"& Replace(PRC_UniversityEtc_5,"|","") Else PRC_UniversityValue5 = "" End If
'Else
'  PRC_UniversityValue1 = ""
'  PRC_UniversityValue2 = ""
'  PRC_UniversityValue3 = ""
'  PRC_UniversityValue4 = ""
'  PRC_UniversityValue5 = ""
'End IF

PRC_PayFrom = Replace(PRC_PayFrom,",","")
PRC_PayTo = Replace(PRC_PayTo,",","")

' 급여조건이 "급여협의"라면
If PRC_PayKind = 0 Then
  PRC_PayFrom = 0
  PRC_PayTo = 0
ElseIf PRC_PayKind = 5 Then' 아무것도 선택안했다면
  PRC_PayFrom = 0
  PRC_PayTo = 0
Else
  If PRC_PayFrom = 0 And PRC_PayTo = 0 Then ' 연봉 월급 일급 시급인 경우 최소/최대금액이 0인 경우
    Call MsgBack("최소/최대 금액이 입력 누락되었습니다.")
  '기존 연봉일 경우에는 만원 단위로 넘어온값 변환 부분 삭제
  'Else
  '  PRC_PayFrom = GetPayCurrent(PRC_PayFrom, PRC_PayKind)
  '  PRC_PayTo   = GetPayCurrent(PRC_PayTo, PRC_PayKind)
  End If
End If


' 연령
IF PRC_AgeF = 0 Then  ' 연령무관
  PRC_AgeFrom = 0
  PRC_AgeTo = 0
  PRC_AgeOldValue = 0
ElseIf PRC_AgeF = 1 Then  ' 연령 범위 (SelectBox)
  PRC_AgeOldValue = 0
ElseIf PRC_AgeF = 2 Then  ' 연령대 (CheckBox)
  PRC_AgeFrom = 0
  PRC_AgeTo = 0
End IF

' 경력
If PRC_CareerF_Chk = "999" Then ' 무관이라면
  'PRC_CareerFValue = 2
  PRC_CareerFrom   = 999
  PRC_CareerTo     = 999
End If

' 상시채용
If PRC_RegularempF = 1 or PRC_RegularempF = 2 Then   ' 상시채용인 경우
  PRC_RecuitEndDate = ""
End IF

' 게재시작일
'****************************************************************************************
' 테스트 데이터 입력
'****************************************************************************************
'PRC_StartDate = "2016-04-08"
'PRC_OptStartDt = "2016-04-09"
'PRC_OptEndDt = "2016-04-30"
'PRC_RegularempF = "0"
'PRC_RecuitEndDate = "2016-05-25"
''PRC_RecuitEndDate = ""
'
'PRC_ReserveYN = "Y"
'PRC_ReserveHour = "07"
'PRC_ReserveMin = "30"
'
'If PRC_ReserveYN = "Y" Then
'  PRC_ReserveStartDT = PRC_OptStartDt & " " & Right("0" & PRC_ReserveHour, 2) & ":" & Right("0" & PRC_ReserveMin, 2)
'  PRC_ReserveEndDT = PRC_OptEndDt
'Else
'  PRC_ReserveStartDT = ""
'  PRC_ReserveEndDT = ""
'End If

'If MagID = "stari" Then
'  Response.Write "공고번호 : " & PRC_ReqLineAdid & "<br>"
'  Response.Write "원 게재시작일 : " & PRC_OrgStartDt & "<br>"
'  Response.Write "선택한 게재시작일 : " & PRC_StartDate & "<br>"
'  Response.Write "선택한 옵션시작일 : " & PRC_OptStartDt & "<br>"
'  Response.Write "선택한 옵션종료일 : " & PRC_OptEndDt & "<br>"
'  Response.Write "선택한 상시채용 여부 : " & PRC_RegularempF & "<br>"
'  Response.Write "선택한 모집마감일 : " & PRC_RecuitEndDate & "<br>"
'  Response.Write "예약 여부 : " & PRC_ReserveYN & "<br>"
'  Response.Write "예약 시작일 : " & PRC_ReserveStartDT & "<br>"
'  Response.Write "예약 종료일 : " & PRC_ReserveEndDT & "<br><br>"
'  Response.End
'End If
'****************************************************************************************

PRC_StartDate = GetEmptyChange(PRC_StartDate, GetEmptyChange(PRC_OrgStartDt, Date()))

Dim OptDateTerm

' 게재 시작일자 / 게재종료일자
If PRC_FormType = "Agency" Or PRC_FormType = "Ecomm" Then ' 등록대행 또는 이컴등록인 경우 게재일자 결정 프로세스 실행
  If PRC_FreeReg <> "1" And Not isBoolFreeDirectGoods("1",PRC_InternetOpt) Then
    '무료/즉시등록이 아닌경우에만 시작일 기본값 설정
    PRC_StartDate = GetEmptyChange(PRC_OptStartDt, Date())
  End If

  If (PRC_InternetOpt > 0 And PRC_FreeReg = 0) And Trim(PRC_ProcessType) = "Regist" Then ' 무료공고가 아닌 경우
    PRC_Opt_Term = DateDiff("D", Cdate(PRC_OptStartDt), Cdate(PRC_OptEndDt))
  End If

  '정액권 사용 공고의 경우 (기존 유료옵션 정책 적용)
  If  PRC_ReqInputBranch = 181 Then

    '옵션코드 = 16384 정액권 공고전용
		'PRC_InternetOpt = 16384

		'정액권일 경우 인터넷옵션 코드를 정액권 코드로 대입
		PRC_InternetOpt = PRC_FatOpt

    If Trim(PRC_ProcessType) = "Regist" Or (Trim(PRC_ProcessType) = "Modify" And PRC_ReserveYN = "Y") Then
      OptDateTerm = DateDiff("D", Cdate(PRC_StartDate), Cdate(PRC_OptEndDt))
      PRC_EndDate = GetEmptyChange(PRC_EndDate,PRC_OptEndDt) '게재기간(종료일)이 없을경우, 유료기간(종료일)과 동일하게 설정

      's 페이지에서 막는 조건이나, 페이지 오류로 패스되어 넘어올 경우에 차단할 수 있도록 추가
      If CDate(PRC_OptEndDt) > CDate(PRC_EndDate) Then
        MsgBack "게재기간이 유료공고마감일보다 짧습니다.\n게재기간을 조정해 주세요."
        Response.End
      End If

      If OptDateTerm < 30 Then
        If CDate(PRC_StartDate) + CInt(31) < CDate(PRC_EndDate) Then '기본 30일 +1일
          MsgBack "게재기간이 설정 가능한 종료일 보다 깁니다.\n게재기간을 조정해 주세요."
          Response.End
        End If
      Else
        If CDate(PRC_OptEndDt) < CDate(PRC_EndDate) Then
          MsgBack "게재기간이 설정 가능한 종료일 보다 깁니다.\n게재기간을 조정해 주세요."
          Response.End
        End If
      End If
      'e 페이지에서 막는 조건이나, 페이지 오류로 패스되어 넘어올 경우에 차단할 수 있도록 추가
		End If
  Else
	  If PRC_FreeReg = 1 Then ' 무료등록인 경우
	    PRC_StartDate = PRC_StartDate             ' 게재시작일을 모집기간 시작일
	    If CDate(PRC_EndDate) > CDate(Cdate(PRC_StartDate) + CInt(intFreeTerm)) Then  ' 게재 마감일이 무료게재기간보다 크다면
	      PRC_EndDate = CDate(PRC_StartDate) + CInt(intFreeTerm)  ' 무료게재기간(오늘 포함)
	    Else
	      PRC_EndDate = PRC_EndDate         ' 기재된 게재마감일
	    End If
	  ElseIf isBoolFreeDirectGoods("1",PRC_InternetOpt) Then
      ' 즉시등록 게재기간(오늘 미포함 20일), 등록시에만 시작일, 옵션시작일 재설정
      If Trim(PRC_ProcessType) = "Regist" Then
	      PRC_StartDate = PRC_StartDate             ' 게재시작일을 모집기간 시작일
	      If CDate(PRC_EndDate) > CDate(Cdate(PRC_StartDate) + CInt(intFreeDirectTerm)) Then  ' 게재 마감일이 즉시게재기간보다 크다면
	        PRC_EndDate = CDate(PRC_StartDate) + CInt(intFreeDirectTerm)  ' 즉시등록 게재기간(오늘 미포함)
	      Else
	        PRC_EndDate = PRC_EndDate         ' 기재된 게재마감일
	      End If

		    PRC_OptStartDt = PRC_StartDate '옵션 시작일 재설정
		    PRC_OptEndDt = CDate(PRC_StartDate) + CInt(intFreeDirectTerm) '옵션 종료일 재설정
      End If
	  ElseIf PRC_InternetOpt > 0 Or (PRC_InternetOpt = 0 And PRC_MobileOpt > 0) Then
      '유료옵션 등록 또는 예약공고 수정할때만 게재종료일 설정
      If Trim(PRC_ProcessType) = "Regist" Or (Trim(PRC_ProcessType) = "Modify" And PRC_ReserveYN = "Y") Then
        OptDateTerm = DateDiff("D", Cdate(PRC_StartDate), Cdate(PRC_OptEndDt))
        PRC_EndDate = GetEmptyChange(PRC_EndDate,PRC_OptEndDt) '게재기간(종료일)이 없을경우, 유료기간(종료일)과 동일하게 설정

        's 페이지에서 막는 조건이나, 페이지 오류로 패스되어 넘어올 경우에 차단할 수 있도록 추가
        If CDate(PRC_OptEndDt) > CDate(PRC_EndDate) Then
          MsgBack "게재기간이 유료공고마감일보다 짧습니다.\n게재기간을 조정해 주세요."
          Response.End
        End If

        If OptDateTerm < 30 Then
          If CDate(PRC_StartDate) + CInt(31) < CDate(PRC_EndDate) Then '기본 30일 +1일
            MsgBack "게재기간이 설정 가능한 종료일 보다 깁니다.\n게재기간을 조정해 주세요."
            Response.End
          End If
        Else
          If CDate(PRC_OptEndDt) < CDate(PRC_EndDate) Then
            MsgBack "게재기간이 설정 가능한 종료일 보다 깁니다.\n게재기간을 조정해 주세요."
            Response.End
          End If
        End If
        'e 페이지에서 막는 조건이나, 페이지 오류로 패스되어 넘어올 경우에 차단할 수 있도록 추가
		  End If
    End If
  End If

  ' 예약 공고 일 경우 일반게재시작일을 일반게재종료일로 적용
  If PRC_ReserveYN = "Y" Then
    PRC_ReserveEndDT = PRC_EndDate '예약기간(종료일)을 게재기간(종료일)로 설정

    If PRC_ProcessType = "Modify" Then
      If DateAdd("h", "-3", CDate(PRC_ReserveStartDT)) > Now() Then
        PRC_StartDate = PRC_EndDate
      Else
        PRC_StartDate = ""
      End If
    Else
      PRC_StartDate = PRC_EndDate
    End If
  End If

Else  ' 줄/박스(영업데이터인경우)는 폼단에서 게재시작일,종료일로 대체한다.

  PRC_StartDate = PRC_OrgStartDt
  PRC_EndDate   = PRC_OrgEndDt

End If

'****************************************************************************************
'Response.Write "(일반)게재시작일: "& PRC_StartDate &"</br>"
'Response.Write "(일반)게재종료일: "& PRC_EndDate &"</br>"
'Response.Write "옵션시작일: "& PRC_OptStartDt &"</br>"
'Response.Write "옵션종료일: "& PRC_OptEndDt &"</br>"
'Response.Write "예약 여부 : " & PRC_ReserveYN & "<br>"
'Response.Write "예약 시작일 : " & PRC_ReserveStartDT & "<br>"
'Response.Write "예약 종료일 : " & PRC_ReserveEndDT & "<br><br>"
'Response.Write "PRC_InternetOpt: "& PRC_InternetOpt &"</br>"
'Response.Write "모집마감일: "& PRC_RecuitEndDate &"</br>"
'Response.Write "PRC_MobileOpt: "& PRC_MobileOpt &"</br>"
'Response.End
'****************************************************************************************

' 상세내용
If PRC_HtmlFlag = 0 Then  ' TextArea 선택시
  PRC_txtExContents = PRC_txtExContents_TextArea
End If

' 상세내용
If PRC_HtmlFlag = 2 Then  'NEW 템플릿 선택시
  PRC_txtExContents = PRC_NewExContents
End If

If FnLen(PRC_txtExContents) = 0 Then
  PRC_txtExContents = " "
End If

' MwPlus일 경우, 신문옵션은 없음
If PRC_MwPlus = "1" Then
  PRC_OptIconValue = 0
  PRC_OptPaper = 0
Else
  ' 테두리 옵션
  If PRC_OptBg = 1 Then
    PRC_OptBgValue = PRC_OptBgType
  Else
    PRC_OptBgValue = 0
  End If

  ' 신문옵션
  PRC_OptPaper = CInt(PRC_OptPrefClose) + CInt(PRC_OptPremium) + CInt(PRC_OptLineBox) + CInt(PRC_OptSpeed) + CInt(PRC_OptAccent) + CInt(PRC_OptColor) + CInt(PRC_OptBgValue)

  If PRC_OptPaper = "" Then
    PRC_OptPaper = 0
  End If

  ' 아이콘 옵션
  If PRC_OptIcon = 1 Then
    PRC_OptIconValue = PRC_OptIconType
  Else
    PRC_OptIconValue = 0
  End If
End If

'인터넷 강조옵션 시작
PRC_DisplayOpt = 0
If PRC_DisplayOptTmp = "0" Then
  PRC_DisplayOpt = PRC_DisplayOptTmp
Else
  For PRC_i = 0 To UBound(Split(PRC_DisplayOptTmp, ","))
    PRC_DisplayOpt = PRC_DisplayOpt + Split(PRC_DisplayOptTmp, ",")(PRC_i)
  Next
End If

'인터넷 강조옵션 중 아이콘이 있을 경우 신문옵션의 아이콘 값에 입력
If PRC_DisplayOpt And 8 Then
  PRC_OptIconValue = PRC_DisplayIconType
End If
'인터넷 강조옵션 끝


' 입금형태가 신용카드, 휴대폰인 경우 입금자명 삭제
If PRC_ChargeKind = "2" Or PRC_ChargeKind = "3" Then
  PRC_ChargeRecNm = ""
End If

' 관리자 상세번지 빈값으로 수정 시 지도좌표값 초기화 (2013.10.02 기획팀 요청 정책 재반영)
'If PRC_AreaDetail_1 = "" Then
'   PRC_Point_X = 0
'   PRC_Point_Y = 0
'   PRC_GPoint_X = 0
'   PRC_GPoint_Y = 0
'   PRC_RV_PANOID = ""
'   PRC_RV_ANGLEID = ""
'End If

If PRC_AreaA_1 > 0 And PRC_AreaB_1 > 0 And PRC_AreaC_1 > 0 Then
  PRC_AreaValue1 =  PRC_AreaC_1
ElseIf PRC_AreaA_1 > 0 And PRC_AreaB_1 > 0 And PRC_AreaC_1 = 0 Then
  PRC_AreaValue1 =  PRC_AreaB_1 & "0000"
ElseIf PRC_AreaA_1 > 0 And PRC_AreaB_1 = 0 And PRC_AreaC_1 = 0 Then
  PRC_AreaValue1 =  PRC_AreaA_1 & "000000"
End If

If PRC_AreaA_2 <> "" And PRC_AreaB_2 > 0 And PRC_AreaC_2 > 0 Then
  PRC_AreaValue2 =  PRC_AreaC_2
ElseIf PRC_AreaA_2 <> "" And PRC_AreaB_2 > 0 And PRC_AreaC_2 = 0 Then
  PRC_AreaValue2 =  PRC_AreaB_2 & "0000"
ElseIf PRC_AreaA_2 <> "" And PRC_AreaB_2 = 0 And PRC_AreaC_2 = 0 Then
  PRC_AreaValue2 =  PRC_AreaA_2 & "000000"
End If

If PRC_AreaA_3 <> "" And PRC_AreaB_3 > 0 And PRC_AreaC_3 > 0 Then
  PRC_AreaValue3 =  PRC_AreaC_3
ElseIf PRC_AreaA_3 <> "" And PRC_AreaB_3 > 0 And PRC_AreaC_3 = 0 Then
  PRC_AreaValue3 =  PRC_AreaB_3 & "0000"
ElseIf PRC_AreaA_3 <> "" And PRC_AreaB_3 = 0 And PRC_AreaC_3 = 0 Then
  PRC_AreaValue3 =  PRC_AreaA_3 & "000000"
End If

'Response.Write "PRC_AreaA_1 : " & PRC_AreaA_1 & "<br>"
'Response.Write "PRC_AreaB_1 : " & PRC_AreaB_1 & "<br>"
'Response.Write "PRC_AreaC_1 : " & PRC_AreaC_1 & "<br>"
'Response.Write "PRC_AreaA_2 : " & PRC_AreaA_2 & "<br>"
'Response.Write "PRC_AreaB_2 : " & PRC_AreaB_2 & "<br>"
'Response.Write "PRC_AreaC_2 : " & PRC_AreaC_2 & "<br>"
'Response.Write "PRC_AreaA_3 : " & PRC_AreaA_3 & "<br>"
'Response.Write "PRC_AreaB_3 : " & PRC_AreaB_3 & "<br>"
'Response.Write "PRC_AreaC_3 : " & PRC_AreaC_3 & "<br>"
'Response.Write "PRC_AreaValue1 : " & PRC_AreaValue1 & "<br>"
'Response.Write "PRC_AreaValue2 : " & PRC_AreaValue2 & "<br>"
'Response.Write "PRC_AreaValue3 : " & PRC_AreaValue3 & "<br>"
%>
<%
'Response.Write "LINEADNO : " & PRC_ReqLineAdid &" / "& PRC_ReqInputBranch &" / "& PRC_LayoutBranch &" / "& PRC_MwPlus
'Response.End
%>
<%
' 등록처리시 무료등록 & 아이디 매칭공고인 경우 건수 체크

If PRC_ProcessType = "Regist" And PRC_FreeReg = 1 And FnLen(PRC_UserId) > 0 Then

  DBOpen("ConnPaper")

    With objCmd
      .ActiveConnection = ConnPaper
      .CommandText = "GET_F_JOB_FREEREG_COUNT_PROC"

  		If .Parameters.Count > 0 Then
  			For PRC_ParamCnt = 0 to .Parameters.Count-1
  				.Parameters.Delete(0)
  			Next
  		End If

      .CommandType = adCmdStoredProc
      .Parameters.Append .CreateParameter("@CUID"					  , adInteger, adParamInput,   4, PRC_CUID)
      .Execute()
    End with

    objRs.open objCmd, , adOpenForwardOnly, adLockReadOnly, adCmdStoredProc

    PRC_FreeRegCnt = objRs("CNT")
	  PRC_FreeRegCnt2 = objRs("CNT2")

    ' 무료공고건수가 1일 1건 이상인 경우
    If PRC_FreeRegCnt >= 1 Or PRC_FreeRegCnt2 >=3 Then
      MsgBack("["&PRC_UserId &"] 아이디로 무료공고등록 "& PRC_FreeRegCnt &"건을 모두 사용했습니다. 유료구인공고상품을 이용해 주세요.")
    End IF

    objRs.Close

  DBClose("ConnPaper")

End If

' 회사주소지 ZipId로 Convert
If FnLen(Trim(PRC_Ci_AreaA) & Trim(PRC_Ci_AreaB) & Trim(PRC_Ci_AreaC)) > 0 Then ' 주소지가 입력이 된 경우

  DBOpen("ConnPaperReg")

    With objCmd
      .ActiveConnection = ConnPaperReg
      .CommandText = "GET_M_AREA_TO_ZIPID_PROC"

  		If .Parameters.Count > 0 Then
  			For PRC_ParamCnt = 0 to .Parameters.Count-1
  				.Parameters.Delete(0)
  			Next
  		End If

      .CommandType = adCmdStoredProc
      .Parameters.Append .CreateParameter("@AREA_A"					, adVarChar, adParamInput,  30, PRC_Ci_AreaA)
      .Parameters.Append .CreateParameter("@AREA_B"					, adVarChar, adParamInput,  30, PRC_Ci_AreaB)
      .Parameters.Append .CreateParameter("@AREA_C"					, adVarChar, adParamInput,  30, PRC_Ci_AreaC)
      .Execute()
    End with

    objRs.open objCmd, , adOpenForwardOnly, adLockReadOnly, adCmdStoredProc

    If Not(objRs.Bof Or objRs.Eof) Then
      PRC_Ci_ZipId = objRs("ZIPID")
    End If

    objRs.Close

  DBClose("ConnPaperReg")

End If

'************************ 등록대행 우대정책 개선 (2017.03.22) ************************
Dim PRC_RegType         : PRC_RegType         = 1 'GetEmptyChange(uploadForm("rdoRegType"),0)      '결제유형 (온라인만 접수로 고정)
Dim PRC_ServiceF        : PRC_ServiceF        = GetEmptyChange(uploadForm("sltSeviceF"),0)      '서비스이유
Dim PRC_OrgAmount       : PRC_OrgAmount       = GetEmptyChange(uploadForm("txtProductAmt"),0)    '상품정상가
Dim PRC_CouponAmount    : PRC_CouponAmount    = GetEmptyChange(uploadForm("txtCouponAmount"),0)    '쿠폰금액
Dim PRC_PromotionAmount : PRC_PromotionAmount = GetEmptyChange(uploadForm("txtPromotionAmt"),0)    '프로모션 금액
Dim PRC_BranchDCAmount

'등록유형이 [프로모션,지역할인,기타] 가 아닌경우 서비스이유/내용 초기화
If Not(PRC_RegKind = "2" Or PRC_RegKind = "9" Or PRC_RegKind = "0") Then
  PRC_ServiceF = 0
  PRC_Service_Reason = ""
End If

'등록유형이 [무료-보류후 재등록]인 경우 상품정상가 0원
If PRC_RegKind = "5" Then
  PRC_OrgAmount = 0
End If

' 서비스이유가 "기타"가 아닌 경우 관련내용 삭제
'If PRC_ServiceF <> "99" Then
'  PRC_Service_Reason = ""
'End If

'response.write "(개발) 점검중 : "& PRC_Discount_Price
'response.end

' 공고 담당자명
Dim PRC_MagOrderName                : PRC_MagOrderName                  = uploadForm("txtMagOrderName")

'Custcode값 입력이 없을시 윌리언트에서 받아온 코드로 적용
PRC_CustomerCD = GetEmptyChange(PRC_CustomerCD,PRC_CustCode)

Dim PRC_Promo             : PRC_Promo = GetEmptyChange(getReplaceWord(uploadForm("chkPromo")),"")
%>
<%
'Response.Write "PRC_MinusPoint : "& PRC_MinusPoint &"</br>"
'Response.Write "PRC_OrgAmount : "& PRC_OrgAmount &"</br>"
'Response.Write "PRC_Discount_Price : "& PRC_Discount_Price &"</br>"
'Response.Write "PRC_CouponAmount : "& PRC_CouponAmount &"</br>"
'Response.Write "PRC_PromotionAmount : "& PRC_PromotionAmount &"</br>"
'Response.Write "PRC_IPrice : "& PRC_IPrice &"</br>"
'Response.Write "PRC_ChargeKind : "& PRC_ChargeKind &"</br>"
'Response.End

'Response.Write "PRC_ProcessType : "& PRC_ProcessType &"</br>"
'Response.Write "PRC_ReserveYN : "& PRC_ReserveYN &"</br>"
'Response.Write "PRC_StartDateModifyF : "& PRC_StartDateModifyF &"</br>"
'Response.End
%>