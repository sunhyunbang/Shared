using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using System.Text;

using MediaWill._Lib;
using MediaWill._Pack;

namespace MB.Job.Controllers
{
	public class ConditionalSearchController : __ReNew_BaseController
	{

		public ActionResult Index()
		{
			return Redirect("/ConditionalSearch/Hub/" + gDefaultParams);
		}

		/// <summary>일자리 빠르게 찾기 메인</summary>
		/// <returns></returns>
		public ActionResult Hub()
		{
			#region 검색조건 사용여부
			string AREA_USE = Req.GetString("AREA_USE", "Y");  //검색조건 사용여부
			string CATE_USE = Req.GetString("CATE_USE", "Y");  //검색조건 사용여부
			string WORK_USE = Req.GetString("WORK_USE", "Y");  //검색조건 사용여부

			ViewBag.AREA_USE = AREA_USE;
			ViewBag.CATE_USE = CATE_USE;
			ViewBag.WORK_USE = WORK_USE;
			#endregion

			string REQ_KEYWORD = Req.GetString("REQ_KEYWORD", "");  //통합검색 키워드
			ViewBag.REQ_KEYWORD = REQ_KEYWORD;

<<<<<<< HEAD
      string SEARCH_LOCATION = Req.GetString("SEARCH_LOCATION", "");
      ViewBag.SEARCH_LOCATION = SEARCH_LOCATION;
      
      string Edit = Req.GetString("EDIT", "");
      ViewBag.Edit = Edit;

      #region ### 지역/분류/근무조건 조건검색 ###
      NameValueCollection nvc_cookie = null;
=======
			string SEARCH_LOCATION = Req.GetString("SEARCH_LOCATION", "");
			ViewBag.SEARCH_LOCATION = SEARCH_LOCATION;

			#region ### 지역/분류/근무조건 조건검색 ###
			NameValueCollection nvc_cookie = null;
>>>>>>> develop
			// 검색조건 기본 셋팅            
			nvc_cookie = initConditionalSearchCookie();

			string SELECT_PAGE = Req.GetString("SELECT_PAGE", "");

      //ViewBag.COOKIE_TYPE = "MS";   // "" : 기본(단일선택), "MT" : 다중선택, "OT" : 우리동네일자리, "SW" : 역세권, "MS" : 다중선택(NEW), "KO" : 다중선택(KONAN)
      ViewBag.PAGE_LOCATION = Req.GetString("PAGE_LOCATION", "");
      string COOKIE_TYPE = Req.GetString("COOKIE_TYPE", "MS");
      if (ViewBag.PAGE_LOCATION == "BRAND")
      {
        COOKIE_TYPE = "BR";
      }

      ViewBag.COOKIE_TYPE = COOKIE_TYPE;

			// 쿠키 가져오기
			nvc_cookie = getConditionalSearchCookie(null, ViewBag.COOKIE_TYPE, AREA_USE, CATE_USE, WORK_USE);

			#region 조건검색 쿠키 (지역)
			ViewBag.COUNT_AREA = "0";
			if (!string.IsNullOrEmpty(nvc_cookie["area_cookie"]))
			{
				ViewBag.COUNT_AREA = nvc_cookie["area_cookie"].Split(',').Length.ToString();
			}
			ViewBag.AREA = nvc_cookie["area_cookie"];
			ViewBag.AREA_TXT = nvc_cookie["area_txt_cookie"];
			#endregion

			#region 조건검색 쿠키 (업/직종)
			ViewBag.COUNT_CATE = "0";
			if (!string.IsNullOrEmpty(nvc_cookie["cate_cookie"]))
			{
				ViewBag.COUNT_CATE = nvc_cookie["cate_cookie"].Split(',').Length.ToString();
			}
			ViewBag.CATE = nvc_cookie["cate_cookie"];
			ViewBag.CATE_TXT = nvc_cookie["cate_txt_cookie"];
			#endregion

			#region 조건검색 쿠키 (근무조건)
			ViewBag.WORK_PAYF = nvc_cookie["work_payf_cookie"];
			ViewBag.WORK_PAYAMOUNT = nvc_cookie["work_payamount_cookie"];
			ViewBag.WORK_PAY_TEXT = nvc_cookie["work_pay_text_cookie"];
			ViewBag.WORK_WF = nvc_cookie["work_wf_cookie"];
			ViewBag.WORK_WTEXT = nvc_cookie["work_wtext_cookie"];
			ViewBag.WORK_DAY_WEEK = nvc_cookie["work_day_week_cookie"];
			ViewBag.WORK_DAY_WEEK_NEGO = nvc_cookie["work_day_week_nego_cookie"];
			ViewBag.WORK_DAY_WEEK_TEXT = nvc_cookie["work_day_week_text_cookie"];
			ViewBag.WORK_TIME = nvc_cookie["work_time_cookie"];
			ViewBag.WORK_TIMEF = nvc_cookie["work_timef_cookie"];
			ViewBag.WORK_TIME_FROM = nvc_cookie["work_time_from_cookie"];
			ViewBag.WORK_TIME_TO = nvc_cookie["work_time_to_cookie"];
			ViewBag.WORK_TIME_NEGO = nvc_cookie["work_time_nego_cookie"];
			ViewBag.WORK_TIME_TEXT = nvc_cookie["work_time_text_cookie"];
			ViewBag.WORK_AGE = nvc_cookie["work_age_cookie"];
			ViewBag.WORK_AGE_N = nvc_cookie["work_age_n_cookie"];
			ViewBag.WORK_AGE_TEXT = nvc_cookie["work_age_text_cookie"];
			ViewBag.WORK_SEX = nvc_cookie["work_sex_cookie"];
			ViewBag.WORK_SEX_N = nvc_cookie["work_sex_n_cookie"];
			ViewBag.WORK_SEX_TEXT = nvc_cookie["work_sex_text_cookie"];
			ViewBag.WORK_TXT = nvc_cookie["work_txt"];
			#endregion

			#region 우리동네일자리 쿠키
			ViewBag.OT_AREA_TXT = Utils_Cookies.getJobConditionalSearchookies(null, "OT", "AREA", "T");

			ViewBag.GMAP_X = nvc_cookie["ourtown_gmap_x"];
			ViewBag.GMAP_Y = nvc_cookie["ourtown_gmap_y"];
			ViewBag.RADIUS = nvc_cookie["ourtown_radius"];
			#endregion

			#region Request 값 설정
			ViewBag.PAGE_LOCATION = Req.GetString("PAGE_LOCATION", "");
			ViewBag.SPID = Req.GetString("SPID", "");
			ViewBag.BR_GBN = Req.GetString("BR_GBN", "");
			ViewBag.BR_SEQ = Req.GetString("BR_SEQ", "");

			if ((ViewBag.PAGE_LOCATION == "SPECIAL" || ViewBag.PAGE_LOCATION == "BRAND") && string.IsNullOrEmpty(SEARCH_LOCATION))
			{
				ViewBag.lCOUNT_AREA = 1;
				ViewBag.lCOUNT_CATE = 1;
			}
			else
			{
				ViewBag.lCOUNT_AREA = 5;
				ViewBag.lCOUNT_CATE = 5;
			}

			// 지역
			string REQ_AREA = Req.GetString("REQ_AREA", "");
			string REQ_AREA_TXT = Req.GetString("REQ_AREA_TXT", "");
			string REQ_AREA_COUNT = Req.GetString("REQ_AREA_COUNT", "0");

			if (REQ_AREA != "")
			{
				ViewBag.AREA = REQ_AREA;
				ViewBag.AREA_TXT = REQ_AREA_TXT;
				ViewBag.COUNT_AREA = REQ_AREA_COUNT;
			}
			else if (REQ_AREA == "" && !string.IsNullOrEmpty(nvc_cookie["area_cookie"]) && SELECT_PAGE != "Y")
			{
				REQ_AREA = nvc_cookie["area_cookie"];
				REQ_AREA_TXT = nvc_cookie["area_txt_cookie"];
				REQ_AREA_COUNT = nvc_cookie["area_cookie"].Split(',').Length.ToString();
			}

			ViewBag.REQ_AREA = REQ_AREA;
			ViewBag.REQ_AREA_TXT = REQ_AREA_TXT;
			ViewBag.REQ_AREA_COUNT = REQ_AREA_COUNT;

			// 업직종
			string REQ_CATE = Req.GetString("REQ_CATE", "");
			string REQ_CATE_TXT = Req.GetString("REQ_CATE_TXT", "");
			string REQ_CATE_COUNT = Req.GetString("REQ_CATE_COUNT", "0");

			if (REQ_CATE != "")
			{
				ViewBag.CATE = REQ_CATE;
				ViewBag.CATE_TXT = REQ_CATE_TXT;
				ViewBag.COUNT_CATE = REQ_CATE_COUNT;
			}
			else if (REQ_CATE == "" && !string.IsNullOrEmpty(nvc_cookie["cate_cookie"]) && SELECT_PAGE != "Y")
			{
				REQ_CATE = nvc_cookie["cate_cookie"];
				REQ_CATE_TXT = nvc_cookie["cate_txt_cookie"];
				REQ_CATE_COUNT = nvc_cookie["cate_cookie"].Split(',').Length.ToString();
			}

			ViewBag.REQ_CATE = REQ_CATE;
			ViewBag.REQ_CATE_TXT = REQ_CATE_TXT;
			ViewBag.REQ_CATE_COUNT = REQ_CATE_COUNT;

			// 근무조건      
			string REQ_WORK_PAYF = Req.GetString("REQ_WORK_PAYF", "0");
			string REQ_WORK_PAYAMOUNT = Req.GetString("REQ_WORK_PAYAMOUNT", "0");
			string REQ_WORK_PAY_TEXT = Req.GetString("REQ_WORK_PAY_TEXT", "");
			string REQ_WORK_WF = Req.GetString("REQ_WORK_WF", "0");
			string REQ_WORK_WTEXT = Req.GetString("REQ_WORK_WTEXT", "");
			string REQ_WORK_DAY_WEEK = Req.GetString("REQ_WORK_DAY_WEEK", "0");
			string REQ_WORK_DAY_WEEK_NEGO = Req.GetString("REQ_WORK_DAY_WEEK_NEGO", "");
			string REQ_WORK_DAY_WEEK_TEXT = Req.GetString("REQ_WORK_DAY_WEEK_TEXT", "");
			string REQ_WORK_TIME = Req.GetString("REQ_WORK_TIME", "0");
			string REQ_WORK_TIMEF = Req.GetString("REQ_WORK_TIMEF", "0");
			string REQ_WORK_TIME_FROM = Req.GetString("REQ_WORK_TIME_FROM", "");
			string REQ_WORK_TIME_TO = Req.GetString("REQ_WORK_TIME_TO", "");
			string REQ_WORK_TIME_NEGO = Req.GetString("REQ_WORK_TIME_NEGO", "");
			string REQ_WORK_TIME_TEXT = Req.GetString("REQ_WORK_TIME_TEXT", "");
			string REQ_WORK_AGE = Req.GetString("REQ_WORK_AGE", "");
			string REQ_WORK_AGE_N = Req.GetString("REQ_WORK_AGE_N", "");
			string REQ_WORK_AGE_TEXT = Req.GetString("REQ_WORK_AGE_TEXT", "");
			string REQ_WORK_SEX = Req.GetString("REQ_WORK_SEX", "0");
			string REQ_WORK_SEX_N = Req.GetString("REQ_WORK_SEX_N", "");
			string REQ_WORK_SEX_TEXT = Req.GetString("REQ_WORK_SEX_TEXT", "");
			string REQ_WORK_TXT = Req.GetString("REQ_WORK_TXT", "");

			if (SELECT_PAGE == "Y")
			{
				ViewBag.REQ_WORK_PAYF = REQ_WORK_PAYF;
				ViewBag.REQ_WORK_PAYAMOUNT = REQ_WORK_PAYAMOUNT;
				ViewBag.REQ_WORK_PAY_TEXT = REQ_WORK_PAY_TEXT;
				ViewBag.REQ_WORK_WF = REQ_WORK_WF;
				ViewBag.REQ_WORK_WTEXT = REQ_WORK_WTEXT;
				ViewBag.REQ_WORK_DAY_WEEK = REQ_WORK_DAY_WEEK;
				ViewBag.REQ_WORK_DAY_WEEK_NEGO = REQ_WORK_DAY_WEEK_NEGO;
				ViewBag.REQ_WORK_DAY_WEEK_TEXT = REQ_WORK_DAY_WEEK_TEXT;
				ViewBag.REQ_WORK_TIME = REQ_WORK_TIME;
				ViewBag.REQ_WORK_TIMEF = REQ_WORK_TIMEF;
				ViewBag.REQ_WORK_TIME_FROM = REQ_WORK_TIME_FROM;
				ViewBag.REQ_WORK_TIME_TO = REQ_WORK_TIME_TO;
				ViewBag.REQ_WORK_TIME_NEGO = REQ_WORK_TIME_NEGO;
				ViewBag.REQ_WORK_TIME_TEXT = REQ_WORK_TIME_TEXT;
				ViewBag.REQ_WORK_AGE = REQ_WORK_AGE;
				ViewBag.REQ_WORK_AGE_N = REQ_WORK_AGE_N;
				ViewBag.REQ_WORK_AGE_TEXT = REQ_WORK_AGE_TEXT;
				ViewBag.REQ_WORK_SEX = REQ_WORK_SEX;
				ViewBag.REQ_WORK_SEX_N = REQ_WORK_SEX_N;
				ViewBag.REQ_WORK_SEX_TEXT = REQ_WORK_SEX_TEXT;
				ViewBag.REQ_WORK_TXT = REQ_WORK_TXT;
			}
			else
			{
				ViewBag.REQ_WORK_PAYF = REQ_WORK_PAYF != "0" ? REQ_WORK_PAYF : nvc_cookie["work_payf_cookie"];
				ViewBag.REQ_WORK_PAYAMOUNT = REQ_WORK_PAYAMOUNT != "0" ? REQ_WORK_PAYAMOUNT : nvc_cookie["work_payamount_cookie"];
				ViewBag.REQ_WORK_PAY_TEXT = !(REQ_WORK_PAY_TEXT.Equals("0") || string.IsNullOrEmpty(REQ_WORK_PAY_TEXT)) ? REQ_WORK_PAY_TEXT : nvc_cookie["work_pay_text_cookie"];
				ViewBag.REQ_WORK_WF = REQ_WORK_WF != "0" ? REQ_WORK_WF : nvc_cookie["work_wf_cookie"];
				ViewBag.REQ_WORK_WTEXT = !(REQ_WORK_WTEXT.Equals("0") || string.IsNullOrEmpty(REQ_WORK_WTEXT)) ? REQ_WORK_WTEXT : nvc_cookie["work_wtext_cookie"];
				ViewBag.REQ_WORK_DAY_WEEK = REQ_WORK_DAY_WEEK != "0" ? REQ_WORK_DAY_WEEK : nvc_cookie["work_day_week_cookie"];
				ViewBag.REQ_WORK_DAY_WEEK_NEGO = REQ_WORK_DAY_WEEK_NEGO != "" ? REQ_WORK_DAY_WEEK_NEGO : nvc_cookie["work_day_week_nego_cookie"];
				ViewBag.REQ_WORK_DAY_WEEK_TEXT = REQ_WORK_DAY_WEEK_TEXT != "" ? REQ_WORK_DAY_WEEK_TEXT : nvc_cookie["work_day_week_text_cookie"];
				ViewBag.REQ_WORK_TIME = REQ_WORK_TIME != "0" ? REQ_WORK_TIME : nvc_cookie["work_time_cookie"];
				ViewBag.REQ_WORK_TIMEF = REQ_WORK_TIMEF != "0" ? REQ_WORK_TIMEF : nvc_cookie["work_timef_cookie"];
				ViewBag.REQ_WORK_TIME_FROM = REQ_WORK_TIME_FROM != "" ? REQ_WORK_TIME_FROM : nvc_cookie["work_time_from_cookie"];
				ViewBag.REQ_WORK_TIME_TO = REQ_WORK_TIME_TO != "" ? REQ_WORK_TIME_TO : nvc_cookie["work_time_to_cookie"];
				ViewBag.REQ_WORK_TIME_NEGO = REQ_WORK_TIME_NEGO != "" ? REQ_WORK_TIME_NEGO : nvc_cookie["work_time_nego_cookie"];
				ViewBag.REQ_WORK_TIME_TEXT = REQ_WORK_TIME_TEXT != "" ? REQ_WORK_TIME_TEXT : nvc_cookie["work_time_text_cookie"];
				ViewBag.REQ_WORK_AGE = REQ_WORK_AGE != "" ? REQ_WORK_AGE : nvc_cookie["work_age_cookie"];
				ViewBag.REQ_WORK_AGE_N = REQ_WORK_AGE_N != "" ? REQ_WORK_AGE_N : nvc_cookie["work_age_n_cookie"];
				ViewBag.REQ_WORK_AGE_TEXT = REQ_WORK_AGE_TEXT != "" ? REQ_WORK_AGE_TEXT : nvc_cookie["work_age_text_cookie"];
				ViewBag.REQ_WORK_SEX = REQ_WORK_SEX != "0" ? REQ_WORK_SEX : nvc_cookie["work_sex_cookie"];
				ViewBag.REQ_WORK_SEX_N = REQ_WORK_SEX_N != "" ? REQ_WORK_SEX_N : nvc_cookie["work_sex_n_cookie"];
				ViewBag.REQ_WORK_SEX_TEXT = REQ_WORK_SEX_TEXT != "" ? REQ_WORK_SEX_TEXT : nvc_cookie["work_sex_text_cookie"];
				ViewBag.REQ_WORK_TXT = REQ_WORK_TXT != "" ? REQ_WORK_TXT : nvc_cookie["work_txt"];
			}
			#endregion

			#endregion


			NameValueCollection eVnvc = new NameValueCollection();
			eVnvc["DEVICE_ID"] = gMachinID; //운영      									
			MediaWill._Data.MDT_Service ms = new MediaWill._Data.MDT_Service();
			ViewBag.Event_State = ms.GET_MOBILE_APPDOWN_EVENT_TARGET_CHECK_PROC(eVnvc);
			ViewBag.DeviceID = gMachinID;

			return View();
		}

		#region  지역 조건검색 ---------------------------------------------------------------------------------------------------
		/// <summary>지역선택</summary>
		/// <returns></returns>
		public ActionResult Area()
		{
			#region 검색조건 사용여부
			string AREA_USE = Req.GetString("AREA_USE", "Y");  //검색조건 사용여부
			string CATE_USE = Req.GetString("CATE_USE", "Y");  //검색조건 사용여부
			string WORK_USE = Req.GetString("WORK_USE", "Y");  //검색조건 사용여부

			ViewBag.AREA_USE = AREA_USE;
			ViewBag.CATE_USE = CATE_USE;
			ViewBag.WORK_USE = WORK_USE;
			#endregion

<<<<<<< HEAD
     //뒤로가기를 눌렀을 경우 Hub 페이지로 돌아가기 위한 파라미터
     string RETURN_URL = Req.GetString("RETURN_URL", "");
     ViewBag.RETURN_URL = RETURN_URL;

     //쿠키를 사용 Request값을 생성할지에 대한 여부
     string USE_COOKIE = Req.GetString("USE_COOKIE", "N" );
=======
			//뒤로가기를 눌렀을 경우 Hub 페이지로 돌아가기 위한 파라미터
			string RETURN_URL = Req.GetString("RETURN_URL", "");
			ViewBag.RETURN_URL = RETURN_URL;

			//쿠키를 사용 Request값을 생성할지에 대한 여부
			string USE_COOKIE = Req.GetString("USE_COOKIE", "N");
>>>>>>> develop

			string REQ_KEYWORD = Req.GetString("REQ_KEYWORD", "");  //통합검색 키워드
			ViewBag.REQ_KEYWORD = REQ_KEYWORD;

<<<<<<< HEAD
      NameValueCollection nvc_cookie = null;
      // 검색조건 기본 셋팅            
      nvc_cookie = initConditionalSearchCookie();

      string SELECT_PAGE = Req.GetString("SELECT_PAGE", "");
      string SEARCH_LOCATION = Req.GetString("SEARCH_LOCATION", "");
      ViewBag.SEARCH_LOCATION = SEARCH_LOCATION;

      //ViewBag.COOKIE_TYPE = "MS";   // "" : 기본(단일선택), "MT" : 다중선택, "OT" : 우리동네일자리, "SW" : 역세권, "MS" : 다중선택(NEW), "KO" : 다중선택(KONAN)
      string COOKIE_TYPE = Req.GetString("COOKIE_TYPE", "MS");
      ViewBag.COOKIE_TYPE = COOKIE_TYPE;

      // 쿠키 가져오기
      nvc_cookie = getConditionalSearchCookie(null, ViewBag.COOKIE_TYPE, AREA_USE, CATE_USE, WORK_USE);
=======
			NameValueCollection nvc_cookie = null;
			// 검색조건 기본 셋팅            
			nvc_cookie = initConditionalSearchCookie();

			string SELECT_PAGE = Req.GetString("SELECT_PAGE", "");
			string SEARCH_LOCATION = Req.GetString("SEARCH_LOCATION", "");
			ViewBag.SEARCH_LOCATION = SEARCH_LOCATION;

			//ViewBag.COOKIE_TYPE = "MS";   // "" : 기본(단일선택), "MT" : 다중선택, "OT" : 우리동네일자리, "SW" : 역세권, "MS" : 다중선택(NEW), "KO" : 다중선택(KONAN)
			string COOKIE_TYPE = Req.GetString("COOKIE_TYPE", "MS");
			ViewBag.COOKIE_TYPE = COOKIE_TYPE;

			// 쿠키 가져오기
			nvc_cookie = getConditionalSearchCookie(null, ViewBag.COOKIE_TYPE, AREA_USE, CATE_USE, WORK_USE);
>>>>>>> develop

			ViewBag.PAGE_LOCATION = Req.GetString("PAGE_LOCATION", "");
			ViewBag.SPID = Req.GetString("SPID", "");
			ViewBag.BR_GBN = Req.GetString("BR_GBN", "");
			ViewBag.BR_SEQ = Req.GetString("BR_SEQ", "");

<<<<<<< HEAD
      if ((ViewBag.PAGE_LOCATION == "SPECIAL" || ViewBag.PAGE_LOCATION == "BRAND") && string.IsNullOrEmpty(SEARCH_LOCATION))
=======
			if ((ViewBag.PAGE_LOCATION == "SPECIAL" || ViewBag.PAGE_LOCATION == "BRAND") && string.IsNullOrEmpty(SEARCH_LOCATION))
>>>>>>> develop
			{
				ViewBag.lCOUNT_AREA = 1;
			}
			else
			{
				ViewBag.lCOUNT_AREA = 5;
			}

			string REQ_AREA = Req.GetString("REQ_AREA", "");
			string REQ_AREA_TXT = Req.GetString("REQ_AREA_TXT", "");
			string REQ_AREA_COUNT = Req.GetString("REQ_AREA_COUNT", "0");

			ViewBag.REQ_AREA = REQ_AREA;
			ViewBag.REQ_AREA_TXT = REQ_AREA_TXT;
			ViewBag.REQ_AREA_COUNT = REQ_AREA_COUNT;

			if (REQ_AREA == "" && !string.IsNullOrEmpty(nvc_cookie["area_cookie"]) && USE_COOKIE == "Y")
			{
				ViewBag.REQ_AREA = nvc_cookie["area_cookie"];
				ViewBag.REQ_AREA_TXT = nvc_cookie["area_txt_cookie"];
				ViewBag.REQ_AREA_COUNT = nvc_cookie["area_cookie"].Split(',').Length.ToString();
			}

			string REQ_CATE = Req.GetString("REQ_CATE", "");
			string REQ_CATE_TXT = Req.GetString("REQ_CATE_TXT", "");
			string REQ_CATE_COUNT = Req.GetString("REQ_CATE_COUNT", "0");

			ViewBag.REQ_CATE = REQ_CATE;
			ViewBag.REQ_CATE_TXT = REQ_CATE_TXT;
			ViewBag.REQ_CATE_COUNT = REQ_CATE_COUNT;

			if (REQ_CATE == "" && !string.IsNullOrEmpty(nvc_cookie["cate_cookie"]) && USE_COOKIE == "Y")
			{
				ViewBag.REQ_CATE = nvc_cookie["cate_cookie"];
				ViewBag.REQ_CATE_TXT = nvc_cookie["cate_txt_cookie"];
				ViewBag.REQ_CATE_COUNT = nvc_cookie["cate_cookie"].Split(',').Length.ToString();
			}

			ViewBag.SELECT_PAGE = "Y";

			//근무조건      
			string REQ_WORK_PAYF = Req.GetString("REQ_WORK_PAYF", "0");
			string REQ_WORK_PAYAMOUNT = Req.GetString("REQ_WORK_PAYAMOUNT", "0");
			string REQ_WORK_PAY_TEXT = Req.GetString("REQ_WORK_PAY_TEXT", "");
			string REQ_WORK_WF = Req.GetString("REQ_WORK_WF", "0");
			string REQ_WORK_WTEXT = Req.GetString("REQ_WORK_WTEXT", "0");
			string REQ_WORK_DAY_WEEK = Req.GetString("REQ_WORK_DAY_WEEK", "0");
			string REQ_WORK_DAY_WEEK_NEGO = Req.GetString("REQ_WORK_DAY_WEEK_NEGO", "");
			string REQ_WORK_DAY_WEEK_TEXT = Req.GetString("REQ_WORK_DAY_WEEK_TEXT", "");
			string REQ_WORK_TIME = Req.GetString("REQ_WORK_TIME", "0");
			string REQ_WORK_TIMEF = Req.GetString("REQ_WORK_TIMEF", "0");
			string REQ_WORK_TIME_FROM = Req.GetString("REQ_WORK_TIME_FROM", "");
			string REQ_WORK_TIME_TO = Req.GetString("REQ_WORK_TIME_TO", "");
			string REQ_WORK_TIME_NEGO = Req.GetString("REQ_WORK_TIME_NEGO", "");
			string REQ_WORK_TIME_TEXT = Req.GetString("REQ_WORK_TIME_TEXT", "");
			string REQ_WORK_AGE = Req.GetString("REQ_WORK_AGE", "");
			string REQ_WORK_AGE_N = Req.GetString("REQ_WORK_AGE_N", "");
			string REQ_WORK_AGE_TEXT = Req.GetString("REQ_WORK_AGE_TEXT", "");
			string REQ_WORK_SEX = Req.GetString("REQ_WORK_SEX", "0");
			string REQ_WORK_SEX_N = Req.GetString("REQ_WORK_SEX_N", "");
			string REQ_WORK_SEX_TEXT = Req.GetString("REQ_WORK_SEX_TEXT", "");
			string REQ_WORK_TXT = Req.GetString("REQ_WORK_TXT", "");

			if (USE_COOKIE == "N")
			{
				ViewBag.REQ_WORK_PAYF = REQ_WORK_PAYF;
				ViewBag.REQ_WORK_PAYAMOUNT = REQ_WORK_PAYAMOUNT;
				ViewBag.REQ_WORK_PAY_TEXT = REQ_WORK_PAY_TEXT;
				ViewBag.REQ_WORK_WF = REQ_WORK_WF;
				ViewBag.REQ_WORK_WTEXT = REQ_WORK_WTEXT;
				ViewBag.REQ_WORK_DAY_WEEK = REQ_WORK_DAY_WEEK;
				ViewBag.REQ_WORK_DAY_WEEK_NEGO = REQ_WORK_DAY_WEEK_NEGO;
				ViewBag.REQ_WORK_DAY_WEEK_TEXT = REQ_WORK_DAY_WEEK_TEXT;
				ViewBag.REQ_WORK_TIME = REQ_WORK_TIME;
				ViewBag.REQ_WORK_TIMEF = REQ_WORK_TIMEF;
				ViewBag.REQ_WORK_TIME_FROM = REQ_WORK_TIME_FROM;
				ViewBag.REQ_WORK_TIME_TO = REQ_WORK_TIME_TO;
				ViewBag.REQ_WORK_TIME_NEGO = REQ_WORK_TIME_NEGO;
				ViewBag.REQ_WORK_TIME_TEXT = REQ_WORK_TIME_TEXT;
				ViewBag.REQ_WORK_AGE = REQ_WORK_AGE;
				ViewBag.REQ_WORK_AGE_N = REQ_WORK_AGE_N;
				ViewBag.REQ_WORK_AGE_TEXT = REQ_WORK_AGE_TEXT;
				ViewBag.REQ_WORK_SEX = REQ_WORK_SEX;
				ViewBag.REQ_WORK_SEX_N = REQ_WORK_SEX_N;
				ViewBag.REQ_WORK_SEX_TEXT = REQ_WORK_SEX_TEXT;
				ViewBag.REQ_WORK_TXT = REQ_WORK_TXT;
			}
			else
			{
				ViewBag.REQ_WORK_PAYF = REQ_WORK_PAYF != "0" ? REQ_WORK_PAYF : nvc_cookie["work_payf_cookie"];
				ViewBag.REQ_WORK_PAYAMOUNT = REQ_WORK_PAYAMOUNT != "0" ? REQ_WORK_PAYAMOUNT : nvc_cookie["work_payamount_cookie"];
				ViewBag.REQ_WORK_PAY_TEXT = !(REQ_WORK_PAY_TEXT.Equals("0") || string.IsNullOrEmpty(REQ_WORK_PAY_TEXT)) ? REQ_WORK_PAY_TEXT : nvc_cookie["work_pay_text_cookie"];
				ViewBag.REQ_WORK_WF = REQ_WORK_WF != "0" ? REQ_WORK_WF : nvc_cookie["work_wf_cookie"];
				ViewBag.REQ_WORK_WTEXT = !(REQ_WORK_WTEXT.Equals("0") || string.IsNullOrEmpty(REQ_WORK_WTEXT)) ? REQ_WORK_WTEXT : nvc_cookie["work_wtext_cookie"];
				ViewBag.REQ_WORK_DAY_WEEK = REQ_WORK_DAY_WEEK != "0" ? REQ_WORK_DAY_WEEK : nvc_cookie["work_day_week_cookie"];
				ViewBag.REQ_WORK_DAY_WEEK_NEGO = REQ_WORK_DAY_WEEK_NEGO != "" ? REQ_WORK_DAY_WEEK_NEGO : nvc_cookie["work_day_week_nego_cookie"];
				ViewBag.REQ_WORK_DAY_WEEK_TEXT = REQ_WORK_DAY_WEEK_TEXT != "" ? REQ_WORK_DAY_WEEK_TEXT : nvc_cookie["work_day_week_text_cookie"];
				ViewBag.REQ_WORK_TIME = REQ_WORK_TIME != "0" ? REQ_WORK_TIME : nvc_cookie["work_time_cookie"];
				ViewBag.REQ_WORK_TIMEF = REQ_WORK_TIMEF != "0" ? REQ_WORK_TIMEF : nvc_cookie["work_timef_cookie"];
				ViewBag.REQ_WORK_TIME_FROM = REQ_WORK_TIME_FROM != "" ? REQ_WORK_TIME_FROM : nvc_cookie["work_time_from_cookie"];
				ViewBag.REQ_WORK_TIME_TO = REQ_WORK_TIME_TO != "" ? REQ_WORK_TIME_TO : nvc_cookie["work_time_to_cookie"];
				ViewBag.REQ_WORK_TIME_NEGO = REQ_WORK_TIME_NEGO != "" ? REQ_WORK_TIME_NEGO : nvc_cookie["work_time_nego_cookie"];
				ViewBag.REQ_WORK_TIME_TEXT = REQ_WORK_TIME_TEXT != "" ? REQ_WORK_TIME_TEXT : nvc_cookie["work_time_text_cookie"];
				ViewBag.REQ_WORK_AGE = REQ_WORK_AGE != "" ? REQ_WORK_AGE : nvc_cookie["work_age_cookie"];
				ViewBag.REQ_WORK_AGE_N = REQ_WORK_AGE_N != "" ? REQ_WORK_AGE_N : nvc_cookie["work_age_n_cookie"];
				ViewBag.REQ_WORK_AGE_TEXT = REQ_WORK_AGE_TEXT != "" ? REQ_WORK_AGE_TEXT : nvc_cookie["work_age_text_cookie"];
				ViewBag.REQ_WORK_SEX = REQ_WORK_SEX != "0" ? REQ_WORK_SEX : nvc_cookie["work_sex_cookie"];
				ViewBag.REQ_WORK_SEX_N = REQ_WORK_SEX_N != "" ? REQ_WORK_SEX_N : nvc_cookie["work_sex_n_cookie"];
				ViewBag.REQ_WORK_SEX_TEXT = REQ_WORK_SEX_TEXT != "" ? REQ_WORK_SEX_TEXT : nvc_cookie["work_sex_text_cookie"];
				ViewBag.REQ_WORK_TXT = REQ_WORK_TXT != "" ? REQ_WORK_TXT : nvc_cookie["work_txt"];
			}

			return View();
		}

		/// <summary>지역검색</summary>
		/// <returns></returns>
		public ActionResult AreaSearch()
		{
			#region 검색조건 사용여부
			string AREA_USE = Req.GetString("AREA_USE", "Y");  //검색조건 사용여부
			string CATE_USE = Req.GetString("CATE_USE", "Y");  //검색조건 사용여부
			string WORK_USE = Req.GetString("WORK_USE", "Y");  //검색조건 사용여부

			ViewBag.AREA_USE = AREA_USE;
			ViewBag.CATE_USE = CATE_USE;
			ViewBag.WORK_USE = WORK_USE;
			#endregion

			//뒤로가기를 눌렀을 경우 Hub 페이지로 돌아가기 위한 파라미터
			string RETURN_URL = Req.GetString("RETURN_URL", "");
			ViewBag.RETURN_URL = RETURN_URL;

			string REQ_KEYWORD = Req.GetString("REQ_KEYWORD", "");  //통합검색 키워드
			ViewBag.REQ_KEYWORD = REQ_KEYWORD;

			string COOKIE_TYPE = Req.GetString("COOKIE_TYPE", "MS");
			ViewBag.COOKIE_TYPE = COOKIE_TYPE;

			string SEARCH_LOCATION = Req.GetString("SEARCH_LOCATION", "");
			ViewBag.SEARCH_LOCATION = SEARCH_LOCATION;

			ViewBag.PAGE_LOCATION = Req.GetString("PAGE_LOCATION", "");
			ViewBag.SPID = Req.GetString("SPID", "");
			ViewBag.BR_GBN = Req.GetString("BR_GBN", "");
			ViewBag.BR_SEQ = Req.GetString("BR_SEQ", "");

			if ((ViewBag.PAGE_LOCATION == "SPECIAL" || ViewBag.PAGE_LOCATION == "BRAND") && string.IsNullOrEmpty(SEARCH_LOCATION))
			{
				ViewBag.lCOUNT_AREA = 1;
			}
			else
			{
				ViewBag.lCOUNT_AREA = 5;
			}

			string REQ_AREA = Req.GetString("REQ_AREA", "");
			string REQ_AREA_TXT = Req.GetString("REQ_AREA_TXT", "");
			string REQ_AREA_COUNT = Req.GetString("REQ_AREA_COUNT", "0");

			ViewBag.REQ_AREA = REQ_AREA;
			ViewBag.REQ_AREA_TXT = REQ_AREA_TXT;
			ViewBag.REQ_AREA_COUNT = REQ_AREA_COUNT;

			string REQ_CATE = Req.GetString("REQ_CATE", "");
			string REQ_CATE_TXT = Req.GetString("REQ_CATE_TXT", "");
			string REQ_CATE_COUNT = Req.GetString("REQ_CATE_COUNT", "0");

			ViewBag.REQ_CATE = REQ_CATE;
			ViewBag.REQ_CATE_TXT = REQ_CATE_TXT;
			ViewBag.REQ_CATE_COUNT = REQ_CATE_COUNT;

			ViewBag.SELECT_PAGE = "Y";

			string REQ_WORK_DAY_WEEK = Req.GetString("REQ_WORK_DAY_WEEK", "0");
			string REQ_WORK_DAY_WEEK_NEGO = Req.GetString("REQ_WORK_DAY_WEEK_NEGO", "");
			string REQ_WORK_TIME = Req.GetString("REQ_WORK_TIME", "0");
			string REQ_WORK_TIME_FROM = Req.GetString("REQ_WORK_TIME_FROM", "");
			string REQ_WORK_TIME_TO = Req.GetString("REQ_WORK_TIME_TO", "");
			string REQ_WORK_TIME_NEGO = Req.GetString("REQ_WORK_TIME_NEGO", "");
			string REQ_WORK_AGE = Req.GetString("REQ_WORK_AGE", "");
			string REQ_WORK_AGE_N = Req.GetString("REQ_WORK_AGE_N", "");
			string REQ_WORK_SEX = Req.GetString("REQ_WORK_SEX", "0");
			string REQ_WORK_SEX_N = Req.GetString("REQ_WORK_SEX_N", "");
			string REQ_WORK_TXT = Req.GetString("REQ_WORK_TXT", "");

			ViewBag.REQ_WORK_DAY_WEEK = REQ_WORK_DAY_WEEK;
			ViewBag.REQ_WORK_DAY_WEEK_NEGO = REQ_WORK_DAY_WEEK_NEGO;
			ViewBag.REQ_WORK_TIME = REQ_WORK_TIME;
			ViewBag.REQ_WORK_TIME_FROM = REQ_WORK_TIME_FROM;
			ViewBag.REQ_WORK_TIME_TO = REQ_WORK_TIME_TO;
			ViewBag.REQ_WORK_TIME_NEGO = REQ_WORK_TIME_NEGO;
			ViewBag.REQ_WORK_AGE = REQ_WORK_AGE;
			ViewBag.REQ_WORK_AGE_N = REQ_WORK_AGE_N;
			ViewBag.REQ_WORK_SEX = REQ_WORK_SEX;
			ViewBag.REQ_WORK_SEX_N = REQ_WORK_SEX_N;
			ViewBag.REQ_WORK_TXT = REQ_WORK_TXT;

			return View();
		}

		/// <summary>지역선택 - "시/군/구" 가져오기 Ajax</summary>
		/// <returns></returns>
		public string AjaxAreaCityList()
		{
			string rtnValue = string.Empty;
			try
			{
				lCOUNT_AREA = Req.GetInt("lCOUNT_AREA", lCOUNT_AREA);
				int sCOUNT_AREA = Req.GetInt("sCOUNT_AREA", 0);   //총 선택 카운트

				string cMETRO = Req.GetString("cMETRO", "");    // 클릭 "시/도" 지역            
				string cMETRO_TXT = Req.GetString("cMETRO_TXT", "");    //클릭 "시/도" 지역 텍스트
				if (!string.IsNullOrEmpty(cMETRO_TXT))
				{
					cMETRO_TXT = HttpUtility.UrlDecode(cMETRO_TXT);
				}

				string sAREA = Req.GetString("sAREA", "");  // 선택지역
				string sAREA_TXT = Req.GetString("sAREA_TXT", "");  // 선택지역 텍스트

				string[] arrArea = null;
				if (!string.IsNullOrEmpty(sAREA))
				{
					sAREA = HttpUtility.UrlDecode(sAREA);
					arrArea = sAREA.Split(',');
				}
				string[] arrAreaTxt = null;
				if (!string.IsNullOrEmpty(sAREA_TXT))
				{
					sAREA_TXT = HttpUtility.UrlDecode(sAREA_TXT);
					arrAreaTxt = sAREA_TXT.Split(',');
				}

				string checkedString = string.Empty;
				if (arrArea != null)
				{
					for (int t = 0; t < arrArea.Length; t++)
					{
						if (cMETRO == arrArea[t])
						{
							// 전체 체크시
							checkedString = " checked";
							break;
						}
						else if (("," + arrArea[t]).IndexOf("," + cMETRO) > -1)
						{
							// 선택된 항목의 상위 지역이면..
							checkedString = string.Empty;
							break;
						}
					}
				}

				NameValueCollection nvc = new NameValueCollection();
				nvc["Kind"] = "5";
				nvc["Level"] = "2";
				nvc["Area_Code"] = cMETRO;

				MediaWill._Data.MDT_Job_ReNew mdjr = new MediaWill._Data.MDT_Job_ReNew();

				// "시/군/구" 지역 가져오기
				DataSet dsCity = mdjr.GetAreaDropDownList(nvc);
				DataTable dtCity = dsCity.Tables["LIST"];

				StringBuilder sb = new StringBuilder();
				if (dtCity.Rows.Count > 0)
				{
					sb.Append("<!-- tab-contents -->" + "\r\n");
					sb.Append("<div class=\"tab-contents\">" + "\r\n");
					sb.Append("    <div class=\"tab-contents__check\">" + "\r\n");
					sb.Append("        <span class=\"inp-check\">" + "\r\n");
					sb.AppendFormat("            <label for=\"chkAll_AREA_A_{0}\" class=\"inp-check__label\">{1} 전체</label>" + "\r\n", cMETRO, cMETRO_TXT);
					sb.AppendFormat("            <input type=\"checkbox\" name=\"chkAll_AREA_A_{0}\" id=\"chkAll_AREA_A_{1}\" val=\"{2}\" valtxt=\"{3}\" valfulltxt=\"{4}\" {5} class=\"inp-check__all\" onclick=\"AreaCheckEvt(this, '');\">" + "\r\n", cMETRO, cMETRO, cMETRO, cMETRO_TXT, cMETRO_TXT + " 전체", checkedString);
					sb.Append("        </span>" + "\r\n");
					sb.Append("    </div>" + "\r\n");

					DataRow dr;
					int i;
					//int j = 0;                    
					string AREA_B_GROUP = string.Empty;

					for (i = 0; i < dtCity.Rows.Count; i++)
					{
						dr = dtCity.Rows[i];

						if (i % 2 == 0)
						{
							sb.Append("    <!-- list-box11 -->" + "\r\n");
							sb.Append("    <div class=\"list-box\">" + "\r\n");
						}

						sb.Append("        <!-- tab-list -->" + "\r\n");
						sb.Append("        <dl class=\"tab-list\">" + "\r\n");
						sb.Append("            <!-- 2depth -->" + "\r\n");
						sb.Append("            <dt class=\"tab-list__title\">" + "\r\n");
						sb.AppendFormat("                <a href=\"javascript:;\" onclick=\"detailView(this);return false;\" AREA_B_CODE=\"{0}\" AREA_B_GROUP=\"{1}\" AREA_B_TEXT=\"{2}\" AREA_A_TEXT=\"{3}\">{4}</a>" + "\r\n", dr["AREA_B_CODE"].ToString(), dr["AREA_B_GROUP"].ToString(), dr["CITY"].ToString(), cMETRO_TXT, dr["CITY"].ToString());
						sb.Append("            </dt>" + "\r\n");
						sb.Append("            <!-- // 2depth -->" + "\r\n");
						sb.Append("            <!-- 3depth -->" + "\r\n");
						sb.AppendFormat("            <dd class=\"tab-list__view\" id=\"AREA_C_HTML_{0}\">" + "\r\n", dr["AREA_B_CODE"].ToString());
						sb.Append("            </dd>" + "\r\n");
						sb.Append("            <!-- // 3depth -->" + "\r\n");
						sb.Append("        </dl>" + "\r\n");
						sb.Append("        <!-- // tab-list -->" + "\r\n");

						if (i % 2 == 1)
						{
							sb.Append("    </div>" + "\r\n");
							sb.Append("    <!-- // list-box -->" + "\r\n");
						}
					}
				}

				dsCity.Dispose();
				dtCity.Dispose();

				rtnValue = sb.ToString();
			}
			catch (Exception ex)
			{
				rtnValue = ex.Message;
				rtnValue = string.Empty;
			}
			return rtnValue;
		}

		/// <summary>지역선택 - "동/읍/면" 가져오기 Ajax</summary>
		/// <returns></returns>
		public string AjaxAreaDongList()
		{
			string rtnValue = string.Empty;
			try
			{
				lCOUNT_AREA = Req.GetInt("lCOUNT_AREA", lCOUNT_AREA);
				int sCOUNT_AREA = Req.GetInt("sCOUNT_AREA", 0);   //현재 페이지 선택 된 지역 갯수

				string cCITY = Req.GetString("cCITY", "");  //클릭 "시/군/구" 지역
				string cCITY_TEXT = Req.GetString("cCITY_TXT", ""); // 도시 체크여부(true/false)
				string sAREA = Req.GetString("sAREA", "");  // 선택지역
				string sAREA_TXT = Req.GetString("sAREA_TXT", "");  // 선택지역 텍스트
																														//string cMETRO = Req.GetString("cMETRO", "");    // 클릭 "시/도" 지역            
				string sMETRO_TXT = Req.GetString("sMETRO_TXT", "");    //클릭 "시/도" 지역 텍스트
				if (!string.IsNullOrEmpty(sMETRO_TXT))
				{
					sMETRO_TXT = HttpUtility.UrlDecode(sMETRO_TXT);
				}

				string OTJF = Req.GetString("OTJF", "0");   // 우리동네일자리로부터 호출여부

				string[] arrArea = null;
				if (!string.IsNullOrEmpty(sAREA))
				{
					sAREA = HttpUtility.UrlDecode(sAREA);
					arrArea = sAREA.Split(',');
				}
				string[] arrAreaTxt = null;
				if (!string.IsNullOrEmpty(sAREA_TXT))
				{
					sAREA_TXT = HttpUtility.UrlDecode(sAREA_TXT);
					arrAreaTxt = sAREA_TXT.Split(',');
				}

				string checkedString = string.Empty;
				if (arrArea != null)
				{
					for (int t = 0; t < arrArea.Length; t++)
					{
						if (cCITY == arrArea[t])
						{
							// 전체 체크시
							checkedString = " checked";
							break;
						}
						else if (("," + arrArea[t]).IndexOf("," + cCITY) > -1)
						{
							// 선택된 항목의 상위 지역이면..
							checkedString = string.Empty;
							break;
						}
					}
				}

				MediaWill._Data.MDT_Job_ReNew mdjr = new MediaWill._Data.MDT_Job_ReNew();

				NameValueCollection nvc = new NameValueCollection();
				nvc["Kind"] = "5";
				nvc["Level"] = "3";
				nvc["Area_Code"] = cCITY;
				nvc["OTJF"] = OTJF;

				// "동/읍/면" 지역 가져오기
				DataSet dsDong = mdjr.GetAreaDropDownList(nvc);
				DataTable dtDong = dsDong.Tables["LIST"];

				StringBuilder sb = new StringBuilder();
				if (dtDong.Rows.Count > 0)
				{
					sb.Append("            <ul class=\"inp-list\">" + "\r\n");
					sb.Append("                <li class=\"inp-list__item--all\">" + "\r\n");
					sb.Append("                    <span class=\"inp-check\">" + "\r\n");
					sb.AppendFormat("                        <label for=\"chkAll_AREA_B_{0}\" class=\"inp-check__label\">{1} 전체</label>" + "\r\n", cCITY, cCITY_TEXT);
					//sb.AppendFormat("                        <input type=\"checkbox\" name=\"chkAll_AREA_B_{0}\" id=\"chkAll_AREA_B_{1}\" val=\"{2}\" valtxt=\"{3}\" valfulltxt=\"{4}\" {5} class=\"inp-check__subAll\" onclick=\"AreaCheckEvt(this, '');\">" + "\r\n", cCITY, cCITY, cCITY, cCITY_TEXT, sMETRO_TXT + "==" + cCITY_TEXT + " 전체", checkedString);
					sb.AppendFormat("                        <input type=\"checkbox\" name=\"chkAll_AREA_B_{0}\" id=\"chkAll_AREA_B_{1}\" val=\"{2}\" valtxt=\"{3}\" valfulltxt=\"{4}\" {5} class=\"inp-check__subAll\" onclick=\"AreaCheckEvt(this, '');\">" + "\r\n", cCITY, cCITY, cCITY, cCITY_TEXT, cCITY_TEXT + " 전체", checkedString);
					sb.Append("                    </span>" + "\r\n");
					sb.Append("                </li>" + "\r\n");

					DataRow dr;
					for (int i = 0; i < dtDong.Rows.Count; i++)
					{
						dr = dtDong.Rows[i];

						#region 선택항목 처리
						checkedString = string.Empty;
						if (!string.IsNullOrEmpty(sAREA))
						{
							if (("," + sAREA).IndexOf("," + dr["AREA_C_GROUP"].ToString()) > -1)
							{
								try
								{
									if (arrArea != null)
									{
										for (int j = 0; j < arrArea.Length; j++)
										{
											if (arrArea[j].Length == 8)
											{
												if (arrArea[j].Equals(dr["AREA_C_GROUP"].ToString()))
												{
													checkedString = "checked";
													break;
												}
											}
										}
									}
								}
								catch (Exception ex) { string err = ex.Message; }
							}
						}
						#endregion

						sb.Append("                <li class=\"inp-list__item\">" + "\r\n");
						sb.Append("                    <span class=\"inp-check\">" + "\r\n");
						sb.AppendFormat("                        <label for=\"chk_AREA_C_{0}\" class=\"inp-check__label\">{1}</label>" + "\r\n", dr["AREA_C_GROUP"].ToString(), dr["DONG_DETAIL"].ToString());
						sb.AppendFormat("                        <input type=\"checkbox\" name=\"chk_AREA_C_{0}\" id=\"chk_AREA_C_{1}\" val=\"{2}\" valtxt=\"{3}\" valfulltxt=\"{4}\" {5} onclick=\"AreaCheckEvt(this, '');\">" + "\r\n", dr["AREA_C_GROUP"].ToString(), dr["AREA_C_GROUP"].ToString(), dr["AREA_C_GROUP"].ToString(), dr["DONG_DETAIL"].ToString(), cCITY_TEXT + "==" + dr["DONG_DETAIL"].ToString(), checkedString);
						sb.Append("                    </span>" + "\r\n");
						sb.Append("                </li>" + "\r\n");
					}
					sb.Append("            </ul>" + "\r\n");
				}

				dsDong.Dispose();
				dtDong.Dispose();

				rtnValue = sb.ToString();
			}
			catch (Exception ex)
			{
				rtnValue = ex.Message;
				rtnValue = string.Empty;
			}
			return rtnValue;
		}

		/// <summary>지역검색 - 검색엔진</summary>
		/// <returns></returns>
		public string AreaSearchKonanApi()
		{
			string sVersion = Req.GetString("sVersion", "");
			string keyword = Req.GetString("keyword", "");
			string gbn = "area";

			string sAREA = Req.GetString("sAREA", "");  // 선택지역
			string sAREA_TXT = Req.GetString("sAREA_TXT", "");  // 선택지역 텍스트

			string[] arrArea = null;
			if (!string.IsNullOrEmpty(sAREA))
			{
				sAREA = HttpUtility.UrlDecode(sAREA);
				arrArea = sAREA.Split(',');
			}
			string[] arrAreaTxt = null;
			if (!string.IsNullOrEmpty(sAREA_TXT))
			{
				sAREA_TXT = HttpUtility.UrlDecode(sAREA_TXT);
				arrAreaTxt = sAREA_TXT.Split(',');
			}

			DataSet ds = new DataSet();
			NameValueCollection nvc_param = new NameValueCollection();

			nvc_param["searchEngine"] = (string.IsNullOrEmpty(getDevelopmentSubDomain()) ? "S" : "T"); //S(실서버) , T(로컬 및 테스트)
			nvc_param["searchService"] = "AREA_CATE";
			nvc_param["page"] = "1";
			nvc_param["pageSize"] = "200";
			nvc_param["keyword"] = keyword;
			nvc_param["gbn"] = gbn;
			nvc_param["mid"] = Req.GetString("mid", gMachinID);

			StringBuilder sb = new StringBuilder();
			if (keyword != "")
			{
				if (sVersion.Equals("v5"))
				{
					NameValueCollection nvc_autocomplete = new NameValueCollection();
					nvc_autocomplete["searchEngine"] = nvc_param["searchEngine"];
					nvc_autocomplete["searchService"] = "KFSLOGDICTIONARY";
					nvc_autocomplete["searchSection"] = "JOB";
					nvc_autocomplete["searchPlatform"] = "MOBILEWEB";
					nvc_autocomplete["searchDevice"] = "ANDROID";
					nvc_autocomplete["mid"] = nvc_param["mid"];   //앱<->모바일웹구분
					nvc_autocomplete["searchKfsApi"] = "AREA"; //지역
					nvc_autocomplete["keyword"] = keyword;

					MB.Search._BasePage_Konan_v5 objSearchv5 = new MB.Search._BasePage_Konan_v5();
					// 검색결과 가져오기
					ds = objSearchv5.ParseJsonToDataSetForAreaCate(objSearchv5.GetJsonKsfLogDictionaryToHtml(nvc_autocomplete).ToString(), nvc_autocomplete["searchKfsApi"]);
				}
				else
				{
					MB.Search._BasePage_Konan objSearch = new MB.Search._BasePage_Konan();
					// 검색결과 가져오기
					ds = objSearch.ParseJsonToDataSetForAreaCate(objSearch.GetSearchResult(objSearch.GetSearchUrl(nvc_param)));
				}

				DataTable dt1 = ds.Tables[0];
				DataTable dt2 = ds.Tables[1];

				if (dt2.Rows.Count > 0)
				{
					for (int i = 0; i < dt2.Rows.Count; i++)
					{
						string area_full_search = dt2.Rows[i]["area_full_search"].ToString();
						string area_full_text = dt2.Rows[i]["area_full_text"].ToString();
						string area_code = dt2.Rows[i]["area_code"].ToString();

						if (!string.IsNullOrEmpty(area_code))
						{
							string checkedString = string.Empty;
							if (arrArea != null)
							{
								for (int t = 0; t < arrArea.Length; t++)
								{
									if (area_code == arrArea[t])
									{
										// 전체 체크시
										checkedString = " checked";
										break;
									}
								}
							}

							if (sVersion.Equals("v5"))
							{
								area_full_search = area_full_search.Replace("&gt;", "<span class=\"depth\">&gt;</span>").Replace(keyword, "<strong>" + keyword + "</strong>"); //강조 표시
							}
							else
							{
								area_full_search = area_full_search.Replace("&gt;", "<span class=\"depth\">&gt;</span>").Replace("<b>", "<strong>").Replace("</b>", "</strong>").ToString();
							}
							area_full_text = area_full_text.Replace("&gt;", "==").Replace("<b>", "").Replace("</b>", "").ToString();

							sb.Append("<li class=\"auto-list__item\">" + "\r\n");
							sb.Append("    <span class=\"inp-check\">" + "\r\n");
							if (area_code.Length == 2)
							{
								sb.AppendFormat("        <label for=\"chkAll_AREA_A_{0}\" class=\"inp-check__label\">{1}</label>" + "\r\n", area_code, area_full_search);
								sb.AppendFormat("        <input type=\"checkbox\" name=\"chkAll_AREA_A_{0}\" id=\"chkAll_AREA_A_{1}\"  val=\"{2}\" valtxt=\"{3}\" valfulltxt=\"{4}\" {5} onclick=\"CheckEvt(this, '');\">" + "\r\n", area_code, area_code, area_code, area_full_text, area_full_text, checkedString);
							}
							else if (area_code.Length == 4)
							{
								sb.AppendFormat("        <label for=\"chkAll_AREA_B_{0}\" class=\"inp-check__label\">{1}</label>" + "\r\n", area_code, area_full_search);
								//sb.AppendFormat("        <input type=\"checkbox\" name=\"chkAll_AREA_B_{0}\" id=\"chkAll_AREA_B_{1}\" onclick=\"CheckEvt(this, '');\">" + "\r\n", area_code, area_code);
								sb.AppendFormat("        <input type=\"checkbox\" name=\"chkAll_AREA_B_{0}\" id=\"chkAll_AREA_B_{1}\"  val=\"{2}\" valtxt=\"{3}\" valfulltxt=\"{4}\" {5} onclick=\"CheckEvt(this, '');\">" + "\r\n", area_code, area_code, area_code, area_full_text, area_full_text, checkedString);
							}
							else
							{
								sb.AppendFormat("        <label for=\"chk_AREA_C_{0}\" class=\"inp-check__label\">{1}</label>" + "\r\n", area_code, area_full_search);
								//sb.AppendFormat("        <input type=\"checkbox\" name=\"chk_AREA_C_{0}\" id=\"chk_AREA_C_{1}\" onclick=\"CheckEvt(this, '');\">" + "\r\n", area_code, area_code);
								sb.AppendFormat("        <input type=\"checkbox\" name=\"chk_AREA_C_{0}\" id=\"chk_AREA_C_{1}\"  val=\"{2}\" valtxt=\"{3}\" valfulltxt=\"{4}\" {5} onclick=\"CheckEvt(this, '');\">" + "\r\n", area_code, area_code, area_code, area_full_text, area_full_text, checkedString);
							}
							sb.Append("    </span>" + "\r\n");
							sb.Append("</li>" + "\r\n");
						}
					}
				}
			}
			else
			{
				sb.Append("");
			}

			return sb.ToString();
		}
    #endregion

    #region  업직종 조건검색 ---------------------------------------------------------------------------------------------------
    /// <summary>업직종검색</summary>
    /// <returns></returns>
    public ActionResult Cate()
		{
			#region 검색조건 사용여부
			string AREA_USE = Req.GetString("AREA_USE", "Y");  //검색조건 사용여부
			string CATE_USE = Req.GetString("CATE_USE", "Y");  //검색조건 사용여부
			string WORK_USE = Req.GetString("WORK_USE", "Y");  //검색조건 사용여부

			ViewBag.AREA_USE = AREA_USE;
			ViewBag.CATE_USE = CATE_USE;
			ViewBag.WORK_USE = WORK_USE;
			#endregion

			//뒤로가기를 눌렀을 경우 Hub 페이지로 돌아가기 위한 파라미터
			string RETURN_URL = Req.GetString("RETURN_URL", "");
			ViewBag.RETURN_URL = RETURN_URL;

			//쿠키를 사용 Request값을 생성할지에 대한 여부
			string USE_COOKIE = Req.GetString("USE_COOKIE", "N");

			string REQ_KEYWORD = Req.GetString("REQ_KEYWORD", "");  //통합검색 키워드
			ViewBag.REQ_KEYWORD = REQ_KEYWORD;

			NameValueCollection nvc_cookie = null;
			// 검색조건 기본 셋팅            
			nvc_cookie = initConditionalSearchCookie();

			string COOKIE_TYPE = Req.GetString("COOKIE_TYPE", "MS");
			ViewBag.COOKIE_TYPE = COOKIE_TYPE;

			// 쿠키 가져오기
			nvc_cookie = getConditionalSearchCookie(null, ViewBag.COOKIE_TYPE, AREA_USE, CATE_USE, WORK_USE);

			string SEARCH_LOCATION = Req.GetString("SEARCH_LOCATION", "");
			ViewBag.SEARCH_LOCATION = SEARCH_LOCATION;

			ViewBag.PAGE_LOCATION = Req.GetString("PAGE_LOCATION", "");
			ViewBag.SPID = Req.GetString("SPID", "");
			ViewBag.BR_GBN = Req.GetString("BR_GBN", "");
			ViewBag.BR_SEQ = Req.GetString("BR_SEQ", "");

			if ((ViewBag.PAGE_LOCATION == "SPECIAL" || ViewBag.PAGE_LOCATION == "BRAND") && string.IsNullOrEmpty(SEARCH_LOCATION))
			{
				ViewBag.lCOUNT_CATE = 1;
			}
			else
			{
				ViewBag.lCOUNT_CATE = 5;
			}

			string REQ_AREA = Req.GetString("REQ_AREA", "");
			string REQ_AREA_TXT = Req.GetString("REQ_AREA_TXT", "");
			string REQ_AREA_COUNT = Req.GetString("REQ_AREA_COUNT", "0");

			ViewBag.REQ_AREA = REQ_AREA;
			ViewBag.REQ_AREA_TXT = REQ_AREA_TXT;
			ViewBag.REQ_AREA_COUNT = REQ_AREA_COUNT;

			if (REQ_AREA == "" && !string.IsNullOrEmpty(nvc_cookie["area_cookie"]) && USE_COOKIE == "Y")
			{
				ViewBag.REQ_AREA = nvc_cookie["area_cookie"];
				ViewBag.REQ_AREA_TXT = nvc_cookie["area_txt_cookie"];
				ViewBag.REQ_AREA_COUNT = nvc_cookie["area_cookie"].Split(',').Length.ToString();
			}

			string REQ_CATE = Req.GetString("REQ_CATE", "");
			string REQ_CATE_TXT = Req.GetString("REQ_CATE_TXT", "");
			string REQ_CATE_COUNT = Req.GetString("REQ_CATE_COUNT", "0");

			ViewBag.REQ_CATE = REQ_CATE;
			ViewBag.REQ_CATE_TXT = REQ_CATE_TXT;
			ViewBag.REQ_CATE_COUNT = REQ_CATE_COUNT;

			if (REQ_CATE == "" && !string.IsNullOrEmpty(nvc_cookie["cate_cookie"]) && USE_COOKIE == "Y")
			{
				ViewBag.REQ_CATE = nvc_cookie["cate_cookie"];
				ViewBag.REQ_CATE_TXT = nvc_cookie["cate_txt_cookie"];
				ViewBag.REQ_CATE_COUNT = nvc_cookie["cate_cookie"].Split(',').Length.ToString();
			}

			ViewBag.SELECT_PAGE = "Y";

			//근무조건      
			string REQ_WORK_PAYF = Req.GetString("REQ_WORK_PAYF", "0");
			string REQ_WORK_PAYAMOUNT = Req.GetString("REQ_WORK_PAYAMOUNT", "0");
			string REQ_WORK_PAY_TEXT = Req.GetString("REQ_WORK_PAY_TEXT", "");
			string REQ_WORK_WF = Req.GetString("REQ_WORK_WF", "0");
			string REQ_WORK_WTEXT = Req.GetString("REQ_WORK_WTEXT", "0");
			string REQ_WORK_DAY_WEEK = Req.GetString("REQ_WORK_DAY_WEEK", "0");
			string REQ_WORK_DAY_WEEK_NEGO = Req.GetString("REQ_WORK_DAY_WEEK_NEGO", "");
			string REQ_WORK_DAY_WEEK_TEXT = Req.GetString("REQ_WORK_DAY_WEEK_TEXT", "");
			string REQ_WORK_TIME = Req.GetString("REQ_WORK_TIME", "0");
			string REQ_WORK_TIMEF = Req.GetString("REQ_WORK_TIMEF", "0");
			string REQ_WORK_TIME_FROM = Req.GetString("REQ_WORK_TIME_FROM", "");
			string REQ_WORK_TIME_TO = Req.GetString("REQ_WORK_TIME_TO", "");
			string REQ_WORK_TIME_NEGO = Req.GetString("REQ_WORK_TIME_NEGO", "");
			string REQ_WORK_TIME_TEXT = Req.GetString("REQ_WORK_TIME_TEXT", "");
			string REQ_WORK_AGE = Req.GetString("REQ_WORK_AGE", "");
			string REQ_WORK_AGE_N = Req.GetString("REQ_WORK_AGE_N", "");
			string REQ_WORK_AGE_TEXT = Req.GetString("REQ_WORK_AGE_TEXT", "");
			string REQ_WORK_SEX = Req.GetString("REQ_WORK_SEX", "0");
			string REQ_WORK_SEX_N = Req.GetString("REQ_WORK_SEX_N", "");
			string REQ_WORK_SEX_TEXT = Req.GetString("REQ_WORK_SEX_TEXT", "");
			string REQ_WORK_TXT = Req.GetString("REQ_WORK_TXT", "");

			if (USE_COOKIE == "N")
			{
				ViewBag.REQ_WORK_PAYF = REQ_WORK_PAYF;
				ViewBag.REQ_WORK_PAYAMOUNT = REQ_WORK_PAYAMOUNT;
				ViewBag.REQ_WORK_PAY_TEXT = REQ_WORK_PAY_TEXT;
				ViewBag.REQ_WORK_WF = REQ_WORK_WF;
				ViewBag.REQ_WORK_WTEXT = REQ_WORK_WTEXT;
				ViewBag.REQ_WORK_DAY_WEEK = REQ_WORK_DAY_WEEK;
				ViewBag.REQ_WORK_DAY_WEEK_NEGO = REQ_WORK_DAY_WEEK_NEGO;
				ViewBag.REQ_WORK_DAY_WEEK_TEXT = REQ_WORK_DAY_WEEK_TEXT;
				ViewBag.REQ_WORK_TIME = REQ_WORK_TIME;
				ViewBag.REQ_WORK_TIMEF = REQ_WORK_TIMEF;
				ViewBag.REQ_WORK_TIME_FROM = REQ_WORK_TIME_FROM;
				ViewBag.REQ_WORK_TIME_TO = REQ_WORK_TIME_TO;
				ViewBag.REQ_WORK_TIME_NEGO = REQ_WORK_TIME_NEGO;
				ViewBag.REQ_WORK_TIME_TEXT = REQ_WORK_TIME_TEXT;
				ViewBag.REQ_WORK_AGE = REQ_WORK_AGE;
				ViewBag.REQ_WORK_AGE_N = REQ_WORK_AGE_N;
				ViewBag.REQ_WORK_AGE_TEXT = REQ_WORK_AGE_TEXT;
				ViewBag.REQ_WORK_SEX = REQ_WORK_SEX;
				ViewBag.REQ_WORK_SEX_N = REQ_WORK_SEX_N;
				ViewBag.REQ_WORK_SEX_TEXT = REQ_WORK_SEX_TEXT;
				ViewBag.REQ_WORK_TXT = REQ_WORK_TXT;
			}
			else
			{
				ViewBag.REQ_WORK_PAYF = REQ_WORK_PAYF != "0" ? REQ_WORK_PAYF : nvc_cookie["work_payf_cookie"];
				ViewBag.REQ_WORK_PAYAMOUNT = REQ_WORK_PAYAMOUNT != "0" ? REQ_WORK_PAYAMOUNT : nvc_cookie["work_payamount_cookie"];
				ViewBag.REQ_WORK_PAY_TEXT = !(REQ_WORK_PAY_TEXT.Equals("0") || string.IsNullOrEmpty(REQ_WORK_PAY_TEXT)) ? REQ_WORK_PAY_TEXT : nvc_cookie["work_pay_text_cookie"];
				ViewBag.REQ_WORK_WF = REQ_WORK_WF != "0" ? REQ_WORK_WF : nvc_cookie["work_wf_cookie"];
				ViewBag.REQ_WORK_WTEXT = !(REQ_WORK_WTEXT.Equals("0") || string.IsNullOrEmpty(REQ_WORK_WTEXT)) ? REQ_WORK_WTEXT : nvc_cookie["work_wtext_cookie"];
				ViewBag.REQ_WORK_DAY_WEEK = REQ_WORK_DAY_WEEK != "0" ? REQ_WORK_DAY_WEEK : nvc_cookie["work_day_week_cookie"];
				ViewBag.REQ_WORK_DAY_WEEK_NEGO = REQ_WORK_DAY_WEEK_NEGO != "" ? REQ_WORK_DAY_WEEK_NEGO : nvc_cookie["work_day_week_nego_cookie"];
				ViewBag.REQ_WORK_DAY_WEEK_TEXT = REQ_WORK_DAY_WEEK_TEXT != "" ? REQ_WORK_DAY_WEEK_TEXT : nvc_cookie["work_day_week_text_cookie"];
				ViewBag.REQ_WORK_TIME = REQ_WORK_TIME != "0" ? REQ_WORK_TIME : nvc_cookie["work_time_cookie"];
				ViewBag.REQ_WORK_TIMEF = REQ_WORK_TIMEF != "0" ? REQ_WORK_TIMEF : nvc_cookie["work_timef_cookie"];
				ViewBag.REQ_WORK_TIME_FROM = REQ_WORK_TIME_FROM != "" ? REQ_WORK_TIME_FROM : nvc_cookie["work_time_from_cookie"];
				ViewBag.REQ_WORK_TIME_TO = REQ_WORK_TIME_TO != "" ? REQ_WORK_TIME_TO : nvc_cookie["work_time_to_cookie"];
				ViewBag.REQ_WORK_TIME_NEGO = REQ_WORK_TIME_NEGO != "" ? REQ_WORK_TIME_NEGO : nvc_cookie["work_time_nego_cookie"];
				ViewBag.REQ_WORK_TIME_TEXT = REQ_WORK_TIME_TEXT != "" ? REQ_WORK_TIME_TEXT : nvc_cookie["work_time_text_cookie"];
				ViewBag.REQ_WORK_AGE = REQ_WORK_AGE != "" ? REQ_WORK_AGE : nvc_cookie["work_age_cookie"];
				ViewBag.REQ_WORK_AGE_N = REQ_WORK_AGE_N != "" ? REQ_WORK_AGE_N : nvc_cookie["work_age_n_cookie"];
				ViewBag.REQ_WORK_AGE_TEXT = REQ_WORK_AGE_TEXT != "" ? REQ_WORK_AGE_TEXT : nvc_cookie["work_age_text_cookie"];
				ViewBag.REQ_WORK_SEX = REQ_WORK_SEX != "0" ? REQ_WORK_SEX : nvc_cookie["work_sex_cookie"];
				ViewBag.REQ_WORK_SEX_N = REQ_WORK_SEX_N != "" ? REQ_WORK_SEX_N : nvc_cookie["work_sex_n_cookie"];
				ViewBag.REQ_WORK_SEX_TEXT = REQ_WORK_SEX_TEXT != "" ? REQ_WORK_SEX_TEXT : nvc_cookie["work_sex_text_cookie"];
				ViewBag.REQ_WORK_TXT = REQ_WORK_TXT != "" ? REQ_WORK_TXT : nvc_cookie["work_txt"];
			}

			string[] arrCate = null;
			if (!string.IsNullOrEmpty(ViewBag.REQ_CATE))
			{
				REQ_CATE = HttpUtility.UrlDecode(ViewBag.REQ_CATE);
				arrCate = REQ_CATE.Split(',');
			}
			string[] arrCateTxt = null;
			if (!string.IsNullOrEmpty(ViewBag.REQ_CATE_TXT))
			{
				REQ_CATE_TXT = HttpUtility.UrlDecode(ViewBag.REQ_CATE_TXT);
				arrCateTxt = REQ_CATE_TXT.Split(',');
			}

			NameValueCollection nvc = new NameValueCollection();
			nvc["KIND"] = "1";
			nvc["CATE_LEVEL"] = "0";
			nvc["CATE1"] = "4";
			nvc["FINDCODE"] = "";

			MediaWill._Data.MDT_Job_ReNew mdjr = new MediaWill._Data.MDT_Job_ReNew();

			// 중분류 업/직종 가져오기
			DataSet dsCate2 = mdjr.GET_F_FINDCODE_DROP_DOWN_LIST_PROC(nvc);
			DataTable dtCate2 = dsCate2.Tables["LIST"];

			StringBuilder sb = new StringBuilder();
			if (dtCate2.Rows.Count > 0)
			{
				DataRow dr;
				string Code2 = string.Empty;
				int i = 0;
				int j = 0;

				for (i = 0; i < dtCate2.Rows.Count; i++)
				{
					dr = dtCate2.Rows[i];

					string checkedString = string.Empty;
					if (arrCate != null)
					{
						for (int t = 0; t < arrCate.Length; t++)
						{
							if (dr["Code2"].ToString() == arrCate[t])
							{
								// 전체 체크시
								checkedString = " checked";
								break;
							}
						}
					}

					if (dr["CateLevel"].ToString() == "1" && Code2 != dr["Code2"].ToString())
					{
						if (i > 0)
						{
							if (j % 2 == 1)
							{
								sb.Append("                <dl class=\"tab-list\">" + "\r\n");
								sb.Append("                    <dt class=\"tab-list__title\">" + "\r\n");
								sb.Append("                    </dt>" + "\r\n");
								sb.Append("                    <dd class=\"tab-list__view\">" + "\r\n");
								sb.AppendFormat("                        <ul class=\"inp-list\"  id=\"CATE_HTML_{0}\"></ul>" + "\r\n", i);
								sb.Append("                    </dd>" + "\r\n");
								sb.Append("                </dl>" + "\r\n");
								sb.Append("            </div>" + "\r\n");
								sb.Append("            <!-- // list-box -->" + "\r\n");
							}


							sb.Append("    </div>" + "\r\n");
						}

						sb.Append("       <div class=\"tab-contents\">" + "\r\n");
						sb.AppendFormat("            <h3 class=\"tab-contents__title\">{0}</h3>" + "\r\n", dr["CodeNm2"].ToString());
						sb.Append("            <div class=\"tab-contents__check\">" + "\r\n");
						sb.Append("                <span class=\"inp-check\">" + "\r\n");
						sb.AppendFormat("					 <label for=\"chkAll_{0}\" class=\"inp-check__label\">전체</label>" + "\r\n", dr["Code2"].ToString());
						sb.AppendFormat("                    <input type=\"checkbox\" name=\"chkAll_{0}\" id=\"chkAll_{1}\" class=\"inp-check__all\" val=\"{2}\" valfulltxt=\"{3}\" {4} onclick=\"CateCheckEvt(this, '');\">" + "\r\n", dr["Code2"].ToString(), dr["Code2"].ToString(), dr["Code2"].ToString(), dr["FullNm"].ToString() + " 전체", checkedString);
						sb.Append("                </span>" + "\r\n");
						sb.Append("            </div>" + "\r\n");

						j = 0;
					}
					else if (dr["CateLevel"].ToString() == "2")
					{
						if (j % 2 == 0)
						{
							sb.Append("            <!-- list-box -->" + "\r\n");
							sb.Append("            <div class=\"list-box\">" + "\r\n");
						}

						sb.Append("                <dl class=\"tab-list\">" + "\r\n");
						sb.Append("                    <dt class=\"tab-list__title\">" + "\r\n");
						sb.AppendFormat("                        <a href=\"javascript:;\" onclick=\"detailView(this);return false;\" Code3=\"{0}\" CodeNm3=\"{1}\">{2}</a>" + "\r\n", dr["Code3"].ToString(), dr["CodeNm3"].ToString(), dr["CodeNm3"].ToString());
						sb.Append("                    </dt>" + "\r\n");
						sb.Append("                    <dd class=\"tab-list__view\">" + "\r\n");
						sb.AppendFormat("                        <ul class=\"inp-list\"  id=\"CATE_HTML_{0}\"></ul>" + "\r\n", dr["Code3"].ToString());
						sb.Append("                    </dd>" + "\r\n");
						sb.Append("                </dl>" + "\r\n");

						if (j % 2 == 1)
						{
							sb.Append("            </div>" + "\r\n");
							sb.Append("            <!-- // list-box -->" + "\r\n");
						}

						j++;
					}

					Code2 = dr["Code2"].ToString();
				}

				sb.Append("</div>" + "\r\n");
			}

			dtCate2.Dispose();
			dtCate2.Dispose();

			ViewBag.CateHtml = sb.ToString();

			return View();
		}

		/// <summary>업직종검색</summary>
		/// <returns></returns>
		public ActionResult CateSearch()
		{
			#region 검색조건 사용여부
			string AREA_USE = Req.GetString("AREA_USE", "Y");  //검색조건 사용여부
			string CATE_USE = Req.GetString("CATE_USE", "Y");  //검색조건 사용여부
			string WORK_USE = Req.GetString("WORK_USE", "Y");  //검색조건 사용여부

			ViewBag.AREA_USE = AREA_USE;
			ViewBag.CATE_USE = CATE_USE;
			ViewBag.WORK_USE = WORK_USE;
			#endregion

			//뒤로가기를 눌렀을 경우 Hub 페이지로 돌아가기 위한 파라미터
			string RETURN_URL = Req.GetString("RETURN_URL", "");
			ViewBag.RETURN_URL = RETURN_URL;

			string REQ_KEYWORD = Req.GetString("REQ_KEYWORD", "");  //통합검색 키워드
			ViewBag.REQ_KEYWORD = REQ_KEYWORD;

			string COOKIE_TYPE = Req.GetString("COOKIE_TYPE", "MS");
			ViewBag.COOKIE_TYPE = COOKIE_TYPE;

			string SEARCH_LOCATION = Req.GetString("SEARCH_LOCATION", "");
			ViewBag.SEARCH_LOCATION = SEARCH_LOCATION;

			ViewBag.PAGE_LOCATION = Req.GetString("PAGE_LOCATION", "");
			ViewBag.SPID = Req.GetString("SPID", "");
			ViewBag.BR_GBN = Req.GetString("BR_GBN", "");
			ViewBag.BR_SEQ = Req.GetString("BR_SEQ", "");

			if ((ViewBag.PAGE_LOCATION == "SPECIAL" || ViewBag.PAGE_LOCATION == "BRAND") && string.IsNullOrEmpty(SEARCH_LOCATION))
			{
				ViewBag.lCOUNT_CATE = 1;
			}
			else
			{
				ViewBag.lCOUNT_CATE = 5;
			}

			string REQ_AREA = Req.GetString("REQ_AREA", "");
			string REQ_AREA_TXT = Req.GetString("REQ_AREA_TXT", "");
			string REQ_AREA_COUNT = Req.GetString("REQ_AREA_COUNT", "0");

			ViewBag.REQ_AREA = REQ_AREA;
			ViewBag.REQ_AREA_TXT = REQ_AREA_TXT;
			ViewBag.REQ_AREA_COUNT = REQ_AREA_COUNT;

			string REQ_CATE = Req.GetString("REQ_CATE", "");
			string REQ_CATE_TXT = Req.GetString("REQ_CATE_TXT", "");
			string REQ_CATE_COUNT = Req.GetString("REQ_CATE_COUNT", "0");

			ViewBag.REQ_CATE = REQ_CATE;
			ViewBag.REQ_CATE_TXT = REQ_CATE_TXT;
			ViewBag.REQ_CATE_COUNT = REQ_CATE_COUNT;

			ViewBag.SELECT_PAGE = "Y";

			string REQ_WORK_DAY_WEEK = Req.GetString("REQ_WORK_DAY_WEEK", "0");
			string REQ_WORK_DAY_WEEK_NEGO = Req.GetString("REQ_WORK_DAY_WEEK_NEGO", "");
			string REQ_WORK_TIME = Req.GetString("REQ_WORK_TIME", "0");
			string REQ_WORK_TIME_FROM = Req.GetString("REQ_WORK_TIME_FROM", "");
			string REQ_WORK_TIME_TO = Req.GetString("REQ_WORK_TIME_TO", "");
			string REQ_WORK_TIME_NEGO = Req.GetString("REQ_WORK_TIME_NEGO", "");
			string REQ_WORK_AGE = Req.GetString("REQ_WORK_AGE", "");
			string REQ_WORK_AGE_N = Req.GetString("REQ_WORK_AGE_N", "");
			string REQ_WORK_SEX = Req.GetString("REQ_WORK_SEX", "0");
			string REQ_WORK_SEX_N = Req.GetString("REQ_WORK_SEX_N", "");
			string REQ_WORK_TXT = Req.GetString("REQ_WORK_TXT", "");

			ViewBag.REQ_WORK_DAY_WEEK = REQ_WORK_DAY_WEEK;
			ViewBag.REQ_WORK_DAY_WEEK_NEGO = REQ_WORK_DAY_WEEK_NEGO;
			ViewBag.REQ_WORK_TIME = REQ_WORK_TIME;
			ViewBag.REQ_WORK_TIME_FROM = REQ_WORK_TIME_FROM;
			ViewBag.REQ_WORK_TIME_TO = REQ_WORK_TIME_TO;
			ViewBag.REQ_WORK_TIME_NEGO = REQ_WORK_TIME_NEGO;
			ViewBag.REQ_WORK_AGE = REQ_WORK_AGE;
			ViewBag.REQ_WORK_AGE_N = REQ_WORK_AGE_N;
			ViewBag.REQ_WORK_SEX = REQ_WORK_SEX;
			ViewBag.REQ_WORK_SEX_N = REQ_WORK_SEX_N;
			ViewBag.REQ_WORK_TXT = REQ_WORK_TXT;

			return View();
		}

		/// <summary>업직종선택 - 3Depth 가져오기 Ajax</summary>
		/// <returns></returns>
		public string AjaxCateDepthList()
		{
			string rtnValue = string.Empty;

			try
			{
				lCOUNT_CATE = Req.GetInt("lCOUNT_CATE", lCOUNT_CATE);
				int sCOUNT_CATE = Req.GetInt("sCOUNT_CATE", 0);   //총 선택 카운트

				string cCATE = Req.GetString("cCATE", "");    // 클릭 "시/도" 지역            
				string cCATE_TXT = Req.GetString("cCATE_TXT", "");    //클릭 "시/도" 지역 텍스트
				if (!string.IsNullOrEmpty(cCATE_TXT))
				{
					cCATE_TXT = HttpUtility.UrlDecode(cCATE_TXT);
				}

				string sCATE = Req.GetString("sCATE", "");  // 선택지역
				string sCATE_TXT = Req.GetString("sCATE_TXT", "");  // 선택지역 텍스트

				string[] arrCate = null;
				if (!string.IsNullOrEmpty(sCATE))
				{
					sCATE = HttpUtility.UrlDecode(sCATE);
					arrCate = sCATE.Split(',');
				}
				string[] arrCateTxt = null;
				if (!string.IsNullOrEmpty(sCATE_TXT))
				{
					sCATE_TXT = HttpUtility.UrlDecode(sCATE_TXT);
					arrCateTxt = sCATE_TXT.Split(',');
				}

				string checkedString = string.Empty;
				if (arrCate != null)
				{
					for (int t = 0; t < arrCate.Length; t++)
					{
						if (cCATE == arrCate[t])
						{
							// 전체 체크시
							checkedString = " checked";
							break;
						}
						else if (("," + arrCate[t]).IndexOf("," + cCATE) > -1)
						{
							// 선택된 항목의 상위 지역이면..
							checkedString = string.Empty;
							break;
						}
					}
				}

				NameValueCollection nvc = new NameValueCollection();
				nvc["KIND"] = "1";
				nvc["CATE_LEVEL"] = "3";
				nvc["CATE1"] = "4";
				nvc["FINDCODE"] = cCATE;

				MediaWill._Data.MDT_Job_ReNew mdjr = new MediaWill._Data.MDT_Job_ReNew();

				// 중분류 업/직종 가져오기
				DataSet dsCate2 = mdjr.GET_F_FINDCODE_DROP_DOWN_LIST_PROC(nvc);
				DataTable dtCate2 = dsCate2.Tables["LIST"];

				StringBuilder sb = new StringBuilder();
				if (dtCate2.Rows.Count > 0)
				{
					sb.Append("								<li class=\"inp-list__item--all\">" + "\r\n");
					sb.Append("									<span class=\"inp-check\">" + "\r\n");
					sb.AppendFormat("										<label for=\"chkAll_{0}\" class=\"inp-check__label\">{1} 전체</label>" + "\r\n", dtCate2.Rows[0]["Code3"].ToString(), dtCate2.Rows[0]["CodeNm3"].ToString());
					sb.AppendFormat("										<input type=\"checkbox\" name=\"chkAll_{0}\" id=\"chkAll_{1}\" val=\"{2}\" valfulltxt=\"{3}\" {4} class=\"inp-check__subAll\" onclick=\"CateCheckEvt(this, '');\">" + "\r\n", dtCate2.Rows[0]["Code3"].ToString(), dtCate2.Rows[0]["Code3"].ToString(), dtCate2.Rows[0]["Code3"].ToString(), dtCate2.Rows[0]["CodeNm3"].ToString() + " 전체", checkedString);
					sb.Append("									</span>" + "\r\n");
					sb.Append("								</li>" + "\r\n");

					DataRow dr;
					int i;

					for (i = 0; i < dtCate2.Rows.Count; i++)
					{
						dr = dtCate2.Rows[i];

						if (("," + sCATE).IndexOf("," + dr["Code4"].ToString()) > -1)
						{
							try
							{
								if (arrCate != null)
								{
									for (int j = 0; j < arrCate.Length; j++)
									{
										if (arrCate[j].Length == 7)
										{
											if (arrCate[j].Equals(dr["Code4"].ToString()))
											{
												checkedString = "checked";
												break;
											}
										}
									}
								}
							}
							catch (Exception ex) { string err = ex.Message; }
						}

						string FullNm = dr["FullNm"].ToString();
						FullNm = FullNm.Replace(" > ", "==");

						sb.Append("								<li class=\"inp-list__item\">" + "\r\n");
						sb.Append("									<span class=\"inp-check\">" + "\r\n");
						sb.AppendFormat("										<label for=\"chk_{0}\" class=\"inp-check__label\">{1}</label>" + "\r\n", dr["Code4"].ToString(), dr["CodeNm4"].ToString());
						sb.AppendFormat("										<input type=\"checkbox\" name=\"chk_{0}\" id=\"chk_{1}\" val=\"{2}\" valfulltxt=\"{3}\" {4} onclick=\"CateCheckEvt(this, '');\">" + "\r\n", dr["Code4"].ToString(), dr["Code4"].ToString(), dr["Code4"].ToString(), FullNm, checkedString);
						sb.Append("									</span>" + "\r\n");
						sb.Append("								</li>" + "\r\n");
					}
				}

				dtCate2.Dispose();
				dtCate2.Dispose();

				rtnValue = sb.ToString();
			}
			catch (Exception ex)
			{
				rtnValue = ex.Message;
				rtnValue = string.Empty;
			}

			return rtnValue;
		}

		/// <summary>업직종검색 - 검색엔진</summary>
		/// <returns></returns>
		public string CateSearchKonanApi()
		{
			string sVersion = Req.GetString("sVersion", "");
			string keyword = Req.GetString("keyword", "");
			string gbn = "cate";

			string sCATE = Req.GetString("sCATE", "");  // 선택지역
			string sCATE_TXT = Req.GetString("sCATE_TXT", "");  // 선택지역 텍스트

			string[] arrCate = null;
			if (!string.IsNullOrEmpty(sCATE))
			{
				sCATE = HttpUtility.UrlDecode(sCATE);
				arrCate = sCATE.Split(',');
			}
			string[] arrCateTxt = null;
			if (!string.IsNullOrEmpty(sCATE_TXT))
			{
				sCATE_TXT = HttpUtility.UrlDecode(sCATE_TXT);
				arrCateTxt = sCATE_TXT.Split(',');
			}

			DataSet ds = new DataSet();
			NameValueCollection nvc_param = new NameValueCollection();

			nvc_param["searchEngine"] = (string.IsNullOrEmpty(getDevelopmentSubDomain()) ? "S" : "T"); //S(실서버) , T(로컬 및 테스트)
			nvc_param["searchService"] = "AREA_CATE";
			nvc_param["page"] = "1";
			nvc_param["pageSize"] = "200";
			nvc_param["keyword"] = keyword;
			nvc_param["gbn"] = gbn;
			nvc_param["mid"] = Req.GetString("mid", gMachinID);
			StringBuilder sb = new StringBuilder();
			if (keyword != "")
			{
				if (sVersion.Equals("v5"))
				{
					// v5 자동완성 API
					NameValueCollection nvc_autocomplete = new NameValueCollection();
					nvc_autocomplete["searchEngine"] = nvc_param["searchEngine"];
					nvc_autocomplete["searchService"] = "KFSLOGDICTIONARY";
					nvc_autocomplete["searchSection"] = "JOB";
					nvc_autocomplete["searchPlatform"] = "MOBILEWEB";
					nvc_autocomplete["searchDevice"] = "ANDROID";
					nvc_autocomplete["mid"] = nvc_param["mid"];   //앱<->모바일웹구분
					nvc_autocomplete["searchKfsApi"] = "CATE"; //업직종
					nvc_autocomplete["keyword"] = keyword;

					MB.Search._BasePage_Konan_v5 objSearchv5 = new MB.Search._BasePage_Konan_v5();
					// 검색결과 가져오기
					ds = objSearchv5.ParseJsonToDataSetForAreaCate(objSearchv5.GetJsonKsfLogDictionaryToHtml(nvc_autocomplete).ToString(), nvc_autocomplete["searchKfsApi"]);
				}
				else
				{
					// v5 검색 API / sVersion v4로 넘어오는 경우
					MB.Search._BasePage_Konan objSearch = new MB.Search._BasePage_Konan();
					// 검색결과 가져오기
					ds = objSearch.ParseJsonToDataSetForAreaCate(objSearch.GetSearchResult(objSearch.GetSearchUrl(nvc_param)));
				}

				DataTable dt1 = ds.Tables[0];
				DataTable dt2 = ds.Tables[1];

				if (dt2.Rows.Count > 0)
				{
					for (int i = 0; i < dt2.Rows.Count; i++)
					{
						string cate_full_search = dt2.Rows[i]["findcodenm_full"].ToString();
						string cate_full_text = dt2.Rows[i]["full_nm"].ToString();
						string cate_code = dt2.Rows[i]["findcode"].ToString();

						if (!string.IsNullOrEmpty(cate_code))
						{
							string checkedString = string.Empty;
							if (arrCate != null)
							{
								for (int t = 0; t < arrCate.Length; t++)
								{
									if (cate_code == arrCate[t])
									{
										// 전체 체크시
										checkedString = " checked";
										break;
									}
								}
							}

							if (sVersion.Equals("v5"))
							{
								cate_full_search = cate_full_search.Replace("&gt;", "<span class=\"depth\">&gt;</span>").Replace(keyword, "<strong>" + keyword + "</strong>"); //강조 표시
							}
							else
							{
								cate_full_search = cate_full_search.Replace("&gt;", "<span class=\"depth\">&gt;</span>").Replace("<b>", "<strong>").Replace("</b>", "</strong>").ToString();
							}
							cate_full_text = cate_full_text.Replace("&gt;", "==").Replace("<b>", "").Replace("</b>", "").ToString();

							sb.Append("<li class=\"auto-list__item\">" + "\r\n");
							sb.Append("    <span class=\"inp-check\">" + "\r\n");
							if (cate_code.Length == 3)
							{
								sb.AppendFormat("        <label for=\"chkAll_CATE_A_{0}\" class=\"inp-check__label\">{1}</label>" + "\r\n", cate_code, cate_full_search);
								sb.AppendFormat("        <input type=\"checkbox\" name=\"chkAll_CATE_A_{0}\" id=\"chkAll_CATE_A_{1}\"  val=\"{2}\" valtxt=\"{3}\" valfulltxt=\"{4}\" {5} onclick=\"CheckEvt(this, '');\">" + "\r\n", cate_code, cate_code, cate_code, cate_full_text, cate_full_text, checkedString);
							}
							else if (cate_code.Length == 5)
							{
								sb.AppendFormat("        <label for=\"chkAll_CATE_B_{0}\" class=\"inp-check__label\">{1}</label>" + "\r\n", cate_code, cate_full_search);
								//sb.AppendFormat("        <input type=\"checkbox\" name=\"chkAll_CATE_B_{0}\" id=\"chkAll_CATE_B_{1}\" onclick=\"CheckEvt(this, '');\">" + "\r\n", area_code, area_code);
								sb.AppendFormat("        <input type=\"checkbox\" name=\"chkAll_CATE_B_{0}\" id=\"chkAll_CATE_B_{1}\"  val=\"{2}\" valtxt=\"{3}\" valfulltxt=\"{4}\" {5} onclick=\"CheckEvt(this, '');\">" + "\r\n", cate_code, cate_code, cate_code, cate_full_text, cate_full_text, checkedString);
							}
							else
							{
								sb.AppendFormat("        <label for=\"chk_CATE_C_{0}\" class=\"inp-check__label\">{1}</label>" + "\r\n", cate_code, cate_full_search);
								//sb.AppendFormat("        <input type=\"checkbox\" name=\"chk_CATE_C_{0}\" id=\"chk_CATE_C_{1}\" onclick=\"CheckEvt(this, '');\">" + "\r\n", area_code, area_code);
								sb.AppendFormat("        <input type=\"checkbox\" name=\"chk_CATE_C_{0}\" id=\"chk_CATE_C_{1}\"  val=\"{2}\" valtxt=\"{3}\" valfulltxt=\"{4}\" {5} onclick=\"CheckEvt(this, '');\">" + "\r\n", cate_code, cate_code, cate_code, cate_full_text, cate_full_text, checkedString);
							}
							sb.Append("    </span>" + "\r\n");
							sb.Append("</li>" + "\r\n");
						}
					}
				}
			}
			else
			{
				sb.Append("");
			}

			return sb.ToString();
		}
		#endregion

		#region  근무조건 조건검색 ---------------------------------------------------------------------------------------------------
		/// <summary>근무조건 선택</summary>
		/// <returns></returns>
		public ActionResult Work()
		{
			#region 검색조건 사용여부
			string AREA_USE = Req.GetString("AREA_USE", "Y");  //검색조건 사용여부
			string CATE_USE = Req.GetString("CATE_USE", "Y");  //검색조건 사용여부
			string WORK_USE = Req.GetString("WORK_USE", "Y");  //검색조건 사용여부

			ViewBag.AREA_USE = AREA_USE;
			ViewBag.CATE_USE = CATE_USE;
			ViewBag.WORK_USE = WORK_USE;
			#endregion
      
			string REQ_KEYWORD = Req.GetString("REQ_KEYWORD", "");  //통합검색 키워드
			ViewBag.REQ_KEYWORD = REQ_KEYWORD;
      
      //브랜드관 추가
      string REQ_BR_GBN = Req.GetString("BR_GBN", "");
      string REQ_BR_SEQ = Req.GetString("BR_SEQ", "");
      ViewBag.BR_GBN = REQ_BR_GBN;
      ViewBag.BR_SEQ = REQ_BR_SEQ;

      string REQ_EDIT = Req.GetString("EDIT", "");
      string COOKIE_TYPE = "MS"; // "" : 기본(단일선택), "MT" : 다중선택, "OT" : 우리동네일자리, "SW" : 역세권, "MS" : 다중선택(NEW), "KO" : 다중선택(KONAN), "BR" : 브랜드관
      COOKIE_TYPE = Req.GetString("COOKIE_TYPE", "MS");  
			ViewBag.COOKIE_TYPE = COOKIE_TYPE;

      ViewBag.PAGE_LOCATION = Req.GetString("PAGE_LOCATION", "");
      ViewBag.SPID = Req.GetString("SPID", "");
			ViewBag.BR_GBN = Req.GetString("BR_GBN", "");
			ViewBag.BR_SEQ = Req.GetString("BR_SEQ", "");

			string REQ_AREA = Req.GetString("REQ_AREA", "");
			string REQ_AREA_TXT = Req.GetString("REQ_AREA_TXT", "");
			string REQ_AREA_COUNT = Req.GetString("REQ_AREA_COUNT", "0");

			ViewBag.REQ_AREA = REQ_AREA;
			ViewBag.REQ_AREA_TXT = REQ_AREA_TXT;
			ViewBag.REQ_AREA_COUNT = REQ_AREA_COUNT;

<<<<<<< HEAD
      string SEARCH_LOCATION = Req.GetString("SEARCH_LOCATION", "");
      ViewBag.SEARCH_LOCATION = SEARCH_LOCATION;
=======
			string SEARCH_LOCATION = Req.GetString("SEARCH_LOCATION", "");
			ViewBag.SEARCH_LOCATION = SEARCH_LOCATION;
>>>>>>> develop

			string REQ_CATE = Req.GetString("REQ_CATE", "");
			string REQ_CATE_TXT = Req.GetString("REQ_CATE_TXT", "");
			string REQ_CATE_COUNT = Req.GetString("REQ_CATE_COUNT", "0");

			ViewBag.REQ_CATE = REQ_CATE;
			ViewBag.REQ_CATE_TXT = REQ_CATE_TXT;
			ViewBag.REQ_CATE_COUNT = REQ_CATE_COUNT;
      ViewBag.SELECT_PAGE = "Y";

			//근무조건      
			string REQ_WORK_PAYF = Req.GetString("REQ_WORK_PAYF", "0");
			string REQ_WORK_PAYAMOUNT = Req.GetString("REQ_WORK_PAYAMOUNT", "0");
			string REQ_WORK_PAY_TEXT = Req.GetString("REQ_WORK_PAY_TEXT", "");
			string REQ_WORK_WF = Req.GetString("REQ_WORK_WF", "0");
			string REQ_WORK_WTEXT = Req.GetString("REQ_WORK_WTEXT", "0");
			string REQ_WORK_DAY_WEEK = Req.GetString("REQ_WORK_DAY_WEEK", "0");
			string REQ_WORK_DAY_WEEK_NEGO = Req.GetString("REQ_WORK_DAY_WEEK_NEGO", "");
			string REQ_WORK_DAY_WEEK_TEXT = Req.GetString("REQ_WORK_DAY_WEEK_TEXT", "");
			string REQ_WORK_TIME = Req.GetString("REQ_WORK_TIME", "0");
			string REQ_WORK_TIMEF = Req.GetString("REQ_WORK_TIMEF", "0");
			string REQ_WORK_TIME_FROM = Req.GetString("REQ_WORK_TIME_FROM", "");
			string REQ_WORK_TIME_TO = Req.GetString("REQ_WORK_TIME_TO", "");
			string REQ_WORK_TIME_NEGO = Req.GetString("REQ_WORK_TIME_NEGO", "");
			string REQ_WORK_TIME_TEXT = Req.GetString("REQ_WORK_TIME_TEXT", "");
			string REQ_WORK_AGE = Req.GetString("REQ_WORK_AGE", "");
			string REQ_WORK_AGE_N = Req.GetString("REQ_WORK_AGE_N", "");
			string REQ_WORK_AGE_TEXT = Req.GetString("REQ_WORK_AGE_TEXT", "");
			string REQ_WORK_SEX = Req.GetString("REQ_WORK_SEX", "0");
			string REQ_WORK_SEX_N = Req.GetString("REQ_WORK_SEX_N", "");
			string REQ_WORK_SEX_TEXT = Req.GetString("REQ_WORK_SEX_TEXT", "");
			string REQ_WORK_TXT = Req.GetString("REQ_WORK_TXT", "");

			ViewBag.REQ_WORK_PAYF = REQ_WORK_PAYF;
			ViewBag.REQ_WORK_PAYAMOUNT = REQ_WORK_PAYAMOUNT;
			ViewBag.REQ_WORK_PAY_TEXT = REQ_WORK_PAY_TEXT;
			ViewBag.REQ_WORK_WF = REQ_WORK_WF;
			ViewBag.REQ_WORK_WTEXT = REQ_WORK_WTEXT;
			ViewBag.REQ_WORK_DAY_WEEK = REQ_WORK_DAY_WEEK;
			ViewBag.REQ_WORK_DAY_WEEK_NEGO = REQ_WORK_DAY_WEEK_NEGO;
			ViewBag.REQ_WORK_DAY_WEEK_TEXT = REQ_WORK_DAY_WEEK_TEXT;
			ViewBag.REQ_WORK_TIME = REQ_WORK_TIME;
			ViewBag.REQ_WORK_TIMEF = REQ_WORK_TIMEF;
			ViewBag.REQ_WORK_TIME_FROM = REQ_WORK_TIME_FROM;
			ViewBag.REQ_WORK_TIME_TO = REQ_WORK_TIME_TO;
			ViewBag.REQ_WORK_TIME_NEGO = REQ_WORK_TIME_NEGO;
			ViewBag.REQ_WORK_TIME_TEXT = REQ_WORK_TIME_TEXT;
			ViewBag.REQ_WORK_AGE = REQ_WORK_AGE;
			ViewBag.REQ_WORK_AGE_N = REQ_WORK_AGE_N;
			ViewBag.REQ_WORK_AGE_TEXT = REQ_WORK_AGE_TEXT;
			ViewBag.REQ_WORK_SEX = REQ_WORK_SEX;
			ViewBag.REQ_WORK_SEX_N = REQ_WORK_SEX_N;
			ViewBag.REQ_WORK_SEX_TEXT = REQ_WORK_SEX_TEXT;
			ViewBag.REQ_WORK_TXT = REQ_WORK_TXT;

			return View();
		}
		#endregion

		#region  최근 검색 조건 ---------------------------------------------------------------------------------------------------
		/// <summary>최근 검색 조건</summary>
		/// <returns></returns>
		public ActionResult Lately()
		{
			#region 검색조건 사용여부
			string AREA_USE = Req.GetString("AREA_USE", "Y");  //검색조건 사용여부
			string CATE_USE = Req.GetString("CATE_USE", "Y");  //검색조건 사용여부
			string WORK_USE = Req.GetString("WORK_USE", "Y");  //검색조건 사용여부
			string REQ_KEYWORD = Req.GetString("REQ_KEYWORD", "");  //통합검색 키워드

			ViewBag.AREA_USE = AREA_USE;
			ViewBag.CATE_USE = CATE_USE;
			ViewBag.WORK_USE = WORK_USE;
			ViewBag.REQ_KEYWORD = REQ_KEYWORD;
			#endregion

			NameValueCollection nvc_cookie = null;
			nvc_cookie = initConditionalSearchCookie();

			//ViewBag.COOKIE_TYPE = "MS";   // "" : 기본(단일선택), "MT" : 다중선택, "OT" : 우리동네일자리, "SW" : 역세권, "MS" : 다중선택(NEW)
			string COOKIE_TYPE = Req.GetString("COOKIE_TYPE", "MS");
      if (ViewBag.PAGE_LOCATION == "BRAND")
      {
        COOKIE_TYPE = "BR";
      }
      ViewBag.COOKIE_TYPE = COOKIE_TYPE;

			// 쿠키 가져오기
			nvc_cookie = getConditionalSearchCookie(null, ViewBag.COOKIE_TYPE, AREA_USE, CATE_USE, WORK_USE);

      #region 조건검색 쿠키 (근무조건)
      ViewBag.WORK_PAYF = nvc_cookie["work_payf_cookie"];
      ViewBag.WORK_PAYAMOUNT = nvc_cookie["work_payamount_cookie"];
      ViewBag.WORK_PAY_TEXT = nvc_cookie["work_pay_text_cookie"];
      ViewBag.WORK_WF = nvc_cookie["work_wf_cookie"];
      ViewBag.WORK_WTEXT = nvc_cookie["work_wtext_cookie"];
      ViewBag.WORK_DAY_WEEK = nvc_cookie["work_day_week_cookie"];
      ViewBag.WORK_DAY_WEEK_NEGO = nvc_cookie["work_day_week_nego_cookie"];
      ViewBag.WORK_DAY_WEEK_TEXT = nvc_cookie["work_day_week_text_cookie"];
      ViewBag.WORK_TIME = nvc_cookie["work_time_cookie"];
      ViewBag.WORK_TIMEF = nvc_cookie["work_timef_cookie"];
      ViewBag.WORK_TIME_FROM = nvc_cookie["work_time_from_cookie"];
      ViewBag.WORK_TIME_TO = nvc_cookie["work_time_to_cookie"];
      ViewBag.WORK_TIME_NEGO = nvc_cookie["work_time_nego_cookie"];
      ViewBag.WORK_TIME_TEXT = nvc_cookie["work_time_text_cookie"];
      ViewBag.WORK_AGE = nvc_cookie["work_age_cookie"];
      ViewBag.WORK_AGE_N = nvc_cookie["work_age_n_cookie"];
      ViewBag.WORK_AGE_TEXT = nvc_cookie["work_age_text_cookie"];
      ViewBag.WORK_SEX = nvc_cookie["work_sex_cookie"];
      ViewBag.WORK_SEX_N = nvc_cookie["work_sex_n_cookie"];
      ViewBag.WORK_SEX_TEXT = nvc_cookie["work_sex_text_cookie"];
      ViewBag.WORK_TXT = nvc_cookie["work_txt"];
      #endregion



      #region 우리동네일자리 쿠키
      ViewBag.OT_AREA_TXT = Utils_Cookies.getJobConditionalSearchookies(null, "OT", "AREA", "T");

			ViewBag.GMAP_X = nvc_cookie["ourtown_gmap_x"];
			ViewBag.GMAP_Y = nvc_cookie["ourtown_gmap_y"];
			ViewBag.RADIUS = nvc_cookie["ourtown_radius"];
			#endregion

			ViewBag.PAGE_LOCATION = Req.GetString("PAGE_LOCATION", "");
			ViewBag.SPID = Req.GetString("SPID", "");
			ViewBag.BR_GBN = Req.GetString("BR_GBN", "");
			ViewBag.BR_SEQ = Req.GetString("BR_SEQ", "");

			string SEARCH_LOCATION = Req.GetString("SEARCH_LOCATION", "");
			ViewBag.SEARCH_LOCATION = SEARCH_LOCATION;

<<<<<<< HEAD
      if ((ViewBag.PAGE_LOCATION == "SPECIAL") && string.IsNullOrEmpty(SEARCH_LOCATION))
=======
			if ((ViewBag.PAGE_LOCATION == "SPECIAL" || ViewBag.PAGE_LOCATION == "BRAND") && string.IsNullOrEmpty(SEARCH_LOCATION))
>>>>>>> develop
			{
				ViewBag.lCOUNT_AREA = 1;
				ViewBag.lCOUNT_CATE = 1;
			}
			else
			{
				ViewBag.lCOUNT_AREA = 5;
				ViewBag.lCOUNT_CATE = 5;
			}

			return View();
		}
		#endregion
	}
}