--NEW VITALS

SELECT
fvs.Coid AS HospID,
Substr(Cast(Cast(Trim(OTranslate(reg.Medical_Record_Num,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' ,'')) AS INTEGER) + 135792468 + Cast(fvs.Coid AS INTEGER) + 1000000000000 AS CHAR(13)),2,12) AS PtID,
Cast((fp.Patient_DW_ID (Format '999999999999999999'))  + 135792468 + Cast(fp.Coid AS INTEGER)AS DECIMAL(18,0)) AS AdmtID,
dvt.Vital_Test_Desc,
fvs.Vital_Result_Value_Txt,
fvs.Vital_Result_Unit_Type_Code AS Vital_UOM,
Cast(fvs.Vital_Occr_Date_Time AS DATE) - fp.Admission_Date AS Vital_Rel_Day,
Cast(fvs.Vital_Occr_Date_Time AS TIME) AS Vital_Time,
fvs.Source_System_Original_Code
FROM EDWCDM_PC_VIEWS.Fact_Vital_Signs fvs

INNER JOIN EDWCDM_Views.Fact_Patient fp
ON fp.Patient_DW_Id = fvs.Patient_DW_Id
AND fp.CoID = fvs.CoID
AND fp.company_code = fvs.company_code 

INNER JOIN EDWCL_Views.Clinical_Registration reg
ON fvs.Patient_DW_Id = reg.Patient_DW_Id
AND fvs.CoID = reg.CoID
AND fvs.company_code = reg.company_code 

INNER JOIN qwu6617.McDonald_SU_PatientPop1 pop  --replace pop
ON fvs.Patient_DW_Id = pop.Patient_DW_Id
AND fvs.Company_Code = pop.Company_Code
AND fvs.Coid = pop.Coid

LEFT JOIN EDWCDM_VIEWS.Dim_Vital_Test dvt
ON dvt.Vital_Test_Sk = fvs.Vital_Test_Sk

GROUP BY 1,2,3,4,5,6,7,8,9
