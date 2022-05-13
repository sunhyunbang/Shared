<%
'===============================================================================================
'1. 시스템명 		: 파인드올 공통하단
'2. 단위업무명 	: 제휴문의 등록폼
'3. 페이지명 		: InsFrm.asp
'4. 처리설명 		:	제휴문의 등록폼 (전섹션 공통사용)
'5. 작성자 			: 이상무
'6. 작성일 			:	2004.11.25
'7. 주의사항 		:
'8. 수정사항
'	1) 수정일자 		:
'	2) 수정자 			:
'	3) 수정이유 		:
'	4) 수정내용 		:
'9. INC 파일목록
'==================================================================================================
Dim strHost			: strHost		= Request("strHost")
%>
<!-- #include virtual = "/include/Cm_Function.inc" //-->
<!-- #include virtual = "/fa/inc/head.inc" //-->
<!-- #include virtual = "/fa/inc/top_main.inc" 	//-->

<!-- #include virtual = "/fa/inc/ServerIP.inc" //-->

<% ' HTTPS 처리 2019/04/01 S %>
<!-- #include virtual = "/include/RedirectSSL.asp" // HTTPS로 이동 //-->
<% ' HTTPS 처리 2019/04/01 E %>

<script language="javascript">
<!--
/*---------------------------------------------------------------------------------------------------------
  공란 check하기
----------------------------------------------------------------------------------------------------------*/
	function CheckIt(Local)
	{
		var FrmFriends = document.FrmFriends

		if(FrmFriends.txtCompany.value == "")
		{
			alert("회사명을 입력하세요");
			FrmFriends.txtCompany.focus();
			return ;
		}

		if(FrmFriends.txtCharge.value == "")
		{
			alert("담당자를 입력하세요");
			FrmFriends.txtCharge.focus();
			return;
		}

		if(FrmFriends.txtPhone.value == "")
		{
			alert("연락처를 입력하세요");
			FrmFriends.txtPhone.focus();
			return;
		}

		if(FrmFriends.txtEmail.value.length != 0 )
		{
			if (FrmFriends.txtEmail.value != "" && FrmFriends.txtEmail.value.match(/[a-zA-Z0-9_@.-]+/g) != FrmFriends.txtEmail.value)
			{
			alert("이메일 주소가 부정확합니다.");
			FrmFriends.txtEmail.focus();
			return;
			}
			if (FrmFriends.txtEmail.value != "" && FrmFriends.txtEmail.value.search(/(\S+)@(\S+)\.(\S+)/) == -1 )
			{
			alert("이메일 주소가 부정확합니다.");
			FrmFriends.txtEmail.focus();
			return;
			}
		}
		else
		{
			alert("이메일 주소를 입력해 주세요!");
			FrmFriends.txtEmail.focus();
			return;
		}

		if(FrmFriends.chk_agree.checked == false )
		{
			alert("제휴신청정보 제공에 동의해 주세요.");
			FrmFriends.chk_agree.focus();
			return ;
		}

		if(FrmFriends.txtTitle.value =="")
		{
			alert("제목을 입력하세요");
			FrmFriends.txtTitle.focus();
			return;
		}

		if(FrmFriends.txaProposal.value == "")
		{
			alert("사업제안서 내용을 입력하세요");
			FrmFriends.txaProposal.focus();
			return;
		}

		//FrmFriends.action = "Insert.asp?Local="  + Local
		//본서버 적용시 아래 내용 적용 (임시로 적용시켰음 (1번 서버)
		//FrmFriends.action = "Insert.asp"
		FrmFriends.submit();
	}

/*---------------------------------------------------------------------------------------------------------
  숫자형 Check(금액..수량등등..)
----------------------------------------------------------------------------------------------------------*/
	function NumCheck(FrmFriends)
	{
		var num ="0123456789- ";
		for (var i=0; i<FrmFriends.value.length; i++)
		{
				if(-1 == num.indexOf(FrmFriends.value.charAt(i)))
				{
						alert("숫자만 입력가능합니다!");
						FrmFriends.value = '';
						return;
				}
		}
	}

/*---------------------------------------------------------------------------------------------------------
  특수문자 제어
---------------------------------------------------------------------------------------------------------*/
	function Restric (m) {

			var x = m;
			var y = x.split(" ")
			var z = y.length
			var t = "";

			for (i=0;i<z;i++)
				t = t+y[i];
			//공백만 입력 제어
			if ((t == "") && (z > 1)){
				alert("공백만 입력할 수 없습니다!");
				return 0;
			}
			//특수문자 제어
			//띄어쓰기는 해제
			if (escape(x).indexOf("%20") >=0) {
				return 1;
			}
			//그외 특수문자 제한 "(%22),'(%27),%(%25),&(%26), ,(%2C)
			if ((escape(x).indexOf("%22") >=0) || (escape(x).indexOf("%25") >=0) || (escape(x).indexOf("%26") >=0) || (escape(x).indexOf("%27") >=0) || (escape(x).indexOf("%2C") >=0)){
				alert("['],["+'"'+"],[%],[&],[,]의 특수문자는 검색어로 입력할 수 없습니다.!");
			  return 0;
			}
		return 1;
	}

	function CharCheck(){
		if (Restric (document.FrmFriends.txtCompany.value) == 0) {
			document.FrmFriends.txtCompany.value = "";
 			document.FrmFriends.txtCompany.focus();
			return false;
		}
		if (Restric (document.FrmFriends.txtCharge.value) == 0) {
			document.FrmFriends.txtCharge.value = "";
 			document.FrmFriends.txtCharge.focus();
			return false;
		}
		if (Restric (document.FrmFriends.txtAddress.value) == 0) {
			document.FrmFriends.txtAddress.value = "";
 			document.FrmFriends.txtAddress.focus();
			return false;
		}
		if (Restric (document.FrmFriends.txtEmail.value) == 0) {
			document.FrmFriends.txtEmail.value = "";
 			document.FrmFriends.txtEmail.focus();
			return false;
		}
}

	//사업제안서 첨부
	function file_browse()
	{
	 document.FrmFriends.strSearch.click();
	 document.FrmFriends.strFile.value=document.FrmFriends.strSearch.value;
	}
//-->
</script>

<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<hr />
<div id="body">
  <div id="content">
    <table>
      <tr>
        <td>
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
    				<form name="FrmFriends" method="post" action="Insert.asp">
    				<input type="hidden" name="strHost" value="<%=strHost%>">
            <tr>
              <td width="200px" style="padding-bottom:8px; text-align: left;"><img src="//image.findall.co.kr/FAImage/All/Foot/Ins_tit01.gif" alt="제휴문의"></td>
              <td align="right" valign="bottom" style="font-size:11px;padding-bottom:3px;"><font color="888888"><a href="http://www.findall.co.kr">Home</a>
                |</font> <font color="#222222">제휴문의</font></td>
            </tr>
          </table></td>
      </tr>
      <tr>
        <td height="1px;" bgcolor="#DADADA"></td>
      </tr>
      <tr>
        <td height="56px" align="left" valign="top" background="//image.findall.co.kr/FAImage/All/Foot/images/Ins_bg01.gif" style="padding-left:26px;padding-top:22px;padding-bottom:22px;">
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="9px" height="18px"><img src="//image.findall.co.kr/FAImage/All/Foot/Ins_icon01.gif"></td>
              <td><strong>벼룩시장</strong>은 고객들의 실생활에 필요한 정보를 제공하고자 노력합니다. </td>
            </tr>
            <tr>
              <td height="18px"><img src="//image.findall.co.kr/FAImage/All/Foot/Ins_icon01.gif"></td>
              <td>지금보다 더 나은 정보를 제공하기 위해, 함께 할 파트너를 찾고 있습니다.</td>
            </tr>
            <tr>
              <td height="20px"><img src="//image.findall.co.kr/FAImage/All/Foot/Ins_icon01.gif"></td>
              <td><strong>벼룩시장</strong>은 우수한 기술이나 탁월한 컨텐츠를 보유하고 있는 파트너들은 언제든지
                문의주시기 바랍니다.</td>
            </tr>
          </table></td>
      </tr>
      <tr>
        <td style="padding-bottom:8px; text-align: left;"><img src="//image.findall.co.kr/FAImage/All/Foot/Ins_tit03.gif" alt="제휴 신청자 정보"></td>
      </tr>
      <tr>
        <td>
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="120px" height="2px" bgcolor="#2B44A2"></td>
              <td bgcolor="#2B44A2" height="2px"></td>
            </tr>
            <tr>
              <td height="30px" bgcolor="#DFF1FA" style="padding-left:15px;"><strong>회사명 <span style="color:red;">*</span></strong></td>
              <td style="padding-left:15px;"><table width="100%" height="30px" border="0" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="210px"><input type="text" name="txtCompany" style="width:175px;"></td>
                    <td width="120px" bgcolor="#DFF1FA" style="padding-left:15px;"><strong>제휴분야</strong></td>
                    <td style="padding-left:15px;">
                    	<select name="selSection" style="width:165px;">
	                   		<option value="1">부동산 관련</option>
	                   		<%'<option value="3">중고장터 관련</option> '사용하지 않는 항목 삭제 20190514 %>
          							<option value="5">신문벼룩시장 관련</option>
          							<option value="7">쿠폰 관련</option>
          							<option value="9">기타 - 컨텐츠 제휴</option>
          							<option value="10" selected="selected">기타 - 전략적 제휴</option>
                      </select>
                     </td>
                  </tr>
                </table></td>
            </tr>
            <tr>
              <td height="1px;" bgcolor="#DADADA"></td>
              <td bgcolor="#DADADA"></td>
            </tr>
            <tr>
              <td height="30px" bgcolor="#DFF1FA" style="padding-left:15px;"><strong>담당자 <span style="color:red;">*</span></strong></td>
              <td style="padding-left:15px;">
	              <table width="100%" height="30px" border="0" cellpadding="0" cellspacing="0">
	                <tr>
	                  <td width="210"><input type="text" name="txtCharge" style="width:175px;" onBlur="CharCheck();"></td>
	                  <td width="120" bgcolor="#DFF1FA" style="padding-left:15px;"><strong>연락처 <span style="color:red;">*</span></strong></td>
	                  <td style="padding-left:15px;"><input type="text" name="txtPhone" style="width:160px;" onBlur="CharCheck();"></td>
	                </tr>
	              </table>
              </td>
            </tr>
            <tr>
              <td height="1px;" bgcolor="#DADADA"></td>
              <td bgcolor="#DADADA"></td>
            </tr>
            <tr>
              <td height="30px" bgcolor="#DFF1FA" style="padding-left:15px;"><strong>주소 <span style="color:red;">*</span></strong></td>
              <td style="padding-left:15px;"><table width="100%" height="30px" border="0" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="210px"><input type="text" name="txtAddress" style="width:175px;" onBlur="CharCheck();">
                    </td>
                    <td width="120px" bgcolor="#DFF1FA" style="padding-left:15px;"><strong>이메일 <span style="color:red;">*</span></strong></td>
                    <td style="padding-left:15px;"><input type="text" name="txtEmail" style="width:160px;" onBlur="CharCheck();"></td>
                  </tr>
                </table></td>
            </tr>
            <tr>
              <td height="1px;" bgcolor="#DADADA"></td>
              <td bgcolor="#DADADA"></td>
            </tr>

          </table>
        </td>
      </tr>
      <!-- 2015-08-25_삭제 <tr>
        <td class="agree">
	    회사명, 담당자명, 연락처, 이메일, 홈페이지주소 중 기재하신 정보는 문의내용에 대한확인 및 신속하고  정확한 상담을 위해 <br />
	  서비스 이용기간 동안 보관하고 있으며, <span>이외의 다른 목적으로 사용되지 않습니다.</span>
	   <label><input type="checkbox" name="chk_agree" value="T" class="chk"> 동의합니다.</label>
        </td>
      </tr> -->
	  <tr>
	  <td>
			<div class="adregist_h clearfix mt40">
				<h3 class="title">개인정보 수집 및 이용안내 (필수)</h3>
			</div>
			<div class="adregist_agree mt7">
				<div class="panel">
					1. 수집목적 : 상담 내용 확인 및 광고 문의에 대한 결과 회신<br />
					2. 수집항목 : 회사명, 담당자명, 연락처, 이메일, 주소<br />
					3. 이용 및 보유기간 : <strong>문의접수일로부터 3년</strong>
				</div>
				<p class="chk vamfix"><input type="checkbox" name="chk_agree" id="chk_agree" value="T" /><label for="chk_agree">(필수) 개인정보 수집 및 이용에 동의합니다.</label></p>
			</div>
			<p style="padding-top:8px; text-align: left;">* 필수 수집 정보는 서비스 이용에 필요한 최소한의 정보이며, 동의를 해야만 서비스를 이용할 수 있습니다.</p>
	  </td>
	  </tr>
	  <tr><td height="40">&nbsp;</td></tr>
      <tr>
        <td style="padding-bottom:8px; text-align: left;"><img src="//image.findall.co.kr/FAImage/All/Foot/Ins_tit04.gif" alt="제휴 제안내용"></td>
      </tr>
      <tr>
        <td>
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="120px" height="2px" bgcolor="#2B44A2"></td>
              <td bgcolor="#2B44A2" height="2px"></td>
            </tr>
            <tr>
              <td height="30px" bgcolor="#DFF1FA" style="padding-left:15px;"><strong>제목</strong></td>
              <td style="padding-left:15px;"><input type="text" name="txtTitle" style="width:520px;"></td>
            </tr>
            <tr>
              <td height="1px;" bgcolor="#DADADA"></td>
              <td bgcolor="#DADADA"></td>
            </tr>
            <tr>
              <td height="180px" valign="top" bgcolor="#DFF1FA" style="padding-left:15px;padding-top:9px;"><strong>제안사항요약</strong></td>
              <td valign="top" style="padding-left:15px;padding-top:10px;"><textarea name="txaProposal" style="width:520px;height:160px;" wrap="hard"></textarea></td>
            </tr>
            <tr>
              <td height="1px;" bgcolor="#DADADA"></td>
              <td bgcolor="#DADADA"></td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td align="center"><table height="24px" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td width="54px"><a href="javascript:CheckIt(<%=Local%>);"><img src="//image.findall.co.kr/FAImage/All/Foot/Ins_btn01.gif" border="0"></a></td>
              <td width="5px"></td>
              <td width="54px"><a href="javascript:document.FrmFriends.reset();"><img src="//image.findall.co.kr/FAImage/All/Foot/Ins_btn02.gif" border="0"></a></td>
            </tr>
           </form>
          </table>
        </td>
      </tr>

    </table>
  </div>
</div>
<hr />
<!-- #include virtual = "/include/main_new2020/nbFooter.inc" -->
</body>
</html>
