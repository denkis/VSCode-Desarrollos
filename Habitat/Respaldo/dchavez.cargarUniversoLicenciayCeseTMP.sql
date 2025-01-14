create PROCEDURE dchavez.cargarUniversoLicenciayCeseTMP(IN periodoInformar date,OUT codigoError VARCHAR(10))
BEGIN
/**
        - Nombre archivo                            : cargarUniversoLicenciayCese.sql
        - Nombre del módulo                         : 
        - Fecha de  creación                        : 
        - Nombre del autor                          : 
        - Descripción corta del módulo              : 
        - Lista de procedimientos contenidos        : 
        - Documentos asociados a la creación        : 
        - Fecha de modificación                     : 
        - Nombre de la persona que lo modificó      : . 
        - Cambios realizados                        : 
        - Documentos asociados a la modificación    : 
    **/
    --variable para capturar el codigo de error
    DECLARE lstCodigoError                              VARCHAR(10);    --variable local de tipo varchar
    --Variables
    DECLARE ldtMaximaFechaVigencia                      DATE;           --variable local de tipo date
    DECLARE linIdPeriodoInformar                        INTEGER;        --variable local de tipo integer
    ----------------------------------------------------------------------------------------
    DECLARE cstOwner                                    VARCHAR(150);
    DECLARE cstNombreProcedimiento                      VARCHAR(150);   --constante de tipo varchar
    DECLARE cstNombreTablaFct                           VARCHAR(150);   --constante de tipo varchar
    DECLARE ldtFechaUltimoDiaMes                        DATE;           --variable local de tipo date
    DECLARE ldtFechaPeriodoInformado                    DATE;           --variable local de tipo date
    --Variables auditoria
    DECLARE ldtFechaInicioCarga                         DATETIME;       --variable local de tipo datetime
    DECLARE cstCodigoErrorCero                          VARCHAR(10);
    
        -------------------------------------------------------------------------------------------
    --Seteo Variable auditoria
    -------------------------------------------------------------------------------------------
    --se obtiene la fecha y hora de carga
    SET ldtFechaInicioCarga                     = getDate();
    
    -------------------------------------------------------------------------------------------
    --Seteo de Constantes
    -------------------------------------------------------------------------------------------
    SET cstOwner                                = 'dchavez';
    SET cstNombreProcedimiento                  = 'cargarUniversoLicenciayCese';
    --SET cstNombreTablaFct                       = 'FctLagunaPrevisionalDetalle';
    
    --se obtiene el parametro MAXIMA_FECHA_VIGENCIA de la tabla Parametros
    SELECT CONVERT(DATE, DMGestion.obtenerParametro('MAXIMA_FECHA_VIGENCIA'), 103) 
    INTO ldtMaximaFechaVigencia 
    FROM DUMMY;

    --Fecha del periodo a informar
    SET ldtFechaPeriodoInformado  = periodoInformar;

    SET cstCodigoErrorCero = '0';


    --Obtener el ultimo dia del mes
    SELECT DMGestion.obtenerUltimaFechaMes(ldtFechaPeriodoInformado) 
    INTO ldtFechaUltimoDiaMes 
    FROM DUMMY;
    
    IF (EXISTS (SELECT 1 FROM SYSCATALOG WHERE tname = 'UniversoLicenciasMedicasTMP' AND creator = 'dchavez')) THEN
            DROP TABLE dchavez.UniversoLicenciasMedicasTMP;
    END IF;

    CREATE TABLE dchavez.UniversoLicenciasMedicasTMP (
        rut int NULL,
        FEC_DESDE date NULL,
        FEC_HASTA date NULL,
        periodoInicio date NULL,
        periodoTermino date NULL
    );
    CREATE INDEX DATE_licenciasMedicasTMP_01 ON dchavez.UniversoLicenciasMedicasTMP (periodoInicio);
    CREATE INDEX DATE_licenciasMedicasTMP_02 ON dchavez.UniversoLicenciasMedicasTMP (periodoTermino);
    CREATE INDEX HG_licenciasMedicasTMP_01 ON   dchavez.UniversoLicenciasMedicasTMP (rut);


    INSERT INTO dchavez.UniversoLicenciasMedicasTMP
    WITH detalle as
        (SELECT ID_DET_PLANILLA,
            FEC_DESDE,FEC_HASTA, DATE(dateformat(FEC_DESDE,'YYYYMM')||'01')periodoInicio,
            DATE(dateformat(FEC_HASTA,'YYYYMM')||'01')periodoTermino
            FROM
        (SELECT DISTINCT ID_DET_PLANILLA,FEC_DESDE, FEC_HASTA
        --INTO #revisa
        FROM DMGestion.VistaTbPlanillaMoviper tm 
            WHERE tm.ID_TIP_MOVIPER = 3
            AND ID_DET_PLANILLA IS NOT NULL
            AND ISNULL(FEC_DESDE,ldtMaximaFechaVigencia)<= ldtFechaUltimoDiaMes
            AND ISNULL(FEC_HASTA,ldtMaximaFechaVigencia)<= ldtFechaUltimoDiaMes)UN
        WHERE FEC_DESDE BETWEEN '1981-01-01' AND ldtFechaUltimoDiaMes
            AND FEC_HASTA BETWEEN '1981-01-01' AND ldtFechaUltimoDiaMes
            )
    SELECT tmp.RUT_MAE_PERSONA rut,FEC_DESDE, FEC_HASTA, periodoInicio, periodoTermino
    FROM dds.TB_DET_PLANILLA tdp
    INNER JOIN dds.TB_MAE_PERSONA tmp ON tmp.ID_MAE_PERSONA = tdp.ID_MAE_PERSONA 
    INNER JOIN detalle det ON det.ID_DET_PLANILLA = tdp.ID_DET_PLANILLA;


    IF (EXISTS (SELECT 1 FROM SYSCATALOG WHERE tname = 'UniversoTerminoRelacionLaboralTMP' AND creator = 'dchavez')) THEN
            DROP TABLE dchavez.UniversoTerminoRelacionLaboralTMP;
    END IF;

    CREATE TABLE dchavez.UniversoTerminoRelacionLaboralTMP (
        rut int NULL,
        FEC_HASTA date NULL,
        periodoTermino date NULL
    );
    CREATE INDEX DATE_UniversoTerminoRelacionLaboralTMP_02 ON dchavez.UniversoTerminoRelacionLaboralTMP (periodoTermino);
    CREATE INDEX HG_UniversoTerminoRelacionLaboralTMP_01 ON   dchavez.UniversoTerminoRelacionLaboralTMP (rut);
    

    INSERT INTO dchavez.UniversoTerminoRelacionLaboralTMP
    WITH cese as
        (SELECT ID_DET_PLANILLA,FEC_HASTA, DATE(dateformat(FEC_HASTA,'YYYYMM')||'01')periodoTermino
         FROM
            (SELECT DISTINCT ID_DET_PLANILLA, FEC_HASTA
            --INTO #revisa
            FROM DMGestion.VistaTbPlanillaMoviper tm 
                WHERE tm.ID_TIP_MOVIPER = 2
                AND ID_DET_PLANILLA IS NOT NULL
                AND ISNULL(FEC_HASTA,ldtMaximaFechaVigencia)<= ldtFechaUltimoDiaMes)UN
        WHERE FEC_HASTA BETWEEN '1981-01-01' AND ldtFechaUltimoDiaMes
        )
    SELECT tmp.RUT_MAE_PERSONA rut, FEC_HASTA,  DATEADD(mm,1,periodoTermino)periodoTermino
    FROM dds.TB_DET_PLANILLA tdp
    INNER JOIN dds.TB_MAE_PERSONA tmp ON tmp.ID_MAE_PERSONA = tdp.ID_MAE_PERSONA 
    INNER JOIN cese det ON det.ID_DET_PLANILLA = tdp.ID_DET_PLANILLA;

    COMMIT;
    SAVEPOINT;
    SET codigoError = cstCodigoErrorCero;

-------------------------------------------------------------------------------------------     
--Manejo de Excepciones      
-------------------------------------------------------------------------------------------   
/*EXCEPTION
    WHEN OTHERS THEN
        SET lstCodigoError = SQLSTATE;
        SET codigoError = lstCodigoError;
        ROLLBACK;
        CALL ControlProcesos.registrarErrorProceso(cstOwner, cstNombreProcedimiento, lstCodigoError);*/
END