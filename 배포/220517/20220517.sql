USE PAPER_NEW
GO

UPDATE PP_BRANCH_INFO_TB
SET BOXTEL = '042-540-1900' , LINETEL = '042-540-1900' , ICON_USE_YN ='N'
WHERE BRANCHCODE ='53' AND BRANCHNAME = '��õ�������'


UPDATE CM_ADMIN_BRANCH_MAPPING_TB
SET MAG_BRANCH ='12'
WHERE MAG_BRANCH ='53' 