------------------------------------------------------------------------------------------------------------------------------
UPDATE FINDDB1.COMDB1.dbo.KKO_MSG_TEMPLATE
SET TEMPLATE_NAME = REPLACE(TEMPLATE_NAME,'[��˼�_���ีũ����]','[BI����]') , URL_BUTTON_TXT = REPLACE(URL_BUTTON_TXT,'������屸�α��� �ٷΰ���','������� �ٷΰ���')
WHERE TEMPLATE_CODE_2019 in (
 'ABFa067','ABFa066','ABFa065','ABFa048','ABFa047','ABFa046','ABFa045','ABFa021','ABFa020','ABFa015','ABFa011','ABsms17','ABsms06','ABsms02','ABsms01','ABFa070','ABFa043','ABFa042','ABFa041','ABFa038','ABFa026','ABFa025','ABFa024','ABFa022','ABFa019','ABFa018','ABFa017','ABFa016','ABFa014','ABFa013','ABFa012','ABFa010','ABFa009','ABFa008','ABFa007'
 ) 
------------------------------------------------------------------------------------------------------------------------------
