create PROCEDURE dchavez.cargarFctLagunaPrevisionalDetalle(OUT codigoError VARCHAR(10))
BEGIN
    /*-----------------------------------------------------------------------------------------
    - Nombre archivo                            : cargarFctDeudaPresunta.sql
    - Nombre del módulo                         : Modelo de Deudas
    - Fecha de  creación                        : 27-08-2010
    - Nombre del autor                          : Ricardo Salinas - Gesfor Chile S.A.
    - Descripción corta del módulo              : Procedimiento que carga FctDeudaPresunta
    - Lista de procedimientos contenidos        :
    - Documentos asociados a la creación        : Mapping Deudas v03
    - Fecha de modificación                     : 26-08-2013
    - Nombre de la persona que lo modificó      : Ricardo Salinas S. - CGI
    - Cambios realizados                        : Modificaciones para 1661V1
    - Documentos asociados a la modificación    : Documento Análisis  Diseño - BDA - Ex Circ  1661 - Deudas_v1 Final.docx
    -------------------------------------------------------------------------------------------*/

    -------------------------------------------------------------------------------------------
    --Declaración de Variables
    -------------------------------------------------------------------------------------------
    -- Variable para capturar el codigo de error
    DECLARE lstCodigoError                      VARCHAR(10);    --variable local de tipo varchar
    -- Variables Locales
    DECLARE ldtPeriodoInformar                  DATE;
   
    -- Constantes 
    DECLARE cstOwner                            VARCHAR(150);
    DECLARE cstNombreProcedimiento              VARCHAR(150);   --constante de tipo varchar
    DECLARE cstCodigoErrorCero                  VARCHAR(10);

    -------------------------------------------------------------------------------------------
    --Seteo de Constantes
    -------------------------------------------------------------------------------------------
    SET cstOwner                                = 'dchavez';
    SET cstNombreProcedimiento                  = 'cargarFctLagunaPrevisionalDetalle';
    SET cstCodigoErrorCero                      = '0';

    -------------------------------------------------------------------------------------------
    --Seteo de Variables
    -------------------------------------------------------------------------------------------
    SET ldtPeriodoInformar                      = DMGestion.obtenerFechaPeriodoInformar();
    

    -------------------------------------------------------------------------------------------
    --Cuerpo
    -------------------------------------------------------------------------------------------
    
        --Se ejecuta periodo Actual
        CALL dchavez.cargarFctLagunaPrevisionalDetalleManual(ldtPeriodoInformar, codigoError);
    

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