

-- ��ũ :�Ͼ��
UPDATE A
SET A.TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(A.TEMPLATE_CODE_2019,3,len(A.TEMPLATE_CODE_2019)-2)
,A.LMS_MSG = REPLACE(A.LMS_MSG , '������屸�α���' , '�������')
,A.KKO_MSG = REPLACE(A.KKO_MSG , '������屸�α���' , '�������')
FROM KKO_MSG_TEMPLATE AS A
WHERE A.TEMPLATE_CODE_2019 in('AAsms17','AAsms06','AAsms02','AAsms01','AAFa070','AAFa043','AAFa042','AAFa041','AAFa038','AAFa026','AAFa025','AAFa024','AAFa022','AAFa019','AAFa018','AAFa017','AAFa016','AAFa014','AAFa013','AAFa012','AAFa010','AAFa009','AAFa008','AAFa007')



--��ũ :���
UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[�������] [#{�����ڸ�}]ȸ����,  #{������ ȸ���}�� #{�������} �Ի������� �Ϸ�Ǿ����ϴ�.  ���� ����� �����ñ� ������嵵 �Բ� �����մϴ�!     * ���� : #{����}   * ��ǥ��ȣ : #{ȸ���ǥ��ȣ}   * ������ : #{������}   * �ٹ��ð� : #{�ٹ��ð�}   * �ٹ��� ��ġ : #{�ٹ���}   * �޿� : #{�޿�����} #{�޿�}     �� �Ի����� ������ �Ʒ� ��ũ�� ���� Ȯ�� �Ͻ� �� �ֽ��ϴ�.    https://cqc39.app.goo.gl/St87 �� ������ : 080-269-0011  '
,KKO_MSG ='[�������] [#{�����ڸ�}]ȸ����,  #{������ ȸ���}�� #{�������} �Ի������� �Ϸ�Ǿ����ϴ�.  ���� ����� �����ñ� ������嵵 �Բ� �����մϴ�!     * ���� : #{����}   * ��ǥ��ȣ : #{ȸ���ǥ��ȣ}   * ������ : #{������}   * �ٹ��ð� : #{�ٹ��ð�}   * �ٹ��� ��ġ : #{�ٹ���}   * �޿� : #{�޿�����} #{�޿�}     �� �Ի����� ������ �Ʒ� ��ũ�� ���� Ȯ�� �Ͻ� �� �ֽ��ϴ�.    https://cqc39.app.goo.gl/St87 �� ������ : 080-269-0011  '
WHERE TEMPLATE_CODE_2019 ='AAFa067'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[�������]   [#{ȸ���}]ȸ����, #{�����ڸ�}�Բ��� #{�������} �Ի������� ���(#{�Ի����� �����}) �Ͽ����ϴ�.     * ������ : #{�����ڸ�}   * ��һ��� : #{��һ���}   * �Ի����� ����� : #{�Ի����� �����}     �� �����ڰ����� �Ʒ� ��ũ�� ���� Ȯ�� �Ͻ� �� �ֽ��ϴ�.    https://cqc39.app.goo.gl/h4Dv �� ������ : 080-269-0011 '
,KKO_MSG ='[�������]   [#{ȸ���}]ȸ����, #{�����ڸ�}�Բ��� #{�������} �Ի������� ���(#{�Ի����� �����}) �Ͽ����ϴ�.     * ������ : #{�����ڸ�}   * ��һ��� : #{��һ���}   * �Ի����� ����� : #{�Ի����� �����}     �� �����ڰ����� �Ʒ� ��ũ�� ���� Ȯ�� �Ͻ� �� �ֽ��ϴ�.    https://cqc39.app.goo.gl/h4Dv �� ������ : 080-269-0011 '
WHERE TEMPLATE_CODE_2019 ='AAFa066'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[�������]   [#{ȸ���}]ȸ����,  #{�����ڸ�}�Բ��� �Ի������� �Ͽ����ϴ�     * �̸� : #{�����ڸ�}   * ����ó : #{������ ����ó}  * ��� ������ : #{���������} * ��� �ٹ��� : #{����ٹ���} * ������ �ڱ�Ұ� : #{���� �ڱ�Ұ�}  * ���� �з� : #{������ �����з�}   * �ٹ� ���� : #{�ٹ�����}   * ��� �޿� : #{��� �޿�}     * �������� : #{���� �����Է�}     �� �����ڰ����� �Ʒ� ��ũ�� ���� Ȯ�� �Ͻ� �� �ֽ��ϴ�.    https://cqc39.app.goo.gl/ELep �� ������ 080-269-0011  '
,KKO_MSG ='[�������]   [#{ȸ���}]ȸ����,  #{�����ڸ�}�Բ��� �Ի������� �Ͽ����ϴ�     * �̸� : #{�����ڸ�}   * ����ó : #{������ ����ó}  * ��� ������ : #{���������} * ��� �ٹ��� : #{����ٹ���} * ������ �ڱ�Ұ� : #{���� �ڱ�Ұ�}  * ���� �з� : #{������ �����з�}   * �ٹ� ���� : #{�ٹ�����}   * ��� �޿� : #{��� �޿�}     * �������� : #{���� �����Է�}     �� �����ڰ����� �Ʒ� ��ũ�� ���� Ȯ�� �Ͻ� �� �ֽ��ϴ�.    https://cqc39.app.goo.gl/ELep �� ������ 080-269-0011  '
WHERE TEMPLATE_CODE_2019 ='AAFa065'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[�������]  [#{ȸ���}]ȸ����,  ���� ���ڸ��� ���� ����Ǿ����ϴ�.    * ���� : #{��������}   * �����ȣ : #{�����ȣ}   * ��ǰ�� : #{��ǰ��}   * ����Ⱓ : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}�ϰ�)   * ���� �ٷΰ��� : #{����URL}    * ������� : #{���������}   * ���� : #{������ȭ��ȣ}   �� ������� �ٷΰ��� : https://cqc39.app.goo.gl/civ8'
,KKO_MSG ='[�������]  [#{ȸ���}]ȸ����,  ���� ���ڸ��� ���� ����Ǿ����ϴ�.    * ���� : #{��������}   * �����ȣ : #{�����ȣ}   * ��ǰ�� : #{��ǰ��}   * ����Ⱓ : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}�ϰ�)   * ���� �ٷΰ��� : #{����URL}    * ������� : #{���������}   * ���� : #{������ȭ��ȣ}   �� ������� �ٷΰ��� : https://cqc39.app.goo.gl/civ8'
WHERE TEMPLATE_CODE_2019 ='AAFa048'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[�������] #{ȸ���}ȸ����,  ���ڸ� ���� ����� �Ϸ�Ǿ� #{YYYY-MM-DD}�Ͽ� ����˴ϴ�.     * ���� : #{��������}   * �����ȣ : #{�����ȣ}   * ��ǰ�� : #{��ǰ��}  * ��û�� : #{��û��}   * ����Ⱓ : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}�ϰ�)  * ������� : #{���������}  * ���� : #{������ȭ��ȣ}   �� ������� �ٷΰ��� : https://cqc39.app.goo.gl/kP7D'
,KKO_MSG ='[�������] #{ȸ���}ȸ����,  ���ڸ� ���� ����� �Ϸ�Ǿ� #{YYYY-MM-DD}�Ͽ� ����˴ϴ�.     * ���� : #{��������}   * �����ȣ : #{�����ȣ}   * ��ǰ�� : #{��ǰ��}  * ��û�� : #{��û��}   * ����Ⱓ : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}�ϰ�)  * ������� : #{���������}  * ���� : #{������ȭ��ȣ}   �� ������� �ٷΰ��� : https://cqc39.app.goo.gl/kP7D'
WHERE TEMPLATE_CODE_2019 ='AAFa047'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[�������]  #{ȸ���}ȸ����,   ���ڸ��� ���� ����Ǿ����ϴ�.   * ���� : #{��������}   * �����ȣ : #{�����ȣ}   * ��ǰ�� : #{��ǰ��}  * ����Ⱓ : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}�ϰ�)   * ���� �ٷΰ��� : #{����URL}  * ������� : #{���������}  * ���� : #{������ȭ��ȣ}   �� ������� �ٷΰ��� : https://cqc39.app.goo.gl/b2HC'
,KKO_MSG ='[�������]  #{ȸ���}ȸ����,   ���ڸ��� ���� ����Ǿ����ϴ�.   * ���� : #{��������}   * �����ȣ : #{�����ȣ}   * ��ǰ�� : #{��ǰ��}  * ����Ⱓ : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}�ϰ�)   * ���� �ٷΰ��� : #{����URL}  * ������� : #{���������}  * ���� : #{������ȭ��ȣ}   �� ������� �ٷΰ��� : https://cqc39.app.goo.gl/b2HC'
WHERE TEMPLATE_CODE_2019 ='AAFa046'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[�������]  ����Ͻ� ���ڸ��� �������ǰ� ���� �Ǿ����ϴ�  * ���� : #{��������}   * �����ȣ : #{�����ȣ}   * ������ : #{�����ڼ���}  * ���ǳ��� : #{�������Է³���}  * �����ڿ���ó : #{��ȭ��ȣ}  �� ������ 080-269-0011   �� ������� �ٷΰ��� : https://cqc39.app.goo.gl/qNpA'
,KKO_MSG ='[�������]  ����Ͻ� ���ڸ��� �������ǰ� ���� �Ǿ����ϴ�  * ���� : #{��������}   * �����ȣ : #{�����ȣ}   * ������ : #{�����ڼ���}  * ���ǳ��� : #{�������Է³���}  * �����ڿ���ó : #{��ȭ��ȣ}  �� ������ 080-269-0011   �� ������� �ٷΰ��� : https://cqc39.app.goo.gl/qNpA'
WHERE TEMPLATE_CODE_2019 ='AAFa045'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[�������]  [#{ȸ���}]ȸ����,  [���� : #{����}]  / #{�����ȣ} ���ڸ��� ���� ����˴ϴ�.     * ���� : #{��������}   * �����ȣ : #{�����ȣ}   * ����� : #{�����}   * ����Ⱓ : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}�ϰ�)     �� ���ڸ� ������ �Ʒ� ��ũ�� ���� Ȯ�� �Ͻ� �� �ֽ��ϴ�.    https://cqc39.app.goo.gl/GTHH �� ������ : 080-269-0011 '
,KKO_MSG ='[�������]  [#{ȸ���}]ȸ����,  [���� : #{����}]  / #{�����ȣ} ���ڸ��� ���� ����˴ϴ�.     * ���� : #{��������}   * �����ȣ : #{�����ȣ}   * ����� : #{�����}   * ����Ⱓ : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}�ϰ�)     �� ���ڸ� ������ �Ʒ� ��ũ�� ���� Ȯ�� �Ͻ� �� �ֽ��ϴ�.    https://cqc39.app.goo.gl/GTHH �� ������ : 080-269-0011 '
WHERE TEMPLATE_CODE_2019 ='AAFa021'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[�������]  [#{ȸ���}]ȸ����,  ����� ���ڸ��� ���� ����Ǿ����ϴ�.     * ���� : #{��������}   * �����ȣ : #{�����ȣ}   * ����� : #{�����}   * ����Ⱓ : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}�ϰ�)   * ���� �ٷΰ��� : #{����URL}     �� ���ڸ� ������ �Ʒ� ��ũ�� ���� Ȯ�� �Ͻ� �� �ֽ��ϴ�.   https://cqc39.app.goo.gl/tkEq �� ������ : 080-269-0011 '
,KKO_MSG ='[�������]  [#{ȸ���}]ȸ����,  ����� ���ڸ��� ���� ����Ǿ����ϴ�.     * ���� : #{��������}   * �����ȣ : #{�����ȣ}   * ����� : #{�����}   * ����Ⱓ : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}�ϰ�)   * ���� �ٷΰ��� : #{����URL}     �� ���ڸ� ������ �Ʒ� ��ũ�� ���� Ȯ�� �Ͻ� �� �ֽ��ϴ�.   https://cqc39.app.goo.gl/tkEq �� ������ : 080-269-0011 '
WHERE TEMPLATE_CODE_2019 ='AAFa020'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[�������] [#{ȸ���}]ȸ����,  #{��ǰ��} ��ǰ�� ������ �Ϸ� �Ǿ����ϴ�     [���ڸ���������]   * ���� : #{title}   * �����ǰ ����Ⱓ : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}�ϰ�)   * �����ݾ� : #{�����ݾ�}��   �� ���ڸ� ������ �Ʒ� ��ũ�� ���� Ȯ�� �Ͻ� �� �ֽ��ϴ�.  https://cqc39.app.goo.gl/NedC �� ������ : 080-269-0011 '
,KKO_MSG ='[�������] [#{ȸ���}]ȸ����,  #{��ǰ��} ��ǰ�� ������ �Ϸ� �Ǿ����ϴ�     [���ڸ���������]   * ���� : #{title}   * �����ǰ ����Ⱓ : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}�ϰ�)   * �����ݾ� : #{�����ݾ�}��   �� ���ڸ� ������ �Ʒ� ��ũ�� ���� Ȯ�� �Ͻ� �� �ֽ��ϴ�.  https://cqc39.app.goo.gl/NedC �� ������ : 080-269-0011 '
WHERE TEMPLATE_CODE_2019 ='AAFa015'

UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_CODE_2019 = 'AB'+SUBSTRING(TEMPLATE_CODE_2019,3,len(TEMPLATE_CODE_2019)-2)
,LMS_MSG ='[�������] [#{ȸ���}]ȸ����,  #{��ǰ��} ��ǰ�� ������ �Ϸ� �Ǿ����ϴ�    [���ڸ���������]  * ���� : #{title}   * ��ǰ�� : #{��ǰ��}   * �����ǰ ����Ⱓ : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}�ϰ�)   * �����ݾ� : #{�����ݾ�}��     �� ���ڸ� ������ �Ʒ� ��ũ�� ���� Ȯ�� �Ͻ� �� �ֽ��ϴ�.   https://cqc39.app.goo.gl/2fHe �� ������ : 080-269-0011 '
,KKO_MSG ='[�������] [#{ȸ���}]ȸ����,  #{��ǰ��} ��ǰ�� ������ �Ϸ� �Ǿ����ϴ�    [���ڸ���������]  * ���� : #{title}   * ��ǰ�� : #{��ǰ��}   * �����ǰ ����Ⱓ : #{YYYY-MM-DD ~ YYYY-MM-DD}(#{day}�ϰ�)   * �����ݾ� : #{�����ݾ�}��     �� ���ڸ� ������ �Ʒ� ��ũ�� ���� Ȯ�� �Ͻ� �� �ֽ��ϴ�.   https://cqc39.app.goo.gl/2fHe �� ������ : 080-269-0011 '
WHERE TEMPLATE_CODE_2019 ='AAFa011'



/*
select A.LINEADNO
           , A.LINEADID
           , C.CodeNm3 +' > '+C.CodeNm4
FROM [FINDDB1].PAPER_NEW.DBO.PP_AD_TB A (NOLOCK)
  INNER JOIN [FINDDB1].PAPER_NEW.DBO.PP_LINE_AD_FINDCODE_TB B (NOLOCK) 
          ON B.LINEADNO = A.LINEADNO
  INNER JOIN [FINDDB1].PAPER_NEW.DBO.PP_FINDCODE_TB C (NOLOCK) 
          ON C.Code4 = B.FINDCODE
       WHERE B.LINEADNO='0005351922180080'

       
SELECT 
WORKTIMETO , WORKTIMEFROM,*
fROM PP_LINE_AD_EXTEND_DETAIL_JOB_1DAY_TB --WHERE WORKTIMEF = '0'
WHERE LINEADNO='0005351956180180'

SELECT 
CASE WHEN LEN(WORKTIMETO) = 4 THEN REPLACE(WORKTIMETO,LEFT(WORKTIMETO,2),LEFT(WORKTIMETO,2)+':')
     WHEN LEN(WORKTIMETO) = 3 THEN REPLACE(WORKTIMETO,LEFT(WORKTIMETO,1),'0'+LEFT(WORKTIMETO,1)+':')
     WHEN LEN(WORKTIMETO) = 2 THEN REPLACE(WORKTIMETO,WORKTIMETO,'00:'+RIGHT(WORKTIMETO,2))
     ELSE '00:00' END,
CASE WHEN LEN(WORKTIMEFROM) = 4 THEN REPLACE(WORKTIMEFROM,LEFT(WORKTIMEFROM,2),LEFT(WORKTIMEFROM,2)+':')
     WHEN LEN(WORKTIMEFROM) = 3 THEN REPLACE(WORKTIMEFROM,LEFT(WORKTIMEFROM,1),'0'+LEFT(WORKTIMEFROM,1)+':')
     WHEN LEN(WORKTIMEFROM) = 2 THEN REPLACE(WORKTIMEFROM,WORKTIMEFROM,'00:'+RIGHT(WORKTIMEFROM,2))
     ELSE '00:00' END
fROM PP_LINE_AD_EXTEND_DETAIL_JOB_1DAY_TB --WHERE WORKTIMEF = '0'
WHERE LINEADNO='0005351956180180'

       */