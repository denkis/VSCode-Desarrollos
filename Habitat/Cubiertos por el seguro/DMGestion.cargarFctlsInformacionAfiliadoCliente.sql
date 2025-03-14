create PROCEDURE DMGestion.cargarFctlsInformacionAfiliadoCliente(OUT codigoError VARCHAR(10))
BEGIN
    /*-----------------------------------------------------------------------------------------
    - Nombre archivo                            : cargarFtlsInformacionAfiliadoCliente.sql
    - Nombre del módulo                         : Modelo de Cuentas
    - Fecha de  creación                        : 02-05-2013
    - Nombre del autor                          : Giovani Chavez CGI
    - Descripción corta del módulo              : Procedimiento que carga
                                                  FtlsInformacionAfiliadoCliente
    - Documentos asociados a la creación        : Documento de Analisis y Diseño Metricas.doc
    - Fecha de modificación                     : 17-07-2013
    - Nombre de la persona que lo modificó      : Ricardo Salinas S. - CGI
    - Cambios realizados                        : Implementación de nuevas funcionalidades
                                                  Ex 1661
    - Documentos asociados a la modificación    : Documento Análisis & Diseño Modelo Cuentas -
                                                  BDA - Ex Circ. 1661.docx
    -------------------------------------------------------------------------------------------*/

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
    DECLARE cstNombreTablaFct                       VARCHAR(150);   --constante de tipo varchar
    DECLARE ctiProductoCCICO                        TINYINT;        --variable local de tipo tinyint
    DECLARE ctiProductoCCIAV                        TINYINT;        --variable local de tipo tinyint
    DECLARE ctiProductoCCIDC                        TINYINT;        --variable local de tipo tinyint
    DECLARE ctiProductoCCICV                        TINYINT;        --variable local de tipo tinyint
    DECLARE ctiTraCtaCteCCICO                       INTEGER;        --variable local de tipo integer
    DECLARE ctiTraCtaCteCCIAV                       INTEGER;        --variable local de tipo integer
    DECLARE cstCodigoErrorCero                      VARCHAR(10);    --constante de tipo varchar
    DECLARE cstCodControlVAL                        CHAR(3);        --constante de tipo char
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
    DECLARE cstSi                                   CHAR(1);        --constante de tipo char
    DECLARE cstNo                                   CHAR(1);        --constante de tipo char
    DECLARE cstZ                                    CHAR(1);        --constante de tipo char
    DECLARE cstFemenino                             CHAR(1);        --constante de tipo char
    DECLARE cstMasculino                            CHAR(1);        --constante de tipo char
    DECLARE cstCero                                 CHAR(2);        --constante de tipo char
    DECLARE cstDobleCero                            CHAR(2);        --constante de tipo char
    DECLARE cstUno                                  CHAR(2);        --constante de tipo char
    DECLARE cstDos                                  CHAR(2);        --constante de tipo char
    DECLARE cstTres                                 CHAR(2);        --constante de tipo char
    DECLARE cstCuatro                               CHAR(2);        --constante de tipo char
    DECLARE cstCinco                                CHAR(2);        --constante de tipo char
    DECLARE cstOcho                                 CHAR(2);        --constante de tipo char
    DECLARE cinEstadoRol1                           INTEGER;        --variable local de tipo integer
    DECLARE cinEstadoRol2                           INTEGER;        --variable local de tipo integer
    DECLARE cinEstadoRol4                           INTEGER;        --variable local de tipo integer
    DECLARE cinEstadoRol5                           INTEGER;        --variable local de tipo integer
    DECLARE cinEstadoRol6                           INTEGER;        --variable local de tipo integer
    DECLARE cinTipoRol1                             INTEGER;        --variable local de tipo integer
    DECLARE cinTipoRol7                             INTEGER;        --variable local de tipo integer
    DECLARE cinTipoRol12                            INTEGER;        --variable local de tipo integer
    DECLARE cinTipoTrabajador1                      INTEGER;        --variable local de tipo integer
    DECLARE cinTipoTrabajador2                      INTEGER;        --variable local de tipo integer
    DECLARE cinTipoTrabajador3                      INTEGER;        --variable local de tipo integer
    DECLARE cinTipoTrabajador5                      INTEGER;        --variable local de tipo integer
    DECLARE cinTipoTrabajador7                      INTEGER;        --variable local de tipo integer
    DECLARE cinTipoTrabajador8                      INTEGER;        --variable local de tipo integer
    DECLARE cinTipoTrabajador9                      INTEGER;        --variable local de tipo integer
    DECLARE cinTipoTrabajador10                     INTEGER;        --variable local de tipo integer
    DECLARE cinTipoTrabajador11                     INTEGER;        --variable local de tipo integer
    DECLARE cinTipoTrabajador12                     INTEGER;        --variable local de tipo integer
    DECLARE cinIndEstado                            INTEGER;        --variable local de tipo integer
    DECLARE cinIndEstadoCero                        INTEGER;        --variable local de tipo integer
    DECLARE cinEdadLegalH                           INTEGER;        --variable local de tipo integer
    DECLARE cinEdadLegalM                           INTEGER;        --variable local de tipo integer
    DECLARE cinMovimientoCCICO1                     INTEGER;        --variable local de tipo integer
    DECLARE cinMovimientoCCICO2                     INTEGER;        --variable local de tipo integer
    DECLARE cinMovimientoCCICO3                     INTEGER;        --variable local de tipo integer
    DECLARE cinMovPagoSeguro1                       INTEGER;        --variable local de tipo integer
    DECLARE cinMovPagoSeguro2                       INTEGER;        --variable local de tipo integer
    DECLARE cinMovRentaVita                         INTEGER;        --variable local de tipo integer
    DECLARE cinUno                                  INTEGER;        --variable local de tipo integer
    DECLARE cinCero                                 INTEGER;        --variable local de tipo integer
    DECLARE cinMovRetProgramado                     INTEGER;        --variable local de tipo integer
    DECLARE cinMovPagoRentaTmp                      INTEGER;        --variable local de tipo integer
    DECLARE cinMovPagoPrelRP                        INTEGER;        --variable local de tipo integer
    DECLARE cinMovPagoPrimaRV                       INTEGER;        --variable local de tipo integer
    DECLARE cinInvalidezTrans                       INTEGER;        --variable local de tipo integer
    DECLARE cinCodEstDesestimado                    INTEGER;        --variable local de tipo integer
    DECLARE cinCodEstRechazo                        INTEGER;        --variable local de tipo integer
    DECLARE cinCodVigencia30                        INTEGER;        --variable local de tipo integer
    DECLARE cinCodTipoPago2                         INTEGER;        --variable local de tipo integer
    DECLARE cinTres                                 INTEGER;        --constante de tipo char
    DECLARE cinCuatro                               INTEGER;        --constante de tipo char
    DECLARE cinCinco                                INTEGER;        --constante de tipo char
    DECLARE cinSeis                                 INTEGER;        --constante de tipo char
    DECLARE cin24                                   INTEGER;        --constante de tipo char
    DECLARE cinTipoBen1                             TINYINT;        --constante local de tipo tinyint
    DECLARE cinTipoBen2                             TINYINT;        --constante local de tipo tinyint
    DECLARE cinTipoBen3                             TINYINT;        --constante local de tipo tinyint
    DECLARE cinTipoBen5                             TINYINT;        --constante local de tipo tinyint
    DECLARE cinTipoBen6                             TINYINT;        --constante local de tipo tinyint
    DECLARE cinCodestsol2                           TINYINT;        --constante local de tipo tinyint
    DECLARE cinSubGrupoMov2405                      INTEGER;        --constante local de tipo tinyint
    DECLARE cchError1008                            CHAR(4);        --constante de tipo char
    DECLARE cchError1009                            CHAR(4);        --constante de tipo char
    DECLARE cchError1010                            CHAR(4);        --constante de tipo char
    DECLARE cchError1011                            CHAR(4);        --constante de tipo char
    DECLARE cchError1012                            CHAR(4);        --constante de tipo char
    DECLARE cchError1013                            CHAR(4);        --constante de tipo char
    DECLARE cchError1014                            CHAR(4);        --constante de tipo char
    DECLARE cchError1015                            CHAR(4);        --constante de tipo char
    DECLARE cchError1016                            CHAR(4);        --constante de tipo char
    DECLARE cchError1017                            CHAR(4);        --constante de tipo char
    DECLARE cchError1018                            CHAR(4);        --constante de tipo char
    DECLARE cchError1019                            CHAR(4);        --constante de tipo char
    DECLARE cchError1020                            CHAR(4);        --constante de tipo char
    DECLARE cchError1034                            CHAR(4);        --constante de tipo char
    DECLARE cchError1035                            CHAR(4);        --constante de tipo char
    DECLARE cchError1036                            CHAR(4);        --constante de tipo char
    DECLARE cchError1037                            CHAR(4);        --constante de tipo char
    DECLARE cchError1038                            CHAR(4);        --constante de tipo char
    DECLARE cchError1039                            CHAR(4);        --constante de tipo char
    DECLARE cchError1040                            CHAR(4);        --constante de tipo char
    DECLARE cchError1041                            CHAR(4);        --constante de tipo char
    DECLARE cchError1042                            CHAR(4);        --constante de tipo char
    DECLARE cchError1043                            CHAR(4);        --constante de tipo char
    DECLARE cchError1044                            CHAR(4);        --constante de tipo char
    DECLARE cchError1045                            CHAR(4);        --constante de tipo char
    DECLARE cchError1046                            CHAR(4);        --constante de tipo char
    DECLARE cchError1047                            CHAR(4);        --constante de tipo char
    DECLARE cchError1048                            CHAR(4);        --constante de tipo char
    DECLARE cchError1049                            CHAR(4);        --constante de tipo char
    DECLARE cchError1050                            CHAR(4);        --constante de tipo char
    DECLARE cchError1051                            CHAR(4);        --constante de tipo char
    DECLARE cchError1052                            CHAR(4);        --constante de tipo char
    DECLARE cchError1053                            CHAR(4);        --constante de tipo char
    DECLARE cchError1054                            CHAR(4);        --constante de tipo char
    DECLARE cchError1055                            CHAR(4);        --constante de tipo char
    DECLARE cchError1056                            CHAR(4);        --constante de tipo char
    DECLARE cchError1057                            CHAR(4);        --constante de tipo char
    DECLARE cchError1058                            CHAR(4);        --constante de tipo char
    DECLARE cchError1059                            CHAR(4);        --constante de tipo char
    DECLARE cchError1060                            CHAR(4);        --constante de tipo char
    DECLARE cchError1061                            CHAR(4);        --constante de tipo char
    DECLARE cchError1062                            CHAR(4);        --constante de tipo char
    DECLARE cchError1063                            CHAR(4);        --constante de tipo char
    DECLARE cchError1003                            CHAR(4);        --constante de tipo char
    DECLARE cchError1079                            CHAR(4);        --constante de tipo char
    DECLARE cchError1080                            CHAR(4);        --constante de tipo char
    DECLARE cchError1081                            CHAR(4);        --constante de tipo char
    DECLARE cchTipoErrorInconsistencia              CHAR(1);        --constante de tipo varchar
    DECLARE cinDoce                                 INTEGER;        --variable local de tipo integer
    DECLARE cchCanalWeb                             CHAR(4);        --constante de tipo char
    DECLARE cchUno                                  CHAR(1);        --constante de tipo char
    DECLARE cchDos                                  CHAR(1);        --constante de tipo char
    DECLARE cchTres                                 CHAR(1);        --constante de tipo char
    DECLARE cchCuatro                               CHAR(1);        --constante de tipo char
    DECLARE cchCinco                                CHAR(1);        --constante de tipo char
    DECLARE cchSeis                                 CHAR(1);        --constante de tipo char
    DECLARE cchSiete                                CHAR(1);        --constante de tipo char
    DECLARE cchOcho                                 CHAR(1);        --constante de tipo char
    DECLARE cchNueve                                CHAR(1);        --constante de tipo char
    DECLARE cchdv1                                  CHAR(1);        --constante de tipo char
    DECLARE cchdv2                                  CHAR(1);        --constante de tipo char
    DECLARE cchEspacionBlanco                       CHAR(1);        --constante de tipo char
    DECLARE cchPaisCL                               CHAR(2);        --constante de tipo char
    DECLARE cchConcedida                            VARCHAR(15);    --constante de tipo char
    DECLARE cchAnulada                              VARCHAR(15);    --constante de tipo char
    DECLARE cchRechazada                            VARCHAR(15);    --constante de tipo char
    DECLARE cchEnTramite                            VARCHAR(15);    --constante de tipo char
    DECLARE cchSinInformacion                       VARCHAR(15);    --constante de tipo char
    DECLARE ctiCrearTablaCodigoTrafil02             TINYINT;        --constante de tipo tinyint
    DECLARE ctiBorrarTablaCodigoTrafil02            TINYINT;        --constante de tipo tinyint
    DECLARE ctiCodigoSubClasPerTrasPen              TINYINT;
    DECLARE ctiCodigoSubClasPerTrasFall             TINYINT;
    DECLARE ctiCodigoSubClasPerTrasAfil             TINYINT;
    DECLARE cin1101                                 INTEGER;        --variable local de tipo integer
    DECLARE cin1104                                 INTEGER;        --variable local de tipo integer
    DECLARE cin1105                                 INTEGER;        --variable local de tipo integer
    DECLARE cin1207                                 INTEGER;        --variable local de tipo integer
    DECLARE cinAV                                   INTEGER;        --variable local de tipo integer
    DECLARE cstSeis                                 CHAR(2);        --constante de tipo char
    DECLARE cbiIdTipMovimiento97                    BIGINT;
    DECLARE cbiIdTipMovimiento560                   BIGINT;
    DECLARE cstSolEnTramite                         VARCHAR(50);    --constante de tipo varchar
    DECLARE cstSolAceptado                          VARCHAR(50);    --constante de tipo varchar
    DECLARE cchCodChile                             CHAR(2);        --constante de tipo char
    DECLARE cchCodPeru                              CHAR(2);        --constante de tipo char
    DECLARE cchTraspasoContra                       CHAR(2);        --constante de tipo char
    DECLARE cinTopeReevalucion                      INTEGER;
    DECLARE cinCODMOV2581                           INTEGER;
    DECLARE cinCODMOV2582                           INTEGER;
    DECLARE cinCODMOV2697                           INTEGER;
    DECLARE cinCODMOV2703                           INTEGER;
    DECLARE cinCODMOV2707                           INTEGER;
    DECLARE cinCODMOV2583                           INTEGER;
    DECLARE cinCODMOV2584                           INTEGER;
    DECLARE cinCODMOV2698                           INTEGER;
    DECLARE cinCODMOV2704                           INTEGER;
    DECLARE cinCODMOV2706                           INTEGER;
    DECLARE cinCODMOV2766                           INTEGER;
    DECLARE cinCODMOV2767                           INTEGER;
    DECLARE cinCODMOV2796                           INTEGER;
    DECLARE cinCODMOV2798                           INTEGER;
    DECLARE cinCODMOV2768                           INTEGER;
    DECLARE cinCODMOV2769                           INTEGER;
    DECLARE cinCODMOV2797                           INTEGER;
    DECLARE cinCODMOV2799                           INTEGER;
    DECLARE cinCOD2300                            INTEGER;
    DECLARE cinCOD2700                            INTEGER;
    DECLARE cinCOD2305                            INTEGER;
    DECLARE cinCOD2307                            INTEGER;
    DECLARE cinCOD2308                            INTEGER;
    DECLARE cinCOD2709                            INTEGER;
    DECLARE cinCOD2710                            INTEGER;
    DECLARE cinCOD2711                            INTEGER;

    -------------------------------------------------------------------------------------------
    --Seteo Variable auditoria
    -------------------------------------------------------------------------------------------
    --se obtiene la fecha y hora de carga
    SET ldtFechaInicioCarga = getDate();

    -------------------------------------------------------------------------------------------
    --Seteo de Constantes
    -------------------------------------------------------------------------------------------
    SET cstNombreProcedimiento = 'cargarFctlsInformacionAfiliadoCliente';
    SET cstNombreTablaFct = 'FctlsInformacionAfiliadoCliente';
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
    SET cstZ = 'Z';
    SET cstFemenino = 'F';
    SET cstMasculino = 'M';
    SET cstCero = '0';
    SET cstDobleCero = '00';
    SET cstUno = '01';
    SET cstDos = '02';
    SET cstTres = '03';
    SET cstCuatro = '04';
    SET cstCinco = '05';
    SET cstOcho = '08';
    SET cinEstadoRol1 = 1;
    SET cinEstadoRol2 = 2;
    SET cinEstadoRol4 = 4;
    SET cinEstadoRol5 = 5;
    SET cinTipoRol1 = 1;
    SET cinTipoRol7 = 7;
    SET cinTipoRol12 = 12;
    SET cinTipoTrabajador1 = 1;
    SET cinTipoTrabajador2 = 2;
    SET cinTipoTrabajador3 = 3;
    SET cinTipoTrabajador5 = 5;
    SET cinTipoTrabajador7 = 7;
    SET cinTipoTrabajador8 = 8;
    SET cinTipoTrabajador9 = 9;
    SET cinTipoTrabajador10 = 10;
    SET cinTipoTrabajador11 = 11;
    SET cinTipoTrabajador12 = 12;
    SET cinIndEstado = 1;
    SET cinIndEstadoCero = 0;
    SET cinEdadLegalM = 60;
    SET cinMovimientoCCICO1 = 1101;
    SET cinMovimientoCCICO2 = 1104;
    SET cinMovimientoCCICO3 = 1105;
    SET cinMovPagoSeguro1 = 11073;
    SET cinMovPagoSeguro2 = 61003;
    SET cinMovRentaVita = 87;
    SET cinUno = 1;
    SET cinMovRetProgramado = 63;
    SET cinMovPagoRentaTmp = 64;
    SET cinMovPagoPrelRP = 66;
    SET cinMovPagoPrimaRV = 87;
    SET cinInvalidezTrans = 3;
    SET cinCodEstDesestimado = 3;
    SET cinCodEstRechazo = 4;
    SET cinCodVigencia30 = 30;
    SET cinCodTipoPago2 = 2;
    SET cinTres = 3;
    SET cinCuatro = 4;
    SET cinSeis = 6;
    SET cinTipoBen1 = 1;
    SET cinTipoBen2 = 2;
    SET cinTipoBen3 = 3;
    SET cinTipoBen5 = 5;
    SET cinTipoBen6 = 6;
    SET cinCodestsol2 = 2;
    SET cinSubGrupoMov2405 = 2405;
    SET cchError1008 = '1008';
    SET cchError1009 = '1009';
    SET cchError1010 = '1010';
    SET cchError1011 = '1011';
    SET cchError1012 = '1012';
    SET cchError1013 = '1013';
    SET cchError1014 = '1014';
    SET cchError1015 = '1015';
    SET cchError1016 = '1016';
    SET cchError1017 = '1017';
    SET cchError1018 = '1018';
    SET cchError1019 = '1019';
    SET cchError1020 = '1020';
    SET cchError1034 = '1034';
    SET cchError1035 = '1035';
    SET cchError1036 = '1036';
    SET cchError1037 = '1037';
    SET cchError1038 = '1038';
    SET cchError1039 = '1039';
    SET cchError1040 = '1040';
    SET cchError1041 = '1041';
    SET cchError1042 = '1042';
    SET cchError1043 = '1043';
    SET cchError1044 = '1044';
    SET cchError1045 = '1045';
    SET cchError1046 = '1046';
    SET cchError1047 = '1047';
    SET cchError1048 = '1048';
    SET cchError1049 = '1049';
    SET cchError1050 = '1050';
    SET cchError1051 = '1051';
    SET cchError1052 = '1052';
    SET cchError1053 = '1053';
    SET cchError1054 = '1054';
    SET cchError1055 = '1055';
    SET cchError1056 = '1056';
    SET cchError1057 = '1057';
    SET cchError1058 = '1058';
    SET cchError1059 = '1059';
    SET cchError1060 = '1060';
    SET cchError1061 = '1061';
    SET cchError1062 = '1062';
    SET cchError1063 = '1063';
    SET cchError1003 = '1003';
    SET cchError1079 = '1079';
    SET cchError1080 = '1080';
    SET cchError1081 = '1081';
    SET cchTipoErrorInconsistencia = 'I';
    SET cinCero = 0;
    SET cinDoce = 12;
    SET cchCanalWeb = 'WEB';
    SET cchUno = '1';
    SET cchDos = '2';
    SET cchTres = '3';
    SET cchCuatro = '4';
    SET cchCinco = '5';
    SET cchSeis = '6';
    SET cchSiete = '7';
    SET cchOcho = '8';
    SET cchNueve = '9';
    SET cchdv1 = 'k';
    SET cchdv2 = 'K';
    SET cchEspacionBlanco = ' ';
    SET cchPaisCL = 'cl';
    SET cchConcedida = 'Concedida';
    SET cchAnulada = 'Anulada';
    SET cchRechazada = 'Rechazada';
    SET cchEnTramite = 'En trámite';
    SET cchSinInformacion = 'Sin Información';
    SET ctiCrearTablaCodigoTrafil02 = 1;
    SET ctiBorrarTablaCodigoTrafil02 = 2;
    SET ctiCodigoSubClasPerTrasAfil = 9;
    SET ctiCodigoSubClasPerTrasPen = 10;
    SET ctiCodigoSubClasPerTrasFall = 11;
    SET cin1101 = 1101;
    SET cin1104 = 1104;
    SET cin1105 = 1105;
    SET cin1207 = 1207;
    SET cinAV  = 6;
    SET cstSeis= '06';
    SET cbiIdTipMovimiento97 = 97;
    SET cbiIdTipMovimiento560 = 560;
    SET cstSolEnTramite = 'en trámite';
    SET cstSolAceptado = 'aceptado';
    SET cchCodChile = 'CL';
    SET cchCodPeru = 'PE';
    SET cinTopeReevalucion = 42;
    SET cchTraspasoContra =  'Traspasos en Contra';
    SET ctiTraCtaCteCCICO = 974;
    SET ctiTraCtaCteCCIav = 861;
    SET cinCODMOV2581   = 2581;
    SET cinCODMOV2582   = 2582;
    SET cinCODMOV2697   = 2697;
    SET cinCODMOV2703   = 2703;
    SET cinCODMOV2707   = 2707;
    SET cinCODMOV2583   = 2583;
    SET cinCODMOV2584   = 2584;
    SET cinCODMOV2698   = 2698;
    SET cinCODMOV2704   = 2704;
    SET cinCODMOV2706   = 2706;
    SET cinCODMOV2766   = 2766;
    SET cinCODMOV2767   = 2767;
    SET cinCODMOV2796   = 2796;
    SET cinCODMOV2798   = 2798;
    SET cinCODMOV2768   = 2768;
    SET cinCODMOV2769   = 2769;
    SET cinCODMOV2797   = 2797;
    SET cinCODMOV2799   = 2799;
    SET cinCOD2300    = 2300;
    SET cinCOD2700    = 2700;
    SET cinCOD2305    = 2305;
    SET cinCOD2307    = 2307;
    SET cinCOD2308    = 2308;
    SET cinCOD2709    = 2709;
    SET cinCOD2710    = 2710;
    SET cinCOD2711    = 2711;

    --se obtiene el parametro MAXIMA_FECHA_VIGENCIA de la tabla Parametros
    SELECT CONVERT(DATE, DMGestion.obtenerParametro('MAXIMA_FECHA_VIGENCIA'), 103)
    INTO ldtMaximaFechaVigencia
    FROM DUMMY;

    --se obtiene el parametro MINIMA_FECHA_INCORP_O_AFI de la tabla Parametros
    SELECT CONVERT(DATE, DMGestion.obtenerParametro('MINIMA_FECHA_INCORP_O_AFI'), 103)
    INTO ldtMinimaFechaIncorpOAfi
    FROM DUMMY;

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

    --Se obtiene el periodo de cotización
    SELECT CONVERT(DATE, DATEADD(mm, -1, ldtFechaPeriodoInformado))
    INTO ldtPeriodoCotizacion
    FROM DUMMY;

     --se obtiene el último día habil del mes
    SELECT DMGestion.obtenerUltimoDiaHabilMes(ldtFechaPeriodoInformado)
    INTO ldtUltimoDiaHabilMes
    FROM DUMMY;

    -------------------------------------------------------------------------------------------
    --Cuerpo
    -------------------------------------------------------------------------------------------
    --se elimina los errores de carga y datos de la fact para el periodo a informar
    CALL DMGestion.eliminarFact(cstNombreProcedimiento, cstNombreTablaFct, linIdPeriodoInformar, codigoError);

    --verifica si se elimino con exito los errores de carga y datos de la fact
    IF (codigoError = cstCodigoErrorCero) THEN
        --1. Creación del universo con los datos de las personas.
        CALL DMGestion.cargarUniversoAfiliadoClienteTMP(codigoError);

        --2. Verifica si cargo el universo con exito
        IF (codigoError = cstCodigoErrorCero) THEN

            CALL DMGestion.cargarDireccionContactoAfiliadoTMP(ldtFechaPeriodoInformado, codigoError);

            IF (codigoError = cstCodigoErrorCero) THEN
                
                CALL DMGestion.cargarUniversoCubiertoSeguroTMP(codigoError);
            
                 IF (codigoError = cstCodigoErrorCero) THEN
            
                    --Creación del universo código trafil02
                    CALL DDS.cargarUniversoCodigoTrafil02(ctiCrearTablaCodigoTrafil02);
    
                    --convenio internacional
                    SELECT DISTINCT b.id_mae_persona,
                        a.rut numrut,
                        a.estadoSolicitud estadoSolicitudConvenio,
                        LCASE(a.paisConvenio) paisPensionOtroEstado,
                        (CASE
                            WHEN (UPPER(a.paisConvenio) = UPPER(cchPaisCL) AND
                                  UPPER(a.estadoSolicitud) = UPPER(cchConcedida)) THEN cstSi
                            ELSE cstNo
                        END)  indPensionadoOtroEstado,
                        a.fechaRecepcion
                    INTO #ConvenioInternacionalTMP
                    FROM DDS.PlanillaConvenioInternacional a
                        INNER JOIN DMGestion.UniversoAfiliadoClienteTMP b ON (b.rutPersona = a.rut)
                    WHERE UPPER(a.estadoSolicitud) NOT IN (UPPER(cchAnulada), UPPER(cchRechazada), UPPER(cchSinInformacion))
                    AND b.esUniversoCuadro1 = cstSi
                    ORDER BY a.rut;
    
                    SELECT numrut,
                        estadoSolicitudConvenio,
                        MAX(fechaRecepcion) fechaRecepcion
                    INTO #MaximaFechaRecepcionConvenioTMP
                    FROM #ConvenioInternacionalTMP
                    GROUP BY numrut,
                        estadoSolicitudConvenio;
                    SELECT a.id_mae_persona,
                        a.numrut,
                        a.estadoSolicitudConvenio,
                        a.paisPensionOtroEstado,
                        a.indPensionadoOtroEstado,
                        a.fechaRecepcion
                    INTO #UniversoConvenioInternacional
                    FROM #ConvenioInternacionalTMP a
                        INNER JOIN #MaximaFechaRecepcionConvenioTMP b ON (a.numrut = b.numrut
                        AND a.estadoSolicitudConvenio = b.estadoSolicitudConvenio
                        AND a.fechaRecepcion = b.fechaRecepcion);
    
                    --Sobrecotización por Trabajos Pesados
                    SELECT up.id_mae_persona,
                        MAX(ftp.idPeriodoInformado) idPeriodoInformado
                    INTO #MaximaPeriodoInformadoTrabajoPesadoTMP
                    FROM DMGestion.FctTrabajoPesado ftp
                        INNER JOIN DMGestion.DimPersona dp ON (ftp.idPersona = dp.id)
                        INNER JOIN DMGestion.DimProcesoCarga dpc ON (ftp.idProcesoCarga = dpc.id)
                        INNER JOIN DMGestion.UniversoAfiliadoClienteTMP up ON (dp.idPersonaOrigen = up.id_mae_persona)
                    WHERE up.esUniversoCuadro1 = cstSi
                    AND dpc.codigo = cstUno --Carga Mensual
                    AND ftp.idPeriodoInformado <= linIdPeriodoInformar
                    GROUP BY up.id_mae_persona;
    
                    SELECT mpitp.id_mae_persona,
                        MAX(ftp.idPeriodoInformado) idPeriodoInformado,
                        MAX(ftp.periodoCotizacion) periodoCotizacion
                    INTO #UltimaSobrecotizacionTrabajoPesadoTMP
                    FROM DMGestion.FctTrabajoPesado ftp
                        INNER JOIN DMGestion.DimPersona dp ON (ftp.idPersona = dp.id)
                        INNER JOIN DMGestion.DimProcesoCarga dpc ON (ftp.idProcesoCarga = dpc.id)
                        INNER JOIN #MaximaPeriodoInformadoTrabajoPesadoTMP mpitp ON (dp.idPersonaOrigen = mpitp.id_mae_persona
                        AND ftp.idPeriodoInformado = mpitp.idPeriodoInformado)
                    WHERE dpc.codigo = cstUno --Carga Mensual
                    GROUP BY mpitp.id_mae_persona;
    
                    SELECT ustp.id_mae_persona,
                        MAX(ftp.porcentaje) porcentaje,
                        MAX(ftp.contadorPeriodosTasa2Porc) contadorPeriodosTasa2Porc,
                        MAX(ftp.contadorPeriodosTasa4Porc) contadorPeriodosTasa4Porc,
                        dp.rut
                    INTO #UniversoTrabajoPesadoTMP
                    FROM DMGestion.FctTrabajoPesado ftp
                        INNER JOIN DMGestion.DimPersona dp ON (ftp.idPersona = dp.id)
                        INNER JOIN DMGestion.DimProcesoCarga dpc ON (ftp.idProcesoCarga = dpc.id)
                        INNER JOIN #UltimaSobrecotizacionTrabajoPesadoTMP ustp
                        ON (dp.idPersonaOrigen = ustp.id_mae_persona
                        AND ftp.idPeriodoInformado = ustp.idPeriodoInformado
                        AND ftp.periodoCotizacion = ustp.periodoCotizacion)
                    WHERE dpc.codigo = cstUno --Carga Mensual
                    GROUP BY ustp.id_mae_persona,dp.rut;
    
              /************* ACTUALIZACION TRABAJO PESADO POR MOVIMIENTOS QUE NO ESTAN EN EL MODELO *********************/
               SELECT tmp.rut,
               (contadorPeriodosTasa2Porc + tasa2prc) tasa2,
               (contadorPeriodosTasa4Porc + tasa4prc) tasa4
               INTO #trPesadoSuma
               FROM #UniversoTrabajoPesadoTMP tmp
               INNER JOIN DMGestion.AgrTrabajoPesadoNoHabitat agr ON agr.rutAfiliado = tmp.rut AND agr.periodoInformado = ldtFechaPeriodoInformado;
    
               UPDATE #UniversoTrabajoPesadoTMP
               SET contadorPeriodosTasa2Porc  = b.tasa2,
               contadorPeriodosTasa4Porc = b.tasa4
               FROM #UniversoTrabajoPesadoTMP a
               INNER JOIN #trPesadoSuma b ON a.rut = b.rut;
    
               INSERT INTO #UniversoTrabajoPesadoTMP
               SELECT dp.idPersonaOrigen ,CONVERT(integer,NULL) porcentaje,agr.tasa2prc,agr.tasa4prc,rutAfiliado
               FROM DMGestion.AgrTrabajoPesadoNoHabitat agr
               INNER JOIN DMGestion.dimPersona dp ON agr.rutAfiliado = dp.rut AND dp.fechaVigencia = ldtMaximaFechaVigencia
               WHERE rutAfiliado NOT IN (SELECT rut FROM #UniversoTrabajoPesadoTMP)
               AND agr.periodoInformado = ldtFechaPeriodoInformado;
    
               /******************************************************************************************************/
    
                    --Se elimina tabla temporal
                    DROP TABLE #UltimaSobrecotizacionTrabajoPesadoTMP;
                    DROP TABLE #MaximaPeriodoInformadoTrabajoPesadoTMP;
    
                    --Pensionado en Renta Vitalicia con CCICO nueva en la AFP
                    SELECT DISTINCT a.id_mae_persona,
                        b.fec_movimiento,
                        a.cod_control
                    INTO #UniversoMovimiento87
                    FROM DMGestion.UniversoAfiliadoClienteTMP a
                        INNER JOIN DDS.TB_MAE_MOVIMIENTO b ON a.id_mae_persona = b.id_mae_persona
                        INNER JOIN DDS.TB_TIP_MOVIMIENTO c ON b.id_tip_movimiento = c.id_tip_movimiento
                    WHERE a.cod_control IN (cstCodControlVAL,
                                            cstCodControlPRV,
                                            cstCodControlAVP,
                                            cstCodControlAVV)
                    AND a.codigoTipoRol = cinTipoRol1
                    AND a.id_tip_estado_rol = cinEstadoRol2
                    AND b.fec_acreditacion <= ldtUltimaFechaMesInformar
                    AND c.cod_movimiento = cinMovRentaVita
                    AND a.esUniversoCuadro1 = cstSi;
    
                    SELECT DISTINCT a.id_mae_persona,
                        CONVERT(CHAR(1), cstSi) pensionadoRentaVitaliciaCCICONuevaAFP
                    INTO #UniversoPensionadoRentaVitalicia
                    FROM #UniversoMovimiento87 a
                        INNER JOIN DDS.VectorCotizaciones b ON (a.id_mae_persona = b.id_mae_persona)
                    WHERE b.codigoTipoProducto = ctiProductoCCICO --Producto CCICO
                    AND a.cod_control IN (cstCodControlVAL,
                                          cstCodControlPRV,
                                          cstCodControlAVP,
                                          cstCodControlAVV)
                    AND b.fec_acreditacion <= ldtUltimaFechaMesInformar
                    --El tope del per_cot es menor o igual a la fecha del periodo informado
                    AND b.per_cot <= ldtFechaPeriodoInformado
                    AND b.codigoSubGrupoMovimiento IN (cinMovimientoCCICO1,
                                                       cinMovimientoCCICO2,
                                                       cinMovimientoCCICO3)
                    AND b.fec_movimiento > a.fec_movimiento;
    
                /***************** COBERTURA SIS *****************************************************/
    
                
                    SELECT id_mae_persona,sexo ,edadActuarial,edadCubiertaSeguro,codigoTipoCobertura
                        INTO #UniversoTipoCoberturaTMP
                    FROM DMGestion.UniversoCubiertoSeguroTMP;
                
                
                /*************************************************************************************/
    
                    --Pensionado en retiro programado o renta temporal sin garantía estatal y saldo cero
                    --Universos de Pensionados
                    SELECT DISTINCT b.id_mae_persona
                    INTO #UniversoBeneficios
                    FROM DDS.SLB_BENEFICIOS a
                        INNER JOIN DMGestion.UniversoAfiliadoClienteTMP b ON (a.numcue = b.cuentaAntigua)
                    WHERE b.codigoTipoRol = cinTipoRol1 --Rol Persona
                    AND b.id_tip_estado_rol = cinEstadoRol2
                    AND b.ind_estado = cinIndEstado
                    AND a.cod_vigencia < cinCodVigencia30
                    AND a.tipo_pago = cinCodTipoPago2
                    AND b.esUniversoCuadro1 = cstSi
                    AND a.fecsol <= ldtUltimaFechaMesInformar;
    
                    --Universo de Pensionado con Movimientos de Retirado Programado ó Pago de
                    --Renta temporal
                    SELECT DISTINCT a.id_mae_persona
                    INTO #UniversoMovimiento63o64
                    FROM DMGestion.UniversoAfiliadoClienteTMP a
                        INNER JOIN DDS.TB_MAE_MOVIMIENTO b ON (a.id_mae_persona = b.id_mae_persona)
                        INNER JOIN DDS.TB_TIP_MOVIMIENTO c ON (b.id_tip_movimiento = c.id_tip_movimiento)
                    WHERE c.cod_movimiento IN (cinMovRetProgramado, cinMovPagoRentaTmp)
                    AND a.codigoTipoRol = cinTipoRol1
                    AND a.id_tip_estado_rol = cinEstadoRol2
                    AND a.ind_estado = cinIndEstado
                    AND a.esUniversoCuadro1 = cstSi
                    AND b.fec_acreditacion <= ldtUltimaFechaMesInformar;
    
                    --Universo Pensionado con cuentas CCICO en 0
                    SELECT DISTINCT a.id_mae_persona
                    INTO #UniversoCuentaCCICO
                    FROM DMGestion.UniversoAfiliadoClienteTMP a
                        INNER JOIN DDS.TB_MAE_CUENTA b ON (a.id_mae_persona = b.id_mae_persona)
                    WHERE a.codigoTipoRol = cinTipoRol1
                    AND a.id_tip_estado_rol = cinEstadoRol2
                    AND a.ind_estado = cinIndEstado
                    AND b.id_tip_producto = ctiProductoCCICO --Producto CCICO
                    AND b.saldo_cuota_control = cinCero
                    AND b.ind_estado = cinIndEstado
                    AND a.esUniversoCuadro1 = cstSi;
    
                    SELECT DISTINCT a.id_mae_persona
                    INTO #UniversoPenRPRTSinGarEstSaldo0
                    FROM #UniversoBeneficios a
                        INNER JOIN #UniversoMovimiento63o64 b ON (a.id_mae_persona = b.id_mae_persona)
                        INNER JOIN #UniversoCuentaCCICO c ON (a.id_mae_persona = c.id_mae_persona);
    
                    --Se elimina la tabla temporal
                    DROP TABLE #UniversoMovimiento63o64;
                    DROP TABLE #UniversoCuentaCCICO;
                    DROP TABLE #UniversoBeneficios;
    
                    --INI-INFESP-279
                    CREATE TABLE #UniversoAfiliadoPensionInvRevocadaCesada(
                        id_mae_persona              BIGINT  NOT NULL,
                        codigoMotivoCesePensionInv  CHAR(2) NOT NULL
                    );
    
                    --Afiliado con pensión de invalidez revocada o cesada
                    --se obtiene el universo de la solipen y invalpen
                    SELECT DISTINCT a.id_mae_persona,
                        a.cuentaAntigua,
                        b.fecsol,
                        c.femodif,
                        c.fecejec_cmc,
                        c.fecejec_cmr
                    INTO #UniversoSolicPenInvalPen
                    FROM DMGestion.UniversoAfiliadoClienteTMP a
                        INNER JOIN DDS.STP_SOLICPEN b ON (b.numcue = a.cuentaAntigua)
                        LEFT JOIN DDS.STP_INVALPEN c ON (c.numcue = b.numcue
                            AND c.tipoben = b.tipoben
                            AND c.fecsol = b.fecsol
                            AND c.numcorr = cinCero)
                    WHERE a.codigoTipoRol = cinTipoRol1
                    AND a.id_tip_estado_rol = cinEstadoRol1
                    AND b.tipoben = cinInvalidezTrans
                    AND b.codestsol = cinCodestsol2
                    AND a.esUniversoCuadro1 = cstSi
                    AND b.fecsol <= ldtUltimaFechaMesInformar;
    
                    --se obtiene la ultima fecha de solicitud
                    SELECT a.id_mae_persona,
                        a.cuentaAntigua,
                        a.fecsol,
                        a.femodif,
                        a.fecejec_cmc,
                        a.fecejec_cmr,
                        cstNo AS tipoben6,
                        CONVERT(INTEGER, NULL) AS cod_vigencia
                    INTO #UniversoRevocadaCesada
                    FROM(
                        SELECT dense_rank() OVER (PARTITION BY id_mae_persona
                                            ORDER BY fecsol DESC, femodif DESC) rank,
                            id_mae_persona,
                            cuentaAntigua,
                            fecsol,
                            femodif,
                            fecejec_cmc,
                            fecejec_cmr
                        from #UniversoSolicPenInvalPen
                    )a
                    WHERE a.rank = cinUno;
    
                    SELECT b.id_mae_persona,
                        a.codestsol
                    INTO #UniversoRevocadaCesada01TMP
                    FROM DDS.STP_SOLICPEN a
                        INNER JOIN #UniversoRevocadaCesada b ON (a.numcue = b.cuentaAntigua)
                    WHERE a.tipoben = cinTipoBen6
                    AND DATEDIFF(MONTH, b.fecsol, a.fecsol) <= cinTopeReevalucion;
    
                    DELETE FROM #UniversoRevocadaCesada01TMP WHERE codestsol != cinCodEstRechazo;
    
                    UPDATE #UniversoRevocadaCesada SET
                        u.tipoben6 = cstSi
                    FROM #UniversoRevocadaCesada u
                        JOIN #UniversoRevocadaCesada01TMP u1 ON (u.id_mae_persona = u1.id_mae_persona);
    
                    UPDATE #UniversoRevocadaCesada SET
                        a.cod_vigencia = s.cod_vigencia
                    FROM #UniversoRevocadaCesada a
                        JOIN DDS.SLB_MONTOBEN s ON (a.cuentaAntigua = s.numcue
                            AND s.tipoben = cinInvalidezTrans
                            AND a.fecsol = s.fecsol);
    
                    --01 Pensión de Invalidez revocada con Dictamen Ejecutoriado
                    INSERT INTO #UniversoAfiliadoPensionInvRevocadaCesada(id_mae_persona,
                        codigoMotivoCesePensionInv)
                    SELECT DISTINCT a.id_mae_persona,
                        CONVERT(CHAR(2), cstUno) codigoMotivoCesePensionInv
                    FROM #UniversoRevocadaCesada a
                    WHERE a.tipoben6 = cstSi
                    AND ((a.fecejec_cmc IS NOT NULL) OR (a.fecejec_cmr IS NOT NULL));
    
                    --02 Pensión de Invalidez cesada por no presentarse a la reevaluación
                    INSERT INTO #UniversoAfiliadoPensionInvRevocadaCesada(id_mae_persona,
                        codigoMotivoCesePensionInv)
                    SELECT DISTINCT a.id_mae_persona,
                        CONVERT(CHAR(2), cstDos) codigoMotivoCesePensionInv
                    FROM #UniversoRevocadaCesada a
                    WHERE a.tipoben6 = cstNo;
                    --FIN-INFESP-279
    
                    --Indicador de existencia de clave de seguridad
                    SELECT DISTINCT uc.id_mae_persona,
                        uc.rutPersona,
                        CONVERT(CHAR(1), cstSi) indicadorClaveSeguridad
                    INTO #ClaveSeguridad
                    FROM DMGestion.UniversoAfiliadoClienteTMP uc
                        INNER JOIN DDS.CLAVE_AFILIADO cafil ON (uc.rutPersona = cafil.rut)
                    WHERE cafil.COD_ESTADO_CLAVE IN (cinCuatro)
                    AND uc.esUniversoCuadro1 = cstSi;
    
                    --Indicador de movimiento de clave de seguridad
                    SELECT DISTINCT cs.id_mae_persona,
                           CONVERT(CHAR(1), cstSi) indicadorMovimientoClaveSeguridad
                    INTO #MovimientoClaveSeguridad
                    FROM DDS.LOG_TRANSACCION lt
                        INNER JOIN #ClaveSeguridad cs ON (cs.rutPersona = lt.rut)
                    WHERE fecha_transaccion
                        BETWEEN ldtFechaPeriodoInformado AND ldtUltimaFechaMesInformar
                    AND UCASE(Pagina_visitada) LIKE '%AUTENTICACION_VALIDA%';
    
                    --Se obtiene el tipo de pensión de los pensionados por vejez e invalidez traspasados a favor
                    SELECT a.numcue,
                        a.numrut,
                        CONVERT(BIGINT, NULL) id_mae_persona
                    INTO #UniversoPensionadosTMP
                    FROM (
                        SELECT a.numcue,
                            a.numrut
                        FROM DDS.SLB_BENEPAGO a
                        WHERE a.tipoben IN (cinTipoBen1,
                                            cinTipoBen2,
                                            cinTipoBen3,
                                            cinTipoBen5,
                                            cinTipoBen6)
                        AND a.fecsol <= ldtUltimaFechaMesInformar
                        UNION
                        SELECT s.numcue,
                            m.numrut
                        FROM DDS.STP_SOLICPEN s
                            INNER JOIN DDS.STP_MASOLPEN m ON (s.numcue = m.numcue)
                        WHERE s.tipoben IN (cinTipoBen1,
                                            cinTipoBen2,
                                            cinTipoBen3,
                                            cinTipoBen5,
                                            cinTipoBen6)
                        AND s.codestsol = cinCodestsol2 --Aprobado historico
                        AND s.fecsol <= ldtUltimaFechaMesInformar
                   ) a;
    
                    UPDATE #UniversoPensionadosTMP SET
                        a.id_mae_persona = b.idPersonaOrigen
                    FROM #UniversoPensionadosTMP a
                        JOIN DMGestion.DimPersona b ON (a.numcue = b.cuentaAntigua)
                    WHERE b.cuentaAntigua > cinCero
                    AND b.idPersonaOrigen > cinCero
                    AND b.fechaVigencia >= ldtMaximaFechaVigencia;
    
                    UPDATE #UniversoPensionadosTMP SET
                        a.id_mae_persona = b.idPersonaOrigen
                    FROM #UniversoPensionadosTMP a
                        JOIN DMGestion.DimPersona b ON (a.numrut = b.rut)
                    WHERE b.cuentaAntigua > cinCero
                    AND b.idPersonaOrigen > cinCero
                    AND a.id_mae_persona IS NULL
                    AND b.fechaVigencia >= ldtMaximaFechaVigencia;
    
                    SELECT DISTINCT id_mae_persona
                    INTO #SolicitudPensionAprobadaTMP
                    FROM #UniversoPensionadosTMP;
    
                    --se crea tabla temporal
                    CREATE TABLE #UniversoAgrupadoTMP(
                        numeroFila                      BIGINT          NULL,
                        idDimPersona                    BIGINT          NULL,
                        rutPersona                      BIGINT          NULL,
                        codigoSobrecotTrabajoPesado     CHAR(1)         DEFAULT '0',
                        idSubClasifPersona              INTEGER         NULL,
                        idNivelEducacional              INTEGER         NULL,
                        indSolicitaCartolaViaMail       CHAR(1)         NULL,
                        idEstadoCivil                   INTEGER         NULL,
                        codigoCanalSuscripcionCartola   INTEGER       NULL,
                        codigoTipoIncorporacion         CHAR(2)         NULL,
                        codigoControl                   CHAR(3)         NULL,
                        codigoEstado                    CHAR(2)         NULL,
                        codigoEstadoAnt                 CHAR(2)         NULL,
                        codigoMotivoCesePensionInv      CHAR(2)         NULL,
                        indEstadoRol                    TINYINT         NULL,
                        codigoTipoEstadoRol             TINYINT         NULL,
                        nombreTipoEstadoRol             VARCHAR(100)    NULL,
                        codigoActividadEconomica        BIGINT          NULL,
                        nombreActividadEconomica        VARCHAR(100)    NULL,
                        indTrabConvBilatSegSoc          CHAR(1)         NULL,
                        indTransFdoOtroEstado           CHAR(1)         NULL,
                        afiPenLegOtroEstadoConv         CHAR(1)         NULL,
                        paisPensionOtroEstado           CHAR(2)         NULL,
                        indExisteClaveSecreta           CHAR(1)         NULL,
                        indMovClaveSecreta              CHAR(1)         NULL,
                        indExisteClaveSeguridad         CHAR(1)         NULL,
                        indMovClaveSeguridad            CHAR(1)         NULL,
                        penRPRTSinGarEstSaldo0          CHAR(1)         NULL,
                        indPensRentaVitCCICONueva       CHAR(1)         NULL,
                        fechaAfiliacionSistema          DATE            NULL,
                        fechaIncorporacionAFP           DATE            NULL,
                        codigoTipoRol                   SMALLINT        NULL,
                        codigoTipoCoberturaSIS          CHAR(2)         NULL,
                        edad                            SMALLINT        NULL,
                        idSucursal                      INTEGER         DEFAULT 0,
                        fechaSolicitudCartola           DATE            NULL,
                        esCuadro1                       CHAR(1)         NULL,
                        idPersonaOrigen                 BIGINT          NULL,
                        codigoPaisNacimiento            CHAR(2)         NULL
                    );
    
                   /******************Codigo Estado******Giovani Chavez CGI 25-03-2013 (+)***************************/
                    --INICIO INFESP-123
                    --Saldo de a cuenta CCIAV y CCICO en CERO
                    SELECT c.rutPersona,
                        c.id_mae_persona
                    INTO #UniversoCuentasCCICO_CCIAVTMP
                    FROM DDS.tb_mae_cuenta a
                        INNER JOIN DDS.TB_TIP_PRODUCTO d ON (a.id_tip_producto = d.id_tip_producto)
                        INNER JOIN DMGestion.UniversoAfiliadoClienteTMP c ON (a.id_mae_persona  = c.id_mae_persona)
                    WHERE a.ind_estado = cinIndEstado
                    AND CONVERT(INTEGER, TRIM(d.cod_tip_producto)) IN (ctiProductoCCICO, ctiProductoCCIAV, ctiProductoCCIDC, ctiProductoCCICV)--Producto CCICO -INESP-220--)
                    GROUP BY c.rutPersona,
                        c.id_mae_persona
                    HAVING SUM(a.saldo_cuota_control) = cinCero;
    
                    --Se obtiene los afiliado que tienen algún movimiento CCICO y CCIAV, para los casos que tienen una cuenta
                    --CCICO y CCIAV con saldo CERO
                    SELECT DISTINCT a.rutPersona
                    INTO #AfiliadosTieneMovimientosCCICO_CCIAVTMP
                    FROM #UniversoCuentasCCICO_CCIAVTMP a
                        INNER JOIN DDS.VectorCotizaciones b ON (a.rutPersona = b.rut_mae_persona)
                    WHERE b.codigoTipoProducto IN (ctiProductoCCICO, ctiProductoCCIAV) --Producto CCICO
                    AND b.fec_acreditacion <= ldtUltimaFechaMesInformar
                    AND b.per_cot <= ldtFechaPeriodoInformado
                    AND b.codigoSubGrupoMovimiento IN (cinMovimientoCCICO1,
                                                       cinMovimientoCCICO2,
                                                       cinMovimientoCCICO3);
    
                    --Se elimina los casos que tienen una cuenta CCICO con saldo CERO, para los casos que no tienen
                    --un movimiento de cotización en el producto CCICO
                    DELETE FROM #UniversoCuentasCCICO_CCIAVTMP
                    WHERE rutPersona NOT IN (SELECT rutPersona
                                             FROM #AfiliadosTieneMovimientosCCICO_CCIAVTMP);
    
                    --Inicio Jira INFESP-63
                    --Se elimina los casos que tiene un movimiento 97 en el mes de informe, para el producto CCICO
                    SELECT DISTINCT u.rutPersona
                    INTO #UniversoMovimiento97TMP
                    FROM DDS.TB_MAE_MOVIMIENTO A
                        INNER JOIN #UniversoCuentasCCICO_CCIAVTMP U ON (A.ID_MAE_PERSONA = U.ID_MAE_PERSONA)
                    WHERE a.id_tip_movimiento = cbiIdTipMovimiento97
                    AND A.FEC_ACREDITACION BETWEEN ldtFechaPeriodoInformado AND ldtUltimaFechaMesInformar;
    
                    DELETE FROM #UniversoCuentasCCICO_CCIAVTMP
                    FROM #UniversoCuentasCCICO_CCIAVTMP u, #UniversoMovimiento97TMP u97
                    WHERE u.rutPersona = u97.rutPersona;
    
                    --Se elimina los casos que tiene un movimiento 560 en el mes de informe, para el producto CCIAV
                    SELECT DISTINCT u.rutPersona
                    INTO #UniversoMovimiento560TMP
                    FROM DDS.TB_MAE_MOVIMIENTO A
                        INNER JOIN #UniversoCuentasCCICO_CCIAVTMP U ON (A.ID_MAE_PERSONA = U.ID_MAE_PERSONA)
                    WHERE a.id_tip_movimiento = cbiIdTipMovimiento560
                    AND A.FEC_ACREDITACION BETWEEN ldtFechaPeriodoInformado AND ldtUltimaFechaMesInformar;
    
                    DELETE FROM #UniversoCuentasCCICO_CCIAVTMP
                    FROM #UniversoCuentasCCICO_CCIAVTMP u, #UniversoMovimiento560TMP u560
                    WHERE u.rutPersona = u560.rutPersona;
                    --Termino INFESP-123
                    --Termino Jira INFESP-63
    
                    -----------------------------------------------------INESP-220----------------------------------------------------------------
                    --Se elimina los casos que tiene movimientos de Traspaso en contra en el mes de informe, para el producto CCICV
                    SELECT DISTINCT u.rutPersona
                    INTO #UniversoMovimientoTC4
                    FROM DDS.TB_MAE_MOVIMIENTO A
                        INNER JOIN #UniversoCuentasCCICO_CCIAVTMP U ON (A.ID_MAE_PERSONA = U.ID_MAE_PERSONA)
                    WHERE A.FEC_ACREDITACION BETWEEN ldtFechaPeriodoInformado AND ldtUltimaFechaMesInformar
                    AND A.ID_TIP_MOVIMIENTO IN (select codigoTipoMovimiento from dds.grupoMovimiento
                                                where codigoProducto = ctiProductoCCICV and glosaGrupoMovimiento = cchTraspasoContra)
                    AND A.ID_TIP_PRODUCTO = ctiProductoCCICV;
    
                    DELETE FROM #UniversoCuentasCCICO_CCIAVTMP
                    FROM #UniversoCuentasCCICO_CCIAVTMP u, #UniversoMovimientoTC4 tc4
                    WHERE u.rutPersona = tc4.rutPersona;
    
                    --Se elimina los casos que tiene movimientos de Traspaso en contra en el mes de informe, para el producto CCIDC
                    SELECT DISTINCT u.rutPersona
                    INTO #UniversoMovimientoTC5
                    FROM DDS.TB_MAE_MOVIMIENTO A
                        INNER JOIN #UniversoCuentasCCICO_CCIAVTMP U ON (A.ID_MAE_PERSONA = U.ID_MAE_PERSONA)
                    WHERE A.FEC_ACREDITACION BETWEEN ldtFechaPeriodoInformado AND ldtUltimaFechaMesInformar
                    AND A.ID_TIP_MOVIMIENTO IN (select codigoTipoMovimiento from dds.grupoMovimiento
                                                where codigoProducto = ctiProductoCCIDC and glosaGrupoMovimiento = cchTraspasoContra)
                    AND A.ID_TIP_PRODUCTO = ctiProductoCCIDC;
    
                    DELETE FROM #UniversoCuentasCCICO_CCIAVTMP
                    FROM #UniversoCuentasCCICO_CCIAVTMP u, #UniversoMovimientoTC5 tc5
                    WHERE u.rutPersona = tc5.rutPersona;
    
                   --------------------------------------------------------------------------------------------------------------------------------
                   ----------Traspaso de saldo a cta cte por solicitud de pensión------------------------------------------------------------------
                    SELECT DISTINCT RUT_MAE_PERSONA RUT INTO #traspasoSaldoPorPension
                        FROM DDS.TB_MAE_MOVIMIENTO tmm
                        INNER JOIN DDS.TB_MAE_PERSONA tmp ON tmm.ID_MAE_PERSONA = tmp.ID_MAE_PERSONA
                        WHERE TMM.ID_TIP_MOVIMIENTO IN (ctiTraCtaCteCCICO,ctiTraCtaCteCCIAV)
                        AND ID_TIP_PRODUCTO IN (ctiProductoCCIAV,ctiProductoCCICO)
                        AND fec_movimiento <= ldtUltimaFechaMesInformar;
    
                   --------------------------------------------------------------------------------------------------------------------------------
                   ---------- Retiro 10% ----------------------------------------------------------------------------------------------------------
                                 SELECT DISTINCT RUT_MAE_PERSONA RUT INTO #Retiro10
                        FROM DDS.TB_MAE_MOVIMIENTO tmm
                        INNER JOIN DDS.TB_MAE_PERSONA tmp ON tmm.ID_MAE_PERSONA = tmp.ID_MAE_PERSONA
                        WHERE TMM.ID_TIP_MOVIMIENTO IN (SELECT  DISTINCT codigoTipoMovimiento
                              FROM DDS.GrupoMovimiento gm
                              WHERE codigoGrupoMovimiento IN (cinCOD2300,cinCOD2700)
                              AND codigoProducto IN (ctiProductoCCICO,ctiProductoCCIAV)
                              AND codigoSubgrupoMovimiento IN (cinCOD2305,cinCOD2307,cinCOD2308,cinCOD2709,cinCOD2710,cinCOD2711))
                        AND ID_TIP_PRODUCTO IN (ctiProductoCCIAV,ctiProductoCCICO)
                        AND fec_movimiento <= ldtUltimaFechaMesInformar;
    
                   --------------------------------------------------------------------------------------------------------------------------------
                    --Se obtiene los afiliados que tienen un bono sin importar su estado.
                    SELECT DISTINCT c.rutPersona
                    INTO #UniversoBonosTMP
                    FROM DDS.planobono_02  a
                        INNER JOIN DMGestion.UniversoAfiliadoClienteTMP c ON (a.rutTrabajador  = c.rutPersona );
                   /******************Codigo Estado******Giovani Chavez CGI 25-03-2013 (-)***************************/
    
                    --5. Se crea una tabla temporal con los datos del universo del cuadro 1
                    INSERT INTO #UniversoAgrupadoTMP(numeroFila,
                        idDimPersona,
                        rutPersona,
                        codigoSobrecotTrabajoPesado,
                        idSubClasifPersona,
                        idNivelEducacional,
                        indSolicitaCartolaViaMail,
                        idEstadoCivil,
                        codigoTipoIncorporacion,
                        codigoControl,
                        codigoEstado,
                        codigoEstadoAnt,
                        codigoMotivoCesePensionInv,
                        indEstadoRol,
                        codigoTipoEstadoRol,
                        nombreTipoEstadoRol,
                        codigoActividadEconomica,
                        nombreActividadEconomica,
                        indTrabConvBilatSegSoc,
                        indTransFdoOtroEstado,
                        afiPenLegOtroEstadoConv,
                        paisPensionOtroEstado,
                        indExisteClaveSecreta,
                        indMovClaveSecreta,
                        indExisteClaveSeguridad,
                        indMovClaveSeguridad,
                        penRPRTSinGarEstSaldo0,
                        indPensRentaVitCCICONueva,
                        fechaAfiliacionSistema,
                        fechaIncorporacionAFP,
                        codigoTipoRol,
                        codigoTipoCoberturaSIS,
                        edad,
                        idPersonaOrigen,
                        esCuadro1)
                    SELECT up.numeroFila,
                        up.idDimPersona,
                        up.rutPersona,
                        (CASE
                            WHEN (up.cod_control IN (cstCodControlVAL, cstCodControlPRV,
                                  cstCodControlAVP, cstCodControlAVV)
                                AND (up.codigoTipoRol = cinTipoRol1)
                                AND (up.id_tip_estado_rol
                                    IN (cinEstadoRol1, cinEstadoRol2, cinEstadoRol4))) THEN
                                CASE
                                    WHEN (utp.id_mae_persona IS NOT NULL) THEN cstSi
                                    ELSE cstNo
                                END
                            ELSE cstZ
                         END
                        ) codigoSobrecotTrabajoPesado,
                        up.idSubClasifPersona,
                        (CASE WHEN up.idNivelEducacional >= cinCero
                            THEN up.idNivelEducacional ELSE cinCero END) idNivelEducacional,
                         cstNo indSolicitaCartolaViaMail, --Indicador por default 27-05-2014 CGI Chile
                        (CASE WHEN up.idEstadoCivil >= cinCero
                            THEN up.idEstadoCivil ELSE cinCero END) idEstadoCivil,
                        /*CGI ISP 181 (+) 10-03-2014 */
                        (CASE
                            WHEN (up.cod_control IN (cstCodControlPRV, cstCodControlVAL)
                                AND (up.codigoTipoRol = cinTipoRol1)
                                AND (up.id_tip_estado_rol IN (cinEstadoRol1,cinEstadoRol2,
                                                              cinEstadoRol4,cinEstadoRol5))) THEN
                                (CASE
                                    WHEN (up.id_tip_trabajador IN (cinTipoTrabajador1, cinTipoTrabajador7,
                                                                   cinTipoTrabajador8)) THEN cstUno
                                    WHEN (up.id_tip_trabajador IN (cinTipoTrabajador2, cinTipoTrabajador9)) THEN cstDos
                                    ELSE cstCero
                                 END)
                            WHEN (up.cod_control IN (cstCodControlVRF, cstCodControlTAS)
                                 AND (up.codigoTipoRol = cinTipoRol7
                                 OR up.id_tip_estado_rol = cinEstadoRol4)) THEN  cstTres
                            WHEN (up.cod_control IN (cstCodControlAPP, cstCodControlAPV,
                                                     cstCodControlACP, cstCodControlACV,
                                                     cstCodControlCAP, cstCodControlCAV)
                                 AND (up.codigoTipoRol IN (cinTipoRol7, cinTipoRol12)
                                 OR up.id_tip_estado_rol = cinEstadoRol4)) THEN cstCuatro
                            WHEN (up.cod_control IN (cstCodControlAVV, cstCodControlAVP)
                                AND (up.codigoTipoRol = cinTipoRol1)
                                AND (up.id_tip_trabajador IN (cinTipoTrabajador3, cinTipoTrabajador10))
                                AND (up.id_tip_estado_rol IN (cinEstadoRol1,cinEstadoRol2,
                                                              cinEstadoRol4,cinEstadoRol5)))
                                THEN cstCinco
                            WHEN up.cod_control = cstCodControlOCE THEN
                                cstSeis
                            ELSE cstCero
                         END
                        ) codigoTipoIncorporacion,
                        /*CGI ISP 181 (-) 10-03-2014 */
                        (CASE
                            WHEN (up.cod_control IN (cstCodControlVAL,
                                                     cstCodControlPRV,
                                                     cstCodControlTAS,
                                                     cstCodControlVRF,
                                                     cstCodControlAVP,
                                                     cstCodControlAVV,
                                                     cstCodControlAPV,
                                                     cstCodControlAPP,
                                                     cstCodControlACV,
                                                     cstCodControlACP,
                                                     cstCodControlCAV,
                                                     cstCodControlCAP,
                                                     cstCodControlOCE)) THEN
                                up.cod_control
                            ELSE cstCero
                         END
                        ) codigoControl,
                        (CASE
                            --00 No corresponde informar
                            WHEN (up.codigoTipoRol IN (cinTipoRol7, cinTipoRol12) OR up.cod_control = cstCodControlOCE) THEN cstDobleCero
                            --02 Afiliado vivo pensionado
                            WHEN (up.codigoTipoRol = cinTipoRol1)
                                AND (up.id_tip_estado_rol = cinEstadoRol2) THEN cstDos
                            --04 Fallecido que causan pensión.
                            WHEN (up.codigoTipoRol = cinTipoRol1)
                                AND (up.id_tip_estado_rol = cinEstadoRol4)
                                AND (spa.id_mae_persona IS NOT NULL) THEN cstCuatro
                            --03 Fallecido no pensionado
                            WHEN (up.codigoTipoRol = cinTipoRol1)
                                AND (up.id_tip_estado_rol = cinEstadoRol4)
                                AND (spa.id_mae_persona IS NULL) THEN cstTres
                            --05 Afiliados sin derecho a pensión.
                            WHEN (up.codigoTipoRol = cinTipoRol1)
                                AND (uccicco.rutPersona IS NOT NULL)
                                AND (ubono.rutPersona IS NULL)
                                AND (trasxs.rut IS NULL)
                                AND (reti.rut IS NULL)
                              THEN cstCinco
                            --01 Afiliado vivo no pensionado
                            WHEN (up.codigoTipoRol = cinTipoRol1)
                                AND (up.id_tip_estado_rol = cinEstadoRol1) THEN cstUno
                            --Para los Traspasados
                            --02 Afiliado vivo pensionado
                            WHEN (up.codigoTipoRol = cinTipoRol1)
                                AND (up.id_tip_estado_rol = cinEstadoRol5)
                                AND (dscp.codigo = ctiCodigoSubClasPerTrasPen) THEN cstDos
                            --04 Fallecido que causan pensión.
                            WHEN (up.codigoTipoRol = cinTipoRol1)
                                AND (up.id_tip_estado_rol = cinEstadoRol5)
                                AND (dscp.codigo = ctiCodigoSubClasPerTrasFall)
                                AND (spa.id_mae_persona IS NOT NULL) THEN cstCuatro
                            --03 Fallecido no pensionado
                            WHEN (up.codigoTipoRol = cinTipoRol1)
                                AND (up.id_tip_estado_rol = cinEstadoRol5)
                                AND (dscp.codigo = ctiCodigoSubClasPerTrasFall)
                                AND (spa.id_mae_persona IS NULL) THEN cstTres
                            --01 Afiliado vivo no pensionado
                            --(Esto es solo para el modelo ya que no se informan los afiliados traspasados)
                            WHEN (up.codigoTipoRol = cinTipoRol1)
                                AND (up.id_tip_estado_rol = cinEstadoRol5)
                                AND (dscp.codigo = ctiCodigoSubClasPerTrasAfil) THEN cstUno
                            ELSE cstCero
                         END
                        ) codigoEstado,
                        (CASE
                            WHEN (up.codigoTipoRol  IN (cinTipoRol7, cinTipoRol12) OR up.cod_control = cstCodControlOCE) THEN cstDobleCero
                            WHEN ((up.id_tip_estado_rol = cinEstadoRol1) AND (up.codigoTipoRol = cinTipoRol1)) THEN cstUno
                            WHEN ((up.id_tip_estado_rol = cinEstadoRol2) AND (up.codigoTipoRol = cinTipoRol1)) THEN cstTres
                            WHEN ((up.id_tip_estado_rol = cinEstadoRol4) AND (up.codigoTipoRol = cinTipoRol1)) THEN cstCuatro
                            ELSE cstCero
                         END
                        ) codigoEstadoAnt,
                        (CASE
                            WHEN (up.cod_control
                                IN (cstCodControlVAL, cstCodControlPRV,
                                    cstCodControlAVP, cstCodControlAVV)
                                AND (up.codigoTipoRol = cinTipoRol1)
                                AND (up.id_tip_estado_rol = cinEstadoRol1)
                                AND (l.id_mae_persona IS NOT NULL)) THEN
                                l.codigoMotivoCesePensionInv
                            ELSE cstDobleCero
                         END
                        ) codigoMotivoCesePensionInv,
                        up.ind_estado indEstadoRol,
                        up.id_tip_estado_rol codigoTipoEstadoRol,
                        up.des_tip_estado_rol nombreTipoEstadoRol,
                        up.cod_act_economica codigoActividadEconomica,
                        up.des_larga_act_eco nombreActividadEconomica,
                        cstNo indTrabConvBilatSegSoc,
                        cstNo indTransFdoOtroEstado,
                        cstNo afiPenLegOtroEstadoConv,
                        CONVERT(CHAR(2), NULL) paisPensionOtroEstado,
                        CONVERT(CHAR(1), cstNo) indExisteClaveSecreta,
                        CONVERT(CHAR(1), cstNo) indMovClaveSecreta,
                        ISNULL(cs.indicadorClaveSeguridad, cstNo) indExisteClaveSeguridad,
                        ISNULL(mcs.indicadorMovimientoClaveSeguridad, cstNo) indMovClaveSeguridad,
                        (CASE
                            WHEN ((up.codigoTipoRol = cinTipoRol1)
                                  AND (up.id_tip_estado_rol = cinEstadoRol2)
                                  AND (up.ind_estado = cinIndEstado)
                                  AND (k.id_mae_persona IS NOT NULL)) THEN
                                cstSi
                            ELSE cstNo
                         END
                        ) penRPRTSinGarEstSaldo0,
                        (CASE
                            WHEN (up.cod_control
                                IN (cstCodControlVAL, cstCodControlPRV,
                                    cstCodControlAVP, cstCodControlAVV)
                                AND (up.codigoTipoRol = cinTipoRol1)
                                AND (up.id_tip_estado_rol = cinEstadoRol2)
                                AND (j.id_mae_persona IS NOT NULL)) THEN
                                j.pensionadoRentaVitaliciaCCICONuevaAFP
                            ELSE cstNo
                         END
                        ) indPensRentaVitCCICONueva,
                        up.fechaAfiliacion fechaAfiliacionSistema, -- DATAWCL - 526
                        up.fechaIncorporacion fechaIncorporacionAFP,
                        up.codigoTipoRol,
                        ISNULL(utcsis.codigoTipoCobertura, cstTres) codigoTipoCoberturaSIS,
                        up.edad,
                        up.id_mae_persona idPersonaOrigen,
                        cstSi esCuadro1
                    FROM DMGestion.UniversoAfiliadoClienteTMP up
                        LEFT OUTER JOIN #UniversoTrabajoPesadoTMP utp ON (up.id_mae_persona = utp.id_mae_persona)
                        LEFT OUTER JOIN #UniversoPensionadoRentaVitalicia j ON (up.id_mae_persona = j.id_mae_persona)
                        LEFT OUTER JOIN #UniversoPenRPRTSinGarEstSaldo0 k ON (up.id_mae_persona = k.id_mae_persona)
                        LEFT OUTER JOIN #UniversoAfiliadoPensionInvRevocadaCesada l ON (up.id_mae_persona = l.id_mae_persona)
                        LEFT OUTER JOIN #ClaveSeguridad cs ON (up.id_mae_persona = cs.id_mae_persona)
                        LEFT OUTER JOIN #MovimientoClaveSeguridad mcs ON (up.id_mae_persona = mcs.id_mae_persona)
                        LEFT OUTER JOIN #UniversoTipoCoberturaTMP utcsis ON (up.id_mae_persona = utcsis.id_mae_persona)
                        LEFT OUTER JOIN #UniversoCuentasCCICO_CCIAVTMP uccicco ON (up.rutPersona = uccicco.rutPersona)
                        LEFT OUTER JOIN #UniversoBonosTMP ubono ON (up.rutPersona = ubono.rutPersona)
                        LEFT OUTER JOIN #SolicitudPensionAprobadaTMP spa ON (up.id_mae_persona = spa.id_mae_persona)
                        LEFT OUTER JOIN DMGestion.DimSubClasificacionPersona dscp ON (up.idSubClasifPersona = dscp.id)
                        LEFT OUTER JOIN #traspasoSaldoPorPension trasxs ON (up.rutPersona = trasxs.rut)
                        LEFT OUTER JOIN #Retiro10                reti   ON (up.rutPersona = reti.rut)
                    WHERE up.esUniversoCuadro1 = cstSi;
    
                    --5.1 Determina trabajador acogido a Convenio Bilateral de SeguridadSocial
                    UPDATE #UniversoAgrupadoTMP SET
                        up.indTrabConvBilatSegSoc = cstSi
                    FROM #UniversoAgrupadoTMP up
                        JOIN #UniversoConvenioInternacional uci ON (up.idPersonaOrigen = uci.id_mae_persona)
                    WHERE up.codigoEstado = cstDos
                    AND UPPER(uci.estadoSolicitudConvenio) = UPPER(cchConcedida);
    
                    --5.2 Determina el país pensión otro estado
                    UPDATE #UniversoAgrupadoTMP SET
                        up.paisPensionOtroEstado = uci.paisPensionOtroEstado
                    FROM #UniversoAgrupadoTMP up
                        JOIN #UniversoConvenioInternacional uci ON (up.idPersonaOrigen = uci.id_mae_persona)
                    WHERE up.indTrabConvBilatSegSoc = cstSi;
    
                    -- Versión anterior para indicar Trabajador con proceso de transferencia de fondos a otro Estado
                    -- 5.3 Determina trabajador con proceso de transferencia de fondos a otroEstado
                    /*
                    SELECT DISTINCT dp.id idDimPersona
                    INTO #UniversoMovConvenioChilePeru
                    FROM DDS.TB_MAE_MOVIMIENTO tm
                        INNER JOIN DDS.CodigoTrafil02 vct ON (tm.id_tip_producto = vct.id_tip_producto
                            AND tm.id_tip_movimiento = vct.id_tip_movimiento)
                        INNER JOIN DMGestion.DimPersona DP ON tm.id_mae_persona = DP.idPersonaOrigen
                    WHERE vct.codigoSubGrupoMovimiento = cinSubGrupoMov2405;
    
                    UPDATE #UniversoAgrupadoTMP SET
                        indTransFdoOtroEstado = cstSi
                    WHERE codigoEstado IN (cstUno,cstDos,cstTres,cstCuatro)
                    AND idDimPersona IN (SELECT idDimPersona
                                         FROM #UniversoMovConvenioChilePeru);
                    */
                    -----------------------------------------------------------------------------------------------
                    -- JIRA INFESP-50: Convenio Chile - Perú
                    -- Trabajador con proceso de transferencia de fondos a otro Estado
                    -- Toda solicitud aceptada con transferencia en trámite
                    -----------------------------------------------------------------------------------------------
                    SELECT
                        periodoInformado,
                        fechaSolTransferencia,
                        paisDestinoTransferencia,
                        idPersona,
                        rut
                    INTO #convenioChilePeru
                    FROM(
                        SELECT
                            DATEADD([month], dateDiff([month], '19000101', a.envioSolPaisDestino), '19000101') periodoInformado,
                            a.envioSolPaisDestino           fechaSolTransferencia,
                            cchCodChile                     paisDestinoTransferencia,
                            dp.id                           idPersona,
                            a.rut
                        FROM DDS.solTransferenciaPeruChile a
                            INNER JOIN DMGestion.DimPersona dp ON ( a.rut = dp.rut AND dp.fechaVigencia >= ldtMaximaFechaVigencia )
                        WHERE periodoInformado <= ldtFechaPeriodoInformado
                        AND LOWER(a.estadoSolicitud) = cstSolAceptado
                        AND ISNULL( LOWER(a.estadoTransferencia ), cstSolEnTramite ) = cstSolEnTramite
                        UNION
                        SELECT
                            DATEADD([month], dateDiff([month], '19000101', a.recepcionSolPaisOrigen), '19000101') periodoInformado,
                            a.recepcionSolPaisOrigen        fechaSolTransferencia,
                            cchCodPeru                      paisDestinoTransferencia,
                            dp.id                           idPersona,
                            a.rut
                        FROM DDS.solTransferenciaChilePeru a
                            INNER JOIN DMGestion.DimPersona dp ON ( a.rut = dp.rut AND dp.fechaVigencia >= ldtMaximaFechaVigencia )
                        WHERE periodoInformado <= ldtFechaPeriodoInformado
                        AND LOWER(a.estadoSolicitud) = cstSolEnTramite
                    ) a ORDER BY fechaSolTransferencia;
    
                    UPDATE #UniversoAgrupadoTMP SET
                        indTransFdoOtroEstado = cstSi
                    WHERE idDimPersona IN (SELECT idPersona
                                         FROM #convenioChilePeru);
    
                    --5.4 Determina afiliado pensionado bajo la legislación de otro Estado sujeto a
                    --convenio
                    UPDATE #UniversoAgrupadoTMP SET
                        up.afiPenLegOtroEstadoConv = cstSi
                    FROM #UniversoAgrupadoTMP up
                        JOIN #UniversoConvenioInternacional uci ON (up.idPersonaOrigen = uci.id_mae_persona)
                    WHERE up.codigoEstado IN (cstUno, cstDos)
                    AND UPPER(uci.estadoSolicitudConvenio) = UPPER(cchEnTramite);
    
                    --5.5 Indicador de existencia de clave secreta
                    UPDATE #UniversoAgrupadoTMP SET
                        ua.indExisteClaveSecreta = cstSi
                    FROM #UniversoAgrupadoTMP ua
                    JOIN DMGestion.DimPersona dp ON (ua.idDimPersona = dp.id)
                    WHERE dp.idPersonaOrigen IN (SELECT DISTINCT id_mae_persona
                                                 FROM DDS.TB_INGRESO
                                                 WHERE ind_estado = cinIndEstado);
    
                    --5.6 Indicador de movimiento clave secreta
                    UPDATE #UniversoAgrupadoTMP SET
                        ua.indMovClaveSecreta = cstSi
                    FROM #UniversoAgrupadoTMP ua
                        JOIN DMGestion.DimPersona dp ON (ua.idDimPersona = dp.id)
                    WHERE dp.rut IN (SELECT DISTINCT(rut_mae_persona)
                                     FROM DDS.TB_ACCION_CLAVE
                                     WHERE canal = cchCanalWeb
                                     AND id_tip_accion_clave = cinTres
                                     AND ind_estado = cinIndEstado
                                     AND aud_fec_creac BETWEEN ldtFechaPeriodoInformado
                                     AND ldtUltimaFechaMesInformar);
    
                    --6.1. Se incorpora los tipo de rol que no son persona,
                    --clientes y que no tienen rol asociado
                    INSERT INTO #UniversoAgrupadoTMP(
                        numeroFila,
                        idDimPersona,
                        idSubClasifPersona,
                        idNivelEducacional,
                        idEstadoCivil,
                        rutPersona,
                        codigoTipoIncorporacion,
                        codigoControl,
                        codigoEstado,
                        codigoEstadoAnt,
                        codigoMotivoCesePensionInv,
                        indEstadoRol,
                        codigoTipoEstadoRol,
                        nombreTipoEstadoRol,
                        codigoActividadEconomica,
                        nombreActividadEconomica,
                        indTrabConvBilatSegSoc,
                        indTransFdoOtroEstado,
                        afiPenLegOtroEstadoConv,
                        paisPensionOtroEstado,
                        indExisteClaveSecreta,
                        indMovClaveSecreta,
                        indExisteClaveSeguridad,
                        indMovClaveSeguridad,
                        penRPRTSinGarEstSaldo0,
                        indPensRentaVitCCICONueva,
                        fechaAfiliacionSistema,
                        fechaIncorporacionAFP,
                        codigoTipoCoberturaSIS,
                        edad,
                        esCuadro1)
                    SELECT DISTINCT
                        a.numeroFila,
                        a.idDimPersona,
                        0,
                        (CASE
                            WHEN a.idNivelEducacional >= 0 THEN
                                a.idNivelEducacional
                            ELSE 0
                         END) idNivelEducacional,
                        (CASE
                            WHEN a.idEstadoCivil >= 0 THEN
                                a.idEstadoCivil
                            ELSE 0
                         END) idEstadoCivil,
                        a.rutPersona,
                        cstCero,
                        a.cod_control,
                        cstDobleCero,
                        cstDobleCero,
                        cstDobleCero,
                        a.ind_estado,
                        a.id_tip_estado_rol,
                        a.des_tip_estado_rol,
                        a.cod_act_economica,
                        a.des_larga_act_eco,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        CONVERT(CHAR(2), '03'),
                        a.edad,
                        cstNo
                    FROM DMGestion.UniversoAfiliadoClienteTMP a
                    WHERE a.esUniversoCuadro1 = cstNo;
    
                    --Sucursal Mas cercana
                    UPDATE #UniversoAgrupadoTMP
                    SET idSucursal = b.idSucursal
                    FROM #UniversoAgrupadoTMP a
                        INNER JOIN DMGestion.DireccionContactoAfiliadoTMP b
                            ON (a.rutPersona = b.rutPersona)
                    WHERE b.id_tip_direccion = cinUno;
    
                    -- Fecha solicitud cartola via electrónica GChavez CGI 20-05-2014 (+)
                    --Universo Cartolas con Suscripcion
                    SELECT MAX(a.fec_inicio_envio) fec_inicio_envio,
                        a.id_mae_persona
                    INTO #MaximaFechaSuscripCartola
                    FROM DDS.TB_SUSCRIPCION_DOC a
                        INNER JOIN DDS.TB_TIP_DOC_SUSCRIPCION b on (a.id_tip_doc_susc = b.id_tip_doc_susc)
                    WHERE a.id_tip_doc_susc = cinUno --Cartola Cuatrimestral
                        AND a.ind_estado_suc = cinUno  -- Activo
                        AND b.ind_estado= cinUno  --Activo
                        AND a.fec_inicio_envio <= ldtUltimaFechaMesInformar
                    GROUP BY a.id_mae_persona;
    
                    SELECT DISTINCT a.id_mae_persona,
                        a.fec_inicio_envio,
                        a.id_tip_canal
                    INTO #UniversoFechaSuscripCartola
                    FROM DDS.TB_SUSCRIPCION_DOC a
                        INNER JOIN DDS.TB_TIP_DOC_SUSCRIPCION b on (a.id_tip_doc_susc = b.id_tip_doc_susc)
                        INNER JOIN #MaximaFechaSuscripCartola m ON (a.id_mae_persona = m.id_mae_persona
                        AND a.fec_inicio_envio = m.fec_inicio_envio)
                    WHERE a.id_tip_doc_susc = cinUno --Cartola Cuatrimestral
                        AND a.ind_estado_suc = cinUno  -- Activo
                        AND b.ind_estado= cinUno  --Activo
                        AND a.fec_inicio_envio <= ldtUltimaFechaMesInformar;
    
                    UPDATE #UniversoAgrupadoTMP
                    SET a.indSolicitaCartolaViaMail = cstSi,
                        a.fechaSolicitudCartola = b.fec_inicio_envio,
                        a.codigoCanalSuscripcionCartola = b.id_tip_canal
                    FROM #UniversoAgrupadoTMP a
                        JOIN #UniversoFechaSuscripCartola b ON (a.idPersonaOrigen = b.id_mae_persona)
                    WHERE a.indSolicitaCartolaViaMail = cstNo;
    
                    -- Fecha solicitud cartola via electrónica GChavez CGI 20-05-2014 (-)
                    --Pais de Nacimiento
                    UPDATE #UniversoAgrupadoTMP SET
                        a.codigoPaisNacimiento = b.COD_PAIS
                    FROM #UniversoAgrupadoTMP a
                        JOIN DDS.NACIONALIDAD_PERSONA b ON (a.idPersonaOrigen = b.id_mae_persona);
    
                    -- Se crea un universo con lo que se va a registrar, asociando sus respectivas
                    -- dimensiones
                    SELECT
                        ISNULL(a.idDimPersona, 0) idDimPersona,
                        ISNULL(dstp.id, 0) idDimSobrecotizacionTrabajoPesado,
                        ISNULL(e.id, 0) idSubClasifPersona,
                        ISNULL(j.id, 0) idNivelEducacional,
                        ISNULL(i.id, 0) idEstadoCivil,
                        ISNULL(b.id, 0) idDimTipoIncorporacionSistema,
                        ISNULL(c.id, 0) idDimTipoControl,
                        ISNULL(d.id, 0) idDimTipoEstado,
                        ISNULL(g.id, 0) idDimMotivoCesePensionInvalidez,
                        ISNULL(h.id, 0) idDimTipoCobertura,
                        ISNULL(a.indEstadoRol, 0) indEstadoRol,
                        ISNULL(a.codigoTipoEstadoRol, 0) codigoTipoEstadoRol,
                        ISNULL(a.nombreTipoEstadoRol, cchEspacionBlanco) nombreTipoEstadoRol,
                        ISNULL(f.id, 0) idActividadEconomica,
                        ISNULL(a.idSucursal, 0) idSucursal,
                        ISNULL(dcs.id, 0) idCanalSuscripcionCartola,
                        ISNULL(dpa.id, cinCero) idPaisNacimiento,
                        a.nombreActividadEconomica,
                        ISNULL(a.indTrabConvBilatSegSoc, cchEspacionBlanco) indTrabConvBilatSegSoc,
                        ISNULL(a.indTransFdoOtroEstado, cchEspacionBlanco) indTransFdoOtroEstado,
                        ISNULL(a.afiPenLegOtroEstadoConv, cchEspacionBlanco) afiPenLegOtroEstadoConv,
                        a.paisPensionOtroEstado,
                        ISNULL(a.indExisteClaveSecreta, cchEspacionBlanco) indExisteClaveSecreta,
                        ISNULL(a.indMovClaveSecreta, cchEspacionBlanco) indMovClaveSecreta,
                        ISNULL(a.indExisteClaveSeguridad, cchEspacionBlanco) indExisteClaveSeguridad,
                        ISNULL(a.indMovClaveSeguridad, cchEspacionBlanco) indMovClaveSeguridad,
                        ISNULL(a.penRPRTSinGarEstSaldo0, cchEspacionBlanco) penRPRTSinGarEstSaldo0,
                        ISNULL(a.indPensRentaVitCCICONueva, cchEspacionBlanco) indPensRentaVitCCICONueva,
                        a.fechaAfiliacionSistema,
                        a.fechaIncorporacionAFP,
                        a.codigoTipoIncorporacion,
                        a.codigoEstado,
                        a.codigoEstadoAnt,
                        a.codigoControl,
                        a.esCuadro1,
                        a.indSolicitaCartolaViaMail,
                        a.fechaSolicitudCartola,
                        IsNULL(a.edad, 0) edad,
                        a.numeroFila,
                        CONVERT(BIGINT, NULL) idError
                    INTO #UniversoRegistroTMP
                    FROM #UniversoAgrupadoTMP a
                        LEFT OUTER JOIN DMGestion.DimTipoIncorporacionSistema b ON (a.codigoTipoIncorporacion = b.codigo
                            AND b.fechaVigencia >= ldtMaximaFechaVigencia)
                        LEFT OUTER JOIN DMGestion.DimTipoControl c ON (a.codigoControl = c.codigo
                            AND c.fechaVigencia >= ldtMaximaFechaVigencia)
                        LEFT OUTER JOIN DMGestion.DimTipoEstado d ON (a.codigoEstado = d.codigo
                            AND d.fechaVigencia >= ldtMaximaFechaVigencia)
                        LEFT OUTER JOIN DMGestion.DimSobrecotizacionTrabajoPesado dstp ON (a.codigoSobrecotTrabajoPesado = dstp.codigo
                            AND dstp.fechaVigencia >= ldtMaximaFechaVigencia)
                        LEFT OUTER JOIN DMGestion.DimSubClasificacionPersona e ON (a.idSubClasifPersona = e.codigo
                            AND e.fechaVigencia >= ldtMaximaFechaVigencia)
                        LEFT OUTER JOIN DMGestion.DimActividadEconomica f ON (a.codigoActividadEconomica = f.codigo
                            AND f.fechaVigencia >= ldtMaximaFechaVigencia)
                        LEFT OUTER JOIN DMGestion.DimMotivoCesePensionInvalidez g ON (a.codigoMotivoCesePensionInv = g.codigo
                            AND g.fechaVigencia >= ldtMaximaFechaVigencia)
                        LEFT OUTER JOIN DMGestion.DimTipoCobertura h ON (a.codigoTipoCoberturaSIS = h.codigo
                            AND h.fechaVigencia >= ldtMaximaFechaVigencia)
                        LEFT OUTER JOIN DMGestion.DimEstadoCivil i ON (a.idEstadoCivil = i.codigo
                            AND i.fechaVigencia >= ldtMaximaFechaVigencia)
                        LEFT OUTER JOIN DMGestion.DimNivelEducacional j ON (a.idNivelEducacional = j.codigo
                            AND j.fechaVigencia >= ldtMaximaFechaVigencia)
                        LEFT OUTER JOIN DMGestion.DimCanal dcs ON (a.codigoCanalSuscripcionCartola = dcs.codigo
                            AND dcs.fechaVigencia >= ldtMaximaFechaVigencia)
                        LEFT OUTER JOIN DMGestion.DimPais dpa ON (UPPER(a.codigoPaisNacimiento) = UPPER(dpa.codigo)
                            AND dpa.fechaVigencia >= ldtMaximaFechaVigencia);
    
                    --7.1. Se elimina las tablas temporales.
                    DROP TABLE #UniversoAgrupadoTMP;
                    DROP TABLE DMGestion.UniversoAfiliadoClienteTMP;
                    DROP TABLE DMGestion.DireccionContactoAfiliadoTMP;
                    DROP TABLE DMGestion.UniversoCubiertoSeguroTMP;
                    DROP TABLE #UniversoConvenioInternacional;
    
                    --DROP TABLE #UniversoPensionadoRentaVitalicia;
                    DROP TABLE #UniversoPenRPRTSinGarEstSaldo0;
                    DROP TABLE #UniversoAfiliadoPensionInvRevocadaCesada;
                    --DROP TABLE #UniversoMaximaFechasTMP;
    
                    --Eliminación del universo código trafil02
                    CALL DDS.cargarUniversoCodigoTrafil02(ctiBorrarTablaCodigoTrafil02);
    
                    ----------------------------------------------------------------------
                    --Generación de Universo de Errores
                    ----------------------------------------------------------------------
    
                    --Actualiza el numero de fila que corresponde
                    UPDATE #UniversoRegistroTMP a SET
                         numeroFila = ROWID(a);
                    /*
                    CREATE TABLE #UniversoErrores(
                        idError             BIGINT          NULL,
                        numeroFila          BIGINT          NOT NULL,
                        nombreColumna       VARCHAR(50)     NOT NULL,
                        tipoError           CHAR(1)         NOT NULL,
                        idCodigoError       BIGINT          NOT NULL,
                        descripcionError    VARCHAR(500)    NOT NULL
                     );
    
                    --8.1. Error de inconsistencia fecha de nacimiento con valor nulo
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idPersona' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        'Fecha de nacimiento con valor nulo. Origen de extracción (TB_MAE_PERSONA)'
                            descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.DimPersona dp ON ur.idDimPersona = dp.id
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1008
                    WHERE ur.esCuadro1 = cstSi
                    AND dp.fechaNacimiento IS NULL;
    
                    --8.2. Error de inconsistencia fecha de nacimiento mayor a fecha del periodo
                    -- a informar
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idPersona' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                        ce.id idCodigoError,
                        'Fecha de nacimiento es mayor al periodo a informar.
                            Origen de extracción (TB_MAE_PERSONA)' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.DimPersona dp ON ur.idDimPersona = dp.id
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1009
                    WHERE ur.esCuadro1 = cstSi
                    AND dp.fechaNacimiento > ldtUltimaFechaMesInformar;
    
                    --8.3. Error de inconsistencia fecha de afiliación es menor a 01/05/1981
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'fechaAfiliacionSistema' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                        ce.id idCodigoError,
                        'Fecha de afiliación '+
                        +'(' ||CONVERT(VARCHAR, ur.fechaAfiliacionSistema, 103) || ')'+
                        'es menor a 01/05/1981' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1010
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.fechaAfiliacionSistema < ldtMinimaFechaIncorpOAfi;
    
                    --8.4. Error de inconsistencia fecha de afiliación es mayor al periodo a informar
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'fechaAfiliacionSistema' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                        ce.id idCodigoError,
                        'Fecha de afiliación '+
                        '(' ||CONVERT(VARCHAR, ur.fechaAfiliacionSistema, 103) || ')'+
                        'es mayor al periodo a informar' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1011
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.fechaAfiliacionSistema > ldtUltimaFechaMesInformar;
    
                    --8.5. Error de inconsistencia fecha de incorporación a la A.F.P. es menor
                    -- a 01/05/1981
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'fechaIncorporacionAFP' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                        ce.id idCodigoError,
                        'Fecha de incorporación '+
                        '(' ||CONVERT(VARCHAR, ur.fechaIncorporacionAFP, 103) ||')'+
                        'es menor a 01/05/1981' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1012
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.fechaIncorporacionAFP < ldtMinimaFechaIncorpOAfi;
    
                    --8.6. Error de inconsistencia fecha de incorporación a la A.F.P. es mayor
                    -- al periodo a informar
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'fechaIncorporacionAFP' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                        ce.id idCodigoError,
                        'Fecha de incorporación (' ||CONVERT(VARCHAR, ur.fechaIncorporacionAFP, 103)||')'+
                        ' es mayor al periodo a informar' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1013
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.fechaIncorporacionAFP > ldtUltimaFechaMesInformar;
    
                    --8.7. Error de inconsistencia tipo de incorporación al Sistema con valor 0
                    -- 'Sin clasificar'
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idTipoIncorpSistema' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                        ce.id idCodigoError,
                        'Dimensión DimTipoIncorporacionSistema' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1014
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.idDimTipoIncorporacionSistema = cinCero;
    
                    --8.8. Error de inconsistencia código de control con valor nulo
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idTipoControl' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                        ce.id idCodigoError,
                        'Dimensión DimTipoControl' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1015
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.idDimTipoControl IS NULL;
    
                    --8.9. Error de inconsistencia código de estado con valor 0 'Sin clasificar'
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idTipoEstado' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                        ce.id idCodigoError,
                        'Dimensión DimTipoEstado' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1016
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.idDimTipoEstado = cinCero;
    
                    --8.10. Error de inconsistencia indicador de existencia de clave secreta con
                    -- valor nulo
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'indExisteClaveSecreta' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                        ce.id idCodigoError,
                        '' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1017
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.indExisteClaveSecreta Is NULL;
    
                    --8.11. Error de inconsistencia Indicador de movimiento de clave secreta con valor
                    -- nulo
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'indMovClaveSecreta' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                        ce.id idCodigoError,
                        '' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1018
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.indMovClaveSecreta IS NULL;
    
                    --8.12. Error de inconsistencia Indicador de existencia de clave de seguridad con
                    -- valor nulo
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'indExisteClaveSeguridad' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                        ce.id idCodigoError,
                        '' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1019
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.indExisteClaveSeguridad IS NULL;
    
                    --8.13. Error de inconsistencia Indicador de movimiento de clave de seguridad con
                    -- valor nulo
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'indMovClaveSeguridad' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                        ce.id idCodigoError,
                        '' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1020
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.indMovClaveSeguridad IS NULL;
    
                    --8.14. Error de inconsistencia digito verificador fuera de rango (0-9 o K)
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idPersona' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        'Digito verificador con valor incorrecto. Origen de extracción (TB_MAE_PERSONA)'
                            descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.DimPersona dp ON ur.idDimPersona = dp.id
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1034
                    WHERE ur.esCuadro1 = cstSi
                    AND dp.dv NOT IN (cstCero, cchUno, cchDos,cchTres,
                                      cchCuatro, cchCinco, cchSeis, cchSiete,
                                      cchOcho, cchNueve, cchdv1, cchdv2);
    
                    --8.15. Error de inconsistencia rut con valor nulo
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idPersona' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        'RUT con valor nulo. Origen de extracción (TB_MAE_PERSONA)' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.DimPersona dp ON ur.idDimPersona = dp.id
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1035
                    WHERE ur.esCuadro1 = cstSi
                    AND dp.rut IS NULL;
    
                    --8.16. Error de inconsistencia, Si el tipo de incorporación al sistema se informa
                    -- con valor 04,  la fecha de afiliación al sistema debe ser informada en 0.
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'fechaAfiliacionSistema' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        '' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1044
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.codigoTipoIncorporacion = cstCuatro
                    AND ur.fechaAfiliacionSistema IS NOT NULL;
    
                    --8.17. Error de inconsistencia, Si el tipo de incorporación al sistema se informa
                    -- con valor 04, el código de estado para afiliados a la AFP debe ser  igual de 00.
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idTipoEstado' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        'Dimensión DimTipoEstado' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1045
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.codigoTipoIncorporacion = cstCuatro
                    AND ur.codigoEstadoAnt NOT IN(cstDobleCero, cstCero);
    
                    --8.18. Error de inconsistencia, Si el tipo de incorporación al sistema se informa
                    -- con valor 04,  el código de control debe informarse con valor TAS, VRF.
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idTipoControl' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                        ce.id idCodigoError,
                        'Dimensión DimTipoControl' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1046
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.codigoTipoIncorporacion = cstCuatro
                    AND ur.codigoControl NOT IN(cstCodControlTAS, cstCodControlVRF);
    
                    --8.19. Error de inconsistencia, Si el tipo de incorporación al sistema se informa
                    -- con valor 01, 02, 03 o 05, el código de control debe informarse con valor
                    -- VAL, PRV, AVP o AVV.
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idTipoControl' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                        ce.id idCodigoError,
                        'Dimensión DimTipoControl' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1047
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.codigoTipoIncorporacion IN (cstUno, cstDos, cstTres, cstCinco)
                    AND ur.codigoControl NOT IN(cstCodControlVAL, cstCodControlPRV,
                                                cstCodControlAVP, cstCodControlAVV);
    
                    --8.20. Error de inconsistencia, Si el tipo de incorporación al sistema se informa
                    -- con valor 01, 02, 03 o 05, el código de estado para afiliados a la AFP debe
                    -- ser distinto de 00.
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idTipoEstado' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        'Dimensión DimTipoEstado' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1048
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.codigoTipoIncorporacion IN (cstUno, cstDos, cstTres, cstCinco)
                    AND ur.codigoEstadoAnt IN (cstDobleCero, cstCero);
    
                    --8.21. Error de inconsistencia, Si el tipo de incorporación al sistema se informa
                    -- con valor 01, 02, 03 o 05, el tipo de cotizante debe ser distinto de 00.
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idTipoCotizante' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        'Dimensión DimTipoCotizante' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1049
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.codigoTipoIncorporacion IN (cstUno, cstDos, cstTres, cstCinco)
                    ;
    
                    --8.22. Error de inconsistencia, Si el código de control se informa con valor
                    -- VAL, PRV, AVP o AVV,  el tipo de cotizante debe ser distinto de 00.
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idTipoCotizante' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        'Dimensión DimTipoCotizante' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1051
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.codigoControl IN(cstCodControlVAL, cstCodControlPRV,
                                            cstCodControlAVP, cstCodControlAVV);
    
                    --8.23. Error de inconsistencia, Si el código de estado para afiliados a la A.F.P.
                    -- se informa con valor 00, el código de control debe ser distinto de
                    -- VAL, PRV, AVP o AVV.
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idTipoControl' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                        ce.id idCodigoError,
                        'Dimensión DimTipoControl' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1052
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.codigoEstadoAnt = cstDobleCero
                    AND ur.codigoControl IN(cstCodControlVAL, cstCodControlPRV,
                                            cstCodControlAVP, cstCodControlAVV);
    
                    --8.24. Error de inconsistencia, Si el código de estado para afiliados a la A.F.P.
                    -- se informa con valor 00, el tipo de cotizante debe ser igual a 00.
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idTipoCotizante' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        'Dimensión DimTipoCotizante' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1053
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.codigoEstadoAnt = cstDobleCero;
    
                    --8.25. Error de inconsistencia, Si el tipo de cotizante se informa en 00, la
                    -- fecha de afiliación al sistema debe ser igual a 0.
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'fechaAfiliacionSistema' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        '' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1055
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.fechaAfiliacionSistema IS NOT NULL;
    
                    --8.26. Error de inconsistencia, Si el tipo de cotizante se informa en 00,
                    -- la fecha de incorporación a la AFP debe ser igual a 0.
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'fechaIncorporacionAFP' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        '' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1056
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.fechaIncorporacionAFP IS NOT NULL;
    
                    --8.27. Error de inconsistencia, Si el pensionado en renta vitalicia con CCICO
                    -- nueva en la AFP se informa con S, si el tipo de incorporación al sistema debe
                    -- ser informado con valor 01, 02, 03 o 08
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idTipoIncorpSistema' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        'Dimensión DimTipoIncorporacionSistema' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1059
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.indPensRentaVitCCICONueva = cstSi
                    AND ur.codigoTipoIncorporacion NOT IN(cstUno, cstDos, cstTres, cstOcho);
    
                    --8.28. Error de inconsistencia, Si el pensionado en renta vitalicia con CCICO
                    -- nueva en la AFP se informa con S, el código de estado para afiliados a la
                    -- A.F.P. debe ser igual a 03.
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idTipoEstado' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        'Dimensión DimTipoEstado' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1060
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.indPensRentaVitCCICONueva = cstSi
                    AND ur.codigoEstadoAnt <> cstTres;
    
                    --8.29. Error de inconsistencia, Si el pensionado en renta vitalicia con CCICO
                    -- nueva en la AFP se informa con S, el tipo de cotizante debe ser distinto de 00.
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idTipoCotizante' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        'Dimensión DimTipoCotizante' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1061
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.indPensRentaVitCCICONueva = cstSi;
    
                    --8.30. Error de inconsistencia, Si el pensionado en retiro programado o renta
                    -- temporal sin garantía estatal y saldo 0 se informa con S, el código de estado
                    -- para afiliados a la A.F.P., debe ser igual a 03.
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idTipoEstado' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        'Dimensión DimTipoEstado' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1062
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.penRPRTSinGarEstSaldo0 = cstSi
                    AND ur.codigoEstadoAnt <> cstTres;
    
                    --8.31. Error de inconsistencia, Si el pensionado en retiro programado o renta
                    -- temporal sin garantía estatal y saldo 0 se informa con S, el tipo de cotizante
                    -- debe ser distinto de 00.
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idTipoCotizante' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        'Dimensión DimTipoCotizante' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1063
                    WHERE ur.esCuadro1 = cstSi
                    AND ur.penRPRTSinGarEstSaldo0 = cstSi;
    
                    --8.32. Error de inconsistencia fecha de fallecimiento con valor nulo, para los
                    -- de estado fallecido
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idPersona' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        'Fecha de fallecimiento con valor nulo. Origen de extracción (TB_MAE_PERSONA)'
                            descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.DimPersona dp ON ur.idDimPersona = dp.id
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1079
                    WHERE ur.esCuadro1 = cstSi
                    AND dp.fechaDefuncion IS NULL;
    
                    --8.33. Error de inconsistencia fecha de fallecimiento es igual a la fecha de
                    -- nacimiento, para los de estado fallecido
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'idPersona' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        'Fecha de fallecimiento es igual a la fecha de nacimiento.'+
                        'Origen de extracción (TB_MAE_PERSONA)' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.DimPersona dp ON ur.idDimPersona = dp.id
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1080
                    WHERE ur.esCuadro1 = cstSi
                    AND dp.fechaDefuncion = dp.fechaNacimiento;
    
                    --8.34. Error de inconsistencia fecha de incorporación mayor a la fecha de
                    -- fallecimiento
                    INSERT INTO #UniversoErrores(numeroFila,
                                                 nombreColumna,
                                                 tipoError,
                                                 idCodigoError,
                                                 descripcionError)
                    SELECT ur.numeroFila,
                        'fechaIncorporacionAFP' nombreColumna,
                        cchTipoErrorInconsistencia tipoError,
                         ce.id idCodigoError,
                        'Fecha de incorporación al AFP es mayor a la fecha de fallecimiento. '+
                        'Origen de extracción (TB_MAE_PERSONA)' descripcionError
                    FROM #UniversoRegistroTMP ur
                        INNER JOIN DMGestion.DimPersona dp ON ur.idDimPersona = dp.id
                        INNER JOIN DMGestion.CodigoError ce ON ce.codigo = cchError1081
                    WHERE ur.esCuadro1 = cstSi
                    AND dp.fechaDefuncion < ur.fechaIncorporacionAFP;
    
                    --9. Se registra la cabecera del error
                    INSERT INTO DMGestion.ErrorCarga(idPeriodoInformado,
                        procesoCarga,
                        fechaCarga,
                        nombreTabla,
                        numeroRegistro)
                    SELECT DISTINCT linIdPeriodoInformar,
                        cstNombreProcedimiento,
                        getDate(),
                        cstNombreTablaFct,
                        numeroFila
                    FROM #UniversoErrores;
    
                    --10. Se agrega el idError al universo de errores
                    UPDATE #UniversoErrores ue SET
                        ue.idError = ec.id
                    FROM DMGestion.ErrorCarga ec
                    WHERE ue.numeroFila = ec.numeroRegistro
                    AND ec.procesoCarga = cstNombreProcedimiento
                    AND ec.nombreTabla = cstNombreTablaFct
                    AND ec.idPeriodoInformado = linIdPeriodoInformar;
    
                    --11. Se registra el detalle del error
                    INSERT INTO DMGestion.DetalleErrorCarga(idError,
                        nombreColumna,
                        tipoError,
                        idCodigoError,
                        descripcion)
                    SELECT ue.idError,
                        ue.nombreColumna,
                        ue.tipoError,
                        ue.idCodigoError,
                        ue.descripcionError
                    FROM #UniversoErrores ue;
    
                    --12. Actualiza el idError en el universo a registrar
                    UPDATE #UniversoRegistroTMP ur SET
                        ur.idError = ue.idError
                    FROM #UniversoErrores ue
                    WHERE ue.numeroFila = ur.numeroFila;
    
                    DROP TABLE #UniversoErrores;
                    */
                    --13. Se registra en la FctlsInformacionAfiliadoCliente
                    INSERT INTO DMGestion.FctlsInformacionAfiliadoCliente(idPeriodoInformado,
                        idPersona,
                        idSobrecotizacionTrabajoPesado,
                        idSubClasificacionPersona,
                        idTipoIncorpSistema,
                        idTipoControl,
                        idTipoEstado,
                        idMotivoCesePensionInv,
                        idTipoCoberturaSIS,
                        idActividadEconomica,
                        idNivelEducacional,
                        idEstadoCivil,
                        idCanalSuscripcionCartola,
                        idPaisNacimiento,
                        indTrabConvBilatSegSoc,
                        indTransFdoOtroEstado,
                        afiPenLegOtroEstadoConv,
                        paisPensionOtroEstado,
                        indExisteClaveSecreta,
                        indMovClaveSecreta,
                        indExisteClaveSeguridad,
                        indMovClaveSeguridad,
                        penRPRTSinGarEstSaldo0,
                        indPensRentaVitCCICONueva,
                        fechaAfiliacionSistema,
                        fechaIncorporacionAFP,
                        edad,
                        idSucursal,
                        indSolCartolaElectronica,
                        fecSolCartolaElectronica,
                        numeroFila,
                        idError)
                    SELECT linIdPeriodoInformar,
                        idDimPersona,
                        idDimSobrecotizacionTrabajoPesado,
                        idSubClasifPersona,
                        idDimTipoIncorporacionSistema,
                        idDimTipoControl,
                        idDimTipoEstado,
                        idDimMotivoCesePensionInvalidez,
                        idDimTipoCobertura,
                        idActividadEconomica,
                        idNivelEducacional,
                        idEstadoCivil,
                        idCanalSuscripcionCartola,
                        idPaisNacimiento,
                        indTrabConvBilatSegSoc,
                        indTransFdoOtroEstado,
                        afiPenLegOtroEstadoConv,
                        ISNULL(paisPensionOtroEstado, cstCero),
                        indExisteClaveSecreta,
                        indMovClaveSecreta,
                        indExisteClaveSeguridad,
                        indMovClaveSeguridad,
                        penRPRTSinGarEstSaldo0,
                        indPensRentaVitCCICONueva,
                        fechaAfiliacionSistema,
                        fechaIncorporacionAFP,
                        edad,
                        idSucursal,
                        indSolicitaCartolaViaMail,
                        fechaSolicitudCartola,
                        numeroFila,
                        idError
                    FROM #UniversoRegistroTMP;
                    --------------------
                    --Datos de Auditoria
                    --------------------
                    --Se registra datos de auditoria
                    SELECT COUNT(*) INTO lbiCantidadRegistrosInformados
                    FROM #UniversoRegistroTMP;
    
                    CALL DMGestion.registrarAuditoriaDatamarts(cstNombreProcedimiento,
                                                               cstNombreTablaFct,
                                                               ldtFechaInicioCarga,
                                                               lbiCantidadRegistrosInformados, NULL);
    
                    COMMIT;
                    SAVEPOINT;
                    SET codigoError = cstCodigoErrorCero;
                END IF;
            END IF;
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
       CALL DMGestion.registrarErrorProceso(cstNombreProcedimiento, lstCodigoError);
END