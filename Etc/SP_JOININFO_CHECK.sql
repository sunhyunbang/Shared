/*************************************************************************************  
 *  ���� ���� �� : �ߺ� �������� üũ  
 *  ��   ��   �� : JMG  
 *  ��   ��   �� : 2019-01-14  
 *  ��   ��   �� :  
 *  ��   ��   �� :  
 *  ��        �� : �ߺ� �������� üũ  
 * RETURN(500)  3�� �̻�  
 * RETURN(0)  ����  
 * DECLARE @RET INT  
 * EXEC @RET=SP_JOININFO_CHECK 'MC0GCCqGSIb3DQIJAyEActtpjaNTuHntREaitYRGxqwzecHEwbwNX4bWviXJtxI='  
 * SELECT @RET  
  
 **************************************************************************************/   
ALTER PROCEDURE [dbo].[SP_JOININFO_CHECK]  
	@DI  varchar(70),   
	@CI  varchar(100) 

AS   

 DECLARE @NO_CHK INT  
 IF @DI ='' OR @CI =''
 BEGIN  
  RETURN 500  
 END  

 SELECT @NO_CHK = COUNT(*) FROM CST_MASTER WITH(NOLOCK)   
      WHERE DI = @DI   AND CI = @CI
      AND MEMBER_CD = '2'  
      AND OUT_YN='N'  
  
 IF @NO_CHK > 2  
 BEGIN  
  print(500)  
  RETURN(500)  
 END ELSE  
 BEGIN  
  print(0)  
  RETURN(0)  
 END  