CREATE DATABASE IF NOT EXISTS artconnect
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE artconnect;



CREATE TABLE CommunityMember (
  id_member      INT            AUTO_INCREMENT PRIMARY KEY,
  name           VARCHAR(100)   NOT NULL,
  email          VARCHAR(150)   NOT NULL UNIQUE,
  city           VARCHAR(100),
  membershipType VARCHAR(50)    NOT NULL DEFAULT 'standard'
);

CREATE TABLE Artist (
  id_artist  INT          AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(100) NOT NULL,
  bio        TEXT,
  email      VARCHAR(150) UNIQUE,
  city       VARCHAR(100),
  birthYear  INT,
  isActive   BOOLEAN      NOT NULL DEFAULT TRUE
);

CREATE TABLE Discipline (
  id_discipline INT          AUTO_INCREMENT PRIMARY KEY,
  name          VARCHAR(100) NOT NULL UNIQUE
);

-- Relation M:N  Artist <-> Discipline
CREATE TABLE Artist_Discipline (
  id_artist     INT NOT NULL,
  id_discipline INT NOT NULL,
  PRIMARY KEY (id_artist, id_discipline),
  CONSTRAINT fk_ad_artist     FOREIGN KEY (id_artist)
    REFERENCES Artist(id_artist)     ON DELETE CASCADE,
  CONSTRAINT fk_ad_discipline FOREIGN KEY (id_discipline)
    REFERENCES Discipline(id_discipline) ON DELETE CASCADE
);

CREATE TABLE Gallery (
  id_gallery INT            AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(150)   NOT NULL,
  address    VARCHAR(255)   NOT NULL,
  rating     DECIMAL(3,1)   CHECK (rating BETWEEN 0 AND 5)
);

CREATE TABLE Exhibition (
  id_exhibition INT          AUTO_INCREMENT PRIMARY KEY,
  title         VARCHAR(200) NOT NULL,
  startDate     DATE         NOT NULL,
  endDate       DATE,
  theme         VARCHAR(100),
  curatorName   VARCHAR(100),
  id_gallery    INT          NOT NULL,
  CONSTRAINT fk_exh_gallery FOREIGN KEY (id_gallery)
    REFERENCES Gallery(id_gallery) ON DELETE RESTRICT
);

CREATE TABLE Artwork (
  id_artwork INT            AUTO_INCREMENT PRIMARY KEY,
  title      VARCHAR(200)   NOT NULL,
  type       VARCHAR(50),
  medium     VARCHAR(100),
  price      DECIMAL(15,2)  CHECK (price >= 0),
  status     ENUM('FOR_SALE','SOLD','EXHIBITED') NOT NULL DEFAULT 'FOR_SALE',
  id_artist  INT            NOT NULL,
  CONSTRAINT fk_art_artist FOREIGN KEY (id_artist)
    REFERENCES Artist(id_artist) ON DELETE RESTRICT
);

CREATE TABLE ArtworkTag (
  id_tag INT          AUTO_INCREMENT PRIMARY KEY,
  name   VARCHAR(50)  NOT NULL UNIQUE
);

-- Relation M:N  Artwork <-> ArtworkTag
CREATE TABLE Artwork_Tag (
  id_artwork INT NOT NULL,
  id_tag     INT NOT NULL,
  PRIMARY KEY (id_artwork, id_tag),
  CONSTRAINT fk_at_artwork FOREIGN KEY (id_artwork)
    REFERENCES Artwork(id_artwork)   ON DELETE CASCADE,
  CONSTRAINT fk_at_tag    FOREIGN KEY (id_tag)
    REFERENCES ArtworkTag(id_tag)    ON DELETE CASCADE
);

-- Relation M:N  Artwork <-> Exhibition
CREATE TABLE Artwork_Exhibition (
  id_artwork    INT NOT NULL,
  id_exhibition INT NOT NULL,
  PRIMARY KEY (id_artwork, id_exhibition),
  CONSTRAINT fk_ae_artwork    FOREIGN KEY (id_artwork)
    REFERENCES Artwork(id_artwork)       ON DELETE CASCADE,
  CONSTRAINT fk_ae_exhibition FOREIGN KEY (id_exhibition)
    REFERENCES Exhibition(id_exhibition) ON DELETE CASCADE
);

CREATE TABLE Workshop (
  id_workshop     INT            AUTO_INCREMENT PRIMARY KEY,
  title           VARCHAR(200)   NOT NULL,
  date            DATETIME       NOT NULL,
  maxParticipants INT            CHECK (maxParticipants > 0),
  price           DECIMAL(8,2)   CHECK (price >= 0),
  level           VARCHAR(50),   -- 'Beginner' | 'Intermediate' | 'Advanced'
  id_artist       INT            NOT NULL,  -- instructeur
  CONSTRAINT fk_ws_artist FOREIGN KEY (id_artist)
    REFERENCES Artist(id_artist) ON DELETE RESTRICT
);

CREATE TABLE Booking (
  id_booking    INT          AUTO_INCREMENT PRIMARY KEY,
  bookingDate   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  paymentStatus VARCHAR(50)  NOT NULL DEFAULT 'PENDING',
  id_member     INT          NOT NULL,
  id_workshop   INT          NOT NULL,
  CONSTRAINT fk_bk_member   FOREIGN KEY (id_member)
    REFERENCES CommunityMember(id_member)  ON DELETE CASCADE,
  CONSTRAINT fk_bk_workshop FOREIGN KEY (id_workshop)
    REFERENCES Workshop(id_workshop)       ON DELETE CASCADE,
  UNIQUE (id_member, id_workshop)          -- un membre réserve une fois par atelier
);

CREATE TABLE Review (
  id_review   INT     AUTO_INCREMENT PRIMARY KEY,
  rating      INT     NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment     TEXT,
  reviewDate  DATE    NOT NULL DEFAULT (CURRENT_DATE),
  id_member   INT     NOT NULL,
  id_artwork  INT     NOT NULL,
  CONSTRAINT fk_rv_member  FOREIGN KEY (id_member)
    REFERENCES CommunityMember(id_member) ON DELETE CASCADE,
  CONSTRAINT fk_rv_artwork FOREIGN KEY (id_artwork)
    REFERENCES Artwork(id_artwork)        ON DELETE CASCADE,
  UNIQUE (id_member, id_artwork)           -- un avis par œuvre et par membre
);
