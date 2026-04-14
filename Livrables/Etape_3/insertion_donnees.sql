USE artconnect;

-- Artistes
INSERT INTO Artist (name, bio, email, city, birthYear, isActive) VALUES
('Leonardo da Vinci',  'Génie universel de la Renaissance',      'leo@vincistudio.it',   'Florence',      1452, TRUE),
('Claude Monet',       'Père de l\'impressionnisme français',      'claude@monet.fr',      'Giverny',       1840, TRUE),
('Frida Kahlo',        'Icône du surréalisme mexicain',           'frida@kahlo.mx',       'Mexico City',   1907, TRUE),
('Auguste Rodin',      'Maître de la sculpture moderne',          'auguste@rodin.fr',     'Paris',         1840, TRUE),
('Ansel Adams',        'Photographe américain de la nature',      'ansel@adams.co',       'San Francisco', 1902, TRUE),
('Yayoi Kusama',       'Art répétitif et installations',          'yayoi@kusama.jp',      'Tokyo',         1929, TRUE),
('Basquiat',           'Néo-expressionnisme urbain new-yorkais',  'jean@basquiat.com',    'New York',      1960, TRUE),
('Georgia O''Keeffe',  'Pionnière du modernisme américain',       'georgia@okeeffe.com',  'New Mexico',    1887, TRUE);

-- Disciplines
INSERT INTO Discipline (name) VALUES
('Peinture'), ('Sculpture'), ('Photographie'),
('Art numérique'), ('Installation'), ('Dessin');

-- Artistes <-> Disciplines
INSERT INTO Artist_Discipline (id_artist, id_discipline) VALUES
(1,1),(1,6),(2,1),(3,1),(4,2),(5,3),(6,5),(6,1),(7,1),(7,6),(8,1);

-- Galeries
INSERT INTO Gallery (name, address, rating) VALUES
('Louvre Art House',      'Rue de Rivoli, Paris',           4.9),
('The British Gallery',   'Great Russell St, London',       4.7),
('Metropolitan Hub',      '1000 5th Ave, New York',         4.8),
('Reina Sofía',           'Calle Santa Isabel, Madrid',     4.6),
('Mori Art Museum',       '6-10-1 Roppongi, Tokyo',         4.5);

-- Expositions
INSERT INTO Exhibition (title, startDate, endDate, theme, curatorName, id_gallery) VALUES
('Renaissance Revival',      '2026-03-06','2026-06-06','Classic Renaissance',          'Jean Dupont',     1),
('Sculpting the Soul',       '2026-03-22','2026-07-22','Modern & Classical Sculpture', 'Marie Martin',    2),
('Impressionist Dreams',     '2026-02-06','2026-05-06','Light and Color',              'Paul Bernard',    3),
('Visions de Tokyo',         '2026-04-01','2026-08-01','Art Contemporain Japonais',    'Hana Mori',       5),
('Street & Canvas',          '2026-05-10','2026-09-10','Néo-expressionnisme',          'Carlos Reyes',    4),
('Colors of the Desert',     '2026-06-01','2026-10-01','Modernisme Américain',         'Laura Smith',     3);

-- Œuvres
INSERT INTO Artwork (title, type, medium, price, status, id_artist) VALUES
('Mona Lisa',                     'Painting',    'Huile sur bois',    850000000, 'EXHIBITED', 1),
('The Last Supper',               'Painting',    'Tempera',           450000000, 'FOR_SALE',  1),
('Water Lilies',                  'Painting',    'Huile sur toile',    40000000, 'EXHIBITED', 2),
('The Two Fridas',                'Painting',    'Huile sur toile',     5000000, 'FOR_SALE',  3),
('The Thinker',                   'Sculpture',   'Bronze',            150000000, 'EXHIBITED', 4),
('Monolith, Face of Half Dome',   'Photography', 'Tirage argentique',    100000, 'FOR_SALE',  5),
('Infinity Mirror Room',          'Installation','Miroirs / LEDs',      3500000, 'EXHIBITED', 6),
('Untitled (skull)',              'Painting',    'Acrylique',           900000, 'SOLD',       7),
('Black Iris',                    'Painting',    'Huile sur toile',    450000,  'FOR_SALE',   8),
('Pumpkins',                      'Sculpture',   'Fibre de verre',     700000,  'FOR_SALE',   6);

-- Tags
INSERT INTO ArtworkTag (name) VALUES
('Renaissance'),('Impressionnisme'),('Surréalisme'),('Sculpture'),
('Photographie'),('Installation'),('Urbain'),('Nature'),('Portrait'),('Abstrait');

-- Œuvres <-> Tags
INSERT INTO Artwork_Tag (id_artwork, id_tag) VALUES
(1,1),(1,9),(2,1),(3,2),(3,8),(4,3),(4,9),(5,4),(6,5),(6,8),
(7,6),(7,10),(8,7),(8,10),(9,8),(9,10),(10,4),(10,6);

-- Œuvres <-> Expositions
INSERT INTO Artwork_Exhibition (id_artwork, id_exhibition) VALUES
(1,1),(2,1),(3,3),(5,2),(7,4),(8,5),(9,6),(10,4);

-- Membres
INSERT INTO CommunityMember (name, email, city, membershipType) VALUES
('Alice Wonderland', 'alice@art.com',        'Paris',     'premium'),
('Bob Ross',         'bob@happytrees.com',   'London',    'standard'),
('Charlie Brown',    'charlie@peanuts.com',  'New York',  'standard'),
('Diana Prince',     'diana@themyscira.com', 'Madrid',    'premium'),
('Eve Curie',        'eve@curie.fr',         'Paris',     'standard'),
('Frank Castle',     'frank@castle.com',     'Chicago',   'standard'),
('Grace Hopper',     'grace@hopper.io',      'Boston',    'premium'),
('Hiro Protagonist', 'hiro@snow.jp',         'Tokyo',     'standard'),
('Ivy League',       'ivy@league.edu',       'Cambridge', 'premium'),
('Jack Sparrow',     'jack@rum.co',          'London',    'standard');

-- Ateliers
INSERT INTO Workshop (title, date, maxParticipants, price, level, id_artist) VALUES
('Mastering Oil Painting',      '2026-04-11 10:00:00', 15, 150.00, 'Intermediate', 1),
('Impressionist Landscapes',    '2026-04-16 14:00:00', 20, 120.00, 'Beginner',     2),
('Sculpting Modernity',         '2026-04-21 09:00:00', 10, 200.00, 'Advanced',     4),
('Street Art & Expression',     '2026-05-03 11:00:00', 12, 180.00, 'Intermediate', 7),
('Photography in Nature',       '2026-05-10 08:00:00', 8,  250.00, 'Advanced',     5);

-- Réservations (croisées)
INSERT INTO Booking (bookingDate, paymentStatus, id_member, id_workshop) VALUES
('2026-03-01 10:00:00','CONFIRMED', 1, 1),
('2026-03-01 10:05:00','CONFIRMED', 1, 2),
('2026-03-02 09:00:00','CONFIRMED', 2, 2),
('2026-03-02 09:30:00','PENDING',   2, 4),
('2026-03-03 14:00:00','CONFIRMED', 3, 3),
('2026-03-03 14:30:00','CONFIRMED', 3, 5),
('2026-03-04 11:00:00','CONFIRMED', 4, 1),
('2026-03-04 11:30:00','CANCELLED', 4, 4),
('2026-03-05 08:00:00','CONFIRMED', 5, 2),
('2026-03-05 08:30:00','CONFIRMED', 5, 5),
('2026-03-06 16:00:00','PENDING',   6, 3),
('2026-03-07 10:00:00','CONFIRMED', 7, 4),
('2026-03-08 09:00:00','CONFIRMED', 8, 5);

-- Avis
INSERT INTO Review (rating, comment, reviewDate, id_member, id_artwork) VALUES
(5, 'Chef-d''œuvre absolu, bouleversant.',    '2026-03-10', 1, 1),
(4, 'Très belle technique impressionniste.',  '2026-03-11', 2, 3),
(5, 'Frida Kahlo est une génie.',             '2026-03-12', 3, 4),
(3, 'Installation originale mais froide.',    '2026-03-13', 4, 7),
(5, 'Photo sublime, lumière parfaite.',       '2026-03-14', 5, 6),
(4, 'Sculpture très expressive.',             '2026-03-15', 6, 5),
(4, 'Basquiat est toujours surprenant.',      '2026-03-16', 7, 8),
(5, 'O''Keeffe capture l''essence du désert.','2026-03-17', 8, 9),
(4, 'Kusama et ses citrouilles, unique !',    '2026-03-18', 9,10),
(3, 'Moins impressionné que prévu.',          '2026-03-19',10, 2);
