-- Remove date/time format and accessibility columns from user_preferences
-- Date and time formats will be derived from system settings instead

ALTER TABLE public.user_preferences
DROP COLUMN IF EXISTS date_format,
DROP COLUMN IF EXISTS time_format,
DROP COLUMN IF EXISTS high_contrast,
DROP COLUMN IF EXISTS reduce_animations,
DROP COLUMN IF EXISTS locale;

-- Update any existing rows to ensure they have valid defaults for remaining columns
UPDATE public.user_preferences
SET
  theme_mode = COALESCE(theme_mode, 'system'),
  language = COALESCE(language, 'de'),
  timezone = COALESCE(timezone, 'Europe/Vienna')
WHERE theme_mode IS NULL OR language IS NULL OR timezone IS NULL;