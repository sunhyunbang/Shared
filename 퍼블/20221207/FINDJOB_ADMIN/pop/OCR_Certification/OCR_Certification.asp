<%
'*******************************************************************************************
' 단 위 업 무 명	: 등록대행 > 기업정보 인증
' 작    성    자	: 방 순 현
' 작    성    일	: 2022/11/09
' 수    정    자	: 
' 수    정    일	: 
' 내          용	: 
' 주  의  사  항  :
'*******************************************************************************************
%>
<!-- #include virtual = "/include/Const.inc" -->
<!-- #include virtual = "/include/Odbc.inc" -->
<!-- #include virtual = "/include/Cookies.inc" -->
<!-- #include virtual = "/include/Cm_Function.inc" -->
<!-- #include virtual="/include/DAO/MemberDAO.inc" //-->

<%
  '***********************************************
  '검색
  '***********************************************
  Response.Buffer     = TRUE
  Response.Expires    = -1
  Session.CodePage    = 949
  Response.ChaRset    = "EUC-KR"


  Dim member_cd : member_cd = "2"		'회원구분코드	1:개인, 2:기업
  Dim AdminID : AdminID = Request.Cookies("JobPaperAdminKEY")("AdminID")
  
%>


<!--  *************** 다음 API SCRIPT *************** -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%=KAKAO_API_KEY_JS%>&libraries=services"></script>

<link rel="stylesheet" type="text/css" href="/css/datepicker/jquery-ui.css" />
<link rel="stylesheet" href="/css/mag.css?v=<%=second(now)%>" type="text/css" />
<link rel="stylesheet" type="text/css" href="/css/popup_new.css?v=<%=second(now)%>" />


<!--  *************** S본인인증 SCRIPT *************** -->
<script language="javascript" type="text/javascript" src="/js/Certify/biz_join.js?v=<%=second(now)%>"></script>
<!--  *************** E본인인증 SCRIPT *************** -->
<script language="javascript" type="text/javascript" src="/js/jquery-1.9.1.min.js"></script>
<script language="javascript" type="text/javascript" src="/js/datepicker/jquery-ui.js"></script>
<script language="javascript" type="text/javascript" src="/js/Common.js?v=<%=second(now)%>"></script>
<script language="javascript" type="text/javascript" src="/js/AdminMenu.js?v=<%=second(now)%>"></script>
<script language="javascript" type="text/javascript" src="/js/form/FormCommon.js?v=<%=second(now)%>"></script>
<script language="javascript" type="text/javascript" src="/js/calendar/calendar_std.js?v=<%=second(now)%>"></script>

<!--<script language="javascript" type="text/javascript" src="/smarteditor/js/HuskyEZCreator.js?v=<%=second(now)%>"></script>-->
<!--<script language="javascript" type="text/javascript" src="/js/form/AreaCodeCombo.js?v=<%=second(now)%>"></script>-->
<script language="javascript" type="text/javascript" src="/js/jobRegist/common_Search.js?v=<%=second(now)%>"></script>
<script language="javascript" type="text/javascript" src="/js/jobRegist/search.js?v=<%=second(now)%>"></script>


<script type="text/javascript">

  $(document).ready(function () {

  //인증방식선택
  $('input[type=radio][name=ra]').on('click',function() {
      var chkValue = $('input[type=radio][name=ra]:checked').val();
        if (chkValue == '1') {
          $('#type_wrap_1').css('display','block');
          $('#type_wrap_2').css('display','none');
        } else if (chkValue == '2') {
          $('#type_wrap_1').css('display','none');
          $('#type_wrap_2').css('display','block');
        }
    })

  //datepicker
  $(function() {
		$("#datepicker").datepicker({
			dateFormat: 'yy-mm-dd',
      monthNamesMin: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
      monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
      monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
      dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
      changeMonth: true,
      changeYear: true,
      showAnim: 'fadeIn',
      showButtonPanel: true,
      showMonthAfterYear: true,
      yearSuffix: '년',
      closeText: '닫기',
      yearRange:'c-150:c+10',
      beforeShow: function (input) {
        $('.ui-datepicker-div').addClass('open');
        var i_offset = $(input).offset();
        setTimeout(function () {
          $(".ui-datepicker").css({
            'position': 'fixed',
            'top': '50%',
            'left': '50%'
          });
          $('.job_new').append("<div class='dim' style='display:block'></div>");
        });
      },
      onClose: function (selectedDate) {
        $('.dim').remove();
        $("#ui-datepicker-div").html("")
      }
		});
	});



  });

  $(function () {
    visible_Html($("#hidOCR_Certification").val());
  });

  function fnCheckBizInfo() {

    // 파일등록 유효성체크
    if ($("#file_upload").val() == "") {
      alert("기업정보 인증을 위해 사업자등록 증명원 또는 사업자등록증 파일을 첨부해 주세요.");
      //$('html, body').animate({ scrollTop: $('#file_upload_alert').offset().top - 100 }, 400);
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
      } 
    }
    
    // 기업정보 입력
    if ($("#company_nm").val() == "") {
      alert("기업명을 입력해 주세요.");
      $("#company_nm").addClass('input_alert');
      $("#company_nm_alert").show();
      $("#company_nm_alert").focus();
      $('html, body').animate({ scrollTop: $('#company_nm_alert').offset().top - 100 }, 400);
      return;
    } else {
      $("#company_nm").removeClass('input_alert');
      $("#company_nm_alert").hide();
    }

    // 기업정보 입력
    if ($("#RegisterNo").val() == "") {
      alert("사업자등록번호 입력해 주세요.");
      $("#RegisterNo").addClass('input_alert');
      $("#RegisterNo_alert").show();
      $("#RegisterNo_alert").focus();
      $('html, body').animate({ scrollTop: $('#RegisterNo_alert').offset().top - 100 }, 400);
      return;
    } else {
      $("#RegisterNo").removeClass('input_alert');
      $("#RegisterNo_alert").hide();
    }

    if ($("#ceo_nm").val() == "") {
      alert("대표자명을 입력해 주세요.");
      $("#ceo_nm").addClass('input_alert');
      $("#ceo_nm_alert").show();
      $("#ceo_nm_alert").focus();
      $('html, body').animate({ scrollTop: $('#ceo_nm_alert').offset().top - 100 }, 400);
      return;
    } else {
      $("#ceo_nm").removeClass('input_alert');
      $("#ceo_nm_alert").hide();
    }

    $("form[name='frm']").attr("encrypte", "multipart/form-data");
    var form = $('#frm')[0];
    var formData = new FormData(form);

    $("#checkBizInfo").css("pointer-events", "none");
    
    $.ajax({
      type: 'post',
      url: 'Ajax_OCR_Certification_Proc.asp',
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
        var IssuanceDT = retOCR_ISSUANCEDATE.substring('0', '4') + '-' + retOCR_ISSUANCEDATE.substring('5', '7') + '-' + retOCR_ISSUANCEDATE.substring('8', '10');

        if (jsonParseDepth1.RESULT_CODE == "200") {
          if (retOCR_CODE == "C2") { //인증완료
            $("#hidOCR_Certification").val("Y");
            
          } else { //인증 실패
            $("#hidOCR_Certification").val("N");
          }
          visible_Html($("#hidOCR_Certification").val());
        }
        console.log("리턴 코드 :" + retOCR_CODE + "| 리턴 텍스트 :" + retOCR_TXT + "| 리턴 발행일 :" + retOCR_ISSUANCEDATE + "| OCR에서 받은 잘못된 리턴값 :" + retOCR_RETVAL);

        alert(retOCR_TXT);
        $("#checkBizInfo").css("pointer-events", "auto");
      },
    });
  }

  function get_MemberInfo() {

    if ($("#UserID").val() == "") {
      alert("기업정보 인증을 진행할 회원ID를 입력해 주세요.");
      return;
    } else {
      $("#UserID").removeClass('input_alert')
      $("#UserID_alert").hide();
       
      $.ajax({
        url: 'Ajax_Get_MemberInfo.asp',
        type: 'post',
        async: false,
        dataType: 'json',
        data: { UserID: $("#UserID").val() },
        success: function (data) {
          console.log(data[0]);

          if (data[0].RetVal > 0) {
            if (data[0].MK_AGREEF == "0") {
              alert("‘서비스 이용 동의’를 하지 않은 회원입니다.\n\n‘서비스 이용 동의‘ 후 이용 부탁 드립니다.");
              $("#UserID").val("");
              $("#UserID").focus();
              $('html, body').animate({ scrollTop: $('#UserID_alert').offset().top - 100 }, 400);
              return;
            } else if (data[0].OUT_YN == "Y" || data[0].RetVal == "1") {
              alert("기업회원이 아니거나 가입된 아이디가 없습니다.");
              $("#UserID").val("");              
              $("#UserID").focus();
              $('html, body').animate({ scrollTop: $('#UserID_alert').offset().top - 100 }, 400);
              return;
            } else if (data[0].REST_YN == "Y") {
              alert("현재 휴면회원 상태로 공고 등록 이용이 제한되어 있습니다. 휴면상태 해제 후 이용 부탁 드립니다.");
              $("#UserID").val("");
              $("#UserID").focus();
              $('html, body').animate({ scrollTop: $('#UserID_alert').offset().top - 100 }, 400);
              return;
            } else if (data[0].BAD_YN == "Y") {
              alert("이용이 제한된 아이디입니다.\n\n자세한 사항은 고객센터(080-269-0011)로 문의해 주세요.");
              $("#UserID").val("");
              $("#UserID").focus();
              $('html, body').animate({ scrollTop: $('#UserID_alert').offset().top - 100 }, 400);
              return;
            } else {
              var fullADDR = data[0].CITY + " " + data[0].GU + " " + data[0].DONG + " " + data[0].ADDR1;
              $("#hidCUID").val(data[0].CUID);
              $("#COM_ID").val(data[0].COM_ID);
              $("#company_nm").val(data[0].COM_NM);
              $("#RegisterNo").val(data[0].RESITER_NO);
              $("#ceo_nm").val(data[0].CEO_NM);
              $("#txtADDRESS_JIBUN").val(fullADDR.trim());
              $("#txtADDRESS_JIBUN_DETAIL").val(data[0].ADDR2);
              $("#hidOCR_Certification").val(data[0].BizLicense_Certification_YN);

              $("#Fax").val(data[0].Rs_FAX); 
              $("#MAIN_PHONE").val(data[0].MAIN_PHONE);

              $("#bname").val(data[0].DONG);
              $("#bcode").val(data[0].Rs_LAW_DONGNO);
              $("#buildingCode").val(data[0].Rs_MAN_NO);
              $("#buildingName").val(data[0].Rs_ROAD_ADDR_DETAIL);

              alert("정상 회원입니다.\n\n사업자등록 증명원 또는 사업자등록증을 첨부하여 기업정보 인증을 진행해 주세요.");
            }
          }
        },
        error: function (request, status, error) {
          console.log('code:' + request.status + '\n' + 'message:' + request.responseText + '\n' + 'error:' + error);
        }
      });
    }

  }

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
      $("#company_nm").attr("class", "input_ty");
      $("#company_nm").attr("readonly", false);
      $("#ceo_nm").attr("class", "input_ty");
      $("#ceo_nm").attr("readonly", false);
    }
  }


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



	function ConfirmSubmit() {

	  if ($("#UserID").val() == "") {
	    alert("기업정보 인증을 진행할 회원ID를 입력해 주세요.");
	    return;
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

	  // 기업정보 입력
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

	  if ($("#txtADDRESS_JIBUN").val().trim() == "") {
	    alert("회사주소를 입력해 주세요.");
	    $("#txtADDRESS_JIBUN").addClass('input_alert')
	    $("#txtADDRESS_JIBUN_alert").show();
	    $("#txtADDRESS_JIBUN_alert").focus();
	    $('html, body').animate({ scrollTop: $('#txtADDRESS_JIBUN_alert').offset().top - 100 }, 400);
	    return;
    } else {
	    $("#txtADDRESS_JIBUN").removeClass('input_alert')
	    $("#txtADDRESS_JIBUN_alert").hide();
    }

	  if ($("#txtADDRESS_JIBUN_DETAIL").val() == "") {
	    alert("상세주소를 입력해 주세요.");
	    $("#txtADDRESS_JIBUN_DETAIL").addClass('input_alert')
	    $("#txtADDRESS_JIBUN_DETAIL_alert").show();
	    $("#txtADDRESS_JIBUN_DETAIL_alert").focus();
	    $('html, body').animate({ scrollTop: $('#txtADDRESS_JIBUN_DETAIL_alert').offset().top - 100 }, 400);
	    return;
    } else {
	    $("#txtADDRESS_JIBUN_DETAIL").removeClass('input_alert')
	    $("#txtADDRESS_JIBUN_DETAIL_alert").hide();
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


</script>

<body id="mag">
<div id="wrap">
  <div class="corp_certi window_pop job_new">
    <h3 class="title">
      기업정보 인증 (필수)
      <a href="javascript:;">기업정보 인증 안내</a>
    </h3>
    <div class="desc">
      안전한 채용과 기업정보 도용을 막기 위해 <strong class="p_color02">기업정보를 사업자등록 증명원 또는 사업자등록증</strong>으로 확인하고 있습니다.
    </div>
    <form id ="frm" name="frm">
      <input type="hidden" name="targetpage" id="targetpage" value="<%=targetpage%>">		<!--리턴페이지-->
      <input type="hidden" name="fahost" id="fahost" value="<%=basehost%>">				<!--리턴호스트-->
      <input type="hidden" name="hidOCR_Certification" id="hidOCR_Certification" value ="N">
      <input type="hidden" name="hidCUID" id="hidCUID" >
      <input type="hidden" name="COM_ID" id="COM_ID" >
      <input type="hidden" name="hidAdminID" id="hidAdminID" value="<%=AdminID %>">
      <input type="hidden" name="Fax" id="Fax">
      <input type="hidden" name="MAIN_PHONE" id="MAIN_PHONE">

      <div class="cont">
        <div class="form_list">
          <dl>
            <dt>회원ID</dt>
            <dd>
              <ul class="form_area">
                <li>
                  <input type="text" class="input_ty" id="UserID" name="UserID" placeholder="아이디 입력">
                  <div id="UserID_alert" class="alert_txt" style="display: none;">기업정보 인증을 진행할 회원ID를 입력해 주세요.</div>
                </li>
                <li class="btn">
                  <a href="javascript:get_MemberInfo();" class="btn_m btn_ty02">검색</a>
                </li>
              </ul>
            </dd>
          </dl>
        </div>
        
        <div class="blt_list circle">
          <ul>
            <li class="mb0">기업정보 인증을 진행할 회원 ID를 입력해 주세요.</li>
            <li>반드시 검색 버튼을 눌러야 회원 매핑이 완료됩니다.</li>
          </ul>
        </div>
      </div>

      <div class="cont">
        <h4 class="tit">기업정보</h4>

        <div class="form_list">
          <dl>
            <dt>회사명</dt>
            <dd>
              <input type="text" class="input_ty" name="company_nm" id="company_nm" value="<%=com_nm%>" placeholder="회사명 입력">
              <div id="company_nm_alert" class="alert_txt" style="display: none;">회사명을 입력해주세요.</div>
            </dd>
          </dl>

          <dl>
            <dt>사업자등록번호</dt>
            <dd>
              <input type="text" class="disabled" id="RegisterNo" name="RegisterNo" value="<%=register_no%>" readonly >
              <div id="RegisterNo_alert" class="alert_txt" style="display: none;">사업자등록번호를 입력해주세요.</div>
            </dd>
          </dl>

          <dl>
            <dt>대표자명</dt>
            <dd>
              <input type="text" class="input_ty" name="ceo_nm" id="ceo_nm" value="" placeholder="대표자명 입력">
              <div id="ceo_nm_alert" class="alert_txt" style="display: none;">대표자명을 입력해주세요.</div>
            </dd>
          </dl>

          <dl>
            <dt>회사주소</dt>
            <dd>

              <input type="hidden" name="hidADDRESS_ROAD" id="hidADDRESS_ROAD" value="" />
              <input type="hidden" name="hidADDRESS_DETAIL" id="hidADDRESS_DETAIL" value="" />
              <input type="hidden" name="buildingCode" id="buildingCode">
              <input type="hidden" name="buildingName" id="buildingName">
              <input type="hidden" name="sido" id="sido">
              <input type="hidden" name="sigungu" id="sigungu">
              <input type="hidden" name="bcode" id="bcode">
              <input type="hidden" name="bname" id="bname">

              <div class="form_address">
                <div class="basic">
                  <input type="text" class="input_ty" placeholder="회사주소 입력" readonly="true" name="txtADDRESS_JIBUN" id="txtADDRESS_JIBUN">
                  <input type="hidden" name="txtADDRESS_ROAD" id="txtADDRESS_ROAD" value="" >
                  <a href="javascript:;" class="btn_m btn_ty03" id="btnAddrSearch" onclick="Fn_FindDaumAddress();">주소검색</a>
                </div>
                <div id="txtADDRESS_ROAD_alert" class="alert_txt" style="display: none;">회사주소를 입력해 주세요.</div>
                <div class="detail">
                  <input type="text" class="input_ty" placeholder="상세주소 입력" name="txtADDRESS_JIBUN_DETAIL" id="txtADDRESS_JIBUN_DETAIL">
                  <div id="txtADDRESS_JIBUN_DETAIL_alert" class="alert_txt" style="display: none;">상세주소를 입력해 주세요.</div>
                </div>
              </div>
              <div id="" class="alert_txt" style="display: none;">회사주소를 입력해주세요.</div>
            </dd>
          </dl>

        </div>
      </div>


      <div class="cont">
        <h4 class="tit">인증 방식 선택</h4>

        <!-- 기업인증 추가 -->
							<div class="certi_type_wrap">
										<div class="certi_type">
											<dl>
												<dt>
													<input type="radio" name="ra" value="1" id="doc" checked="checked">
													<label for="doc">인증 서류 첨부</label>
												</dt>
												<dd>
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
													<input type="text" class="inp_txt nts_inp input_ty" name="op_date" id="datepicker" value="" placeholder="YYYY.MM.DD"> 
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

      <div class="btn_area confirm">
        <a href="javascript: ConfirmSubmit()" class="btn_l btn_ty02">확인</a>
      </div>

    </form>
  </div>
 
</div>
  <!-- iOS에서는 position:fixed 버그가 있음, 적용하는 사이트에 맞게 position:absolute 등을 이용하여 top,left값 조정 필요 -->
  <div id="divLayer" style="display:none;position:fixed;overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch;">
    <img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1" onclick="closeDaumPostcode()" alt="닫기 버튼">
  </div>
</body>
 <script type="text/javascript">
   // 우편번호 찾기 화면을 넣을 element
   var element_layer = document.getElementById('divLayer');

   // 텍스트박스내 숫자만 입력받기
   function keyIntCheck2(keep) {
     var keyValue = event.keyCode;

     if ((keyValue <= 95 || keyValue >= 106) && (keyValue <= 47 || keyValue >= 58) && keyValue != 8 && keyValue != 9 && keyValue != 46 && keyValue != 37 && keyValue != 39 && keyValue != 13 && keyValue) {
       if (keyValue != 110) { // .(점)은 예외처리 (소수점 허용)
         alert("숫자만 입력할 수 있습니다");
         if (!keep) event.srcElement.value = ''; //기존값 유지 여부
         event.srcElement.focus();
         return false;
       }
     }
   }

   // 회사 주소 검색
   function Fn_FindDaumAddress(type) {
     new daum.Postcode({
       oncomplete: function (data) {

         var duildingName = ""; // 상세 건물명 표기
         if (data.buildingName != "") {
           duildingName = "(" + data.buildingName + ")";
         }


         if (data.jibunAddress != "") {
           $("#txtADDRESS_JIBUN").val(data.jibunAddress);
         } else if (data.autoJibunAddress != "") {
           $("#txtADDRESS_JIBUN").val(data.autoJibunAddress);
         }
         // 회원가입시에는 상세주소(addr2)와 건물 주소(road_addr_detail)가 따로있음
         if (data.roadAddress != "") {
           $("#hidADDRESS_ROAD").val(data.roadAddress);
           $("#txtADDRESS_JIBUN_DETAIL").val("");
         } else if (data.autoRoadAddress != "") {
           $("#hidADDRESS_ROAD").val(data.autoRoadAddress);
           $("#txtADDRESS_JIBUN_DETAIL").val("");
         }

         // BNAME1에 값이 있으면 BNAME1로 값이 없으면 BNAME2로 수정 2020-09-21
         var bname = "";
         if (data.bname1 != "") {
           //$("#hidBname2").val(data.bname1);
           bname = data.bname1;
         }
         else {
           //$("#hidBname2").val(data.bname2);
           bname = data.bname2;
         }
         if (data.sido == "세종특별자치시") {
           data.sido = "세종";
           data.sigungu = "세종시";
         }

         if (data.sido == "제주특별자치도") {
           data.sido = "제주";
         }
         document.getElementById('buildingCode').value = data.buildingCode;
         document.getElementById('buildingName').value = data.buildingName;

         document.getElementById('sido').value = data.sido;
         document.getElementById('sigungu').value = data.sigungu;
         document.getElementById('bcode').value = data.bcode;
         document.getElementById('bname').value = bname;

         element_layer.style.display = 'block';
         $("#txtADDRESS_JIBUN_DETAIL").focus();
         closeDaumPostcode();


       },
       width: '100%',
       height: '100%',
       maxSuggestItems: 5
     }).embed(element_layer, { closeLayer: true });
     // iframe을 넣은 element를 보이게 한다.
     element_layer.style.display = 'block';
     // iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
     initLayerPosition();

   }

   // DAUM API 좌표 저장
   function Fn_FindCodeFromAddress(address, posType) {
     $.ajax({
       url: "/js/ajax/ajax_getMap.asp",
       type: "POST",
       dataType: 'json',
       async: false,
       data: { addr: escape(address) },
       success: function (data) {
         var tm128_posx = data.TM128_PosX;
         var tm128_posy = data.TM128_PosY;
         var tm128_addr = data.TM128_Addr;
         var wgs84_posx = data.WGS84_PosX;
         var wgs84_posy = data.WGS84_PosY;
         var wgs84_addr = data.WGS84_Addr; //서울 중랑구 면목동 5-3 의 형태

         // 수정시 데이터 불러올때는 좌표를 저장 안함
         if (posType == "Y") {
           $("#hidGPoint_X").val(wgs84_posx);
           $("#hidGPoint_Y").val(wgs84_posy);
         }
       },
       error: function (xhr, status, error) {
         alert("DAUM API 에러");
       }
     });
   }

   // 브라우저의 크기 변경에 따라 레이어를 가운데로 이동시키고자 하실때에는
   // resize이벤트나, orientationchange이벤트를 이용하여 값이 변경될때마다 아래 함수를 실행 시켜 주시거나,
   // 직접 element_layer의 top,left값을 수정해 주시면 됩니다.
   function initLayerPosition() {
     var width = 500; //우편번호서비스가 들어갈 element의 width
     var height = 500; //우편번호서비스가 들어갈 element의 height
     var borderWidth = 3; //샘플에서 사용하는 border의 두께

     // 위에서 선언한 값들을 실제 element에 넣는다.
     element_layer.style.width = width + 'px';
     element_layer.style.height = height + 'px';
     element_layer.style.border = borderWidth + 'px solid';
     // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
     element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width) / 2 - borderWidth) + 'px';
     element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height) / 2 - borderWidth) + 'px';
   }
   // daum 팝업창 close
   function closeDaumPostcode() {
     // iframe을 넣은 element를 안보이게 한다.
     element_layer.style.display = 'none';
   }

   function FnConfirmID() {
     $("#hidIDSearchYN").val("N");
   }



</script>