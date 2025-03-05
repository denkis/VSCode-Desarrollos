create PROCEDURE Certificacion.cargarFctLagunaPrevisionalManual(IN periodoInformar date,OUT codigoError VARCHAR(10))
BEGIN
/**
        - Nombre archivo                            : cargarFctLagunaPrevisional.sql
        - Nombre del módulo                         : 
        - Fecha de  creación                        : 
        - Nombre del autor                          : 
        - Descripción corta del módulo              : 
        - Lista de procedimientos contenidos        : 
        - Documentos asociados a la creación        : 
        - Fecha de modificación                     :
        - Nombre de la persona que lo modificó      :  
        - Cambios realizados                        : 
        - Documentos asociados a la modificación    : 

        - Fecha de modificación                     : 
        - Cambios realizados                        : 
        - Nombre de la persona que lo modificó      :
    **/
    --variable para capturar el codigo de error
    DECLARE lstCodigoError                              VARCHAR(10);    --variable local de tipo varchar
    --Variables
    DECLARE ldtMaximaFechaVigencia                      DATE;           --variable local de tipo date
    DECLARE linIdPeriodoInformar                        INTEGER;        --variable local de tipo integer
    DECLARE lbiCantidadRegistrosInformados              BIGINT; 
    DECLARE ctiCodigoTipoProcesoMensual                 TINYINT;
    DECLARE ltiCodigoTipoProceso                        TINYINT;
    ----------------------------------------------------------------------------------------
    DECLARE cstOwner                                    VARCHAR(150);
    DECLARE cstNombreProcedimiento                      VARCHAR(150);   --constante de tipo varchar
    DECLARE cstNombreTablaFct                           VARCHAR(150);   --constante de tipo varchar
    
    DECLARE ldtFechaPeriodoInformado                    DATE;           --variable local de tipo date
    --Variables auditoria
    DECLARE ldtFechaInicioCarga                         DATETIME;       --variable local de tipo datetime
    DECLARE cstCodigoErrorCero                          VARCHAR(10);    --constante de tipo varchar
    DECLARE cstSi                                       CHAR(2);
    DECLARE cstNo                                       CHAR(2);
    
        -------------------------------------------------------------------------------------------
    --Seteo Variable auditoria
    -------------------------------------------------------------------------------------------
    --se obtiene la fecha y hora de carga
    SET ldtFechaInicioCarga                     = getDate();
    
    -------------------------------------------------------------------------------------------
    --Seteo de Constantes
    -------------------------------------------------------------------------------------------
    SET cstOwner                                = 'DMGestion';
    SET cstNombreProcedimiento                  = 'cargarFctLagunaPrevisionalManual';
    SET cstNombreTablaFct                       = 'FctLagunaPrevisional';
    SET cstCodigoErrorCero                      = '0';
    SET cstSi                                   = 'Si';
    SET cstNo                                   = 'No';
    SET ctiCodigoTipoProcesoMensual             = 1;
    SET ltiCodigoTipoProceso                    = ctiCodigoTipoProcesoMensual; 
    
        --se obtiene el parametro MAXIMA_FECHA_VIGENCIA de la tabla Parametros
    SELECT CONVERT(DATE, DMGestion.obtenerParametro('MAXIMA_FECHA_VIGENCIA'), 103) 
    INTO ldtMaximaFechaVigencia 
    FROM DUMMY;

    --Fecha del periodo a informar
    SET ldtFechaPeriodoInformado  = periodoInformar;

    --ID del periodo a informar
    SELECT id
    INTO linIdPeriodoInformar 
    FROM DMGestion.DimPeriodoInformado
    WHERE fecha = ldtFechaPeriodoInformado;
    
    
    --se elimina los errores de carga y datos de la fact para el periodo a informar
    CALL Certificacion.eliminarFact(cstNombreProcedimiento, cstNombreTablaFct, linIdPeriodoInformar, codigoError);
    
    IF codigoError = cstCodigoErrorCero THEN 

        CREATE TABLE #UniversoRegistroTMP (
            periodoInformado date,
            idPeriodoInformado integer NOT NULL,
            idPersona bigint NOT NULL,
            rut bigint NOT NULL,
            nroTotalLagunasPrevisionales integer NULL,
            nroTotalMesesConLaguna integer NULL,
            nroTotalMesesSinLaguna integer NULL,
            nroPromedioMesesLaguna numeric(5,2) NULL,
            porcMesesConLaguna numeric(6,3)NULL,--porcentaje de meses sobre el total de meses cotizados
            nroTotaTerminoRelacionLaboral integer NULL,
            nrototalAbonosCCIAV integer NULL,
            indPensionado char(2) NULL,
            indMantieneLagunaVigente char(2) NULL
            );
        
    
        INSERT INTO  #UniversoRegistroTMP
        (periodoInformado,idPeriodoInformado ,idPersona ,rut,nroTotaTerminoRelacionLaboral,nroTotalLagunasPrevisionales,nroTotalMesesConLaguna,nrototalAbonosCCIAV )
        SELECT ldtFechaPeriodoInformado,flpd.idPeriodoInformado,flpd.idPersona,rut,sum(CASE WHEN indTerminoRelacionLaboral= cstSi THEN 1 ELSE 0 end) totaTerminoRelacionLaboral,max(nroLaguna)totalLagunasPrevisionales
            , sum(flpd.nroMesesLaguna)totalMesesLaguna, SUM(flpd.nroMesesAbonoCCIAV)totalCotiCCIAV
        FROM Certificacion.FctLagunaPrevisionalDetalle flpd 
            INNER JOIN DMGestion.DimPersona dp ON dp.id = flpd.idPersona 
        GROUP BY flpd.idPeriodoInformado,flpd.idPersona,rut;
    
    
        SELECT dp.rut, round(avg(nroMesesLaguna),1)promedio 
        INTO #promedio
        FROM Certificacion.FctLagunaPrevisionalDetalle flpd 
        INNER JOIN DMGestion.DimPersona dp ON dp.id = flpd.idPersona 
        WHERE nroMesesLaguna IS NOT NULL
        GROUP BY dp.rut;
    
        UPDATE #UniversoRegistroTMP
        SET nroPromedioMesesLaguna = promedio
        FROM #UniversoRegistroTMP un  
            LEFT OUTER JOIN #promedio b ON un.rut = b.rut;
    
    
        UPDATE #UniversoRegistroTMP
        SET indMantieneLagunaVigente = CASE WHEN b.rut IS NOT NULL THEN cstSi ELSE cstNo END
        FROM #UniversoRegistroTMP un  
            LEFT OUTER JOIN (SELECT DISTINCT rut
                            FROM Certificacion.FctLagunaPrevisionalDetalle flpd 
                            INNER JOIN DMGestion.DimPersona dp ON dp.id = flpd.idPersona 
                            WHERE indVigenciaUltimaLAguna = cstSi) b ON b.rut = un.rut;
     
        UPDATE #UniversoRegistroTMP
        SET indPensionado = CASE WHEN b.rut IS NOT NULL THEN cstSi ELSE cstNo END
        FROM #UniversoRegistroTMP un  
            LEFT OUTER JOIN (SELECT DISTINCT rut
                            FROM Certificacion.FctLagunaPrevisionalDetalle flpd 
                            INNER JOIN DMGestion.DimPersona dp ON dp.id = flpd.idPersona 
                            WHERE flpd.fechaPension IS NOT NULL) b ON b.rut = un.rut;                
                        
    
    
    
    
        SELECT rut, totalMesesCotizadosCCICO 
        INTO #meseseCotizados 
        FROM DMGestion.FctComportamientoPago fcp
        INNER JOIN DMGestion.DimPersona dp ON dp.id = fcp.idPersona 
        WHERE idPeriodoInformado = linIdPeriodoInformar;
    
        UPDATE #UniversoRegistroTMP
        SET nroTotalMesesSinLaguna = totalMesesCotizadosCCICO
        FROM #UniversoRegistroTMP un  
            LEFT OUTER JOIN #meseseCotizados b ON un.rut = b.rut;
    
    
        SELECT rut,(nroTotalMesesConLaguna+nroTotalMesesSinLaguna)total,nroTotalMesesConLaguna,round(CONVERT(NUMERIC(6,3),nroTotalMesesConLaguna)/CONVERT(NUMERIC(5,2),total),3)*100 promedio
        INTO #promLaguna
        FROM #UniversoRegistroTMP
        WHERE nroTotalMesesConLaguna IS NOT NULL;
    
        UPDATE #UniversoRegistroTMP
        SET porcMesesConLaguna = promedio
        FROM #UniversoRegistroTMP un  
            LEFT OUTER JOIN #promLaguna b ON un.rut = b.rut;
    
        
        
        
        INSERT INTO Certificacion.FctLagunaPrevisional 
            (idPeriodoInformado,
            idPersona,
            nroTotalLagunasPrevisionales,
            nroTotalMesesConLaguna,
            nroTotalMesesSinLaguna,
            nroPromedioMesesLaguna,
            porcMesesConLaguna,
            nroTotaTerminoRelacionLaboral,
            nrototalAbonosCCIAV,
            indPensionado,
            indMantieneLagunaVigente)
        SELECT  idPeriodoInformado
            , idPersona,
            nroTotalLagunasPrevisionales,
            nroTotalMesesConLaguna,
            nroTotalMesesSinLaguna,
            nroPromedioMesesLaguna,
            porcMesesConLaguna,--porcentaje de meses sobre el total de meses cotizados
            nroTotaTerminoRelacionLaboral,
            nrototalAbonosCCIAV,
            indPensionado,
            indMantieneLagunaVigente 
        FROM #UniversoRegistroTMP a;
                
                
        COMMIT;
        SAVEPOINT;
    
        ------------------------------------------------
        --Datos de Auditoria
        ------------------------------------------------
        --Se registra datos de auditoria
        SELECT COUNT(*) 
        INTO lbiCantidadRegistrosInformados
        FROM #UniversoRegistroTMP;
    
        CALL Certificacion.registrarAuditoriaDatamartsPorFecha(ldtFechaPeriodoInformado,
                                                           ltiCodigoTipoProceso,
                                                           cstNombreProcedimiento, 
                                                           cstNombreTablaFct, 
                                                           ldtFechaInicioCarga, 
                                                           lbiCantidadRegistrosInformados, 
                                                           NULL);

        
    
    END IF;


--Manejo de errores
EXCEPTION
    WHEN OTHERS THEN
        SET lstCodigoError = SQLSTATE;
        SET codigoError = lstCodigoError;
        ROLLBACK;
        CALL Certificacion.registrarErrorProceso(cstNombreProcedimiento, lstCodigoError);
END