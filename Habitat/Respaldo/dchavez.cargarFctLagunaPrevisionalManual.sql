create PROCEDURE dchavez.cargarFctLagunaPrevisionalManual(IN periodoInformar date,OUT codigoError VARCHAR(10))
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
    ----------------------------------------------------------------------------------------
    DECLARE cstOwner                                    VARCHAR(150);
    DECLARE cstNombreProcedimiento                      VARCHAR(150);   --constante de tipo varchar
    DECLARE cstNombreTablaFct                           VARCHAR(150);   --constante de tipo varchar
    DECLARE ldtFechaUltimoDiaMes                        DATE;           --variable local de tipo date
    DECLARE ldtFechaPeriodoInformado                    DATE;           --variable local de tipo date
    --Variables auditoria
    DECLARE ldtFechaInicioCarga                         DATETIME;       --variable local de tipo datetime
    
        -------------------------------------------------------------------------------------------
    --Seteo Variable auditoria
    -------------------------------------------------------------------------------------------
    --se obtiene la fecha y hora de carga
    SET ldtFechaInicioCarga                     = getDate();
    
    -------------------------------------------------------------------------------------------
    --Seteo de Constantes
    -------------------------------------------------------------------------------------------
    SET cstOwner                                = 'dchavez';
    SET cstNombreProcedimiento                  = 'cargarFctLagunaPrevisionalDetalleManual';
    SET cstNombreTablaFct                       = 'FctLagunaPrevisionalDetalle';
    
        --se obtiene el parametro MAXIMA_FECHA_VIGENCIA de la tabla Parametros
    SELECT CONVERT(DATE, DMGestion.obtenerParametro('MAXIMA_FECHA_VIGENCIA'), 103) 
    INTO ldtMaximaFechaVigencia 
    FROM DUMMY;

    --Fecha del periodo a informar
    SET ldtFechaPeriodoInformado  = periodoInformar;


    --Obtener el ultimo dia del mes
    SELECT DMGestion.obtenerUltimaFechaMes(ldtFechaPeriodoInformado) 
    INTO ldtFechaUltimoDiaMes 
    FROM DUMMY;

    --ID del periodo a informar
    SELECT id
    INTO linIdPeriodoInformar 
    FROM DMGestion.DimPeriodoInformado
    WHERE fecha = ldtFechaPeriodoInformado;
    
    
    DELETE FROM dchavez.FctLagunaPrevisional WHERE idPeriodoInformado = linIdPeriodoInformar;


    

    CREATE TABLE #universoFinal (
        periodoInformado date,
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
    

    INSERT INTO  #universoFinal
    (periodoInformado,rut,nroTotaTerminoRelacionLaboral,nroTotalLagunasPrevisionales,nroTotalMesesConLaguna,nrototalAbonosCCIAV )
    SELECT ldtFechaPeriodoInformado,rut,sum(CASE WHEN indTerminoRelacionLaboral= 'Si' THEN 1 ELSE 0 end) totaTerminoRelacionLaboral,max(nroLaguna)totalLagunasPrevisionales
        , sum(flpd.nroMesesLaguna)totalMesesLaguna, SUM(flpd.nroMesesAbonoCCIAV)totalCotiCCIAV
    FROM dchavez.FctLagunaPrevisionalDetalle flpd 
        INNER JOIN DMGestion.DimPersona dp ON dp.id = flpd.idPersona 
    GROUP BY rut;


    SELECT dp.rut, round(avg(nroMesesLaguna),1)promedio 
    INTO #promedio
    FROM dchavez.FctLagunaPrevisionalDetalle flpd 
    INNER JOIN DMGestion.DimPersona dp ON dp.id = flpd.idPersona 
    WHERE nroMesesLaguna IS NOT NULL
    GROUP BY dp.rut;

    UPDATE #universoFinal
    SET nroPromedioMesesLaguna = promedio
    FROM #universoFinal un  
        LEFT OUTER JOIN #promedio b ON un.rut = b.rut;


    UPDATE #universoFinal
    SET indMantieneLagunaVigente = CASE WHEN b.rut IS NOT NULL THEN 'Si' ELSE 'No' END
    FROM #universoFinal un  
        LEFT OUTER JOIN (SELECT DISTINCT rut
                        FROM dchavez.FctLagunaPrevisionalDetalle flpd 
                        INNER JOIN DMGestion.DimPersona dp ON dp.id = flpd.idPersona 
                        WHERE indVigenciaUltimaLAguna = 'Si') b ON b.rut = un.rut;
 
    UPDATE #universoFinal
    SET indPensionado = CASE WHEN b.rut IS NOT NULL THEN 'Si' ELSE 'No' END
    FROM #universoFinal un  
        LEFT OUTER JOIN (SELECT DISTINCT rut
                        FROM dchavez.FctLagunaPrevisionalDetalle flpd 
                        INNER JOIN DMGestion.DimPersona dp ON dp.id = flpd.idPersona 
                        WHERE flpd.fechaPension IS NOT NULL) b ON b.rut = un.rut;                
                    




    SELECT rut, totalMesesCotizadosCCICO 
    INTO #meseseCotizados 
    FROM DMGestion.FctComportamientoPago fcp
    INNER JOIN DMGestion.DimPersona dp ON dp.id = fcp.idPersona 
    WHERE idPeriodoInformado = 170;

    UPDATE #universoFinal
    SET nroTotalMesesSinLaguna = totalMesesCotizadosCCICO
    FROM #universoFinal un  
        LEFT OUTER JOIN #meseseCotizados b ON un.rut = b.rut;


    SELECT rut,(nroTotalMesesConLaguna+nroTotalMesesSinLaguna)total,nroTotalMesesConLaguna,round(CONVERT(NUMERIC(6,3),nroTotalMesesConLaguna)/CONVERT(NUMERIC(5,2),total),3)*100promedio
    INTO #promLaguna
    FROM #universoFinal
    WHERE nroTotalMesesConLaguna IS NOT NULL;

    UPDATE #universoFinal
    SET porcMesesConLaguna = promedio
    FROM #universoFinal un  
        LEFT OUTER JOIN #promLaguna b ON un.rut = b.rut;

    
    
    
    INSERT INTO dchavez.FctLagunaPrevisional 
        (idPeriodoInformado,
        idPersona,
        nroTotalLagunasPrevisionale,
        nroTotalMesesConLaguna,
        nroTotalMesesSinLaguna,
        nroPromedioMesesLaguna,
        porcMesesConLaguna,
        nroTotaTerminoRelacionLaboral,
        nrototalAbonosCCIAV,
        indPensionado,
        indMantieneLagunaVigente)
    SELECT   dpi.id idPeriodoInformado
        , dp.id idPersona,
        nroTotalLagunasPrevisionales,
        nroTotalMesesConLaguna,
        nroTotalMesesSinLaguna,
        nroPromedioMesesLaguna,
        porcMesesConLaguna,--porcentaje de meses sobre el total de meses cotizados
        nroTotaTerminoRelacionLaboral,
        nrototalAbonosCCIAV,
        indPensionado,
        indMantieneLagunaVigente 
    INTO dchavez.FctLagunaPrevisional
    FROM #universoFinal a
            INNER JOIN DMGestion.Dimpersona dp ON dp.rut = a.rut
                AND dp.fechaVigencia >= '21991231'
            INNER JOIN DMGestion.DimPeriodoInformado dpi ON
                dpi.fecha = a.periodoInformado;
            
            
    COMMIT;
    SAVEPOINT;


--Manejo de errores
/*EXCEPTION
    WHEN OTHERS THEN
        SET lstCodigoError = SQLSTATE;
        SET codigoError = lstCodigoError;
        ROLLBACK;
        CALL DMGestion.registrarErrorProceso(cstNombreProcedimiento, lstCodigoError);
        */
END