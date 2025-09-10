create PROCEDURE Circular1536.cargarFctAfiliadoCotizanteManual(IN periodoProceso DATE, OUT codigoError VARCHAR(10))
BEGIN
    /**
        - Nombre archivo                            : cargarFctAfiliadoCotizanteManual.sql
        - Nombre del módulo                         : Circular 1536
        - Fecha de  creación                        : 04-07-2011
        - Nombre del autor                          : Ricardo Salinas S. - Logica
        - Descripción corta del módulo              : procedimiento que carga la Fact table FctAfiliadoCotizante, modelo de Circular 1536.
        - Lista de procedimientos contenidos        : 
        - Documentos asociados a la creación        : Circular_1536_Documento_Análisis V1.0.doc
        - Fecha de modificación                     : 17-07-2019
        - Nombre de la persona que lo modificó      : Denis Chávez. 
        - Cambios realizados                        : 
        - Documentos asociados a la modificación    : 

        - Fecha de modificación                     : 25-09-2023
        - Cambios realizados                        : Modificacion de rut pagador para coitzante mes CCIAV (ACEC)
        - Nombre de la persona que lo modificó      : Denis Chávez. 
    **/
    --variable para capturar el codigo de error
    DECLARE lstCodigoError                              VARCHAR(10);    --variable local de tipo varchar
    --Variables
    DECLARE ldtMaximaFechaVigencia                      DATE;           --variable local de tipo date
    DECLARE linIdPeriodoInformar                        INTEGER;        --variable local de tipo integer
    DECLARE ltiCodigoTipoRolCero                        TINYINT;        --variable local de tipo tinyint
    DECLARE ldtUltimaFechaMesInformado                  DATE;           --variable local de tipo date
    DECLARE ldtFechaPeriodoInformado                    DATE;           --variable local de tipo date
    DECLARE ltiIdDimTopeImponible                       TINYINT;
    DECLARE ltiIdTipoCotizanteDependiente               TINYINT;
    DECLARE ltiIdRangoIngresoImponiblePrimerRangoCCICO  TINYINT;
    DECLARE ltiIdRangoIngresoImponiblePrimerRangoCAI    TINYINT;
    DECLARE ltiIdTipoCoberturaNoCubierto                TINYINT;
    DECLARE ltiEdadLegalPensionarseMasculino            TINYINT;        --variable local de tipo tinyint
    DECLARE ltiEdadLegalPensionarseFemenino             TINYINT;        --variable local de tipo tinyint
    DECLARE ldtPeriodoCotizacion                        DATE;
    --Variables auditoria
    DECLARE ldtFechaInicioCarga                         DATETIME;       --variable local de tipo datetime
    DECLARE lbiCantidadRegistrosInformados              BIGINT;         --variable local de tipo bigint
    DECLARE lnuValorTopeUF                              NUMERIC(5,2);         --variable local de tipo bigint
    --Constantes
    DECLARE cchCodigoGrupoCotizacionesCCICO             CHAR(2);        --constante de tipo char
    DECLARE cchCodigoGrupoCotizacionesRezagoCCICO       CHAR(2);        --constante de tipo char
    DECLARE cchCodigoGrupoCotizacionesCCIAV             CHAR(2);        --constante de tipo char
    DECLARE cchCodigoGrupoCotizacionesRezagoCCIAV       CHAR(2);        --constante de tipo char
    DECLARE cchCodigoGrupoCotizacionesCCICOInd          CHAR(2);        --constante de tipo char
    DECLARE cdtFechaTopeCubiertoSeguro                  DATE;           --constante de tipo date
    DECLARE cchCodigo01                                 CHAR(2);
    DECLARE cchCodigo02                                 CHAR(2);
    ----------------------------------------------------------------------------------------
    DECLARE cstOwner                                    VARCHAR(150);
    DECLARE cstNombreProcedimiento                      VARCHAR(150);   --constante de tipo varchar
    DECLARE cstNombreTablaFct                           VARCHAR(150);   --constante de tipo varchar
    DECLARE ctiUno                                      TINYINT;
    DECLARE ctiCero                                     TINYINT;
    DECLARE cstTipoProceso                              VARCHAR(150);
    DECLARE cstSi                                       VARCHAR(2);    
    DECLARE cst04                                       VARCHAR(2);
    DECLARE cstCCIAV                                    VARCHAR(10);

    -------------------------------------------------------------------------------------------
    --Seteo Variable auditoria
    -------------------------------------------------------------------------------------------
    --se obtiene la fecha y hora de carga
    SET ldtFechaInicioCarga                     = getDate();
    
    -------------------------------------------------------------------------------------------
    --Seteo de Constantes
    -------------------------------------------------------------------------------------------
    SET cstOwner                                = 'Circular1536';
    SET cstNombreProcedimiento                  = 'cargarFctAfiliadoCotizante';
    SET cstNombreTablaFct                       = 'FctAfiliadoCotizante';
    SET cstTipoProceso                          = 'Tabla de Hechos';
    SET cchCodigo01                             = '01';
    SET cchCodigo02                             = '02';
    SET ctiUno                                  = 1;
    SET ctiCero                                 = 0;
    SET cchCodigoGrupoCotizacionesCCICO         = DMGestion.obtenerParametro('CODIGO_GRUPO_MOVIMIENTO_COTIZACIONES_CCICO');
    SET cchCodigoGrupoCotizacionesRezagoCCICO   = DMGestion.obtenerParametro('CODIGO_GRUPO_MOVIMIENTO_COTIZACIONES_CCICO_REZAGO');
    SET cchCodigoGrupoCotizacionesCCIAV         = DMGestion.obtenerParametro('CODIGO_GRUPO_MOVIMIENTO_COTIZACIONES_CCIAV'); 
    SET cchCodigoGrupoCotizacionesRezagoCCIAV   = DMGestion.obtenerParametro('CODIGO_GRUPO_MOVIMIENTO_COTIZACIONES_CCIAV_REZAGO');
    SET cchCodigoGrupoCotizacionesCCICOInd      = DMGestion.obtenerParametro('CODIGO_GRUPO_MOVIMIENTO_COTIZACIONES_CCICO_INDEPENDIENTE');
    SET cdtFechaTopeCubiertoSeguro              = CONVERT(DATE, DMGestion.obtenerParametro('FECHA_TOPE_CUBIERTO_SEGURO'), 103);
    SET cstSi                                   = 'Si';
    SET cst04                                   = '04';
    SET cstCCIAV                                = 'CCIAV';


    --se obtiene el parametro MAXIMA_FECHA_VIGENCIA de la tabla Parametros
    SELECT CONVERT(DATE, DMGestion.obtenerParametro('MAXIMA_FECHA_VIGENCIA'), 103) 
    INTO ldtMaximaFechaVigencia 
    FROM DUMMY;

    -------------------------------------------------------------------------------------------
    --Seteo de Variables
    -------------------------------------------------------------------------------------------
    SET ldtFechaPeriodoInformado                = periodoProceso;
    SET linIdPeriodoInformar                    = DMGestion.obtenerIdDimPeriodoInformarPorFecha(ldtFechaPeriodoInformado);
    
    --Se obtiene el identificador del tipo cotizante dependiente
    SELECT id
    INTO ltiIdTipoCotizanteDependiente
    FROM DMGestion.DimTipoCotizante
    WHERE codigo = '01' --Dependiente
    AND fechaVigencia >= ldtMaximaFechaVigencia;

    --Se obtiene el identificador del primer rango CCICO
    SELECT id
    INTO ltiIdRangoIngresoImponiblePrimerRangoCCICO
    FROM DMGestion.DimRangoIngresoImponible
    WHERE codigo = '01'
    AND codigoGrupo = '01' --Rango CCICO o CCIAV
    AND fechaVigencia >= ldtMaximaFechaVigencia;

    --Se obtiene el identificador del primer rango CAI
    SELECT id
    INTO ltiIdRangoIngresoImponiblePrimerRangoCAI
    FROM DMGestion.DimRangoIngresoImponible
    WHERE codigo = '01'
    AND codigoGrupo = '02' --Rango CAI
    AND fechaVigencia >= ldtMaximaFechaVigencia;

    --Se obtiene el identificador del tipo cobertura 'No Cubierto'
    SELECT id
    INTO ltiIdTipoCoberturaNoCubierto
    FROM DMGestion.DimTipoCobertura
    WHERE codigo = '03'
    AND fechaVigencia >= ldtMaximaFechaVigencia;

    --se obtiene el parametro EDAD_LEGAL_PENSIONARSE_MASCULINO de la tabla Parametros
    SELECT CONVERT(TINYINT, DMGestion.obtenerParametro('EDAD_LEGAL_PENSIONARSE_MASCULINO')) 
    INTO ltiEdadLegalPensionarseMasculino 
    FROM DUMMY;

    --se obtiene el parametro EDAD_LEGAL_PENSIONARSE_FEMENINO de la tabla Parametros
    SELECT CONVERT(TINYINT, DMGestion.obtenerParametro('EDAD_LEGAL_PENSIONARSE_FEMENINO')) 
    INTO ltiEdadLegalPensionarseFemenino 
    FROM DUMMY;

    --Obtener la última fecha del mes a informar
    SELECT DMGestion.obtenerUltimaFechaMes(ldtFechaPeriodoInformado) 
    INTO ldtUltimaFechaMesInformado
    FROM Dummy;

    --Se obtiene el periodo de cotización
    SELECT CONVERT(DATE, DATEADD(mm, -1, ldtFechaPeriodoInformado))
    INTO ldtPeriodoCotizacion
    FROM DUMMY;

     
    --se elimina los errores de carga y datos de la fact para el periodo a informar
    CALL Circular1536.eliminarFact(cstNombreProcedimiento, cstNombreTablaFct, linIdPeriodoInformar, codigoError);
   

    -- Verifica si se elimino con éxito
    IF (codigoError = '0') THEN
      
        -------------------------------------------
        --UNIVERSO
        -------------------------------------------
        SELECT dp.rut AS rutAfiliado,
            fca.idComunaPrincipal,
            fca.idComunaAlternativa
        INTO #FctContactoAfiliadoTMP
        FROM DMGestion.FctContactoAfiliado fca
            INNER JOIN DMGestion.DimPeriodoInformado dpi ON (dpi.id = fca.idPeriodoInformado)
            INNER JOIN DMGestion.DimPersona dp ON (dp.id = fca.idPersona)
        WHERE fca.idPeriodoInformado = linIdPeriodoInformar;
       
        

        SELECT dp.rut AS rutAfiliado,
            fcp.remuneraImpoUltimaCCIAV,
            fcp.rentaPesosUltimoPeriodo,
            fcp.fechaUltimaCotiCCIAV,
            fcp.fechaUltimaCotiCCICO, 
            fcp.ultimoPeriodoCotiCCIAV,
            fcp.ultimoPeriodoCotiCCICO,
            fcp.indCotizanteMes,  
            fcp.totalMesesCotizadosCCICO,
            fcp.idTipoCotizante,
            fcp.indTopeImponible,
            convert(bigint,0 ) AS idActividadEconomica,
            fcp.idEmpleador,
            fcp.fechaUltimaAcredCCIAV,
            dtc.codigo
        INTO #FctComportamientoPagoTMP
        FROM DMGestion.FctComportamientoPago fcp
            INNER JOIN DMGestion.DimPeriodoInformado dpi ON (dpi.id = fcp.idPeriodoInformado)
            INNER JOIN DMGestion.DimPersona dp ON (dp.id = fcp.idPersona)
            INNER JOIN DMGestion.DimTipoCotizante dtc ON dtc.id = fcp.idTipoCotizante
        WHERE fcp.idPeriodoInformado = linIdPeriodoInformar;
    
    
    
   --Nueva forma de extraer el código de actividad desde la planilla de pago       
    SELECT distinct dpe.rut,isnull(era.idActividadEconomica,ctiCero) idActividadEconomica,era.idEmpleador into #principal
    FROM DmGestion.FctEmpleadorRelacionAfiliado era
    INNER JOIN DmGestion.dimEscalaCalidad decc ON (decc.id = era.idEscalaCalidad )
    INNER JOIN DMGestion.DimPersona dpe ON (dpe.id = era.idPersona )
    WHERE idPeriodoInformado = linIdPeriodoInformar
    AND idEscalaCalidad = ctiUno
    AND dpe.rut in (SELECT rutAfiliado from #FctComportamientoPagoTMP)
    AND dpe.rut NOT IN (SELECT rutAfiliado from #FctComportamientoPagoTMP WHERE  (codigo = cst04 AND indCotizanteMes = cstSi));-- INESP-5082
    
    
        
    
    UPDATE #FctComportamientoPagoTMP
    SET idActividadEconomica = B.idActividadEconomica,
        idEmpleador         = B.idEmpleador
    FROM #FctComportamientoPagoTMP A
        INNER JOIN #principal B ON (A.rutAfiliado = B.RUT);


    --------- INESP-5082 AFILIADO CCIAV COTIZANTE MES ------------------------------------------
    SELECT DISTINCT dp.rut,fcp.fechaUltimaAcredCCIAV,fcp.ultimoPeriodoCotiCCIAV,fmc.idPagador 
    into #CCIAV
    FROM DMGestion.FctMovimientosCuenta fmc
        INNER JOIN DMGestion.DimPeriodoInformado dpi ON dpi.id = fmc.idPeriodoInformado
        INNER JOIN DMGestion.DimPersona dp ON dp.id = fmc.idPersona
        INNER JOIN #FctComportamientoPagoTMP fcp ON fcp.rutAfiliado = dp.rut AND fcp.fechaUltimaAcredCCIAV = fmc.fechaAcreditacion
        INNER JOIN  DMGestion.DimTipoProducto dtp ON dtp.id = fmc.idTipoProducto 
    WHERE idPeriodoInformado = linIdPeriodoInformar
        AND fcp.codigo = cst04
        AND fcp.indCotizanteMes = cstSi
        AND fcp.ultimoPeriodoCotiCCIAV = fmc.periodoDevengRemuneracion
        AND dtp.nombreCorto = cstCCIAV;
      
   UPDATE #FctComportamientoPagoTMP
   SET idEmpleador = B.idPagador
   FROM #FctComportamientoPagoTMP A
   INNER JOIN #CCIAV B ON (A.rutAfiliado = B.RUT);
   --------------------------------------------------------------------------------------------
   
    

        --Obtiene Universo de Afiliados y Cotizantes
        SELECT CONVERT(BIGINT, NULL) numeroFila,
            fip.idPeriodoInformado,
            dp.id idAfiliado, 
            dp.rut rutAfiliado,
            dp.fechaNacimiento, 
            dp.sexo,
            (CASE
                WHEN (dtcot.codigo = '04') THEN --Voluntario
                    fcp.remuneraImpoUltimaCCIAV
                ELSE fcp.rentaPesosUltimoPeriodo
             END) ingresoImponible,
            dtcot.codigo codigoTipoCotizante,
            (CASE
                WHEN (dtcot.codigo = '04') THEN --Voluntario
                    fcp.fechaUltimaCotiCCIAV
                ELSE fcp.fechaUltimaCotiCCICO
             END) fechaUltimaCotizacion,
            (CASE
                WHEN (dtcot.codigo = '04') THEN --Voluntario
                    fcp.ultimoPeriodoCotiCCIAV
                ELSE fcp.ultimoPeriodoCotiCCICO
             END) periodoUltimaCotizacion,
            fcp.fechaUltimaCotiCCICO, 
            fcp.fechaUltimaCotiCCIAV,
            fcp.indCotizanteMes,  
            fcp.ultimoPeriodoCotiCCICO, 
            fcp.ultimoPeriodoCotiCCIAV,
            (CASE 
                WHEN dcp.codigo = 3 THEN
                    4 --Fallecido
                WHEN dcp.codigo = 4 THEN
                    6 --Cliente
                ELSE
                    dcp.codigo
             END) codigoTipoEstadoRol, 
            fcp.idTipoCotizante, 
            (CASE
                WHEN (fca.idComunaPrincipal = 0) THEN
                    fca.idComunaAlternativa
                ELSE fca.idComunaPrincipal
             END) idComuna, 
            fip.fechaAfiliacionSistema, 
            fip.fechaIncorporacionAFP,
            fcp.totalMesesCotizadosCCICO,
            (CASE
                WHEN (dcp.codigo = 4 ) THEN
                    CONVERT(VARCHAR(20), 'Cliente')
                WHEN (dcp.codigo = 1 ) THEN
                    CONVERT(VARCHAR(20), 'Activo')
                WHEN (dcp.codigo IN (2, 3) ) THEN
                    CONVERT(VARCHAR(20), 'Pasivo')
             END) tipoAfiliado,
            (CASE 
                WHEN ((dp.fechaNacimiento IS NOT NULL) AND 
                      (dp.fechaNacimiento < ldtUltimaFechaMesInformado)) THEN
                    CONVERT(BIGINT, (DATEDIFF(mm, dp.fechaNacimiento, ldtUltimaFechaMesInformado)/12))
                ELSE NULL
             END) edadActuarial,
            (CASE 
                WHEN ((dp.fechaNacimiento IS NOT NULL) AND 
                      (dp.fechaNacimiento < cdtFechaTopeCubiertoSeguro)) THEN
                    CONVERT(BIGINT, (DATEDIFF(mm, dp.fechaNacimiento, cdtFechaTopeCubiertoSeguro)/12))
                ELSE CONVERT(BIGINT, 0)
             END) edadCubiertaSeguro,
            dtc.codigo codigoTipoControl,
            (CASE
                WHEN (fip.fechaAfiliacionSistema IS NOT NULL) THEN
                    DATEPART(yy, fip.fechaAfiliacionSistema) 
                ELSE NULL
             END) anoAfiliacion,
            fip.idTipoCoberturaSIS idTipoCobertura,
            dtco.codigo codigoTipoCobertura,
            (CASE
                WHEN (dcp.codigo = 4 ) THEN
                    CONVERT(TINYINT, 7)
                ELSE
                    CONVERT(TINYINT, 1)
             END) codigoTipoRol,
            CONVERT(NUMERIC(4, 3), NULL) densidadCotizacion,
            CONVERT(SMALLINT, NULL) mesesSinmovimiento,
            CONVERT(TINYINT, 0) indCotizacionUltimoMes, 
            ISNULL(fcp.idActividadEconomica, 0) AS idActividadEconomica, 
            CONVERT(TINYINT, 0) idTopeImponible,
            CONVERT(INTEGER, 0) idRegion,
            CONVERT(TINYINT, 0) idAnoAfiliacion,
            CONVERT(TINYINT, 0) idRangoEdadTrimestral,
            CONVERT(TINYINT, 0) idRangoEdadAnual,
            CONVERT(TINYINT, 0) idEdadTrimestral,
            CONVERT(TINYINT, 0) idRangoIngresoImponible,
            CONVERT(TINYINT, 0) idRangoMesesMovimiento,
            CONVERT(TINYINT, 0) idRangoDensidadCotizacion,
             CONVERT(TINYINT, 0) idRangoIngresoImponibleCAI,
            CONVERT(BIGINT, NULL) ingresoImponibleCAI,
            CONVERT(TINYINT, 0) indCotizacionUltimoMesCAI,
            CONVERT(CHAR(1), 'S') registroInformar,
            CONVERT(BIGINT, NULL) idError,
            fcp.indTopeImponible,
            fcp.idEmpleador
        INTO #UniversoRegistroTMP
        FROM DMGestion.FctlsInformacionAfiliadoCliente fip
            INNER JOIN DMGestion.DimPeriodoInformado dpi ON (dpi.id = fip.idPeriodoInformado)
            INNER JOIN DMGestion.DimPersona dp ON (dp.id = fip.idPersona)
            INNER JOIN DMGestion.DimTipoControl dtc ON (dtc.id = fip.idTipoControl)
            INNER JOIN DMGestion.DimTipoCobertura dtco ON (dtco.id = fip.idTipoCoberturaSIS)
            INNER JOIN DMGestion.DimSubClasificacionPersona dscp ON (dscp.id = fip.idSubClasificacionPersona)
            INNER JOIN DMGestion.DimClasificacionPersona dcp ON (dcp.id = dscp.idClasificacionPersona)
            INNER JOIN #FctContactoAfiliadoTMP fca ON (fca.rutAfiliado = dp.rut)
            LEFT OUTER JOIN #FctComportamientoPagoTMP fcp ON (fcp.rutAfiliado = dp.rut)
            LEFT OUTER JOIN DmGestion.DimTipoCotizante dtcot ON (dtcot.id = fcp.idTipoCotizante)
        WHERE dcp.codigo IN (1, 2, 3, 4) --Afiliados, Pensionado, Fallecido y Cliente
        AND fip.idPeriodoInformado = linIdPeriodoInformar;
        
        -------------------------------------------
        --PRODUCTOS ASOCIADOS
        -------------------------------------------
        SELECT DISTINCT dtp.codigo codigoTipoProducto,
            u.idAfiliado,
            u.rutAfiliado
        INTO #UniversoProductosAsociadosTMP
        FROM DMGestion.FctCuenta fc
            INNER JOIN DMGestion.DimPersona dp ON(fc.idPersona = dp.id)
            INNER JOIN DMGestion.DimTipoProducto dtp ON (fc.idTipoProducto = dtp.id)
            INNER JOIN #UniversoRegistroTMP u ON (dp.rut = u.rutAfiliado)           
        WHERE fc.idPeriodoInformado = linIdPeriodoInformar;

       
        -------------------------------------------
        --TIPO COBERTURA
        -------------------------------------------
        UPDATE #UniversoRegistroTMP SET
            idTipoCobertura = ltiIdTipoCoberturaNoCubierto
        WHERE codigoTipoCobertura IN ('01', '02')
        AND sexo = 'M' 
        AND edadActuarial > ltiEdadLegalPensionarseMasculino;

        UPDATE #UniversoRegistroTMP SET
            idTipoCobertura = ltiIdTipoCoberturaNoCubierto
        WHERE codigoTipoCobertura IN ('01', '02')
        AND sexo = 'F' 
        AND edadCubiertaSeguro > 60
        AND edadActuarial > ltiEdadLegalPensionarseFemenino;

        UPDATE #UniversoRegistroTMP SET
            idTipoCobertura = ltiIdTipoCoberturaNoCubierto
        WHERE codigoTipoCobertura IN ('01', '02')
        AND sexo = 'F' 
        AND edadCubiertaSeguro <= 60
        AND edadActuarial > ltiEdadLegalPensionarseMasculino;

        -------------------------------------------
        --COTIZANTES EN EL MES
        -------------------------------------------
        --Se obtiene universo de movimientos de los cotizantes en el mes
        SELECT u.tipoAfiliado,
            fmc.fechaOperacion,
            fmc.periodoDevengRemuneracion,
            dgm.codigoSubgrupo codigoSubGrupoMovimiento, 
            u.idAfiliado,
            u.rutAfiliado,
            dtp.codigo AS codigoTipoProducto,
            fmc.remuneracionImponible,
            fmc.idPagador,
            dpe.rut AS rutPagador,
            fmc.montoPesos
        INTO #UniversoMovimientosCotizanteMesTMP
        FROM DMGestion.FctMovimientosCuenta fmc
            INNER JOIN DMGestion.DimGrupoMovimiento dgm ON (fmc.idGrupoMovimiento = dgm.id)
            INNER JOIN DMGestion.DimTipoProducto dtp ON (fmc.idTipoProducto = dtp.id)
            INNER JOIN DMGestion.DimPersona dp ON (fmc.idPersona = dp.id)
            INNER JOIN #UniversoRegistroTMP u ON (dp.rut = u.rutAfiliado)
            INNER JOIN DMGestion.FctCuenta fc ON fc.idPeriodoInformado = linIdPeriodoInformar AND fc.idTipoProducto = dtp.id AND fc.idPersona = dp.id
            LEFT JOIN DMGestion.DimPersona dpe ON (fmc.idPagador = dpe.id)
        WHERE fmc.idPeriodoInformado = linIdPeriodoInformar
        AND dgm.codigoSubgrupo IN (1101, 1104, 1105)
        AND dtp.codigo IN (1, 6) --CCICO y CCIAV
        AND fmc.periodoDevengRemuneracion IN (ldtPeriodoCotizacion, ldtFechaPeriodoInformado)
        AND fmc.montoPesos > 0
        ORDER BY fmc.fechaOperacion;

        --Se obtiene el mayor periodo de cotización
        SELECT idAfiliado, 
            MAX(periodoDevengRemuneracion) AS periodoDevengRemuneracion
        INTO #UniversoMaximoPerCotTMP
        FROM #UniversoMovimientosCotizanteMesTMP
        GROUP BY idAfiliado;

        SELECT DISTINCT ucm.tipoAfiliado,
            ucm.fechaOperacion,
            ucm.periodoDevengRemuneracion,
            ucm.codigoSubGrupoMovimiento, 
            ucm.idAfiliado,
            ucm.rutAfiliado,
            ucm.codigoTipoProducto,
            ucm.idPagador,
            ucm.rutPagador
        INTO #UniversoMovimientosMaximoPerCotTMP
        FROM #UniversoMovimientosCotizanteMesTMP ucm
            INNER JOIN #UniversoMaximoPerCotTMP umpc ON (ucm.idAfiliado = umpc.idAfiliado
            AND ucm.periodoDevengRemuneracion = umpc.periodoDevengRemuneracion);

        DROP TABLE #UniversoMaximoPerCotTMP;

        --Se obtiene la cantidad de productos que tiene una persona para el maximo periodo de cotización,
        --Solo los que tienes mas de un producto
        SELECT idAfiliado, 
            COUNT(DISTINCT codigoTipoProducto) cantidadProductos
        INTO #CantidadProductosTMP
        FROM #UniversoMovimientosMaximoPerCotTMP
        GROUP BY idAfiliado
        HAVING cantidadProductos > 1;

        --Si existen varios movimientos para los productos CCICO y CCIAV, con el mismo periodo de 
        --cotización, se eliminan los movimientos del producto CCIAV
        DELETE FROM #UniversoMovimientosMaximoPerCotTMP 
        FROM #UniversoMovimientosMaximoPerCotTMP ummpc, #CantidadProductosTMP cp
        WHERE ummpc.idAfiliado = cp.idAfiliado
        AND ummpc.codigoTipoProducto = 6; --Producto CCIAV

        DROP TABLE #CantidadProductosTMP;

        --Se obtiene la cantidad de registros que tiene una persona, para el máximo periodo de cotización
        SELECT idAfiliado, 
            COUNT(*) cantidad
        INTO #CantidadRegistrosTMP
        FROM #UniversoMovimientosMaximoPerCotTMP
        GROUP BY idAfiliado;

        --Se determina el tipo de cotizante para los movimientos que tengan un solo registro
        SELECT a.idAfiliado,
            a.codigoTipoProducto,
            (CASE
                WHEN (a.codigoSubGrupoMovimiento IN (1101, 1104, 1105)
                      AND (a.codigoTipoProducto = 1))
                THEN
                    (CASE
                        WHEN (a.rutPagador != a.rutAfiliado) THEN 
                            CONVERT(CHAR(2), '01') --Dependiente
                        ELSE CONVERT(CHAR(2), '02') --Independiente
                     END
                    )
                WHEN (a.codigoSubGrupoMovimiento IN (1101, 1105) 
                      AND (a.codigoTipoProducto IN (1, 6))) THEN 
                    CONVERT(CHAR(2), '04') --Voluntario
             END
            ) codigoTipoCotizante
        INTO #UniversoTipoCotizanteTMP
        FROM #UniversoMovimientosMaximoPerCotTMP a
            INNER JOIN #CantidadRegistrosTMP cr ON (a.idAfiliado = cr.idAfiliado)
        WHERE cr.cantidad = 1;

        --Se determina el tipo de cotizante para los movimientos que tengan varios registros
        --Se crea un universo temporal para los movimientos que tengan varios registros
        SELECT a.idAfiliado, 
            a.idPagador, 
            a.rutAfiliado,
            a.rutPagador,
            a.codigoTipoProducto, 
            a.periodoDevengRemuneracion, 
            a.codigoSubGrupoMovimiento
        INTO #UniversoTemp1
        FROM #UniversoMovimientosMaximoPerCotTMP a
            INNER JOIN #CantidadRegistrosTMP cr ON (a.idAfiliado = cr.idAfiliado)
        WHERE cr.cantidad > 1;

        DROP TABLE #CantidadRegistrosTMP;

        --Se obtiene el tipo cotizante (voluntario) que cumplan con el código grupo de movimiento (60, 61)
        --y que no existan registros con los código grupo de movimiento (10, 11, 13)
        --registrando en la tabla temporal #UniversoTipoCotizanteTMP
        INSERT INTO #UniversoTipoCotizanteTMP(idAfiliado, codigoTipoProducto, codigoTipoCotizante)
        SELECT DISTINCT a.idAfiliado,
            a.codigoTipoProducto,
            CONVERT(CHAR(2), '04') codigoTipoCotizante --Voluntario
        FROM #UniversoTemp1 a
        WHERE a.idAfiliado NOT IN (SELECT DISTINCT b.idAfiliado 
                                   FROM #UniversoTemp1 b 
                                   WHERE b.codigoSubGrupoMovimiento IN (1101, 1104, 1105)
                                   AND b.codigoTipoProducto = 1
                                  )
        AND a.codigoSubGrupoMovimiento IN (1101, 1105)
        AND a.codigoTipoProducto = 6;

        --Se obtiene la cantidad de registros para el grupo de movimiento 10, 11 y 13,
        --agrupados por el id_mae_persona
        SELECT idAfiliado, 
            count(*) cantidadRegistros
        INTO #UniversoTemp2
        FROM #UniversoTemp1
        WHERE codigoSubGrupoMovimiento IN (1101, 1104, 1105)
        AND codigoTipoProducto = 1
        GROUP BY idAfiliado;

        --Se obtiene la cantidad de registros para el grupo de movimiento 10, 11 y 13, y
        --que el rut de la persona sea igual al rut del pagador, agrupados por el idAfiliado
        SELECT idAfiliado, 
            count(*) cantidadRegistrosRutIguales
        INTO #UniversoTemp3
        FROM #UniversoTemp1
        WHERE codigoSubGrupoMovimiento IN (1101, 1104, 1105)
        AND rutAfiliado = rutPagador
        AND codigoTipoProducto = 1
        GROUP BY idAfiliado;

        --Se obtiene el tipo cotizante (01: 'Dependiente', 02:'Independiente', 03:'Dependiente e Independiente')
        INSERT INTO #UniversoTipoCotizanteTMP(idAfiliado, codigoTipoProducto, codigoTipoCotizante)
        SELECT DISTINCT a.idAfiliado, 
            a.codigoTipoProducto,
            (CASE 
                WHEN (b.cantidadRegistros = ISNULL(c.cantidadRegistrosRutIguales, 0)) THEN 
                    CONVERT(CHAR(2), '02') --Independiente
                WHEN (ISNULL(c.cantidadRegistrosRutIguales, 0) = 0) THEN 
                    CONVERT(CHAR(2), '01') --Dependiente
                ELSE CONVERT(CHAR(2), '03') --Dependiente e Independiente
             END
            ) codigoTipoCotizante
        FROM #UniversoTemp1 a 
            INNER JOIN #UniversoTemp2 b ON (a.idAfiliado = b.idAfiliado)
            LEFT OUTER JOIN #UniversoTemp3 c ON (b.idAfiliado = c.idAfiliado);

        --Se elmimina tablas temporales
        DROP TABLE #UniversoTemp1;
        DROP TABLE #UniversoTemp2;
        DROP TABLE #UniversoTemp3;

        --Se obtiene el máximo fecha de operación
        SELECT idAfiliado, 
            periodoDevengRemuneracion, 
            codigoTipoProducto,
            MAX(fechaOperacion) fechaOperacion
        INTO #UniversoMovimientosMaximaFechasTMP
        FROM #UniversoMovimientosMaximoPerCotTMP
        GROUP BY idAfiliado, periodoDevengRemuneracion, codigoTipoProducto;
       
       

        --Actualiza los siguientes campos para el producto CCICO:
        --1. fechaUltimaCotiCCICO
        --2. ultimoPeriodoCotiCCICO
        UPDATE #UniversoRegistroTMP SET
            u.fechaUltimaCotiCCICO = ummf.fechaOperacion,
            u.ultimoPeriodoCotiCCICO = ummf.periodoDevengRemuneracion
        FROM #UniversoRegistroTMP u
            JOIN #UniversoMovimientosMaximaFechasTMP ummf ON (u.idAfiliado = ummf.idAfiliado)
        WHERE ummf.codigoTipoProducto = 1; --CCICO

        --Actualiza los siguientes campos para el producto CCIAV:
        --1. fechaUltimaCotiCCIAV
        --2. ultimoPeriodoCotiCCIAV
        UPDATE #UniversoRegistroTMP SET
            u.fechaUltimaCotiCCIAV = ummf.fechaOperacion,
            u.ultimoPeriodoCotiCCIAV = ummf.periodoDevengRemuneracion
        FROM #UniversoRegistroTMP u
            JOIN #UniversoMovimientosMaximaFechasTMP ummf ON (u.idAfiliado = ummf.idAfiliado)
        WHERE ummf.codigoTipoProducto = 6; --CCIAV

        SELECT u.idAfiliado,
              dtc.id idTipoCotizante,
              u.codigoTipoCotizante
        INTO #AfiliadoTipoCotizanteTMP
        FROM #UniversoTipoCotizanteTMP u
            INNER JOIN DMGestion.DimTipoCotizante dtc ON (u.codigoTipoCotizante = dtc.codigo)
        WHERE dtc.fechaVigencia >= ldtMaximaFechaVigencia;

        --Actualiza el tipo cotizante
        UPDATE #UniversoRegistroTMP SET
            uac.idTipoCotizante         = atc.idTipoCotizante,
            uac.idActividadEconomica    = (CASE
                                                WHEN (atc.codigoTipoCotizante = '04') THEN  --Voluntario
                                                    CONVERT(BIGINT, 0) --Sin Clasificar
                                                ELSE uac.idActividadEconomica
                                           END)
        FROM #UniversoRegistroTMP uac
            JOIN #AfiliadoTipoCotizanteTMP atc ON (uac.idAfiliado = atc.idAfiliado);

        -------------------------------------------
        --TOTAL MESES COTIZADOS CCICO
        -------------------------------------------
       
           
        --Si el percot es el mes informado se resta una cotización
        UPDATE #UniversoRegistroTMP SET
            totalMesesCotizadosCCICO = (totalMesesCotizadosCCICO - 1)
        WHERE ultimoPeriodoCotiCCICO = ldtFechaPeriodoInformado
        AND totalMesesCotizadosCCICO > 0;

        -------------------------------------------
        --REMUNERACIÓN IMPONIBLE
        -------------------------------------------
        --Se obtiene el universo de remuneración imponible, de acuerdo al siguiente criterio:
        --1. Si el producto es CCICO, se debe de sumar el campo remuneracionImponible
        --2. Si el producto es CCIAV, se debe de sumar el campo montoPesos
        SELECT umcm.idAfiliado,
            umcm.codigoTipoProducto,
            umcm.periodoDevengRemuneracion,
            SUM(umcm.remuneracionImponible) remuneracionImponible
        INTO #UniversoRemuneracionImponibleTMP
        FROM #UniversoMovimientosCotizanteMesTMP umcm
            INNER JOIN #UniversoMovimientosMaximaFechasTMP ummf ON (umcm.idAfiliado = ummf.idAfiliado
            AND umcm.periodoDevengRemuneracion = ummf.periodoDevengRemuneracion
            AND umcm.codigoTipoProducto = ummf.codigoTipoProducto)
        GROUP BY umcm.idAfiliado, umcm.codigoTipoProducto, umcm.periodoDevengRemuneracion;

        --Se obtiene la ultimo dia del mes, correspondiente al periodo de cotización y el valor de
        --la UF
        SELECT DISTINCT uri.periodoDevengRemuneracion,
            (DATE(DATEFORMAT( uri.periodoDevengRemuneracion,'YYYYMM')+ convert(char(2), 
             DATEPART(dd,(DATEADD(ms,-3,DATEADD(mm, DATEDIFF(mm,DATE('1900-01-01'), 
             uri.periodoDevengRemuneracion)+1,DATE('1900-01-01')))))))
            ) ultimoDiaMes,
            vvu.valorUF,
            CONVERT(NUMERIC(5, 2), NULL) valorTopeImponible
        INTO #TopeRentaImponibleTMP
        FROM #UniversoRemuneracionImponibleTMP uri
            INNER JOIN DMGestion.VistaValorUF vvu ON (vvu.fechaUF = ultimoDiaMes)
        WHERE vvu.ultimoDiaMes = 'S';

        --Se obtiene el valor del tope imponible de acuerdo al periodo de cotización
        UPDATE #TopeRentaImponibleTMP SET
            tri.valorTopeImponible = ISNULL(vti.valor, 0)
        FROM #TopeRentaImponibleTMP tri, DMGestion.VistaTopeImponible vti
        WHERE tri.periodoDevengRemuneracion between vti.fechaInicioRango and  vti.fechaTerminoRango;
        
        --Se topa la Renta Imponible
        UPDATE #UniversoRemuneracionImponibleTMP SET
            uri.remuneracionImponible = (CASE
                                            WHEN (uri.remuneracionImponible > ROUND((tri.valorUF * tri.valorTopeImponible), 0)) THEN
                                                ROUND((tri.valorUF * tri.valorTopeImponible), 0)
                                            ELSE
                                                uri.remuneracionImponible
                                         END) 
        FROM #UniversoRemuneracionImponibleTMP uri
            JOIN #TopeRentaImponibleTMP tri ON (uri.periodoDevengRemuneracion = tri.periodoDevengRemuneracion);

        DROP TABLE #TopeRentaImponibleTMP;

        -------------------------------------------
        --NÚMERO MESES SIN MOVIMIENTO
        -------------------------------------------
       
       
        --Cálcula los meses sin movimiento
        UPDATE #UniversoRegistroTMP SET
            mesesSinmovimiento = (CASE 
                                    WHEN (fechaUltimaCotiCCICO IS NOT NULL) THEN
                                        (CASE
                                            WHEN (fechaUltimaCotiCCICO >= fechaIncorporacionAFP) THEN
                                                CONVERT(SMALLINT, datediff(mm, fechaUltimaCotiCCICO, ldtUltimaFechaMesInformado))
                                         ELSE
                                            CONVERT(SMALLINT, datediff(mm, fechaIncorporacionAFP, ldtUltimaFechaMesInformado))
                                         END)
                                    ELSE CONVERT(SMALLINT, datediff(mm, fechaIncorporacionAFP, ldtUltimaFechaMesInformado))
                                  END);

        -------------------------------------------
        --TIPO COTIZACION ULTIMO MES
        -------------------------------------------
        --Se actualiza campo indCotizacionUltimoMes para CCIAV
        UPDATE #UniversoRegistroTMP SET
            indCotizacionUltimoMes = 2
        WHERE indCotizanteMes = 'Si'
        AND ultimoPeriodoCotiCCIAV IN (ldtPeriodoCotizacion, ldtFechaPeriodoInformado)
        and rutAfiliado = any(select b.rutAfiliado from #UniversoMovimientosCotizanteMesTMP b);

        --Se actualiza campo indCotizacionUltimoMes para CCICO
        UPDATE #UniversoRegistroTMP SET
            indCotizacionUltimoMes = 1
        WHERE indCotizanteMes = 'Si'
        AND ultimoPeriodoCotiCCICO IN (ldtPeriodoCotizacion, ldtFechaPeriodoInformado)            
        AND rutAfiliado = any(select b.rutAfiliado from #UniversoMovimientosCotizanteMesTMP b);

        -----------------------------------------------------
        --FECHA ULTIMA COTIZACION Y PERIODO ULTIMA COTIZACION
        -----------------------------------------------------
        --actualiza para el producto CCIAV
        UPDATE #UniversoRegistroTMP SET
            fechaUltimaCotizacion = fechaUltimaCotiCCIAV,
            periodoUltimaCotizacion = ultimoPeriodoCotiCCIAV
        WHERE indCotizacionUltimoMes = 2;

        --actualiza para el producto CCICO
        UPDATE #UniversoRegistroTMP SET
            fechaUltimaCotizacion = fechaUltimaCotiCCICO,
            periodoUltimaCotizacion = ultimoPeriodoCotiCCICO
        WHERE indCotizacionUltimoMes = 1;

        --Actualiza el ingresoImponible
        UPDATE #UniversoRegistroTMP SET
            uac.ingresoImponible = uri.remuneracionImponible
        FROM #UniversoRegistroTMP uac
            JOIN #UniversoRemuneracionImponibleTMP uri ON (uac.idAfiliado = uri.idAfiliado)
        WHERE indCotizacionUltimoMes = 0;--Cambio para actulizar la renta solo para los que no tienen cotizaciones en el mes

        -------------------------------------------
        --REGIÓN
        -------------------------------------------
        --Actualiza el id de la DimRegion
        UPDATE #UniversoRegistroTMP SET 
            u.idRegion = dr.id
        FROM #UniversoRegistroTMP u
            JOIN DMGestion.DimComuna dco ON (u.idComuna = dco.id)
            JOIN DMGestion.DimCiudad dc ON (dco.idCiudad = dc.id)
            JOIN DMGestion.DimRegion dr ON (dc.idRegion  = dr.id);

        -------------------------------------------
        --AÑO AFILIACIÓN
        -------------------------------------------
        --Actualiza el id de la DimAnoAfiliacion
         UPDATE #UniversoRegistroTMP SET 
            u.idAnoAfiliacion = daa.id
        FROM #UniversoRegistroTMP u
            JOIN Circular1536.DimAnoAfiliacion daa ON (u.anoAfiliacion = daa.codigo)
        WHERE daa.fechaVigencia >= ldtMaximaFechaVigencia;

        -------------------------------------------
        --RANGO EDAD TRIMESTRAL
        -------------------------------------------
        --Actualiza el id de la DimRangoEdad, para el Grupo Rango Trimestral
        UPDATE #UniversoRegistroTMP SET 
            u.idRangoEdadTrimestral = dre.id
        FROM DMGestion.DimRangoEdad dre, #UniversoRegistroTMP u
        WHERE ((u.edadActuarial <= dre.termino AND u.edadActuarial > dre.inicio)
            OR (u.edadActuarial <= dre.termino AND dre.inicio IS NULL)
            OR (dre.termino IS NULL AND u.edadActuarial > dre.inicio))
        AND dre.codigoGrupo = 1 --Grupo Rango Trimestral
        AND dre.fechaVigencia >= ldtMaximaFechaVigencia;

        -------------------------------------------
        --RANGO EDAD ANUAL
        -------------------------------------------
        --Actualiza el id de la DimRangoEdad, para el Grupo Rango Anual
        UPDATE #UniversoRegistroTMP SET 
            u.idRangoEdadAnual = dre.id
        FROM DMGestion.DimRangoEdad dre, #UniversoRegistroTMP u
        WHERE ((u.edadActuarial <= dre.termino AND u.edadActuarial > dre.inicio)
            OR (u.edadActuarial <= dre.termino AND dre.inicio IS NULL)
            OR (dre.termino IS NULL AND u.edadActuarial > dre.inicio))
        AND dre.codigoGrupo = 2 --Grupo Rango anual
        AND dre.fechaVigencia >= ldtMaximaFechaVigencia;

        -------------------------------------------
        --EDAD TRIMESTRAL (UNITARIO)
        -------------------------------------------
        --Actualiza el id de la DimRangoEdad, para el Grupo Unitario Trimestral
        UPDATE #UniversoRegistroTMP SET 
            u.idEdadTrimestral = dre.id
        FROM DMGestion.DimRangoEdad dre, #UniversoRegistroTMP u
        WHERE ((u.edadActuarial = dre.termino AND u.edadActuarial = dre.inicio)
            OR (u.edadActuarial <= dre.termino AND dre.inicio IS NULL)
            OR (dre.termino IS NULL AND u.edadActuarial > dre.inicio))
        AND dre.codigoGrupo = 3 --Grupo Unitario Trimestral
        AND dre.fechaVigencia >= ldtMaximaFechaVigencia;

        -------------------------------------------
        --RANGO INGRESO IMPONIBLE
        -------------------------------------------
        --Actualiza el id de la DimRangoIngresoImponible
        UPDATE #UniversoRegistroTMP SET 
            u.idRangoIngresoImponible = drii.id
        FROM DMGestion.DimRangoIngresoImponible drii, #UniversoRegistroTMP u
        WHERE ((u.ingresoImponible <= drii.termino AND u.ingresoImponible > drii.inicio)
            OR (u.ingresoImponible <= drii.termino AND drii.inicio IS NULL)
            OR (drii.termino IS NULL AND u.ingresoImponible > drii.inicio))
        AND drii.codigoGrupo = '01' --RANGO CCICO o CCIAV
        AND drii.fechaVigencia >= ldtMaximaFechaVigencia;

        UPDATE #UniversoRegistroTMP --> INESP-523 <--
        SET idRangoIngresoImponible = dri.id
        FROM #UniversoRegistroTMP u
        INNER JOIN DMGestion.DimRangoIngresoImponible dri on (dri.termino = (SELECT MAX(TERMINO) FROM DMGestion.DimRangoIngresoImponible WHERE CodigoGrupo = cchCodigo01 AND fechaVigencia >= ldtMaximaFechaVigencia) and dri.Codigogrupo = cchCodigo01)
        WHERE u.ingresoImponible > dri.termino;
        
                
        -------------------------------------------
        --TOPE IMPONIBLE
        -------------------------------------------
        --Se obtiene los movimientos CAI del cotizante mes de la cuenta obligatoria
        SELECT DISTINCT fmc.idPersona
        INTO #UniversoCotizaronCAITMP
        FROM DMGestion.FctMovimientosCuenta fmc
            INNER JOIN DMGestion.DimGrupoMovimiento dgm ON (fmc.idGrupoMovimiento = dgm.id)
            INNER JOIN DMGestion.DimTipoProducto dtp ON (fmc.idTipoProducto = dtp.id)
            INNER JOIN #UniversoRegistroTMP u ON (fmc.idPersona = u.idAfiliado)
        WHERE fmc.idPeriodoInformado = linIdPeriodoInformar
        AND dtp.codigo = 3 --CAI 
        AND dgm.codigoSubgrupo IN (1101, 1105) --Grupo movimiento productos CAI
        AND fmc.periodoDevengRemuneracion = u.ultimoPeriodoCotiCCICO
        AND u.indCotizacionUltimoMes = 1; --Cotizante Mes CCICO

        --Se obtiene la ultima fecha del periodo de cotización
        SELECT periodoUltimaCotizacion, 
            DMGestion.obtenerUltimaFechaMes(periodoUltimaCotizacion) ultimaFechaMesPerCot
        INTO #UltimaFechaMesPerCotTMP
        FROM #UniversoRegistroTMP   
        WHERE indCotizacionUltimoMes IN (1, 2)--Cotizante Mes
        GROUP BY periodoUltimaCotizacion;

       
        SELECT u.idAfiliado,
            (CASE 
                WHEN ((u.fechaNacimiento IS NOT NULL) AND 
                      (u.fechaNacimiento < ufmpc.ultimaFechaMesPerCot)) THEN
                    CONVERT(BIGINT, (DATEDIFF(mm, u.fechaNacimiento, ufmpc.ultimaFechaMesPerCot)/12))
                ELSE 0
             END) edad
        INTO #UniversoEdadTMP
        FROM #UniversoRegistroTMP u
            INNER JOIN #UltimaFechaMesPerCotTMP ufmpc ON (u.periodoUltimaCotizacion = ufmpc.periodoUltimaCotizacion)
            LEFT OUTER JOIN #UniversoCotizaronCAITMP uccai ON (u.idAfiliado = uccai.idPersona)
        WHERE u.fechaNacimiento < ufmpc.ultimaFechaMesPerCot
        AND u.indCotizacionUltimoMes IN (1, 2)--Cotizante Mes
        AND uccai.idPersona IS NULL;

        --Actualiza el id de la DimTopeImponible - Monto en Pesos
        --Trabajador Casa Particular
        UPDATE #UniversoRegistroTMP SET 
            u.idTopeImponible = dti.id
        FROM #UniversoRegistroTMP u
            JOIN DMGestion.DimTopeImponible dti ON u.ingresoImponible = dti.monto
            JOIN #UniversoCotizaronCAITMP uccai ON u.idAfiliado = uccai.idPersona
        WHERE u.indCotizacionUltimoMes = 1 --Cotizante CCICO
        AND dti.codigo = '03' -- Ingreso mínimo (Trabajador casa particular)
        --AND dti.fechaVigencia >= ldtMaximaFechaVigencia;
       AND periodoUltimaCotizacion between fechaInicio and fechaTermino; 

      
      
        --Ingreso Mínimo (>=18 y <=65)
        UPDATE #UniversoRegistroTMP SET 
            u.idTopeImponible = dti.id
        FROM #UniversoRegistroTMP u
            JOIN DMGestion.DimTopeImponible dti ON (u.ingresoImponible = dti.monto)
            JOIN #UniversoEdadTMP ue ON (u.idAfiliado = ue.idAfiliado)
        WHERE u.indCotizacionUltimoMes IN (1, 2) --Cotizante Mes CCICO o CCIAV
        AND dti.codigo = '01' -- Ingreso mínimo (Trabajador casa particular)
        AND ue.edad BETWEEN 18 AND 65
        --AND dti.fechaVigencia >= ldtMaximaFechaVigencia;
        AND periodoUltimaCotizacion between fechaInicio and fechaTermino;
       
       
        --Ingreso Mínimo (<18 y >65)
        UPDATE #UniversoRegistroTMP SET 
            u.idTopeImponible = dti.id
        FROM #UniversoRegistroTMP u
            JOIN DMGestion.DimTopeImponible dti ON (u.ingresoImponible = dti.monto)
            JOIN #UniversoEdadTMP ue ON (u.idAfiliado = ue.idAfiliado)
        WHERE u.indCotizacionUltimoMes IN (1, 2) --Cotizante Mes CCICO o CCIAV
        AND dti.codigo = '02' -- Ingreso mínimo (Trabajador casa particular)
        AND (ue.edad < 18 OR ue.edad > 65)
        --AND dti.fechaVigencia >= ldtMaximaFechaVigencia;
        AND periodoUltimaCotizacion between fechaInicio and fechaTermino;

        --Se actualiza el campo tope Imponible de acuerdo a DimTopeImponible - Monto en UF
        SELECT dti.monto, dti.id
        INTO lnuValorTopeUF, ltiIdDimTopeImponible
        FROM DMGestion.DimTopeImponible dti
        WHERE dti.codigo = '04' -- Tope Imponible
        --AND dti.fechaVigencia >= ldtMaximaFechaVigencia
        AND ldtFechaPeriodoInformado BETWEEN dti.fechaInicio and dti.fechaTermino;

        SELECT periodoUltimaCotizacion, 
            CONVERT(BIGINT, ROUND((lnuValorTopeUF * DMGestion.obtenerValorUF(ultimaFechaMesPerCot)), 0)) rentaImponibleTope
        INTO #UniversoRentaImponibleTope
        FROM #UltimaFechaMesPerCotTMP;

       UPDATE #UniversoRegistroTMP SET 
            u.idTopeImponible = ltiIdDimTopeImponible
        FROM #UniversoRegistroTMP u
           JOIN #UniversoRentaImponibleTope urit ON (u.periodoUltimaCotizacion = urit.periodoUltimaCotizacion)
        WHERE u.indCotizacionUltimoMes IN (1, 2) --Cotizante Mes CCICO o CCIAV
        AND u.ingresoImponible >= urit.rentaImponibleTope;

        -------------------------------------------
        --RANGO MESES SIN MOVIMIENTO
        -------------------------------------------
        --Actualiza el id de la DimRangoMesesMovimiento
        UPDATE #UniversoRegistroTMP SET 
            u.idRangoMesesMovimiento = drmm.id
        FROM Circular1536.DimRangoMesesMovimiento drmm, #UniversoRegistroTMP u
        WHERE ((u.mesesSinmovimiento <= drmm.termino AND u.mesesSinmovimiento >= drmm.inicio)
            OR (u.mesesSinmovimiento <= drmm.termino AND drmm.inicio IS NULL)
            OR (drmm.termino IS NULL AND u.mesesSinmovimiento >= drmm.inicio))
        AND drmm.fechaVigencia >= ldtMaximaFechaVigencia;

        -------------------------------------------
        --DENSIDAD COTIZACIÓN
        -------------------------------------------
        --Actualiza la densidad de cotización
        UPDATE #UniversoRegistroTMP SET 
            densidadCotizacion = (CASE
                                     WHEN fechaAfiliacionSistema IS NULL THEN
                                        CONVERT(NUMERIC(4, 3), 0.000)
                                     WHEN (DATEDIFF(mm, fechaAfiliacionSistema, ldtFechaPeriodoInformado) <= 0) THEN
                                        CONVERT(NUMERIC(4, 3), 0.000)
                                     WHEN ROUND(CONVERT(NUMERIC(4, 0), totalMesesCotizadosCCICO) / CONVERT(NUMERIC(4, 0), (DATEDIFF(mm, fechaAfiliacionSistema, ldtFechaPeriodoInformado))), 3) >= 10 THEN
                                        CONVERT(NUMERIC(4, 3), 0.000)
                                     ELSE
                                        CONVERT(NUMERIC(4, 3), 
                                                ROUND(CONVERT(NUMERIC(4, 0), totalMesesCotizadosCCICO) / 
                                                      CONVERT(NUMERIC(4, 0), (DATEDIFF(mm, fechaAfiliacionSistema, ldtFechaPeriodoInformado))), 3))
                                  END);

        --Actualiza el id de la DimRangoDensidadCotizacion
        UPDATE #UniversoRegistroTMP SET 
            u.idRangoDensidadCotizacion = drdc.id
        FROM Circular1536.DimRangoDensidadCotizacion drdc, #UniversoRegistroTMP u
        WHERE ((u.densidadCotizacion < drdc.termino AND u.densidadCotizacion >= drdc.inicio)
            OR (u.densidadCotizacion <= drdc.termino AND drdc.inicio IS NULL)
            OR (drdc.termino IS NULL AND u.densidadCotizacion >= drdc.inicio))
        AND drdc.fechaVigencia >= ldtMaximaFechaVigencia;

        -------------------------------------------
        --RANGO INGRESO IMPONIBLE CAI
        -------------------------------------------
        SELECT u.idAfiliado,
            MAX(periodoDevengRemuneracion) periodoDevengRemuneracion,
            SUM(fmc.remuneracionImponible) remuneracionImponible
        INTO #UniversoIngresoImponibleCAITMP
        FROM DMGestion.FctMovimientosCuenta fmc
            INNER JOIN DMGestion.DimPersona dp ON (fmc.idPersona =  dp.id)
            INNER JOIN DMGestion.DimGrupoMovimiento dgm ON (fmc.idGrupoMovimiento = dgm.id)
            INNER JOIN DMGestion.DimTipoProducto dtp ON (fmc.idTipoProducto = dtp.id)
            INNER JOIN #UniversoRegistroTMP u ON (dp.rut = u.rutAfiliado)
        WHERE fmc.idPeriodoInformado = linIdPeriodoInformar
        AND dtp.codigo = 3 --CAI
        AND dgm.codigoSubgrupo IN (1101, 1105)
        AND fmc.fechaOperacion BETWEEN ldtFechaPeriodoInformado AND ldtUltimaFechaMesInformado
        AND fmc.periodoDevengRemuneracion IN (ldtPeriodoCotizacion, ldtFechaPeriodoInformado)
        AND fmc.montoPesos > 0
        GROUP BY u.idAfiliado;

        --Se obtiene la ultimo dia del mes, correspondiente al periodo de cotización y el valor de
        --la UF
        SELECT DISTINCT u.periodoDevengRemuneracion,
            (DATE(DATEFORMAT(u.periodoDevengRemuneracion,'YYYYMM') + convert(char(2), 
             DATEPART(dd,(DATEADD(ms,-3,DATEADD(mm, DATEDIFF(mm,DATE('1900-01-01'), 
             u.periodoDevengRemuneracion)+1,DATE('1900-01-01')))))))
            ) ultimoDiaMes,
            vvu.valorUF,
            CONVERT(NUMERIC(5, 2), 90.0) valorTopeImponible --Cambiar por parametros
        INTO #TopeRentaImponibleCAITMP
        FROM #UniversoIngresoImponibleCAITMP u
            INNER JOIN DMGestion.VistaValorUF vvu ON (vvu.fechaUF = ultimoDiaMes)
        WHERE vvu.ultimoDiaMes = 'S';

        --Se topa la Renta Imponible
        UPDATE #UniversoIngresoImponibleCAITMP SET
            u.remuneracionImponible = (CASE
                                            WHEN (u.remuneracionImponible > ROUND((tri.valorUF * tri.valorTopeImponible), 0)) THEN
                                                ROUND((tri.valorUF * tri.valorTopeImponible), 0)
                                            ELSE
                                                u.remuneracionImponible
                                         END) 
        FROM #UniversoIngresoImponibleCAITMP u
            JOIN #TopeRentaImponibleCAITMP tri ON (u.periodoDevengRemuneracion = tri.periodoDevengRemuneracion);

        DROP TABLE #TopeRentaImponibleCAITMP;

        --Actualiza el ingresoImponible de la CAI
        UPDATE #UniversoRegistroTMP SET
            uac.ingresoImponibleCAI = u.remuneracionImponible,
            uac.indCotizacionUltimoMesCAI = 1
        FROM #UniversoRegistroTMP uac
            JOIN #UniversoIngresoImponibleCAITMP u ON (uac.idAfiliado = u.idAfiliado);

        DROP TABLE #UniversoIngresoImponibleCAITMP;

        --Actualiza el id de la DimRangoIngresoImponibleCAI
        UPDATE #UniversoRegistroTMP SET 
            u.idRangoIngresoImponibleCAI = drii.id
        FROM DMGestion.DimRangoIngresoImponible drii, #UniversoRegistroTMP u
        WHERE ((u.ingresoImponibleCAI <= drii.termino AND u.ingresoImponibleCAI > drii.inicio)
            OR (u.ingresoImponibleCAI <= drii.termino AND drii.inicio IS NULL)
            OR (drii.termino IS NULL AND u.ingresoImponibleCAI > drii.inicio))
        AND drii.codigoGrupo = '02' --RANGO CAI
        AND drii.fechaVigencia >= ldtMaximaFechaVigencia;
       
        UPDATE #UniversoRegistroTMP --> INESP-523 <--
        SET idRangoIngresoImponibleCAI = dri.id
        FROM #UniversoRegistroTMP u
        INNER JOIN DMGestion.DimRangoIngresoImponible dri on (dri.termino = (SELECT MAX(TERMINO) FROM DMGestion.DimRangoIngresoImponible WHERE CodigoGrupo = cchCodigo02 AND fechaVigencia >= ldtMaximaFechaVigencia) and dri.Codigogrupo = cchCodigo02)
        WHERE u.ingresoImponibleCAI > dri.termino;

        -------------------------------------------
        --GENERACIÓN DE NÚMERO DE FILA
        -------------------------------------------
        UPDATE #UniversoRegistroTMP a SET
            numeroFila = ROWID(a);

        -------------------------------------------
        --MANEJO DE ERRORES
        -------------------------------------------
        CREATE TABLE #UniversoErrores(
            idError             BIGINT          NULL,
            numeroFila          BIGINT          NOT NULL,
            nombreColumna       VARCHAR(50)     NOT NULL,
            tipoError           CHAR(1)         NOT NULL,
            idCodigoError       BIGINT          NOT NULL,
            descripcionError    VARCHAR(500)    NOT NULL,
            registroInformar    CHAR(1)         NULL
         );

        --Error de inconsistencia código control, tipo rol persona
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError, registroInformar)
        SELECT u.numeroFila,
            'idTipoControl' nombreColumna,
            'I' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ''Persona'' y Código Tipo Control = ' || u.codigoTipoControl) descripcionError,
            CONVERT(CHAR(1), 'N') registroInformar
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1430')
        WHERE u.codigoTipoControl NOT IN ('AVP', 'AVV', 'PRV', 'VAL')
        AND u.codigoTipoRol = 1; --Tipo rol Persona

        --Error de inconsistencia código control, tipo rol cliente
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError, registroInformar)
        SELECT u.numeroFila,
            'codigoTipoControl' nombreColumna,
            'I' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ''Cliente'' y Código Tipo Control = ' || u.codigoTipoControl) descripcionError,
            CONVERT(CHAR(1), 'N') registroInformar
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1430')
        WHERE u.codigoTipoControl IN ('AVP', 'AVV', 'PRV', 'VAL')
        AND u.codigoTipoRol = 7; --Tipo rol Cliente

        --Error de inconsistencia, Tipo Rol Persona, fecha de afiliación al sistema con valor NULO
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError, registroInformar)
        SELECT u.numeroFila,
            'fechaAfiliacionSistema' nombreColumna,
            'I' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ''Persona''') descripcionError,
            CONVERT(CHAR(1), 'N') registroInformar
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1431')
        WHERE u.fechaAfiliacionSistema IS NULL
        AND u.codigoTipoRol = 1; --Tipo rol Persona

        --Error de inconsistencia con observación, Tipo Rol Persona, fecha de afiliación al sistema menor a 01/05/1981
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
        SELECT u.numeroFila,
            'fechaAfiliacionSistema' nombreColumna,
            'O' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ''Persona'' y fecha de afiliación al sistema = ' || u.fechaAfiliacionSistema) descripcionError
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1010')
        WHERE u.fechaAfiliacionSistema < DATE('1981-05-01')
        AND u.codigoTipoRol = 1; --Tipo rol Persona

        --Error de inconsistencia con observación, Tipo Rol Persona, fecha de afiliación es mayor al periodo a informar
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
        SELECT u.numeroFila,
            'fechaAfiliacionSistema' nombreColumna,
            'O' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ''Persona'' y fecha de afiliación al sistema = ' || u.fechaAfiliacionSistema) descripcionError
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1011')
        WHERE u.fechaAfiliacionSistema > ldtUltimaFechaMesInformado
        AND u.codigoTipoRol = 1; --Tipo rol Persona

        --Error de inconsistencia, Tipo Rol Persona, fecha de incorporación a la A.F.P. con valor NULO
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError, registroInformar)
        SELECT u.numeroFila,
            'fechaIncorporacionAFP' nombreColumna,
            'I' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ''Persona''') descripcionError,
            CONVERT(CHAR(1), 'N') registroInformar
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1432')
        WHERE u.fechaIncorporacionAFP IS NULL
        AND u.codigoTipoRol = 1; --Tipo rol Persona

        --Error de inconsistencia con observación, Tipo Rol Persona, fecha de incorporación a la A.F.P. menor a 01/05/1981
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
        SELECT u.numeroFila,
            'fechaIncorporacionAFP' nombreColumna,
            'O' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ''Persona'' y fecha de incorporación a la A.F.P. = ' || u.fechaIncorporacionAFP) descripcionError
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1012')
        WHERE u.fechaIncorporacionAFP < DATE('1981-05-01')
        AND u.codigoTipoRol = 1; --Tipo rol Persona

        --Error de inconsistencia con observación, Tipo Rol Persona, fecha de incorporación a la A.F.P. mayor al periodo a informar
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
        SELECT u.numeroFila,
            'fechaIncorporacionAFP' nombreColumna,
            'O' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ''Persona'' y fecha de incorporación a la A.F.P. = ' || u.fechaIncorporacionAFP) descripcionError
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1013')
        WHERE u.fechaIncorporacionAFP > ldtUltimaFechaMesInformado
        AND u.codigoTipoRol = 1; --Tipo rol Persona

        --Error de inconsistencia con observación, fecha de nacimiento con valor NULO
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
        SELECT u.numeroFila,
            'fechaNacimiento' nombreColumna,
            'O' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ' || 
            (CASE codigoTipoRol 
                WHEN 1 THEN '''Persona''' 
                ELSE '''Cliente''' 
             END)) descripcionError
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1433')
        WHERE u.fechaNacimiento IS NULL;

        --Error de inconsistencia con observación, fecha de nacimiento mayor al periodo a informar
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
        SELECT u.numeroFila,
            'fechaNacimiento' nombreColumna,
            'O' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ' || 
            (CASE codigoTipoRol 
                WHEN 1 THEN '''Persona''' 
                ELSE '''Cliente''' 
             END) ||
            ' y fecha de nacimiento = ' || u.fechaNacimiento) descripcionError
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1434')
        WHERE u.fechaNacimiento > ldtFechaPeriodoInformado;

        --Error de inconsistencia, Personas sin cuenta asociada
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError, registroInformar)
        SELECT u.numeroFila,
            'codigoTipoProducto' nombreColumna,
            'I' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ' || 
            (CASE codigoTipoRol 
                WHEN 1 THEN '''Persona''' 
                ELSE '''Cliente''' 
             END)) descripcionError,
            CONVERT(CHAR(1), 'N') registroInformar
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1435')
        WHERE u.idAfiliado NOT IN (SELECT idAfiliado 
                                   FROM #UniversoProductosAsociadosTMP);

        --Error de inconsistencia, Afiliados Activo sin cuenta asociada (CCICO o CCIAV)
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError, registroInformar)
        SELECT u.numeroFila,
            'codigoTipoProducto' nombreColumna,
            'I' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ''Persona'' y tipo estado rol = ' ||
             (CASE u.codigoTipoEstadoRol
                WHEN 1 THEN '''Afiliado'''
                WHEN 2 THEN '''Pensionado'''
                WHEN 4 THEN '''Fallecido'''
              END)) descripcionError,
            CONVERT(CHAR(1), 'N') registroInformar
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1436')
        WHERE UPPER(u.tipoAfiliado) = 'ACTIVO'
        AND u.idAfiliado NOT IN (SELECT idAfiliado 
                                 FROM #UniversoProductosAsociadosTMP      
                                 WHERE codigoTipoProducto IN (1, 6)); --CCICO o CCIAV

        --Error de inconsistencia con observación, sexo con valor NULO
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
        SELECT u.numeroFila,
            'sexo' nombreColumna,
            'O' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ' || 
            (CASE codigoTipoRol 
                WHEN 1 THEN '''Persona''' 
                ELSE '''Cliente''' 
             END)) descripcionError
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1418')
        WHERE u.sexo IS NULL;
        
        --Error de inconsistencia con observación, sexo con valor BLANCO
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
        SELECT u.numeroFila,
            'sexo' nombreColumna,
            'O' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ' || 
            (CASE codigoTipoRol 
                WHEN 1 THEN '''Persona''' 
                ELSE '''Cliente''' 
             END)) descripcionError
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1419')
        WHERE TRIM(u.sexo) = '';

        --Error de inconsistencia con observación, código de actividad económica con valor NULO
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
        SELECT u.numeroFila,
            'idActividadEconomica' nombreColumna,
            'O' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ''Persona'', sin actividad económica de su empleador.') descripcionError
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.DimTipoCotizante dtc ON(u.idTipoCotizante = dtc.id)
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1437')
        WHERE UPPER(u.tipoAfiliado) = 'ACTIVO'
        AND dtc.codigo != '04' --Distinto de Voluntario
        AND u.idActividadEconomica = 0;

        --Error de inconsistencia con observación, tipo cotizante con valor '00'
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
        SELECT u.numeroFila,
            'idTipoCotizante' nombreColumna,
            'O' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ' || 
            (CASE codigoTipoRol 
                WHEN 1 THEN '''Persona''' 
                ELSE '''Cliente''' 
             END) ||
            ', serán clasificados como ''Dependientes''.') descripcionError
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.DimTipoCotizante dtc ON(u.idTipoCotizante = dtc.id)
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1438')
        WHERE dtc.codigo = '00';

        --Error de inconsistencia con observación, código de región con valor NULO
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
        SELECT u.numeroFila,
            'idRegion' nombreColumna,
            'O' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ' || 
            (CASE codigoTipoRol 
                WHEN 1 THEN '''Persona''' 
                ELSE '''Cliente''' 
             END)) descripcionError
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1439')
        WHERE u.idRegion = 0; --Sin Clasificar

        --Error de inconsistencia con observación, renta imponible con valor CERO o NULO
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
        SELECT u.numeroFila,
            'ingresoImponible' nombreColumna,
            'O' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ' || 
            (CASE codigoTipoRol 
                WHEN 1 THEN '''Persona''' 
                ELSE '''Cliente''' 
             END) ||
            ', serán clasificados en el primer rango del ingreso imponible ''+0 - 20''') descripcionError
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1253')
        WHERE u.indCotizacionUltimoMes IN (1, 2)--Cotizante Mes
        AND u.ingresoImponible <= 0; 

        --Error de inconsistencia con observación, renta imponible con valor CERO o NULO
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
        SELECT u.numeroFila,
            'ingresoImponibleCAI' nombreColumna,
            'O' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || ' con tipo rol ' || 
            (CASE codigoTipoRol 
                WHEN 1 THEN '''Persona''' 
                ELSE '''Cliente''' 
             END) ||
            ', serán clasificados en el primer rango del ingreso imponible ''+0 - 20''') descripcionError
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1253')
        WHERE u.indCotizacionUltimoMesCAI = 1 --Tienen CAI
        AND u.ingresoImponibleCAI <= 0; 

        --Error de inconsistencia con observación, No registra cotizaciones para el producto CCICO
        INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
        SELECT u.numeroFila,
            'periodoCotizacion' nombreColumna,
            'O' tipoError,
             ce.id idCodigoError, 
            ('RUT = ' || u.rutAfiliado || '') descripcionError
        FROM #UniversoRegistroTMP u
            INNER JOIN DMGestion.DimTipoCotizante dtc ON(u.idTipoCotizante = dtc.id)
            INNER JOIN DMGestion.CodigoError ce ON (ce.codigo = '1440')
        WHERE UPPER(u.tipoAfiliado) = 'ACTIVO'
        AND dtc.codigo IN ('00')
        AND u.codigoTipoRol = 1 --Tipo rol Persona
        AND u.ultimoPeriodoCotiCCICO IS NULL;

        INSERT INTO DMGestion.ErrorCarga(idPeriodoInformado, procesoCarga, fechaCarga, nombreTabla, numeroRegistro)
        SELECT DISTINCT linIdPeriodoInformar, cstNombreProcedimiento, getDate(), cstNombreTablaFct, numeroFila
        FROM #UniversoErrores;

        --Se agrega el idError al universo de errores
        UPDATE #UniversoErrores ue SET
            ue.idError = ec.id
        FROM DMGestion.ErrorCarga ec 
        WHERE ue.numeroFila = ec.numeroRegistro
        AND ec.procesoCarga = cstNombreProcedimiento
        AND ec.nombreTabla = cstNombreTablaFct
        AND ec.idPeriodoInformado = linIdPeriodoInformar;

        --Se registra el detalle del error
        INSERT INTO DMGestion.DetalleErrorCarga(idError, nombreColumna, tipoError, idCodigoError, descripcion)
        SELECT ue.idError, ue.nombreColumna, ue.tipoError, ue.idCodigoError, ue.descripcionError 
        FROM #UniversoErrores ue;

        --Actualiza el idError en el universo a registrar
        UPDATE #UniversoRegistroTMP SET
            ur.idError = ue.idError
        FROM #UniversoErrores ue
            JOIN #UniversoRegistroTMP ur ON (ue.numeroFila = ur.numeroFila);

        UPDATE #UniversoRegistroTMP SET
            ur.registroInformar = ue.registroInformar
        FROM #UniversoRegistroTMP ur
            JOIN #UniversoErrores ue ON (ur.numeroFila = ue.numeroFila)
        WHERE ue.registroInformar = 'N';

        DROP TABLE #UniversoErrores;
        --Fin Manejo Errores

        -------------------------------------------
        --TIPO COTIZANTE (NO CORRESPONDE INFORMAR)
        -------------------------------------------
        --Existen casos para los afiliados que tienen tipo cotizante '00', ya que no existen movimientos para determinarlos.
        --Se asume que son Dependientes
        UPDATE #UniversoRegistroTMP SET
            u.idTipoCotizante = ltiIdTipoCotizanteDependiente
        FROM #UniversoRegistroTMP u
            JOIN DMGestion.DimTipoCotizante dtc ON (u.idTipoCotizante = dtc.id)
        WHERE (UPPER(u.tipoAfiliado) IN ('ACTIVO', 'PASIVO') AND dtc.codigo = '00') or UPPER(u.tipoAfiliado) = ('CLIENTE');

        -----------------------------------------------
        --RANGO INGRESO IMPONIBLE (SIN RANGO)
        -----------------------------------------------
        --Si la remuneración imponible es menor o igual a cero, se deja por defecto en el primer rango dela remuneración imponible.
        UPDATE #UniversoRegistroTMP SET
            idRangoIngresoImponible = ltiIdRangoIngresoImponiblePrimerRangoCCICO
        WHERE indCotizacionUltimoMes IN (1, 2) --Cotizante Mes
        AND ingresoImponible <= 0;

        UPDATE #UniversoRegistroTMP SET
            idRangoIngresoImponibleCAI = ltiIdRangoIngresoImponiblePrimerRangoCAI
        WHERE indCotizacionUltimoMesCAI = 1 --Tienen CAI
        AND ingresoImponibleCAI <= 0;

        INSERT INTO Circular1536.FctAfiliadoCotizante(idPeriodoInformado,
            idAfiliado,
            idRegion,
            idAnoAfiliacion,
            idTipoCotizante,
            idRangoEdadTrimestral,
            idRangoEdadAnual,
            idEdadTrimestral,
            idRangoMesesMovimiento,
            idRangoIngresoImponible,
            idTopeImponible,
            idActividadEconomica,
            idTipoCobertura,
            idRangoDensidadCotizacion,
            idRangoIngresoImponibleCAI,
            indCotizacionUltimoMes,
            indCotizacionUltimoMesCAI,
            tipoAfiliado,
            ingresoImponible,
            ingresoImponibleCAI,
            edadActuarial,
            mesesSinMovimiento,
            totalMesesCotizadosCCICO,
            fechaAfiliacionSistema,
            fechaIncorporacionAFP,
            fechaUltimaCotizacion,
            periodoUltimaCotizacion,
            densidadCotizacion,
            registroInformar,
            numeroFila,
            idError,
            idEmpleador)
        SELECT idPeriodoInformado,
            idAfiliado,
            idRegion,
            idAnoAfiliacion,
            idTipoCotizante,
            idRangoEdadTrimestral,
            idRangoEdadAnual,
            idEdadTrimestral,
            idRangoMesesMovimiento,
            idRangoIngresoImponible,
            idTopeImponible,
            idActividadEconomica,
            idTipoCobertura,
            idRangoDensidadCotizacion,
            idRangoIngresoImponibleCAI,
            indCotizacionUltimoMes,
            indCotizacionUltimoMesCAI,
            tipoAfiliado,
            ingresoImponible,
            ingresoImponibleCAI,
            edadActuarial,
            mesesSinMovimiento,
            totalMesesCotizadosCCICO,
            fechaAfiliacionSistema,
            fechaIncorporacionAFP,
            fechaUltimaCotizacion,
            periodoUltimaCotizacion,
            densidadCotizacion,
            registroInformar,
            numeroFila,
            idError,
            idEmpleador
        FROM #UniversoRegistroTMP;

        -----------------------------
        --Datos de Auditoria FctAfiliadosCotizantes
        -----------------------------
        --Se registra datos de auditoria
        SELECT COUNT(*) 
        INTO lbiCantidadRegistrosInformados
        FROM #UniversoRegistroTMP;

        ------------------------------------------------
        --Datos de Auditoria
        ------------------------------------------------
        CALL Circular1536.registrarAuditoriaDM(ldtFechaPeriodoInformado,
                                               cstTipoProceso, 
                                               cstNombreProcedimiento, 
                                               cstNombreTablaFct, 
                                               ldtFechaInicioCarga);

        COMMIT;
        SAVEPOINT;
        SET codigoError = '0';

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