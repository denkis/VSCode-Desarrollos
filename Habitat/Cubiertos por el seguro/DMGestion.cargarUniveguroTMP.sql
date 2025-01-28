ALTER  PROCEDURE DMGestion.cargarUniversoCubiertoSeguroTMP(OUT codigoError VARCHAR(10))
BEGIN

-------------------------------------------------------------------------------------------
    --Declaración de Variables
    -------------------------------------------------------------------------------------------
    --variable para capturar el codigo de error
    DECLARE lstCodigoError                          VARCHAR(10);    --variable local de tipo varchar
    --variables
    DECLARE ldtMaximaFechaVigencia                  DATE;           --variable local de tipo date
    DECLARE linIdPeriodoInformar                    INTEGER;        --variable local de tipo tinyint
    DECLARE ltiIdDimTipoRolBeneficiario             TINYINT;        --variable local de tipo tinyint
    DECLARE ldtFechaPeriodoInformado                DATE;           --variable local de tipo date
    DECLARE ldtFechaPeriodoInfodoAnt                DATE;           --variable local de tipo date
    DECLARE ldtFechaPeriodoCotizadoAnt              DATE;           --variable local de tipo date
    DECLARE ldtUltimaFechaMesInformarAnt            DATE;           --variable local de tipo date
    DECLARE ldtUltimoDiaHabilMes                    DATE;           --variable local de tipo date
    DECLARE ldtMinimaFechaIncorpOAfi                DATE;           --variable local de tipo date
    DECLARE ldtUltimaFechaMesInformar               DATE;           --variable local de tipo date
    DECLARE ldtPeriodoCotizacionUnAnoAtras          DATE;           --variable local de tipo date
    DECLARE ldtPeriodoCotizacion                    DATE;           --variable local de tipo date
    DECLARE ltiEdadLegalPensionarseMasculino        TINYINT;        --variable local de tipo tinyint
    DECLARE ltiEdadLegalPensionarseFemenino         TINYINT;        --variable local de tipo tinyint
    DECLARE linComunaPrincipal                      INTEGER;        --variable local de tipo integer
    DECLARE linSucursal                             INTEGER;        --variable local de tipo integer
    --Variables auditoria
    DECLARE ldtFechaInicioCarga                     DATETIME;       --variable local de tipo datetime
    DECLARE lbiCantidadRegistrosInformados          BIGINT;         --variable local de tipo bigint
    --Constantes
    DECLARE cdtFechaTopeCubiertoSeguro              DATE;           --constante de tipo date
    DECLARE cstNombreProcedimiento                  VARCHAR(150);   --constante de tipo varchar
    DECLARE cstNombreTabla                          VARCHAR(150);   --constante de tipo varchar
    DECLARE ctiProductoCCICO                        TINYINT;        --variable local de tipo tinyint
    DECLARE ctiProductoCCIAV                        TINYINT;        --variable local de tipo tinyint
    DECLARE ctiProductoCCIDC                        TINYINT;        --variable local de tipo tinyint
    DECLARE ctiProductoCCICV                        TINYINT;        --variable local de tipo tinyint
    DECLARE ctiTraCtaCteCCICO                       INTEGER;        --variable local de tipo integer
    DECLARE ctiTraCtaCteCCIAV                       INTEGER;        --variable local de tipo integer   
    DECLARE cstCodigoErrorCero                      VARCHAR(10);    --constante de tipo varchar
    DECLARE cstCodControlVAL                        CHAR(3);        --constante de tipo char
    DECLARE cstSi                                   CHAR(1);        --constante de tipo char
    DECLARE cstNo                                   CHAR(1);        --constante de tipo char
    DECLARE cinEstadoRol1                           INTEGER;        --variable local de tipo integer
    DECLARE cinEstadoRol2                           INTEGER;        --variable local de tipo integer
    DECLARE cinTipoRol1                             INTEGER;        --variable local de tipo integer
    DECLARE cinMovPagoSeguro1                       INTEGER;        --variable local de tipo integer
    DECLARE cinMovPagoSeguro2                       INTEGER;        --variable local de tipo integer
    DECLARE cinSeis                                 INTEGER;        --constante de tipo char
    DECLARE cstFemenino                             CHAR(1);        --constante de tipo char
    DECLARE cstMasculino                            CHAR(1);        --constante de tipo char
    DECLARE cinEdadLegalM                           INTEGER;        --variable local de tipo integer
    DECLARE cinDoce                                 INTEGER;        --variable local de tipo integer
    DECLARE cstCodControlPRV                        CHAR(3);        --constante de tipo char
    DECLARE cstCodControlAVP                        CHAR(3);        --constante de tipo char
    DECLARE cstCodControlAVV                        CHAR(3);        --constante de tipo char
    DECLARE cstCodControlAPP                        CHAR(3);        --constante de tipo char
    DECLARE cstCodControlAPV                        CHAR(3);        --constante de tipo char
    DECLARE cstCodControlACP                        CHAR(3);        --constante de tipo char
    DECLARE cstCodControlACV                        CHAR(3);        --constante de tipo char
    DECLARE cstCodControlCAP                        CHAR(3);        --constante de tipo char
    DECLARE cstCodControlCAV                        CHAR(3);        --constante de tipo char
    DECLARE cstCodControlTAS                        CHAR(3);        --constante de tipo char
    DECLARE cstCodControlVRF                        CHAR(3);        --constante de tipo char
    DECLARE cstCodControlOCE                        CHAR(3);        --constante de tipo char
        

   

    
    
   
    -------------------------------------------------------------------------------------------
    --Seteo Variable auditoria
    -------------------------------------------------------------------------------------------
    --se obtiene la fecha y hora de carga
    SET ldtFechaInicioCarga = getDate();

    -------------------------------------------------------------------------------------------
    --Seteo de Constantes
    -------------------------------------------------------------------------------------------    
    SET cstNombreProcedimiento = 'cargarUniversoCubiertoSeguroTMP';
    SET cstNombreTabla = 'UniversoCubiertoSeguroTMP';
    SET cstCodigoErrorCero = '0';
    SET ctiProductoCCICO = 1;
    SET ctiProductoCCIAV = 6;
    SET ctiProductoCCIDC = 5;
    SET ctiProductoCCICV = 4;
    SET cstCodControlVAL = 'VAL';
    SET cstCodControlPRV = 'PRV';
    SET cstCodControlAVP = 'AVP';
    SET cstCodControlAVV = 'AVV';
    --SET cstCodControlAPP = 'APP';
    --SET cstCodControlAPV = 'APV';
    --SET cstCodControlACP = 'ACP';
    --SET cstCodControlACV = 'ACV';
    --SET cstCodControlCAP = 'CAP';
    --SET cstCodControlCAV = 'CAV';
    --SET cstCodControlTAS = 'TAS';
    --SET cstCodControlVRF = 'VRF';
    --SET cstCodControlOCE = 'OCE';
    SET cstSi = 'S';
    SET cstNo = 'N';
    SET cinEstadoRol1 = 1;
    SET cinEstadoRol2 = 2;
    SET cinTipoRol1 = 1;
    SET ctiProductoCCICO = 1;
    SET ctiProductoCCIAV = 6;
    SET cinMovPagoSeguro1 = 11073;
    SET cinMovPagoSeguro2 = 61003;
    SET cinSeis = 6;
    SET cstFemenino = 'F';
    SET cstMasculino = 'M';
    SET cinEdadLegalM = 60;
    SET cinDoce = 12;



    --se obtiene el parametro EDAD_LEGAL_PENSIONARSE_MASCULINO de la tabla Parametros
    SELECT CONVERT(TINYINT, DMGestion.obtenerParametro('EDAD_LEGAL_PENSIONARSE_MASCULINO')) 
    INTO ltiEdadLegalPensionarseMasculino 
    FROM DUMMY;

    --se obtiene el parametro EDAD_LEGAL_PENSIONARSE_FEMENINO de la tabla Parametros
    SELECT CONVERT(TINYINT, DMGestion.obtenerParametro('EDAD_LEGAL_PENSIONARSE_FEMENINO')) 
    INTO ltiEdadLegalPensionarseFemenino 
    FROM DUMMY;

    --se obtiene el parametro FECHA_TOPE_CUBIERTO_SEGURO de la tabla Paramentros
    SELECT CONVERT(DATE, DMGestion.obtenerParametro('FECHA_TOPE_CUBIERTO_SEGURO'), 103)
    INTO cdtFechaTopeCubiertoSeguro
    FROM DUMMY;
    
     --se obtiene el parametro FECHA_TOPE_CUBIERTO_SEGURO de la tabla Paramentros
    SELECT CONVERT(DATE, DMGestion.obtenerParametro('FECHA_TOPE_CUBIERTO_SEGURO'), 103)
    INTO cdtFechaTopeCubiertoSeguro
    FROM DUMMY;

    --se obtiene el identificador del periodo actual a informar
    SELECT DMGestion.obtenerIdDimPeriodoInformar() 
    INTO linIdPeriodoInformar
    FROM DUMMY;

    --se obtiene la fecha del periodo a informar
    SELECT DMGestion.obtenerFechaPeriodoInformar() 
    INTO ldtFechaPeriodoInformado 
    FROM DUMMY;

    --se obtiene la ultimo día del periodo a informar
    SELECT DMGestion.obtenerUltimaFechaMes(ldtFechaPeriodoInformado) 
    INTO ldtUltimaFechaMesInformar
    FROM DUMMY;

    --se obtiene el periodo de cotización un año atrás desde el periodo informado
    SELECT CONVERT(DATE, DATEADD(mm, -12, ldtFechaPeriodoInformado))
    INTO ldtPeriodoCotizacionUnAnoAtras
    FROM DUMMY;

    SET ldtFechaPeriodoInfodoAnt = DATEADD(mm,-1,ldtFechaPeriodoInformado);    
    
    SET ldtFechaPeriodoCotizadoAnt = DATEADD(mm,-1,ldtFechaPeriodoInfodoAnt);

    --se obtiene la ultimo día del periodo a informarAnterior
    SELECT DMGestion.obtenerUltimaFechaMes(ldtFechaPeriodoInfodoAnt) 
    INTO ldtUltimaFechaMesInformarAnt
    FROM DUMMY;
    
    

     --verifica si tabla se encuentra creada
    IF (EXISTS (SELECT 1 FROM SYSCATALOG WHERE tname = cstNombreTabla AND creator = 'DMGestion')) THEN
        DROP TABLE DMGestion.UniversoCubiertoSeguroTMP;
    END IF;


    CREATE TABLE DMGestion.UniversoCubiertoSeguroTMP 
        (id_mae_persona bigint NULL,
        rut integer NULL,
        sexo char(1)  NULL,
        edadActuarial bigint NULL,
        edadCubiertaSeguro bigint NULL,
        codigoTipoCobertura char(2) NULL,
        periodoCotizado date NULL,
        universoOrigen  varchar(200)NULL
        );
    
    CREATE TABLE #UniversoFinalTMP 
        (id_mae_persona bigint NULL,
        rut integer,
        sexo char(1)  NULL,
        edadActuarial bigint NULL,
        edadCubiertaSeguro bigint NULL,
        codigoTipoCobertura char(2) NULL,
        periodoCotizado date NULL,
        universoOrigen  varchar(200)NULL,
        prioridad integer null
        );
    

    /*TIPO DE COBERTURUA SIS*/
                --Universo Afiliados Activos
                SELECT up.id_mae_persona,
                    dp.rut,
                    dp.fechaNacimiento,
                    dp.sexo
                INTO #UniversoAfiliadosActivosTMP
                FROM DMGestion.UniversoAfiliadoClienteTMP up
                    INNER JOIN DMGestion.DimPersona dp ON (up.idDimPersona = dp.id) AND dp.fechaVigencia >= '21991231'
                WHERE up.cod_control IN (cstCodControlVAL, cstCodControlPRV, 
                                         cstCodControlAVP, cstCodControlAVV)
                AND up.esUniversoCuadro1 = 'S'
                AND up.id_tip_estado_rol = 1 --Afiliado
                AND up.codigoTipoRol = 1; --Persona
                
                /*UNIVERSO DE DECLARACIONES DE NO PAGO*/
                SELECT DISTINCT tdd.NUM_RUT rut,b.FEC_PERIODO_COTIZ periodoCotizado, ID_MAE_PERSONA
                INTO #DNP
                FROM DDS.TB_DET_DEUDA tdd 
                INNER JOIN (SELECT ID_DEUDA,FEC_PERIODO_COTIZ 
                            FROM DDS.TB_DEUDA td 
                            WHERE ID_ORIGEN_DEUDA = 1 
                            AND FEC_PERIODO_COTIZ >= DATEADD(MM,-24,ldtFechaPeriodoInformado)) b ON tdd.ID_DEUDA  = b.id_deuda
                INNER JOIN (SELECT ID_DET_DEUDA 
                            FROM DDS.TB_DET_DEUDA_CONCEPTO tddc 
                            WHERE ID_TIP_CONCEPTO = 164 )dc ON tdd.ID_DET_DEUDA = dc.ID_DET_DEUDA
                WHERE rut IN (SELECT DISTINCT RUT FROM #UniversoAfiliadosActivosTMP);

                
                --UNIVERSO DE MOVIMIENTOS DE PAGO DE SIS
                SELECT vc.id_mae_persona,
                    uaa.rut,
                    uaa.fechaNacimiento,
                    uaa.sexo,
                    vc.per_cot,
                    vc.fec_acreditacion,
                    vc.fec_movimiento,
                    vc.codigoTipoProducto,
                    vc.rut_pagador
                INTO #MovimientosPagoSeguroTMP
                FROM DDS.VectorCotizaciones vc
                    INNER JOIN #UniversoAfiliadosActivosTMP uaa ON (vc.id_mae_persona = uaa.id_mae_persona)
                WHERE vc.codigoTipoProducto IN (1,6) --productos CCICO y CCIAV
                AND vc.codTrafil02 IN (11020,11073,11105,11107,61003 ); --Movimientos Pago de Seguro

                
                /***** UNIVERSO DE MOVIMIENTOS DNP A CONSIDERAR ****/
                SELECT b.id_mae_persona,
                    dn.rut,
                    b.fechaNacimiento,
                    b.sexo,
                    max(dn.periodoCotizado)ultimoPerCot
                INTO  #UniversoDNP
                FROM #DNP dn
                    INNER JOIN #UniversoAfiliadosActivosTMP b ON dn.rut = b.rut
                GROUP BY b.id_mae_persona,
                        dn.rut,
                        fechaNacimiento,
                        sexo;
                
                
                --UNIVERSO 1: Cotizantes del Mes con Pago a Seguro- Afiliados Activos
                SELECT up.id_mae_persona,
                    up.rut,
                    up.fechaNacimiento,
                    up.sexo,
                    MAX(up.per_cot) ultimoPerCot
                INTO #Universo1TipoCoberturaTMP
                FROM #MovimientosPagoSeguroTMP up
                WHERE up.per_cot IN(ldtPeriodoCotizacion, ldtFechaPeriodoInformado)
                AND up.fec_acreditacion BETWEEN ldtFechaPeriodoInformado AND ldtUltimaFechaMesInformar
                AND up.fec_movimiento BETWEEN ldtFechaPeriodoInformado AND ldtUltimaFechaMesInformar
                AND codigoTipoProducto = 1
                AND up.rut_pagador <> up.rut
                GROUP BY up.id_mae_persona,
                    up.rut,
                    up.fechaNacimiento,
                    up.sexo;
                
         
                SELECT a.id_mae_persona, a.rut, a.fechaNacimiento, a.sexo, max(a.ultimoPerCot)ultimoPerCot 
                INTO #Universo1TipoCoberturaTMPDNP
                FROM 
                (SELECT a.id_mae_persona, a.rut, a.fechaNacimiento, a.sexo, a.ultimoPerCot
                FROM #Universo1TipoCoberturaTMP a
                LEFT OUTER JOIN #UniversoDNP b ON a.rut = b.rut 
                WHERE b.rut IS NULL
                UNION 
                SELECT a.id_mae_persona, a.rut, a.fechaNacimiento, a.sexo, a.ultimoPerCot
                FROM #Universo1TipoCoberturaTMP a
                INNER JOIN #UniversoDNP b ON a.rut = b.rut 
                WHERE b.ultimoPerCot > a.ultimoPerCot
                UNION 
                SELECT a.id_mae_persona, a.rut, a.fechaNacimiento, a.sexo, a.ultimoPerCot
                FROM #UniversoDNP a
                LEFT OUTER JOIN #Universo1TipoCoberturaTMP b ON a.rut = b.rut 
                WHERE b.rut IS NULL)a
                GROUP BY a.id_mae_persona, a.rut, a.fechaNacimiento, a.sexo;
                

                SELECT ultimoPerCot, 
                    DMGestion.obtenerUltimaFechaMes(ultimoPerCot) ultimaFechaMesPerCot
                INTO #UltimaFechaMesPerCotTMP
                FROM #Universo1TipoCoberturaTMPDNP
                GROUP BY ultimoPerCot;

                --UNIVERSO CUBIERTOS COMO COTIZANTE MES
                
                INSERT INTO #UniversoFinalTMP --DMGestion.UniversoCubiertoSeguroTMP
                (id_mae_persona,rut,sexo,edadActuarial,edadCubiertaSeguro,codigoTipoCobertura, periodoCotizado, universoOrigen, prioridad)
                SELECT DISTINCT u1.id_mae_persona,
                    u1.rut,
                    ISNULL(u1.sexo, '') sexo,
                    (CASE 
                        WHEN ((u1.fechaNacimiento IS NOT NULL) AND 
                              (u1.fechaNacimiento < ufmpc.ultimaFechaMesPerCot)) THEN
                            CONVERT(BIGINT, (DATEDIFF(mm, u1.fechaNacimiento, ufmpc.ultimaFechaMesPerCot)/12))
                        ELSE CONVERT(BIGINT, 0)
                     END) edadActuarial,
                    (CASE 
                        WHEN ((u1.fechaNacimiento IS NOT NULL) AND 
                              (u1.fechaNacimiento < cdtFechaTopeCubiertoSeguro)) THEN
                            CONVERT(BIGINT, (DATEDIFF(mm, u1.fechaNacimiento, cdtFechaTopeCubiertoSeguro)/12))
                        ELSE CONVERT(BIGINT, 0)
                     END) edadCubiertaSeguro,
                    CONVERT(CHAR(2), '01') codigoTipoCobertura
                    , u1.ultimoPerCot
                    , 'Cotizante Mes'
                    , 1
                --INTO DMGestion.UniversoCubiertoSeguroTMP --#UniversoTipoCoberturaTMP
                FROM #Universo1TipoCoberturaTMPDNP u1
                    INNER JOIN #UltimaFechaMesPerCotTMP ufmpc ON (u1.ultimoPerCot = ufmpc.ultimoPerCot);
                
                DROP TABLE #UltimaFechaMesPerCotTMP;
            
                --Se elimina del universo Afiliados Activo, los que tienen convertura del universo 1
                /*DELETE FROM #UniversoAfiliadosActivosTMP
                FROM #UniversoAfiliadosActivosTMP uaa,  #UniversoFinalTMP uc
                WHERE uaa.id_mae_persona = uc.id_mae_persona;*/

                --UNIVERSO 2: Cotizantes con Pago a Seguro un año atras del periodo informado - Afiliados Activos
            
                /* UNIVERSO DE DNP */
                SELECT DISTINCT rut, periodoCotizado, ID_MAE_PERSONA 
                    INTO #dnpTipo2
                FROM #DNP dnp
                WHERE periodoCotizado BETWEEN ldtPeriodoCotizacionUnAnoAtras AND ldtFechaPeriodoInformado
                AND dnp.rut NOT IN (SELECT rut FROM #UniversoFinalTMP WHERE universoOrigen ='Cotizante Mes' );          
            
                SELECT up.id_mae_persona,
                    up.rut,
                    MAX(up.per_cot) ultimoPerCot
                INTO #Universo2TipoCoberturaTMP
                FROM #MovimientosPagoSeguroTMP up
                    INNER JOIN #UniversoAfiliadosActivosTMP uaa ON (up.id_mae_persona = uaa.id_mae_persona)
                WHERE up.per_cot BETWEEN ldtPeriodoCotizacionUnAnoAtras AND ldtFechaPeriodoInformado
                AND up.codigoTipoProducto = 1
                AND up.rut_pagador <> up.rut
                AND up.rut NOT IN (SELECT rut FROM #UniversoFinalTMP WHERE universoOrigen ='Cotizante Mes' )
                GROUP BY up.id_mae_persona, up.rut;
            
                --INCLUSION DE DNP Y COTIZACION
                SELECT id_mae_persona, rut, max(ultimoPerCot)ultimoPerCot
                    INTO #Universo2TipoCoberturaTMPDNP
                FROM 
                (SELECT id_mae_persona, rut, ultimoPerCot
                FROM #Universo2TipoCoberturaTMP
                UNION 
                SELECT ID_MAE_PERSONA,rut, periodoCotizado AS ultimoPerCot 
                FROM #dnpTipo2)a
                GROUP BY id_mae_persona, rut;
                

               --Universo con mas de 6 periodo COTIZADOS
                SELECT u2tc.id_mae_persona,u2tc.RUT,b.per_cot
                INTO #Universo2_COT
                FROM #Universo2TipoCoberturaTMPDNP u2tc
                    INNER JOIN #MovimientosPagoSeguroTMP b ON (u2tc.id_mae_persona = b.id_mae_persona)
                WHERE b.per_cot BETWEEN DATEADD(mm, -11, u2tc.ultimoPerCot) AND u2tc.ultimoPerCot
                AND b.codigoTipoProducto = 1;
            
                --Universo con mas de 6 periodo DNP
                SELECT u2tc.id_mae_persona,u2tc.RUT,periodoCotizado per_cot
                INTO #Universo2_DNP
                FROM #Universo2TipoCoberturaTMPDNP u2tc
                    INNER JOIN #DNP b ON (u2tc.id_mae_persona = b.id_mae_persona)
                WHERE b.periodoCotizado BETWEEN DATEADD(mm, -11, u2tc.ultimoPerCot) AND u2tc.ultimoPerCot;
            
                 --Universo FIANL con mas de 6 periodo cotizados (DNP + COTIZACIONES)
                SELECT DISTINCT a.id_mae_persona
                INTO #Universo2_2TipoCoberturaTMP
                FROM
                (SELECT id_mae_persona, RUT, per_cot
                FROM #Universo2_DNP
                union
                SELECT id_mae_persona, RUT, per_cot
                FROM #Universo2_COT)a
                GROUP BY a.id_mae_persona
                HAVING COUNT(DISTINCT a.per_cot) >= 6;
            
                SELECT u2tc.ultimoPerCot, 
                    DMGestion.obtenerUltimaFechaMes(u2tc.ultimoPerCot) ultimaFechaMesPerCot
                INTO #UltimaFechaMesPerCotTMP2
                FROM #Universo2TipoCoberturaTMPDNP u2tc
                    INNER JOIN #Universo2_2TipoCoberturaTMP u22tc ON (u2tc.id_mae_persona = u22tc.id_mae_persona)
                GROUP BY u2tc.ultimoPerCot;
            

                --Universo Tipo Cobertura
                INSERT INTO  #UniversoFinalTMP(
                      id_mae_persona
                    , rut
                    , sexo
                    , edadActuarial
                    , edadCubiertaSeguro
                    , codigoTipoCobertura
                    , periodoCotizado
                    , universoOrigen
                    , prioridad)
                SELECT DISTINCT u2.id_mae_persona,
                    u2.rut,
                    ISNULL(uaa.sexo, '') sexo,
                    (CASE 
                        WHEN ((uaa.fechaNacimiento IS NOT NULL) AND 
                              (uaa.fechaNacimiento < ldtUltimaFechaMesInformar)) THEN
                            CONVERT(BIGINT, (DATEDIFF(mm, uaa.fechaNacimiento, ldtUltimaFechaMesInformar)/12))
                        ELSE CONVERT(BIGINT, 0)
                     END) edadActuarial,
                    (CASE 
                        WHEN ((uaa.fechaNacimiento IS NOT NULL) AND 
                              (uaa.fechaNacimiento < cdtFechaTopeCubiertoSeguro)) THEN
                            CONVERT(BIGINT, (DATEDIFF(mm, uaa.fechaNacimiento, cdtFechaTopeCubiertoSeguro)/12))
                        ELSE CONVERT(BIGINT, 0)
                     END) edadCubiertaSeguro,
                    CONVERT(CHAR(2), '01') codigoTipoCobertura,
                    u2.ultimoPerCot,
                    'Cesante cubierto',
                    2
                FROM #Universo2TipoCoberturaTMPDNP u2
                    INNER JOIN #Universo2_2TipoCoberturaTMP u22tc ON (u2.id_mae_persona = u22tc.id_mae_persona)
                    INNER JOIN #UltimaFechaMesPerCotTMP2 ufmpc ON (u2.ultimoPerCot = ufmpc.ultimoPerCot)
                    INNER JOIN #UniversoAfiliadosActivosTMP uaa ON (u22tc.id_mae_persona = uaa.id_mae_persona);
                
                DROP TABLE #UltimaFechaMesPerCotTMP2;
            
            ---AFILIADOS INDEPENDIENTES O VOLUNTARIOS
                
                --Universo Pago Seguro
                SELECT DISTINCT vc.id_mae_persona,
                    uaa.rut,
                    uaa.fechaNacimiento,
                    uaa.sexo,
                    vc.per_cot,
                    /*vc.fec_acreditacion,
                    vc.fec_movimiento,*/
                    CASE 
                        WHEN ((uaa.fechaNacimiento IS NOT NULL) AND 
                              (uaa.fechaNacimiento < vc.per_cot)) THEN
                            CONVERT(integer, (DATEDIFF(mm, uaa.fechaNacimiento, vc.per_cot)/12))
                        ELSE CONVERT(integer, 0)
                     END edadActuarial,
                     CASE 
                        WHEN ((uaa.fechaNacimiento IS NOT NULL) AND 
                              (uaa.fechaNacimiento < cdtFechaTopeCubiertoSeguro)) THEN
                            CONVERT(integer, (DATEDIFF(mm, uaa.fechaNacimiento, cdtFechaTopeCubiertoSeguro)/12))
                        ELSE CONVERT(integer, 0)
                        END edadCubiertaSeguro,
                     ('01') codigoTipoCobertura
                INTO #Independiente
                FROM DDS.VectorCotizaciones vc
                    INNER JOIN #UniversoAfiliadosActivosTMP uaa ON (vc.id_mae_persona = uaa.id_mae_persona)
                WHERE vc.codigoTipoProducto IN (1) 
                AND per_cot = ldtFechaPeriodoCotizadoAnt
                AND vc.rut_pagador = vc.rut_mae_persona
                AND fec_acreditacion BETWEEN ldtPeriodoCotizacion AND ldtUltimaFechaMesInformarAnt ;
            
            
             --UNIVERSO INDEPENDIENTE
                SELECT up.id_mae_persona,
                    up.rut,
                    up.fechaNacimiento,
                    up.sexo,
                    up.per_cot ultimoPerCot
                INTO #UniversoInd
                FROM #MovimientosPagoSeguroTMP up
                WHERE up.per_cot = ldtFechaPeriodoCotizadoAnt
                AND up.fec_acreditacion BETWEEN ldtPeriodoCotizacion AND ldtUltimaFechaMesInformarAnt
                AND up.rut = up.rut_pagador
                AND codigoTipoProducto = 1;
            
            INSERT INTO #UniversoFinalTMP --DMGestion.UniversoCubiertoSeguroTMP
                (id_mae_persona,rut,sexo,edadActuarial,edadCubiertaSeguro,codigoTipoCobertura, periodoCotizado, universoOrigen, prioridad)
                SELECT DISTINCT u1.id_mae_persona,
                    u1.rut,
                    ISNULL(u1.sexo, '') sexo,
                    (CASE 
                        WHEN ((u1.fechaNacimiento IS NOT NULL) AND 
                              (u1.fechaNacimiento < u1.ultimoPerCot)) THEN
                            CONVERT(BIGINT, (DATEDIFF(mm, u1.fechaNacimiento, u1.ultimoPerCot)/12))
                        ELSE CONVERT(BIGINT, 0)
                     END) edadActuarial,
                    (CASE 
                        WHEN ((u1.fechaNacimiento IS NOT NULL) AND 
                              (u1.fechaNacimiento < cdtFechaTopeCubiertoSeguro)) THEN
                            CONVERT(BIGINT, (DATEDIFF(mm, u1.fechaNacimiento, cdtFechaTopeCubiertoSeguro)/12))
                        ELSE CONVERT(BIGINT, 0)
                     END) edadCubiertaSeguro,
                    CONVERT(CHAR(2), '01') codigoTipoCobertura
                    , u1.ultimoPerCot
                    , 'Independiente'
                    , 4
                FROM #UniversoInd u1;

            
             --UNIVERSO VOLUNTARIO
                SELECT up.id_mae_persona,
                    up.rut,
                    up.fechaNacimiento,
                    up.sexo,
                    up.per_cot ultimoPerCot
                INTO #UniversoVol
                FROM #MovimientosPagoSeguroTMP up
                WHERE up.per_cot = ldtFechaPeriodoCotizadoAnt
                AND up.fec_acreditacion BETWEEN ldtPeriodoCotizacion AND ldtUltimaFechaMesInformarAnt
                AND codigoTipoProducto = 6;
            
                INSERT INTO #UniversoFinalTMP --DMGestion.UniversoCubiertoSeguroTMP
                (id_mae_persona,rut,sexo,edadActuarial,edadCubiertaSeguro,codigoTipoCobertura, periodoCotizado, universoOrigen, prioridad)
                SELECT DISTINCT u1.id_mae_persona,
                    u1.rut,
                    ISNULL(u1.sexo, '') sexo,
                    (CASE 
                        WHEN ((u1.fechaNacimiento IS NOT NULL) AND 
                              (u1.fechaNacimiento < u1.ultimoPerCot)) THEN
                            CONVERT(BIGINT, (DATEDIFF(mm, u1.fechaNacimiento, u1.ultimoPerCot)/12))
                        ELSE CONVERT(BIGINT, 0)
                     END) edadActuarial,
                    (CASE 
                        WHEN ((u1.fechaNacimiento IS NOT NULL) AND 
                              (u1.fechaNacimiento < cdtFechaTopeCubiertoSeguro)) THEN
                            CONVERT(BIGINT, (DATEDIFF(mm, u1.fechaNacimiento, cdtFechaTopeCubiertoSeguro)/12))
                        ELSE CONVERT(BIGINT, 0)
                     END) edadCubiertaSeguro,
                    CONVERT(CHAR(2), '01') codigoTipoCobertura
                    , u1.ultimoPerCot
                    , 'Voluntario'
                    , 5
                FROM #UniversoVol u1;
            
            
            ---AFILIADOS INDEPENDIENTES CON PAGO A LA TGR 
            
                
                --TGR POR TRASPASO
                SELECT CED_NAC_IDE rut, MAX(MES_DEV_REM) periodoCotizado 
                INTO #TGR_CMH
                FROM DDS.TB_CMH tc
                WHERE COD_MOV  IN (11105,11107)
                AND MES_DEV_REM IN (ldtPeriodoCotizacion,ldtFechaPeriodoInformado)
                GROUP BY rut;
                
                --TGR REGISTRO INTERNO
                SELECT tmp.RUT_MAE_PERSONA rut, max(tmm.PER_COT) periodoCotizado
                INTO #TGR_TMM
                FROM DDS.TB_MAE_MOVIMIENTO tmm
                INNER JOIN DDS.GrupoMovimiento gm ON gm.codigoTipoMovimiento = tmm.ID_TIP_MOVIMIENTO
                INNER JOIN DDS.TB_MAE_PERSONA tmp ON tmp.ID_MAE_PERSONA = tmm.ID_MAE_PERSONA
                WHERE gm.codigoSubgrupoMovimiento = 1106
                    AND gm.codigoProducto = 1
                    AND tmm.PER_COT IN (ldtPeriodoCotizacion,ldtFechaPeriodoInformado)
                GROUP BY rut;
            
                --TGR FINAL
                SELECT RUT, MAX(periodoCotizado) periodoCotizado
                    INTO #TGR
                FROM 
                (SELECT RUT, periodoCotizado
                FROM #TGR_CMH
                UNION
                SELECT RUT, periodoCotizado
                FROM #TGR_TMM)a
                GROUP BY rut;
                
               INSERT INTO #UniversoFinalTMP --DMGestion.UniversoCubiertoSeguroTMP
                (id_mae_persona,rut,sexo,edadActuarial,edadCubiertaSeguro,codigoTipoCobertura, periodoCotizado, universoOrigen, prioridad) 
               SELECT DISTINCT up.id_mae_persona,
                    up.rut,
                    ISNULL(up.sexo, '') sexo,
                    (CASE 
                        WHEN ((up.fechaNacimiento IS NOT NULL) AND 
                              (up.fechaNacimiento < tgr.periodoCotizado)) THEN
                            CONVERT(BIGINT, (DATEDIFF(mm, up.fechaNacimiento, tgr.periodoCotizado)/12))
                        ELSE CONVERT(BIGINT, 0)
                     END) edadActuarial,
                    (CASE 
                        WHEN ((up.fechaNacimiento IS NOT NULL) AND 
                              (up.fechaNacimiento < cdtFechaTopeCubiertoSeguro)) THEN
                            CONVERT(BIGINT, (DATEDIFF(mm, up.fechaNacimiento, cdtFechaTopeCubiertoSeguro)/12))
                        ELSE CONVERT(BIGINT, 0)
                     END) edadCubiertaSeguro,
                    CONVERT(CHAR(2), '01') codigoTipoCobertura
                    , tgr.periodoCotizado
                    , 'TGR'
                    , 3
                --INTO #UniversoVol
                FROM #UniversoAfiliadosActivosTMP up
                INNER JOIN #TGR tgr ON tgr.rut = up.rut;
            
            DELETE FROM  #UniversoFinalTMP
            WHERE sexo = 'M' 
                AND edadActuarial >= 65;

            DELETE FROM  #UniversoFinalTMP
            WHERE sexo = 'F'
                AND edadCubiertaSeguro > 60
                AND edadActuarial > 60;

            DELETE FROM  #UniversoFinalTMP
            WHERE sexo = 'F'
                AND edadCubiertaSeguro <= 60
                AND edadActuarial >= 65;   
            
        SELECT rut,min(prioridad) orden
           INTO  #filtro
        FROM #UniversoFinalTMP
        GROUP BY rut;
    
        SELECT a.id_mae_persona,a.rut,a.sexo,a.edadActuarial,a.edadCubiertaSeguro,a.codigoTipoCobertura, a.periodoCotizado, a.universoOrigen 
            INTO #UniversoRegistrar
        FROM #UniversoFinalTMP a
        INNER JOIN #filtro b ON a.rut = b.rut AND a.prioridad = b.orden;
    
        
        INSERT INTO DMGestion.UniversoCubiertoSeguroTMP
            (id_mae_persona,
            rut,
            sexo,
            edadActuarial,
            edadCubiertaSeguro,
            codigoTipoCobertura,
            periodoCotizado,
            universoOrigen)
        SELECT
            a.id_mae_persona
            , a.rut
            , a.sexo
            , a.edadActuarial
            , a.edadCubiertaSeguro
            , a.codigoTipoCobertura
            , a.periodoCotizado
            , a.universoOrigen
        FROM
            #UniversoRegistrar a;
                
                
        COMMIT;
        SAVEPOINT;
    
    -------------------------------------------------------------------------------------------
--Manejo de Excepciones
-------------------------------------------------------------------------------------------
/*EXCEPTION
    WHEN OTHERS THEN
       SET lstCodigoError = SQLSTATE;
       SET codigoError = lstCodigoError;
       ROLLBACK;
       CALL DMGestion.registrarErrorProceso(cstNombreProcedimiento, lstCodigoError);*/
END