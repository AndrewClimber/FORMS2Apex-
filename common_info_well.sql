
Данные формы расставлены в порядке приоритета.


Формы для загрузки данных
1. Для маркшрейдера
http://www.tomsknipineft/database/others/MARK2.htm
2. Загрузка перфорации
\\science\apps\forms\FRM_WELL_PERF.fmb
Тут надо будет переделать на обращение к другой таблице, а именно 
к WELL_PERFORATION
3. Конструкция скважин.
http://www.tomsknipineft/database/dev_server/form_start.htm


3. Дела скважин - загрузка
\\science\apps\forms\rep_wells.fmb


Отчетные Формы (просмотр)
1. Интерпретация материалов ГИС
http://www.tomsknipineft/database/dev_server/form_start.htm
2. Перфорация скважин
http://www.tomsknipineft/database/dev_server/form_start.htm

------------------------
--- предварительный вариант запроса для выгрузки инклинометрии в las-файлы.
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


-- используется для выбора месторождений
SELECT A.PROJ_FINDER, A.FIELD_NAME, A.FIELD_CODE 
FROM CLASS.ALL_FIELD_HDR A, SYS.ALL_CATALOG C 
WHERE A.PROJ_FINDER = C.OWNER AND C.TABLE_NAME = 'WELL_HDR' AND FIELD_NAME > 'A' order by 2


SELECT  field_name, field_code, proj_finder
  FROM codes.field_hdr@finder WHERE field_code>0



-- используется для отображения спсика uwi в месторождении
SELECT ROWID,NODE_ID,UWI,WELL_NAME,WELL_NUMBER,PROV_ST,CLASS,TOP_DELTA_X,
BASE_DELTA_X, -- сдвиг от верхней позиции ствола к позиции забоя X
TOP_DELTA_Y,
BASE_DELTA_Y, -- сдвиг от верхней позиции ствола к позиции забоя Y
ELEVATION, -- альтитуда(м)
DRILLERS_TD, -- общая глубина бурения(м)
TVD, -- вертикальная глубина забоя(м)
SPUD_DATE,FIN_DRILL,COMP_DATE,FIELD,LICENSEE,
INITIAL_CLASS, -- проектное назначение скважины
ELEVATION_REF,
PRIMARY_SOURCE -- источник данных
FROM DVURECH.WELL_HDR 
WHERE uwi like to_char('150','fm0000')||'%' and substr(uwi,10,2) != 'LE' and well_name not like 'L%'  
order by UWI, WELL_NAME





SELECT ROWID,NODE_ID,
NODE_X, -- устье X 
NODE_Y, -- устье Y 
LOC_QUAL,
SOURCE -- источник данных
FROM DVURECH.NODES 
WHERE node_id = 442777 and (NODE_ID=442777) order by NODE_X, NODE_Y


-- табличка внизу
SELECT ROWID,UWI,DIR_SRVY_ID,
SOURCE, -- предприятие
SURVEY_COMPANY, -- геофизик
SURVEY_DATE, -- дата
SURVEY_TYPE,
REMARKS, -- прибор , которым проводили измерения
COMPILE_GROUP,
PREFERRED_FLAG,PROJECTION_ID,NORTH_REFERENCE,DECLINATION_CORRECTION,CALCULATION_METHOD,PROC_DATE,SURVEY_DIGITAL_REF,DIGITAL_REF_VOLUME 
FROM DVURECH.WELL_DIR_SRVY_HDR WHERE (UWI='015000001W0') order by DIR_SRVY_ID, SOURCE


-- каротаж
SELECT ROWID,TRACE_ID,
UWI,
SERVICE, -- кто проводил
TRACE_TYPE, -- тип каротажа
TOP, -- начало
BASE, -- конец
DEPTH_INC, -- шаг
DEPTH_UNIT -- ед.изм.
FROM DVURECH.WELL_LOG_CURVE_HDR WHERE (UWI='015000001W0')



-- инклинометрия
SELECT ROWID,
UWI,N_S_DIR,E_W_DIR,DELTA_ANGLE,DELTA_AZIMUTH,TRAVEL_TIME,
SOURCE,DIR_SRVY_ID,
MD, -- глубина (м) измер.
TVD,-- глубина (м) вертик.
DEVIATION_ANGLE, -- отклонение гр. угол 
AZIMUTH, -- отклонение гр. азимут 
DX, -- отклонение м. по оси X
DY, -- отклонение м. по оси Y
VERTICAL_SECTION,CONDITION 
FROM DVURECH.WELL_DIR_SRVY_PTS WHERE (UWI='015000001W0') and (SOURCE='TNGF') and (DIR_SRVY_ID=1) order by MD


-- инклинометрия . конечная точка
select 
deviation_angle, -- угол
azimuth,  -- азимут
dx,  -- отход по оси X
dy,  -- отход по оси Y
md,  -- глубина по стволу
tvd  -- глубина по вертикали
from DVURECH.WELL_DIR_SRVY_PTS where UWI = '015000001W0' and SOURCE = 'TNGF' and DIR_SRVY_ID = '1' ORDER BY md desc


-- выгрузка инклинометрии в las
procedure make_las

