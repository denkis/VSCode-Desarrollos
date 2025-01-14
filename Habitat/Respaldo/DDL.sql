CREATE TABLE habitat.dchavez.FctLagunaPrevisionalDetalle (
	idPeriodoInformado int NOT NULL,
	idPersona bigint NOT NULL,
	fechaPension date NULL,
	fechaInicioLaguna date NULL,
	fechaTerminoLaguna date NULL,
	nroLaguna bigint NULL,
	nroMesesLaguna int NULL,
	nroMesesAbonoCAV int NULL,
	indVigenciaUltimaLAguna char(2) NULL,
	indExisteDNP char(2) NULL,
	indExisteDNPA char(2) NULL,
	indTerminoRelacionLaboral char(2) NULL,
	montoPesosCotiAnterior int NULL,
	montoUFCotiAnterior numeric(10,2) NULL,
	montoTotalPesosAbonoCAV bigint NULL,
	nroMesesAbonoCCICV int NULL,
	montoTotalPesosAbonoCCICV bigint NULL,
	nroMesesAbonoCCIDC int NULL,
	montoTotalPesosAbonoCCIDC bigint NULL,
	nroMesesAbonoProdVoluntario int NULL,
	totalPlanesAPV int NULL,
	nroMesesAbonoCCIAV int NULL
);

CREATE TABLE habitat.dchavez.FctLagunaPrevisional (
	idPeriodoInformado int NOT NULL,
	idPersona bigint NOT NULL,
	nroTotalLagunasPrevisionales int NULL,
	nroTotalMesesConLaguna int NULL,
	nroTotalMesesSinLaguna int NULL,
	nroPromedioMesesLaguna numeric(5,2) NULL,
	porcMesesConLaguna numeric(6,3) NULL,
	nroTotaTerminoRelacionLaboral int NULL,
	nrototalAbonosCCIAV int NULL,
	indPensionado char(2) NULL,
	indMantieneLagunaVigente char(2) NULL
);

CREATE TABLE habitat.lavadoactivos.ControlTransmision (
	nombreTabla varchar(250) NOT NULL,
	nroParticion bigint NOT NULL,
	nroFilaIni bigint NULL,
	nroFilaFin bigint NULL,
	indTransmitido char(2) DEFAULT 'No' NOT NULL,
	fechaHoraTransmision timestamp NULL
);