--Informes de Lavado de Activos

--RIESGO BASE POR PONDERACION 
SELECT dp.rut , dv, de.codigoEscenario, fo.valorOperacionEscenario ,fo.valorOperacionNormalizado, fo.valorOperacionRiesgoEscenario , fo.valorRiesgoPonderado , fo.indCriterioAlerta , dra.nombre riesgoAlerta
,frb.riesgoBase,  indPep , indListaNegra  , indPreAlertaUlt6Meses ,  frb.indROS  ,pondNacionalidad    ,pondIndAlertasPrevias   ,pondCargoPoliticoPep   , pondAlertaROS  , pondCuentasVoluntarias , pondSituacionEconomica  ,pondSaldoCuentasVoluntarias ,pondTipoCliente ,pondListaNegra
from lavadoactivos.FctOperacionesRiesgosas fo
    inner join DMGestion.DimPersona dp on dp.id = fo.idPersona 
    inner join DMGestion.DimPeriodoInformado dpi on dpi.id = fo.idPeriodoInformado
    INNER JOIN lavadoactivos.DimEscenario de ON de.id = fo.idEscenario 
    INNER JOIN lavadoactivos.DimRiesgoAlerta dra ON dra.id = fo.idRiesgoAlerta 
    INNER JOIN lavadoactivos.FctRiesgoBase frb ON frb.idPeriodoInformado = dpi.id AND frb.idPersona = dp.id 
where dpi.fecha = '20241101'
AND codigoEscenario not in ('15','17')



--RIESGO ALERTAS POR VARIABLES                       

SELECT
            a.fecha      periodoInformado,
            a.rut ,
            dp.dv ,    
              a.edad,
              a.sexo,
              dcl.nombre                              clasificacionPersona,
              dtc.nombre                                                                                                          tipoCotizante,
              dpa.nombre                              nacionalidad,
              a.mesesPermanenciaAFP,
              --a.nacionalidad,
              a.rentaUFUltimoPeriodo,
              a.montoPensionPagadoUF,
              //case when a.cargoPoliticoPep = 'Relacionado' then  'Relacionado' else  dcp.nombre  end cargoPolitico,
              a.cargoPoliticoPep,
              dlr.nombre                                                                                                          indListaNegra,
              a.listaNegra,
              a.montoSaldoUFCCICO,
              a.montoSaldoUFCAV,
              a.montoSaldoUFCAI,
              a.montoSaldoUFCCICV, 
              a.montoSaldoUFCCIDC,
              a.montoSaldoUFCCIAV, 
              a.montoSaldoUFCAPVC,
              a.saldoVolUF,
              a.cuentasVoluntarias,
              a.situacionEconomica,
              a.saldoCuentasVoluntarias,
              a.tipoCliente,
              a.indAlertasPrevias,
              a.opSospechosasPrevias,
              a.alertaROS,
              a.indTotalRotaciones    
FROM LavadoActivos.variablesVectorPersonas a
    INNER JOIN DMGestion.DimPeriodoInformado dpi ON ( a.fecha = dpi.fecha )
              INNER JOIN DMGestion.DimPersona dp ON ( a.rut = dp.rut )
    //LEFT OUTER JOIN LavadoActivos.DimCargoPoliticoPROS dcp ON ( a.cargoPoliticoPep = dcp.grupo 
    //   AND dcp.fechaVigencia >= DATE('21991231')) 
    LEFT OUTER JOIN LavadoActivos.DimListaNegraRos dlr ON ( a.indListaNegra = dlr.codigo 
        AND dlr.fechaVigencia >= DATE('21991231'))  
    LEFT OUTER JOIN DMGestion.DimTipoCotizante dtc ON ( a.tipoCotizante = dtc.codigo 
        AND dtc.fechaVigencia >= DATE('21991231'))
    LEFT OUTER JOIN DMGestion.DimPais dpa ON ( UPPER(a.nacionalidad) = UPPER(dpa.codigo) 
        AND dpa.fechaVigencia >= DATE('21991231'))
    LEFT OUTER JOIN DMGestion.DimClasificacionPersona dcl ON ( a.clasificacionPersona = dcl.codigo
        AND dcl.fechaVigencia >= DATE('21991231'))
WHERE dpi.fecha  ='20241101'
AND dp.fechaVigencia >= DATE('21991231')
and dp.rut in (select DISTINCT dp.rut  
                 from lavadoactivos.FctOperacionesRiesgosas fo
                    inner join DMGestion.DimPersona dp on dp.id = fo.idPersona 
                    inner join DMGestion.DimPeriodoInformado dpi on dpi.id = fo.idPeriodoInformado
                    INNER JOIN lavadoactivos.DimEscenario de ON de.id = fo.idEscenario AND de.codigoEscenario not in ('15','17')
                where dpi.fecha = '20241101')
ORDER BY a.fecha DESC;
