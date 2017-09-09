

DROP TABLE IF EXISTS `corso`;
DROP TABLE IF EXISTS `docente`;
DROP TABLE IF EXISTS `edificio`;
DROP TABLE IF EXISTS `insegnamento`;
DROP TABLE IF EXISTS `prenotazione`;
DROP TABLE IF EXISTS `stanza`;
DROP TABLE IF EXISTS `supporto`;
DROP TABLE IF EXISTS `tecnico_amministrativo`;

--
-- Database: `basidati`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `corso`
--

CREATE TABLE `corso` (
  `Codice` int(11) NOT NULL,
  `Nome` varchar(30) NOT NULL,
  `Laurea` varchar(30) NOT NULL,
  `IsMagistrale` tinyint(1) NOT NULL,

  PRIMARY KEY (`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `edificio`
--

CREATE TABLE `edificio` (
  `Nome` varchar(16) NOT NULL,
  `Via` varchar(30) NOT NULL,
  `NumeroCivico` varchar(5) NOT NULL,

  PRIMARY KEY (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `stanza`
--

CREATE TABLE `stanza` (
  `Nome` varchar(10) NOT NULL,
  `NumPosti` int(11) NOT NULL,
  `TipoStanza` set('Aula','Laboratorio','Ufficio') NOT NULL,
  `Piano` int(11) NOT NULL,
  `IdEdificio` varchar(16) NOT NULL,

  PRIMARY KEY (`Nome`),
  FOREIGN KEY (`IdEdificio`) REFERENCES `edificio` (`Nome`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `docente`
--

CREATE TABLE `docente` (
  `Matricola` int(7) NOT NULL,
  `Nome` varchar(15) NOT NULL,
  `Cognome` varchar(15) NOT NULL,
  `AreaRicerca` varchar(20) NOT NULL,
  `Fascia` set('Associato','Ordinario','Contratto','') NOT NULL,
  `Categoria` set('Professore','Ricercatore','Dottorando','Assegnista') NOT NULL,
  `IdStanza` varchar(10) DEFAULT NULL,

  PRIMARY KEY (`Matricola`),
  FOREIGN KEY (`IdStanza`) REFERENCES `stanza` (`Nome`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `insegnamento`
--

CREATE TABLE `insegnamento` (
  `DataInizio` date NOT NULL,
  `DataFine` date NOT NULL,
  `IdCorso` int(11) NOT NULL,
  `IdDocente` int(7) NOT NULL,

  PRIMARY KEY (`DataInizio`,`DataFine`,`IdCorso`,`IdDocente`),
  FOREIGN KEY (`IdCorso`) REFERENCES `corso` (`Codice`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`IdDocente`) REFERENCES `docente` (`Matricola`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `prenotazione`
--

CREATE TABLE `prenotazione` (
  `IdStanza` varchar(10) NOT NULL,
  `IdCorso` int(11) NOT NULL,
  `DataInizio` datetime NOT NULL,
  `DataFine` datetime NOT NULL,

  PRIMARY KEY (`IdStanza`,`DataInizio`,`DataFine`),
  FOREIGN KEY (`IdStanza`) REFERENCES `stanza` (`Nome`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`IdCorso`) REFERENCES `corso` (`Codice`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `supporto`
--

CREATE TABLE `supporto` (
  `IdDocenteSupporto` int(7) NOT NULL,
  `IdCorso` int(11) NOT NULL,
  `DataInizio` date NOT NULL,
  `DataFine` date NOT NULL,
  `IdDocente` int(7) NOT NULL,

  PRIMARY KEY (`IdDocenteSupporto`,`IdCorso`,`DataInizio`,`DataFine`,`IdDocente`),
  FOREIGN KEY (`IdDocenteSupporto`) REFERENCES `docente` (`Matricola`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`DataInizio`) REFERENCES `insegnamento` (`DataInizio`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`IdCorso`) REFERENCES `insegnamento` (`IdCorso`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`IdDocente`) REFERENCES `insegnamento` (`IdDocente`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `tecnico_amministrativo`
--

CREATE TABLE `tecnico_amministrativo` (
  `Matricola` int(7) NOT NULL,
  `Nome` varchar(15) NOT NULL,
  `Cognome` varchar(15) NOT NULL,
  `Ruolo` set('Tecnico','Segretario') NOT NULL,
  `IdStanza` varchar(15) DEFAULT NULL,

  PRIMARY KEY (`Matricola`),
  FOREIGN KEY (`IdStanza`) REFERENCES `stanza` (`Nome`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- -----------------------------------------------
--
-- Inserimento dei dati nella tabella `corso`
--

INSERT INTO `corso` (`Codice`, `Nome`, `Laurea`, `IsMagistrale`) VALUES
(126065416, 'Calcolo Numerico', 'Informatica', 0),
(126065418, 'Sistemi Operativi', 'Informatica', 0),
(128515122, 'Reti e Sicurezza', 'Informatica', 0),
(188784544, 'Programmazione', 'Informatica', 0),
(214245428, 'Programmazione ad oggetti', 'Informatica', 0),
(245578645, 'Basi di dati', 'Informatica', 0),
(248745844, 'Analisi Matematica', 'Informatica', 0),
(254789647, 'Architettura degli elaboratori', 'Informatica', 0);

-- -----------------------------------------------
--
-- Inserimento dei dati nella tabella `edificio`
--

INSERT INTO `edificio` (`Nome`, `Via`, `NumeroCivico`) VALUES
('Paolotti', 'Via Luzzati, Padova, PD', '8'),
('Torre Archimede', 'Via Trieste, Padova, PD', '63');

-- -----------------------------------------------
--
-- Inserimento dei dati nella tabella `stanza`
--

INSERT INTO `stanza` (`Nome`, `NumPosti`, `TipoStanza`, `Piano`, `IdEdificio`) VALUES
('369', 2, 'Ufficio', 4, 'Torre Archimede'),
('402', 1, 'Ufficio', 4, 'Torre Archimede'),
('404', 1, 'Ufficio', 3, 'Torre Archimede'),
('LabP140', 140, 'Laboratorio', 2, 'Paolotti'),
('LabP36', 36, 'Laboratorio', 2, 'Paolotti'),
('LabTA', 63, 'Laboratorio', 2, 'Torre Archimede'),
('Lum250', 250, 'Aula', 0, 'Paolotti'),
('P100', 100, 'Aula', 4, 'Paolotti'),
('P200', 200, 'Aula', 4, 'Paolotti'),
('Ufficio', 2, 'Ufficio', 4, 'Torre Archimede');

-- -----------------------------------------------
--
-- Inserimento dei dati nella tabella `docente`
--

INSERT INTO `docente` (`Matricola`, `Nome`, `Cognome`, `AreaRicerca`, `Fascia`, `Categoria`, `IdStanza`) VALUES
(2174569, 'Michela', 'Zaglia', 'MAT/08', 'Associato', 'Professore', NULL),
(3456874, 'Alessandro', 'Sperduti', 'INF/01', 'Associato', 'Professore', NULL),
(3457895, 'Gilberto', 'File\'', 'INF/01', 'Ordinario', 'Professore', '404'),
(3546845, 'Massimo', 'Marchiori', 'INFO/01', 'Associato', 'Professore', NULL),
(4756842, 'Francesco', 'Ranzato', 'INF/01', 'Associato', 'Professore', NULL),
(11245789, 'Caterina', 'Sartori', 'MAT/05', 'Contratto', 'Professore', '369'),
(12764587, 'Claudio', 'Palazzi', 'INF/01', 'Associato', 'Professore', NULL),
(32145684, 'Mauro', 'Conti', 'INF/01', 'Associato', 'Professore', '402');

-- -----------------------------------------------
--
-- Inserimento dei dati nella tabella `insegnamento`
--

INSERT INTO `insegnamento` (`DataInizio`, `DataFine`, `IdCorso`, `IdDocente`) VALUES
('2017-10-01', '2018-09-30', 126065416, 2174569),
('2017-10-01', '2018-09-30', 126065418, 12764587),
('2017-10-01', '2018-09-30', 128515122, 3546845),
('2017-10-01', '2018-09-30', 188784544, 3457895),
('2017-10-01', '2018-09-30', 214245428, 4756842),
('2017-10-01', '2018-09-30', 245578645, 32145684),
('2017-10-01', '2018-09-30', 248745844, 11245789),
('2017-10-01', '2018-09-30', 254789647, 3456874);

-- -----------------------------------------------
--
-- Inserimento dei dati nella tabella `prenotazione`
--

INSERT INTO `prenotazione` (`IdStanza`, `IdCorso`, `DataInizio`, `DataFine`) VALUES
('LabP140', 126065416, '2017-10-20 10:00:00', '2017-10-20 13:00:00'),
('LabTA', 188784544, '2017-10-20 09:00:00', '2017-10-20 13:00:00'),
('P200', 214245428, '2017-10-20 09:00:00', '2017-10-20 13:00:00'),
('LabP36', 245578645, '2017-10-20 09:00:00', '2017-10-20 13:00:00'),
('Lum250', 248745844, '2017-10-20 13:00:00', '2017-10-20 15:00:00'),
('Lum250', 254789647, '2017-10-20 09:00:00', '2017-10-20 11:00:00');

-- -----------------------------------------------
--
-- Funzione la quale verifica se e' disponibile un'aula in un determinato lasso di tempo  
-- ritorna true se esiste gia' una prenotazione altrimenti false
--
DROP FUNCTION IF EXISTS CheckPrenotazione;
DELIMITER |
CREATE FUNCTION CheckPrenotazione(Stanza VARCHAR(10),Corso INT(11),DataInizio DATETIME, DataFine DATETIME)
RETURNS BOOLEAN
BEGIN
	IF EXISTS (SELECT p.DataInizio
                FROM prenotazione AS p
                WHERE Stanza = p.IdStanza AND p.DataInizio<DataFine AND p.DataFine>DataInizio)THEN
    	RETURN 1;
    ELSE
    	RETURN 0;
    END IF;
END|

DELIMITER ;

-- -----------------------------------------------
--
-- Funzione la quale verifica se un ufficio ha un posto disponibile
-- Ritorna falso se ha posti disponibili
-- Ritrona true se non ha posti disponibili
--
DROP FUNCTION IF EXISTS CheckUffici;
DELIMITER |
CREATE FUNCTION CheckUffici(Ufficio VARCHAR(10))
RETURNS BOOLEAN
BEGIN
	IF ((SELECT COUNT(stanza.Nome) AS Numero
        FROM ((stanza LEFT JOIN docente ON stanza.Nome=docente.IdStanza) LEFT JOIN tecnico_amministrativo ON stanza.Nome = tecnico_amministrativo.IdStanza)
        WHERE Ufficio = stanza.Nome)
        <
        (SELECT stanza.NumPosti
        FROM stanza
        WHERE Ufficio=stanza.Nome))THEN
    	RETURN 0; 
    ELSE
    	RETURN 1;
    END IF;
END|

DELIMITER ;

-- -------------------------------------------------
--
-- Trigger il quale ha il compito di verificare:
-- se non gli sia stata assegnata al docente una stanza che corrisponda ad un'aula, laboratorio o sala riunioni
-- se la stanza assegnata ha raggiunto la capienza massima
-- se la Categoria corrisponde al professore, allora la fascia non puo' essere vuota
-- se la Categoria non corrisponde al professore, allora la fascia deve essere vuota
-- 

DROP TRIGGER IF EXISTS Before_Docente_Insert;
DELIMITER |
CREATE TRIGGER `Before_Docente_Insert` BEFORE INSERT ON `docente` FOR EACH ROW BEGIN
DECLARE Tipo varchar(15);

DECLARE TipoC varchar(15);
SET TipoC = NEW.Categoria;

SELECT TipoStanza INTO Tipo
    FROM stanza
    WHERE Nome=NEW.IdStanza;

IF ('Aula' LIKE Tipo OR 'Laboratorio' LIKE Tipo OR 'Sala riunioni' LIKE Tipo) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Impossibile aggiungere il docente, al docente e'' possibile assegnargli solo gli uffici';
END IF;
IF (CheckUffici(NEW.IdStanza)) THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Impossibile aggiungere il docente, l''ufficio ha gia'' raggiunto la capienza massima';
END IF;

IF ('Professore' LIKE TipoC) THEN
	IF ('' LIKE NEW.Fascia) THEN
    	SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = 'Impossibile aggiungere il docente, al professore va assegnata la fascia';
    END IF;
ELSE IF ('' NOT LIKE NEW.Fascia) THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Impossibile aggiungere il docente, la fascia va assegnata solo al professore';
END IF;
END IF;

END|
DELIMITER ;

-- -------------------------------------------------
--
-- Ha il compito di verificare l'inserimento di una prenotazione corretta tramite il controllo:
-- Se l'aula selezionata e' corretta
-- se la data inzio e' < della data della fine prenotazione
-- se e' disponibile l'aula in quel lasso di tempo
--

DROP TRIGGER IF EXISTS Before_Prenotazione_Insert;
DELIMITER |
CREATE TRIGGER `Before_Prenotazione_Insert` BEFORE INSERT ON `prenotazione` FOR EACH ROW BEGIN
DECLARE Tipo varchar(15);

SELECT TipoStanza INTO Tipo
    FROM stanza
    WHERE Nome=NEW.IdStanza;
    
IF ('Aula' LIKE Tipo OR 'Laboratorio' LIKE Tipo OR 'Sala riunioni' LIKE Tipo) THEN

    BEGIN
        IF(NEW.DataInizio >= NEW.DataFine) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Impossibile aggiungere la prenotazione, la data inizio deve essere < della data fine';
        END IF;

        IF (CheckPrenotazione(NEW.IdStanza, NEW.IdCorso, NEW.DataInizio, NEW.DataFine))THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Impossibile aggiungere la prenotazione, le date si sovrappongono';
        END IF;
	END;
ELSE
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Impossibile aggiungere la prenotazione, gli uffici non possono essere prenotati';
END IF;
END|
DELIMITER ;

-- ----------------------------------------------------
--
-- Ha il compito di verificare che al tecnico amministrativo non gli venga assegnata una stanza diversa dall'uffico
--

DROP TRIGGER IF EXISTS Before_Tecnico_Insert;
DELIMITER |
CREATE TRIGGER `Before_Tecnico_Insert` BEFORE INSERT ON `tecnico_amministrativo` FOR EACH ROW BEGIN
DECLARE Tipo varchar(15);

SELECT TipoStanza INTO Tipo
    FROM stanza
    WHERE Nome=NEW.IdStanza;

IF ('Aula' LIKE Tipo OR 'Laboratorio' LIKE Tipo OR 'Sala riunioni' LIKE Tipo) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Impossibile aggiungere l''utente, al tecnico ammministrativo e'' possibile assegnargli solo gli uffici';
END IF;

IF (CheckUffici(NEW.IdStanza)) THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Impossibile aggiungere il tecnico, l''ufficio ha gia'' raggiunto la capienza massima';
END IF;

END|
DELIMITER ;


-- ----------------------------------------------------
--
-- Inserisce piu' prenotazioni in un lasso di tempo, sempre nello stesso giorno della settimana, 
-- partendo da DataInizio con orari: OraInzio a Orafine fino al raggiungimento della DataFine
-- 

DROP PROCEDURE IF EXISTS PrenotazioneSettimanale;

DELIMITER |
CREATE PROCEDURE PrenotazioneSettimanale(Stanza VARCHAR(10),Corso INT(11),DataInizio DATE, DataFine DATE, OraInizio TIME, OraFine TIME)

BEGIN
DECLARE DataProgress DATETIME;

	IF (DataInizio<DataFine AND OraInizio<OraFine) THEN
    SELECT DATE_ADD(DataInizio,INTERVAL 0 DAY) INTO DataProgress;
    	WHILE (DataProgress<=DataFine) DO
        	IF NOT(CheckPrenotazione(Stanza, Corso, DataProgress+OraInizio, DataProgress+OraFine)) THEN
                INSERT INTO `prenotazione` (`IdStanza`, `IdCorso`, `DataInizio`, `DataFine`) VALUES
                (Stanza, Corso, DataProgress+OraInizio, DataProgress+OraFine);
            END IF;
            SELECT DATE_ADD(DataProgress,INTERVAL 7 DAY) INTO DataProgress;
		END WHILE;
        
    END IF;
END|
DELIMITER ;

