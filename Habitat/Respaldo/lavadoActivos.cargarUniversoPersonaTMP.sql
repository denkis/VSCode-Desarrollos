create PROCEDURE lavadoActivos.cargarUniversoPersonaTMP(OUT codigoError VARCHAR(10))
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

    --Seteo de constantes
    SET cstNombreProcedimiento  = 'cargarUniversoPersonasTMP';
    SET cstNombreTabla          = 'universoPersonaTMP';
    SET ctiExiste               = 1;

    SET ltiExiteTabla = lavadoActivos.existeTabla(cstNombreTabla);

    --verifica si tabla se encuentra creada
    IF (ltiExiteTabla = ctiExiste) THEN
        DROP TABLE lavadoactivos.universoPersonaTMP;
    END IF;


    --Se crea tabla temporal fisicamente
    CREATE TABLE lavadoactivos.universoPersonaTMP (
        fechaCierre date NOT NULL,
        rut bigint NOT NULL,
        dv char(1)NOT  NULL,
        nombres varchar(300) NULL,
        fechaNacimiento date NULL,
        clasificacionPersona varchar(50) NOT NULL,
        fechaAfiliacionSistema date NULL,
        fechaIncorporacionAFP date NULL,
        claseCotizante varchar(100) NULL,
        totalMesesCotizados integer NOT NULL,
        nroCuentasVol smallint NOT NULL,
        direccionPrincipal varchar(200) NULL,
        telefonoPrincipal varchar(100) NULL,
        correoPrincipal varchar(100) NULL,
        comuna varchar(100) NULL,
        riesgoCliente numeric(6,2) NULL,
        indPep varchar(2) NULL,
        indListaNegra varchar(2) NULL,
        ranking int  NULL,
        motivoAlerta varchar(100) NULL,
        riesgoBase numeric(4,2) NULL,
        paisNacimiento varchar(100) NULL,
        profesion      varchar(100) NULL,
        indFuncionario varchar(2) NULL 
    );


    --Se obtiene la fecha del periodo informado
    SELECT DMGestion.obtenerFechaPeriodoInformar() 
    INTO ldtFechaPeriodoInformado 
    FROM DUMMY;

    SELECT  DISTINCT upt.rut,afi.dv,nombres,
                        fechaNacimiento,
                        clasificacionPersona,
                        fechaAfiliacionSistema,
                        fechaIncorporacionAFP,
                        upt.indPep,
                        upt.indListaNegra,
                        upt.riesgoCliente,
                        upt.motivoAlerta,
                        upt.ranking,
                        CONVERT(numeric(4,2),NULL) riesgoBase, 
                        CONVERT(integer,NULL) totalMesesCotizados,
                        CONVERT(SMALLINT,NULL) nroCuentasVol,
                        CONVERT(varchar(100), NULL) claseCotizante,
                        pais  paisNacimiento,
                        CONVERT(varchar(100), NULL) profesion,
                        CONVERT(varchar(2), NULL) indFuncionario
                        
    INTO #UniversoDatos
    FROM lavadoactivos.UniversoFichaTMP upt
    INNER JOIN (SELECT DISTINCT dpi.fecha ,
                        dpe.rut,dpe.dv,
                        (TRIM(TRIM(TRIM(dpe.primerNombre || ' ' || dpe.segundoNombre) || ', ' || dpe.apellidoPaterno) || ' ' || dpe.apellidoMaterno)) AS nombres,
                        dpe.fechaNacimiento,
                        dcp.nombre AS clasificacionPersona,
                        fiac.fechaAfiliacionSistema,
                        fiac.fechaIncorporacionAFP,
                        dp.nombre pais
                    FROM DMGestion.FctlsInformacionAfiliadoCliente fiac
                        INNER JOIN DMGestion.DimPeriodoInformado dpi ON (fiac.idPeriodoInformado = dpi.id)
                        INNER JOIN DMGestion.DimPersona dpe ON (fiac.idPersona = dpe.id)
                        INNER JOIN DMGestion.DimSubClasificacionPersona dscp ON (fiac.idSubClasificacionPersona = dscp.id)
                        INNER JOIN DMGestion.DimClasificacionPersona dcp ON (dscp.idClasificacionPersona = dcp.id)
                        INNER JOIN DMGestion.DimPais dp ON dp.id = CASE WHEN fiac.idPaisNacimiento = 190 THEN 0 ELSE fiac.idPaisNacimiento END
                    WHERE dpi.fecha = ldtFechaPeriodoInformado) afi ON upt.rut = afi.rut;


    SELECT  DISTINCT uni.rut,direccionPrincipal,
                    telefonoPrincipal,
                    correoPrincipal,  
                    comuna  
    INTO #Direccion
    FROM #UniversoDatos uni
    INNER JOIN (SELECT dpe.rut,        
                    fc.direccionPrincipal,
                    (CASE WHEN fc.telefonoPrincipal = 'SIN CLASIFICAR' THEN '' ELSE fc.telefonoPrincipal END) AS telefonoPrincipal,
                    (CASE WHEN fc.correoPrincipal = 'SIN CLASIFICAR' THEN '' ELSE fc.correoPrincipal END) AS correoPrincipal,  
                    dco.nombre AS comuna
                FROM DMGestion.FctContactoAfiliado fc
                    INNER JOIN DMGestion.DimPeriodoInformado dpi ON (fc.idPeriodoInformado = dpi.id)
                    INNER JOIN DMGestion.DimPersona dpe ON (fc.idPersona = dpe.id)
                    INNER JOIN DMGestion.DimComuna dco ON (fc.idComunaPrincipal = dco.id)
                WHERE dpi.fecha = ldtFechaPeriodoInformado)dir ON dir.rut = uni.rut;
            

            
            
            UPDATE #UniversoDatos
            SET riesgoBase = ris.riesgoBase
            FROM  #UniversoDatos uni 
            INNER JOIN (SELECT dpe.rut, fori.riesgoBase  
                        FROM  LavadoActivos.FctRiesgoBase fori
                                INNER JOIN DMGestion.DimPeriodoInformado dpi ON (fori.idPeriodoInformado = dpi.id)
                                INNER JOIN DMGestion.DimPersona dpe ON (fori.idPersona = dpe.id)
                            WHERE dpi.fecha = ldtFechaPeriodoInformado)ris ON ris.rut = uni.rut;
                        
            UPDATE #UniversoDatos
            SET totalMesesCotizados = vp.totalMesesCotizados,
            nroCuentasVol = vp.nroCuentasVol
            FROM  #UniversoDatos uni 
            INNER JOIN (SELECT vvp.rut,
                        ISNULL(vvp.totalMesesCotizados, 0) AS totalMesesCotizados,
                        ((CASE WHEN ISNULL(vvp.cuentaCAV, 0) > 0 THEN 1 ELSE 0 END) + 
                         (CASE WHEN ISNULL(vvp.cuentaCCICV, 0) > 0 THEN 1 ELSE 0 END) + 
                         (CASE WHEN ISNULL(vvp.cuentaCCIDC, 0) > 0 THEN 1 ELSE 0 END) + 
                         (CASE WHEN ISNULL(vvp.cuentaCCIAV, 0) > 0 THEN 1 ELSE 0 END) +
                         (CASE WHEN ISNULL(vvp.cuentaCAPVC, 0) > 0 THEN 1 ELSE 0 END)) AS nroCuentasVol  
                        FROM LavadoActivos.VariablesVectorPersonas vvp 
                        WHERE fecha =  ldtFechaPeriodoInformado)vp ON vp.rut = uni.rut;
                    
            UPDATE #UniversoDatos
            SET clasecotizante = AGR.clasecotizante
            FROM  #UniversoDatos uni 
            INNER JOIN (SELECT  RUT,clasecotizante
                        FROM LavadoActivos.AgrClasificacionTipoCliente
                        WHERE FECHA = ldtFechaPeriodoInformado) agr ON agr.rut = uni.rut;
                    
            
            SELECT DISTINCT RUT_MAE_PERSONA rut, ttc.DES_TIP_CARGO  
                INTO #cargo
            FROM DDS.TB_MAE_PERSONA tmp
                INNER JOIN dds.TB_TIP_CARGO ttc ON ttc.ID_TIP_CARGO  = tmp.ID_TIP_CARGO_PERSONA;
        
            UPDATE #UniversoDatos
            SET profesion = DES_TIP_CARGO
            FROM #UniversoDatos uni 
                INNER JOIN #cargo car ON car.rut = uni.rut;
            
            SELECT DISTINCT dpa.rut 
                INTO #funcionario
            FROM DMGestion.FctEmpleadorRelacionAfiliado fera
                INNER JOIN DMGestion.DimPersona dp ON dp.id = fera.idEmpleador 
                INNER JOIN DMGestion.DimPersona dpa ON dpa.id = fera.idPersona  
                INNER JOIN DMGestion.DimPeriodoInformado dpi ON dpi.id = fera.idPeriodoInformado
                INNER JOIN DMGestion.DimEscalaCalidad del ON del.id = fera.idEscalaCalidad
                INNER JOIN DMGestion.DimPersonal dpp ON dpa.rut = dpp.rut AND dpp.fechaVigencia > GETDATE() AND  dpp.vigente = 'Si'
            WHERE dpi.fecha = ldtFechaPeriodoInformado
                AND idTipoProducto = 1
                AND dp.rut IN (98000100)
                AND indCotizanteMes = 'S';
            
        
           UPDATE #UniversoDatos
            SET indFuncionario = CASE WHEN car.rut IS NULL THEN 'No' ELSE 'Si'END
            FROM #UniversoDatos uni 
                LEFT OUTER JOIN #funcionario car ON car.rut = uni.rut;
                    

                    
        SELECT un.rut,dv, nombres, fechaNacimiento, clasificacionPersona, fechaAfiliacionSistema, fechaIncorporacionAFP, 
            indPep, indListaNegra, riesgoCliente, motivoAlerta, ranking, riesgoBase, totalMesesCotizados, nroCuentasVol, 
            claseCotizante, direccionPrincipal, telefonoPrincipal, correoPrincipal, comuna,paisNacimiento,profesion,indFuncionario
            INTO #UniversoRegistrar
        FROM #UniversoDatos un
            LEFT OUTER JOIN #Direccion di ON un.rut = di.rut;

        
        INSERT INTO lavadoactivos.universoPersonaTMP
            (fechaCierre,
            rut,
            dv,
            nombres,
            fechaNacimiento,
            clasificacionPersona,
            fechaAfiliacionSistema,
            fechaIncorporacionAFP,
            claseCotizante,
            totalMesesCotizados,
            nroCuentasVol,
            direccionPrincipal,
            telefonoPrincipal,
            correoPrincipal,
            comuna,
            riesgoCliente,
            indPep,
            indListaNegra,
            ranking ,
            motivoAlerta,
            riesgoBase,
            paisNacimiento,
            profesion,
            indFuncionario)
        SELECT
            ldtFechaPeriodoInformado,
            rut,
            dv, 
            nombres,
            fechaNacimiento, 
            clasificacionPersona, 
            fechaAfiliacionSistema, 
            fechaIncorporacionAFP,
            claseCotizante,
            totalMesesCotizados, 
            nroCuentasVol,
            direccionPrincipal, 
            telefonoPrincipal,
            correoPrincipal, 
            comuna,
            riesgoCliente,
            indPep, 
            indListaNegra,
            ranking,
            motivoAlerta,
            riesgoBase,
            paisNacimiento,
            profesion,
            indFuncionario
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