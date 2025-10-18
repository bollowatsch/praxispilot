SET search_path TO public;
DROP EXTENSION IF EXISTS "uuid-ossp";

CREATE EXTENSION "uuid-ossp" SCHEMA public;

CREATE TABLE IF NOT EXISTS public.user_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE NOT NULL,

    email VARCHAR(255) UNIQUE NOT NULL,
    is_Active BOOLEAN DEFAULT true,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.user_personal_info (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_profile_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE UNIQUE NOT NULL,
    title_prefix VARCHAR(100),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    title_suffix VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(50),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- trigger on registration
CREATE OR REPLACE FUNCTION public.create_user_profile_shells()
    RETURNS TRIGGER
    SECURITY DEFINER
    SET search_path = public
AS $$
DECLARE
    profile_id UUID;
BEGIN

    -- main profile
    INSERT INTO public.user_profiles (
        user_id,
        email
    ) VALUES (
 NEW.id,
        NEW.email
     ) RETURNING id INTO profile_id;

    -- empty shells for additional data
    INSERT INTO public.user_personal_info (user_profile_id)
    VALUES (profile_id);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger aktivieren
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
EXECUTE FUNCTION public.create_user_profile_shells();