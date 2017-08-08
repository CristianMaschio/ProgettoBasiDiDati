-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Ago 08, 2017 alle 10:16
-- Versione del server: 10.1.25-MariaDB
-- Versione PHP: 7.1.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `database v0.03`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `corso`
--

CREATE TABLE `corso` (
  `Codice` int(11) NOT NULL,
  `Nome` varchar(30) NOT NULL,
  `Laurea` varchar(30) NOT NULL,
  `IsMagistrale` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `corso`
--

INSERT INTO `corso` (`Codice`, `Nome`, `Laurea`, `IsMagistrale`) VALUES
(12606541, 'Sistemi Operativ', 'Informatica', 1),
(126065416, 'Calcolo Numerico', 'Informatica', 0);

-- --------------------------------------------------------

--
-- Struttura della tabella `docente`
--

CREATE TABLE `docente` (
  `Matricola` int(7) NOT NULL,
  `Nome` varchar(15) NOT NULL,
  `Cognome` varchar(15) NOT NULL,
  `AreaRicerca` varchar(20) NOT NULL,
  `Fascia` set('Associato','Ordinario','Contratto','') DEFAULT NULL,
  `Categoria` set('Professore','Ricercatore','Dottorando','Assegnista') NOT NULL,
  `IdStanza` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `docente`
--

INSERT INTO `docente` (`Matricola`, `Nome`, `Cognome`, `AreaRicerca`, `Fascia`, `Categoria`, `IdStanza`) VALUES
(3434, 'Mario', 'Rossi', 'Rosso', 'Ordinario', 'Professore', 'Ufficio'),
(1551215484, 'Andrea', 'Ciucchi Ciucchi', 'Ritardi di Marchiori', '', 'Ricercatore', 'Ufficio');

--
-- Trigger `docente`
--
DELIMITER $$
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

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `edificio`
--

CREATE TABLE `edificio` (
  `Nome` varchar(16) NOT NULL,
  `Via` varchar(30) NOT NULL,
  `NumeroCivico` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `edificio`
--

INSERT INTO `edificio` (`Nome`, `Via`, `NumeroCivico`) VALUES
('Paolotti', 'Via Luzzati, Padova, PD', '8'),
('Torre Archimede', 'Via Trieste, Padova, PD', '63');

-- --------------------------------------------------------

--
-- Struttura della tabella `insegnamento`
--

CREATE TABLE `insegnamento` (
  `DataInizio` date NOT NULL,
  `DataFine` date NOT NULL,
  `IdCorso` int(11) NOT NULL,
  `IdDocente` int(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `insegnamento`
--

INSERT INTO `insegnamento` (`DataInizio`, `DataFine`, `IdCorso`, `IdDocente`) VALUES
('2017-07-26', '2018-07-26', 12606541, 1551215484);

-- --------------------------------------------------------

--
-- Struttura della tabella `prenotazione`
--

CREATE TABLE `prenotazione` (
  `IdStanza` varchar(10) NOT NULL,
  `IdCorso` int(11) NOT NULL,
  `DataInizio` datetime NOT NULL,
  `DataFine` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `prenotazione`
--

INSERT INTO `prenotazione` (`IdStanza`, `IdCorso`, `DataInizio`, `DataFine`) VALUES
('LabP36', 12606541, '2017-07-21 00:00:00', '2017-07-22 00:00:00'),
('LabP140', 126065416, '2017-07-12 00:00:00', '2017-07-26 00:00:00'),
('LabTA', 126065416, '2017-07-31 09:00:00', '2017-07-31 13:00:00'),
('P200', 126065416, '2017-07-20 00:00:00', '2017-07-21 00:00:00');

--
-- Trigger `prenotazione`
--
DELIMITER $$
CREATE TRIGGER `Before_Prenotazione_Insert` BEFORE INSERT ON `prenotazione` FOR EACH ROW BEGIN
DECLARE Tipo varchar(15);

SELECT TipoStanza INTO Tipo
    FROM stanza
    WHERE Nome=NEW.IdStanza;
    
IF ('Aula' LIKE Tipo OR 'Laboratorio' LIKE Tipo OR 'Sala riunioni' LIKE Tipo) THEN

    BEGIN
    IF EXISTS (SELECT DataInizio
               FROM prenotazione
               WHERE NEW.IdStanza = IdStanza AND DataInizio<NEW.DataFine AND DataFine>NEW.DataInizio)THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Impossibile aggiungere la prenotazione, le date si sovrappongono';
    END IF;

    IF(NEW.DataInizio >= NEW.DataFine) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Impossibile aggiungere la prenotazione, la data inizio deve essere < della data fine';
    END IF;
	END;
    
    ELSE
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Impossibile aggiungere la prenotazione, gli uffici non possono essere prenotati';
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `stanza`
--

CREATE TABLE `stanza` (
  `Nome` varchar(10) NOT NULL,
  `NumPosti` int(11) NOT NULL,
  `TipoStanza` set('Aula','Laboratorio','Ufficio') NOT NULL,
  `Piano` int(11) NOT NULL,
  `IdEdificio` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `stanza`
--

INSERT INTO `stanza` (`Nome`, `NumPosti`, `TipoStanza`, `Piano`, `IdEdificio`) VALUES
('LabP140', 140, 'Laboratorio', 2, 'Paolotti'),
('LabP36', 36, 'Laboratorio', 2, 'Paolotti'),
('LabTA', 63, 'Laboratorio', 2, 'Torre Archimede'),
('P100', 100, 'Aula', 4, 'Paolotti'),
('P200', 200, 'Aula', 4, 'Paolotti'),
('Ufficio', 2, 'Ufficio', 4, 'Torre Archimede');

-- --------------------------------------------------------

--
-- Struttura della tabella `supporto`
--

CREATE TABLE `supporto` (
  `IdDocenteSupporto` int(7) NOT NULL,
  `IdCorso` int(11) NOT NULL,
  `DataInizio` date NOT NULL,
  `DataFine` date NOT NULL,
  `IdDocente` int(7) NOT NULL
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
  `IdStanza` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `tecnico_amministrativo`
--

INSERT INTO `tecnico_amministrativo` (`Matricola`, `Nome`, `Cognome`, `Ruolo`, `IdStanza`) VALUES
(5444515, 'Pozio', 'Conzio', 'Tecnico', 'Ufficio');

--
-- Trigger `tecnico_amministrativo`
--
DELIMITER $$
CREATE TRIGGER `Before_Tecnico_Insert` BEFORE INSERT ON `tecnico_amministrativo` FOR EACH ROW BEGIN
DECLARE Tipo varchar(15);

SELECT TipoStanza INTO Tipo
    FROM stanza
    WHERE Nome=NEW.IdStanza;

IF ('Aula' LIKE Tipo OR 'Laboratorio' LIKE Tipo OR 'Sala riunioni' LIKE Tipo) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Impossibile aggiungere l''utente, al tecnico ammministrativo e'' possibile assegnargli solo gli uffici';
END IF;

END
$$
DELIMITER ;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `corso`
--
ALTER TABLE `corso`
  ADD PRIMARY KEY (`Codice`);

--
-- Indici per le tabelle `docente`
--
ALTER TABLE `docente`
  ADD PRIMARY KEY (`Matricola`),
  ADD KEY `docente_ibfk_1` (`IdStanza`);

--
-- Indici per le tabelle `edificio`
--
ALTER TABLE `edificio`
  ADD PRIMARY KEY (`Nome`);

--
-- Indici per le tabelle `insegnamento`
--
ALTER TABLE `insegnamento`
  ADD PRIMARY KEY (`DataInizio`,`DataFine`,`IdCorso`,`IdDocente`),
  ADD KEY `IdCorso` (`IdCorso`),
  ADD KEY `IdDocente` (`IdDocente`);

--
-- Indici per le tabelle `prenotazione`
--
ALTER TABLE `prenotazione`
  ADD PRIMARY KEY (`IdStanza`,`DataInizio`,`DataFine`),
  ADD KEY `IdCorso` (`IdCorso`);

--
-- Indici per le tabelle `stanza`
--
ALTER TABLE `stanza`
  ADD PRIMARY KEY (`Nome`),
  ADD KEY `IdEdificio` (`IdEdificio`);

--
-- Indici per le tabelle `supporto`
--
ALTER TABLE `supporto`
  ADD PRIMARY KEY (`IdDocenteSupporto`,`IdCorso`,`DataInizio`,`DataFine`,`IdDocente`),
  ADD KEY `DataInizio` (`DataInizio`),
  ADD KEY `IdCorso` (`IdCorso`),
  ADD KEY `IdDocente` (`IdDocente`);

--
-- Indici per le tabelle `tecnico_amministrativo`
--
ALTER TABLE `tecnico_amministrativo`
  ADD PRIMARY KEY (`Matricola`),
  ADD KEY `IdStanza` (`IdStanza`);

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `docente`
--
ALTER TABLE `docente`
  ADD CONSTRAINT `docente_ibfk_1` FOREIGN KEY (`IdStanza`) REFERENCES `stanza` (`Nome`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limiti per la tabella `insegnamento`
--
ALTER TABLE `insegnamento`
  ADD CONSTRAINT `insegnamento_ibfk_1` FOREIGN KEY (`IdCorso`) REFERENCES `corso` (`Codice`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `insegnamento_ibfk_2` FOREIGN KEY (`IdDocente`) REFERENCES `docente` (`Matricola`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `prenotazione`
--
ALTER TABLE `prenotazione`
  ADD CONSTRAINT `prenotazione_ibfk_1` FOREIGN KEY (`IdStanza`) REFERENCES `stanza` (`Nome`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `prenotazione_ibfk_2` FOREIGN KEY (`IdCorso`) REFERENCES `corso` (`Codice`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `stanza`
--
ALTER TABLE `stanza`
  ADD CONSTRAINT `stanza_ibfk_1` FOREIGN KEY (`IdEdificio`) REFERENCES `edificio` (`Nome`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `supporto`
--
ALTER TABLE `supporto`
  ADD CONSTRAINT `supporto_ibfk_1` FOREIGN KEY (`IdDocenteSupporto`) REFERENCES `docente` (`Matricola`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `supporto_ibfk_2` FOREIGN KEY (`DataInizio`) REFERENCES `insegnamento` (`DataInizio`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `supporto_ibfk_3` FOREIGN KEY (`IdCorso`) REFERENCES `insegnamento` (`IdCorso`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `supporto_ibfk_4` FOREIGN KEY (`IdDocente`) REFERENCES `insegnamento` (`IdDocente`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `tecnico_amministrativo`
--
ALTER TABLE `tecnico_amministrativo`
  ADD CONSTRAINT `tecnico_amministrativo_ibfk_1` FOREIGN KEY (`IdStanza`) REFERENCES `stanza` (`Nome`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
