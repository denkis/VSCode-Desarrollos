create PROCEDURE lavadoActivos.actualizaTransmision(IN inNombreTabla varchar(100), IN inNroParticion integer,OUT codigoError VARCHAR(10))
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
    


    --Seteo de constantes
    SET cstNombreProcedimiento  = 'actualizaTransmision';
    SET cstNombreTabla          = 'ControlTransmision';
   


    UPDATE lavadoactivos.ControlTransmision
    SET indTransmitido = 'Si'
    , fechaHoraTransmision = GETDATE()
    WHERE nroParticion = inNroParticion
        AND  nombreTabla = inNombreTabla;


    COMMIT;
    SAVEPOINT;

    SET codigoError = '0';

--Manejo de errores
EXCEPTION
    WHEN OTHERS THEN
        SET lstCodigoError = SQLSTATE;
        SET codigoError = lstCodigoError;
        ROLLBACK;
        --CALL DMGestion.registrarErrorProceso(cstNombreProcedimiento, lstCodigoError);
END