create PROCEDURE Certificacion.cargarFctLagunaPrevisionalDetalleManual(IN periodoInformar date,OUT codigoError VARCHAR(10))
BEGIN
/**
        - Nombre archivo                            : cargarFctLagunaPrevisionalDetalleManual.sql
        - Nombre del módulo                         : Laguna Previsional
        - Fecha de  creación                        : 2025-02-01
        - Nombre del autor                          : Denis Chávez  Cognitivati
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
    DECLARE ldtFechaUltimoDiaMes                        DATE;           --variable local de tipo date
    DECLARE ldtFechaPeriodoInformado                    DATE;           --variable local de tipo date
    DECLARE lbiCantidadRegistrosInformados              BIGINT; 
    --Variables auditoria
    DECLARE ldtFechaInicioCarga                         DATETIME;       --variable local de tipo datetime
    
    DECLARE ctiCodigoTipoProcesoMensual                 TINYINT;
    DECLARE ltiCodigoTipoProceso                        TINYINT;
    DECLARE cstCodigoErrorCero                          VARCHAR(10);    --constante de tipo varchar
    DECLARE cstNombreTablaFct                           VARCHAR(150);   --constante de tipo varchar
    DECLARE cstNombreTablaTMP                           VARCHAR(150);   --constante de tipo varchar
    DECLARE cstSi                                       CHAR(2);
    DECLARE cstNo                                       CHAR(2);
    DECLARE ctiCCICV                                    INTEGER;
    DECLARE ctiCAV                                      INTEGER;
    DECLARE ctiCCIDC                                    INTEGER;
    DECLARE ctiCAVCOVID                                 INTEGER;
    DECLARE ctiCCIAV                                    INTEGER;
    DECLARE ctiCCICO                                    INTEGER;
    DECLARE ctiGrupo1100                                INTEGER;
    DECLARE ctiSubGrupo1104                             INTEGER;
    DECLARE ctiSubGrupo1105                             INTEGER;
    DECLARE ctiSubGrupo1101                             INTEGER;
    DECLARE ctiIngresada                                INTEGER;
    DECLARE cstAbonos                                   VARCHAR(20);
    DECLARE cstDNP                                      VARCHAR(20);
    DECLARE cstDNPA                                     VARCHAR(20);
    DECLARE cstAfiliado                                 VARCHAR(20);
    DECLARE cstPensionado                               VARCHAR(20);
    DECLARE csfFechaLicenciaNula                        DATE;
    
        -------------------------------------------------------------------------------------------
    --Seteo Variable auditoria
    -------------------------------------------------------------------------------------------
    --se obtiene la fecha y hora de carga
    SET ldtFechaInicioCarga                     = getDate();
    
    -------------------------------------------------------------------------------------------
    --Seteo de Constantes
    -------------------------------------------------------------------------------------------
    SET cstOwner                                = 'Certificacion';
    SET cstNombreProcedimiento                  = 'cargarFctLagunaPrevisionalDetalleManual';
    SET cstNombreTablaFct                       = 'FctLagunaPrevisionalDetalle';
    SET cstCodigoErrorCero                      = '0';
    SET cstNombreTablaTMP                       = 'PeriodoCotizadoTMP';
    SET cstSi                                   = 'Si';
    SET cstNo                                   = 'No';
    SET ctiCCICV                                = 4;
    SET ctiCAV                                  = 2;
    SET ctiCCIDC                                = 5;
    SET ctiCAVCOVID                             = 10;
    SET ctiCCIAV                                = 6;
    SET ctiCCICO                                = 1;
    SET ctiGrupo1100                            = 1100;
    SET ctiSubGrupo1101                         = 1101;
    SET ctiSubGrupo1104                         = 1104;
    SET ctiSubGrupo1105                         = 1105;
    SET cstAbonos                               = 'Abonos';
    SET cstDNP                                  = '01';
    SET cstDNPA                                 = '07';
    SET ctiIngresada                            = 1;
    SET cstPensionado                           = 'Pensionado';
    SET cstAfiliado                             = 'Afiliado';
    SET csfFechaLicenciaNula                    = '1900-01-01';
    SET ctiCodigoTipoProcesoMensual             = 1;
    SET ltiCodigoTipoProceso                    = ctiCodigoTipoProcesoMensual; 


    
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
    

    --se elimina los errores de carga y datos de la fact para el periodo a informar
    CALL Certificacion.eliminarFact(cstNombreProcedimiento, cstNombreTablaFct, linIdPeriodoInformar, codigoError);
    
    IF codigoError = cstCodigoErrorCero THEN 


        IF (EXISTS (SELECT 1 FROM SYSCATALOG WHERE tname = cstNombreTablaTMP AND creator = cstOwner)) THEN
                DROP TABLE DMGestion.PeriodoCotizadoTMP;
        END IF;
    
        CREATE TABLE   Certificacion.PeriodoCotizadoTMP (
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
        CREATE DATE INDEX DATE_periodoCotizadostmp_01 ON Certificacion.PeriodoCotizadoTMP (periodo);
        CREATE DATE INDEX DATE_periodoCotizadostmp_02 ON Certificacion.PeriodoCotizadoTMP (per_cot);
        CREATE HG INDEX HG_periodocotizadotmp_01 ON Certificacion.PeriodoCotizadoTMP (rut);
        CREATE HG INDEX HG_periodocotizadotmp_02 ON Certificacion.PeriodoCotizadoTMP (InicioLaguna);
        CREATE HG INDEX HG_periodocotizadotmp_03 ON Certificacion.PeriodoCotizadoTMP (TerminoLaguna);
    
    
        CREATE TABLE #UniversoRegistroTMP (
            periodoInformado date,
            idPeriodoInformado integer NOT NULL,
            idPersona bigint NOT NULL,
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
        CREATE HG INDEX HG_universoFinal_01 ON #UniversoRegistroTMP (rut);
        CREATE date INDEX DT_universoFinal_02 ON #UniversoRegistroTMP (fechaInicioLaguna);
        CREATE date INDEX DT_universoFinal_03 ON #UniversoRegistroTMP (fechaTerminoLaguna);
    
        --OBTIENE UNIVERSO DE COTIZACIONES POR AFILIADO
        CALL Certificacion.cargarUniversoPeriodoCotizadoTMP(codigoError);
    
        IF (codigoError = cstCodigoErrorCero) THEN 
    
    
            INSERT INTO Certificacion.PeriodoCotizadoTMP
            (rut,fechaAfiliacionSistema,ClasificacionPersona,periodo, per_cot,fechaPension, codigoPension)
            SELECT DISTINCT rut, fechaAfiliacionSistema, ClasificacionPersona, periodo , per_cot,fechaPension, codigoPension
            FROM Certificacion.UniversoPeriodoCotizadoTMP;
        
            --OBTIENE UNIVERSO DE LICENCIAS MEDICAS
            CALL Certificacion.cargarUniversoLicenciaMedicaTMP(ldtFechaPeriodoInformado,codigoError);
        
            IF (codigoError = cstCodigoErrorCero) THEN  
            
                UPDATE  Certificacion.PeriodoCotizadoTMP 
                SET indLicenciaMedica = cstSi
                ,per_cot = csfFechaLicenciaNula
                FROM Certificacion.PeriodoCotizadoTMP a
                    INNER JOIN Certificacion.UniversoLicenciaMedicaTMP B ON A.periodo = B.periodoInicio AND a.rut = b.rut
                WHERE a.per_cot IS NULL;
                
                
                UPDATE  Certificacion.PeriodoCotizadoTMP 
                SET indLicenciaMedica = cstSi
                ,per_cot = csfFechaLicenciaNula
                FROM Certificacion.PeriodoCotizadoTMP a
                    INNER JOIN Certificacion.UniversoLicenciaMedicaTMP B ON A.periodo = B.periodoTermino AND a.rut = b.rut
                WHERE a.per_cot IS NULL;

            
            
                ----PERIODO ANTERIOR--------
                SELECT DISTINCT rut,periodo, perAnterior 
                INTO #anterior
                    from
                    (SELECT rut,periodo, 
                        LAG(per_cot) OVER (PARTITION BY rut ORDER BY periodo) perAnterior
                    FROM Certificacion.PeriodoCotizadoTMP a)u
                    WHERE perAnterior IS NOT NULL ;
                
                UPDATE Certificacion.PeriodoCotizadoTMP
                SET perAnterior = b.perAnterior
                FROM Certificacion.PeriodoCotizadoTMP a
                INNER JOIN #anterior b ON a.rut = b.rut AND a.periodo = b.periodo;
            
                DROP TABLE #anterior;
                
                ----PERIODO SIGUIENTE--------
                SELECT DISTINCT rut,periodo, perSiguiente 
                INTO #siguiente
                    from
                    (SELECT rut,periodo, 
                        LEAD(per_cot) OVER (PARTITION BY rut ORDER BY periodo) perSiguiente
                    FROM Certificacion.PeriodoCotizadoTMP a)u
                    WHERE perSiguiente IS NOT NULL ;
                
                UPDATE Certificacion.PeriodoCotizadoTMP
                SET perSiguiente = b.perSiguiente
                FROM Certificacion.PeriodoCotizadoTMP a
                INNER JOIN #siguiente b ON a.rut = b.rut AND a.periodo = b.periodo;
                
                DROP TABLE #siguiente;
            
                DELETE FROM Certificacion.PeriodoCotizadoTMP
                WHERE periodo = ldtFechaPeriodoInformado;
                -----------------------------------------------------------------------------------------
            
                UPDATE Certificacion.PeriodoCotizadoTMP
                SET InicioLaguna = CASE WHEN (PER_COT IS NULL AND perAnterior IS NOT NULL) THEN cstSi ELSE cstNo END,
                TerminoLaguna = CASE WHEN (PER_COT IS NULL AND perSiguiente IS NOT NULL) THEN cstSi ELSE cstNo END;
            
            
                SELECT RUT, MIN(periodo) primerPeriodo
                INTO #primerPeriodo
                FROM Certificacion.PeriodoCotizadoTMP
                GROUP BY RUT;
                
                
                UPDATE Certificacion.PeriodoCotizadoTMP
                SET InicioLaguna = cstSi
                FROM Certificacion.PeriodoCotizadoTMP A
                    INNER JOIN #primerPeriodo b ON a.rut=b.rut AND a.periodo = b.primerPeriodo
                WHERE per_cot IS NULL;
                
                DROP TABLE #primerPeriodo;
            
            
                -------------- PERIODO COTIZADO ANTES DE LA LAGUNA -----------------------------------------------------------------------
            
                SELECT DISTINCT rut_mae_persona rut, per.periodo,vc.per_cot,date(dateadd(dd,-1,per.periodo))fechaUF,
                    sum(vc.monto_pesos)montoPesos,round((montoPesos/vvu.valorUF),2)montoUF, 
                    sum(vc.renta_imponible)rentaImponiblePesos,round((rentaImponiblePesos/vvu.valorUF),2)rentaImponibleUF,
                    CASE WHEN montoUF > vti.valor THEN cstSi ELSE cstNo END superaTope,
                    CASE WHEN superaTope = cstSi THEN vti.valor ELSE montoUF END montoUFCalculado,
                    CASE WHEN superaTope = cstSi THEN round(vvf.valorUF*vti.valor,0) ELSE montoPesos  END montoPesosCalculado,
                    CASE WHEN rentaImponibleUF > vti.valor THEN cstSi ELSE cstNo END superaTopeRI,
                    CASE WHEN superaTopeRI = cstSi THEN vti.valor ELSE rentaImponibleUF END rentaImponobleUFCalculado,
                    CASE WHEN superaTopeRI = cstSi THEN round(vvf.valorUF*vti.valor,0) ELSE rentaImponiblePesos  END rentaImponiblePesosCalculado
                INTO #UNI
                FROM DDS.VectorCotizaciones vc
                    INNER JOIN (SELECT rut,perAnterior, per_cot, periodo ,InicioLaguna  
                                FROM Certificacion.PeriodoCotizadoTMP
                                WHERE InicioLaguna = cstSi
                                ORDER BY periodo ASC) per ON per.rut = vc.rut_mae_persona AND vc.per_cot = per.perAnterior
                    INNER JOIN DMGestion.VistaValorUF vvu ON vvu.fechaUF = fechaUF
                    INNER JOIN DMGestion.VistaValorUF vvf ON vvf.fechaUF = fec_acreditacion
                    LEFT OUTER JOIN  DMGestion.vistaTopeImponible vti ON vc.per_cot BETWEEN vti.fechaInicioRango AND vti.fechaTerminoRango
                WHERE vc.codigoTipoProducto = ctiCCICO
                    AND monto_pesos > 0
                    AND codigoGrupoMovimiento = ctiGrupo1100
                    AND codigoSubgrupomovimiento IN (ctiSubGrupo1101,ctiSubGrupo1104,ctiSubGrupo1105)
                GROUP BY rut, vc.per_cot,per.periodo, vvu.valorUF,valor,vvf.valorUF;
            
             
            
                SELECT a.rut, a.periodo, a.per_cot, a.fechaUF,   
                    CASE WHEN a.superaTope = cstSi THEN a.montoPesosCalculado ELSE a.montoPesos END montoPesos,
                    CASE WHEN a.superaTope = cstSi THEN a.montoUFCalculado ELSE a.montoUF END montoUF,
                    CASE WHEN a.superaTopeRI = cstSi THEN a.rentaImponiblePesosCalculado ELSE a.rentaImponiblePesos END rentaImponiblePesos,
                    CASE WHEN a.superaTopeRI = cstSi THEN a.rentaImponobleUFCalculado ELSE a.rentaImponibleUF END rentaImponibleUF
                INTO #COTIZ
                FROM #UNI a;
            
                UPDATE Certificacion.PeriodoCotizadoTMP
                SET montoPesosCotiAnterior = b.montoPesos,
                    montoUFCotiAnterior = b.montoUF,
                    montoPesosRentaAnterior = rentaImponiblePesos,
                    montoUFRentaAnterior = rentaImponibleUF
                FROM Certificacion.PeriodoCotizadoTMP A
                    INNER JOIN #COTIZ b ON a.rut=b.rut AND a.periodo = b. periodo;
                
                DROP TABLE #COTIZ;
                DROP TABLE #UNI;
                
                -------------------------------------------------------------------------------------
                SELECT idPersona, rut
                    INTO #universoPersona
                FROM DMGestion.FctlsInformacionAfiliadoCliente fiac
                    INNER JOIN DMGestion.DimPeriodoInformado dpi ON dpi.id = fiac.idPeriodoInformado 
                    INNER JOIN DMGestion.DimPersona dp ON dp.id = fiac.idPersona 
                WHERE dpi.id = linIdPeriodoInformar;
                
                
                INSERT INTO  #UniversoRegistroTMP
                (periodoInformado,idPeriodoInformado,idPersona,rut,fechaAfiliacionSistema,ClasificacionPersona,fechaInicioLaguna,montoPesosCotiAnterior ,montoUFCotiAnterior,
                montoPesosRentaAnterior,montoUFRentaAnterior,FechaPension,orden)
                SELECT ldtFechaPeriodoInformado,linIdPeriodoInformar,idPersona,tmp.rut, fechaAfiliacionSistema, ClasificacionPersona, periodo,montoPesosCotiAnterior ,montoUFCotiAnterior,
                montoPesosRentaAnterior,montoUFRentaAnterior,FechaPension,  
                    DENSE_RANK ()OVER (PARTITION BY tmp.rut ORDER BY tmp.rut,periodo)orden
                FROM Certificacion.PeriodoCotizadoTMP tmp
                    INNER JOIN #universoPersona b ON b.rut = tmp.rut
                WHERE  InicioLaguna = cstSi;
                
                SELECT rut, periodo,   
                DENSE_RANK ()OVER (PARTITION BY rut ORDER BY rut,periodo)orden
                INTO #FinLaguna
                FROM Certificacion.PeriodoCotizadoTMP
                WHERE  TerminoLaguna = cstSi;
                
                
                UPDATE #UniversoRegistroTMP
                SET fechaTerminoLaguna = B.periodo
                FROM #UniversoRegistroTMP a
                    INNER JOIN #FinLaguna b ON a.rut = b.rut AND a.orden = b.orden;
                
                DROP TABLE #FinLaguna;
            
                 
                ---------NUMERO DE MESES DE LA LAGUNA
            
                UPDATE  #UniversoRegistroTMP
                SET fechaTerminoLaguna = FechaPension
                WHERE ClasificacionPersona = cstPensionado
                AND isnull(fechaTerminoLaguna,ldtFechaPeriodoInformado) = ldtFechaPeriodoInformado;
            
                UPDATE  #UniversoRegistroTMP
                SET nroMesesLaguna = DATEDIFF(mm,fechaInicioLaguna,ISnull(fechaTerminoLaguna,ldtFechaPeriodoInformado))+1
                WHERE ClasificacionPersona = cstAfiliado;
            
                UPDATE  #UniversoRegistroTMP
                SET nroMesesLaguna = DATEDIFF(mm,fechaInicioLaguna,fechaTerminoLaguna)+1
                WHERE ClasificacionPersona = cstPensionado;
            
            
                 ---------INDICADOR DE VIGENCIA ULTIMA LAGUNA
                UPDATE #UniversoRegistroTMP
                SET indVigenciaUltimaLaguna = CASE WHEN fechaTerminoLaguna IS NULL THEN cstSi ELSE cstNo END;
            
            
                ----PRODUCTOS VOLUNTARIOS
            
                SELECT  dp.rut,dgm.nombreGrupo,dgm.nombreSubgrupo ,sum(montoPesos)totalPesos,dtp.codigo,dtp.nombreCorto , COUNT(DISTINCT periodoDevengRemuneracion) totalMeses,fl.fechaInicioLaguna,fl.fechaTerminoLaguna,fl.nroLaguna
                INTO #productosVoluntarios
                FROM DMGestion.FctMovimientosCuenta fmc 
                INNER JOIN DMGestion.DimPeriodoInformado dpi ON dpi.id = fmc.idPeriodoInformado 
                INNER JOIN DMGestion.DimPersona dp ON dp.id = fmc.idPersona 
                INNER JOIN DMGestion.DimGrupoMovimiento dgm ON dgm.id = fmc.idGrupoMovimiento 
                INNER JOIN DMGestion.DimTipoProducto dtp ON dtp.id = CASE WHEN fmc.idTipoProducto = ctiCAVCOVID THEN ctiCAV ELSE fmc.idTipoProducto END 
                INNER JOIN (SELECT rut,fl.fechaInicioLaguna ,isnull(fechaTerminoLaguna,date(ldtFechaPeriodoInformado))fechaTerminoLaguna,fl.orden AS nroLaguna
                            FROM #UniversoRegistroTMP fl
                            ) fl ON fl.rut = dp.rut 
                WHERE dtp.codigo IN (ctiCAV,ctiCCICV,ctiCCIDC,ctiCAVCOVID)
                    --AND dp.rut = 10398097
                    AND periodoDevengRemuneracion BETWEEN fl.fechaInicioLaguna  AND fl.fechaTerminoLaguna 
                    AND dgm.tipoMovimiento = cstAbonos
                    AND dgm.codigoGrupo = ctiGrupo1100
                    AND dgm.codigoSubgrupo = ctiSubGrupo1101
                GROUP BY dp.rut,nombreGrupo,dgm.nombreSubgrupo,dtp.codigo,dtp.nombreCorto,fl.fechaInicioLaguna,fl.fechaTerminoLaguna,nroLaguna;
            
            
                UPDATE #UniversoRegistroTMP
                SET nroMesesAbonoCCIDC = vl.totalMeses,
                montoTotalPesosAbonoCCIDC = vl.totalPesos
                FROM #UniversoRegistroTMP fl
                INNER JOIN #productosVoluntarios vl ON fl.orden = vl.nroLaguna
                    AND fl.rut = vl.rut
                    AND vl.codigo = ctiCCIDC; --CCIDC
            
                UPDATE #UniversoRegistroTMP
                SET nroMesesAbonoCAV = vl.totalMeses,
                montoTotalPesosAbonoCAV = vl.totalPesos
                FROM #UniversoRegistroTMP fl
                INNER JOIN #productosVoluntarios vl ON fl.orden = vl.nroLaguna
                    AND fl.rut = vl.rut
                    AND vl.codigo = ctiCAV;--CAV
            
                UPDATE #UniversoRegistroTMP
                SET nroMesesAbonoCCICV = vl.totalMeses,
                montoTotalPesosAbonoCCICV = vl.totalPesos
                FROM #UniversoRegistroTMP fl
                INNER JOIN #productosVoluntarios vl ON fl.orden = vl.nroLaguna
                    AND fl.rut = vl.rut
                    AND vl.codigo = ctiCCICV;--CCICV
                    
                ----Total Voluntario sin producto
                SELECT  dp.rut, COUNT(DISTINCT periodoDevengRemuneracion) totalMeses,nroLaguna
                    INTO  #totalVoluntarios
                FROM DMGestion.FctMovimientosCuenta fmc 
                INNER JOIN DMGestion.DimPeriodoInformado dpi ON dpi.id = fmc.idPeriodoInformado 
                INNER JOIN DMGestion.DimPersona dp ON dp.id = fmc.idPersona 
                INNER JOIN DMGestion.DimGrupoMovimiento dgm ON dgm.id = fmc.idGrupoMovimiento 
                INNER JOIN DMGestion.DimTipoProducto dtp ON dtp.id = CASE WHEN fmc.idTipoProducto = ctiCAVCOVID THEN ctiCAV ELSE fmc.idTipoProducto END 
                INNER JOIN (SELECT rut,fl.fechaInicioLaguna ,isnull(fechaTerminoLaguna,date(ldtFechaPeriodoInformado))fechaTerminoLaguna,fl.orden AS nroLaguna
                            FROM #UniversoRegistroTMP fl
                            ) fl ON fl.rut = dp.rut 
                WHERE dtp.codigo IN (ctiCAV,ctiCCICV,ctiCCIDC,ctiCAVCOVID)
                    AND periodoDevengRemuneracion BETWEEN fl.fechaInicioLaguna  AND fl.fechaTerminoLaguna 
                    AND dgm.tipoMovimiento = cstAbonos
                    AND dgm.codigoGrupo = ctiGrupo1100
                    AND dgm.codigoSubgrupo = ctiSubGrupo1101
                GROUP BY dp.rut,fl.nroLaguna;
            
            
                UPDATE #UniversoRegistroTMP
                SET nroMesesAbonoProdVoluntario = vl.totalMeses
                FROM #UniversoRegistroTMP fl
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
                            FROM #UniversoRegistroTMP fl
                            ) fl ON fl.rut = dp.rut 
                WHERE dtp.codigo  = ctiCCIAV
                    AND periodoDevengRemuneracion BETWEEN fl.fechaInicioLaguna  AND isnull(fl.fechaTerminoLaguna,ldtFechaPeriodoInformado) 
                    AND dgm.tipoMovimiento = cstAbonos
                    AND dgm.codigoGrupo = ctiGrupo1100
                    AND dgm.codigoSubgrupo = ctiSubGrupo1101
                GROUP BY dp.rut,nombreGrupo,dgm.nombreSubgrupo,dtp.codigo,dtp.nombreCorto,fl.fechaInicioLaguna,fl.fechaTerminoLaguna,nroLaguna;
            
            
                UPDATE #UniversoRegistroTMP
                SET nroMesesAbonoCCIAV = vl.totalMeses
                FROM #UniversoRegistroTMP fl
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
                            FROM #UniversoRegistroTMP
                            ) fl ON fl.rut = dp.rut 
                WHERE fd.periodoCotizado BETWEEN fl.fechaInicioLaguna  AND fl.fechaTerminoLaguna
                AND dpi.fecha = ldtFechaPeriodoInformado
                AND dgm.codigo IN (cstDNP,cstDNPA)
                AND dsd.codigo = ctiIngresada;
            
                UPDATE #UniversoRegistroTMP
                SET indExisteDNP = CASE WHEN vl.rut IS NOT NULL THEN cstSi ELSE cstNo END
                FROM #UniversoRegistroTMP fl
                LEFT OUTER JOIN #totalDNPDNPA vl ON vl.nroLaguna = fl.orden 
                    AND fl.rut = vl.rut
                    AND vl.codigo = cstDNP;
                
                UPDATE #UniversoRegistroTMP
                SET indExisteDNPA = CASE WHEN vl.rut IS NOT NULL THEN cstSi ELSE cstNo END
                FROM #UniversoRegistroTMP fl
                LEFT OUTER  JOIN #totalDNPDNPA vl ON vl.nroLaguna = fl.orden 
                    AND fl.rut = vl.rut
                    AND vl.codigo = cstDNPA;
                
                -----TERMINO DE RELACION LABORAL
                
                SELECT b.rutAfiliado RUT,b.periodoInformado periodoTermino, FL.orden nroLaguna
                    INTO #TerminoRL
                FROM #UniversoRegistroTMP fl
                    INNER JOIN DMGestion.AgrTerminoRelLaboral B ON  fl.rut = b.rutAfiliado  AND b.periodoInformado = DATEADD(mm,-1,fl.fechaInicioLaguna)
                   ORDER BY fl.orden;
               
               
                UPDATE #UniversoRegistroTMP
                SET indTerminoRelacionLaboral = CASE WHEN vl.rut IS NOT NULL THEN cstSi ELSE cstNo END
                FROM #UniversoRegistroTMP fl
                LEFT OUTER  JOIN #TerminoRL vl ON vl.nroLaguna = fl.orden 
                    AND fl.rut = vl.rut;       
                
                
            
               INSERT INTO
                Certificacion.FctLagunaPrevisionalDetalle
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
                nroMesesAbonoCCIAV,
                montoPesosRentaAnterior,
                montoUFRentaAnterior
                )
                SELECT
                  idPeriodoInformado
                , idPersona
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
                , nroMesesAbonoCCIAV
                , montoPesosRentaAnterior
                , montoUFRentaAnterior
                FROM #UniversoRegistroTMP a;
            
            
                COMMIT;
                SAVEPOINT;
                SET codigoError = cstCodigoErrorCero;
            
                DROP TABLE Certificacion.UniversoLicenciaMedicaTMP;
                DROP TABLE Certificacion.UniversoPeriodoCotizadoTMP;
                DROP TABLE Certificacion.PeriodoCotizadoTMP;
                
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
        END IF;
    END IF;
--Manejo de errores
EXCEPTION
    WHEN OTHERS THEN
        SET lstCodigoError = SQLSTATE;
        SET codigoError = lstCodigoError;
        ROLLBACK;
        CALL Certificacion.registrarErrorProceso(cstNombreProcedimiento, lstCodigoError);

END