
-- -------------------------------------------------------- 
--
-- Mostra per ogni docente il corso di insegnamento
-- OUTPUT: Nome | Cognome | AreaRicerca | Categoria | Fascia | Ufficio | Corso
--

SELECT docente.Nome, docente.Cognome, docente.AreaRicerca, docente.Categoria, docente.Fascia, docente.IdStanza AS Ufficio, corso.Nome AS Corso
FROM (docente LEFT JOIN insegnamento ON docente.Matricola=insegnamento.IdDocente) LEFT JOIN corso ON insegnamento.IdCorso=corso.Codice;



-- -------------------------------------------------------- 
--
-- Mostra tutte le aule prenotate da ciascun corso in ordine di corso
-- OUTPUT: Corso | Aula | Data inizo | Data fine
--


SELECT corso.Nome AS Corso, prenotazione.IdStanza AS Aula, prenotazione.DataInizio AS Data inzio, prenotazione.DataFine AS Data fine
FROM prenotazione LEFT JOIN corso ON prenotazione.IdCorso = corso.Codice
ORDER BY Corso

-- -------------------------------------------------------- 
--
-- Mostra tutte le aule prenotate in un certo lasso ti tempo
-- OUTPUT: Stanza | Corso | Data inizo | Data fine
--
SELECT IdStanza AS Stanza, corso.Nome AS Corso, DataInizio AS Data inizio, DataFine AS Data fine
FROM prenotazione LEFT JOIN corso ON prenotazione.IdCorso = corso.Codice
WHERE DataInizio >= '2017-07-20 00:00:00' AND DataFine <= '2017-07-22 00:00:00'