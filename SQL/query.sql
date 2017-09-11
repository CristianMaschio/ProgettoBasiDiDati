
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
-- OUTPUT: Corso | Aula | DataInizo | DataFine
--


SELECT corso.Nome AS Corso, prenotazione.IdStanza AS Aula, prenotazione.DataInizio AS DataInzio, prenotazione.DataFine AS DataFine
FROM prenotazione LEFT JOIN corso ON prenotazione.IdCorso = corso.Codice
ORDER BY Corso

-- -------------------------------------------------------- 
--
-- Mostra tutte le aule prenotate in un certo lasso ti tempo
-- OUTPUT: Stanza | Corso | Data inizo | Data fine
--
SELECT IdStanza AS Stanza, corso.Nome AS Corso, DataInizio AS DataInizio, DataFine AS DataFine
FROM prenotazione LEFT JOIN corso ON prenotazione.IdCorso = corso.Codice
WHERE (DataInizio >= '2017-10-20 00:00:00' AND DataInizio <= '2017-10-20 12:00:00') OR 
        (DataFine >= '2017-10-20 00:00:00' AND DataFine <= '2017-10-20 12:00:00')

-- -------------------------------------------------------- 
--
-- Mostra tutte le aule libere in un certo lasso ti tempo
-- OUTPUT: Stanza
--
SELECT stanza.Nome AS Stanza
FROM stanza
WHERE Nome NOT IN(
    SELECT IdStanza AS Nome
    FROM prenotazione LEFT JOIN corso ON prenotazione.IdCorso = corso.Codice
    WHERE (DataInizio >= '2017-10-20 00:00:00' AND DataInizio <= '2017-10-20 12:00:00') OR 
            (DataFine >= '2017-10-20 00:00:00' AND DataFine <= '2017-10-20 12:00:00'))


-- -------------------------------------------------------- 
--
-- Per ogni insegnamento, mostra, docente, supporto, con ulteriori informazioni su docente e supporto, in ordine di Corso
-- OUTPUT: Corso, DataInizio, DataFine, NomeDocente, CognomeDocente, CategoriaDocente, UfficioDocente, 
-- NomeSupporto, CognomeSupporto, CategoriaSupporto, UfficioSupporto
--   
SELECT corso.Nome AS Corso, insegnamento.DataInizio, insegnamento.DataFine, d.Nome AS NomeDocente, 
        d.Cognome AS CognomeDocente, d.Categoria AS CategoriaDocente, d.IdStanza AS UfficioDocente, 
        docente.Nome AS NomeSupporto, docente.Cognome AS CognomeSupporto, 
        docente.Categoria AS CategoriaSupporto, docente.IdStanza AS UfficioSupporto
FROM ((insegnamento LEFT JOIN supporto ON insegnamento.IdInsegnamento=supporto.IdInsegnamento) 
        LEFT JOIN docente ON supporto.IdDocenteSupporto=docente.Matricola) 
        LEFT JOIN corso ON corso.Codice=insegnamento.IdCorso 
        LEFT JOIN docente AS d ON d.Matricola=insegnamento.IdDocente 
ORDER BY corso.Nome