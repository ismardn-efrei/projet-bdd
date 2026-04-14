USE artconnect;


DELIMITER $$

-- PROCÉDURE 1 : Inscrire un membre à un atelier
--   Vérifie l'existence, les doublons, la capacité, puis crée la réservation.
CREATE PROCEDURE sp_inscrire_membre(
  IN p_id_member   INT,
  IN p_id_workshop INT,
  IN p_payment     VARCHAR(50)
)
BEGIN
  DECLARE v_exists_member   INT;
  DECLARE v_exists_workshop INT;
  DECLARE v_already         INT;
  DECLARE v_count           INT;
  DECLARE v_max             INT;

  SELECT COUNT(*) INTO v_exists_member   FROM CommunityMember WHERE id_member   = p_id_member;
  SELECT COUNT(*) INTO v_exists_workshop FROM Workshop         WHERE id_workshop = p_id_workshop;
  SELECT COUNT(*) INTO v_already         FROM Booking
    WHERE id_member = p_id_member AND id_workshop = p_id_workshop;

  IF v_exists_member = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Membre introuvable.';
  ELSEIF v_exists_workshop = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Atelier introuvable.';
  ELSEIF v_already > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ce membre est déjà inscrit à cet atelier.';
  END IF;

  SELECT COUNT(*), maxParticipants
    INTO v_count, v_max
    FROM Booking b
    JOIN Workshop w ON b.id_workshop = w.id_workshop
    WHERE b.id_workshop = p_id_workshop AND b.paymentStatus != 'CANCELLED'
    GROUP BY w.maxParticipants;

  IF v_count >= v_max THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Atelier complet.';
  END IF;

  INSERT INTO Booking (bookingDate, paymentStatus, id_member, id_workshop)
  VALUES (NOW(), p_payment, p_id_member, p_id_workshop);

  SELECT 'Inscription réussie.' AS message;
END$$


-- PROCÉDURE 2 : Créer une exposition et y associer automatiquement
--               les œuvres EXHIBITED de la galerie cible
CREATE PROCEDURE sp_creer_exposition(
  IN p_title       VARCHAR(200),
  IN p_startDate   DATE,
  IN p_endDate     DATE,
  IN p_theme       VARCHAR(100),
  IN p_curator     VARCHAR(100),
  IN p_id_gallery  INT
)
BEGIN
  DECLARE v_new_id INT;

  INSERT INTO Exhibition (title, startDate, endDate, theme, curatorName, id_gallery)
  VALUES (p_title, p_startDate, p_endDate, p_theme, p_curator, p_id_gallery);

  SET v_new_id = LAST_INSERT_ID();
  SELECT CONCAT('Exposition créée avec id = ', v_new_id) AS message;
END$$


-- PROCÉDURE 3 : Annuler une réservation
CREATE PROCEDURE sp_annuler_reservation(
  IN p_id_booking INT
)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM Booking WHERE id_booking = p_id_booking) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Réservation introuvable.';
  END IF;

  UPDATE Booking
  SET paymentStatus = 'CANCELLED'
  WHERE id_booking = p_id_booking;

  SELECT 'Réservation annulée.' AS message;
END$$


-- FONCTION 1 : Retourner le nombre de participants confirmés à un atelier
CREATE FUNCTION fn_nb_participants(p_id_workshop INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_count INT;
  SELECT COUNT(*) INTO v_count
  FROM Booking
  WHERE id_workshop = p_id_workshop
    AND paymentStatus != 'CANCELLED';
  RETURN v_count;
END$$


-- FONCTION 2 : Calculer la note moyenne d'un artiste (via ses œuvres)
CREATE FUNCTION fn_note_artiste(p_id_artist INT)
RETURNS DECIMAL(3,1)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_avg DECIMAL(3,1);
  SELECT ROUND(AVG(r.rating), 1) INTO v_avg
  FROM Review r
  JOIN Artwork a ON r.id_artwork = a.id_artwork
  WHERE a.id_artist = p_id_artist;
  RETURN COALESCE(v_avg, 0);
END$$


-- FONCTION 3 : Vérifier si un membre peut encore s'inscrire à un atelier
CREATE FUNCTION fn_peut_sinscrire(p_id_member INT, p_id_workshop INT)
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_already  INT;
  DECLARE v_count    INT;
  DECLARE v_max      INT;

  SELECT COUNT(*) INTO v_already
  FROM Booking
  WHERE id_member = p_id_member AND id_workshop = p_id_workshop;

  SELECT COUNT(b.id_booking), w.maxParticipants
    INTO v_count, v_max
  FROM Booking b
  JOIN Workshop w ON b.id_workshop = w.id_workshop
  WHERE b.id_workshop = p_id_workshop
    AND b.paymentStatus != 'CANCELLED'
  GROUP BY w.maxParticipants;

  IF v_already > 0 OR COALESCE(v_count, 0) >= COALESCE(v_max, 0) THEN
    RETURN FALSE;
  END IF;
  RETURN TRUE;
END$$

DELIMITER ;
