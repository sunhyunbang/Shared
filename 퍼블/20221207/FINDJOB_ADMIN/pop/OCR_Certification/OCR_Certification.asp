<%
'*******************************************************************************************
' �� �� �� �� ��	: ��ϴ��� > ������� ����
' ��    ��    ��	: �� �� ��
' ��    ��    ��	: 2022/11/09
' ��    ��    ��	: 
' ��    ��    ��	: 
' ��          ��	: 
' ��  ��  ��  ��  :
'*******************************************************************************************
%>
<!-- #include virtual = "/include/Const.inc" -->
<!-- #include virtual = "/include/Odbc.inc" -->
<!-- #include virtual = "/include/Cookies.inc" -->
<!-- #include virtual = "/include/Cm_Function.inc" -->
<!-- #include virtual="/include/DAO/MemberDAO.inc" //-->

<%
  '***********************************************
  '�˻�
  '***********************************************
  Response.Buffer     = TRUE
  Response.Expires    = -1
  Session.CodePage    = 949
  Response.ChaRset    = "EUC-KR"


  Dim member_cd : member_cd = "2"		'ȸ�������ڵ�	1:����, 2:���
  Dim AdminID : AdminID = Request.Cookies("JobPaperAdminKEY")("AdminID")
  
%>


<!--  *************** ���� API SCRIPT *************** -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%=KAKAO_API_KEY_JS%>&libraries=services"></script>

<link rel="stylesheet" type="text/css" href="/css/datepicker/jquery-ui.css" />
<link rel="stylesheet" href="/css/mag.css?v=<%=second(now)%>" type="text/css" />
<link rel="stylesheet" type="text/css" href="/css/popup_new.css?v=<%=second(now)%>" />


<!--  *************** S�������� SCRIPT *************** -->
<script language="javascript" type="text/javascript" src="/js/Certify/biz_join.js?v=<%=second(now)%>"></script>
<!--  *************** E�������� SCRIPT *************** -->
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

  //������ļ���
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
      monthNames: ['1��', '2��', '3��', '4��', '5��', '6��', '7��', '8��', '9��', '10��', '11��', '12��'],
      monthNamesShort: ['1��', '2��', '3��', '4��', '5��', '6��', '7��', '8��', '9��', '10��', '11��', '12��'],
      dayNamesMin: ['��', '��', 'ȭ', '��', '��', '��', '��'],
      changeMonth: true,
      changeYear: true,
      showAnim: 'fadeIn',
      showButtonPanel: true,
      showMonthAfterYear: true,
      yearSuffix: '��',
      closeText: '�ݱ�',
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

    // ���ϵ�� ��ȿ��üũ
    if ($("#file_upload").val() == "") {
      alert("������� ������ ���� ����ڵ�� ����� �Ǵ� ����ڵ���� ������ ÷���� �ּ���.");
      //$('html, body').animate({ scrollTop: $('#file_upload_alert').offset().top - 100 }, 400);
      return;
    } else {
      var ext = $("#file_upload").val().split('.').pop().toLowerCase();
      var maxSize = 2 * 1024 * 1024; // 20MB
      var fileSize = $("#file_upload")[0].files[0].size;

      if ($.inArray(ext, ["jpg", "jpeg", "png"]) == -1 || fileSize > maxSize) {
        alert("���� ���� �� �뷮 Ȯ�� �� �ٽ� ����� �ּ���.\n\n(JPEG, JPG, PNG / �뷮 20M ����)");
        $("#file_upload").val("");
        $(".file_nm").text("");
        $('.upload_file').removeClass('on');
        return;
      } 
    }
    
    // ������� �Է�
    if ($("#company_nm").val() == "") {
      alert("������� �Է��� �ּ���.");
      $("#company_nm").addClass('input_alert');
      $("#company_nm_alert").show();
      $("#company_nm_alert").focus();
      $('html, body').animate({ scrollTop: $('#company_nm_alert').offset().top - 100 }, 400);
      return;
    } else {
      $("#company_nm").removeClass('input_alert');
      $("#company_nm_alert").hide();
    }

    // ������� �Է�
    if ($("#RegisterNo").val() == "") {
      alert("����ڵ�Ϲ�ȣ �Է��� �ּ���.");
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
      alert("��ǥ�ڸ��� �Է��� �ּ���.");
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
          if (retOCR_CODE == "C2") { //�����Ϸ�
            $("#hidOCR_Certification").val("Y");
            
          } else { //���� ����
            $("#hidOCR_Certification").val("N");
          }
          visible_Html($("#hidOCR_Certification").val());
        }
        console.log("���� �ڵ� :" + retOCR_CODE + "| ���� �ؽ�Ʈ :" + retOCR_TXT + "| ���� ������ :" + retOCR_ISSUANCEDATE + "| OCR���� ���� �߸��� ���ϰ� :" + retOCR_RETVAL);

        alert(retOCR_TXT);
        $("#checkBizInfo").css("pointer-events", "auto");
      },
    });
  }

  function get_MemberInfo() {

    if ($("#UserID").val() == "") {
      alert("������� ������ ������ ȸ��ID�� �Է��� �ּ���.");
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
              alert("������ �̿� ���ǡ��� ���� ���� ȸ���Դϴ�.\n\n������ �̿� ���ǡ� �� �̿� ��Ź �帳�ϴ�.");
              $("#UserID").val("");
              $("#UserID").focus();
              $('html, body').animate({ scrollTop: $('#UserID_alert').offset().top - 100 }, 400);
              return;
            } else if (data[0].OUT_YN == "Y" || data[0].RetVal == "1") {
              alert("���ȸ���� �ƴϰų� ���Ե� ���̵� �����ϴ�.");
              $("#UserID").val("");              
              $("#UserID").focus();
              $('html, body').animate({ scrollTop: $('#UserID_alert').offset().top - 100 }, 400);
              return;
            } else if (data[0].REST_YN == "Y") {
              alert("���� �޸�ȸ�� ���·� ���� ��� �̿��� ���ѵǾ� �ֽ��ϴ�. �޸���� ���� �� �̿� ��Ź �帳�ϴ�.");
              $("#UserID").val("");
              $("#UserID").focus();
              $('html, body').animate({ scrollTop: $('#UserID_alert').offset().top - 100 }, 400);
              return;
            } else if (data[0].BAD_YN == "Y") {
              alert("�̿��� ���ѵ� ���̵��Դϴ�.\n\n�ڼ��� ������ ������(080-269-0011)�� ������ �ּ���.");
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

              alert("���� ȸ���Դϴ�.\n\n����ڵ�� ����� �Ǵ� ����ڵ������ ÷���Ͽ� ������� ������ ������ �ּ���.");
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

		alert("���� ����� �Ϸ� �Ǿ����ϴ�.\n\n������� ���� ��ư�� ���� ������ �Ϸ����ּ���.");
	}

	function imgDel() {
		$('.upload_file').removeClass('on');
	}



	function ConfirmSubmit() {

	  if ($("#UserID").val() == "") {
	    alert("������� ������ ������ ȸ��ID�� �Է��� �ּ���.");
	    return;
	  }

	  // ������� �Է�
	  if ($("#company_nm").val() == "") {
	    alert("������� �Է��� �ּ���.");
	    $("#company_nm").addClass('input_alert')
	    $("#company_nm_alert").show();
	    $("#company_nm_alert").focus();
	    $('html, body').animate({ scrollTop: $('#company_nm_alert').offset().top - 100 }, 400);
	    return;
	  } else {
	    $("#company_nm").removeClass('input_alert')
	    $("#company_nm_alert").hide();
	  }

	  // ������� �Է�
	  if ($("#RegisterNo").val() == "") {
	    alert("����ڵ�Ϲ�ȣ�� �Է��� �ּ���.");
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
	    alert("��ǥ�ڸ��� �Է��� �ּ���.");
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
	    alert("ȸ���ּҸ� �Է��� �ּ���.");
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
	    alert("���ּҸ� �Է��� �ּ���.");
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
	    alert("������� ������ �Ϸ���� �ʾҽ��ϴ�.\n\n������� ������ Ȯ���� �ּ���.");
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
      ������� ���� (�ʼ�)
      <a href="javascript:;">������� ���� �ȳ�</a>
    </h3>
    <div class="desc">
      ������ ä��� ������� ������ ���� ���� <strong class="p_color02">��������� ����ڵ�� ����� �Ǵ� ����ڵ����</strong>���� Ȯ���ϰ� �ֽ��ϴ�.
    </div>
    <form id ="frm" name="frm">
      <input type="hidden" name="targetpage" id="targetpage" value="<%=targetpage%>">		<!--����������-->
      <input type="hidden" name="fahost" id="fahost" value="<%=basehost%>">				<!--����ȣ��Ʈ-->
      <input type="hidden" name="hidOCR_Certification" id="hidOCR_Certification" value ="N">
      <input type="hidden" name="hidCUID" id="hidCUID" >
      <input type="hidden" name="COM_ID" id="COM_ID" >
      <input type="hidden" name="hidAdminID" id="hidAdminID" value="<%=AdminID %>">
      <input type="hidden" name="Fax" id="Fax">
      <input type="hidden" name="MAIN_PHONE" id="MAIN_PHONE">

      <div class="cont">
        <div class="form_list">
          <dl>
            <dt>ȸ��ID</dt>
            <dd>
              <ul class="form_area">
                <li>
                  <input type="text" class="input_ty" id="UserID" name="UserID" placeholder="���̵� �Է�">
                  <div id="UserID_alert" class="alert_txt" style="display: none;">������� ������ ������ ȸ��ID�� �Է��� �ּ���.</div>
                </li>
                <li class="btn">
                  <a href="javascript:get_MemberInfo();" class="btn_m btn_ty02">�˻�</a>
                </li>
              </ul>
            </dd>
          </dl>
        </div>
        
        <div class="blt_list circle">
          <ul>
            <li class="mb0">������� ������ ������ ȸ�� ID�� �Է��� �ּ���.</li>
            <li>�ݵ�� �˻� ��ư�� ������ ȸ�� ������ �Ϸ�˴ϴ�.</li>
          </ul>
        </div>
      </div>

      <div class="cont">
        <h4 class="tit">�������</h4>

        <div class="form_list">
          <dl>
            <dt>ȸ���</dt>
            <dd>
              <input type="text" class="input_ty" name="company_nm" id="company_nm" value="<%=com_nm%>" placeholder="ȸ��� �Է�">
              <div id="company_nm_alert" class="alert_txt" style="display: none;">ȸ����� �Է����ּ���.</div>
            </dd>
          </dl>

          <dl>
            <dt>����ڵ�Ϲ�ȣ</dt>
            <dd>
              <input type="text" class="disabled" id="RegisterNo" name="RegisterNo" value="<%=register_no%>" readonly >
              <div id="RegisterNo_alert" class="alert_txt" style="display: none;">����ڵ�Ϲ�ȣ�� �Է����ּ���.</div>
            </dd>
          </dl>

          <dl>
            <dt>��ǥ�ڸ�</dt>
            <dd>
              <input type="text" class="input_ty" name="ceo_nm" id="ceo_nm" value="" placeholder="��ǥ�ڸ� �Է�">
              <div id="ceo_nm_alert" class="alert_txt" style="display: none;">��ǥ�ڸ��� �Է����ּ���.</div>
            </dd>
          </dl>

          <dl>
            <dt>ȸ���ּ�</dt>
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
                  <input type="text" class="input_ty" placeholder="ȸ���ּ� �Է�" readonly="true" name="txtADDRESS_JIBUN" id="txtADDRESS_JIBUN">
                  <input type="hidden" name="txtADDRESS_ROAD" id="txtADDRESS_ROAD" value="" >
                  <a href="javascript:;" class="btn_m btn_ty03" id="btnAddrSearch" onclick="Fn_FindDaumAddress();">�ּҰ˻�</a>
                </div>
                <div id="txtADDRESS_ROAD_alert" class="alert_txt" style="display: none;">ȸ���ּҸ� �Է��� �ּ���.</div>
                <div class="detail">
                  <input type="text" class="input_ty" placeholder="���ּ� �Է�" name="txtADDRESS_JIBUN_DETAIL" id="txtADDRESS_JIBUN_DETAIL">
                  <div id="txtADDRESS_JIBUN_DETAIL_alert" class="alert_txt" style="display: none;">���ּҸ� �Է��� �ּ���.</div>
                </div>
              </div>
              <div id="" class="alert_txt" style="display: none;">ȸ���ּҸ� �Է����ּ���.</div>
            </dd>
          </dl>

        </div>
      </div>


      <div class="cont">
        <h4 class="tit">���� ��� ����</h4>

        <!-- ������� �߰� -->
							<div class="certi_type_wrap">
										<div class="certi_type">
											<dl>
												<dt>
													<input type="radio" name="ra" value="1" id="doc" checked="checked">
													<label for="doc">���� ���� ÷��</label>
												</dt>
												<dd>
													<input type="radio" name="ra" value="2" id="nts">
													<label for="nts">����û ����</label>
												</dd>
											</dl>
										</div>


										<!--��������÷���϶� -->
										<div id="type_wrap_1">
												<div class="upload_file">
													<input type="file" id="file_upload" name="file_upload" onchange="getName($(this))">
													<label for="file_upload">
														<div class="txt">
															���� ���� ÷���ϱ�
														</div>
														<div class="file_nm"></div>
														<a href="javascript:imgDel();" class="img_del"></a>
													</label>
												</div>

												<div class="btn_area">
													<ul>
														<li>
															<a href="javascript:fnCheckBizInfo();" class="btn_l btn_ty03">������� ����</a>
														</li>
														<li>
															<a href="https://www.findjob.co.kr/advertiser/regist_simple_ad_reception.asp" target="_blank" class="btn_l btn_ty">���� ����</a>
														</li>
													</ul>
												</div>

											<!-- �����Ϸ� �� -->
											<div class="btn_area">
												<ul>
													<li>
														<a href="javascript:;" class="btn_l btn_ty04">������� ���� �Ϸ�</a>
													</li>
													<li>
														<a href="https://www.findjob.co.kr/advertiser/regist_simple_ad_reception.asp" target="_blank" class="btn_l btn_ty">���� ����</a>
													</li>
													<li>
														<a href="javascript:fn_nts_BizAPI();" class="btn_l btn_ty04">����û �������</a>
													</li>
												</ul>
											</div>
											<!-- // �����Ϸ� �� -->

											<div class="blt_list circle">
												<ul>
													<li>
														90�� �� �߱��� <strong class="p_color01">����ڵ�� ����� �Ǵ� ����ڵ����</strong>�� ����� �ּ���.<br>
														��, <span class="p_color02">�ֹε�Ϲ�ȣ ���ڸ��� ������� �ʵ��� ó��</span> (ex 991234 - ******* ǥ�� ��)�� �Ǿ� �־�� �մϴ�. (���� ���� : JPEG,JPG,PNG,BMP / �뷮 20M ����)
													</li>
													<li>����ڵ�� ����� : <a href="https://www.gov.kr/mw/AA020InfoCappView.do?HighCtgCD=&CappBizCD=12100000016" target="_blank">�߱� �ٷΰ��� ></a></li>
													<li>����ڵ���� : <a href="https://www.hometax.go.kr/" target="_blank">�߱� �ٷΰ��� ></a></li>
													<li>���� ���� ��� ����, ���� ���� ����ġ, ����ڵ�� �����, ����ڵ���� �� ������ ������ ��û�ϴ� ��� <strong class="p_color03">���� ����</strong> ��ư�� ���� ���Ǹ� �����ּ���.</li>
												</ul>
											</div>
										</div>


										<!-- ����û�����϶� -->
										<div id="type_wrap_2" style="display:none;">
										<div class="nts_certifi">
											<dl class="list_join list_join_media">
												<dt>��������</dt>
                        <dd class="input_s">
													<input type="text" class="inp_txt nts_inp input_ty" name="op_date" id="datepicker" value="" placeholder="YYYY.MM.DD"> 
												</dd>
											</dl>
										</div>

										<div class="btn_area">
												<ul>
													<li>
														<a href="javascript:fnCheckBizInfo();" class="btn_l btn_ty03">������� ����</a>
													</li>
													<li>
														<a href="https://www.findjob.co.kr/advertiser/regist_simple_ad_reception.asp" target="_blank" class="btn_l btn_ty">���� ����</a>
													</li>
												</ul>
											</div>

										<!-- �����Ϸ� �� -->
										<div class="btn_area">
											<ul>
												<li>
													<a href="javascript:;" class="btn_l btn_ty04">������� ���� �Ϸ�</a>
												</li>
												<li>
													<a href="https://www.findjob.co.kr/advertiser/regist_simple_ad_reception.asp" target="_blank" class="btn_l btn_ty">���� ����</a>
												</li>
												<li>
													<a href="javascript:fn_nts_BizAPI();" class="btn_l btn_ty04">����û �������</a>
												</li>
											</ul>
										</div>
										<!-- // �����Ϸ� �� -->
										<div class="blt_list circle">
											<ul>
												<li>
													<strong class="p_color01">����ڵ�� �����</strong> �Ǵ� <strong class="p_color01">����ڵ����</strong>�� <strong class="p_color03">��������</strong>(������, ����������)�� �Է��� �ּ���. 
												</li>
												<li>����ڵ�� ����� : <a href="https://www.gov.kr/mw/AA020InfoCappView.do?HighCtgCD=&CappBizCD=12100000016" target="_blank">�߱� �ٷΰ��� ></a></li>
												<li>����ڵ���� : <a href="https://www.hometax.go.kr/" target="_blank">�߱� �ٷΰ��� ></a></li>
												<li>���� ���� ��� ����, ���� ���� ����ġ, ����ڵ�� �����, ����ڵ���� �� ������ ������ ��û�ϴ� ��� <strong class="p_color03">���� ����</strong> ��ư�� ���� ���Ǹ� �����ּ���.</li>
											</ul>
										</div>
										</div>
								</div>
								<!-- // ������� ���� end -->

      <div class="btn_area confirm">
        <a href="javascript: ConfirmSubmit()" class="btn_l btn_ty02">Ȯ��</a>
      </div>

    </form>
  </div>
 
</div>
  <!-- iOS������ position:fixed ���װ� ����, �����ϴ� ����Ʈ�� �°� position:absolute ���� �̿��Ͽ� top,left�� ���� �ʿ� -->
  <div id="divLayer" style="display:none;position:fixed;overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch;">
    <img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1" onclick="closeDaumPostcode()" alt="�ݱ� ��ư">
  </div>
</body>
 <script type="text/javascript">
   // �����ȣ ã�� ȭ���� ���� element
   var element_layer = document.getElementById('divLayer');

   // �ؽ�Ʈ�ڽ��� ���ڸ� �Է¹ޱ�
   function keyIntCheck2(keep) {
     var keyValue = event.keyCode;

     if ((keyValue <= 95 || keyValue >= 106) && (keyValue <= 47 || keyValue >= 58) && keyValue != 8 && keyValue != 9 && keyValue != 46 && keyValue != 37 && keyValue != 39 && keyValue != 13 && keyValue) {
       if (keyValue != 110) { // .(��)�� ����ó�� (�Ҽ��� ���)
         alert("���ڸ� �Է��� �� �ֽ��ϴ�");
         if (!keep) event.srcElement.value = ''; //������ ���� ����
         event.srcElement.focus();
         return false;
       }
     }
   }

   // ȸ�� �ּ� �˻�
   function Fn_FindDaumAddress(type) {
     new daum.Postcode({
       oncomplete: function (data) {

         var duildingName = ""; // �� �ǹ��� ǥ��
         if (data.buildingName != "") {
           duildingName = "(" + data.buildingName + ")";
         }


         if (data.jibunAddress != "") {
           $("#txtADDRESS_JIBUN").val(data.jibunAddress);
         } else if (data.autoJibunAddress != "") {
           $("#txtADDRESS_JIBUN").val(data.autoJibunAddress);
         }
         // ȸ�����Խÿ��� ���ּ�(addr2)�� �ǹ� �ּ�(road_addr_detail)�� ��������
         if (data.roadAddress != "") {
           $("#hidADDRESS_ROAD").val(data.roadAddress);
           $("#txtADDRESS_JIBUN_DETAIL").val("");
         } else if (data.autoRoadAddress != "") {
           $("#hidADDRESS_ROAD").val(data.autoRoadAddress);
           $("#txtADDRESS_JIBUN_DETAIL").val("");
         }

         // BNAME1�� ���� ������ BNAME1�� ���� ������ BNAME2�� ���� 2020-09-21
         var bname = "";
         if (data.bname1 != "") {
           //$("#hidBname2").val(data.bname1);
           bname = data.bname1;
         }
         else {
           //$("#hidBname2").val(data.bname2);
           bname = data.bname2;
         }
         if (data.sido == "����Ư����ġ��") {
           data.sido = "����";
           data.sigungu = "������";
         }

         if (data.sido == "����Ư����ġ��") {
           data.sido = "����";
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
     // iframe�� ���� element�� ���̰� �Ѵ�.
     element_layer.style.display = 'block';
     // iframe�� ���� element�� ��ġ�� ȭ���� ����� �̵���Ų��.
     initLayerPosition();

   }

   // DAUM API ��ǥ ����
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
         var wgs84_addr = data.WGS84_Addr; //���� �߶��� ��� 5-3 �� ����

         // ������ ������ �ҷ��ö��� ��ǥ�� ���� ����
         if (posType == "Y") {
           $("#hidGPoint_X").val(wgs84_posx);
           $("#hidGPoint_Y").val(wgs84_posy);
         }
       },
       error: function (xhr, status, error) {
         alert("DAUM API ����");
       }
     });
   }

   // �������� ũ�� ���濡 ���� ���̾ ����� �̵���Ű���� �ϽǶ�����
   // resize�̺�Ʈ��, orientationchange�̺�Ʈ�� �̿��Ͽ� ���� ����ɶ����� �Ʒ� �Լ��� ���� ���� �ֽðų�,
   // ���� element_layer�� top,left���� ������ �ֽø� �˴ϴ�.
   function initLayerPosition() {
     var width = 500; //�����ȣ���񽺰� �� element�� width
     var height = 500; //�����ȣ���񽺰� �� element�� height
     var borderWidth = 3; //���ÿ��� ����ϴ� border�� �β�

     // ������ ������ ������ ���� element�� �ִ´�.
     element_layer.style.width = width + 'px';
     element_layer.style.height = height + 'px';
     element_layer.style.border = borderWidth + 'px solid';
     // ����Ǵ� ������ ȭ�� �ʺ�� ���� ���� �����ͼ� �߾ӿ� �� �� �ֵ��� ��ġ�� ����Ѵ�.
     element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width) / 2 - borderWidth) + 'px';
     element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height) / 2 - borderWidth) + 'px';
   }
   // daum �˾�â close
   function closeDaumPostcode() {
     // iframe�� ���� element�� �Ⱥ��̰� �Ѵ�.
     element_layer.style.display = 'none';
   }

   function FnConfirmID() {
     $("#hidIDSearchYN").val("N");
   }



</script>