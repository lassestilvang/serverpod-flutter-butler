BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "focus_session" (
    "id" bigserial PRIMARY KEY,
    "startTime" timestamp without time zone NOT NULL,
    "plannedEndTime" timestamp without time zone NOT NULL,
    "actualEndTime" timestamp without time zone,
    "isActive" boolean NOT NULL,
    "slackStatusOriginal" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "pomodoro" (
    "id" bigserial PRIMARY KEY,
    "taskId" bigint NOT NULL,
    "taskId" bigint NOT NULL,
    "startTime" timestamp without time zone NOT NULL,
    "endTime" timestamp without time zone NOT NULL,
    "durationSeconds" bigint NOT NULL,
    "interruptionCount" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "task" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "description" text,
    "estimatedPomodoros" bigint NOT NULL,
    "isCompleted" boolean NOT NULL,
    "parentTaskId" bigint,
    "parentTaskId" bigint NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "pomodoro"
    ADD CONSTRAINT "pomodoro_fk_0"
    FOREIGN KEY("taskId")
    REFERENCES "task"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "task"
    ADD CONSTRAINT "task_fk_0"
    FOREIGN KEY("parentTaskId")
    REFERENCES "task"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_flutter_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_flutter_butler', '20260128210922517', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260128210922517', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260109031533194', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109031533194', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
