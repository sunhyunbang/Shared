USE [MWMEMBER]
GO
/****** Object:  StoredProcedure [dbo].[sv_find_staff]    Script Date: 2021-11-03 오후 4:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
--직원찾기
--@step=2, @step=3 튜닝함. junesang_cho20100604
*/
CREATE    procedure [dbo].[sv_find_staff]
	@step int=1,	--검색단계
	@c_id int=0	--상위부서코드
as
begin
	set nocount on

	if @step = 1
	begin
		--회사.
		SELECT DISTINCT 2 step, c.c1_id c_id, c.c1_name c_name 
		FROM [221.143.23.211,8019].intranet.dbo.sv_company c with (readuncommitted) 
		WHERE c.c1_level = 1 and (c.c1_id=1  or c.c1_id=141 or c.c1_id=190 or c.c1_id=203) order by c.c1_name --  or c.c1_id=40 부동산써브와 벼룩시장 만 나오도록 추가		
	end
	else if @step = 2
	begin
		--부서1
--		SELECT DISTINCT case when (SELECT count(*) from intranet.dbo.sv_company with (readuncommitted) WHERE c1_level = 1 and c3_id is not null and c2_id = c.c2_id)=0 then 9 else 3 end step,
		SELECT DISTINCT case when not exists(SELECT * from [221.143.23.211,8019].intranet.dbo.sv_company with (readuncommitted) WHERE c1_level = 1 and c3_id is not null and c2_id = c.c2_id) then 9 else 3 end step,
			c.c2_id c_id, c.c2_name c_name 
		FROM [221.143.23.211,8019].intranet.dbo.sv_company c with (readuncommitted) 
		WHERE c.c1_level = 1 and c.c1_id = @c_id order by c.c2_name
	end
	else if @step = 3
	begin
		--부서2
--		SELECT DISTINCT case when (SELECT count(*) from intranet.dbo.sv_company with (readuncommitted) WHERE c1_level = 1 and c4_id is not null and c3_id = c.c3_id)=0 then 9 else 4 end step,
		SELECT DISTINCT case when not exists(SELECT * from [221.143.23.211,8019].intranet.dbo.sv_company with (readuncommitted) WHERE c1_level = 1 and c4_id is not null and c3_id = c.c3_id) then 9 else 4 end step,
			c.c3_id c_id, c.c3_name c_name 
		FROM [221.143.23.211,8019].intranet.dbo.sv_company c with (readuncommitted) 
		WHERE c.c1_level = 1 and c.c2_id = @c_id order by c.c3_name
	end
	else if @step = 4
	begin
		--부서3
		--select distinct case when (select count(*) from intranet.dbo.sv_company where c1_level = 1 and c5_id is not null and c4_id = c.c4_id)=0 then 9 else 5 end step,
		SELECT DISTINCT 9 step,	--추후 하위단계가 추가된다면 이부분을 주석으로 돌리고 위 주석을 풉니다.
			c.c4_id c_id, c.c4_name c_name 
		FROM [221.143.23.211,8019].intranet.dbo.sv_company c with (readuncommitted) WHERE c.c1_level = 1 and c.c3_id = @c_id order by c.c4_name
	end
/*	--추후 하위단계가 추가된다면 옆의 주석을 풀어주십시오. 2005.11.18 Jonathan
	else if @step = 5
	begin
		--부서5
		select distinct 9 step, c.c4_id c_id, c.c4_name c_name 
		from intranet.dbo.sv_company c where c.c1_level = 1 and c.c4_id = @c_id order by c.c5_name
	end
*/
	else if @step = 9
	begin
		if @c_id>108 
		--부서내 직원
		SELECT staff_seq, name FROM [221.143.23.211,8019].intranet.dbo.login_member  with (readuncommitted) where c_id = @c_id and yn_client>0
		else
		SELECT staff_seq, name FROM [221.143.23.211,8019].intranet.dbo.login_member  with (readuncommitted) where c_id = @c_id and yn_client>0
		
	end
	else 
	begin
		--해당조건이 없을때
		print '해당조건으로 검색된 데이터가 없습니다.'
	end
end





GO
