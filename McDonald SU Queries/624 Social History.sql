SELECT
e.COID,
ff.COID_Name,
Cast((sh.Encounter_DW_ID (Format '999999999999999999')) + 135792468 + Cast(e.Coid AS INTEGER)AS DECIMAL(18,0)) AS AdmtID,
SOCIAL_HIST_CAT_DESC,
SOCIAL_HIST_COND_DESC,
SOCIAL_HIST_DETAIL_DESC,
SOCIAL_HIST_VALUE_TXT,
SNOMED_CODE
FROM EDWPS_GME_Views.Encounter_Social_History sh

INNER JOIN EDWPS_GME_Views.Encounter e
ON sh.encounter_dw_id = e.encounter_dw_id

INNER JOIN EDWCDM_Views.Fact_Facility ff
ON e.Coid = ff.Coid

INNER JOIN qwu6617.McDonald_SU_PatientPop pop
ON e.coid = pop.coid
AND sh.encounter_dw_id = pop.patient_dw_id