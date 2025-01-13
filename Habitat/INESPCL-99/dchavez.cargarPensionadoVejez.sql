create PROCEDURE dchavez.cargarPensionadoVejez(OUT cantRegRegistrados BIGINT, OUT codigoError VARCHAR(10))
BEGIN
    /**
        - Nombre archivo                            : cargarPensionadoVejez.sql
        - Nombre del módulo                         : Modelo de Vejez
        - Fecha de  creación                        : 12/06/2010
        - Nombre del autor                          : Cristian Zavaleta V. - Gesfor Chile S.A.
        - Descripción corta del módulo              : 
        - Lista de procedimientos contenidos        : - DMGestion.obtenerIdDimPeriodoInformar
                                                      - DMGestion.obtenerParametro  
                                                      - DMGestion.obtenerFechaPeriodoInformar
                                                      - DMGestion.obtenerUltimaFechaMes
                                                      - DMGestion.eliminarPensionadoVejez
        - Documentos asociados a la creación        : 
        - Fecha de modificación                     : 26/10/2022
        - Nombre de la persona que lo modificó      : Denis Chávez.
        - Cambios realizados                        : Cambios informe PAFE
        - Documentos asociados a la modificación    : INESPCL-74
    **/

    -------------------------------------------------------------------------------------------
    --Declaracion de Variables
    -------------------------------------------------------------------------------------------
    --variable para capturfar el codigo de error
    DECLARE lstCodigoError                      VARCHAR(10);    --variable local de tipo varchar
    --Variables auditoria
    DECLARE lbiCantidadRegistrosInformados      BIGINT;         --variable local de tipo bigint
    --Variables
    DECLARE linIdPeriodoInformar                INTEGER;        --variable local de tipo integer
    DECLARE ldtFechaPeriodoInformado            DATE;           --variable local de tipo date
    DECLARE ldtUltimaFechaPeriodoInformar       DATE;           --variable local de tipo date
    DECLARE ltiIdDimTipoProceso                 TINYINT;        --variable local de tipo tinyint
    DECLARE lnuValorTopeImponible               NUMERIC(7,2);
    DECLARE lbiMaxNumeroFila                    BIGINT;
    -- Constantes
    DECLARE cstOwner                            VARCHAR(150);
    DECLARE cstNombreProcedimiento              VARCHAR(150);   --constante de tipo varchar
    DECLARE cstNombreTablaFct                   VARCHAR(150);   --constante de tipo varchar
    DECLARE cchCodigoTramiteVejInv              CHAR(2);
    DECLARE cstCodigoErrorCero                  VARCHAR(10);
    DECLARE cnuMontoCero                        NUMERIC(2, 1);
    DECLARE cnuMontoPAFECero                    NUMERIC(6, 2);
    DECLARE ctiCero                             TINYINT;
    DECLARE ctiUno                              TINYINT;
    DECLARE ctiDos                              TINYINT;
    DECLARE ctiTres                             TINYINT;
    DECLARE ctiCuatro                           TINYINT;
    DECLARE ctiCinco                            TINYINT;
    DECLARE ctiSeis                             TINYINT;
    DECLARE cdtFecha01IndScomp                  DATE;
    DECLARE cdtFecha02IndScomp                  DATE;
    DECLARE ctiCodTipoCalcFajuSim               TINYINT;
    DECLARE cstCodigoPaisChile                  VARCHAR(2);
    DECLARE cnuPorcentajeRentaImp               NUMERIC(10, 2);
    DECLARE cnuMontoRentaImpDefecto             NUMERIC(10, 2);
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
    DECLARE cchN                                CHAR(1);
    DECLARE cchS                                CHAR(1);
    DECLARE cchSignoMas                         CHAR(1);
    DECLARE cchCodigoSinClasificar              CHAR(2);
    DECLARE cchCodigoModalidadPension00         CHAR(2);
    DECLARE cchCodigoModalidadPension01         CHAR(2);
    DECLARE cchCodigoModalidadPension02         CHAR(2);
    DECLARE cchCodigoModalidadPension03         CHAR(2);
    DECLARE cchCodigoModalidadPension04         CHAR(2);
    DECLARE cchCodigoModalidadPension05         CHAR(2);
    DECLARE cchCodigoModalidadPension06         CHAR(2);
    DECLARE cchCodigoModalidadPension07         CHAR(2);
    DECLARE cchCodigoModalidadPension08         CHAR(2);
    DECLARE cchCodigoModalidadPension09         CHAR(2);
    DECLARE cchCodigoModalidadPension10         CHAR(2);
    DECLARE cchCodigoTipoAnualidad01            CHAR(2);
    DECLARE cchCodigoTipoAnualidad02            CHAR(2);
    DECLARE cchCodigoTipoAnualidad03            CHAR(2);
    DECLARE cchCodigoTipoRecalculo01            CHAR(2);
    DECLARE cchCodigoCausalRecalculo01          CHAR(2);
    DECLARE cchSi                               CHAR(2);
    DECLARE cchNo                               CHAR(2);
    DECLARE cchCodigoVE                         CHAR(2);
    DECLARE cchBlanco                           CHAR(1);
    DECLARE cinCodigoRegionSinClasificar        INTEGER;
    DECLARE cinCodigoFinanciamiento1            INTEGER;
    DECLARE cinModalidad5                       INTEGER;
    DECLARE ctiSucInternet                      TINYINT;
    DECLARE cchFormPeriodo                      VARCHAR(6);
    DECLARE cinCero                             INTEGER;
    DECLARE csmCero                             SMALLINT;
    DECLARE cdtMaximaFechaVigencia              DATE;
    DECLARE ctiEdadLegalPensionarseMasculino    TINYINT;
    DECLARE ctiEdadLegalPensionarseFemenino     TINYINT;
    DECLARE cdtFecCorteNoPerfect                DATE;
    DECLARE cinAproNoPerfeccionado              INTEGER;
    DECLARE cinAprobado                         INTEGER;
    DECLARE cchSexoMasculino                    CHAR(1);
    DECLARE cchSexoFemenino                     CHAR(1);

    -------------------------------------------------------------------------------------------
    --Seteo de Constantes
    -------------------------------------------------------------------------------------------
    SET cstOwner                            = 'DMGestion';
    SET cstNombreProcedimiento      = 'cargarPensionadoVejez';
    SET cstNombreTablaFct           = 'FctPensionadoInvalidezVejez';
    SET cchCodigoTramiteVejInv      = '03';
    SET cstCodigoErrorCero          = '0';
    SET cnuMontoCero                = 0.0;
    SET cnuMontoPAFECero            = 0.0;
    SET ctiCero                     = 0;
    SET ctiUno                      = 1; 
    SET ctiDos                      = 2;
    SET ctiTres                     = 3;
    SET ctiCuatro                   = 4;
    SET ctiCinco                    = 5;
    SET ctiSeis                     = 6;
    SET cdtFecha01IndScomp          = DATE('2009-07-01');
    SET cdtFecha02IndScomp          = DATE('2004-08-19');
    SET ctiCodTipoCalcFajuSim       = 2;
    SET cstCodigoPaisChile          = 'CL';
    SET cnuPorcentajeRentaImp       = 0.1;
    SET cnuMontoRentaImpDefecto     = 0.01;
    SET cinCodigoGrupo1200          = 1200;
    SET cinCodigoSubGrupo1205       = 1205;
    SET cinCodigoSubGrupo1206       = 1206;
    SET cdt20080701                 = '20080701';
    SET cinEdad65                   = 65;
    SET cchIndPafeNo                = 'N';   
    SET cchIndPafeSi                = 'S';  
    SET cchUno                      = '01'; 
    SET cchDos                      = '02';
    SET cchCinco                    = '05';
    SET cchSeis                     = '06';
    SET cchN                        = 'N';
    SET cchS                        = 'S';
    SET cchSignoMas                 = '+';
    SET cchCodigoSinClasificar      = '0';
    SET cchCodigoModalidadPension00 = '00';
    SET cchCodigoModalidadPension05 = '05';
    SET cchCodigoModalidadPension06 = '06';
    SET cchCodigoModalidadPension08 = '08';
    SET cchCodigoModalidadPension09 = '09';
    SET cchCodigoModalidadPension10 = '10';
    SET cchCodigoModalidadPension03 = '03';
    SET cchCodigoModalidadPension04 = '04';
    SET cchCodigoModalidadPension07 = '07';
    SET cchCodigoModalidadPension01 = '01';
    SET cchCodigoModalidadPension02 = '02';
    SET cchCodigoTipoAnualidad01    = '01';
    SET cchCodigoTipoAnualidad02    = '02';
    SET cchCodigoTipoAnualidad03    = '03';
    SET cchCodigoTipoRecalculo01    = '01';
    SET cchCodigoCausalRecalculo01  = '01';
    SET cchSi                       = 'Si';
    SET cchNo                       = 'No';
    SET cchCodigoVE                 = 'VE';
    SET cchBlanco                   = ' ';
    SET cinCodigoRegionSinClasificar= 99; 
    SET cinCodigoFinanciamiento1    = 1;
    SET cinModalidad5               = 5;   
    SET ctiSucInternet              = 97;
    SET cchFormPeriodo              = 'YYYYMM';
    SET cinCero                     = 0;
    SET csmCero                     = 0;
    SET cdtMaximaFechaVigencia              = CONVERT(DATE, DMGestion.obtenerParametro('MAXIMA_FECHA_VIGENCIA'), 103);
    SET ctiEdadLegalPensionarseMasculino    = CONVERT(TINYINT, DMGestion.obtenerParametro('EDAD_LEGAL_PENSIONARSE_MASCULINO'));
    SET ctiEdadLegalPensionarseFemenino     = CONVERT(TINYINT, DMGestion.obtenerParametro('EDAD_LEGAL_PENSIONARSE_FEMENINO'));
    SET cdtFecCorteNoPerfect            = '20220801'; -- Fecha de corte para el universo de tramites NO perfeccionados (aprobados si fecha de primer pago)
    SET cinAproNoPerfeccionado          = 104;
    SET cinAprobado                     = 4;
    SET cchSexoMasculino                = 'M';
    SET cchSexoFemenino                 = 'F';

    -------------------------------------------------------------------------------------------
    --Seteo de Variables
    -------------------------------------------------------------------------------------------
    SET linIdPeriodoInformar                = DMGestion.obtenerIdDimPeriodoInformar();
    SET ldtFechaPeriodoInformado            = DMGestion.obtenerFechaPeriodoInformar();
    SET ldtUltimaFechaPeriodoInformar       = DMGestion.obtenerUltimaFechaMes(ldtFechaPeriodoInformado);
    
    -------------------------------------------------------------------------------------------
    --Cuerpo
    -------------------------------------------------------------------------------------------

    --se obtiene el identificador del tipo de proceso
    SELECT id 
    INTO ltiIdDimTipoProceso
    FROM DMGestion.DimTipoProceso 
    WHERE codigo = cchCodigoTramiteVejInv --'03'
    AND fechaVigencia >= cdtMaximaFechaVigencia;

    --se obtiene valor tope imponible del periodo cotizado
    SELECT valor
    INTO lnuValorTopeImponible
    FROM DMGestion.VistaTopeImponible 
    WHERE DATE(DATEADD(mm, -1, ldtFechaPeriodoInformado)) BETWEEN fechaInicioRango AND fechaTerminoRango;

   
    -------------------------------------------------------------------------------------------------------------
    --UNIVERSOS
    -------------------------------------------------------------------------------------------------------------
    CALL dchavez.cargarUniversoVejezTMP(codigoError);

        
    IF (codigoError = cstCodigoErrorCero) THEN
        --9. Movimientos 87 del universo 1
        --Se Obtiene Universo de los movimientos 87 (Pago Prima Renta Vitalicia)
        CALL dchavez.cargarUniversoMovimientosRVTMP(ldtFechaPeriodoInformado, codigoError);
        
        IF (codigoError = cstCodigoErrorCero) THEN
            --4. Indicador artículo 69 - Campo 5
            --4.1. Universo 1
            SELECT DISTINCT b.numcue, 
                b.tipoben, 
                b.fecsol
            INTO #SLB_BENEFICIOS_CONDICION
            FROM DDS.SLB_BENEFICIOS b
                INNER JOIN dchavez.UniversoVejezTMP u1 ON (b.numcue = u1.numcue 
                AND b.tipoben = u1.tipoben 
                AND b.fecsol = u1.fecsol)
            WHERE u1.numeroUniverso = 1
            AND b.modalidad IN (3, 5) 
            AND b.cod_vigencia = 30; --cesado
                       
            SELECT DISTINCT a.numcue, 
                a.tipoben, 
                a.fecsol
            INTO #IndicadorArt69Universo1
            FROM #SLB_BENEFICIOS_CONDICION a
                INNER JOIN DDS.SLB_BENEFICIOS b ON (a.numcue = b.numcue
                AND a.tipoben = b.tipoben)
            WHERE b.fecsol >= a.fecsol
            AND b.modalidad = 1 
            AND b.tipo_pago = 2
            AND b.cod_vigencia = 10;
        
            --6. Modalidad de pensión seleccionada al pensionarse - Campo 9
            --   Fecha Emision Certificado de saldo - Campo 10 
            --   Fecha emisión primera ficha de cálculo para RP - Campo 11 
            --6.1. Universo 1
            SELECT DISTINCT p.numcue, 
                p.tipoben, 
                p.fecsol, 
                p.modpen_selmod, 
                p.anos_renta_garantizada, 
                p.cod_ciaseg_selmod, 
                p.fecemi_cersal,
                p.fec_emision_selmod, 
                (CASE WHEN (p.promedio_remuner_uf is null) OR (p.promedio_remuner_uf = 0) THEN 
                    (CASE WHEN (s.PROMEDIO_RENTAS_120MESES is NULL) OR (s.PROMEDIO_RENTAS_120MESES = 0) THEN 
                                  p.promedio_remuner_uf ELSE (CASE WHEN s.PROMEDIO_RENTAS_120MESES > lnuValorTopeImponible THEN 0 ELSE s.PROMEDIO_RENTAS_120MESES END)    END ) ELSE 
                                      p.promedio_remuner_uf end) AS promedio_remuner_uf, 
                p.saldo_final_uf
            INTO #STP_PENCERSA_CONDICION_U1
            FROM DDS.STP_PENCERSA p
                INNER JOIN dchavez.UniversoVejezTMP u ON (u.numcue = p.numcue AND u.tipoben = p.tipoben AND u.fecsol = p.fecsol)
                LEFT JOIN DDS.STP_SOLICPEN s ON (s.numcue = p.numcue AND s.tipoben = p.tipoben AND s.fecsol = p.fecsol )             
            WHERE u.numeroUniverso = 1
            AND p.modpen_selmod IS NOT NULL;
                
            --Fecha emisión primera ficha de cálculo para RP
            SELECT u.numcue, 
                   u.tipoben, 
                   u.fecsol, 
                   fc.fec_calculo
            INTO #FichasCalculoMF
            FROM DDS.SLB_FICHAS_CALCULO_MF fc
                INNER JOIN dchavez.UniversoVejezTMP u ON u.numcue = fc.numcue 
                AND u.tipoben = fc.tipoben_stp
                AND u.fecsol = fc.fecsol
            WHERE fc.tipo_ficha = 'RP'
            AND fc.tipo_pago = 2
            AND u.numeroUniverso = 1;
                
            --7. Código del país donde solicita la pensión - Campo 28      
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
                
            --8. Región donde solicita la pensión - Campo 13
            SELECT DISTINCT
                u1.numcue,
                u1.tipoben,
                u1.fecsol,
                (CASE
                    WHEN (CONVERT(TINYINT, r.cod_region) = cinCodigoRegionSinClasificar) THEN 
                        '00'
                    WHEN (CONVERT(TINYINT, r.cod_region) < 10) THEN
                        ('0' || CONVERT(TINYINT, r.cod_region))
                    ELSE 
                        ISNULL(r.cod_region, '00')
                 END) codigoRegionSolicitaPension
            INTO #RegionSolicitaPensionTMP
            FROM dchavez.UniversoVejezTMP u1
                INNER JOIN DDS.TB_DIRECCION_SUCURSAL s ON (u1.sucursal_origen = s.id_sucursal)
                INNER JOIN DDS.TB_COD_REGION r ON (s.id_cod_region = r.id_cod_region)
            WHERE u1.numeroUniverso = 1;
           --AND s.ind_estado = 1; --MODIFICACION INESP-1034
               
            --9. Fecha de primer pago de pensión definitiva - Campo 15
            --9.1. Universo 1
            SELECT DISTINCT rank() OVER (PARTITION BY d.numcue ORDER BY d.fec_liquidacion ASC) rankDocupago,
                d.numcue, 
                d.tipoben, 
                d.fecsol, 
                d.fec_liquidacion
            INTO #SLB_DOCUPAGO_U1
            FROM DDS.SLB_DOCUPAGO d
                INNER JOIN dchavez.UniversoVejezTMP u ON u.numcue = d.numcue 
                AND u.tipoben = d.tipoben 
                AND u.fecsol = d.fecsol
            WHERE u.numeroUniverso = 1
            AND d.tipo_pago = 2;
        
            DELETE FROM #SLB_DOCUPAGO_U1 
            WHERE rankDocupago > 1;
    
            --12. Integración de los campos del 1 - 17 y 20
            --12.1. Universo 1
            SELECT CONVERT(BIGINT, NULL) numeroFila,
                u1.idDimPersona,    --Campo 2
                u1.rut,             --Campo 2
                u1.idPersonaOrigen,
                (CASE 
                    WHEN ((ISNULL(u1.monto_pension_sisant_art17, cnuMontoCero) > cnuMontoCero) OR 
                          (u1.fec_devenga_sisant IS NOT NULL) OR 
                          (ISNULL(u1.cod_inst_sisant, ctiCero) > ctiCero)) THEN 'S'
                    ELSE 'N'
                 END
                ) indicadorArt17, --Campo 4 Indicador artículo 17 transitorio
                (CASE
                    WHEN (ia67.numcue IS NOT NULL) THEN 'S'
                    ELSE 'N'
                 END
                ) indicadorArt69, --Campo 5 Indicador artículo 69
                CONVERT(CHAR(1), 'N') indicadorArt68Bis, --Campo 6 Indicador artículo 68 bis
                u1.codigoTipoPension,    --Campo 7 Tipo de pensión de vejez
                u1.fechaNacimiento,
                u1.sexo,
                u1.fecsol,
                u1.tipoben,
                u1.numcue,
                (CASE
                    WHEN (u1.tipoben = 1) THEN u1.fecsol
                    WHEN ((u1.fechaNacimiento IS NULL) OR 
                          (u1.fechaNacimiento > ldtUltimaFechaPeriodoInformar) OR (u1.fecsol IS NULL)) THEN NULL
                    WHEN ((u1.tipoben = 2) AND 
                          (dateadd(yy, ISNULL((CASE u1.sexo
                                                WHEN cchSexoMasculino THEN ctiEdadLegalPensionarseMasculino
                                                WHEN cchSexoFemenino THEN ctiEdadLegalPensionarseFemenino
                                                ELSE ctiCero
                                               END
                                              ), ctiCero), u1.fechaNacimiento) > u1.fecsol)) THEN 
                        CONVERT(DATE,
                            dateadd(yy, ISNULL((CASE u1.sexo
                                                    WHEN cchSexoMasculino THEN ctiEdadLegalPensionarseMasculino
                                                    WHEN cchSexoFemenino THEN ctiEdadLegalPensionarseFemenino
                                                    ELSE ctiCero 
                                                END), ctiCero), u1.fechaNacimiento)
                        )
                    WHEN ((u1.tipoben = 2) AND 
                          (dateadd(yy, ISNULL((CASE u1.sexo
                                                WHEN cchSexoMasculino THEN ctiEdadLegalPensionarseMasculino
                                                WHEN cchSexoFemenino THEN ctiEdadLegalPensionarseFemenino
                                                ELSE ctiCero
                                               END
                                              ), ctiCero), u1.fechaNacimiento) <= u1.fecsol)) THEN u1.fecsol
                    ELSE NULL
                 END
                ) fechaSolicitudPensionVejez, --Fecha de solicitud de pensión de vejez edad o vejez anticipada - Campo 8
                (CASE
                    WHEN ((p.modpen_selmod = 3) AND 
                          (ISNULL(p.anos_renta_garantizada, ctiCero) = ctiCero)) THEN '01'
                    WHEN ((p.modpen_selmod = 3) AND 
                          (ISNULL(p.anos_renta_garantizada, ctiCero) > ctiCero)) THEN '02'
                    WHEN ((p.modpen_selmod = 5) AND 
                          (ISNULL(p.anos_renta_garantizada, ctiCero) = ctiCero)) THEN '03'
                    WHEN ((p.modpen_selmod = 5) AND 
                          (ISNULL(p.anos_renta_garantizada, ctiCero) > ctiCero)) THEN '04'
                    WHEN ((p.modpen_selmod = 9) AND 
                          (ISNULL(p.anos_renta_garantizada, ctiCero) = ctiCero)) THEN '05'
                    WHEN ((p.modpen_selmod = 9) AND 
                          (ISNULL(p.anos_renta_garantizada, ctiCero) > ctiCero)) THEN '06'
                    WHEN ((p.modpen_selmod) IN (1, 7)) THEN '08'
                    WHEN ((p.modpen_selmod) = 6) THEN '09'
                    ELSE '0'
                 END 
                ) codigoModalidadPension, --Modalidad de pensión seleccionada al pensionarse - Campo 9
                CONVERT(DATE, NULL) fechaEmisionCersal, --Fecha Emision Certificado de saldo - Campo 10 
                fc.fec_calculo fechaEmisionPrimeraFichaCalculoRP, --Fecha emisión primera ficha de cálculo para RP - Campo 11
                ISNULL(ci.codigoPaisRecepcion, cstCodigoPaisChile) codigoPaisSolicitaPension, --Código del país donde solicita la pensión - Campo 12
                (CASE
                    WHEN (codigoPaisSolicitaPension IN (cstCodigoPaisChile)) THEN 
                        rsp.codigoRegionSolicitaPension
                    ELSE '00'
                 END
                ) codigoRegionSolicitaPension, --Región donde solicita la pensión - Campo 13
                p.fec_emision_selmod fechaSelModPen, --Fecha de selección de modalidad de pensión - Campo 14
                docup.fec_liquidacion fechaPrimerPagoPenDef, --Fecha de primer pago de pensión definitiva - Campo 15
                p.promedio_remuner_uf promedioRentasUF, --Promedio de Rentas y/o remuneraciones, en UF - Campo 16
                u1.nro_meses_con_renta numRemunEfectivas, --Número de remuneraciones efectivas consideradas en el promedio de rentas y/o remuneraciones - Campo 17
                p.modpen_selmod codigoModalidadAFP,
                (CASE u1.codestsol
                    WHEN 1 THEN 
                        CONVERT(INTEGER, 1)
                    WHEN 2 THEN 
                        CONVERT(INTEGER, 4)
                    ELSE 
                        CONVERT(INTEGER, ctiCero)
                 END) codigoEstadoSolicitud, --Código del estado de la solicitud
                u1.fecha_codestsol fechaEstadoSolicitud,
                u1.fedevpen,
                u1.subtipben,
                p.fecemi_cersal,
                (CASE 
                    WHEN ((u1.fechaNacimiento IS NOT NULL) AND (u1.fechaNacimiento < ISNULL(u1.fedevpen, fechaSolicitudPensionVejez))) 
                        THEN CONVERT(BIGINT, (DATEDIFF(mm, u1.fechaNacimiento, ISNULL(u1.fedevpen, fechaSolicitudPensionVejez))/12))
                    ELSE NULL
                 END) edad,
                (CASE 
                    WHEN ((u1.fechaNacimiento IS NOT NULL) AND (u1.fechaNacimiento < ldtUltimaFechaPeriodoInformar) AND fechaDefuncion IS NULL) 
                        THEN CONVERT(BIGINT, (DATEDIFF(mm, u1.fechaNacimiento, ldtUltimaFechaPeriodoInformar)/12))
                    WHEN ((u1.fechaNacimiento IS NOT NULL) AND (u1.fechaNacimiento < ldtUltimaFechaPeriodoInformar) AND fechaDefuncion IS NOT NULL) 
                        THEN CONVERT(BIGINT, (DATEDIFF(mm, u1.fechaNacimiento,fechaDefuncion )/12))
                    ELSE NULL
                 END) edadMesInforme,
                CONVERT(NUMERIC(7, 2), cnuMontoCero) montoPrimPensDefUF,
                CONVERT(BIGINT, ctiCero) mesesEfecRebaja,
                CONVERT(CHAR(1), 'N') indScomp,
                u1.fec_devenga_sisant,
                CONVERT(NUMERIC(10, 7), cnuMontoCero) factorAjuste,
                CONVERT(NUMERIC(5, 4), cnuMontoCero) factorActuorialmenteJusto,
                CONVERT(CHAR(2), 'N') codigoGradoInvalidezPriDicEjec,
                CONVERT(CHAR(2), 'N') codigoGradoInvalidezUniDicEjec,
                CONVERT(CHAR(2), 'N') codigoGradoInvalidezSegDicEjec,
                CONVERT(CHAR(2), '03') codigoTipoCobertura,
                CONVERT(NUMERIC(7, 2), 0.0) montoPrimPensDefRTUF,
                CONVERT(BIGINT, NULL) idError,
                u1.fechaDefuncion
            INTO #DatosRegistrar_Universo_1
            FROM dchavez.UniversoVejezTMP u1
                LEFT OUTER JOIN #IndicadorArt69Universo1 ia67 ON (u1.numcue = ia67.numcue
                AND ia67.tipoben = u1.tipoben 
                AND ia67.fecsol = u1.fecsol)
                LEFT OUTER JOIN #STP_PENCERSA_CONDICION_U1 p ON (u1.numcue = p.numcue 
                AND u1.tipoben = p.tipoben 
                AND u1.fecsol = p.fecsol)
                LEFT OUTER JOIN #ConvenioInternacionalTMP ci ON (u1.rut = ci.numrut)
                LEFT OUTER JOIN #RegionSolicitaPensionTMP rsp ON (u1.numcue = rsp.numcue
                AND rsp.tipoben = u1.tipoben 
                AND rsp.fecsol = u1.fecsol)
                LEFT OUTER JOIN #SLB_DOCUPAGO_U1 docup ON (u1.numcue = docup.numcue 
                AND u1.tipoben = docup.tipoben 
                AND u1.fecsol = docup.fecsol)
                LEFT OUTER JOIN #FichasCalculoMF fc ON (u1.numcue = fc.numcue 
                AND u1.tipoben = fc.tipoben 
                AND u1.fecsol = fc.fecsol)
            WHERE u1.numeroUniverso = 1;
            
            -- se agrega el indicaor de articulo 68 bis 
            SELECT b.ant_numrut,
                MAX(b.ant_fec_emision) ant_fec_emision
            INTO #maxFecCse
            FROM #DatosRegistrar_Universo_1 a
                INNER JOIN dds.stp_cse_antecedente b ON (a.rut = b.ant_numrut)
            WHERE a.codigoTipoPension = '02'
            AND b.ant_cambio_modalidad = 'N'
            GROUP BY b.ant_numrut;
    
            SELECT b.ant_numrut,
                MAX(b.ant_fec_emision) ant_fec_emision
            INTO #FecEmisionArt68TMP
            FROM #DatosRegistrar_Universo_1 a
                INNER JOIN #maxFecCse c ON (a.rut = c.ant_numrut)
                INNER JOIN dds.stp_cse_antecedente b ON (b.ant_numrut = c.ant_numrut
                AND b.ant_fec_emision = c.ant_fec_emision)
            WHERE a.codigoTipoPension = '02'
            AND b.ant_trabajo_pesado = 'S'
            AND b.ant_cambio_modalidad = 'N'
            GROUP BY b.ant_numrut;
           
            UPDATE #DatosRegistrar_Universo_1 SET 
                a.indicadorArt68bis = 'S'
            FROM #DatosRegistrar_Universo_1 a
                INNER JOIN #FecEmisionArt68TMP b ON (a.rut = b.ant_numrut)
            WHERE a.codigoTipoPension = '02';
            
            UPDATE #DatosRegistrar_Universo_1 SET 
                u.codigoModalidadPension = '08',
                u.codigoModalidadAFP = 1
            FROM #DatosRegistrar_Universo_1 u
                JOIN DDS.TB_MAE_MOVIMIENTO m ON (u.idPersonaOrigen = m.id_mae_persona)
                JOIN DDS.TB_TIP_MOVIMIENTO tm ON (m.id_tip_movimiento = tm.id_tip_movimiento)
            WHERE u.codigoModalidadPension = '0'
            AND u.fecsol >= '1996-01-01'
            AND tm.cod_movimiento IN(63, 66)
            AND m.fec_movimiento >= u.fecsol;
            
            UPDATE #DatosRegistrar_Universo_1 SET 
                u.codigoModalidadPension = '01',
                u.codigoModalidadAFP = 3
            FROM #DatosRegistrar_Universo_1 u
                JOIN dchavez.UniversoMovimientosRVTMP m ON (u.idPersonaOrigen = m.id_mae_persona)
            WHERE u.codigoModalidadPension = '0'
            AND u.fecsol >= '1996-01-01'
            AND m.fec_movimiento >= u.fecsol;
            
            --debido a que existen casos que no tienen modalidad de pension en la tabla pencersa, 
            --se obtiene de la tabla slb_beneficios   
            SELECT DISTINCT
                a.idDimPersona, 
                a.codigoTipoPension,
                a.fecsol,
                a.tipoben,
                a.numcue,
                b.modalidad,
                b.tipo_pago
            INTO #SLB_Beneficios_Universo01_TMP
            FROM #DatosRegistrar_Universo_1 a   
                INNER JOIN DDS.SLB_BENEFICIOS b ON (a.numcue = b.numcue
                AND a.tipoben = b.tipoben)
            WHERE (a.fecsol = b.fecsol OR a.fedevpen = b.fecsol)
            AND a.codigoModalidadPension = '0'
            AND b.tipo_pago = 2;
            
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
                                                WHEN 1 THEN 
                                                    CONVERT(CHAR(2), '08')
                                                WHEN 3 THEN 
                                                    CONVERT(CHAR(2), '01')
                                                WHEN 5 THEN 
                                                    CONVERT(CHAR(2), '03')
                                                ELSE CONVERT(CHAR(2), '0')
                                            END),
                a.codigoModalidadAFP = b.modalidad
            FROM #DatosRegistrar_Universo_1 a
                JOIN #SLB_Beneficios_Universo01_TMP b ON (a.idDimPersona = b.idDimPersona
                AND a.codigoTipoPension = b.codigoTipoPension
                AND a.numcue = b.numcue
                AND a.tipoben = b.tipoben
                AND a.fecsol = b.fecsol)
            WHERE a.codigoModalidadPension = '0';
    
            --Para los casos que no se pudo clasificar la modalidad de pensión, 
            --se debe obtener una solicitud de invalidez anterior a la solicitud de 
            --vejez y seleccionar la modalidad de la invalidez
            SELECT b.rut,
                e.numcue,
                e.tipoben,
                e.fecsol,
                d.codigo codigoModalidadPension,
                a.codigoModalidadAFP
            INTO #ModalidadPensionInvalidezTMP
            FROM dchavez.FctPensionadoInvalidezVejez a
                INNER JOIN DMGestion.DimPersona b ON (a.idPersona = b.id)
                INNER JOIN DMGestion.DimTipoPension c ON (a.idTipoPension = c.id)
                INNER JOIN DMGestion.DimModalidadPension d ON (a.idModalidadPension = d.id)
                INNER JOIN #DatosRegistrar_Universo_1 e ON (b.rut = e.rut)
            WHERE c.codigo NOT IN ('01', '02') --Solo invalidez
            AND a.fechaSolicitud < e.fecsol
            AND e.codigoModalidadPension = '0'
            AND a.idPeriodoInformado = linIdPeriodoInformar;
    
            UPDATE #DatosRegistrar_Universo_1 SET
                u.codigoModalidadPension = m.codigoModalidadPension,
                u.codigoModalidadAFP = m.codigoModalidadAFP
            FROM #DatosRegistrar_Universo_1 u
                JOIN #ModalidadPensionInvalidezTMP  m ON (u.rut = m.rut
                AND u.numcue = m.numcue
                AND u.tipoben = m.tipoben
                AND u.fecsol = m.fecsol)
            WHERE u.codigoModalidadPension = '0';
            
            UPDATE #DatosRegistrar_Universo_1 SET
                a.codigoModalidadPension = b.codigoModalidadPensionReemplazar,
                a.codigoModalidadAFP = b.codigoModalidadAFPReemplazar
            FROM #DatosRegistrar_Universo_1 a
                JOIN DDS.TramitePensionAprobadoDatoIncompleto b ON (a.rut = b.rut
                AND a.fecsol = b.fechaSolicitud
                AND a.tipoben = b.tipoBeneficio
                AND a.codigoModalidadPension = b.codigoModalidadPension)
            WHERE b.indRegistroInformar = cchSi
            AND b.indInfModalidadPensionReemplazar = cchSi
            AND b.tramitePension = cchCodigoVE;

            -- Casos sin modalidad se deja por defecto RP (08)
            UPDATE #DatosRegistrar_Universo_1 SET 
                u.codigoModalidadPension = '08',
                u.codigoModalidadAFP = 1
            FROM #DatosRegistrar_Universo_1 u 
            WHERE u.codigoModalidadPension = '0';
    
            -- meses efectivos de rebaja
            -- Periodo maximo de trabajo pesado
            --Sobrecotización Trabajo Pesado
            SELECT dp.cuentaAntigua, 
                MAX(ftp.idPeriodoInformado) idPeriodoInformado
            INTO #MaximaPeriodoInformadoTrabajoPesadoTMP
            FROM DMGestion.FctTrabajoPesado ftp
                INNER JOIN DMGestion.DimPersona dp ON (ftp.idPersona = dp.id)
                INNER JOIN DMGestion.DimProcesoCarga dpc ON (ftp.idProcesoCarga = dpc.id)
                INNER JOIN #DatosRegistrar_Universo_1 u ON (u.numcue = dp.cuentaAntigua)
            WHERE u.indicadorArt68bis ='S'
            AND ftp.idPeriodoInformado <= linIdPeriodoInformar
            AND dpc.codigo = '01' --carga mensual
            GROUP BY dp.cuentaAntigua;
    
            SELECT dp.cuentaAntigua, 
                MAX(ftp.idPeriodoInformado) idPeriodoInformado, 
                MAX(ftp.periodoCotizacion) periodoCotizacion
            INTO #UltimaSobrecotizacionTrabajoPesadoTMP
            FROM DMGestion.FctTrabajoPesado ftp
                INNER JOIN DMGestion.DimPersona dp ON (ftp.idPersona = dp.id)
                INNER JOIN DMGestion.DimProcesoCarga dpc ON (ftp.idProcesoCarga = dpc.id)
                INNER JOIN #MaximaPeriodoInformadoTrabajoPesadoTMP mpitp ON (dp.cuentaAntigua = mpitp.cuentaAntigua
                AND ftp.idPeriodoInformado = mpitp.idPeriodoInformado)
            WHERE dpc.codigo = '01' --Carga Mensual
            GROUP BY dp.cuentaAntigua;
    
            --Universo Trabajo Pesado
            SELECT ustp.cuentaAntigua numcue, 
                MAX(ftp.porcentaje) porcentaje,
                MAX(ftp.contadorPeriodosTasa2Porc) contadorPeriodosTasa2Porc, 
                MAX(ftp.contadorPeriodosTasa4Porc) contadorPeriodosTasa4Porc,
                dp.rut
            INTO #periodoPorcentajeTMP
            FROM DMGestion.FctTrabajoPesado ftp
                INNER JOIN DMGestion.DimPersona dp ON (ftp.idPersona = dp.id)
                INNER JOIN DMGestion.DimProcesoCarga dpc ON (ftp.idProcesoCarga = dpc.id)
                INNER JOIN #UltimaSobrecotizacionTrabajoPesadoTMP ustp ON (dp.cuentaAntigua = ustp.cuentaAntigua
                AND ftp.idPeriodoInformado = ustp.idPeriodoInformado
                AND ftp.periodoCotizacion = ustp.periodoCotizacion)
            WHERE dpc.codigo = '01' --Carga Mensual
            GROUP BY ustp.cuentaAntigua,dp.rut;
    
           /************* ACTUALIZACION TRABAJO PESADO POR MOVIMIENTOS QUE NO ESTAN EN EL MODELO *********************/     
       
       SELECT tmp.rut,
       (contadorPeriodosTasa2Porc + tasa2prc) tasa2,
       (contadorPeriodosTasa4Porc + tasa4prc) tasa4 
       INTO #trPesadoSuma
       FROM #periodoPorcentajeTMP tmp
       INNER JOIN DMGestion.AgrTrabajoPesadoNoHabitat agr ON agr.rutAfiliado = tmp.rut AND agr.periodoInformado = ldtFechaPeriodoInformado;
     
     
       UPDATE #periodoPorcentajeTMP
       SET contadorPeriodosTasa2Porc  = b.tasa2,
       contadorPeriodosTasa4Porc = b.tasa4
       FROM #periodoPorcentajeTMP a
       INNER JOIN #trPesadoSuma b ON a.rut = b.rut;
      
      
       INSERT INTO #periodoPorcentajeTMP       
       SELECT dp.cuentaAntigua, CASE WHEN tasa4prc > 0 THEN 4 ELSE 2 END porcentaje,agr.tasa2prc,AGR.tasa4prc,agr.rutAfiliado  
       FROM DMGestion.AgrTrabajoPesadoNoHabitat agr 
       INNER JOIN DMGestion.DimPersona dp ON (agr.rutAfiliado = dp.rut) AND dp.fechaVigencia >= cdtMaximaFechaVigencia
       INNER JOIN #DatosRegistrar_Universo_1 u ON (u.numcue = dp.cuentaAntigua)
       WHERE u.indicadorArt68bis ='S'
       AND  agr.rutAfiliado NOT IN (SELECT rut FROM #periodoPorcentajeTMP)
       AND agr.periodoInformado = ldtFechaPeriodoInformado;  
      
     
       
       /******************************************************************************************************/ 

    
            UPDATE #DatosRegistrar_Universo_1 SET 
                a.mesesEfecRebaja = (CASE
                                        WHEN (ROUND(ISNULL(pp.contadorPeriodosTasa2Porc, ctiCero) * 0.2, 0) > 60) THEN 
                                            60
                                        ELSE ROUND(ISNULL(pp.contadorPeriodosTasa2Porc, ctiCero) * 0.2, 0)
                                     END) 
            FROM #DatosRegistrar_Universo_1 a
                JOIN #periodoPorcentajeTMP pp ON (a.numcue = pp.numcue) 
            WHERE pp.porcentaje = 2 
            AND a.indicadorArt68bis = 'S';
    
            UPDATE #DatosRegistrar_Universo_1 SET 
                a.mesesEfecRebaja = (CASE
                                        WHEN (ROUND(ISNULL(pp.contadorPeriodosTasa4Porc, ctiCero) * 0.4, 0) > 120) THEN 
                                            120
                                        ELSE ROUND(ISNULL(pp.contadorPeriodosTasa4Porc, ctiCero) * 0.4, 0)
                                     END)
            FROM #DatosRegistrar_Universo_1 a 
                JOIN #periodoPorcentajeTMP pp ON (a.numcue = pp.numcue) 
            WHERE pp.porcentaje = 4 
            AND a.indicadorArt68bis = 'S';
    
            --Si no tiene meses de rebaja, se deja con N el indicador Art 68 bis
            UPDATE #DatosRegistrar_Universo_1 SET
                indicadorArt68bis = 'N'
            WHERE indicadorArt68bis = 'S'
            AND mesesEfecRebaja = 0;
    
            -- se obtiene fecha de pensión en el antiguo sistema
            UPDATE #DatosRegistrar_Universo_1 SET 
                a.fec_devenga_sisant = (CASE
                                            WHEN (a.indicadorArt17 = 'S') THEN 
                                                a.fec_devenga_sisant
                                            ELSE NULL
                                        END)
            FROM #DatosRegistrar_Universo_1 a;
    
            -- se rescata fctor de ajuste
            SELECT f.numcue,
                f.numrut,
                f.tipopen,
                MAX(f.fecha_calculo) fecha_calculo   --Obtener el máximo FAJU Fase 2  22-05-2014 
            INTO #MaxFechaFaju
            FROM #DatosRegistrar_Universo_1 u 
                INNER JOIN DDS.slb_faju f ON (u.numcue = f.numcue 
                AND u.rut = f.numrut
                AND u.tipoben = f.tipopen) 
            WHERE f.tipo_calculo <> ctiCodTipoCalcFajuSim --2: Simulacion
            GROUP BY f.numcue, f.numrut, f.tipopen;
    
            SELECT f.numcue,
                f.numrut,
                f.tipopen,
                f.fecha_calculo,
                MAX(f.hora_registro) hora_registro
            INTO #MaxFecHoraFaju
            FROM #MaxFechaFaju m
                INNER JOIN DDS.slb_faju f ON (m.numcue = f.numcue 
                AND m.numrut = f.numrut
                AND m.tipopen = f.tipopen
                AND m.fecha_calculo = f.fecha_calculo)
            WHERE f.tipo_calculo <> ctiCodTipoCalcFajuSim --2_ Simulacion
            GROUP BY f.numcue, f.numrut, f.tipopen, f.fecha_calculo;      
    
            UPDATE #DatosRegistrar_Universo_1 SET 
                u.factorAjuste = ISNULL(f.faju, 0)                                 
            FROM #DatosRegistrar_Universo_1 u
                JOIN #MaxFecHoraFaju m ON (u.numcue = m.numcue 
                AND u.rut = m.numrut
                AND u.tipoben = m.tipopen)
                JOIN DDS.slb_faju f ON (m.numcue = f.numcue
                AND m.numrut = f.numrut
                AND m.tipopen = f.tipopen
                AND m.fecha_calculo = f.fecha_calculo
                AND m.hora_registro = f.hora_registro)    
            WHERE u.indicadorArt17 = 'N'
            AND u.indicadorArt69 = 'N'
            AND u.codigoModalidadPension IN('08', '09');
    
            -- se rescata valor factor actuarialmente justo
            SELECT stp_faj_det_rut,
                MAX(stp_faj_id) stp_faj_id
            INTO #MaxIdFaj
            FROM dds.aps_archivo_faj_det afd 
            GROUP BY stp_faj_det_rut;
               
            UPDATE #DatosRegistrar_Universo_1 SET 
                u.factorActuorialmenteJusto = ISNULL(afd.stp_faj_det_faj, 0)
            FROM #DatosRegistrar_Universo_1 u
                JOIN #MaxIdFaj m ON (u.rut = m.stp_faj_det_rut)
                JOIN dds.aps_archivo_faj_det afd ON (m.stp_faj_det_rut = afd.stp_faj_det_rut
                AND m.stp_faj_id = afd.stp_faj_id)
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
                INNER JOIN #DatosRegistrar_Universo_1 u ON (p.tipoben = u.tipoben
                AND p.fecsol = u.fecsol
                AND p.numcue = u.numcue)
            WHERE p.tipoben IN (1, 2)
            AND p.modpen_selmod = 5
            AND u.codigoModalidadPension IN ('03', '04')
            AND ISNULL(u.montoPrimPensDefRTUF, 0) = 0
            AND ISNULL(p.pension_rt_afil_uf, 0) > 0;
    
            UPDATE #DatosRegistrar_Universo_1 SET
                u.montoPrimPensDefRTUF = m.pension_rt_afil_uf
            FROM #DatosRegistrar_Universo_1 u
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
                INNER JOIN #DatosRegistrar_Universo_1 u ON (m.id_mae_persona = u.idPersonaOrigen)
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
            INTO #VistaValorUFFecMovimientoTMP
            FROM #MontoPrimeraPenDefRTUF_U2_TMP u
                INNER JOIN DMGestion.VistaValorUF v ON (u.fec_movimiento = v.fechaUF);
    
            UPDATE #MontoPrimeraPenDefRTUF_U2_TMP SET
                u.montoUF = CONVERT(NUMERIC(7, 2), ROUND((u.monto_pesos / v.valorUF), 2))
            FROM #MontoPrimeraPenDefRTUF_U2_TMP u
                INNER JOIN #VistaValorUFFecMovimientoTMP v ON (u.fec_movimiento = v.fechaUF);
    
            UPDATE #DatosRegistrar_Universo_1 SET
                u.montoPrimPensDefRTUF = m.montoUF
            FROM #DatosRegistrar_Universo_1 u
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
                INNER JOIN #DatosRegistrar_Universo_1 u ON (p.tipoben = u.tipoben
                AND p.fecsol = u.fecsol
                AND p.numcue = u.numcue)
            WHERE p.tipoben IN (1, 2)
            AND p.modalidad = 5
            AND p.tipo_pago = 2
            AND p.cod_financiamiento = 2
            AND u.codigoModalidadPension IN ('03', '04')
            AND ISNULL(u.montoPrimPensDefRTUF, 0) = 0
            AND montoUF > 0;
 
            UPDATE #DatosRegistrar_Universo_1 SET
                u.montoPrimPensDefRTUF = m.montoUF
            FROM #DatosRegistrar_Universo_1 u
                JOIN #MontoPrimeraPenDefRTUF_U3_TMP m ON (m.tipoben = u.tipoben
                AND m.fecsol = u.fecsol
                AND m.numcue = u.numcue)
            WHERE u.codigoModalidadPension IN ('03', '04')
            AND ISNULL(u.montoPrimPensDefRTUF, 0) = 0;
            --TERMINO - IESP-235

            ---------------------------------------------
            --13. Integración del Universo 1 y Universo 2
            ---------------------------------------------
            SELECT numeroFila,
                idDimPersona,                        --Campo 2
                rut,                                 --Campo 2
                idPersonaOrigen,
                indicadorArt17,                      --Indicador artículo 17 transitorio - Campo 4
                indicadorArt69,                      --Indicador artículo 69 - Campo 5
                indicadorArt68Bis,                   --Indicador artículo 68 bis - Campo 6
                codigoTipoPension,                   --Tipo de pensión de vejez - Campo 7
                fechaNacimiento,
                sexo,
                fecsol,
                tipoben,
                numcue,
                fechaSolicitudPensionVejez,          --Fecha de solicitud de pensión de vejez edad o vejez anticipada - Campo 8
                codigoModalidadPension,              --Modalidad de pensión seleccionada al pensionarse - Campo 9
                fechaEmisionCersal,                  --Fecha Emision Certificado de saldo - Campo 10
                fechaEmisionPrimeraFichaCalculoRP,   --Fecha emisión primera ficha de cálculo para RP - Campo 11
                codigoPaisSolicitaPension,           --Código del país donde solicita la pensión - Campo 12
                codigoRegionSolicitaPension,               --Región donde solicita la pensión - Campo 13
                fechaSelModPen,                      --Fecha de selección de modalidad de pensión - Campo 14
                fechaPrimerPagoPenDef,               --Fecha de primer pago de pensión definitiva - Campo 15
                promedioRentasUF,                    --Promedio de Rentas y/o remuneraciones, en UF - Campo 16
                numRemunEfectivas,                   --Número de remuneraciones efectivas consideradas en el promedio de rentas y/o remuneraciones - Campo 17
                --montoPensionCalculadoUF,             --Monto pensión calculado, en UF - Campo 20
                (CASE 
                    WHEN (codigoModalidadPension IN (cchCodigoModalidadPension00, 
                                                     cchCodigoModalidadPension05, 
                                                     cchCodigoModalidadPension06, 
                                                     cchCodigoModalidadPension08, 
                                                     cchCodigoModalidadPension09, 
                                                     cchCodigoModalidadPension10)) THEN 
                        cchCodigoTipoAnualidad01 --RP
                    WHEN (codigoModalidadPension IN (cchCodigoModalidadPension03, 
                                                     cchCodigoModalidadPension04, 
                                                     cchCodigoModalidadPension07)) THEN 
                        cchCodigoTipoAnualidad02 --RT
                    WHEN (codigoModalidadPension IN (cchCodigoModalidadPension01, 
                                                     cchCodigoModalidadPension02)) THEN 
                        cchCodigoTipoAnualidad03 --RV
                    ELSE 
                        cchCodigoSinClasificar
                 END
                )                           AS codigoTipoAnualidad,
                cchCodigoTipoRecalculo01    AS codigoTipoRecalculo,
                cchCodigoCausalRecalculo01  AS codigoCausalRecalculo,
                codigoModalidadAFP,
                codigoEstadoSolicitud, --Código del estado de la solicitud
                fechaEstadoSolicitud,
                edad,
                edadMesInforme,
                fedevpen,
                fecemi_cersal,
                montoPrimPensDefUF,
                mesesEfecRebaja,
                indScomp,
                fec_devenga_sisant,
                factorAjuste,
                factorActuorialmenteJusto,
                codigoGradoInvalidezPriDicEjec,
                codigoGradoInvalidezUniDicEjec,
                codigoGradoInvalidezSegDicEjec,
                codigoTipoCobertura,
                montoPrimPensDefRTUF,
                ctiUno AS numeroUniverso,
                idError,
                fechaDefuncion
            INTO #DatosRegistrar_Universo_2
            FROM #DatosRegistrar_Universo_1;

           
            SELECT u.idDimPersona,                        --Campo 2
                u.rut,                                 --Campo 2
                u.idPersonaOrigen,
                u.indicadorArt17,                      --Indicador artículo 17 transitorio - Campo 4
                u.indicadorArt69,                      --Indicador artículo 69 - Campo 5
                u.indicadorArt68Bis,                   --Indicador artículo 68 bis - Campo 6
                dtp.id idDimTipoPension,               --Tipo de pensión de vejez - Campo 7
                u.codigoTipoPension,                   --Tipo de pensión de vejez - Campo 7
                u.fechaNacimiento,
                u.sexo,
                u.fecsol,
                u.tipoben,
                u.numcue,
                u.fechaSolicitudPensionVejez,          --Fecha de solicitud de pensión de vejez edad o vejez anticipada - Campo 8
                dmp.id idDimModalidadPension,          --Modalidad de pensión seleccionada al pensionarse - Campo 9
                u.codigoModalidadPension,              --Modalidad de pensión seleccionada al pensionarse - Campo 9
                u.fechaEmisionCersal,                  --Fecha Emision Certificado de saldo - Campo 10
                u.fechaEmisionPrimeraFichaCalculoRP,   --Fecha emisión primera ficha de cálculo para RP - Campo 11
                u.codigoPaisSolicitaPension,           --Código del país donde solicita la pensión - Campo 12
                u.codigoRegionSolicitaPension,               --Región donde solicita la pensión - Campo 13
                u.fechaSelModPen,                      --Fecha de selección de modalidad de pensión - Campo 14
                u.fechaPrimerPagoPenDef,               --Fecha de primer pago de pensión definitiva - Campo 15
                ISNULL(u.promedioRentasUF, 0.0) promedioRentasUF,                    --Promedio de Rentas y/o remuneraciones, en UF - Campo 16
                ISNULL(u.numRemunEfectivas, 0) numRemunEfectivas,                   --Número de remuneraciones efectivas consideradas en el promedio de rentas y/o 
                                                       --remuneraciones - Campo 17
                CONVERT(DATE, NULL) periodoSolicitudPensionVejez,
                CONVERT(NUMERIC(6, 2), 0.0) remImpUltCotAnFecSolPenUF, --Remuneración imponible asociada a la última cotización anterior 
                                                                        --a la fecha de la solicitud de pensión, en UF - Campo 18
                CONVERT(DATE, NULL) fecUltCotAntFecSolPension, --Fecha última cotización anterior a la fecha de solicitud de pensión - Campo 19
                --u.montoPensionCalculadoUF,             --Monto pensión calculado, en UF - Campo 20
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
                u.edad,
                u.edadMesInforme,
                u.fedevpen,
                u.fecemi_cersal,
                CONVERT(NUMERIC(10, 2), 0.0) pensionMinimaUF,
                CONVERT(NUMERIC(10, 2), 0.0) pensionBasicaSolidariaUF,
                u.montoPrimPensDefUF,
                u.mesesEfecRebaja,
                u.indScomp,
                u.fec_devenga_sisant,
                u.factorAjuste,
                u.factorActuorialmenteJusto,
                ISNULL(dr.idRegion, 0) idDimRegion,
                dgi01.id idGradoInvalidezPriDicEjec,
                dgi02.id idGradoInvalidezUniDicEjec,
                dgi03.id idGradoInvalidezSegDicEjec,
                dtc.id idTipoCobertura,
                CONVERT(CHAR(1), 'N') compPM_PBS,
                CONVERT(NUMERIC(9, 2), 0.0) saldoRetenidoUF,
                CONVERT(NUMERIC(7, 2), 0.0) ingresoBaseUF,
                CONVERT(NUMERIC(7, 2), 0.0) pensionReferenciaUF,
                CONVERT(NUMERIC(7, 2), 0.0) montoTotalAporteAdicionalUF,
                CONVERT(NUMERIC(7, 2), 0.0) montoPensionTransitoriaUF,
                CONVERT(CHAR(1), 'N') indResolReposicionEjec,
                CONVERT(NUMERIC(6, 2), cnuMontoPAFECero) montoPafeUF,
                CONVERT(CHAR(1), ' ') signoMontoPafe,
                cchIndPafeNo                AS indPafe, -- Nuevo Campo Oficio 22.178, JIRA INFESP72
                u.montoPrimPensDefRTUF,
                CONVERT(DATE, NULL) fechaCierre,
                cchN AS indUsoSaldoRetenido,
                cchN AS indMontoPafeTablaHist,
                cchN AS indExpasis,
                cchN AS indProcesoReevaluacion,
                ctiCero AS idComisionMedica,
                cinCero AS numeroDictamen,
                csmCero AS anioDictamen,  
                u.numeroUniverso,
                u.idError,
                fechaDefuncion,
                ROW_NUMBER() OVER(ORDER BY u.numcue ASC, 
                                    u.tipoben ASC,
                                    u.fecsol ASC) AS numeroFila
            INTO #UniversoRegistroTMP
            FROM #DatosRegistrar_Universo_2 u
                INNER JOIN DMGestion.DimTipoPension dtp ON (u.codigoTipoPension = dtp.codigo)
                INNER JOIN DMGestion.DimModalidadPension dmp ON (u.codigoModalidadPension = dmp.codigo)
                INNER JOIN DMGestion.DimTipoAnualidad dta ON (u.codigoTipoAnualidad = dta.codigo)
                INNER JOIN DMGestion.DimTipoRecalculo dtr ON (u.codigoTipoRecalculo = dtr.codigo)
                INNER JOIN DMGestion.DimEstadoSolicitud des ON (u.codigoEstadoSolicitud = des.codigo)
                INNER JOIN DMGestion.DimCausalRecalculo dcr ON (u.codigoCausalRecalculo = dcr.codigo
                AND u.codigoTipoPension = dcr.tipoPension)
                INNER JOIN DMGestion.DimGradoInvalidez dgi01 ON (u.codigoGradoInvalidezPriDicEjec = dgi01.codigo)
                INNER JOIN DMGestion.DimGradoInvalidez dgi02 ON (u.codigoGradoInvalidezUniDicEjec = dgi02.codigo)
                INNER JOIN DMGestion.DimGradoInvalidez dgi03 ON (u.codigoGradoInvalidezSegDicEjec = dgi03.codigo)
                INNER JOIN DMGestion.DimTipoCobertura dtc ON (u.codigoTipoCobertura = dtc.codigo)
                LEFT OUTER JOIN #DimRegionTMP dr ON (u.codigoPaisSolicitaPension = dr.codigoPais
                AND u.codigoRegionSolicitaPension = dr.codigoRegion)
            WHERE dtp.fechaVigencia >= cdtMaximaFechaVigencia
            AND dmp.fechaVigencia >= cdtMaximaFechaVigencia
            AND dta.fechaVigencia >= cdtMaximaFechaVigencia
            AND des.fechaVigencia >= cdtMaximaFechaVigencia
            AND dcr.fechaVigencia >= cdtMaximaFechaVigencia
            AND dgi01.fechaVigencia >= cdtMaximaFechaVigencia
            AND dgi02.fechaVigencia >= cdtMaximaFechaVigencia
            AND dgi03.fechaVigencia >= cdtMaximaFechaVigencia
            AND dtc.fechaVigencia >= cdtMaximaFechaVigencia;
            
            --14. Eliminación de las tablas temporales
            DROP TABLE #IndicadorArt69Universo1;
            DROP TABLE #STP_PENCERSA_CONDICION_U1;
            DROP TABLE #RegionSolicitaPensionTMP;
            DROP TABLE #SLB_DOCUPAGO_U1;
            DROP TABLE #ConvenioInternacionalTMP;
            DROP TABLE #DatosRegistrar_Universo_1;
            
            --DATAW-4752 - Marca de expasis
            UPDATE #UniversoRegistroTMP SET
                u.indExpasis = 'S'
            FROM #UniversoRegistroTMP u
            INNER JOIN DDS.TB_EXPASIS ex ON (u.rut = ex.rut_afiliado
                                            AND ex.estado = 1 );
        
            --Inicio JIRA - IESP-32
            --1. Fecha de primer pago de pensión definitiva
            SELECT a.numcue,
                u.idDimPersona,
                a.tipoben,
                a.modalidad,
                u.fedevpen,
                MIN(a.fec_primer_pago) fec_primer_pago 
            INTO #FechaPrimerPagoPensionTMP
            FROM DDS.SLB_MONTOBEN a 
                INNER JOIN #UniversoRegistroTMP u ON (a.numcue = u.numcue
                AND a.modalidad = u.codigoModalidadAFP
                AND a.tipoben = u.tipoben
                AND a.fecsol = u.fedevpen)
            WHERE a.fec_primer_pago IS NOT NULL
            AND u.fechaPrimerPagoPenDef IS NULL
            AND (u.fechaEstadoSolicitud < cdtFecCorteNoPerfect OR u.fechaDefuncion IS NOT NULL) /************* INESP-4233  *************/ 
            GROUP BY a.numcue, u.idDimPersona, a.tipoben, a.modalidad, u.fedevpen;
           
            UPDATE #UniversoRegistroTMP SET
                u.fechaPrimerPagoPenDef = fpp.fec_primer_pago
            FROM #UniversoRegistroTMP u
                JOIN #FechaPrimerPagoPensionTMP fpp ON (fpp.numcue = u.numcue
                AND fpp.modalidad = u.codigoModalidadAFP
                AND fpp.tipoben = u.tipoben
                AND fpp.fedevpen = u.fedevpen
                AND fpp.idDimPersona = u.idDimPersona)
            WHERE u.fechaPrimerPagoPenDef IS NULL;
    
            DROP TABLE #FechaPrimerPagoPensionTMP;
    
            SELECT a.numcue,
                u.idDimPersona,
                a.tipoben,
                u.fecsol,
                MAX(a.ferealiz) ferealiz
            INTO #FechaPrimerPagoPensionTMP
            FROM DDS.STP_FECHAPEN a
                INNER JOIN #UniversoRegistroTMP u ON (a.numcue = u.numcue
                AND a.tipoben = u.tipoben
                AND a.fecsol = u.fecsol)
            WHERE a.ferealiz IS NOT NULL
            AND a.codeven IN (998, 999)
            AND u.fechaPrimerPagoPenDef IS NULL
            AND (u.fechaEstadoSolicitud < cdtFecCorteNoPerfect OR u.fechaDefuncion IS NOT NULL)/************* INESP-4233  *************/ 
            GROUP BY a.numcue, u.idDimPersona, a.tipoben, u.fecsol; 
    
            UPDATE #UniversoRegistroTMP SET
                u.fechaPrimerPagoPenDef = fpp.ferealiz
            FROM #UniversoRegistroTMP u
                JOIN #FechaPrimerPagoPensionTMP fpp ON (fpp.numcue = u.numcue
                AND fpp.tipoben = u.tipoben
                AND fpp.fecsol = u.fecsol
                AND fpp.idDimPersona = u.idDimPersona)
            WHERE u.fechaPrimerPagoPenDef IS NULL;
    
            --2. Número de remuneraciones efectivas consideradas en el promedio de rentas
            --y/o remuneraciones
            --Restricción: no puede ser mayor a 120
            UPDATE #UniversoRegistroTMP SET
                numRemunEfectivas = 120
            WHERE numRemunEfectivas > 120;
        
            --3. Fecha Emisión Certificado de Saldo para seleccionar modalidad de pensión.
            UPDATE #UniversoRegistroTMP SET
                fechaEmisionCersal = fecemi_cersal
            WHERE codigoModalidadPension IN ('01', '02', '03', '04', '05', '06', '07', '08', '09');
    
            --Para los que no se pudo obtener la Fecha emisión certificado saldo.
            SELECT a.numcue,
                u.idDimPersona,
                a.tipoben,
                u.fecsol,
                MAX(a.ferealiz) ferealiz
            INTO #FechaEmisionCertifSaldoTMP
            FROM DDS.STP_FECHAPEN a
                INNER JOIN #UniversoRegistroTMP u ON (a.numcue = u.numcue
                AND a.tipoben = u.tipoben
                AND a.fecsol = u.fecsol)
            WHERE a.ferealiz IS NOT NULL
            AND u.codigoEstadoSolicitud = 4 --Aprobado Historico
            AND a.codeven = 500
            AND u.fechaEmisionCersal IS NULL
            AND u.codigoModalidadPension IN ('01', '02', '03', '04', '05', '06', '07', '08', '09')
            GROUP BY a.numcue, u.idDimPersona, a.tipoben, u.fecsol; 
    
            UPDATE #UniversoRegistroTMP SET
                u.fechaEmisionCersal = f.ferealiz
            FROM #UniversoRegistroTMP u
                JOIN #FechaEmisionCertifSaldoTMP f ON (u.numcue = f.numcue
                AND u.idDimPersona = f.idDimPersona
                AND u.tipoben = f.tipoben
                AND u.fecsol = f.fecsol)
            WHERE u.fechaEmisionCersal IS NULL
            AND u.codigoModalidadPension  IN ('01', '02', '03', '04', '05', '06', '07', '08', '09');
            
            --4. Fecha Emisión primera ficha de cálculo para RP
            SELECT a.numcue,
                u.idDimPersona,
                a.tipoben,
                u.fecsol,
                MAX(a.ferealiz) ferealiz
            INTO #FechaEmisionPrimeraFCTMP
            FROM DDS.STP_FECHAPEN a
                INNER JOIN #UniversoRegistroTMP u ON (a.numcue = u.numcue
                AND a.tipoben = u.tipoben
                AND a.fecsol = u.fecsol)
            WHERE a.ferealiz IS NOT NULL
            AND a.codeven IN (998, 999)
            --AND u.indicadorArt17 = 'N' se pide eliminar esta logica JIRA 197
            AND u.codigoEstadoSolicitud = 4 --Aprobado Historico
            AND u.codigoModalidadPension IN ('03', '04', '05', '06','08', '09')
            AND u.fechaEmisionPrimeraFichaCalculoRP IS NULL
            GROUP BY a.numcue, u.idDimPersona, a.tipoben, u.fecsol; 
    
            UPDATE #UniversoRegistroTMP SET
                u.fechaEmisionPrimeraFichaCalculoRP = fpp.ferealiz--dateadd(dd,-1,fpp.ferealiz) --JIRA 197
            FROM #UniversoRegistroTMP u
                JOIN #FechaEmisionPrimeraFCTMP fpp ON (fpp.numcue = u.numcue
                AND fpp.tipoben = u.tipoben
                AND fpp.fecsol = u.fecsol
                AND fpp.idDimPersona = u.idDimPersona)
            WHERE --u.indicadorArt17 = 'N' AND --JIRA 197
            u.codigoModalidadPension IN ('03', '04', '05', '06','08', '09')
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
                INNER JOIN #UniversoRegistroTMP u ON (a.numcue = u.numcue
                AND a.tipoben = u.tipoben
                AND a.fecsol = u.fecsol)
            WHERE a.ferealiz IS NOT NULL
            AND u.codigoEstadoSolicitud = 4 --Aprobado Historico
            AND a.codeven = 600
            AND u.fechaSelModPen IS NULL
            AND u.codigoModalidadPension IN ('01', '02', '03', '04', '05', '06', '07', '08', '09')
            GROUP BY a.numcue, u.idDimPersona, a.tipoben, u.fecsol; 
    
            UPDATE #UniversoRegistroTMP SET
                u.fechaSelModPen = f.ferealiz
            FROM #UniversoRegistroTMP u
                JOIN #FechaSelecModPenTMP f ON (u.numcue = f.numcue
                AND u.idDimPersona = f.idDimPersona
                AND u.tipoben = f.tipoben
                AND u.fecsol = f.fecsol)
            WHERE u.fechaSelModPen IS NULL
            AND u.codigoModalidadPension  IN ('01', '02', '03', '04', '05', '06', '07', '08', '09');

            --y para los que se les cambiara la modalidad de pension
            UPDATE #UniversoRegistroTMP SET
                a.fechaEmisionCersal                = b.fecEmiCertSaldoModPension,
                a.fechaSelModPen                    = b.fechaSeleccionModPension,
                a.fechaEmisionPrimeraFichaCalculoRP = b.fecEmis1FichaCalculoRP,
                a.fechaPrimerPagoPenDef             = b.fecPrimerPagoPensionDef,
                a.montoPrimPensDefUF                = ISNULL(b.montoPrimPensDefUF, 0),
                a.codigoModalidadPension            = b.codigoModalidadPension,
                a.idDimModalidadPension             = 0
            FROM #UniversoRegistroTMP a
                JOIN DDS.TramitePensionAprobadoDatoIncompleto b ON (a.rut = b.rut
                AND a.fecsol = b.fechaSolicitud
                AND a.tipoben = b.tipoBeneficio)
            WHERE b.indRegistroInformar = cchSi
            AND b.indInfModalidadPensionRecuperada = cchSi
            AND b.tramitePension = cchCodigoVE;
    
            UPDATE #UniversoRegistroTMP SET
                a.idDimModalidadPension = b.id
            FROM #UniversoRegistroTMP a
                JOIN DMGestion.DimModalidadPension b ON (a.codigoModalidadPension = b.codigo)
            WHERE a.idDimModalidadPension = 0
            AND b.fechaVigencia >= cdtMaximaFechaVigencia;
    
            ----------------------------------------
            --Primera pensión defenitiva
            ----------------------------------------
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
            UPDATE #UniversoRegistroTMP SET 
                u.montoPrimPensDefUF = ISNULL(c.montoPensionUF, cnuMontoCero)
            FROM #UniversoRegistroTMP u
                JOIN #MontoPensionRPUFPencersaTMP c ON (u.numcue  = c.numcue 
                AND u.tipoben = c.tipoben 
                AND u.fecsol  = c.fecsol)
            WHERE u.codigoModalidadpension IN ('08', '09')
            AND ISNULL(c.montoPensionUF, cnuMontoCero) > cnuMontoCero;
    
            UPDATE #UniversoRegistroTMP SET 
                u.montoPrimPensDefUF = ISNULL(c.montoPenDefUF, cnuMontoCero)
            FROM #UniversoRegistroTMP u
                JOIN (SELECT u.numcue,
                        u.tipoben,
                        u.fecsol,
                        SUM(ISNULL(fcs.retiro_mensual_afil_ob_uf, cnuMontoCero) + 
                            ISNULL(fcs.retiro_mensual_afil_vo_uf, cnuMontoCero) +
                            ISNULL(fcs.retiro_mensual_afil_co_uf, cnuMontoCero) +
                            ISNULL(fcs.RETIRO_MENSUAL_AFIL_AV_UF, cnuMontoCero)) montoPenDefUF
                      FROM #UniversoRegistroTMP u        
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
    
            --INICIO - Solucion para el cambio Oficio N° 11.440
            --Si el monto de pension calculado en uf es CERO o NULO se obtiene
            --desde la tb_mae_movimiento con los codigos 63, 64 o 66
            --solo los que tienen modalidad RP.
            SELECT idPersonaOrigen,
                numcue, 
                tipoben, 
                fecsol
            INTO #CasosSinMontoPensionCalculadoTMP
            FROM #UniversoRegistroTMP
            WHERE ISNULL(montoPrimPensDefUF, cnuMontoCero) <= cnuMontoCero
            AND codigoModalidadPension IN ('08', '09');
    
            --Se obtiene los movimientos 63, 64 y 66
            SELECT c.idPersonaOrigen,
                c.numcue, 
                c.tipoben, 
                c.fecsol,
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
                MAX(a.per_cot) per_cot
            INTO #MaximoPerCotMontoPensionTMP
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
                INNER JOIN #MaximoPerCotMontoPensionTMP b ON (a.idPersonaOrigen = b.idPersonaOrigen
                AND a.fec_movimiento = b.fec_movimiento
                AND a.per_cot = b.per_cot
                AND a.tipoben = b.tipoben
                AND a.fecsol = b.fecsol)
            GROUP BY a.idPersonaOrigen, a.numcue,  a.tipoben, a.fecsol, a.fec_movimiento, a.fec_acreditacion, a.per_cot;
    
            SELECT DISTINCT vvUF.fechaUF,
                vvUF.valorUF
            INTO #VistaValorUFFecMovimiento02TMP
            FROM #UniversoMontoPensionTMP a
                JOIN DMGestion.VistaValorUF vvUF ON (a.fec_movimiento = vvUF.fechaUF);

            UPDATE #UniversoMontoPensionTMP SET
                a.montoUF = ROUND((CONVERT(BIGINT, a.monto_pesos) / CONVERT(NUMERIC(7, 2), vvUF.valorUF)), 2)
            FROM #UniversoMontoPensionTMP a
                JOIN #VistaValorUFFecMovimiento02TMP vvUF ON (a.fec_movimiento = vvUF.fechaUF);
    
            --Si el monto en uf es mayor a 99999.99 se deja en CERO
            UPDATE #UniversoMontoPensionTMP SET
                montoUF = cnuMontoCero
            WHERE montoUF > 99999.99;
    
            UPDATE #UniversoRegistroTMP SET
                a.montoPrimPensDefUF = b.montoUF
            FROM #UniversoRegistroTMP a
                JOIN #UniversoMontoPensionTMP b ON (a.idPersonaOrigen = b.idPersonaOrigen
                AND a.fecsol = b.fecsol
                AND a.tipoben = b.tipoben)
            WHERE a.codigoModalidadpension IN ('08', '09')
            AND ISNULL(a.montoPrimPensDefUF, cnuMontoCero) = cnuMontoCero;
            --TERMINO Oficio N° 11.440
            ------------------------------
    
            -- renta vitalicia
            UPDATE #UniversoRegistroTMP SET 
                u.montoPrimPensDefUF = (ISNULL(m.monto_obligatorio, cnuMontoCero) + 
                                        ISNULL(m.monto_voluntario, cnuMontoCero) + 
                                        ISNULL(m.monto_convenido, cnuMontoCero) +
                                        ISNULL(m.monto_afi_voluntario, cnuMontoCero))
            FROM #UniversoRegistroTMP u
                JOIN DDS.slb_montoben m ON (u.numcue = m.numcue
                AND u.tipoben = m.tipoben 
                AND u.fecsol = m.fecsol)
            WHERE m.modalidad = 3
            AND m.cod_financiamiento = 1
            AND u.codigoModalidadPension IN ('01', '02', '07');
    
            --renta temporal con renta vitalicia diferida
            SELECT sc.numcue,  
                sc.tipoben,
                sc.fecsol,
                sc.monto_obligatorio,
                sc.monto_voluntario,
                sc.monto_convenido,
                sc.monto_afi_voluntario,
                sc.fec_inicio,
                sc.fec_termino
            INTO #SLB_MONTOBEN_02TMP
            FROM (
                SELECT smb.numcue,  
                    smb.tipoben,
                    smb.fecsol,
                    smb.monto_obligatorio,
                    smb.monto_voluntario,
                    smb.monto_convenido,
                    smb.monto_afi_voluntario,
                    smb.fec_inicio,
                    smb.fec_termino,
                    DENSE_RANK() OVER (PARTITION BY smb.numcue, smb.tipoben, smb.fecsol ORDER BY smb.fec_inicio DESC, ISNULL(smb.fec_termino, getDate()) DESC) orden
                FROM DDS.SLB_MONTOBEN smb 
                    INNER JOIN #UniversoRegistroTMP u ON (u.numcue = smb.numcue
                        AND u.tipoben = smb.tipoben 
                        AND u.fecsol = smb.fecsol
                        AND u.codigoModalidadPension IN (cchCodigoModalidadPension03, cchCodigoModalidadPension04))
                WHERE smb.modalidad = cinModalidad5
                AND smb.cod_financiamiento = cinCodigoFinanciamiento1
            ) sc
            WHERE sc.orden = ctiUno;

            UPDATE #UniversoRegistroTMP SET 
                u.montoPrimPensDefUF = (ISNULL(smb.monto_obligatorio, cnuMontoCero) + 
                                        ISNULL(smb.monto_voluntario, cnuMontoCero) + 
                                        ISNULL(smb.monto_convenido, cnuMontoCero) +
                                        ISNULL(smb.monto_afi_voluntario, cnuMontoCero))
            FROM  #UniversoRegistroTMP u 
                JOIN #SLB_MONTOBEN_02TMP smb ON (u.numcue = smb.numcue
                AND u.tipoben = smb.tipoben 
                AND u.fecsol = smb.fecsol)
            WHERE u.codigoModalidadPension IN (cchCodigoModalidadPension03, cchCodigoModalidadPension04);
    
            --Casos donde el monto de la priemra pension defenitiva en UF no existe en la tabla SLB_MONTOBEN
            UPDATE #UniversoRegistroTMP SET 
                u.montoPrimPensDefUF = ISNULL(p.pension_rv_afil_uf, cnuMontoCero)
            FROM #UniversoRegistroTMP u 
                JOIN DDS.stp_pencersa p ON (u.numcue = p.numcue
                AND u.tipoben = p.tipoben 
                AND u.fecsol = p.fecsol)
            WHERE ISNULL(u.montoPrimPensDefUF, cnuMontoCero) = cnuMontoCero
            AND u.codigoModalidadPension IN ('03', '04', '01', '02', '07');
    
            -- renta vitalicia con retiro programado
            UPDATE #UniversoRegistroTMP SET 
                u.montoPrimPensDefUF = (ISNULL(m.monto_obligatorio, cnuMontoCero) + 
                                        ISNULL(m.monto_voluntario, cnuMontoCero) + 
                                        ISNULL(m.monto_convenido, cnuMontoCero) + 
                                        ISNULL(m.monto_afi_voluntario, cnuMontoCero))
            FROM #UniversoRegistroTMP u 
                JOIN DDS.slb_montoben m ON (u.numcue = m.numcue
                AND u.tipoben = m.tipoben 
                AND u.fecsol = m.fecsol)
            WHERE m.modalidad = 3 
            AND m.cod_financiamiento = 1
            AND u.codigoModalidadpension = '05';
    
            UPDATE #UniversoRegistroTMP SET 
                u.montoPrimPensDefUF = (ISNULL(u.montoPrimPensDefUF, cnuMontoCero) + 
                                        ISNULL(c.montoPensionUF, cnuMontoCero))
            FROM #UniversoRegistroTMP u 
                JOIN #MontoPensionRPUFPencersaTMP c ON (u.numcue = c.numcue
                AND u.tipoben = c.tipoben
                AND u.fecsol = c.fecsol)  
            WHERE u.codigoModalidadpension = '05';

            SELECT sc.numcue,  
                sc.tipoben,
                sc.fecsol,
                sc.monto_obligatorio,
                sc.monto_voluntario,
                sc.monto_convenido,
                sc.monto_afi_voluntario,
                sc.fec_inicio,
                sc.fec_termino
            INTO #SLB_MONTOBEN_04TMP
            FROM (
                SELECT smb.numcue,  
                    smb.tipoben,
                    smb.fecsol,
                    smb.monto_obligatorio,
                    smb.monto_voluntario,
                    smb.monto_convenido,
                    smb.monto_afi_voluntario,
                    smb.fec_inicio,
                    smb.fec_termino,
                    DENSE_RANK() OVER (PARTITION BY smb.numcue, smb.tipoben, smb.fecsol ORDER BY smb.fec_inicio DESC, ISNULL(smb.fec_termino, getDate()) DESC) orden
                FROM DDS.SLB_MONTOBEN smb 
                    INNER JOIN #UniversoRegistroTMP u ON (u.numcue = smb.numcue
                        AND u.tipoben = smb.tipoben 
                        AND u.fecsol = smb.fecsol
                        AND u.codigoModalidadPension = cchCodigoModalidadPension06)
                WHERE smb.modalidad = cinModalidad5
                AND smb.cod_financiamiento = cinCodigoFinanciamiento1
            ) sc
            WHERE sc.orden = ctiUno;
   
            UPDATE #UniversoRegistroTMP SET
                u.montoPrimPensDefUF = (ISNULL(smb.monto_obligatorio, cnuMontoCero) + 
                                        ISNULL(smb.monto_voluntario, cnuMontoCero) + 
                                        ISNULL(smb.monto_convenido, cnuMontoCero) + 
                                        ISNULL(smb.monto_afi_voluntario, cnuMontoCero))
            FROM #UniversoRegistroTMP u
                JOIN #SLB_MONTOBEN_04TMP smb ON (u.numcue = smb.numcue
                AND u.tipoben = smb.tipoben 
                AND u.fecsol = smb.fecsol)
            WHERE u.codigoModalidadpension = cchCodigoModalidadPension06;
    
            UPDATE #UniversoRegistroTMP SET
                u.montoPrimPensDefUF = (ISNULL(u.montoPrimPensDefUF, cnuMontoCero) + 
                                        ISNULL(c.montoPensionUF, cnuMontoCero))
            FROM #UniversoRegistroTMP u
                JOIN #MontoPensionRPUFPencersaTMP c ON (u.numcue = c.numcue
                AND u.tipoben = c.tipoben 
                AND u.fecsol = c.fecsol)  
            WHERE u.codigoModalidadpension = '06';
    
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
                INNER JOIN #UniversoRegistroTMP b ON (a.numcue = b.numcue
                AND a.tipoben = b.tipoben
                AND a.fecsol = b.fecsol);
    
            UPDATE #UniversoRegistroTMP SET
                u.fechaCierre = a.fecierre
            FROM #UniversoRegistroTMP u
                JOIN #UniversoPencersaTMP a ON (a.numcue = u.numcue
                AND a.tipoben = u.tipoben
                AND a.fecsol = u.fecsol);
    
            --Si no tiene una fecha de cierre entonces e deja la fecha del primer pago de pensión definitiva
            UPDATE #UniversoRegistroTMP SET
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
    
            UPDATE #UniversoRegistroTMP SET
                u.pensionMinimaUF = ISNULL(a.ant_pen_min_uf, 0.0),
                u.pensionBasicaSolidariaUF = ISNULL(a.pbs_aps, 0.0)
            FROM #UniversoRegistroTMP u
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
            FROM #UniversoRegistroTMP u, DMGestion.VistaValorPensionMinima vvpm
            WHERE periodoFechaCierre  = vvpm.periodo
            AND u.montoPrimPensDefUF > cnuMontoCero
            AND u.codigoTipoPension = '01' --Vejez Normal
            AND pensionMinimaPesos IS NOT NULL
            AND u.pensionMinimaUF = 0;

            SELECT DISTINCT v.fechaUF,
                v.valorUF
            INTO #VistaValorUFFechaCierre01TMP
            FROM #PensionMinimaTMP p
                JOIN DMGestion.VistaValorUF v ON (p.fechaCierre = v.fechaUF);
                
            UPDATE #PensionMinimaTMP SET 
                p.pensionMinimaUF = (CONVERT(NUMERIC(10, 2), p.pensionMinimaPesos) / isnull(v.valorUF,p.pensionMinimaPesos))
            FROM #PensionMinimaTMP p
                JOIN #VistaValorUFFechaCierre01TMP v ON (p.fechaCierre = v.fechaUF);
    
            UPDATE #UniversoRegistroTMP SET 
                u.pensionMinimaUF = isnull(p.pensionMinimaUF, 0)
            FROM #UniversoRegistroTMP u
                JOIN #PensionMinimaTMP p ON (u.numcue = p.numcue
                AND u.idDimPersona = p.idDimPersona
                AND u.codigoModalidadPension = p.codigoModalidadPension)
            WHERE u.codigoTipoPension = '01' --Vejez Normal
            AND u.pensionMinimaUF = 0;
    
            SELECT DISTINCT u.numcue,
                u.idDimPersona,
                u.codigoModalidadPension,
                u.fechaCierre,
                pbs.monto pensionBasicaSolidariaPesos,
                CONVERT(NUMERIC(10, 2), cnuMontoCero) pensionBasicaSolidariaUF
            INTO #PensionBasicaSolidariaTMP
            FROM #UniversoRegistroTMP u, DMGestion.VistaPensionBasicaSolidaria pbs 
            WHERE u.fechaCierre BETWEEN pbs.fechaInicioRango AND pbs.fechaTerminoRango
            AND u.pensionBasicaSolidariaUF = 0;

            SELECT DISTINCT v.fechaUF,
                v.valorUF
            INTO #VistaValorUFFechaCierre02TMP
            FROM #PensionBasicaSolidariaTMP p
                JOIN DMGestion.VistaValorUF v ON (p.fechaCierre = fechaUF);
    
            UPDATE #PensionBasicaSolidariaTMP SET 
                p.pensionBasicaSolidariaUF = (CONVERT(NUMERIC(10, 2), p.pensionBasicaSolidariaPesos) / v.valorUF)
            FROM #PensionBasicaSolidariaTMP p
                JOIN #VistaValorUFFechaCierre02TMP v ON (p.fechaCierre = v.fechaUF);
    
            UPDATE #UniversoRegistroTMP SET 
                u.pensionBasicaSolidariaUF = p.pensionBasicaSolidariaUF
            FROM #UniversoRegistroTMP u
                JOIN #PensionBasicaSolidariaTMP p ON (u.numcue = p.numcue
                AND u.idDimPersona = p.idDimPersona
                AND u.codigoModalidadPension = p.codigoModalidadPension)
            WHERE u.pensionBasicaSolidariaUF = 0;
    
            -- indicador SCOMP
            -- se valida que la pensión sea mayor que la pensión basica solidaria
            UPDATE #UniversoRegistroTMP a SET 
                a.indScomp = 'S'
            FROM #UniversoRegistroTMP a
            WHERE a.fechaSolicitudPensionVejez >= cdtFecha01IndScomp --'2009-07-01'
            AND a.montoPrimPensDefUF > a.pensionBasicaSolidariaUF
            AND a.pensionBasicaSolidariaUF > 0;
    
            UPDATE #UniversoRegistroTMP a SET 
                a.indScomp = 'S'
            WHERE a.fechaSolicitudPensionVejez > cdtFecha02IndScomp--'2004-08-19'
            AND a.codigoModalidadPension IN ('01', '02', '03', '04', '05', '06', '07'); 
    
            -- Se valida que la pension sea mayor que la pensión minima
            UPDATE #UniversoRegistroTMP a SET 
                a.indScomp = 'S'
            WHERE a.fechaSolicitudPensionVejez < cdtFecha01IndScomp-- '2009-07-01'                         
            AND a.fechaSolicitudPensionVejez > cdtFecha02IndScomp--'2004-08-19'
            AND a.montoPrimPensDefUF > a.pensionMinimaUF
            AND a.pensionMinimaUF > 0;
    
            UPDATE #UniversoRegistroTMP a SET 
                a.indScomp = 'S'
            WHERE a.fechaSolicitudPensionVejez > cdtFecha02IndScomp--'2004-08-19'
              AND a.codigoTipoPension = '02';
    
            SELECT MAX(numeroFila) AS maxNroFila
            INTO lbiMaxNumeroFila
            FROM dchavez.FctPensionadoInvalidezVejez
            WHERE idPeriodoInformado = linIdPeriodoInformar;

            UPDATE #UniversoRegistroTMP u SET
                numeroFila = isnull(lbiMaxNumeroFila,1) + numeroFila;
    
            --16. Remuneración imponible asociada a la última cotización anterior a la fecha de la 
            --    solicitud de pensión, en UF - Campo 18
            UPDATE #UniversoRegistroTMP u SET
                u.periodoSolicitudPensionVejez = DATE(DATEFORMAT(u.fechaSolicitudPensionVejez, 'YYYYMM') || '01')
            WHERE u.fechaSolicitudPensionVejez IS NOT NULL;
        
            SELECT m.codigoTipoProducto,
                   u.numeroFila, 
                   u.idPersonaOrigen, 
                   m.per_cot, 
                   m.fec_movimiento, 
                   m.renta_imponible, 
                   u.periodoSolicitudPensionVejez, 
                   u.tipoben, 
                   u.fechaSolicitudPensionVejez,
                   m.monto_pesos
            INTO #TB_MAE_MOVIMIENTO
            FROM DDS.VectorCotizaciones m
                INNER JOIN #UniversoRegistroTMP u ON (m.id_mae_persona = u.idPersonaOrigen)
            WHERE u.fechaSolicitudPensionVejez IS NOT NULL
            AND m.per_cot < u.periodoSolicitudPensionVejez
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
                periodoSolicitudPensionVejez, 
                tipoben, 
                MAX(per_cot) periodoCotizacion
            INTO #MaximoPerCot
            FROM #TB_MAE_MOVIMIENTO
            GROUP BY codigoTipoProducto, idPersonaOrigen, periodoSolicitudPensionVejez, tipoben;
        
            SELECT m.codigoTipoProducto,
                m.idPersonaOrigen, 
                m.periodoSolicitudPensionVejez, 
                m.per_cot, m.tipoben, 
                CONVERT(NUMERIC(6, 2), ROUND((CONVERT(BIGINT, SUM(m.renta_imponible)) / CONVERT(NUMERIC(7, 2), MAX(vvUF.valorUF))), 2)) renta_imponible
            INTO #RentaImponibleTMP
            FROM #TB_MAE_MOVIMIENTO m
                INNER JOIN #MaximoPerCot mpc ON (m.idPersonaOrigen = mpc.idPersonaOrigen
                AND m.per_cot = mpc.periodoCotizacion
                AND m.periodoSolicitudPensionVejez = mpc.periodoSolicitudPensionVejez
                AND m.codigoTipoProducto = mpc.codigoTipoProducto)
                INNER JOIN DMGestion.VistaValorUF vvUF ON mpc.periodoCotizacion = vvUF.periodo
            WHERE vvUF.ultimoDiaMes = 'S'
            GROUP BY m.codigoTipoProducto, m.idPersonaOrigen, m.periodoSolicitudPensionVejez, m.per_cot, m.tipoben;
    
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
            UPDATE #UniversoRegistroTMP SET 
                u.remImpUltCotAnFecSolPenUF = ri.renta_imponible
            FROM #UniversoRegistroTMP u 
                JOIN #RentaImponibleTMP ri ON (u.idPersonaOrigen = ri.idPersonaOrigen
                AND u.periodoSolicitudPensionVejez = ri.periodoSolicitudPensionVejez
                AND u.tipoben = ri.tipoben)
            WHERE ri.codigoTipoProducto = 1;
    
            --Producto CCIAV si no tiene CCICO
            UPDATE #UniversoRegistroTMP SET 
                u.remImpUltCotAnFecSolPenUF = ri.renta_imponible
            FROM #UniversoRegistroTMP u 
                JOIN #RentaImponibleTMP ri ON (u.idPersonaOrigen = ri.idPersonaOrigen
                AND u.periodoSolicitudPensionVejez = ri.periodoSolicitudPensionVejez
                AND u.tipoben = ri.tipoben)
            WHERE ri.codigoTipoProducto = 6
            AND ISNULL(u.remImpUltCotAnFecSolPenUF, ctiCero) = ctiCero;

            --Casos que tienen renta imponible pero al convertirlos a UF es muy pequeño la cantidad,
            --Estos casos quedaran registrados con monto 0.01.
            UPDATE #UniversoRegistroTMP SET
                u.remImpUltCotAnFecSolPenUF = cnuMontoRentaImpDefecto
            FROM #UniversoRegistroTMP u 
                JOIN #RentaImponibleTMP ri ON (u.idPersonaOrigen = ri.idPersonaOrigen
                AND u.periodoSolicitudPensionVejez = ri.periodoSolicitudPensionVejez
                AND u.tipoben = ri.tipoben)
            WHERE ISNULL(u.remImpUltCotAnFecSolPenUF, ctiCero) = ctiCero;
            
            --17. Fecha última cotización anterior a la fecha de solicitud de pensión - Campo 19
            --Producto CCICO
            UPDATE #UniversoRegistroTMP SET
                u.fecUltCotAntFecSolPension = mpc.periodoCotizacion
            FROM #UniversoRegistroTMP u 
                JOIN #MaximoPerCot mpc ON u.idPersonaOrigen = mpc.idPersonaOrigen
                AND u.periodoSolicitudPensionVejez = mpc.periodoSolicitudPensionVejez
                AND u.tipoben = mpc.tipoben
            WHERE mpc.codigoTipoProducto = 1;
    
            --Producto CCIAV si no tiene producto CCICO
            UPDATE #UniversoRegistroTMP SET
                u.fecUltCotAntFecSolPension = mpc.periodoCotizacion
            FROM #UniversoRegistroTMP u 
                JOIN #MaximoPerCot mpc ON u.idPersonaOrigen = mpc.idPersonaOrigen
                AND u.periodoSolicitudPensionVejez = mpc.periodoSolicitudPensionVejez
                AND u.tipoben = mpc.tipoben
            WHERE mpc.codigoTipoProducto = 6
            AND u.fecUltCotAntFecSolPension IS NULL;
        
            --18. Eliminación de las tablas temporales
            DROP TABLE #TB_MAE_MOVIMIENTO;
            DROP TABLE #MaximoPerCot;
            DROP TABLE #RentaImponibleTMP;
            DROP TABLE dchavez.UniversoVejezTMP;
 
            UPDATE #UniversoRegistroTMP SET     
                a.indicadorArt17                    = (CASE WHEN b.indArticulo17 IS NOT NULL                THEN b.indArticulo17                ELSE a.indicadorArt17                       END),
                a.indicadorArt69                    = (CASE WHEN b.indArticulo69 IS NOT NULL                THEN b.indArticulo69                ELSE a.indicadorArt69                       END),
                a.indicadorArt68Bis                 = (CASE WHEN b.indArticulo68bis IS NOT NULL             THEN b.indArticulo68bis             ELSE a.indicadorArt68Bis                    END),
                a.fechaEmisionCersal                = (CASE WHEN b.fecEmiCertSaldoModPension IS NOT NULL    THEN b.fecEmiCertSaldoModPension    ELSE a.fechaEmisionCersal                   END),
                a.fechaEmisionPrimeraFichaCalculoRP = (CASE WHEN b.fecEmis1FichaCalculoRP IS NOT NULL       THEN b.fecEmis1FichaCalculoRP       ELSE a.fechaEmisionPrimeraFichaCalculoRP    END),
                a.fechaSelModPen                    = (CASE WHEN b.fechaSeleccionModPension IS NOT NULL     THEN b.fechaSeleccionModPension     ELSE a.fechaSelModPen                       END),
                a.fechaPrimerPagoPenDef             = (CASE WHEN b.fecPrimerPagoPensionDef IS NOT NULL      THEN b.fecPrimerPagoPensionDef      ELSE a.fechaPrimerPagoPenDef                END),
                a.promedioRentasUF                  = (CASE WHEN b.promedioRentasRemuneraUF IS NOT NULL     THEN b.promedioRentasRemuneraUF     ELSE a.promedioRentasUF                     END),
                a.numRemunEfectivas                 = (CASE WHEN b.numRemEfectPromRenRemu IS NOT NULL       THEN b.numRemEfectPromRenRemu       ELSE a.numRemunEfectivas                    END),
                a.remImpUltCotAnFecSolPenUF         = (CASE WHEN b.remImpUltCotAnFecSolPenUF IS NOT NULL    THEN b.remImpUltCotAnFecSolPenUF    ELSE a.remImpUltCotAnFecSolPenUF            END),
                a.fecUltCotAntFecSolPension         = (CASE WHEN b.perUltCotDevAcrAntFecSol IS NOT NULL     THEN b.perUltCotDevAcrAntFecSol     ELSE a.fecUltCotAntFecSolPension            END),
                a.montoPrimPensDefUF                = (CASE WHEN b.montoPrimPensDefUF IS NOT NULL           THEN b.montoPrimPensDefUF           ELSE a.montoPrimPensDefUF                   END),
                a.mesesEfecRebaja                   = (CASE WHEN b.numeroMesesEfecRebaja IS NOT NULL        THEN b.numeroMesesEfecRebaja        ELSE a.mesesEfecRebaja                      END),
                a.montoPrimPensDefRTUF              = (CASE WHEN b.montoPrimPensDefRTUF IS NOT NULL         THEN b.montoPrimPensDefRTUF         ELSE a.montoPrimPensDefRTUF                 END),
                a.codigoRegionSolicitaPension       = (CASE WHEN b.codigoRegionTramiteSol IS NOT NULL       THEN b.codigoRegionTramiteSol       ELSE a.codigoRegionSolicitaPension          END),
                a.idDimRegion                       = (CASE WHEN b.codigoRegionTramiteSol IS NOT NULL       THEN 0                              ELSE a.idDimRegion                          END)
            FROM #UniversoRegistroTMP a
                JOIN DDS.TramitePensionAprobadoDatoIncompleto b ON (a.rut = b.rut
                AND a.fecsol = b.fechaSolicitud
                AND a.tipoben = b.tipoBeneficio
                AND a.codigoModalidadPension = b.codigoModalidadPension)
            WHERE b.indRegistroInformar = cchSi
            AND b.indInfModalidadPensionRecuperada = cchNo
            AND b.indInfModalidadPensionReemplazar = cchNo
            AND b.tramitePension = cchCodigoVE;

            UPDATE #UniversoRegistroTMP SET     
                a.indicadorArt17                    = (CASE WHEN b.indArticulo17 IS NOT NULL                THEN b.indArticulo17                ELSE a.indicadorArt17                       END),
                a.indicadorArt69                    = (CASE WHEN b.indArticulo69 IS NOT NULL                THEN b.indArticulo69                ELSE a.indicadorArt69                       END),
                a.indicadorArt68Bis                 = (CASE WHEN b.indArticulo68bis IS NOT NULL             THEN b.indArticulo68bis             ELSE a.indicadorArt68Bis                    END),
                a.fechaEmisionCersal                = (CASE WHEN b.fecEmiCertSaldoModPension IS NOT NULL    THEN b.fecEmiCertSaldoModPension    ELSE a.fechaEmisionCersal                   END),
                a.fechaEmisionPrimeraFichaCalculoRP = (CASE WHEN b.fecEmis1FichaCalculoRP IS NOT NULL       THEN b.fecEmis1FichaCalculoRP       ELSE a.fechaEmisionPrimeraFichaCalculoRP    END),
                a.fechaSelModPen                    = (CASE WHEN b.fechaSeleccionModPension IS NOT NULL     THEN b.fechaSeleccionModPension     ELSE a.fechaSelModPen                       END),
                a.fechaPrimerPagoPenDef             = (CASE WHEN b.fecPrimerPagoPensionDef IS NOT NULL      THEN b.fecPrimerPagoPensionDef      ELSE a.fechaPrimerPagoPenDef                END),
                a.promedioRentasUF                  = (CASE WHEN b.promedioRentasRemuneraUF IS NOT NULL     THEN b.promedioRentasRemuneraUF     ELSE a.promedioRentasUF                     END),
                a.numRemunEfectivas                 = (CASE WHEN b.numRemEfectPromRenRemu IS NOT NULL       THEN b.numRemEfectPromRenRemu       ELSE a.numRemunEfectivas                    END),
                a.remImpUltCotAnFecSolPenUF         = (CASE WHEN b.remImpUltCotAnFecSolPenUF IS NOT NULL    THEN b.remImpUltCotAnFecSolPenUF    ELSE a.remImpUltCotAnFecSolPenUF            END),
                a.fecUltCotAntFecSolPension         = (CASE WHEN b.perUltCotDevAcrAntFecSol IS NOT NULL     THEN b.perUltCotDevAcrAntFecSol     ELSE a.fecUltCotAntFecSolPension            END),
                a.montoPrimPensDefUF                = (CASE WHEN b.montoPrimPensDefUF IS NOT NULL           THEN b.montoPrimPensDefUF           ELSE a.montoPrimPensDefUF                   END),
                a.mesesEfecRebaja                   = (CASE WHEN b.numeroMesesEfecRebaja IS NOT NULL        THEN b.numeroMesesEfecRebaja        ELSE a.mesesEfecRebaja                      END),
                a.montoPrimPensDefRTUF              = (CASE WHEN b.montoPrimPensDefRTUF IS NOT NULL         THEN b.montoPrimPensDefRTUF         ELSE a.montoPrimPensDefRTUF                 END),
                a.codigoRegionSolicitaPension       = (CASE WHEN b.codigoRegionTramiteSol IS NOT NULL       THEN b.codigoRegionTramiteSol       ELSE a.codigoRegionSolicitaPension          END),
                a.idDimRegion                       = (CASE WHEN b.codigoRegionTramiteSol IS NOT NULL       THEN 0                              ELSE a.idDimRegion                          END)
            FROM #UniversoRegistroTMP a
                JOIN DDS.TramitePensionAprobadoDatoIncompleto b ON (a.rut = b.rut
                AND a.fecsol = b.fechaSolicitud
                AND a.tipoben = b.tipoBeneficio
                AND a.codigoModalidadPension = b.codigoModalidadPensionReemplazar)
            WHERE b.indRegistroInformar = cchSi
            AND b.indInfModalidadPensionRecuperada = cchNo
            AND b.indInfModalidadPensionReemplazar = cchSi
            AND b.tramitePension = cchCodigoVE;

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
        
            --19.1.3. Se obtiene la información de la tabla SLB_FICHAS_CALCULO_SALDO_MF
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
                SELECT u.numcue, 
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
                UNION
                SELECT u.numcue, 
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
                AND u.codigoTipoAnualidad = '01'
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
            WHERE a.tipoPension = 'VEJEZ'
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
            WHERE a.tipoPension = 'VEJEZ'
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
    
            --Se aplica información de la matriz 3.0, la cual nos indica que fecha se debe informar en
            --el modelo
            --Fecha Emisión Certificado Saldo
            UPDATE #UniversoRegistroTMP SET
                fechaEmisionCersal = NULL
            WHERE codigoTipoPension = '01'
            AND codigoModalidadPension IN ('08', '09')
            AND indicadorArt17 = 'N'
            AND indScomp = 'N';
        
            --No se informa cuando no es RP 23-05-2014 codigo (03,04,05,06)
            UPDATE #UniversoRegistroTMP SET     
                fechaEmisionPrimeraFichaCalculoRP = NULL
            WHERE codigoModalidadPension NOT IN ('03','04','05','06','08', '09');
    
            --Inicio Jira79
            SELECT rut,
                fechaEmisionPrimeraFichaCalculoRP,
                DMGestion.obtenerDiaHabil(CONVERT(DATE, DATEADD(DAY, 1, fechaEmisionPrimeraFichaCalculoRP))) fechaFichaRPCorregida   
            INTO #correcionFechaFicha-- Cambio en Fecha de emision de Ficha de Calculo.
            FROM #UniversoRegistroTMP
            WHERE fechaEmisionPrimeraFichaCalculoRP = fechaSolicitudPensionVejez;
    
            UPDATE #UniversoRegistroTMP SET 
                fechaEmisionPrimeraFichaCalculoRP = b.fechaFichaRPCorregida
            FROM #UniversoRegistroTMP a
                INNER JOIN #correcionFechaFicha b ON (a.rut = b.rut 
                AND a.fechaEmisionPrimeraFichaCalculoRP = b.fechaEmisionPrimeraFichaCalculoRP);
            --Fin Jira79
    
            --Fecha Selección Modalidad Pensión
            UPDATE #UniversoRegistroTMP SET
                fechaSelModPen = NULL
            WHERE codigoTipoPension = '01'
            AND codigoModalidadPension IN ('08', '09')
            AND indicadorArt17 = 'N'
            AND indScomp = 'N';
    
            --Primer pago definitivo en UF
            UPDATE #UniversoRegistroTMP SET
                fechaPrimerPagoPenDef = NULL
            WHERE codigoModalidadPension IN ('01', '02', '07');
            --FIN JIRA
    
            --Inicio JIRA 87
            --Promedio de Rentas UF
            UPDATE #UniversoRegistroTMP SET
                promedioRentasUF = 0.0
            WHERE numRemunEfectivas = 0;
    
            --Número remuneraciones efectivas
            UPDATE #UniversoRegistroTMP SET
                numRemunEfectivas = 0
            WHERE promedioRentasUF = 0.0;
    
            --Fin JIRA 87
    
            --Tratamiento fecha emisión certificado de saldo y fecha ficha de cálculo
            --para casos de vejez por edad en donde la solicitud de pensión es anterior a 
            --la fecha de cumplimiento de la edad legal
            UPDATE #UniversoRegistroTMP SET 
                fechaEmisionCersal = fechaSolicitudPensionVejez
            FROM #UniversoRegistroTMP 
            WHERE codigoTipoPension ='01'
            AND fechaEmisionCersal IS NOT NULL
            AND fechaEmisionCersal < fechaSolicitudPensionVejez;
             
            UPDATE #UniversoRegistroTMP SET 
                fechaEmisionPrimeraFichaCalculoRP = fechaSolicitudPensionVejez
            FROM #UniversoRegistroTMP 
            WHERE codigoTipoPension ='01'
            AND fechaEmisionPrimeraFichaCalculoRP IS NOT NULL
            AND fechaEmisionPrimeraFichaCalculoRP < fechaSolicitudPensionVejez;
    
            --Casos cuando la ficha de cálculo es posterior a la fecha del primer pago de pensión definitiva
            UPDATE #UniversoRegistroTMP SET 
                fechaEmisionPrimeraFichaCalculoRP = fechaPrimerPagoPenDef
            WHERE fechaEmisionPrimeraFichaCalculoRP > fechaPrimerPagoPenDef
            AND fechaPrimerPagoPenDef IS NOT NULL;
    
            SELECT DISTINCT fechaEmisionCersal 
            INTO #FechasSelecModDis
            FROM #UniversoRegistroTMP 
            WHERE codigoTipoPension ='01'
            AND fechaSelModPen IS NOT NULL
            AND fechaSelModPen < fechaSolicitudPensionVejez;
    
            SELECT fechaEmisionCersal,
                   DMGestion.obtenerDiaHabil(DATEADD(DAY, 1, fechaEmisionCersal)) fechaHabil1Dia,
                   DMGestion.obtenerDiaHabil(DATEADD(DAY, 1, fechaHabil1Dia)) fechaHabil2Dia,
                   DMGestion.obtenerDiaHabil(DATEADD(DAY, 1, fechaHabil2Dia)) fechaHabil3Dia
            INTO #FechasSelecModHabil
            FROM #FechasSelecModDis;     
    
            UPDATE #UniversoRegistroTMP SET 
                a.fechaSelModPen = b.fechaHabil3Dia
            FROM #UniversoRegistroTMP a
                INNER JOIN #FechasSelecModHabil b ON (a.fechaEmisionCersal = b.fechaEmisionCersal)
            WHERE codigoTipoPension ='01'
            AND fechaSelModPen IS NOT NULL
            AND fechaSelModPen < fechaSolicitudPensionVejez;
    
            --Indicador SCOMP
            UPDATE #UniversoRegistroTMP SET
               indScomp = 'N'
            WHERE fechaEmisionCersal IS NULL;
           
           
           /********** PAFE ***********************/

            --INI Jira - INFESP-93
            UPDATE #UniversoRegistroTMP SET
                a.montoPafeUF           = ISNULL(b.mnto_pafe, cnuMontoPAFECero),
                a.signoMontoPafe        = (CASE
                                                WHEN ISNULL(b.vlor_signo, cchSignoMas) = cchSignoMas THEN 
                                                    ISNULL(b.vlor_signo, cchSignoMas)
                                                ELSE 
                                                    cchSignoMas
                                           END),
                a.indMontoPafeTablaHist = cchS,
                indPafe = cchIndPafeSi
            FROM #UniversoRegistroTMP a
                JOIN DDS.TN_PAFEACTUALIZADA b ON (a.rut = b.nmro_rutafi);
        
            
            
        /********** PAFE DESDE PLANILLA HISTORICA ***********************/          
            
            SELECT rutAfiliado,
            MAX(periodoInformado) periodoInformado
            INTO #PlanillaPAFETMP1
            FROM DDS.PlanillaPAFE
            WHERE tipoAfiliado IN (0,1, 2)
            --AND montoPafeUF > 0.0
            GROUP BY rutAfiliado; 
        
       
            
        
            UPDATE #UniversoRegistroTMP SET
                a.montoPafeUF    = CASE WHEN b.montoPafeUF = NULL THEN cnuMontoPAFECero
                                       WHEN b.signoMontoPafe = '-' THEN cnuMontoPAFECero
                                       ELSE b.montoPafeUF END ,
                a.signoMontoPafe = (CASE
                                        WHEN b.signoMontoPafe = '+' THEN b.signoMontoPafe
                                        WHEN b.signoMontoPafe = '-' THEN 'X'
                                        ELSE '+'
                                    END),
               indPafe = cchIndPafeSi
            FROM #UniversoRegistroTMP a
                INNER JOIN #PlanillaPAFETMP1 c ON (a.rut = c.rutAfiliado)
                INNER JOIN DDS.PlanillaPAFE b ON (a.rut = b.rutAfiliado AND b.periodoInformado = c.periodoInformado)
            WHERE b.tipoAfiliado IN (0, 1, 2)
            AND a.indMontoPafeTablaHist = cchN; 
               
           /* SELECT rutAfiliado,
                MAX(periodoInformado) periodoInformado
            INTO #PlanillaPAFETMP2
            FROM DDS.PlanillaPAFE
            WHERE tipoAfiliado IN (3, 4, 5, 6)
            AND montoPafeUF > cnuMontoPAFECero
            GROUP BY rutAfiliado; 
            
            --Gchavez CGI 08-05-2014 (+)
            --Actualizar Monto PAFE y Signo PAFE
            UPDATE #UniversoRegistroTMP SET
                a.montoPafeUF    = CASE WHEN b.montoPafeUF = NULL THEN cnuMontoPAFECero
                                       WHEN b.signoMontoPafe = '-' THEN cnuMontoPAFECero
                                       ELSE b.montoPafeUF END ,
                a.signoMontoPafe = (CASE
                                        WHEN b.signoMontoPafe = cchSignoMas THEN b.signoMontoPafe
                                        WHEN b.signoMontoPafe = '-' THEN 'X'
                                        ELSE cchSignoMas
                                    END),
             indPafe = cchIndPafeSi
            FROM #UniversoRegistroTMP a
                INNER JOIN #PlanillaPAFETMP2 c ON (a.rut = c.rutAfiliado)
                INNER JOIN DDS.PlanillaPAFE b ON (a.rut = b.rutAfiliado AND b.periodoInformado = c.periodoInformado)
            WHERE b.tipoAfiliado IN (3, 4, 5, 6)
            AND b.montoPafeUF > cnuMontoPAFECero
            AND a.indMontoPafeTablaHist = cchN;  */       
        
    
            --INICIO - IESP-235
            --Campo: Monto y Signo PAFE
            --Si se modifico el monto PAFE, se debe de obtener desde la planilla MODPAFE
            SELECT rutBenef,
                MAX(periodoInformado) periodoInformado
            INTO #PlanillaMODPAFETMP
            FROM DDS.PlanillaMODPAFE
            WHERE tipoAfiliado IN (ctiCero, ctiUno, ctiDos)
            AND montoPafeUF > cnuMontoPAFECero
            GROUP BY rutBenef;
    
            UPDATE #UniversoRegistroTMP SET
                a.montoPafeUF = CASE WHEN b.montoPafeUF = NULL THEN cnuMontoPAFECero
                                       WHEN b.signoMontoPafe = '-' THEN cnuMontoPAFECero
                                       ELSE b.montoPafeUF END ,
                a.signoMontoPafe = (CASE
                                        WHEN b.signoMontoPafe = cchSignoMas THEN b.signoMontoPafe
                                        WHEN b.signoMontoPafe = '-' THEN 'X'
                                        ELSE cchSignoMas
                                    END),
                indPafe = cchIndPafeSi
            FROM #UniversoRegistroTMP a
                JOIN #PlanillaMODPAFETMP c ON (a.rut = c.rutBenef)
                JOIN DDS.PlanillaMODPAFE b ON (c.rutBenef = b.rutBenef
                AND c.periodoInformado = b.periodoInformado)
            WHERE b.tipoAfiliado IN (ctiCero, ctiUno, ctiDos)
            AND b.montoPafeUF > cnuMontoPAFECero
            AND a.indMontoPafeTablaHist = cchN;
        
             --ACTUALIZA SIGNO PARA LAS PAFES HISTORICAS NEGATIVAS
            UPDATE  #UniversoRegistroTMP 
            SET signoMontoPafe = cchSignoMas
            WHERE signoMontoPafe = 'X';
           
            --TERMINO - IESP-235

            --INICIO - INFESP-273
            --1. Trabajo Pesado 
            --   No informa PAFE para aquellos pensionados con menos de 65 años, a excepción que sean pensionados por trabajo pesado.
            UPDATE #UniversoRegistroTMP SET
                montoPafeUF     = cnuMontoPAFECero,
                signoMontoPafe  = cchBlanco,
                indPafe = cchIndPafeNo
            WHERE indicadorArt68bis = cchN
            AND SEXO = cchSexoMasculino
            AND edadMesInforme < ctiEdadLegalPensionarseMasculino;
           
            UPDATE #UniversoRegistroTMP SET
                montoPafeUF     = cnuMontoPAFECero,
                signoMontoPafe  = cchBlanco,
                indPafe = cchIndPafeNo
            WHERE indicadorArt68bis = cchN
            and SEXO = cchSexoFemenino
            AND edadMesInforme < ctiEdadLegalPensionarseFemenino;

            --2. Renta Vitalicias 
            --   No informar PAFE para aquellos pensionados por vejez que seleccionaron modalidad de renta vitalicia antes de 01-07-2008.
            UPDATE #UniversoRegistroTMP SET
                montoPafeUF     = cnuMontoPAFECero,
                signoMontoPafe  = cchBlanco,
                indPafe = cchIndPafeNo
            WHERE fecsol < cdt20080701
            AND codigoModalidadPension IN (cchCodigoModalidadPension01,
                                           cchCodigoModalidadPension02,
                                           cchCodigoModalidadPension03,
                                           cchCodigoModalidadPension04,
                                           cchCodigoModalidadPension05,
                                           cchCodigoModalidadPension06,
                                           cchCodigoModalidadPension07);
                                       
                                       
            --PAGOS DE RV ANTERIORES AL '20080701'
            /*SELECT DISTINCT B.RUT 
                INTO #RV
            FROM DDS.TB_MAE_MOVIMIENTO A
                INNER JOIN #UniversoRegistroTMP b ON a.ID_MAE_PERSONA = b.idPersonaOrigen
            WHERE A.FEC_MOVIMIENTO < '20080701'
            AND A.ID_TIP_MOVIMIENTO IN (87, 515, 533, 1546, 1572);*/
                                       
            SELECT dp.rut,fechaSolicitud, fechaMovimiento, dtp.codigo
                INTO #rentasVitalicias
            FROM DMGestion.FctRentasVitaliciasContratadas frv
                INNER JOIN DMGestion.DimPersona dp ON dp.id = frv.idPersona
                INNER JOIN DMGestion.DimPeriodoInformado dpi ON dpi.id = frv.idPeriodoInformado
                INNER JOIN DMGestion.DimTipoPension dtp ON dtp.id = frv.idTipoPension AND dtp.codigo IN ('01','02')
                INNER JOIN #UniversoRegistroTMP b ON dp.rut = b.rut
            WHERE dpi.fecha = '20240701'
            AND fechaSolicitud < '20080701';                           

        
             UPDATE #UniversoRegistroTMP SET
                a.montoPafeUF    = 0 ,
                a.signoMontoPafe = ' ',
             indPafe = 'No'
            FROM #UniversoRegistroTMP a
                INNER JOIN #rentasVitalicias c ON (a.rut = c.rut);
        
            --TEMINO - INFESP-273
                                       
            --RENTA VITALICIA
                                          
            SELECT ss.NUMCUE,ss.FECSOL  
                INTO #cambioModalidad
            FROM DDS.STP_SOLICPEN ss
                INNER JOIN #UniversoRegistroTMP tmp ON ss.NUMCUE = tmp.numcue
            WHERE ss.TIPOBEN = 12    
                AND ss.FECSOL < cdt20080701
                AND ss.CODESTSOL = 2
                AND ss.FECSOL < tmp.fecsol;
                              
            SELECT numrut  
                INTO #CMconRV
            FROM #cambioModalidad cm
                INNER JOIN DDS.SLB_MONTOBEN sm ON sm.numcue = cm.numcue AND cm.FECSOL = sm.fecsol
            WHERE sm.modalidad IN (1,2,3,4,5,6);
            
        
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
       SET codigoEstadoSolicitud = (SELECT codigo FROM DMGestion.DimEstadoSolicitud WHERE CODIGO = cinAproNoPerfeccionado AND fechaVigencia >= cdtMaximaFechaVigencia)--APROBADA SIN FECHA DE PAGO EN EL MES DEL INFORME(NO PERFECCIONADA)
       ,idDimEstadoSolicitud = (SELECT id FROM DMGestion.DimEstadoSolicitud WHERE CODIGO = cinAproNoPerfeccionado AND fechaVigencia >= cdtMaximaFechaVigencia) --APROBADA SIN FECHA DE PAGO EN EL MES DEL INFORME(NO PERFECCIONADA)
       WHERE fechaPrimerPagoPenDef IS NULL
       AND rut IN (SELECT rut FROM #estadoNoPerfeccionado);
          
 
            -------------------------------------------------------------------------------------------
            -- Fin Inicio Indicador PAFE
            ------------------------------------------------------------------------------------------- 
    
            DROP TABLE dchavez.UniversoSaldoPensionTMP;
            DROP TABLE dchavez.UniversoMovimientosRVTMP;
 /*   
            -----------------------------------------------------------
            --20. Manejo de Errores para la FctPensionadoInvalidezVejez
            -----------------------------------------------------------
            --20.1. Marcar los errores
            CREATE TABLE #UniversoErrores(
                idError             BIGINT          NULL,
                numeroFila          BIGINT          NOT NULL,
                nombreColumna       VARCHAR(50)     NOT NULL,
                tipoError           CHAR(1)         NOT NULL,
                idCodigoError       BIGINT          NOT NULL,
                descripcionError    VARCHAR(500)    NOT NULL
             );
    
            --20.2. Error de estructura, Remuneración imponible asociada a la última cotización anterior a la 
            --      fecha de la solicitud de pensión mayor a 99.99 UF
            INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
            SELECT ur.numeroFila,
                'remImpUltCotAnFecSolPenUF' nombreColumna,
                'E' tipoError,
                 ce.id idCodigoError, 
                'Remuneración imponible asociada a la última cotización anterior a la fecha de la solicitud de pensión ' ||
                'mayor a 99.99 UF. Origen de extracción (TB_MAE_MOVIMIENTO), con ID_MAE_PERSONA = ' || ur.idPersonaOrigen descripcionError
            FROM #UniversoRegistroTMP ur
                INNER JOIN DMGestion.CodigoError ce ON ce.codigo = '1086'
            WHERE ur.remImpUltCotAnFecSolPenUF > 99.99;
    
            --20.4. Error de inconsistencia persona no se encuentra en la dimpersona
            INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
            SELECT ur.numeroFila, 
                'idPersona' nombreColumna,
                'I' tipoError,
                ce.id idCodigoError,
                'La cuenta antigua (numcue) = ' || ur.numcue ||
                ', no se encuentra en la tabla TB_PERSONA_PRODUCTO o TB_MAE_PERSONA' descripcionError
            FROM #UniversoRegistroTMP ur
                INNER JOIN DMGestion.CodigoError ce ON ce.codigo = '1007'
            WHERE ur.idDimPersona = 0;
    
            --20.5. Error de inconsistencia no se puede clasificar la modalidad de pensión
            INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
            SELECT ur.numeroFila, 
                'idModalidadPension' nombreColumna,
                'I' tipoError,
                ce.id idCodigoError,
                'La cuenta antigua (numcue) = ' || ur.numcue ||
                ', no se pudo clasificar la modalidad de pensión' descripcionError
            FROM #UniversoRegistroTMP ur
                INNER JOIN DMGestion.CodigoError ce ON ce.codigo = '1087'
            WHERE ur.idDimModalidadPension = 0;
    
            --20.5. Error de inconsistencia fecha de devengamiento con valor nulo
            INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
            SELECT ur.numeroFila, 
                'fechaDevengamiento' nombreColumna,
                'I' tipoError,
                ce.id idCodigoError,
                'La fecha de nacimiento o sexo con valor nulo. Origen de extracción (TB_MAE_PERSONA), ' ||
                'con ID_MAE_PERSONA = ' || ur.idPersonaOrigen 
            FROM #UniversoRegistroTMP ur
                INNER JOIN DMGestion.CodigoError ce ON ce.codigo = '1088'
            WHERE ur.fechaSolicitudPensionVejez IS NULL
            AND ur.idDimPersona > 0;
    
            --20.6. Error de inconsistencia no se puede clasificar el tipo de anualidad
            INSERT INTO #UniversoErrores(numeroFila, nombreColumna, tipoError, idCodigoError, descripcionError)
            SELECT ur.numeroFila, 
                'idTipoAnualidad' nombreColumna,
                'I' tipoError,
                ce.id idCodigoError,
                'La cuenta antigua (numcue) = ' || ur.numcue ||
                ', no se pudo clasificar el tipo de anualidad' descripcionError
            FROM #UniversoRegistroTMP ur
                INNER JOIN DMGestion.CodigoError ce ON ce.codigo = '1089'
            WHERE ur.idDimTipoAnualidad = 0;
    
            --20.7. se registra la cabecera del error
            INSERT INTO DMGestion.ErrorCarga(idPeriodoInformado, procesoCarga, fechaCarga, nombreTabla, numeroRegistro)
            SELECT DISTINCT linIdPeriodoInformar, cstNombreProcedimiento, getDate(), cstNombreTablaFct, numeroFila
            FROM #UniversoErrores;
    
            --20.8. Se agrega el idError al universo de errores
            UPDATE #UniversoErrores ue SET
                ue.idError = ec.id
            FROM DMGestion.ErrorCarga ec 
            WHERE ue.numeroFila = ec.numeroRegistro
            AND ec.procesoCarga = cstNombreProcedimiento
            AND ec.nombreTabla = cstNombreTablaFct
            AND ec.idPeriodoInformado = linIdPeriodoInformar;
        
            --20.9. Se registra el detalle del error
            INSERT INTO DMGestion.DetalleErrorCarga(idError, nombreColumna, tipoError, idCodigoError, descripcion)
            SELECT ue.idError, ue.nombreColumna, ue.tipoError, ue.idCodigoError, ue.descripcionError 
            FROM #UniversoErrores ue;
        
            --20.10. Actualiza el idError en el universo a registrar
            UPDATE #UniversoRegistroTMP ur SET
                ur.idError = ue.idError
            FROM #UniversoErrores ue
            WHERE ue.numeroFila = ur.numeroFila;
 */   
            --20.11. Actualiza la Remuneración imponible asociada a la última cotización anterior a la fecha 
            --       de la solicitud de pensión, por ser mayor a 99.99 UF el cual queda marcado como error
            UPDATE #UniversoRegistroTMP u SET 
                u.remImpUltCotAnFecSolPenUF = 99.99
            WHERE u.remImpUltCotAnFecSolPenUF > 99.99;
    
            ---------------------------------------------------
            --21. Se registra en la FctPensionadoInvalidezVejez
            ---------------------------------------------------         
            INSERT INTO dchavez.FctPensionadoInvalidezVejez(idPeriodoInformado, 
                idTipoProceso, 
                idPersona, 
                idTipoPension,
                idTipoAnualidad, 
                idModalidadPension, 
                idTipoRecalculo, 
                idCausalRecalculo, 
                idEstadoSolicitud,
                idRegionTramiteSol,
                idGradoInvalidezPriDicEjec,
                idGradoInvalidezUniDicEjec,
                idGradoInvalidezSegDicEjec,
                idTipoCobertura,
                indicadorArticulo17Trans, 
                indicadorArticulo69, 
                indicadorArticulo68bis, 
                fecEmiCertSaldoModPension, 
                fecEmis1FichaCalculoRP, 
                promedioRentasRemuneraUF, 
                numRemEfectPromRenRemu, 
                remImpUltCotAnFecSolPenUF, 
                fechaSeleccionModPension,  
                fecPrimerPagoPensionDef, 
                fechaSolicitud, 
                fechaDevengamiento, 
                perUltCotDevAcrAntFecSol,
                fecCalculo,
                fechaEstadoSolicitud, 
                codigoModalidadAFP, 
                pensionMinimaUF, 
                montoPrimPensDefUF,
                montoPrimPensDefRTUF,
                numeroMesesEfecRebaja,
                indicadorSCOMP,
                factorAjuste,              -- nuevo campo
                factorActuorialmenteJusto, -- nuevo campo
                fecPensionAntiguoSistema,  -- nuevo campo
                pensionBasicaSolidariaUF,
                saldoRetenidoUF,
                ingresoBaseUF,
                pensionReferenciaUF,
                montoTotalAporteAdicUF,
                montoPensionTransitoriaUF,
                numeroCuenta,
                indResolReposicionEjec,
                montoPafeUF,       -- Campo Nuevo 08-05-2014
                signoMontoPafe,    -- Campo Nuevo 08-05-2014
                indPafe,
                indUsoSaldoRetenido,
                idComisionMedica,
                indExpasis,
                indProcesoReevaluacion,
                numeroDictamen,
                anioDictamen,
                numeroFila, 
                idError)
            SELECT linIdPeriodoInformar, 
                ltiIdDimTipoProceso, 
                idDimPersona, 
                idDimTipoPension, 
                idDimTipoAnualidad, 
                idDimModalidadPension, 
                idDimTipoRecalculo, 
                idDimCausalRecalculo, 
                idDimEstadoSolicitud, 
                idDimRegion,
                idGradoInvalidezPriDicEjec,
                idGradoInvalidezUniDicEjec,
                idGradoInvalidezSegDicEjec,
                idTipoCobertura,
                indicadorArt17, 
                indicadorArt69, 
                indicadorArt68Bis, 
                fechaEmisionCersal, 
                fechaEmisionPrimeraFichaCalculoRP, 
                promedioRentasUF, 
                numRemunEfectivas, 
                remImpUltCotAnFecSolPenUF, 
                fechaSelModPen, 
                fechaPrimerPagoPenDef, 
                fecsol, 
                fechaSolicitudPensionVejez, 
                fecUltCotAntFecSolPension, 
                fechaCalculo, 
                fechaEstadoSolicitud, 
                codigoModalidadAFP, 
                pensionMinimaUF, 
                montoPrimPensDefUF,
                montoPrimPensDefRTUF,
                mesesEfecRebaja,
                indScomp,
                factorAjuste,
                factorActuorialmenteJusto,
                fec_devenga_sisant,
                pensionBasicaSolidariaUF,
                saldoRetenidoUF,
                ingresoBaseUF,
                pensionReferenciaUF,
                montoTotalAporteAdicionalUF,
                montoPensionTransitoriaUF,
                numcue,
                indResolReposicionEjec,
                montoPafeUF,        -- Campo Nuevo 08-05-2014
                signoMontoPafe,     -- Campo Nuevo 08-05-2014
                indPafe,            -- Campo Nuevo 27-12-2016 Oficio 22.178
                indUsoSaldoRetenido,
                idComisionMedica,
                indExpasis,
                indProcesoReevaluacion,
                numeroDictamen,
                anioDictamen,
                numeroFila, 
                idError
            FROM #UniversoRegistroTMP;

            ------------------------------------------------
            --Datos de Auditoria FctPensionadoInvalidezVejez
            ------------------------------------------------
            --22. Se registra datos de auditoria
            SELECT COUNT(*) 
            INTO lbiCantidadRegistrosInformados
            FROM #UniversoRegistroTMP;
             
            COMMIT;
            SAVEPOINT;

            SET cantRegRegistrados  = lbiCantidadRegistrosInformados;
            SET codigoError         = cstCodigoErrorCero;
        END IF;
    END IF;
-------------------------------------------------------------------------------------------     
--Manejo de Excepciones      
-------------------------------------------------------------------------------------------
/*EXCEPTION
    WHEN OTHERS THEN
        SET lstCodigoError = SQLSTATE;
        SET codigoError = lstCodigoError;
        ROLLBACK;
        CALL ControlProcesos.registrarErrorProceso(cstOwner, cstNombreProcedimiento, lstCodigoError);*/
END