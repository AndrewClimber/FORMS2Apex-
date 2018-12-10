
������ ����� ����������� � ������� ����������.


����� ��� �������� ������
1. ��� ������������
http://www.tomsknipineft/database/others/MARK2.htm
2. �������� ����������
\\science\apps\forms\FRM_WELL_PERF.fmb
��� ���� ����� ���������� �� ��������� � ������ �������, � ������ 
� WELL_PERFORATION
3. ����������� �������.
http://www.tomsknipineft/database/dev_server/form_start.htm


3. ���� ������� - ��������
\\science\apps\forms\rep_wells.fmb


�������� ����� (��������)
1. ������������� ���������� ���
http://www.tomsknipineft/database/dev_server/form_start.htm
2. ���������� �������
http://www.tomsknipineft/database/dev_server/form_start.htm

------------------------
--- ��������������� ������� ������� ��� �������� ������������� � las-�����.
---
select pts.md, pts.deviation_angle, pts.azimuth+hdr.d_corr, pts.md, pts.tvd-w_hdr.elevation
from DVURECH.WELL_DIR_SRVY_PTS pts ,
( SELECT  decode(north_reference, 'M', declination_correction, 0 ) d_corr       
  FROM  dvurech.well_dir_srvy_hdr 
  where uwi ='015000001W0' ) hdr,
( select elevation from dvurech.well_hdr where uwi='015000001W0' )  w_hdr 
where UWI = '015000001W0' 
      and SOURCE = 'TNGF' and DIR_SRVY_ID = '1' 
ORDER BY pts.md --deviation_angle 
---------------------------


-- ������������ ��� ������ �������������
SELECT A.PROJ_FINDER, A.FIELD_NAME, A.FIELD_CODE 
FROM CLASS.ALL_FIELD_HDR A, SYS.ALL_CATALOG C 
WHERE A.PROJ_FINDER = C.OWNER AND C.TABLE_NAME = 'WELL_HDR' AND FIELD_NAME > 'A' order by 2


SELECT  field_name, field_code, proj_finder
  FROM codes.field_hdr@finder WHERE field_code>0



-- ������������ ��� ����������� ������ uwi � �������������
SELECT ROWID,NODE_ID,UWI,WELL_NAME,WELL_NUMBER,PROV_ST,CLASS,TOP_DELTA_X,
BASE_DELTA_X, -- ����� �� ������� ������� ������ � ������� ����� X
TOP_DELTA_Y,
BASE_DELTA_Y, -- ����� �� ������� ������� ������ � ������� ����� Y
ELEVATION, -- ���������(�)
DRILLERS_TD, -- ����� ������� �������(�)
TVD, -- ������������ ������� �����(�)
SPUD_DATE,FIN_DRILL,COMP_DATE,FIELD,LICENSEE,
INITIAL_CLASS, -- ��������� ���������� ��������
ELEVATION_REF,
PRIMARY_SOURCE -- �������� ������
FROM DVURECH.WELL_HDR 
WHERE uwi like to_char('150','fm0000')||'%' and substr(uwi,10,2) != 'LE' and well_name not like 'L%'  
order by UWI, WELL_NAME





SELECT ROWID,NODE_ID,
NODE_X, -- ����� X 
NODE_Y, -- ����� Y 
LOC_QUAL,
SOURCE -- �������� ������
FROM DVURECH.NODES 
WHERE node_id = 442777 and (NODE_ID=442777) order by NODE_X, NODE_Y


-- �������� �����
SELECT ROWID,UWI,DIR_SRVY_ID,
SOURCE, -- �����������
SURVEY_COMPANY, -- ��������
SURVEY_DATE, -- ����
SURVEY_TYPE,
REMARKS, -- ������ , ������� ��������� ���������
COMPILE_GROUP,
PREFERRED_FLAG,PROJECTION_ID,NORTH_REFERENCE,DECLINATION_CORRECTION,CALCULATION_METHOD,PROC_DATE,SURVEY_DIGITAL_REF,DIGITAL_REF_VOLUME 
FROM DVURECH.WELL_DIR_SRVY_HDR WHERE (UWI='015000001W0') order by DIR_SRVY_ID, SOURCE


-- �������
SELECT ROWID,TRACE_ID,
UWI,
SERVICE, -- ��� ��������
TRACE_TYPE, -- ��� ��������
TOP, -- ������
BASE, -- �����
DEPTH_INC, -- ���
DEPTH_UNIT -- ��.���.
FROM DVURECH.WELL_LOG_CURVE_HDR WHERE (UWI='015000001W0')



-- �������������
SELECT ROWID,
UWI,N_S_DIR,E_W_DIR,DELTA_ANGLE,DELTA_AZIMUTH,TRAVEL_TIME,
SOURCE,DIR_SRVY_ID,
MD, -- ������� (�) �����.
TVD,-- ������� (�) ������.
DEVIATION_ANGLE, -- ���������� ��. ���� 
AZIMUTH, -- ���������� ��. ������ 
DX, -- ���������� �. �� ��� X
DY, -- ���������� �. �� ��� Y
VERTICAL_SECTION,CONDITION 
FROM DVURECH.WELL_DIR_SRVY_PTS WHERE (UWI='015000001W0') and (SOURCE='TNGF') and (DIR_SRVY_ID=1) order by MD


-- ������������� . �������� �����
select 
deviation_angle, -- ����
azimuth,  -- ������
dx,  -- ����� �� ��� X
dy,  -- ����� �� ��� Y
md,  -- ������� �� ������
tvd  -- ������� �� ���������
from DVURECH.WELL_DIR_SRVY_PTS where UWI = '015000001W0' and SOURCE = 'TNGF' and DIR_SRVY_ID = '1' ORDER BY md desc


-- �������� ������������� � las
procedure make_las

