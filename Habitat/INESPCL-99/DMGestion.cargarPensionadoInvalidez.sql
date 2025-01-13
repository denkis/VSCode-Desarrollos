ALTER PROCEDURE dchavez.cargarPensionadoInvalidez(OUT cantRegRegistrados BIGINT, OUT codigoError VARCHAR(10))
BEGIN
    /**
        - Nombre archivo                            : cargarPensionadoInvalidez.sql
        - Nombre del módulo                         : Modelo de Invalidez
        - Fecha de  creación                        : 27/07/2010
        - Nombre del autor                          : Cristian Zavaleta V. - Gesfor Chile S.A.
        - Descripción corta del módulo              : 
        - Lista de procedimientos contenidos        : - DMGestion.obtenerIdDimPeriodoInformar
                                                      - DMGestion.obtenerParametro
                                                      - DMGestion.obtenerFechaPeriodoInformar
                                                      - DMGestion.obtenerUltimaFechaMes
                                                      - Circular1661.eliminarCuadro
                                                      - DMGestion.eliminarErrorCarga
        - Documentos asociados a la creación        : 
        - Fecha de modificación                     : 26/10/2022
        - Nombre de la persona que lo modificó      : Denis Chávez.
        - Cambios realizados                        : Cambio lógica de nuevos pensionados
        - Documentos asociados a la modificación    : INESP-4233
        - Fecha de modificación                     : 25-07-2022
        - Nombre de la persona que lo modificó      : Gabriela Aravena Villalón
        - Cambios realizados                        : DATAW-4752 - Circular 1509 - Generación Archivo 1.5 Personas Inválidas
        - Documentos asociados a la modificación    :
    **/

    -------------------------------------------------------------------------------------------
    --Declaracion de Variables
    -------------------------------------------------------------------------------------------
    --variable para capturar el codigo de error 
    DECLARE lstCodigoError                      VARCHAR(10);    --variable local de tipo varchar
    --Variables auditoria
    DECLARE lbiCantidadRegistrosInformados      BIGINT;         --variable local de tipo bigint
    --Variables
    DECLARE linContadorExistencia               INTEGER;        --variable local de tipo integer
    DECLARE linIdPeriodoInformar                INTEGER;        --variable local de tipo integer
    DECLARE lstValorParametro                   VARCHAR(100);   --variable local de tipo varchar
    DECLARE ldtFechaPeriodoInformado            DATE;           --variable local de tipo date
    DECLARE ldtUltimaFechaPeriodoInformar       DATE;           --variable local de tipo date
    DECLARE ldtFechaInicioCnuVectorTasa         DATE;           --variable local de tipo date
    DECLARE ldtFechaInicioNormaNormal           DATE;           --variable local de tipo date
    DECLARE ldtFechaInicioNormaNueva            DATE;           --variable local de tipo date
    DECLARE ltiIdDimTipoProceso                 TINYINT;        --variable local de tipo tinyint
    DECLARE lnuValorTopeImponible               NUMERIC(7,2);
	DECLARE linIdPeriodoInformarAnterior        INTEGER; -- DATAWCL-383
    --Constantes
    DECLARE cstOwner                            VARCHAR(150);
    DECLARE cstNombreProcedimiento              VARCHAR(150);   --constante de tipo varchar
    DECLARE cstNombreTablaFct                   VARCHAR(150);   --constante de tipo varchar
    DECLARE cdtMaximaFechaVigencia              DATE;           --variable local de tipo date
    DECLARE cnuMontoCero                        NUMERIC(2, 1);
    DECLARE cnuMontoPAFECero                    NUMERIC(6, 2);
    DECLARE cstCodigoErrorCero                  VARCHAR(10);
    DECLARE ctiCodTipoCalcFajuSim               TINYINT;
    DECLARE ctiCero                             TINYINT;
    DECLARE ctiTres                             TINYINT;
    DECLARE ctiCuatro                           TINYINT;
    DECLARE ctiCinco                            TINYINT;
    DECLARE ctiSeis                             TINYINT;
    DECLARE ctiDoce                             TINYINT;
    
    DECLARE ctiUno                              TINYINT;
    DECLARE cdtFecha01IndScomp                  DATE;
    DECLARE cdtFecha02IndScomp                  DATE;
    DECLARE cstCodigoPaisChile                  VARCHAR(2);
    DECLARE cchS                                CHAR(1);
    DECLARE ctiCodEstSolRevRechazada            TINYINT;
    DECLARE ctiCodEstSolSinSolRev               TINYINT;
    DECLARE cchCodigoModalidadPension01         CHAR(2);
    DECLARE cchCodigoModalidadPension02         CHAR(2);
    DECLARE cchCodigoModalidadPension07         CHAR(2);
    DECLARE cchCodigoModalidadPension03         CHAR(2);
    DECLARE cchCodigoModalidadPension04         CHAR(2);
    DECLARE cchCodigoModalidadPension05         CHAR(2);
    DECLARE cchCodigoModalidadPension06         CHAR(2);
    DECLARE cnuPorcentajeRentaImp               NUMERIC(10, 2);
    DECLARE cinCodigoGrupo1200                  INTEGER;
    DECLARE cinCodigoSubGrupo1205               INTEGER;
    DECLARE cinCodigoSubGrupo1206               INTEGER;
    DECLARE cdt20080701                         DATE;
    DECLARE cinEdad65                           INTEGER;
    DECLARE cchIndPafeNo                        CHAR(1);
    DECLARE cchIndPafeSi                        CHAR(1);
    DECLARE cchUno                              CHAR(2);
    DECLARE cchDos                              CHAR(2);
    DECLARE cchCinco                            CHAR(2);
    DECLARE cchSeis                             CHAR(2);
    DECLARE cch11                               CHAR(2);
    DECLARE cch12                               CHAR(2);
    DECLARE cch13                               CHAR(2);
    DECLARE cch14                               CHAR(2);
    DECLARE cch15                               CHAR(2);
    DECLARE cch16                               CHAR(2);
    DECLARE cch17                               CHAR(2);
    DECLARE cch18                               CHAR(2);
    DECLARE cch19                               CHAR(2);    
    DECLARE cchN                                CHAR(1);
    DECLARE cchX                                CHAR(1);
    DECLARE cchSignoMas                         CHAR(1);
    DECLARE cchSignoMenos                       CHAR(1);
    DECLARE ctiDos                              INTEGER;
    DECLARE cchCodigoIN                         CHAR(2);
    DECLARE cchSi                               CHAR(2);
    DECLARE cchNo                               CHAR(2);
    DECLARE cchCodigoTipoCobertura03            CHAR(2);
    DECLARE ctiSucInternet                      TINYINT;
    DECLARE cchFormPeriodo                      VARCHAR(6);
    DECLARE ctiCodigoPAET                       TINYINT;
    DECLARE cchCodigoInvPAET                    CHAR(2);
    DECLARE cdtFecCorteNoPerfect                DATE;
    DECLARE cinAproNoPerfeccionado              INTEGER;
    DECLARE cinAprobado                         INTEGER;
    DECLARE ctiCodEstProcReevaluacion           TINYINT;    
    DECLARE ctiNumeroComMedMetro                TINYINT;
    DECLARE cinCero                             INTEGER;
    DECLARE csmCero                             SMALLINT;
    DECLARE cchCodigoSinClasificar              CHAR(2);
    DECLARE ctiNroMesesRevaluacion              INTEGER;
    DECLARE cchmurioAntes                       VARCHAR(20); 
    DECLARE cchmurioDespues                     VARCHAR(20);
    DECLARE cchvivo                             VARCHAR(20);
    DECLARE cchBlanco                           CHAR(1);
    
    -------------------------------------------------------------------------------------------
    --Seteo de Constantes
    -------------------------------------------------------------------------------------------
    SET cstOwner                        = 'DMGestion';
    SET cstNombreProcedimiento      = 'cargarPensionadoInvalidez';
    SET cstNombreTablaFct           = 'FctPensionadoInvalidezVejez';
    SET cnuMontoCero                = 0.0;
    SET cnuMontoPAFECero            = 0.0;
    SET ctiCero                     = 0;
    SET ctiDos                      = 2;
    SET ctiTres                     = 3;
    SET ctiCuatro                   = 4;
    SET ctiCinco                    = 5;
    SET ctiSeis                     = 6;
    SET ctiDoce                     = 12;
    SET ctiUno                      = 1;
    SET cstCodigoErrorCero          = '0';
    SET ctiCodTipoCalcFajuSim       = 2;
    SET cdtFecha01IndScomp          = DATE('2009-07-01');
    SET cdtFecha02IndScomp          = DATE('2004-08-19');
    SET cstCodigoPaisChile          = 'CL';
    SET cchS                        = 'S';
    SET ctiCodEstSolRevRechazada    = 100;
    SET ctiCodEstSolSinSolRev       = 99;
    SET cchCodigoModalidadPension01 = '01';
    SET cchCodigoModalidadPension02 = '02';
    SET cchCodigoModalidadPension07 = '07';
    SET cchCodigoModalidadPension03 = '03';
    SET cchCodigoModalidadPension04 = '04';
    SET cchCodigoModalidadPension05 = '05';
    SET cchCodigoModalidadPension06 = '06';
    SET cnuPorcentajeRentaImp       = 0.1;
    SET cinCodigoGrupo1200          = 1200;
    SET cinCodigoSubGrupo1205       = 1205;
    SET cinCodigoSubGrupo1206       = 1206;
    SET cdt20080701                 = '20080701';
    SET cinEdad65                   = 65;
    SET cchIndPafeNo                = 'N';   
    SET cchIndPafeSi                = 'S';  
    SET cchX                        = 'X';
    SET cchUno                      = '01'; 
    SET cchDos                      = '02';
    SET cchCinco                    = '05';
    SET cchSeis                     = '06';
    SET cch11                       = '11';
    SET cch12                       = '12';
    SET cch13                       = '13';
    SET cch14                       = '14';
    SET cch15                       = '15';
    SET cch16                       = '16';
    SET cch17                       = '17';
    SET cch18                       = '18';
    SET cch19                       = '19';
    SET cchN                        = 'N';
    SET cchSignoMas                 = '+';
    SET cchSignoMenos               = '-';
    SET cchCodigoIN                 = 'IN';
    SET cchSi                       = 'Si';
    SET cchNo                       = 'No';
    SET cchCodigoTipoCobertura03    = '03';
    SET ctiSucInternet              = 97;
    SET cchFormPeriodo              = 'YYYYMM';
    SET ctiCodigoPAET               = 18;
    SET cchCodigoInvPAET            = '58';
    SET cdtMaximaFechaVigencia          = CONVERT(DATE, DMGestion.obtenerParametro('MAXIMA_FECHA_VIGENCIA'), 103);
    SET cdtFecCorteNoPerfect            = '20220801'; -- Fecha de corte para el universo de tramites NO perfeccionados (aprobados si fecha de primer pago)
    SET cinAproNoPerfeccionado          = 104;
    SET cinAprobado                     = 4;
    SET ctiNumeroComMedMetro        = 19;
    SET cinCero                     = 0;
    SET csmCero                     = 0;
    SET cchCodigoSinClasificar      = '0';
    SET ctiNroMesesRevaluacion      = 42;
    SET cchmurioAntes               = 'murioAntes'; 
    SET cchmurioDespues             = 'murioDespues';
    SET cchvivo                     = 'vivo'; 
    SET cchBlanco                   = ' ';
                      


    -------------------------------------------------------------------------------------------
    --Seteo de Variables
    -------------------------------------------------------------------------------------------
    SET linIdPeriodoInformar            = DMGestion.obtenerIdDimPeriodoInformar();
    SET ldtFechaPeriodoInformado        = DMGestion.obtenerFechaPeriodoInformar(); 
    SET ldtUltimaFechaPeriodoInformar   = DMGestion.obtenerUltimaFechaMes(ldtFechaPeriodoInformado);
	SET linIdPeriodoInformarAnterior    = linIdPeriodoInformar - 1 ; -- DATAWCL-383

    -------------------------------------------------------------------------------------------
    --Cuerpo
    -------------------------------------------------------------------------------------------
    --se obtiene el identificador del tipo de proceso
    SELECT id INTO ltiIdDimTipoProceso
    FROM DMGestion.DimTipoProceso 
    WHERE codigo = '03'
    AND fechaVigencia >= cdtMaximaFechaVigencia;

    --se obtiene valor tope imponible del periodo cotizado
    SELECT valor
    INTO lnuValorTopeImponible
    FROM DMGestion.VistaTopeImponible 
    WHERE DATE(DATEADD(mm, -1, ldtFechaPeriodoInformado)) BETWEEN fechaInicioRango AND fechaTerminoRango;

    -------------------------------------------------------------------------------------------------------------
    --UNIVERSOS
    -------------------------------------------------------------------------------------------------------------
    
    CALL dchavez.cargarUniversoInvalidezTMP(codigoError);

    IF (codigoError = cstCodigoErrorCero) THEN
        CALL dchavez.cargarUniversoMovimientosRVTMP(ldtFechaPeriodoInformado, codigoError);

        IF (codigoError = cstCodigoErrorCero) THEN

            ---------------------------------------------------------------------------------------------------
            --Invalidos Transitorios (Tipoben=3)
            --Universo 1
            SELECT rank() OVER(PARTITION BY u.numcue_u1 ORDER BY u.fecsol DESC) rank,
                u.numcue_u1,
                u.tipoben_u1, 
                u.fecsol_u1, 
                u.subtipben_u1,
                u.ingreso_base_u1,
                u.numcue, 
                u.digcue, 
                u.tipoben, 
                u.subtipben, 
                u.fedevpen, 
                u.fecsol, 
                u.fecha_codestsol, 
                u.codestsol,
                u.sucursal_origen, 
                u.monto_pension_sisant_art17, 
                u.fec_devenga_sisant, 
                u.cod_inst_sisant,
                u.nro_meses_con_renta, 
                u.ind_cobertura_seg_invalidez, 
                u.pension_referencia, 
                u.ingreso_base,
                u.porcentaje_cobertura_seg
            INTO #STP_SOLICPEN_TIPOBEN_3
            FROM (
                SELECT u1.numcue numcue_u1,
                    u1.tipoben tipoben_u1, 
                    u1.fecsol fecsol_u1, 
                    u1.subtipben subtipben_u1,
                    u1.ingreso_base ingreso_base_u1,
                    s.numcue, 
                    s.digcue, 
                    s.tipoben, 
                    s.subtipben, 
                    s.fedevpen, 
                    s.fecsol, 
                    s.fecha_codestsol, 
                    s.codestsol,
                    s.sucursal_origen, 
                    s.monto_pension_sisant_art17, 
                    s.fec_devenga_sisant, 
                    s.cod_inst_sisant,
                    s.nro_meses_con_renta, 
                    s.ind_cobertura_seg_invalidez, 
                    s.pension_referencia, 
                    s.ingreso_base,
                    s.porcentaje_cobertura_seg
                FROM dchavez.UniversoInvalidezTMP u1
                    INNER JOIN DDS.STP_SOLICPEN s ON (u1.numcue = s.numcue)
                WHERE u1.tipoben = 6
                AND s.tipoben = 3
                and u1.fecsol >= s.fecsol
                AND s.codestsol = 2 --Aprobado Historico
                AND ISNULL(u1.numcue2, 0) = 0
                AND u1.numeroUniverso = 1
                UNION
                SELECT u1.numcue numcue_u1,
                    u1.tipoben tipoben_u1, 
                    u1.fecsol fecsol_u1, 
                    u1.subtipben subtipben_u1,
                    u1.ingreso_base ingreso_base_u1,
                    s.numcue, 
                    s.digcue, 
                    s.tipoben, 
                    s.subtipben, 
                    s.fedevpen, 
                    s.fecsol, 
                    s.fecha_codestsol, 
                    s.codestsol,
                    s.sucursal_origen, 
                    s.monto_pension_sisant_art17, 
                    s.fec_devenga_sisant, 
                    s.cod_inst_sisant,
                    s.nro_meses_con_renta, 
                    s.ind_cobertura_seg_invalidez, 
                    s.pension_referencia, 
                    s.ingreso_base,
                    s.porcentaje_cobertura_seg
                FROM dchavez.UniversoInvalidezTMP u1
                    INNER JOIN DDS.STP_SOLICPEN s ON (u1.numcue2 = s.numcue
                    AND u1.fecsol2 = s.fecsol)
                WHERE u1.numcue2 > 0
                AND u1.tipoben = 6
                AND s.tipoben = 3
                and u1.fecsol >= s.fecsol
                AND s.codestsol = 2 --Aprobado Historico
                AND u1.numeroUniverso = 1) u;
            
            DELETE FROM #STP_SOLICPEN_TIPOBEN_3
            WHERE rank > 1;

            SELECT s.numcue_u1, 
                s.tipoben_u1, 
                s.fecsol_u1, 
                s.subtipben_u1, 
                s.numcue, 
                s.digcue, 
                s.tipoben, 
                s.subtipben, 
                s.fedevpen, 
                s.fecsol,
                s.fecha_codestsol, 
                s.codestsol, 
                s.sucursal_origen, 
                s.monto_pension_sisant_art17, 
                s.fec_devenga_sisant, 
                s.cod_inst_sisant, 
                s.nro_meses_con_renta, 
                s.ind_cobertura_seg_invalidez, 
                s.pension_referencia, 
                s.ingreso_base,
                s.porcentaje_cobertura_seg,
                (CASE
                    WHEN ((s.ingreso_base IS NOT NULL) AND 
                          (vvuf.valorUF IS NOT NULL)) THEN 
                        CONVERT(NUMERIC(8, 3), ROUND((s.ingreso_base/vvuf.valorUF), 3))
                    ELSE
                        CONVERT(NUMERIC(8, 3), 0.0)
                 END) ingresoBaseUF,
                (CASE
                    WHEN (i.fecejec_cmc IS NOT NULL) THEN
                        (CASE
                            WHEN (i.grainval_cmc IN (0, 1, 3)) THEN '17'
                            WHEN (i.grainval_cmc = 2) THEN '18'
                            ELSE '0'
                         END)
                    WHEN (i.fecejec_cmr IS NOT NULL) THEN
                        (CASE 
                            WHEN(i.grainval_cmr IN (0, 1, 3)) THEN '17'
                            WHEN(i.grainval_cmr = 2) THEN '18'
                            ELSE '0'
                         END)
                    ELSE
                        --Incorporación nueva definición para casos que no tienen fecha de ejecutoriedad
                        (CASE 
                            WHEN(i.grainval_cmr IN (0, 1, 3)) THEN '17'
                            WHEN(i.grainval_cmr = 2) THEN '18'
                            ELSE '0'
                         END)
                 END) codigoTipoPension,
                s.fecsol fechaDeclInvPrimerDictEject,
                (CASE
                    WHEN (i.grainval_cmc IS NOT NULL) THEN 
                        i.grainval_cmc
                    WHEN (i.grainval_cmr IS NOT NULL) THEN 
                        i.grainval_cmr
                 END) gradoInvalidez,
                CONVERT(DATE, NULL) fechaEmiFCPensionTransit,
                i.fecresol_cmc,
                i.fecdicta_cmr,
                i.fecejec_cmr, 
                i.fecejec_cmc, 
                (CASE 
                    WHEN (s.subtipben IN (301, 601, 604)) THEN
                        (CASE 
                            WHEN (s.porcentaje_cobertura_seg IN (35, 50)) THEN '02' --parcial
                            WHEN (s.porcentaje_cobertura_seg = 70) THEN '01' --total
                            ELSE '99' --sin informacion
                         END)
                    WHEN (s.subtipben = 501) THEN '03' --NO CUBIERTO 
                    ELSE 
                        (CASE
                            WHEN ((s.ind_cobertura_seg_invalidez = 'S') OR 
                                  (i.cod_ciaseg > 0)) THEN
                                (CASE 
                                    WHEN (s.porcentaje_cobertura_seg IN (35, 50)) THEN '02' --parcial
                                    WHEN (s.porcentaje_cobertura_seg = 70) THEN '01' --total
                                    ELSE '99' --sin informacion
                                 END)
                            ELSE '03' --NO CUBIERTO
                         END)
                 END) codigoTipoCobertura,
                i.cod_ciaseg,
                vvuf.valorUF
            INTO #InvalidosTransitorios_U1
            FROM #STP_SOLICPEN_TIPOBEN_3 s
                LEFT OUTER JOIN DDS.STP_INVALPEN i ON s.numcue = i.numcue 
                AND s.tipoben = i.tipoben
                AND s.fecsol = i.fecsol
                AND i.numcorr = 0
                LEFT OUTER JOIN DMGestion.VistaValorUF vvuf ON (vvuf.periodo = DATE(DATEADD( month, -1, DATE(DATEFORMAT(s.fecsol, 'YYYYMM') || '01')))
                AND vvuf.ultimoDiaMes = 'S')
            ORDER BY s.fecsol;
    
            SELECT u.numcue,
                u.tipoBen,
                u.fecsol,
                MIN(fec_calculo) fec_calculo
            INTO #FechaCalculo 
            FROM #InvalidosTransitorios_U1 u 
                INNER JOIN DDS.SLB_FICHAS_CALCULO_MF fc ON (u.numcue = fc.numcue 
                AND u.tipoben = fc.tipoben_stp
                AND u.fecsol = fc.fecsol)
            WHERE fc.cod_estado = 2
            AND fc.tipo_pago  = 2
            AND u.codigoTipoPension IN ('17', '18')
            GROUP BY u.numcue, u.tipoBen, u.fecsol; 
         
            UPDATE #InvalidosTransitorios_U1 SET 
                u.fechaEmiFCPensionTransit = f.fec_calculo
            FROM #InvalidosTransitorios_U1 u
                JOIN #FechaCalculo f ON (u.numcue  = f.numcue 
                AND u.tipoben = f.tipoben
                AND u.fecsol  = f.fecsol);
    
            DROP TABLE #STP_SOLICPEN_TIPOBEN_3;
    
            --Casos que en la invalidez definitiva no aparece la cobertura, se tiene que obtener desde la 
            --invalidez transitoria.
            UPDATE dchavez.UniversoInvalidezTMP SET
                u1.porcentaje_cobertura_seg = it.porcentaje_cobertura_seg,
                u1.cod_ciaseg = (CASE
                                    WHEN (ISNULL(u1.cod_ciaseg, 0) = 0) THEN
                                        it.cod_ciaseg
                                    ELSE u1.cod_ciaseg
                                 END),
                u1.codigoTipoCobertura = it.codigoTipoCobertura
            FROM dchavez.UniversoInvalidezTMP u1
                INNER JOIN #InvalidosTransitorios_U1 it ON (u1.numcue = it.numcue_u1
                AND u1.tipoben = it.tipoben_u1
                AND u1.fecsol = it.fecsol_u1)
            WHERE u1.codigoTipoCobertura = '99'
            AND it.codigoTipoCobertura IN ('01', '02');
    
            -------------------------------------------------------------------------------------------------------
            --Obtención de campos
            -------------------------------------------------------------------------------------------------------  
            --4. Indicador artículo 69 - Campo 5
            --4.1. Universo 1
            SELECT u.numcue, 
                u.tipoben, 
                u.fecsol,
                u.tipoben_sol
            INTO #SLB_BENEFICIOS_CONDICION
            FROM (
                SELECT u1.numcue, 
                    b.tipoben, 
                    u1.fecsol,
                    u1.tipoben tipoben_sol
                FROM DDS.SLB_BENEFICIOS b
                    INNER JOIN dchavez.UniversoInvalidezTMP u1 ON (b.numcue = u1.numcue 
                    AND b.tipoben = u1.tipoben 
                    AND b.fecsol = u1.fecsol)
                WHERE b.modalidad IN (3, 5) 
                AND b.cod_vigencia = 30 --cesado
                AND u1.numeroUniverso = 1
                AND u1.tipoben <> ctiCodigoPAET 
                UNION
                --Casos de invalidez previa (tipoben=5), en la tabla SLB_BENEFICIOS quedan registrados como tipoben=6
                SELECT u1.numcue, 
                    b.tipoben, 
                    u1.fecsol,
                    u1.tipoben tipoben_sol
                FROM DDS.SLB_BENEFICIOS b
                    INNER JOIN dchavez.UniversoInvalidezTMP u1 ON (b.numcue = u1.numcue 
                    AND b.fecsol = u1.fecsol)
                WHERE b.tipoben = 6
                AND u1.tipoben = 5
                AND b.modalidad IN (3, 5) 
                AND b.cod_vigencia = 30 --cesado
                AND u1.numeroUniverso = 1) u;
    
            SELECT DISTINCT a.numcue, 
                a.tipoben_sol tipoben, 
                a.fecsol
            INTO #IndicadorArt69Universo1
            FROM #SLB_BENEFICIOS_CONDICION a
                INNER JOIN DDS.SLB_BENEFICIOS b ON (a.numcue = b.numcue
                AND a.tipoben = b.tipoben)
            WHERE b.fecsol >= a.fecsol
            AND b.modalidad = 1 
            AND b.tipo_pago = 2 
            AND b.cod_vigencia = 10;        
        
            DROP TABLE #SLB_BENEFICIOS_CONDICION;
        
            --5. Modalidad de pensión seleccionada al pensionarse - Campo 7
            --   Fecha Emision Certificado de saldo - Campo 20 
            --   Promedio de Rentas y/o remuneraciones, en UF -Campo 25
            --5.1. Universo 1
            SELECT DISTINCT p.numcue, 
                p.tipoben,
                p.fecsol, 
                p.modpen_selmod, 
                p.anos_renta_garantizada, 
                p.cod_ciaseg_selmod, 
                p.fecemi_cersal,
                p.fec_emision_selmod, 
                (CASE 
                    WHEN (ISNULL(p.promedio_remuner_uf, 0) = ctiCero) THEN 
                        (CASE 
                            WHEN (ISNULL(s.PROMEDIO_RENTAS_120MESES, 0) = ctiCero) THEN 
                                p.promedio_remuner_uf 
                            ELSE 
                                (CASE 
                                    WHEN (s.PROMEDIO_RENTAS_120MESES > lnuValorTopeImponible) THEN 
                                        ctiCero
                                    ELSE 
                                        s.PROMEDIO_RENTAS_120MESES 
                                 END)
                         END) 
                    ELSE
                        p.promedio_remuner_uf
                 END) promedio_remuner_uf, 
                p.saldo_retenido_uf
            INTO #STP_PENCERSA_CONDICION_U1
            FROM DDS.STP_PENCERSA p
                INNER JOIN dchavez.UniversoInvalidezTMP u ON (u.numcue = p.numcue 
                AND u.tipoben = p.tipoben 
                AND u.fecsol = p.fecsol)
                LEFT JOIN DDS.stp_solicpen s ON (s.numcue = p.numcue 
                AND s.tipoben = p.tipoben 
                AND s.fecsol = p.fecsol)
            WHERE p.modpen_selmod IS NOT NULL
            AND u.numeroUniverso = 1;
    
            --Fecha emisión primera ficha de cálculo para RP - Campo 21
            SELECT u.numcue, 
                u.tipoben, 
                u.fecsol, 
                fc.fec_calculo
            INTO #FichasCalculoMF
            FROM DDS.SLB_FICHAS_CALCULO_MF fc
                INNER JOIN dchavez.UniversoInvalidezTMP u ON u.numcue = fc.numcue 
                AND u.tipoben = fc.tipoben_stp
                AND u.fecsol = fc.fecsol
            WHERE fc.tipo_ficha = 'RP'
            AND fc.tipo_pago = 2
            AND u.numeroUniverso = 1;           
        
            --7.  Monto total del aporte adicional, en UF - Campo 22
            --Universo 1
            SELECT DISTINCT u1.numcue, 
                u1.tipoben, 
                u1.fecsol, 
                m.id_mae_persona, 
                vvUF.valorUF,
                m.monto_pesos, 
                m.monto_cuotas, 
                m.fec_movimiento
            INTO #TB_MAE_MOVIMIENTO_TMP_1
            FROM DDS.TB_MAE_MOVIMIENTO m
                INNER JOIN DDS.TB_TIP_MOVIMIENTO tm ON (m.id_tip_movimiento = tm.id_tip_movimiento)
                INNER JOIN dchavez.UniversoInvalidezTMP u1 ON (m.id_mae_persona = u1.idPersonaOrigen)
                INNER JOIN DMGestion.VistaValorUF vvUF ON (m.fec_movimiento = vvUF.fechaUF)
            WHERE tm.cod_movimiento = 5
            AND tm.ind_estado = 1
            AND (u1.ind_cobertura_seg_invalidez = 'S' OR u1.cod_ciaseg > 0)
            AND u1.tipoben = 6
            AND m.monto_pesos > 0
            AND m.fec_acreditacion <= ldtUltimaFechaPeriodoInformar
            AND u1.numeroUniverso = 1;
       
            SELECT DISTINCT m.id_mae_persona, 
                m.monto_pesos, 
                m.monto_cuotas,
                m.fec_movimiento
            INTO #TB_MAE_MOVIMIENTO_TMP_2
            FROM #TB_MAE_MOVIMIENTO_TMP_1 a
                INNER JOIN DDS.TB_MAE_MOVIMIENTO m ON (a.id_mae_persona = m.id_mae_persona)
                INNER JOIN DDS.TB_TIP_MOVIMIENTO tm ON (m.id_tip_movimiento = tm.id_tip_movimiento)
            WHERE tm.cod_movimiento IN (85, 89)
            AND tm.ind_estado = 1
            AND a.fec_movimiento <= m.fec_movimiento
            AND m.fec_acreditacion <= ldtUltimaFechaPeriodoInformar;
            
            DELETE FROM #TB_MAE_MOVIMIENTO_TMP_1
            FROM #TB_MAE_MOVIMIENTO_TMP_1 a, 
                 #TB_MAE_MOVIMIENTO_TMP_2 b
            WHERE a.id_mae_persona = b.id_mae_persona
            AND (a.monto_pesos = b.monto_pesos OR a.monto_cuotas = b.monto_cuotas);
        
            SELECT numcue, 
                tipoben, 
                fecsol, 
                id_mae_persona, 
                SUM(CONVERT(NUMERIC(7, 2), (monto_pesos / valorUF))) monto
            INTO #TB_MAE_MOVIMIENTO_5_U1
            FROM #TB_MAE_MOVIMIENTO_TMP_1
            GROUP BY numcue, tipoben, fecsol, id_mae_persona;
        
            DROP TABLE #TB_MAE_MOVIMIENTO_TMP_1;
            DROP TABLE #TB_MAE_MOVIMIENTO_TMP_2;
    
            SELECT DISTINCT m87.id_mae_persona
            INTO #TB_MAE_MOVIMIENTO_87
            FROM dchavez.UniversoMovimientosRVTMP m87;
           
             --10. Código del país donde solicita la pensión - Campo 28      
            SELECT DISTINCT a.rut numrut,
                UPPER(a.paisRecepcion) codigoPaisRecepcion
            INTO #ConvenioInternacionalTMP
            FROM DDS.PlanillaConvenioInternacional a
                INNER JOIN (SELECT a.rut,
                                MAX(a.fechaRecepcion) fechaRecepcion
                            FROM DDS.PlanillaConvenioInternacional a
                            WHERE UPPER(a.estadoSolicitud) IN ('EN TRÁMITE', 'CONCEDIDA')
                            AND UPPER(a.tipoPension) IN ('VEJEZ NORMAL', 'VEJEZ ANTICIPADA')
                            GROUP BY a.rut) b ON (a.rut = b.rut
                AND a.fechaRecepcion = b.fechaRecepcion)
            WHERE UPPER(a.estadoSolicitud) IN ('EN TRÁMITE', 'CONCEDIDA')
            AND UPPER(a.tipoPension) IN ('VEJEZ NORMAL', 'VEJEZ ANTICIPADA')
            ORDER BY a.rut;
    
            --11. Región donde solicita la pensión - Campo 29
            SELECT DISTINCT
                u1.numcue,
                u1.tipoben,
                u1.fecsol,
                (CASE
                    WHEN (CONVERT(TINYINT, r.cod_region) = 99) THEN 
                        '00'
                    WHEN (CONVERT(TINYINT, r.cod_region) < 10) THEN
                        ('0' || CONVERT(TINYINT, r.cod_region))
                    ELSE 
                        ISNULL(r.cod_region, '00')
                 END) codigoRegionSolicitaPension
            INTO #RegionSolicitaPensionTMP
            FROM dchavez.UniversoInvalidezTMP u1
                INNER JOIN DDS.TB_DIRECCION_SUCURSAL s ON (u1.sucursal_origen = s.id_sucursal)
                INNER JOIN DDS.TB_COD_REGION r ON (s.id_cod_region = r.id_cod_region)
            WHERE u1.numeroUniverso = 1; 
            --AND s.ind_estado = 1; --MODIFICACION INESP-1034
			
			--- DATAWCL-383
            SELECT u.rut,u.idDimPersona,fpi.fecPrimerPagoPensionDef,fpi.fechaSolicitud
            INTO #UniversoFechaAnterior
            FROM dchavez.UniversoInvalidezTMP u
            INNER JOIN DMGestion.DimPersona dp ON dp.rut = u.rut
            INNER JOIN DMGestion.FctPensionadoInvalidezVejez fpi ON fpi.idPersona = dp.id
            WHERE u.indFechaMes = 'N'
            AND u.fecsol = fpi.fechaSolicitud
            AND fpi.idPeriodoInformado = linIdPeriodoInformarAnterior;
            --- FIN DATAWCL-383
        
            --12. Fecha de primer pago de pensión definitiva - Campo 31
            --12.1. Universo 1
            SELECT DISTINCT rank() OVER (PARTITION BY u.numcue ORDER BY u.fec_liquidacion ASC) rankDocupago,
                u.numcue, 
                u.tipoben, 
                u.fecsol, 
                u.fec_liquidacion
            INTO #SLB_DOCUPAGO_U1
            FROM (
                SELECT d.numcue, 
                    d.tipoben, 
                    d.fecsol, 
                    d.fec_liquidacion
                FROM DDS.SLB_DOCUPAGO d
                    INNER JOIN dchavez.UniversoInvalidezTMP u ON (u.numcue = d.numcue 
                    AND u.tipoben = d.tipoben 
                    AND u.fecsol = d.fecsol)
                WHERE d.tipo_pago = 2
                AND u.numeroUniverso = 1
                UNION
                SELECT d.numcue, 
                    d.tipoben, 
                    d.fecsol, 
                    d.fec_liquidacion
                FROM DDS.SLB_DOCUPAGO d
                    INNER JOIN dchavez.UniversoInvalidezTMP u ON (u.numcue = d.numcue 
                    AND u.fecsol = d.fecsol)
                WHERE d.tipo_pago = 2
                AND u.tipoben = 5
                AND d.tipoben = 6
                AND u.numeroUniverso = 1
            ) u;
    
            DELETE FROM #SLB_DOCUPAGO_U1 
            WHERE rankDocupago > 1;
    
            -- Se Modifica el tipo de pension de 11 a 19 a todos los registros 
            -- que tengan una invalidez definitiva y no tengan una solicitud de invlaidez transitoria
            SELECT u1.numcue, 
                u1.tipoben, 
                u1.fecsol,
                u1.codigoTipoPension
            INTO #DefenitivoSinTransitorio
            FROM dchavez.UniversoInvalidezTMP u1
                LEFT OUTER JOIN #InvalidosTransitorios_U1 it ON u1.numcue = it.numcue_u1
                AND u1.tipoben = it.tipoben_u1
                AND u1.fecsol = it.fecsol_u1
            WHERE u1.codigoTipoPension IN ('11', '12')
            AND it.numcue_u1 IS NULL;       
            
            UPDATE dchavez.UniversoInvalidezTMP SET 
                u1.codigoTipoPension = '19'
            FROM dchavez.UniversoInvalidezTMP u1
                JOIN #DefenitivoSinTransitorio d ON (u1.numcue  = d.numcue
                AND u1.tipoben = d.tipoben
                AND u1.fecsol  = d.fecsol
                AND u1.codigoTipoPension = d.codigoTipoPension);
    
            --Casos que no se les pudo identificar cobertura pero si tienen monto de aporte adicional.
            --Se les informa como cobertura total.
            UPDATE dchavez.UniversoInvalidezTMP SET
                u1.codigoTipoCobertura = (CASE
                                            WHEN ((u1.codigoTipoCobertura = '99') AND 
                                                  (u1.tipoben = 6) AND 
                                                  (m5.monto > 0)) THEN
                                                '01' --Cobertura Total
                                            ELSE
                                                u1.codigoTipoCobertura
                                          END), --Cobertura al pensionarse por invalidez - Campo 48
                u1.porcentaje_cobertura_seg = 70
            FROM dchavez.UniversoInvalidezTMP u1
                JOIN #TB_MAE_MOVIMIENTO_5_U1 m5 ON (u1.numcue = m5.numcue
                AND u1.tipoben = m5.tipoben
                AND u1.fecsol = m5.fecsol);
    
            ---------------------------------------------------------------------------------------------- 
            --14. Integración de los campos
            ----------------------------------------------------------------------------------------------
            --14.1. Universo 1
            SELECT CONVERT(BIGINT, NULL) numeroFila,
                u1.fechaNacimiento,
                u1.sexo,
                u1.fecsol,
                u1.tipoben,
                u1.numcue,
                u1.idDimPersona,    --Campo 2
                u1.rut,             --Campo 2
                u1.idPersonaOrigen,
                u1.codigoTipoCobertura, --Cobertura al pensionarse por invalidez - Campo 48
                (CASE 
                    WHEN u1.tipoben = ctiCodigoPAET THEN 
                        'N' 
                    WHEN ((ISNULL(u1.monto_pension_sisant_art17, 0) > 0) OR 
                          (u1.fec_devenga_sisant IS NOT NULL) OR 
                          (ISNULL(u1.cod_inst_sisant,0) > 0)) THEN 
                        'S'
                    ELSE 'N'
                 END
                ) indicadorArt17, --Indicador artículo 17 transitorio - Campo 4
                (CASE
                    WHEN u1.tipoben = ctiCodigoPAET THEN 
                        'N' 
                    WHEN (ia69.numcue IS NOT NULL) THEN 
                        'S'
                    ELSE 'N'
                 END
                ) indicadorArt69, --Indicador artículo 69 - Campo 5
                u1.codigoTipoPension, --Tipo de pensión de vejez - Campo 6
                (CASE
                    WHEN u1.tipoben = ctiCodigoPAET THEN cch13 
                    WHEN u1.codigoTipoPension ='15' THEN '12'
                    WHEN (u1.tipoben = 3) THEN '00'
                    WHEN ((p.modpen_selmod = 3) AND 
                          (ISNULL(p.anos_renta_garantizada, 0) = 0) AND
                          (u1.codigoTipoCobertura IN ('01', '02')) AND //IESP-235: Se agrega nueva condición para clasificar la modalidad '07'.
                          (p.cod_ciaseg_selmod IN (3, 7)) AND 
                          (m87.id_mae_persona IS NOT NULL)) THEN '07' --existe un movimiento 87
                    WHEN ((p.modpen_selmod = 3) AND 
                          (ISNULL(p.anos_renta_garantizada, 0) = 0)) THEN '01'
                    WHEN ((p.modpen_selmod = 3) AND 
                          (ISNULL(p.anos_renta_garantizada, 0) > 0)) THEN '02'
                    WHEN ((p.modpen_selmod = 5) AND 
                          (ISNULL(p.anos_renta_garantizada, 0) = 0)) THEN '03'
                    WHEN ((p.modpen_selmod = 5) AND 
                          (ISNULL(p.anos_renta_garantizada, 0) > 0)) THEN '04'
                    WHEN ((p.modpen_selmod = 9) AND 
                          (ISNULL(p.anos_renta_garantizada, 0) = 0)) THEN '05'
                    WHEN ((p.modpen_selmod = 9) AND 
                          (ISNULL(p.anos_renta_garantizada, 0) > 0)) THEN '06'
                    WHEN ((p.modpen_selmod) IN (1, 7)) THEN '08'
                    WHEN ((p.modpen_selmod) = 6) THEN '09'
                    ELSE '0'
                 END 
                ) codigoModalidadPension, --Modalidad de pensión seleccionada al pensionarse - Campo 7
                (CASE
                    WHEN ((u1.tipoben = 6) AND (it.tipoben = 3) AND 
                          (u1.codigoTipoPension IN ('11', '12')) AND
                          (it.codigoTipoPension IN ('17', '18', '0'))) THEN
                        it.fechaDeclInvPrimerDictEject
                    WHEN ((u1.tipoben = 3) AND (u1.codigoTipoPension IN ('17', '18'))) THEN
                        u1.fechaDeclInvPrimerDictEject
                    ELSE NULL
                 END
                ) fechaDeclInvPrimerDictEject, --Fecha de declaración de invalidez primer dictamen ejecutoriado - Campo 8
                (CASE                  
                    WHEN ((u1.tipoben = 6) AND (it.tipoben = 3) AND 
                          (u1.codigoTipoPension IN ('11', '12')) AND
                          (it.codigoTipoPension IN ('17', '18'))) THEN
                        CASE it.codigoTipoPension
                            WHEN '17' THEN 'T'--invalidez Total
                            WHEN '18' THEN 'P'--invalidez parcial
                        END
                    WHEN ((u1.tipoben = 3) AND (u1.codigoTipoPension IN ('17', '18'))) THEN
                        CASE u1.codigoTipoPension
                            WHEN '17' THEN 'T'--invalidez Total
                            WHEN '18' THEN 'P'--invalidez parcial
                        END
                    ELSE 'N'
                 END
                ) gradoInvalidezPrimerDictEject, --Grado de invalidez primer dictamen ejecutoriado - Campo 9
                (CASE
                    WHEN ((u1.tipoben = 6) AND (it.tipoben = 3) AND 
                          (u1.codigoTipoPension IN ('11', '12')) AND
                          (it.codigoTipoPension IN ('17', '18'))) THEN
                        it.fechaEmiFCPensionTransit
                    WHEN (u1.tipoben = 3) THEN
                        u1.fechaEmiFCPensionTransit
                    ELSE NULL
                 END
                ) fechaEmiFCPensionTransit, --Fecha emisión ficha de cálculo para PensiónTransitoria - Campo 10
                (CASE 
                    WHEN (u1.codigoTipoPension IN ('13', '14')) THEN u1.fecsol
                    ELSE CONVERT(DATE, NULL)
                 END
                ) fechaDeclaInvPreviaUnicoDictEject, --Fecha de declaración de invalidez previa único dictamen ejecutoriado - Campo 11
                (CASE
                    WHEN (u1.codigoTipoPension IN ('15', '16')) THEN u1.fecsol
                    ELSE CONVERT(DATE, NULL)
                 END
                ) fechaDeclaInvUnicoDictEjectLey18964, --Fecha de declaración de invalidez único dictamen ejecutoriado anteriores a la Ley N° 18.964 - Campo 12
                (CASE
                    WHEN (u1.codigoTipoPension IN ('19', cchCodigoInvPAET)) THEN u1.fecsol 
                    ELSE CONVERT(DATE, NULL)
                 END
                ) fechaDeclaInvTotalUnicoDictEjectLey20255, --Fecha de declaración de invalidez total único dictamen ejecutoriado según ley N° 20.255 - Campo 13
                (CASE 
                    WHEN (u1.codigoTipoPension IN ('13', '14', '15', '16', '19', cchCodigoInvPAET)) THEN  
                        CASE
                            WHEN (u1.codigoTipoPension IN ('13', '15', '16', '19', cchCodigoInvPAET)) THEN 'T' 
                            ELSE 'P'--invalidez parcial
                         END
                    ELSE 'N'
                 END
                ) gradoInvalidezUnicoDictEject, --Grado de invalidez único dictamen ejecutoriado - Campo 14        
                (CASE
                    WHEN ((u1.codigoTipoPension IN ('11', '12')) AND 
                          (u1.fecejec_cmc IS NOT NULL)) THEN 
                        u1.fecejec_cmc
                    WHEN ((u1.codigoTipoPension IN ('11', '12')) AND 
                          (u1.fecejec_cmr IS NOT NULL)) THEN 
                        u1.fecejec_cmr
                    ELSE CONVERT(DATE, NULL)
                 END
                ) fecEjecutSegundoDic,
                (CASE
                    WHEN (u1.codigoTipoPension IN ('11', '12')) THEN
                        CASE u1.codigoTipoPension
                            WHEN '11' THEN 'T'--invalidez Total
                            WHEN '12' THEN 'P'--invalidez parcial
                        END
                    ELSE
                        'N'
                 END
                ) gradoInvalidezSegundoDictEject, --Grado de invalidez segundo dictamen ejecutoriado - Campo 16
                (CASE
                    WHEN ((u1.codigoTipoPension IN ('11', '12')) AND 
                          (u1.fecresol_cmc IS NOT NULL)) THEN 
                        u1.fecresol_cmc
                    WHEN ((u1.codigoTipoPension IN ('11', '12')) AND 
                          (u1.fecdicta_cmr IS NOT NULL)) THEN 
                        u1.fecdicta_cmr
                    ELSE CONVERT(DATE, NULL)
                 END
                ) fechaSegundoDictEject,
                (CASE
                    WHEN ((u1.tipoben = 6) AND (it.tipoben = 3) AND 
                          (u1.codigoTipoPension IN ('11', '12')) AND
                          (it.codigoTipoPension IN ('17', '18'))) THEN
                        CASE 
                            WHEN (it.fecejec_cmc IS NOT NULL) THEN it.fecejec_cmc
                            ELSE it.fecejec_cmr
                        END
                    WHEN ((u1.tipoben = 3) AND (u1.codigoTipoPension IN ('17', '18'))) THEN
                        CASE 
                            WHEN (u1.fecejec_cmc IS NOT NULL) THEN u1.fecejec_cmc
                            ELSE u1.fecejec_cmr
                        END
                    ELSE CONVERT(DATE, NULL)
                 END
                ) fechaEjecutPrimerDictInv, --Fecha en que quedó ejecutoriado el primer dictamen de invalidez - Campo 18    
                (CASE
                    WHEN ((u1.codigoTipoPension IN ('13', '14', '15', '16', '19')) AND 
                          (u1.fecejec_cmc IS NOT NULL)) THEN 
                        u1.fecejec_cmc
                    WHEN ((u1.codigoTipoPension IN ('13', '14', '15', '16', '19', cchCodigoInvPAET)) AND 
                          (u1.fecejec_cmr IS NOT NULL)) THEN 
                        u1.fecejec_cmr
                    ELSE CONVERT(DATE, NULL)
                 END
                ) fechaEjecutUnicoDictInv, --Fecha en que quedó ejecutoriado el único dictamen de invalidez - Campo 19
                (CASE
                    WHEN ((u1.codigoTipoPension IN ('11', '12', '13', '14', '15', '16', '19')) AND 
                          (p.numcue IS NOT NULL)) THEN 
                        p.fecemi_cersal
                    ELSE CONVERT(DATE, NULL)
                 END 
                ) fechaEmisionCersal, --Fecha emisión Certificado de Saldo para seleccionar modalidad de pensión - Campo 20
                (CASE
                    WHEN (u1.codigoTipoPension IN ('11', '12', '13', '14', '19')) THEN 
                        fc.fec_calculo
                    ELSE CONVERT(DATE, NULL)
                 END 
                ) fechaEmisionPrimeraFichaCalculoRP, --Fecha emisión primera ficha de cálculo para RP - Campo 21
                (CASE
                    WHEN u1.tipoben = ctiCodigoPAET THEN   
                        u1.monto_aporte_adicional
                    WHEN ((u1.tipoben = 6) AND (m5.monto IS NOT NULL)) THEN
                        m5.monto
                    ELSE 0.0
                 END) montoTotalAporteAdicionalUF, --Monto total del aporte adicional, en UF - Campo 22
                (CASE                   
                    WHEN ( u1.tipoben = ctiCodigoPAET AND u1.codigoTipoCobertura = '01' ) THEN 
                        ISNULL(u1.pension_referencia, 0.0)
                    WHEN ((u1.tipoben IN (3, 6)) AND (u1.codestsol = 2) AND 
                          (u1.codigoTipoCobertura IN ('01', '02'))) THEN
                        ISNULL(u1.pension_referencia, 0.0)
                    ELSE
                        0.0
                 END
                ) pensionReferenciaUF, --Pensión de referencia, en UF - Campo 23
                (CASE
                    WHEN ((u1.tipoben = 6) AND (it.tipoben = 3) AND 
                          (u1.codigoTipoPension IN ('11', '12')) AND
                          (it.codigoTipoPension IN ('17', '18')) AND
                          (u1.codigoTipoCobertura IN ('01', '02'))) THEN 
                        CASE
                            WHEN(ISNULL(u1.ingreso_base, 0) > ISNULL(it.ingreso_base, 0) AND 
                                 ISNULL(it.valorUF, 0) > 0) THEN 
                                CONVERT(NUMERIC(8, 3), ROUND((u1.ingreso_base/it.valorUF), 3))
                            WHEN(it.ingreso_base > 0) THEN 
                                ISNULL(it.ingresoBaseUF, 0.0)
                            ELSE ISNULL(u1.ingresoBaseUF, 0.0) 
                        END                       
                    WHEN ((u1.tipoben IN (3, 6)) AND (u1.codestsol = 2) AND 
                          (u1.codigoTipoCobertura IN ('01', '02'))) THEN
                        ISNULL(u1.ingresoBaseUF, 0.0)
                    WHEN ( u1.tipoben = ctiCodigoPAET AND u1.codigoTipoCobertura ='01' ) THEN   
                        ISNULL(u1.ingresoBaseUF, 0.0)
                    ELSE
                        0.0
                 END
                ) ingresoBaseUF, --Ingreso Base, en UF - Campo 24   
                (CASE
                    WHEN ((u1.codigoTipoPension IN ('11', '12', '13', '14', '19', cchCodigoInvPAET)) AND 
                          (p.promedio_remuner_uf IS NOT NULL)) THEN
                        p.promedio_remuner_uf 
                    ELSE 0.0
                 END
                ) promedioRentasUF, --Promedio de Rentas y/o remuneraciones, en UF - Campo 25
                (CASE
                    WHEN (u1.tipoben = 6) THEN
                        u1.nro_meses_con_renta 
                    ELSE
                        0
                 END) numRemunEfectivas, --Número de remuneraciones efectivas consideradas en el promedio de rentas y/o remuneraciones - Campo 26
                ISNULL(ci.codigoPaisRecepcion, cstCodigoPaisChile) codigoPaisSolicitaPension, --Código del país donde solicita la pensión - Campo 28
                (CASE
                    WHEN (codigoPaisSolicitaPension = cstCodigoPaisChile) THEN 
                        rsp.codigoRegionSolicitaPension
                    ELSE '00'
                 END
                ) codigoRegionSolicitaPension, --Región donde solicita la pensión - Campo 29
                (CASE
                    WHEN (u1.tipoben = 6) THEN
                        p.fec_emision_selmod 
                    ELSE CONVERT(DATE, NULL)
                 END
                ) fechaSelModPen, --Fecha de selección de modalidad de pensión - Campo 30
                --docup.fec_liquidacion fechaPrimerPagoPenDef, --Fecha de primer pago de pensión definitiva - Campo 31
				--- DATAWCL-383
                CASE
                    WHEN u1.indFechaMes = 'N' AND ufa.fecPrimerPagoPensionDef IS NOT NULL THEN ufa.fecPrimerPagoPensionDef
                    WHEN u1.indFechaMes = 'N' AND ufa.fecPrimerPagoPensionDef IS NULL THEN docup.fec_liquidacion
                    WHEN u1.indFechaMes = 'S' THEN docup.fec_liquidacion
                END AS fechaPrimerPagoPenDef,
                 --- FIN DATAWCL-383				
                (CASE
                    WHEN ( u1.indProcReev = cchS AND u1.fecsolProcReev IS NOT NULL AND u1.codigoEstadoReevaluacion NOT IN (ctiCodEstSolRevRechazada, ctiCodEstSolSinSolRev)) THEN
                        u1.fecsolProcReev
                    WHEN (u1.codigoTipoPension IN ('11', '12')) THEN
                        u1.fecsol
                    ELSE CONVERT(DATE, NULL)
                 END
                ) fechaSolReevalInvalidez, --Fecha de la solicitud de reevaluación de invalidez - Campo 15'' Nuevo Campo
                (CASE
                    WHEN (u1.codigoTipoPension = cch15 AND ISNULL(p.modpen_selmod, ctiCero) = ctiCero) THEN 
                        ctiDos
                    WHEN u1.codigoTipoPension = cchCodigoInvPAET THEN 
                        ctiCinco
                    ELSE
                        p.modpen_selmod 
                 END) AS codigoModalidadAFP,
                (CASE 
                    WHEN (u1.codigoEstadoReevaluacion IN (ctiCodEstSolRevRechazada, ctiCodEstSolSinSolRev)) THEN 
                        u1.codigoEstadoReevaluacion
                    WHEN (u1.codestsol = 1) THEN 
                        CONVERT(INTEGER, 1) --En tramite
                    WHEN (u1.codestsol = 2) THEN 
                        CONVERT(INTEGER, 4) --Aprobado
                    ELSE 
                        CONVERT(INTEGER, 0) --Sin Clasificar
                 END) codigoEstadoSolicitud, --Código del estado de la solicitud
                u1.codestsol,
                u1.fecha_codestsol fechaEstadoSolicitud,
                u1.fedevpen,
                (CASE
                    WHEN ((u1.tipoben = 6) AND (it.tipoben = 3) AND 
                          (u1.codigoTipoPension IN ('11', '12')) AND
                          (it.codigoTipoPension IN ('17', '18'))) THEN
                        it.fedevpen
                    WHEN ((u1.tipoben = 3) AND (u1.codigoTipoPension IN ('17', '18'))) THEN
                        u1.fedevpen
                    ELSE NULL
                 END
                ) fechaDevPenTranst,
                ISNULL(p.saldo_retenido_uf, 0.0) saldoRetenidoUF,
                (CASE
                    WHEN ((u1.tipoben = 6) AND (it.tipoben = 3)) THEN 
                         DATE(DATEFORMAT(it.fecsol, 'YYYYMM') || '01') 
                    ELSE
                        DATE(DATEFORMAT(u1.fecsol, 'YYYYMM') || '01') 
                 END) periodoSolicitudPensionInvalidez,
                (CASE 
                    WHEN ((u1.fechaNacimiento IS NOT NULL) AND 
                          (u1.fechaNacimiento < ISNULL(u1.fedevpen, u1.fecsol))) THEN
                        CONVERT(BIGINT, (DATEDIFF(mm, u1.fechaNacimiento, ISNULL(u1.fedevpen, u1.fecsol))/12))
                    ELSE NULL
                 END) edad,
                CONVERT(BIGINT, NULL) idError,
                it.fec_devenga_sisant,
                (CASE
                    WHEN ((u1.codigoTipoPension IN ('11', '12')) AND 
                          (it.fecresol_cmc IS NOT NULL)) THEN 
                        it.fecresol_cmc
                    WHEN ((u1.codigoTipoPension IN ('11', '12')) AND 
                          (it.fecdicta_cmr IS NOT NULL)) THEN 
                        it.fecdicta_cmr
                    WHEN ((u1.codigoTipoPension IN ('13', '14', '15', '16', '17', '18', '19')) AND 
                          (u1.fecresol_cmc IS NOT NULL)) THEN 
                        u1.fecresol_cmc
                    WHEN ((u1.codigoTipoPension IN ('13', '14', '15', '16', '17', '18', '19', cchCodigoInvPAET)) AND 
                          (u1.fecdicta_cmr IS NOT NULL)) THEN 
                        u1.fecdicta_cmr
                    ELSE CONVERT(DATE, NULL)
                 END) fecEmiPrimUnicoDictEjec,
                u1.porcentaje_cobertura_seg,
                CONVERT(BIGINT, DATEFORMAT( u1.fecha_codestsol, 'YYYYMM' )) AS periodoEstadoSolicitud,
                fechaDefuncion,
                u1.indProcReev,
                u1.fecdicta_cmr ,
                u1.regionDictaCMR ,
                u1.nroDictaCMR ,
                u1.anioDictaCMR
            INTO #DatosRegistrar_Universo_1
            FROM dchavez.UniversoInvalidezTMP u1
                LEFT OUTER JOIN #IndicadorArt69Universo1 ia69 ON u1.numcue = ia69.numcue
                AND ia69.tipoben = u1.tipoben 
                AND ia69.fecsol = u1.fecsol
                LEFT OUTER JOIN #STP_PENCERSA_CONDICION_U1 p ON u1.numcue = p.numcue 
                AND u1.tipoben = p.tipoben 
                AND u1.fecsol = p.fecsol
                LEFT OUTER JOIN #TB_MAE_MOVIMIENTO_87 m87 ON u1.idPersonaOrigen = m87.id_mae_persona
                LEFT OUTER JOIN #ConvenioInternacionalTMP ci ON u1.rut = ci.numrut
                LEFT OUTER JOIN #RegionSolicitaPensionTMP rsp ON u1.numcue = rsp.numcue
                AND rsp.tipoben = u1.tipoben 
                AND rsp.fecsol = u1.fecsol
				 --- DATAWCL-383
                LEFT OUTER JOIN #UniversoFechaAnterior ufa ON (u1.rut = ufa.rut AND u1.fecsol = ufa.fechaSolicitud )
                --- FIN DATAWCL-383
                LEFT OUTER JOIN #SLB_DOCUPAGO_U1 docup ON u1.numcue = docup.numcue 
                AND u1.tipoben = docup.tipoben 
                AND u1.fecsol = docup.fecsol
                LEFT OUTER JOIN #FichasCalculoMF fc ON u1.numcue = fc.numcue 
                AND u1.tipoben = fc.tipoben 
                AND u1.fecsol = fc.fecsol
                LEFT OUTER JOIN #InvalidosTransitorios_U1 it ON u1.numcue = it.numcue_u1
                AND u1.tipoben = it.tipoben_u1
                AND u1.fecsol = it.fecsol_u1
                LEFT OUTER JOIN #TB_MAE_MOVIMIENTO_5_U1 m5 ON u1.numcue = m5.numcue
                AND u1.tipoben = m5.tipoben
                AND u1.fecsol = m5.fecsol
            WHERE u1.numeroUniverso = 1;
			
			DROP TABLE #UniversoFechaAnterior; -- DATAWCL-383

            --Remuneraciones PAET
            SELECT DISTINCT p.numcue, 
                p.tipoben,
                p.fecsol, 
                (CASE 
                    WHEN (ISNULL(p.promedio_remuner_uf, 0) = ctiCero) THEN 
                        (CASE 
                            WHEN (ISNULL(s.promedio_rentas_120meses, 0) = ctiCero) THEN 
                                p.promedio_remuner_uf 
                            ELSE 
                                (CASE 
                                    WHEN (s.promedio_rentas_120meses > lnuValorTopeImponible) THEN 
                                        ctiCero
                                    ELSE 
                                        s.promedio_rentas_120meses 
                                 END)
                         END) 
                    ELSE
                        p.promedio_remuner_uf
                 END) promedio_remuner_uf
            INTO #pencersaPaet
            FROM DDS.STP_PENCERSA p
                INNER JOIN #DatosRegistrar_Universo_1 u ON (u.numcue = p.numcue 
                AND u.tipoben = p.tipoben 
                AND u.fecsol = p.fecsol)
                LEFT JOIN DDS.stp_solicpen s ON (s.numcue = p.numcue 
                AND s.tipoben = p.tipoben 
                AND s.fecsol = p.fecsol)
            WHERE u.codigoTipoPension = cchCodigoInvPAET;
            
            UPDATE #DatosRegistrar_Universo_1
            SET promedioRentasUF = p.promedio_remuner_uf
            FROM #DatosRegistrar_Universo_1 u
                INNER JOIN #pencersaPaet p ON (u.numcue = p.numcue 
                AND u.tipoben = p.tipoben 
                AND u.fecsol = p.fecsol);       
            
    
            --Asignación modalidad 11
            --Casos afiliado fallecido
            UPDATE #DatosRegistrar_Universo_1 SET 
                u.codigoModalidadPension = '11'
            FROM #DatosRegistrar_Universo_1 u
              JOIN DDS.STP_SOLICPEN s ON u.numcue  = s.numcue      
            WHERE s.codestsol IN (1, 2)
              AND s.tipoBen IN (7, 8, 9)
              AND u.codigoModalidadPension = '0'
              AND u.codigoTipoPension IN('11', '12', '13', '14', '19', cchCodigoInvPAET)
              AND u.fecsol >= '1996-01-01';
    
            --Casos sin afiliado fallecido tipo pensión 13 y 14 se agrega modalidad 08
            UPDATE #DatosRegistrar_Universo_1 SET 
                u.codigoModalidadPension = '08',
                u.codigoModalidadAFP = 1
            FROM #DatosRegistrar_Universo_1 u
                JOIN DDS.TB_MAE_MOVIMIENTO m ON (u.idPersonaOrigen = m.id_mae_persona)
                JOIN DDS.TB_TIP_MOVIMIENTO tm ON (m.id_tip_movimiento = tm.id_tip_movimiento)
            WHERE u.codigoTipoPension IN('13', '14')
            AND u.codigoModalidadPension = '0'
            AND u.fecsol >= '1996-01-01'
            AND tm.cod_movimiento IN(63, 66)
            AND m.fec_movimiento >= fechaEjecutUnicoDictInv;
    
            UPDATE #DatosRegistrar_Universo_1 SET 
                u.codigoModalidadPension = '01',
                u.codigoModalidadAFP = 3
            FROM #DatosRegistrar_Universo_1 u
                JOIN dchavez.UniversoMovimientosRVTMP m ON (u.idPersonaOrigen = m.id_mae_persona)
            WHERE u.codigoTipoPension IN ('13', '14')
            AND u.codigoModalidadPension = '0'
            AND u.fecsol >= '1996-01-01'
            AND m.fec_movimiento >= fechaEjecutUnicoDictInv;
            
            --Casos sin afiliado fallecido tipo pensión 19
            UPDATE #DatosRegistrar_Universo_1 SET 
                u.codigoModalidadPension = '08',
                u.codigoModalidadAFP = 1
            FROM #DatosRegistrar_Universo_1 u
                JOIN DDS.TB_MAE_MOVIMIENTO m ON (u.idPersonaOrigen = m.id_mae_persona)
                JOIN DDS.TB_TIP_MOVIMIENTO tm ON (m.id_tip_movimiento = tm.id_tip_movimiento)
            WHERE u.codigoTipoPension = '19'
            AND u.codigoModalidadPension = '0'
            AND u.fecsol >= '1996-01-01'
            AND tm.cod_movimiento IN (63, 66)
            AND m.fec_movimiento >= fechaEjecutUnicoDictInv;
    
            UPDATE #DatosRegistrar_Universo_1 SET 
                u.codigoModalidadPension = '01',
                u.codigoModalidadAFP = 3
            FROM #DatosRegistrar_Universo_1 u
                JOIN dchavez.UniversoMovimientosRVTMP m ON (u.idPersonaOrigen = m.id_mae_persona)
            WHERE u.codigoTipoPension = '19'
            AND u.codigoModalidadPension = '0'
            AND u.fecsol >= '1996-01-01'
            AND m.fec_movimiento >= fechaEjecutUnicoDictInv;
    
           --Casos sin afiliado fallecido tipo pensión 11 y 12
            UPDATE #DatosRegistrar_Universo_1 SET 
                u.codigoModalidadPension = '08',
                u.codigoModalidadAFP = 1
            FROM #DatosRegistrar_Universo_1 u
                JOIN DDS.TB_MAE_MOVIMIENTO m ON (u.idPersonaOrigen = m.id_mae_persona)
                JOIN DDS.TB_TIP_MOVIMIENTO tm ON (m.id_tip_movimiento = tm.id_tip_movimiento)
            WHERE u.codigoTipoPension IN ('11', '12')
            AND u.codigoModalidadPension = '0'
            AND u.fecsol >= '1996-01-01'
            AND tm.cod_movimiento IN (63, 66)
            AND m.fec_movimiento >= fecEjecutSegundoDic;
          
            UPDATE #DatosRegistrar_Universo_1 SET 
                u.codigoModalidadPension = '01',
                u.codigoModalidadAFP = 3
            FROM #DatosRegistrar_Universo_1 u
                JOIN dchavez.UniversoMovimientosRVTMP m ON (u.idPersonaOrigen = m.id_mae_persona)
            WHERE u.codigoTipoPension IN ('11','12')
            AND u.codigoModalidadPension = '0'
            AND u.fecsol >= '1996-01-01'
            AND m.fec_movimiento >= fecEjecutSegundoDic;
    
            -- Obtener fecha de ficha de calculo para registros anteriores 2003-05-05 tipo 
            -- pensión 11,12,17,18
            SELECT u.idPersonaOrigen,
                u.codigoTipoPension,
                MIN(m.fec_movimiento) fec_movimiento 
            INTO #UniversoMenMovimiento
            FROM #DatosRegistrar_Universo_1 u
                INNER JOIN DDS.TB_MAE_MOVIMIENTO m ON (u.idPersonaOrigen = m.id_mae_persona)
                INNER JOIN DDS.TB_TIP_MOVIMIENTO tm ON (m.id_tip_movimiento = tm.id_tip_movimiento)
            WHERE u.codigoTipoPension IN('11', '12', '17', '18')
            AND fechaEmiFCPensionTransit IS NULL
            AND tm.cod_movimiento IN(63, 66)
            AND m.fec_movimiento >= fechaEjecutPrimerDictInv
            GROUP BY u.idPersonaOrigen, u.codigoTipoPension;
    
            UPDATE #DatosRegistrar_Universo_1 SET 
                u.fechaEmiFCPensionTransit = b.fec_movimiento
            FROM #DatosRegistrar_Universo_1 u
                JOIN #UniversoMenMovimiento b ON (u.idPersonaOrigen = b.idPersonaOrigen 
                AND u.codigoTipoPension = b.codigoTipoPension);
            
            --Si no tiene fecha de emisión ficha de calculo para la pensión transitoria
            SELECT DISTINCT fechaEjecutPrimerDictInv
            INTO #FechaEjecutPrimerDictInvTMP
            FROM #DatosRegistrar_Universo_1
            WHERE codigoTipoPension IN('11', '12', '17', '18')
            AND fechaEmiFCPensionTransit IS NULL
            AND fechaEjecutPrimerDictInv IS NOT NULL;
                
            SELECT fechaEjecutPrimerDictInv,
                DMGestion.obtenerDiaHabil(DATEADD(DAY, 1, fechaEjecutPrimerDictInv)) fechaHabil1Dia,
                DMGestion.obtenerDiaHabil(DATEADD(DAY, 1, fechaHabil1Dia)) fechaHabil2Dia,
                DMGestion.obtenerDiaHabil(DATEADD(DAY, 1, fechaHabil2Dia)) fechaHabil3Dia,
                DMGestion.obtenerDiaHabil(DATEADD(DAY, 1, fechaHabil2Dia)) fechaHabil4Dia,
                DMGestion.obtenerDiaHabil(DATEADD(DAY, 1, fechaHabil2Dia)) fechaHabil5Dia
            INTO #FechaEmiFCPenTranHabilTMP
            FROM #FechaEjecutPrimerDictInvTMP;
    
            UPDATE #DatosRegistrar_Universo_1 SET 
                u.fechaEmiFCPensionTransit = f.fechaHabil5Dia
            FROM #DatosRegistrar_Universo_1 u
                JOIN #FechaEmiFCPenTranHabilTMP f ON (u.fechaEjecutPrimerDictInv = f.fechaEjecutPrimerDictInv)
            WHERE u.codigoTipoPension IN('11', '12', '17', '18')
            AND u.fechaEmiFCPensionTransit IS NULL;
    
            --debido a que existen casos que no tienen modalidad de pension en la tabla pencersa, 
            --se obtiene de la tabla slb_beneficios
            SELECT u.idDimPersona, 
                u.codigoTipoPension,
                u.fecsol,
                u.tipoben,
                u.numcue,
                u.modalidad,
                u.tipo_pago
            INTO #SLB_Beneficios_Universo01_TMP
            FROM (
                SELECT a.idDimPersona, 
                    a.codigoTipoPension,
                    a.fecsol,
                    a.tipoben,
                    a.numcue,
                    b.modalidad,
                    b.tipo_pago
                FROM #DatosRegistrar_Universo_1 a   
                    INNER JOIN DDS.SLB_BENEFICIOS b ON (a.numcue = b.numcue
                    AND a.tipoben = b.tipoben)
                WHERE (a.fecsol = b.fecsol OR a.fedevpen = b.fecsol)
                AND a.codigoModalidadPension = '0'
                AND b.tipo_pago = 2
                UNION
                SELECT a.idDimPersona, 
                    a.codigoTipoPension,
                    a.fecsol,
                    a.tipoben,
                    a.numcue,
                    b.modalidad,
                    b.tipo_pago
                FROM #DatosRegistrar_Universo_1 a   
                    INNER JOIN DDS.SLB_BENEFICIOS b ON (a.numcue = b.numcue
                    AND a.fecsol = b.fecsol)
                WHERE a.codigoModalidadPension = '0'
                AND b.tipo_pago = 2
                AND a.tipoben = 5
                AND b.tipoben = 6
            ) u;
    
            SELECT idDimPersona, 
                codigoTipoPension,
                numcue, 
                tipoben, 
                fecsol, 
                MIN(modalidad) modalidad, 
                COUNT(*) cantidadRegistrosIguales
            INTO #SLB_Beneficios_Universo01_Menor_TMP
            FROM #SLB_Beneficios_Universo01_TMP
            GROUP BY idDimPersona, codigoTipoPension, numcue, tipoben, fecsol
            HAVING cantidadRegistrosIguales > 1;
        
            DELETE FROM #SLB_Beneficios_Universo01_TMP
            FROM #SLB_Beneficios_Universo01_TMP a, #SLB_Beneficios_Universo01_Menor_TMP b
            WHERE a.idDimPersona = b.idDimPersona
            AND a.codigoTipoPension = b.codigoTipoPension
            AND a.numcue = b.numcue
            AND a.tipoben = b.tipoben
            AND a.fecsol = b.fecsol 
            AND a.modalidad = b.modalidad;
    
            UPDATE #DatosRegistrar_Universo_1 SET
                a.codigoModalidadPension = (CASE b.modalidad
                                                WHEN 1 THEN CONVERT(CHAR(2), '08')
                                                WHEN 3 THEN CONVERT(CHAR(2), '01')
                                                WHEN 5 THEN CONVERT(CHAR(2), '03')
                                                ELSE '0'
                                            END),
                a.codigoModalidadAFP = b.modalidad
            FROM #DatosRegistrar_Universo_1 a
                JOIN #SLB_Beneficios_Universo01_TMP b ON (a.idDimPersona = b.idDimPersona
                AND a.codigoTipoPension = b.codigoTipoPension
                AND a.numcue = b.numcue
                AND a.tipoben = b.tipoben
                AND a.fecsol = b.fecsol)
            WHERE a.codigoModalidadPension = '0';
    
            UPDATE #DatosRegistrar_Universo_1 SET
                a.codigoModalidadPension    = b.codigoModalidadPensionReemplazar,
                a.codigoModalidadAFP        = b.codigoModalidadAFPReemplazar
            FROM #DatosRegistrar_Universo_1 a
                JOIN DDS.TramitePensionAprobadoDatoIncompleto b ON (a.rut = b.rut
                AND a.fecsol = b.fechaSolicitud
                AND a.tipoben = b.tipoBeneficio
                AND a.codigoModalidadPension = b.codigoModalidadPension)
            WHERE b.indRegistroInformar             = cchSi
            AND b.indInfModalidadPensionReemplazar  = cchSi
            AND b.tramitePension                    = cchCodigoIN;
            
            -- Casos sin modalidad se deja por defecto RP (08)
            UPDATE #DatosRegistrar_Universo_1 SET 
                u.codigoModalidadPension = '08',
                u.codigoModalidadAFP = 1
            FROM #DatosRegistrar_Universo_1 u 
            WHERE u.codigoModalidadPension = '0';
    
            ----------------------------------------------------------------------------------------------------
            --Integración de universos
            ----------------------------------------------------------------------------------------------------
            --15. Integración del Universo 1 y Universo 2
            SELECT u.numeroFila,
                u.fechaNacimiento,
                u.sexo,
                u.fecsol,
                u.tipoben,
                u.numcue,
                u.idDimPersona, --Campo 2
                u.rut, --Campo 2
                u.idPersonaOrigen,
                u.indicadorArt17, --Indicador artículo 17 transitorio - Campo 4
                u.indicadorArt69, --Indicador artículo 69 - Campo 5
                u.codigoTipoPension, --Tipo de pensión de vejez - Campo 6
                dtp.id idDimTipoPension, --Tipo de pensión de vejez - Campo 6
                u.codigoModalidadPension, --Modalidad de pensión seleccionada al pensionarse - Campo 7
                dmp.id idDimModalidadPension, --Modalidad de pensión seleccionada al pensionarse - Campo 7
                u.fechaDeclInvPrimerDictEject, --Fecha de declaración de invalidez primer dictamen ejecutoriado - Campo 8
                u.gradoInvalidezPrimerDictEject, --Grado de invalidez primer dictamen ejecutoriado - Campo 9
                u.fechaEmiFCPensionTransit, --Fecha emisión ficha de cálculo para PensiónTransitoria - Campo 10
                u.fechaDeclaInvPreviaUnicoDictEject, --Fecha de declaración de invalidez previa único dictamen ejecutoriado - Campo 11
                u.fechaDeclaInvUnicoDictEjectLey18964, --Fecha de declaración de invalidez único dictamen ejecutoriado anteriores a la Ley N° 18.964 - Campo 12
                u.fechaDeclaInvTotalUnicoDictEjectLey20255, --Fecha de declaración de invalidez total único dictamen ejecutoriado según ley N° 20.255 - Campo 13
                u.gradoInvalidezUnicoDictEject, --Grado de invalidez único dictamen ejecutoriado - Campo 14
                u.fechaSegundoDictEject, --Fecha de segundo dictamen ejecutoriado - Campo 15
                u.fecEjecutSegundoDic,
                u.gradoInvalidezSegundoDictEject, --Grado de invalidez segundo dictamen ejecutoriado - Campo 16
                u.fechaEjecutPrimerDictInv, --Fecha en que quedó ejecutoriado el primer dictamen de invalidez - Campo 18
                u.fechaEjecutUnicoDictInv, --Fecha en que quedó ejecutoriado el único dictamen de invalidez - Campo 19
                u.fechaEmisionCersal, --Fecha emisión Certificado de Saldo para seleccionar modalidad de pensión - Campo 20
                u.fechaEmisionPrimeraFichaCalculoRP, --Fecha emisión primera ficha de cálculo para RP - Campo 21
                u.montoTotalAporteAdicionalUF, --Monto total del aporte adicional, en UF - Campo 22
                u.pensionReferenciaUF, --Pensión de referencia, en UF - Campo 23
                u.ingresoBaseUF, --Ingreso Base, en UF - Campo 24   
                u.promedioRentasUF, --Promedio de Rentas y/o remuneraciones, en UF - Campo 25
                u.numRemunEfectivas, --Número de remuneraciones efectivas consideradas en el promedio de rentas y/o remuneraciones - Campo 26
                CONVERT(NUMERIC(6, 2), NULL) remImpUltCotAnFecSolPenUF, --Remuneración imponible asociada a la última cotización anterior a la fecha 
                                                                        --de la solicitud de pensión, en UF - Campo 27
                u.codigoPaisSolicitaPension, --Código del país donde solicita la pensión - Campo 28
                u.codigoRegionSolicitaPension, --Región donde solicita la pensión - Campo 29
                u.fechaSelModPen, --Fecha de selección de modalidad de pensión - Campo 30
                u.fechaPrimerPagoPenDef, --Fecha de primer pago de pensión definitiva - Campo 31
                u.codigoTipoCobertura, --Cobertura al pensionarse por invalidez - Campo 48
                u.fechaSolReevalInvalidez, --Fecha de la solicitud de reevaluación de invalidez - Campo 15'' Nuevo Campo
                u.periodoSolicitudPensionInvalidez,
                CONVERT(DATE, NULL) fecUltCotAntFecSolPension,        
                u.codigoTipoAnualidad,
                dta.id idDimTipoAnualidad,
                u.codigoTipoRecalculo,
                dtr.id idDimTipoRecalculo,
                u.codigoCausalRecalculo,
                dcr.id idDimCausalRecalculo,
                CONVERT(DATE, NULL) fechaCalculo,
                u.codigoModalidadAFP,
                u.codigoEstadoSolicitud, --Código del estado de la solicitud
                des.id idDimEstadoSolicitud,
                u.fechaEstadoSolicitud,
                u.saldoRetenidoUF,
                u.edad,
                u.fedevpen,
                CONVERT(NUMERIC(10, 2), 0.0) pensionMinimaUF,
                CONVERT(NUMERIC(10, 2), 0.0) pensionBasicaSolidariaUF,
                u.numeroUniverso,
                u.idError,
                u.indScomp,
                u.mesesEfecRebaja,
                u.fec_devenga_sisant,
                u.montoPrimPensDefUF,
                u.montoPensionTranUF,
                u.factorAjuste,
                u.factorActuorialmenteJusto,
                u.fecEmiPrimUnicoDictEjec,
                u.montoPrimPensDefRTUF,
                u.codestsol,
                u.porcentaje_cobertura_seg,
                u.fechaDevPenTranst,
                (CASE
                    WHEN (u.codigoTipoPension IN ('11', '12')) THEN
                        u.fechaSegundoDictEject
                    WHEN (u.codigoTipoPension IN ('13', '14', '19', cchCodigoInvPAET)) THEN 
                        ISNULL(u.fechaDeclInvPrimerDictEject, 
                               ISNUll(u.fechaDeclaInvPreviaUnicoDictEject, 
                                      ISNULL(u.fechaDeclaInvTotalUnicoDictEjectLey20255, 
                                             ISNULL(u.fechaDeclaInvUnicoDictEjectLey18964, u.fechaSolReevalInvalidez))))
                    ELSE NULL
                 END) fechaInvalidez,
                CONVERT(DATE, NULL) fechaCierre,
                fechaDefuncion,
                indProcReev             AS  indProcesoReevaluacion,
                fecdicta_cmr            AS  fechaDictamen,
                ISNULL( hcm.codigoDimension, cchCodigoSinClasificar )AS codigoComisionMedica,
                nroDictaCMR             AS  numeroDictamen,
                anioDictaCMR            AS anioDictamen
            INTO #DatosRegistro_U1_U2
            FROM (
                SELECT numeroFila,
                    fechaNacimiento,
                    sexo,
                    fecsol,
                    tipoben,
                    numcue,
                    idDimPersona, --Campo 2
                    rut, --Campo 2
                    idPersonaOrigen,
                    indicadorArt17, --Indicador artículo 17 transitorio - Campo 4
                    indicadorArt69, --Indicador artículo 69 - Campo 5
                    codigoTipoPension, --Tipo de pensión de vejez - Campo 6
                    codigoModalidadPension, --Modalidad de pensión seleccionada al pensionarse - Campo 7
                    fechaDeclInvPrimerDictEject, --Fecha de declaración de invalidez primer dictamen ejecutoriado - Campo 8
                    gradoInvalidezPrimerDictEject, --Grado de invalidez primer dictamen ejecutoriado - Campo 9
                    fechaEmiFCPensionTransit, --Fecha emisión ficha de cálculo para PensiónTransitoria - Campo 10
                    fechaDeclaInvPreviaUnicoDictEject, --Fecha de declaración de invalidez previa único dictamen ejecutoriado - Campo 11
                    fechaDeclaInvUnicoDictEjectLey18964, --Fecha de declaración de invalidez único dictamen ejecutoriado anteriores a la Ley N° 18.964 - Campo 12
                    fechaDeclaInvTotalUnicoDictEjectLey20255, --Fecha de declaración de invalidez total único dictamen ejecutoriado según ley N° 20.255 - Campo 13
                    gradoInvalidezUnicoDictEject, --Grado de invalidez único dictamen ejecutoriado - Campo 14
                    fechaSegundoDictEject, --Fecha de segundo dictamen ejecutoriado - Campo 15
                    fecEjecutSegundoDic,
                    gradoInvalidezSegundoDictEject, --Grado de invalidez segundo dictamen ejecutoriado - Campo 16
                    fechaEjecutPrimerDictInv, --Fecha en que quedó ejecutoriado el primer dictamen de invalidez - Campo 18
                    fechaEjecutUnicoDictInv, --Fecha en que quedó ejecutoriado el único dictamen de invalidez - Campo 19
                    fechaEmisionCersal, --Fecha emisión Certificado de Saldo para seleccionar modalidad de pensión - Campo 20
                    fechaEmisionPrimeraFichaCalculoRP, --Fecha emisión primera ficha de cálculo para RP - Campo 21
                    montoTotalAporteAdicionalUF, --Monto total del aporte adicional, en UF - Campo 22
                    pensionReferenciaUF, --Pensión de referencia, en UF - Campo 23
                    ingresoBaseUF, --Ingreso Base, en UF - Campo 24   
                    promedioRentasUF, --Promedio de Rentas y/o remuneraciones, en UF - Campo 25
                    numRemunEfectivas, --Número de remuneraciones efectivas consideradas en el promedio de rentas y/o remuneraciones - Campo 26
                    codigoPaisSolicitaPension, --Código del país donde solicita la pensión - Campo 28
                    codigoRegionSolicitaPension, --Región donde solicita la pensión - Campo 29
                    fechaSelModPen, --Fecha de selección de modalidad de pensión - Campo 30
                    fechaPrimerPagoPenDef, --Fecha de primer pago de pensión definitiva - Campo 31
                    codigoTipoCobertura, --Cobertura al pensionarse por invalidez - Campo 48
                    fechaSolReevalInvalidez, --Fecha de la solicitud de reevaluación de invalidez - Campo 15'' Nuevo Campo
                    (CASE 
                        WHEN (codigoModalidadPension IN ('00', '05', '06', '08', '09', '10')) THEN '01' --RP
                        WHEN (codigoModalidadPension IN ('03', '04', '07', cch13)) THEN '02' --RT 
                        WHEN (codigoModalidadPension IN ('01', '02')) THEN '03' --RV
                        ELSE '0'
                     END) codigoTipoAnualidad,
                    CONVERT(CHAR(2), '01') codigoTipoRecalculo,
                    CONVERT(CHAR(2), '01') codigoCausalRecalculo,
                    codigoModalidadAFP,
                    codigoEstadoSolicitud, --Código del estado de la solicitud
                    fechaEstadoSolicitud,
                    saldoRetenidoUF,
                    edad,
                    fedevpen,
                    periodoSolicitudPensionInvalidez,
                    CONVERT(TINYINT, 1) numeroUniverso,
                    idError,
                    CONVERT(CHAR(1), 'N') indScomp,
                    CONVERT(BIGINT, 0) mesesEfecRebaja,
                    fec_devenga_sisant,
                    CONVERT(NUMERIC(7, 2), 0.0) montoPrimPensDefUF,
                    CONVERT(NUMERIC(7, 2), 0.0) montoPensionTranUF,
                    CONVERT(NUMERIC(10, 7), 0.0) factorAjuste,
                    CONVERT(NUMERIC(5, 4), 0.0) factorActuorialmenteJusto,
                    CONVERT(NUMERIC(7, 2), 0.0) montoPrimPensDefRTUF,
                    fecEmiPrimUnicoDictEjec,
                    codestsol,
                    porcentaje_cobertura_seg,
                    fechaDevPenTranst,
                    fechaDefuncion,
                    indProcReev,
                    fecdicta_cmr    ,
                    ISNULL( regionDictaCMR, ctiCero )  AS codigoRegionDictamen,
                    nroDictaCMR ,
                    anioDictaCMR
                FROM #DatosRegistrar_Universo_1
            ) u
                INNER JOIN DMGestion.DimTipoPension dtp ON u.codigoTipoPension = dtp.codigo
                INNER JOIN DMGestion.DimModalidadPension dmp ON u.codigoModalidadPension = dmp.codigo 
                INNER JOIN DMGestion.DimTipoAnualidad dta ON u.codigoTipoAnualidad = dta.codigo
                INNER JOIN DMGestion.DimTipoRecalculo dtr ON u.codigoTipoRecalculo = dtr.codigo
                INNER JOIN DMGestion.DimEstadoSolicitud des ON u.codigoEstadoSolicitud = des.codigo
                INNER JOIN DMGestion.DimCausalRecalculo dcr ON u.codigoCausalRecalculo = dcr.codigo
                LEFT JOIN DMGestion.HomologacionComisionMedica hcm ON u.codigoRegionDictamen = hcm.codigoRegionDictamen
            WHERE dcr.tipoPension = '03' --Invalidez
            AND dtp.fechaVigencia >= cdtMaximaFechaVigencia
            AND dmp.fechaVigencia >= cdtMaximaFechaVigencia
            AND dta.fechaVigencia >= cdtMaximaFechaVigencia
            AND des.fechaVigencia >= cdtMaximaFechaVigencia
            AND dcr.fechaVigencia >= cdtMaximaFechaVigencia;
            
            --16. Remuneración imponible asociada a la última cotización anterior a la fecha de la 
            --    solicitud de pensión, en UF - Campo 27
            SELECT m.codigoTipoProducto, 
                u.numeroFila, 
                u.idPersonaOrigen, 
                m.per_cot, 
                m.fec_movimiento,
                m.renta_imponible, 
                u.periodoSolicitudPensionInvalidez, 
                u.tipoben, 
                u.fecsol,
                m.monto_pesos
            INTO #TB_MAE_MOVIMIENTO
            FROM DDS.VectorCotizaciones m
                INNER JOIN #DatosRegistro_U1_U2 u ON (m.id_mae_persona = u.idPersonaOrigen)
            WHERE u.fecsol IS NOT NULL
            AND m.per_cot < u.periodoSolicitudPensionInvalidez
            AND m.codigoTipoProducto IN (1, 6) --productos CCICO y CCIAV
            AND m.codigoSubGrupoMovimiento IN (1101, 1104, 1105)
            AND m.monto_pesos > ctiCero;

            //Se calcula la renta imponible para los casos que vengan en CERO o NULOS
            UPDATE #TB_MAE_MOVIMIENTO SET 
                renta_imponible = ROUND((monto_pesos / cnuPorcentajeRentaImp), ctiCero)
            FROM #TB_MAE_MOVIMIENTO
            WHERE ISNULL(renta_imponible, ctiCero) = ctiCero;
    
            SELECT codigoTipoProducto,
                idPersonaOrigen, 
                periodoSolicitudPensionInvalidez, 
                tipoben, 
                MAX(per_cot) periodoCotizacion
            INTO #MaximoPerCot
            FROM #TB_MAE_MOVIMIENTO
            GROUP BY codigoTipoProducto, 
                idPersonaOrigen, 
                periodoSolicitudPensionInvalidez, 
                tipoben;
          
            SELECT m.codigoTipoProducto,
                m.idPersonaOrigen, 
                m.periodoSolicitudPensionInvalidez, 
                m.per_cot, 
                m.tipoben, 
                ROUND(CONVERT(NUMERIC(6, 2), (CONVERT(BIGINT, SUM(m.renta_imponible)) / CONVERT(NUMERIC(7, 2), MAX(vvUF.valorUF)))), 2) renta_imponible
            INTO #RentaImponibleTMP
            FROM #TB_MAE_MOVIMIENTO m
                INNER JOIN #MaximoPerCot mpc ON m.idPersonaOrigen = mpc.idPersonaOrigen
                AND m.per_cot = mpc.periodoCotizacion
                AND m.periodoSolicitudPensionInvalidez = mpc.periodoSolicitudPensionInvalidez
                AND m.codigoTipoProducto = mpc.codigoTipoProducto
                INNER JOIN DMGestion.VistaValorUF vvUF ON mpc.periodoCotizacion = vvUF.periodo
                AND vvUF.ultimoDiaHabilMes = 'S'
            GROUP BY m.codigoTipoProducto, 
                m.idPersonaOrigen, 
                m.periodoSolicitudPensionInvalidez, 
                m.per_cot, 
                m.tipoben;
     
            --Se obtiene el valor del tope imponible de acuerdo al periodo de cotización
            SELECT DISTINCT ri.per_cot,
                CONVERT(NUMERIC(5, 2), NULL) valorTopeImponible
            INTO #TopeRentaImponibleCCICO
            FROM #RentaImponibleTMP ri;
    
            SELECT valor,
                fechaInicioRango,
                fechaTerminoRango
            INTO #VistaTopeImponible
            FROM DMGestion.VistaTopeImponible;
    
            UPDATE #TopeRentaImponibleCCICO SET
                triccico.valorTopeImponible = ISNULL(vti.valor, 0)
            FROM #TopeRentaImponibleCCICO triccico, #VistaTopeImponible vti
            WHERE triccico.per_cot BETWEEN vti.fechaInicioRango AND vti.fechaTerminoRango;
    
            --Se topa la Renta Imponible
            UPDATE #RentaImponibleTMP SET
                ri.renta_imponible = triccico.valorTopeImponible
            FROM #RentaImponibleTMP ri
                JOIN #TopeRentaImponibleCCICO triccico ON (ri.per_cot = triccico.per_cot)
            WHERE ri.renta_imponible > triccico.valorTopeImponible;
    
            DROP TABLE #TopeRentaImponibleCCICO;
        
            --Producto CCICO
            UPDATE #DatosRegistro_U1_U2 SET 
                u.remImpUltCotAnFecSolPenUF = ri.renta_imponible
            FROM #DatosRegistro_U1_U2 u 
                JOIN #RentaImponibleTMP ri ON (u.idPersonaOrigen = ri.idPersonaOrigen
                AND u.periodoSolicitudPensionInvalidez = ri.periodoSolicitudPensionInvalidez
                AND u.tipoben = ri.tipoben)
            WHERE ri.codigoTipoProducto = 1;
       
            --Producto CCIAV si no tiene CCICO
            UPDATE #DatosRegistro_U1_U2 SET 
                u.remImpUltCotAnFecSolPenUF = ri.renta_imponible
            FROM #DatosRegistro_U1_U2 u 
                JOIN #RentaImponibleTMP ri ON (u.idPersonaOrigen = ri.idPersonaOrigen
                AND u.periodoSolicitudPensionInvalidez = ri.periodoSolicitudPensionInvalidez
                AND u.tipoben = ri.tipoben)
            WHERE ri.codigoTipoProducto = 6
            AND ISNULL(u.remImpUltCotAnFecSolPenUF, ctiCero) = ctiCero;
    
            --Casos que tienen renta imponible pero al convertirlos a UF es muy pequeño la cantidad,
            --Estos casos quedaran registrados con monto 0.01.
            UPDATE #DatosRegistro_U1_U2 SET
                u.remImpUltCotAnFecSolPenUF = 0.01
            FROM #DatosRegistro_U1_U2 u 
                JOIN #RentaImponibleTMP ri ON (u.idPersonaOrigen = ri.idPersonaOrigen
                AND u.periodoSolicitudPensionInvalidez = ri.periodoSolicitudPensionInvalidez
                AND u.tipoben = ri.tipoben)
            WHERE ISNULL(u.remImpUltCotAnFecSolPenUF, 0) = 0;
         
            --17. Fecha última cotización anterior a la fecha de solicitud de pensión 
            --Producto CCICO
            UPDATE #DatosRegistro_U1_U2 SET
                u.fecUltCotAntFecSolPension = mpc.periodoCotizacion
            FROM #DatosRegistro_U1_U2 u 
                JOIN #MaximoPerCot mpc ON (u.idPersonaOrigen = mpc.idPersonaOrigen
                AND u.periodoSolicitudPensionInvalidez = mpc.periodoSolicitudPensionInvalidez
                AND u.tipoben = mpc.tipoben)
            WHERE mpc.codigoTipoProducto = 1;
         
            --Producto CCIAV si no tiene producto CCICO
            UPDATE #DatosRegistro_U1_U2 SET
                u.fecUltCotAntFecSolPension = mpc.periodoCotizacion
            FROM #DatosRegistro_U1_U2 u 
                JOIN #MaximoPerCot mpc ON u.idPersonaOrigen = mpc.idPersonaOrigen
                AND u.periodoSolicitudPensionInvalidez = mpc.periodoSolicitudPensionInvalidez
                AND u.tipoben = mpc.tipoben
            WHERE mpc.codigoTipoProducto = 6
            AND u.fecUltCotAntFecSolPension IS NULL;
       
            --18. Eliminación de las tablas temporales
            DROP TABLE #TB_MAE_MOVIMIENTO;
            DROP TABLE #MaximoPerCot;
            DROP TABLE #RentaImponibleTMP;
    
            --Inicio JIRA - IESP-xx
            -------------------------------------------------
            --1. Fecha de primer pago de pensión definitiva
            -------------------------------------------------
            SELECT a.numcue,
                a.idDimPersona,
                a.tipoben,
                a.modalidad,
                a.fecsol,
                MIN(a.fec_primer_pago) fec_primer_pago 
            INTO #FechaPrimerPagoPensionTMP
            FROM (
                SELECT a.numcue,
                    u.idDimPersona,
                    a.tipoben,
                    a.modalidad,
                    u.fecsol,
                    a.fec_primer_pago
                FROM DDS.SLB_MONTOBEN a 
                    INNER JOIN #DatosRegistro_U1_U2 u ON (a.numcue = u.numcue
                    AND a.modalidad = u.codigoModalidadAFP
                    AND a.tipoben = u.tipoben
                    AND a.fecsol = u.fecsol)
                WHERE a.fec_primer_pago IS NOT NULL
                AND u.fechaPrimerPagoPenDef IS NULL
                UNION
                SELECT a.numcue,
                    u.idDimPersona,
                    a.tipoben,
                    a.modalidad,
                    u.fecsol,
                    a.fec_primer_pago
                FROM DDS.SLB_MONTOBEN a 
                    INNER JOIN #DatosRegistro_U1_U2 u ON (a.numcue = u.numcue
                    AND a.modalidad = u.codigoModalidadAFP
                    AND a.tipoben = u.tipoben
                    AND a.fecsol = u.fedevpen)
                WHERE a.fec_primer_pago IS NOT NULL
                AND u.fechaPrimerPagoPenDef IS NULL
                UNION
                SELECT a.numcue,
                    u.idDimPersona,
                    u.tipoben,
                    a.modalidad,
                    u.fecsol,
                    a.fec_primer_pago
                FROM DDS.SLB_MONTOBEN a 
                    INNER JOIN #DatosRegistro_U1_U2 u ON (a.numcue = u.numcue
                    AND a.modalidad = u.codigoModalidadAFP
                    AND a.fecsol = u.fedevpen)
                WHERE a.fec_primer_pago IS NOT NULL
                AND u.fechaPrimerPagoPenDef IS NULL
                AND a.tipoben = 6
                AND u.tipoben = 5
                UNION
                SELECT a.numcue,
                    u.idDimPersona,
                    u.tipoben,
                    a.modalidad,
                    u.fecsol,
                    a.fec_primer_pago
                FROM DDS.SLB_MONTOBEN a 
                    INNER JOIN #DatosRegistro_U1_U2 u ON (a.numcue = u.numcue
                    AND a.modalidad = u.codigoModalidadAFP
                    AND a.fecsol = a.fecsol)
                WHERE a.fec_primer_pago IS NOT NULL
                AND u.fechaPrimerPagoPenDef IS NULL
                AND a.tipoben = 6
                AND u.tipoben = 5
            ) a
            GROUP BY a.numcue, a.idDimPersona, a.tipoben, a.modalidad, a.fecsol;
    
            UPDATE #DatosRegistro_U1_U2 SET
                u.fechaPrimerPagoPenDef = fpp.fec_primer_pago
            FROM #DatosRegistro_U1_U2 u
                JOIN #FechaPrimerPagoPensionTMP fpp ON (fpp.numcue = u.numcue
                AND fpp.modalidad = u.codigoModalidadAFP
                AND fpp.tipoben = u.tipoben
                AND fpp.fecsol = u.fecsol
                AND fpp.idDimPersona = u.idDimPersona)
            WHERE u.fechaPrimerPagoPenDef IS NULL
            AND (u.fechaEstadoSolicitud < cdtFecCorteNoPerfect OR u.fechaDefuncion IS NOT NULL);/************* INESP-4233  *************/ 
        
            DROP TABLE #FechaPrimerPagoPensionTMP;
    
            SELECT a.numcue,
                u.idDimPersona,
                a.tipoben,
                u.fecsol,
                MAX(a.ferealiz) ferealiz
            INTO #FechaPrimerPagoPensionTMP
            FROM DDS.STP_FECHAPEN a
                INNER JOIN #DatosRegistro_U1_U2 u ON (a.numcue = u.numcue
                AND a.tipoben = u.tipoben
                AND a.fecsol = u.fecsol)
            WHERE a.ferealiz IS NOT NULL
            AND a.codeven IN (998, 999)
            AND u.fechaPrimerPagoPenDef IS NULL
            AND (u.fechaEstadoSolicitud < cdtFecCorteNoPerfect OR u.fechaDefuncion IS NOT NULL)/************* INESP-4233  *************/ 
            GROUP BY a.numcue, u.idDimPersona, a.tipoben, u.fecsol; 
    
            UPDATE #DatosRegistro_U1_U2 SET
                u.fechaPrimerPagoPenDef = fpp.ferealiz
            FROM #DatosRegistro_U1_U2 u
                JOIN #FechaPrimerPagoPensionTMP fpp ON (fpp.numcue = u.numcue
                AND fpp.tipoben = u.tipoben
                AND fpp.fecsol = u.fecsol
                AND fpp.idDimPersona = u.idDimPersona)
            WHERE u.fechaPrimerPagoPenDef IS NULL;
        
            --3. Fecha Emisión Certificado de Saldo para seleccionar modalidad de pensión.
            --Para los que no se pudo obtener la Fecha emisión certificado saldo.
            SELECT a.numcue,
                u.idDimPersona,
                a.tipoben,
                u.fecsol,
                MAX(a.ferealiz) ferealiz
            INTO #FechaEmisionCertifSaldoTMP
            FROM DDS.STP_FECHAPEN a
                INNER JOIN #DatosRegistro_U1_U2 u ON (a.numcue = u.numcue
                AND a.tipoben = u.tipoben
                AND a.fecsol = u.fecsol)
            WHERE a.ferealiz IS NOT NULL
            AND u.codestsol = 2 --Aprobado Historico
            AND a.codeven = 500
            AND u.fechaEmisionCersal IS NULL
            AND u.codigoModalidadPension IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '11')
            GROUP BY a.numcue, u.idDimPersona, a.tipoben, u.fecsol;
        
            UPDATE #DatosRegistro_U1_U2 SET
                u.fechaEmisionCersal = f.ferealiz
            FROM #DatosRegistro_U1_U2 u
                JOIN #FechaEmisionCertifSaldoTMP f ON (u.numcue = f.numcue
                AND u.idDimPersona = f.idDimPersona
                AND u.tipoben = f.tipoben
                AND u.fecsol = f.fecsol)
            WHERE u.fechaEmisionCersal IS NULL
            AND u.codigoModalidadPension  IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '11');
    
            --4. Fecha Emisión primera ficha de cálculo para RP
            SELECT a.numcue,
                u.idDimPersona,
                a.tipoben,
                u.fecsol,
                MAX(a.ferealiz) ferealiz
            INTO #FechaEmisionPrimeraFCTMP
            FROM DDS.STP_FECHAPEN a
                INNER JOIN #DatosRegistro_U1_U2 u ON (a.numcue = u.numcue
                AND a.tipoben = u.tipoben
                AND a.fecsol = u.fecsol)
            WHERE a.ferealiz IS NOT NULL
            AND a.codeven IN (998, 999)
            AND u.codestsol = 2 --Aprobado Historico
            AND u.codigoModalidadPension IN ('03', '04', '05', '06', '08', '09', '10')
            AND u.fechaEmisionPrimeraFichaCalculoRP IS NULL
            GROUP BY a.numcue, u.idDimPersona, a.tipoben, u.fecsol; 
      
            UPDATE #DatosRegistro_U1_U2 SET
                u.fechaEmisionPrimeraFichaCalculoRP = fpp.ferealiz
            FROM #DatosRegistro_U1_U2 u
                JOIN #FechaEmisionPrimeraFCTMP fpp ON (fpp.numcue = u.numcue
                AND fpp.tipoben = u.tipoben
                AND fpp.fecsol = u.fecsol
                AND fpp.idDimPersona = u.idDimPersona)
            WHERE u.codigoModalidadPension IN ('03', '04', '05', '06', '08', '09', '10')
            AND u.fechaEmisionPrimeraFichaCalculoRP IS NULL;
    
            SELECT a.numcue,
                u.idDimPersona,
                a.tipoben,
                u.fecsol,
                MAX(a.ferealiz) ferealiz
            INTO #FechaEmisionPrimeraFCEve500TMP
            FROM DDS.STP_FECHAPEN a
                INNER JOIN #DatosRegistro_U1_U2 u ON (a.numcue = u.numcue
                AND a.tipoben = u.tipoben
                AND a.fecsol = u.fecsol)
            WHERE a.ferealiz IS NOT NULL
            AND a.codeven = 500
            AND u.codestsol = 2 --Aprobado Historico
            AND u.codigoModalidadPension IN ('03', '04', '05', '06', '08', '09', '10')
            AND u.fechaEmisionPrimeraFichaCalculoRP IS NULL
            GROUP BY a.numcue, u.idDimPersona, a.tipoben, u.fecsol; 
      
            UPDATE #DatosRegistro_U1_U2 SET
                u.fechaEmisionPrimeraFichaCalculoRP = fpp.ferealiz
            FROM #DatosRegistro_U1_U2 u
                JOIN #FechaEmisionPrimeraFCEve500TMP fpp ON (fpp.numcue = u.numcue
                AND fpp.tipoben = u.tipoben
                AND fpp.fecsol = u.fecsol
                AND fpp.idDimPersona = u.idDimPersona)
            WHERE u.codigoModalidadPension IN ('03', '04', '05', '06', '08', '09', '10')
            AND u.fechaEmisionPrimeraFichaCalculoRP IS NULL;
       
            --5. Fecha de selección de modalidad de pensión
            --Para los que no se pudo obtener la Fecha de selección de modalidad de pensión.
            SELECT a.numcue,
                u.idDimPersona,
                a.tipoben,
                u.fecsol,
                MAX(a.ferealiz) ferealiz
            INTO #FechaSelecModPenTMP
            FROM DDS.STP_FECHAPEN a
                INNER JOIN #DatosRegistro_U1_U2 u ON (a.numcue = u.numcue
                AND a.tipoben = u.tipoben
                AND a.fecsol = u.fecsol)
            WHERE a.ferealiz IS NOT NULL
            AND u.codestsol = 2 --Aprobado Historico
            AND a.codeven = 600
            AND u.fechaSelModPen IS NULL
            AND u.codigoModalidadPension IN ('01', '02', '03', '04', '05', '06', '07', '08', '09')
            GROUP BY a.numcue, u.idDimPersona, a.tipoben, u.fecsol; 
    
            UPDATE #DatosRegistro_U1_U2 SET
                u.fechaSelModPen = f.ferealiz
            FROM #DatosRegistro_U1_U2 u
                JOIN #FechaSelecModPenTMP f ON (u.numcue = f.numcue
                AND u.idDimPersona = f.idDimPersona
                AND u.tipoben = f.tipoben
                AND u.fecsol = f.fecsol)
            WHERE u.fechaSelModPen IS NULL
            AND u.codigoModalidadPension  IN ('01', '02', '03', '04', '05', '06', '07', '08', '09');
    
            --Fecha de solicitud de pensión menor a 1996-01-01 se obtiene:
            -- - Fecha emisión certificado de saldo
            -- - Fecha de emisión primera ficha de calculo RP
            -- - Fecha selección modalidad de pensión
            -- - Fecha primer pago de pensión definitiva
            -- - Monto Pensión Calculada en UF
            --desde la tabla DDS.TramitePensionAprobadoDatoIncompleto
            UPDATE #DatosRegistro_U1_U2 SET
                a.fechaEmisionCersal                = b.fecEmiCertSaldoModPension,
                a.fechaSelModPen                    = b.fechaSeleccionModPension,
                a.fechaEmisionPrimeraFichaCalculoRP = b.fecEmis1FichaCalculoRP,
                a.fechaPrimerPagoPenDef             = b.fecPrimerPagoPensionDef,
                a.montoPrimPensDefUF                = ISNULL(b.montoPrimPensDefUF, cnuMontoCero),
                a.codigoModalidadPension            = b.codigoModalidadPension,
                a.idDimModalidadPension             = ctiCero
            FROM #DatosRegistro_U1_U2 a
                JOIN DDS.TramitePensionAprobadoDatoIncompleto b ON (a.rut = b.rut
                AND a.fecsol = b.fechaSolicitud
                AND a.tipoben = b.tipoBeneficio)
            WHERE b.indRegistroInformar             = cchSi
            AND b.indInfModalidadPensionRecuperada  = cchSi
            AND b.tramitePension                    = cchCodigoIN;
    
            UPDATE #DatosRegistro_U1_U2 SET
                a.idDimModalidadPension = b.id
            FROM #DatosRegistro_U1_U2 a
                JOIN DMGestion.DimModalidadPension b ON (a.codigoModalidadPension = b.codigo)
            WHERE a.idDimModalidadPension = 0
            AND b.fechaVigencia >= cdtMaximaFechaVigencia;
    
            -- se obtiene fecha de pensión en el antiguo sistema
            UPDATE #DatosRegistro_U1_U2 SET 
                a.fec_devenga_sisant = NULL
            FROM #DatosRegistro_U1_U2 a
            WHERE a.indicadorArt17 <> 'S' ;           
    
            SELECT m.numcue,
                m.tipoben,  
                m.fecsol,
                m.cod_financiamiento,
                SUM(ISNULL(m.monto_obligatorio, 0.0) + 
                    ISNULL(m.monto_voluntario, 0.0) + 
                    ISNULL(m.monto_convenido, 0.0) +
                    ISNULL(m.monto_afi_voluntario, 0.0)) montoPensionTranUF
            INTO #MontoPensionTransTMP
            FROM DDS.SLB_MONTOBEN m
            WHERE m.tipoBen = 3          
            AND m.tipo_pago = 2           
            AND m.modalidad IN (1, 2)     
            AND m.cod_financiamiento IN (1, 2)
            AND (ISNULL(m.monto_obligatorio, 0.0) + 
                 ISNULL(m.monto_voluntario, 0.0) + 
                 ISNULL(m.monto_convenido, 0.0) +
                 ISNULL(m.monto_afi_voluntario, 0.0)) > 0
            GROUP BY m.numcue,
                m.tipoben,  
                m.fecsol,
                m.cod_financiamiento;
    
            SELECT DISTINCT rank() OVER (PARTITION BY numcue, tipoben, fecsol ORDER BY cod_financiamiento ASC) rank,
                numcue,
                tipoben,  
                fecsol,
                cod_financiamiento,
                montoPensionTranUF
            INTO #MontoPensionTransFinalTMP
            FROM #MontoPensionTransTMP;
    
            -- se obtiene monto de pensión transitoria
            UPDATE #DatosRegistro_U1_U2 SET 
                u.montoPensionTranUF = m.montoPensionTranUF
            FROM #DatosRegistro_U1_U2 u
                JOIN #MontoPensionTransFinalTMP m ON (u.numcue = m.numcue
                AND u.tipoben = m.tipoben 
                AND u.fecsol = m.fecsol)
            WHERE u.codigoTipoPension IN ('17', '18')
            AND m.tipoBen = 3
            AND m.rank = 1;
          
            -- se obtiene monto de pensión definitiva
            UPDATE #DatosRegistro_U1_U2 SET 
                u.montoPensionTranUF = m.montoPensionTranUF
            FROM #DatosRegistro_U1_U2 u
                INNER JOIN #MontoPensionTransFinalTMP m ON (u.numcue = m.numcue
                AND u.fechaDeclInvPrimerDictEject = m.fecsol)
            WHERE u.codigoTipoPension in ('11', '12')
            AND m.tipoBen = 3     
            AND u.tipoBen = 6; 
    
            -- se obtiene primera pensión defenitiva
            --SALDOS
            CALL dchavez.cargarUniversoSaldoPensionTMP();
    
            SELECT numcue,
                tipoben,
                fecsol,
                SUM(montoPensionUF) montoPensionUF
            INTO #MontoPensionRPUFPencersaTMP
            FROM dchavez.UniversoSaldoPensionTMP
            WHERE indicador = 'PER4'
            GROUP BY numcue, tipoben, fecsol;
            
            -- retiro programado 
            UPDATE #DatosRegistro_U1_U2 SET 
                u.montoPrimPensDefUF = ISNULL(c.montoPensionUF, cnuMontoCero)
            FROM #DatosRegistro_U1_U2 u
                JOIN #MontoPensionRPUFPencersaTMP c ON (u.numcue = c.numcue
                AND u.tipoben = c.tipoben 
                AND u.fecsol  = c.fecsol)
            WHERE u.tipoben <> ctiCodigoPAET;
            
                        
            UPDATE #DatosRegistro_U1_U2 SET 
                u.montoPrimPensDefUF = ISNULL(dc.monto_bruto_fdo_uf, cnuMontoCero)
            FROM #DatosRegistro_U1_U2 u
                INNER JOIN DDS.SLB_DOCUPAGO dc ON (u.numcue = dc.numcue
                                                AND u.tipoben = dc.tipoben 
                                                AND u.fecsol  = dc.fecsol)
                INNER JOIN #SLB_DOCUPAGO_U1 d ON (dc.numcue = d.numcue
                                                AND dc.tipoben = d.tipoben 
                                                AND dc.fecsol  = d.fecsol
                                                AND dc.fec_liquidacion = d.fec_liquidacion)
            WHERE u.tipoben = ctiCodigoPAET;
        
            UPDATE #DatosRegistro_U1_U2 SET 
                u.montoPrimPensDefUF = ISNULL(c.montoPenDefUF, cnuMontoCero)
            FROM #DatosRegistro_U1_U2 u
                JOIN (SELECT u.numcue,
                        u.tipoben,
                        u.fecsol,
                        SUM(ISNULL(fcs.retiro_mensual_afil_ob_uf, cnuMontoCero) + 
                            ISNULL(fcs.retiro_mensual_afil_vo_uf, cnuMontoCero) +
                            ISNULL(fcs.retiro_mensual_afil_co_uf, cnuMontoCero) +
                            ISNULL(fcs.RETIRO_MENSUAL_AFIL_AV_UF, cnuMontoCero)) montoPenDefUF
                      FROM #DatosRegistro_U1_U2 u        
                        INNER JOIN DDS.SLB_FICHAS_CALCULO_SALDO_MF fcs ON (u.numcue = fcs.numcue
                        AND u.tipoben = fcs.tipoben_stp
                        AND u.fecsol = fcs.fecsol)
                      WHERE fcs.tipo_ficha = 'RP'
                      AND u.codigoModalidadpension IN ('08', '09')
                      GROUP BY u.numcue, u.tipoben, u.fecsol) c ON (u.numcue  = c.numcue 
                AND u.tipoben = c.tipoben 
                AND u.fecsol = c.fecsol)
            WHERE u.codigoModalidadpension IN ('08', '09')
            AND ISNULL(u.montoPrimPensDefUF, cnuMontoCero) = cnuMontoCero;
    
            --Solucion para el cambio Oficio N° 11.440
            --Si el monto de pension calculado en uf es CERO o NULO se obtiene
            --desde la tb_mae_movimiento con los codigos 63, 64 o 66
            --solo los que tienen modalidad RP.
            SELECT idPersonaOrigen,
                numcue, 
                tipoben, 
                fecsol
            INTO #CasosSinMontoPensionCalculadoTMP
            FROM #DatosRegistro_U1_U2
            WHERE ISNULL(montoPrimPensDefUF, cnuMontoCero) <= cnuMontoCero
            AND codigoModalidadPension IN ('08', '09');
           
            --Se obtiene los movimientos 63, 64 y 66
            SELECT idPersonaOrigen,
                numcue, 
                tipoben, 
                fecsol,
                a.fec_movimiento,
                a.fec_acreditacion,
                a.per_cot,
                a.monto_pesos
            INTO #UniversoMovimientosMontoPensionTMP
            FROM DDS.TB_MAE_MOVIMIENTO a
                INNER JOIN DDS.TB_TIP_MOVIMIENTO b ON (a.id_tip_movimiento = b.id_tip_movimiento)
                INNER JOIN #CasosSinMontoPensionCalculadoTMP c ON (a.id_mae_persona = c.idPersonaOrigen)
            WHERE b.cod_movimiento IN (63, 64, 66)
            AND a.monto_pesos > 0
            AND a.fec_movimiento <= ldtUltimaFechaPeriodoInformar
            AND c.fecsol <= a.fec_movimiento;
         
            --se obtiene la primera fecha de movimiento a partir de la fecsol
            SELECT idPersonaOrigen,
                tipoben,
                fecsol,
                MIN(fec_movimiento) fec_movimiento
            INTO #MinimaFechaMovimientoMontoPensionTMP
            FROM #UniversoMovimientosMontoPensionTMP
            GROUP BY idPersonaOrigen, tipoben, fecsol;
          
            --se obtiene el minimo per_cot 
            SELECT a.idPersonaOrigen,
                a.tipoben,
                a.fecsol,
                a.fec_movimiento,
                MIN(a.per_cot) per_cot
            INTO #MinimoPerCotMontoPensionTMP
            FROM #UniversoMovimientosMontoPensionTMP a
                INNER JOIN #MinimaFechaMovimientoMontoPensionTMP b ON (a.idPersonaOrigen = b.idPersonaOrigen
                AND a.fec_movimiento = b.fec_movimiento
                AND a.tipoben = b.tipoben
                AND a.fecsol = b.fecsol)
            GROUP BY a.idPersonaOrigen, a.fec_movimiento, a.tipoben, a.fecsol;
        
            SELECT a.idPersonaOrigen,
                a.numcue, 
                a.tipoben, 
                a.fecsol,
                a.fec_movimiento,
                a.fec_acreditacion,
                a.per_cot,
                SUM(a.monto_pesos) monto_pesos,
                CONVERT(NUMERIC(15, 2), NULL) montoUF
            INTO #UniversoMontoPensionTMP
            FROM #UniversoMovimientosMontoPensionTMP a
                INNER JOIN #MinimoPerCotMontoPensionTMP b ON (a.idPersonaOrigen = b.idPersonaOrigen
                AND a.fec_movimiento = b.fec_movimiento
                AND a.per_cot = b.per_cot
                AND a.tipoben = b.tipoben
                AND a.fecsol = b.fecsol)
            GROUP BY a.idPersonaOrigen, a.numcue,  a.tipoben, a.fecsol, a.fec_movimiento, a.fec_acreditacion, a.per_cot;

            SELECT DISTINCT vvUF.fechaUF,
                vvUF.valorUF
            INTO #VistaValorUFFecMovimientoTMP
            FROM #UniversoMontoPensionTMP a
                JOIN DMGestion.VistaValorUF vvUF ON (a.fec_movimiento = vvUF.fechaUF);
    
            UPDATE #UniversoMontoPensionTMP SET
                a.montoUF = ROUND((CONVERT(BIGINT, a.monto_pesos) / CONVERT(NUMERIC(7, 2), vvUF.valorUF)), 2)
            FROM #UniversoMontoPensionTMP a
                JOIN #VistaValorUFFecMovimientoTMP vvUF ON (a.fec_movimiento = vvUF.fechaUF);
    
            --Si el monto en uf es mayor a 99999.99 se deja en CERO
            UPDATE #UniversoMontoPensionTMP SET
                montoUF = /*cnuMontoCero*/0
            WHERE montoUF > 99999.99;
    
            UPDATE #DatosRegistro_U1_U2 SET
                a.montoPrimPensDefUF = b.montoUF
            FROM #DatosRegistro_U1_U2 a
                JOIN #UniversoMontoPensionTMP b ON (a.idPersonaOrigen = b.idPersonaOrigen
                AND a.fecsol = b.fecsol
                AND a.tipoben = b.tipoben)
            WHERE a.codigoModalidadpension IN ('08', '09')
            AND ISNULL(a.montoPrimPensDefUF, cnuMontoCero) = cnuMontoCero;
    
            -- renta vitalicia
            UPDATE #DatosRegistro_U1_U2 SET 
                u.montoPrimPensDefUF = (ISNULL(m.monto_obligatorio, cnuMontoCero) + 
                                        ISNULL(m.monto_voluntario, cnuMontoCero) + 
                                        ISNULL(m.monto_convenido, cnuMontoCero) +
                                        ISNULL(m.monto_afi_voluntario, cnuMontoCero))
            FROM  #DatosRegistro_U1_U2 u 
                JOIN DDS.slb_montoben m ON (u.numcue = m.numcue
                AND u.tipoben = m.tipoben 
                AND u.fecsol = m.fecsol)
            WHERE m.modalidad = 3
            AND m.cod_financiamiento = 1
            AND u.codigoModalidadPension IN ('01', '02', '07');
    
            UPDATE #DatosRegistro_U1_U2 SET 
                u.montoPrimPensDefUF = (ISNULL(m.monto_obligatorio, cnuMontoCero) + 
                                        ISNULL(m.monto_voluntario, cnuMontoCero) + 
                                        ISNULL(m.monto_convenido, cnuMontoCero) +
                                        ISNULL(m.monto_afi_voluntario, cnuMontoCero))
            FROM  #DatosRegistro_U1_U2 u 
                JOIN DDS.slb_montoben m ON (u.numcue = m.numcue 
                AND u.fecsol = m.fecsol)
            WHERE m.modalidad = 3
            AND m.cod_financiamiento = 1
            AND u.tipoben = 5
            AND m.tipoben = 6
            AND u.codigoModalidadPension IN ('01', '02', '07');
    
            --renta temporal con renta vitalicia diferida
            UPDATE #DatosRegistro_U1_U2 SET 
                u.montoPrimPensDefUF = (ISNULL(m.monto_obligatorio, cnuMontoCero) + 
                                        ISNULL(m.monto_voluntario, cnuMontoCero) + 
                                        ISNULL(m.monto_convenido, cnuMontoCero) +
                                        ISNULL(m.monto_afi_voluntario, cnuMontoCero))
            FROM  #DatosRegistro_U1_U2 u 
                JOIN DDS.slb_montoben m ON (u.numcue = m.numcue
                AND u.tipoben = m.tipoben 
                AND u.fecsol = m.fecsol)
            WHERE m.modalidad = 5
            AND m.cod_financiamiento = 1
            AND u.codigoModalidadPension IN ('03', '04');
    
            UPDATE #DatosRegistro_U1_U2 SET 
                u.montoPrimPensDefUF = (ISNULL(m.monto_obligatorio, cnuMontoCero) + 
                                        ISNULL(m.monto_voluntario, cnuMontoCero) + 
                                        ISNULL(m.monto_convenido, cnuMontoCero) +
                                        ISNULL(m.monto_afi_voluntario, cnuMontoCero))
            FROM  #DatosRegistro_U1_U2 u 
                JOIN DDS.slb_montoben m ON (u.numcue = m.numcue 
                AND u.fecsol = m.fecsol)
            WHERE m.modalidad = 5
            AND m.cod_financiamiento = 1
            AND u.tipoben = 5
            AND m.tipoben = 6
            AND u.codigoModalidadPension IN ('03', '04');
           
            --Casos donde el monto de la priemra pension defenitiva en UF no existe en la tabla SLB_MONTOBEN
            UPDATE #DatosRegistro_U1_U2 SET 
                u.montoPrimPensDefUF = ISNULL(p.pension_rv_afil_uf, cnuMontoCero)
            FROM #DatosRegistro_U1_U2 u 
                JOIN DDS.stp_pencersa p ON (u.numcue = p.numcue
                AND u.tipoben = p.tipoben 
                AND u.fecsol = p.fecsol)
            WHERE ISNULL(u.montoPrimPensDefUF, cnuMontoCero) = cnuMontoCero
            AND u.codigoModalidadPension IN ('03', '04', '01', '02', '07');
    
            -- renta vitalicia con retiro programado
            UPDATE #DatosRegistro_U1_U2 SET 
                u.montoPrimPensDefUF = (ISNULL(m.monto_obligatorio, cnuMontoCero) + 
                                        ISNULL(m.monto_voluntario, cnuMontoCero) + 
                                        ISNULL(m.monto_convenido, cnuMontoCero) + 
                                        ISNULL(m.monto_afi_voluntario, cnuMontoCero))
            FROM #DatosRegistro_U1_U2 u 
                JOIN DDS.slb_montoben m ON (u.numcue = m.numcue
                AND u.tipoben = m.tipoben 
                AND u.fecsol = m.fecsol)
            WHERE m.modalidad = 3 
            AND m.cod_financiamiento = 1
            AND u.codigoModalidadpension = '05';
    
            UPDATE #DatosRegistro_U1_U2 SET 
                u.montoPrimPensDefUF = (ISNULL(m.monto_obligatorio, cnuMontoCero) + 
                                        ISNULL(m.monto_voluntario, cnuMontoCero) + 
                                        ISNULL(m.monto_convenido, cnuMontoCero) + 
                                        ISNULL(m.monto_afi_voluntario, cnuMontoCero))
            FROM #DatosRegistro_U1_U2 u 
                JOIN DDS.slb_montoben m ON (u.numcue = m.numcue
                AND u.fecsol = m.fecsol)
            WHERE m.modalidad = 3 
            AND m.cod_financiamiento = 1
            AND u.tipoben = 5
            AND m.tipoben = 6
            AND u.codigoModalidadpension = '05';
    
            UPDATE #DatosRegistro_U1_U2 SET 
                u.montoPrimPensDefUF = (ISNULL(u.montoPrimPensDefUF, cnuMontoCero) + 
                                        ISNULL(c.montoPensionUF, cnuMontoCero))
            FROM #DatosRegistro_U1_U2 u 
                JOIN #MontoPensionRPUFPencersaTMP c ON (u.numcue = c.numcue
                AND u.tipoben = c.tipoben
                AND u.fecsol = c.fecsol)  
            WHERE u.codigoModalidadpension = '05';
    
            UPDATE #DatosRegistro_U1_U2 SET
                u.montoPrimPensDefUF = (ISNULL(m.monto_obligatorio, cnuMontoCero) + 
                                        ISNULL(m.monto_voluntario, cnuMontoCero) + 
                                        ISNULL(m.monto_convenido, cnuMontoCero) + 
                                        ISNULL(m.monto_afi_voluntario, cnuMontoCero))
            FROM #DatosRegistro_U1_U2 u
                JOIN DDS.slb_montoben m ON (u.numcue = m.numcue
                AND u.tipoben = m.tipoben 
                AND u.fecsol = m.fecsol)
            WHERE m.modalidad = 5 
            AND m.cod_financiamiento = 1
            AND u.codigoModalidadpension = '06';
    
            UPDATE #DatosRegistro_U1_U2 SET
                u.montoPrimPensDefUF = (ISNULL(m.monto_obligatorio, cnuMontoCero) + 
                                        ISNULL(m.monto_voluntario, cnuMontoCero) + 
                                        ISNULL(m.monto_convenido, cnuMontoCero) + 
                                        ISNULL(m.monto_afi_voluntario, cnuMontoCero))
            FROM #DatosRegistro_U1_U2 u
                JOIN DDS.slb_montoben m ON (u.numcue = m.numcue 
                AND u.fecsol = m.fecsol)
            WHERE m.modalidad = 5 
            AND m.cod_financiamiento = 1
            AND u.tipoben = 5
            AND m.tipoben = 6
            AND u.codigoModalidadpension = '06';
    
            UPDATE #DatosRegistro_U1_U2 SET
                u.montoPrimPensDefUF = (ISNULL(u.montoPrimPensDefUF, cnuMontoCero) + 
                                        ISNULL(c.montoPensionUF, cnuMontoCero))
            FROM #DatosRegistro_U1_U2 u
                JOIN #MontoPensionRPUFPencersaTMP c ON (u.numcue = c.numcue
                AND u.tipoben = c.tipoben 
                AND u.fecsol = c.fecsol)  
            WHERE u.codigoModalidadpension = '06';
    
            --INICIO - IESP-235
            --Campo: Fecha de primer pago de pensión definitiva
            --Se incorpora nuevas casuisticas, en el que se obtiene desde la la tabla TB_MAE_MOVIMIENTO.
            SELECT a.id_mae_persona,
                d.numcue,
                d.fecsol,
                d.tipoben,
                MIN(fec_movimiento) fec_movimiento
            INTO #FecPrimerPagoPenDefTMP
            FROM DDS.TB_MAE_MOVIMIENTO a
                INNER JOIN DDS.TB_TIP_MOVIMIENTO b ON (a.id_tip_movimiento = b.id_tip_movimiento)
                INNER JOIN DDS.TB_TIP_PRODUCTO c ON (a.id_tip_producto = c.id_tip_producto)
                INNER JOIN #DatosRegistro_U1_U2 d ON (a.id_mae_persona = d.idPersonaOrigen)
            WHERE b.cod_movimiento IN (63, 64, 66)
            AND c.cod_tip_producto = '1' --CCICO
            AND a.fec_movimiento >= d.fecsol
            AND d.fechaPrimerPagoPenDef IS NULL
            AND a.fec_movimiento < cdtFecCorteNoPerfect --INESP-5120
            GROUP BY a.id_mae_persona,
                d.numcue,
                d.fecsol,
                d.tipoben;
    
            UPDATE #DatosRegistro_U1_U2 SET
                a.fechaPrimerPagoPenDef = b.fec_movimiento
            FROM #DatosRegistro_U1_U2 a
                JOIN #FecPrimerPagoPenDefTMP b ON (a.idPersonaOrigen = b.id_mae_persona
                AND a.numcue = b.numcue
                AND a.fecsol = b.fecsol 
                AND a.tipoben = b.tipoben);
            --TERMINO - IESP-235
    
            -------------------------------------
            --Pension minima
            -------------------------------------
            SELECT DISTINCT a.numcue,
                a.tipoben,
                a.fecsol,
                a.fecierre,
                b.rut
            INTO #UniversoPencersaTMP
            FROM DDS.STP_PENCERSA a
                INNER JOIN #DatosRegistro_U1_U2 b ON (a.numcue = b.numcue
                AND a.tipoben = b.tipoben
                AND a.fecsol = b.fecsol);
    
            UPDATE #DatosRegistro_U1_U2 SET
                u.fechaCierre = a.fecierre
            FROM #DatosRegistro_U1_U2 u
                JOIN #UniversoPencersaTMP a ON (a.numcue = u.numcue
                AND a.tipoben = u.tipoben
                AND a.fecsol = u.fecsol);
    
            --Si no tiene una fecha de cierre entonces e deja la fecha del primer pago de pensión definitiva
            UPDATE #DatosRegistro_U1_U2 SET
                fechaCierre = fechaPrimerPagoPenDef
            WHERE fechaCierre IS NULL;
    
            SELECT DISTINCT rank() OVER (PARTITION BY a.numcue, a.tipoben, a.fecsol, a.fecierre, a.rut ORDER BY b.ant_folio DESC) rank,
                a.numcue,
                a.tipoben,
                a.fecsol,
                a.fecierre,
                a.rut,
                b.ant_pen_min_uf,
                b.pbs_aps,
                b.ant_folio,
                b.ant_fec_emision
            INTO #UniversoCSEAntTMP
            FROM #UniversoPencersaTMP a
                INNER JOIN DDS.STP_CSE_ANTECEDENTE b ON (a.rut = b.ant_numrut
                AND a.fecierre = b.ant_fec_cierre);
    
            DELETE FROM #UniversoCSEAntTMP 
            WHERE rank > 1;
        
            UPDATE #DatosRegistro_U1_U2 SET
                u.pensionMinimaUF = ISNULL(a.ant_pen_min_uf, 0.0),
                u.pensionBasicaSolidariaUF = ISNULL(a.pbs_aps, 0.0)
            FROM #DatosRegistro_U1_U2 u
                JOIN #UniversoCSEAntTMP a ON (a.numcue = u.numcue
                AND a.tipoben = u.tipoben
                AND a.fecsol = u.fecsol);
    
            SELECT DISTINCT u.numcue,
                u.idDimPersona,
                u.codigoModalidadPension,
                u.edad,
                u.fechaCierre,
                CONVERT(BIGINT, DATEFORMAT(u.fechaCierre, 'YYYYMM') || '01') AS periodoFechaCierre,
                (CASE
                    WHEN (vvpm.tramoPensionMinima = 'TRAMO_PENSION_MINIMA_01') THEN
                         (CASE 
                             WHEN (vvpm.clave = 'PENMINHM<70' AND u.edad < 70) THEN
                                   vvpm.montoPesos
                          END)
                    WHEN (vvpm.tramoPensionMinima = 'TRAMO_PENSION_MINIMA_02') THEN
                         (CASE 
                             WHEN (vvpm.clave = 'PENMINHM<70' AND u.edad < 70) THEN
                                   vvpm.montoPesos
                             WHEN (vvpm.clave = 'PENMINHM>=70' AND u.edad >= 70) THEN
                                   vvpm.montoPesos
                          END)
                    WHEN (vvpm.tramoPensionMinima = 'TRAMO_PENSION_MINIMA_03') THEN
                         (CASE 
                             WHEN (vvpm.clave = 'PENMINHM<70' AND u.edad < 70) THEN
                                   vvpm.montoPesos
                             WHEN (vvpm.clave = 'PENMINHM>=70' AND u.edad >= 70 AND u.edad < 75) THEN
                                   vvpm.montoPesos
                             WHEN (vvpm.clave = 'PENMINHM>=75' AND u.edad >= 75) THEN
                                   vvpm.montoPesos
                          END)
                END) pensionMinimaPesos,
                CONVERT(NUMERIC(10, 2), NULL) pensionMinimaUF
            INTO #PensionMinimaTMP
            FROM #DatosRegistro_U1_U2 u, DMGestion.VistaValorPensionMinima vvpm
            WHERE periodoFechaCierre  = vvpm.periodo
            AND u.montoPrimPensDefUF > cnuMontoCero
            AND pensionMinimaPesos IS NOT NULL
            AND u.pensionMinimaUF = 0;

            SELECT DISTINCT v.fechaUF,
                v.valorUF
            INTO #VistaValorUFFechaCierreTMP
            FROM #PensionMinimaTMP p
                JOIN DMGestion.VistaValorUF v ON (p.fechaCierre = fechaUF);
    
            UPDATE #PensionMinimaTMP SET 
                p.pensionMinimaUF = (CONVERT(NUMERIC(10, 2), p.pensionMinimaPesos) / v.valorUF)
            FROM #PensionMinimaTMP p
                JOIN #VistaValorUFFechaCierreTMP v ON (p.fechaCierre = v.fechaUF);
    
            UPDATE #DatosRegistro_U1_U2 SET 
                u.pensionMinimaUF = p.pensionMinimaUF
            FROM #DatosRegistro_U1_U2 u
                JOIN #PensionMinimaTMP p ON (u.numcue = p.numcue
                AND u.idDimPersona = p.idDimPersona
                AND u.codigoModalidadPension = p.codigoModalidadPension)
            WHERE u.pensionMinimaUF = 0;
    
            SELECT DISTINCT u.numcue,
                u.idDimPersona,
                u.codigoModalidadPension,
                u.fechaCierre,
                pbs.monto pensionBasicaSolidariaPesos,
                CONVERT(NUMERIC(10, 2), 0.0) pensionBasicaSolidariaUF
            INTO #PensionBasicaSolidariaTMP
            FROM #DatosRegistro_U1_U2 u, DMGestion.VistaPensionBasicaSolidaria pbs 
            WHERE u.fechaCierre BETWEEN pbs.fechaInicioRango AND pbs.fechaTerminoRango
            AND u.pensionBasicaSolidariaUF = 0;

            SELECT DISTINCT v.fechaUF,
                v.valorUF
            INTO #VistaValorUFFechaCierre02TMP
            FROM #PensionBasicaSolidariaTMP p
                JOIN DMGestion.VistaValorUF v ON (p.fechaCierre = v.fechaUF);
    
            UPDATE #PensionBasicaSolidariaTMP SET 
                p.pensionBasicaSolidariaUF = (CONVERT(NUMERIC(10, 2), p.pensionBasicaSolidariaPesos) / v.valorUF)
            FROM #PensionBasicaSolidariaTMP p
                JOIN #VistaValorUFFechaCierre02TMP v ON (p.fechaCierre = v.fechaUF);
    
            UPDATE #DatosRegistro_U1_U2 SET 
                u.pensionBasicaSolidariaUF = p.pensionBasicaSolidariaUF
            FROM #DatosRegistro_U1_U2 u
                JOIN #PensionBasicaSolidariaTMP p ON (u.numcue = p.numcue
                AND u.idDimPersona = p.idDimPersona
                AND u.codigoModalidadPension = p.codigoModalidadPension)
            WHERE u.pensionBasicaSolidariaUF = 0;
    
            -- indicador SCOMP
    
            -- se valida que la pensión sea mayor que la pensión basica solidaria
            UPDATE #DatosRegistro_U1_U2 a SET 
                a.indScomp = 'S'
            WHERE a.fechaInvalidez >= cdtFecha01IndScomp
            AND a.montoPrimPensDefUF > a.pensionBasicaSolidariaUF
            AND a.pensionBasicaSolidariaUF > 0;
            
            UPDATE #DatosRegistro_U1_U2 a SET 
                a.indScomp = 'S'
            WHERE a.fechaInvalidez > cdtFecha02IndScomp
            AND a.codigoModalidadPension IN ('01', '02', '03', '04', '05', '06', '07'); 
    
            -- Se valida que la pension sea mayor que la pensión minima
            UPDATE #DatosRegistro_U1_U2 a SET 
                a.indScomp = 'S'
            WHERE a.fechaInvalidez < cdtFecha01IndScomp-- '2009-07-01'
            AND a.fechaInvalidez > cdtFecha02IndScomp-- '2004-08-19'
            AND a.montoPrimPensDefUF > a.pensionMinimaUF
            AND a.pensionMinimaUF > 0;
    
            -- se rescata fctor de ajuste
            SELECT f.numcue,
                f.numrut,
                f.tipopen,
                MAX(f.fecha_calculo) fecha_calculo 
            INTO #MaxFechaFaju   --Obtener el máximo FAJU Fase 2  22-05-2014 
            FROM #DatosRegistro_U1_U2 u 
                INNER JOIN dds.slb_faju f ON u.numcue = f.numcue
                AND u.rut = f.numrut
                AND u.tipoben = f.tipopen 
            WHERE f.tipo_calculo <> ctiCodTipoCalcFajuSim   -- Simulación (2)
            GROUP BY f.numcue,f.numrut,f.tipopen;
    
            SELECT f.numcue,
                f.numrut,
                f.tipopen,
                f.fecha_calculo,
                MAX(f.hora_registro) hora_registro
            INTO #MaxFecHoraFaju
            FROM #MaxFechaFaju m
                INNER JOIN dds.slb_faju f ON m.numcue  = f.numcue
                AND m.numrut  = f.numrut
                AND m.tipopen = f.tipopen
                AND m.fecha_calculo = f.fecha_calculo
            WHERE f.tipo_calculo <> ctiCodTipoCalcFajuSim   -- Simulación
            GROUP BY f.numcue,f.numrut,f.tipopen,f.fecha_calculo;      
    
            UPDATE #DatosRegistro_U1_U2 SET 
                u.factorAjuste = ISNULL(f.faju, 0)                                 
            FROM #DatosRegistro_U1_U2 u
                INNER JOIN #MaxFecHoraFaju m ON u.numcue = m.numcue
                AND u.rut = m.numrut 
                AND u.tipoben = m.tipopen 
                INNER JOIN dds.slb_faju f ON m.numcue = f.numcue
                AND m.numrut  = f.numrut  
                AND m.tipopen = f.tipopen 
                AND m.fecha_calculo = f.fecha_calculo 
                AND m.hora_registro = f.hora_registro  
            WHERE u.indicadorArt17 = 'N'
            AND u.indicadorArt69 = 'N'
            AND u.codigoTipoPension NOT IN ('15', '16', '17', '18')
            AND u.codigoModalidadPension IN ('08','09');
    
            -- se rescata valor factor actuarialmente justo
            SELECT stp_faj_det_rut,
                MAX(stp_faj_id) stp_faj_id
            INTO #MaxIdFaj
            FROM dds.aps_archivo_faj_det afd 
            GROUP BY stp_faj_det_rut;
              
            UPDATE #DatosRegistro_U1_U2 SET 
                u.factorActuorialmenteJusto = ISNULL(afd.stp_faj_det_faj, 0)
            FROM #DatosRegistro_U1_U2 u
                INNER JOIN #MaxIdFaj m ON u.rut = m.stp_faj_det_rut
                INNER JOIN dds.aps_archivo_faj_det afd ON m.stp_faj_det_rut = afd.stp_faj_det_rut 
                AND m.stp_faj_id = afd.stp_faj_id
            WHERE u.codigoModalidadPension IN ('08', '09');
    
            SELECT dr.id idRegion,
                dr.codigo codigoRegion,
                UPPER(dp.codigo) codigoPais
            INTO #DimRegionTMP
            FROM DMGestion.DimRegion dr
                INNER JOIN DMGestion.DimPais dp ON (dr.idPais = dp.id)
            WHERE dr.fechaVigencia >= cdtMaximaFechaVigencia
            AND dp.fechaVigencia >= cdtMaximaFechaVigencia;
    
            --INICIO - IESP-235
            --Monto de la primera pensión definitiva en Renta temporal, en UF
            --Universo 01 - STP_PENCERSA
            SELECT u.numcue,
                u.tipoben,
                u.fecsol,
                p.pension_rt_afil_uf
            INTO #MontoPrimeraPenDefRTUF_U1_TMP
            FROM DDS.STP_PENCERSA p
                INNER JOIN #DatosRegistro_U1_U2 u ON (p.tipoben = u.tipoben
                AND p.fecsol = u.fecsol
                AND p.numcue = u.numcue)
            WHERE p.tipoben IN (5, 6)
            AND p.modpen_selmod = 5
            AND u.codigoModalidadPension IN ('03', '04')
            AND ISNULL(u.montoPrimPensDefRTUF, 0) = 0
            AND ISNULL(p.pension_rt_afil_uf, 0) > 0;
    
            UPDATE #DatosRegistro_U1_U2 SET
                u.montoPrimPensDefRTUF = m.pension_rt_afil_uf
            FROM #DatosRegistro_U1_U2 u
                JOIN #MontoPrimeraPenDefRTUF_U1_TMP m ON (m.tipoben = u.tipoben
                AND m.fecsol = u.fecsol
                AND m.numcue = u.numcue)
            WHERE u.codigoModalidadPension IN ('03', '04');
    
            --Universo 2 - TB_MAE_MOVIMIENTO
            SELECT u.numcue,
                u.tipoben,
                u.fecsol,
                m.id_mae_persona,
                m.id_tip_movimiento,
                MIN(m.fec_movimiento) fec_movimiento
            INTO #Movimiento64MinFecMovTMP
            FROM DDS.TB_MAE_MOVIMIENTO m
                INNER JOIN DDS.TB_TIP_MOVIMIENTO t ON (m.id_tip_movimiento = t.id_tip_movimiento)
                INNER JOIN #DatosRegistro_U1_U2 u ON (m.id_mae_persona = u.idPersonaOrigen)
            WHERE t.cod_movimiento = 64
            AND m.fec_movimiento >= u.fecsol
            AND u.codigoModalidadPension IN ('03', '04')
            AND ISNULL(u.montoPrimPensDefRTUF, 0) = 0
            GROUP BY u.numcue,
                u.tipoben,
                u.fecsol,
                m.id_mae_persona,
                m.id_tip_movimiento;
    
            SELECT m64.numcue,
                m64.tipoben,
                m64.fecsol,
                m64.fec_movimiento,
                SUM(m.monto_pesos) monto_pesos,
                CONVERT(NUMERIC(7, 2), 0.0) montoUF
            INTO #MontoPrimeraPenDefRTUF_U2_TMP
            FROM DDS.TB_MAE_MOVIMIENTO m
                INNER JOIN #Movimiento64MinFecMovTMP m64 ON (m.id_mae_persona = m64.id_mae_persona
                AND m.id_tip_movimiento = m64.id_tip_movimiento
                AND m.fec_movimiento = m64.fec_movimiento)
            GROUP BY m64.numcue,
                m64.tipoben,
                m64.fecsol,
                m64.fec_movimiento;

            SELECT DISTINCT v.fechaUF,
                v.valorUF
            INTO #VistaValorUFFecMovimiento02TMP
            FROM #MontoPrimeraPenDefRTUF_U2_TMP u
                INNER JOIN DMGestion.VistaValorUF v ON (u.fec_movimiento = v.fechaUF);
    
            UPDATE #MontoPrimeraPenDefRTUF_U2_TMP SET
                u.montoUF = CONVERT(NUMERIC(7, 2), ROUND((u.monto_pesos / v.valorUF), 2))
            FROM #MontoPrimeraPenDefRTUF_U2_TMP u
                INNER JOIN #VistaValorUFFecMovimiento02TMP v ON (u.fec_movimiento = v.fechaUF);
    
            UPDATE #DatosRegistro_U1_U2 SET
                u.montoPrimPensDefRTUF = m.montoUF
            FROM #DatosRegistro_U1_U2 u
                JOIN #MontoPrimeraPenDefRTUF_U2_TMP m ON (m.tipoben = u.tipoben
                AND m.fecsol = u.fecsol
                AND m.numcue = u.numcue)
            WHERE u.codigoModalidadPension IN ('03', '04')
            AND ISNULL(u.montoPrimPensDefRTUF, 0) = 0;
    
            --Universo 3 - SLB_MONTOBEN
            SELECT u.numcue,
                u.tipoben,
                u.fecsol,
                (ISNULL(p.monto_obligatorio, 0) + 
                 ISNULL(p.monto_voluntario, 0) + 
                 ISNULL(p.monto_convenido, 0) + 
                 ISNULL(p.monto_afi_voluntario, 0)) montoUF
            INTO #MontoPrimeraPenDefRTUF_U3_TMP
            FROM DDS.SLB_MONTOBEN p
                INNER JOIN #DatosRegistro_U1_U2 u ON (p.tipoben = u.tipoben
                AND p.fecsol = u.fecsol
                AND p.numcue = u.numcue)
            WHERE p.tipoben = 6
            AND p.modalidad = 5
            AND p.tipo_pago = 2
            AND p.cod_financiamiento = 2
            AND u.codigoModalidadPension IN ('03', '04')
            AND ISNULL(u.montoPrimPensDefRTUF, 0) = 0
            AND montoUF > 0;
    
            UPDATE #DatosRegistro_U1_U2 SET
                u.montoPrimPensDefRTUF = m.montoUF
            FROM #DatosRegistro_U1_U2 u
                JOIN #MontoPrimeraPenDefRTUF_U3_TMP m ON (m.tipoben = u.tipoben
                AND m.fecsol = u.fecsol
                AND m.numcue = u.numcue)
            WHERE u.codigoModalidadPension IN ('03', '04')
            AND ISNULL(u.montoPrimPensDefRTUF, 0) = 0;
            --TERMINO - IESP-235

            --19. Se obtiene el universo a registrar
            SELECT u.fechaNacimiento, 
                u.sexo, 
                u.fecsol, 
                u.tipoben, 
                u.numcue, 
                u.idDimPersona,
                u.rut, 
                u.idPersonaOrigen, 
                u.indicadorArt17, 
                u.indicadorArt69, 
                u.codigoTipoPension, 
                u.idDimTipoPension, 
                u.codigoModalidadPension, 
                u.idDimModalidadPension, 
                u.fechaDeclInvPrimerDictEject, 
                u.fechaDeclaInvPreviaUnicoDictEject,
                u.fechaDeclaInvUnicoDictEjectLey18964,
                u.fechaDeclaInvTotalUnicoDictEjectLey20255,
                u.codigoGradoInvalidezPrimDicEjec,
                u.codigoGradoInvalidezSegDicEjec,
                u.codigoGradoInvalidezUniDicEjec, 
                dgi.id idDimGradoInvalidezPrimDic,
                dgisd.id idDimGradoInvalidezSegDic,
                dgiud.id idDimGradoInvalidez, 
                u.fechaEmiFCPensionTransit, 
                u.fechaEjecutPrimerDictInv, 
                u.fechaEjecutUnicoDictInv,
                u.fechaSegundoDictEject,
                u.fecEjecutSegundoDic,
                u.fechaEmisionCersal, 
                u.fechaEmisionPrimeraFichaCalculoRP, 
                ISNULL(u.montoTotalAporteAdicionalUF, 0.0) montoTotalAporteAdicionalUF, 
                u.pensionReferenciaUF, 
                u.ingresoBaseUF, 
                ISNULL(u.promedioRentasUF, 0.0) promedioRentasUF, 
                ISNULL(u.numRemunEfectivas, 0) numRemunEfectivas, 
                ISNULL(u.remImpUltCotAnFecSolPenUF, 0.0) remImpUltCotAnFecSolPenUF, 
                u.codigoPaisSolicitaPension, 
                u.codigoRegionSolicitaPension, 
                u.fechaSelModPen, 
                u.fechaPrimerPagoPenDef, 
                u.codigoTipoCobertura, 
                dtc.id idDimTipoCobertura, 
                u.periodoSolicitudPensionInvalidez, 
                u.fecUltCotAntFecSolPension, 
                u.codigoTipoAnualidad, 
                u.idDimTipoAnualidad, 
                u.codigoTipoRecalculo, 
                u.idDimTipoRecalculo, 
                u.codigoCausalRecalculo, 
                u.idDimCausalRecalculo, 
                u.fechaCalculo, 
                u.numeroUniverso, 
                u.idError,
                u.fechaSolReevalInvalidez, 
                u.codigoModalidadAFP, 
                u.idDimEstadoSolicitud, 
                u.fechaEstadoSolicitud, 
                u.saldoRetenidoUF,
                u.pensionMinimaUF,
                u.indScomp,
                u.mesesEfecRebaja numeroMesesEfecRebaja,
                u.fec_devenga_sisant,
                u.montoPrimPensDefUF,
                u.montoPrimPensDefRTUF,
                u.montoPensionTranUF,
                u.factorAjuste,
                u.factorActuorialmenteJusto,
                u.pensionBasicaSolidariaUF,
                CONVERT(DATE, NULL) fecDicPosteriorEjec, --No existe actualmente en el sistema
                ISNULL(dr.idRegion, 0) idDimRegion,
                CONVERT(CHAR(1), 'N') indicadorArticulo68bis,
                CONVERT(CHAR(1), 'N') compPM_PBS,
                CONVERT(CHAR(1), 'N') indResolReposicionEjec,
                u.fecEmiPrimUnicoDictEjec,
                u.fedevpen,
                u.fechaDevPenTranst,
                CONVERT(NUMERIC(6, 2), cnuMontoPAFECero) montoPafeUF,
                CONVERT(CHAR(1),NULL) signoMontoPafe,
                cchIndPafeNo AS indPafe,
                ISNULL(u.porcentaje_cobertura_seg, 0) porcentaje_cobertura_seg,
                u.fechaInvalidez,
                cchN AS indUsoSaldoRetenido,
                cchN AS indMontoPafeTablaHist,
                fechaDefuncion,
                cchN AS indExpasis,  --DATAW-4752   
                u.indProcesoReevaluacion,
                u.fechaDictamen,
                ISNULL( u.numeroDictamen , cinCero) AS numeroDictamen,
                ISNULL (u.anioDictamen, csmCero)    AS anioDictamen,
                dcm.id AS idComisionMedica,
                ROW_NUMBER() OVER(ORDER BY u.numcue ASC, 
                                u.tipoben ASC,
                                u.fecsol ASC) AS numeroFila
            INTO #UniversoRegistroTMP
            FROM (
                SELECT fechaNacimiento, 
                    sexo, 
                    fecsol, 
                    tipoben, 
                    numcue, 
                    idDimPersona, 
                    rut, 
                    idPersonaOrigen, 
                    indicadorArt17, 
                    indicadorArt69, 
                    codigoTipoPension, 
                    idDimTipoPension, 
                    codigoModalidadPension, 
                    idDimModalidadPension, 
                    fechaDeclInvPrimerDictEject, 
                    fechaDeclaInvPreviaUnicoDictEject,
                    fechaDeclaInvUnicoDictEjectLey18964,
                    fechaDeclaInvTotalUnicoDictEjectLey20255,
                    ISNULL(gradoInvalidezPrimerDictEject, '0') codigoGradoInvalidezPrimDicEjec,
                    ISNULL(gradoInvalidezSegundoDictEject, '0') codigoGradoInvalidezSegDicEjec,
                    ISNULL(gradoInvalidezUnicoDictEject, '0') codigoGradoInvalidezUniDicEjec,
                    fechaEmiFCPensionTransit, 
                    fechaEjecutPrimerDictInv, 
                    fechaEjecutUnicoDictInv,
                    fechaSegundoDictEject,
                    fecEjecutSegundoDic,
                    fechaEmisionCersal, 
                    fechaEmisionPrimeraFichaCalculoRP,
                    montoTotalAporteAdicionalUF, 
                    pensionReferenciaUF, 
                    ingresoBaseUF, 
                    promedioRentasUF, 
                    numRemunEfectivas,
                    remImpUltCotAnFecSolPenUF, 
                    codigoPaisSolicitaPension, 
                    codigoRegionSolicitaPension, 
                    fechaSelModPen,
                    fechaPrimerPagoPenDef, 
                    codigoTipoCobertura, 
                    periodoSolicitudPensionInvalidez,
                    fecUltCotAntFecSolPension, 
                    codigoTipoAnualidad, 
                    idDimTipoAnualidad,  
                    codigoTipoRecalculo,
                    idDimTipoRecalculo, 
                    codigoCausalRecalculo, 
                    idDimCausalRecalculo, 
                    fechaCalculo, 
                    numeroUniverso, 
                    idError, 
                    fechaSolReevalInvalidez, 
                    codigoModalidadAFP, 
                    idDimEstadoSolicitud, 
                    fechaEstadoSolicitud, 
                    saldoRetenidoUF, 
                    pensionMinimaUF,     
                    indScomp,
                    mesesEfecRebaja,
                    fec_devenga_sisant,
                    montoPrimPensDefUF,
                    montoPrimPensDefRTUF,
                    montoPensionTranUF,
                    factorAjuste,
                    factorActuorialmenteJusto,   
                    pensionBasicaSolidariaUF,
                    fecEmiPrimUnicoDictEjec,
                    fedevpen,
                    fechaDevPenTranst,
                    porcentaje_cobertura_seg,
                    fechaInvalidez,
                    fechaDefuncion,
                    indProcesoReevaluacion,
                    fechaDictamen,
                    numeroDictamen,
                    anioDictamen,
                    codigoComisionMedica
                FROM #DatosRegistro_U1_U2 
            ) u 
                INNER JOIN DMGestion.DimTipoCobertura dtc ON u.codigoTipoCobertura = dtc.codigo
                INNER JOIN DMGestion.DimGradoInvalidez dgi ON u.codigoGradoInvalidezPrimDicEjec = dgi.codigo 
                INNER JOIN DMGestion.DimGradoInvalidez dgisd ON u.codigoGradoInvalidezSegDicEjec = dgisd.codigo
                INNER JOIN DMGestion.DimGradoInvalidez dgiud ON u.codigoGradoInvalidezUniDicEjec = dgiud.codigo 
                LEFT OUTER JOIN #DimRegionTMP dr ON (u.codigoPaisSolicitaPension = dr.codigoPais
                AND u.codigoRegionSolicitaPension = dr.codigoRegion)
                LEFT OUTER JOIN DMGestion.DimComisionMedica dcm ON u.codigoComisionMedica = dcm.codigo --DATAW-4752
            WHERE dtc.fechaVigencia >= cdtMaximaFechaVigencia
            AND dgi.fechaVigencia  >= cdtMaximaFechaVigencia
            AND dgisd.fechaVigencia >= cdtMaximaFechaVigencia
            AND dgi.fechaVigencia >= cdtMaximaFechaVigencia;
    
            DROP TABLE #DatosRegistro_U1_U2;
    
            UPDATE #UniversoRegistroTMP SET
                u.indResolReposicionEjec = 'S'
            FROM #UniversoRegistroTMP u
                JOIN DDS.STP_DOCUMPEN d ON (u.tipoben = d.tipoben 
                AND u.fecsol = d.fecsol 
                AND u.numcue = d.numcue)
            WHERE d.tipodoc = 1222
            AND d.tipoben IN (3, 6);
            
            
            
            --DATAW-4752 - Marca de expasis
            UPDATE #UniversoRegistroTMP SET
                u.indExpasis = 'S'
            FROM #UniversoRegistroTMP u
            INNER JOIN DDS.TB_EXPASIS ex ON (u.rut = ex.rut_afiliado
                                            AND ex.estado = 1 );
            
            
            --INICIO - IESP-235
            --Campo: Fecha emisión primera ficha de cálculo para RP
            --Se incorpora nuevas casuisticas, en el que se obtiene desde la la tabla SLB_MONTOBEN.
            SELECT DISTINCT rank() OVER (PARTITION BY u.numcue ORDER BY u.cod_financiamiento ASC) rank,
                u.numcue,
                u.rut,
                u.fecsol,
                u.fec_primer_pago, 
                u.codigoTipoPension
            INTO #UniversoFechaEmisionFicCalPenTMP
            FROM (
                SELECT a.numcue,
                    b.rut,
                    b.fecsol,
                    a.fec_primer_pago, 
                    b.codigoTipoPension,
                    a.cod_financiamiento
                FROM DDS.SLB_MONTOBEN a
                    INNER JOIN #UniversoRegistroTMP b ON (a.numcue = b.numcue
                    AND a.fecsol = b.fecsol
                    AND a.tipoben = b.tipoben)
                WHERE a.tipoben = 6
                AND a.tipo_pago = 2
                AND b.codigoTipoPension IN ('11', '12', '13', '14', '19')
                AND a.fec_primer_pago IS NOT NULL
                AND b.fechaEmisionPrimeraFichaCalculoRP IS NULL
                AND b.fecsol < '1996-01-01'
                UNION
                SELECT a.numcue,
                    b.rut,
                    b.fecsol,
                    a.fec_primer_pago, 
                    b.codigoTipoPension,
                    a.cod_financiamiento
                FROM DDS.SLB_MONTOBEN a
                    INNER JOIN #UniversoRegistroTMP b ON (a.numcue = b.numcue
                    AND a.fecsol = b.fedevpen
                    AND a.tipoben = b.tipoben)
                WHERE a.tipoben = 6
                AND a.tipo_pago = 2
                AND b.codigoTipoPension IN ('11', '12', '13', '14', '19')
                AND a.fec_primer_pago IS NOT NULL
                AND b.fechaEmisionPrimeraFichaCalculoRP IS NULL
                AND b.fecsol < '1996-01-01') u;
    
            DELETE FROM #UniversoFechaEmisionFicCalPenTMP
            WHERE rank > 1;
    
            UPDATE #UniversoRegistroTMP SET
                u.fechaEmisionPrimeraFichaCalculoRP = f.fec_primer_pago
            FROM #UniversoRegistroTMP u
                INNER JOIN #UniversoFechaEmisionFicCalPenTMP f ON (u.numcue = f.numcue
                AND u.fecsol = f.fecsol
                AND u.codigoTipoPension = f.codigoTipoPension);
            --TERMINO - IESP-235

            --INICIO - IESP-235
            --Campo: Pensión de referencia, en UF
            --Se incorpora nuevas casuisticas, en el que se obtiene desde la la tabla SLB_MONTOBEN.
            SELECT u.numcue,
                u.rut,
                u.fecsol,
                u.monto_obligatorio, 
                u.codigoTipoPension
            INTO #UniversoMontoPenRefUFTMP
            FROM (
                SELECT a.numcue,
                    b.rut,
                    b.fecsol,
                    b.codigoTipoPension,
                    a.monto_obligatorio
                FROM DDS.SLB_MONTOBEN a
                    INNER JOIN #UniversoRegistroTMP b ON (a.numcue = b.numcue
                    AND a.fecsol = b.fecsol
                    AND a.tipoben = b.tipoben)
                WHERE a.tipo_pago = 2
                AND a.tipoben IN (3, 6)
                AND a.cod_financiamiento = 1
                AND a.modalidad = 2
                AND ISNULL(a.monto_obligatorio, 0) > 0
                AND ISNULL(b.pensionReferenciaUF, 0) = 0
                AND b.codigoTipoCobertura IN ('01', '02')
                UNION
                SELECT a.numcue,
                    b.rut,
                    b.fecsol,
                    b.codigoTipoPension,
                    a.monto_obligatorio
                FROM DDS.SLB_MONTOBEN a
                    INNER JOIN #UniversoRegistroTMP b ON (a.numcue = b.numcue
                    AND a.fecsol = b.fedevpen
                    AND a.tipoben = b.tipoben)
                WHERE a.tipo_pago = 2
                AND a.tipoben IN (3, 6)
                AND a.cod_financiamiento = 1
                AND a.modalidad = 2
                AND ISNULL(a.monto_obligatorio, 0) > 0
                AND ISNULL(b.pensionReferenciaUF, 0) = 0
                AND b.codigoTipoCobertura IN ('01', '02')) u;
                
            UPDATE #UniversoRegistroTMP SET
                u.pensionReferenciaUF = f.monto_obligatorio
            FROM #UniversoRegistroTMP u
                INNER JOIN #UniversoMontoPenRefUFTMP f ON (u.numcue = f.numcue
                AND u.fecsol = f.fecsol
                AND u.codigoTipoPension = f.codigoTipoPension)
            WHERE ISNULL(u.pensionReferenciaUF, 0) = 0
            AND u.codigoTipoCobertura IN ('01', '02');
            --TERMINO - IESP-235

            --INICIO - IESP-235
            --Campo: Ingreso Base
            --Se incorpora nuevas casuisticas, en el que se calcula el ingrese de acuerdo al porcentaje
            --de cobertura
            UPDATE #UniversoRegistroTMP SET
                u.ingresoBaseUF = (CASE
                                        WHEN (u.porcentaje_cobertura_seg IN (35, 50, 70)) THEN
                                            ROUND(ISNULL(u.pensionReferenciaUF, 0) * (100.0/u.porcentaje_cobertura_seg), 2)
                                        ELSE 0.0
                                   END)
            FROM #UniversoRegistroTMP u
            WHERE u.codigoTipoCobertura IN ('01', '02') 
            AND ISNULL(u.ingresoBaseUF, 0) = 0
            AND u.porcentaje_cobertura_seg > 0;
            
            --Monto Pensión de Referencia: Para los casos que no se les pudo obtener una pensión de referencia y
            --tipo de cobertura 01, 02 y tienen ingreso base
            UPDATE #UniversoRegistroTMP SET
                pensionReferenciaUF = (CASE
                                            WHEN (porcentaje_cobertura_seg IN (35, 50, 70)) THEN
                                                ROUND((ingresoBaseUF * (porcentaje_cobertura_seg / 100.0)), 2)
                                            ELSE 0.0
                                       END)
            WHERE codigoTipoCobertura IN ('01', '02') 
            AND ISNULL(pensionReferenciaUF, 0) = 0
            AND ingresoBaseUF > 0
            AND porcentaje_cobertura_seg > 0;

            --Monto pensión transitoria UF, para los casos que no se les pudo encontrar el monto. Se debe de aplicar la siguiente 
            --logica: Solo para tipo de pensión 11, 12, 17, 18 y que tengan pensión de referencia, este monto debe de ser informado
            --en el campo monto pensión transitoria.
            
            UPDATE #UniversoRegistroTMP SET
                montoPensionTranUF = (CASE
                                        WHEN (pensionReferenciaUF > 99999.99) THEN
                                            99999.99
                                        ELSE
                                            pensionReferenciaUF
                                      END)
            WHERE codigoTipoPension IN ('11', '12', '17', '18')
            AND ISNULL(montoPensionTranUF, 0) = 0
            AND pensionReferenciaUF > 0;

            --Campo: Fecha emisión ficha de cálculo para Pensión Transitoria
            --Se incorpora nuevas casuisticas, en el que se obtiene desde la la tabla SLB_MONTOBEN.
            SELECT DISTINCT rank() OVER (PARTITION BY u.numcue ORDER BY u.cod_financiamiento ASC) rank,
                u.numcue,
                u.rut,
                u.fecsol,
                u.fec_primer_pago, 
                u.codigoTipoPension
            INTO #UniversoFechaEmisionFicCalPenTransTMP
            FROM (
                SELECT a.numcue,
                    b.rut,
                    b.fecsol,
                    a.fec_primer_pago, 
                    b.codigoTipoPension,
                    a.cod_financiamiento
                FROM DDS.SLB_MONTOBEN a
                    INNER JOIN #UniversoRegistroTMP b ON (a.numcue = b.numcue
                    AND a.fecsol = b.fechaDeclInvPrimerDictEject)
                WHERE a.tipoben = 3
                AND a.tipo_pago = 2
                AND b.codigoTipoPension IN ('11', '12', '17', '18')
                AND a.fec_primer_pago IS NOT NULL
                AND fechaEmiFCPensionTransit IS NULL
                UNION
                SELECT a.numcue,
                    b.rut,
                    b.fecsol,
                    a.fec_primer_pago, 
                    b.codigoTipoPension,
                    a.cod_financiamiento
                FROM DDS.SLB_MONTOBEN a
                    INNER JOIN #UniversoRegistroTMP b ON (a.numcue = b.numcue
                    AND a.fecsol = b.fechaDevPenTranst)
                WHERE a.tipoben = 3
                AND a.tipo_pago = 2
                AND b.codigoTipoPension IN ('11', '12', '17', '18')
                AND a.fec_primer_pago IS NOT NULL
                AND fechaEmiFCPensionTransit IS NULL) u;
    
            DELETE FROM #UniversoFechaEmisionFicCalPenTransTMP
            WHERE rank > 1;
    
            UPDATE #UniversoRegistroTMP SET
                u.fechaEmiFCPensionTransit = f.fec_primer_pago
            FROM #UniversoRegistroTMP u
                INNER JOIN #UniversoFechaEmisionFicCalPenTransTMP f ON (u.numcue = f.numcue
                AND u.fecsol = f.fecsol
                AND u.codigoTipoPension = f.codigoTipoPension);
            --TERMINO - IESP-235

            --Fecha de solicitud de pensión menor a 1996-01-01 se obtiene:
            -- - Fecha emisión certificado de saldo
            -- - Fecha de emisión primera ficha de calculo RP
            -- - Fecha selección modalidad de pensión
            -- - Fecha primer pago de pensión definitiva
            -- - Monto Pensión Calculada en UF
            --desde la tabla DDS.TramitePensionAprobadoDatoIncompleto
            UPDATE #UniversoRegistroTMP SET     
                a.indicadorArt17                            = (CASE WHEN b.indArticulo17 IS NOT NULL                THEN b.indArticulo17                ELSE a.indicadorArt17                           END),
                a.indicadorArt69                            = (CASE WHEN b.indArticulo69 IS NOT NULL                THEN b.indArticulo69                ELSE a.indicadorArt69                           END),
                a.fechaEmisionCersal                        = (CASE WHEN b.fecEmiCertSaldoModPension IS NOT NULL    THEN b.fecEmiCertSaldoModPension    ELSE a.fechaEmisionCersal                       END),
                a.fechaEmisionPrimeraFichaCalculoRP         = (CASE WHEN b.fecEmis1FichaCalculoRP IS NOT NULL       THEN b.fecEmis1FichaCalculoRP       ELSE a.fechaEmisionPrimeraFichaCalculoRP        END),
                a.fechaSelModPen                            = (CASE WHEN b.fechaSeleccionModPension IS NOT NULL     THEN b.fechaSeleccionModPension     ELSE a.fechaSelModPen                           END),
                a.fechaPrimerPagoPenDef                     = (CASE WHEN b.fecPrimerPagoPensionDef IS NOT NULL      THEN b.fecPrimerPagoPensionDef      ELSE a.fechaPrimerPagoPenDef                    END),
                a.promedioRentasUF                          = (CASE WHEN b.promedioRentasRemuneraUF IS NOT NULL     THEN b.promedioRentasRemuneraUF     ELSE a.promedioRentasUF                         END),
                a.numRemunEfectivas                         = (CASE WHEN b.numRemEfectPromRenRemu IS NOT NULL       THEN b.numRemEfectPromRenRemu       ELSE a.numRemunEfectivas                        END),
                a.remImpUltCotAnFecSolPenUF                 = (CASE WHEN b.remImpUltCotAnFecSolPenUF IS NOT NULL    THEN b.remImpUltCotAnFecSolPenUF    ELSE a.remImpUltCotAnFecSolPenUF                END),
                a.fecUltCotAntFecSolPension                 = (CASE WHEN b.perUltCotDevAcrAntFecSol IS NOT NULL     THEN b.perUltCotDevAcrAntFecSol     ELSE a.fecUltCotAntFecSolPension                END),
                a.montoPrimPensDefUF                        = (CASE WHEN b.montoPrimPensDefUF IS NOT NULL           THEN b.montoPrimPensDefUF           ELSE a.montoPrimPensDefUF                       END),
                a.numeroMesesEfecRebaja                     = (CASE WHEN b.numeroMesesEfecRebaja IS NOT NULL        THEN b.numeroMesesEfecRebaja        ELSE a.numeroMesesEfecRebaja                    END),
                a.montoPrimPensDefRTUF                      = (CASE WHEN b.montoPrimPensDefRTUF IS NOT NULL         THEN b.montoPrimPensDefRTUF         ELSE a.montoPrimPensDefRTUF                     END),
                a.fechaDeclInvPrimerDictEject               = (CASE WHEN b.fecDeclaInvPrimDictEjec IS NOT NULL      THEN b.fecDeclaInvPrimDictEjec      ELSE a.fechaDeclInvPrimerDictEject              END),
                a.fechaDeclaInvPreviaUnicoDictEject         = (CASE WHEN b.fecDeclaInvUniDictEjec IS NOT NULL       THEN b.fecDeclaInvUniDictEjec       ELSE a.fechaDeclaInvPreviaUnicoDictEject        END),
                a.fechaDeclaInvUnicoDictEjectLey18964       = (CASE WHEN b.fecDecInUniDicAntLey18964 IS NOT NULL    THEN b.fecDecInUniDicAntLey18964    ELSE a.fechaDeclaInvUnicoDictEjectLey18964      END),
                a.fechaDeclaInvTotalUnicoDictEjectLey20255  = (CASE WHEN b.fecDeclaInvUniDicLey20255 IS NOT NULL    THEN b.fecDeclaInvUniDicLey20255    ELSE a.fechaDeclaInvTotalUnicoDictEjectLey20255 END),
                a.fechaEmiFCPensionTransit                  = (CASE WHEN b.fecEmiFichaCalcPensTrans IS NOT NULL     THEN b.fecEmiFichaCalcPensTrans     ELSE a.fechaEmiFCPensionTransit                 END),
                a.fechaEjecutPrimerDictInv                  = (CASE WHEN b.fecEjePrimDictamenInv IS NOT NULL        THEN b.fecEjePrimDictamenInv        ELSE a.fechaEjecutPrimerDictInv                 END),
                a.fechaEjecutUnicoDictInv                   = (CASE WHEN b.fecEjecUnicoDictamenInv IS NOT NULL      THEN b.fecEjecUnicoDictamenInv      ELSE a.fechaEjecutUnicoDictInv                  END),
                a.fechaSegundoDictEject                     = (CASE WHEN b.fecEmiSegundoDicEjec IS NOT NULL         THEN b.fecEmiSegundoDicEjec         ELSE a.fechaSegundoDictEject                    END),
                a.fecEjecutSegundoDic                       = (CASE WHEN b.fecEjecutSegundoDic IS NOT NULL          THEN b.fecEjecutSegundoDic          ELSE a.fecEjecutSegundoDic                      END),
                a.montoTotalAporteAdicionalUF               = (CASE WHEN b.montoTotalAporteAdicUF IS NOT NULL       THEN b.montoTotalAporteAdicUF       ELSE a.montoTotalAporteAdicionalUF              END),
                a.pensionReferenciaUF                       = (CASE WHEN b.pensionReferenciaUF IS NOT NULL          THEN b.pensionReferenciaUF          ELSE a.pensionReferenciaUF                      END),
                a.ingresoBaseUF                             = (CASE WHEN b.ingresoBaseUF IS NOT NULL                THEN b.ingresoBaseUF                ELSE a.ingresoBaseUF                            END),
                a.fechaSolReevalInvalidez                   = (CASE WHEN b.fechaSolReevalInvalidez IS NOT NULL      THEN b.fechaSolReevalInvalidez      ELSE a.fechaSolReevalInvalidez                  END),
                a.saldoRetenidoUF                           = (CASE WHEN b.saldoRetenidoUF IS NOT NULL              THEN b.saldoRetenidoUF              ELSE a.saldoRetenidoUF                          END),
                a.pensionMinimaUF                           = (CASE WHEN b.pensionMinimaUF IS NOT NULL              THEN b.pensionMinimaUF              ELSE a.pensionMinimaUF                          END),
                a.montoPensionTranUF                        = (CASE WHEN b.montoPensionTransitoriaUF IS NOT NULL    THEN b.montoPensionTransitoriaUF    ELSE a.montoPensionTranUF                       END),
                a.pensionBasicaSolidariaUF                  = (CASE WHEN b.pensionBasicaSolidariaUF IS NOT NULL     THEN b.pensionBasicaSolidariaUF     ELSE a.pensionBasicaSolidariaUF                 END),
                a.fecDicPosteriorEjec                       = (CASE WHEN b.fecDicPosteriorEjec IS NOT NULL          THEN b.fecDicPosteriorEjec          ELSE a.fecDicPosteriorEjec                      END),
                a.codigoRegionSolicitaPension               = (CASE WHEN b.codigoRegionTramiteSol IS NOT NULL       THEN b.codigoRegionTramiteSol       ELSE a.codigoRegionSolicitaPension              END),
                a.idDimRegion                               = (CASE WHEN b.codigoRegionTramiteSol IS NOT NULL       THEN ctiCero                        ELSE a.idDimRegion                              END)
            FROM #UniversoRegistroTMP a
                JOIN DDS.TramitePensionAprobadoDatoIncompleto b ON (a.rut = b.rut
                AND a.fecsol = b.fechaSolicitud
                AND a.tipoben = b.tipoBeneficio
                AND a.codigoModalidadPension = b.codigoModalidadPension)
            WHERE b.indRegistroInformar = cchSi
            AND b.indInfModalidadPensionRecuperada = cchNo
            AND b.indInfModalidadPensionReemplazar = cchNo
            AND b.tramitePension = cchCodigoIN;

            UPDATE #UniversoRegistroTMP SET     
                a.indicadorArt17                            = (CASE WHEN b.indArticulo17 IS NOT NULL                THEN b.indArticulo17                ELSE a.indicadorArt17                           END),
                a.indicadorArt69                            = (CASE WHEN b.indArticulo69 IS NOT NULL                THEN b.indArticulo69                ELSE a.indicadorArt69                           END),
                a.fechaEmisionCersal                        = (CASE WHEN b.fecEmiCertSaldoModPension IS NOT NULL    THEN b.fecEmiCertSaldoModPension    ELSE a.fechaEmisionCersal                       END),
                a.fechaEmisionPrimeraFichaCalculoRP         = (CASE WHEN b.fecEmis1FichaCalculoRP IS NOT NULL       THEN b.fecEmis1FichaCalculoRP       ELSE a.fechaEmisionPrimeraFichaCalculoRP        END),
                a.fechaSelModPen                            = (CASE WHEN b.fechaSeleccionModPension IS NOT NULL     THEN b.fechaSeleccionModPension     ELSE a.fechaSelModPen                           END),
                a.fechaPrimerPagoPenDef                     = (CASE WHEN b.fecPrimerPagoPensionDef IS NOT NULL      THEN b.fecPrimerPagoPensionDef      ELSE a.fechaPrimerPagoPenDef                    END),
                a.promedioRentasUF                          = (CASE WHEN b.promedioRentasRemuneraUF IS NOT NULL     THEN b.promedioRentasRemuneraUF     ELSE a.promedioRentasUF                         END),
                a.numRemunEfectivas                         = (CASE WHEN b.numRemEfectPromRenRemu IS NOT NULL       THEN b.numRemEfectPromRenRemu       ELSE a.numRemunEfectivas                        END),
                a.remImpUltCotAnFecSolPenUF                 = (CASE WHEN b.remImpUltCotAnFecSolPenUF IS NOT NULL    THEN b.remImpUltCotAnFecSolPenUF    ELSE a.remImpUltCotAnFecSolPenUF                END),
                a.fecUltCotAntFecSolPension                 = (CASE WHEN b.perUltCotDevAcrAntFecSol IS NOT NULL     THEN b.perUltCotDevAcrAntFecSol     ELSE a.fecUltCotAntFecSolPension                END),
                a.montoPrimPensDefUF                        = (CASE WHEN b.montoPrimPensDefUF IS NOT NULL           THEN b.montoPrimPensDefUF           ELSE a.montoPrimPensDefUF                       END),
                a.numeroMesesEfecRebaja                     = (CASE WHEN b.numeroMesesEfecRebaja IS NOT NULL        THEN b.numeroMesesEfecRebaja        ELSE a.numeroMesesEfecRebaja                    END),
                a.montoPrimPensDefRTUF                      = (CASE WHEN b.montoPrimPensDefRTUF IS NOT NULL         THEN b.montoPrimPensDefRTUF         ELSE a.montoPrimPensDefRTUF                     END),
                a.fechaDeclInvPrimerDictEject               = (CASE WHEN b.fecDeclaInvPrimDictEjec IS NOT NULL      THEN b.fecDeclaInvPrimDictEjec      ELSE a.fechaDeclInvPrimerDictEject              END),
                a.fechaDeclaInvPreviaUnicoDictEject         = (CASE WHEN b.fecDeclaInvUniDictEjec IS NOT NULL       THEN b.fecDeclaInvUniDictEjec       ELSE a.fechaDeclaInvPreviaUnicoDictEject        END),
                a.fechaDeclaInvUnicoDictEjectLey18964       = (CASE WHEN b.fecDecInUniDicAntLey18964 IS NOT NULL    THEN b.fecDecInUniDicAntLey18964    ELSE a.fechaDeclaInvUnicoDictEjectLey18964      END),
                a.fechaDeclaInvTotalUnicoDictEjectLey20255  = (CASE WHEN b.fecDeclaInvUniDicLey20255 IS NOT NULL    THEN b.fecDeclaInvUniDicLey20255    ELSE a.fechaDeclaInvTotalUnicoDictEjectLey20255 END),
                a.fechaEmiFCPensionTransit                  = (CASE WHEN b.fecEmiFichaCalcPensTrans IS NOT NULL     THEN b.fecEmiFichaCalcPensTrans     ELSE a.fechaEmiFCPensionTransit                 END),
                a.fechaEjecutPrimerDictInv                  = (CASE WHEN b.fecEjePrimDictamenInv IS NOT NULL        THEN b.fecEjePrimDictamenInv        ELSE a.fechaEjecutPrimerDictInv                 END),
                a.fechaEjecutUnicoDictInv                   = (CASE WHEN b.fecEjecUnicoDictamenInv IS NOT NULL      THEN b.fecEjecUnicoDictamenInv      ELSE a.fechaEjecutUnicoDictInv                  END),
                a.fechaSegundoDictEject                     = (CASE WHEN b.fecEmiSegundoDicEjec IS NOT NULL         THEN b.fecEmiSegundoDicEjec         ELSE a.fechaSegundoDictEject                    END),
                a.fecEjecutSegundoDic                       = (CASE WHEN b.fecEjecutSegundoDic IS NOT NULL          THEN b.fecEjecutSegundoDic          ELSE a.fecEjecutSegundoDic                      END),
                a.montoTotalAporteAdicionalUF               = (CASE WHEN b.montoTotalAporteAdicUF IS NOT NULL       THEN b.montoTotalAporteAdicUF       ELSE a.montoTotalAporteAdicionalUF              END),
                a.pensionReferenciaUF                       = (CASE WHEN b.pensionReferenciaUF IS NOT NULL          THEN b.pensionReferenciaUF          ELSE a.pensionReferenciaUF                      END),
                a.ingresoBaseUF                             = (CASE WHEN b.ingresoBaseUF IS NOT NULL                THEN b.ingresoBaseUF                ELSE a.ingresoBaseUF                            END),
                a.fechaSolReevalInvalidez                   = (CASE WHEN b.fechaSolReevalInvalidez IS NOT NULL      THEN b.fechaSolReevalInvalidez      ELSE a.fechaSolReevalInvalidez                  END),
                a.saldoRetenidoUF                           = (CASE WHEN b.saldoRetenidoUF IS NOT NULL              THEN b.saldoRetenidoUF              ELSE a.saldoRetenidoUF                          END),
                a.pensionMinimaUF                           = (CASE WHEN b.pensionMinimaUF IS NOT NULL              THEN b.pensionMinimaUF              ELSE a.pensionMinimaUF                          END),
                a.montoPensionTranUF                        = (CASE WHEN b.montoPensionTransitoriaUF IS NOT NULL    THEN b.montoPensionTransitoriaUF    ELSE a.montoPensionTranUF                       END),
                a.pensionBasicaSolidariaUF                  = (CASE WHEN b.pensionBasicaSolidariaUF IS NOT NULL     THEN b.pensionBasicaSolidariaUF     ELSE a.pensionBasicaSolidariaUF                 END),
                a.fecDicPosteriorEjec                       = (CASE WHEN b.fecDicPosteriorEjec IS NOT NULL          THEN b.fecDicPosteriorEjec          ELSE a.fecDicPosteriorEjec                      END),
                a.codigoRegionSolicitaPension               = (CASE WHEN b.codigoRegionTramiteSol IS NOT NULL       THEN b.codigoRegionTramiteSol       ELSE a.codigoRegionSolicitaPension              END),
                a.idDimRegion                               = (CASE WHEN b.codigoRegionTramiteSol IS NOT NULL       THEN ctiCero                        ELSE a.idDimRegion                              END)
            FROM #UniversoRegistroTMP a
                JOIN DDS.TramitePensionAprobadoDatoIncompleto b ON (a.rut = b.rut
                AND a.fecsol = b.fechaSolicitud
                AND a.tipoben = b.tipoBeneficio
                AND a.codigoModalidadPension = b.codigoModalidadPensionReemplazar)
            WHERE b.indRegistroInformar = cchSi
            AND b.indInfModalidadPensionRecuperada = cchNo
            AND b.indInfModalidadPensionReemplazar = cchSi
            AND b.tramitePension = cchCodigoIN;

            UPDATE #UniversoRegistroTMP SET
                a.idDimRegion = b.id
            FROM #UniversoRegistroTMP a
                JOIN DMGestion.DimRegion b ON (a.codigoRegionSolicitaPension = b.codigo)
            WHERE a.idDimRegion = ctiCero
            AND b.fechaVigencia >= cdtMaximaFechaVigencia;
            
            
            --Solicitudes ingresadas por sucursal internet
            SELECT a.idDimPersona,
                   a.rut,
                   a.numcue,
                   a.tipoben,
                   a.fecsol,
                   DATE(DATEFORMAT(a.fecsol, cchFormPeriodo) || cchUno) AS fechaCierre 
            INTO #UniversoWebTMP 
            FROM #UniversoRegistroTMP a 
                INNER JOIN DDS.STP_SOLICPEN b ON a.numcue = b.numcue
                                              AND a.tipoben = b.tipoben
                                              AND a.fecsol = b.fecsol
            WHERE b.sucursal_origen = ctiSucInternet;
            
            --Se busca region a fecha de cierre de fecha de solicitud en modelo de contactabilidad          
            SELECT  c.idDimPersona,
                    c.numcue,
                    c.tipoben,
                    c.fecsol,
                    g.codigo        AS codRegion
            INTO #UniversoRegionTMP 
            FROM DmGestion.FctContactoAfiliado a 
                INNER JOIN DmGestion.DimPersona b ON a.idPersona = b.id
                INNER JOIN #UniversoWebTMP c ON b.rut = c.rut
                INNER JOIN DmGestion.DimPeriodoInformado d ON a.idPeriodoInformado = d.id
                INNER JOIN DmGestion.DimComuna e on a.idComunaPrincipal = e.id
                INNER JOIN DmGestion.DimCiudad f on e.idCiudad = f.id
                INNER JOIN DmGestion.DimRegion g on f.idRegion = g.id
            WHERE d.fecha = c.fechaCierre; 
                            
            
            UPDATE #UniversoRegistroTMP SET
                a.idDimRegion = c.id
            FROM #UniversoRegistroTMP a
                INNER JOIN #UniversoRegionTMP b ON a.idDimPersona = b.idDimPersona
                                         AND a.numcue = b.numcue
                                         AND a.tipoben = b.tipoben
                                         AND a.fecsol = b.fecsol
                INNER JOIN DmGestion.DimRegion c ON b.codRegion = c.codigo
                                        AND c.fechaVigencia >= cdtMaximaFechaVigencia;
                        
            

            --Se aplica información de la matriz 3.0, la cual nos indica que fecha se debe informar en     
            --Fecha Emisión Certificado Saldo
            UPDATE #UniversoRegistroTMP SET
                fechaEmisionCersal = NULL
            WHERE codigoTipoPension NOT IN ('11', '12', '13', '14', '19');
    
            UPDATE #UniversoRegistroTMP SET
                fechaEmisionCersal = NULL
            WHERE codigoTipoPension IN ('11', '12', '13', '14', '19')
            AND codigoModalidadPension NOT IN ('01', '02', '03', '04', '05', '06','07', '08', '09');
    
            UPDATE #UniversoRegistroTMP SET
                fechaEmisionCersal = NULL
            WHERE codigoTipoPension IN ('11', '12', '13', '14', '19')
            AND codigoModalidadPension IN ('08', '09')
            AND indScomp = 'N';
    
            --Indicador SCOMP
            UPDATE #UniversoRegistroTMP SET
               indScomp = 'N'
            WHERE fechaEmisionCersal IS NULL;          
            
            --Casos que tienen la ficha de calculo mayor a la fecha de pago de pensión,
            --para estos casos se deja la fecha de pago pension como fecha de ficha de cálculo.
            UPDATE #UniversoRegistroTMP SET
                fechaEmisionPrimeraFichaCalculoRP = fechaPrimerPagoPenDef
            WHERE fechaEmisionPrimeraFichaCalculoRP > fechaPrimerPagoPenDef
            AND fechaPrimerPagoPenDef IS NOT NULL;           
    
            --Fecha Emisión Primera Ficha de Calculo
            UPDATE #UniversoRegistroTMP SET
                fechaEmisionPrimeraFichaCalculoRP = NULL
            WHERE codigoTipoPension NOT IN ('11', '12', '13', '14', '19');
    
            UPDATE #UniversoRegistroTMP SET
                fechaEmisionPrimeraFichaCalculoRP = NULL
            WHERE codigoTipoPension IN ('11', '12', '13', '14', '19')
            AND codigoModalidadPension NOT IN ('03', '04', '05', '06', '08', '09', '10');
    
            --Fecha Selección Modalidad Pensión
            UPDATE #UniversoRegistroTMP SET
                fechaSelModPen = NULL
            WHERE codigoTipoPension NOT IN ('11', '12', '13', '14', '19');
    
            UPDATE #UniversoRegistroTMP SET
                fechaSelModPen = NULL
            WHERE codigoTipoPension IN ('11', '12', '13', '14', '19')
            AND codigoModalidadPension NOT IN ('01', '02', '03', '04', '05', '06', '07', '08', '09');
    
            UPDATE #UniversoRegistroTMP SET
                fechaSelModPen = NULL
            WHERE codigoTipoPension IN ('11', '12', '13', '14', '19')
            AND codigoModalidadPension IN ('08', '09')
            AND indScomp = 'N';
    
            --IESP-235
            --Se incorpora nueva restricción: El campo Fecha de primer pago de pensión definitiva, 
            --solo se debe de informar si el tipo de pensión es distinto de 15, 17 ó 18 y 
            --la modalidad de pensión al pensionarse es distinta de 00, 01, 02, 07, 10, 11 ó 12.
            --Primer pago definitivo en UF
            UPDATE #UniversoRegistroTMP SET
                fechaPrimerPagoPenDef = NULL
            WHERE codigoTipoPension IN ('16', '17', '18')
            AND codigoModalidadPension IN ('00', '10', '11', '12')
            AND indicadorArt17 = 'S';
    
            --Se debe dejar en nulo para los que tienen modalida de pensión 01, 02 ó 07,
            --Esta fecha se obtendra cuando el modelo de renta vitalicia se genere,
            --debido a que se informa la fecha de traspaso de la prima
            UPDATE #UniversoRegistroTMP SET
                fechaPrimerPagoPenDef = NULL
            WHERE codigoModalidadPension IN (cchCodigoModalidadPension01, 
                                             cchCodigoModalidadPension02, 
                                             cchCodigoModalidadPension07);
    
            --Promedio de Rentas UF
            UPDATE #UniversoRegistroTMP SET
                promedioRentasUF = 0.0
            WHERE numRemunEfectivas = 0;
    
            --Número remuneraciones efectivas
            UPDATE #UniversoRegistroTMP SET
                numRemunEfectivas = 0
            WHERE promedioRentasUF = 0.0;
    
            --IESP-235
            --Se incorpora nueva restricción a la pensión de referencia, Se debe de informar en CERO solo
            --el tipo de pensión es Transitoria (Parcial o Total) y que no sea cubierto
            --Pensión de referencia
            UPDATE #UniversoRegistroTMP SET
                pensionReferenciaUF = 0.0
            WHERE codigoTipoPension IN ('17', '18')
            AND codigoTipoCobertura = '03';
    
            --IESP-235
            --Se incorpora nueva restricción:
            --El campo Monto de la primera pensión definitiva, en UF, debe de ser mayor que CERO, 
            --si el tipo de pensión es igual a 11, 12, 13, 14 ó 19 y 
            --la modalidad de pensión al pensionarse es distinta de 00, 10, 11 ó 12.
            UPDATE #UniversoRegistroTMP SET
                montoPrimPensDefUF = 0.0
            WHERE codigoModalidadPension IN ('00', '10', '11', '12');
    
            UPDATE #UniversoRegistroTMP SET
                montoPrimPensDefUF = 0.0
            WHERE codigoTipoPension IN ('15', '16', '17', '18');
            
            --INICIO - IESP-235
            -- se deja ingreso en 0 para los no cubiertos
            UPDATE #UniversoRegistroTMP SET 
                ingresoBaseUF = cnuMontoCero
            WHERE codigoTipoCobertura = cchCodigoTipoCobertura03; 
            --TERMINO - IESP-235
    
            SELECT DISTINCT u.numcue, 
                u.tipoben, 
                u.fecsol, 
                u.idDimPersona, 
                u.rut, 
                u.idPersonaOrigen, 
                u.codigoTipoPension, 
                u.idDimTipoPension, 
                u.codigoTipoAnualidad,
                u.idDimTipoAnualidad, 
                u.codigoModalidadPension, 
                u.idDimModalidadPension, 
                u.codigoTipoRecalculo,
                u.idDimTipoRecalculo, 
                u.codigoCausalRecalculo, 
                u.idDimCausalRecalculo, 
                u.fechaCalculo
            INTO #UniversoTMP
            FROM #UniversoRegistroTMP u;
           
            --21.1.4. Se obtiene los saldos que se encontrarón en la tabla STP_PENCERSA_PER4 y 
            --        los que no se encontrarón se obtienen de la tabla SLB_FICHAS_CALCULO_SALDO_MF
            SELECT a.numcue, 
                a.tipoben, 
                a.fecsol, 
                a.idDimPersona, 
                a.rut, 
                a.idPersonaOrigen, 
                a.codigoTipoPension, 
                a.idDimTipoPension, 
                a.codigoTipoAnualidad,
                a.idDimTipoAnualidad, 
                a.codigoModalidadPension, 
                a.idDimModalidadPension, 
                a.codigoTipoRecalculo,
                a.idDimTipoRecalculo, 
                a.codigoCausalRecalculo, 
                a.idDimCausalRecalculo, 
                a.idDimTipoProducto, 
                a.codigoTipoProducto, 
                a.nombreTipoProducto, 
                a.idDimTipoFondo,
                a.codigoTipoFondo,
                a.nombreTipoFondo, 
                a.fechaCalculo,
                a.capital_neces_unit_afil,
                a.kn_grupo_familiar, --KN
                a.kn_afil_sin_ebr_cersal, --KN para Bono deReconocimiento
                a.montoPensionCuota, --Monto pensión CCICO Cuota
                a.montoPensionUF, --Monto pensión CCICO UF
                a.valorCuota, 
                a.saldoCuota, --SALDO CCICO Cuota
                a.saldoUF, --SALDO CCICO UF
                a.indicador
            INTO #SaldosTMP
            FROM (
                SELECT  u.numcue, 
                        u.tipoben, 
                        u.fecsol, 
                        u.idDimPersona, 
                        u.rut, 
                        u.idPersonaOrigen, 
                        u.codigoTipoPension, 
                        u.idDimTipoPension, 
                        u.codigoTipoAnualidad,
                        u.idDimTipoAnualidad, 
                        u.codigoModalidadPension, 
                        u.idDimModalidadPension, 
                        u.codigoTipoRecalculo,
                        u.idDimTipoRecalculo, 
                        u.codigoCausalRecalculo, 
                        u.idDimCausalRecalculo, 
                        uT.idDimTipoProducto, 
                        uT.codigoTipoProducto, 
                        uT.nombreTipoProducto, 
                        uT.idDimTipoFondo,
                        uT.codigoTipoFondo,
                        uT.nombreTipoFondo, 
                        uT.fechaCalculo,
                        uT.capital_neces_unit_afil,
                        uT.kn_grupo_familiar, --KN
                        uT.kn_afil_sin_ebr_cersal, --KN para Bono deReconocimiento
                        uT.montoPensionCuota, --Monto pensión CCICO Cuota
                        uT.montoPensionUF, --Monto pensión CCICO UF
                        uT.valorCuota, 
                        uT.saldoCuota, --SALDO CCICO Cuota
                        uT.saldoUF, --SALDO CCICO UF
                        uT.indicador
                FROM #UniversoTMP u
                    INNER JOIN dchavez.UniversoSaldoPensionTMP uT ON u.numcue = uT.numcue
                    AND u.fecsol = uT.fecsol
                    AND u.tipoben = uT.tipoben
                WHERE uT.indicador = 'PER4'
                AND  u.codigoTipoPension <> cchCodigoInvPAET
                UNION
                SELECT  u.numcue, 
                        u.tipoben, 
                        u.fecsol, 
                        u.idDimPersona, 
                        u.rut, 
                        u.idPersonaOrigen, 
                        u.codigoTipoPension, 
                        u.idDimTipoPension, 
                        u.codigoTipoAnualidad,
                        u.idDimTipoAnualidad, 
                        u.codigoModalidadPension, 
                        u.idDimModalidadPension, 
                        u.codigoTipoRecalculo,
                        u.idDimTipoRecalculo, 
                        u.codigoCausalRecalculo, 
                        u.idDimCausalRecalculo, 
                        uT.idDimTipoProducto, 
                        uT.codigoTipoProducto, 
                        uT.nombreTipoProducto, 
                        uT.idDimTipoFondo,
                        uT.codigoTipoFondo,
                        uT.nombreTipoFondo, 
                        uT.fechaCalculo,
                        uT.capital_neces_unit_afil,
                        uT.kn_grupo_familiar, --KN
                        uT.kn_afil_sin_ebr_cersal, --KN para Bono deReconocimiento
                        uT.montoPensionCuota, --Monto pensión CCICO Cuota
                        uT.montoPensionUF, --Monto pensión CCICO UF
                        uT.valorCuota, 
                        uT.saldoCuota, --SALDO CCICO Cuota
                        uT.saldoUF, --SALDO CCICO UF
                        uT.indicador
                FROM #UniversoTMP u
                    INNER JOIN dchavez.UniversoSaldoPensionTMP uT ON u.numcue = uT.numcue
                    AND u.fecsol = uT.fecsol
                    AND u.tipoben = uT.tipoben
                WHERE uT.indicador = 'FICH'
                AND ( u.codigoTipoAnualidad = '01' 
                    OR u.codigoTipoPension = cchCodigoInvPAET )
            )a;
    
            SELECT DISTINCT numcue, 
                fecsol, 
                tipoben, 
                fechaCalculo
            INTO #FechaCalculoTMP
            FROM #SaldosTMP;
               
            UPDATE #UniversoRegistroTMP SET
                u.fechaCalculo = fc.fechaCalculo
            FROM #UniversoRegistroTMP u
                JOIN #FechaCalculoTMP fc ON u.numcue = fc.numcue
                AND u.fecsol = fc.fecsol
                AND u.tipoben = fc.tipoben;
    
            DROP TABLE #FechaCalculoTMP;
            
            --INICIO JIRA
            --Para los que no tiene fecha de calculo se incorpora de los
            --saldos reconstituidos
            SELECT a.rut, 
                   a.ultimaFechaAcreditacion
            INTO #FechaCalculoTMP
            FROM DMGestion.AgrSaldoReconstituido a
                INNER JOIN #UniversoRegistroTMP u ON (a.rut = u.rut)
            WHERE a.tipoPension = 'INVALIDEZ'
            AND a.periodoInformado = ldtFechaPeriodoInformado
            AND a.codigoTipoProducto = 1 --CCICO
            AND (a.saldoFondo1Pesos > 0 OR a.saldoFondo2Pesos > 0)
            AND u.fechaCalculo IS NULL;
    
            UPDATE #UniversoRegistroTMP SET
                u.fechaCalculo = fc.ultimaFechaAcreditacion
            FROM #UniversoRegistroTMP u
                JOIN #FechaCalculoTMP fc ON (u.rut = fc.rut)
            WHERE u.fechaCalculo IS NULL;
    
            DROP TABLE #FechaCalculoTMP;
            
            SELECT a.rut, 
                   a.ultimaFechaAcreditacion
            INTO #FechaCalculoTMP
            FROM DMGestion.AgrSaldoReconstituido a
                INNER JOIN #UniversoRegistroTMP u ON (a.rut = u.rut)
            WHERE a.tipoPension = 'INVALIDEZ'
            AND a.periodoInformado = ldtFechaPeriodoInformado
            AND a.codigoTipoProducto = 6 --CCIAV
            AND (a.saldoFondo1Pesos > 0 OR a.saldoFondo2Pesos > 0)
            AND u.fechaCalculo IS NULL;
    
            UPDATE #UniversoRegistroTMP SET
                u.fechaCalculo = fc.ultimaFechaAcreditacion
            FROM #UniversoRegistroTMP u
                JOIN #FechaCalculoTMP fc ON (u.rut = fc.rut)
            WHERE u.fechaCalculo IS NULL;
    
            DROP TABLE #UniversoTMP;
    
            SELECT DISTINCT u.numcue, 
                u.tipoben, 
                u.fecsol, 
                u.idDimPersona, 
                u.rut, 
                u.idPersonaOrigen, 
                u.codigoTipoPension, 
                u.idDimTipoPension, 
                u.codigoTipoAnualidad,
                u.idDimTipoAnualidad, 
                u.codigoModalidadPension, 
                u.idDimModalidadPension,
                u.codigoTipoRecalculo,
                u.idDimTipoRecalculo, 
                u.codigoCausalRecalculo, 
                u.idDimCausalRecalculo,
                u.fechaCalculo
            INTO #UniversoTMP
            FROM #UniversoRegistroTMP u;
            --FIN JIRA
    
            DROP TABLE dchavez.UniversoSaldoPensionTMP;
  
            --22.16. Actualiza la Remuneración imponible asociada a la última cotización anterior a la fecha 
            --       de la solicitud de pensión, por ser mayor a 99.99 UF el cual queda marcado como error
            UPDATE #UniversoRegistroTMP u SET 
                u.remImpUltCotAnFecSolPenUF = 99.99
            WHERE u.remImpUltCotAnFecSolPenUF > 99.99;
    
            UPDATE #UniversoRegistroTMP u SET 
                u.ingresoBaseUF = 99999.999
            WHERE u.ingresoBaseUF > 99999.999;
    
            UPDATE #UniversoRegistroTMP u SET 
                u.pensionReferenciaUF = 99999.99
            WHERE u.pensionReferenciaUF > 99999.99;

            --INI Jira - INFESP-93
            UPDATE #UniversoRegistroTMP SET
                a.montoPafeUF           = ISNULL(b.mnto_pafe, cnuMontoPAFECero),
                a.signoMontoPafe        = CASE WHEN b.vlor_signo = NULL THEN cchSignoMas
                                               WHEN b.vlor_signo = '' THEN cchSignoMas
                                           ELSE b.vlor_signo END,
                a.indMontoPafeTablaHist = cchS
            FROM #UniversoRegistroTMP a
                JOIN DDS.TN_PAFEACTUALIZADA b ON (a.rut = b.nmro_rutafi);


            --Gchavez CGI 08-05-2014 (+)
            --Actualizar Monto PAFE y Signo PAFE

            SELECT rutAfiliado,
            MAX(periodoInformado) periodoInformado
            INTO #PlanillaPAFETMP
            FROM DDS.PlanillaPAFE
            WHERE tipoAfiliado IN (ctiCero, ctiTres, ctiCuatro, ctiCinco, ctiSeis)
            AND montoPafeUF > cnuMontoPAFECero
            GROUP BY rutAfiliado;

            UPDATE #UniversoRegistroTMP SET
                a.montoPafeUF =  (CASE WHEN b.montoPafeUF = NULL THEN cnuMontoPAFECero
                                       WHEN b.signoMontoPafe = cchSignoMenos THEN cnuMontoPAFECero
                                       ELSE b.montoPafeUF END ),
                a.signoMontoPafe = (CASE
                                        WHEN b.signoMontoPafe = cchSignoMas THEN b.signoMontoPafe
                                        WHEN b.signoMontoPafe = cchSignoMenos THEN cchX
                                        ELSE
                                            cchSignoMas
                                    END)
            FROM #UniversoRegistroTMP a
                INNER JOIN #PlanillaPAFETMP c ON (a.rut = c.rutAfiliado)
                JOIN DDS.PlanillaPAFE b ON (a.rut = b.rutAfiliado AND b.periodoInformado = c.periodoInformado)
            WHERE b.tipoAfiliado IN (ctiCero,ctiTres,ctiCuatro,ctiCinco,ctiSeis)
            AND a.indMontoPafeTablaHist = cchN;
            --Gchavez CGI 08-05-2014 (-)
    
            --INICIO - IESP-235
            --Campo: Monto y Signo PAFE
            --Si se modifico el monto PAFE, se debe de obtener desde la planilla MODPAFE
            SELECT rutBenef,
                MAX(periodoInformado) periodoInformado
            INTO #PlanillaMODPAFETMP
            FROM DDS.PlanillaMODPAFE
            WHERE tipoAfiliado IN (ctiCero, ctiTres, ctiCuatro, ctiCinco, ctiSeis)
            AND montoPafeUF > cnuMontoPAFECero
            GROUP BY rutBenef;
            
            UPDATE #UniversoRegistroTMP SET
                a.montoPafeUF    = (CASE WHEN b.montoPafeUF = NULL THEN cnuMontoPAFECero
                                       WHEN b.signoMontoPafe = cchSignoMenos THEN cnuMontoPAFECero
                                       ELSE b.montoPafeUF END ),
                a.signoMontoPafe =  (CASE
                                        WHEN b.signoMontoPafe = cchSignoMas THEN b.signoMontoPafe
                                        WHEN b.signoMontoPafe = cchSignoMenos THEN cchX
                                        ELSE
                                            cchSignoMas
                                     END)
            FROM #UniversoRegistroTMP a
                JOIN #PlanillaMODPAFETMP c ON (a.rut = c.rutBenef)
                JOIN DDS.PlanillaMODPAFE b ON (c.rutBenef = b.rutBenef
                AND c.periodoInformado = b.periodoInformado)
            WHERE b.tipoAfiliado IN (ctiCero, ctiTres, ctiCuatro, ctiCinco, ctiSeis)
            AND b.montoPafeUF > cnuMontoPAFECero
            AND a.indMontoPafeTablaHist = cchN;
            --FIN Jira - INFESP-93
    
    |UPDATE  #UniversoRegistroTMP 
            SET signoMontoPafe = cchSignoMas
            WHERE signoMontoPafe = cchX;
        
           
            --2. Renta Vitalicias 
            --   No informar PAFE para aquellos pensionados por vejez que seleccionaron modalidad de renta vitalicia antes de 01-07-2008.
            UPDATE #UniversoRegistroTMP SET
                montoPafeUF     = cnuMontoPAFECero,
                signoMontoPafe  = cchBlanco
            WHERE fecsol < cdt20080701
            AND codigoModalidadPension IN (cchCodigoModalidadPension01,
                                           cchCodigoModalidadPension02,
                                           cchCodigoModalidadPension03,
                                           cchCodigoModalidadPension04,
                                           cchCodigoModalidadPension05,
                                           cchCodigoModalidadPension06,
                                           cchCodigoModalidadPension07);


            SELECT dp.rut,fechaSolicitud, fechaMovimiento, dtp.codigo
                INTO #rentasVitalicias
            FROM DMGestion.FctRentasVitaliciasContratadas frv
                INNER JOIN DMGestion.DimPersona dp ON dp.id = frv.idPersona
                INNER JOIN DMGestion.DimPeriodoInformado dpi ON dpi.id = frv.idPeriodoInformado
                INNER JOIN DMGestion.DimTipoPension dtp ON dtp.id = frv.idTipoPension AND dtp.codigo  NOT IN ('01','02','04')
                INNER JOIN #UniversoRegistroTMP b ON dp.rut = b.rut
            WHERE dpi.fecha = ldtFechaPeriodoInformado
            AND fechaSolicitud < cdt20080701;                           
                                       
        
        
             UPDATE #UniversoRegistroTMP SET
                a.montoPafeUF    = cnuMontoPAFECero ,
                a.signoMontoPafe = cchBlanco,
                indPafe = cchNo
            FROM #UniversoRegistroTMP a
                INNER JOIN #rentasVitalicias c ON (a.rut = c.rut);

            SELECT ss.NUMCUE,ss.FECSOL  
                INTO #cambioModalidad
            FROM DDS.STP_SOLICPEN ss
                INNER JOIN #UniversoRegistroTMP tmp ON ss.NUMCUE = tmp.numcue
            WHERE ss.TIPOBEN = ctiDoce    
                AND ss.FECSOL < cdt20080701
                AND ss.CODESTSOL = ctiDos
                AND ss.FECSOL < tmp.fecsol;
                              
            SELECT numrut  
                INTO #CMconRV
            FROM #cambioModalidad cm
                INNER JOIN DDS.SLB_MONTOBEN sm ON sm.numcue = cm.numcue AND cm.FECSOL = sm.fecsol
            WHERE sm.modalidad IN (tiUno, ctiDos,ctiTres,ctiCuatro,ctiCinco,ctiSeis);
            
           
            UPDATE #UniversoRegistroTMP SET
                montoPafeUF     = cnuMontoPAFECero,
                signoMontoPafe  = cchBlanco,
                indPafe = cchIndPafeNo
            FROM #UniversoRegistroTMP a
            INNER JOIN #CMconRV rv ON a.rut = rv.numrut;
           
       /************* INESP-4233  *************/  
       SELECT rut INTO #estadoNoPerfeccionado 
       FROM  #UniversoRegistroTMP uni
       INNER JOIN DMGestion.DimEstadoSolicitud des ON des.id = uni.idDimEstadoSolicitud
       WHERE des.codigo = cinAprobado
       AND uni.fechaEstadoSolicitud >= cdtFecCorteNoPerfect
       AND uni.fechaDefuncion IS NULL
       AND uni.codigoModalidadPension NOT IN (cchCodigoModalidadPension01, cchCodigoModalidadPension02, cchCodigoModalidadPension07)
       AND uni.fechaPrimerPagoPenDef IS NULL;
       
       
       UPDATE #UniversoRegistroTMP
       SET idDimEstadoSolicitud = (SELECT id FROM DMGestion.DimEstadoSolicitud WHERE CODIGO = cinAproNoPerfeccionado AND fechaVigencia >= cdtMaximaFechaVigencia) --APROBADA SIN FECHA DE PAGO EN EL MES DEL INFORME(NO PERFECCIONADA)
       WHERE fechaPrimerPagoPenDef IS NULL
       AND rut IN (SELECT rut FROM #estadoNoPerfeccionado);
    
            --TERMINO - IESP-235
            DROP TABLE dchavez.UniversoInvalidezTMP;
            DROP TABLE dchavez.UniversoMovimientosRVTMP;
           
            UPDATE #UniversoRegistroTMP SET 
                indPafe = cchIndPafeSi
            WHERE signoMontoPafe = cchSignoMas;
        
            /********************* ELIMINCACION INVALIDOS TRANSITORIOS NO REEVALUADOS *********************/
        
        
            SELECT dp.rut,dtp.id idTipoPension,dtp.codigo ,dtp.nombre tipoPension ,indExpasis,fechaDictamen,fechaEjecutPrimerDictInv fecEjePrimDictamenInv ,fecsol fechaSolicitud,
                date(DATEFORMAT(DATEADD(MONTH, ctiNroMesesRevaluacion, isnull(fp.fechaDictamen,fecEjePrimDictamenInv)),'YYYYMM')||'01') periodoTopeReevaluacion, dp.fechaDefuncion 
                , CASE WHEN fp.fechaDefuncion < periodoTopeReevaluacion THEN cchmurioAntes 
                       WHEN fp.fechaDefuncion > periodoTopeReevaluacion THEN cchmurioDespues 
                       WHEN fp.fechaDefuncion = NULL THEN cchvivo 
                    END cuandoMurio
            INTO #RevInvTran
            FROM #UniversoRegistroTMP fp 
                INNER JOIN DMGestion.DimPersona dp ON dp.id = fp.idDimPersona 
                INNER JOIN DMGestion.DimTipoPension dtp ON dtp.id  = fp.idDimTipoPension 
            WHERE dtp.codigo = cch18
            AND indExpasis = cchN
            AND fp.indProcesoReevaluacion = cchN;


            SELECT rut, idTipoPension, indExpasis, fechaDictamen, fecEjePrimDictamenInv,fechaSolicitud,cuandoMurio 
            INTO #borrarInvTransitorios
            FROM #RevInvTran
            WHERE periodoTopeReevaluacion < ldtFechaPeriodoInformado
            AND cuandoMurio <> cchmurioAntes;
                        

            DELETE FROM #UniversoRegistroTMP
            FROM #UniversoRegistroTMP fp 
                INNER JOIN DMGestion.DimPersona dp ON dp.id = fp.idDimPersona 
                INNER JOIN DMGestion.DimTipoPension dtp ON dtp.id  = fp.idDimTipoPension
                INNER JOIN #borrarInvTransitorios del ON del.rut = dp.rut 
                    AND del.idTipoPension = dtp.id 
                    AND del.fechaDictamen = fp.fechaDictamen 
                    AND del.fechaSolicitud = fp.fecsol;
        
            /**********************************************************************************************/   
        
            ------------------------------------------------------------------------------------------- 
            -- Fin Indicador PAFE
            ------------------------------------------------------------------------------------------- 
        
            ---------------------------------------------------
            --23. Se registra en la FctPensionadoInvalidezVejez
            ---------------------------------------------------
            INSERT INTO dchavez.FctPensionadoInvalidezVejez(idPeriodoInformado,
                idTipoProceso, 
                idPersona,
                idTipoPension,
                idTipoAnualidad, 
                idModalidadPension, 
                idTipoRecalculo, 
                idCausalRecalculo, 
                idGradoInvalidezPriDicEjec, -- se agrega nuevo campo
                idGradoInvalidezUniDicEjec, -- se agrega nuevo campo
                idGradoInvalidezSegDicEjec, -- se agrega nuevo campo
                idTipoCobertura,
                idEstadoSolicitud, 
                idRegionTramiteSol,
                fecCalculo,                -- cambio de nombre
                indicadorArticulo17Trans,  -- nuevo nombre campo anterior  
                indicadorArticulo69, 
                fecEmiFichaCalcPensTrans, 
                fecDeclaInvPrimDictEjec,    -- nuevo campo
                fecDeclaInvUniDictEjec,     -- nuevo campo 
                fecDeclaInvUniDicLey20255,  -- nuevo campo 
                fecDecInUniDicAntLey18964,  -- nuevo campo 
                fecDicPosteriorEjec,        -- nuevo campo 
                fecEjePrimDictamenInv,      -- nuevo campo 
                fecEjecUnicoDictamenInv,    -- nuevo campo 
                fecEmiSegundoDicEjec,        -- nuevo campo
                fecEjecutSegundoDic,
                fecEmiCertSaldoModPension, 
                fecEmis1FichaCalculoRP,
                montoTotalAporteAdicUF, 
                pensionReferenciaUF, 
                ingresoBaseUF, 
                promedioRentasRemuneraUF, 
                numRemEfectPromRenRemu,
                remImpUltCotAnFecSolPenUF, 
                fechaSeleccionModPension, 
                fecPrimerPagoPensionDef, 
                fechaSolicitud, 
                perUltCotDevAcrAntFecSol, 
                fechaSolReevalInvalidez,
                fechaEstadoSolicitud, 
                saldoRetenidoUF, 
                codigoModalidadAFP,
                montoPrimPensDefUF,        -- nuevo campo  
                montoPrimPensDefRTUF,
                montoPensionTransitoriaUF, -- nuevo campo
                indicadorSCOMP,            -- nuevo campo
                factorAjuste,              -- nuevo campo
                factorActuorialmenteJusto, -- nuevo campo
                fecPensionAntiguoSistema,  -- nuevo campo
                pensionBasicaSolidariaUF,
                pensionMinimaUF,
                numeroMesesEfecRebaja,
                indicadorArticulo68bis,
                numeroCuenta,   
                indResolReposicionEjec,
                fecEmiPrimUnicoDictEjec,
                montoPafeUF,       -- Campo Nuevo 08-05-2014
                signoMontoPafe,    -- Campo Nuevo 08-05-2014
                porcentajeCobertura,
                indPafe,
                indUsoSaldoRetenido,
                idComisionMedica,
                indExpasis,
                indProcesoReevaluacion,
                numeroDictamen,
                fechaDictamen,
                anioDictamen,               
                numeroFila,       -- se agrega nuevo campo
                idError)
            SELECT linIdPeriodoInformar,
                ltiIdDimTipoProceso, 
                idDimPersona, 
                idDimTipoPension, 
                idDimTipoAnualidad, 
                idDimModalidadPension, 
                idDimTipoRecalculo, 
                idDimCausalRecalculo, 
                idDimGradoInvalidezPrimDic,
                idDimGradoInvalidez,            
                idDimGradoInvalidezSegDic, 
                idDimTipoCobertura, 
                idDimEstadoSolicitud, 
                idDimRegion,
                fechaCalculo, 
                indicadorArt17, 
                indicadorArt69, 
                fechaEmiFCPensionTransit,
                fechaDeclInvPrimerDictEject, 
                fechaDeclaInvPreviaUnicoDictEject,
                fechaDeclaInvTotalUnicoDictEjectLey20255,
                fechaDeclaInvUnicoDictEjectLey18964,
                fecDicPosteriorEjec, 
                fechaEjecutPrimerDictInv, 
                fechaEjecutUnicoDictInv,
                fechaSegundoDictEject,
                fecEjecutSegundoDic,
                fechaEmisionCersal, -- mad
                fechaEmisionPrimeraFichaCalculoRP,
                montoTotalAporteAdicionalUF,
                pensionReferenciaUF, 
                ingresoBaseUF, 
                promedioRentasUF, 
                numRemunEfectivas, 
                remImpUltCotAnFecSolPenUF,   
                fechaSelModPen, 
                fechaPrimerPagoPenDef, 
                fecsol, -- mad
                fecUltCotAntFecSolPension, 
                fechaSolReevalInvalidez, 
                fechaEstadoSolicitud, 
                saldoRetenidoUF, 
                codigoModalidadAFP, 
                montoPrimPensDefUF, 
                montoPrimPensDefRTUF,
                montoPensionTranUF,
                indScomp,
                factorAjuste,
                factorActuorialmenteJusto,
                fec_devenga_sisant,
                pensionBasicaSolidariaUF,
                pensionMinimaUF,
                numeroMesesEfecRebaja,
                indicadorArticulo68bis,
                numcue,
                indResolReposicionEjec,
                fecEmiPrimUnicoDictEjec,
                montoPafeUF,        -- Campo Nuevo 08-05-2014
                signoMontoPafe,     -- Campo Nuevo 08-05-2014
                porcentaje_cobertura_seg,
                indPafe,            -- Campo Nuevo 27-12-2016 Oficio 22.178
                indUsoSaldoRetenido,
                idComisionMedica,
                indExpasis,
                indProcesoReevaluacion,
                numeroDictamen,
                fechaDictamen,
                anioDictamen,
                numeroFila,
                idError
            FROM #UniversoRegistroTMP;
    
            ------------------------------------------------
            --Datos de Auditoria FctPensionadoInvalidezVejez
            ------------------------------------------------
            --24. Se registra datos de auditoria
            SELECT COUNT(*) 
            INTO lbiCantidadRegistrosInformados
            FROM #UniversoRegistroTMP;
            
            COMMIT;
            SAVEPOINT;
    
            SET cantRegRegistrados  = lbiCantidadRegistrosInformados;
            SET codigoError = cstCodigoErrorCero;
        END IF;
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