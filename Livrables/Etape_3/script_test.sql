USE artconnect;

-- Test des vues
SELECT * FROM v_catalogue_public;
SELECT * FROM v_programme_expositions;
SELECT * FROM v_ateliers_disponibilite;
SELECT * FROM v_profil_artiste;

-- Test des fonctions
SELECT fn_nb_participants(1)   AS inscrits_atelier_1;
SELECT fn_note_artiste(1)      AS note_da_vinci;
SELECT fn_peut_sinscrire(9, 1) AS membre9_peut_atelier1;

-- Test de la procédure d'inscription simple
CALL sp_inscrire_membre(9, 1, 'CONFIRMED');

-- Test de la transaction multiple (membres 9 et 10 sur 3 ateliers)
CALL sp_inscription_multiple(10, 1, 2, 3);

-- Test : inscription sur atelier complet (doit échouer si maxParticipants atteint)
-- CALL sp_inscrire_membre(10, 5, 'CONFIRMED');

-- Test trigger date invalide (doit échouer)
-- INSERT INTO Exhibition (title, startDate, endDate, theme, curatorName, id_gallery)
-- VALUES ('Test', '2026-06-01', '2026-01-01', 'Erreur', 'Test', 1);

-- Test annulation de réservation
CALL sp_annuler_reservation(1);

-- Vérification de l'audit de prix
UPDATE Artwork SET price = 999999999 WHERE id_artwork = 1;
SELECT * FROM Artwork_Price_Audit;
