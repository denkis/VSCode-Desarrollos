create PROCEDURE DMGestion."cargarFctComportamientoPagoManual"(IN periodoProceso DATE, OUT codigoError VARCHAR(10))
BEGIN
    /*-----------------------------------------------------------------------------------------
    - Nombre archivo                            : DMGestion.cargarFctComportamientoPagoManual.sql
    - Nombre del módulo                         : Cuentas
    - Fecha de  creación                        : 2010
    - Nombre del autor                          : Denis Chavez
    - Descripción corta del módulo              : [Descripción]
    - Documentos asociados a la creación        : [Documento Creación]
    - Fecha de modificación                     : 29-08-2019
    - Nombre de la persona que lo modificó      : Denis Chavez - 
    - Cambios realizados                        : INESP-609
    - Documentos asociados a la modificación    : Documento Análisis y Diseño Métricas Faltantes.doc
    -------------------------------------------------------------------------------------------*/
    --
    -------------------------------------------------------------------------------------------
    --Declaración de Variables
    -------------------------------------------------------------------------------------------
    -- Variable para capturar el codigo de error
    DECLARE lstCodigoError                              VARCHAR(10); --variable local de tipo varchar
    -- Variables auditoria
    DECLARE ldtFechaInicioCarga                         DATETIME;       --variable local de tipo datetime
    DECLARE lbiCantidadRegistrosInformados              BIGINT;         --variable local de tipo bigint
    -- Variables Locales
    DECLARE linIdPeriodoInformar                        INTEGER;        --variable local de tipo Integer
    DECLARE ldtFechaPeriodoInformado                    DATE;           --variable local de tipo DATE
    DECLARE ldtFechaPeriodoCotizacion                   DATE;           --variable local de tipo DATE
    DECLARE ldtFechaPeriodoCotizacionInicio12Meses      DATE;           --variable local de tipo DATE
    DECLARE ldtFechaPeriodoCotizacionInicio3Meses       DATE;           --variable local de tipo DATE
    DECLARE ldtFechaPeriodoCotizacionInicio6Meses       DATE;           --variable local de tipo DATE
    DECLARE ldtFechaPeriodoCotizacionPenultimoPeriodo   DATE;           --variable local de tipo DATE    
    DECLARE ldtUltimaFechaMesInformar                   DATE;           --variable local de tipo DATE
    DECLARE ltiExisteTabla                              TINYINT;
    DECLARE ltiCodigoTipoProceso                        TINYINT;
    DECLARE lnuValorTopeImponibleUF                     NUMERIC(5, 2);
    DECLARE ldtFechaPeriodoRentaPPP                     DATE;
    -- Constantes   
    DECLARE cstOwner                                    VARCHAR(150);
    DECLARE cstNombreProcedimiento                      VARCHAR(150);   --constante de tipo varchar
    DECLARE cstNombreTablaFct                           VARCHAR(150);   --constante de tipo varchar
    DECLARE cstCodigoErrorCero                          VARCHAR(10);    --constante de tipo varchar
    DECLARE cdtMaximaFechaVigencia                      DATE;           --constante de tipo date
    DECLARE cchCodigoSinClasificar                      CHAR(1);        --constante de tipo char
    DECLARE cstClaveMaximaFechaVigencia                 VARCHAR(150);   --constante de tipo varchar
    DECLARE cchError1301                                CHAR(4);        --constante de tipo varchar
    DECLARE cchTipoErrorInconsistencia                  CHAR(1);        --constante de tipo varchar
    DECLARE cinCero                                     INTEGER; 
    DECLARE cinDos                                      INTEGER; 
    DECLARE cinTres                                     INTEGER; 
    DECLARE cinCuatro                                   INTEGER; 
    DECLARE cinSeis                                     INTEGER; 
    DECLARE cinDoce                                     INTEGER; 
    DECLARE cinCicco                                    INTEGER; 
    DECLARE cinCciav                                    INTEGER; 
    DECLARE cinCcico1101                                INTEGER; 
    DECLARE cinCcico1104                                INTEGER; 
    DECLARE cinCcico1105                                INTEGER; 
    DECLARE cchS                                        CHAR(1);        --constante de tipo varchar
    DECLARE cchN                                        CHAR(1);        --constante de tipo varchar
    DECLARE cstControlVAL                               CHAR(5);
    DECLARE cstControlPRV                               CHAR(5);
    DECLARE cstControlAVP                               CHAR(5);
    DECLARE cstControlAVV                               CHAR(5);
    DECLARE cdtFechaInicio                              DATE;           --constante de tipo date
    DECLARE cch00                                       CHAR(3);        --constante de tipo varchar
    DECLARE cinUno                                      INTEGER;
    DECLARE cchUno                                      CHAR(2);
    DECLARE cchCodigoTipoCotDependiente                 CHAR(2);
    DECLARE cchCodigoTipoCotIndependiente               CHAR(2);
    DECLARE cchCodigoTipoCotVoluntario                  CHAR(2);
    DECLARE cchCodigoTipoCotDepenIndep                  CHAR(2);
    DECLARE cnuTres                                     NUMERIC(2, 1);
    DECLARE cnuSeis                                     NUMERIC(2, 1);
    DECLARE cnuDoce                                     NUMERIC(3, 1);
    DECLARE ctiCien                                     TINYINT;
    DECLARE ctiExiste                                   TINYINT;
    DECLARE cstNombreTablaEliminar                      VARCHAR(25);
    DECLARE cchSi                                       CHAR(2);
    DECLARE cchNo                                       CHAR(2);
    DECLARE ctiCodigoClasifPersonaCliente               TINYINT;
    DECLARE ctiCodigoTipoProcesoDiario                  TINYINT;
    DECLARE ctiCodigoTipoProcesoMensual                 TINYINT;
    DECLARE cinMenos1                                   INTEGER;
    
    -------------------------------------------------------------------------------------------
    --Seteo Variable auditoria
    -------------------------------------------------------------------------------------------
    --se obtiene la fecha y hora de carga
    SET ldtFechaInicioCarga             = getDate();

    -------------------------------------------------------------------------------------------
    --Seteo de Constantes
    -------------------------------------------------------------------------------------------
    SET cstOwner                                    = 'DMGestion';
    SET cstNombreProcedimiento                      = 'cargarFctComportamientoPago';
    SET cstNombreTablaFct                           = 'FctComportamientoPago';
    SET cstCodigoErrorCero                          = '0';
    SET cchCodigoSinClasificar                      = '0';
    SET cstClaveMaximaFechaVigencia                 = 'MAXIMA_FECHA_VIGENCIA';
    SET cinCero                                     = 0;
    SET cinCicco                                    = 1;
    SET cinCciav                                    = 6;
    SET cchS                                        = 'S';
    SET cchN                                        = 'N';
    SET cinCuatro                                   = 4;
    SET cinCcico1101                                = 1101;
    SET cinCcico1104                                = 1104;
    SET cinCcico1105                                = 1105;
    SET cstControlVAL                               = 'VAL';
    SET cstControlPRV                               = 'PRV';
    SET cstControlAVP                               = 'AVP';
    SET cstControlAVV                               = 'AVV';
    SET cdtFechaInicio                              = DATE('1900-01-01');
    SET cchTipoErrorInconsistencia                  = 'I';
    SET cchError1301                                = '1301';
    SET cch00                                       = '00';
    SET cinUno                                      = 1;
    SET cinDos                                      = 2;
    SET cinTres                                     = 3;
    SET cinSeis                                     = 6;
    SET cinDoce                                     = 12;
    SET cchUno                                      = '01';
    SET cchCodigoTipoCotDependiente                 = '01';
    SET cchCodigoTipoCotIndependiente               = '02';
    SET cchCodigoTipoCotVoluntario                  = '04';
    SET cchCodigoTipoCotDepenIndep                  = '03';
    SET cnuTres                                     = 3.0;
    SET cnuSeis                                     = 6.0;
    SET cnuDoce                                     = 12.0;
    SET ctiCien                                     = 100;
    SET ctiExiste                                   = 1;
    SET cstNombreTablaEliminar                      = 'UniversoMovimientosTMP';
    SET cchSi                                       = 'Si';
    SET cchNo                                       = 'No';
    SET ctiCodigoClasifPersonaCliente               = 4;
    SET ctiCodigoTipoProcesoDiario                  = 3;
    SET ctiCodigoTipoProcesoMensual                 = 1;
    SET cinMenos1                                   = -1;
    SET cdtMaximaFechaVigencia                      = CONVERT(DATE, DMGestion.obtenerParametro(cstClaveMaximaFechaVigencia), 103);

    -------------------------------------------------------------------------------------------
    --Seteo de Variables
    -------------------------------------------------------------------------------------------
    SET ldtFechaPeriodoInformado                    = periodoProceso;
    SET linIdPeriodoInformar                        = DMGestion.obtenerIdDimPeriodoInformarPorFecha(ldtFechaPeriodoInformado);
    SET ltiCodigoTipoProceso                        = ctiCodigoTipoProcesoMensual; 
    SET ldtUltimaFechaMesInformar                   = DMGestion.obtenerUltimaFechaMes(ldtFechaPeriodoInformado);
    SET ldtFechaPeriodoCotizacion                   = CONVERT(DATE, DATEADD(mm, -cinUno, ldtFechaPeriodoInformado));
    SET ldtFechaPeriodoCotizacionPenultimoPeriodo   = CONVERT(DATE, DATEADD(mm, -cinDos, ldtFechaPeriodoInformado));  
    SET ldtFechaPeriodoCotizacionInicio3Meses       = CONVERT(DATE, DATEADD(mm, -cinTres, ldtFechaPeriodoInformado));
    SET ldtFechaPeriodoCotizacionInicio6Meses       = CONVERT(DATE, DATEADD(mm, -cinSeis, ldtFechaPeriodoInformado));
    SET ldtFechaPeriodoCotizacionInicio12Meses      = CONVERT(DATE, DATEADD(mm, -cinDoce, ldtFechaPeriodoInformado));
    SET ldtFechaPeriodoRentaPPP                     = DATE(DATEADD(mm, cinMenos1, ldtFechaPeriodoInformado));
    
    SELECT valor
    INTO lnuValorTopeImponibleUF
    FROM DMGestion.vistaTopeImponible
    WHERE ldtFechaPeriodoCotizacion BETWEEN fechaInicioRango AND fechaTerminoRango;

    -------------------------------------------------------------------------------------------
    --Cuerpo
    -------------------------------------------------------------------------------------------
    --Elimina los errores de carga y datos de la fact para el periodo a informar
    CALL DMGestion.eliminarFact(cstNombreProcedimiento, cstNombreTablaFct, linIdPeriodoInformar, codigoError);
    
    CALL DMGestion.cargarUniversoMovimientosCotizacionTMP(ldtFechaPeriodoInformado, codigoError);
    
    --Verifica si se elimino con exito los errores de carga y datos de la fact
    IF (codigoError = cstCodigoErrorCero) THEN    
    
        CREATE TABLE #FctComportamientoPago  (
            idPeriodoInformado              INTEGER         NOT NULL,
            idPersona                       BIGINT          NOT NULL,
            rut                             BIGINT          NULL, 
            idPersonaOrigen                 BIGINT          NULL,
            mesesPermanencia                INTEGER         NULL,
            rentapromedioUF3Meses           NUMERIC(10,2)   NULL,
            totalPeriodos3Meses             INTEGER         NULL,
            densidadCotizacion3Meses        NUMERIC(5,2)    NULL,
            rentapromedioUF6Meses           NUMERIC(15,2)   NULL,
            totalPeriodos6Meses             INTEGER         NULL,
            densidadCotizacion6Meses        NUMERIC(5,2)    NULL,
            rentapromedioUF12Meses          NUMERIC(10,2)   NULL,
            totalPeriodos12Meses            INTEGER         NULL,
            densidadCotizacion12Meses       NUMERIC(5,2)    NULL,
            rentaUFPenultimoPeriodo         NUMERIC(10,2)   NULL,
            rentaUFUltimoPeriodo            NUMERIC(10,2)   NULL,
            rentaPesosUltimoPeriodo         BIGINT          NULL,
            codigoTipoCotizante             VARCHAR(5)      NULL,
            idTipoCotizante                 TINYINT         NULL,
            fechaUltimaAcredCCIAV           DATE            NULL,
            fechaUltimaCotiCCIAV            DATE            NULL,
            ultimoPeriodoCotiCCIAV          DATE            NULL,
            montoCotizacionCCIAV            BIGINT          NULL DEFAULT 0,
            remuneraImpoUltimaCCIAV         BIGINT          NULL DEFAULT 0,
            fechaUltimaAcredCCICO           DATE            NULL,
            ultimoPeriodoCotiCCICO          DATE            NULL,
            fechaUltimaCotiCCICO            DATE            NULL,
            remuneraImpoUltimaCCICO         BIGINT          NULL DEFAULT 0,
            totalMesesCotizadosCCICO        INTEGER         NULL DEFAULT 0,
            totalMesesCotizados             BIGINT          NULL DEFAULT 0,
            numeroFila                      BIGINT          NULL,
            idError                         BIGINT          NULL,
            indTopeImponible                CHAR(1)         NULL DEFAULT 'N',
            indCotizanteMes                 CHAR(2)         NULL,
            idEmpleador                     BIGINT          NULL DEFAULT 0,
            idActividadEconomicaEmpleador   BIGINT          NULL DEFAULT 0,
            remuneraImpoUltimaCCICOSinTope  BIGINT          NULL DEFAULT 0,
            remuneraImpoUltimaCCIAVSinTope  BIGINT          NULL DEFAULT 0,
            rentaPromedioPPPPesosCCICO      BIGINT          NULL,
            rentaPromedioPPPUFCCICO         NUMERIC(12,2)   NULL,
            indUsaCMHCCICO                  CHAR(2)         NULL,
            rentaPromedioPPPPesosCCIAV      BIGINT          NULL,
            rentaPromedioPPPUFCCIAV         NUMERIC(12,2)   NULL,
            indUsaCMHCCIAV                  CHAR(2)         NULL,
            rentaPromedioPPPPesosCCICV      BIGINT          NULL,
            rentaPromedioPPPUFCCICV         NUMERIC(12,2)   NULL,
            indUsaCMHCCICV                  CHAR(2)         NULL,
            rentaPromedioPPPPesosCAPVC      BIGINT          NULL,
            rentaPromedioPPPUFCAPVC         NUMERIC(12,2)   NULL,
            indUsaCMHCAPVC                  CHAR(2)         NULL,
            numeroMesesCotCCICOCCIAV        INTEGER         NULL
        ); 

        --Obtener Universo de la FctInformación Afiliado Cliente
        SELECT
            b.idPersona,
            a.idPersonaOrigen,
            c.codigo cod_control,
            a.rut,
            (DATEDIFF(mm, b.fechaIncorporacionAFP, ldtFechaPeriodoInformado) + cinUno) mesesPermanencia,
            b.idSubClasificacionPersona,
            e.codigo codigoClasificacion
        INTO #PersonaTMP
        FROM DMGestion.FctlsInformacionAfiliadoCliente b  
            INNER JOIN DMGestion.DimPersona a ON (a.id = b.idPersona)
            INNER JOIN DMGestion.DimTipoControl c ON (c.id = b.idTipoControl)
            INNER JOIN DMGestion.DimSubClasificacionPersona d ON (d.id = b.idSubClasificacionPersona)
            INNER JOIN DMGestion.DimClasificacionPersona e ON (e.id = d.idClasificacionPersona)
        WHERE e.codigo <> ctiCodigoClasifPersonaCliente --Cliente
        AND b.idPeriodoInformado = linIdPeriodoInformar;

        SELECT a.idPersona,
            a.rut
        INTO #DimPersonaEmpleadorTMP
        FROM (
            SELECT idPersona,
                rut
            FROM #PersonaTMP
            UNION 
            SELECT a.id AS idPersona,
                a.rut
            FROM DMGestion.DimPersona a
                LEFT JOIN #PersonaTMP b ON (a.rut = b.rut)
            WHERE a.fechaVigencia >= cdtMaximaFechaVigencia
            AND b.rut IS NULL
        ) a;

        --------------------------------
        --Tipo Cotizante Historico
        --------------------------------

        --Se crea tabla temporal con los movimientos de la persona, para el máximo periodo de cotización
        SELECT DISTINCT um.id_mae_persona,
            um.codigoTipoProducto, 
            um.codigoSubGrupoMovimiento,
            um.rut_pagador, 
            um.rutPersona, 
            um.per_cot
        INTO #UniversoMovimientosMaximoPerCotTMP
        FROM DMGestion.UniversoMovimientosCotizacionTMP um 
        WHERE um.indUltPerCotHist = cchSi
        AND um.monto_pesos > cinCero;

        --Se obtiene la cantidad de productos que tiene una persona para el maximo periodo de cotización, solo los que tienes mas de un producto
        SELECT id_mae_persona, 
            COUNT(DISTINCT codigoTipoProducto) cantidadProductos
        INTO #CantidadProductosTMP
        FROM #UniversoMovimientosMaximoPerCotTMP
        GROUP BY id_mae_persona
        HAVING cantidadProductos > cinUno;

        --Si existen varios movimientos para los productos CCICO y CCIAV, con el mismo periodo de cotización, se eliminan los movimientos del producto CCIAV
        DELETE FROM #UniversoMovimientosMaximoPerCotTMP 
        FROM #UniversoMovimientosMaximoPerCotTMP ummpc, #CantidadProductosTMP cp
        WHERE ummpc.id_mae_persona = cp.id_mae_persona
        AND ummpc.codigoTipoProducto = cinCciav; --Producto CCIAV

       --Se obtiene la cantidad de registros que tiene una persona, para el máximo periodo de cotización
        SELECT id_mae_persona, 
            COUNT(*) cantidad
        INTO #CantidadRegistrosTMP
        FROM #UniversoMovimientosMaximoPerCotTMP
        GROUP BY id_mae_persona;

        --Se determina el tipo de cotizante para los movimientos que tengan un solo registro
        SELECT a.id_mae_persona,
            a.codigoTipoProducto,
            (CASE
                WHEN (a.codigoSubGrupoMovimiento IN (cinCcico1101, cinCcico1104, cinCcico1105)
                      AND (a.codigoTipoProducto = cinCicco))
                THEN
                    (CASE
                        WHEN (a.rut_pagador != a.rutPersona) THEN 
                            cchCodigoTipoCotDependiente --Dependiente
                        ELSE cchCodigoTipoCotIndependiente --Independiente
                     END
                    )
                WHEN (a.codigoSubGrupoMovimiento IN (cinCcico1101, cinCcico1105) 
                      AND (a.codigoTipoProducto = cinCciav)) THEN 
                    cchCodigoTipoCotVoluntario --Voluntario
             END) codigoTipoCotizante
        INTO #UniversoTipoCotizanteTMP
        FROM #UniversoMovimientosMaximoPerCotTMP a
            INNER JOIN #CantidadRegistrosTMP cr ON (a.id_mae_persona = cr.id_mae_persona)
        WHERE cr.cantidad = cinUno;

        --Se determina el tipo de cotizante para los movimientos que tengan varios registros
        --Se crea un universo temporal para los movimientos que tengan varios registros
        SELECT a.id_mae_persona, 
            a.rutPersona,
            a.rut_pagador, 
            a.codigoTipoProducto, 
            a.per_cot, 
            a.codigoSubGrupoMovimiento
        INTO #UniversoTemp1
        FROM #UniversoMovimientosMaximoPerCotTMP a
            INNER JOIN #CantidadRegistrosTMP cr ON (a.id_mae_persona = cr.id_mae_persona)
        WHERE cr.cantidad > cinUno;

        --Se obtiene el tipo cotizante (voluntario) que cumplan con alguno de estos codigo de movimiento  (239, 240, 247) y que no existan registros con los siguiente codigo de movimiento 
        --(2, 3, 4, 11, 14, 15, 17, 19, 49) registrando en la tabla temporal #UniversoTipoCotizanteTMP
        INSERT INTO #UniversoTipoCotizanteTMP(id_mae_persona, 
            codigoTipoProducto, 
            codigoTipoCotizante)
        SELECT DISTINCT a.id_mae_persona,
            a.codigoTipoProducto,
            cchCodigoTipoCotVoluntario codigoTipoCotizante --Voluntario
        FROM #UniversoTemp1 a
        WHERE a.id_mae_persona NOT IN (SELECT DISTINCT b.id_mae_persona 
                                       FROM #UniversoTemp1 b 
                                       WHERE b.codigoSubGrupoMovimiento IN (cinCcico1101, cinCcico1104, cinCcico1105)
                                       AND (b.codigoTipoProducto = cinCicco)
                                      )
        AND a.codigoSubGrupoMovimiento IN (cinCcico1101, cinCcico1105)
        AND a.codigoTipoProducto = cinCciav;

        --Se obtiene la cantidad de registros para el grupo de movimiento 10, 11 y 13, agrupados por el id_mae_persona
        SELECT id_mae_persona, 
            count(*) cantidadRegistros
        INTO #UniversoTemp2
        FROM #UniversoTemp1
        WHERE codigoSubGrupoMovimiento IN (cinCcico1101, cinCcico1104, cinCcico1105)
        AND codigoTipoProducto = cinCicco
        GROUP BY id_mae_persona;

        --Se obtiene la cantidad de registros para el grupo de movimiento 10, 11 y 13, y que el rut de la persona sea igual al rut del pagador, agrupados por el id_mae_persona
        SELECT id_mae_persona, 
            count(*) cantidadRegistrosRutIguales
        INTO #UniversoTemp3
        FROM #UniversoTemp1
        WHERE codigoSubGrupoMovimiento IN (cinCcico1101, cinCcico1104, cinCcico1105)
        AND codigoTipoProducto = cinCicco
        AND rutPersona = rut_pagador
        GROUP BY id_mae_persona;

        --Se obtiene el tipo cotizante (01: 'Dependiente', 02:'Independiente', 03:'Dependiente e Independiente')
        INSERT INTO #UniversoTipoCotizanteTMP(id_mae_persona, 
            codigoTipoProducto, 
            codigoTipoCotizante)
        SELECT DISTINCT a.id_mae_persona, 
            a.codigoTipoProducto,
            (CASE 
                WHEN (b.cantidadRegistros = ISNULL(c.cantidadRegistrosRutIguales, cinCero)) THEN 
                    cchCodigoTipoCotIndependiente
                WHEN (ISNULL(c.cantidadRegistrosRutIguales, cinCero) = cinCero) THEN 
                    cchCodigoTipoCotDependiente
                ELSE cchCodigoTipoCotDepenIndep
             END
            ) codigoTipoCotizante
        FROM #UniversoTemp1 a 
            INNER JOIN #UniversoTemp2 b ON (a.id_mae_persona = b.id_mae_persona)
            LEFT OUTER JOIN #UniversoTemp3 c ON (b.id_mae_persona = c.id_mae_persona);

        --Se elmimina tablas temporales
        DROP TABLE #UniversoTemp1;
        DROP TABLE #UniversoTemp2;
        DROP TABLE #UniversoTemp3;

        /*************************************Codigo de Estado**Giovani Chavez  CGI 25-03-2014(+)***************************************/
        --Se crea tabla temporal con los movimientos de la persona, para el máximo periodo de cotización
        SELECT DISTINCT um.id_mae_persona,
            um.codigoTipoProducto, 
            um.codigoSubGrupoMovimiento,
            um.rut_pagador, 
            um.rutPersona, 
            um.per_cot
        INTO #UniversoMovimientosMaximoPerCotTMP_MES
        FROM DMGestion.UniversoMovimientosCotizacionTMP um 
        WHERE um.indUltPerCotCotizanteMes = cchSi
        AND um.monto_pesos > cinCero;

        --Se obtiene la cantidad de productos que tiene una persona para el maximo periodo de cotización, solo los que tienes mas de un producto
        SELECT id_mae_persona, 
            COUNT(DISTINCT codigoTipoProducto) cantidadProductos
        INTO #CantidadProductosTMP_MES
        FROM #UniversoMovimientosMaximoPerCotTMP_MES
        GROUP BY id_mae_persona
        HAVING cantidadProductos > cinUno;

        --Si existen varios movimientos para los productos CCICO y CCIAV, con el mismo periodo de cotización, se eliminan los movimientos del producto CCIAV
        DELETE FROM #UniversoMovimientosMaximoPerCotTMP_MES 
        FROM #UniversoMovimientosMaximoPerCotTMP_MES ummpc, #CantidadProductosTMP_MES cp
        WHERE ummpc.id_mae_persona = cp.id_mae_persona
        AND ummpc.codigoTipoProducto = cinCciav; --Producto CCIAV

       --Se obtiene la cantidad de registros que tiene una persona, para el máximo periodo de cotización
        SELECT id_mae_persona, 
            COUNT(*) cantidad
        INTO #CantidadRegistrosTMP_MES
        FROM #UniversoMovimientosMaximoPerCotTMP_MES
        GROUP BY id_mae_persona;

        --Se determina el tipo de cotizante para los movimientos que tengan un solo registro
        SELECT 
            a.id_mae_persona,
            a.codigoTipoProducto,
            (CASE
                WHEN (a.codigoSubGrupoMovimiento IN (cinCcico1101, cinCcico1104, cinCcico1105)
                      AND (a.codigoTipoProducto = cinCicco))
                THEN
                    (CASE
                        WHEN (a.rut_pagador != a.rutPersona) THEN 
                            cchCodigoTipoCotDependiente --Dependiente
                        ELSE cchCodigoTipoCotIndependiente --Independiente
                     END
                    )
                WHEN (a.codigoSubGrupoMovimiento IN (cinCcico1101, cinCcico1105) 
                      AND (a.codigoTipoProducto = cinCciav)) THEN 
                    cchCodigoTipoCotVoluntario --Voluntario
             END
            ) codigoTipoCotizante
        INTO #UniversoTipoCotizanteTMP_MES
        FROM #UniversoMovimientosMaximoPerCotTMP_MES a
            INNER JOIN #CantidadRegistrosTMP_MES cr ON (a.id_mae_persona = cr.id_mae_persona)
        WHERE cr.cantidad = cinUno;

        --Se determina el tipo de cotizante para los movimientos que tengan varios registros
        --Se crea un universo temporal para los movimientos que tengan varios registros
        SELECT 
            a.id_mae_persona, 
            a.rutPersona,
            a.rut_pagador, 
            a.codigoTipoProducto, 
            a.per_cot, 
            a.codigoSubGrupoMovimiento
        INTO #UniversoTemp1_MES
        FROM #UniversoMovimientosMaximoPerCotTMP_MES a
            INNER JOIN #CantidadRegistrosTMP_MES cr ON (a.id_mae_persona = cr.id_mae_persona)
        WHERE cr.cantidad > cinUno;

        --Se obtiene el tipo cotizante (voluntario) que cumplan con alguno de estos codigo de movimiento  (239, 240, 247) y que no existan registros con los siguiente codigo de movimiento 
        --(2, 3, 4, 11, 14, 15, 17, 19, 49) registrando en la tabla temporal #UniversoTipoCotizanteTMP
        INSERT INTO #UniversoTipoCotizanteTMP_MES(id_mae_persona, 
            codigoTipoProducto, 
            codigoTipoCotizante)
        SELECT DISTINCT a.id_mae_persona,
            a.codigoTipoProducto,
            cchCodigoTipoCotVoluntario codigoTipoCotizante --Voluntario
        FROM #UniversoTemp1_MES a
        WHERE a.id_mae_persona NOT IN (SELECT DISTINCT b.id_mae_persona 
                                       FROM #UniversoTemp1_MES b 
                                       WHERE b.codigoSubGrupoMovimiento IN (cinCcico1101, cinCcico1104, cinCcico1105)
                                       AND (b.codigoTipoProducto = cinCicco)
                                      )
        AND a.codigoSubGrupoMovimiento IN (cinCcico1101, cinCcico1105)
        AND a.codigoTipoProducto = cinCciav;

        --Se obtiene la cantidad de registros para el grupo de movimiento 10, 11 y 13, agrupados por el id_mae_persona
        SELECT id_mae_persona, 
            count(*) cantidadRegistros
        INTO #UniversoTemp2_MES
        FROM #UniversoTemp1_MES
        WHERE codigoSubGrupoMovimiento IN (cinCcico1101, cinCcico1104, cinCcico1105)
        AND codigoTipoProducto = cinCicco
        GROUP BY id_mae_persona;

        --Se obtiene la cantidad de registros para el grupo de movimiento 10, 11 y 13, y que el rut de la persona sea igual al rut del pagador, agrupados por el id_mae_persona
        SELECT id_mae_persona, 
            count(*) cantidadRegistrosRutIguales
        INTO #UniversoTemp3_MES
        FROM #UniversoTemp1_MES
        WHERE codigoSubGrupoMovimiento IN (cinCcico1101, cinCcico1104, cinCcico1105)
        AND codigoTipoProducto = cinCicco
        AND rutPersona = rut_pagador
        GROUP BY id_mae_persona;

        --Se obtiene el tipo cotizante (01: 'Dependiente', 02:'Independiente', 03:'Dependiente e Independiente')
        INSERT INTO #UniversoTipoCotizanteTMP_MES(id_mae_persona, 
            codigoTipoProducto, 
            codigoTipoCotizante)
        SELECT DISTINCT a.id_mae_persona, 
            a.codigoTipoProducto,
            (CASE 
                WHEN (b.cantidadRegistros = ISNULL(c.cantidadRegistrosRutIguales, cinCero)) THEN 
                    cchCodigoTipoCotIndependiente
                WHEN (ISNULL(c.cantidadRegistrosRutIguales, cinCero) = cinCero) THEN 
                    cchCodigoTipoCotDependiente
                ELSE cchCodigoTipoCotDepenIndep
             END
            ) codigoTipoCotizante
        FROM #UniversoTemp1_MES a 
            INNER JOIN #UniversoTemp2_MES b ON (a.id_mae_persona = b.id_mae_persona)
            LEFT OUTER JOIN #UniversoTemp3_MES c ON (b.id_mae_persona = c.id_mae_persona);

        --Se elmimina tablas temporales
        DROP TABLE #UniversoTemp1_MES;
        DROP TABLE #UniversoTemp2_MES;
        DROP TABLE #UniversoTemp3_MES;
        /*************************************Codigo de Estado**Giovani Chavez  CGI 25-03-2014(+)***************************************/

        SELECT DISTINCT id_mae_persona, 
            fec_movimiento ultimaFechaCotizacionCCIAV,  --fechaUltimaAcredCCIAV  (1)
            fec_acreditacion fechaUltimaAcredCCIAV,     --fechaUltimaCotiCCIAV   (2)
            per_cot ultimoPeriodoCotiCCIAV              --ultimoPeriodoCotiCCIAV (3)
        INTO #UniversoUltimaFechaCotizacionCCIAVTMP
        FROM DMGestion.UniversoMovimientosCotizacionTMP um 
        WHERE um.indUltFecAcrProdHist = cchSi
        AND um.monto_pesos > cinCero
        AND um.codigoTipoProducto = cinCciav; --Producto CCIAV

        SELECT um.id_mae_persona, 
            um.per_cot, 
            SUM(um.renta_imponible) AS remuneraImpoUltimaCCIAVSinTope,
            SUM(um.monto_pesos)     AS montoCotizacionCCIAV,
            SUM(um.renta_imponible) AS rentaImponibleCCIAV
        INTO #UniversoMontoCotizacionCCIAV
        FROM DMGestion.UniversoMovimientosCotizacionTMP um 
        WHERE um.indUltPerCotProdHist = cchSi
        AND um.codigoTipoProducto = cinCciav --Producto CCIAV
        AND um.indCotizanteMes    = cchSi
        GROUP BY um.id_mae_persona, um.per_cot;

        --Se obtiene la ultimo dia del mes, correspondiente al periodo de cotización y el valor de la UF
        SELECT DISTINCT 
            umccciav.per_cot,
            (DATE(DATEFORMAT(umccciav.per_cot, 'YYYYMM') ||
                  CONVERT(CHAR(2),DATEPART(dd, (DATEADD(ms, -cinTres, DATEADD(mm, DATEDIFF(mm, cdtFechaInicio,umccciav.per_cot) + cinUno, cdtFechaInicio))))))
             ) ultimoDiaMesPerCot,
            vvu.valorUF,
            CONVERT(NUMERIC(5, 2), NULL) valorTopeImponible
        INTO #TopeMontoCotizacionCCIAV
        FROM #UniversoMontoCotizacionCCIAV umccciav
            INNER JOIN DMGestion.VistaValorUF vvu ON (vvu.fechaUF = ultimoDiaMesPerCot)
        WHERE vvu.ultimoDiaMes = cchS;

        --Tabla Temporal de la Vista Tope Imponible
        SELECT fechaInicioRango,
            fechaTerminoRango,
            valor
        INTO #TopeImponibleTMP
        FROM DMGestion.VistaTopeImponible;

        --Se obtiene el valor del tope imponible de acuerdo al periodo de cotización
        UPDATE #TopeMontoCotizacionCCIAV SET 
            tmccciav.valorTopeImponible = ISNULL(ti.valor, cinCero)
        FROM #TopeMontoCotizacionCCIAV tmccciav,#TopeImponibleTMP ti
        WHERE tmccciav.per_cot BETWEEN ti.fechaInicioRango AND ti.fechaTerminoRango;

        --Se topa la Renta Imponible

        UPDATE #UniversoMontoCotizacionCCIAV SET
            umccciav.montoCotizacionCCIAV = (CASE
                                                WHEN (umccciav.montoCotizacionCCIAV > ROUND((valorUF * tmccciav.valorTopeImponible), cinCero)) THEN
                                                    ROUND((tmccciav.valorUF * tmccciav.valorTopeImponible), cinCero)
                                                ELSE
                                                    umccciav.montoCotizacionCCIAV
                                             END),--montoCotizacionCCIAV  (4)
            umccciav.rentaImponibleCCIAV = (CASE
                                                WHEN (umccciav.rentaImponibleCCIAV > ROUND((valorUF * tmccciav.valorTopeImponible), cinCero)) THEN
                                                    ROUND((tmccciav.valorUF * tmccciav.valorTopeImponible), cinCero)
                                                ELSE
                                                    umccciav.rentaImponibleCCIAV
                                            END)--remuneraImpoUltimaCCIAV (5)
        FROM #UniversoMontoCotizacionCCIAV umccciav
            INNER JOIN #TopeMontoCotizacionCCIAV tmccciav ON (umccciav.per_cot = tmccciav.per_cot);

        --Se obtiene la fecha de la última cotización para el producto CCICO
        SELECT DISTINCT id_mae_persona, 
            fec_movimiento ultimaFechaCotizacionCCICO,  --fechaUltimaCotiCCICO(8)
            fec_acreditacion fechaUltimaAcredCCICO,    --fechaUltimaAcredCCICO (6)
            per_cot ultimoPeriodoCotiCCICO            --ultimoPeriodoCotiCCICO (7)
        INTO #UniversoUltimaFechaCotizacionCCICOTMP
        FROM DMGestion.UniversoMovimientosCotizacionTMP um 
        WHERE um.indUltFecAcrProdHist = cchSi
        AND um.monto_pesos > cinCero
        AND codigoTipoProducto = cinCicco; --Producto CCICO

        --Remuneración imponible asociada a la última cotización en la CCICO, en pesos, se crea el universo de remuneraciones imponibles asociada a la última 
        --cotización en la CCICO, en pesos 
        SELECT um.id_mae_persona, 
            um.per_cot, 
            CONVERT(BIGINT, 0)      AS rentaImponibleCCICOConTope,
            SUM(um.renta_imponible) AS rentaImponibleCCICO
        INTO #UniversoRemuneracionImponibleCCICO
        FROM DMGestion.UniversoMovimientosCotizacionTMP um 
        WHERE um.indUltPerCotProdHist = cchSi
        AND um.codigoTipoProducto = cinCicco --Producto CCICO
        GROUP BY um.id_mae_persona, um.per_cot;

        --Se obtiene la ultimo dia del mes, correspondiente al periodo de cotización y el valor de la UF
        SELECT DISTINCT 
            uriccico.per_cot,
            (DATE(DATEFORMAT(uriccico.per_cot, 'YYYYMM') ||
                  CONVERT(CHAR(2),DATEPART(dd,(DATEADD(ms,-cinTres,DATEADD(mm, DATEDIFF(mm,cdtFechaInicio,uriccico.per_cot)+cinUno,cdtFechaInicio))))))
            ) ultimoDiaMesPerCot,
            vvu.valorUF,
            CONVERT(NUMERIC(5, 2), NULL) valorTopeImponible
        INTO #TopeRentaImponibleCCICO
        FROM #UniversoRemuneracionImponibleCCICO uriccico
            INNER JOIN DMGestion.VistaValorUF vvu ON (vvu.fechaUF = ultimoDiaMesPerCot)
        WHERE vvu.ultimoDiaMes = cchS;

        --Se obtiene el valor del tope imponible de acuerdo al periodo de cotización
        UPDATE #TopeRentaImponibleCCICO SET 
            triccico.valorTopeImponible = ISNULL(ti.valor, cinCero)
        FROM #TopeRentaImponibleCCICO triccico,#TopeImponibleTMP ti
        WHERE triccico.per_cot BETWEEN ti.fechaInicioRango AND ti.fechaTerminoRango;       

        --Se topa la Renta Imponible
        UPDATE #UniversoRemuneracionImponibleCCICO SET 
            uriccico.rentaImponibleCCICOConTope = (CASE
                                                    WHEN (uriccico.rentaImponibleCCICO > ROUND((valorUF * triccico.valorTopeImponible), cinCero)) THEN
                                                        ROUND((triccico.valorUF * triccico.valorTopeImponible), cinCero)
                                                    ELSE
                                                        uriccico.rentaImponibleCCICO
                                                   END)
        FROM #UniversoRemuneracionImponibleCCICO uriccico
            JOIN #TopeRentaImponibleCCICO triccico ON (uriccico.per_cot = triccico.per_cot);

        SELECT um.id_mae_persona, 
            COUNT(DISTINCT um.per_cot) numeroMesesCotizadosCCICO  --totalMesesCotizadosCCICO (10)
        INTO #UniversoNumeroMesesCotizadosCCICO
        FROM DMGestion.UniversoMovimientosCotizacionTMP um
        WHERE um.codigoTipoProducto = cinCicco --Producto CCICO
        AND um.per_cot >= um.periodoAfiliacionSistema
        AND um.monto_pesos > cinCero
        GROUP BY um.id_mae_persona;

        --Número total de meses cotizados en la CCICO y CCIAV
        SELECT um.id_mae_persona, 
            COUNT(DISTINCT um.per_cot) numeroMesesCotizados  --totalMesesCotizados (11)
        INTO #UniversoNumeroMesesCotizadosTMP 
        FROM DMGestion.UniversoMovimientosCotizacionTMP um
        WHERE um.codigoTipoProducto IN (cinCicco, cinCciav) --Producto CCICO y CCIAV
        AND um.monto_pesos > cinCero
        GROUP BY um.id_mae_persona;

        INSERT INTO #FctComportamientoPago( 
            idPeriodoInformado,
            idPersona,
            rut,
            idPersonaOrigen,
            mesesPermanencia,
            codigoTipoCotizante,
            indCotizanteMes) 
        SELECT 
            linIdPeriodoInformar,
            idPersona,
            rut,
            idPersonaOrigen,
            mesesPermanencia,
            cch00,
            cchNo
        FROM #PersonaTMP; 

        -------------------------------------
        -- Tipo Cotizante Historico
        -------------------------------------
        UPDATE #FctComportamientoPago SET 
            a.codigoTipoCotizante = up.codigoTipoCotizante
        FROM #FctComportamientoPago a
            JOIN #UniversoTipoCotizanteTMP up ON (up.id_mae_persona = a.idPersonaOrigen);       

        UPDATE #FctComportamientoPago SET 
            a.idTipoCotizante = e.id
        FROM #FctComportamientoPago  a    
            JOIN DMGestion.DimTipoCotizante e ON (a.codigoTipoCotizante = e.codigo)
        WHERE e.fechaVigencia >= cdtMaximaFechaVigencia;               

        -------------------------------------
        -- Tipo Cotizante Mes
        -------------------------------------
        /*************************************Codigo de Estado**Giovani Chavez  CGI 25-03-2014(+)***************************************/
        UPDATE #FctComportamientoPago SET 
            a.codigoTipoCotizante = up.codigoTipoCotizante,
            a.indCotizanteMes = cchSi
        FROM #FctComportamientoPago a
            JOIN #UniversoTipoCotizanteTMP_MES up ON (up.id_mae_persona = a.idPersonaOrigen);       

        UPDATE #FctComportamientoPago SET 
            a.idTipoCotizante = e.id
        FROM #FctComportamientoPago  a    
            JOIN DMGestion.DimTipoCotizante e ON (a.codigoTipoCotizante = e.codigo)
        WHERE e.fechaVigencia >= cdtMaximaFechaVigencia
        AND a.indCotizanteMes = cchSi;               

        /*************************************Codigo de Estado**Giovani Chavez  CGI 25-03-2014(-)***************************************/

        UPDATE #FctComportamientoPago SET 
            a.fechaUltimaAcredCCIAV = c.fechaUltimaAcredCCIAV,
            a.fechaUltimaCotiCCIAV = c.ultimaFechaCotizacionCCIAV,
            a.ultimoPeriodoCotiCCIAV = c.ultimoPeriodoCotiCCIAV
        FROM #FctComportamientoPago a
            JOIN #UniversoUltimaFechaCotizacionCCIAVTMP c ON (c.id_mae_persona = a.idPersonaOrigen);

        UPDATE #FctComportamientoPago SET 
            a.montoCotizacionCCIAV = c.montoCotizacionCCIAV,
            a.remuneraImpoUltimaCCIAV = c.rentaImponibleCCIAV,
            a.remuneraImpoUltimaCCIAVSinTope = c.remuneraImpoUltimaCCIAVSinTope
        FROM #FctComportamientoPago a
            JOIN #UniversoMontoCotizacionCCIAV c ON (c.id_mae_persona = a.idPersonaOrigen);

        UPDATE #FctComportamientoPago SET 
            a.fechaUltimaAcredCCICO = c.fechaUltimaAcredCCICO,
            a.ultimoPeriodoCotiCCICO = c.ultimoPeriodoCotiCCICO,
            a.fechaUltimaCotiCCICO  =  c.ultimaFechaCotizacionCCICO
        FROM #FctComportamientoPago a
            JOIN #UniversoUltimaFechaCotizacionCCICOTMP c ON (c.id_mae_persona = a.idPersonaOrigen);

        UPDATE #FctComportamientoPago SET 
            a.remuneraImpoUltimaCCICO           = c.rentaImponibleCCICOConTope,
            a.remuneraImpoUltimaCCICOSinTope    = c.rentaImponibleCCICO
        FROM #FctComportamientoPago a
            JOIN #UniversoRemuneracionImponibleCCICO c ON (c.id_mae_persona = a.idPersonaOrigen);

        UPDATE #FctComportamientoPago SET 
            a.totalMesesCotizadosCCICO = c.numeroMesesCotizadosCCICO   
        FROM #FctComportamientoPago a
            JOIN #UniversoNumeroMesesCotizadosCCICO c ON (c.id_mae_persona = a.idPersonaOrigen);

       UPDATE #FctComportamientoPago SET 
            a.totalMesesCotizados = c.numeroMesesCotizados  
       FROM #FctComportamientoPago a
           JOIN #UniversoNumeroMesesCotizadosTMP c ON (c.id_mae_persona = a.idPersonaOrigen);
        
        SELECT fmc.rutPersona rut,
            ptmp.mesesPermanencia,
            fmc.per_cot AS periodoDevengRemuneracion,
            SUM(fmc.renta_imponible) as remuneracionImponible 
        INTO #MovimientosTMP 
        FROM DMGestion.UniversoMovimientosCotizacionTMP fmc 
             INNER JOIN #PersonaTMP ptmp ON (fmc.rutPersona = ptmp.rut)
        WHERE ptmp.rut > cinCero 
        AND periodoDevengRemuneracion BETWEEN ldtFechaPeriodoCotizacionInicio12Meses AND ldtFechaPeriodoInformado--ldtFechaPeriodoCotizacion
        AND fmc.codigoTipoProducto = cinCicco  --CCICO
        GROUP BY fmc.rutPersona, fmc.per_cot, ptmp.mesesPermanencia;

        SELECT m.rut,
            m.periodoDevengRemuneracion,
            m.remuneracionImponible,
            m.mesesPermanencia,
            vvu.valorUF,
            ROUND(CONVERT(NUMERIC(17, 4), (m.remuneracionImponible/vvu.valorUF)), cinDos) as remuneracionImponibleUF,
            CONVERT(NUMERIC(10, 2), 0.0) valorTopeUF
        INTO #RentaImponibleTMP 
        FROM #MovimientosTMP as m 
            INNER JOIN DMGestion.VistaValorUF as vvu on(vvu.periodo = m.periodoDevengRemuneracion) 
        WHERE vvu.ultimoDiaMes = cchS;

        UPDATE #RentaImponibleTMP SET
            a.remuneracionImponibleUF = (CASE 
                                            WHEN a.remuneracionImponibleUF > b.valor THEN 
                                                b.valor 
                                            ELSE a.remuneracionImponibleUF 
                                         END),
            a.valorTopeUF = b.valor
        FROM #RentaImponibleTMP a, #TopeImponibleTMP b 
        WHERE periodoDevengRemuneracion BETWEEN fechaInicioRango AND fechaTerminoRango;

        SELECT DISTINCT periodoDevengRemuneracion periodoCotizacion
        INTO #PeriodoUltimaRentaTMP
        FROM #RentaImponibleTMP;

        SELECT periodoCotizacion,
            DMGestion.obtenerUltimaFechaMes(periodoCotizacion) ultimoDiaPeriodo,    
            CONVERT(NUMERIC(12, 2), 0.0) valorUF
        INTO #ValorUFUltimaRentaTMP
        FROM #PeriodoUltimaRentaTMP;
    
        SELECT DISTINCT a.fechaUF,
            a.valorUF
        INTO #VistaValorUFUltimoDiaPeriodoTMP
        FROM #ValorUFUltimaRentaTMP v
            JOIN DMGestion.VistaValorUF a ON (a.fechaUF = v.ultimoDiaPeriodo)
        WHERE a.ultimoDiaMes = cchS;

        UPDATE #ValorUFUltimaRentaTMP SET
            v.valorUF = a.valorUF
        FROM #ValorUFUltimaRentaTMP v
            JOIN #VistaValorUFUltimoDiaPeriodoTMP a ON (a.fechaUF = v.ultimoDiaPeriodo);

        UPDATE #RentaImponibleTMP SET
            a.remuneracionImponible = (CASE
                                           WHEN (a.remuneracionImponibleUF = a.valorTopeUF) THEN 
                                               ROUND((a.valorTopeUF * v.valorUF), 0)
                                           ELSE
                                               a.remuneracionImponible
                                       END)
        FROM #RentaImponibleTMP a
            JOIN #ValorUFUltimaRentaTMP v ON (a.periodoDevengRemuneracion = v.periodoCotizacion);

        SELECT rut,
            CONVERT(NUMERIC(5,2), ROUND((SUM(remuneracionImponibleUF)/cinTres), cinDos)) promedioRemuneracionImponibleUF,
            COUNT(*) cantidadRemuneracionImponible,
            mesesPermanencia 
        INTO #Promedio3Meses 
        FROM #RentaImponibleTMP 
        WHERE periodoDevengRemuneracion BETWEEN ldtFechaPeriodoCotizacionInicio3Meses AND ldtFechaPeriodoCotizacion 
        AND mesesPermanencia >= cinTres
        GROUP BY rut, mesesPermanencia 
        ORDER BY rut asc;

        SELECT rut,
            CONVERT(NUMERIC(5,2), ROUND((SUM(remuneracionImponibleUF)/cinSeis), cinDos)) promedioRemuneracionImponibleUF,
            COUNT(*) cantidadRemuneracionImponible,
            mesesPermanencia 
        INTO #Promedio6Meses 
        FROM #RentaImponibleTMP 
        WHERE periodoDevengRemuneracion BETWEEN ldtFechaPeriodoCotizacionInicio6Meses AND ldtFechaPeriodoCotizacion 
        AND mesesPermanencia >= cinSeis
        GROUP BY rut,mesesPermanencia 
        ORDER BY rut asc;

        SELECT rut,
            CONVERT(NUMERIC(5,2), ROUND((SUM(remuneracionImponibleUF)/cinDoce), cinDos)) promedioRemuneracionImponibleUF,
            COUNT(*) cantidadRemuneracionImponible,
            mesesPermanencia 
        INTO #Promedio12Meses 
        FROM #RentaImponibleTMP 
        WHERE periodoDevengRemuneracion BETWEEN ldtFechaPeriodoCotizacionInicio12Meses AND ldtFechaPeriodoCotizacion 
        AND mesesPermanencia >= cinDoce
        GROUP BY rut,mesesPermanencia 
        ORDER BY rut asc;

        SELECT 
            rut,
            CONVERT(NUMERIC(5,2), ROUND((SUM(remuneracionImponibleUF)), cinDos)) as rentaImponiblePenultimoPeriodo 
        INTO #PromedioT2Meses 
        FROM #RentaImponibleTMP 
        WHERE periodoDevengRemuneracion = ldtFechaPeriodoCotizacionPenultimoPeriodo 
        AND mesesPermanencia >= cinDos
        GROUP BY rut, mesesPermanencia 
        ORDER BY rut asc;

        SELECT rut,
            MAX(periodoDevengRemuneracion) ultimoPercot
        INTO #UltimaPerCotRentaTMP
        FROM #RentaImponibleTMP 
        WHERE periodoDevengRemuneracion IN (ldtFechaPeriodoCotizacion, ldtFechaPeriodoInformado)
        GROUP BY rut;

        SELECT a.rut,
            ISNULL(a.remuneracionImponibleUF, cinCero)  AS  rentaImponibleMes,
            ISNULL(a.remuneracionImponible, cinCero)    AS rentaImponibleMesPesos
        INTO #ultimaRenta 
        FROM #RentaImponibleTMP a
            INNER JOIN #UltimaPerCotRentaTMP b ON (a.rut = b.rut
                AND a.periodoDevengRemuneracion = b.ultimoPercot);
    
        UPDATE #FctComportamientoPago as c 
        SET rentapromedioUF3Meses = promedioRemuneracionImponibleUF,
            totalPeriodos3Meses = cantidadRemuneracionImponible
        FROM #Promedio3Meses as a 
            INNER JOIN #FctComportamientoPago as c on(a.rut = c.rut) 
        WHERE c.idPeriodoInformado = linIdPeriodoInformar;  

        UPDATE #FctComportamientoPago as c 
        SET rentapromedioUF6Meses = promedioRemuneracionImponibleUF,
            totalPeriodos6Meses = cantidadRemuneracionImponible 
        FROM #Promedio6Meses as a 
            INNER JOIN #FctComportamientoPago as c on(a.rut = c.rut) 
        WHERE c.idPeriodoInformado = linIdPeriodoInformar;

        UPDATE #FctComportamientoPago as c 
        SET rentapromedioUF12Meses = promedioRemuneracionImponibleUF,
            totalPeriodos12Meses = cantidadRemuneracionImponible 
        FROM #Promedio12Meses as a 
            INNER JOIN #FctComportamientoPago as c on(a.rut = c.rut) 
        WHERE c.idPeriodoInformado = linIdPeriodoInformar;

        UPDATE #FctComportamientoPago
        SET rentaUFPenultimoPeriodo = rentaImponiblePenultimoPeriodo
        FROM #PromedioT2Meses a
            INNER JOIN #FctComportamientoPago c on (a.rut = c.rut)
        WHERE c.idPeriodoInformado = linIdPeriodoInformar;       

        UPDATE #FctComportamientoPago SET 
            c.rentaUFUltimoPeriodo = a.rentaImponibleMes,
            c.rentaPesosUltimoPeriodo = a.rentaImponibleMesPesos
        FROM #ultimaRenta a
            INNER JOIN #FctComportamientoPago c ON (a.rut = c.rut) 
        WHERE c.idPeriodoInformado = linIdPeriodoInformar;

        UPDATE #FctComportamientoPago 
        SET rentapromedioUF3Meses = cinCero,
            totalPeriodos3Meses = cinCero,
            rentapromedioUF6Meses = cinCero,
            totalPeriodos6Meses = cinCero,
            rentapromedioUF12Meses = cinCero,
            totalPeriodos12Meses = cinCero 
        WHERE mesesPermanencia >= cinDoce
        AND rentapromedioUF3Meses IS NULL 
        AND totalPeriodos6Meses IS NULL
        AND totalPeriodos12Meses IS NULL 
        AND idPeriodoInformado = linIdPeriodoInformar;

        UPDATE #FctComportamientoPago 
        SET rentapromedioUF3Meses = cinCero,
            totalPeriodos3Meses = cinCero 
        WHERE rentapromedioUF3Meses IS NULL 
        AND totalPeriodos3Meses IS NULL
        AND mesesPermanencia >= cinTres 
        AND idPeriodoInformado = linIdPeriodoInformar;

        UPDATE #FctComportamientoPago 
        SET rentapromedioUF6Meses = cinCero,
            totalPeriodos6Meses = cinCero 
        WHERE rentapromedioUF6Meses IS NULL 
        AND totalPeriodos6Meses IS NULL
        AND mesesPermanencia >= cinSeis 
        AND idPeriodoInformado = linIdPeriodoInformar;

        --UPDATE densidades de cotizacion
        UPDATE #FctComportamientoPago
        SET densidadCotizacion3Meses = CONVERT(NUMERIC(5,2), (ROUND((CONVERT(NUMERIC(15,6), totalPeriodos3Meses) / cnuTres) * ctiCien, cinDos)))
        WHERE idPeriodoInformado = linIdPeriodoInformar;

        UPDATE #FctComportamientoPago
        SET densidadCotizacion6Meses = CONVERT(NUMERIC(5,2), (ROUND((CONVERT(NUMERIC(15,6), totalPeriodos6Meses) / cnuSeis) * ctiCien, cinDos)))
        WHERE idPeriodoInformado = linIdPeriodoInformar;

        UPDATE #FctComportamientoPago
        SET densidadCotizacion12Meses = CONVERT(NUMERIC(5,2), (ROUND((CONVERT(NUMERIC(15,6), totalPeriodos12Meses) / cnuDoce) * ctiCien, cinDos)))
        WHERE idPeriodoInformado = linIdPeriodoInformar;

        UPDATE #FctComportamientoPago SET 
            indTopeImponible = cchS
        FROM #FctComportamientoPago a
        WHERE rentaUFUltimoPeriodo IS NOT NULL
        AND rentaUFUltimoPeriodo >= lnuValorTopeImponibleUF;

        --Obtiene el rut empleador de la ultima cotización CCICO
        SELECT id_mae_persona,
            rut_pagador,
            codigoActEconomicaEmpleador,
            SUM(renta_imponible) AS renta_imponible
        INTO #UniversoRutEmpleadorTMP
        FROM DMGestion.UniversoMovimientosCotizacionTMP
        WHERE indUltPerCotProdHist = cchSi
        AND rut_pagador > cinCero
        AND codigoTipoProducto = cinCicco --Producto CCICO
        GROUP BY id_mae_persona,
            rut_pagador,
            codigoActEconomicaEmpleador;

        SELECT a.id_mae_persona,
            a.rut_pagador,
            a.codigoActEconomicaEmpleador,
            ISNULL(b.idPersona, 0)  AS idEmpleador,
            ISNULL(c.id, 0)         AS idActividadEconomicaEmpleador
        INTO #UniversoEmpleadorActEconomicaTMP
        FROM (
            SELECT id_mae_persona,
                rut_pagador,
                codigoActEconomicaEmpleador,
                DENSE_RANK() OVER (PARTITION BY id_mae_persona ORDER BY renta_imponible DESC, rut_pagador DESC) AS rank
            FROM #UniversoRutEmpleadorTMP
            WHERE codigoActEconomicaEmpleador > 0
            UNION
            SELECT a.id_mae_persona,
                a.rut_pagador,
                a.codigoActEconomicaEmpleador,
                DENSE_RANK() OVER (PARTITION BY a.id_mae_persona ORDER BY a.renta_imponible DESC, a.rut_pagador DESC) AS rank
            FROM #UniversoRutEmpleadorTMP a
                LEFT JOIN (SELECT DISTINCT id_mae_persona
                           FROM #UniversoRutEmpleadorTMP
                           WHERE codigoActEconomicaEmpleador > 0) b ON (a.id_mae_persona = b.id_mae_persona)
            WHERE a.codigoActEconomicaEmpleador = 0
            AND b.id_mae_persona IS NULL
        ) a
            LEFT JOIN #DimPersonaEmpleadorTMP b ON (a.rut_pagador = b.rut)
            LEFT JOIN DMGestion.DimActividadEconomica c ON (a.codigoActEconomicaEmpleador = c.codigo
                AND c.fechaVigencia >= cdtMaximaFechaVigencia)
        WHERE a.rank = 1;

        UPDATE #FctComportamientoPago SET 
            a.idEmpleador                   = up.idEmpleador,
            a.idActividadEconomicaEmpleador = up.idActividadEconomicaEmpleador
        FROM #FctComportamientoPago a
            JOIN #UniversoEmpleadorActEconomicaTMP up ON (up.id_mae_persona = a.idPersonaOrigen);

        --Universo a registrar
        SELECT a.idPersona,         
            a.mesesPermanencia,                 
            a.rentapromedioUF3Meses,        
            a.totalPeriodos3Meses,              
            a.densidadCotizacion3Meses,         
            a.rentapromedioUF6Meses,        
            a.totalPeriodos6Meses,              
            a.densidadCotizacion6Meses,         
            a.rentapromedioUF12Meses,       
            a.totalPeriodos12Meses,             
            a.densidadCotizacion12Meses,        
            a.rentaUFPenultimoPeriodo,      
            a.rentaUFUltimoPeriodo, 
            a.idTipoCotizante,          
            a.fechaUltimaAcredCCIAV,        
            a.fechaUltimaCotiCCIAV,             
            a.ultimoPeriodoCotiCCIAV,       
            a.montoCotizacionCCIAV,             
            a.remuneraImpoUltimaCCIAV,          
            a.fechaUltimaAcredCCICO,        
            a.ultimoPeriodoCotiCCICO,       
            a.fechaUltimaCotiCCICO,             
            a.remuneraImpoUltimaCCICO,          
            a.totalMesesCotizadosCCICO,         
            a.totalMesesCotizados,          
            a.numeroFila,                   
            a.idError,
            a.indTopeImponible, 
            a.indCotizanteMes,
            a.rentaPesosUltimoPeriodo,
            a.idEmpleador,
            a.idActividadEconomicaEmpleador,
            a.remuneraImpoUltimaCCICOSinTope,
            a.remuneraImpoUltimaCCIAVSinTope,
            a.rentaPromedioPPPPesosCCICO,
            a.rentaPromedioPPPUFCCICO,
            a.indUsaCMHCCICO,
            a.rentaPromedioPPPPesosCCIAV,
            a.rentaPromedioPPPUFCCIAV,
            a.indUsaCMHCCIAV,
            a.rentaPromedioPPPPesosCCICV,
            a.rentaPromedioPPPUFCCICV,
            a.indUsaCMHCCICV,
            a.rentaPromedioPPPPesosCAPVC,
            a.rentaPromedioPPPUFCAPVC,
            a.indUsaCMHCAPVC,
            a.numeroMesesCotCCICOCCIAV
        INTO #UniversoRegistroTMP
        FROM #FctComportamientoPago a;       

        -------------------------------------------------------------------------------------------     
        --Generación de Universo de Errores      
        -------------------------------------------------------------------------------------------
        --Actualiza el numero de fila que corresponde
        UPDATE #UniversoRegistroTMP a SET
            numeroFila = ROWID(a);

        CREATE TABLE #UniversoErrores(
            idError             BIGINT          NULL,
            numeroFila          BIGINT          NOT NULL,
            nombreColumna       VARCHAR(50)     NOT NULL,
            tipoError           CHAR(1)         NOT NULL,
            idCodigoError       BIGINT          NOT NULL,
            descripcionError    VARCHAR(500)    NOT NULL
        );

        -------------------------------------------------------------------------------------------     
        --Insertando en la Fact      
        -------------------------------------------------------------------------------------------
         INSERT INTO DMGestion.FctComportamientoPago(
            idPeriodoInformado,             
            idPersona,
            idTipoCotizante,
            idEmpleador,
            idActividadEconomicaEmpleador,
            mesesPermanencia,               
            rentapromedioUF3Meses,          
            totalPeriodos3Meses,            
            densidadCotizacion3Meses,       
            rentapromedioUF6Meses,          
            totalPeriodos6Meses,            
            densidadCotizacion6Meses,       
            rentapromedioUF12Meses,         
            totalPeriodos12Meses,           
            densidadCotizacion12Meses,      
            rentaUFPenultimoPeriodo,        
            rentaUFUltimoPeriodo,
            rentaPesosUltimoPeriodo,
            fechaUltimaAcredCCIAV,      
            fechaUltimaCotiCCIAV,           
            ultimoPeriodoCotiCCIAV,         
            montoCotizacionCCIAV,           
            remuneraImpoUltimaCCIAV,        
            fechaUltimaAcredCCICO,          
            ultimoPeriodoCotiCCICO,         
            fechaUltimaCotiCCICO,           
            remuneraImpoUltimaCCICO,        
            totalMesesCotizadosCCICO,       
            totalMesesCotizados,            
            numeroFila,                     
            idError,
            indTopeImponible,
            indCotizanteMes,    
            remuneraImpoUltimaCCICOSinTope,
            remuneraImpoUltimaCCIAVSinTope,
            rentaPromedioPPPPesosCCICO,
            rentaPromedioPPPUFCCICO,
            indUsaCMHCCICO,
            rentaPromedioPPPPesosCCIAV,
            rentaPromedioPPPUFCCIAV,
            indUsaCMHCCIAV,
            rentaPromedioPPPPesosCCICV,
            rentaPromedioPPPUFCCICV,
            indUsaCMHCCICV,
            rentaPromedioPPPPesosCAPVC,
            rentaPromedioPPPUFCAPVC,
            indUsaCMHCAPVC,
            numeroMesesCotCCICOCCIAV
        )
        SELECT  linIdPeriodoInformar,            
            a.idPersona,                    
            a.idTipoCotizante,
            a.idEmpleador,
            a.idActividadEconomicaEmpleador,
            a.mesesPermanencia,                 
            a.rentapromedioUF3Meses,        
            a.totalPeriodos3Meses,
            a.densidadCotizacion3Meses,
            a.rentapromedioUF6Meses,        
            a.totalPeriodos6Meses,              
            a.densidadCotizacion6Meses,         
            a.rentapromedioUF12Meses,       
            a.totalPeriodos12Meses,             
            a.densidadCotizacion12Meses,        
            a.rentaUFPenultimoPeriodo,      
            a.rentaUFUltimoPeriodo, 
            a.rentaPesosUltimoPeriodo,          
            a.fechaUltimaAcredCCIAV,        
            a.fechaUltimaCotiCCIAV,             
            a.ultimoPeriodoCotiCCIAV,       
            a.montoCotizacionCCIAV,             
            a.remuneraImpoUltimaCCIAV,          
            a.fechaUltimaAcredCCICO,        
            a.ultimoPeriodoCotiCCICO,       
            a.fechaUltimaCotiCCICO,             
            a.remuneraImpoUltimaCCICO,          
            a.totalMesesCotizadosCCICO,         
            a.totalMesesCotizados,          
            a.numeroFila,                   
            a.idError,
            a.indTopeImponible,
            a.indCotizanteMes,
            a.remuneraImpoUltimaCCICOSinTope,
            a.remuneraImpoUltimaCCIAVSinTope,
            a.rentaPromedioPPPPesosCCICO,
            a.rentaPromedioPPPUFCCICO,
            a.indUsaCMHCCICO,
            a.rentaPromedioPPPPesosCCIAV,
            a.rentaPromedioPPPUFCCIAV,
            a.indUsaCMHCCIAV,
            a.rentaPromedioPPPPesosCCICV,
            a.rentaPromedioPPPUFCCICV,
            a.indUsaCMHCCICV,
            a.rentaPromedioPPPPesosCAPVC,
            a.rentaPromedioPPPUFCAPVC,
            a.indUsaCMHCAPVC,
            a.numeroMesesCotCCICOCCIAV
         FROM #UniversoRegistroTMP a;     
     
        ------------------------------------------------
        --Datos de Auditoria
        ------------------------------------------------
        --Se registra datos de auditoria
        SELECT COUNT(*) 
        INTO lbiCantidadRegistrosInformados
        FROM #UniversoRegistroTMP;

        DROP TABLE #UniversoRegistroTMP;
        DROP TABLE DMGestion.UniversoMovimientosCotizacionTMP;

        CALL DMGestion.registrarAuditoriaDatamartsPorFecha(ldtFechaPeriodoInformado,
                                                           ltiCodigoTipoProceso,
                                                           cstNombreProcedimiento, 
                                                           cstNombreTablaFct, 
                                                           ldtFechaInicioCarga, 
                                                           lbiCantidadRegistrosInformados, 
                                                           NULL);

        --Obtener datos RentaPromedio 
        CALL DMGestion.cargarRentaPromedioPPP(ldtFechaPeriodoRentaPPP);
       
        COMMIT;
        SAVEPOINT;

        SET codigoError = cstCodigoErrorCero;
    END IF;
-------------------------------------------------------------------------------------------     
--Manejo de Excepciones      
-------------------------------------------------------------------------------------------
EXCEPTION
    WHEN OTHERS THEN
        SET lstCodigoError = SQLSTATE;
        SET codigoError = lstCodigoError;        
        ROLLBACK;
        CALL ControlProcesos.registrarErrorProceso(cstOwner, cstNombreProcedimiento, lstCodigoError);
END