

-- 마크 :하얀색
UPDATE A
SET A.TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(A.TEMPLATE_CODE_2019,3,len(A.TEMPLATE_CODE_2019)-2)
,A.LMS_MSG = REPLACE(A.LMS_MSG , '벼룩시장구인구직' , '벼룩시장')
,A.KKO_MSG = REPLACE(A.KKO_MSG , '벼룩시장구인구직' , '벼룩시장')
FROM FINDDB1.COMDB1.DBO.KKO_MSG_TEMPLATE AS A
WHERE A.TEMPLATE_CODE_2019 in('AAsms17','AAsms06','AAsms02','AAsms01','AAFa070','AAFa043','AAFa042','AAFa041','AAFa038','AAFa026','AAFa025','AAFa024','AAFa022','AAFa019','AAFa018','AAFa017','AAFa016','AAFa014','AAFa013','AAFa012','AAFa010','AAFa009','AAFa008','AAFa007')


UPDATE A
SET A.LMS_MSG = REPLACE(REPLACE(A.LMS_MSG,'고객센터','고객문의'),'080-269-0011','02-3407-9700')
   ,A.KKO_MSG = REPLACE(REPLACE(A.KKO_MSG,'고객센터','고객문의'),'080-269-0011','02-3407-9700')
FROM FINDDB1.COMDB1.DBO.KKO_MSG_TEMPLATE AS A 
WHERE A.TEMPLATE_CODE_2019 IN('ABFa024','ABFa025')


UPDATE A
SET A.LMS_MSG = REPLACE(A.LMS_MSG,'벼룩시장님','벼룩시장')
   ,A.KKO_MSG = REPLACE(A.KKO_MSG,'벼룩시장님','벼룩시장')
FROM FINDDB1.COMDB1.DBO.KKO_MSG_TEMPLATE AS A 
WHERE A.TEMPLATE_CODE_2019 IN('ABFa016')



--마크 :노랑
UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[벼룩시장] [#{지원자명}]회원님,  #{지원한 회사명}에 #{지원방법} 입사지원이 완료되었습니다.  좋은 결과가 있으시길 벼룩시장도 함께 응원합니다!     * 제목 : #{제목}   * 대표번호 : #{회사대표번호}   * 업직종 : #{업직종}   * 근무시간 : #{근무시간}   * 근무지 위치 : #{근무지}   * 급여 : #{급여종류} #{급여}     ※ 입사지원 관리는 아래 링크를 통해 확인 하실 수 있습니다.    https://cqc39.app.goo.gl/St87 ※ 고객센터 : 080-269-0011  '
,KKO_MSG ='[벼룩시장] [#{지원자명}]회원님,  #{지원한 회사명}에 #{지원방법} 입사지원이 완료되었습니다.  좋은 결과가 있으시길 벼룩시장도 함께 응원합니다!     * 제목 : #{제목}   * 대표번호 : #{회사대표번호}   * 업직종 : #{업직종}   * 근무시간 : #{근무시간}   * 근무지 위치 : #{근무지}   * 급여 : #{급여종류} #{급여}     ※ 입사지원 관리는 아래 링크를 통해 확인 하실 수 있습니다.    https://cqc39.app.goo.gl/St87 ※ 고객센터 : 080-269-0011  '
WHERE TEMPLATE_CODE_2019 ='AAFa067'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[벼룩시장]   [#{회사명}]회원님, #{지원자명}님께서 #{지원방법} 입사지원을 취소(#{입사지원 취소일}) 하였습니다.     * 지원자 : #{지원자명}   * 취소사유 : #{취소사유}   * 입사지원 취소일 : #{입사지원 취소일}     ※ 지원자관리는 아래 링크를 통해 확인 하실 수 있습니다.    https://cqc39.app.goo.gl/h4Dv ※ 고객센터 : 080-269-0011 '
,KKO_MSG ='[벼룩시장]   [#{회사명}]회원님, #{지원자명}님께서 #{지원방법} 입사지원을 취소(#{입사지원 취소일}) 하였습니다.     * 지원자 : #{지원자명}   * 취소사유 : #{취소사유}   * 입사지원 취소일 : #{입사지원 취소일}     ※ 지원자관리는 아래 링크를 통해 확인 하실 수 있습니다.    https://cqc39.app.goo.gl/h4Dv ※ 고객센터 : 080-269-0011 '
WHERE TEMPLATE_CODE_2019 ='AAFa066'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[벼룩시장]   [#{회사명}]회원님,  #{지원자명}님께서 입사지원을 하였습니다     * 이름 : #{지원자명}   * 연락처 : #{지원자 연락처}  * 희망 업직종 : #{희망업직종} * 희망 근무지 : #{희망근무지} * 간단한 자기소개 : #{간단 자기소개}  * 최종 학력 : #{지원자 최종학력}   * 근무 형태 : #{근무형태}   * 희망 급여 : #{희망 급여}     * 지원내용 : #{문자 직접입력}     ※ 지원자관리는 아래 링크를 통해 확인 하실 수 있습니다.    https://cqc39.app.goo.gl/ELep ※ 고객센터 080-269-0011  '
,KKO_MSG ='[벼룩시장]   [#{회사명}]회원님,  #{지원자명}님께서 입사지원을 하였습니다     * 이름 : #{지원자명}   * 연락처 : #{지원자 연락처}  * 희망 업직종 : #{희망업직종} * 희망 근무지 : #{희망근무지} * 간단한 자기소개 : #{간단 자기소개}  * 최종 학력 : #{지원자 최종학력}   * 근무 형태 : #{근무형태}   * 희망 급여 : #{희망 급여}     * 지원내용 : #{문자 직접입력}     ※ 지원자관리는 아래 링크를 통해 확인 하실 수 있습니다.    https://cqc39.app.goo.gl/ELep ※ 고객센터 080-269-0011  '
WHERE TEMPLATE_CODE_2019 ='AAFa065'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[벼룩시장]  [#{회사명}]회원님,  예약 일자리가 오늘 게재되었습니다.    * 제목 : #{공고제목}   * 공고번호 : #{공고번호}   * 상품명 : #{상품명}   * 게재기간 : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}일간)   * 공고 바로가기 : #{공고URL}    * 담당지점 : #{담당지점명}   * 문의 : #{지점번화번호}   ※ 벼룩시장 바로가기 : https://cqc39.app.goo.gl/civ8'
,KKO_MSG ='[벼룩시장]  [#{회사명}]회원님,  예약 일자리가 오늘 게재되었습니다.    * 제목 : #{공고제목}   * 공고번호 : #{공고번호}   * 상품명 : #{상품명}   * 게재기간 : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}일간)   * 공고 바로가기 : #{공고URL}    * 담당지점 : #{담당지점명}   * 문의 : #{지점번화번호}   ※ 벼룩시장 바로가기 : https://cqc39.app.goo.gl/civ8'
WHERE TEMPLATE_CODE_2019 ='AAFa048'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[벼룩시장] #{회사명}회원님,  일자리 예약 등록이 완료되어 #{YYYY-MM-DD}일에 게재됩니다.     * 제목 : #{공고제목}   * 공고번호 : #{공고번호}   * 상품명 : #{상품명}  * 신청일 : #{신청일}   * 게재기간 : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}일간)  * 담당지점 : #{담당지점명}  * 문의 : #{지점번화번호}   ※ 벼룩시장 바로가기 : https://cqc39.app.goo.gl/kP7D'
,KKO_MSG ='[벼룩시장] #{회사명}회원님,  일자리 예약 등록이 완료되어 #{YYYY-MM-DD}일에 게재됩니다.     * 제목 : #{공고제목}   * 공고번호 : #{공고번호}   * 상품명 : #{상품명}  * 신청일 : #{신청일}   * 게재기간 : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}일간)  * 담당지점 : #{담당지점명}  * 문의 : #{지점번화번호}   ※ 벼룩시장 바로가기 : https://cqc39.app.goo.gl/kP7D'
WHERE TEMPLATE_CODE_2019 ='AAFa047'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[벼룩시장]  #{회사명}회원님,   일자리가 오늘 게재되었습니다.   * 제목 : #{공고제목}   * 공고번호 : #{공고번호}   * 상품명 : #{상품명}  * 게재기간 : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}일간)   * 공고 바로가기 : #{공고URL}  * 담당지점 : #{담당지점명}  * 문의 : #{지점번화번호}   ※ 벼룩시장 바로가기 : https://cqc39.app.goo.gl/b2HC'
,KKO_MSG ='[벼룩시장]  #{회사명}회원님,   일자리가 오늘 게재되었습니다.   * 제목 : #{공고제목}   * 공고번호 : #{공고번호}   * 상품명 : #{상품명}  * 게재기간 : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}일간)   * 공고 바로가기 : #{공고URL}  * 담당지점 : #{담당지점명}  * 문의 : #{지점번화번호}   ※ 벼룩시장 바로가기 : https://cqc39.app.goo.gl/b2HC'
WHERE TEMPLATE_CODE_2019 ='AAFa046'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[벼룩시장]  등록하신 일자리에 지원문의가 접수 되었습니다  * 제목 : #{공고제목}   * 공고번호 : #{공고번호}   * 지원자 : #{지원자성명}  * 문의내용 : #{지원자입력내용}  * 지원자연락처 : #{전화번호}  ※ 고객센터 080-269-0011   ※ 벼룩시장 바로가기 : https://cqc39.app.goo.gl/qNpA'
,KKO_MSG ='[벼룩시장]  등록하신 일자리에 지원문의가 접수 되었습니다  * 제목 : #{공고제목}   * 공고번호 : #{공고번호}   * 지원자 : #{지원자성명}  * 문의내용 : #{지원자입력내용}  * 지원자연락처 : #{전화번호}  ※ 고객센터 080-269-0011   ※ 벼룩시장 바로가기 : https://cqc39.app.goo.gl/qNpA'
WHERE TEMPLATE_CODE_2019 ='AAFa045'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[벼룩시장]  [#{회사명}]회원님,  [제목 : #{제목}]  / #{광고번호} 일자리가 오늘 종료됩니다.     * 제목 : #{공고제목}   * 공고번호 : #{공고번호}   * 등록일 : #{등록일}   * 게재기간 : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}일간)     ※ 일자리 내용은 아래 링크를 통해 확인 하실 수 있습니다.    https://cqc39.app.goo.gl/GTHH ※ 고객센터 : 080-269-0011 '
,KKO_MSG ='[벼룩시장]  [#{회사명}]회원님,  [제목 : #{제목}]  / #{광고번호} 일자리가 오늘 종료됩니다.     * 제목 : #{공고제목}   * 공고번호 : #{공고번호}   * 등록일 : #{등록일}   * 게재기간 : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}일간)     ※ 일자리 내용은 아래 링크를 통해 확인 하실 수 있습니다.    https://cqc39.app.goo.gl/GTHH ※ 고객센터 : 080-269-0011 '
WHERE TEMPLATE_CODE_2019 ='AAFa021'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[벼룩시장]  [#{회사명}]회원님,  예약된 일자리가 오늘 게재되었습니다.     * 제목 : #{공고제목}   * 공고번호 : #{공고번호}   * 등록일 : #{등록일}   * 게재기간 : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}일간)   * 공고 바로가기 : #{공고URL}     ※ 일자리 내용은 아래 링크를 통해 확인 하실 수 있습니다.   https://cqc39.app.goo.gl/tkEq ※ 고객센터 : 080-269-0011 '
,KKO_MSG ='[벼룩시장]  [#{회사명}]회원님,  예약된 일자리가 오늘 게재되었습니다.     * 제목 : #{공고제목}   * 공고번호 : #{공고번호}   * 등록일 : #{등록일}   * 게재기간 : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}일간)   * 공고 바로가기 : #{공고URL}     ※ 일자리 내용은 아래 링크를 통해 확인 하실 수 있습니다.   https://cqc39.app.goo.gl/tkEq ※ 고객센터 : 080-269-0011 '
WHERE TEMPLATE_CODE_2019 ='AAFa020'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[벼룩시장] [#{회사명}]회원님,  #{상품명} 상품의 결제가 완료 되었습니다     [일자리게재정보]   * 제목 : #{title}   * 유료상품 게재기간 : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}일간)   * 결제금액 : #{결제금액}원   ※ 일자리 내용은 아래 링크를 통해 확인 하실 수 있습니다.  https://cqc39.app.goo.gl/NedC ※ 고객센터 : 080-269-0011 '
,KKO_MSG ='[벼룩시장] [#{회사명}]회원님,  #{상품명} 상품의 결제가 완료 되었습니다     [일자리게재정보]   * 제목 : #{title}   * 유료상품 게재기간 : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}일간)   * 결제금액 : #{결제금액}원   ※ 일자리 내용은 아래 링크를 통해 확인 하실 수 있습니다.  https://cqc39.app.goo.gl/NedC ※ 고객센터 : 080-269-0011 '
WHERE TEMPLATE_CODE_2019 ='AAFa015'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[벼룩시장] [#{회사명}]회원님,  #{상품명} 상품의 결제가 완료 되었습니다    [일자리게재정보]  * 제목 : #{title}   * 상품명 : #{상품명}   * 유료상품 게재기간 : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}일간)   * 결제금액 : #{결제금액}원     ※ 일자리 내용은 아래 링크를 통해 확인 하실 수 있습니다.   https://cqc39.app.goo.gl/2fHe ※ 고객센터 : 080-269-0011 '
,KKO_MSG ='[벼룩시장] [#{회사명}]회원님,  #{상품명} 상품의 결제가 완료 되었습니다    [일자리게재정보]  * 제목 : #{title}   * 상품명 : #{상품명}   * 유료상품 게재기간 : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}일간)   * 결제금액 : #{결제금액}원     ※ 일자리 내용은 아래 링크를 통해 확인 하실 수 있습니다.   https://cqc39.app.goo.gl/2fHe ※ 고객센터 : 080-269-0011 '
WHERE TEMPLATE_CODE_2019 ='AAFa011'



