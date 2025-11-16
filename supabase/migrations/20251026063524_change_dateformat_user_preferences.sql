UPDATE user_preferences SET date_format = 'dMyDots' WHERE date_format='DD.MM.YYYY';

ALTER TABLE user_preferences
ALTER COLUMN date_format
SET DEFAULT 'dMyDots';