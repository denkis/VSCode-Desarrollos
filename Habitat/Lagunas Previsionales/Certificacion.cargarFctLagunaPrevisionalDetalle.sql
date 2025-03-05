create PROCEDURE Certificacion.cargarFctLagunaPrevisionalDetalle(OUT codigoError VARCHAR(10))
BEGIN
    /*-----------------------------------------------------------------------------------------
    - Nombre archivo                            : cargarFctLagunaPrevisionalDetalle.sql
    - Nombre del módulo                         : Modelo de Laguna Previsional
    - Fecha de  creación                        : 02-02-2025
    - Nombre del autor                          : Denis Chávez - Cognitiva-ti.
    - Descripción corta del módulo              : Procedimiento que carga FCTLagunaPrevisionalDetalle
    - Lista de procedimientos contenidos        :
    - Documentos asociados a la creación        : 
    - Fecha de modificación                     : 
    - Nombre de la persona que lo modificó      : 
    - Cambios realizados                        : 
    - Documentos asociados a la modificación    : 
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
    SET cstOwner                                = 'Certificacion';
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
        CALL Certificacion.cargarFctLagunaPrevisionalDetalleManual(ldtPeriodoInformar, codigoError);
    

-------------------------------------------------------------------------------------------     
--Manejo de Excepciones      
-------------------------------------------------------------------------------------------
EXCEPTION
    WHEN OTHERS THEN
        SET lstCodigoError = SQLSTATE;
        SET codigoError = lstCodigoError;
        ROLLBACK;
        CALL Certificacion.registrarErrorProceso(cstOwner, cstNombreProcedimiento, lstCodigoError);
END