<%@Codepage=65001%>
<%
'Option Explicit
%>
<!-- #include virtual = "/common/include/fa_cookies.inc" //-->
<!-- #include virtual = "/common/common.inc" -->
<!-- #include virtual = "/common/Certify_config.asp" //-->
<!-- #include virtual = "/common/oauth/aspJSON1.17.asp" -->
<script type="text/javascript" language="javascript" runat="server" src="/common/js/JSON2.min.asp"></script>
<%
Response.Buffer		=	TRUE
Response.Expires	=	-1
'	한글깨짐방지
Session.CodePage = "65001"
Response.CharSet = "utf-8"
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "Expires","0"

Call isLogin()

Dim strRtnUrl     : strRtnUrl     = GET_REQUEST("retUrl","")
Dim strtel        : strtel = "02/031/032/033/041/042/043/044/050/051/052/053/054/055/061/062/063/064/070/080/010/011/016/017/018/019/지역번호없음"
Dim strSectionNm  : strSectionNm = ""

Dim BizLicense_Certification_YN
Dim BizLicense_RegDT
%>


<%
Set clsCmd = new clsCommand
Call clsCmd.MakeCMD(FN_application("dsn_member"), adCmdStoredProc, "mwmember.dbo.sp_master_select", 3, false)
Call clsCmd.MakeParam("@CUID",			adinteger	, adParaminput, 0	,	int("0"&CkCUID))
'Response.write clscmd.debug()
'Response.end
Set rs = clsCmd.Rs()

If Not(rs.eof Or rs.bof) Then
  '기업정보
  com_id                      = rs("COM_ID")
  com_nm                      = rs("COM_NM")          ' 기업명
  register_no                 = rs("REGISTER_NO")       ' 사업자번호
  ceo_nm                      = rs("CEO_NM")            ' 대표자명
  Rs_MAIN_PHONE               = rs("MAIN_PHONE")
  Rs_CITY                     = rs("CITY")
  Rs_GU                       = rs("GU")
  Rs_DONG                     = rs("DONG")
  Rs_ADDR1                    = rs("ADDR1")
  Rs_ADDR2                    = rs("ADDR2")
  Rs_FAX                      = rs("FAX")
  Rs_LAW_DONGNO               = rs("LAW_DONGNO")
  Rs_MAN_NO                   = rs("MAN_NO")
  Rs_ROAD_ADDR_DETAIL         = rs("ROAD_ADDR_DETAIL")
  BizLicense_Certification_YN = rs("BIZLICENSE_CERTIFICATION_YN")
  BizLicense_RegDT            = rs("BIZLICENSE_REGDATE") 
  BizLicense_IssuanceDT       = rs("BIZLICENSE_ISSUANCEDATE") 
  

  If BizLicense_Certification_YN = "Y" Then
    If Datediff("d" , BizLicense_RegDT ,Date()) < 335 Then	'인증완료 & 등록일 30일전부터
	    'Response.redirect Host&"/login/login.asp?TargetPage=http://"&Request.ServerVariables("HTTP_HOST")&"/"&Server.URLEncode(lcase(Request.ServerVariables("SCRIPT_NAME")))&"?"&Request.ServerVariables("QUERY_STRING")
      'Response.redirect "http://test.www.findjob.co.kr"
	    'Response.End
    End If
  End IF

End If

Set clsCmd = Nothing

%>
<%
	If Rs_MAIN_PHONE <> "" Then
		strmainphone = Split(Rs_MAIN_PHONE,"-")
		If UBound(strmainphone) > 1 Then
			strmainphone1 = strmainphone(0)
			strmainphone2 = strmainphone(1)
			strmainphone3 = strmainphone(2)
		End If
		main_phone1 = strmainphone1
		main_phone2 = strmainphone2 & strmainphone3
	End If

	If Rs_FAX <> "" Then
		strfax = Split(Rs_FAX,"-")
		If UBound(strfax) > 1 Then
			strfax1 = strfax(0)
			strfax2 = strfax(1)
			strfax3 = strfax(2)
		End If
		fax1 = strfax1
		fax2 = strfax2 & strfax3
	End If

strSectionNm = "벼룩시장"

 
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi">
<title>미디어윌 온라인 통합 회원</title>
<link rel="stylesheet" type="text/css" href="../common/css/jquery-ui.css" />
<link rel="stylesheet" type="text/css" href="../common/css/member_common.css" />
<script type="text/javascript" src="../common/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../common/js/member_common.js"></script>
<script type="text/javascript" src="../common/js/join.js"></script>
<script type="text/javascript" src="../common/js/jquery-ui.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script type="text/javascript">
  $(document).ready(function() {
	
    var strFullADDR = '<%=Rs_CITY &" "& Rs_GU &" "& Rs_DONG &" "& Rs_ADDR1%>';
    $(".alert").hide();

    $("#spanTitle").text("기업정보 인증");

    $("#ceo_nm").val('<%=ceo_nm%>');
    $("#main_phone1").val('<%=main_phone1%>');
    $("#main_phone2").val('<%=main_phone2%>');
    $("#fax1").val('<%=fax1%>');
    $("#fax2").val('<%=fax2%>');

    $("#addr1").val(strFullADDR.trim());
    $("#addr2").val('<%=Rs_ADDR2%>');
    $("#sido").val('<%=Rs_CITY%>');
    $("#sigungu").val('<%=Rs_GU%>');
    $("#bname").val('<%=Rs_DONG%>');
    $("#bcode").val('<%=Rs_LAW_DONGNO%>');
    $("#buildingCode").val('<%=Rs_MAN_NO%>');
    $("#buildingName").val('<%=Rs_ROAD_ADDR_DETAIL%>');
    $("#hidOCR_Certification").val('<%=BizLicense_Certification_YN%>'); 
    $("#txtIssuanceDT").val('<%=BizLicense_IssuanceDT%>');
    visible_Html('<%=BizLicense_Certification_YN%>');

  });

  function visible_Html(agree_YN) {
    if (agree_YN == "Y") {
      $(".btn_ty03").closest('.btn_area').hide();
      $(".btn_ty04").closest('.btn_area').show();
      $("#company_nm").attr("class", "disabled");
      $("#company_nm").attr("readonly", true);
      $("#ceo_nm").attr("class", "disabled");
      $("#ceo_nm").attr("readonly", true);
    } else {
      $(".btn_ty04").closest('.btn_area').hide();
      $(".btn_ty03").closest('.btn_area').show();
      $("#company_nm").attr("class", "inp_txt");
      $("#company_nm").attr("readonly", false);
      $("#ceo_nm").attr("class", "inp_txt");
      $("#ceo_nm").attr("readonly", false);
    }
  }

  function hidAlert(obj){
    $("#"+ obj.id +"_alert").hide();
  }

  function showAlert(obj){
    $("#"+ obj +"_alert").show();
  }
  

  function fnCheckBizInfo() {

    // 파일등록 유효성체크
    if ($("#file_upload").val() == "") {
      alert("기업정보 인증을 위해 사업자등록 증명원 또는 사업자등록증 파일을 첨부해 주세요.");
      $("#file_upload").addClass('input_alert')
      $("#file_upload_alert").show();
      $("#file_upload_alert").focus();
      $('html, body').animate({ scrollTop: $('#file_upload_alert').offset().top - 100 }, 400);
      return;
    } else {
      var ext = $("#file_upload").val().split('.').pop().toLowerCase();
      var maxSize = 2 * 1024 * 1024; // 20MB
      var fileSize = $("#file_upload")[0].files[0].size;

      if ($.inArray(ext, ["jpg", "jpeg", "png"]) == -1 || fileSize > maxSize) {
        alert("파일 형식 및 용량 확인 후 다시 등록해 주세요.\n\n(JPEG, JPG, PNG / 용량 20M 이하)");
        $("#file_upload").val("");
        $(".file_nm").text("");
        $('.upload_file').removeClass('on');
        return;
      } else {
        $("#file_upload").removeClass('input_alert')
        $("#file_upload_alert").hide();
      }
    }

    // 기업정보 입력
    if ($("#company_nm").val() == "") {
      alert("기업명을 입력해 주세요.");
      $("#company_nm").addClass('input_alert')
      $("#company_nm_alert").show();
      $("#company_nm_alert").focus();
      $('html, body').animate({ scrollTop: $('#company_nm_alert').offset().top - 100 }, 400);
      return;
    } else {
      $("#company_nm").removeClass('input_alert')
      $("#company_nm_alert").hide();
    }

    if ($("#RegisterNo").val() == "") {
      alert("사업자등록번호를 입력해 주세요.");
      $("#RegisterNo").addClass('input_alert')
      $("#RegisterNo_alert").show();
      $("#RegisterNo_alert").focus();
      $('html, body').animate({ scrollTop: $('#RegisterNo_alert').offset().top - 100 }, 400);
      return;
    } else {
      $("#RegisterNo").removeClass('input_alert')
      $("#RegisterNo_alert").hide();
    }

    if ($("#ceo_nm").val() == "") {
      alert("대표자명을 입력해 주세요.");
      $("#ceo_nm").addClass('input_alert')
      $("#ceo_nm_alert").show();
      $("#ceo_nm_alert").focus();
      $('html, body').animate({ scrollTop: $('#ceo_nm_alert').offset().top - 100 }, 400);
      return;
    } else {
      $("#ceo_nm").removeClass('input_alert')
      $("#ceo_nm_alert").hide();
    }


    $("form[name='frm']").attr("accept-charset", "utf-8");
    $("form[name='frm']").attr("encrypte", "multipart/form-data");
    var form = $('#frm')[0];
    var formData = new FormData(form);
    $("#checkBizInfo").css("pointer-events", "none");
    
    $.ajax({
      type: 'post',
      url: 'ajax_OCR_Certification_Proc.asp',
      data: formData,
      dataType: 'html',
      contentType: false,
      processData: false,
      error: function (xhr, status, error) {
        alert(error);
      },
      success: function (data) {
        //alert(data);
        var jsonParseDepth1 = JSON.parse(data);
        var retOCR_CODE = jsonParseDepth1.RESULT_DATA[0].OCR_CODE;
        var retOCR_TXT = jsonParseDepth1.RESULT_DATA[0].OCR_TXT;
        var retOCR_ISSUANCEDATE = jsonParseDepth1.RESULT_DATA[0].OCR_ISSUANCEDATE;
        var retOCR_RETVAL = jsonParseDepth1.RESULT_DATA[0].OCR_RETVAL;

        if (jsonParseDepth1.RESULT_CODE =="200") {
          if (retOCR_CODE == "C2") { //인증완료
            $("#hidOCR_Certification").val("Y");
          }else{ //인증 실패
            $("#hidOCR_Certification").val("N");
          }
          //visible_Html($("#hidOCR_Certification").val());
        }
        console.log("리턴 코드 :" + retOCR_CODE + "| 리턴 텍스트 :" + retOCR_TXT + "| 리턴 발행일 :" + retOCR_ISSUANCEDATE + "| OCR에서 받은 잘못된 리턴값 :" + retOCR_RETVAL);

        alert(retOCR_TXT);
        $("#checkBizInfo").css("pointer-events", "auto");
      },
    });
  }

  function ConfirmSubmit(){

    // 기업정보 입력
		if($("#company_nm").val() == ""){
		  alert("기업명을 입력해 주세요.");
		  $("#company_nm").addClass('input_alert');
			$("#company_nm_alert").show();
			$("#company_nm_alert").focus();
			$('html, body').animate({scrollTop : $('#company_nm_alert').offset().top - 100},400);
			return;
		}else {
		  $("#company_nm").removeClass('input_alert');
		  $("#company_nm_alert").hide();
		}

		if ($("#RegisterNo").val() == "") {
		  alert("사업자등록번호를 입력해 주세요.");
		  $("#RegisterNo").addClass('input_alert');
		  $("#RegisterNo_alert").show();
		  $("#RegisterNo_alert").focus();
		  $('html, body').animate({ scrollTop: $('#RegisterNo_alert').offset().top - 100 }, 400);
		  return;
		} else {
		  $("#RegisterNo").removeClass('input_alert');
		  $("#RegisterNo_alert").hide();
		}

		if($("#ceo_nm").val() == ""){
		  alert("대표자명을 입력해 주세요.");
		  $("#ceo_nm").addClass('input_alert');
			$("#ceo_nm_alert").show();
			$("#ceo_nm_alert").focus();
			$('html, body').animate({scrollTop : $('#ceo_nm_alert').offset().top - 100},400);
			return;
		}else {
		  $("#ceo_nm").removeClass('input_alert');
		  $("#ceo_nm_alert").hide();
		}

		if($("#main_phone2").val() == ""){
		  alert("대표 전화번호를 입력해 주세요.");
		  $("#main_phone1").closest('.opt_select').addClass('input_alert')
		  $("#main_phone2").addClass('input_alert');
		  $("#main_phone_alert").show();
		  $("#main_phone_alert").focus();
		  $('html, body').animate({scrollTop : $('#main_phone_alert').offset().top - 100},400);
			return;
		}else {
		  $("#main_phone1").closest('.opt_select').removeClass('input_alert');
		  $("#main_phone2").removeClass('input_alert');
		  $("#main_phone_alert").hide();
		}

		if($("#addr1").val().trim() == ""){
		  alert("회사주소를 입력해 주세요.");
		  $("#addr1").addClass('input_alert');
		  $("#addr1_alert").show();
		  $("#addr1_alert").focus();
		  $('html, body').animate({ scrollTop: $('#addr1_alert').offset().top - 100 }, 400);
		  return;
    } else {
		  $("#addr1").removeClass('input_alert');
		  $("#addr1_alert").hide();
    }

		if($("#addr2").val() == ""){
		  alert("상세주소를 입력해 주세요.");
		  $("#addr2").addClass('input_alert');
			$("#addr2_alert").show();
			$("#addr2_alert").focus();
			$('html, body').animate({scrollTop : $('#addr2_alert').offset().top - 100},400);
			return;
		}else {
		  $("#addr2").removeClass('input_alert');
		  $("#addr2_alert").hide();
		}


		if ($("#hidOCR_Certification").val() == "N") {
		  alert("기업정보 인증이 완료되지 않았습니다.\n\n기업정보 인증을 확인해 주세요.");
		  return;
		}

		var frm = document.frm;
		frm.action = "OCR_Certification_proc.asp";
		frm.method = "post";
		frm.submit();
  }

	// 기업정보 인증 사업자 등록

	function getName (obj) {
		var fileVal = obj.val();
		var fileName = fileVal.split('/').pop().split('\\').pop();

		obj.closest('.upload_file').addClass('on');
		obj.closest('.upload_file').find('.file_nm').html(fileName);

		alert("파일 등록이 완료 되었습니다.\n\n기업정보 인증 버튼을 눌러 인증을 완료해주세요.");
	}

	function imgDel() {
		$('.upload_file').removeClass('on');
	}

	function fn_nts_BizAPI() {
	  var serviceKey = "d8u2JTyOBLAR%2FjCySFrHX7QoJI9ULo0hx6QisBo9Q2XEcFICzTxGtrEFUSsus4fPQXeVS2wYSd5rUSlDZroCqQ%3D%3D";

	  var reqData = {
	    "b_no": ["8942201425"] // 사업자 번호("-"등 기호 제거 숫자로만 구성 필수)
      , "start_dt": ["20220930"] // 개업일(YYYYMMDD)
      , "p_nm": ["이나영"] // 대표자명
	  };

	  $.ajax({
	    url : "https://api.odcloud.kr/api/nts-businessman/v1/status?serviceKey=" + serviceKey,
	    type : "POST",
	    data : JSON.stringify(reqData),
	    dataType: "JSON",
	    contentType: "application/json",
	    accept: "application/json",
	    success: function (result) {
	      console.log(result);
	      
	      if (result.status_code == "OK") {
	        $("#hidOCR_Certification").val("Y");
	      } else {
	        console.log(result.status_code);
	        alert(result.status_code);
	      }
	    },
	    error: function (result) {
	      console.log(result.responseText);
	      alert(result.status_code);
	    }

	  });
	}


</script>



</head>
<body>

<!-- new Header -->
  <!-- #include virtual ="/common/include/header.inc" -->
<!-- // new Header -->

<div id="wrap" class="n_content biz member job_new">
	<div id="content">
		<div id="cMain">
			<h2 id="Body">
				<span><%=strSectionNm%> 서비스를 이용해주셔서 감사합니다.</span>
				<span class="txt">원활한 서비스 이용을 위해 기업정보를 인증해주세요.</span>
			</h2>
			<div id="mArticle">
				<form id="frm" name="frm" >
					<input type="hidden" name="retUrl" value="<%=strRtnUrl%>">
								
					<input type="hidden" name="com_id" value="<%=com_id%>">

					<input type="hidden" name="zonecode" id="zonecode">
					<input type="hidden" name="address" id="address">
					<input type="hidden" name="addressEnglish" id="addressEnglish">
					<input type="hidden" name="addressType" id="addressType">
					<input type="hidden" name="userSelectedType" id="userSelectedType">
					<input type="hidden" name="userLanguageType" id="userLanguageType">
					<input type="hidden" name="roadAddress" id="roadAddress">
					<input type="hidden" name="roadAddressEnglish" id="roadAddressEnglish">
					<input type="hidden" name="jibunAddress" id="jibunAddress">
					<input type="hidden" name="jibunAddressEnglish" id="jibunAddressEnglish">
					<input type="hidden" name="autoRoadAddress" id="autoRoadAddress">
					<input type="hidden" name="autoRoadAddressEnglish" id="autoRoadAddressEnglish">
					<input type="hidden" name="autoJibunAddress" id="autoJibunAddress">
					<input type="hidden" name="autoJibunAddressEnglish" id="autoJibunAddressEnglish">
					<input type="hidden" name="buildingCode" id="buildingCode">
					<input type="hidden" name="buildingName" id="buildingName">
					<input type="hidden" name="apartment" id="apartment">
					<input type="hidden" name="sido" id="sido">
					<input type="hidden" name="sigungu" id="sigungu">
					<input type="hidden" name="bcode" id="bcode">
					<input type="hidden" name="bname" id="bname">
					<input type="hidden" name="bname1" id="bname1">
					<input type="hidden" name="bname2" id="bname2">
					<input type="hidden" name="query" id="query">
					<input type="hidden" name="postcode" id="postcode">
					<input type="hidden" name="postcode1" id="postcode1">
					<input type="hidden" name="postcode2" id="postcode2">
					<input type="hidden" name="postcodeSeq" id="postcodeSeq">

          <input type="hidden" name="hidOCR_Certification" id="hidOCR_Certification" value ="N">
          <input type="hidden" name="hidCUID" id="hidCUID" value="<%=CkCUID%>"">
					
					<div class="agree_cont">
						<!-- 기업정보 start -->
						<div class="wrap_join_box">
						<h3 class="tit_join mg_t00">기업정보 입력(필수)</h3>

							<dl class="list_join text_field">
								<dt>회사명 (필수)</dt>
								<dd class="input_s">
									<input type="text" class="inp_txt" name="company_nm" id="company_nm" value="<%=com_nm%>"  placeholder="회사명 입력"> <!-- 인증클릭시 내용 미입력시 class input_alert 추가 -->
									<div id="company_nm_alert" class="alert">회사명을 입력해 주세요.</div>
								</dd>
							</dl>

							<dl class="list_join text_field">
								<dt>사업자등록번호</dt>
								<dd><input type="text" id="RegisterNo" name="RegisterNo" value="<%=register_no%>" class="disabled" readonly /></dd>
							</dl>

							<dl class="list_join list_join_media">
								<dt>대표자명 (필수)</dt>
								<dd class="input_s">
									<input type="text" class="inp_txt" name="ceo_nm" id="ceo_nm" value="" placeholder="대표자명 입력"> <!-- 인증클릭시 내용 미입력시 class input_alert 추가 -->
									<div id="ceo_nm_alert" class="alert">대표자명을 입력해 주세요.</div>
								</dd>
							</dl>

							<dl class="list_join list_join_media">
								<dt>대표 전화번호 (필수)</dt>
								<dd class="phone_num clear_g">
									<div class="inner clear_g">
										<div class="opt_select"> <!-- 인증클릭시 내용 미입력시 class input_alert 추가 -->
											<div class="txt">선택</div>
											<select name="main_phone1" id="main_phone1">
											<%For i = 0 To 24
												tmptel = Split(strtel,"/")
											%>
												<option value="<%=tmptel(i)%>" <%If tmptel(i) = tel Then Response.write "selected" End If %>><%=tmptel(i)%></option>
											<% Next %>
											</select>
										</div>
										<div class="bar">&nbsp;</div>
										<input type="text" name="main_phone2" id="main_phone2" class="inp_txt" maxlength="8" style="ime-mode:disabled;" pattern="[0-9]*"  onkeyup="num(this);dis_alert('phone_alert');hidAlert(this);" /> <!-- 인증클릭시 내용 미입력시 class input_alert 추가 -->
										<!-- <input type="text" class="inp_txt" pattern="[0-9]*" maxlength="8"> -->
									</div>
                  <div id="main_phone_alert" class="alert" style="display: none;">대표 전화번호를 입력해주세요.</div>
								</dd>
							</dl>

							<dl class="list_join address">
								<dt>회사주소 (필수)</dt>
								<dd class="inpbtn clear_g">
									<div id="showPostCodeLayWrap">
										<div id="showPostCodeLay" style="display:none;position:fixed;overflow:hidden;z-index:10;-webkit-overflow-scrolling:touch;">
										<img src="//i1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1" onclick="foldDaumPostcode()" alt="접기 버튼">
										</div>
									</div>
									<div class="address_area">
										<div class="basic">
											<input type="text" name="addr1" id="addr1" type="text"  class="inp_txt" style="ime-mode:disabled;" placeholder="회사주소 입력"  readonly="true"/> <!-- 인증클릭시 내용 미입력시 class input_alert 추가 -->
											<button type="button" class="btn" onClick="showDaumPostcode();dis_alert('addr_alert');"><span class="btn_g">주소검색</span></button>
										</div>
                    <div id="addr1_alert" class="alert">회사주소를 입력해주세요.</div>
										<div class="detail">
											<input type="text" name="addr2" id="addr2" class="inp_txt" placeholder="상세주소 입력"/> <!-- 인증클릭시 내용 미입력시 class input_alert 추가 -->
											<div id="addr2_alert" class="alert">상세주소를 입력해주세요.</div>
										</div>
									</div>
								</dd>
							</dl>

							<dl class="list_join list_join_media">
								<dt>회사팩스번호 (선택)</dt>
								<dd class="phone_num clear_g">
									<div class="inner clear_g">
										<div class="opt_select">
											<div class="txt">선택</div>
											<select name="fax1" id="fax1">
											<%For i = 0 To 24
												tmptel = Split(strtel,"/")
											%>
												<option value="<%=tmptel(i)%>" <%If tmptel(i) = tel Then Response.write "selected" End If %>><%=tmptel(i)%></option>
											<% Next %>
											</select>
										</div>
										<div class="bar">&nbsp;</div>
										<input type="text" name="fax2" id="fax2" class="inp_txt" maxlength="8" style="ime-mode:disabled;" pattern="[0-9]*"  onkeyup="num(this);" />
									</div>
								</dd>
							</dl>

							<p class="notice">* 기업정보 수정 시, 회원정보 내 기업정보도 변경됩니다.</p>
						</div>
						<!-- 기업정보 end -->
        

						<!-- 기업정보 인증 start -->
						<div class="wrap_join_box corp_certi" id="">
							<h3 class="tit_join">
								기업정보 인증(필수)
								<a href="javascript:void(0);">기업정보 인증 안내</a>
							</h3>

							<div class="tit">
								안전한 채용과 기업정보 도용을 막기 위해 기업정보를 <strong><span class="p_color01">사업자등록 증명원</span> 또는 <span class="p_color01">사업자등록증</span></strong>으로 확인하고 있습니다.
							</div>



							<!-- 기업인증 추가 -->
							<div class="certi_type_wrap">
										<div class="certi_type">
											<dl>
												<dt class="flex2">인증 방식 선택</dt>
												<dd class="flex2">
													<input type="radio" name="ra" value="1" id="doc" checked="checked">
													<label for="doc">인증 서류 첨부</label>
												</dd>
												<dd class="flex5">
													<input type="radio" name="ra" value="2" id="nts">
													<label for="nts">국세청 인증</label>
												</dd>
											</dl>
										</div>


										<!--인증서류첨부일때 -->
										<div id="type_wrap_1">
												<div class="upload_file">
													<input type="file" id="file_upload" name="file_upload" onchange="getName($(this))">
													<label for="file_upload">
														<div class="txt">
															인증 서류 첨부하기
														</div>
														<div class="file_nm"></div>
														<a href="javascript:imgDel();" class="img_del"></a>
													</label>
												</div>

												<div class="btn_area">
													<ul>
														<li>
															<a href="javascript:fnCheckBizInfo();" class="btn_l btn_ty03">기업정보 인증</a>
														</li>
														<li>
															<a href="https://www.findjob.co.kr/advertiser/regist_simple_ad_reception.asp" target="_blank" class="btn_l btn_ty">인증 문의</a>
														</li>
													</ul>
												</div>

											<!-- 인증완료 후 -->
											<div class="btn_area">
												<ul>
													<li>
														<a href="javascript:;" class="btn_l btn_ty04">기업정보 인증 완료</a>
													</li>
													<li>
														<a href="https://www.findjob.co.kr/advertiser/regist_simple_ad_reception.asp" target="_blank" class="btn_l btn_ty">인증 문의</a>
													</li>
													<li>
														<a href="javascript:fn_nts_BizAPI();" class="btn_l btn_ty04">국세청 기업인증</a>
													</li>
												</ul>
											</div>
											<!-- // 인증완료 후 -->

											<div class="blt_list circle">
												<ul>
													<li>
														90일 내 발급한 <strong class="p_color01">사업자등록 증명원 또는 사업자등록증</strong>을 등록해 주세요.<br>
														단, <span class="p_color02">주민등록번호 뒷자리는 노출되지 않도록 처리</span> (ex 991234 - ******* 표시 등)가 되어 있어야 합니다. (파일 형식 : JPEG,JPG,PNG,BMP / 용량 20M 이하)
													</li>
													<li>사업자등록 증명원 : <a href="https://www.gov.kr/mw/AA020InfoCappView.do?HighCtgCD=&CappBizCD=12100000016" target="_blank">발급 바로가기 ></a></li>
													<li>사업자등록증 : <a href="https://www.hometax.go.kr/" target="_blank">발급 바로가기 ></a></li>
													<li>인증 서류 등록 오류, 인증 정보 불일치, 사업자등록 증명원, 사업자등록증 외 서류로 인증을 요청하는 경우 <strong class="p_color03">인증 문의</strong> 버튼을 눌러 문의를 남겨주세요.</li>
												</ul>
											</div>
										</div>


										<!-- 국세청인증일때 -->
										<div id="type_wrap_2" style="display:none;">
										<div class="nts_certifi">
											<dl class="list_join list_join_media">
												<dt>개업일자</dt>
												<dd class="input_s">
													<input type="text" class="inp_txt nts_inp" name="op_date" id="datepicker" value="" placeholder="YYYY.MM.DD"> 
												</dd>
											</dl>
										</div>

										<div class="btn_area">
												<ul>
													<li>
														<a href="javascript:fnCheckBizInfo();" class="btn_l btn_ty03">기업정보 인증</a>
													</li>
													<li>
														<a href="https://www.findjob.co.kr/advertiser/regist_simple_ad_reception.asp" target="_blank" class="btn_l btn_ty">인증 문의</a>
													</li>
												</ul>
											</div>

										<!-- 인증완료 후 -->
										<div class="btn_area">
											<ul>
												<li>
													<a href="javascript:;" class="btn_l btn_ty04">기업정보 인증 완료</a>
												</li>
												<li>
													<a href="https://www.findjob.co.kr/advertiser/regist_simple_ad_reception.asp" target="_blank" class="btn_l btn_ty">인증 문의</a>
												</li>
												<li>
													<a href="javascript:fn_nts_BizAPI();" class="btn_l btn_ty04">국세청 기업인증</a>
												</li>
											</ul>
										</div>
										<!-- // 인증완료 후 -->
										<div class="blt_list circle">
											<ul>
												<li>
													<strong class="p_color01">사업자등록 증명원</strong> 또는 <strong class="p_color01">사업자등록증</strong>의 <strong class="p_color03">개업일자</strong>(개업일, 개업연월일)를 입력해 주세요. 
												</li>
												<li>사업자등록 증명원 : <a href="https://www.gov.kr/mw/AA020InfoCappView.do?HighCtgCD=&CappBizCD=12100000016" target="_blank">발급 바로가기 ></a></li>
												<li>사업자등록증 : <a href="https://www.hometax.go.kr/" target="_blank">발급 바로가기 ></a></li>
												<li>인증 서류 등록 오류, 인증 정보 불일치, 사업자등록 증명원, 사업자등록증 외 서류로 인증을 요청하는 경우 <strong class="p_color03">인증 문의</strong> 버튼을 눌러 문의를 남겨주세요.</li>
											</ul>
										</div>
										</div>

									
								</div>
								<!-- // 기업정보 인증 end -->
						

							</div>






                            
						
						<div class="box_btn">
							<a href="<%=strReturnUrl%>" class="before_link"><span>이전으로</span></a>
							<button type="button" onclick="ConfirmSubmit()" class=""><span class="btn_g">확인</span></button>
						</div>

					</div>
									
				</form>
			</div>
		</div>
	</div>
</div>
  <!-- new Footer -->
    <!-- #include virtual = "/common/include/footer.inc" -->
  <!--// new Footer -->
<script type="text/javascript">
  var element_wrap = document.getElementById('showPostCodeLay');

  function foldDaumPostcode() {
  	// iframe을 넣은 element를 안보이게 한다.
  	element_wrap.style.display = 'none';
  }

  function showDaumPostcode() {
  	new daum.Postcode({
  		oncomplete: function(data) {
  			document.getElementById('zonecode').value = data.zonecode;
  			document.getElementById('address').value = data.address;
  			document.getElementById('addressEnglish').value = data.addressEnglish;
  			document.getElementById('addressType').value = data.addressType;
  			document.getElementById('userSelectedType').value = data.userSelectedType;
  			document.getElementById('userLanguageType').value = data.userLanguageType;
  			document.getElementById('roadAddress').value = data.roadAddress;
  			document.getElementById('roadAddressEnglish').value = data.roadAddressEnglish;
  			document.getElementById('jibunAddress').value = data.jibunAddress;
  			document.getElementById('jibunAddressEnglish').value = data.jibunAddressEnglish;
  			document.getElementById('autoRoadAddress').value = data.autoRoadAddress;
  			document.getElementById('autoRoadAddressEnglish').value = data.autoRoadAddressEnglish;
  			document.getElementById('autoJibunAddress').value = data.autoJibunAddress;
  			document.getElementById('autoJibunAddressEnglish').value = data.autoJibunAddressEnglish;
  			document.getElementById('buildingCode').value = data.buildingCode;
  			document.getElementById('buildingName').value = data.buildingName;
  			document.getElementById('apartment').value = data.apartment;
  			document.getElementById('sido').value = data.sido;
  			document.getElementById('sigungu').value = data.sigungu;
  			document.getElementById('bcode').value = data.bcode;
  			document.getElementById('bname').value = data.bname;
  			document.getElementById('bname1').value = data.bname1;
  			document.getElementById('bname2').value = data.bname2;
  			document.getElementById('query').value = data.query;
  			document.getElementById('postcode').value = data.postcode;
  			document.getElementById('postcode1').value = data.postcode1;
  			document.getElementById('postcode2').value = data.postcode2;
  			document.getElementById('postcodeSeq').value = data.postcodeSeq;

  			if (data.jibunAddress != '')
  			{
  				document.getElementById('addr1').value = data.jibunAddress;
  			}else{
  				document.getElementById('addr1').value = data.autoJibunAddress;
  			}


  			if (data.buildingName != '')
  			{
  				if (data.roadAddress != '')
  				{
  					$('#spnRoadAddr').text(data.roadAddress + " (" + data.bname + ", " + data.buildingName + ")");
  				}else{
  					$('#spnRoadAddr').text(data.autoRoadAddress + " (" + data.bname + ", " + data.buildingName + ")");
  				}
  			}else{
  				if (data.roadAddress != '')
  				{
  					$('#spnRoadAddr').text(data.roadAddress + " (" + data.bname + ")");
  				}else{
  					$('#spnRoadAddr').text(data.autoRoadAddress + " (" + data.bname + ")");
  				}
  			}
  			// iframe을 넣은 element를 안보이게 한다.
  			// (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
  			element_wrap.style.display = 'none';
  		},
  		width : '100%',
  		height : '100%'
  	}).embed(element_wrap);

  	// iframe을 넣은 element를 보이게 한다.
  	element_wrap.style.display = 'block';

  	// iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
  	initLayerPosition();
  }
  function initLayerPosition(){
  	var width = 300; //우편번호서비스가 들어갈 element의 width
  	var height = 460; //우편번호서비스가 들어갈 element의 height
  	var borderWidth = 5; //샘플에서 사용하는 border의 두께

  	// 위에서 선언한 값들을 실제 element에 넣는다.
  	element_wrap.style.width = width + 'px';
  	element_wrap.style.height = height + 'px';
  	element_wrap.style.border = borderWidth + 'px solid';
  	// 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
  	element_wrap.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px';
  	element_wrap.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth) + 'px';
  }
</script>
</body>
</html>