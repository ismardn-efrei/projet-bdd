USE artconnect;

-- VUE 1 : Catalogue public des œuvres (masque le prix des œuvres SOLD)
-- Objectif : sécurité / masquage d'attributs sensibles
CREATE OR REPLACE VIEW v_catalogue_public AS
SELECT
  a.id_artwork,
  a.title                                            AS oeuvre,
  ar.name                                            AS artiste,
  a.type,
  a.medium,
  CASE WHEN a.status = 'SOLD' THEN NULL
       ELSE a.price END                              AS prix,
  a.status
FROM Artwork a
JOIN Artist ar ON a.id_artist = ar.id_artist;

-- VUE 2 : Programme des expositions avec galerie
-- Objectif : simplification de requête pour l'interface Exhibitions
CREATE OR REPLACE VIEW v_programme_expositions AS
SELECT
  e.id_exhibition,
  e.title                                            AS exposition,
  e.theme,
  e.startDate,
  e.endDate,
  g.name                                             AS galerie,
  g.address                                          AS adresse,
  g.rating                                           AS note_galerie,
  e.curatorName                                      AS curateur,
  COUNT(ae.id_artwork)                               AS nb_oeuvres
FROM Exhibition e
JOIN Gallery g        ON e.id_gallery    = g.id_gallery
LEFT JOIN Artwork_Exhibition ae ON e.id_exhibition = ae.id_exhibition
GROUP BY e.id_exhibition, e.title, e.theme, e.startDate, e.endDate,
         g.name, g.address, g.rating, e.curatorName;

-- VUE 3 : Tableau de bord des ateliers (places restantes en temps réel)
-- Objectif : requête métier complexe réutilisable
CREATE OR REPLACE VIEW v_ateliers_disponibilite AS
SELECT
  w.id_workshop,
  w.title                                            AS atelier,
  ar.name                                            AS instructeur,
  w.date,
  w.level,
  w.price,
  w.maxParticipants,
  COUNT(b.id_booking)                                AS inscrits,
  (w.maxParticipants - COUNT(b.id_booking))          AS places_restantes
FROM Workshop w
JOIN Artist ar ON w.id_artist = ar.id_artist
LEFT JOIN Booking b ON w.id_workshop = b.id_workshop
  AND b.paymentStatus != 'CANCELLED'
GROUP BY w.id_workshop, w.title, ar.name, w.date,
         w.level, w.price, w.maxParticipants;

-- VUE 4 : Profil artiste enrichi (œuvres, disciplines, note moyenne)
-- Objectif : agrégation pour la page Artists
CREATE OR REPLACE VIEW v_profil_artiste AS
SELECT
  ar.id_artist,
  ar.name,
  ar.city,
  ar.birthYear,
  GROUP_CONCAT(DISTINCT d.name ORDER BY d.name SEPARATOR ', ') AS disciplines,
  COUNT(DISTINCT a.id_artwork)                        AS nb_oeuvres,
  ROUND(AVG(r.rating), 1)                             AS note_moyenne
FROM Artist ar
LEFT JOIN Artist_Discipline ad ON ar.id_artist  = ad.id_artist
LEFT JOIN Discipline d          ON ad.id_discipline = d.id_discipline
LEFT JOIN Artwork a             ON ar.id_artist  = a.id_artist
LEFT JOIN Review r              ON a.id_artwork  = r.id_artwork
GROUP BY ar.id_artist, ar.name, ar.city, ar.birthYear;
