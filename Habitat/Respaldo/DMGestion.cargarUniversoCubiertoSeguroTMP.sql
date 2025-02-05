create PROCEDURE DMGestion.cargarUniversoCubiertoSeguroTMP(OUT codigoError VARCHAR(10))
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
    SET cstCodControlAPP = 'APP';
    SET cstCodControlAPV = 'APV';
    SET cstCodControlACP = 'ACP';
    SET cstCodControlACV = 'ACV';
    SET cstCodControlCAP = 'CAP';
    SET cstCodControlCAV = 'CAV';
    SET cstCodControlTAS = 'TAS';
    SET cstCodControlVRF = 'VRF';
    SET cstCodControlOCE = 'OCE';
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
    --INTO cdtFechaTopeCubiertoSeguro
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

     --verifica si tabla se encuentra creada
    IF (EXISTS (SELECT 1 FROM SYSCATALOG WHERE tname = cstNombreTabla AND creator = 'DMGestion')) THEN
        DROP TABLE DMGestion.UniversoCubiertoSeguroTMP;
    END IF;


    CREATE TABLE DMGestion.UniversoCubiertoSeguroTMP 
        (id_mae_persona bigint NULL,
        sexo char(1)  NULL,
        edadActuarial bigint NULL,
        edadCubiertaSeguro bigint NULL,
        codigoTipoCobertura char(2) NULL
        );

    /*TIPO DE COBERTURUA SIS*/
                --Universo Afiliados Activos
                SELECT up.id_mae_persona,
                    dp.fechaNacimiento,
                    dp.sexo
                INTO #UniversoAfiliadosActivosTMP
                FROM DMGestion.UniversoAfiliadoClienteTMP up
                    INNER JOIN DMGestion.DimPersona dp ON (up.idDimPersona = dp.id) AND dp.fechaVigencia >= '21991231'
                WHERE up.cod_control IN ('VAL', 'PRV', 
                                         'AVP', 'AVV')
                AND up.esUniversoCuadro1 = 'S'
                AND up.id_tip_estado_rol = 1 --Afiliado
                AND up.codigoTipoRol = 1; --Persona

                --Universo Pago Seguro
                SELECT vc.id_mae_persona,
                    uaa.fechaNacimiento,
                    uaa.sexo,
                    vc.per_cot,
                    vc.fec_acreditacion,
                    vc.fec_movimiento
                INTO #MovimientosPagoSeguroTMP
                FROM DDS.VectorCotizaciones vc
                    INNER JOIN #UniversoAfiliadosActivosTMP uaa ON (vc.id_mae_persona = uaa.id_mae_persona)
                WHERE vc.codigoTipoProducto IN (ctiProductoCCICO, ctiProductoCCIAV) --productos CCICO y CCIAV
                AND vc.codTrafil02 IN (cinMovPagoSeguro1, cinMovPagoSeguro2); --Movimientos Pago de Seguro

                --Universo 1: Cotizantes del Mes con Pago a Seguro- Afiliados Activos
                SELECT up.id_mae_persona,
                    up.fechaNacimiento,
                    up.sexo,
                    MAX(up.per_cot) ultimoPerCot
                INTO #Universo1TipoCoberturaTMP
                FROM #MovimientosPagoSeguroTMP up
                WHERE up.per_cot IN(ldtPeriodoCotizacion, ldtFechaPeriodoInformado)
                AND up.fec_acreditacion BETWEEN ldtFechaPeriodoInformado AND ldtUltimaFechaMesInformar
                AND up.fec_movimiento BETWEEN ldtFechaPeriodoInformado AND ldtUltimaFechaMesInformar
                GROUP BY up.id_mae_persona,
                    up.fechaNacimiento,
                    up.sexo;

                SELECT ultimoPerCot, 
                    DMGestion.obtenerUltimaFechaMes(ultimoPerCot) ultimaFechaMesPerCot
                INTO #UltimaFechaMesPerCotTMP
                FROM #Universo1TipoCoberturaTMP
                GROUP BY ultimoPerCot;

                --Universo Tipo Cobertura
                
                INSERT INTO DMGestion.UniversoCubiertoSeguroTMP
                (id_mae_persona,sexo,edadActuarial,edadCubiertaSeguro,codigoTipoCobertura)
                SELECT u1.id_mae_persona,
                    ISNULL(u1.sexo, '') sexo,
                    (CASE 
                        WHEN ((u1.fechaNacimiento IS NOT NULL) AND 
                              (u1.fechaNacimiento < ufmpc.ultimaFechaMesPerCot)) THEN
                            CONVERT(BIGINT, (DATEDIFF(mm, u1.fechaNacimiento, ufmpc.ultimaFechaMesPerCot)/cinDoce))
                        ELSE CONVERT(BIGINT, 0)
                     END) edadActuarial,
                    (CASE 
                        WHEN ((u1.fechaNacimiento IS NOT NULL) AND 
                              (u1.fechaNacimiento < cdtFechaTopeCubiertoSeguro)) THEN
                            CONVERT(BIGINT, (DATEDIFF(mm, u1.fechaNacimiento, cdtFechaTopeCubiertoSeguro)/cinDoce))
                        ELSE CONVERT(BIGINT, 0)
                     END) edadCubiertaSeguro,
                    CONVERT(CHAR(2), '01') codigoTipoCobertura
                --INTO DMGestion.UniversoCubiertoSeguroTMP --#UniversoTipoCoberturaTMP
                FROM #Universo1TipoCoberturaTMP u1
                    INNER JOIN #UltimaFechaMesPerCotTMP ufmpc ON (u1.ultimoPerCot = ufmpc.ultimoPerCot);

                --Se elimina del universo Afiliados Activo, los que tienen convertura del universo 1
                DELETE FROM #UniversoAfiliadosActivosTMP
                FROM #UniversoAfiliadosActivosTMP uaa, DMGestion.UniversoCubiertoSeguroTMP uc
                WHERE uaa.id_mae_persona = uc.id_mae_persona;

                --Universo 2: Cotizantes con Pago a Seguro un año atras del periodo informado - Afiliados Activos
                SELECT up.id_mae_persona,
                    MAX(up.per_cot) ultimoPerCot
                INTO #Universo2TipoCoberturaTMP
                FROM #MovimientosPagoSeguroTMP up
                    INNER JOIN #UniversoAfiliadosActivosTMP uaa ON (up.id_mae_persona = uaa.id_mae_persona)
                WHERE up.per_cot BETWEEN ldtPeriodoCotizacionUnAnoAtras AND ldtFechaPeriodoInformado
                GROUP BY up.id_mae_persona;

                --Universo con mas de 6 periodo cotizados
                SELECT u2tc.id_mae_persona
                INTO #Universo2_2TipoCoberturaTMP
                FROM #Universo2TipoCoberturaTMP u2tc
                    INNER JOIN #MovimientosPagoSeguroTMP b ON (u2tc.id_mae_persona = b.id_mae_persona)
                WHERE b.per_cot BETWEEN DATEADD(mm, -11, u2tc.ultimoPerCot) AND u2tc.ultimoPerCot
                GROUP BY u2tc.id_mae_persona
                HAVING COUNT(DISTINCT b.per_cot) >= cinSeis;
                
                DROP TABLE #UltimaFechaMesPerCotTMP;

                SELECT u2tc.ultimoPerCot, 
                    DMGestion.obtenerUltimaFechaMes(u2tc.ultimoPerCot) ultimaFechaMesPerCot
                INTO #UltimaFechaMesPerCotTMP
                FROM #Universo2TipoCoberturaTMP u2tc
                    INNER JOIN #Universo2_2TipoCoberturaTMP u22tc ON (u2tc.id_mae_persona = u22tc.id_mae_persona)
                GROUP BY u2tc.ultimoPerCot;

                --Universo Tipo Cobertura
                INSERT INTO DMGestion.UniversoCubiertoSeguroTMP(id_mae_persona, 
                    sexo, 
                    edadActuarial, 
                    edadCubiertaSeguro, 
                    codigoTipoCobertura)
                SELECT u2.id_mae_persona,
                    ISNULL(uaa.sexo, '') sexo,
                    (CASE 
                        WHEN ((uaa.fechaNacimiento IS NOT NULL) AND 
                              (uaa.fechaNacimiento < ufmpc.ultimaFechaMesPerCot)) THEN
                            CONVERT(BIGINT, (DATEDIFF(mm, uaa.fechaNacimiento, ufmpc.ultimaFechaMesPerCot)/cinDoce))
                        ELSE CONVERT(BIGINT, 0)
                     END) edadActuarial,
                    (CASE 
                        WHEN ((uaa.fechaNacimiento IS NOT NULL) AND 
                              (uaa.fechaNacimiento < cdtFechaTopeCubiertoSeguro)) THEN
                            CONVERT(BIGINT, (DATEDIFF(mm, uaa.fechaNacimiento, cdtFechaTopeCubiertoSeguro)/cinDoce))
                        ELSE CONVERT(BIGINT, 0)
                     END) edadCubiertaSeguro,
                    CONVERT(CHAR(2), '01') codigoTipoCobertura
                FROM #Universo2TipoCoberturaTMP u2
                    INNER JOIN #Universo2_2TipoCoberturaTMP u22tc ON (u2.id_mae_persona = u22tc.id_mae_persona)
                    INNER JOIN #UltimaFechaMesPerCotTMP ufmpc ON (u2.ultimoPerCot = ufmpc.ultimoPerCot)
                    INNER JOIN #UniversoAfiliadosActivosTMP uaa ON (u22tc.id_mae_persona = uaa.id_mae_persona);

                --Se elimina los que no cumplen la siguiente regla:
                --Sexo M edadActuarial > 65
                --Sexo F 
                --Si la edad al 01-10-2008 menor a 60 entonces 
                --edadActuarial > 65
                --Si No 
                --edadActuarial > 60

                DELETE FROM DMGestion.UniversoCubiertoSeguroTMP
                WHERE sexo = cstMasculino 
                    AND edadActuarial > ltiEdadLegalPensionarseMasculino;

                DELETE FROM DMGestion.UniversoCubiertoSeguroTMP
                WHERE sexo = cstFemenino
                    AND edadCubiertaSeguro > cinEdadLegalM
                    AND edadActuarial > ltiEdadLegalPensionarseFemenino;

                DELETE FROM DMGestion.UniversoCubiertoSeguroTMP
                WHERE sexo = cstFemenino
                    AND edadCubiertaSeguro <= cinEdadLegalM
                    AND edadActuarial > ltiEdadLegalPensionarseMasculino;
                
                
                ---AFILIADOS INDEPENDIENTES O VOLUNTARIOS
                
                
                                --Universo Pago Seguro
                SELECT DISTINCT vc.id_mae_persona,
                    uaa.fechaNacimiento,
                    uaa.sexo,
                    /*vc.per_cot,
                    vc.fec_acreditacion,
                    vc.fec_movimiento,*/
                    CASE 
                        WHEN ((uaa.fechaNacimiento IS NOT NULL) AND 
                              (uaa.fechaNacimiento < vc.per_cot)) THEN
                            CONVERT(integer, (DATEDIFF(mm, uaa.fechaNacimiento, vc.per_cot)/12))
                        ELSE CONVERT(integer, 0)
                     END edadActuarial,
                     CASE 
                        WHEN ((uaa.fechaNacimiento IS NOT NULL) AND 
                              (uaa.fechaNacimiento < '2008-03-17')) THEN
                            CONVERT(integer, (DATEDIFF(mm, uaa.fechaNacimiento, '2008-03-17')/12))
                        ELSE CONVERT(integer, 0)
                        END edadCubiertaSeguro,
                     ('01') codigoTipoCobertura
                INTO #Independiente
                FROM DDS.VectorCotizaciones vc
                    INNER JOIN #UniversoAfiliadosActivosTMP uaa ON (vc.id_mae_persona = uaa.id_mae_persona)
                WHERE vc.codigoTipoProducto IN (1) --productos CCICO y CCIAV
                AND per_cot = '20240601'
                AND fec_acreditacion BETWEEN '20240701' AND '20240731'
                AND rut_pagador = rut_mae_persona ;
            
            
                SELECT DISTINCT vc.id_mae_persona,
                    uaa.fechaNacimiento,
                    uaa.sexo,
                    /*vc.per_cot,
                    vc.fec_acreditacion,
                    vc.fec_movimiento,*/
                    CASE 
                        WHEN ((uaa.fechaNacimiento IS NOT NULL) AND 
                              (uaa.fechaNacimiento < vc.per_cot)) THEN
                            CONVERT(integer, (DATEDIFF(mm, uaa.fechaNacimiento, vc.per_cot)/12))
                        ELSE CONVERT(integer, 0)
                     END edadActuarial,
                     CASE 
                        WHEN ((uaa.fechaNacimiento IS NOT NULL) AND 
                              (uaa.fechaNacimiento < '2008-03-17')) THEN
                            CONVERT(integer, (DATEDIFF(mm, uaa.fechaNacimiento, '2008-03-17')/12))
                        ELSE CONVERT(integer, 0)
                        END edadCubiertaSeguro,
                     ('01') codigoTipoCobertura
                INTO #voluntario
                FROM DDS.VectorCotizaciones vc
                    INNER JOIN #UniversoAfiliadosActivosTMP uaa ON (vc.id_mae_persona = uaa.id_mae_persona)
                WHERE vc.codigoTipoProducto IN (6) --productos CCICO y CCIAV
                AND per_cot = '20240601'
                AND fec_acreditacion BETWEEN '20240701' AND '20240731';
            
            
                INSERT INTO DMGestion.UniversoCubiertoSeguroTMP(id_mae_persona, 
                    sexo, 
                    edadActuarial, 
                    edadCubiertaSeguro, 
                    codigoTipoCobertura)
                SELECT uni.id_mae_persona,
                    uni.sexo,
                    uni.edadActuarial, 
                    uni.edadCubiertaSeguro, 
                    uni.codigoTipoCobertura
                FROM 
                (SELECT id.id_mae_persona,
                    id.sexo,
                    id.edadActuarial, 
                    id.edadCubiertaSeguro, 
                    id.codigoTipoCobertura
                FROM #Independiente id
                UNION 
                SELECT vol.id_mae_persona,
                    vol.sexo,
                    vol.edadActuarial, 
                    vol.edadCubiertaSeguro, 
                    vol.codigoTipoCobertura
                    FROM #Voluntario vol)uni;
                
                ---AFILIADOS INDEPENDIENTES CON PAGO A LA TGR 
                
                
                
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