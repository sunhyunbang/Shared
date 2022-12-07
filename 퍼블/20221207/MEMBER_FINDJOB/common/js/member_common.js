
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


  	var pageAllSelect = $('.opt_select select')
  	$(pageAllSelect).each(function () {
  		var selectTxt = $(this).children('option:selected').text();
  		$(this).parent().children('.txt').text(selectTxt);
  	});
  	$(pageAllSelect).change(function () {
  		var thisTxt = $(this).children('option:selected').text();
  		$(this).parent().children('.txt').text(thisTxt);
  	});
  	$('.lab_radio input:checked').parent().addClass('on');
  	$('.lab_radio').click(function(){
  		var myLabel = $(this).attr('for');
  		var name = $('#'+myLabel).attr('name');
  		$('input[name="'+name+'"]').each(function(){
  			var myInputCheck = $(this).attr('id');
  			if (myLabel == myInputCheck){
  				$(this).parent().parent().addClass('on');
  				$(this).prop('checked',true);
  			}else{
  				$(this).parent().parent().removeClass('on');
  				$(this).prop('checked',false);
  			}
  		})
  	})
  	$('.lab_check input:checked').parent().addClass('on');
  	$('.lab_check .ico input:checked').parent().parent().addClass('on');
  	$('.lab_check').click(function(){
      var checkIdx = $(".list_check input[type='checkbox']").length;
      var checkTotal = $(".list_check input[type='checkbox']:checked").length;
  		var checkedCK = $(this).children('.ico').children('input').is(':checked');
  		var allCheckedCK = $(this).hasClass('lab_check_all');
  		if (allCheckedCK == true){
  			var myLabel = $(this).attr('for');
  			var name = $('#'+myLabel).attr('name');
  			if(checkedCK == true){
  				$(this).addClass('on');
  				$('input[name="'+name+'"]').each(function(){
  					$(this).parent().parent().addClass('on');
  					$(this).prop('checked',true);
  				});
  			}else{
  				$(this).removeClass('on');
  				$('input[name="'+name+'"]').each(function(){
  					$(this).parent().parent().removeClass('on');
  					$(this).prop('checked',false);
  				});
  			}
  		}else{
			if (checkIdx == checkTotal){
			  $(".lab_check_all").addClass("on");
			  $(".lab_check_all").children('.ico').children('input').prop('checked',true);
			  if(checkedCK == true){
				$(this).addClass('on');
			  }else{
				$(this).removeClass('on');
				$(".lab_check_all").removeClass("on");
				$(".lab_check_all").children('.ico').children('input').prop('checked',false);
			  }
			}
			else{
			  if(checkedCK == true){
				$(this).addClass('on');
			  }else{
				$(this).removeClass('on');
				$(".lab_check_all").removeClass("on");
				$(".lab_check_all").children('.ico').children('input').prop('checked',false);
			  }
			}          
  		}
  	});

	var emailAllCheckTarget = $('.emailAllCheck');
	var emailCheckTarget = $('.emailCheck');
	$(emailAllCheckTarget).change(function(){
		var emailCheckNum = $('.emailCheck:checked').length;
		if($(this).is(':checked') == true){
			$(emailCheckTarget).prop('checked',true).parent().parent().addClass('on');
			$('#boxEmailCheck').show();
		}else{
			$(emailCheckTarget).prop('checked',false).parent().parent().removeClass('on');
			$('#boxEmailCheck').hide();
		}
	})
	$(emailCheckTarget).change(function(){
		var allLength = $(emailCheckTarget).length;
		var emailCheckNum = $('.emailCheck:checked').length;
		if (emailCheckNum == allLength){
			$(emailAllCheckTarget).prop('checked',true);
		}else if (emailCheckNum == 0){
			$('#boxEmailCheck').hide();
			$(emailAllCheckTarget).prop('checked',false);
			$(emailAllCheckTarget).parent().parent().removeClass('on')
		}else{
		}
	});
  });

  // 앞자리 0값 채우기
  function SetZeros(num, digits) {
    var Zeros = '';

    if (num == '') {
      return '';
    }else{
      num = num.toString();

      if (num.length < digits) {
        for (i = 0; i < digits - num.length; i++)
          Zeros += '0';
      }

      return Zeros + num;
    }
  }

  // 이메일 도메인 셋팅
  function setDomain(sObj, tObj){
    $("#"+ tObj).val($("#"+ sObj.id).val());
  }

  // SMS본인인증
  function fn_MobileCert_Popup() {

    // parameter frm 사용안함(무조건 form_chk 사용)
    var popupChk = window.open('/common/blank.htm', 'popupChk', 'width=500, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');

    document.frmPhone.action = "https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb";
    document.frmPhone.target = "popupChk";
    document.frmPhone.submit();
    return false;
  }

  // SMS본인인증(App)
  function fn_MobileCert_Popup_App() {

    if ($("input[name=param_r3]").val() == "idfind") {
      $("input[name=param_r3]").val($("input[name=param_r3]").val() + "|_|" + $("input[name=hidBizNo]").val() + "|_|" + $("input[name=TargetPage]").val());
    } else if ($("input[name=param_r3]").val() == "pwfind") {
      $("input[name=param_r3]").val($("input[name=param_r3]").val() + "|_|" + $("input[name=biznumber]").val() + "|_|" + $("input[name=userid]").val() + "|_|" + $("input[name=TargetPage]").val());
    } else if ($("input[name=param_r3]").val() == "HpCert") {
      $("input[name=param_r3]").val($("input[name=param_r3]").val() + "|_|" + $("input[name=userid]").val() + "|_|" + $("input[name=cuid]").val() + "|_|" + $("input[name=TargetPage]").val());
    }

    document.frmPhone.action = "https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb";
    document.frmPhone.submit();
    return false;

  }

  // IPIN본인인증
  function fn_IpinCert_Popup() {

    // parameter frm 사용안함(무조건 frmIPin 사용)
    var popupChk = window.open('/common/blank.htm', 'popupChk', 'width=445, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');

    // 1) IE11에서 Form Submit할 데이터를 LocalStorage에 넣는다.
    if (!!navigator.userAgent.match(/Trident.*rv\:11\./)) {
      // 서브밋할때 팝업창이 아닌 탭으로 열릴시 적용해본다.. (검증필요)
      //document.frmIPin.action = "/join/common/ipin_bridge.asp";
      document.frmIPin.action = "https://cert.vno.co.kr/ipin.cb";
    } else {
      document.frmIPin.action = "https://cert.vno.co.kr/ipin.cb";
    }

    document.frmIPin.target = "popupChk";
    document.frmIPin.submit();
    return false;
  }

  // IPIN본인인증(App)
  function fn_IpinCert_Popup_App() {

    if ($("input[name=param_r3]").val() == "idfind") {
      $("input[name=param_r3]").val($("input[name=hidBizNo]").val() + "|_|" + $("input[name=TargetPage]").val());
    } else if ($("input[name=param_r3]").val() == "pwfind") {
      $("input[name=param_r3]").val($("input[name=biznumber]").val() + "|_|" + $("input[name=userid]").val() + "|_|" + $("input[name=TargetPage]").val());
    } else if ($("input[name=param_r3]").val() == "HpCert") {
      $("input[name=param_r3]").val($("input[name=userid]").val() + "|_|" + $("input[name=cuid]").val() + "|_|" + $("input[name=TargetPage]").val());
    }

    document.frmIPin.action = "https://cert.vno.co.kr/ipin.cb";
    document.frmIPin.submit();
    return false;

  }

  //사업자 번호 체크
  function isBizNo(s_v1, s_v2, s_v3) {

    if (s_v1 == "" || s_v2 == "" || s_v3 == "") return false;
    if (s_v1.length != 3) return false;
    if (s_v2.length != 2) return false;
    if (s_v3.length != 5) return false;

    // 형식체크
    var num = (s_v1 + s_v2 + s_v3); 	//사업자등록번호를 붙입니다.
    var w_c, w_e, w_f, w_tot;

    w_c = num.charAt(8) * 5; 		// 9번째자리의 숫자에 5를 곱한다.
    w_e = parseInt((w_c / 10), 10); 	// 10으로 나누고 10진수 형태의 숫자형으로 ..나눈몫
    w_f = w_c % 10; 					// 10으로 나눈 나머지.
    w_tot = num.charAt(0) * 1;
    w_tot += num.charAt(1) * 3;
    w_tot += num.charAt(2) * 7;
    w_tot += num.charAt(3) * 1;
    w_tot += num.charAt(4) * 3;
    w_tot += num.charAt(5) * 7;
    w_tot += num.charAt(6) * 1;
    w_tot += num.charAt(7) * 3;
    w_tot += num.charAt(9) * 1;
    w_tot += (w_e + w_f);
    if (!(w_tot % 10)) {				// 10으로 나누어 지면 true를 그렇지 않으면 false
      return true;
    } else {
      return false;
    }
  }

  // 숫자만 입력(onkeyup, onblur, oncharge 이용)
  function onlyNumber(obj) {
    var objEv = obj;
    var numPattern = /([^0-9])/;
    numPattern = objEv.value.match(numPattern);
    if (numPattern != null) {
      alert("숫자만 입력할 수 있습니다");
      objEv.value = "";
      objEv.focus();
      return false;
    }
    return true;
  }

  // 텍스트박스내 숫자만 입력받기
  function keyIntCheck() {
    var keyValue = event.keyCode;

    if ((keyValue <= 95 || keyValue >= 106) && (keyValue <= 47 || keyValue >= 58) && keyValue != 8 && keyValue != 9 && keyValue != 46 && keyValue != 37 && keyValue != 39 && keyValue != 13 && keyValue) {
      if (keyValue != 110) { // .(점)은 예외처리 (소수점 허용)
        alert("숫자만 입력할 수 있습니다");
        event.srcElement.value = '';
        event.srcElement.focus();
        return false;
      }
    }
  }






  