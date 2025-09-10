create PROCEDURE DMGestion.cargarUniversoMovimientosCotizacionTMP(IN periodoProceso DATE, OUT codigoError VARCHAR(10))
BEGIN
    /**
        - Nombre archivo                            : cargarUniversoMovimientosCotizacionTMP.sql
        - Nombre del módulo                         : Modelo de Cuentas
        - Fecha de  creación                        : 10-03-2014
        - Nombre del autor                          : Cristian Zavaleta V.
        - Descripción corta del módulo              : Procedimiento que carga el universo de movimientos cotizados
                                                      en la tb_mae_movimiento y tb_cmh para los productos CCICO y CCIAV
        - Lista de procedimientos contenidos        :
        - Documentos asociados a la creación        : 
        - Fecha de modificación                     : 
        - Nombre de la persona que lo modificó      :
        - Cambios realizados                        : 
        - Documentos asociados a la modificación    : 
    **/
    -------------------------------------------------------------------------------------------
    --Declaración de Variables
    -------------------------------------------------------------------------------------------
    -- Variable para capturar el codigo de error
    DECLARE lstCodigoError                  VARCHAR(10);    --variable local de tipo varchar
    -- Variables Locales
    DECLARE lstValorParametro               VARCHAR(100);   --variable local de tipo varchar
    DECLARE ldtMaximaFechaVigencia          DATE;           --variable local de tipo date
    DECLARE ldtFechaPeriodoInformado        DATE;           --variable local de tipo date
    DECLARE ldtUltimaFechaMesInformar       DATE;           --variable local de tipo date
    DECLARE linIdPeriodoInformar            INTEGER;
    DECLARE ldtFechaPeriodoCotizacion       DATE;
    DECLARE ltiExisteTabla                  TINYINT;

    -- Constantes
    DECLARE cstNombreTabla                  VARCHAR(150);   --constante de tipo varchar
    DECLARE cstNombreProcedimiento          VARCHAR(150);   --constante de tipo varchar
    DECLARE cstCodigoErrorCero              VARCHAR(10);
    DECLARE cstClaveMaximaFechaVigencia     VARCHAR(30);
    DECLARE ctiExiste                       TINYINT;
    DECLARE cchSi                           CHAR(2);
    DECLARE cchNo                           CHAR(2);
    DECLARE cinUno                          INTEGER;
    DECLARE cchUno                          CHAR(2);
    DECLARE cinCcico1101                    INTEGER; 
    DECLARE cinCcico1104                    INTEGER; 
    DECLARE cinCcico1105                    INTEGER; 
    DECLARE cinCicco                        INTEGER; 
    DECLARE cinCciav                        INTEGER;
    DECLARE cinCero                         INTEGER;
    DECLARE cbiMontoCero                    BIGINT;
    DECLARE ctiCodigoClasifPersonaCliente   TINYINT;
    DECLARE cnuPorcentaCalculoRemuneracionImp       NUMERIC(5,2);
    DECLARE cstClavePorcCalculoRemuImp              VARCHAR(100);
    DECLARE cnu100Porciento                         NUMERIC(5,2);

    -------------------------------------------------------------------------------------------
    --Seteo de Constantes
    -------------------------------------------------------------------------------------------
    SET cstNombreTabla                  = 'UniversoMovimientosCotizacionTMP';
    SET cstNombreProcedimiento          = 'cargarUniversoMovimientosCotizacionTMP';
    SET cstClaveMaximaFechaVigencia     = 'MAXIMA_FECHA_VIGENCIA';
    SET cstCodigoErrorCero              = '0';
    SET ctiExiste                       = 1;
    SET cchSi                           = 'Si';
    SET cchNo                           = 'No';
    SET cchUno                          = '01';
    SET cinUno                          = 1;
    SET cinCcico1101                    = 1101;
    SET cinCcico1104                    = 1104;
    SET cinCcico1105                    = 1105;
    SET cinCicco                        = 1;
    SET cinCciav                        = 6;
    SET cinCero                         = 0;
    SET cbiMontoCero                    = 0;
    SET ctiCodigoClasifPersonaCliente   = 4;
    SET cnu100Porciento                 = 100.0;
    SET cstClavePorcCalculoRemuImp      = 'PORC_CALCULO_REMUNERACION_IMPONIBLE_CCICO_CCIAV';
    SET ldtFechaPeriodoInformado        = periodoProceso;

    -------------------------------------------------------------------------------------------
    --Seteo de Variables
    -------------------------------------------------------------------------------------------
    --se obtiene el parametro MAXIMA_FECHA_VIGENCIA de la tabla Parametros
    SELECT CONVERT(DATE, DMGestion.obtenerParametro(cstClaveMaximaFechaVigencia), 103)
    INTO ldtMaximaFechaVigencia 
    FROM DUMMY;

    --Se obtiene el porcentaje para calcular la remuneración imponible
    SELECT (CONVERT(NUMERIC(5, 2), DMGestion.obtenerParametro(cstClavePorcCalculoRemuImp)) / cnu100Porciento)
    INTO cnuPorcentaCalculoRemuneracionImp
    FROM DUMMY;

    --se obtiene la ultimo día del periodo a informar
    SELECT DMGestion.obtenerUltimaFechaMes(ldtFechaPeriodoInformado) 
    INTO ldtUltimaFechaMesInformar
    FROM DUMMY;
    
    --Obtencion de Datos del Periodo Informado
    SELECT DMGestion.obtenerIdDimPeriodoInformarPorFecha(ldtFechaPeriodoInformado)
    INTO linIdPeriodoInformar 
    FROM DUMMY;

    --Se obtiene el periodo de cotización 12 mese de inicio
    SELECT CONVERT(DATE, DATEADD(mm, -cinUno, ldtFechaPeriodoInformado)) 
    INTO ldtFechaPeriodoCotizacion
    FROM DUMMY;
    
    -------------------------------------------------------------------------------------------
    --Cuerpo
    -------------------------------------------------------------------------------------------
    SELECT DMGestion.existeTabla(cstNombreTabla)
    INTO ltiExisteTabla
    FROM DUMMY;

    IF (ltiExisteTabla = ctiExiste) THEN
        DROP TABLE DMGestion.UniversoMovimientosCotizacionTMP;
    END IF;

    CREATE TABLE DMGestion.UniversoMovimientosCotizacionTMP (
        id_mae_persona              BIGINT  NULL,
        codigoTipoProducto          INTEGER NULL,
        monto_pesos                 BIGINT  NULL,
        per_cot                     DATE    NULL,
        fec_movimiento              DATE    NULL,
        fec_acreditacion            DATE    NULL,
        renta_imponible             BIGINT  NULL,
        rentaImponibleCalculada     BIGINT  NULL,
        fec_afiliacion              DATE    NULL,
        periodoAfiliacionSistema    DATE    NULL,
        rut_pagador                 BIGINT  NULL,
        codigoSubGrupoMovimiento    INTEGER NULL,
        rutPersona                  INTEGER NULL,
        mesesPermanencia            BIGINT  NULL,
        codigoActEconomicaEmpleador BIGINT  NULL,
        indCotizanteMes             CHAR(2) NULL DEFAULT 'No',
        indUltPerCotProdHist        CHAR(2) NULL DEFAULT 'No',
        indUltFecMovProdHist        CHAR(2) NULL DEFAULT 'No', --Esto se identifica desde el último percot por producto
        indUltFecAcrProdHist        CHAR(2) NULL DEFAULT 'No', --Esto se identifica desde el último fecha Movimiento por producto
        indUltPerCotHist            CHAR(2) NULL DEFAULT 'No', --Esto se identifica desde el último fecha acreditación por producto
        indUltPerCotCotizanteMes    CHAR(2) NULL DEFAULT 'No' 
    );
     
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_01 ON DMGestion.UniversoMovimientosCotizacionTMP( id_mae_persona );
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_02 ON DMGestion.UniversoMovimientosCotizacionTMP( codigoTipoProducto );
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_03 ON DMGestion.UniversoMovimientosCotizacionTMP( monto_pesos );
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_04 ON DMGestion.UniversoMovimientosCotizacionTMP( renta_imponible );
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_05 ON DMGestion.UniversoMovimientosCotizacionTMP( rut_pagador );
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_06 ON DMGestion.UniversoMovimientosCotizacionTMP( codigoSubGrupoMovimiento );
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_07 ON DMGestion.UniversoMovimientosCotizacionTMP( rutPersona );
    CREATE DATE INDEX DATE_UniversoMovimientosCotizacionTMP_08 ON DMGestion.UniversoMovimientosCotizacionTMP( per_cot );
    CREATE DATE INDEX DATE_UniversoMovimientosCotizacionTMP_09 ON DMGestion.UniversoMovimientosCotizacionTMP( fec_movimiento );
    CREATE DATE INDEX DATE_UniversoMovimientosCotizacionTMP_10 ON DMGestion.UniversoMovimientosCotizacionTMP( fec_acreditacion );
    CREATE DATE INDEX DATE_UniversoMovimientosCotizacionTMP_11 ON DMGestion.UniversoMovimientosCotizacionTMP( periodoAfiliacionSistema );
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_12 ON DMGestion.UniversoMovimientosCotizacionTMP( indCotizanteMes );
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_13 ON DMGestion.UniversoMovimientosCotizacionTMP( id_mae_persona, codigoTipoProducto );
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_14 ON DMGestion.UniversoMovimientosCotizacionTMP( id_mae_persona, per_cot);
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_15 ON DMGestion.UniversoMovimientosCotizacionTMP( id_mae_persona, codigoTipoProducto,  per_cot);
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_16 ON DMGestion.UniversoMovimientosCotizacionTMP( id_mae_persona, per_cot, fec_movimiento);
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_17 ON DMGestion.UniversoMovimientosCotizacionTMP( id_mae_persona, codigoTipoProducto,  per_cot, fec_movimiento);
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_18 ON DMGestion.UniversoMovimientosCotizacionTMP( indUltPerCotProdHist );
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_19 ON DMGestion.UniversoMovimientosCotizacionTMP( indUltFecMovProdHist );
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_20 ON DMGestion.UniversoMovimientosCotizacionTMP( indUltFecAcrProdHist );
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_21 ON DMGestion.UniversoMovimientosCotizacionTMP( indUltPerCotHist );
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_22 ON DMGestion.UniversoMovimientosCotizacionTMP( indUltPerCotCotizanteMes );
    CREATE HG INDEX HG_UniversoMovimientosCotizacionTMP_23 ON DMGestion.UniversoMovimientosCotizacionTMP( id_mae_persona, codigoTipoProducto, per_cot, fec_movimiento, fec_acreditacion);

    --Obtener Universo de la FctInformación Afiliado Cliente
    SELECT b.idPersona,
        a.idPersonaOrigen,
        a.rut,
        (DATEDIFF(mm, b.fechaIncorporacionAFP, ldtFechaPeriodoInformado) + cinUno) mesesPermanencia
    INTO #PersonaTMP
    FROM DMGestion.FctlsInformacionAfiliadoCliente b
        INNER JOIN DMGestion.DimPersona a ON (a.id = b.idPersona)
        INNER JOIN DMGestion.DimTipoControl c ON (c.id = b.idTipoControl)
        INNER JOIN DMGestion.DimSubClasificacionPersona dscp ON (b.idSubClasificacionPersona = dscp.id)
        INNER JOIN DMGestion.DimClasificacionPersona dcp ON (dscp.idClasificacionPersona = dcp.id)
    WHERE dcp.codigo <> ctiCodigoClasifPersonaCliente --Cliente   
    AND b.idPeriodoInformado = linIdPeriodoInformar;

    -----------------------------------------
    --Universo Movimientos CCICO y CCIAV
    -----------------------------------------
    INSERT INTO DMGestion.UniversoMovimientosCotizacionTMP(id_mae_persona,
        codigoTipoProducto, 
        monto_pesos,
        per_cot,
        fec_movimiento,
        fec_acreditacion,
        renta_imponible,
        rentaImponibleCalculada,
        fec_afiliacion,
        rut_pagador,
        codigoSubGrupoMovimiento,
        rutPersona,
        mesesPermanencia,
        codigoActEconomicaEmpleador,
        periodoAfiliacionSistema,
        indCotizanteMes)
    SELECT b.id_mae_persona,
        b.codigoTipoProducto, 
        ISNULL(b.monto_pesos, cbiMontoCero) monto_pesos,
        b.per_cot,
        b.fec_movimiento,
        b.fec_acreditacion,
        renta_imponible rentaImponibeDirecta,--renta imponible de la tb_mae_movimiento
        (CASE
            WHEN CONVERT(BIGINT, ROUND((ISNULL(b.renta_imponible, cinCero) * cnuPorcentaCalculoRemuneracionImp), 0)) = ISNULL(b.monto_pesos, cbiMontoCero) THEN
                ISNULL(b.renta_imponible, cinCero)
            ELSE
                CONVERT(BIGINT, ROUND((ISNULL(b.monto_pesos, cbiMontoCero) / cnuPorcentaCalculoRemuneracionImp), 0))
         END) AS renta_imponible, --Renta calculada en base a la cotizacion
        b.fec_afiliacion,
        ISNULL(b.rut_pagador, cinCero) rut_pagador,
        b.codigoSubGrupoMovimiento,
        a.rut rutPersona,
        a.mesesPermanencia,
        ISNULL(b.cod_act_economica, cinCero) AS codigoActEconomicaEmpleador,
        (CASE
            WHEN b.fec_afiliacion IS NOT NULL THEN 
                DATE(DATEFORMAT(b.fec_afiliacion, 'YYYYMM') || cchUno) 
         END) AS periodoAfiliacionSistema,
        --Se marca el cotizante mes
        (CASE
            WHEN ((b.fec_acreditacion BETWEEN ldtFechaPeriodoInformado AND ldtUltimaFechaMesInformar)
                 AND b.per_cot IN (ldtFechaPeriodoCotizacion, ldtFechaPeriodoInformado)
                 AND b.codTrafil02 NOT IN (11138,11140,81130,81132)) THEN --no considerar movimientos de trafil 02 de AFC
                cchSi
            ELSE
                cchNo
         END) AS indCotizanteMes
    FROM DDS.VectorCotizaciones b
        INNER JOIN #PersonaTMP a ON (a.idPersonaOrigen = b.id_mae_persona)
    WHERE b.codigoTipoProducto IN (cinCicco, cinCciav) --productos CCICO y CCIAV
    AND b.fec_acreditacion <= ldtUltimaFechaMesInformar
    AND b.per_cot <= ldtFechaPeriodoInformado --El tope del per_cot es menor o igual a la fecha del periodo informado
    AND b.codigoSubGrupoMovimiento IN (cinCcico1101, 
                                       cinCcico1104, 
                                       cinCcico1105);
    -----------------------------------
    --Cotizaciones del Mes del Proceso
    -----------------------------------
    --Se obtiene el maximo periodo de cotización por id_mae_persona
    /*SELECT id_mae_persona, 
        MAX(per_cot) per_cot
    INTO #MaximiPerCotCotizanteMesTMP
    FROM Certificacion.UniversoMovimientosCotizacionTMP
    WHERE monto_pesos > cinCero
    AND indCotizanteMes = cchSi
    GROUP BY id_mae_persona;

    UPDATE Certificacion.UniversoMovimientosCotizacionTMP SET
        a.indUltPerCotCotizanteMes = cchSi
    FROM Certificacion.UniversoMovimientosCotizacionTMP a
        JOIN #MaximiPerCotCotizanteMesTMP b ON (a.id_mae_persona = b.id_mae_persona
        AND a.per_cot = b.per_cot)
    WHERE a.indCotizanteMes = cchSi;*/ --INESP-92

    SELECT id_mae_persona,per_cot,codigoTipoProducto --> INESP-92
    INTO #MaximiPerCotCotizanteMesTMP 
    FROM (   
    SELECT id_mae_persona,codigoTipoProducto,per_cot, dense_rank() over (partition by id_mae_persona order by codigoTipoProducto,per_cot)ranking
   FROM DMGestion.UniversoMovimientosCotizacionTMP
    WHERE indCotizanteMes = cchSi)RNK
    where rnk.ranking  = cinUno ;


    UPDATE DMGestion.UniversoMovimientosCotizacionTMP SET
        a.indUltPerCotCotizanteMes = cchSi
    FROM DMGestion.UniversoMovimientosCotizacionTMP a
        JOIN #MaximiPerCotCotizanteMesTMP b ON (a.id_mae_persona = b.id_mae_persona
        AND a.per_cot = b.per_cot
        AND a.codigoTipoProducto = b.codigoTipoProducto)
    WHERE a.indCotizanteMes = cchSi;


    -----------------------------------
    --Cotizaciones Historicas
    -----------------------------------
    --Se obtiene el máximo per_cot por producto
    SELECT id_mae_persona, 
        codigoTipoProducto, 
        MAX(per_cot) per_cot
    INTO #MaximoPerCotPorProductoTMP
    FROM DMGestion.UniversoMovimientosCotizacionTMP
    GROUP BY id_mae_persona, codigoTipoProducto;

    UPDATE DMGestion.UniversoMovimientosCotizacionTMP SET
        a.indUltPerCotProdHist = cchSi
    FROM DMGestion.UniversoMovimientosCotizacionTMP a
        JOIN #MaximoPerCotPorProductoTMP b ON (a.id_mae_persona = b.id_mae_persona
        AND a.codigoTipoProducto = b.codigoTipoProducto
        AND a.per_cot = b.per_cot);

    --Se obtiene la maxima fecha de movimiento por Producto
    SELECT u.id_mae_persona,
        u.codigoTipoProducto,
        MAX(u.fec_movimiento) fec_movimiento,
        MAX(u.per_cot) per_cot
    INTO #MaximoFechaMovimientoPorProductoTMP
    FROM DMGestion.UniversoMovimientosCotizacionTMP u
    WHERE u.indUltPerCotProdHist = cchSi
    GROUP BY u.id_mae_persona, u.codigoTipoProducto;

    UPDATE DMGestion.UniversoMovimientosCotizacionTMP SET
        a.indUltFecMovProdHist = cchSi
    FROM DMGestion.UniversoMovimientosCotizacionTMP a
        JOIN #MaximoFechaMovimientoPorProductoTMP b ON (a.id_mae_persona = b.id_mae_persona
        AND a.codigoTipoProducto = b.codigoTipoProducto
        AND a.per_cot = b.per_cot
        AND a.fec_movimiento = b.fec_movimiento);

    --se obtiene la maxima fecha de acreditación por producto
    SELECT u.id_mae_persona,
        u.codigoTipoProducto,
        MAX(u.fec_movimiento) fec_movimiento,
        MAX(u.per_cot) per_cot,
        MAX(u.fec_acreditacion) fec_acreditacion
    INTO #MaximaFechaAcreditacionPorProductoTMP
    FROM DMGestion.UniversoMovimientosCotizacionTMP u
    WHERE u.indUltFecMovProdHist = cchSi 
    GROUP BY u.id_mae_persona, u.codigoTipoProducto;

    UPDATE DMGestion.UniversoMovimientosCotizacionTMP SET
        a.indUltFecAcrProdHist = cchSi
    FROM DMGestion.UniversoMovimientosCotizacionTMP a
        JOIN #MaximaFechaAcreditacionPorProductoTMP b ON (a.id_mae_persona = b.id_mae_persona
        AND a.codigoTipoProducto = b.codigoTipoProducto
        AND a.per_cot = b.per_cot
        AND a.fec_movimiento = b.fec_movimiento
        AND a.fec_acreditacion = b.fec_acreditacion);

    --Se obtiene el maximo percot de los movimientos acreditados.
    SELECT id_mae_persona, 
        MAX(per_cot) per_cot
    INTO #MaximoPerCotHistTMP
    FROM DMGestion.UniversoMovimientosCotizacionTMP
    WHERE indUltFecAcrProdHist = cchSi
    GROUP BY id_mae_persona;

    UPDATE DMGestion.UniversoMovimientosCotizacionTMP SET
        a.indUltPerCotHist = cchSi
    FROM DMGestion.UniversoMovimientosCotizacionTMP a
        JOIN #MaximoPerCotHistTMP b ON (a.id_mae_persona = b.id_mae_persona
        AND a.per_cot = b.per_cot)
    WHERE indUltFecAcrProdHist = cchSi;

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
        CALL DMGestion.registrarErrorProceso(cstNombreProcedimiento, lstCodigoError);
END