--Represents fighters
CREATE TABLE "fighters"(
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "nickname" TEXT,
    "last_name" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

--Represents fighters
CREATE TABLE "referees"(
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

--Represents weightclasses
CREATE TABLE "weightclasses"(
    "id" INTEGER,
    "weightclass" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

--Represents fighter weight classes
CREATE TABLE "fighter_weight_classes"(
    "fighter_id" INTEGER,
    "weightclass_id" INTEGER,
    PRIMARY KEY ("fighter_id", "weightclass_id"),
    FOREIGN KEY ("fighter_id") REFERENCES "fighters"("id") ON DELETE CASCADE,
    FOREIGN KEY ("weightclass_id") REFERENCES "weightclasses"("id") ON DELETE CASCADE
);


--Represents victory methods: tko/ko, submission, decision, disqualification
CREATE TABLE "victory_methods" (
    "id" INTEGER,
    "victory_method" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

--Represents stadiums
CREATE TABLE "stadiums" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

--Represents fights
CREATE TABLE "fights"(
    "id" INTEGER,
    "date" DATE NOT NULL,
    "stadium_id" INTEGER NOT NULL,
    "weightclass_id" INTEGER NOT NULL,
    "fighter_id1" INTEGER NOT NULL,
    "fighter_id2" INTEGER NOT NULL,
    "referee_id" INTEGER NOT NULL,
    "winner_id" INTEGER,
    "victory_method_id" INTEGER,
    "notes" TEXT,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("stadium_id") REFERENCES "stadiums"("id") ON DELETE CASCADE,
    FOREIGN KEY ("weightclass_id") REFERENCES "weightclasses"("id") ON DELETE CASCADE,
    FOREIGN KEY ("fighter_id1") REFERENCES "fighters"("id") ON DELETE CASCADE,
    FOREIGN KEY ("fighter_id2") REFERENCES "fighters"("id") ON DELETE CASCADE,
    FOREIGN KEY ("referee_id") REFERENCES "referees"("id") ON DELETE CASCADE,
    FOREIGN KEY ("winner_id") REFERENCES "fighters"("id") ON DELETE CASCADE,
    FOREIGN KEY ("victory_method_id") REFERENCES "victory_methods"("id") ON DELETE CASCADE
);


--Represents records
CREATE TABLE "records"(
    "fighter_id" INTEGER,
    "wins" INTEGER DEFAULT 0,
    "losses" INTEGER DEFAULT 0,
    "draws" INTEGER DEFAULT 0,
    "no_contests" INTEGER DEFAULT 0,
    PRIMARY KEY ("fighter_id"),
    FOREIGN KEY ("fighter_id") REFERENCES "fighters"("id")
);

--View of fights table
CREATE VIEW "fights_view" AS
SELECT
    "fights"."id",
    "fights"."date",
    "stadiums"."name" AS "stadium_name",
    "weightclasses"."weightclass",
    f1."first_name" || ' ' || f1."last_name" AS "fighter1",
    f2."first_name" || ' ' || f2."last_name" AS "fighter2",
    "referees"."first_name" || ' ' || "referees"."last_name" AS "referee",
    fw."first_name" || ' ' || fw."last_name" AS "winner",
    "victory_methods"."victory_method"

FROM
    "fights"
JOIN "stadiums" ON "fights"."stadium_id" = "stadiums"."id"
JOIN "weightclasses" ON "fights"."weightclass_id" = "weightclasses"."id"
JOIN "fighters" f1 ON  "fights"."fighter_id1" = f1."id"
JOIN "fighters" f2 ON "fights"."fighter_id2" = f2."id"
JOIN "referees" ON  "fights"."referee_id" = "referees"."id"
LEFT JOIN "fighters" fw ON "fights"."winner_id" = fw."id"
JOIN "victory_methods" ON "fights"."victory_method_id" = "victory_methods"."id";


--Triiger to initialize record for fighter1
CREATE TRIGGER "initialize_record_for_fighter1"
BEFORE INSERT ON "fights"
BEGIN
    INSERT OR IGNORE INTO "records"("fighter_id")
    VALUES (NEW.fighter_id1);
END;

--Triiger to initialize record for fighter2
CREATE TRIGGER "initialize_record_for_fighter2"
BEFORE INSERT ON "fights"
BEGIN
    INSERT OR IGNORE INTO "records"("fighter_id")
    VALUES (NEW.fighter_id2);
END;

--Triiger to insert win for fighter1
CREATE TRIGGER "insert_win_for_fighter1"
AFTER INSERT ON "fights"
WHEN NEW.winner_id = NEW.fighter_id1
BEGIN
    UPDATE records
    SET wins = wins + 1
    WHERE fighter_id = NEW.fighter_id1;
END;

--Triiger to insert win for fighter2
CREATE TRIGGER "insert_win_for_fighter2"
AFTER INSERT ON "fights"
WHEN NEW.winner_id = NEW.fighter_id2
BEGIN
    UPDATE records
    SET wins = wins + 1
    WHERE fighter_id = NEW.fighter_id2;
END;

--Trigger to insert loss for fighter1
CREATE TRIGGER "insert_loss_for_fighter1"
AFTER INSERT ON "fights"
WHEN NEW.winner_id = NEW.fighter_id2
BEGIN
    UPDATE records
    SET losses = losses + 1
    WHERE fighter_id = NEW.fighter_id1;
END;

--Trigger to insert loss for fighter2
CREATE TRIGGER "insert_loss_for_fighter2"
AFTER INSERT ON "fights"
WHEN NEW.winner_id = NEW.fighter_id1
BEGIN
    UPDATE records
    SET losses = losses + 1
    WHERE fighter_id = NEW.fighter_id2;
END;

--Various indexes created based on potential queries
CREATE INDEX "fighters_name_search" ON "fighters" ("first_name", "last_name");
CREATE INDEX "fighters_nickname_search" ON "fighters" ("nickname");
CREATE INDEX "referees_name_search" ON "referees" ("first_name", "last_name");
CREATE INDEX "fights_winner_id" ON "fights" ("winner_id");
CREATE INDEX "fights_fighter_id1" ON "fights" ("fighter_id1");
CREATE INDEX "fights_fighter_id2" ON "fights" ("fighter_id2");
CREATE INDEX "fights_referee_id" ON "fights" ("referee_id");
CREATE INDEX "victory_method_id" ON "fights" ("victory_method_id");
CREATE INDEX "records_wins" ON "records" ("wins");
CREATE INDEX "records_losses" ON "records" ("losses");
