USE artconnect;

-- INDEX 1 : Recherche d'artistes par ville (filtre fréquent dans l'UI)
CREATE INDEX idx_artist_city
  ON Artist(city);

-- INDEX 2 : Recherche d'artiste par nom (barre de recherche)
CREATE INDEX idx_artist_name
  ON Artist(name);

-- INDEX 3 : Filtrage des œuvres par statut (FOR_SALE / SOLD / EXHIBITED)
CREATE INDEX idx_artwork_status
  ON Artwork(status);

-- INDEX 4 : Filtrage des œuvres par artiste (jointure fréquente)
CREATE INDEX idx_artwork_artist
  ON Artwork(id_artist);

-- INDEX 5 : Recherche de réservations par membre
CREATE INDEX idx_booking_member
  ON Booking(id_member);

-- INDEX 6 : Expositions par date de début (tri chronologique)
CREATE INDEX idx_exhibition_startdate
  ON Exhibition(startDate);
