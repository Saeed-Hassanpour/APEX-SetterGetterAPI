CREATE OR REPLACE PACKAGE  APEX_PKG_PARAMS IS

/*-----------------------------------
-- Author: Saeed Hassanpour
-- Date:  2014-07-06
-- Current revision:
-- Last Modified: 2017-02-09
-- By:
-- Reviewers:
*/-----------------------------------

--      setter and getter for APEX 4.x,5.x,18.x

--     p_count_records = If you have multi records like array to use this parameter
--     p_seq           = Indicate record that generate when you use multi records

--     p_index Character  =  Index numbers are 1 through 50. Any number outside of this range will be ignored.
--     p_param            =  Maximum length can be 4,000 bytes.

--     p_index Number  =  Index numbers are 1 through 5. Any number outside of this range will be ignored.
--     p_index Date  =  Index numbers are 1 through 5. Any number outside of this range will be ignored.

--    add  p_count_records, p_seq 2017/02/07

l_sql  Varchar2(2000);

-------------------------***************************************---------------------------
--Set Parameter Initial
procedure setparaminit(p_count_records number default 1);
-------------------------***************************************---------------------------
function getcollectionname return varchar2;
-------------------------***************************************---------------------------
--Set Parameter Varchar2
procedure setparam(p_param varchar2,p_index number default 1, p_count_seq number default 1, p_seq number default 1);
-------------------------***************************************---------------------------
--Set Parameter NUMBER
procedure setparamnum(p_param number,p_index number default 1, p_count_seq number default 1, p_seq number default 1);
-------------------------***************************************---------------------------
--Set Parameter DATE
procedure setparamdte(p_param date,p_index number default 1, p_count_seq number default 1, p_seq number default 1);
-------------------------***************************************---------------------------
--Set Parameter CLOB
procedure setparamclob(p_param clob,  p_count_seq number default 1, p_seq number default 1);
-------------------------***************************************---------------------------
--Set Parameter BLOB
procedure setparamblob(p_param blob,  p_count_seq number default 1, p_seq number default 1);
-------------------------***************************************---------------------------
--Set Parameter XML
procedure setparamxml(p_param sys.xmltype,  p_count_seq number default 1, p_seq number default 1);
-------------------------***************************************---------------------------
--Get Parameter Varchar2
function getparam(p_index number default 1, p_seq number default 1) return varchar2;
-------------------------***************************************---------------------------
--Get Parameter NUMBER
function getparamnum(p_index number default 1, p_seq number default 1) return number;
-------------------------***************************************---------------------------
--Get Parameter DATE
function getparamdte(p_index number default 1, p_seq number default 1) return date;
-------------------------***************************************---------------------------
--Get Parameter CLOB
function getparamclob(p_seq number default 1) return clob;
-------------------------***************************************---------------------------
--Get Parameter BLOB
function getparamblob(p_seq number default 1) return blob;
-------------------------***************************************---------------------------
--Get Parameter XML
function getparamxml(p_seq number default 1) return sys.xmltype;
-------------------------***************************************---------------------------
--Remove Parameters
procedure purgeparams;
-------------------------***************************************---------------------------
--Is Parameters 
function isparams return char;



END APEX_PKG_PARAMS;
/


CREATE OR REPLACE PACKAGE BODY       APEX_PKG_PARAMS IS

-------------------------***************************************---------------------------
--get parameter varchar2
function getparam(p_index number default 1, p_seq number default 1) return varchar2 is

l_get Varchar2(4000);
 
BEGIN

     l_sql := 'Begin Select C'||Lpad(To_Char(p_index),3,00)||' Into :1 From APEX_COLLECTIONS Where Collection_Name = '''||getcollectionname||'''  and SEQ_ID = '||p_seq||'; End;';
     Execute Immediate l_sql Using Out l_get;

     Return l_get;
END;
-------------------------***************************************---------------------------
--get parameter number
function getparamnum(p_index number default 1, p_seq number default 1) return number is

l_get NUMBER;
 
BEGIN

     l_sql := 'Begin Select N'||Lpad(To_Char(p_index),3,00)||' Into :1 From APEX_COLLECTIONS Where Collection_Name = '''||getcollectionname||'''  and SEQ_ID = '||p_seq||'; End;';
     Execute Immediate l_sql Using Out l_get;

     Return l_get;
END;
-------------------------***************************************---------------------------
--get parameter date
function getparamdte(p_index number default 1, p_seq number default 1) return date is

l_get DATE;
 
BEGIN

     l_sql := 'Begin Select D'||Lpad(To_Char(p_index),3,00)||' Into :1 From APEX_COLLECTIONS Where Collection_Name = '''||getcollectionname||'''  and SEQ_ID = '||p_seq||'; End;';
     Execute Immediate l_sql Using Out l_get;

     Return l_get;
END;
-------------------------***************************************---------------------------
--get parameter clob
function getparamclob(p_seq number default 1) return clob is

l_get CLOB;
 
BEGIN

     l_sql := 'Begin Select CLOB001 Into :1 From APEX_COLLECTIONS Where Collection_Name = '''||getcollectionname||'''  and SEQ_ID = '||p_seq||'; End;';
     Execute Immediate l_sql Using Out l_get;

     Return l_get;
END;
-------------------------***************************************---------------------------
--get parameter blob
function getparamblob(p_seq number default 1) return blob is

l_get BLOB;
 
BEGIN

     l_sql := 'Begin Select BLOB001 Into :1 From APEX_COLLECTIONS Where Collection_Name = '''||getcollectionname||'''  and SEQ_ID = '||p_seq||'; End;';
     Execute Immediate l_sql Using Out l_get;

     Return l_get;
END;
-------------------------***************************************---------------------------
--get parameter xml
function getparamxml(p_seq number default 1) return sys.xmltype is

l_get sys.xmltype;
 
BEGIN

     l_sql := 'Begin Select XMLTYPE001 Into :1 From APEX_COLLECTIONS Where Collection_Name = '''||getcollectionname||'''  and SEQ_ID = '||p_seq||'; End;';
     Execute Immediate l_sql Using Out l_get;

     Return l_get;
END;





-------------------------***************************************---------------------------
--set parameter varchar2
procedure setparam(p_param varchar2,p_index number default 1, p_count_seq number default 1, p_seq number default 1) is

BEGIN

    --žCotrol index
    If p_index > 49 Then 
        Raise_Application_Error('-20000','@Maximum index can be 50@');
         
    End If;
    --Initialize parameter
    SetParamInit(p_count_seq);
    --Update index value
    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(p_collection_name => getcollectionname,
                                            p_seq => p_seq,
                                            p_attr_number => p_index, 
                                            p_attr_value =>  p_param);
    Commit;                                            
 
     
END;
-------------------------***************************************---------------------------
--set parameter number
procedure setparamnum(p_param number,p_index number default 1, p_count_seq number default 1, p_seq number default 1) is

BEGIN
    --žControl index
    If p_index > 5 Then 
        Raise_Application_Error('-20000','@Maximum index can be 5@');
    End If;
    --Initialize parameter
    SetParamInit(p_count_seq);
    --Update index value
    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(p_collection_name => getcollectionname,
                                            p_seq => p_seq,
                                            p_attr_number => p_index, 
                                            p_number_value  => p_param);    
      
END;
-------------------------***************************************---------------------------
--set parameter date
procedure setparamdte(p_param date,p_index number default 1, p_count_seq number default 1, p_seq number default 1) is


BEGIN
    
    --žControl index
    If p_index > 5 Then 
        Raise_Application_Error('-20000','@Maximum index can be 5@');
    End If;
    --Initialize parameter
    SetParamInit(p_count_seq);
    --Update index value
    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(p_collection_name => getcollectionname,
                                            p_seq => p_seq,
                                            p_attr_number => p_index, 
                                            p_date_value  => p_param);
       
END;
-------------------------***************************************---------------------------
--set parameter clob
procedure setparamclob(p_param clob, p_count_seq number default 1, p_seq number default 1) is


BEGIN

    --Initialize parameter
    SetParamInit(p_count_seq);
    --Update index value
    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(p_collection_name => getcollectionname,
                                            p_seq => p_seq,
                                            p_clob_number => 1, 
                                            p_clob_value  => p_param);
       
END;
-------------------------***************************************---------------------------
--set parameter blob
procedure setparamblob(p_param blob, p_count_seq number default 1, p_seq number default 1) is


BEGIN

    --Initialize parameter
    SetParamInit(p_count_seq);
    --Update seq value
    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(p_collection_name => getcollectionname,
                                            p_seq => p_seq,
                                            p_blob_number => 1, 
                                            p_blob_value  => p_param);
       
END;

--set parameter xml
procedure setparamxml(p_param sys.xmltype, p_count_seq number default 1, p_seq number default 1) is


BEGIN

    --Initialize parameter
    SetParamInit(p_count_seq);
    --Update seq value
    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(p_collection_name => getcollectionname,
                                            p_seq => p_seq,
                                            p_xmltype_number => 1, 
                                            p_xmltype_value  => p_param);
       
END;





-------------------------***************************************---------------------------
--set parameter initial
procedure setparaminit(p_count_records number default 1)
 IS

BEGIN

    -- If collection doesn't exist yet - create it
    If Not apex_collection.collection_exists(p_collection_name => getcollectionname) Then
         apex_collection.create_or_truncate_collection(p_collection_name => getcollectionname);
         for rec in 1..p_count_records Loop
             apex_collection.add_member(p_collection_name => getcollectionname,
                                        p_c001 => null,
                                        p_c002 => null,
                                        p_c003 => null,
                                        p_c004 => null,
                                        p_c005 => null,
                                        p_c006 => null,
                                        p_c007 => null,
                                        p_c008 => null,
                                        p_c009 => null,
                                        p_c010 => null,
                                        p_c011 => null,
                                        p_c012 => null,
                                        p_c013 => null,
                                        p_c014 => null,
                                        p_c015 => null,
                                        p_c016 => null,
                                        p_c017 => null,
                                        p_c018 => null,
                                        p_c019 => null,
                                        p_c020 => null,
                                        p_c021 => null,
                                        p_c022 => null,
                                        p_c023 => null,
                                        p_c024 => null,
                                        p_c025 => null,
                                        p_c026 => null,
                                        p_c027 => null,
                                        p_c028 => null,
                                        p_c029 => null,
                                        p_c030 => null,
                                        p_c031 => null,
                                        p_c032 => null,
                                        p_c033 => null,
                                        p_c034 => null,
                                        p_c035 => null,
                                        p_c036 => null,
                                        p_c037 => null,
                                        p_c038 => null,
                                        p_c039 => null,
                                        p_c040 => null,
                                        p_c041 => null,
                                        p_c042 => null,
                                        p_c043 => null,
                                        p_c044 => null,
                                        p_c045 => null,
                                        p_c046 => null,
                                        p_c047 => null,
                                        p_c048 => null,
                                        p_c049 => null,
                                        p_c050 => null,
                                        p_n001 => null,
                                        p_n002 => null,
                                        p_n003 => null,
                                        p_n004 => null,
                                        p_n005 => null,
                                        p_d001 => null,
                                        p_d002 => null,
                                        p_d003 => null,
                                        p_d004 => null,
                                        p_d005 => null,
                                        p_clob001 => empty_clob(),
                                        p_blob001 => empty_blob(),
                                        p_xmltype001 => null
                                        );
        end loop;                                
    End If;
      
END;
-------------------------***************************************---------------------------
function getcollectionname return varchar2
IS

    v_app_session Varchar2(20);
    v_col_name    Varchar2(100);
    
BEGIN
    v_app_session := To_Char(v('APP_SESSION'));
    v_col_name    := 'COL_PARAM_'||v_app_session;

    Return v_col_name;
END;
-------------------------***************************************---------------------------
--Remove Parameters
procedure purgeparams 
IS
BEGIN
    If  apex_collection.collection_exists(p_collection_name => getcollectionname) Then
        apex_collection.delete_collection(p_collection_name => getcollectionname);
    End If;    
END;
-------------------------***************************************---------------------------
--Is Parameters 
function isparams return char
IS

    -- True 'T'
    -- False 'F'

    l_out CHAR(1);

BEGIN
    
    Select Count(1) 
    Into  l_out 
    From  apex_collections 
    Where collection_name = getcollectionname;
    
    Return (Case When l_out = 0 Then 'F'
            Else 'T'
            End);
       
END;
-------------------------***************************************---------------------------


END APEX_PKG_PARAMS;
/

