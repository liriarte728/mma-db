-- Find all records given fighter first and last name
SELECT * FROM "records"
WHERE "fighter_id" = (
    SELECT "id"
    FROM "fighters"
    WHERE "first_name" = LOWER(TRIM('Alexander')) AND "last_name" = LOWER(TRIM('Volkanovski'))
);

-- Find all fights a fighter has won given fighter first and last name
SELECT * FROM "fights"
WHERE "winner_id" IN(
    SELECT "id"
    FROM "fighters"
    WHERE "first_name" = LOWER(TRIM('Alexander')) AND "last_name" = LOWER(TRIM('Volkanovski'))
);


-- Find all fights a referee has officiated given referee first and last name
SELECT * FROM "fights"
WHERE "referee_id" IN(
    SELECT "id"
    FROM "referees"
    WHERE "first_name" = LOWER(TRIM('Marc'))AND "last_name" = LOWER(TRIM('Goddard'))
);

-- Find all fights a figther has fought given fighter first and last name and given victory method.
SELECT * FROM "fights"
WHERE "fighter_id1" = (
    SELECT "id"
    FROM "fighters"
    WHERE "first_name" = LOWER(TRIM('Alexander')) AND "last_name" = LOWER(TRIM('Volkanovski'))
)

AND "victory_method_id" = (
    SELECT "id"
    FROM "victory_methods"
    WHERE "victory_method" = LOWER(TRIM('decision'))
);


--Find all fights a fighter has won given fighter first and last name and given referee first and last name.
SELECT * FROM "fights"
WHERE "winner_id" IN(
    SELECT "id"
    FROM "fighters"
    WHERE "first_name" = LOWER(TRIM('Alexander')) AND "last_name" = LOWER(TRIM('Volkanovski'))
)

AND "referee_id" IN(
    SELECT "id"
    FROM "referees"
    WHERE "first_name" = LOWER(TRIM('Marc'))AND "last_name" = LOWER(TRIM('Goddard'))
);

--View of fights table
SELECT * FROM "fights_view";

--Add a new fighter
INSERT INTO "fighters"("first_name", "nickname", "last_name")
VALUES(LOWER(TRIM('Nathaniel')), LOWER(TRIM('The Prospect')), LOWER(TRIM('Wood')));

--Add a new referee
INSERT INTO "referees"("first_name", "last_name")
VALUES(LOWER(TRIM('Dan')), LOWER(TRIM('Miragliotta')));

--Add a new stadium
INSERT INTO "stadiums"("name", "location")
VALUES(LOWER(TRIM('Footprint Center')), LOWER(TRIM('Phoenix, Arizona')));

--Populate fights table given set values
INSERT INTO "fights"("date", "stadium_id", "weightclass_id", "fighter_id1", "fighter_id2", "referee_id", "winner_id", "victory_method_id")
VALUES
--date
('2022-07-02',

--stadium
(SELECT "id" FROM "stadiums" WHERE "name" = LOWER(TRIM('T-Mobile Arena'))),

--weightclass
(SELECT "id" FROM "weightclasses" WHERE "weightclass" = LOWER(TRIM('featherweight'))),

--fighter1
(SELECT "id" FROM "fighters" WHERE "first_name" = LOWER(TRIM('Alexander')) AND "last_name" = LOWER(TRIM('Volkanovski'))),

--fighter2
(SELECT "id" FROM "fighters" WHERE "first_name" = LOWER(TRIM('Max'))AND "last_name" = LOWER(TRIM('Holloway'))),

--referee
(SELECT "id" FROM "referees" WHERE "first_name" = LOWER(TRIM('Herb'))AND "last_name" = LOWER(TRIM('Dean'))),

--winning fighter
(SELECT "id" FROM "fighters" WHERE "first_name" = LOWER(TRIM('Alexander')) AND "last_name" = LOWER(TRIM('Volkanovski'))),

--victory method: tko/ko, submission, decision, disqualification
(SELECT "id" FROM "victory_methods" WHERE "victory_method" = LOWER(TRIM('decision')))

);

-- Find all values given said tables
SELECT * FROM "fighters";
SELECT * FROM "referees";
SELECT * FROM "records";
SELECT * FROM "stadiums";
SELECT * FROM "fights";
SELECT * FROM "fights_view";
