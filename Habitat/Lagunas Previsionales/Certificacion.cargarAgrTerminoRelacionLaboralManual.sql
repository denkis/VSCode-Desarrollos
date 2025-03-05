ALTER  PROCEDURE Certificacion.cargarAgrTerminoRelacionLaboralManual(IN fechaProceso DATE, OUT codigoError VARCHAR(10))
BEGIN
     /*-----------------------------------------------------------------------------------------
    - Nombre archivo                            : cargarAgrTerminoRelacionLaboral.sql
    - Nombre del módulo                         : Termino de realación laboral
    - Fecha de  creación                        : 2025-02-01
    - Nombre del autor                          : Denis Chávez
    - Descripción corta del módulo              : Procedimiento que carga la tabla de agregación de termino de relaciones laborales
    - Lista de procedimientos contenidos        : 
    - Documentos asociados a la creación        : 
    - Fecha de modificación                     : 
    - Nombre de la persona que lo modificó      : 
    - Cambios realizados                        : 
    - Documentos asociados a la modificación    : 
    -------------------------------------------------------------------------------------------*/

    -------------------------------------------------------------------------------------------
    --Declaración de Variables
    -------------------------------------------------------------------------------------------
    -- Variable para capturar el codigo de error
    DECLARE lstCodigoError                  VARCHAR(10);    --variable local de tipo varchar
    DECLARE cstCodigoErrorCero              VARCHAR(10);
    DECLARE cstOwner                        VARCHAR(150);
    --Variables auditoria
    DECLARE ldtFechaInicioCarga             DATETIME;
    DECLARE lbiCantidadRegistros            BIGINT;
    DECLARE ldtMaximaFechaVigencia          DATE;   --variable local de tipo date
    DECLARE ctiCodigoTipoProcesoMensual     TINYINT;
    DECLARE ltiCodigoTipoProceso                        TINYINT;
    
    -- Constantes 
    DECLARE cstNombreProcedimiento          VARCHAR(150);   --constante de tipo varchar
    DECLARE cstNombreTabla                  VARCHAR(150);   --constante de tipo varchar
    DECLARE cchPrimerDia                    CHAR(2);
    DECLARE ldtFechaDesde                   DATE;
    DECLARE ldtFechaHasta                   DATE;
    DECLARE ldtPeriodoInformar              DATE;
    DECLARE linIdPeriodoInformar            INTEGER;
    DECLARE ctiCero                         INTEGER;
    DECLARE ctiDos                          INTEGER;
    


    -------------------------------------------------------------------------------------------
    --Seteo Variable auditoria
    -------------------------------------------------------------------------------------------
    --se obtiene la fecha y hora de carga
    SET ldtFechaInicioCarga             = getDate();

    SET ldtPeriodoInformar = fechaProceso;
   

    -------------------------------------------------------------------------------------------
    --Seteo de Constantes
    -------------------------------------------------------------------------------------------
    SET cstOwner                                = 'Certificacion';
    SET cstNombreProcedimiento                  = 'cargarAgrTerminoRelacionLaboral';
    SET cstNombreTabla                          = 'AgrTerminoRelacionLaboral';
    SET cstCodigoErrorCero                      = '0';
    SET ctiCero                                 = 0;
    SET ctiDos                                  = 2;
    SET ctiCodigoTipoProcesoMensual             = 1;
    SET ltiCodigoTipoProceso                    = ctiCodigoTipoProcesoMensual; 
  

    -------------------------------------------------------------------------------------------
    --Cuerpo
    -------------------------------------------------------------------------------------------
    

    --Se obtiene el identificador de la fecha del periodo Informar
    SELECT DMGestion.obtenerIdDimPeriodoInformarPorFecha(ldtPeriodoInformar)
    INTO linIdPeriodoInformar
    FROM DUMMY;

    --se obtiene el parametro MAXIMA_FECHA_VIGENCIA de la tabla Parametros
    SELECT CONVERT(DATE, DMGestion.obtenerParametro('MAXIMA_FECHA_VIGENCIA'), 103) 
    INTO ldtMaximaFechaVigencia 
    FROM DUMMY;

    SET ldtFechaHasta = DMGestion.obtenerUltimaFechaMes(ldtPeriodoInformar);

    --Elimina registros de la Agr
    DELETE FROM DMGestion.AgrTerminoRelacionLaboral
    WHERE periodoInformado = ldtPeriodoInformar;   

    

        --Se crea tabla temporal para el universo de alertas
        CREATE TABLE #UniversoTerminoRelLaboral (
            periodoInformado        date,
            rutAfiliado             BIGINT,
            rutEmpleador            BIGINT,
            fecTerminoRelLaboral    DATE,
            clasificacionPersona    VARCHAR(50) NULL
        );
    
    
    
            SELECT DISTINCT tmp.RUT_MAE_PERSONA rutAfiliado, tpp.rut rutEmpleador, FEC_HASTA  fechaTerminoRL 
                INTO #terminoRL
            FROM dds.TB_PLANILLA_MOVIPER TM
                INNER JOIN dds.TB_DET_PLANILLA tdp ON TM.ID_DET_PLANILLA = tdp.ID_DET_PLANILLA
                INNER JOIN dds.TB_MAE_PERSONA  tmp ON tmp.ID_MAE_PERSONA = tdp.ID_MAE_PERSONA 
                LEFT OUTER JOIN DDS.TB_PERSONA_PLANILLA tpp ON tpp.ID_MAE_PLANILLA = tdp.ID_MAE_PLANILLA AND  TPP.IND_TIPO = ctiCero
            WHERE tm.ID_TIP_MOVIPER = ctiDos
                AND TM.ID_DET_PLANILLA IS NOT NULL
                AND ISNULL(FEC_HASTA,ldtMaximaFechaVigencia) BETWEEN ldtPeriodoInformar AND ldtFechaHasta
                AND isnull(tpp.rut,ctiCero) > ctiCero;
        
            SELECT DISTINCT  vmp.rut rutAfiliado, vme.rut rutEmpleador,pr.FEC_FIN fechaTerminoRL,pr.FEC_MOVIMIENTO,pr.AUD_FEC_CREAC  INTO  #terminoRL2
            FROM DDS.TB_MAE_MOVIPERS pr
                INNER JOIN dmgestion.VistaMaestroPersona vmp ON vmp.identificador = pr.ID_MAE_PERSONA 
                INNER JOIN dmgestion.VistaMaestroPersona vme ON vme.identificador = pr.ID_MAE_PERSONA_EMP  
            WHERE ID_TIP_MOVIPER = ctiDos
                AND FEC_FIN BETWEEN ldtPeriodoInformar AND ldtFechaHasta
                AND isnull(rutEmpleador,ctiCero) > ctiCero;
        
    
    
    
        SELECT DISTINCT rutAfiliado,rutEmpleador,fechaTerminoRL  
            INTO #terminoRelLaboral
        FROM 
            (SELECT rutAfiliado,rutEmpleador,fechaTerminoRL FROM #terminoRL
            UNION 
            SELECT rutAfiliado,rutEmpleador,fechaTerminoRL FROM #terminoRL2)UNI;
        

        
        SELECT trl.rutAfiliado, dcp.nombre ClasificacionPersona 
            INTO #clasificacionPersona
        FROM DMGestion.FctlsInformacionAfiliadoCliente fiac 
            INNER JOIN DMGestion.DimPersona dp ON dp.id = fiac.idPersona
            INNER JOIN DMGestion.DimPeriodoInformado dpi ON dpi.id = fiac.idPeriodoInformado  
            INNER JOIN DMGestion.DimSubClasificacionPersona dscp ON dscp.id = fiac.idSubClasificacionPersona
            INNER JOIN DMGestion.DimClasificacionPersona dcp ON dcp.id = dscp.idClasificacionPersona
            INNER JOIN #terminoRelLaboral trl ON trl.rutAfiliado = dp.rut 
        WHERE dpi.id = linIdPeriodoInformar;
        

    
        INSERT INTO #UniversoTerminoRelLaboral
        (periodoInformado,rutAfiliado,rutEmpleador,fecTerminoRelLaboral, clasificacionPersona )
        SELECT ldtPeriodoInformar,trl.rutAfiliado, rutEmpleador, fechaTerminoRL,ClasificacionPersona
        FROM #terminoRelLaboral trl
            LEFT OUTER JOIN #clasificacionPersona cp ON trl.rutAfiliado = cp.rutAfiliado;
        
    
        INSERT INTO Certificacion.AgrTerminoRelacionLaboral
            (periodoInformado, rutAfiliado, rutEmpleador, fecTerminoRelLaboral, clasificacionPersona)
            SELECT periodoInformado, rutAfiliado, rutEmpleador, fecTerminoRelLaboral, clasificacionPersona
        FROM #UniversoTerminoRelLaboral;
    
        ------------------------------------------------
        --Datos de Auditoria
        ------------------------------------------------
        --Se registra datos de auditoria
        SELECT COUNT(*)
        INTO lbiCantidadRegistros
        FROM #UniversoTerminoRelLaboral;
    
        CALL Certificacion.registrarAuditoriaDatamartsPorFecha(ldtFechaPeriodoInformado,
                                                                ltiCodigoTipoProceso,
                                                                cstNombreProcedimiento, 
                                                                cstNombreTablaFct, 
                                                                ldtFechaInicioCarga, 
                                                                lbiCantidadRegistrosInformados, 
                                                                NULL);
    
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