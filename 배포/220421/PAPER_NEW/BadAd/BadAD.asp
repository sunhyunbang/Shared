<% Option Explicit %>
<%
'*******************************************************************************************
' 단 위 업 무 명  : 허위광고 신고정보 
' 작    성    자  : 여운영
' 작    성    일  : 2014/12/30
' 수    정    자  : 신장순
' 수    정    일  : 2015.06.24
' 내          용  : 1. 파라메터 추가 vSelType : 팝업로드시 신고사유 자동선택값
' 주  의  사  항  : 
' SAMPLE EXECUTE  :
'구인구직   j   param_갯수 : 3
'부동산     l
'자동차     c 
'상품서비스 g
'중고장터   u
'야알바     y
'분양관    b
'*******************************************************************************************
%>
<!-- #include virtual = "/include/Const.inc" -->
<!-- #include virtual = "/include/Odbc.inc" -->
<!-- #include virtual = "/include/Branch.inc" -->
<!-- #include virtual = "/include/Section_Function.inc" -->
<!-- #include virtual = "/include/Cm_Function.inc" -->
<!-- #include virtual ="/include/base64.asp"	//-->
<!-- #include virtual = "/BadAd/BadAD_DAO.inc" -->

<%
Dim setvType : setvType=requestx("vType")
Dim setvAdid : setvAdid=requestx("vAdid")
Dim setvSelType : setvSelType=requestx("vSelType")
Dim arryResult, arryReason   '프로시저 결과배열

if setvType="" then setvType="g"

Dim oTitle  '공고제목
Dim oOwner  '광고주(개인-> 개인, 기업->회사명)
Dim oAGENCYID

Dim setReason   '신고사유 설정

Dim i, LineAdid,IBranchCode,LBranchCode,AdidGubun
Dim clientIP : clientIP = request.serverVariables("REMOTE_HOST")
'Dim UserID : UserID = Request.Cookies("CookieUserKEY")("UserID")
'UserID = strAnsi2Unicode(Base64decode(strUnicode2Ansi(UserID)))

if setvAdid<>"" then

    if setvType="u" then    '중고
        LineAdid       = fn_ADsplit(setvAdid,"|",0)
        IBranchCode    = 0
        LBranchCode    = 0
        AdidGubun      = ""
    elseif setvType="y" then    '야알바
        LineAdid       = fn_ADsplit(setvAdid,"|",0)
        IBranchCode    = 0
        LBranchCode    = 0
        AdidGubun      = fn_ADsplit(setvAdid,"|",1)     '야알바 구분자
    elseif setvType="b" then    '분양관
        LineAdid       = setvAdid
        IBranchCode    = 0
        LBranchCode    = 0
        AdidGubun      = ""
    else
        if instr(setvAdid,"|")>0 then
            LineAdid       = fn_ADsplit(setvAdid,"|",0)
            IBranchCode    = fn_ADsplit(setvAdid,"|",1)
            LBranchCode    = fn_ADsplit(setvAdid,"|",2)
        else
            LineAdid       = setvAdid
            IBranchCode    = 0
            LBranchCode    = 0
        end if
        AdidGubun      = ""
    end if

    arryResult = GET_F_BadAd_LIST_PROC(setvType, LineAdid, IBranchCode, LBranchCode, AdidGubun)
    if isarray(arryResult) then 
        oTitle = arryResult(0,0)
        oOwner = arryResult(1,0)
        oAGENCYID = arryResult(3,0)   '광고주Email
    else
        oTitle = "광고번호" & LineAdid
        oOwner = ""
    end if

    '중고장터&부동산 판매자명 예외처리
    if setvType="u" or ((setvType="l" or setvType="b") And instr(oOwner,"부동")=0 And instr(oOwner,"중개")=0) then
	    Dim strcname
	    For i = 1 to len(oOwner)-2
		    strcname = strcname & "*"
	    Next
	    If Len(oOwner) > 1 Then
		    If Len(oOwner) > 2 Then
			    oOwner = left(oOwner,1) & strcname & right(oOwner,1)
		    Else
			    oOwner = left(oOwner,1) & "*"
		    End If
	    End If
    End If

    '신고사유 표시값 세팅
    Select Case setvType
      Case "j"      '구인구직
        setReason = "1,2,4,5,6,13,15"
      Case "l"      '부동산
        setReason = "1,7,9,13,15"
      Case "v"      '분양관
        setReason = "1,7,9,13,15"
      Case "b"      '분양관
        setReason = "1,7,9,13,15"
      Case "c"      '자동차
        setReason = "1,7,10,13,15"

      Case "g"      '상품
        setReason = "1,7,8,13,15"
      Case "u"      '중고장터
        setReason = "1,7,8,13,15"

      Case "y"      '야알바
        setReason = "1,12,13,15"
    End Select

    arryReason = GET_F_BadAd_Code_TB_PROC(setReason)

else    'pk가 없는 경우 error
    'response.Write "DB error"
    'response.End
end if
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=euc-kr" />
		<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
		<meta name="keywords" content="" />
		<meta name="description" content="" />
		<title>허위정보 신고하기</title>
		<script type="text/javascript" src="/js/jquery-1.9.1.min.js"></script>
		<link rel="stylesheet" type="text/css" href="/css/popup_new.css">

        <style type="text/css" >
        <%'신고호출시 로딩바를 띄움 %>
        .wrap-loading{ /*화면 전체를 어둡게 합니다.*/
            position: fixed;
            left:0;
            right:0;
            top:0;
            bottom:0;
            background: rgba(0,0,0,0.2); /*not in ie */
            filter: progid:DXImageTransform.Microsoft.Gradient(startColorstr='#20000000', endColorstr='#20000000');    /* ie */
        }
            .wrap-loading div{ /*로딩 이미지*/
                position: fixed;
                top:50%;
                left:50%;
                margin-left: -21px;
                margin-top: -21px;
            }
            .display-none{ /*감추기*/
                display:none;
            }

        </style> 

        <script type="text/javascript">
        	$(document).ready(function(){
        		if(window.innerHeight < 700){
        			window.resizeBy(0, 150);
        		}
				  });
            // 웹표준용 스크립트
            function getObject(objectId) {
                if (document.getElementById && document.getElementById(objectId)) {
                    return document.getElementById(objectId);
                }
                else if (document.all && document.all(objectId)) {
                    return document.all(objectId);
                }
                else if (document.layers && document.layers[objectId]) {
                    return document.layers[objectId];
                } else {
                    return false;
                }
            }
            
            function limitTextNum(strElement, size, strTarget) {
                var objElement = getObject(strElement).value;
                var objTarget = getObject(strTarget);
                if (objElement.length > size) {
                    alert(size + "문자까지만 입력가능 합니다");
                    getObject(strElement).value = objElement.substring(0, parseInt(size));
                    objTarget.innerHTML = size;
                    return false;
                }
                objTarget.innerHTML = objElement.length;

            }

            function frmCHK() {
                var f = document.frBadAD;
                
                if (f.callInfo.value == "") {
                    alert("[연락처/신고내용]을(를) 입력해 주세요.");
                    f.callInfo.focus();
                    return false;
                }

                if (f.ReasonCode.value == "") {
                    alert("신고사유를 선택해 주세요.");
                    f.ReasonCode.focus();
                    return false;
                }

                if (f.txtContents.value == "") {
                    alert("[연락처/신고내용]을(를) 입력해 주세요.");
                    f.txtContents.focus();
                    return false;
                }
                
                if (f.check.checked == false){
                	alert("'개인정보 수집 및 이용'에 동의 하셔야 신고 가능 합니다.");
                  f.check.focus();
                  return false;
                }
            }
        </script>

        <script type="text/javascript">

            $(document).ready(function () {
                $("#iptBtn").click(function () {
                    if (frmCHK() != false) {
                        //한글인코딩 변환
                        var param = $("#frBadAD").serialize().replace(/=([^&]*)/g,
                            function ($0, $1) {
                                return "=" + escape(decodeURIComponent($1).replace(/\n/g, "\r\n"))
                            })

                        $.ajax({
                            type: "POST",
                            url: "/BadAd/ajaxBadAD.asp",
                            cache: false,
                            data: param,
                            success: onSuccess

                                        , beforeSend: function () {
                                            $('.wrap-loading').removeClass('display-none');
                                        }
                                        , complete: function () {
                                            $('.wrap-loading').addClass('display-none');
                                        }

                                        , error: onError
                        });
                    }
                    return false;
                });
            });

            function onSuccess(json, status) {
                //alert($.trim(json));
                alert("신고접수가 완료 되었습니다.");
                self.close();
            }

            function onError(data, status) {
                //alert("error");
            }

            function fn_keyCHK(obj) {
              // 정규식 - 이메일 유효성 검사
              var regEmail = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
              // 정규식 -전화번호 유효성 검사
              var regPhone = /^((01[1|6|7|8|9])[1-9]+[0-9]{6,7})|(010[1-9][0-9]{7})$/;

              var txt1 = "휴대폰 번호가 유효하지 않습니다";
              var txt2 = "이메일 주소가 유효하지 않습니다";

              if (obj.value != "") {
                if (obj.value.indexOf("@") == -1) {
                  if (!regPhone.test(obj.value.replace(/-/gi,""))){alert(txt1);obj.focus();return false;}
                } else {
                  if (!regEmail.test(obj.value)){alert(txt2);obj.focus();return false;}
                }
              }
            }

        </script>

		<script type="text/javascript">
		    $(function () {
		        $('input.fr_inp').each(function () {
		            $(this).focus(function () {
		                $(this).css('background', 'none');
		            });

		            $(this).blur(function () {
		                if ($(this)[0].value == '') {
		                    $(this).css('background', 'url(http://image.findall.co.kr/FAImage/PaperNew/popup/inp_false_report.png) no-repeat')
		                }
		            });
		        });
		    });

		    $(function () {
		        $('textarea.fr_txta').each(function () {
		            $(this).focus(function () {
		                $(this).css('background', 'none');
		            });

		            $(this).blur(function () {
		                if ($(this)[0].value == '') {
		                    $(this).css('background', 'url(http://image.findall.co.kr/FAImage/PaperNew/popup/txta_false_report.png) no-repeat')
		                }
		            });
		        });
		    });
		</script>
	</head>

	<body class="none"  onload="self.focus()">
        <form name="frBadAD" id="frBadAD" method="post">
        <input type="hidden" name="ADsection" id="ADsection" value="<%=setvType %>" />
        <input type="hidden" name="LineAdid" id="LineAdid" value="<%=LineAdid %>" /><%'광고번호 %>
        <input type="hidden" name="IBranchCode" id="IBranchCode" value="<%=IBranchCode %>" />
        <input type="hidden" name="LBranchCode" id="LBranchCode" value="<%=LBranchCode %>" />
        <input type="hidden" name="AdidGubun" id="AdidGubun" value="<%=AdidGubun %>" />
        <input type="hidden" name="clientIP" id="clientIP" value="<%=clientIP %>" />
        <input type="hidden" name="AGENCYID" id="AGENCYID" value="<%=oAGENCYID %>" />

        <div class="wrap-loading display-none"><%'신고호출시 로딩바를 띄움 %>
            <div><img src="css/loading.gif" /></div>
        </div>  
        
		<div id="FRWrap">
			<div class="header">
				<h1 class="bg_fr fr_tit"><span class="blind">허위정보 신고하기</span></h1>
			</div>
			
			<div class="body">
				<!-- 상단 -->
				<div class="top">
					<div class="left">
						<span class="bg_fr fr_img"></span>
					</div>
					<div class="right">
						<div class="bg_fr fr_txt"></div>
						<div class="fr_list">
							<ul>
								<li><strong>정확한 사실</strong>만을 기재해 주시기 바랍니다.</li>
								<li><strong>연락처(이메일 또는 휴대폰)</strong>를 반드시 기재해 주시기 바랍니다.</li>
								<li>내용은 예시 문안을 참고하셔서 작성해 주세요.</li>
							</ul>
						</div>
					</div>
				</div>
				<!-- //상단 -->

				<!-- 테이블 -->
				<div class="tbl">
					<div class="mtxt">입력한 연락처는 사실 확인 용도로만 사용되며 신고 업체에는 노출되지 않습니다.</div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" summary="허위정보 신고를 위해 정보를 기재해 주시기 바랍니다.">
						<caption>허위정보 신고 폼</caption>
						<colgroup>
							<col width="107">
							<col width="">
						</colgroup>
						<tbody>
							<tr>
								<th>광고제목</th>
								<td>
                                    <%=oTitle %>
                                </td>
							</tr>
							<tr>
								<th>등록자</th>
								<td><%=oOwner %></td>
							</tr>
							<tr>
								<th>연락처 <span class="bg_fr fr_point"></span></th>
								<td>
									<input type="text" name="callInfo" class="fr_inp" maxlength="50" style="ime-mode:disabled" onblur="fn_keyCHK(this)">
								</td>
							</tr>
							<tr>
								<th>신고사유 <span class="bg_fr fr_point"></span></th>
								<td>
									<select name="ReasonCode">
										<option value="">------- 선택 -------</option>
                                        <%
                                        if isarray(arryReason) then
                        Dim tmpSelected : tmpSelected = ""
                                            for i = 0 to ubound(arryReason,2)
                          tmpSelected = ""
                          If Trim(setvSelType) = Trim(arryReason(0,i)) Then
                            tmpSelected = "selected"
                          End If                          
                                        %>
										<option value="<%=arryReason(0,i) %>" <% =tmpSelected %>><%=arryReason(1,i) %></option>
										<%
                                            next
                                        end if
                                        %>
									</select>
								</td>
							</tr>
							<tr class="last">
								<th>신고내용 <span class="bg_fr fr_point"></span></th>
								<td>
									<textarea colspan="10" rowspan="5" name="txtContents" id="txtContents" class="fr_txta" onkeyup="limitTextNum('txtContents',500,'txtContentsspan')"></textarea>
                                    <p>신고내용을 500자 이내로 입력해주세요. (<span id="txtContentsspan">0</span>/500자)</p>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- //테이블 -->
				<div style="margin-top:10px;padding:10px;border:1px solid #d7d7d7;background-color:#f8f8f8;">
					<p style="font-size:11px;line-height:18px;color:#777"><strong style="font-size:12px;color:#777">개인정보 수집 및 이용 안내(필수)</strong><br />1. 수집 항목 : 이메일, 휴대폰번호<br />2. 수집 · 이용 목적 : 민원 처리 및 결과 회신<br />3. 보유 및 이용 기간 : <strong>신고 접수일로부터 3년</strong></p>
					<div style="padding-top:10px"><label for="" style="font-size:11px;color:#f26522"><input type="checkbox" name="check" style="width:13px;height:13px;margin:0;vertical-align:-2px;" /> (필수) 위 ‘개인정보 수집 및 이용’ 에 동의합니다.</label></div>
				</div>
                <p style="padding-top: 5px;font-size:11px;">* 필수 제공 정보는 허위정보 신고하기에 필요한 최소한의 정보이며, 동의를 해야만 허위정보 신고하기를 이용할 수 있습니다.</p>
			</div>
			<div class="footer">
				<a href="javascript:" id="iptBtn" class="bg_fr fr_bt01"><span class="blind">신고하기</span></a>
				<a href="javascript:self.close();" class="bg_fr fr_bt02"><span class="blind" onclick="self.close();">취소</span></a>
			</div>
		</div>
        </form>
	</body>
</html>