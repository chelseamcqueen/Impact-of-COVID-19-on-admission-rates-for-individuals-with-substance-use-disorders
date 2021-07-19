--Procedures

SELECT
fp.Coid AS HospID
,Substr(Cast(Cast(Trim(OTranslate(reg.Medical_Record_Num,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' ,'')) AS INTEGER) + 135792468 + Cast(fp.Coid AS INTEGER) + 1000000000000 AS CHAR(13)),2,12) AS PtID
,Cast((fp.Patient_DW_ID (Format '999999999999999999'))  + 135792468 + Cast(fp.Coid AS INTEGER)AS DECIMAL(18,0)) AS AdmtID
,CASE 
	WHEN   PP.Origin_Id = 'SHP' THEN PP.PA_Procedure_Seq_Num
	WHEN   PP.Origin_Id IN ( 'SPR','DC') THEN PP.Procedure_Seq_Num
END AS Proc_Seq_Num
,CASE
	WHEN (PP.Procedure_Type_Code='9' AND RP.ICD9_Procedure_Code_Formatted IS NOT NULL )
	THEN  RP.ICD9_Procedure_Code_Formatted 
	ELSE  PP.Procedure_Code 
END AS PX
,RP.Procedure_Desc AS PX_Desc
,RP.Procedure_Long_Desc AS PX_Long_Desc
,PP.Procedure_Type_Code AS PX_CodeType
,PP.Procedure_Code AS OrigPX
,PP.Service_Date - fp.Admission_Date AS Rel_Service_Day
FROM EDWCDM_Views.Fact_Patient fp

INNER JOIN qwu6617.McDonald_SU_PatientPop1  pop
ON fp.Patient_DW_Id = pop.Patient_DW_Id
AND fp.Company_Code = pop.Company_Code
AND fp.Coid = pop.Coid

INNER JOIN EDWCL_Views.Clinical_Registration reg
ON fp.Patient_DW_Id = reg.Patient_DW_Id
AND fp.CoID = reg.CoID
AND fp.company_code = reg.company_code       

INNER JOIN EDWCDM_PC_Views.Patient_Procedure PP   
ON	PP.Patient_DW_Id = FP.Patient_DW_Id 
AND	PP.COID=FP.COID
AND    PP.Procedure_Mapped_Code <> 'Y'

INNER JOIN EDW_PUB_Views.Ref_Procedure RP
ON	PP.Procedure_Code = RP.Procedure_Code
AND	RP.Procedure_Type_Code = PP.Procedure_Type_Code

WHERE Proc_Seq_Num IS NOT NULL

GROUP BY 1,2,3,4,5,6,7,8,9,10