ALTER  PROCEDURE dchavez.cargarUniversoPeriodoCotizadosTMP(OUT codigoError VARCHAR(10))
BEGIN
    /**
        - Nombre archivo                            : cargarUniversoMovimiento.sql
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
    **/
    --variable para capturar el codigo de error
    DECLARE lstCodigoError              VARCHAR(10);    --variable local de tipo varchar
    --variables
    DECLARE ldtFechaPeriodoInformado    DATE;           --variable local de tipo date
    DECLARE linIdPeriodoInformar        TINYINT;        --variable local de tipo integer
    DECLARE lchTipoRegistro             CHAR(1);        --variable local de tipo char
    --Variables auditoria
    DECLARE ldtFechaInicioCarga         DATETIME;       --variable local de tipo datetime
    --Constantes
    DECLARE cstNombreProcedimiento      VARCHAR(150);   --constante de tipo varchar
    DECLARE cstNombreTabla              VARCHAR(150);   --constante de tipo varchar
    DECLARE cstCodigoErrorCero          VARCHAR(10);    --constante de tipo varchar
    
    -------------------------------------------------------------------------------------------
    --Seteo de constantes
    SET cstNombreProcedimiento = 'cargarUniversoMovimiento';
    SET cstNombreTabla = 'periodoCotizados';

    --se obtiene la fecha y hora de carga
    SET ldtFechaInicioCarga = getDate();

    SET cstCodigoErrorCero      = '0';

    --obtiene la fecha del periodo a informar
    SELECT DMGestion.obtenerFechaPeriodoInformar() 
    INTO ldtFechaPeriodoInformado 
    FROM DUMMY;

    --obtiene el id del periodo a informar
    SELECT DMGestion.obtenerIdDimPeriodoInformar()
    INTO linIdPeriodoInformar 
    FROM DUMMY;

    --se obtiene el parametro TIPO_REGISTRO_DETALLE de la tabla Parametros
    SELECT CONVERT(CHAR(1), DMGestion.obtenerParametro('TIPO_REGISTRO_DETALLE'))
    INTO lchTipoRegistro 
    FROM DUMMY;

    IF (EXISTS (SELECT 1 FROM SYSCATALOG WHERE tname = 'UniversoPeriodoCotizadosTMP' AND creator = 'dchavez')) THEN
            DROP TABLE dchavez.UniversoPeriodoCotizadosTMP;
    END IF;

    CREATE TABLE dchavez.UniversoPeriodoCotizadosTMP (
    rut bigint NOT NULL,
    fechaPension date NULL,
    codigoPension char(2) NULL,
    fechaAfiliacionSistema date NOT NULL,
    ClasificacionPersona varchar(50) NOT NULL,
    periodo date NOT NULL,
    per_cot date NULL
    );
    CREATE HG INDEX HG_UniversoPeriodoCotizadosTMP_01 ON dchavez.UniversoPeriodoCotizadosTMP (rut);
    CREATE DATE INDEX DATE_UniversoPeriodoCotizadosTMP_01 ON dchavez.UniversoPeriodoCotizadosTMP (periodo);
    CREATE DATE INDEX DATE_UniversoPeriodoCotizadosTMP_02 ON dchavez.UniversoPeriodoCotizadosTMP (per_cot);

    SELECT DISTINCT fiac.idPeriodoInformado,fiac.idPersona, dp.rut,fiac.fechaAfiliacionSistema,dcp.nombre  ClasificacionPersona
        ,convert(date,null)fechaPension,convert(char(2),NULL)codigoPension
    INTO #Universo
    FROM DMGestion.FctlsInformacionAfiliadoCliente fiac 
        INNER JOIN DMGestion.DimPersona dp ON dp.id = fiac.idPersona 
        INNER JOIN DMGestion.DimPeriodoInformado dpi ON dpi.id = fiac.idPeriodoInformado
        INNER JOIN DMGestion.DimSubClasificacionPersona dscp ON dscp.id = fiac.idSubClasificacionPersona 
        INNER JOIN DMGestion.DimClasificacionPersona dcp ON dcp.id = dscp.idClasificacionPersona 
    WHERE idPeriodoInformado = 170
        AND ClasificacionPersona IN ('Afiliado','Pensionado')
        AND dp.fechaDefuncion IS NULL;
    
     MESSAGE 'universo' TO client;
    
 
    SELECT DISTINCT b.rut,b.fechaSolicitud,dtp.codigo codigoPension
    INTO #invalidez
    FROM DMGestion.FctPensionadoInvalidezVejez fpiv 
        INNER JOIN DMGestion.DimTipoPension dtp ON dtp.id = fpiv.idTipoPension 
    INNER JOIN  (SELECT DISTINCT a.rut,a.idPersona,a.idPeriodoInformado, min(fpiv.fechaSolicitud) fechaSolicitud
                FROM  #Universo a
                INNER JOIN DMGestion.FctPensionadoInvalidezVejez fpiv ON fpiv.idPeriodoInformado = a.idPeriodoInformado
                    AND fpiv.idPersona = a.idPersona
                INNER JOIN DMGestion.DimTipoPension dtp ON dtp.id = fpiv.idTipoPension AND dtp.codigo NOT IN ('01','02')--vejez
                WHERE ClasificacionPersona ='Pensionado'
                GROUP BY  a.rut,a.idPersona,a.idPeriodoInformado)b ON b.idPersona = fpiv.idPersona 
                            AND b.idPeriodoInformado = fpiv.idPeriodoInformado 
                            AND b.fechaSolicitud = fpiv.fechaSolicitud;

     MESSAGE 'invalidez' TO client;               
                        
    SELECT a.rut, min(fpiv.fechaSolicitud) fechaSolicitud,dtp.codigo codigoPension
    INTO  #vejez
    FROM  #Universo a
    LEFT OUTER JOIN DMGestion.FctPensionadoInvalidezVejez fpiv ON fpiv.idPeriodoInformado = a.idPeriodoInformado
        AND fpiv.idPersona = a.idPersona
    INNER JOIN DMGestion.DimTipoPension dtp ON dtp.id = fpiv.idTipoPension AND dtp.codigo IN ('01','02')--VE y VA
    WHERE ClasificacionPersona ='Pensionado'
    AND a.rut NOT  IN (SELECT rut  FROM #invalidez WHERE codigoPension <> '18')--distinto de inv. transitorio
    GROUP BY  a.rut,dtp.codigo;

    MESSAGE 'vejez' TO client;

    --ELIMINAN LAS INV. TRANSITORIAS QUE TIENEN UNA VEJEZ POSTERIOR 
    DELETE FROM #INVALIDEZ
    WHERE RUT IN (SELECT RUT FROM #VEJEZ);

    --ACTUALIZA FECHA Y CODIGO DE PENSION
    UPDATE #universo
    SET fechaPension = b.fechaSolicitud
    ,codigoPension = b.codigoPension
    FROM #universo a
    INNER JOIN #vejez b ON a.rut = b.rut;

    UPDATE #universo
    SET fechaPension = b.fechaSolicitud
    ,codigoPension =  b.codigoPension
    FROM #universo a
    INNER JOIN #invalidez b ON a.rut = b.rut;

    MESSAGE 'ACTUALIZA FECHA Y CODIGO DE PENSION' TO client;


    SELECT rut_mae_persona rut, MIN(per_cot)periodo
    INTO #primerPeriodo
    FROM DDS.VectorCotizaciones vc
    WHERE RUT IN (SELECT DISTINCT RUT FROM  #UNIVERSO)
    GROUP BY rut;

    MESSAGE 'antes del insert' TO client;

    INSERT INTO dchavez.UniversoPeriodoCotizadosTMP
    (rut,fechaPension,codigoPension,fechaAfiliacionSistema,ClasificacionPersona,periodo,per_cot)
    WITH cotizacion AS 
        (
            SELECT DISTINCT rut_mae_persona rut, per_cot
            FROM DDS.VectorCotizaciones vc
                INNER JOIN  #universo b ON b.rut = vc.rut_mae_persona
            WHERE  codigoTipoProducto = 1
                AND rut_mae_persona IN (SELECT DISTINCT rut FROM #universo)
        )
    SELECT fec.rut,fechaPension,codigoPension,fec.fechaAfiliacionSistema,fec.ClasificacionPersona,dpi.fecha,tot.per_cot   
    FROM #universo fec
        INNER JOIN #primerPeriodo pp ON pp.rut = fec.rut
        INNER JOIN DMGestion.DimPeriodoInformado dpi ON (dpi.fecha >= CASE WHEN pp.periodo < fec.fechaAfiliacionSistema THEN pp.periodo ELSE  fec.fechaAfiliacionSistema END) 
            AND dpi.fecha <= (CASE WHEN (ClasificacionPersona = 'Pensionado' AND codigoPension <> '18') THEN fec.fechaPension ELSE '20240801' END)--ldtFechaPeriodoInformado
        LEFT OUTER JOIN cotizacion TOT ON tot.per_cot = dpi.fecha AND tot.rut=fec.rut;
    
    COMMIT;
    SAVEPOINT;
    SET codigoError = cstCodigoErrorCero;
    
   
--Manejo de errores
/*EXCEPTION
    WHEN OTHERS THEN
        SET lstCodigoError = SQLSTATE;
        SET codigoError = lstCodigoError;
        ROLLBACK;
        CALL DMGestion.registrarErrorProceso(cstNombreProcedimiento, lstCodigoError);*/
END