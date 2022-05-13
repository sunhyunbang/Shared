<%@Codepage=65001	%>
<%
Option Explicit
response.charset = "utf-8"
%>
<!-- #include virtual = "/common/include/fa_cookies.inc" //-->
<!-- #include virtual = "/common/common.inc" -->
<!-- #include virtual = "/common/common_lib.asp" -->
<!-- #include virtual = "/common/Certify_config.asp" //-->
<!-- include virtual = "/common/cert/clsComIPin.asp" //-->
<%
' 기업회원인 경우 기업회원서비스인증동의로 이동
If CkUserGBN = "2" Then
  Response.Redirect "biz_user_agree.asp?"& Request.ServerVariables("QUERY_STRING")
End If
%>
<%
Dim strRtnUrl     : strRtnUrl     = GET_REQUEST("retUrl","")
Dim strHost       : strHost       = GET_REQUEST("Host","")
Dim strCode       : strCode       = GET_REQUEST("Code","")
Dim strSectionCd  : strSectionCd  = GET_REQUEST("SectionCd","")

Dim strSectionNm  : strSectionNm = ""

If CkCUID = "" Then
  Call js_alert("로그인이 필요합니다.",strRtnUrl)
End If
%>
<%
'***********************************************
'검색
'***********************************************
Dim strmid
strmid = InStr(targetpage,"mid=")
'모바일에서 링크 접속 체크
If browser_chk = "mobile" Then
	strmid = "47"
End If

sReturnUrl = "https://"& lcase(Request.ServerVariables("http_host")) &"/serviceagree/user_agree_proc.asp"

Set clsCPClient  = Server.CreateObject("CPClient.NiceID")

'sRequestNO  = clsCPClient.bstrRandomRequestNO
'session("REQ_SEQ") = sRequestNO

sPlainData = fnGenPlainData(sRequestNO, sSiteCode, sAuthType, sReturnUrl, sErrorUrl, popgubun, customize)

  '실제적인 암호화
iRtn = clsCPClient.fnEncode(sSiteCode, sSitePassword, sPlainData)

sEncData = clsCPClient.bstrCipherData

Set clsCPClient = Nothing

If strSectionCd = "S102" Then
  strSectionNm = "벼룩시장"
ElseIf strSectionCd = "S103" Then
  strSectionNm = "벼룩시장부동산"
Else
  strSectionNm = "벼룩시장"
End If
%>
<%
Dim clsCmd, rs
Dim ReturnPath    : ReturnPath = ""

Set clsCmd = new clsCommand
Call clsCmd.MakeCMD(FN_application("dsn_member"), adCmdStoredProc, "GET_CMN_CODE_RETUN_PATH_PROC", 3, false)
Call clsCmd.MakeParam("@CODE_ID",			adVarchar	, adParaminput, 10	,	strCode)
'Response.write clscmd.debug()
'Response.end
Set rs = clsCmd.Rs()
If Not(rs.eof Or rs.bof) Then
	ReturnPath			= rs("RETURN_PATH")
End If
Set clsCmd = Nothing
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi">
<title>미디어윌 온라인 통합 회원</title>
<link rel="stylesheet" type="text/css" href="/common/css/member_common.css" />
<script type="text/javascript" src="/common/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="/common/js/member_common.js?v=22"></script>
<script type="text/javascript" src="/common/js/join.js?v=aa"></script>
<script type="text/javascript">

  $(document).ready(function() {
  
    $("#spanTitle").text("서비스 이용 동의");
    $("li[id*=bi_]").hide();
    <%
    If strSectionCd = "S102" Then
      Response.Write "$('#bi_02').show();"&vblf
    ElseIf strSectionCd = "S103" Then
      Response.Write "$('#bi_03').show();"&vblf
    Else
      Response.Write "$('#bi_01').show();"&vblf
    End If
    %>
  });
  
  function ConfirmSubmit(){
    if(!$("#ter_person").is(":checked")) {
      alert("개인정보 수집 항목에 동의해 주세요.(필수 수집항목)");
      return;
    }
    
    //서비스이용동의 수정(2022-02-04)
    if(!$("#ter_person2").is(":checked")) {
      alert("개인정보 수집 항목에 동의해 주세요.(선택 수집항목)");
      return;
    }
    else {
      $("input[name=param_r3]").val($("input[name=param_r3]").val() + "Y");
    }

    // 본인인증 모듈 실행
  	if ($("#browser_chk").val() == 'mobile')	{
  		// 휴대폰본인인증 (모바일)
  		fn_MobileCert_Popup1(frmCert);
  	} else {
  		// 휴대폰본인인증
  		fn_MobileCert_Popup(frmCert);
  	}
  }

</script>

</head>
<body>
<!-- new Header -->
  <!-- #include virtual ="/common/include/header.inc" -->
<!-- // new Header -->
<form name="form_chk" method="post">
	<!-- *************** S : 본인인증 제어 필수값 *************** -->
	<input type="hidden" name="m" value="checkplusSerivce" />
	<input type="hidden" name="EncodeData" value="<%= sEncData %>" />
	<input type="hidden" name="param_r1" value="frmCert" />
	<input type="hidden" name="param_r2" value="<%=strRtnUrl%>" />
	<input type="hidden" name="param_r3" value="<%=strCode&"|"&strSectionCd&"|"%>" />
	<!-- *************** S : 본인인증 제어 필수값 *************** -->
  <input type="hidden" name="RtnUrl" value="<%=strRtnUrl%>">
  <input type="hidden" id="browser_chk" value="<%=browser_chk%>"/>
</form>

<form name="frmCert" id="frmCert" method="post" action="javascript:return false;">
	<input type="hidden" name="targetpage" id="targetpage" value="<%=strRtnUrl%>">		<!--리턴페이지-->
	<input type="hidden" name="fahost" id="fahost" value="<%=strHost%>">				<!--리턴호스트-->
</form>

<div id="wrap" class="n_content">
	<div id="content" class="user_agree">
		<div id="cMain">
			<h2 id="Body" >
				<span class="user_agree_tit"><%=strSectionNm%> 서비스를 이용해주셔서 감사합니다.</span>
				<span class="use_agree_txt">회원님의 소중한 개인정보보호와 원활한 서비스 이용을 위해 서비스 이용 동의 절차를 진행해주세요.</span>
			</h2>
			<div id="mArticle">
         

				<div class="wrap_join_box">
					
          <h3 class="tit_join">개인정보 수집 이용 동의 (필수)</h3> 
					<ul class="list_check"> 
						<li>
							<span class="agree_tit">개인정보 수집 및 이용에 동의합니다. (필수 수집항목)</span>
							<label for="agree01" class="lab_check">
								동의
                <span class="ico"><input name="dirrhksCheck" id="ter_person" type="checkbox" /></span>
							</label>
							<!--<span id="person_alert" class="alert1"></span>-->
							<div class="mk_event_tbl">
								<div class="use per35">
									<p class="tbl_th">이용목적</p>
									<p class="tbl_td">구인구직 이력서 등록 및 수정</p>
								</div>
								<div class="per_unit per30">
									<p class="tbl_th">개인정보의 항목</p>
									<p class="tbl_td">본인인증값(CI, DI, 이름, 생년월일, 성별), 휴대폰번호, 이메일, 거주지, 희망 근무지, 희망 직종, 직종 키워드, 간단 자기소개, 성격 및 강점</p>
								</div>
								<div class="per_unit per35">
									<p class="tbl_th">보유 및 이용기간</p>
									<p class="tbl_td"><strong>회원 탈퇴 시 지체없이 파기</strong></p>
								</div>
							</div> 
							<p class="notice">* 필수 수집 항목은 구인구직 이력서 등록 및 수정에 필요한 최소한의 정보이며, 동의를 해야만 구인구직 이력서 등록 및 수정 서비스를 이용할 수 있습니다.</p>
						</li>
						<li>
              <div class="join_hd">
							  <span class="agree_tit">개인정보 수집 및 이용에 동의합니다. (선택 수집항목)</span> 
                <label for="agree02" class="lab_check">
                  동의
                  <span class="ico"><input name="dirrhksCheck2" id="ter_person2" type="checkbox" /></span>
                </label>
              </div>
							<div class="biz mk_event_tbl">
								<div class="use per35">
									<p class="tbl_th">이용목적</p>
									<p class="tbl_td">구인구직 이력서 등록 및 수정</p>
								</div>
								<div class="per_unit per30">
									<p class="tbl_th">개인정보의 항목</p>
									<p class="tbl_td">사진, 희망 근무형태, 희망급여, 경력, 학력, 상세 학력, 상세 경력사항, 보유 자격증, 국적 여부, 병역사항, 자기소개서</p>
								</div>
								<div class="per_unit per35">
									<p class="tbl_th">보유 및 이용기간</p>
									<p class="tbl_td"><strong>회원 탈퇴 시 지체없이 파기</strong></p>
								</div>
							</div>
							<p class="notice">* 선택 수집 항목은 구인구직 이력서 등록 및 수정 시 입력하지 않아도 서비스를 이용할 수 <strong>있으나, 입사지원 시 불이익이 발생할 수 있습니다.</strong></p>
						</li>
				  </ul> 
  


				<h3 class="tit_join">본인 인증</h3>

				<div class="wrap_join_box">
					<div class="biz_info_txt">
						<p>아래 <em>인증하기</em>버튼을 클릭해 본인인증을 진행해주세요.</p>
						<p>회원 가입하신 분의 정보와 본인인증 정보가 일치하는 경우에만 서비스이용동의가 가능합니다.</p>
					</div>
				</div>
<%
Dim strReturnUrl

If ReturnPath <> "" Then
  strReturnUrl = "http://" & replace(replace(strHost,"http://",""),"https://","") & ReturnPath
Else
  strReturnUrl = "javascript:history.back();"
End If
%>
				<div class="box_btn">
					<a href="<%=strReturnUrl%>" class="before_link"><span>이전으로</span></a>
					<button type="button" onclick="ConfirmSubmit()" class=""><span class="btn_g">인증하기</span></button>
				</div>

			</div>
		</div>
	</div>
</div>
  <!-- new Footer -->
    <!-- #include virtual = "/common/include/footer.inc" -->
  <!--// new Footer -->
  <iframe name="hiddenFrame" id="hiddenFrame" width="0" height="0" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</body>
</html>