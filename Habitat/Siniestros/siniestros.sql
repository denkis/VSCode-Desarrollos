SELECT  *
FROM oficio14880.SiniestroEnCursoBeneficiario secb 
WHERE periodoInformado = '20240901'


SELECT * FROM Oficio14880.SiniestroOcurridoNoRepoBeneficiario sonrb 

SELECT  
FROM Oficio14880.SiniestroEnCursoCausanteInvalidez secci
    

SELECT * FROM DDS.PlanillaSinEnCursoBeneficiario psecb
    
    
SELECT * FROM DDS.PlanillaSinEnCursoSinSobreviInvalTramite s   

SELECT * FROM DDS.PlanillaSinEnCursoCausanteInvalidez psecci 

SELECT * FROM dds.PlanillaSinEnCursoBeneficiario psecb 

SELECT * FROM dds.PlanillaSinOcurridoNoRepoCauSobrevivencia psonrcs 

SELECT * FROM dds.PlanillaSinOcurridoNoRepoBeneficiario psonrb 


TRUNCATE table DDS.PlanillaSinEnCursoSinSobreviInvalTramite;  

TRUNCATE table DDS.PlanillaSinEnCursoCausanteInvalidez;

TRUNCATE table dds.PlanillaSinEnCursoBeneficiario;

TRUNCATE table dds.PlanillaSinOcurridoNoRepoCauSobrevivencia;

TRUNCATE table dds.PlanillaSinOcurridoNoRepoBeneficiario;


GRANT SELECT ON Oficio14880.SiniestroOcurridoNoRepoBeneficiario TO Oficio14880Consulta

GRANT SELECT ON DDS.PlanillaSinOcurridoNoRepoBeneficiario TO DDSConsulta

    
SELECT * FROM Oficio14880.AuditoriaCE ac 


CREATE VIEW DMGestion.VistaSiniestroOcurridoNoRepoBeneficiario as
SELECT * 
FROM DDS.PlanillaSinOcurridoNoRepoBeneficiario   

SinEnCursoCausanteInvalidez


GRANT SELECT ON DMGestion.VistaSiniestroOcurridoNoRepoBeneficiario TO Oficio14880




CALL Oficio14880.cargarSiniestroEnCursoBeneficiario();

CALL Oficio14880.cargarSiniestroEnCursoCausanteInvalidez();


CALL Oficio14880.cargarSiniestroEnCursoCausanteInvalidezManual('20240901');

CALL Oficio14880.cargarSiniestroEnCursoBeneficiarioManual('20240901');

CALL Oficio14880.cargarSiniestroEnCursoSinSobreviInvalTramiteManual('20240901');

CALL Oficio14880.cargarSiniestroOcurridoNoRepoCauSobrevivenciaManual('20240901');

CALL Oficio14880.cargarSiniestroOcurridoNoRepoBeneficiarioManual('20240901');


SELECT * FROM Oficio14880.AuditoriaCE ac 

SELECT * FROM ControlProcesos.ErrorProceso ep 
ORDER BY id DESC




SELECT * FROM DDS.PlanillaSinOcurridoNoRepoBeneficiario


CREATE TABLE DDS.PlanillaSinOcurridoNoRepoBeneficiario (
    periodoInformado int NOT NULL,
    anioContrato int NOT NULL,
    numeroSiniestro varchar(10) NULL,
    rutCausante bigint NOT NULL,
    dvCausante char(1) NOT NULL,
    rutBeneficiario bigint NOT NULL,
    dvBeneficiario char(1) NOT NULL,
    apePaternoBenef varchar(30) NULL,
    apeMaternoBenef varchar(30) NULL,
    nombresBenef varchar(30) NULL,
    fechaNaciminentoBenef date NOT NULL,
    sexoBenef char(1) NOT NULL,
    situacionInvalidez char(1) NOT NULL,
    parentescoBenef int NOT NULL,
    derechoPension int NOT NULL,
    grupoFamiliar int NULL,
    capitalNecesarioUF int NULL
);


CREATE TABLE Oficio14880.SiniestroOcurridoNoRepoBeneficiario (
    periodoInformado date NOT NULL,
    anioContrato int NOT NULL,
    numeroSiniestro varchar(10) NULL,
    rutCausante bigint NOT NULL,
    dvCausante char(1) NOT NULL,
    rutBeneficiario bigint NOT NULL,
    dvBeneficiario char(1) NOT NULL,
    apePaternoBenef varchar(30) NULL,
    apeMaternoBenef varchar(30) NULL,
    nombresBenef varchar(30) NULL,
    fechaNaciminentoBenef date NOT NULL,
    sexoBenef char(1) NOT NULL,
    situacionInvalidez char(1) NOT NULL,
    parentescoBenef int NOT NULL,
    derechoPension int NOT NULL,
    grupoFamiliar int NULL,
    capitalNecesarioUF numeric(7,2) NULL
);


SELECT * FROM Oficio14880.SiniestroOcurridoNoRepoBeneficiario




SELECT dp.rut rutTrabajador,dp.dv dvTrabajador,
    dp2.rut rutEmpleador,dp2.dv dvEmpleador,dcp.periodoCotizado,dcp.remuneracionImponible
    --INTO #UniversoDNPUpdate
    FROM DMGestion.FctDetalleDeudaCotizacionesPrevisionales dcp
    INNER JOIN DMGestion.DimPersona dp ON dp.id = dcp.idAfiliado
    INNER JOIN DMGestion.DimPersona dp2 ON dp2.id = dcp.idEmpleador
    INNER JOIN DMGestion.DimTipoProducto dtp ON dtp.id = dcp.idTipoProducto
    INNER JOIN DMGestion.DimOrigenDeuda dod ON dod.id = dcp.idOrigenDeuda
    INNER JOIN DMGestion.DimSituacionDeuda dsd ON dsd.id = dcp.idSituacionDeuda
    INNER JOIN DMGestion.DimTipoConcepto dtc ON dtc.id = dcp.idTipoConcepto
    INNER JOIN DMGestion.DimPeriodoInformado dpi ON dpi.id = dcp.idPeriodoInformado
    WHERE dcp.periodoCotizado  >= '2023-09-01' AND dcp.periodoCotizado <= '20240801'
    AND dpi.fecha  = '2024-08-01'
    AND dtp.codigo = 1 -- CCICO
    AND dod.codigo = '01' --- Declaración y No Pago
    AND dsd.codigo = 1    -- Ingresada
    AND dtc.codigo = '102' -- Cotización Obligatoria
    AND dp.rut  IN (7324520,14406327);
    

CALL DMGestion.cargarUniversoDeudaTMP('20240801');


SELECT * FROM DMGestion.UniversoDeudaTMP
WHERE rutAfiNoIdentificado IN (7324520,14406327);