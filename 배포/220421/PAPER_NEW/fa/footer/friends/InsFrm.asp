<%
'===============================================================================================
'1. �ý��۸� 		: ���ε�� �����ϴ�
'2. ���������� 	: ���޹��� �����
'3. �������� 		: InsFrm.asp
'4. ó������ 		:	���޹��� ����� (������ ������)
'5. �ۼ��� 			: �̻�
'6. �ۼ��� 			:	2004.11.25
'7. ���ǻ��� 		:
'8. ��������
'	1) �������� 		:
'	2) ������ 			:
'	3) �������� 		:
'	4) �������� 		:
'9. INC ���ϸ��
'==================================================================================================
Dim strHost			: strHost		= Request("strHost")
%>
<!-- #include virtual = "/include/Cm_Function.inc" //-->
<!-- #include virtual = "/fa/inc/head.inc" //-->
<!-- #include virtual = "/fa/inc/top_main.inc" 	//-->

<!-- #include virtual = "/fa/inc/ServerIP.inc" //-->

<% ' HTTPS ó�� 2019/04/01 S %>
<!-- #include virtual = "/include/RedirectSSL.asp" // HTTPS�� �̵� //-->
<% ' HTTPS ó�� 2019/04/01 E %>

<script language="javascript">
<!--
/*---------------------------------------------------------------------------------------------------------
  ���� check�ϱ�
----------------------------------------------------------------------------------------------------------*/
	function CheckIt(Local)
	{
		var FrmFriends = document.FrmFriends

		if(FrmFriends.txtCompany.value == "")
		{
			alert("ȸ����� �Է��ϼ���");
			FrmFriends.txtCompany.focus();
			return ;
		}

		if(FrmFriends.txtCharge.value == "")
		{
			alert("����ڸ� �Է��ϼ���");
			FrmFriends.txtCharge.focus();
			return;
		}

		if(FrmFriends.txtPhone.value == "")
		{
			alert("����ó�� �Է��ϼ���");
			FrmFriends.txtPhone.focus();
			return;
		}

		if(FrmFriends.txtEmail.value.length != 0 )
		{
			if (FrmFriends.txtEmail.value != "" && FrmFriends.txtEmail.value.match(/[a-zA-Z0-9_@.-]+/g) != FrmFriends.txtEmail.value)
			{
			alert("�̸��� �ּҰ� ����Ȯ�մϴ�.");
			FrmFriends.txtEmail.focus();
			return;
			}
			if (FrmFriends.txtEmail.value != "" && FrmFriends.txtEmail.value.search(/(\S+)@(\S+)\.(\S+)/) == -1 )
			{
			alert("�̸��� �ּҰ� ����Ȯ�մϴ�.");
			FrmFriends.txtEmail.focus();
			return;
			}
		}
		else
		{
			alert("�̸��� �ּҸ� �Է��� �ּ���!");
			FrmFriends.txtEmail.focus();
			return;
		}

		if(FrmFriends.chk_agree.checked == false )
		{
			alert("���޽�û���� ������ ������ �ּ���.");
			FrmFriends.chk_agree.focus();
			return ;
		}

		if(FrmFriends.txtTitle.value =="")
		{
			alert("������ �Է��ϼ���");
			FrmFriends.txtTitle.focus();
			return;
		}

		if(FrmFriends.txaProposal.value == "")
		{
			alert("������ȼ� ������ �Է��ϼ���");
			FrmFriends.txaProposal.focus();
			return;
		}

		//FrmFriends.action = "Insert.asp?Local="  + Local
		//������ ����� �Ʒ� ���� ���� (�ӽ÷� ��������� (1�� ����)
		//FrmFriends.action = "Insert.asp"
		FrmFriends.submit();
	}

/*---------------------------------------------------------------------------------------------------------
  ������ Check(�ݾ�..�������..)
----------------------------------------------------------------------------------------------------------*/
	function NumCheck(FrmFriends)
	{
		var num ="0123456789- ";
		for (var i=0; i<FrmFriends.value.length; i++)
		{
				if(-1 == num.indexOf(FrmFriends.value.charAt(i)))
				{
						alert("���ڸ� �Է°����մϴ�!");
						FrmFriends.value = '';
						return;
				}
		}
	}

/*---------------------------------------------------------------------------------------------------------
  Ư������ ����
---------------------------------------------------------------------------------------------------------*/
	function Restric (m) {

			var x = m;
			var y = x.split(" ")
			var z = y.length
			var t = "";

			for (i=0;i<z;i++)
				t = t+y[i];
			//���鸸 �Է� ����
			if ((t == "") && (z > 1)){
				alert("���鸸 �Է��� �� �����ϴ�!");
				return 0;
			}
			//Ư������ ����
			//����� ����
			if (escape(x).indexOf("%20") >=0) {
				return 1;
			}
			//�׿� Ư������ ���� "(%22),'(%27),%(%25),&(%26), ,(%2C)
			if ((escape(x).indexOf("%22") >=0) || (escape(x).indexOf("%25") >=0) || (escape(x).indexOf("%26") >=0) || (escape(x).indexOf("%27") >=0) || (escape(x).indexOf("%2C") >=0)){
				alert("['],["+'"'+"],[%],[&],[,]�� Ư�����ڴ� �˻���� �Է��� �� �����ϴ�.!");
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

	//������ȼ� ÷��
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
              <td width="200px" style="padding-bottom:8px; text-align: left;"><img src="//image.findall.co.kr/FAImage/All/Foot/Ins_tit01.gif" alt="���޹���"></td>
              <td align="right" valign="bottom" style="font-size:11px;padding-bottom:3px;"><font color="888888"><a href="http://www.findall.co.kr">Home</a>
                |</font> <font color="#222222">���޹���</font></td>
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
              <td><strong>�������</strong>�� ������ �ǻ�Ȱ�� �ʿ��� ������ �����ϰ��� ����մϴ�. </td>
            </tr>
            <tr>
              <td height="18px"><img src="//image.findall.co.kr/FAImage/All/Foot/Ins_icon01.gif"></td>
              <td>���ݺ��� �� ���� ������ �����ϱ� ����, �Բ� �� ��Ʈ�ʸ� ã�� �ֽ��ϴ�.</td>
            </tr>
            <tr>
              <td height="20px"><img src="//image.findall.co.kr/FAImage/All/Foot/Ins_icon01.gif"></td>
              <td><strong>�������</strong>�� ����� ����̳� Ź���� �������� �����ϰ� �ִ� ��Ʈ�ʵ��� ��������
                �����ֽñ� �ٶ��ϴ�.</td>
            </tr>
          </table></td>
      </tr>
      <tr>
        <td style="padding-bottom:8px; text-align: left;"><img src="//image.findall.co.kr/FAImage/All/Foot/Ins_tit03.gif" alt="���� ��û�� ����"></td>
      </tr>
      <tr>
        <td>
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="120px" height="2px" bgcolor="#2B44A2"></td>
              <td bgcolor="#2B44A2" height="2px"></td>
            </tr>
            <tr>
              <td height="30px" bgcolor="#DFF1FA" style="padding-left:15px;"><strong>ȸ��� <span style="color:red;">*</span></strong></td>
              <td style="padding-left:15px;"><table width="100%" height="30px" border="0" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="210px"><input type="text" name="txtCompany" style="width:175px;"></td>
                    <td width="120px" bgcolor="#DFF1FA" style="padding-left:15px;"><strong>���޺о�</strong></td>
                    <td style="padding-left:15px;">
                    	<select name="selSection" style="width:165px;">
	                   		<option value="1">�ε��� ����</option>
	                   		<%'<option value="3">�߰����� ����</option> '������� �ʴ� �׸� ���� 20190514 %>
          							<option value="5">�Ź�������� ����</option>
          							<option value="7">���� ����</option>
          							<option value="9">��Ÿ - ������ ����</option>
          							<option value="10" selected="selected">��Ÿ - ������ ����</option>
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
              <td height="30px" bgcolor="#DFF1FA" style="padding-left:15px;"><strong>����� <span style="color:red;">*</span></strong></td>
              <td style="padding-left:15px;">
	              <table width="100%" height="30px" border="0" cellpadding="0" cellspacing="0">
	                <tr>
	                  <td width="210"><input type="text" name="txtCharge" style="width:175px;" onBlur="CharCheck();"></td>
	                  <td width="120" bgcolor="#DFF1FA" style="padding-left:15px;"><strong>����ó <span style="color:red;">*</span></strong></td>
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
              <td height="30px" bgcolor="#DFF1FA" style="padding-left:15px;"><strong>�ּ� <span style="color:red;">*</span></strong></td>
              <td style="padding-left:15px;"><table width="100%" height="30px" border="0" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="210px"><input type="text" name="txtAddress" style="width:175px;" onBlur="CharCheck();">
                    </td>
                    <td width="120px" bgcolor="#DFF1FA" style="padding-left:15px;"><strong>�̸��� <span style="color:red;">*</span></strong></td>
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
      <!-- 2015-08-25_���� <tr>
        <td class="agree">
	    ȸ���, ����ڸ�, ����ó, �̸���, Ȩ�������ּ� �� �����Ͻ� ������ ���ǳ��뿡 ����Ȯ�� �� �ż��ϰ�  ��Ȯ�� ����� ���� <br />
	  ���� �̿�Ⱓ ���� �����ϰ� ������, <span>�̿��� �ٸ� �������� ������ �ʽ��ϴ�.</span>
	   <label><input type="checkbox" name="chk_agree" value="T" class="chk"> �����մϴ�.</label>
        </td>
      </tr> -->
	  <tr>
	  <td>
			<div class="adregist_h clearfix mt40">
				<h3 class="title">�������� ���� �� �̿�ȳ� (�ʼ�)</h3>
			</div>
			<div class="adregist_agree mt7">
				<div class="panel">
					1. �������� : ��� ���� Ȯ�� �� ���� ���ǿ� ���� ��� ȸ��<br />
					2. �����׸� : ȸ���, ����ڸ�, ����ó, �̸���, �ּ�<br />
					3. �̿� �� �����Ⱓ : <strong>���������Ϸκ��� 3��</strong>
				</div>
				<p class="chk vamfix"><input type="checkbox" name="chk_agree" id="chk_agree" value="T" /><label for="chk_agree">(�ʼ�) �������� ���� �� �̿뿡 �����մϴ�.</label></p>
			</div>
			<p style="padding-top:8px; text-align: left;">* �ʼ� ���� ������ ���� �̿뿡 �ʿ��� �ּ����� �����̸�, ���Ǹ� �ؾ߸� ���񽺸� �̿��� �� �ֽ��ϴ�.</p>
	  </td>
	  </tr>
	  <tr><td height="40">&nbsp;</td></tr>
      <tr>
        <td style="padding-bottom:8px; text-align: left;"><img src="//image.findall.co.kr/FAImage/All/Foot/Ins_tit04.gif" alt="���� ���ȳ���"></td>
      </tr>
      <tr>
        <td>
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="120px" height="2px" bgcolor="#2B44A2"></td>
              <td bgcolor="#2B44A2" height="2px"></td>
            </tr>
            <tr>
              <td height="30px" bgcolor="#DFF1FA" style="padding-left:15px;"><strong>����</strong></td>
              <td style="padding-left:15px;"><input type="text" name="txtTitle" style="width:520px;"></td>
            </tr>
            <tr>
              <td height="1px;" bgcolor="#DADADA"></td>
              <td bgcolor="#DADADA"></td>
            </tr>
            <tr>
              <td height="180px" valign="top" bgcolor="#DFF1FA" style="padding-left:15px;padding-top:9px;"><strong>���Ȼ��׿��</strong></td>
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
