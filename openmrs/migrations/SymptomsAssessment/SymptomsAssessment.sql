set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
set @uuid = NULL;

#Add Parent Concepts
#Add Date Concepts
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Date recorded","Date recorded","Date","Misc",false);

#Add Text Concepts
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Other symptoms","Other symptoms","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Visit type, other","Visit type, other","Text","Misc",false);

#Add Coded Concepts
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Visit type","Visit type","Coded","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Fatigue severity of symptom","Fatigue severity","Coded","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Sleep disorder severity of symptom","Sleep disorder severity","Coded","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Nausea and vomiting severity of symptom","Nausea and vomiting severity","Coded","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Poor appetite severity of symptom","Poor appetite severity","Coded","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Shortness of breath severity of symptom","Shortness of breath severity","Coded","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Constipation severity of symptom","Constipation severity","Coded","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Urge incontinence of urine severity of symptom","Urine incontinence severity","Coded","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Dysuria severity of symptom","Dysuria severity","Coded","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Oral lesion severity of symptom","Oral lesion severity","Coded","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Abnormal vaginal bleeding severity of symptom","Abnormal vaginal bleeding severity","Coded","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Postcoital and contact bleeding severity of symptom","Contact bleeding severity","Coded","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Vaginal odor severity of symptom","Vaginal odor severity","Coded","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Vaginal discharge severity of symptom","Vaginal discharge severity","Coded","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Dyspareunia severity of symptom","Dyspareunia severity","Coded","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SA, Other symptoms severity","Other symptoms severity","Coded","Misc",false);

#Add Child Concepts
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Moderate","Moderate","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Initial visit","Initial visit","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Mild","Mild","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Very severe","Very severe","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Severe","Severe","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Follow-up","Follow-up","N/A","Misc",false);