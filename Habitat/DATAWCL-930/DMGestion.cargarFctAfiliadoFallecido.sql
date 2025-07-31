ALTER  PROCEDURE DMGestion.cargarFctAfiliadoFallecido_DATAWCL930(OUT codigoError VARCHAR(10))
BEGIN
    /**
        - Nombre archivo                            : cargarFctAfiliadoFallecido.sql
        - Nombre del módulo                         : Modelo de Sobrevivencia
        - Fecha de  creación                        : 12/06/2010
        - Nombre del autor                          : Javier Saavedra Muñoz
        - Descripción corta del módulo              : Procedimiento que carga la dimensión de afiliados fallecido los 
                                                      que causaron pension de sobrevivencia como los que no
        - Lista de procedimientos contenidos        : 
        - Documentos asociados a la creación        : Documento_Diseo_Circ 1661 - Modelo Sobrevivencia IV.doc
        - Fecha de modificación                     :
        - Nombre de la persona que lo modificó      : Alvaro Hidalgo Ruiz
        - Cambios realizados                        : 
        - Documentos asociados a la modificación    : Documento Análisis  Diseño - BDA - Ex Circ  1661 - SOB_2507_JQ
    **/

    -------------------------------------------------------------------------------------------
    --Declaracion de Variables
    -------------------------------------------------------------------------------------------
    -- variable para capturar el codigo de error
    DECLARE lstCodigoError                  VARCHAR(10);    --variable local de tipo varchar
    --Variables auditoria
    DECLARE ldtFechaInicioCarga             DATETIME;       --variable local de tipo datetime
    DECLARE lbiCantidadRegistrosInformados  BIGINT;         --variable local de tipo bigint
    -- variables locales
    DECLARE linContadorExistencia           INTEGER;        --variable local de tipo integer
    DECLARE lchAux                          BIGINT;         --variable local de tipo bigint
    DECLARE linIdPeriodoInformar            INTEGER;        --variable local de tipo integer
    DECLARE lstValorParametro               VARCHAR(100);   --variable local de tipo varchar
    DECLARE ldtFechaPeriodoInformado        DATE;           --variable local de tipo date
    DECLARE ldtHastaFechaPeriodoInformar    DATE;           --variable local de tipo date
    DECLARE ltiIdDimTipoProceso             TINYINT;        --variable local de tipo tinyint
    -- Constantes
    DECLARE cstOwner                        VARCHAR(150);
    DECLARE cstNombreProcedimiento          VARCHAR(150);   --constante de tipo varchar
    DECLARE cstNombreTablaFct               VARCHAR(150);   --constante de tipo varchar
    DECLARE cstCodigoErrorCero              VARCHAR(10);
    DECLARE cdtFecha01IndScomp              DATE;
    DECLARE cdtFecha02IndScomp              DATE;
    DECLARE cinValor99999                   INTEGER;
    DECLARE cinValor0                       INTEGER;
    DECLARE cinTipoBen8                     INTEGER;
    DECLARE ctiCodigoEstadoAprobado         TINYINT;
    DECLARE cchCodigoTipoPension01          CHAR(2);
    DECLARE cchCodigoTipoPension02          CHAR(2);
    DECLARE cchCodigoTipoPension11          CHAR(2);
    DECLARE cchCodigoTipoPension12          CHAR(2);
    DECLARE cchCodigoTipoPension13          CHAR(2);
    DECLARE cchCodigoTipoPension14          CHAR(2);
    DECLARE cchCodigoTipoPension15          CHAR(2);
    DECLARE cchCodigoTipoPension16          CHAR(2);
    DECLARE cchCodigoTipoPension17          CHAR(2);
    DECLARE cchCodigoTipoPension18          CHAR(2);
    DECLARE cchCodigoTipoPension19          CHAR(2);
    DECLARE cchCodigoTipoPension58          CHAR(2);
    DECLARE ctiCodigoEstadoSinReevaluacion  TINYINT;
    DECLARE cchSi                           CHAR(2);
    DECLARE cchNo                           CHAR(2);
    DECLARE cinTipoBen1                     INTEGER;
    DECLARE cinTipoBen2                     INTEGER;
    DECLARE cinTipoBen3                     INTEGER;
    DECLARE cinTipoBen5                     INTEGER;
    DECLARE cinTipoBen6                     INTEGER;
    DECLARE cchCodigoTipoEstadoFallecido    CHAR(2);
    DECLARE cinUno                          INTEGER;
    DECLARE cinDos                          INTEGER;
    DECLARE cchCodigoSituacionAfiliado01    CHAR(2);
    DECLARE cchCodigoSituacionAfiliado02    CHAR(2);
    DECLARE cchCodigoSituacionAfiliado11    CHAR(2);
    DECLARE cchCodigoSituacionAfiliado13    CHAR(2);
    DECLARE cchCodigoSituacionAfiliado14    CHAR(2);
    DECLARE cchCodigoSituacionAfiliado15    CHAR(2);
    DECLARE cchSinClasificar                CHAR(2);
    DECLARE cchCodigoSO                     CHAR(2);
    DECLARE cnuMontoCero                    NUMERIC(7, 2);
    DECLARE cstAbonos                       VARCHAR(10);
    DECLARE cstCargos                       VARCHAR(10);
    DECLARE ctiCodigoProductoCCICO          TINYINT;
    DECLARE ctiCodigoProductoCAI            TINYINT;
    DECLARE ctiCodigoProductoCCIAV          TINYINT;
    DECLARE cinCodigoGrupoMovimiento1300    INTEGER;
    DECLARE cinCodigoGrupoMovimiento2500    INTEGER;
    DECLARE cchFormatoYYYYMM                CHAR(6);
    DECLARE cchDia01                        CHAR(2);
    DECLARE ctiCodSubclasifPersona5         TINYINT;
    DECLARE ctiCodSubclasifPersona6         TINYINT;
    DECLARE ctiCodSubclasifPersona11        TINYINT;
    DECLARE ctiCodSolEstAprobado            TINYINT;
    DECLARE ctiDoce                         TINYINT;
    DECLARE ctiModalidad1                   TINYINT;
    DECLARE ctiModalidad2                   TINYINT;
    DECLARE ctiModalidad3                   TINYINT;
    DECLARE ctiModalidad5                   TINYINT;
    DECLARE cchCodigoModalidadPension01     CHAR(2);
    DECLARE cchCodigoModalidadPension02     CHAR(2);
    DECLARE cchCodigoModalidadPension07     CHAR(2);
    DECLARE cchCodigoModalidadPension03     CHAR(2);
    DECLARE cchCodigoModalidadPension04     CHAR(2);
    DECLARE cchCodigoModalidadPension05     CHAR(2);
    DECLARE cchCodigoModalidadPension06     CHAR(2);
    DECLARE cchCodigoModalidadPension08     CHAR(2);
    DECLARE cchCodigoModalidadPension09     CHAR(2);
    DECLARE cchCodigoModalidadPension11     CHAR(2);
    DECLARE cchCodigoModalidadPension12     CHAR(2);
    DECLARE cinCodigoTipoMov63              INTEGER;
    DECLARE cinCodigoTipoMov66              INTEGER;
    DECLARE cchCodTipoProductoCCICO         CHAR(1);
    DECLARE cchAPROBADA                     CHAR(10);
    DECLARE cstAprobadaNoPerfeccionada      VARCHAR(30);
    DECLARE cchPAGADA                       CHAR(10);
    DECLARE cdtMaximaFechaVigencia          DATE;           --variable local de tipo date
    DECLARE cdtFecCorteNoPerfect            DATE;
    DECLARE cchN                            CHAR(1);
    DECLARE cchS                            CHAR(1);   
    DECLARE cinAprobadaNoPerfeccionada      INTEGER;
    DECLARE cinAprobada                     INTEGER;
    DECLARE ctiSubtipobe801                 INTEGER;
    DECLARE ctiSubtipobe802                 INTEGER;
    
    

    -------------------------------------------------------------------------------------------
    --Seteo Variable auditoria
    -------------------------------------------------------------------------------------------
    --se obtiene la fecha y hora de carga
    SET ldtFechaInicioCarga             = getDate();

    -------------------------------------------------------------------------------------------
    --Seteo de Constantes
    -------------------------------------------------------------------------------------------
    SET cstOwner                        = 'DMGestion';
    SET cstNombreProcedimiento          = 'cargarFctAfiliadoFallecido';
    SET cstNombreTablaFct               = 'FctAfiliadoFallecido';
    SET cstCodigoErrorCero              = '0';
    SET cdtFecha01IndScomp              = DATE('2009-07-01');
    SET cdtFecha02IndScomp              = DATE('2004-08-19');
    SET cinValor99999                   = 99999;
    SET cinValor0                       = 0;
    SET cinTipoBen1                     = 1;
    SET cinTipoBen2                     = 2;
    SET cinTipoBen3                     = 3;
    SET cinTipoBen5                     = 5;
    SET cinTipoBen6                     = 6;
    SET cinTipoBen8                     = 8;
    SET ctiCodigoEstadoAprobado         = 4;
    SET cchCodigoTipoPension01          = '01';
    SET cchCodigoTipoPension02          = '02';
    SET cchCodigoTipoPension11          = '11';
    SET cchCodigoTipoPension12          = '12';
    SET cchCodigoTipoPension13          = '13';
    SET cchCodigoTipoPension14          = '14';
    SET cchCodigoTipoPension15          = '15';
    SET cchCodigoTipoPension16          = '16';
    SET cchCodigoTipoPension17          = '17';
    SET cchCodigoTipoPension18          = '18';
    SET cchCodigoTipoPension19          = '19';
    SET cchCodigoTipoPension58          = '58';
    SET cchSi                           = 'Si';
    SET cchNo                           = 'No';
    SET cchCodigoSituacionAfiliado11    = '11';
    SET cchCodigoSituacionAfiliado13    = '13';
    SET cchCodigoSituacionAfiliado14    = '14';
    SET cchCodigoSituacionAfiliado15    = '15';
    SET cinUno                          = 1;  
    SET cinDos                          = 2;   
    SET cchCodigoTipoEstadoFallecido    = '04';
    SET ctiCodigoEstadoSinReevaluacion  = 99;
    SET cchCodigoSituacionAfiliado01    = '01';
    SET cchCodigoSituacionAfiliado02    = '02';
    SET cchSinClasificar                = '0';
    SET cchCodigoSO                     = 'SO';
    SET cnuMontoCero                    = 0.0;
    SET cstAbonos                       = 'Abonos';
    SET cstCargos                       = 'Cargos';
    SET ctiCodigoProductoCCICO          = 1;
    SET ctiCodigoProductoCAI            = 3;
    SET ctiCodigoProductoCCIAV          = 6;
    SET cinCodigoGrupoMovimiento1300    = 1300;
    SET cinCodigoGrupoMovimiento2500    = 2500;
    SET cchFormatoYYYYMM                = 'YYYYMM';
    SET cchDia01                        = '01';
    SET ctiCodSubclasifPersona5         = 5;
    SET ctiCodSubclasifPersona6         = 6;
    SET ctiCodSubclasifPersona11        = 11;
    SET ctiCodSolEstAprobado            = 2;
    SET ctiDoce                         = 12;
    SET ctiModalidad1                   = 1;
    SET ctiModalidad2                   = 2;
    SET ctiModalidad3                   = 3;
    SET ctiModalidad5                   = 5;
    SET cchCodigoModalidadPension01     = '01';
    SET cchCodigoModalidadPension02     = '02';
    SET cchCodigoModalidadPension03     = '03';
    SET cchCodigoModalidadPension04     = '04';
    SET cchCodigoModalidadPension05     = '05';
    SET cchCodigoModalidadPension06     = '06';
    SET cchCodigoModalidadPension07     = '07';
    SET cchCodigoModalidadPension08     = '08';
    SET cchCodigoModalidadPension09     = '09';
    SET cchCodigoModalidadPension12     = '12';
    SET cchCodigoModalidadPension11     = '11';
    SET cinCodigoTipoMov63              = 63;
    SET cinCodigoTipoMov66              = 66;
    SET ctiSubtipobe801                 = 801;
    SET ctiSubtipobe802                 = 802;
    SET cchCodTipoProductoCCICO         = '1';
    SET cchAPROBADA                     = 'APROBADA';
    SET cchPAGADA                       = 'PAGADA';
    SET cstAprobadaNoPerfeccionada      = 'Aprobada no perfeccionada';
    SET cchN                            = 'N';
    SET cchS                            = 'S';
    SET cdtMaximaFechaVigencia          = CONVERT(DATE, DMGestion.obtenerParametro('MAXIMA_FECHA_VIGENCIA'), 103);
    SET cdtFecCorteNoPerfect            = '20220801'; -- Fecha de corte para el universo de tramites NO perfeccionados (aprobados si fecha de primer pago)
    

    -------------------------------------------------------------------------------------------
    --Seteo de Variables
    -------------------------------------------------------------------------------------------
    SET linIdPeriodoInformar            = DMGestion.obtenerIdDimPeriodoInformar();
    SET ldtFechaPeriodoInformado        = DMGestion.obtenerFechaPeriodoInformar(); 
    SET ldtHastaFechaPeriodoInformar    = DMGestion.obtenerUltimaFechaMes(ldtFechaPeriodoInformado);


    SET cinAprobada                     = (SELECT CODIGO FROM DMGestion.dimestadoSolicitud WHERE nombre = cchAPROBADA);
    SET cinAprobadaNoPerfeccionada      = (SELECT CODIGO FROM DMGestion.dimestadoSolicitud WHERE nombre = cstAprobadaNoPerfeccionada);

    -------------------------------------------------------------------------------------------
    --Cuerpo
    -------------------------------------------------------------------------------------------
    --se obtiene el identificador del tipo de proceso
    SELECT id INTO ltiIdDimTipoProceso
    FROM DMGestion.DimTipoProceso 
    WHERE codigo = '02'
        AND fechaVigencia >= cdtMaximaFechaVigencia;
 

    --se elimina los errores de carga y datos de la fact para el periodo a informar
    CALL DMGestion.eliminarFact(cstNombreProcedimiento, cstNombreTablaFct, linIdPeriodoInformar, codigoError);
    
    IF (codigoError = cstCodigoErrorCero) THEN
        CALL DMGestion.cargarUniversoHerenciaTMP(ldtFechaPeriodoInformado, codigoError);

        IF (codigoError = cstCodigoErrorCero) THEN
            CALL DMGestion.cargarUniversoCuotaMortuoriaTMP(ldtFechaPeriodoInformado, codigoError);
    
            IF (codigoError = cstCodigoErrorCero) THEN
                --Se Obtiene Universo de los movimientos 87 (Pago Prima Renta Vitalicia)
                CALL DMGestion.cargarUniversoMovimientosRVTMP(ldtFechaPeriodoInformado, codigoError);
            END IF;
        END IF;       
    END IF;

    --verifica si se elimino con exito los errores de carga y datos de la fact
    IF (codigoError = cstCodigoErrorCero) THEN
        
        -- 04/01/2017 Este CALL no existía, para resolverlo se agrega.
        --Creación del universo código trafil02
        CALL DDS.cargarUniversoCodigoTrafil02(1);
    
        -----------------
        --Universo
        -----------------
        --CGI-ahr-ini--
        --Cantidad de registro= 345977 row(s) affected universo #STP_SOLICPEN --
        --CGI-ahr-fin--
        WITH RankedSolicPen AS (
            SELECT
                numcue,
                tipoben,
                subtipben,
                fedevpen,
                fecsol,
                codestsol,
                fecha_codestsol,
                ind_cobertura_seg_invalidez,
                ingreso_base,
                promedio_rentas_120meses,
                nro_meses_con_renta,
                pension_referencia,
                cod_ciaseg,
                porcentaje_cobertura_seg,
                RANK() OVER (PARTITION BY numcue ORDER BY fecsol DESC) as rn 
            FROM DDS.STP_SOLICPEN
            WHERE tipoben IN (cinTipoBen1, cinTipoBen2, cinTipoBen3, cinTipoBen5, cinTipoBen6, cinTipoBen8)
            AND codestsol = ctiCodSolEstAprobado
            AND fecsol <= ldtHastaFechaPeriodoInformar
        )
        SELECT
            numcue,
            tipoben,
            subtipben,
            fedevpen,
            fecsol,
            codestsol,
            fecha_codestsol,
            ind_cobertura_seg_invalidez,
            ingreso_base,
            promedio_rentas_120meses,
            nro_meses_con_renta,
            pension_referencia,
            cod_ciaseg,
            porcentaje_cobertura_seg
        INTO #STP_SOLICPEN
        FROM RankedSolicPen
        WHERE rn = cinUno; 

        --CGI-ahr-ini--
        --se genera un universo con todos los numcue que posean la invalidez transitoria (3) e invalidez definitiva (6)
        --cantidad de registros = 154 row(s) affected
        --CGI-ahr-fin--
 
        DELETE FROM #STP_SOLICPEN
        WHERE tipoben = cinTipoBen3
            AND EXISTS (SELECT 1
                        FROM #STP_SOLICPEN b
                        WHERE b.numcue = #STP_SOLICPEN.numcue
                        AND b.tipoben = cinTipoBen6);

        --ERROR cuando numcuePencersa es nulo, no hay info de certificado de saldo
        
        --CGI-ahr-ini--
        --se obtiene el universo a traves de la tablas #STP_SOLICPEN y DDS.STP_PENCERSA 
        --conciderando solo los tipoben = 8 (sobrevivencia)
        --se obtiene el numcuepencersa y modalidad de la tabla DDS.STP_PENCERSA  
        --se evalua a traves del case los campos numcue y ANOS_RENTA_GARANTIZADA para informar el campo tipoGarantia
        --si cumple algun when del case no evalua los when que siguen y en caso de no cumplir ninguno va por el else y
        --asigna un null al campo tipogarantia
        --universo registros creados 43243 row(s) affected
        --CGI-ahr-fin--
        SELECT p.numcue numcuePencersa,
            p.modpen_selmod modalidad,
            (CASE 
                WHEN (p.numcue IS NULL) THEN 
                    CONVERT(VARCHAR(50), NULL)
                WHEN (p.ANOS_RENTA_GARANTIZADA > cinValor0) THEN 
                    CONVERT(VARCHAR(50), 'GARANTIZADA')
                WHEN (p.ANOS_RENTA_GARANTIZADA <= cinValor0 OR p.ANOS_RENTA_GARANTIZADA IS NULL) THEN 
                    CONVERT(VARCHAR(50), 'SIMPLE')
                ELSE 
                    CONVERT(VARCHAR(50), NULL)
             END) tipoGarantia,
            s.numcue,
            s.tipoben,
            s.fecsol
        INTO #ModalidadSobrevivenciaTMP
        FROM #STP_SOLICPEN s
            LEFT OUTER JOIN DDS.STP_PENCERSA p ON (p.numcue = s.numcue 
            AND p.tipoben = s.tipoben 
            AND p.fecsol = s.fecsol)
        WHERE s.tipoben = cinTipoBen8;


        --CGI-ahr-ini--
        --se crea un universo #STP_SOLICPEN_TMP incorporando los campos de modalidad y tipogarantia
        --cruzandose el universo inicial STP_SOLICPEN con el universo #ModalidadSobrevivenciaTMP que posee solo las sobrevivencias 
        -- la cantidad de registro = 313481 row(s) affected
        --CGI-ahr-fin--
        
        SELECT so.modalidad,
            so.tipoGarantia,
            s.numcue,
            s.tipoben,
            s.subtipben,
            s.fedevpen,
            s.fecsol,
            s.codestsol,
            s.fecha_codestsol,
            s.ind_cobertura_seg_invalidez,
            s.ingreso_base,
            s.promedio_rentas_120meses,
            s.nro_meses_con_renta,
            s.pension_referencia,
            s.cod_ciaseg,
            s.porcentaje_cobertura_seg
        INTO #STP_SOLICPEN_TMP
        FROM #STP_SOLICPEN s
            LEFT OUTER JOIN #ModalidadSobrevivenciaTMP so ON (s.numcue = so.numcue 
            AND s.tipoben = so.tipoben 
            AND s.fecsol = so.fecsol);
    
        DROP TABLE #STP_SOLICPEN;       
        DROP TABLE #ModalidadSobrevivenciaTMP;
    
        --------------------------------------
        --Universo de Fallecidos
        --------------------------------------
        --CGI-ahr-ini--
        --en este universo se genera los fallecidos y se calcula la edad --
        --se reemplazo la Vista por la FctlsInformacionAfiliadoCliente con los ajustes que requerian
        --se reemplazo la forma de calcular la edad por una mas eficiente
        --cantidad de registro = 82090 row(s) affected
        SELECT DISTINCT dp.fechaDefuncion,
            dp.sexo, 
            dp.idPersonaOrigen ID_MAE_PERSONA,
            dp.fechaNacimiento,
            dp.rut,
            ISNULL(dp.cuentaAntigua, cinValor0) numcue,
            s.tipoben,
            s.fecsol,
            s.codestsol,
            s.fecha_codestsol,
            s.fedevpen,
            s.ingreso_base,
            s.promedio_rentas_120meses,
            s.nro_meses_con_renta,
            s.pension_referencia,
            s.modalidad,
            s.tipoGarantia,
            s.COD_CIASEG,
            s.subtipben,
            s.IND_COBERTURA_SEG_INVALIDEZ,
            s.PORCENTAJE_COBERTURA_SEG,
            (CASE
                WHEN ((dp.fechaNacimiento IS NOT NULL) AND (s.fecsol IS NOT NULL)) THEN
                    CONVERT(BIGINT, (DATEDIFF(mm, dp.fechaNacimiento, s.fecsol)/ctiDoce))
                ELSE 
                    CONVERT(BIGINT, NULL)
             END) edad, --Edad a la fecha de solicitud --> cuando no hay solicitud, la edad queda en NULL
            dp.id idPersona,
            dte.codigo AS codigoTipoEstado
        INTO #Universo01FallecidosTMP
        FROM DMGestion.FctlsInformacionAfiliadoCliente i
            INNER JOIN DMGestion.DimPersona dp ON (i.idPersona = dp.id) 
            INNER JOIN DMGestion.DimSubClasificacionPersona dscp ON (i.idSubClasificacionPersona = dscp.id)
            INNER JOIN DMGestion.DimClasificacionPersona dcp ON (dscp.idClasificacionPersona = dcp.id)  
            INNER JOIN DMGestion.DimTipoEstado dte ON (i.idTipoEstado = dte.id)
            LEFT OUTER JOIN #STP_SOLICPEN_TMP s ON (dp.cuentaAntigua = s.numcue)
        WHERE i.idPeriodoInformado = linIdPeriodoInformar
        AND dp.fechaDefuncion >= i.fechaIncorporacionAFP
        AND dscp.codigo IN (ctiCodSubclasifPersona5, ctiCodSubclasifPersona6, ctiCodSubclasifPersona11);

        --INI-INFESP-227
        SELECT DISTINCT dp.fechaDefuncion,
            dp.sexo, 
            dp.idPersonaOrigen AS ID_MAE_PERSONA,
            dp.fechaNacimiento,
            dp.rut,
            ISNULL(dp.cuentaAntigua, cinValor0) AS numcue,
            s.tipoben,
            s.fecsol,
            s.codestsol,
            s.fecha_codestsol,
            s.fedevpen,
            s.ingreso_base,
            s.promedio_rentas_120meses,
            s.nro_meses_con_renta,
            s.pension_referencia,
            s.modalidad,
            s.tipoGarantia,
            s.COD_CIASEG,
            s.subtipben,
            s.IND_COBERTURA_SEG_INVALIDEZ,
            s.PORCENTAJE_COBERTURA_SEG,
            (CASE
                WHEN ((dp.fechaNacimiento IS NOT NULL) AND (s.fecsol IS NOT NULL)) THEN
                    CONVERT(BIGINT, (DATEDIFF(mm, dp.fechaNacimiento, s.fecsol)/ctiDoce))
                ELSE 
                    CONVERT(BIGINT, NULL)
             END) edad, --Edad a la fecha de solicitud --> cuando no hay solicitud, la edad queda en NULL
            dp.id idPersona,
            dte.codigo AS codigoTipoEstado,
            i.fechaIncorporacionAFP,
            cchNo AS indRegistroInf
        INTO #Universo02FallecidosTMP
        FROM DMGestion.FctlsInformacionAfiliadoCliente i
            INNER JOIN DMGestion.DimPersona dp ON (i.idPersona = dp.id) 
            INNER JOIN DMGestion.DimSubClasificacionPersona dscp ON (i.idSubClasificacionPersona = dscp.id)
            INNER JOIN DMGestion.DimClasificacionPersona dcp ON (dscp.idClasificacionPersona = dcp.id)  
            INNER JOIN DMGestion.DimTipoEstado dte ON (i.idTipoEstado = dte.id)
            LEFT OUTER JOIN #STP_SOLICPEN_TMP s ON (dp.cuentaAntigua = s.numcue)
        WHERE i.idPeriodoInformado = linIdPeriodoInformar
        AND dp.fechaDefuncion < i.fechaIncorporacionAFP
        AND dscp.codigo IN (ctiCodSubclasifPersona5, ctiCodSubclasifPersona6, ctiCodSubclasifPersona11);

        --Caso 1: Si tiene un tramite de pensión de sobrevivencia fallecio en habitat
        SELECT DISTINCT c.rut
        INTO #Caso01Univero02TMP
        FROM DDS.STP_SOLICPEN a
            INNER JOIN DDS.STP_MASOLPEN b ON (a.numcue = b.numcue)
            INNER JOIN #Universo02FallecidosTMP c ON (b.numrut = c.rut)
        WHERE a.tipoben = cinTipoBen8
        AND a.codestsol = ctiCodSolEstAprobado;

        UPDATE #Universo02FallecidosTMP SET
            a.indRegistroInf = cchSi
        FROM #Universo02FallecidosTMP a 
            JOIN #Caso01Univero02TMP b ON (a.rut = b.rut);

        --Caso 2: Si tiene un pago por cuota mortuoria
        SELECT DISTINCT b.rut
        INTO #Caso02Univero02TMP
        FROM DMGestion.UniversoCuotaMortuoriaTMP a
            INNER JOIN #Universo02FallecidosTMP b ON (a.id_mae_persona = b.id_mae_persona)
        WHERE b.indRegistroInf = cchNo
        AND a.fechaPago IS NOT NULL;

        UPDATE #Universo02FallecidosTMP SET
            a.indRegistroInf = cchSi
        FROM #Universo02FallecidosTMP a 
            JOIN #Caso02Univero02TMP b ON (a.rut = b.rut);

        --Caso 3: Si tiene un pago por herencia
        SELECT DISTINCT b.rut
        INTO #Caso03Univero02TMP
        FROM DMGestion.UniversoHerenciaTMP a
            INNER JOIN #Universo02FallecidosTMP b ON (a.id_mae_persona = b.id_mae_persona)
        WHERE b.indRegistroInf = cchNo
        AND a.fechaPago IS NOT NULL;

        UPDATE #Universo02FallecidosTMP SET
            a.indRegistroInf = cchSi
        FROM #Universo02FallecidosTMP a 
            JOIN #Caso03Univero02TMP b ON (a.rut = b.rut);
        
        --Caso 4: Si tiene movimiento de traspaso
        SELECT DISTINCT c.id_tip_producto,
            b.id_tip_movimiento,    
            a.tipoMovimiento
        INTO #TipMovimientoTraspasoTMP
        FROM DDS.GrupoMovimiento a
            INNER JOIN DDS.TB_TIP_MOVIMIENTO b ON (a.codigoTipoMovimiento = b.COD_MOVIMIENTO)
            INNER JOIN DDS.TB_TIP_PRODUCTO c ON (a.codigoProducto = CONVERT(INTEGER, c.COD_TIP_PRODUCTO))
        WHERE a.codigoGrupoMovimiento IN (cinCodigoGrupoMovimiento1300, cinCodigoGrupoMovimiento2500);

        SELECT a.id_mae_movimiento,
            c.id_mae_persona,
            c.rut,
            b.tipoMovimiento, 
            a.fec_movimiento, 
            a.id_tip_producto, 
            a.id_tip_movimiento, 
            a.fec_acreditacion,
            c.fechaDefuncion,   
            c.fechaIncorporacionAFP,
            DENSE_RANK() OVER (PARTITION BY c.rut ORDER BY a.fec_movimiento ASC, a.id_tip_producto ASC, a.fec_acreditacion ASC, a.id_mae_movimiento ASC) rank,
            DENSE_RANK() OVER (PARTITION BY c.rut, a.fec_movimiento, a.id_tip_producto ORDER BY a.fec_acreditacion ASC, a.id_mae_movimiento ASC) rank02
        INTO #MovimientosTraspasoCaso03Universo02TMP
        FROM DDS.TB_MAE_MOVIMIENTO a
            INNER JOIN #TipMovimientoTraspasoTMP b ON (a.id_tip_producto = b.id_tip_producto
                AND a.id_tip_movimiento = b.id_tip_movimiento)
            INNER JOIN #Universo02FallecidosTMP c ON (a.id_mae_persona = c.id_mae_persona
                AND DATE(DATEFORMAT(a.fec_movimiento, cchFormatoYYYYMM) || cchDia01) <= c.fechaIncorporacionAFP)
        WHERE c.indRegistroInf = cchNo
        ORDER BY c.rut, a.fec_movimiento;

        DELETE FROM #MovimientosTraspasoCaso03Universo02TMP WHERE rank02 > cinUno;
        --Se elimina si el primer movimiento es un abono y la fecha de movimiento es mayor a la fecha de defuncion
        --se considera que se traspaso a favor ya estando fallecido.
        DELETE FROM #MovimientosTraspasoCaso03Universo02TMP
        FROM #MovimientosTraspasoCaso03Universo02TMP u, 
            (SELECT DISTINCT id_mae_persona
             FROM #MovimientosTraspasoCaso03Universo02TMP
             WHERE rank = cinUno
             AND fec_movimiento > fechaDefuncion
            AND tipoMovimiento = cstAbonos) b 
        WHERE u.id_mae_persona = b.id_mae_persona;

        --abonos con fec_movimiento igual, pero tipo producto diferente a CCICO
        DELETE FROM #MovimientosTraspasoCaso03Universo02TMP
        FROM #MovimientosTraspasoCaso03Universo02TMP a,
            (SELECT b.id_mae_movimiento
             FROM #MovimientosTraspasoCaso03Universo02TMP a
                 INNER JOIN #MovimientosTraspasoCaso03Universo02TMP b ON (a.id_mae_persona = b.id_mae_persona
                     AND a.tipoMovimiento = b.tipoMovimiento
                     AND a.id_tip_producto != b.id_tip_producto
                     AND a.fec_movimiento = b.fec_movimiento)
             WHERE a.tipoMovimiento = cstAbonos
             AND a.id_tip_producto = ctiCodigoProductoCCICO) b
        WHERE a.id_mae_movimiento = b.id_mae_movimiento;

        --Cargos con fec_movimiento igual, pero tipo producto diferente a CCICO
        DELETE FROM #MovimientosTraspasoCaso03Universo02TMP
        FROM #MovimientosTraspasoCaso03Universo02TMP a,
            (SELECT b.id_mae_movimiento
             FROM #MovimientosTraspasoCaso03Universo02TMP a
                 INNER JOIN #MovimientosTraspasoCaso03Universo02TMP b ON (a.id_mae_persona = b.id_mae_persona
                     AND a.tipoMovimiento = b.tipoMovimiento
                     AND a.id_tip_producto != b.id_tip_producto
                     AND a.fec_movimiento = b.fec_movimiento)
             WHERE a.tipoMovimiento = cstCargos
             AND a.id_tip_producto = ctiCodigoProductoCCICO) b
        WHERE a.id_mae_movimiento = b.id_mae_movimiento;
        
        --DROP TABLE #RevisarTMP02
        SELECT a.id_mae_movimiento,
            a.id_mae_persona,
            a.rut,
            a.tipoMovimiento, 
            a.fec_movimiento, 
            a.id_tip_producto, 
            a.id_tip_movimiento, 
            a.fec_acreditacion,
            a.fechaDefuncion,   
            a.fechaIncorporacionAFP,
            DENSE_RANK() OVER (PARTITION BY a.rut ORDER BY a.fec_movimiento ASC, a.id_tip_producto ASC, a.fec_acreditacion ASC, a.id_mae_movimiento ASC) rank,
            LAG (a.tipoMovimiento) OVER (PARTITION BY a.rut ORDER BY a.fec_movimiento ASC, a.id_tip_producto ASC, a.fec_acreditacion ASC, a.id_mae_movimiento ASC) col01,
            LAG (a.fec_movimiento) OVER (PARTITION BY a.rut ORDER BY a.fec_movimiento ASC, a.id_tip_producto ASC, a.fec_acreditacion ASC, a.id_mae_movimiento ASC) col02,
            LAG (a.id_tip_producto) OVER (PARTITION BY a.rut ORDER BY a.fec_movimiento ASC, a.id_tip_producto ASC, a.fec_acreditacion ASC, a.id_mae_movimiento ASC) col03,
            LEAD (a.tipoMovimiento) OVER (PARTITION BY a.rut ORDER BY a.fec_movimiento ASC, a.id_tip_producto ASC, a.fec_acreditacion ASC, a.id_mae_movimiento ASC) col04,
            LEAD (a.fec_movimiento) OVER (PARTITION BY a.rut ORDER BY a.fec_movimiento ASC, a.id_tip_producto ASC, a.fec_acreditacion ASC, a.id_mae_movimiento ASC) col05,
            LEAD (a.id_tip_producto) OVER (PARTITION BY a.rut ORDER BY a.fec_movimiento ASC, a.id_tip_producto ASC, a.fec_acreditacion ASC, a.id_mae_movimiento ASC) col06
        INTO #MovimientosTraspasoCaso03Universo02TMP02
        FROM #MovimientosTraspasoCaso03Universo02TMP a;

        SELECT id_mae_movimiento,
            id_mae_persona,
            rut,
            tipoMovimiento, 
            fec_movimiento, 
            id_tip_producto, 
            id_tip_movimiento, 
            fec_acreditacion,
            fechaDefuncion,   
            fechaIncorporacionAFP,
            (CASE
                WHEN col04 IS NOT NULL THEN 
                    CASE
                        WHEN tipoMovimiento = cstAbonos AND fec_movimiento <= fechaDefuncion AND col04 = cstCargos AND col05 >= fechaDefuncion AND id_tip_producto = col06 THEN cchSi
                        WHEN tipoMovimiento = cstAbonos AND fec_movimiento <= fechaDefuncion AND col04 = cstCargos AND col05 <  fechaDefuncion AND id_tip_producto = col06 THEN cchNo
                        WHEN tipoMovimiento = cstCargos AND fec_movimiento <= fechaDefuncion AND col04 = cstAbonos AND col05 >  fechaDefuncion AND id_tip_producto = col06 THEN cchNo
                        WHEN tipoMovimiento = cstCargos AND fec_movimiento <= fechaDefuncion AND col04 = cstAbonos AND col05 <= fechaDefuncion AND id_tip_producto = col06 THEN cchNo
                        WHEN tipoMovimiento = cstAbonos AND fec_movimiento <= fechaDefuncion AND id_tip_producto = ctiCodigoProductoCCICO AND col04 = cstAbonos AND col05 >= fechaDefuncion AND col06 = ctiCodigoProductoCCIAV THEN cchSi
                        WHEN tipoMovimiento = cstAbonos AND fec_movimiento <= fechaDefuncion AND id_tip_producto = ctiCodigoProductoCCICO AND col04 = cstAbonos AND col05 >= fechaDefuncion AND col06 = ctiCodigoProductoCAI THEN cchSi
                        WHEN tipoMovimiento = cstAbonos AND fec_movimiento <= fechaDefuncion AND id_tip_producto = ctiCodigoProductoCAI AND col04 = cstAbonos AND col05 <= fechaDefuncion AND col06 = id_tip_producto THEN cchNo
                        WHEN tipoMovimiento = cstAbonos AND fec_movimiento <= fechaDefuncion AND id_tip_producto = ctiCodigoProductoCAI AND col04 = cstAbonos AND col05 >  fechaDefuncion AND col06 = id_tip_producto THEN cchNo
                    END
                WHEN col01 IS NOT NULL AND col04 IS NULL THEN
                    CASE
                        WHEN tipoMovimiento = cstAbonos AND fec_movimiento > fechaDefuncion THEN cchNo
                    END
                WHEN col01 IS NULL AND col04 IS NULL THEN
                    CASE
                        WHEN tipoMovimiento = cstAbonos AND fec_movimiento <= fechaDefuncion THEN cchSi
                        WHEN tipoMovimiento = cstCargos AND fec_movimiento >= fechaDefuncion THEN cchSi
                    END
             END) AS ind
        INTO #MovimientosTraspasoCaso03Universo02TMP03
        FROM #MovimientosTraspasoCaso03Universo02TMP02;

        SELECT DISTINCT rut
        INTO #Caso04Univero02TMP
        FROM #MovimientosTraspasoCaso03Universo02TMP03
        WHERE ind = cchSi;

        UPDATE #Universo02FallecidosTMP SET
            a.indRegistroInf = cchSi
        FROM #Universo02FallecidosTMP a 
            JOIN #Caso04Univero02TMP b ON (a.rut = b.rut);

        DELETE FROM #Universo02FallecidosTMP
        WHERE indRegistroInf = cchNo;

        SELECT a.fechaDefuncion,
            a.sexo, 
            a.ID_MAE_PERSONA,
            a.fechaNacimiento,
            a.rut,
            a.numcue,
            a.tipoben,
            a.fecsol,
            a.codestsol,
            a.fecha_codestsol,
            a.fedevpen,
            a.ingreso_base,
            a.promedio_rentas_120meses,
            a.nro_meses_con_renta,
            a.pension_referencia,
            a.modalidad,
            a.tipoGarantia,
            a.COD_CIASEG,
            a.subtipben,
            a.IND_COBERTURA_SEG_INVALIDEZ,
            a.PORCENTAJE_COBERTURA_SEG,
            a.edad,
            a.idPersona,
            a.codigoTipoEstado
        INTO #UniversoFallecidosTMP_01
        FROM (
            SELECT fechaDefuncion,
                sexo, 
                ID_MAE_PERSONA,
                fechaNacimiento,
                rut,
                numcue,
                tipoben,
                fecsol,
                codestsol,
                fecha_codestsol,
                fedevpen,
                ingreso_base,
                promedio_rentas_120meses,
                nro_meses_con_renta,
                pension_referencia,
                modalidad,
                tipoGarantia,
                COD_CIASEG,
                subtipben,
                IND_COBERTURA_SEG_INVALIDEZ,
                PORCENTAJE_COBERTURA_SEG,
                edad,
                idPersona,
                codigoTipoEstado
            FROM #Universo01FallecidosTMP
            UNION
            SELECT fechaDefuncion,
                sexo, 
                ID_MAE_PERSONA,
                fechaNacimiento,
                rut,
                numcue,
                tipoben,
                fecsol,
                codestsol,
                fecha_codestsol,
                fedevpen,
                ingreso_base,
                promedio_rentas_120meses,
                nro_meses_con_renta,
                pension_referencia,
                modalidad,
                tipoGarantia,
                COD_CIASEG,
                subtipben,
                IND_COBERTURA_SEG_INVALIDEZ,
                PORCENTAJE_COBERTURA_SEG,
                edad,
                idPersona,
                codigoTipoEstado
            FROM #Universo02FallecidosTMP
        ) a;
        --FIN-INFESP-227

        UPDATE #UniversoFallecidosTMP_01 SET
            u.numcue = s.numcue,
            u.tipoben = s.tipoben,
            u.fecsol = s.fecsol,
            u.codestsol = s.codestsol,
            u.fecha_codestsol = s.fecha_codestsol,
            u.fedevpen = s.fedevpen,
            u.ingreso_base = s.ingreso_base,
            u.promedio_rentas_120meses = s.promedio_rentas_120meses,
            u.nro_meses_con_renta = s.nro_meses_con_renta,
            u.pension_referencia = s.pension_referencia,
            u.modalidad = s.modalidad,
            u.tipoGarantia = s.tipoGarantia,
            u.COD_CIASEG = s.COD_CIASEG,
            u.subtipben = s.subtipben,
            u.IND_COBERTURA_SEG_INVALIDEZ = s.IND_COBERTURA_SEG_INVALIDEZ,
            u.PORCENTAJE_COBERTURA_SEG = s.PORCENTAJE_COBERTURA_SEG,
            u.edad = (CASE
                          WHEN ((u.fechaNacimiento IS NOT NULL) AND (s.fecsol IS NOT NULL)) THEN
                              CONVERT(BIGINT, (DATEDIFF(mm, u.fechaNacimiento, s.fecsol)/12))
                          ELSE 
                              CONVERT(BIGINT, NULL)
                      END) --Edad a la fecha de solicitud --> cuando no hay solicitud, la edad queda en NULL
        FROM #UniversoFallecidosTMP_01 u 
            JOIN DDS.STP_MASOLPEN m ON (u.rut = m.numrut)
            JOIN #STP_SOLICPEN_TMP s ON (m.numcue = s.numcue)
        WHERE u.fecsol IS NULL;

        DROP TABLE #STP_SOLICPEN_TMP;


        /*Obteniendo la ultima solicitud de pensión antes de SOBREVIVENCIA*/
        --CGI-ahr-ini--
        --cantidad de registros = 30410 row(s) affected --
        --CGI-ahr-fin--
        --PARA SOLUCIONAR LA SITUACION AL FALLECER 
        SELECT fiv.numeroCuenta numcue,
            fiv.idPersona,
            dp.rut,
            u.fechaDefuncion,
            dtp.codigo codigoTipoPension,
            fiv.fechaSolicitud fecsol,
            (CASE 
                WHEN (dtp.codigo = cchCodigoTipoPension01) THEN
                    cinTipoBen2
                WHEN (dtp.codigo = cchCodigoTipoPension02) THEN
                    cinTipoBen1
                WHEN (dtp.codigo IN (cchCodigoTipoPension17, cchCodigoTipoPension18)) THEN
                    cinTipoBen3
                WHEN (dtp.codigo IN (cchCodigoTipoPension11, cchCodigoTipoPension12, cchCodigoTipoPension15, cchCodigoTipoPension16, cchCodigoTipoPension19)) THEN
                    cinTipoBen6
                WHEN (dtp.codigo IN (cchCodigoTipoPension13, cchCodigoTipoPension14)) THEN
                    cinTipoBen5
                ELSE
                    cinValor0
             END) tipoben,
            fiv.ingresoBaseUF,
            dtc.codigo codigoTipoCobertura,
            (CASE
                WHEN dtp.codigo NOT IN (cchCodigoTipoPension17, cchCodigoTipoPension18) THEN
                    cchNo
                WHEN dtp.codigo IN (cchCodigoTipoPension17, cchCodigoTipoPension18) AND u.fechaDefuncion BETWEEN fiv.fechaSolicitud AND CONVERT(DATE, (DATEADD(month, 42, fiv.fechaSolicitud))) THEN
                    cchNo
                ELSE
                    cchSi
             END) indEliminar
        INTO #UniversoSolPensionInvTMP
        FROM DMGestion.FctPensionadoInvalidezVejez fiv 
            INNER JOIN DMGestion.DimPersona dp ON (fiv.idPersona = dp.id)
            INNER JOIN DMGestion.DimTipoPension dtp ON (fiv.idTipoPension = dtp.id)
            INNER JOIN DMGestion.DimEstadoSolicitud des ON (fiv.idEstadoSolicitud = des.id)
            LEFT OUTER JOIN DMGestion.DimTipoCobertura dtc ON (dtc.id = fiv.idTipoCobertura) 
            INNER JOIN #UniversoFallecidosTMP_01 u ON (fiv.idPersona = u.idPersona)
        WHERE fiv.idperiodoinformado = linIdPeriodoInformar
        AND dtp.codigo NOT IN (cchCodigoTipoPension01, cchCodigoTipoPension02)
        AND des.codigo IN (ctiCodigoEstadoAprobado, ctiCodigoEstadoSinReevaluacion) --Aprobado o Sin Reevaluación
        AND fiv.fechaSolicitud <= u.fechaDefuncion;

        DELETE FROM #UniversoSolPensionInvTMP
        WHERE indEliminar = cchSi;
 
        SELECT fiv.numeroCuenta numcue,
            fiv.idPersona,
            dp.rut,
            dtp.codigo codigoTipoPension,
            fiv.fechaSolicitud fecsol,
            (CASE 
                WHEN (dtp.codigo = cchCodigoTipoPension01) THEN
                    cinTipoBen2
                WHEN (dtp.codigo = cchCodigoTipoPension02) THEN
                    cinTipoBen1
                WHEN (dtp.codigo IN (cchCodigoTipoPension17, cchCodigoTipoPension18)) THEN
                    cinTipoBen3
                WHEN (dtp.codigo IN (cchCodigoTipoPension11, cchCodigoTipoPension12, cchCodigoTipoPension15, cchCodigoTipoPension16, cchCodigoTipoPension19)) THEN
                    cinTipoBen6
                WHEN (dtp.codigo IN (cchCodigoTipoPension13, cchCodigoTipoPension14)) THEN
                    cinTipoBen5
                ELSE
                    cinValor0
             END) tipoben,
            fiv.ingresoBaseUF,
            dtc.codigo codigoTipoCobertura
        INTO #UniversoSolPensionVejezTMP
        FROM DMGestion.FctPensionadoInvalidezVejez fiv 
            INNER JOIN DMGestion.DimPersona dp ON (fiv.idPersona = dp.id)
            INNER JOIN DMGestion.DimTipoPension dtp ON (fiv.idTipoPension = dtp.id)
            INNER JOIN DMGestion.DimEstadoSolicitud des ON (fiv.idEstadoSolicitud = des.id)
            LEFT OUTER JOIN DMGestion.DimTipoCobertura dtc ON (dtc.id = fiv.idTipoCobertura) 
            INNER JOIN #UniversoFallecidosTMP_01 u ON (fiv.idPersona = u.idPersona)
        WHERE fiv.idperiodoinformado = linIdPeriodoInformar
            AND dtp.codigo IN (cchCodigoTipoPension01, cchCodigoTipoPension02)
            AND des.codigo = ctiCodigoEstadoAprobado --Aprobado
            AND fiv.fechaSolicitud <= u.fechaDefuncion;

        --No se informan las solicitudes por vejez, que tengan una solicitud de invalidez parcial
        --anterior a la fecha de solicitud de vejez
        SELECT a.rut,
            e.codigoTipoPension,
            e.fecsol
        INTO #PensionInvalidezTMP
        FROM #UniversoSolPensionInvTMP a
            INNER JOIN #UniversoSolPensionVejezTMP e ON (a.rut = e.rut)
        WHERE a.codigoTipoPension IN (cchCodigoTipoPension12, cchCodigoTipoPension14) --Solo invalidez definiva parcial
            AND a.fecsol < e.fecsol;

        DELETE FROM #UniversoSolPensionVejezTMP
        FROM #UniversoSolPensionVejezTMP a, #PensionInvalidezTMP b
        WHERE a.rut = b.rut
            AND a.fecsol = b.fecsol
            AND a.codigoTipoPension = b.codigoTipoPension;

        SELECT a.numcue,
            a.idPersona,
            a.rut,
            a.codigoTipoPension,
            a.fecsol,
            a.tipoben,
            a.ingresoBaseUF,
            a.codigoTipoCobertura
        INTO #UniversoSolPenVejezInvalidezTMP
        FROM ( 
            SELECT numcue,
                idPersona,
                rut,
                codigoTipoPension,
                fecsol,
                tipoben,
                ingresoBaseUF,
                codigoTipoCobertura
            FROM #UniversoSolPensionInvTMP
            UNION
            SELECT numcue,
                idPersona,
                rut,
                codigoTipoPension,
                fecsol,
                tipoben,
                ingresoBaseUF,
                codigoTipoCobertura
            FROM #UniversoSolPensionVejezTMP
        ) a;

        --Pensionado con invalidez Transitoria que tambien tienen una Pension por Vejez
        --Se elimina la Invaldiez Transitoria
        SELECT DISTINCT a.rut,
            a.fecsol,
            a.codigoTipoPension
        INTO #EliminaInvTranTMP
        FROM #UniversoSolPenVejezInvalidezTMP a
            INNER JOIN #UniversoSolPenVejezInvalidezTMP b ON (a.rut = b.rut)
        WHERE a.codigoTipoPension IN (cchCodigoTipoPension17, cchCodigoTipoPension18)
            AND b.codigoTipoPension IN (cchCodigoTipoPension01, cchCodigoTipoPension02);

        DELETE FROM #UniversoSolPenVejezInvalidezTMP
        FROM #UniversoSolPenVejezInvalidezTMP a, 
            #EliminaInvTranTMP b
        WHERE a.rut = b.rut
            AND a.fecsol = b.fecsol
            AND a.codigoTipoPension = b.codigoTipoPension;
        
        SELECT rank() OVER (PARTITION BY a.rut ORDER BY a.fecsol ASC) rankAnt,
            a.numcue,
            a.idPersona,
            a.rut,
            a.codigoTipoPension,
            a.fecsol,
            a.tipoben,
            a.ingresoBaseUF,
            a.codigoTipoCobertura
        INTO #UniversoSolicitudAnteriorTMP
        FROM (
            SELECT numcue,
                idPersona,
                rut,
                codigoTipoPension,
                fecsol,
                tipoben,
                ingresoBaseUF,
                codigoTipoCobertura
            FROM #UniversoSolPenVejezInvalidezTMP
        ) a;
        
        DELETE FROM #UniversoSolicitudAnteriorTMP
        WHERE rankAnt > cinUno;
 
        --CGI-ahr-ini--
        --cantidad de registros = 82090 row(s) affected de la tabla #UNIVERSO_FALLECIDOS_A
        --Se elimina el idTipoRol por requerimiento de la nueva circular 1661
        --CGI-ahr-fin--
        SELECT u.fechaDefuncion,
            u.sexo, 
            u.ID_MAE_PERSONA,
            u.fechaNacimiento,
            u.rut,
            u.numcue,
            u.tipoben,
            u.fecsol,
            u.codestsol,
            u.fecha_codestsol,
            u.fedevpen,
            u.ingreso_base,
            u.promedio_rentas_120meses,
            u.nro_meses_con_renta,
            u.pension_referencia,
            u.modalidad,
            u.tipoGarantia,
            u.COD_CIASEG,
            u.subtipben,
            u.IND_COBERTURA_SEG_INVALIDEZ,
            u.PORCENTAJE_COBERTURA_SEG,
            u.edad,
            u.idPersona,
            sa.tipoben tipobenAnterior, 
            sa.fecsol fecsolAnterior,
            sa.ingresoBaseUF ingresoBaseInvalidezUF,
            sa.codigoTipoPension codigoTipoPensionAnterior,
            sa.codigoTipoCobertura codigoTipoCoberturaInvalidez,
            u.codigoTipoEstado
        INTO #UniversoFallecidosTMP_02
        FROM #UniversoFallecidosTMP_01 u
            LEFT OUTER JOIN #UniversoSolicitudAnteriorTMP sa ON (u.rut = sa.rut);

        DROP TABLE #UniversoFallecidosTMP_01;

        --CGI-ahr-ini--
        --cantidad de registros = 82090 row(s) affected de la tabla #UNIVERSO_FALLECIDOS_B
        --por requerimiento de la nueva circular 1661 se elimina idTipoRol
        --en los case al cumplirse asignan codigos que solicito la superintendencia para el campo
        --Situación del afiliado al fallecer (documento Nuevo_anexosBDA_v1-Circular1661
        --2.17.2 Descripción de códigos (a))
        --CGI-ahr-fin--

        /*** CAMBIO PAET ***/ 
        SELECT dp.rut into #paet
        FROM DMGestion.FctTramitePAET ftp
        INNER JOIN DMGestion.DimPersona dp ON dp.id = ftp.idPersonaAfiliado 
        INNER JOIN DMGestion.DimFecha   df ON df.id = ftp.idFechaSolicitud
        INNER JOIN DMGestion.DimEstadoSolicitud des ON des.id = ftp.idEstadoSolicitud 
        WHERE df.fecha <= ldtHastaFechaPeriodoInformar  AND fechaEstado <= ldtHastaFechaPeriodoInformar 
        AND upper(des.nombre) in (cchPAGADA,cchAPROBADA); 
    
        SELECT
            (CASE
                WHEN (u.codigoTipoPensionAnterior = '01' AND pt.rut IS NULL) THEN 
                    CONVERT(CHAR(2), '01') --Pensionado por Vejez Normal
                WHEN (u.codigoTipoPensionAnterior = '02' AND pt.rut IS NULL) THEN 
                    CONVERT(CHAR(2), '02') --Pensionado por Vejez Anticipada
                WHEN (u.codigoTipoPensionAnterior = '11') THEN
                    CONVERT(CHAR(2), '03') --Pensionado por Inválidez Total segundo dictamen o dictamen posterior
                WHEN (u.codigoTipoPensionAnterior = '12') THEN
                    CONVERT(CHAR(2), '04') --Pensionado por Inválidez Parcial segundo dictamen
                WHEN (u.codigoTipoPensionAnterior = '13') THEN
                    CONVERT(CHAR(2), '05') --Pensionado por Inválidez total previa
                WHEN (u.codigoTipoPensionAnterior = '14') THEN
                    CONVERT(CHAR(2), '06') --Pensionado por Inválidez Parcial Previa
                WHEN (u.codigoTipoPensionAnterior = '15') THEN
                    CONVERT(CHAR(2), '07') --Pensionado por inválidez cubierto por el seguro con anterioridad a la Ley 18.964 
                WHEN (u.codigoTipoPensionAnterior = '16') THEN
                    CONVERT(CHAR(2), '08') --Pensionado por Inválidez no cubierto por el seguro con anterioridad a la Ley 18.964
                WHEN ((u.codigoTipoPensionAnterior = '17') AND 
                      (u.fechaDefuncion BETWEEN u.fecsolAnterior AND CONVERT(DATE, (DATEADD(month, 42, u.fecsolAnterior))))) THEN
                    CONVERT(CHAR(2), '09') --Inválido total durante el periodo transitorio
                WHEN ((u.codigoTipoPensionAnterior = '18') AND 
                      (u.fechaDefuncion BETWEEN u.fecsolAnterior AND CONVERT(DATE, (DATEADD(month, 42, u.fecsolAnterior))))) THEN
                    CONVERT(CHAR(2), '10') --Inválido parcial durante periodo transitorio
                WHEN (u.codigoTipoPensionAnterior = '19' AND pt.rut IS NULL) THEN
                    CONVERT(CHAR(2), '12') --Pensionado por Inválidez Total Único Dictamen
                /***CAMBIO PAET NUEVOS CODIGOS 13-14-15***/    
                WHEN (u.codigoTipoPensionAnterior = cchCodigoTipoPension01 AND pt.rut IS NOT NULL) THEN 
                    CONVERT(CHAR(2), cchCodigoSituacionAfiliado14) --Pensionado por Vejez Normal  PAET
                WHEN (u.codigoTipoPensionAnterior = cchCodigoTipoPension02 AND pt.rut IS NOT NULL) THEN 
                    CONVERT(CHAR(2), cchCodigoSituacionAfiliado14) --Pensionado por Vejez Anticipada  PAET
                WHEN (u.codigoTipoPensionAnterior = cchCodigoTipoPension19 AND pt.rut IS NOT NULL) THEN
                    CONVERT(CHAR(2), cchCodigoSituacionAfiliado15) --Pensionado por Inválidez Total Único Dictamen PAET
               WHEN (u.codigoTipoPensionAnterior = cchCodigoTipoPension58 AND pt.rut IS NOT NULL) THEN
                    CONVERT(CHAR(2), cchCodigoSituacionAfiliado15) --Invalidez total único dictamen por enfermedad terminal  
                WHEN (u.codigoTipoPensionAnterior IS NULL AND pt.rut IS NOT NULL) THEN 
                    CONVERT(CHAR(2), cchCodigoSituacionAfiliado13) --Afiliado no pensionado PAET    
                ELSE 
                    CONVERT(CHAR(2), '11') --Afiliado no pensionado
             END
            ) codigoSituacionAfiliado,
            u.fechaDefuncion,
            u.sexo, 
            u.ID_MAE_PERSONA,
            u.fechaNacimiento,
            u.rut,
            u.numcue,
            u.tipoben,
            u.fecsol,
            u.codestsol,
            u.fecha_codestsol,
            u.fedevpen,
            u.ingreso_base,
            u.promedio_rentas_120meses,
            u.nro_meses_con_renta,
            u.pension_referencia,
            u.modalidad,
            u.tipoGarantia,
            u.COD_CIASEG,
            u.subtipben,
            u.IND_COBERTURA_SEG_INVALIDEZ,
            u.PORCENTAJE_COBERTURA_SEG,
            u.edad,
            u.idPersona,
            u.tipobenAnterior, 
            u.fecsolAnterior,
            u.ingresoBaseInvalidezUF,
            u.codigoTipoPensionAnterior,
            u.codigoTipoCoberturaInvalidez,
            u.codigoTipoEstado
        INTO #UniversoFallecidosTMP_03
        FROM #UniversoFallecidosTMP_02 u
        LEFT OUTER JOIN #paet pt ON pt.rut = u.rut;

        DROP TABLE #UniversoFallecidosTMP_02;

        --Inicio Jira INFESP-126
        SELECT DISTINCT rank() OVER (PARTITION BY a.rut ORDER BY b.fecsol DESC) rank,
            a.rut,
            a.idPersona,
            a.codigoSituacionAfiliado,
            a.fechaDefuncion,
            a.numcue,
            b.tipoben,
            b.fecsol
        INTO #PensionadosTraspTMP
        FROM #UniversoFallecidosTMP_03 a
            INNER JOIN DDS.SLB_BENEPAGO b ON (a.rut = b.numrut)
        WHERE a.codigoSituacionAfiliado IN (cchCodigoSituacionAfiliado11,cchCodigoSituacionAfiliado13) /* CAMBIO PAET*/
        AND a.codigoTipoEstado = cchCodigoTipoEstadoFallecido
        AND b.tipoben IN (cinTipoBen1, cinTipoBen2)
        AND b.fecsol <= a.fechaDefuncion;

        DELETE FROM #PensionadosTraspTMP 
        WHERE rank > cinUno;

        SELECT rut
        INTO #CasosDuplicadosPenTraspTMP
        FROM #PensionadosTraspTMP
        GROUP BY rut
        HAVING COUNT(*) > cinUno;

        DELETE FROM #PensionadosTraspTMP 
        FROM #PensionadosTraspTMP a,
            #CasosDuplicadosPenTraspTMP b
        WHERE a.rut = b.rut;

        UPDATE #UniversoFallecidosTMP_03 SET
            u.codigoSituacionAfiliado = (CASE b.tipoben
                                            WHEN cinTipoBen1 THEN
                                                cchCodigoSituacionAfiliado02
                                            WHEN cinTipoBen2 THEN
                                                cchCodigoSituacionAfiliado01
                                         END)
        FROM #UniversoFallecidosTMP_03 u
            JOIN #PensionadosTraspTMP b ON (u.rut = b.rut)
        WHERE u.codigoSituacionAfiliado = cchCodigoSituacionAfiliado11
        AND u.codigoTipoEstado = cchCodigoTipoEstadoFallecido;

        --Fin Jira INFESP-126
        ------------------
        --Aporte Adicional
        ------------------
        --CGI-ahr-ini--
        --cantidad de registros = 17954 row(s) affected de la tabla #MovimientoAporteAdicionalTMP
        --se crea un nuevo universo con el monto en pesos  y la fecha de movimiento 
        --de los aportes adicional de las companias de seguros
        --CGI-ahr-fin--
   
        SELECT u.id_mae_persona, 
            m.fec_movimiento, 
            SUM(m.monto_pesos) sumaMontoPesos
        INTO #MovimientoAporteAdicionalTMP
        FROM #UniversoFallecidosTMP_03 u
            INNER JOIN DDS.TB_MAE_MOVIMIENTO m ON (m.id_mae_persona = u.id_mae_persona) 
            INNER JOIN DDS.TB_TIP_MOVIMIENTO tm ON (m.id_tip_movimiento = tm.id_tip_movimiento)
        WHERE tm.cod_movimiento = 5 --Aporte adicional Compañia de seguros
        AND m.fec_acreditacion <= ldtHastaFechaPeriodoInformar
        GROUP BY u.id_mae_persona, m.fec_movimiento;

        --CGI-ahr-ini--
        --cantidad de registros = 17954 row(s) affected de la tabla #MovimientoAporteAdicionalUFTMP
        --se crea un nuevo universo con la fecha de movimiento, el monto en uf y el valor de la uf
        --de los aportes adicional de las companias de seguros   
        --CGI-ahr-fin--

        SELECT mf.id_mae_persona, 
            mf.fec_movimiento,
            (CASE 
                WHEN (vvuf.valorUF IS NULL) THEN 
                    0
                ELSE 
                    CONVERT(NUMERIC(22, 2), mf.sumaMontoPesos) / vvuf.valorUF
             END) sumaMontoUF,
            vvuf.valorUf
        INTO #MovimientoAporteAdicionalUFTMP
        FROM #MovimientoAporteAdicionalTMP mf
            INNER JOIN DMGestion.VistaValorUF vvuf ON (vvuf.fechaUF = mf.fec_movimiento);
        
        DROP TABLE #MovimientoAporteAdicionalTMP;

        --CGI-ahr-ini--
        --cantidad de registros = 15648 row(s) affected
        --CGI-ahr-fin--
        SELECT m.id_mae_persona,
            SUM(m.sumaMontoUF) sumaMontoUF
        INTO #MontoAporteAdicionalUFTMP
        FROM #MovimientoAporteAdicionalUFTMP m
        GROUP BY id_mae_persona;
        
        DROP TABLE #MovimientoAporteAdicionalUFTMP;

        -----------------------
        --Ingreso Base
        -----------------------
        --CGI-ahr-ini--
        --cantidad de registros = 98480 row(s) affected de la tabla #UNIVERSO_INGRESO_BASE  
        --CGI-ahr-fin--
        SELECT u.id_mae_persona,
            (CASE
                WHEN (u.tipoben = cinTipoBen8) THEN 
                    CONVERT(NUMERIC(20, 3), ISNULL(u.ingreso_base, 0)) --10-03-2014 CGI (+)
                ELSE 
                    CONVERT(NUMERIC(20, 3), cinValor0) --cero
             END) ingresoBase,
            CONVERT(NUMERIC(20, 3), cinValor0) ingresoBaseUF,                   --10-03-2014 CGI (-)
            (CASE
                WHEN (u.tipoBen = cinTipoBen8) THEN 
                    CONVERT(NUMERIC(20, 2), ISNULL(u.promedio_rentas_120meses, 0))
                ELSE CONVERT(NUMERIC(20, 2), cinValor0) --cero
             END) promedioRentas,
            CONVERT(NUMERIC(20, 2), cinValor0) promedioRentasUF,
            ISNULL(u.nro_meses_con_renta, cinValor0) numeroRemuneraciones,
            CONVERT(DATE, DATEADD(MONTH, -1, fecsol)) fechaAnterior,
            CONVERT(DATE, NULL) ultimoDiaHabilMesAnterior,
            CONVERT(NUMERIC(10, 2), cnuMontoCero) valorUF
        INTO #UniversoIngresoBaseTMP
        FROM #UniversoFallecidosTMP_03 u;

        SELECT DISTINCT fechaAnterior
        INTO #UniversoFechasTMP 
        FROM #UniversoIngresoBaseTMP;

        SELECT fechaAnterior,
            DMGestion.obtenerUltimaFechaMes(fechaAnterior) ultimoDiaMesAnterior
        INTO #UltimoDiaMesFechaAteriorTMP
        FROM #UniversoFechasTMP;

        DROP TABLE #UniversoFechasTMP;

        SELECT DISTINCT ultimoDiaMesAnterior
        INTO #UniversoFechasTMP
        FROM #UltimoDiaMesFechaAteriorTMP
        WHERE ultimoDiaMesAnterior IS NOT NULL;

        SELECT ultimoDiaMesAnterior,
            DMGestion.obtenerUltimoDiaHabilMes(ultimoDiaMesAnterior) ultimoDiaHabilMesAnterior
        INTO #UltimoDiaHabilMesAnteriorTMP
        FROM #UniversoFechasTMP;

        UPDATE #UniversoIngresoBaseTMP SET
            u.ultimoDiaHabilMesAnterior = b.ultimoDiaHabilMesAnterior
        FROM #UniversoIngresoBaseTMP u
            JOIN #UltimoDiaMesFechaAteriorTMP a ON (u.fechaAnterior = a.fechaAnterior)
            JOIN #UltimoDiaHabilMesAnteriorTMP b ON (a.ultimoDiaMesAnterior = b.ultimoDiaMesAnterior);

        SELECT DISTINCT vvuf.fechaUF,
            vvuf.valorUF
        INTO #VistaValorUFUltimoDiaHabilMesAntTMP
        FROM #UniversoIngresoBaseTMP a
            JOIN DMGestion.VistaValorUF vvuf ON (a.ultimoDiaHabilMesAnterior = vvuf.fechaUF);
        
        UPDATE #UniversoIngresoBaseTMP SET
            a.valorUF = vvuf.valorUF
        FROM #UniversoIngresoBaseTMP a
            JOIN #VistaValorUFUltimoDiaHabilMesAntTMP vvuf ON (a.ultimoDiaHabilMesAnterior = vvuf.fechaUF);        

        UPDATE #UniversoIngresoBaseTMP SET             
            ingresoBaseUF = ROUND((ingresoBase / valorUF),3)  --10-03-2014 CGI (+)
        WHERE ingresoBase > 0 ;

        UPDATE #UniversoIngresoBaseTMP SET 
            promedioRentasUF = (promedioRentas / valorUF)
        WHERE promedioRentas > 0 ;

        --CGI-ahr-ini--
        --cantidad de registros = 8328 row(s) affected  de la tabla #SLB_MONTOBEN_FALLECIDOS
        --se obtiene el ranking por numcue y ordenado por fec_ult_pago descendente
        --filtandro que la fecha ultimo pago sea menor a la fecha de defuncion  de la tabla #UNIVERSO_FALLECIDOS6
        --para obtiene la informacion de los montos  
        --CGI-ahr-fin--

        SELECT rank() OVER (PARTITION BY b.numcue ORDER BY b.fec_ult_pago DESC) rank, 
            b.numcue, 
            b.tipoben, 
            b.fecsol, 
            b.monto_obligatorio, 
            b.monto_voluntario, 
            b.monto_convenido, 
            b.monto_afi_voluntario,
            b.fec_ult_pago, 
            b.cod_vigencia, 
            b.modalidad
        INTO #SLB_MONTOBEN_FALLECIDOS
        FROM DDS.SLB_MONTOBEN b
            INNER JOIN #UniversoFallecidosTMP_03 u ON (u.numcue = b.numcue 
            AND u.tipobenAnterior = b.tipoben 
            AND u.fecsolAnterior = b.fecsol)
        WHERE b.fec_ult_pago < u.fechaDefuncion;

        DELETE FROM #SLB_MONTOBEN_FALLECIDOS 
        WHERE rank>1;
 
        --CGI-ahr-ini--
        --cantidad de registros = 7500 row(s) affected de la tabla #SLB_MONTOBEN_FALLECIDOS_SUMA 
        --CGI-ahr-fin--
        SELECT numcue,
            tipoben,
            fecsol, 
            SUM(ISNULL(monto_obligatorio, cinValor0)) + 
            SUM(ISNULL(monto_voluntario, cinValor0)) + 
            SUM(ISNULL(monto_convenido, cinValor0)) + 
            SUM(ISNULL(monto_afi_voluntario, cinValor0)) montoPension
        INTO #MontoPensionAnteriorTMP
        FROM #SLB_MONTOBEN_FALLECIDOS 
        GROUP BY numcue, tipoben, fecsol;
   
        ----------------------------------------------------------------------
        -- 6 Fecha de cálculo de la pensión de referencia
        --CGI-ahr-ini--
        --cantidad de registros = 14503 row(s) affected de la tabla #UNIVERSO_FECHAPEN 
        --CGI-ahr-fin--

        SELECT rank() OVER (PARTITION BY numcue ORDER BY fecsol DESC) rank,
            p.numcue,
            p.tipoben,
            p.fecsol,
            p.FEREALIZ
        INTO #FechaCalculoPensionRefTMP
        FROM DDS.STP_FECHAPEN p 
        WHERE codeven = 150 
            AND codesteve = 1 
            AND tipoben = cinTipoBen8 
            AND subtipben in (ctiSubtipobe801, ctiSubtipobe802);      
         
        DELETE FROM #FechaCalculoPensionRefTMP 
        WHERE RANK >1;

        --8 Fecha de cálculo del aporte adicionál
        --CGI-ahr-ini--
        --cantidad de registros = 41384 row(s) affected de la tabla #UNIVERSO_SOBREVIVENCIA3
        --Por requerimiento de la nueva circular 1661  se elimina el idTipoRol
        --CGI-ahr-fin--
        SELECT DISTINCT rank() OVER (PARTITION BY p.numcue ORDER BY p.fecsol DESC) rank,
            p.numcue,
            p.tipoben,
            p.fecsol,
            p.FEREALIZ
        INTO #FechaCalculoAporteAdicional01TMP
        FROM DDS.STP_FECHAPEN p 
        WHERE codeven IN (400, 420) 
        AND codesteve = 1 
        AND tipoben = cinTipoBen8
        AND subtipben in (ctiSubtipobe801, ctiSubtipobe802);

        DELETE FROM #FechaCalculoAporteAdicional01TMP 
        WHERE RANK >1;

        SELECT DISTINCT rank() OVER (PARTITION BY p.numcue, p.fecsol ORDER BY p.FEREALIZ DESC) rank,
            p.numcue,
            p.tipoben,
            p.fecsol,
            p.FEREALIZ
        INTO #FechaCalculoAporteAdicionalTMP
        FROM #FechaCalculoAporteAdicional01TMP p;

        DELETE FROM #FechaCalculoAporteAdicionalTMP 
        WHERE RANK >1;

        --Datos Calculo del CNU
        --Fecha del primer cálculo del capital necesario unitario
        --CGI-ahr-ini--
        --cantidad de registros = 341059 row(s) affected de la tabla #STP_PENCERSA_PER4
        --CGI-ahr-fin--
        
        --SALDOS
        CALL DMGestion.cargarUniversoSaldoPensionTMP();
       
        --19.1.3. Se obtiene la información de la tabla SLB_FICHAS_CALCULO_SALDO_MF
        SELECT a.numcue, 
            a.tipoben, 
            a.fecsol, 
            a.fechaCalculo
        INTO #FechaCalculoTMP
        FROM (
            SELECT u.numcue, 
                u.tipoben, 
                u.fecsol, 
                uT.fechaCalculo
            FROM #UniversoFallecidosTMP_03 u
                INNER JOIN DMGestion.UniversoSaldoPensionTMP uT ON u.numcue = uT.numcue
                AND u.fecsol = uT.fecsol
                AND u.tipoben = uT.tipoben
            WHERE uT.indicador = 'PER4'
            AND u.tipoBen = cinTipoBen8
            UNION
            SELECT u.numcue, 
                u.tipoben, 
                u.fecsol, 
                uT.fechaCalculo
            FROM #UniversoFallecidosTMP_03 u
                INNER JOIN DMGestion.UniversoSaldoPensionTMP uT ON u.numcue = uT.numcue
                AND u.fecsol = uT.fecsol
                AND u.tipoben = uT.tipoben
            WHERE uT.indicador = 'FICH'
            AND u.tipoBen = cinTipoBen8
        )a;

        --Fecha selección modalidad pensión
        SELECT p.numcue,
            p.tipoben,
            p.fecsol,
            p.fec_emision_selmod
        INTO #FechaSeleccionModTMP
        FROM DDS.STP_PENCERSA p
            INNER JOIN #UniversoFallecidosTMP_03 u ON (u.numcue = p.numcue 
            AND u.tipoben = p.tipoben 
            AND u.fecsol = p.fecsol)
        WHERE p.fec_emision_selmod IS NOT NULL
        AND u.tipoben = cinTipoBen8;

        --Fecha de emisión Certificado de Saldo que origina la selección de modalidad de pensión
        SELECT DISTINCT ant_fec_emision,
            ant_numrut
        INTO #STP_CSE_ANTECEDENTETMP
        FROM (SELECT MAX(ant_fec_emision) ant_fec_emision,ant_numrut 
              FROM DDS.STP_CSE_ANTECEDENTE 
              WHERE ant_tipo_pension = cchCodigoSO 
              and ant_cambio_modalidad = cchN
              GROUP BY ant_numrut) a
            INNER JOIN #UniversoFallecidosTMP_03 u ON (a.ant_numrut = u.rut)
        WHERE u.tipoben = cinTipoBen8;

        SELECT DISTINCT a.fecemi_cersal ant_fec_emision,
            u.rut ant_numrut
        INTO #STP_PERCESATMP
        FROM DDS.STP_PENCERSA a
            INNER JOIN #UniversoFallecidosTMP_03 u ON (a.numcue = u.numcue 
            AND a.tipoben = u.tipoben 
            AND a.fecsol = u.fecsol)
            LEFT OUTER JOIN #STP_CSE_ANTECEDENTETMP c on (c.ant_numrut = u.rut)
        where u.tipoben = cinTipoBen8
        and c.ant_numrut is null;

        SELECT a.ant_fec_emision,
            a.ant_numrut
        INTO #FechaEmisionCersalTMP
        FROM (
            SELECT ant_fec_emision,
                ant_numrut
            FROM #STP_CSE_ANTECEDENTETMP
            UNION
            SELECT ant_fec_emision,
                ant_numrut
            FROM #STP_PERCESATMP
        ) a;

        --Fecha de primer pago de pensión definitiva
       /* SELECT DISTINCT rank,
            numcue,
            fec_liquidacion
        INTO #FechaPrimerPagoPensionDefTMP
        FROM (
            SELECT RANK() OVER (PARTITION BY d.numcue ORDER BY fec_liquidacion ASC) rank, 
                d.numcue,
                d.fec_liquidacion
            FROM DDS.slb_docupago d
                INNER JOIN #UniversoFallecidosTMP_03 u ON (u.numcue=d.numcue 
                AND u.tipoben=d.tipoben 
                AND u.fecsol=d.fecsol)
            WHERE d.tipo_pago = 2 --definitivo
            AND d.fec_liquidacion IS NOT NULL
            AND u.tipoBen = 8
        )z;

        DELETE FROM #FechaPrimerPagoPensionDefTMP 
        WHERE rank>1;*/
    
        --Fecha de primer pago de pensión definitiva
    
        SELECT DISTINCT dp.rut,faf.fechaPrimerPagoPension,dp.cuentaAntigua numcue
            INTO #fechaPrimPagoModeloFall
        FROM DMGestion.FctAfiliadoFallecido faf
            INNER JOIN DMGestion.DimPersona dp ON dp.id = faf.idPersona
            INNER JOIN DMGestion.DimPeriodoInformado dpi ON dpi.id = faf.idPeriodoInformado 
        WHERE dpi.fecha = '20250501'
            AND fechaPrimerPagoPension IS NOT NULL;
    
        WITH primerPago AS ( 
            SELECT RANK() OVER (PARTITION BY d.numcue ORDER BY fec_liquidacion ASC) rk, 
                d.numcue,
                d.fec_liquidacion
            FROM DDS.SLB_DOCUPAGO d
                INNER JOIN #UniversoFallecidosTMP_03 u ON (u.numcue=d.numcue 
                AND u.tipoben=d.tipoben 
                AND u.fecsol=d.fecsol)
            WHERE d.tipo_pago = 2 --definitivo
            AND d.fec_liquidacion IS NOT NULL
            AND u.tipoBen = cinTipoBen8
        )
        SELECT DISTINCT numcue,fec_liquidacion
            INTO #FechaPrimerPagoPensionDef
        FROM primerPago
        WHERE rk = 1
            AND numcue NOT IN (SELECT numcue FROM #fechaPrimPagoModeloFall);
        
        --Fecha de primer pago de pensión definitiva para Fallecidos con Renta Vitalicia
        
        WITH primerPagoRV AS (
        SELECT DISTINCT dp.cuentaAntigua numcue,rutPersona, a.fec_acreditacion
        FROM DMGestion.UniversoMovimientosRVTMP a
            INNER JOIN DMGestion.DimPersona dp ON a.rutPersona = dp.rut AND dp.fechaVigencia >= cdtMaximaFechaVigencia
            INNER JOIN #UniversoFallecidosTMP_03 u ON (u.numcue = dp.cuentaAntigua  
                AND u.fecsol < a.fec_acreditacion
                AND u.tipoben = cinTipoBen8)
        WHERE a.fec_acreditacion > a.fechaDefuncion
            AND u.numcue NOT IN (SELECT numcue FROM #fechaPrimPagoModeloFall))
        SELECT numcue, DMGestion.obtenerFechaXdiaHabil(fec_acreditacion, 2) fechaPrimerPagoPension
       INTO #FechaPrimerPagoPensionDefRV
        FROM primerPagoRV;
        
        
        SELECT numcue, fechaPrimerPagoPension 
        INTO #FechaPrimerPagoPensionDefTMP
        FROM
            (SELECT numcue, fec_liquidacion AS fechaPrimerPagoPension FROM #FechaPrimerPagoPensionDef
                WHERE numcue NOT IN (SELECT numcue FROM #FechaPrimerPagoPensionDefRV)
            UNION 
            SELECT numcue, fechaPrimerPagoPension FROM #FechaPrimerPagoPensionDefRV
            UNION 
            SELECT numcue,fechaPrimerPagoPension  FROM #fechaPrimPagoModeloFall)a;
        
        ----------------------------------------------------------------------
        --Fecha emisión primera ficha de cálculo para RP
        SELECT z.fecsol,
            t.codtab,
            t.valtab
        INTO #TABLASYS_70
        FROM DDS.TABLASYS t
            INNER JOIN (SELECT DISTINCT fecsol 
                        FROM #UniversoFallecidosTMP_03
                        WHERE tipoben = cinTipoBen8) z ON (t.numitem = CONVERT(BIGINT, DATEFORMAT(z.fecsol, 'YYYYMM') || '01')) --yyyyMMdd
        WHERE CODTAB IN ('PENMINHM<70');
    
        SELECT z.fecsol,
            t.codtab,
            t.valtab
        INTO #TABLASYS_70_75
        FROM dds.TABLASYS t
            INNER JOIN (SELECT DISTINCT fecsol 
                        FROM #UniversoFallecidosTMP_03
                        WHERE tipoben = cinTipoBen8) z ON (t.numitem = CONVERT(BIGINT, DATEFORMAT(z.fecsol, 'YYYYMM') || '01')) --yyyyMMdd
        WHERE CODTAB IN ('PENMINHM>=70');
    
        SELECT z.fecsol,
            t.codtab,
            t.valtab
        INTO #TABLASYS_75
        FROM dds.TABLASYS t
        INNER JOIN (SELECT DISTINCT fecsol 
                    FROM #UniversoFallecidosTMP_03
                        WHERE tipoben = cinTipoBen8) z ON (t.numitem = CONVERT(BIGINT,DATEFORMAT(z.fecsol, 'YYYYMM') || '01' )) --yyyyMMdd
        WHERE CODTAB IN ('PENMINHM>=75');

        SELECT u.numcue,
            u.tipoben,
            u.fecsol,
            u.edad,
            u.fecha_codestsol,
           (CASE
                WHEN (u.edad <70) THEN
                    t.valtab
             END) pensionMinima
        INTO #UniversoSolicitudSobTMP
        FROM #UniversoFallecidosTMP_03 u
            LEFT OUTER JOIN #TABLASYS_70 t ON (u.fecsol = t.fecsol)
        WHERE u.tipoben = cinTipoBen8;
    
        UPDATE #UniversoSolicitudSobTMP u SET 
            u.pensionMinima = t.valtab
        FROM #TABLASYS_70_75 t
        WHERE t.fecsol=u.fecsol 
        AND u.edad BETWEEN 70 AND 75;
        
        UPDATE #UniversoSolicitudSobTMP u SET 
            u.pensionMinima = t.valtab
        FROM #TABLASYS_75 t
        WHERE t.fecsol=u.fecsol 
        AND u.edad > 75;
    
        --valor UF
        SELECT DISTINCT v.fechaUF,
            v.valorUF
        INTO #VistaValorUFFecsolTMP
        FROM #UniversoSolicitudSobTMP u
            JOIN DMGestion.VistaValorUF v ON (v.fechaUF = u.fecsol);

        UPDATE #UniversoSolicitudSobTMP SET 
            u.pensionMinima = u.pensionMinima / (CASE v.valorUF 
                                                    WHEN NULL THEN 1 
                                                    WHEN 0 THEN 1 
                                                    ELSE v.valorUF 
                                                 END)
        FROM #UniversoSolicitudSobTMP u
            JOIN #VistaValorUFFecsolTMP v ON (v.fechaUF = u.fecsol);

        SELECT RANK() OVER (PARTITION BY b.numcue ORDER BY b.fecsol DESC, b.modalidad ASC) rank, 
            b.numcue, 
            b.tipoben, 
            b.fecsol, 
            b.monto_obligatorio, 
            b.monto_voluntario, 
            b.monto_convenido, 
            b.monto_afi_voluntario
        INTO #SLB_MONTOBEN
        FROM DDS.SLB_MONTOBEN b
            INNER JOIN #UniversoSolicitudSobTMP u ON (u.numcue = b.numcue 
            AND u.tipoben = b.tipoben); --El universo ya está filtrado por sobrevivencia
        
        DELETE FROM #SLB_MONTOBEN 
        WHERE rank>1;

        SELECT numcue,
            tipoben,
            fecsol,
            SUM(ISNULL(monto_obligatorio, 0)) +
            SUM(ISNULL(monto_voluntario, 0)) +
            SUM(ISNULL(monto_convenido, 0)) +
            SUM(ISNULL(monto_afi_voluntario, 0)) montoPension
        INTO #MontoPensionTMP
        FROM #SLB_MONTOBEN 
        GROUP BY numcue, tipoben, fecsol;

        --Fecha emisión primera ficha de cálculo para RP - Campo 21
        SELECT u.numcue, 
               u.tipoben, 
               u.fecsol, 
               fc.fec_calculo fechaPrimeraFichaCalculo, 
               fc.fec_cierre, 
               fc.tipo_pago, 
               fc.tipo_ficha,
               fc.cod_estado
        INTO #FechaPrimerFichaCalculoTMP
        FROM DDS.SLB_FICHAS_CALCULO_MF fc
            INNER JOIN #UniversoSolicitudSobTMP u ON u.numcue = fc.numcue 
            AND u.tipoben = fc.tipoben_stp
            AND u.fecsol = fc.fecsol
        WHERE fc.tipo_ficha = 'RP'
        AND fc.tipo_pago = 2;

        DROP TABLE #UniversoSolicitudSobTMP;

        --Informado a Bienes Nacionales con herencia yacente o vacante
        --cantidad registro = 8412 row(s) affected
        SELECT DISTINCT rut, 
            UCASE(infBienesNacHerYacVaca) codigoEstadoBienesNacionales, 
            tipoBenOriginRegulariza,
            CONVERT(CHAR(2), '0' + ISNULL(CONVERT(CHAR(1), tipoBenOriginRegulariza), '0')) codigoTipoBenOriginRegulariza, 
            fecEnvioBienesNacionales, 
            fecRegularizacion
        INTO #BienesNacionalesTMP
        FROM DDS.BienesNacionales
        WHERE UCASE(infBienesNacHerYacVaca) IN ('Y', 'V');

        --Se Obtiene Universo de los movimientos 87 (Pago Prima Renta Vitalicia)
        
        SELECT DISTINCT id_mae_persona
        INTO #TB_MAE_MOVIMIENTO_87
        FROM DMGestion.UniversoMovimientosRVTMP;

        -- 6 Integrando campo MONTO TOTAL DEL APORTE EN UF y INGRESO BASE UF 
        --CGI-ahr-ini--
        --Por requerimiento de la nueva circular 1661  se elimina el idTipoRol
        --cambio efectuado por la nueva circular1661-- 
        --se agregan los campos requeridos (fechaSolicitudHerencia, fechaPagoHerencia, fechaSolCuotaMortuoria  --
        --fechaPagoCuotaMortuoria,fechaPagoPensionSob,indIngresoSCOMP,factorActuarialmenteJusto) --
        --CGI-ahr-fin--
        SELECT u.codigoSituacionAfiliado,
            u.fechaDefuncion,
            u.sexo, 
            u.id_mae_persona,
            u.fechaNacimiento,
            u.rut,
            u.numcue,
            u.tipoben,
            u.fecsol,
            u.codestsol,
            u.fecha_codestsol,
            u.fedevpen,
            u.ingreso_base,
            u.promedio_rentas_120meses,
            u.nro_meses_con_renta,
            u.modalidad,
            u.tipoGarantia,
            u.COD_CIASEG,
            u.subtipben,
            u.IND_COBERTURA_SEG_INVALIDEZ,
            u.PORCENTAJE_COBERTURA_SEG,
            u.edad,
            u.idPersona,
            u.tipobenAnterior, 
            u.fecsolAnterior,
            (CASE
                WHEN (u.codigoSituacionAfiliado IN ('01', '02', '03', '04', '05', '06', '08', '12',cchCodigoSituacionAfiliado15,cchCodigoSituacionAfiliado14)) THEN  /* CAMBIO PAET*/
                    CONVERT(CHAR(2), '03') --NO CUBIERTO
                WHEN (u.codigoSituacionAfiliado = '07') THEN 
                    CONVERT(CHAR(2), '01') --  TOTAL
                WHEN (u.tipoben = cinTipoBen8 AND u.subtipben IN (ctiSubtipobe801, ctiSubtipobe802)) THEN
                    CASE 
                        WHEN (u.PORCENTAJE_COBERTURA_SEG IN (35, 50)) THEN 
                            CONVERT(CHAR(2), '02') --parcial
                        WHEN (u.PORCENTAJE_COBERTURA_SEG = 70) THEN 
                            CONVERT(CHAR(2), '01')--total
                        ELSE 
                            CONVERT(CHAR(2), '99')--sin informacion
                    END
                ELSE 
                    CASE
                        WHEN ((u.IND_COBERTURA_SEG_INVALIDEZ=cchS) OR (u.cod_ciaseg > 0)) THEN
                            CASE 
                                WHEN (u.PORCENTAJE_COBERTURA_SEG IN (35, 50)) THEN 
                                    CONVERT(CHAR(2), '02') --parcial
                                WHEN (u.PORCENTAJE_COBERTURA_SEG = 70) THEN 
                                    CONVERT(CHAR(2), '01') --total
                                ELSE 
                                    CONVERT(CHAR(2), '99') --sin informacion
                            END
                        WHEN (u.numcue IS NOT NULL) THEN
                            CONVERT(CHAR(2), '03') --NO CUBIERTO
                        ELSE
                            CONVERT(CHAR(2), '99') --sin informacion
                    END                 
             END) codigoTipoCobertura,
            (CASE
                WHEN ((u.modalidad = 3) AND 
                      (u.tipoGarantia = 'SIMPLE') AND 
                      (u.COD_CIASEG IN (3, 7)) AND 
                      (codigoTipoCobertura IN ('01', '02')) AND
                      (m87.id_mae_persona IS NOT NULL)) THEN 
                    CONVERT(CHAR(2), cchCodigoModalidadPension07)
                WHEN (u.modalidad = 3 AND u.tipoGarantia = 'SIMPLE') THEN 
                    CONVERT(CHAR(2), cchCodigoModalidadPension01)
                WHEN (u.modalidad = 3 AND u.tipoGarantia = 'GARANTIZADA') THEN 
                    CONVERT(CHAR(2), cchCodigoModalidadPension02)
                WHEN (u.modalidad = 5 AND u.tipoGarantia = 'SIMPLE') THEN 
                    CONVERT(CHAR(2), cchCodigoModalidadPension03)
                WHEN (u.modalidad = 5 AND u.tipoGarantia = 'GARANTIZADA') THEN 
                    CONVERT(CHAR(2), cchCodigoModalidadPension04)
                WHEN (u.modalidad = 9 AND u.tipoGarantia = 'SIMPLE') THEN 
                    CONVERT(CHAR(2), cchCodigoModalidadPension05)
                WHEN (u.modalidad = 9 AND u.tipoGarantia = 'GARANTIZADA') THEN 
                    CONVERT(CHAR(2), cchCodigoModalidadPension06)
                WHEN (u.modalidad = 1) THEN 
                    CONVERT(CHAR(2), cchCodigoModalidadPension08)
                WHEN (u.modalidad = 6) THEN 
                    CONVERT(CHAR(2), cchCodigoModalidadPension09)
                WHEN (u.modalidad = 2) THEN 
                    CONVERT(CHAR(2), cchCodigoModalidadPension12)
                WHEN (u.modalidad IS NULL OR u.modalidad = 0) THEN 
                    CONVERT(CHAR(2), cchSinClasificar)
                ELSE 
                    CONVERT(CHAR(2), '00')
             END) codigoModalidadPension,
            (CASE
                WHEN (u.codigoSituacionAfiliado IN ('09', '10') AND
                      u.codigoTipoPensionAnterior IN ('11', '12', '13', '14', '15', '17', '18', '19') AND
                      u.codigoTipoCoberturaInvalidez IN ('01', '02')) THEN
                    ISNULL(u.ingresoBaseInvalidezUF, 0.0)
                WHEN (codigoTipoCobertura IN ('01', '02')) THEN
                    ISNULL(i.ingresoBaseUF, 0.0) 
                ELSE 0.0
             END) ingresoBaseUF,
            (CASE
                WHEN (codigoTipoCobertura IN ('03', '99')) THEN
                    ISNULL(i.promedioRentasUF, 0.0)
                ELSE 0.0
             END) promedioRentasUF,
            (CASE
                WHEN (codigoTipoCobertura IN ('01', '02')) THEN
                    ISNULL(i.numeroRemuneraciones, 0)
                ELSE 0
             END) numeroRemuneraciones,
            (CASE
                WHEN (codigoTipoCobertura IN ('01', '02')) THEN
                    ISNULL(u.pension_referencia, 0.0)
                ELSE 0.0
             END) pension_referencia,
            (CASE
                WHEN (codigoTipoCobertura IN ('01', '02') AND u.codigoSituacionAfiliado NOT IN ('03' , '04', '05', '06', '07')) THEN
                    ISNULL(m.sumaMontoUF, 0.0) 
                ELSE 0.0
             END) montoTotalAporte, 
            --ISNULL(m.sumaMontoUF, 0.0) montoTotalAporte,
            (CASE
                WHEN (u.tipoBen = cinTipoBen8) THEN
                    CONVERT(CHAR(2), '08')
                ELSE
                    CONVERT(CHAR(2), '00')
             END) codigoTipoPension,
            (CASE
                WHEN (u.tipoBen = cinTipoBen8) THEN
                    CONVERT(CHAR(2), '01')
                ELSE
                    CONVERT(CHAR(2), '00')
             END) codigoCausalRecalculo,
            (CASE
                WHEN (u.tipoBen = cinTipoBen8) THEN
                    CONVERT(CHAR(2), '01')
                ELSE
                    CONVERT(CHAR(2), '00')
             END) codigoTipoAnualidad,
            (CASE
                WHEN (u.tipoBen = cinTipoBen8) THEN
                    CONVERT(CHAR(2), '01')
                ELSE
                    CONVERT(CHAR(2), '00')
             END) codigoTipoRecalculo,
            (CASE
                WHEN (u.codigoSituacionAfiliado NOT IN (cchCodigoSituacionAfiliado11,cchCodigoSituacionAfiliado13)) THEN  /* CAMBIO PAET*/
                    ISNULL(b.montoPension, 0.0)
                ELSE 0.0
             END) montoPensionMesAnterior,
            (CASE
                WHEN (codigoTipoCobertura IN ('01', '02')) THEN
                    (CASE 
                        WHEN (p.FEREALIZ IS NULL) THEN u.fecsol
                        ELSE p.FEREALIZ
                     END)
                ELSE CONVERT(DATE, NULL)
             END) fechaCalPen,
            (CASE
                WHEN (codigoTipoCobertura IN ('01', '02')) THEN
                    (CASE 
                        WHEN (fcap.FEREALIZ IS NULL) THEN u.fecsol
                        ELSE fcap.FEREALIZ
                     END) 
                ELSE CONVERT(DATE, NULL)
             END) fechaCalAporte,
            ISNULL(fecs.ant_fec_emision, fpfc.fechaPrimeraFichaCalculo) fechaPrimerCalculoCNU,
            fpc.fechaCalculo,
            fsmp.FEC_EMISION_SELMOD fechaSelModPen,
            fecs.ant_fec_emision fechaEmisionCerSal,
            --CASE WHEN fpppd.fechaPrimerPagoPension <= ldtHastaFechaPeriodoInformar THEN fpppd.fechaPrimerPagoPension ELSE NULL END  fechaPrimerPagoPenDef,
            fpppd.fechaPrimerPagoPension fechaPrimerPagoPenDef,
            fpfc.fechaPrimeraFichaCalculo,
            (CASE
                WHEN (u.tipoBen = cinTipoBen8 AND bn.codigoEstadoBienesNacionales IS NOT NULL) THEN
                    bn.codigoEstadoBienesNacionales
                ELSE
                    CONVERT(CHAR(1), cchN) 
             END) codigoEstadoBienesNacionales,
            (CASE
                WHEN (u.tipoBen = cinTipoBen8 AND bn.codigoTipoBenOriginRegulariza IS NOT NULL) THEN
                    bn.codigoTipoBenOriginRegulariza
                ELSE
                    CONVERT(CHAR(2), '00')
             END) codigoTipoBenOriginRegulariza,
            (CASE
                WHEN (u.tipoBen = cinTipoBen8 AND bn.fecEnvioBienesNacionales IS NOT NULL) THEN
                    bn.fecEnvioBienesNacionales
                ELSE
                    CONVERT(DATE, NULL)
             END) fecEnvioBienesNacionales,
            (CASE
                WHEN (u.tipoBen = cinTipoBen8 AND bn.fecRegularizacion IS NOT NULL) THEN
                    bn.fecRegularizacion
                ELSE
                   CONVERT(DATE, NULL)
             END) fecRegularizacion,
            CONVERT(DATE,NULL) fechaSolicitudHerencia,
            CONVERT(DATE,NULL) fechaPagoHerencia,
            CONVERT(DATE,NULL) fechaSolCuotaMortuoria,
            CONVERT(DATE,NULL) fechaPagoCuotaMortuoria,
            CONVERT(DATE,NULL) fechaPagoPensionSob,
            CONVERT(CHAR(1), cchN) indIngresoSCOMP,
            CONVERT(NUMERIC(5, 4), 0.0) factorActuarialmenteJusto,
            CONVERT(NUMERIC(10, 2), 0.0) pensionMinimaUF,
            CONVERT(NUMERIC(10, 2), 0.0) pensionBasicaSolidariaUF
        INTO #UniversoFallecidosTMP_04
        FROM #UniversoFallecidosTMP_03 u
            LEFT OUTER JOIN #MontoAporteAdicionalUFTMP m ON (m.id_mae_persona = u.id_mae_persona)
            LEFT OUTER JOIN #UniversoIngresoBaseTMP i ON (i.id_mae_persona = u.id_mae_persona)
            LEFT OUTER JOIN #MontoPensionAnteriorTMP b ON (u.numcue = b.numcue 
            AND u.tipobenAnterior = b.tipoben 
            AND u.fecsolAnterior = b.fecsol)
            LEFT OUTER JOIN #FechaCalculoPensionRefTMP p ON (u.numcue = p.numcue 
            AND u.tipoben = p.tipoben 
            AND u.fecsol = p.fecsol)
            LEFT OUTER JOIN #FechaCalculoAporteAdicionalTMP fcap ON (u.numcue = fcap.numcue 
            AND u.tipoben = fcap.tipoben 
            AND u.fecsol = fcap.fecsol)
            LEFT OUTER JOIN #FechaCalculoTMP fpc ON (u.numcue = fpc.numcue 
            AND u.tipoben = fpc.tipoben 
            AND u.fecsol = fpc.fecsol)
            LEFT OUTER JOIN #FechaSeleccionModTMP fsmp ON (u.numcue = fsmp.numcue 
            AND u.tipoben = fsmp.tipoben 
            AND u.fecsol = fsmp.fecsol)
            LEFT OUTER JOIN #FechaEmisionCersalTMP fecs ON (fecs.ant_numrut = u.rut)
            LEFT OUTER JOIN #FechaPrimerPagoPensionDefTMP fpppd ON (fpppd.numcue = u.numcue)
            LEFT OUTER JOIN #FechaPrimerFichaCalculoTMP fpfc ON (fpfc.numcue = u.numcue
            AND u.tipoben = fpfc.tipoben 
            AND u.fecsol = fpfc.fecsol)
            LEFT OUTER JOIN #BienesNacionalesTMP bn ON (u.rut = bn.rut)
            LEFT OUTER JOIN #TB_MAE_MOVIMIENTO_87 m87 ON (u.id_mae_persona = m87.id_mae_persona);

        --INICIO IESP-235
        --debido a que existen casos que no tienen modalidad de pension en la tabla pencersa, 
        --se obtiene de la tabla slb_beneficios
        SELECT DISTINCT a.idPersona, 
            a.codigoTipoPension,
            a.fecsol,
            a.tipoben,
            a.numcue,
            b.modalidad,
            b.tipo_pago
        INTO #SLB_Beneficios_Universo01_TMP
        FROM #UniversoFallecidosTMP_04 a   
            INNER JOIN DDS.SLB_BENEFICIOS b ON (a.numcue = b.numcue
            AND a.tipoben = b.tipoben)
        WHERE (a.fecsol = b.fecsol OR a.fedevpen = b.fecsol)
        AND a.codigoModalidadPension = '0'
        AND b.tipo_pago = 2;

        SELECT idPersona, 
            codigoTipoPension,
            numcue, 
            tipoben, 
            fecsol, 
            MIN(modalidad) modalidad, 
            COUNT(*) cantidadRegistrosIguales
        INTO #SLB_Beneficios_Universo01_Menor_TMP
        FROM #SLB_Beneficios_Universo01_TMP
        GROUP BY idPersona, codigoTipoPension, numcue, tipoben, fecsol
        HAVING cantidadRegistrosIguales > 1;
    
        DELETE FROM #SLB_Beneficios_Universo01_TMP
        FROM #SLB_Beneficios_Universo01_TMP a, #SLB_Beneficios_Universo01_Menor_TMP b
        WHERE a.idPersona = b.idPersona
        AND a.codigoTipoPension = b.codigoTipoPension
        AND a.numcue = b.numcue
        AND a.tipoben = b.tipoben
        AND a.fecsol = b.fecsol 
        AND a.modalidad = b.modalidad;

        UPDATE #UniversoFallecidosTMP_04 SET
            a.codigoModalidadPension = (CASE b.modalidad
                                            WHEN 1 THEN CONVERT(CHAR(2), cchCodigoModalidadPension08)
                                            WHEN 3 THEN CONVERT(CHAR(2), cchCodigoModalidadPension01)
                                            WHEN 5 THEN CONVERT(CHAR(2), cchCodigoModalidadPension03)
                                            WHEN 2 THEN CONVERT(CHAR(2), cchCodigoModalidadPension12)
                                            ELSE cchSinClasificar
                                        END),
            a.modalidad = b.modalidad
        FROM #UniversoFallecidosTMP_04 a
            JOIN #SLB_Beneficios_Universo01_TMP b ON (a.idPersona = b.idPersona
            AND a.codigoTipoPension = b.codigoTipoPension
            AND a.numcue = b.numcue
            AND a.tipoben = b.tipoben
            AND a.fecsol = b.fecsol)
        WHERE a.codigoModalidadPension = cchSinClasificar
        AND a.codigoTipoPension = '08';

        UPDATE #UniversoFallecidosTMP_04 SET 
            u.codigoModalidadPension = cchCodigoModalidadPension01,
            u.modalidad = 3
        FROM #UniversoFallecidosTMP_04 u
            JOIN DMGestion.UniversoMovimientosRVTMP m ON (u.id_mae_persona = m.id_mae_persona)
        WHERE u.codigoModalidadPension = cchSinClasificar
        AND u.codigoTipoPension = '08'
        AND m.fec_movimiento >= u.fecsol;

        --Reemplaza el codigo de modalidad de pensión obtenedida por la modalidad de pension ingresada en la tabla 
        --Tramite de pension aprobada con datos incompletos
        UPDATE #UniversoFallecidosTMP_04 SET
            a.codigoModalidadPension    = b.codigoModalidadPensionReemplazar,
            a.modalidad                 = b.codigoModalidadAFPReemplazar
        FROM #UniversoFallecidosTMP_04 a
            JOIN DDS.TramitePensionAprobadoDatoIncompleto b ON (a.rut = b.rut
            AND a.fecsol = b.fechaSolicitud
            AND a.tipoben = b.tipoBeneficio
            AND a.codigoModalidadPension = b.codigoModalidadPension)
        WHERE b.indRegistroInformar             = cchSi
        AND b.indInfModalidadPensionReemplazar  = cchSi
        AND b.tramitePension                    = cchCodigoSO
        AND a.tipoben                           = cinTipoBen8;

        -- Casos sin modalidad se deja por defecto RP (08)
        UPDATE #UniversoFallecidosTMP_04 SET 
            u.codigoModalidadPension = cchCodigoModalidadPension08,
            u.modalidad = ctiModalidad1
        FROM #UniversoFallecidosTMP_04 u 
        WHERE u.codigoModalidadPension = cchSinClasificar
            AND u.tipoben = cinTipoBen8;
        --TERMINO IESP-235

        --Compañias de seguro
        SELECT DISTINCT u.numcue,
            u.tipoben,
            u.fecsol,
            c.id idTipoContrato
        INTO #ContratoTMP
        FROM DMGestion.DimTipoContrato c, #UniversoFallecidosTMP_04 u
        WHERE u.fechaDefuncion BETWEEN c.fechaInicioContrato AND c.fechaFinContrato 
            AND u.sexo = c.sexo 
            AND u.tipoben =  cinTipoBen8--sobrevivencia
            AND c.fechaVigencia >= cdtMaximaFechaVigencia;
   
        ------------------------------------------------
        --Universo Registrar 
        ------------------------------------------------
        SELECT CONVERT(BIGINT, NULL) numeroFila,
            u.idPersona, 
            dsf.id idSituacionFallecimiento,
            dmp.id idModalidadPension, 
            dtc.id idTipoCobertura,
            debn.id idEstadoBienesNacionales, 
            dtbr.id idTipoBeneficioRegularizacion,
            dtp.id idTipoPension, 
            dcr.id idCausalRecalculo, 
            dta.id idTipoAnualidad, 
            dtr.id idTipoRecalculo,
            ISNULL(c.idTipoContrato, 0) idTipoContrato,
            u.codigoSituacionAfiliado,
            u.fechaDefuncion,
            u.id_mae_persona,
            u.rut,
            u.numcue,
            u.tipoben,
            u.fecsol,
            u.fedevpen,
            u.modalidad,
            u.subtipben,
            u.edad,       
            u.codigoModalidadPension,
            u.codigoTipoCobertura,
            ISNULL(u.ingresoBaseUF, 0.0) ingresoBaseUF,
            ISNULL(u.promedioRentasUF, 0.0) promedioRentasUF,
            ISNULL(u.numeroRemuneraciones, 0) numeroRemEfectiva,
            ISNULL(u.pension_referencia, 0.0) montoPensionRefUF, 
            ISNULL(u.montoTotalAporte, 0.0) montoAporteAdiUF,
            u.codigoTipoPension,
            u.codigoCausalRecalculo,
            u.codigoTipoAnualidad,
            u.codigoTipoRecalculo,
            u.montoPensionMesAnterior,
            u.fechaCalPen fechaCalculoPensionRef,
            u.fechaCalAporte fechaCalculoAporteAdi,
            u.fechaPrimerCalculoCNU,
            u.fechaCalculo,
            u.fechaSelModPen fechaSeleccionModalidad,
            u.fechaEmisionCerSal fechaCertificadoSaldo,
            u.fechaPrimerPagoPenDef fechaPrimerPagoPension,
            u.fechaPrimeraFichaCalculo fechaPrimerFichaCalculoRP,
            u.codigoEstadoBienesNacionales,
            u.codigoTipoBenOriginRegulariza,
            u.fecEnvioBienesNacionales fechaInformeBienNacional,
            u.fecRegularizacion fechaSolicitudBeneficio,
            u.fechaSolicitudHerencia,
            u.fechaPagoHerencia,
            u.fechaSolCuotaMortuoria,
            u.fechaPagoCuotaMortuoria,
            u.fechaPagoPensionSob,
            u.indIngresoSCOMP,
            u.factorActuarialmenteJusto,
            u.pensionMinimaUF,
            u.pensionBasicaSolidariaUF,
            (CASE
                WHEN (u.tipoben = cinTipoBen8) THEN
                    u.fecsol
             END) fechaSolPensionSob,
            u.PORCENTAJE_COBERTURA_SEG,
            CONVERT(CHAR(1), cchN) compPM_PBS,
            CONVERT(DATE, NULL) fechaCierre,
            CONVERT(NUMERIC(7, 2), 0.0) montoPrimPensDefRTUF,
            CONVERT(BIGINT, NULL) idError,
            CONVERT(INTEGER, 0)estadoSolicitud
        INTO #UniversoRegistro
        FROM #UniversoFallecidosTMP_04 u
            INNER JOIN DMGestion.DimTipoPension dtp ON (u.codigoTipoPension = dtp.codigo)
            INNER JOIN DMGestion.DimSituacionFallecimiento dsf ON (dsf.codigo = u.codigoSituacionAfiliado)
            INNER JOIN DMGestion.DimModalidadPension dmp ON (dmp.codigo = u.codigoModalidadPension)
            INNER JOIN DMGestion.DimTipoCobertura dtc ON (dtc.codigo = u.codigoTipoCobertura)
            INNER JOIN DMGestion.DimEstadoBienesNacionales debn ON (u.codigoEstadoBienesNacionales = debn.codigo)
            INNER JOIN DMGestion.DimTipoBeneficioRegularizacion dtbr ON (u.codigoTipoBenOriginRegulariza = dtbr.codigo)
            INNER JOIN DMGestion.DimCausalRecalculo dcr ON (u.codigoCausalRecalculo = dcr.codigo
            AND dcr.tipoPension = u.codigoTipoPension)
            INNER JOIN DMGestion.DimTipoAnualidad dta ON (u.codigoTipoAnualidad = dta.codigo)
            INNER JOIN DMGestion.DimTipoRecalculo dtr ON (u.codigoTipoRecalculo = dtr.codigo)
            LEFT OUTER JOIN #ContratoTMP c ON (u.numcue = c.numcue
            AND u.fecsol = c.fecsol
            AND u.tipoben = c.tipoben)
        WHERE dsf.fechaVigencia >= cdtMaximaFechaVigencia
        AND dmp.fechaVigencia >= cdtMaximaFechaVigencia
        AND dtc.fechaVigencia >= cdtMaximaFechaVigencia
        AND debn.fechaVigencia >= cdtMaximaFechaVigencia
        AND dtbr.fechaVigencia >= cdtMaximaFechaVigencia
        AND dtp.fechaVigencia >= cdtMaximaFechaVigencia
        AND dcr.fechaVigencia >= cdtMaximaFechaVigencia
        AND dta.fechaVigencia >= cdtMaximaFechaVigencia
        AND dtr.fechaVigencia >= cdtMaximaFechaVigencia;
        
        /*INICIO JIRA - IESP-58*/
        --Fecha Emisión Certificado de Saldo que origina la  selección de modalidad de pensión
        --Para los casos que no se pudo obtener la Fecha emisión certificado de saldo
        --cantidad registro = 11956 row(s) affected
        SELECT a.numcue,
            u.idPersona,
            a.tipoben,
            u.fecsol,
            MAX(a.ferealiz) ferealiz
        INTO #FechaEmisionCertifSaldoTMP
        FROM DDS.STP_FECHAPEN a
            INNER JOIN #UniversoRegistro u ON (a.numcue = u.numcue
            AND a.tipoben = u.tipoben
            AND a.fecsol = u.fecsol)
        WHERE a.ferealiz IS NOT NULL
        AND u.tipoben = cinTipoBen8
        AND a.codeven = 500
        AND u.fechaCertificadoSaldo IS NULL
        AND u.codigoModalidadPension IN (cchCodigoModalidadPension01, cchCodigoModalidadPension02, cchCodigoModalidadPension03, 
                                        cchCodigoModalidadPension04, cchCodigoModalidadPension05, cchCodigoModalidadPension06, 
                                        cchCodigoModalidadPension07, cchCodigoModalidadPension08, cchCodigoModalidadPension09, cchCodigoModalidadPension11)
        GROUP BY a.numcue, u.idPersona, a.tipoben, u.fecsol; 

        UPDATE #UniversoRegistro SET
            u.fechaCertificadoSaldo = f.ferealiz
        FROM #UniversoRegistro u
            JOIN #FechaEmisionCertifSaldoTMP f ON (u.numcue = f.numcue
            AND u.idPersona = f.idPersona
            AND u.tipoben = f.tipoben
            AND u.fecsol = f.fecsol)
        WHERE u.fechaCertificadoSaldo IS NULL
        AND u.codigoModalidadPension  IN (cchCodigoModalidadPension01, cchCodigoModalidadPension02, cchCodigoModalidadPension03, 
                                        cchCodigoModalidadPension04, cchCodigoModalidadPension05, cchCodigoModalidadPension06, 
                                        cchCodigoModalidadPension07, cchCodigoModalidadPension08, cchCodigoModalidadPension09, cchCodigoModalidadPension11);

        --Fecha de selección de modalidad de pensión 
        --Para los que no se pudo obtener la Fecha de selección de modalidad de pensión.
        SELECT a.numcue,
            u.idPersona,
            a.tipoben,
            u.fecsol,
            MAX(a.ferealiz) ferealiz
        INTO #FechaSelecModPenTMP
        FROM DDS.STP_FECHAPEN a
            INNER JOIN #UniversoRegistro u ON (a.numcue = u.numcue
            AND a.tipoben = u.tipoben
            AND a.fecsol = u.fecsol)
        WHERE a.ferealiz IS NOT NULL
        AND u.tipoben = cinTipoBen8
        AND a.codeven = 600
        AND u.fechaSeleccionModalidad IS NULL
        AND u.codigoModalidadPension IN (cchCodigoModalidadPension01, cchCodigoModalidadPension02, cchCodigoModalidadPension03, 
                                        cchCodigoModalidadPension04, cchCodigoModalidadPension05, cchCodigoModalidadPension06, 
                                        cchCodigoModalidadPension07, cchCodigoModalidadPension08, cchCodigoModalidadPension09)
        GROUP BY a.numcue, u.idPersona, a.tipoben, u.fecsol; 
    
        UPDATE #UniversoRegistro SET
            u.fechaSeleccionModalidad = f.ferealiz
        FROM #UniversoRegistro u
            JOIN #FechaSelecModPenTMP f ON (u.numcue = f.numcue
            AND u.idPersona = f.idPersona
            AND u.tipoben = f.tipoben
            AND u.fecsol = f.fecsol)
        WHERE u.fechaSeleccionModalidad IS NULL
            AND u.codigoModalidadPension  IN (cchCodigoModalidadPension01, cchCodigoModalidadPension02, cchCodigoModalidadPension03, 
                                            cchCodigoModalidadPension04, cchCodigoModalidadPension05, cchCodigoModalidadPension06, 
                                            cchCodigoModalidadPension07, cchCodigoModalidadPension08, cchCodigoModalidadPension09);
    
        
    
        /******** LOGICA DE FECHA DE PRIMER PAGO DE PENSION DEFINITIVA **********/

        
        SELECT a.numcue,
            a.idPersona,
            a.tipoben,
            a.modalidad,
            a.fecsol,
            MIN(a.fec_primer_pago) fec_primer_pago 
        INTO #FechaPrimerPagoPensionTMP
        FROM (
            SELECT u.numcue,
                u.idPersona,
                u.tipoben,
                u.modalidad,
                u.fecsol,
                a.fec_primer_pago
            FROM DDS.SLB_MONTOBEN a 
                INNER JOIN #UniversoRegistro u ON (a.numcue = u.numcue
                AND a.modalidad = u.modalidad
                AND a.tipoben = u.tipoben
                AND a.fecsol = u.fedevpen)
            WHERE a.fec_primer_pago IS NOT NULL
                AND u.fechaPrimerPagoPension IS NULL
                AND u.tipoben = cinTipoBen8
            UNION
            SELECT u.numcue,
                u.idPersona,
                u.tipoben,
                u.modalidad,
                u.fecsol,
                a.fec_primer_pago
            FROM DDS.SLB_MONTOBEN a 
                INNER JOIN #UniversoRegistro u ON (a.numcue = u.numcue
                AND a.modalidad = u.modalidad
                AND a.tipoben = u.tipoben
                AND a.fecsol = u.fecsol)
            WHERE a.fec_primer_pago IS NOT NULL
                AND u.fechaPrimerPagoPension IS NULL
                AND u.tipoben = cinTipoBen8
        ) a
        GROUP BY a.numcue, a.idPersona, a.tipoben, a.modalidad, a.fecsol;
     
        UPDATE #UniversoRegistro SET
            u.fechaPrimerPagoPension = CASE WHEN fpp.fec_primer_pago <= ldtHastaFechaPeriodoInformar THEN fpp.fec_primer_pago ELSE NULL END 
        FROM #UniversoRegistro u
            JOIN #FechaPrimerPagoPensionTMP fpp ON (fpp.numcue = u.numcue
                AND fpp.modalidad = u.modalidad
                AND fpp.tipoben = u.tipoben
                AND fpp.fecsol = u.fecsol
                AND fpp.idPersona = u.idPersona)
        WHERE u.fechaPrimerPagoPension IS NULL;
    
        DROP TABLE #FechaPrimerPagoPensionTMP;
    
        
        --ELIMINA LOGICA PRIMER PAGO
        /*SELECT a.numcue,
            u.idPersona,
            a.tipoben,
            u.fecsol,
            MAX(a.ferealiz) ferealiz
        INTO #FechaPrimerPagoPensionTMP
        FROM DDS.STP_FECHAPEN a
            INNER JOIN #UniversoRegistro u ON (a.numcue = u.numcue
            AND a.tipoben = u.tipoben
            AND a.fecsol = u.fecsol)
        WHERE a.ferealiz IS NOT NULL
        AND a.codeven IN (998, 999)
        AND a.tipoben = 8
        AND u.fechaPrimerPagoPension IS NULL
        GROUP BY a.numcue, u.idPersona, a.tipoben, u.fecsol; 
    
        UPDATE #UniversoRegistro SET
            u.fechaPrimerPagoPension = CASE WHEN fpp.ferealiz <= ldtHastaFechaPeriodoInformar THEN fpp.ferealiz ELSE NULL END 
        FROM #UniversoRegistro u
            JOIN #FechaPrimerPagoPensionTMP fpp ON (fpp.numcue = u.numcue
            AND fpp.tipoben = u.tipoben
            AND fpp.fecsol = u.fecsol
            AND fpp.idPersona = u.idPersona)
        WHERE u.fechaPrimerPagoPension IS NULL;

        DROP TABLE #FechaPrimerPagoPensionTMP;*/

        --Fecha Emisión primera ficha de cálculo para RP
        SELECT a.numcue,
            u.idPersona,
            a.tipoben,
            u.fecsol,
            MAX(a.ferealiz) ferealiz
        INTO #FechaEmisionPrimeraFCTMP
        FROM DDS.STP_FECHAPEN a
            INNER JOIN #UniversoRegistro u ON (a.numcue = u.numcue
            AND a.tipoben = u.tipoben
            AND a.fecsol = u.fecsol)
        WHERE a.ferealiz IS NOT NULL
            AND a.codeven IN (998, 999)
            AND u.tipoBen = cinTipoBen8
            AND u.codigoModalidadPension IN (cchCodigoModalidadPension03, cchCodigoModalidadPension04, cchCodigoModalidadPension05, cchCodigoModalidadPension06, cchCodigoModalidadPension08,cchCodigoModalidadPension09)
            AND u.fechaPrimerFichaCalculoRP IS NULL
        GROUP BY a.numcue, u.idPersona, a.tipoben, u.fecsol; 
    
        UPDATE #UniversoRegistro SET
            u.fechaPrimerFichaCalculoRP = fpp.ferealiz
        FROM #UniversoRegistro u
            JOIN #FechaEmisionPrimeraFCTMP fpp ON (fpp.numcue = u.numcue
                AND fpp.tipoben = u.tipoben
                AND fpp.fecsol = u.fecsol
                AND fpp.idPersona = u.idPersona)
        WHERE u.codigoModalidadPension IN (cchCodigoModalidadPension03, cchCodigoModalidadPension04, cchCodigoModalidadPension05, cchCodigoModalidadPension06, cchCodigoModalidadPension08,cchCodigoModalidadPension09)
            AND u.fechaPrimerFichaCalculoRP IS NULL;

        SELECT a.numcue,
            u.idPersona,
            a.tipoben,
            u.fecsol,
            MAX(a.ferealiz) ferealiz
        INTO #FechaEmisionPrimeraFCEve500TMP
        FROM DDS.STP_FECHAPEN a
            INNER JOIN #UniversoRegistro u ON (a.numcue = u.numcue
            AND a.tipoben = u.tipoben
            AND a.fecsol = u.fecsol)
        WHERE a.ferealiz IS NOT NULL
            AND a.codeven = 500
            AND u.tipoBen = cinTipoBen8
            AND u.codigoModalidadPension IN (cchCodigoModalidadPension03, cchCodigoModalidadPension04, cchCodigoModalidadPension05, cchCodigoModalidadPension06, cchCodigoModalidadPension08,cchCodigoModalidadPension09)
            AND u.fechaPrimerFichaCalculoRP IS NULL
        GROUP BY a.numcue, u.idPersona, a.tipoben, u.fecsol; 

        UPDATE #UniversoRegistro SET
            u.fechaPrimerFichaCalculoRP = fpp.ferealiz
        FROM #UniversoRegistro u
            JOIN #FechaEmisionPrimeraFCEve500TMP fpp ON (fpp.numcue = u.numcue
            AND fpp.tipoben = u.tipoben
            AND fpp.fecsol = u.fecsol
            AND fpp.idPersona = u.idPersona)
        WHERE u.codigoModalidadPension IN (cchCodigoModalidadPension03, cchCodigoModalidadPension04, cchCodigoModalidadPension05, cchCodigoModalidadPension06, cchCodigoModalidadPension08,cchCodigoModalidadPension09)
            AND u.fechaPrimerFichaCalculoRP IS NULL;

        --y para los que se les cambiara la modalidad de pension
        UPDATE #UniversoRegistro SET
            a.fechaCertificadoSaldo     = b.fecEmiCertSaldoModPension,
            a.fechaSeleccionModalidad   = b.fechaSeleccionModPension,
            a.fechaPrimerFichaCalculoRP = b.fecEmis1FichaCalculoRP,
            a.fechaPrimerPagoPension    = (CASE WHEN (b.fecPrimerPagoPensionDef IS NOT NULL   AND a.fechaPrimerPagoPension IS NULL)  THEN b.fecPrimerPagoPensionDef      ELSE a.fechaPrimerPagoPension       END),
            a.montoPensionMesAnterior   = ISNULL(b.montoPrimPensDefUF, cnuMontoCero),
            a.codigoModalidadPension    = b.codigoModalidadPension,
            a.idModalidadPension        = cinValor0
        FROM #UniversoRegistro a
            JOIN DDS.TramitePensionAprobadoDatoIncompleto b ON (a.rut = b.rut
            AND a.fecsol = b.fechaSolicitud
            AND a.tipoben = b.tipoBeneficio)
        WHERE b.indRegistroInformar             = cchSi
            AND b.indInfModalidadPensionRecuperada  = cchSi
            AND b.tramitePension                    = cchCodigoSO
            AND a.tipoben                           = cinTipoBen8;

        UPDATE #UniversoRegistro SET
            a.idModalidadPension = b.id
        FROM #UniversoRegistro a
            JOIN DMGestion.DimModalidadPension b ON (a.codigoModalidadPension = b.codigo)
        WHERE a.idModalidadPension  = cinValor0
            AND a.tipoben               = cinTipoBen8
            AND b.fechaVigencia         >= cdtMaximaFechaVigencia;
        /*TERMINO JIRA - IESP-58*/

        --INI-JIRA-INFESP-255
        --Fecha de primer pago de pensión definitiva




        SELECT a.numcue,
            a.idPersona,
            a.tipoben,
            a.codigoModalidadPension,
            a.fecsol,
            MIN(a.fec_primer_pago) fec_primer_pago 
        INTO #FechaPrimerPagoPensionTMP
        FROM (
            SELECT u.numcue,
                u.idPersona,
                u.tipoben,
                u.codigoModalidadPension,
                u.fecsol,
                a.fec_primer_pago
            FROM DDS.SLB_MONTOBEN a 
                INNER JOIN #UniversoRegistro u ON (a.numcue = u.numcue
                    AND a.tipoben = u.tipoben
                    AND a.fecsol = u.fedevpen)
            WHERE u.modalidad = ctiModalidad1
                AND u.codigoModalidadPension IN (cchCodigoModalidadPension08, cchCodigoModalidadPension09)
                AND a.fec_primer_pago IS NOT NULL
                AND u.fechaPrimerPagoPension IS NULL
                AND u.tipoben = cinTipoBen8
            UNION
            SELECT u.numcue,
                u.idPersona,
                u.tipoben,
                u.codigoModalidadPension,
                u.fecsol,
                a.fec_primer_pago
            FROM DDS.SLB_MONTOBEN a 
                INNER JOIN #UniversoRegistro u ON (a.numcue = u.numcue
                    AND a.tipoben = u.tipoben
                    AND a.fecsol = u.fecsol)
            WHERE u.modalidad = ctiModalidad1
                AND u.codigoModalidadPension IN (cchCodigoModalidadPension08, cchCodigoModalidadPension09)
                AND a.fec_primer_pago IS NOT NULL
                AND u.fechaPrimerPagoPension IS NULL
                AND u.tipoben = cinTipoBen8
            UNION
            SELECT u.numcue,
                u.idPersona,
                u.tipoben,
                u.codigoModalidadPension,
                u.fecsol,
                a.fec_primer_pago
            FROM DDS.SLB_MONTOBEN a 
                INNER JOIN #UniversoRegistro u ON (a.numcue = u.numcue
                    AND a.tipoben = u.tipoben
                    AND a.fecsol = u.fedevpen)
            WHERE u.modalidad = ctiModalidad5
                AND u.codigoModalidadPension IN (cchCodigoModalidadPension03, cchCodigoModalidadPension04)
                AND a.fec_primer_pago IS NOT NULL
                AND u.fechaPrimerPagoPension IS NULL
                AND u.tipoben = cinTipoBen8
            UNION
            SELECT u.numcue,
                u.idPersona,
                u.tipoben,
                u.codigoModalidadPension,
                u.fecsol,
                a.fec_primer_pago
            FROM DDS.SLB_MONTOBEN a 
                INNER JOIN #UniversoRegistro u ON (a.numcue = u.numcue
                    AND a.tipoben = u.tipoben
                    AND a.fecsol = u.fecsol)
            WHERE u.modalidad = ctiModalidad5
                AND u.codigoModalidadPension IN (cchCodigoModalidadPension03, cchCodigoModalidadPension04)
                AND a.fec_primer_pago IS NOT NULL
                AND u.fechaPrimerPagoPension IS NULL
                AND u.tipoben = cinTipoBen8
            UNION
            SELECT u.numcue,
                u.idPersona,
                u.tipoben,
                u.codigoModalidadPension,
                u.fecsol,
                a.fec_primer_pago
            FROM DDS.SLB_MONTOBEN a 
                INNER JOIN #UniversoRegistro u ON (a.numcue = u.numcue
                    AND a.tipoben = u.tipoben
                    AND a.fecsol = u.fedevpen)
            WHERE u.modalidad = ctiModalidad2
                AND u.codigoModalidadPension = cchCodigoModalidadPension12
                AND a.fec_primer_pago IS NOT NULL
                AND u.fechaPrimerPagoPension IS NULL
                AND u.tipoben = cinTipoBen8
            UNION
            SELECT u.numcue,
                u.idPersona,
                u.tipoben,
                u.codigoModalidadPension,
                u.fecsol,
                a.fec_primer_pago
            FROM DDS.SLB_MONTOBEN a 
                INNER JOIN #UniversoRegistro u ON (a.numcue = u.numcue
                    AND a.tipoben = u.tipoben
                    AND a.fecsol = u.fecsol)
            WHERE u.modalidad = ctiModalidad2
                AND u.codigoModalidadPension = cchCodigoModalidadPension12
                AND a.fec_primer_pago IS NOT NULL
                AND u.fechaPrimerPagoPension IS NULL
                AND u.tipoben = cinTipoBen8
            UNION
            SELECT u.numcue,
                u.idPersona,
                u.tipoben,
                u.codigoModalidadPension,
                u.fecsol,
                a.fec_primer_pago
            FROM DDS.SLB_MONTOBEN a 
                INNER JOIN #UniversoRegistro u ON (a.numcue = u.numcue
                    AND a.tipoben = u.tipoben
                    AND a.fecsol = u.fedevpen)
            WHERE u.modalidad IN (ctiModalidad1, ctiModalidad3)
                AND u.codigoModalidadPension IN (cchCodigoModalidadPension05, cchCodigoModalidadPension06)
                AND a.fec_primer_pago IS NOT NULL
                AND u.fechaPrimerPagoPension IS NULL
                AND u.tipoben = cinTipoBen8
            UNION
            SELECT u.numcue,
                u.idPersona,
                u.tipoben,
                u.codigoModalidadPension,
                u.fecsol,
                a.fec_primer_pago
            FROM DDS.SLB_MONTOBEN a 
                INNER JOIN #UniversoRegistro u ON (a.numcue = u.numcue
                AND a.tipoben = u.tipoben
                AND a.fecsol = u.fecsol)
            WHERE u.modalidad IN (ctiModalidad1, ctiModalidad3)
                AND u.codigoModalidadPension IN (cchCodigoModalidadPension05, cchCodigoModalidadPension06)
                AND a.fec_primer_pago IS NOT NULL
                AND u.fechaPrimerPagoPension IS NULL
                AND u.tipoben = cinTipoBen8
        ) a
        GROUP BY a.numcue, a.idPersona, a.tipoben, a.codigoModalidadPension, a.fecsol;
    
        UPDATE #UniversoRegistro SET
            u.fechaPrimerPagoPension = CASE WHEN fpp.fec_primer_pago <= ldtHastaFechaPeriodoInformar THEN fpp.fec_primer_pago ELSE NULL END
        FROM #UniversoRegistro u
            JOIN #FechaPrimerPagoPensionTMP fpp ON (fpp.numcue = u.numcue
            AND fpp.codigoModalidadPension = u.codigoModalidadPension
            AND fpp.tipoben = u.tipoben
            AND fpp.fecsol = u.fecsol
            AND fpp.idPersona = u.idPersona)
        WHERE u.fechaPrimerPagoPension IS NULL;
    
        DROP TABLE #FechaPrimerPagoPensionTMP;

    
       
        SELECT a.id_mae_persona,
            u.codigoModalidadPension,
            u.numcue,
            u.fecsol,
            u.tipoben,
            MIN(a.fec_movimiento) AS fec_movimiento
        INTO #FechaPrimerPagoPensionTMP
        FROM DDS.TB_MAE_MOVIMIENTO a
            INNER JOIN DDS.TB_TIP_MOVIMIENTO b ON (a.id_tip_movimiento = b.id_tip_movimiento)
            INNER JOIN DDS.TB_TIP_PRODUCTO c ON (a.id_tip_producto = c.id_tip_producto)
            INNER JOIN #UniversoRegistro u ON (a.id_mae_persona = u.id_mae_persona)
        WHERE b.cod_movimiento IN (cinCodigoTipoMov63, cinCodigoTipoMov66)
            AND c.cod_tip_producto = cchCodTipoProductoCCICO --CCICO
            AND a.fec_movimiento >= u.fecsol
            AND u.fecsol > cdtFecCorteNoPerfect
            AND u.fechaPrimerPagoPension IS NULL
            AND u.tipoben = cinTipoBen8
            AND u.codigoModalidadPension IN (cchCodigoModalidadPension08, cchCodigoModalidadPension09)
        GROUP BY a.id_mae_persona,
            u.codigoModalidadPension,
            u.numcue,
            u.fecsol,
            u.tipoben;

        UPDATE #UniversoRegistro SET
            u.fechaPrimerPagoPension = CASE WHEN fpp.fec_movimiento <= ldtHastaFechaPeriodoInformar THEN fpp.fec_movimiento ELSE NULL END
        FROM #UniversoRegistro u
            JOIN #FechaPrimerPagoPensionTMP fpp ON (fpp.numcue = u.numcue
            AND fpp.tipoben = u.tipoben
            AND fpp.fecsol = u.fecsol
            AND fpp.id_mae_persona = u.id_mae_persona
            AND fpp.codigoModalidadPension = u.codigoModalidadPension)
        WHERE u.fechaPrimerPagoPension IS NULL;

        DROP TABLE #FechaPrimerPagoPensionTMP;

        --FIN-JIRA-INFESP-255

        --INICIO - IESP-235
        --Monto de la primera pensión definitiva en Renta temporal, en UF
        SELECT DISTINCT u.tipoben,
            u.fecsol,
            u.numcue,
            fiv.montoPrimPensDefRTUF
        INTO #UniversoPensionadoTMP
        FROM DMGestion.FctPensionadoInvalidezVejez fiv 
            INNER JOIN DMGestion.DimModalidadPension dmp ON (fiv.idModalidadPension = dmp.id)
            INNER JOIN #UniversoRegistro u ON (fiv.idPersona = u.idPersona)
        WHERE fiv.idperiodoinformado = linIdPeriodoInformar
            AND dmp.codigo IN (cchCodigoModalidadPension03, cchCodigoModalidadPension04)
            AND fiv.montoPrimPensDefRTUF > 0.0
            AND u.codigoModalidadPension IN (cchCodigoModalidadPension03, cchCodigoModalidadPension04);

        UPDATE #UniversoRegistro SET
            u.montoPrimPensDefRTUF = m.montoPrimPensDefRTUF
        FROM #UniversoRegistro u
            INNER JOIN #UniversoPensionadoTMP m ON (m.tipoben = u.tipoben
            AND m.fecsol = u.fecsol
            AND m.numcue = u.numcue)
        WHERE u.codigoModalidadPension IN (cchCodigoModalidadPension03, cchCodigoModalidadPension04);

        --Universo 01 - STP_PENCERSA
        SELECT u.numcue,
            u.tipoben,
            u.fecsol,
            p.pension_rt_afil_uf
        INTO #MontoPrimeraPenDefRTUF_U1_TMP
        FROM DDS.STP_PENCERSA p
            INNER JOIN #UniversoRegistro u ON (p.tipoben = u.tipoben
                AND p.fecsol = u.fecsol
                AND p.numcue = u.numcue)
        WHERE p.tipoBen = cinTipoBen8
        AND p.modpen_selmod = 5
            AND u.codigoModalidadPension IN (cchCodigoModalidadPension03, cchCodigoModalidadPension04)
            AND ISNULL(u.montoPrimPensDefRTUF, 0) = 0
            AND ISNULL(p.pension_rt_afil_uf, 0) > 0;

        UPDATE #UniversoRegistro SET
            u.montoPrimPensDefRTUF = m.pension_rt_afil_uf
        FROM #UniversoRegistro u
            JOIN #MontoPrimeraPenDefRTUF_U1_TMP m ON (m.tipoben = u.tipoben
            AND m.fecsol = u.fecsol
            AND m.numcue = u.numcue)
        WHERE u.codigoModalidadPension IN (cchCodigoModalidadPension03, cchCodigoModalidadPension04);

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
            INNER JOIN #UniversoRegistro u ON (m.id_mae_persona = u.id_mae_persona)
        WHERE t.cod_movimiento = 64
        AND m.fec_movimiento >= u.fecsol
        AND m.fec_acreditacion <= ldtHastaFechaPeriodoInformar
        AND u.codigoModalidadPension IN (cchCodigoModalidadPension03, cchCodigoModalidadPension04)
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
        WHERE m.fec_acreditacion <= ldtHastaFechaPeriodoInformar
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

        UPDATE #UniversoRegistro SET
            u.montoPrimPensDefRTUF = m.montoUF
        FROM #UniversoRegistro u
            JOIN #MontoPrimeraPenDefRTUF_U2_TMP m ON (m.tipoben = u.tipoben
            AND m.fecsol = u.fecsol
            AND m.numcue = u.numcue)
        WHERE u.codigoModalidadPension IN (cchCodigoModalidadPension03, cchCodigoModalidadPension04)
        AND ISNULL(u.montoPrimPensDefRTUF, 0) = 0;

        --Universo 3 - SLB_MONTOBEN
        SELECT rank() OVER (PARTITION BY u.numcue, u.fecsol ORDER BY p.fec_ult_pago DESC, p.porcentaje_pension DESC) rank,
            u.numcue,
            u.tipoben,
            u.fecsol,
            (ISNULL(p.monto_obligatorio, 0) + 
             ISNULL(p.monto_voluntario, 0) + 
             ISNULL(p.monto_convenido, 0) + 
             ISNULL(p.monto_afi_voluntario, 0)) montoUF,
            p.porcentaje_pension
        INTO #MontoPrimeraPenDefRTUF_U3_TMP
        FROM DDS.SLB_MONTOBEN p
            INNER JOIN #UniversoRegistro u ON (p.tipoben = u.tipoben
            AND p.fecsol = u.fecsol
            AND p.numcue = u.numcue)
        WHERE p.tipoBen = cinTipoBen8
        AND p.modalidad = 5
        AND p.tipo_pago = 2
        AND p.cod_financiamiento = 2
        AND u.codigoModalidadPension IN (cchCodigoModalidadPension03, cchCodigoModalidadPension04)
        AND ISNULL(u.montoPrimPensDefRTUF, 0) = 0
        AND p.fec_ult_pago IS NOT NULL
        AND montoUF > 0;

        DELETE FROM #MontoPrimeraPenDefRTUF_U3_TMP
        WHERE rank > 1;

        UPDATE #UniversoRegistro SET
            u.montoPrimPensDefRTUF = ROUND((m.montoUF * 100.00) / CONVERT(NUMERIC(5,2), m.porcentaje_pension), 2)
        FROM #UniversoRegistro u
            JOIN #MontoPrimeraPenDefRTUF_U3_TMP m ON (m.tipoben = u.tipoben
            AND m.fecsol = u.fecsol
            AND m.numcue = u.numcue)
        WHERE u.codigoModalidadPension IN (cchCodigoModalidadPension03, cchCodigoModalidadPension04)
        AND ISNULL(u.montoPrimPensDefRTUF, 0) = 0;
        --TERMINO - IESP-235

        --INICIO - IESP-235
        --Campo: Fecha emisión primera ficha de cálculo para RP
        --Se incorpora nuevas casuisticas, en el que se obtiene desde la la tabla SLB_MONTOBEN.
        SELECT DISTINCT rank() OVER (PARTITION BY u.numcue ORDER BY u.cod_financiamiento ASC, u.fec_primer_pago ASC) rank,
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
                INNER JOIN #UniversoRegistro b ON (a.numcue = b.numcue
                AND a.fecsol = b.fecsol
                AND a.tipoben = b.tipoben)
            WHERE a.tipoBen = cinTipoBen8
            AND a.tipo_pago = 2
            AND a.fec_primer_pago IS NOT NULL
            AND b.fechaPrimerFichaCalculoRP IS NULL
            AND b.fecsol < '1996-01-01'
            UNION
            SELECT a.numcue,
                b.rut,
                b.fecsol,
                a.fec_primer_pago, 
                b.codigoTipoPension,
                a.cod_financiamiento
            FROM DDS.SLB_MONTOBEN a
                INNER JOIN #UniversoRegistro b ON (a.numcue = b.numcue
                AND a.fecsol = b.fedevpen
                AND a.tipoben = b.tipoben)
            WHERE a.tipoBen = cinTipoBen8
            AND a.tipo_pago = 2
            AND a.fec_primer_pago IS NOT NULL
            AND b.fechaPrimerFichaCalculoRP IS NULL
            AND b.fecsol < '1996-01-01') u;

        DELETE FROM #UniversoFechaEmisionFicCalPenTMP
        WHERE rank > 1;

        UPDATE #UniversoRegistro SET
            u.fechaPrimerFichaCalculoRP = f.fec_primer_pago
        FROM #UniversoRegistro u
            INNER JOIN #UniversoFechaEmisionFicCalPenTMP f ON (u.numcue = f.numcue
                AND u.fecsol = f.fecsol
                AND u.codigoTipoPension = f.codigoTipoPension);
        
        --TERMINO - IESP-235

        --Inicio INFESP-193
        SELECT a.numcue,
            MAX(a.fechaSolicitud) AS fechaSolicitudHerencia 
        INTO #fechaSolicitudHerenciaTMP
        FROM DMGestion.UniversoHerenciaTMP a
            INNER JOIN #UniversoRegistro b ON (a.numcue = b.numcue)
        GROUP BY a.numcue;
        
        --Se actualiza la fecha solicitud herencia(fechaSolicitudHerencia) 
        UPDATE #UniversoRegistro SET 
            a.fechaSolicitudHerencia = b.fechaSolicitudHerencia
        FROM #UniversoRegistro a
           INNER JOIN #fechaSolicitudHerenciaTMP b ON (a.numcue = b.numcue);

        SELECT a.numcue,
            MIN(a.fechaDisponibilidad) AS fechaPagoHabilHerencia 
        INTO #fechaPagoHerenciaTMP
        FROM (
            SELECT a.numcue,
                a.fechaDisponibilidad
            FROM DMGestion.UniversoHerenciaTMP a
                INNER JOIN #UniversoRegistro b ON (a.numcue = b.numcue
                    AND a.fechaSolicitud = b.fechaSolicitudHerencia)
            WHERE a.fechaDisponibilidad <= ldtHastaFechaPeriodoInformar
            UNION
            SELECT a.numcue,
                a.fechaDisponibilidad
            FROM DMGestion.UniversoHerenciaTMP a
                INNER JOIN #UniversoRegistro b ON (a.numcue = b.numcue
                    AND b.fechaSolicitudHerencia IS NULL)
            WHERE a.fechaDisponibilidad <= ldtHastaFechaPeriodoInformar
        ) a
        GROUP BY a.numcue;

        --Se actualiza la fecha pago herencia(fechaPagoHerencia) 
        UPDATE #UniversoRegistro SET 
            a.fechaPagoHerencia = b.fechaPagoHabilHerencia
        FROM #UniversoRegistro a
            JOIN #fechaPagoHerenciaTMP b ON (a.numcue = b.numcue);

        --Se obtiene fecha solicitud cuota mortuoria(fechaSolCuotaMortuoria) --
        SELECT a.numcue,
            MAX(a.fechaSolicitud) AS fechaSolCuotaMortuoria 
        INTO #fechaSolCuotaMortuoriaTMP
        FROM DMGestion.UniversoCuotaMortuoriaTMP a
            INNER JOIN #UniversoRegistro b ON (a.numcue = b.numcue)
        GROUP BY a.numcue;

        --Se actualiza la fecha solicitud herencia(fechaSolicitudHerencia) 
        UPDATE #UniversoRegistro SET 
            a.fechaSolCuotaMortuoria = b.fechaSolCuotaMortuoria
        FROM #UniversoRegistro a
            JOIN #fechaSolCuotaMortuoriaTMP b ON (a.numcue = b.numcue);

        SELECT a.numcue,
            MIN(a.fechaDisponibilidad) AS fechaPagoHabilCuotaMortuoria 
        INTO #fechaPagoCuotaMortuoriaTMP
        FROM (
            SELECT a.numcue,
                a.fechaDisponibilidad
            FROM DMGestion.UniversoCuotaMortuoriaTMP a
                INNER JOIN #UniversoRegistro b ON (a.numcue = b.numcue
                    AND a.fechaSolicitud = b.fechaSolCuotaMortuoria)
            WHERE a.fechaDisponibilidad <= ldtHastaFechaPeriodoInformar
            UNION
            SELECT a.numcue,
                a.fechaDisponibilidad
            FROM DMGestion.UniversoCuotaMortuoriaTMP a
                INNER JOIN #UniversoRegistro b ON (a.numcue = b.numcue
                    AND b.fechaSolCuotaMortuoria IS NULL)
            WHERE a.fechaDisponibilidad <= ldtHastaFechaPeriodoInformar
        ) a
        GROUP BY a.numcue;
        
        --Se actualiza la fecha pago cuota mortuoria(fechaPagoCuotaMortuoria)
        --a travez de la fechaPagoHabilCuotaMortuoria de la  tabla #fechaPagoCuotaMortuoriaTMP
        UPDATE #UniversoRegistro SET 
            a.fechaPagoCuotaMortuoria = b.fechaPagoHabilCuotaMortuoria
        FROM #UniversoRegistro a
            JOIN #fechaPagoCuotaMortuoriaTMP b ON (b.numcue = a.numcue)
        WHERE b.fechaPagoHabilCuotaMortuoria <= ldtHastaFechaPeriodoInformar;

        --Fin INFESP - 193

        --Se obtiene fecha pago pension sobrevivencia(fechaPagoPensionSob) --
        --cantidad de registros = 34580 row(s) affected de la tabla #fechaPagoPensionSobTMP

        SELECT a.numcue,
            MAX(a.fec_ult_pago) fechaPagoPensionSob
        INTO #fechaPagoPensionSobTMP
        FROM DDS.SLB_MONTOBEN a
            INNER JOIN #UniversoRegistro b ON (b.numcue = a.numcue
                AND a.tipoben = b.tipoben)
        WHERE a.tipoben = cinTipoBen8
            AND a.modalidad IN (ctiModalidad1,ctiModalidad5) 
            AND a.cod_financiamiento = cinDos
            AND a.tipo_pago = cinDos
            AND a.fec_ult_pago <= ldtHastaFechaPeriodoInformar
        GROUP BY a.numcue;

        --Se actualiza la fecha pago pension sobrevivencia(fechaPagoPensionSob) 
        --al universo de sobrevivencia (#UNIVERSO_SOBREVIVENCIA_FINAL)
        
        UPDATE #UniversoRegistro SET 
            a.fechaPagoPensionSob = b.fechaPagoPensionSob
        FROM #UniversoRegistro a
            JOIN #fechaPagoPensionSobTMP b ON (b.numcue = a.numcue);

        --Se obtiene fecha pago pension sobrevivencia(fechaPagoPensionSob) --
        --para abarcar las fecha pago pension sobrevivencia que quedaron  null
        --cantidad de registros = 553 row(s) affected de la tabla #fechaPagoPensionSob_2TMP

        SELECT a.numcue,
            MAX(a.fec_liquidacion) fechaPagoPensionSob        
        INTO #fechaPagoPensionSob_2TMP
        FROM DDS.SLB_DOCUPAGO a    
            INNER JOIN #UniversoRegistro b ON (b.numcue = a.numcue
                AND a.tipoben = b.tipoben)
        WHERE a.fec_liquidacion <= ldtHastaFechaPeriodoInformar 
            AND b.fechaPagoPensionSob IS NULL   
            AND a.tipoben = cinTipoBen8
            AND a.modalidad IN (ctiModalidad1,ctiModalidad5)
            AND a.tipo_pago = cinDos
        GROUP BY a.numcue;
        
        --Se actualiza la fecha pago pension sobrevivencia(fechaPagoPensionSob) 
        --al universo de sobrevivencia (#UNIVERSO_SOBREVIVENCIA_FINAL)

        UPDATE #UniversoRegistro SET 
            a.fechaPagoPensionSob = b.fechaPagoPensionSob
        FROM #UniversoRegistro a
            JOIN #fechaPagoPensionSob_2TMP b ON (b.numcue = a.numcue);
        
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
            INNER JOIN #UniversoRegistro b ON (a.numcue = b.numcue
            AND a.tipoben = b.tipoben
            AND a.fecsol = b.fecsol);

        UPDATE #UniversoRegistro SET
            u.fechaCierre = a.fecierre
        FROM #UniversoRegistro u
            JOIN #UniversoPencersaTMP a ON (a.numcue = u.numcue
            AND a.tipoben = u.tipoben
            AND a.fecsol = u.fecsol);

        --Si no tiene una fecha de cierre entonces e deja la fecha del primer pago de pensión definitiva
        UPDATE #UniversoRegistro SET
            fechaCierre = fechaPrimerPagoPension
        WHERE fechaCierre IS NULL;

        --Logica para obtener el ingreso SCOMP
        --NOTA: Se obtiene la pension minima
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

        UPDATE #UniversoRegistro SET
            u.pensionMinimaUF = ISNULL(a.ant_pen_min_uf, 0.0),
            u.pensionBasicaSolidariaUF = ISNULL(a.pbs_aps, 0.0)
        FROM #UniversoRegistro u
            JOIN #UniversoCSEAntTMP a ON (a.numcue = u.numcue
            AND a.tipoben = u.tipoben
            AND a.fecsol = u.fecsol);

        SELECT DISTINCT u.numcue,
            u.rut,
            u.codigoModalidadPension,
            u.fechaCierre,
            u.edad,
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
        FROM #UniversoRegistro u, DMGestion.VistaValorPensionMinima vvpm
        WHERE periodoFechaCierre  = vvpm.periodo
        AND u.montoPensionMesAnterior > 0
        AND u.tipoBen = cinTipoBen8
        AND pensionMinimaPesos IS NOT NULL;

        SELECT DISTINCT v.fechaUF,
            v.valorUF
        INTO #VistaValorUFFechaCierreTMP
        FROM #PensionMinimaTMP p
            JOIN DMGestion.VistaValorUF v ON (p.fechaCierre = v.fechaUF);

        UPDATE #PensionMinimaTMP p SET 
            p.pensionMinimaUF = (CONVERT(NUMERIC(10, 2), p.pensionMinimaPesos) / v.valorUF)
        FROM #PensionMinimaTMP p
            JOIN #VistaValorUFFechaCierreTMP v ON (p.fechaCierre = v.fechaUF);
           
        UPDATE #UniversoRegistro u SET 
            u.pensionMinimaUF = ISNULL(p.pensionMinimaUF, 0)
        FROM #UniversoRegistro u
            JOIN #PensionMinimaTMP p ON (u.numcue = p.numcue
            AND u.rut = p.rut
            AND u.codigoModalidadPension = p.codigoModalidadPension)
        WHERE u.pensionMinimaUF = 0;
 
        --NOTA:se obtiene la pension basica solidaria
 
        SELECT DISTINCT u.numcue,
            u.rut,
            u.codigoModalidadPension,
            u.fechaCierre,
            pbs.monto pensionBasicaSolidariaPesos,
            CONVERT(NUMERIC(10, 2), 0.0) pensionBasicaSolidariaUF
        INTO #PensionBasicaSolidariaTMP
        FROM #UniversoRegistro u, DMGestion.VistaPensionBasicaSolidaria pbs 
        WHERE u.tipoBen = cinTipoBen8
        AND u.fechaCierre BETWEEN pbs.fechaInicioRango AND pbs.fechaTerminoRango;

        SELECT DISTINCT v.fechaUF,
            v.valorUF
        INTO #VistaValorUFFechaCierre02TMP
        FROM #PensionBasicaSolidariaTMP p
            JOIN DMGestion.VistaValorUF v ON (p.fechaCierre = fechaUF);

        UPDATE #PensionBasicaSolidariaTMP p SET 
            p.pensionBasicaSolidariaUF = (CONVERT(NUMERIC(10, 2), p.pensionBasicaSolidariaPesos) / v.valorUF)
        FROM #PensionBasicaSolidariaTMP p
            JOIN #VistaValorUFFechaCierre02TMP v ON (p.fechaCierre = v.fechaUF);

        UPDATE #UniversoRegistro u SET 
            u.pensionBasicaSolidariaUF = p.pensionBasicaSolidariaUF
        FROM #UniversoRegistro u
            JOIN #PensionBasicaSolidariaTMP p ON (u.numcue = p.numcue
            AND u.rut = p.rut
            AND u.codigoModalidadPension = p.codigoModalidadPension)
        WHERE u.pensionBasicaSolidariaUF = 0;

        --NOTA: Se obtiene indicador SCOMP

        -- se valida que la pensión sea mayor que la pensión basica solidaria
        UPDATE #UniversoRegistro a SET 
            a.indIngresoSCOMP = cchS
        WHERE a.fecsol >= cdtFecha01IndScomp --'2009-07-01'
        AND a.montoPensionRefUF > a.pensionBasicaSolidariaUF
        AND a.tipoBen = cinTipoBen8
        AND a.pensionBasicaSolidariaUF > 0;
            
        UPDATE #UniversoRegistro a SET 
            a.indIngresoSCOMP = cchS
        WHERE a.fecsol > cdtFecha02IndScomp --'2004-08-19'
        AND a.codigoModalidadPension IN (cchCodigoModalidadPension01,cchCodigoModalidadPension02,cchCodigoModalidadPension03,cchCodigoModalidadPension04,cchCodigoModalidadPension05,cchCodigoModalidadPension06,cchCodigoModalidadPension07)
        AND a.tipoBen = cinTipoBen8;   

        -- Se valida que la pension sea mayor que la pensión minima
        UPDATE #UniversoRegistro a SET 
            a.indIngresoSCOMP = cchS
        WHERE a.tipoBen = cinTipoBen8
        AND a.fecsol < cdtFecha01IndScomp --'2009-07-01'
        AND a.fecsol > cdtFecha02IndScomp --'2004-08-19'
        AND a.montoPensionRefUF > a.pensionMinimaUF
        AND a.pensionMinimaUF > 0;

        --Se obtiene la fecha maxima del campo (stp_faj_fecha) para lograr obtener  --
        --el valor factor actuarialmente justo (factorActuarialmenteJusto) --
        --cantidad de registros = 49 row(s) affected  tabla = #facActJustoTMP

        SELECT c.rut,
            MAX(a.stp_faj_fecha) fajFechaMax
        INTO #facActJustoTMP
        FROM DDS.APS_ARCHIVO_FAJ a
            INNER JOIN DDS.APS_ARCHIVO_FAJ_DET b ON (b.stp_faj_id = a.stp_faj_id)    
            INNER JOIN #UniversoRegistro c ON (c.rut = b.stp_faj_det_rut)
        GROUP BY  c.rut;
    
        --Se obtiene el valor factor actuarialmente justo (factorActuarialmenteJusto) --
        --cantidad de registros = 74 row(s) affected.
        SELECT a.stp_faj_id,
            a.periodo,
            c.rut,
            a.stp_faj_fecha,
            b.stp_faj_det_faj factorActuarialmenteJusto
        INTO #facActJusto_2TMP
        FROM DDS.APS_ARCHIVO_FAJ a
            INNER JOIN DDS.APS_ARCHIVO_FAJ_DET b ON (b.stp_faj_id = a.stp_faj_id)    
            INNER JOIN #facActJustoTMP c ON (c.rut = b.stp_faj_det_rut 
            AND c.fajFechaMax = a.stp_faj_fecha);
        
        --se obtiene el maximo periodo para poder filtrar --
        --cantidad de registros = 49 row(s) affected.
        
        SELECT rut,
            stp_faj_fecha,
            MAX(periodo) periodoMax
        INTO #facActJusto_3TMP
        FROM #facActJusto_2TMP
        GROUP BY rut, stp_faj_fecha;

        --se filtra los rut duplicados  a traves del periodo maximo calculado en el tabla #facActJusto_3TMP --
        --cantidad de registros = 72 row(s) affected
 
        SELECT a.stp_faj_id,
            a.periodo,
            a.rut,
            a.stp_faj_fecha,
            a. factorActuarialmenteJusto
        INTO #facActJusto_4TMP
        FROM #facActJusto_2TMP a
            INNER JOIN #facActJusto_3TMP b ON (a.rut = b.rut 
            AND a.stp_faj_fecha = b.stp_faj_fecha 
            AND b.periodoMax = a.periodo);

        --se obtiene el maximo id para poder filtrar --
        --cantidad de registros = 49 row(s) affected.
        
        SELECT MAX(stp_faj_id) stp_faj_idMax,
            periodo,
            rut,
            stp_faj_fecha
        INTO #facActJusto_5TMP
        FROM #facActJusto_4TMP
        GROUP BY periodo,rut, stp_faj_fecha;

        --Se filtra los rut duplicados  a traves del stp_faj_id  maximo calculado en el tabla #facActJusto_5TMP --
        --cantidad de registros = 49 row(s) affected
        
        SELECT a.stp_faj_id,
            a.periodo,
            a.rut,
            a.stp_faj_fecha,
            a.factorActuarialmenteJusto
        INTO #facActJusto_6TMP
        FROM #facActJusto_4TMP a
            INNER JOIN #facActJusto_5TMP b ON (a.rut = b.rut 
            AND a.stp_faj_fecha = b.stp_faj_fecha 
            AND b.stp_faj_idMax = a.stp_faj_id);

        --Se actualiza a el factor actuarialmente justo(factorActuarialmenteJusto)
        --cantidad de registros = 49 row(s) updated

        UPDATE #UniversoRegistro SET 
            a.factorActuarialmenteJusto = ISNULL(b.factorActuarialmenteJusto, 0)
        FROM #UniversoRegistro a
            JOIN #facActJusto_6TMP b ON (b.rut = a.rut); 

        --Fecha de solicitud de pensión menor a 1996-01-01 se obtiene:
        -- - Fecha emisión certificado de saldo
        -- - Fecha de emisión primera ficha de calculo RP
        -- - Fecha selección modalidad de pensión
        -- - Fecha primer pago de pensión definitiva
        -- - Monto Pensión Calculada en UF
        --desde la tabla DDS.TramitePensionAprobadoDatoIncompleto

        UPDATE #UniversoRegistro SET     
            a.fechaCertificadoSaldo     = (CASE WHEN (b.fecEmiCertSaldoModPension IS NOT NULL AND a.fechaCertificadoSaldo IS NULL)      THEN b.fecEmiCertSaldoModPension    ELSE a.fechaCertificadoSaldo        END),
            a.fechaPrimerFichaCalculoRP = (CASE WHEN (b.fecEmis1FichaCalculoRP IS NOT NULL    AND a.fechaPrimerFichaCalculoRP IS NULL)  THEN b.fecEmis1FichaCalculoRP       ELSE a.fechaPrimerFichaCalculoRP    END),
            a.fechaSeleccionModalidad   = (CASE WHEN (b.fechaSeleccionModPension IS NOT NULL  AND a.fechaSeleccionModalidad IS NULL)    THEN b.fechaSeleccionModPension     ELSE a.fechaSeleccionModalidad      END),
            a.fechaPrimerPagoPension    = (CASE WHEN (b.fecPrimerPagoPensionDef IS NOT NULL   AND a.fechaPrimerPagoPension IS NULL)     THEN b.fecPrimerPagoPensionDef      ELSE a.fechaPrimerPagoPension       END),
            a.promedioRentasUF          = (CASE WHEN (b.promedioRentasRemuneraUF IS NOT NULL  AND a.promedioRentasUF IS NULL)           THEN b.promedioRentasRemuneraUF     ELSE a.promedioRentasUF             END),
            a.numeroRemEfectiva         = (CASE WHEN (b.numRemEfectPromRenRemu IS NOT NULL    AND a.numeroRemEfectiva IS NULL)          THEN b.numRemEfectPromRenRemu       ELSE a.numeroRemEfectiva            END),
            a.montoPensionRefUF         = (CASE WHEN (b.montoPrimPensDefUF IS NOT NULL        AND a.montoPensionRefUF IS NULL)          THEN b.montoPrimPensDefUF           ELSE a.montoPensionRefUF            END),
            a.montoPrimPensDefRTUF      = (CASE WHEN (b.montoPrimPensDefRTUF IS NOT NULL      AND a.montoPrimPensDefRTUF IS NULL)       THEN b.montoPrimPensDefRTUF         ELSE a.montoPrimPensDefRTUF         END),
            a.ingresoBaseUF             = (CASE WHEN (b.ingresoBaseUF IS NOT NULL             AND a.ingresoBaseUF IS NULL)              THEN b.ingresoBaseUF                ELSE a.ingresoBaseUF                END),
            a.montoPensionMesAnterior   = (CASE WHEN (b.montoPensionMesAnterior IS NOT NULL   AND a.montoPensionMesAnterior IS NULL)    THEN b.montoPensionMesAnterior      ELSE a.montoPensionMesAnterior      END)
        FROM #UniversoRegistro a
            INNER JOIN DDS.TramitePensionAprobadoDatoIncompleto b ON (a.rut = b.rut
                AND a.fecsol = b.fechaSolicitud
                AND a.tipoben = b.tipoBeneficio
                AND a.codigoModalidadPension = b.codigoModalidadPension)
        WHERE b.indRegistroInformar             = cchSi
            AND b.indInfModalidadPensionRecuperada  = cchNo
            AND b.indInfModalidadPensionReemplazar  = cchNo
            AND b.tramitePension                    = cchCodigoSO
            AND a.tipoben                           = cinTipoBen8;

        UPDATE #UniversoRegistro SET     
            a.fechaCertificadoSaldo     = (CASE WHEN (b.fecEmiCertSaldoModPension IS NOT NULL AND a.fechaCertificadoSaldo IS NULL)      THEN b.fecEmiCertSaldoModPension    ELSE a.fechaCertificadoSaldo        END),
            a.fechaPrimerFichaCalculoRP = (CASE WHEN (b.fecEmis1FichaCalculoRP IS NOT NULL    AND a.fechaPrimerFichaCalculoRP IS NULL)  THEN b.fecEmis1FichaCalculoRP       ELSE a.fechaPrimerFichaCalculoRP    END),
            a.fechaSeleccionModalidad   = (CASE WHEN (b.fechaSeleccionModPension IS NOT NULL  AND a.fechaSeleccionModalidad IS NULL)    THEN b.fechaSeleccionModPension     ELSE a.fechaSeleccionModalidad      END),
            a.fechaPrimerPagoPension    = (CASE WHEN (b.fecPrimerPagoPensionDef IS NOT NULL   AND a.fechaPrimerPagoPension IS NULL)     THEN b.fecPrimerPagoPensionDef      ELSE a.fechaPrimerPagoPension       END),
            a.promedioRentasUF          = (CASE WHEN (b.promedioRentasRemuneraUF IS NOT NULL  AND a.promedioRentasUF IS NULL)           THEN b.promedioRentasRemuneraUF     ELSE a.promedioRentasUF             END),
            a.numeroRemEfectiva         = (CASE WHEN (b.numRemEfectPromRenRemu IS NOT NULL    AND a.numeroRemEfectiva IS NULL)          THEN b.numRemEfectPromRenRemu       ELSE a.numeroRemEfectiva            END),
            a.montoPensionRefUF         = (CASE WHEN (b.montoPrimPensDefUF IS NOT NULL        AND a.montoPensionRefUF IS NULL)          THEN b.montoPrimPensDefUF           ELSE a.montoPensionRefUF            END),
            a.montoPrimPensDefRTUF      = (CASE WHEN (b.montoPrimPensDefRTUF IS NOT NULL      AND a.montoPrimPensDefRTUF IS NULL)       THEN b.montoPrimPensDefRTUF         ELSE a.montoPrimPensDefRTUF         END),
            a.ingresoBaseUF             = (CASE WHEN (b.ingresoBaseUF IS NOT NULL             AND a.ingresoBaseUF IS NULL)              THEN b.ingresoBaseUF                ELSE a.ingresoBaseUF                END),
            a.montoPensionMesAnterior   = (CASE WHEN (b.montoPensionMesAnterior IS NOT NULL   AND a.montoPensionMesAnterior IS NULL)    THEN b.montoPensionMesAnterior      ELSE a.montoPensionMesAnterior      END)
        FROM #UniversoRegistro a
            JOIN DDS.TramitePensionAprobadoDatoIncompleto b ON (a.rut = b.rut
                AND a.fecsol = b.fechaSolicitud
                AND a.tipoben = b.tipoBeneficio
                AND a.codigoModalidadPension = b.codigoModalidadPensionReemplazar)
        WHERE b.indRegistroInformar             = cchSi
            AND b.indInfModalidadPensionRecuperada  = cchNo
            AND b.indInfModalidadPensionReemplazar  = cchSi
            AND b.tramitePension                    = cchCodigoSO
            AND a.tipoben                           = cinTipoBen8;

        --Se aplica validación de acuerdo ala matriz V3.
        --Fecha Emisión Certificado Saldo
        UPDATE #UniversoRegistro SET
            fechaCertificadoSaldo = NULL
        WHERE codigoModalidadPension NOT IN (cchCodigoModalidadPension01, cchCodigoModalidadPension02, cchCodigoModalidadPension03, cchCodigoModalidadPension04, cchCodigoModalidadPension05, cchCodigoModalidadPension06, cchCodigoModalidadPension07, cchCodigoModalidadPension08, cchCodigoModalidadPension09);

        UPDATE #UniversoRegistro SET
            fechaCertificadoSaldo = NULL
        WHERE codigoModalidadPension IN (cchCodigoModalidadPension08, cchCodigoModalidadPension09)
        AND indIngresoSCOMP = cchN;

        --Indicador SCOMP
        UPDATE #UniversoRegistro SET
           indIngresoSCOMP = cchN
        WHERE fechaCertificadoSaldo IS NULL;

        --Fecha Emisión Primera Ficha de Calculo       
        UPDATE #UniversoRegistro SET
            fechaPrimerFichaCalculoRP = NULL
        WHERE codigoModalidadPension NOT IN (cchCodigoModalidadPension03,cchCodigoModalidadPension04,cchCodigoModalidadPension05,cchCodigoModalidadPension06,cchCodigoModalidadPension08, cchCodigoModalidadPension09);

        --Fecha Selección Modalidad Pensión
        UPDATE #UniversoRegistro SET
            fechaSeleccionModalidad = NULL
        WHERE codigoModalidadPension NOT IN (cchCodigoModalidadPension01, cchCodigoModalidadPension02, cchCodigoModalidadPension03, cchCodigoModalidadPension04, cchCodigoModalidadPension05, cchCodigoModalidadPension06,cchCodigoModalidadPension07, cchCodigoModalidadPension08, cchCodigoModalidadPension09);

        UPDATE #UniversoRegistro SET
            fechaSeleccionModalidad = NULL
        WHERE codigoModalidadPension IN (cchCodigoModalidadPension08, cchCodigoModalidadPension09)
        AND indIngresoSCOMP = cchN;

        --Primer pago definitivo en UF
        /*UPDATE #UniversoRegistro SET
            fechaPrimerPagoPension = NULL
        WHERE codigoModalidadPension IN ('01', '02', '07');*/

        --Casos cuando la ficha de cálculo es posterior a la fecha del primer pago de pensión definitiva
        UPDATE #UniversoRegistro SET 
            fechaPrimerFichaCalculoRP = fechaPrimerPagoPension
        WHERE fechaPrimerFichaCalculoRP > fechaPrimerPagoPension
        AND fechaPrimerPagoPension IS NOT NULL;

        UPDATE #UniversoRegistro SET
            fechaPrimerCalculoCNU = ISNULL(fechaCertificadoSaldo, fechaPrimerFichaCalculoRP)
        WHERE fechaPrimerCalculoCNU IS NULL;

        --Casos que tiene pago de cuota mortuorio pero no tiene fecha solicitud
        --cuota mortuoria
        SELECT DISTINCT fechaPagoCuotaMortuoria
        INTO #FechaSolPagoCuotaMortTMP
        FROM #UniversoRegistro 
        WHERE fechaSolPensionSob IS NULL
        AND fechaPagoCuotaMortuoria IS NOT NULL
        AND fechaSolicitudHerencia IS NULL
        AND fechaSolCuotaMortuoria IS NULL;

        SELECT fechaPagoCuotaMortuoria,
            DMGestion.obtenerDiaHabilAnterior(DATEADD(DAY, -1, fechaPagoCuotaMortuoria)) fechaDiaHabilAnt01,
            DMGestion.obtenerDiaHabilAnterior(DATEADD(DAY, -1, fechaDiaHabilAnt01)) fechaDiaHabilAnt02,
            DMGestion.obtenerDiaHabilAnterior(DATEADD(DAY, -1, fechaDiaHabilAnt02)) fechaDiaHabilAnt03,
            DMGestion.obtenerDiaHabilAnterior(DATEADD(DAY, -1, fechaDiaHabilAnt03)) fechaDiaHabilAnt04,
            DMGestion.obtenerDiaHabilAnterior(DATEADD(DAY, -1, fechaDiaHabilAnt04)) fechaSolCuotaMortuoriaCalc
        INTO #FechaSolCuotaMortCalcTMP
        FROM #FechaSolPagoCuotaMortTMP;

        UPDATE #UniversoRegistro SET
            a.fechaSolCuotaMortuoria = b.fechaSolCuotaMortuoriaCalc
        FROM #UniversoRegistro a
            JOIN #FechaSolCuotaMortCalcTMP b ON (a.fechaPagoCuotaMortuoria = b.fechaPagoCuotaMortuoria)
        WHERE a.fechaSolPensionSob IS NULL
        AND a.fechaPagoCuotaMortuoria IS NOT NULL
        AND a.fechaSolicitudHerencia IS NULL
        AND a.fechaSolCuotaMortuoria IS NULL;

        DROP TABLE #fechaSolicitudHerenciaTMP;
        DROP TABLE #fechaPagoHerenciaTMP;
        DROP TABLE #fechaSolCuotaMortuoriaTMP;
        DROP TABLE #fechaPagoCuotaMortuoriaTMP;
        DROP TABLE #fechaPagoPensionSobTMP;
        DROP TABLE #fechaPagoPensionSob_2TMP;
        DROP TABLE #facActJustoTMP;
        DROP TABLE #facActJusto_2TMP;
        DROP TABLE #facActJusto_3TMP;
        DROP TABLE #facActJusto_4TMP;
        DROP TABLE #facActJusto_5TMP;
        DROP TABLE #facActJusto_6TMP; 
        DROP TABLE #PensionMinimaTMP; 
        DROP TABLE #PensionBasicaSolidariaTMP;    
        DROP TABLE DMGestion.UniversoHerenciaTMP;
        DROP TABLE DMGestion.UniversoCuotaMortuoriaTMP;
        --CGI-ahr-fin --

        -- 04/01/2017 Este CALL no existía, para resolverlo se agrega.
        --Eliminación del universo código trafil02
        CALL DDS.cargarUniversoCodigoTrafil02(2);
    
        --Actualiza el numero de fila que corresponde
        UPDATE #UniversoRegistro a SET
            numeroFila = ROWID(a);
    
        UPDATE #UniversoRegistro 
            SET montoPensionRefUF=cinValor0 
        WHERE montoPensionRefUF>cinValor99999;


        /********** CLASIFICACION DEL ESTADO DE LA SOLICITUD **********/
    
        UPDATE #UniversoRegistro
           SET estadoSolicitud = cinValor0--NO aplica 
        WHERE ISNULL(fechaPrimerPagoPension,cdtMaximaFechaVigencia) = cdtMaximaFechaVigencia
           AND idModalidadPension = cinValor0
           AND estadoSolicitud = cinValor0;
       
        UPDATE #UniversoRegistro
           SET estadoSolicitud = cinAprobada--APROBADA solo si es mayor que la fecha de corte y tiene fecha de primer pago del periodo
        WHERE ISNULL(fechaPrimerPagoPension,cdtMaximaFechaVigencia) <> cdtMaximaFechaVigencia
           AND idModalidadPension > cinValor0
           AND fechaSolPensionSob >= cdtFecCorteNoPerfect
           AND estadoSolicitud = cinValor0;
       
        UPDATE #UniversoRegistro
           SET estadoSolicitud = cinAprobada--APROBADA sin importar la fecha de primer pago anterior a la fecha de corte
        WHERE idModalidadPension > cinValor0
           AND fechaSolPensionSob < cdtFecCorteNoPerfect
           AND estadoSolicitud = cinValor0;
           
        UPDATE #UniversoRegistro
           SET estadoSolicitud = cinAprobadaNoPerfeccionada--APROBADA solo si es mayor que la fecha de corte y tiene fecha de primer pago del periodo
        WHERE ISNULL(fechaPrimerPagoPension,cdtMaximaFechaVigencia) = cdtMaximaFechaVigencia
           AND idModalidadPension > cinValor0
           AND fechaSolPensionSob >= cdtFecCorteNoPerfect
           AND estadoSolicitud = cinValor0;
    
         /****************************************************************/ 
    
        SELECT linIdPeriodoInformar, 
            ltiIdDimTipoProceso, 
            idPersona, 
            idSituacionFallecimiento,
            idTipoCobertura, 
            idModalidadPension, 
            idEstadoBienesNacionales, 
            idTipoBeneficioRegularizacion, 
            idTipoContrato,
            ingresoBaseUF, 
            promedioRentasUF, 
            numeroRemEfectiva, 
            fechaInformeBienNacional,
            fechaSolicitudBeneficio, 
            montoPensionMesAnterior, 
            fechaSolPensionSob, 
            montoPensionRefUF,
            fechaCalculoPensionRef, 
            montoAporteAdiUF, 
            fechaCalculoAporteAdi, 
            fechaCertificadoSaldo,
            fechaSeleccionModalidad, 
            fechaPrimerPagoPension, 
            fechaPrimerFichaCalculoRP, 
            fechaPrimerCalculoCNU,
            idCausalRecalculo, 
            idTipoAnualidad, 
            idTipoRecalculo, 
            idTipoPension, 
            pensionMinimaUF, 
            pensionBasicaSolidariaUF, 
            fechaCalculo, 
            fechaSolicitudHerencia, 
            fechaPagoHerencia, 
            fechaSolCuotaMortuoria, 
            fechaPagoCuotaMortuoria,
            fechaPagoPensionSob, 
            indIngresoSCOMP, 
            ISNULL(factorActuarialmenteJusto, 0) AS factorActuarialmenteJusto,
            ISNULL(PORCENTAJE_COBERTURA_SEG, 0) porcentajeCobertura,
            montoPrimPensDefRTUF,
            numcue,
            numeroFila, 
            idError,
            des.id idEstadoSolicitud -->NUEVO CAMPO DE ESTADO DE LA SOLICITUD
        INTO #UniversoRegistroTMP
        FROM #UniversoRegistro tmp
        INNER JOIN DMGestion.DimEstadoSolicitud des ON des.codigo = tmp.EstadoSolicitud AND des.fechaVigencia >= cdtMaximaFechaVigencia;

        --Se inserta en la FctAfiliadoFallecido
        --cantidad registro = 82090 row(s) inserted
        INSERT INTO DMGestion.FctAfiliadoFallecido(idPeriodoInformado, 
            idTipoProceso, 
            idPersona, 
            idSituacionFallecimiento,
            idTipoCobertura, 
            idModalidadPension, 
            idEstadoBienesNacionales, 
            idTipoBeneficioRegularizacion, 
            idTipoContrato,
            ingresoBaseUF, 
            promedioRentasUF, 
            numeroRemEfectiva, 
            fechaInformeBienNacional,
            fechaSolicitudBeneficio, 
            montoPensionMesAnterior, 
            fechaSolPensionSob, 
            montoPensionRefUF,
            fechaCalculoPensionRef, 
            montoAporteAdiUF, 
            fechaCalculoAporteAdi, 
            fechaCertificadoSaldo,
            fechaSeleccionModalidad, 
            fechaPrimerPagoPension, 
            fechaPrimerFichaCalculoRP, 
            fechaPrimerCalculoCNU,
            idCausalRecalculo, 
            idTipoAnualidad, 
            idTipoRecalculo, 
            idTipoPension, 
            pensionMinimaUF, 
            pensionBasicaSolidariaUF, 
            fechaCalculo, 
            fechaSolicitudHerencia, 
            fechaPagoHerencia, 
            fechaSolCuotaMortuoria, 
            fechaPagoCuotaMortuoria,
            fechaPagoPensionSob, 
            indIngresoSCOMP, 
            factorActuarialmenteJusto, 
            porcentajeCobertura,
            montoPrimPensDefRTUF,
            numeroCuenta,
            numeroFila, 
            idError,
            idEstadoSolicitud)
        SELECT linIdPeriodoInformar, 
            ltiIdDimTipoProceso, 
            idPersona, 
            idSituacionFallecimiento,
            idTipoCobertura, 
            idModalidadPension, 
            idEstadoBienesNacionales, 
            idTipoBeneficioRegularizacion, 
            idTipoContrato,
            ingresoBaseUF, 
            promedioRentasUF, 
            numeroRemEfectiva, 
            fechaInformeBienNacional,
            fechaSolicitudBeneficio, 
            montoPensionMesAnterior, 
            fechaSolPensionSob, 
            montoPensionRefUF,
            fechaCalculoPensionRef, 
            montoAporteAdiUF, 
            fechaCalculoAporteAdi, 
            fechaCertificadoSaldo,
            fechaSeleccionModalidad, 
            fechaPrimerPagoPension, 
            fechaPrimerFichaCalculoRP, 
            fechaPrimerCalculoCNU,
            idCausalRecalculo, 
            idTipoAnualidad, 
            idTipoRecalculo, 
            idTipoPension, 
            pensionMinimaUF, 
            pensionBasicaSolidariaUF, 
            fechaCalculo, 
            fechaSolicitudHerencia, 
            fechaPagoHerencia, 
            fechaSolCuotaMortuoria, 
            fechaPagoCuotaMortuoria,
            fechaPagoPensionSob, 
            indIngresoSCOMP, 
            factorActuarialmenteJusto,
            porcentajeCobertura,
            montoPrimPensDefRTUF,
            numcue,
            numeroFila, 
            idError,
            idEstadoSolicitud
        FROM #UniversoRegistroTMP;
    
        --------------------
        --Datos de Auditoria
        --------------------
        --Se registra datos de auditoria
        SELECT COUNT(*) 
        INTO lbiCantidadRegistrosInformados
        FROM #UniversoRegistroTMP;

        CALL DMGestion.registrarAuditoriaDatamarts(cstNombreProcedimiento, 
                                                   cstNombreTablaFct, 
                                                   ldtFechaInicioCarga, 
                                                   lbiCantidadRegistrosInformados, 
                                                   NULL);

        
        COMMIT;
        SAVEPOINT;

        SET codigoError = cstCodigoErrorCero;

        CALL DMGestion.actualizarFctAfiliadoFallecido(codigoError);

        DROP TABLE DMGestion.UniversoMovimientosRVTMP;

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