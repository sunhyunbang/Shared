
<%
'*******************************************************************************************
' 단 위 업 무 명  : 등록폼 모듈 - 모집정보
' 작    성    자  : 최 봉 기 (virtualman@mediawill.com)
' 작    성    일  : 2013/07/15
' 수    정    자  :
' 수    정    일  :
' 내          용  :
' 주  의  사  항  : AdForm_Dimension.inc(공고등록 공통 변수선언부)를 반드시 연계할 것
' SAMPLE EXECUTE  :
'*******************************************************************************************
%>
<%' strFormType(등록/수정폼 타입)이 정의되어있지 않으면 오류 또는 진행안함.
On Error Resume Next

  If strFormType = "" Then
	response.write 123
	response.end

    Response.Write "<strong><font color=""red"">**************************************** "& Request.Servervariables("SCRIPT_NAME") &" 페이지 상단에 FormType을 정의하시오. ****************************************</font></strong>"
    Response.End
  End If
On Error goto 0

%>
<%
'/********************************** 변수 선언부 **********************************/
Dim ADF3_SelectFindCodeNm
Dim ADF3_i
Dim ADF3_j
Dim ADF3_AreaCnt

Dim ADF3_UnitPayVal
Dim ADF3_txtECName  : ADF3_txtECName = ""

Dim ADF3_strRS_FINDCODE : ADF3_strRS_FINDCODE = ""
Dim ADF3_WORKTIMEFROM_Hour
Dim ADF3_WORKTIMEFROM_Min
Dim ADF3_WORKTIMETO_Hour
Dim ADF3_WORKTIMETO_Min

Dim ADF3_WORKTIMEFROM_Min_Max
Dim ADF3_WORKTIMETO_Min_Max

Dim ADF3_PointChk
Dim ADF3_EcData
'******** 데이터값 테스트 영역 : 시작 ********

'rsECDATA(1) = 1
'rsECDATA(2) = 1
'rsECDATA(3) = 1
'rsECDATA(4) = 1
'rsECDATA(5) = 1
'rsECDATA(6) = 1
'rsECDATA(7) = 1
'rsECDATA(8) = 1
'rsECDATA(9) = 1
'rsECDATA(10) = 0
'rsECDATA(11) = 0
'rsECDATA(12) = 0
'rsECDATA(13) = 0
'rsECDATA(14) = 0
'rsECDATA(15) = 0
'rsECDATA(16) = 0
'rsECDATA(17) = 0
'rsECDATA(18) = 0
'rsECDATA(19) = 0
'rsECDATA(20) = 0

'******** 데이터값 테스트 영역 : 끝  ********
%>
<%
ADF3_PointChk = "N"
If rsGMAP_X <> "0" And rsGMAP_X <> "" And ADF3_PointChk <> "" Then
  ADF3_PointChk = "Y"
End If

ADF3_EcData = ""
For ADF3_i = 1 To 20
  If ADF3_EcData = "" Then
    ADF3_EcData = rsECDATA(ADF3_i)
  Else
    ADF3_EcData = ADF3_EcData & "," & rsECDATA(ADF3_i)
  End If
Next

' 근무지역 개수 등록개수
ADF3_AreaCnt = 1

For ADF3_i = 1 to UBOUND(rsarrAREA_A)
	If Len(rsarrAREA_A(ADF3_i)) > 0 And ADF3_i > 1 Then
		ADF3_AreaCnt = ADF3_AreaCnt + 1
	End If
Next

' 유흥분류 제외(공고불러오기 경우가 있어서..)
' 2015.04.27, 김현정차장 요청, 구인분류 이외 분류도 제외
For ADF3_i = 1 To 10
  If Trim(rsFINDCODE(ADF3_i)) <> "" Then
    If Left(Trim(rsFINDCODE(ADF3_i)), 3) = "490" Or Left(Trim(rsFINDCODE(ADF3_i)), 1) <> "4" Then
      rsFINDCODE(ADF3_i) = ""
      rsFINDCODENAME(ADF3_i) = ""
    End If
  End If
Next

' 모집인원이 숫자값이 아닌경우 값을 비움.
IF Not IsNumeric(rsFIELD_3) Then
  rsFIELD_3 = ""
End If

'근무지역 1번째 기준 지역제한 해제 지점코드(지점코드에 추가하면 근무지역 제한이 해제됨)
'2014.05.22, 대구,부산,미디어윌(본사),경남IC,경북IC등 5곳이 제한해제 됨
'2014.06.05, 김현정차장 요청, 대전,본부시장개발팀 추가
Dim ADF3_AddrNotBranchCode
ADF3_AddrNotBranchCode = "11,12,25,80,83,94"

' 근무기간 빈값 셋팅
rsSERVICE_PERIOD  = GetEmptyChange(rsSERVICE_PERIOD,"")

' 인근지하철 존재여부
rsSUBWAYF = GetEmptyChange(rsSUBWAYF,"0")

' 인근대핵교 존재여부
rsUNIVERSITYF = GetEmptyChange(rsUNIVERSITYF,"0")
%>
	<input type="hidden" name="intHopeAreaCnt"          id="intHopeAreaCnt" value="<%=ADF3_AreaCnt%>" >
	<input type="hidden" name="strArea1_BF"             id="strArea1_BF" value="<%=rsarrAREA_A(1)%>">
	<input type="hidden" name="strArea2_BF"             id="strArea2_BF" value="<%=rsarrAREA_B(1)%>">
	<input type="hidden" name="strArea3_BF"             id="strArea3_BF" value="<%=rsarrAREA_C(1)%>">
	<input type="hidden" name="strAreaDetail_BF"        id="strAreaDetail_BF" value="<%=rsarrAREA_DETAIL(1)%>">
  <input type="hidden" name="strAreaCode_BF"          id="strAreaCode_BF" value="<%=rsarrAREA_C_CODE(1)%>">
  <input type="hidden" name="strAreaCode2_BF"         id="strAreaCode2_BF" value="<%=rsarrAREA_C_CODE(2)%>">
  <input type="hidden" name="strAreaCode3_BF"         id="strAreaCode3_BF" value="<%=rsarrAREA_C_CODE(3)%>">
  <input type="hidden" name="hidPoint_X"              id="hidPoint_X" value="<%=rsMAP_X%>">
  <input type="hidden" name="hidPoint_Y"              id="hidPoint_Y" value="<%=rsMAP_Y%>">
  <input type="hidden" name="hidGPoint_X"             id="hidGPoint_X" value="<%=rsGMAP_X%>">
  <input type="hidden" name="hidGPoint_Y"             id="hidGPoint_Y" value="<%=rsGMAP_Y%>">
  <input type="hidden" name="hidRV_PANOID"            id="hidRV_PANOID" value="<%=rsRV_PANOID%>">
  <input type="hidden" name="hidRV_ANGLEID"           id="hidRV_ANGLEID" value="<%=rsRV_ANGLEID%>">
	<input type="hidden" name="hidPointChk"             id="hidPointChk" value="<%=ADF3_PointChk%>">
  <input type="hidden" name="hidAddrNotBranchCode"    id="hidAddrNotBranchCode" value="<%=ADF3_AddrNotBranchCode%>">

  <input type="hidden" id="hidSubWayCode1" value="<%=rsSUBWAY_CODE(1)%>">
  <input type="hidden" id="hidSubWayCode2" value="<%=rsSUBWAY_CODE(2)%>">
  <input type="hidden" id="hidSubWayCode3" value="<%=rsSUBWAY_CODE(3)%>">
  <input type="hidden" id="hidSubWayCode4" value="<%=rsSUBWAY_CODE(4)%>">
  <input type="hidden" id="hidSubWayCode5" value="<%=rsSUBWAY_CODE(5)%>">
<%
      
  Dim ADF3_AreaA1, ADF3_AreaB1, ADF3_AreaC1, ADF3_AreaCCode1
  Dim ADF3_AreaA2, ADF3_AreaB2, ADF3_AreaC2, ADF3_AreaCCode2
  Dim ADF3_AreaA3, ADF3_AreaB3, ADF3_AreaC3, ADF3_AreaCCode3

  For ADF3_i = 0 To ADF3_AreaCnt - 1
    ADF3_j = ADF3_i + 1

    Select Case ADF3_j
      Case "1":
        ADF3_AreaA1 = rsarrAREA_A(ADF3_j)
        ADF3_AreaB1 = rsarrAREA_B(ADF3_j)
        ADF3_AreaC1 = rsarrAREA_C(ADF3_j)
        ADF3_AreaCCode1 = rsarrAREA_C_CODE(ADF3_j)
      Case "2":
        ADF3_AreaA2 = rsarrAREA_A(ADF3_j)
        ADF3_AreaB2 = rsarrAREA_B(ADF3_j)
        ADF3_AreaC2 = rsarrAREA_C(ADF3_j)
        ADF3_AreaCCode2 = rsarrAREA_C_CODE(ADF3_j)
      Case "3":
        ADF3_AreaA3 = rsarrAREA_A(ADF3_j)
        ADF3_AreaB3 = rsarrAREA_B(ADF3_j)
        ADF3_AreaC3 = rsarrAREA_C(ADF3_j)
        ADF3_AreaCCode3 = rsarrAREA_C_CODE(ADF3_j)
    End Select
  Next

%>

<!--section2-->
<div class="section step2_1" id="t2">
  <h2 class="section__title">어떤 직원을 모집하나요?</h2>
   <div class="section__content">
    <div class="section__division">
      <!--제목-->
      <dl class="article article--title">
        <dt class="article__tit essential">제목 <span class="emphasis--orange">*</span></dt>
        <dd class="article__con">
          <div class="inp-txt__wrap">
            <input type="text" name="txtTitle" id="txtTitle" class="inp-txt" onkeyup="chkword(this)" maxlength="50" value="<%=Left(rsTITLE,60)%>">
						<input type="hidden"  id="hidTitle" name="hidTitle" value="<%=Left(rsTITLE,60)%>">
            <div class="counter"><span class="num">0</span>/50</div>
          </div>
          <dl class="view-caution">
            <dt class="view-caution__tit"><span class="ico ico--attention--red"></span>반드시 지켜주세요!</dt>
            <dd class="view-caution__con">* 채용공고에 특정 <strong>성별</strong>이나 <strong>연령</strong>을 표기하는 경우 채용공고를 등록한 <strong>광고주에게 벌금</strong>이 부과될 수 있습니다.</dd>
            <dd>
              <ul class="view-additional--List">
                <li>- 제목 입력 시 <span>- + ( ) [ ] % & , . ㈜ ㈔ ‘ / @ : ~</span> 제외한 특수문자는 입력해도 노출되지 않습니다.</li>
                <li>- 허위/과대표현 - 최고대우,고수입,선불 등 - 공고는 5년 이하의 징역 또는 5천만원 이하의 벌금이 부과될 수 있으며, 별도 통보없이 내용 수정 및 삭제될 수 있습니다.</li>
              </ul> 
            </dd>
          </dl>
        </dd>
      </dl>
      <!--//제목-->
      <!--업직종-->
      <dl class="article article--jobCategory"><!--유효값없을때 invalid class추가-->
        <dt class="article__tit essential">업직종 <span class="emphasis--orange">*</span><br><button type="button" class="btn--refresh" onclick="SetWorkKeywordReset();"><span class="ico ico--refresh--gray"></span> 초기화</button></dt>
        <dd class="article__con">
				<% IF FnLen(rsFINDCODE(1)) = 0 Then %>
					<div class="keywordBox" onclick="keywordBox(this)">
				<% ELSE %>
					<div class="keywordBox valued" onclick="keywordBox(this)">
				<% End If %>
        <%
          'Dim FIND_POPUP_COOKIE : FIND_POPUP_COOKIE = Request.Cookies("FIND_POPUP")("WEEK_YN")
          'IF FIND_POPUP_COOKIE = "" Then
            'FIND_POPUP_COOKIE = "N"
          'END IF
        %>
        <input type="hidden" id="hidFind1DepthYN"			name="hidFind1DepthYN" value="N">
				<%
  				For ADF3_i = 1 To 10
						' FINDCODE가 중복으로 나올경우 하나만 노출되록 처리
						If InStr(ADF3_strRS_FINDCODE, rsFINDCODE(ADF3_i)) > 0 Then
							Response.Write "<input type=""hidden"" id=""hidFindcode"& ADF3_i &""" name=""hidFindcode"& ADF3_i &""" value="""">"&vblf
							Response.Write "<input type=""hidden"" id=""hidFindName"& ADF3_i &""" name=""hidFindName"& ADF3_i &""" value="""">"&vblf
						Else
							ADF3_strRS_FINDCODE = ADF3_strRS_FINDCODE & "," & rsFINDCODE(ADF3_i)

							If Not IsNull(rsFINDCODE(ADF3_i)) And Not IsNull(rsFINDCODENAME(ADF3_i)) Then
								Response.Write "<input type=""hidden"" id=""hidFindcode"& ADF3_i &""" name=""hidFindcode"& ADF3_i &""" value="""& rsFINDCODE(ADF3_i) &""">"&vblf
								Response.Write "<input type=""hidden"" id=""hidFindName"& ADF3_i &""" name=""hidFindName"& ADF3_i &""" value="""& rsFINDCODENAME(ADF3_i) &""">"&vblf
							Else
								Response.Write "<input type=""hidden"" id=""hidFindcode"& ADF3_i &""" name=""hidFindcode"& ADF3_i &""" value="""">"&vblf
								Response.Write "<input type=""hidden"" id=""hidFindName"& ADF3_i &""" name=""hidFindName"& ADF3_i &""" value="""">"&vblf
							End If
						End If
  				Next
  		  %>
            <!-- 선택값 노출 항목-->
            <ul id="totalTag_list">
             
            </ul>
            <!-- //선택값 노출 항목-->
            <button class="keywordBox__btn" id="btnJobFind" type="button" onclick="openLayer('layerCategory');"><span class="txt">전체업직종</span><span class="ico ico--dropdown"></span></button>
          </div>
          <!--업직종선택 팝업-->
          <div id="layerCategory" class="layer--jobCategory">
						<input type="hidden" id="hidCate"			name="hidCate" value="">
            <input type="hidden" id="hidSecondCate"			name="hidSecondCate" value="">
						<input type="hidden" id="hidCateCnt"  name="hidCateCnt"   value="">
						<input type="hidden" id="hidKeyCode"  name="hidKeyCode"   value="">
						<input type="hidden" id="hidTopVal"		name="hidTopVal"   value="">
						<input type="hidden" name="hidUpKeyCnt" id="hidUpKeyCnt" value="0"/>
						<input type="hidden" name="hidClickConfirm" id="hidClickConfirm" value="N"/>

            <!--jobCategory-->
            <div class="jobCategory">
              <!--jobCategory__top-->
              <div class="jobCategory__top clr_float">
                <h2>업직종 선택</h2>
                <!--search-form-->
                <div class="search-form">
                  <span class="inp-txt__wrap">
                    <input type="type" class="inp-txt" id="txtCate" name="txtCate" value="" placeholder="업직종을 입력해주세요. 예 : 요리 서빙 등">
                    <button type="button"><span class="ico ico--search">검색버튼</span></button>
                  </span>
									<!-- 검색한 업직종-->
                  <div id="chain_search" class="searchWord" style="display:none;">
									 <h3 class="searchWord__tit">업직종 검색</h3>
                    <div class="searchWord__con mCustomScrollbar">
                      <ul id="chain_list">
 
                      </ul>
                    </div>
                    <div class="jobCategory_close">
                      <button type="button" onclick="$('#chain_search').hide();">닫기<span class="ico ico--popup--close--small"></span></button>
                    </div>
                  </div>
                  <!--//검색한 업직종-->

                </div>
                <!--search-form-->

              </div>
              <!--jobCategory__top-->
              <!--select-job-->
              <div class="job_choose">
                <dl class="first_step">
                  <dt>대분류</dt>
                  <dd class="mCustomScrollbar">
                    <ul class="list" >
                      <li id="fCate401" cate_a_code="401" cate_a_name="요리/서빙"><a href="javascript:;">요리/서빙</a></li>
                      <li id="fCate402" cate_a_code="402" cate_a_name="생산/기술/건설"><a href="javascript:;">생산/기술/건설</a></li>
                      <li id="fCate403" cate_a_code="403" cate_a_name="운전/배달"><a href="javascript:;">운전/배달</a></li>
                      <li id="fCate404" cate_a_code="404" cate_a_name="매장관리"><a href="javascript:;">매장관리</a></li>
                      <li id="fCate405" cate_a_code="405" cate_a_name="일반서비스/기타"><a href="javascript:;">일반서비스/기타</a></li>
                      <li id="fCate406" cate_a_code="406" cate_a_name="간호/의료"><a href="javascript:;">간호/의료</a></li>
                      <li id="fCate407" cate_a_code="407" cate_a_name="사무/경리"><a href="javascript:;">사무/경리</a></li>
                      <li id="fCate408" cate_a_code="408" cate_a_name="상담/영업"><a href="javascript:;">상담/영업</a></li>
                      <li id="fCate409" cate_a_code="409" cate_a_name="교사/강사"><a href="javascript:;">교사/강사</a></li>
                    </ul>
                  </dd>
                </dl>

                <dl class="second_step">
                  <dt>중분류 (최대 3개)</dt>
                  <dd class="mCustomScrollbar">
                    <span class="no_list" style="display:block;">대분류 선택시<br>중분류를 선택 할 수 있습니다.</span>
                    <!-- <ul class="list" style="display:block;">
                      <li class="on"><a href="#">주방/주방보조</a></li>
                    </ul> -->
                  </dd>
                </dl>

                <dl class="third_step">
                  <dt>소분류 (최대 10개)</dt>
                  <dd class="mCustomScrollbar">
                    <span class="no_list" style="display:block;">중분류 선택시<br>소분류를 선택 할 수 있습니다.</span>
                     <!-- <ul class="list" style="display:block;">
                      <li>
                        <label for="jobchk1" class="lab_check lab_check--square">
                          <span class="ico--inp"><input type="checkbox" name="" id="jobchk1" value=""></span>전체
                        </label>
                      </li>
                      <li>
                        <label for="jon_0" class="lab_check lab_check--square">
                          <span class="ico--inp"><input type="checkbox" name="" id="jon_0" value=""></span>한식/분식
                        </label>
                      </li>
                    </ul> -->
                  </dd>
                </dl>
              </div>
              <!--//select-job-->
            </div>
            <!--jobCategory-->
            <div class="jobCategory_close">
              <button type="button" onclick="closeLayer('layerCategory'); ">닫기<span class="ico ico--popup--close--small"></span></button>
            </div>
          </div>
          <!--//업직종선택 팝업-->
        </dd>
      </dl>
      <!--//업직종-->
      <!--담당업무-->
      <dl class="article article--job"><!--유효값없을때 invalid class추가-->
        <dt class="article__tit essential">담당업무 <span class="emphasis--orange">*</span></dt>
        <dd class="article__con">
          <div class="inp-txt__wrap">
            <input type="text" class="inp-txt" id="txtWork_Take_Charge" name="txtWork_Take_Charge" value="<%=rsWork_Take_Charge%>" placeholder="예 : 주방보조 | 설거지 (손님이 많을 때에만 지원해주시면 됩니다.)" onkeyup="chkword(this)" maxlength="100">
            <div class="counter"><span class="num">0</span>/100</div>
          </div>
        </dd>
      </dl>
      <!--//담당업무-->
      <!--경력-->
      <dl class="article article--experience">
        <dt class="article__tit essential">경력 <span class="emphasis--orange">*</span></dt>
        <dd class="article__con">
          <div id="divCareere">
            <label for="rdoCareerF" class="lab_radio lab_radio--txt" onclick="SetCareeDisplay();">
              <span class="ico--inp"><input type="radio" name="rdoCareerF" id="rdoCareerF" value="0" title="무관" <%=getBitChecked("0", rsCAREERF)%> ></span>무관
            </label>
            <label for="rdoCareerF1" class="lab_check lab_check--txt" onclick="SetCareeDisplay();">
              <span class="ico--inp"><input type="checkbox" name="rdoCareerF1" id="rdoCareerF1" value="1" title="신입" <%=getBitChecked("1", rsCAREERF)%>></span>신입
            </label>
            <label for="rdoCareerF2" class="lab_check lab_check--txt" onclick="SetCareeDisplay();">
              <span class="ico--inp"><input type="checkbox" name="rdoCareerF2" id="rdoCareerF2" value="2" title="경력" <%=getBitChecked("2", rsCAREERF)%>></span>경력
            </label>
          </div>
          <!--경력체크시 노출-->
          <div class="extraBox extraBox--experience" id="divYear" style="display:none">
            <dl>
              <dt>경력</dt>
              <dd>
                <div class="custom-select">
                  <select name="sltCareerFrom" id="sltCareerFrom" >
										<% Dim year_i  
											FOR year_i = 0 to 30 %>
											<% IF year_i = 0 Then %>
												<option value="0">선택</option>
											<% ELSE %>
                        <% IF  Cint(year_i) = Cint(rsCAREERFROM) Then %>
												  <option value="<%=year_i%>" selected><%=year_i%>년</option>
                        <%ELSE%>
                          <option value="<%=year_i%>"><%=year_i%>년</option>
                        <%END IF %>
											<%END IF %>
										<% NEXT %>
                  </select>
                </div>
                <span class="hyphen">­­-</span>
                <div class="custom-select">
                <!-- onchange="resetCheck();" 필요 없음 -->
                  <select name="sltCareerTo" id="sltCareerTo" >
                    <% FOR year_i = 0 to 30 %>
										<% IF year_i = 0 Then %>
											<option value="0">선택</option>
										<% ELSE %>
										  <% IF  Cint(year_i) = Cint(rsCAREERTO) Then %>
                        <option value="<%=year_i%>" selected><%=year_i%>년</option>
                      <%ELSE%>
                        <option value="<%=year_i%>"><%=year_i%>년</option>
                      <%END IF %>
										<%END IF %>
									<% NEXT %>
                  </select>
                </div>
              </dd>
            </dl>
            <label for="chkCareerF1" class="lab_check lab_check--circle">
              <span class="ico--inp"><input type="checkbox" name="chkCareerF1" id="chkCareerF1" value="999" title="연수무관"
                  onclick="exFree();" <%=getChecked("999",rsCAREERFROM)%>></span>연수무관
            </label>
          </div>
          <!--//경력체크시 노출-->
        </dd>
      </dl>
      <!--//경력-->
      <!--고용형태-->
      <dl class="article article--workType">
        <dt class="article__tit essential">고용형태 <span class="emphasis--orange">*</span><br><span
            class="select-option">(중복선택)</span></dt>
        <dd class="article__con" id="ddWORK">
          <label for="chkWorkMain" class="lab_check lab_check--txt" OnClick="SetEmployType();">
            <span class="ico--inp"><input type="checkbox" name="chkWorkMain" id="chkWorkMain" value="1" title="정규직" <%=getChecked("1",rsWORK_MAIN)%>></span>정규직
          </label>
          <label for="chkWorkSub" class="lab_check lab_check--txt" OnClick="SetEmployType();">
            <span class="ico--inp"><input type="checkbox" name="chkWorkSub" id="chkWorkSub" value="1" title="계약직"  <%=getChecked("1",rsWORK_SUB)%>></span>계약직
          </label>
          <label for="chkWorkOut" class="lab_check lab_check--txt" OnClick="SetEmployType();">
            <span class="ico--inp"><input type="checkbox" name="chkWorkOut" id="chkWorkOut" value="1" title="파견직"  <%=getChecked("1",rsWORK_OUT)%>></span>파견직
          </label>
          <label for="chkPartTime" class="lab_check lab_check--txt" OnClick="SetEmployType();">
            <span class="ico--inp"><input type="checkbox" name="chkPartTime" id="chkPartTime" value="1" title="아르바이트"  <%=getChecked("1",rsPARTTIMEF)%>></span>아르바이트
          </label>
          <label for="chkWorkAppoint" class="lab_check lab_check--txt" OnClick="SetEmployType();">
            <span class="ico--inp"><input type="checkbox" name="chkWorkAppoint" id="chkWorkAppoint" value="1" title="위촉직 "  <%=getChecked("1",rsWORK_APPOINT)%>></span>위촉직
          </label>
          <label for="chkWorkFreelancer" class="lab_check lab_check--txt" OnClick="SetEmployType();">
            <span class="ico--inp"><input type="checkbox" name="chkWorkFreelancer" id="chkWorkFreelancer" value="1" title="프리랜서" <%=getChecked("1",rsWORK_FREELANCER)%>></span>프리랜서
          </label>
        </dd>
      </dl>
      <!--//고용형태-->
      <!--성별-->
      <dl class="article article--gender">
        <dt class="article__tit">성별</dt>
        <dd class="article__con" id="ddSex">
          <label for="rdoSexF1" class="lab_radio lab_radio--txt">
            <span class="ico--inp"><input type="radio" name="rdoSex" id="rdoSexF1" value="3" title="무관" <%=getChecked("3",rsSEXF)%>></span>
            무관
          </label>
          <label for="rdoSexF2" class="lab_radio lab_radio--txt">
            <span class="ico--inp"><input type="radio" name="rdoSex" id="rdoSexF2" value="1" title="남자" <%=getChecked("1",rsSEXF)%>></span>
            남자
          </label>
          <label for="rdoSexF3" class="lab_radio lab_radio--txt">
            <span class="ico--inp"><input type="radio" name="rdoSex" id="rdoSexF3" value="2" title="여자" <%=getChecked("2",rsSEXF)%>></span>
            여자
          </label>
        </dd>
      </dl>
      <!--//성별-->
      <!--연령-->
      <dl class="article article--age">
        <dt class="article__tit">연령</dt>
        <dd class="article__con" id="ddAgeF">
          <label for="rdoAgeF1" class="lab_radio lab_radio--txt" onclick="SetDivDisplay('divAge', 'none');">
            <span class="ico--inp"><input type="radio" name="rdoAgeF" id="rdoAgeF1" value="0" title="무관" <%=getChecked("0",rsAGEF)%>></span>
            무관
          </label>
          <label for="rdoAgeF2" class="lab_radio lab_radio--txt" onclick="SetDivDisplay('divAge', 'inline-block');">
            <span class="ico--inp"><input type="radio" name="rdoAgeF" id="rdoAgeF2" value="1" title="선택" <%=getChecked("1",rsAGEF)%>></span>
            선택
          </label>
          <div class="age-option" id="divChkAge">
            <label for="chkSubAge1" class="lab_check lab_check--circle first">
              <span class="ico--inp"><input type="checkbox" name="chkSubAge1" id="chkSubAge1" value="1" title="주부가능" <%=getChecked("1",rsAGESUB_JUBU)%>></span>
              주부가능
            </label>
            <label for="chkSubAge2" class="lab_check lab_check--circle second">
              <span class="ico--inp"><input type="checkbox" name="chkSubAge2" id="chkSubAge2" value="1" title="중장년가능" <%=getChecked("1",rsAGESUB_MIDDLE)%>></span>
              중장년가능
            </label>
            <label for="chkSubAge3" class="lab_check lab_check--circle third">
              <span class="ico--inp"><input type="checkbox" name="chkSubAge3" id="chkSubAge3" value="1" title="만18세이하 가능" <%=getChecked("1",rsAGESUB_MINORITY)%>></span>
              만 18세이하 가능
            </label>
          </div>
          <!--연령 선택체크시 노출-->
          <div class="extraBox extraBox--age" id="divAge" style="display:none">
            <dl>
              <dt>연령</dt>
              <dd>
                <div>
                  <div class="custom-select">
                    <select name="sltAgeFrom" id="sltAgeFrom">
										<% Dim age_i
											For age_i = 14 to 99
											  IF age_i = 14 Then %>
													<option value="0">선택</option>
											<% ELSE %>
												 <option value="<%=age_i%>"><%=age_i%>세</option>
											<%END IF %>
										<% NEXT%>
                    </select>
                  </div>
                  <span class="hyphen">­­-</span>
                  <div class="custom-select">
                    <select name="sltAgeTo" id="sltAgeTo">
                    <% For age_i = 14 to 99
											 IF age_i = 14 Then %>
												<option value="0">선택</option>
											<% ELSE %>
												 <option value="<%=age_i%>"><%=age_i%>세</option>
											<%END IF %>
										<% NEXT%>
                    </select>
                  </div>
                </div>
              </dd>
            </dl>
          </div>
          <!--//연령 선택체크시 노출-->
          <div class="view">
            <button class="view__btn" type="button" onclick="openLayer2('layerLawGender')">남녀고용평등법 안내</button>
            <button class="view__btn" type="button" onclick="openLayer2('layerLawAge')">연령차별금지법 안내</button>
            <a href="//customer.findall.co.kr/Notice/NoticeMainView.asp?&Page=1&Section=2&Serial=5313"
              class="view__btn" target="_blank">만 18세 미만 청소년 고용금지 직종 안내</a>
          </div>
          <p class="view-additional red">* 채용공고에 특정 <strong>성별</strong>이나 <strong>연령</strong>을 표기하는 경우 채용공고를 등록한 <strong>광고주에게 벌금</strong>이 부과될 수 있습니다.</p>
          <p class="view-additional red">* 성별과 연령은 공고 상세에 미노출되며 상세 검색 조건에만 반영됩니다.</p>
        </dd>
      </dl>
      <!--//연령-->
      <!--학력-->
      <dl class="article article--academy">
        <dt class="article__tit essential">학력 <span class="emphasis--orange">*</span></dt>
        <dd class="article__con" id="ddAcademy">
          <label for="academy1" class="lab_radio lab_radio--txt">
            <span class="ico--inp"><input type="radio" name="academy" id="academy1" value="0" title="무관"></span>
            무관
          </label>
          <label for="academy2" class="lab_radio lab_radio--txt">
            <span class="ico--inp"><input type="radio" name="academy" id="academy2" value="1" title="고졸이상"></span>
            고졸이상
          </label>
          <label for="academy3" class="lab_radio lab_radio--txt">
            <span class="ico--inp"><input type="radio" name="academy" id="academy3" value="2" title="초대졸이상"></span>
            초대졸이상
          </label>
          <label for="academy4" class="lab_radio lab_radio--txt">
            <span class="ico--inp"><input type="radio" name="academy" id="academy4" value="3" title="대졸이상"></span>
            대졸이상
          </label>
        </dd>
      </dl>
      <!--//학력-->
    	<!--우대 기타조건-->
			<dl class="article article--conditions">
				<dt class="article__tit">우대 기타조건<br><span class="select-option">(중복선택)</span></dt>
				<dd class="article__con">
          <input type="hidden" name="hidEcCheckNames" id="hidEcCheckNames" value="<% =ADF3_txtECName %>" />
          <input type="hidden" id="hidEcValueString" name="hidEcValueString" value="<% =ADF3_EcData %>" />
          <%' 자격조건 변수 값 할당
            For ADF3_i = 1 To 20
              Response.Write "<input type=""hidden"" name=""hidEcValue"" id=""hidEcValue"& ADF3_i &""">"&vblf
            Next
          %>
					<div class="keywordBox" onclick="keywordBox(this);checkPreferBox();" ><!--값있을때 valued 추가-->
						<!-- 값 선택 되었을때-->
						<ul id="ulConditions">
							<li>
								<div class="keyword_S" >
								
								</div>
							</li>
						</ul>
						<!--/값 선택 되었을때-->
						<button class="keywordBox__btn" type="button" onclick="openLayer('layerCondition');checkPreferBox();">
							<span class="txt">추가/수정</span><span class="ico ico--plus--blue"></span>
						</button>
					</div>
					<!--우대 기타조건 팝업-->
					<div class="layer__wrap" id="layerCondition">
						<div class="layer">
							<h3 class="layer__tit">우대&middot;기타조건 선택</h3>
							<div class="layer__con">
								<button class="layer__btn--reset" type="button" onclick="resetCheck('layerCondition')"><span
										class="ico ico--refresh--gray"></span> 초기화</button>
								<dl class="layer__form">
									<dt>가능조건</dt>
									<dd id="ddPossible">
										<label for="possible1" class="lab_check lab_check--square">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="possible1" value="초보가능" <% =getChecked("1", rsECDATA(1)) %>></span>초보가능
										</label>
										<label for="possible2" class="lab_check lab_check--square">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="possible2" value="주부가능" <%=getChecked("1", rsECDATA(2)) %>></span>주부가능
										</label>
										<label for="possible3" class="lab_check lab_check--square">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="possible3" value="중장년가능" <%=getChecked("1", rsECDATA(3)) %>></span>중장년가능
										</label>
										<label for="possible4" class="lab_check lab_check--square divide">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="possible4" value="장애인가능" <%=getChecked("1", rsECDATA(4)) %>></span>장애인가능
										</label>
										<label for="possible5" class="lab_check lab_check--square">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="possible5" value="대학휴학생가능" <%=getChecked("1", rsECDATA(5)) %>></span>대학휴학생가능
										</label>
										<label for="possible6" class="lab_check lab_check--square">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="possible6" value="외국인가능" <%=getChecked("1", rsECDATA(6)) %>></span>외국인가능
										</label>
										<label for="possible7" class="lab_check lab_check--square">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="possible7" value="교포가능" <%=getChecked("1", rsECDATA(7)) %>></span>교포가능
										</label>
										<label for="possible8" class="lab_check lab_check--square divide">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="possible8" value="숙식가능" <%=getChecked("1", rsECDATA(8)) %>></span>숙식가능
										</label>
										<label for="possible9" class="lab_check lab_check--square">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="possible9" value="부업가능" <%=getChecked("1", rsECDATA(9)) %>></span>부업가능
										</label>
									</dd>
								</dl>
								<dl class="layer__form">
									<dt>우대조건</dt>
									<dd id="ddPrefer">
										<label for="prefer1" class="lab_check lab_check--square">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="prefer1" value="동종업계경력자" <%=getChecked("1", rsECDATA(10)) %>></span>동종업계경력자
										</label>
										<label for="prefer2" class="lab_check lab_check--square">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="prefer2" value="영어가능자" <%=getChecked("1", rsECDATA(11)) %>></span>영어가능자
										</label>
										<label for="prefer3" class="lab_check lab_check--square">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="prefer3" value="중국어가능자" <%=getChecked("1", rsECDATA(12)) %>></span>중국어가능자
										</label>
										<label for="prefer4" class="lab_check lab_check--square divide">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="prefer4" value="운전면허소지자" <%=getChecked("1", rsECDATA(13)) %>></span>운전면허소지자
										</label>
										<label for="prefer5" class="lab_check lab_check--square">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="prefer5" value="원동기면허소지자" <%=getChecked("1", rsECDATA(14)) %>></span>원동기면허소지자
										</label>
										<label for="prefer6" class="lab_check lab_check--square">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="prefer6" value="차량소지자" <%=getChecked("1", rsECDATA(15)) %>></span>차량소지자
										</label>
										<label for="prefer7" class="lab_check lab_check--square">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="prefer7" value="컴퓨터활용가능자" <%=getChecked("1", rsECDATA(16)) %>></span>컴퓨터활용가능자
										</label>
										<label for="prefer8" class="lab_check lab_check--square divide">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="prefer8" value="장기근무가능자" <%=getChecked("1", rsECDATA(17)) %>></span>장기근무가능자
										</label>
										<label for="prefer9" class="lab_check lab_check--square">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="prefer9" value="인근거주자" <%=getChecked("1", rsECDATA(18)) %>></span>인근거주자
										</label>
										<label for="prefer10" class="lab_check lab_check--square">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="prefer10" value="관련자격증소지자" <%=getChecked("1", rsECDATA(19)) %>></span>관련자격증소지자
										</label>
										<label for="prefer11" class="lab_check lab_check--square">
											<span class="ico--inp"><input type="checkbox" name="chkEcValue" id="prefer11" value="군필자" <%=getChecked("1", rsECDATA(20)) %>></span>군필자
										</label>
									</dd>
								</dl>
								<div class="layer__btn">
									<button class="btn btn--popup btn--blue btn--radius" type="button" onclick="closeLayer('layerCondition');addEtcConditions();">확인</button>
									<button class="btn btn--popup btn--gray btn--radius" type="button" onclick="closeLayer('layerCondition');">취소</button>
								</div>
							</div>
						</div>
						<div class="layer__dimmed"></div>
					</div>
					<!--//우대 기타조건 팝업-->
					<dl class="recommend">
						<dt>추천</dt>
						<dd>
							<button type="button" id="btnPossible2" onclick="addEtcCondition('주부가능');">주부가능<span class="ico ico--plus--black"></span></button>
							<button type="button" id="btnPossible3" onclick="addEtcCondition('중장년가능');">중장년가능<span class="ico ico--plus--black"></span></button>
							<button type="button" id="btnPossible8" onclick="addEtcCondition('숙식가능');">숙식가능<span class="ico ico--plus--black"></span></button>
							<button type="button" id="btnPrefer6" onclick="addEtcCondition('차량소지자');">차량소지자<span class="ico ico--plus--black"></span></button>
							<button type="button" id="btnPrefer9" onclick="addEtcCondition('인근거주자');">인근거주자<span class="ico ico--plus--black"></span></button>
						</dd>
					</dl>
			</dl>
			<!--우대 기타조건-->
    </div>
  </div>
</div>
<!--//section2-->

	<!--남녀고용평등법 팝업-->
	<div id="layerLawGender" class="layer__wrap">
		<div class="layer">
			<h3 class="layer__tit underline">남녀고용평등법 주 내용</h3>
			<div class="layer__con">
				<p class="layer__con__txt">모집 &middot; 채용 시 직무와 무관하게 남성 또는 여성만 대상으로 하거나 직무수행에 불필요한 용모/키/체중 등의 신체조건, 미혼조건을 제시 또는
					요구하는 경우는 '남녀고용평등과 일 &middot; 가정 양립 지원에 관한 법률'에 의거하여 500만원 이하의 벌금이 부과될 수 있습니다.</p>
				<dl class="layer__con__law">
					<dt>다만, 반드시 해당 직무와 성별이 관련되는 내용이라면 가능</dt>
					<dd>
						<ul>
							<li>- 남성 혹은 여성 역할을 위한 배우/모델 등</li>
							<li>- 여성 목욕탕의 여성 목욕 관리사, 여성 장애인/환자의 도우미 등</li>
							<li>- 여성 기숙사의 여성 사감 등</li>
						</ul>
					</dd>
				</dl>
				<div class="layer__btn">
					<a href="//www.law.go.kr/법령/남녀고용평등과일ㆍ가정양립지원에관한법률" target="_blank"
						class="btn btn--popup btn--blue btn--radius">'남녀고용평등과 일 &middot; 가정 양립 지원에 관한 법률' 바로가기</a>
				</div>
			</div>
			<button class="layer__close btn--popup--close" type="button" onclick="closeLayer('layerLawGender');"><span
					class="ico ico--popup--close">닫기</span></button>
		</div>
		<div class="layer__dimmed"></div>
	</div>
	<!--//남녀고용평등법 팝업-->
	<!--연령차별금지법 팝업-->
	<div id="layerLawAge" class="layer__wrap">
		<div class="layer">
			<h3 class="layer__tit underline">연령차별금지법 주 내용</h3>
			<div class="layer__con">
				<p class="layer__con__txt">직무 능력과 연령은 직접적인 연관이 없으므로, 나이를 추정할 수 있는 사항을 요구하는 것은 삼가야 합니다. 다만, 연소자 식별을 위하여 취업 가능 연령을
					묻는 것은 가능합니다.</p>
				<h4 class="layer__con__tit">관련내용</h4>
				<dl class="layer__con__law">
					<dt>제 4조의 4 (모집&middot;채용 등에서의 연령차별 금지)</dt>
					<dd>
						<ul>
							<li>
								<span>①</span> 사업주는 다음 각 호의 분야에서 합리적인 이유 없이 연령을 이유로 근로자 또는 근로자가 되려는 자를 차별하여서는 아니 된다.
								<ul>
									<li>1. 모집·채용</li>
									<li>2. 임금, 임금 외의 금품 지급 및 복리후생</li>
									<li>3. 교육·훈련</li>
									<li>4. 배치·전보·승진</li>
									<li>5. 퇴직·해고</li>
								</ul>
							</li>
							<li>
								<span>②</span> 제1항을 적용할 때 합리적인 이유 없이 연령 외의 기준을 적용하여 특정 연령집단에 특히 불리한 결과를 초래하는 경우에는 연령차별로 본다.
							</li>
						</ul>
					</dd>
				</dl>
				<dl class="layer__con__law">
					<dt>제23조의3(벌칙)</dt>
					<dd>
						<ul>
							<li>
								<span>②</span> 제4조의4제1항제1호를 위반하여 모집·채용에서 합리적인 이유 없이 연령을 이유로 차별한 사업주는 500만원 이하의 벌금에 처한다.
							</li>
						</ul>
					</dd>
				</dl>
				<div class="layer__btn">
					<a href="//likms.assembly.go.kr/law/lawsLawtInqyDetl1010.do?mappingId=%2FlawsLawtInqyDetl1010.do&genActiontypeCd=2ACT1010&genDoctreattypeCd=&procWorkId=&workstepId=&repFlowId=&flowId=&workId=&workSno=&winWd=&winHg=&winTypeAttr=M&nextWinWd=&nextWinHg=&nextWinTypeAttr=&nextMappingId=&nextGenActiontypeCd=&contSid=0017&basicDt=20201023&contId=1991123100000001&cachePreid=ALL&genMenuId=menu_serv_nlaw_lawt_1010&back_contSid=0017&back_basicDt=20201023&back_contId=1991123100000001&back_cachePreid=ALL"
						target="_blank" class="btn btn--popup btn--blue btn--radius">'고용상 연령차별금지 및 고령자고용촉진에 관한 법률' 바로가기</a>
				</div>
			</div>
			<button class="layer__close btn--popup--close" type="button" onclick="closeLayer('layerLawAge');"><span
					class="ico ico--popup--close">닫기</span></button>
		</div>
		<div class="layer__dimmed"></div>
	</div>
	<!--//연령차별금지법 팝업-->

 <script language="JavaScript">

		// 고용형태
    SetChecked("ddWORK","chk");
    //성별
    SetChecked("ddSex","rdoSex");
    //연령
    SetChecked("ddAgeF","rdoAgeF");
    //수정시 연령 선택에 따른 div 노출
    <%
    IF rsAGEF = "1" Then
      Response.Write "SetDivDisplay('divAge', 'inline-block');"&vblf
    END IF 
    %>
   
    //연령 주부,중장년,18세이하
    SetChecked("divChkAge","chkSubAge");

    // 급여지급형태
    getCheckPayType(<%=rsPAYTYPE%>);

    // 연령체크(체크박스)
    setCheckAge(<%=rsAGE%>);

    // 연령형태
    setAgeRegType();

    //연령값
    <%  If rsAGEFROM > 0 Then%>
      fncCheckedVal("#sltAgeFrom", "<% =rsAGEFROM %>", true);
    <%
      End If
      If rsAGETO > 0 Then
    %>
        fncCheckedVal("#sltAgeTo", "<% =rsAGETO %>", true);
    <%
      End If
    %>

    // 경력-신입,경력 체크 divCareere
    SetChecked("divCareere", "rdoCareerF");

    //경력 연수무관 체크
    SetChecked("divYear","chkCareerF1");
    exFree();
    //경력 노출
    SetDivShowAndHide( "rdoCareerF2" , "divYear");

    // 학력-학력 체크
    SetCheckNewEduLevel("<%=rsEDULEVEL%>");

    
    if($("#divYear").css("display") == "block"){
      fncCheckedVal("#sltCareerFrom", "<%=rsCAREERFROM %>", true); 
      fncCheckedVal("#sltCareerTo", "<%=rsCAREERTO %>", true); 
    }

    <%
    If rsPAYF = "0" Then %>
    setPayCurrent('');
    <% End If %>

    <%' 급여조건이 협의가 아닌 경우 금액범위 미리보기 실행
    If rsPAYF > 0 Then
      Response.Write "setPayPreview();"&vblf
    End If
    %>


    $("input[name^=chkDayWeekOption]").click("focus", function () {
      if ($(this).is(":checked")) {
        $("label[for=" + $(this).attr("id") + "]").addClass("checked");
      } else {
        $("label[for=" + $(this).attr("id") + "]").removeClass("checked");
      }
    });

    <% '근무시간, 근무시간 - 협의가능만 체크, 시간값 없음, 근무유형이 위촉직 또는 프리랜서만일 경우 시간값 초기화
    If rsWORKTIMEF <> 100 Then
      If rsWORKTIMEFROM = 0 And rsWORKTIMEFROM = 0 And rsWORKTIMETO = 0 And (rsWORK_APPOINT = 1 Or rsWORK_FREELANCER = 1) And rsWORK_MAIN = 0 And rsWORK_SUB = 0 And rsWORK_OUT = 0 And rsPARTTIMEF = 0 Then %>
    $("#sltWorkTimeFrom_Hour").val("");
    $("#sltWorkTimeFrom_Min").val("");
    $("#sltWorkTimeTo_Hour").val("");
    $("#sltWorkTimeTo_Min").val("");
    <% End If
    End If%>

    if ($("#hidProcessType").val() == "Regist") {
      if ($("#hidReqFormType").val() == "") {
        $("#rdoMapOnly").prop("checked", true);
        $("label[for=rdoMapOnly]").addClass("checked");
      }
    }


  //학력 체크
  function SetCheckNewEduLevel(val){
    $("#ddAcademy input[name^='academy']").each(function(){
      if($(this).val() == val){
        $(this).prop("checked",true);
        $("label[for=" + $(this).attr("id") + "]").addClass("on");
      }
    });
  }

//업직종의 경우 로딩 완료후 데이터 입력
window.onload =function(){
  //업직종 
  for(var i = 1; i <= 10; i++){
    if($("#hidFindcode" + i.toString()).val() != ""){
      
      if($("#hidFind1DepthYN").val() == "Y")
        break;
        
      $(".job_choose .first_step li[id^='fCate" + $("#hidFindcode" + i.toString()).val().substring(0,3) +"']").trigger("click");
  
      if($("#hidFindcode" + i.toString()).val().length == 3){
        lastChecked("ck", $(".job_choose .second_step li[id^='liCate2_" + $("#hidFindcode" + i.toString()).val().substring(0,3) +"']"));
      }else{
          selectTag(".job_choose .second_step li[id^='liCate2_" + $("#hidFindcode" + i.toString()).val().substring(0,5) +"']");  
        if($("#hidFindcode" + i.toString()).val().length > 5){
          lastChecked("ck", $("#hidFindcode" + i.toString()).val());
        }
      }
    }
  }
}

$(document).ready(function() {
    //근무요일 옵션
  var DayWeekOption = $("#txtDayWeekOption").val();
  var DayWeekOptionTmp
  $("input[name^=chkDayWeekOption]").each(function () {
    DayWeekOptionTmp = parseInt($(this).val());

    if ((DayWeekOption & DayWeekOptionTmp) > 0) {
      $(this).prop("checked", true);
      $("label[for=" + $(this).attr("id") + "]").addClass("checked");
    } else {
      $(this).prop("checked", false);
      $("label[for=" + $(this).attr("id") + "]").removeClass("checked");
    }
  });
  //고용형태
  SetEmployType();


  // 글자수 제한
  chkword("#txtWork_Take_Charge");
  chkword("#txtTitle");


	//업직종 텍스트입력창 클릭시
	$("#txtCate").click(function(){
    $("#txtCate").val($("#txtCate").val().replace(" ",""));
    $("#hidKeyCode").val("");
    cnt = 0;
    topVal = 1;
    ajaxCall_AutoComplete_Cate(); //두글자 이상 이미 입력되어 있으면 자동완성
	});

  var topDownCnt = 0;
	var cnt = 0;
  var topVal = 1; // ie인경우 값이0이면 0px를 못가지고옴

  $("#txtCate").on('keyup', function(e){
    if(e.keyCode == 32)
    {
      $("#txtCate").val($("#txtCate").val().replace(" ",""));
      e.keyCode = 13;
    }
  });

  $("#txtCate").on('keydown', function(e){
    if(e.keyCode == 32)
    {
      $("#txtCate").val($("#txtCate").val().replace(" ",""));
      e.keyCode = 13;
    }
    if($("#txtCate").val().length >= 1){
      $("#txtCate").val($("#txtCate").val().replace(" ",""));
    }
    
    if(e.keyCode != 32){
      $("#hidKeyCode").val(e.keyCode);
    }else{
      $("#chain_list li:eq(" + cnt + ") button[id^='btnCk']").focus();
    }
    if(e.keyCode != 39 && e.keyCode != 37 && e.keyCode != 13 && e.keyCode != 40  && e.keyCode != 38 && e.keyCode != 32){
      // 방향키 엔터 스페이스 인경우 자동완성 다시 표출 x
      cnt = 0;
      topVal = 1;
      $("#hidTopVal").val("");
       
    }else{
      if(topVal == 1){
        $("#chain_search .mCSB_container").css("top", topVal);
      }
      
      if(e.keyCode == "40" ){ // 아래
        if(cnt ==  $("#chain_list li").length ){
          $("#chain_list li:eq(" + (cnt -1) + ") button[id^='btnCk']").css("background", "#f3f8fc");

          return;
        }
        if(cnt > 0){
          $("#chain_list li:eq(" + (cnt - 1) + ") button[id^='btnCk']").css("background", ""); // 선택 색상
        }
        // 마우스 스크롤 후 top값 기존값으로 
        if($("#hidTopVal").val() != $("#chain_search .mCSB_container").css("top")){
            $("#chain_search .mCSB_container").css("top", $("#hidTopVal").val() );
        }

        $("#chain_list li:eq(" + cnt + ") button[id^='btnCk']").css("background", "#f3f8fc"); // 선택 색상
        cnt = cnt + 1;
        
        // 4개 이상인경우만 스크롤 top 값 변경 
        if($("#chain_list li").length > 5 && cnt > 5){
          if(topDownCnt == 5){

            topVal = -28 + parseInt($("#chain_search .mCSB_container").css("top"));
            $("#chain_search .mCSB_container").css("top", topVal);
          }
        }
          
        if($("#chain_search .mCSB_container").css("top") != topVal && topVal > 0 ){
          $("#chain_search .mCSB_container").css("top", topVal);
        }
        $("#hidTopVal").val($("#chain_search .mCSB_container").css("top")); // 마우스 스크롤시 다시 현재 top값을 위해 설정

        if(topDownCnt < 5){
          topDownCnt = topDownCnt + 1;
        }
           
      }
      else if(e.keyCode == "38"){  // 위
        if(cnt == 0 ){
          $("#chain_list li:eq(" + 0 + ") button[id^='btnCk']").css("background", "#f3f8fc"); // 선택 색상
          return;
        }else{
          $("#chain_list li:eq(" + (cnt - 1) + ") button[id^='btnCk']").css("background", ""); // 선택 색상
        }
        // 마우스 스크롤 후 top값 기존값으로 
        if($("#hidTopVal").val() != $("#chain_search .mCSB_container").css("top")){
            $("#chain_search .mCSB_container").css("top", $("#hidTopVal").val() );
        }
        // 5개 이상인경우만 스크롤 top 값 변경
 
        if($("#chain_list li").length  > 5 && cnt > 5){
          if(topDownCnt == 1){
            topVal = + 28 + parseInt($("#chain_search .mCSB_container").css("top"));
            $("#chain_search .mCSB_container").css("top", topVal);
          }
        }else{ 
          if(topVal < 0){
            topVal = + 28 + parseInt($("#chain_search .mCSB_container").css("top"));
            $("#chain_search .mCSB_container").css("top", topVal);
          }
        }

        //cnt를 1로 맞춤 length랑  li:eq(value) 값이 다름
        if(cnt > 0 && cnt != 1){
          cnt = cnt - 1;
        } 

        if(cnt == 0 ){
          $("#chain_list li:eq(" + cnt + ") button[id^='btnCk']").css("background", "#f3f8fc"); // 선택 색상
        }else{
          $("#chain_list li:eq(" + (cnt - 1) + ") button[id^='btnCk']").css("background", "#f3f8fc"); // 선택 색상
        }
        $("#hidTopVal").val($("#chain_search .mCSB_container").css("top"));// 마우스 스크롤시 다시 현재 top값을 위해 설정

        
        if(topDownCnt > 1) {
          topDownCnt = topDownCnt - 1;
        }
      }else{
        // 스페이스 및 엔터 눌렀을경우 선택
        if(cnt == 0){
          return;
        }
        if($("#chain_list li").length > 0 &&  (e.keyCode == 13 || e.keyCode == 32)){
          autoCompleteSub($("#chain_list li:eq(" + (cnt -1) + ") button[id^='btnCk']"));
          return;
        }
      }

    }
    $("#hidCateCnt").val(cnt);
  
  });

    // 자동완성
  $("#txtCate").autocomplete({
      source: ajaxCall_AutoComplete_Cate,
      minLength:1,
      delay: 100

  });
});

</script>


<div id="postNotice" class="layer__wrap">
		<div class="layer">
			<h3 class="layer__tit underline"><span class="ico ico--notice2">주의</span>공고 등록 주의사항</h3>
			<div class="layer__con">
				<p>
					우체국 소포 위탁 배달원 모집 공고는 <span>우정사업본부</span> 또는 우체국 
					물류지원단과 계약한 <span>위수탁 배달 업체에서만</span> 진행할 수 있으며, 
					계약업체 일지라도 사전 승인 없이는 우체국 관련 <span>회사 및 브랜드 로고 사용이 불가</span>합니다.
				</p>
				<p>
					위와 관련하여 앞으로 우체국 택배 관련 공고 무료 접수 시  <span>해당 업체가 아닌 경우 검수 
					거절로 등록이 불가</span>하며, 유료 공고의 경우에도 강제 종료처리 될 수 있으니 양해부탁드립니다.
				</p>
			</div>
			<div class="layer__btn">
				<label for="noMore" class="lab_check lab_check--circle first">
					<span class="ico--inp"><input type="checkbox" name="noMore" id="noMore" value="1" title="일주일간 보지 않기"></span>일주일간 보지 않기
				</label>
				<button onclick="fn_CloseToday();closeLayer('postNotice');" type="button" >닫기<span class="ico ico--close--darkblack"></span></button>
			</div>
			<button class="layer__close2 btn--popup--close" type="button" onclick="fn_CloseToday();closeLayer('postNotice');">
				<span class="ico ico--popup--close">닫기</span>
			</button>
		</div>
		<div class="layer__dimmed"></div>
	</div>
