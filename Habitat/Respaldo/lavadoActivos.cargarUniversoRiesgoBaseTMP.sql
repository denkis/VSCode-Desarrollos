create PROCEDURE lavadoActivos.cargarUniversoRiesgoBaseTMP(OUT codigoError VARCHAR(10))
BEGIN
    /**
        - Nombre archivo                            : cargarUniversoPersonasTMP.sql
        - Nombre del módulo                         : Ficha Ros y Ficha Cliente
        - Fecha de  creación                        : 
        - Nombre del autor                          : Denis Chávez
        - Descripción corta del módulo              : 
        - Lista de procedimientos contenidos        : 
        - Documentos asociados a la creación        : 
        - Fecha de modificación                     : 
        - Nombre de la persona que lo modificó      : 
        - Cambios realizados                        : 
        - Documentos asociados a la modificación    : 
    **/
    --variable para capturar el codigo de error
    DECLARE lstCodigoError              VARCHAR(10);    --variable local de tipo varchar
    --Variables
    DECLARE ldtFechaPeriodoInformado    DATE;           --variable local de tipo date
    --Constantes
    DECLARE cstNombreProcedimiento      VARCHAR(150);   --constante de tipo varchar
    DECLARE cstNombreTabla              VARCHAR(150);   --constante de tipo varchar
    DECLARE ltiExiteTabla               TINYINT;
    DECLARE ctiExiste                   TINYINT;
    DECLARE lbiUltimoRegistro           BIGINT;   


    --Seteo de constantes
    SET cstNombreProcedimiento  = 'cargarUniversoRiesgoBaseTMP';
    SET cstNombreTabla          = 'universoRiesgoBaseTMP';
    SET ctiExiste               = 1;

    SET ltiExiteTabla = lavadoActivos.existeTabla(cstNombreTabla);

    --verifica si tabla se encuentra creada
    IF (ltiExiteTabla = ctiExiste) THEN
        DROP TABLE Lavadoactivos.universoRiesgoBaseTMP;
    END IF;


    --Se crea tabla temporal fisicamente
    CREATE TABLE Lavadoactivos.universoRiesgoBaseTMP (
        fechaCierre date NOT NULL,
        rut bigint NOT NULL,
        riesgoBase numeric(4,2) NULL,
        codigoRiesgoBase integer NULL,
        descRiesgoBase   varchar(100) NULL,
        porcPonderacion  integer NULL,
        valorDetalleRB   numeric(4,2) NULL,
        situacion        varchar(100) NULL,
        nroFila          bigint null
    );

    DELETE FROM lavadoactivos.ControlTransmision
    WHERE cstNombreTabla = cstNombreTabla;
    
    --Se obtiene la fecha del periodo informado
    SELECT DMGestion.obtenerFechaPeriodoInformar() 
    INTO ldtFechaPeriodoInformado 
    FROM DUMMY;



    SELECT DISTINCT 
                    (CASE nombreVariable
                        WHEN 'Lista_negra' THEN 1
                        WHEN 'Alertas_previas' THEN 2
                        WHEN 'Alertas_os' THEN 3
                        WHEN 'PEP' THEN 4
                        WHEN 'situacionEconomica' THEN 5
                        WHEN 'tipoCliente' THEN 6
                        WHEN 'cuentasVoluntarias' THEN 7
                        WHEN 'saldoCuentasVoluntarias' THEN 8
                        WHEN 'Nacionalidad' THEN 9
                     END) AS codigoRiesgoBase,
                    (CASE nombreVariable
                        WHEN 'Lista_negra' THEN 'Lista negra'
                        WHEN 'Alertas_previas' THEN 'Prealertas previas'
                        WHEN 'Alertas_os' THEN 'Alertas y OS'
                        WHEN 'PEP' THEN 'PEP'
                        WHEN 'situacionEconomica' THEN 'Situación económica'
                        WHEN 'tipoCliente' THEN 'Tipo de cliente'
                        WHEN 'cuentasVoluntarias' THEN 'Cuentas Voluntarias'
                        WHEN 'saldoCuentasVoluntarias' THEN 'Saldos Voluntarios'
                        WHEN 'Nacionalidad' THEN 'Nacionalidad del afiliado'
                     END) AS descRiesgoBase,
                    (ponderacion * 100) AS porcPonderacion,fechaCierre
        INTO #VariableRB
                FROM DMGestion.VistaPuntajeRiesgoVariable 
                WHERE fechaCierre = ldtFechaPeriodoInformado
                AND nombreVariable IN ('Alertas_os', 
                                        'Alertas_previas',
                                        'Lista_negra',
                                        'Nacionalidad',
                                        'PEP',
                                        'cuentasVoluntarias',
                                        'saldoCuentasVoluntarias',
                                        'situacionEconomica',
                                        'tipoCliente');

    SELECT DISTINCT vvp.fecha AS fechaCierre,fori.rut,vvp.listaNegra Situacion,v.codigoRiesgoBase,descRiesgoBase
    INTO #ln
    FROM LavadoActivos.UniversoFichaTMP fori 
         INNER JOIN LavadoActivos.variablesVectorPersonas vvp ON (vvp.fecha = fori.periodoInformado AND vvp.rut = fori.rut )
         INNER JOIN #VariableRB v ON v.descRiesgoBase = 'Lista negra'
    WHERE vvp.fecha = ldtFechaPeriodoInformado;

    SELECT DISTINCT vvp.fecha AS fechaCierre,fori.rut,CONVERT(varchar(100),indAlertasPrevias) Situacion,v.codigoRiesgoBase,descRiesgoBase
    INTO #previa
    FROM LavadoActivos.UniversoFichaTMP fori 
         INNER JOIN LavadoActivos.variablesVectorPersonas vvp ON (vvp.fecha = fori.periodoInformado AND vvp.rut = fori.rut )
         INNER JOIN #VariableRB v ON v.descRiesgoBase = 'Prealertas previas'
    WHERE vvp.fecha = ldtFechaPeriodoInformado;

    SELECT DISTINCT vvp.fecha AS fechaCierre,fori.rut,TRIM(vvp.cargoPoliticoPep) Situacion,v.codigoRiesgoBase,descRiesgoBase
    INTO #pep
    FROM LavadoActivos.UniversoFichaTMP fori 
         INNER JOIN LavadoActivos.variablesVectorPersonas vvp ON (vvp.fecha = fori.periodoInformado AND vvp.rut = fori.rut )
         INNER JOIN #VariableRB v ON v.descRiesgoBase = 'PEP'
    WHERE vvp.fecha = ldtFechaPeriodoInformado;
    
    SELECT DISTINCT vvp.fecha AS fechaCierre,fori.rut,vvp.situacionEconomica Situacion,v.codigoRiesgoBase,descRiesgoBase
    INTO #sit
    FROM LavadoActivos.UniversoFichaTMP fori 
         INNER JOIN LavadoActivos.variablesVectorPersonas vvp ON (vvp.fecha = fori.periodoInformado AND vvp.rut = fori.rut )
         INNER JOIN #VariableRB v ON v.descRiesgoBase = 'Situación económica'
    WHERE vvp.fecha = ldtFechaPeriodoInformado;
   
    
    SELECT DISTINCT vvp.fecha AS fechaCierre,fori.rut,vvp.cuentasVoluntarias Situacion,v.codigoRiesgoBase,descRiesgoBase
    INTO #cv
    FROM LavadoActivos.UniversoFichaTMP fori 
         INNER JOIN LavadoActivos.variablesVectorPersonas vvp ON (vvp.fecha = fori.periodoInformado AND vvp.rut = fori.rut )
         INNER JOIN #VariableRB v ON v.descRiesgoBase = 'Cuentas Voluntarias'
    WHERE vvp.fecha = ldtFechaPeriodoInformado;
    
    SELECT DISTINCT vvp.fecha AS fechaCierre,fori.rut,vvp.saldoCuentasVoluntarias Situacion,v.codigoRiesgoBase,descRiesgoBase
    INTO #sv
    FROM LavadoActivos.UniversoFichaTMP fori 
         INNER JOIN LavadoActivos.variablesVectorPersonas vvp ON (vvp.fecha = fori.periodoInformado AND vvp.rut = fori.rut )
         INNER JOIN #VariableRB v ON v.descRiesgoBase = 'Saldos Voluntarios'
    WHERE vvp.fecha = ldtFechaPeriodoInformado;
 
    SELECT DISTINCT vvp.fecha AS fechaCierre,fori.rut,CONVERT(varchar(100),vvp.alertaROS) Situacion,v.codigoRiesgoBase,descRiesgoBase
    INTO #al
    FROM LavadoActivos.UniversoFichaTMP fori 
         INNER JOIN LavadoActivos.variablesVectorPersonas vvp ON (vvp.fecha = fori.periodoInformado AND vvp.rut = fori.rut )
         INNER JOIN #VariableRB v ON v.descRiesgoBase = 'Alertas y OS'
    WHERE vvp.fecha = ldtFechaPeriodoInformado;
   
    SELECT DISTINCT vvp.fecha AS fechaCierre,fori.rut,actc.tipoClasificacion Situacion,v.codigoRiesgoBase,descRiesgoBase
    INTO #tc
    FROM LavadoActivos.UniversoFichaTMP fori 
         INNER JOIN LavadoActivos.variablesVectorPersonas vvp ON (vvp.fecha = fori.periodoInformado AND vvp.rut = fori.rut )
         INNER JOIN #VariableRB v ON v.descRiesgoBase = 'Tipo de cliente'
         LEFT JOIN LavadoActivos.AgrClasificacionTipoCliente actc ON (actc.fecha = vvp.fecha AND vvp.rut = actc.rut)
    WHERE vvp.fecha = ldtFechaPeriodoInformado;

    
    SELECT DISTINCT vvp.fecha AS fechaCierre,fori.rut,dp.nombre  Situacion,v.codigoRiesgoBase,descRiesgoBase
    INTO #nc
    FROM LavadoActivos.UniversoFichaTMP fori 
         INNER JOIN LavadoActivos.variablesVectorPersonas vvp ON (vvp.fecha = fori.periodoInformado AND vvp.rut = fori.rut )
         INNER JOIN #VariableRB v ON v.descRiesgoBase = 'Nacionalidad del afiliado'
         LEFT JOIN DMGestion.DimPais dp ON (vvp.nacionalidad = dp.codigo AND dp.fechaVigencia >= '21991231')
    WHERE vvp.fecha = ldtFechaPeriodoInformado;
    

    INSERT INTO Lavadoactivos.universoRiesgoBaseTMP
    (fechaCierre,rut,riesgoBase,codigoRiesgoBase,descRiesgoBase,porcPonderacion,nroFila) 
    SELECT DISTINCT upt.fechaCierre ,
        upt.rut,upt.riesgoBase,
        a.codigoRiesgoBase,
        a.descRiesgoBase,
        a.porcPonderacion,
        ROW_NUMBER() OVER (ORDER BY rut ASC,codigoRiesgoBase ASC)
    FROM lavadoactivos.universoPersonaTMP upt
        INNER JOIN #VariableRB a ON A.fechaCierre = upt.fechaCierre 
    ORDER BY upt.rut ASC, a.codigoRiesgoBase ASC;


    UPDATE Lavadoactivos.universoRiesgoBaseTMP
    SET valorDetalleRB = round(((porcPonderacion*riesgoBase)/100),2)
    WHERE fechaCierre = ldtFechaPeriodoInformado;

    UPDATE Lavadoactivos.universoRiesgoBaseTMP
    SET un.situacion = b.situacion
    FROM Lavadoactivos.universoRiesgoBaseTMP un
    INNER JOIN #LN b ON un.rut = b.rut AND un.codigoRiesgoBase = b.codigoRiesgoBase;


    
    UPDATE Lavadoactivos.universoRiesgoBaseTMP
    SET un.situacion = b.situacion
    FROM Lavadoactivos.universoRiesgoBaseTMP un
    INNER JOIN #previa b ON un.rut = b.rut AND un.codigoRiesgoBase = b.codigoRiesgoBase;

 
 
    UPDATE Lavadoactivos.universoRiesgoBaseTMP
    SET un.situacion = b.situacion
    FROM Lavadoactivos.universoRiesgoBaseTMP un
    INNER JOIN #pep b ON un.rut = b.rut AND un.codigoRiesgoBase = b.codigoRiesgoBase;



    UPDATE Lavadoactivos.universoRiesgoBaseTMP
    SET un.situacion = b.situacion
    FROM Lavadoactivos.universoRiesgoBaseTMP un
    INNER JOIN #sit b ON un.rut = b.rut AND un.codigoRiesgoBase = b.codigoRiesgoBase;



    UPDATE Lavadoactivos.universoRiesgoBaseTMP
    SET un.situacion = b.situacion
    FROM Lavadoactivos.universoRiesgoBaseTMP un
    INNER JOIN #cv b ON un.rut = b.rut AND un.codigoRiesgoBase = b.codigoRiesgoBase;



    UPDATE Lavadoactivos.universoRiesgoBaseTMP
    SET un.situacion = b.situacion
    FROM Lavadoactivos.universoRiesgoBaseTMP un
    INNER JOIN #sv b ON un.rut = b.rut AND un.codigoRiesgoBase = b.codigoRiesgoBase;


 
    UPDATE Lavadoactivos.universoRiesgoBaseTMP
    SET un.situacion = b.situacion
    FROM Lavadoactivos.universoRiesgoBaseTMP un
    INNER JOIN #al b ON un.rut = b.rut AND un.codigoRiesgoBase = b.codigoRiesgoBase;



    UPDATE Lavadoactivos.universoRiesgoBaseTMP
    SET un.situacion = b.situacion
    FROM Lavadoactivos.universoRiesgoBaseTMP un
    INNER JOIN #tc b ON un.rut = b.rut AND un.codigoRiesgoBase = b.codigoRiesgoBase;


    UPDATE Lavadoactivos.universoRiesgoBaseTMP
    SET un.situacion = b.situacion
    FROM Lavadoactivos.universoRiesgoBaseTMP un
    INNER JOIN #nc b ON un.rut = b.rut AND un.codigoRiesgoBase = b.codigoRiesgoBase;

     SET lbiUltimoRegistro = (select max(nroFila) FROM lavadoactivos.universoriesgoBaseTMP);

     SELECT u.nroFilaFin,
        u.nroFilaIni,
        DENSE_RANK() OVER(ORDER BY u.nroFilaIni ASC) AS nroParticion
    INTO #RangoParticionTMP
    FROM (
        SELECT a.nroFila AS nroFilaFin,
            ISNULL((LAG(a.nroFila) OVER(ORDER BY a.nroFila) + 1), 1) AS nroFilaIni
        FROM (
            SELECT nroFila,
                (CASE
                    WHEN nroFila = lbiUltimoRegistro THEN 0
                    ELSE MOD(nroFila, 1000000.0) 
                 END) AS residuo
            FROM lavadoactivos.universoriesgoBaseTMP uft
            WHERE residuo = 0
        ) a
    ) u;

     INSERT INTO lavadoactivos.ControlTransmision
     (nombreTabla,nroParticion,nroFilaIni,nroFilaFin,indTransmitido)
     SELECT cstNombreTabla, nroParticion,nroFilaFin,nroFilaIni, 'No'
     FROM #RangoParticionTMP;

    COMMIT;
    SAVEPOINT;

--Manejo de errores
/*EXCEPTION
    WHEN OTHERS THEN
        SET lstCodigoError = SQLSTATE;
        SET codigoError = lstCodigoError;
        ROLLBACK;
        --CALL DMGestion.registrarErrorProceso(cstNombreProcedimiento, lstCodigoError);*/
END