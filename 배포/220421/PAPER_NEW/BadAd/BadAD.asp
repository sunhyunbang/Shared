<% Option Explicit %>
<%
'*******************************************************************************************
' �� �� �� �� ��  : �������� �Ű����� 
' ��    ��    ��  : ���
' ��    ��    ��  : 2014/12/30
' ��    ��    ��  : �����
' ��    ��    ��  : 2015.06.24
' ��          ��  : 1. �Ķ���� �߰� vSelType : �˾��ε�� �Ű���� �ڵ����ð�
' ��  ��  ��  ��  : 
' SAMPLE EXECUTE  :
'���α���   j   param_���� : 3
'�ε���     l
'�ڵ���     c 
'��ǰ���� g
'�߰�����   u
'�߾˹�     y
'�о��    b
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
Dim arryResult, arryReason   '���ν��� ����迭

if setvType="" then setvType="g"

Dim oTitle  '��������
Dim oOwner  '������(����-> ����, ���->ȸ���)
Dim oAGENCYID

Dim setReason   '�Ű���� ����

Dim i, LineAdid,IBranchCode,LBranchCode,AdidGubun
Dim clientIP : clientIP = request.serverVariables("REMOTE_HOST")
'Dim UserID : UserID = Request.Cookies("CookieUserKEY")("UserID")
'UserID = strAnsi2Unicode(Base64decode(strUnicode2Ansi(UserID)))

if setvAdid<>"" then

    if setvType="u" then    '�߰�
        LineAdid       = fn_ADsplit(setvAdid,"|",0)
        IBranchCode    = 0
        LBranchCode    = 0
        AdidGubun      = ""
    elseif setvType="y" then    '�߾˹�
        LineAdid       = fn_ADsplit(setvAdid,"|",0)
        IBranchCode    = 0
        LBranchCode    = 0
        AdidGubun      = fn_ADsplit(setvAdid,"|",1)     '�߾˹� ������
    elseif setvType="b" then    '�о��
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
        oAGENCYID = arryResult(3,0)   '������Email
    else
        oTitle = "�����ȣ" & LineAdid
        oOwner = ""
    end if

    '�߰�����&�ε��� �Ǹ��ڸ� ����ó��
    if setvType="u" or ((setvType="l" or setvType="b") And instr(oOwner,"�ε�")=0 And instr(oOwner,"�߰�")=0) then
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

    '�Ű���� ǥ�ð� ����
    Select Case setvType
      Case "j"      '���α���
        setReason = "1,2,4,5,6,13,15"
      Case "l"      '�ε���
        setReason = "1,7,9,13,15"
      Case "v"      '�о��
        setReason = "1,7,9,13,15"
      Case "b"      '�о��
        setReason = "1,7,9,13,15"
      Case "c"      '�ڵ���
        setReason = "1,7,10,13,15"

      Case "g"      '��ǰ
        setReason = "1,7,8,13,15"
      Case "u"      '�߰�����
        setReason = "1,7,8,13,15"

      Case "y"      '�߾˹�
        setReason = "1,12,13,15"
    End Select

    arryReason = GET_F_BadAd_Code_TB_PROC(setReason)

else    'pk�� ���� ��� error
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
		<title>�������� �Ű��ϱ�</title>
		<script type="text/javascript" src="/js/jquery-1.9.1.min.js"></script>
		<link rel="stylesheet" type="text/css" href="/css/popup_new.css">

        <style type="text/css" >
        <%'�Ű�ȣ��� �ε��ٸ� ��� %>
        .wrap-loading{ /*ȭ�� ��ü�� ��Ӱ� �մϴ�.*/
            position: fixed;
            left:0;
            right:0;
            top:0;
            bottom:0;
            background: rgba(0,0,0,0.2); /*not in ie */
            filter: progid:DXImageTransform.Microsoft.Gradient(startColorstr='#20000000', endColorstr='#20000000');    /* ie */
        }
            .wrap-loading div{ /*�ε� �̹���*/
                position: fixed;
                top:50%;
                left:50%;
                margin-left: -21px;
                margin-top: -21px;
            }
            .display-none{ /*���߱�*/
                display:none;
            }

        </style> 

        <script type="text/javascript">
        	$(document).ready(function(){
        		if(window.innerHeight < 700){
        			window.resizeBy(0, 150);
        		}
				  });
            // ��ǥ�ؿ� ��ũ��Ʈ
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
                    alert(size + "���ڱ����� �Է°��� �մϴ�");
                    getObject(strElement).value = objElement.substring(0, parseInt(size));
                    objTarget.innerHTML = size;
                    return false;
                }
                objTarget.innerHTML = objElement.length;

            }

            function frmCHK() {
                var f = document.frBadAD;
                
                if (f.callInfo.value == "") {
                    alert("[����ó/�Ű���]��(��) �Է��� �ּ���.");
                    f.callInfo.focus();
                    return false;
                }

                if (f.ReasonCode.value == "") {
                    alert("�Ű������ ������ �ּ���.");
                    f.ReasonCode.focus();
                    return false;
                }

                if (f.txtContents.value == "") {
                    alert("[����ó/�Ű���]��(��) �Է��� �ּ���.");
                    f.txtContents.focus();
                    return false;
                }
                
                if (f.check.checked == false){
                	alert("'�������� ���� �� �̿�'�� ���� �ϼž� �Ű� ���� �մϴ�.");
                  f.check.focus();
                  return false;
                }
            }
        </script>

        <script type="text/javascript">

            $(document).ready(function () {
                $("#iptBtn").click(function () {
                    if (frmCHK() != false) {
                        //�ѱ����ڵ� ��ȯ
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
                alert("�Ű������� �Ϸ� �Ǿ����ϴ�.");
                self.close();
            }

            function onError(data, status) {
                //alert("error");
            }

            function fn_keyCHK(obj) {
              // ���Խ� - �̸��� ��ȿ�� �˻�
              var regEmail = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
              // ���Խ� -��ȭ��ȣ ��ȿ�� �˻�
              var regPhone = /^((01[1|6|7|8|9])[1-9]+[0-9]{6,7})|(010[1-9][0-9]{7})$/;

              var txt1 = "�޴��� ��ȣ�� ��ȿ���� �ʽ��ϴ�";
              var txt2 = "�̸��� �ּҰ� ��ȿ���� �ʽ��ϴ�";

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
        <input type="hidden" name="LineAdid" id="LineAdid" value="<%=LineAdid %>" /><%'�����ȣ %>
        <input type="hidden" name="IBranchCode" id="IBranchCode" value="<%=IBranchCode %>" />
        <input type="hidden" name="LBranchCode" id="LBranchCode" value="<%=LBranchCode %>" />
        <input type="hidden" name="AdidGubun" id="AdidGubun" value="<%=AdidGubun %>" />
        <input type="hidden" name="clientIP" id="clientIP" value="<%=clientIP %>" />
        <input type="hidden" name="AGENCYID" id="AGENCYID" value="<%=oAGENCYID %>" />

        <div class="wrap-loading display-none"><%'�Ű�ȣ��� �ε��ٸ� ��� %>
            <div><img src="css/loading.gif" /></div>
        </div>  
        
		<div id="FRWrap">
			<div class="header">
				<h1 class="bg_fr fr_tit"><span class="blind">�������� �Ű��ϱ�</span></h1>
			</div>
			
			<div class="body">
				<!-- ��� -->
				<div class="top">
					<div class="left">
						<span class="bg_fr fr_img"></span>
					</div>
					<div class="right">
						<div class="bg_fr fr_txt"></div>
						<div class="fr_list">
							<ul>
								<li><strong>��Ȯ�� ���</strong>���� ������ �ֽñ� �ٶ��ϴ�.</li>
								<li><strong>����ó(�̸��� �Ǵ� �޴���)</strong>�� �ݵ�� ������ �ֽñ� �ٶ��ϴ�.</li>
								<li>������ ���� ������ �����ϼż� �ۼ��� �ּ���.</li>
							</ul>
						</div>
					</div>
				</div>
				<!-- //��� -->

				<!-- ���̺� -->
				<div class="tbl">
					<div class="mtxt">�Է��� ����ó�� ��� Ȯ�� �뵵�θ� ���Ǹ� �Ű� ��ü���� ������� �ʽ��ϴ�.</div>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" summary="�������� �Ű� ���� ������ ������ �ֽñ� �ٶ��ϴ�.">
						<caption>�������� �Ű� ��</caption>
						<colgroup>
							<col width="107">
							<col width="">
						</colgroup>
						<tbody>
							<tr>
								<th>��������</th>
								<td>
                                    <%=oTitle %>
                                </td>
							</tr>
							<tr>
								<th>�����</th>
								<td><%=oOwner %></td>
							</tr>
							<tr>
								<th>����ó <span class="bg_fr fr_point"></span></th>
								<td>
									<input type="text" name="callInfo" class="fr_inp" maxlength="50" style="ime-mode:disabled" onblur="fn_keyCHK(this)">
								</td>
							</tr>
							<tr>
								<th>�Ű���� <span class="bg_fr fr_point"></span></th>
								<td>
									<select name="ReasonCode">
										<option value="">------- ���� -------</option>
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
								<th>�Ű��� <span class="bg_fr fr_point"></span></th>
								<td>
									<textarea colspan="10" rowspan="5" name="txtContents" id="txtContents" class="fr_txta" onkeyup="limitTextNum('txtContents',500,'txtContentsspan')"></textarea>
                                    <p>�Ű����� 500�� �̳��� �Է����ּ���. (<span id="txtContentsspan">0</span>/500��)</p>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- //���̺� -->
				<div style="margin-top:10px;padding:10px;border:1px solid #d7d7d7;background-color:#f8f8f8;">
					<p style="font-size:11px;line-height:18px;color:#777"><strong style="font-size:12px;color:#777">�������� ���� �� �̿� �ȳ�(�ʼ�)</strong><br />1. ���� �׸� : �̸���, �޴�����ȣ<br />2. ���� �� �̿� ���� : �ο� ó�� �� ��� ȸ��<br />3. ���� �� �̿� �Ⱓ : <strong>�Ű� �����Ϸκ��� 3��</strong></p>
					<div style="padding-top:10px"><label for="" style="font-size:11px;color:#f26522"><input type="checkbox" name="check" style="width:13px;height:13px;margin:0;vertical-align:-2px;" /> (�ʼ�) �� ���������� ���� �� �̿롯 �� �����մϴ�.</label></div>
				</div>
                <p style="padding-top: 5px;font-size:11px;">* �ʼ� ���� ������ �������� �Ű��ϱ⿡ �ʿ��� �ּ����� �����̸�, ���Ǹ� �ؾ߸� �������� �Ű��ϱ⸦ �̿��� �� �ֽ��ϴ�.</p>
			</div>
			<div class="footer">
				<a href="javascript:" id="iptBtn" class="bg_fr fr_bt01"><span class="blind">�Ű��ϱ�</span></a>
				<a href="javascript:self.close();" class="bg_fr fr_bt02"><span class="blind" onclick="self.close();">���</span></a>
			</div>
		</div>
        </form>
	</body>
</html>