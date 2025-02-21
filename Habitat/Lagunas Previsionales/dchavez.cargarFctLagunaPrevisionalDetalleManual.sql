ALTER  PROCEDURE dchavez.cargarFctLagunaPrevisionalDetalleManual(IN periodoInformar date,OUT codigoError VARCHAR(10))
BEGIN
/**
        - Nombre archivo                            : cargarFctLagunaPrevisionalDetalleManual.sql
        - Nombre del módulo                         : 
        - Fecha de  creación                        : 
        - Nombre del autor                          :
        - Descripción corta del módulo              : .
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
    
    DECLARE cstCodigoErrorCero                          VARCHAR(10);    --constante de tipo varchar
    
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
    SET cstCodigoErrorCero                      = '0';
    
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
        rut                     bigint NOT NULL,
        fechaAfiliacionSistema  date NOT NULL,
        ClasificacionPersona    varchar(50) NOT NULL,
        periodo                 date NOT NULL,
        per_cot                 date NULL,
        indLicenciaMedica       char(2) NULL,
        perAnterior             date NULL,
        perSiguiente            date NULL,
        InicioLaguna            char(2)  NULL,
        TerminoLaguna           char(2)  NULL,
        FechaPension            date null, 
        codigoPension           VARCHAR(2) NULL,
        montoPesosCotiAnterior  integer null, 
        montoUFCotiAnterior     numeric(10,2) NULL,
        montoPesosRentaAnterior integer null, 
        montoUFRentaAnterior    numeric(10,2) NULL
    );
    CREATE DATE INDEX DATE_periodoCotizadostmp_01 ON dchavez.periodoCotizadosTMP (periodo);
    CREATE DATE INDEX DATE_periodoCotizadostmp_02 ON dchavez.periodoCotizadosTMP (per_cot);
    CREATE HG INDEX HG_periodocotizadotmp_01 ON dchavez.periodoCotizadosTMP (rut);
    CREATE HG INDEX HG_periodocotizadotmp_02 ON dchavez.periodoCotizadosTMP (InicioLaguna);
    CREATE HG INDEX HG_periodocotizadotmp_03 ON dchavez.periodoCotizadosTMP (TerminoLaguna);

    IF (EXISTS (SELECT 1 FROM SYSCATALOG WHERE tname = 'licenciasMedicasTMP' AND creator = 'dchavez')) THEN
            DROP TABLE dchavez.licenciasMedicasTMP;
    END IF;

    /*CREATE TABLE dchavez.licenciasMedicasTMP (
        rut int NULL,
        FEC_DESDE date NULL,
        FEC_HASTA date NULL,
        periodoInicio date NULL,
        periodoTermino date NULL
    );
    CREATE INDEX DATE_licenciasMedicasTMP_01 ON dchavez.licenciasMedicasTMP (periodoInicio);
    CREATE INDEX DATE_licenciasMedicasTMP_02 ON dchavez.licenciasMedicasTMP (periodoTermino);
    CREATE INDEX HG_licenciasMedicasTMP_01 ON   dchavez.licenciasMedicasTMP (rut);*/

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
        indVigenciaUltimaLAguna char(2) NULL,
        indExisteDNP char(2) NULL,
        indExisteDNPA char(2) NULL,
        indTerminoRelacionLaboral char(2) NULL,
        montoPesosCotiAnterior integer null, 
        montoUFCotiAnterior numeric(10,2) NULL,
        FechaPension date NULL,
        totalPlanesAPV integer NULL,
        nroMesesAbonoCCIAV INTEGER NULL,
        montoPesosRentaAnterior integer null, 
        montoUFRentaAnterior    numeric(10,2) NULL
        );
    CREATE HG INDEX HG_universoFinal_01 ON #universoFinal (rut);
    CREATE date INDEX DT_universoFinal_02 ON #universoFinal (fechaInicioLaguna);
    CREATE date INDEX DT_universoFinal_03 ON #universoFinal (fechaTerminoLaguna);

    --CALL dchavez.cargarUniversoPeriodoCotizadosTMP(codigoError);
    SET codigoError = '0';
    

    IF (codigoError = cstCodigoErrorCero) THEN 


        INSERT INTO dchavez.periodoCotizadosTMP
        (rut,fechaAfiliacionSistema,ClasificacionPersona,periodo, per_cot,fechaPension, codigoPension)
        SELECT DISTINCT rut, fechaAfiliacionSistema, ClasificacionPersona, periodo , per_cot,fechaPension, codigoPension
        FROM dchavez.UniversoPeriodoCotizadosTMP;
    
        CALL dchavez.cargarUniversoLicenciayCeseTMP(ldtFechaPeriodoInformado,codigoError);
    
        IF (codigoError = cstCodigoErrorCero) THEN  
        
            UPDATE  dchavez.periodoCotizadosTMP 
            SET indLicenciaMedica = 'Si'
            ,per_cot = '1900-01-01'
            FROM dchavez.periodoCotizadosTMP a
                INNER JOIN dchavez.UniversoLicenciasMedicasTMP B ON A.periodo = B.periodoInicio AND a.rut = b.rut
            WHERE a.per_cot IS NULL;
            
            
            UPDATE  dchavez.periodoCotizadosTMP 
            SET indLicenciaMedica = 'Si'
            ,per_cot = '1900-01-01'
            FROM dchavez.periodoCotizadosTMP a
                INNER JOIN dchavez.UniversoLicenciasMedicasTMP B ON A.periodo = B.periodoTermino AND a.rut = b.rut
            WHERE a.per_cot IS NULL;
        
        
           -- DROP TABLE #licenciasMedicasTMP;
        
        
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
        
            DELETE FROM dchavez.periodoCotizadosTMP
            WHERE periodo = ldtFechaPeriodoInformado;
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
        
        
            -------------- PERIODO COTIZADO ANTES DE LA LAGUNA -----------------------------------------------------------------------
        
            SELECT DISTINCT rut_mae_persona rut, per.periodo,vc.per_cot,date(dateadd(dd,-1,per.periodo))fechaUF,
                sum(vc.monto_pesos)montoPesos,round((montoPesos/vvu.valorUF),2)montoUF, 
                sum(vc.renta_imponible)rentaImponiblePesos,round((rentaImponiblePesos/vvu.valorUF),2)rentaImponibleUF,
                CASE WHEN montoUF > vti.valor THEN 'Si' ELSE 'No' END superaTope,
                CASE WHEN superaTope = 'Si' THEN vti.valor ELSE montoUF END montoUFCalculado,
                CASE WHEN superaTope = 'Si' THEN round(vvf.valorUF*vti.valor,0) ELSE montoPesos  END montoPesosCalculado,
                CASE WHEN rentaImponibleUF > vti.valor THEN 'Si' ELSE 'No' END superaTopeRI,
                CASE WHEN superaTopeRI = 'Si' THEN vti.valor ELSE rentaImponibleUF END rentaImponobleUFCalculado,
                CASE WHEN superaTopeRI = 'Si' THEN round(vvf.valorUF*vti.valor,0) ELSE rentaImponiblePesos  END rentaImponiblePesosCalculado
            INTO #UNI
            FROM DDS.VectorCotizaciones vc
                INNER JOIN (SELECT rut,perAnterior, per_cot, periodo ,InicioLaguna  
                            FROM dchavez.periodoCotizadosTMP
                            WHERE InicioLaguna = 'Si'
                            ORDER BY periodo ASC) per ON per.rut = vc.rut_mae_persona AND vc.per_cot = per.perAnterior
                INNER JOIN DMGestion.VistaValorUF vvu ON vvu.fechaUF = fechaUF
                INNER JOIN DMGestion.VistaValorUF vvf ON vvf.fechaUF = fec_acreditacion
                LEFT OUTER JOIN  DMGestion.vistaTopeImponible vti ON vc.per_cot BETWEEN vti.fechaInicioRango AND vti.fechaTerminoRango
            WHERE vc.codigoTipoProducto = 1
                AND monto_pesos > 0
            GROUP BY rut, vc.per_cot,per.periodo, vvu.valorUF,valor,vvf.valorUF;
        
            SELECT a.rut, a.periodo, a.per_cot, a.fechaUF,   
                CASE WHEN a.superaTope = 'Si' THEN a.montoPesosCalculado ELSE a.montoPesos END montoPesos,
                CASE WHEN a.superaTope = 'Si' THEN a.montoUFCalculado ELSE a.montoUF END montoUF,
                CASE WHEN a.superaTopeRI = 'Si' THEN a.rentaImponiblePesosCalculado ELSE a.rentaImponiblePesos END rentaImponiblePesos,
                CASE WHEN a.superaTopeRI = 'Si' THEN a.rentaImponobleUFCalculado ELSE a.rentaImponibleUF END rentaImponibleUF
            INTO #COTIZ
            FROM #UNI a;
        
            UPDATE dchavez.periodoCotizadosTMP
            SET montoPesosCotiAnterior = b.montoPesos,
                montoUFCotiAnterior = b.montoUF,
                montoPesosRentaAnterior = rentaImponiblePesos,
                montoUFRentaAnterior = rentaImponibleUF
            FROM dchavez.periodoCotizadosTMP A
                INNER JOIN #COTIZ b ON a.rut=b.rut AND a.periodo = b. periodo;
            
            DROP TABLE #COTIZ;
            DROP TABLE #UNI;
            
            -------------------------------------------------------------------------------------
            
            INSERT INTO  #universoFinal
            (periodoInformado,rut,fechaAfiliacionSistema,ClasificacionPersona,fechaInicioLaguna,montoPesosCotiAnterior ,montoUFCotiAnterior,FechaPension,orden)
            SELECT ldtFechaPeriodoInformado,rut, fechaAfiliacionSistema, ClasificacionPersona, periodo,montoPesosCotiAnterior ,montoUFCotiAnterior,
            montoPesosRentaAnterior,montoUFRentaAnterior,FechaPension,  
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
        
        
            ---------NUMERO DE MESES DE LA LAGUNA
        
            UPDATE  #universoFinal
            SET fechaTerminoLaguna = FechaPension
            WHERE ClasificacionPersona = 'Pensionado'
            AND isnull(fechaTerminoLaguna,ldtFechaPeriodoInformado) = ldtFechaPeriodoInformado;
        
            UPDATE  #universoFinal
            SET nroMesesLaguna = DATEDIFF(mm,fechaInicioLaguna,ISnull(fechaTerminoLaguna,ldtFechaPeriodoInformado))+1
            WHERE ClasificacionPersona = 'Afiliado';
        
            UPDATE  #universoFinal
            SET nroMesesLaguna = DATEDIFF(mm,fechaInicioLaguna,fechaTerminoLaguna)+1
            WHERE ClasificacionPersona = 'Pensionado';
        
        
             ---------INDICADOR DE VIGENCIA ULTIMA LAGUNA
            UPDATE #universoFinal
            SET indVigenciaUltimaLaguna = CASE WHEN fechaTerminoLaguna IS NULL THEN 'Si' ELSE 'No' END;
        
        
             MESSAGE 'PRODUCTOS VOLUNTARIOS' TO client;
        
            ----PRODUCTOS VOLUNTARIOS
        
            SELECT  dp.rut,dgm.nombreGrupo,dgm.nombreSubgrupo ,sum(montoPesos)totalPesos,dtp.codigo,dtp.nombreCorto , COUNT(DISTINCT periodoDevengRemuneracion) totalMeses,fl.fechaInicioLaguna,fl.fechaTerminoLaguna,fl.nroLaguna
            INTO #productosVoluntarios
            FROM DMGestion.FctMovimientosCuenta fmc 
            INNER JOIN DMGestion.DimPeriodoInformado dpi ON dpi.id = fmc.idPeriodoInformado 
            INNER JOIN DMGestion.DimPersona dp ON dp.id = fmc.idPersona 
            INNER JOIN DMGestion.DimGrupoMovimiento dgm ON dgm.id = fmc.idGrupoMovimiento 
            INNER JOIN DMGestion.DimTipoProducto dtp ON dtp.id = CASE WHEN fmc.idTipoProducto = 10 THEN 2 ELSE fmc.idTipoProducto END 
            INNER JOIN (SELECT rut,fl.fechaInicioLaguna ,isnull(fechaTerminoLaguna,date(ldtFechaPeriodoInformado))fechaTerminoLaguna,fl.orden AS nroLaguna
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
            INNER JOIN (SELECT rut,fl.fechaInicioLaguna ,isnull(fechaTerminoLaguna,date(ldtFechaPeriodoInformado))fechaTerminoLaguna,fl.orden AS nroLaguna
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
            
            DROP TABLE #productosVoluntarios;
            
            ---- COTIZACIONES VOLUNTARIAS CCIAV
        
            SELECT  dp.rut,dgm.nombreGrupo,dgm.nombreSubgrupo , COUNT(DISTINCT periodoDevengRemuneracion) totalMeses,fl.fechaInicioLaguna,fl.fechaTerminoLaguna,fl.nroLaguna
            INTO #CotizacionVoluntaria
            FROM DMGestion.FctMovimientosCuenta fmc 
            INNER JOIN DMGestion.DimPeriodoInformado dpi ON dpi.id = fmc.idPeriodoInformado 
            INNER JOIN DMGestion.DimPersona dp ON dp.id = fmc.idPersona 
            INNER JOIN DMGestion.DimGrupoMovimiento dgm ON dgm.id = fmc.idGrupoMovimiento 
            INNER JOIN DMGestion.DimTipoProducto dtp ON dtp.id = fmc.idTipoProducto  
            INNER JOIN (SELECT rut,fl.fechaInicioLaguna ,isnull(fechaTerminoLaguna,date(ldtFechaPeriodoInformado))fechaTerminoLaguna,fl.orden AS nroLaguna
                        FROM #universoFinal fl
                        ) fl ON fl.rut = dp.rut 
            WHERE dtp.codigo  = 6
                AND periodoDevengRemuneracion BETWEEN fl.fechaInicioLaguna  AND isnull(fl.fechaTerminoLaguna,ldtFechaPeriodoInformado) 
                AND dgm.tipoMovimiento = 'Abonos'
                AND nombreSubgrupo = 'Cotizaciones'
                AND nombreGrupo = 'Cotizaciones y Depósitos'
            GROUP BY dp.rut,nombreGrupo,dgm.nombreSubgrupo,dtp.codigo,dtp.nombreCorto,fl.fechaInicioLaguna,fl.fechaTerminoLaguna,nroLaguna;
        
        
            UPDATE #universoFinal
            SET nroMesesAbonoCCIAV = vl.totalMeses
            FROM #universoFinal fl
            INNER JOIN #CotizacionVoluntaria vl ON fl.orden = vl.nroLaguna
                AND fl.rut = vl.rut; --CCIAV
        
    
        
            -----DEUDA --> DNP Y DNPA
            SELECT  DISTINCT dp.rut,nroLaguna,dgm.codigo
                INTO #totalDNPDNPA
            FROM DMGestion.FctDetalleDeudaCotizacionesPrevisionales fd 
            INNER JOIN DMGestion.DimPeriodoInformado dpi ON dpi.id = fd.idPeriodoInformado 
            INNER JOIN DMGestion.DimPersona dp ON dp.id = fd.idAfiliado  
            INNER JOIN DMGestion.DimOrigenDeuda dgm ON dgm.id = fd.idOrigenDeuda  
            INNER JOIN DMGestion.DimSituacionDeuda dsd ON dsd.id = fd.idSituacionDeuda 
            INNER JOIN (SELECT rut,fechaInicioLaguna ,isnull(fechaTerminoLaguna,ldtFechaPeriodoInformado)fechaTerminoLaguna,ORDEn AS nroLaguna
                        FROM #universoFinal
                        ) fl ON fl.rut = dp.rut 
            WHERE fd.periodoCotizado BETWEEN fl.fechaInicioLaguna  AND fl.fechaTerminoLaguna
            AND dpi.fecha = ldtFechaPeriodoInformado
            AND dgm.codigo IN ('01','07')
            AND dsd.codigo = 1;
        
            UPDATE #universoFinal
            SET indExisteDNP = CASE WHEN vl.rut IS NOT NULL THEN 'Si' ELSE 'No' END
            FROM #universoFinal fl
            LEFT OUTER JOIN #totalDNPDNPA vl ON vl.nroLaguna = fl.orden 
                AND fl.rut = vl.rut
                AND vl.codigo = '01';
            
            UPDATE #universoFinal
            SET indExisteDNPA = CASE WHEN vl.rut IS NOT NULL THEN 'Si' ELSE 'No' END
            FROM #universoFinal fl
            LEFT OUTER  JOIN #totalDNPDNPA vl ON vl.nroLaguna = fl.orden 
                AND fl.rut = vl.rut
                AND vl.codigo = '07';
            
            -----TERMINO DE RELACION LABORAL
            
            SELECT b.rutAfiliado RUT,b.periodoInformado periodoTermino, FL.orden nroLaguna
                INTO #TerminoRL
            FROM #universoFinal fl
                INNER JOIN DMGestion.AgrTerminoRelLaboral B ON  fl.rut = b.rutAfiliado  AND b.periodoInformado = DATEADD(mm,-1,fl.fechaInicioLaguna)
               ORDER BY fl.orden;
           
           
            UPDATE #universoFinal
            SET indTerminoRelacionLaboral = CASE WHEN vl.rut IS NOT NULL THEN 'Si' ELSE 'No' END
            FROM #universoFinal fl
            LEFT OUTER  JOIN #TerminoRL vl ON vl.nroLaguna = fl.orden 
                AND fl.rut = vl.rut;       
            
            -------PLANES APV-----------------------------------------------------------------------------------
    
            /*SELECT dp.rut,qa.orden nroLaguna,count(DISTINCT fvp.idPersonaEmpleador) totalPlanes
            INTO #planes
            FROM DMGestion.FctVentaPlan fvp 
                INNER JOIN DMGestion.DimFecha df ON df.id = fvp.idFechaSuscripcion 
                INNER JOIN DMGestion.DimCausalesRechazo dcr ON dcr.id = fvp.idCausalesRechazo 
                INNER JOIN DMGestion.DimPersona dp ON dp.id = fvp.idPersona 
                INNER JOIN dchavez.DimEstadoSolicitud des ON des.id = fvp.idEstadoSolicitud 
                INNER JOIN #universoFinal qa ON qa.rut = dp.rut 
            WHERE qa.fechaInicioLaguna >= fechaInicioDescuento 
            AND isnull(fechaFinDescuento,ldtFechaPeriodoInformado) >= isnull(qa.fechaTerminoLaguna,ldtFechaPeriodoInformado) 
            AND des.codigo = 4
            AND fechaInicioDescuento IS NOT NULL 
            GROUP BY dp.rut,nroLaguna;
            
            UPDATE #universoFinal
            SET totalPlanesAPV = vl.totalPlanes
            FROM #universoFinal fl
                INNER JOIN #planes vl ON vl.nroLaguna = fl.orden
                    AND fl.rut = vl.rut;*/
            
            
        
           INSERT INTO
            dchavez.FctLagunaPrevisionalDetalle
            (idPeriodoInformado,
            idPersona,
            FechaPension,
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
            indVigenciaUltimaLAguna,
            indExisteDNP,
            indExisteDNPA,
            indTerminoRelacionLaboral,
            montoPesosCotiAnterior ,  
            montoUFCotiAnterior,
            totalPlanesAPV,
            nroMesesAbonoCCIAV,
            montoPesosRentaAnterior,
            montoUFRentaAnterior
            )
            SELECT
              dpi.id
            , dp.id idPersona
            , fechaPension
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
            , indExisteDNP
            , indExisteDNPA
            , indTerminoRelacionLaboral
            , montoPesosCotiAnterior  
            , montoUFCotiAnterior
            , totalPlanesAPV
            , nroMesesAbonoCCIAV
            , montoPesosRentaAnterior
            , montoUFRentaAnterior
            FROM #universoFinal a
                INNER JOIN DMGestion.Dimpersona dp ON dp.rut = a.rut
                    AND dp.fechaVigencia >= ldtMaximaFechaVigencia
                INNER JOIN DMGestion.DimPeriodoInformado dpi ON
                    dpi.fecha = a.periodoInformado;
        
        
            COMMIT;
            SAVEPOINT;
    
        END IF;
    END IF;
--Manejo de errores
/*EXCEPTION
    WHEN OTHERS THEN
        SET lstCodigoError = SQLSTATE;
        SET codigoError = lstCodigoError;
        ROLLBACK;
        CALL DMGestion.registrarErrorProceso(cstNombreProcedimiento, lstCodigoError);*/

END