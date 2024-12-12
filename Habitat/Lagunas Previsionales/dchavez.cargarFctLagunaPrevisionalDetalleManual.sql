ALTER  PROCEDURE dchavez.cargarFctLagunaPrevisionalDetalleManual(IN periodoInformar date,OUT codigoError VARCHAR(10))
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
    
    
    DELETE FROM dchavez.FctLagunaPrevisionalDetalle WHERE idPeriodoInformado = linIdPeriodoInformar;


    IF (EXISTS (SELECT 1 FROM SYSCATALOG WHERE tname = 'periodoCotizadosTMP' AND creator = 'dchavez')) THEN
            DROP TABLE dchavez.periodoCotizadosTMP;
    END IF;

    CREATE TABLE   dchavez.periodoCotizadosTMP (
        rut bigint NOT NULL,
        fechaAfiliacionSistema date NOT NULL,
        ClasificacionPersona varchar(50) NOT NULL,
        periodo date NOT NULL,
        per_cot date NULL,
        indLicenciaMedica char(2) NULL,
        perAnterior date NULL,
        perSiguiente date NULL,
        InicioLaguna char(2)  NULL,
        TerminoLaguna char(2)  NULL
    );
    CREATE DATE INDEX DATE_periodoCotizadostmp_01 ON dchavez.periodoCotizadosTMP (periodo);
    CREATE DATE INDEX DATE_periodoCotizadostmp_02 ON dchavez.periodoCotizadosTMP (per_cot);
    CREATE HG INDEX HG_periodocotizadotmp_01 ON dchavez.periodoCotizadosTMP (rut);
    CREATE HG INDEX HG_periodocotizadotmp_02 ON dchavez.periodoCotizadosTMP (InicioLaguna);
    CREATE HG INDEX HG_periodocotizadotmp_03 ON dchavez.periodoCotizadosTMP (TerminoLaguna);

    IF (EXISTS (SELECT 1 FROM SYSCATALOG WHERE tname = 'licenciasMedicasTMP' AND creator = 'dchavez')) THEN
            DROP TABLE dchavez.licenciasMedicasTMP;
    END IF;

    CREATE TABLE dchavez.licenciasMedicasTMP (
        rut int NULL,
        FEC_DESDE date NULL,
        FEC_HASTA date NULL,
        periodoInicio date NULL,
        periodoTermino date NULL
    );
    CREATE INDEX DATE_licenciasMedicasTMP_01 ON habitat.dchavez.licenciasMedicasTMP (periodoInicio);
    CREATE INDEX DATE_licenciasMedicasTMP_02 ON habitat.dchavez.licenciasMedicasTMP (periodoTermino);
    CREATE INDEX HG_licenciasMedicasTMP_01 ON habitat.dchavez.licenciasMedicasTMP (rut);

    CREATE TABLE #universoFinal (
        periodoInformado date,
        rut bigint NOT NULL,
        fechaAfiliacionSistema date NOT NULL,
        ClasificacionPersona varchar(50) NOT NULL,
        fechaInicioLaguna date  NULL,
        fechaTerminoLaguna date  NULL,
        nroMesesLaguna integer NULL,
        orden bigint NULL,
        nroMesesAbonoCAV INTEGER NULL,
        montoTotalPesosAbonoCAV BIGINT NULL,
        nroMesesAbonoCCICV INTEGER NULL,
        montoTotalPesosAbonoCCICV BIGINT NULL,
        nroMesesAbonoCCIDC INTEGER NULL,
        montoTotalPesosAbonoCCIDC BIGINT NULL,
        nroMesesAbonoProdVoluntario INTEGER NULL,
        indVigenciaUltimaLAguna char(2) null
        );
    CREATE HG INDEX HG_universoFinal_01 ON #universoFinal (rut);
    CREATE date INDEX DT_universoFinal_02 ON #universoFinal (fechaInicioLaguna);
    CREATE date INDEX DT_universoFinal_03 ON #universoFinal (fechaTerminoLaguna);



    INSERT INTO dchavez.periodoCotizadosTMP
    (rut,fechaAfiliacionSistema,ClasificacionPersona,periodo, per_cot)
    SELECT DISTINCT rut, fechaAfiliacionSistema, ClasificacionPersona, periodo , per_cot
    FROM dchavez.UniversoPeriodoCotizadosTMP;


    INSERT INTO dchavez.licenciasMedicasTMP
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


    UPDATE  dchavez.periodoCotizadosTMP 
    SET indLicenciaMedica = 'Si'
    ,per_cot = '1900-01-01'
    FROM dchavez.periodoCotizadosTMP a
        INNER JOIN dchavez.licenciasMedicasTMP B ON A.periodo = B.periodoInicio AND a.rut = b.rut
    WHERE a.per_cot IS NULL;
    
    
    UPDATE  dchavez.periodoCotizadosTMP 
    SET indLicenciaMedica = 'Si'
    ,per_cot = '1900-01-01'
    FROM dchavez.periodoCotizadosTMP a
        INNER JOIN dchavez.licenciasMedicasTMP B ON A.periodo = B.periodoTermino AND a.rut = b.rut
    WHERE a.per_cot IS NULL;


    ----PERIODO ANTERIOR--------
    SELECT DISTINCT rut,periodo, perAnterior 
    INTO #anterior
        from
        (SELECT rut,periodo, 
            LAG(per_cot) OVER (PARTITION BY rut ORDER BY periodo) perAnterior
        FROM dchavez.periodoCotizadosTMP a)u
        WHERE perAnterior IS NOT NULL ;
    
    UPDATE dchavez.periodoCotizadosTMP
    SET perAnterior = b.perAnterior
    FROM dchavez.periodoCotizadosTMP a
    INNER JOIN #anterior b ON a.rut = b.rut AND a.periodo = b.periodo;

    DROP TABLE #anterior;
    
    ----PERIODO SIGUIENTE--------
    SELECT DISTINCT rut,periodo, perSiguiente 
    INTO #siguiente
        from
        (SELECT rut,periodo, 
            LEAD(per_cot) OVER (PARTITION BY rut ORDER BY periodo) perSiguiente
        FROM dchavez.periodoCotizadosTMP a)u
        WHERE perSiguiente IS NOT NULL ;
    
    UPDATE dchavez.periodoCotizadosTMP
    SET perSiguiente = b.perSiguiente
    FROM dchavez.periodoCotizadosTMP a
    INNER JOIN #siguiente b ON a.rut = b.rut AND a.periodo = b.periodo;
    
    DROP TABLE #siguiente;
    -----------------------------------------------------------------------------------------

    UPDATE dchavez.periodoCotizadosTMP
    SET InicioLaguna = CASE WHEN (PER_COT IS NULL AND perAnterior IS NOT NULL) THEN 'Si' ELSE 'No' END,
    TerminoLaguna = CASE WHEN (PER_COT IS NULL AND perSiguiente IS NOT NULL) THEN 'Si' ELSE 'No' END;


    SELECT RUT, MIN(periodo) primerPeriodo
    INTO #primerPeriodo
    FROM dchavez.periodoCotizadosTMP
    GROUP BY RUT;
    
    
    UPDATE dchavez.periodoCotizadosTMP
    SET InicioLaguna = 'Si'
    FROM dchavez.periodoCotizadosTMP A
        INNER JOIN #primerPeriodo b ON a.rut=b.rut AND a.periodo = b.primerPeriodo
    WHERE per_cot IS NULL;
    
    DROP TABLE #primerPeriodo;
    
    
    INSERT INTO  #universoFinal
    (periodoInformado,rut,fechaAfiliacionSistema,ClasificacionPersona,fechaInicioLaguna,orden)
    SELECT ldtFechaPeriodoInformado,rut, fechaAfiliacionSistema, ClasificacionPersona, periodo,   
        DENSE_RANK ()OVER (PARTITION BY rut ORDER BY rut,periodo)orden
    FROM dchavez.periodoCotizadosTMP
    WHERE  InicioLaguna = 'Si';
    
    
    SELECT rut, periodo,   
    DENSE_RANK ()OVER (PARTITION BY rut ORDER BY rut,periodo)orden
    INTO #FinLaguna
    FROM dchavez.periodoCotizadosTMP
    WHERE  TerminoLaguna = 'Si';
    
    
    UPDATE #universoFinal
    SET fechaTerminoLaguna = B.periodo
    FROM #universoFinal a
        INNER JOIN #FinLaguna b ON a.rut = b.rut AND a.orden = b.orden;
    
    DROP TABLE #FinLaguna;
    
    UPDATE  #universoFinal
    SET nroMesesLaguna = DATEDIFF(mm,fechaInicioLaguna,ISnull(fechaTerminoLaguna,ldtFechaPeriodoInformado))+1 ;

    ----PRODUCTOS VOLUNTARIOS

    SELECT  dp.rut,dgm.nombreGrupo,dgm.nombreSubgrupo ,sum(montoPesos)totalPesos,dtp.codigo,dtp.nombreCorto , COUNT(DISTINCT periodoDevengRemuneracion) totalMeses,fl.fechaInicioLaguna,fl.fechaTerminoLaguna,fl.nroLaguna
    INTO #productosVoluntarios
    FROM DMGestion.FctMovimientosCuenta fmc 
    INNER JOIN DMGestion.DimPeriodoInformado dpi ON dpi.id = fmc.idPeriodoInformado 
    INNER JOIN DMGestion.DimPersona dp ON dp.id = fmc.idPersona 
    INNER JOIN DMGestion.DimGrupoMovimiento dgm ON dgm.id = fmc.idGrupoMovimiento 
    INNER JOIN DMGestion.DimTipoProducto dtp ON dtp.id = CASE WHEN fmc.idTipoProducto = 10 THEN 2 ELSE fmc.idTipoProducto END 
    INNER JOIN (SELECT rut,fl.fechaInicioLaguna ,isnull(fechaTerminoLaguna,date('2024-08-01'))fechaTerminoLaguna,fl.orden AS nroLaguna
                FROM #universoFinal fl
                ) fl ON fl.rut = dp.rut 
    WHERE dtp.codigo IN (2,4,5,10)
        --AND dp.rut = 10398097
        AND periodoDevengRemuneracion BETWEEN fl.fechaInicioLaguna  AND fl.fechaTerminoLaguna 
        AND dgm.tipoMovimiento = 'Abonos'
        AND nombreSubgrupo = 'Cotizaciones'
        AND nombreGrupo = 'Cotizaciones y Depósitos'
    GROUP BY dp.rut,nombreGrupo,dgm.nombreSubgrupo,dtp.codigo,dtp.nombreCorto,fl.fechaInicioLaguna,fl.fechaTerminoLaguna,nroLaguna;

    UPDATE #universoFinal
    SET nroMesesAbonoCCIDC = vl.totalMeses,
    montoTotalPesosAbonoCCIDC = vl.totalPesos
    FROM #universoFinal fl
    INNER JOIN #productosVoluntarios vl ON fl.orden = vl.nroLaguna
        AND fl.rut = vl.rut
        AND vl.codigo = 5; --CCIDC

    UPDATE #universoFinal
    SET nroMesesAbonoCAV = vl.totalMeses,
    montoTotalPesosAbonoCAV = vl.totalPesos
    FROM #universoFinal fl
    INNER JOIN #productosVoluntarios vl ON fl.orden = vl.nroLaguna
        AND fl.rut = vl.rut
        AND vl.codigo = 2;--CAV

    UPDATE #universoFinal
    SET nroMesesAbonoCCICV = vl.totalMeses,
    montoTotalPesosAbonoCCICV = vl.totalPesos
    FROM #universoFinal fl
    INNER JOIN #productosVoluntarios vl ON fl.orden = vl.nroLaguna
        AND fl.rut = vl.rut
        AND vl.codigo = 4;--CCICV

    ----Total Voluntario sin producto
    SELECT  dp.rut, COUNT(DISTINCT periodoDevengRemuneracion) totalMeses,nroLaguna
        INTO  #totalVoluntarios
    FROM DMGestion.FctMovimientosCuenta fmc 
    INNER JOIN DMGestion.DimPeriodoInformado dpi ON dpi.id = fmc.idPeriodoInformado 
    INNER JOIN DMGestion.DimPersona dp ON dp.id = fmc.idPersona 
    INNER JOIN DMGestion.DimGrupoMovimiento dgm ON dgm.id = fmc.idGrupoMovimiento 
    INNER JOIN DMGestion.DimTipoProducto dtp ON dtp.id = CASE WHEN fmc.idTipoProducto = 10 THEN 2 ELSE fmc.idTipoProducto END 
    INNER JOIN (SELECT rut,fl.fechaInicioLaguna ,isnull(fechaTerminoLaguna,date('2024-08-01'))fechaTerminoLaguna,fl.orden AS nroLaguna
                FROM #universoFinal fl
                ) fl ON fl.rut = dp.rut 
    WHERE dtp.codigo IN (2,4,5,10)
        AND periodoDevengRemuneracion BETWEEN fl.fechaInicioLaguna  AND fl.fechaTerminoLaguna 
        AND dgm.tipoMovimiento = 'Abonos'
        AND nombreSubgrupo = 'Cotizaciones'
        AND nombreGrupo = 'Cotizaciones y Depósitos'
    GROUP BY dp.rut,fl.nroLaguna;

    UPDATE #universoFinal
    SET nroMesesAbonoProdVoluntario = vl.totalMeses
    FROM #universoFinal fl
    INNER JOIN #totalVoluntarios vl ON vl.nroLaguna = fl.orden 
        AND fl.rut = vl.rut;
    
    UPDATE #universoFinal
    SET indVigenciaUltimaLaguna = CASE WHEN fechaTerminoLaguna IS NULL THEN 'Si' ELSE 'No' END;
    

   INSERT
    INTO
    dchavez.FctLagunaPrevisionalDetalle
    (idPeriodoInformado,
    idPersona,
    fechaInicioLaguna,
    fechaTerminoLaguna,
    nroMesesLaguna,
    nroLaguna,
    nroMesesAbonoCAV,
    montoTotalPesosAbonoCAV,
    nroMesesAbonoCCICV,
    montoTotalPesosAbonoCCICV,
    nroMesesAbonoCCIDC,
    montoTotalPesosAbonoCCIDC,
    nroMesesAbonoProdVoluntario,
    indVigenciaUltimaLAguna)
    SELECT
      dpi.id
    , dp.id idPersona
    , fechaInicioLaguna
    , fechaTerminoLaguna
    , nroMesesLaguna
    , orden nroLaguna
    , nroMesesAbonoCAV
    , montoTotalPesosAbonoCAV
    , nroMesesAbonoCCICV
    , montoTotalPesosAbonoCCICV
    , nroMesesAbonoCCIDC
    , montoTotalPesosAbonoCCIDC
    , nroMesesAbonoProdVoluntario
    , indVigenciaUltimaLAguna
    FROM #universoFinal a
        INNER JOIN DMGestion.Dimpersona dp ON dp.rut = a.rut
            AND dp.fechaVigencia >= ldtMaximaFechaVigencia
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
        CALL DMGestion.registrarErrorProceso(cstNombreProcedimiento, lstCodigoError);*/

END