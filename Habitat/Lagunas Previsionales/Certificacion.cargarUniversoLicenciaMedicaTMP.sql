create PROCEDURE Certificacion.cargarUniversoLicenciaMedicaTMP(IN periodoInformar date,OUT codigoError VARCHAR(10))
BEGIN
/**
        - Nombre archivo                            : cargarUniversoLicenciaMedicaTMP.sql
        - Nombre del módulo                         : Lagunas Previsionales
        - Fecha de  creación                        : 2024-02-01
        - Nombre del autor                          : Denis Chávez - Cognitiva-ti
        - Descripción corta del módulo              : 
        - Lista de procedimientos contenidos        : 
        - Documentos asociados a la creación        : 
        - Fecha de modificación                     : 
        - Nombre de la persona que lo modificó      : 
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
    DECLARE cdtFechaInicio                              DATE;
    DECLARE cstYYYYMM                                   VARCHAR(20);
    DECLARE cst01                                       CHAR(2);  
    DECLARE cit3                                        INTEGER;
    
        -------------------------------------------------------------------------------------------
    --Seteo Variable auditoria
    -------------------------------------------------------------------------------------------
    --se obtiene la fecha y hora de carga
    SET ldtFechaInicioCarga                     = getDate();
    
    -------------------------------------------------------------------------------------------
    --Seteo de Constantes
    -------------------------------------------------------------------------------------------
    SET cstOwner                                = 'Certificacion';
    SET cstNombreProcedimiento                  = 'cargarUniversoLicenciaMedicaTMP';
    SET cstNombreTablaFct                       = 'UniversoLicenciaMedicaTMP';
    SET cdtFechaInicio                          = '1981-01-01';
    SET cstYYYYMM                               = 'YYYYMM';
    SET cst01                                   = '01';
    SET cit3                                    = 3;
    
    --se obtiene el parametro MAXIMA_FECHA_VIGENCIA de la tabla Parametros
    SELECT CONVERT(DATE, DMGestion.obtenerParametro('MAXIMA_FECHA_VIGENCIA'), 103) 
        INTO ldtMaximaFechaVigencia 
    FROM DUMMY;

    --Fecha del periodo a informar
    SET ldtFechaPeriodoInformado  = periodoInformar;

    SET cstCodigoErrorCero = '0';

    
    --Obtener el ultimo dia del mes
    
    SET ldtFechaUltimoDiaMes = DMGestion.obtenerUltimaFechaMes(ldtFechaPeriodoInformado);

    
    IF (EXISTS (SELECT 1 FROM SYSCATALOG WHERE tname = cstNombreTablaFct AND creator = cstOwner)) THEN
            DROP TABLE Certificacion.UniversoLicenciaMedicaTMP;
    END IF;

    CREATE TABLE Certificacion.UniversoLicenciaMedicaTMP (
        rut int NULL,
        FEC_DESDE DATE NULL,
        FEC_HASTA DATE NULL,
        periodoInicio DATE NULL,
        periodoTermino DATE NULL
    );
    CREATE INDEX DATE_licenciasMedicasTMP_01 ON Certificacion.UniversoLicenciaMedicaTMP (periodoInicio);
    CREATE INDEX DATE_licenciasMedicasTMP_02 ON Certificacion.UniversoLicenciaMedicaTMP (periodoTermino);
    CREATE INDEX HG_licenciasMedicasTMP_01 ON   Certificacion.UniversoLicenciaMedicaTMP (rut);


    INSERT INTO Certificacion.UniversoLicenciaMedicaTMP
    WITH detalle as
        (SELECT ID_DET_PLANILLA,
            FEC_DESDE,FEC_HASTA, DATE(DATEFORMAT(FEC_DESDE,cstYYYYMM)||cst01)periodoInicio,
            DATE(DATEFORMAT(FEC_HASTA,cstYYYYMM)||cst01)periodoTermino
            FROM
        (SELECT DISTINCT ID_DET_PLANILLA,FEC_DESDE, FEC_HASTA
        --INTO #revisa
        FROM DMGestion.VistaTbPlanillaMoviper tm 
            WHERE tm.ID_TIP_MOVIPER = cit3
            AND ID_DET_PLANILLA IS NOT NULL
            AND ISNULL(FEC_DESDE,ldtMaximaFechaVigencia)<= ldtFechaUltimoDiaMes
            AND ISNULL(FEC_HASTA,ldtMaximaFechaVigencia)<= ldtFechaUltimoDiaMes)UN
        WHERE FEC_DESDE BETWEEN cdtFechaInicio AND ldtFechaUltimoDiaMes
            AND FEC_HASTA BETWEEN cdtFechaInicio AND ldtFechaUltimoDiaMes
            )
    SELECT tmp.RUT_MAE_PERSONA rut,FEC_DESDE, FEC_HASTA, periodoInicio, periodoTermino
    FROM DDS.TB_DET_PLANILLA tdp
        INNER JOIN DDS.TB_MAE_PERSONA tmp ON tmp.ID_MAE_PERSONA = tdp.ID_MAE_PERSONA 
        INNER JOIN detalle det ON det.ID_DET_PLANILLA = tdp.ID_DET_PLANILLA;


    COMMIT;
    SAVEPOINT;
    SET codigoError = cstCodigoErrorCero;

-------------------------------------------------------------------------------------------     
--Manejo de Excepciones      
-------------------------------------------------------------------------------------------   
EXCEPTION
    WHEN OTHERS THEN
        SET lstCodigoError = SQLSTATE;
        SET codigoError = lstCodigoError;
        ROLLBACK;
        CALL Certificacion.registrarErrorProceso(cstOwner, cstNombreProcedimiento, lstCodigoError);
END