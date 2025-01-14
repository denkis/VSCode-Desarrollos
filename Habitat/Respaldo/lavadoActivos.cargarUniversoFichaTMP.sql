create PROCEDURE lavadoActivos.cargarUniversoFichaTMP(OUT codigoError VARCHAR(10))
BEGIN
    /**
        - Nombre archivo                            : cargarUniversoFicha.sql
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

    --Seteo de constantes
    SET cstNombreProcedimiento  = 'cargarFctAfiliadoCotizante';
    SET cstNombreTabla          = 'UniversoFichaTMP';
    SET ctiExiste               = 1;

    SET ltiExiteTabla = lavadoActivos.existeTabla(cstNombreTabla);

    --verifica si tabla se encuentra creada
    IF (ltiExiteTabla = ctiExiste) THEN
        DROP TABLE lavadoactivos.UniversoFichaTMP;
    END IF;

    --Se crea tabla temporal fisicamente
    CREATE TABLE lavadoactivos.UniversoFichaTMP(
    periodoInformado        DATE NOT NULL,
    rut                     INTEGER NOT NULL,
    codigoEstadoFicha       INTEGER NULL,
    codigoTipoFicha         INTEGER NULL, 
    riesgoCliente           NUMERIC(10,2) NULL,
    motivoAlerta            VARCHAR(50) NULL,
    indPep                  VARCHAR(2) NULL,
    indListaNegra           VARCHAR(2) NULL,
    ranking                 BIGINT NULL);

    --Se obtiene la fecha del periodo informado
    SELECT DMGestion.obtenerFechaPeriodoInformar() 
    INTO ldtFechaPeriodoInformado 
    FROM DUMMY;

    

    SELECT DISTINCT dpi.fecha AS periodoInformado,
            dpe.rut,
            dra.nombre AS motivoAlerta,
            1 AS codigoEstadoFicha,
            1 AS codigoTipoFicha,
            SUM(fori.valorOperacionRiesgoEscenario)         AS riesgoCliente,
            fori.indPep                                     AS indPep,
            fori.indListaNegra                              AS indListaNegra,
        DENSE_RANK() OVER (PARTITION BY dpi.fecha ORDER BY riesgoCliente DESC) AS ranking
        INTO #universo1
        FROM LavadoActivos.FctOperacionesRiesgosas fori
            INNER JOIN DMGestion.DimPeriodoInformado dpi ON (fori.idPeriodoInformado = dpi.id)
            INNER JOIN DMGestion.DimPersona dpe ON (fori.idPersona = dpe.id)
            INNER JOIN LavadoActivos.DimEscenario de ON (de.id = fori.idEscenario)
            INNER JOIN LavadoActivos.DimRiesgoAlerta dra ON (fori.idRiesgoAlerta = dra.id)
    WHERE de.codigoEscenario NOT IN ('15', '17','31','32','33')
        AND dpi.fecha = ldtFechaPeriodoInformado
        AND indCriterioAlerta = 'Si'
    GROUP BY dpi.fecha,
        dpe.rut, 
        dra.nombre,
        fori.indPep,
        fori.indListaNegra;
        
    
    SELECT DISTINCT dpi.fecha AS periodoInformado,
            dpe.rut,
            dra.nombre AS motivoAlerta,
            1 AS codigoEstadoFicha,
            2 AS codigoTipoFicha,
            SUM(fori.valorOperacionRiesgoEscenario)   AS riesgoCliente,
            esPep                                     AS indPep,
            esListaNegra                              AS indListaNegra,
            0 AS ranking
        INTO #universo2
    FROM lavadoactivos.FctRiesgoBase frb 
            INNER JOIN DMGestion.DimPeriodoInformado dpi ON (frb.idPeriodoInformado = dpi.id)
            INNER JOIN DMGestion.DimPersona dpe ON (frb.idPersona = dpe.id)
            LEFT OUTER JOIN LavadoActivos.FctOperacionesRiesgosas fori ON fori.idPeriodoInformado = dpi.id AND fori.idPersona = dpe.id 
            LEFT OUTER JOIN LavadoActivos.DimEscenario de ON (de.id = fori.idEscenario AND de.codigoEscenario NOT IN ('15', '17','31','32','33'))
            LEFT OUTER JOIN LavadoActivos.DimRiesgoAlerta dra ON (fori.idRiesgoAlerta = dra.id)
            LEFT OUTER JOIN (SELECT vvp.rut,
                                    CASE WHEN ISNULL(vvp.indPep,'No')='No' THEN 'No' ELSE 'Si' END esPep , 
                                    CASE WHEN ISNULL(vvp.indListaNegra,0)= 0 THEN 'No' ELSE 'Si' end esListaNegra
                                FROM lavadoactivos.variablesVectorPersonas vvp 
                                WHERE vvp.fecha = ldtFechaPeriodoInformado)lis  ON lis.rut = dpe.rut
    WHERE dpi.fecha = ldtFechaPeriodoInformado
        AND dpe.rut NOT IN (SELECT rut FROM #universo1)
    GROUP BY dpi.fecha,
        dpe.rut, 
        dra.nombre,
        indPep,
        indListaNegra;
    
    
    SELECT
    periodoInformado,
        rut,
        codigoEstadoFicha,
        codigoTipoFicha,
        riesgoCliente,
        indPep,
        indListaNegra,
        ranking,
        motivoAlerta
    INTO #UniversoRegistrar
    FROM 
        (SELECT
            periodoInformado,
            rut,
            codigoEstadoFicha,
            codigoTipoFicha,
            riesgoCliente,
            indPep,
            indListaNegra,
            ranking,
            motivoAlerta
        FROM #universo1
        UNION
        SELECT
            periodoInformado,
            rut,
            codigoEstadoFicha,
            codigoTipoFicha,
            riesgoCliente,
            indPep,
            indListaNegra,
            ranking,
            motivoAlerta
        FROM #universo2)uni;
    
    
    
    INSERT INTO lavadoactivos.UniversoFichaTMP
        (periodoInformado,
        rut             ,
        codigoEstadoFicha,
        codigoTipoFicha  , 
        riesgoCliente    ,
        motivoAlerta     ,
        indPep           ,
        indListaNegra    ,
        ranking          )
    SELECT
        periodoInformado,
        rut,
        codigoEstadoFicha,
        codigoTipoFicha,
        riesgoCliente,
        motivoAlerta,
        indPep,
        indListaNegra,
        ranking
    FROM #UniversoRegistrar;
    

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