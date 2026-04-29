USE artconnect;

DROP USER IF EXISTS 'visiteur_ac'@'localhost';
DROP USER IF EXISTS 'membre_ac'@'localhost';
DROP USER IF EXISTS 'artiste_ac'@'localhost';
DROP USER IF EXISTS 'organisateur_ac'@'localhost';

CREATE USER 'visiteur_ac'@'localhost'
  IDENTIFIED BY 'Visiteur@ArtConnect2025!';

GRANT SELECT ON artconnect.v_catalogue_public       TO 'visiteur_ac'@'localhost';
GRANT SELECT ON artconnect.v_programme_expositions  TO 'visiteur_ac'@'localhost';
GRANT SELECT ON artconnect.v_ateliers_disponibilite TO 'visiteur_ac'@'localhost';
GRANT SELECT ON artconnect.v_profil_artiste         TO 'visiteur_ac'@'localhost';



CREATE USER 'membre_ac'@'localhost'
  IDENTIFIED BY 'Membre@ArtConnect2025!';


GRANT SELECT ON artconnect.v_catalogue_public       TO 'membre_ac'@'localhost';
GRANT SELECT ON artconnect.v_programme_expositions  TO 'membre_ac'@'localhost';
GRANT SELECT ON artconnect.v_ateliers_disponibilite TO 'membre_ac'@'localhost';
GRANT SELECT ON artconnect.v_profil_artiste         TO 'membre_ac'@'localhost';

GRANT SELECT ON artconnect.Discipline  TO 'membre_ac'@'localhost';
GRANT SELECT ON artconnect.ArtworkTag  TO 'membre_ac'@'localhost';
GRANT SELECT ON artconnect.Gallery     TO 'membre_ac'@'localhost';

GRANT SELECT, INSERT, UPDATE ON artconnect.CommunityMember TO 'membre_ac'@'localhost';
GRANT SELECT, INSERT, UPDATE ON artconnect.Booking TO 'membre_ac'@'localhost';
GRANT SELECT, INSERT, UPDATE ON artconnect.Review  TO 'membre_ac'@'localhost';


CREATE USER 'artiste_ac'@'localhost'
  IDENTIFIED BY 'Artiste@ArtConnect2025!';

GRANT SELECT ON artconnect.v_catalogue_public       TO 'artiste_ac'@'localhost';
GRANT SELECT ON artconnect.v_programme_expositions  TO 'artiste_ac'@'localhost';
GRANT SELECT ON artconnect.v_ateliers_disponibilite TO 'artiste_ac'@'localhost';
GRANT SELECT ON artconnect.v_profil_artiste         TO 'artiste_ac'@'localhost';

GRANT SELECT ON artconnect.Discipline  TO 'artiste_ac'@'localhost';
GRANT SELECT ON artconnect.ArtworkTag  TO 'artiste_ac'@'localhost';
GRANT SELECT ON artconnect.Gallery     TO 'artiste_ac'@'localhost';

GRANT SELECT, INSERT, UPDATE ON artconnect.CommunityMember TO 'artiste_ac'@'localhost';
GRANT SELECT, INSERT, UPDATE ON artconnect.Booking         TO 'artiste_ac'@'localhost';
GRANT SELECT, INSERT, UPDATE ON artconnect.Review          TO 'artiste_ac'@'localhost';

GRANT SELECT, UPDATE ON artconnect.Artist             TO 'artiste_ac'@'localhost';
GRANT SELECT         ON artconnect.Artist_Discipline  TO 'artiste_ac'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON artconnect.Artwork           TO 'artiste_ac'@'localhost';
GRANT SELECT, INSERT, DELETE         ON artconnect.Artwork_Tag       TO 'artiste_ac'@'localhost';
GRANT SELECT, INSERT, DELETE         ON artconnect.Artwork_Exhibition TO 'artiste_ac'@'localhost';
GRANT SELECT, INSERT                 ON artconnect.ArtworkTag        TO 'artiste_ac'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON artconnect.Workshop TO 'artiste_ac'@'localhost';



CREATE USER 'organisateur_ac'@'localhost'
  IDENTIFIED BY 'Organisateur@ArtConnect2025!';

GRANT SELECT ON artconnect.v_catalogue_public       TO 'organisateur_ac'@'localhost';
GRANT SELECT ON artconnect.v_programme_expositions  TO 'organisateur_ac'@'localhost';
GRANT SELECT ON artconnect.v_ateliers_disponibilite TO 'organisateur_ac'@'localhost';
GRANT SELECT ON artconnect.v_profil_artiste         TO 'organisateur_ac'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON artconnect.Gallery    TO 'organisateur_ac'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON artconnect.Exhibition          TO 'organisateur_ac'@'localhost';
GRANT SELECT, INSERT, DELETE         ON artconnect.Artwork_Exhibition  TO 'organisateur_ac'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON artconnect.Artist            TO 'organisateur_ac'@'localhost';
GRANT SELECT, INSERT, DELETE         ON artconnect.Artist_Discipline TO 'organisateur_ac'@'localhost';
GRANT SELECT, INSERT                 ON artconnect.Discipline        TO 'organisateur_ac'@'localhost';

GRANT SELECT ON artconnect.Artwork     TO 'organisateur_ac'@'localhost';
GRANT SELECT ON artconnect.ArtworkTag  TO 'organisateur_ac'@'localhost';
GRANT SELECT ON artconnect.Artwork_Tag TO 'organisateur_ac'@'localhost';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'visiteur_ac'@'localhost';
SHOW GRANTS FOR 'membre_ac'@'localhost';
SHOW GRANTS FOR 'artiste_ac'@'localhost';
SHOW GRANTS FOR 'organisateur_ac'@'localhost';