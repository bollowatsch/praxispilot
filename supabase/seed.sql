SET search_path TO public;

CREATE EXTENSION IF NOT EXISTS pgcrypto;
SET search_path = public, extensions;

CREATE OR REPLACE FUNCTION create_test_user(
    p_email VARCHAR,
    p_password VARCHAR,
    p_title_prefix VARCHAR DEFAULT NULL,
    p_first_name VARCHAR DEFAULT NULL,
    p_last_name VARCHAR DEFAULT NULL,
    p_title_suffix VARCHAR DEFAULT NULL,
    p_practice_name VARCHAR DEFAULT NULL,
    p_practice_type VARCHAR DEFAULT NULL
) RETURNS UUID AS $$
DECLARE
    v_user_id UUID;
    v_profile_id UUID;
    v_encrypted_password VARCHAR;
BEGIN
    v_encrypted_password := crypt(p_password, gen_salt('bf'));

    INSERT INTO auth.users (
        id,
        email,
        encrypted_password,
        email_confirmed_at,
        created_at,
        updated_at,
        raw_app_meta_data,
        raw_user_meta_data,
        is_super_admin,
        role
    ) VALUES (
        gen_random_uuid(),
        p_email,
        v_encrypted_password,
        NOW(),
        NOW(),
        NOW(),
        '{"provider":"email","providers":["email"]}'::jsonb,
        '{"email_verified":"true"}'::jsonb,
        false,
     'authenticated'
 ) RETURNING id INTO v_user_id;

    -- Get the created profile_id
    SELECT id INTO v_profile_id
    FROM public.user_profiles
    WHERE user_id = v_user_id;

    -- Update personal information if provided
    IF p_first_name IS NOT NULL OR p_last_name IS NOT NULL THEN
        UPDATE public.user_personal_info
        SET
            title_prefix = COALESCE(p_title_prefix, title_prefix),
            first_name = COALESCE(p_first_name, first_name),
            last_name = COALESCE(p_last_name, last_name),
            title_suffix = COALESCE(p_title_suffix, title_suffix),
            email = p_email,
            updated_at = NOW()
        WHERE user_profile_id = v_profile_id;
    END IF;

    -- Update practice information if provided
    IF p_practice_name IS NOT NULL THEN
        UPDATE public.user_practice_information
        SET
            practice_name = p_practice_name,
            practice_type = COALESCE(p_practice_type, 'Einzelpraxis'),
            email = p_email,
            updated_at = NOW()
        WHERE user_profile_id = v_profile_id;
    END IF;

    RAISE NOTICE 'Created test user: % (ID: %)', p_email, v_user_id;
    RETURN v_user_id;
END;
$$ LANGUAGE plpgsql;

DO $$
    DECLARE
        v_test_user_1 UUID;
        v_test_user_2 UUID;
        v_test_user_3 UUID;
    BEGIN

        -- Test User 1: Dr. Maria Müller (Complete Profile)
        -- Email: maria.mueller@test.example.com
        -- Password: TestPass123!
        v_test_user_1 := create_test_user(
                p_email := 'maria.mueller@test.example.com',
                p_password := 'TestPass123!',
                p_title_prefix := 'Dr.',
                p_first_name := 'Maria',
                p_last_name := 'Müller',
                p_title_suffix := NULL,
                p_practice_name := 'Praxis Dr. Maria Müller',
                p_practice_type := 'Einzelpraxis'
                         );

        -- Update additional practice details
        UPDATE public.user_practice_information
        SET
            street = 'Hauptstraße',
            house_number = '42',
            postal_code = '1010',
            city = 'Wien',
            state = 'Wien',
            country = 'AT',
            phone = '+43 1 234 5678',
            website = 'https://www.praxis-mueller.at',
            updated_at = NOW()
        WHERE user_profile_id IN (
            SELECT id FROM public.user_profiles WHERE user_id = v_test_user_1
        );

        -- Test User 2: Mag. Thomas Schmidt (Minimal Profile)
        -- Email: thomas.schmidt@test.example.com
        -- Password: TestPass123!

        v_test_user_2 := create_test_user(
                p_email := 'thomas.schmidt@test.example.com',
                p_password := 'TestPass123!',
                p_title_prefix := 'Mag.',
                p_first_name := 'Thomas',
                p_last_name := 'Schmidt',
                p_practice_name := 'Psychotherapie Schmidt'
                         );

        UPDATE public.user_practice_information
        SET
            city = 'Graz',
            country = 'AT',
            updated_at = NOW()
        WHERE user_profile_id IN (
            SELECT id FROM public.user_profiles WHERE user_id = v_test_user_2
        );

        -- Test User 3: Anna Weber (New User - Incomplete Profile)
        -- Email: anna.weber@test.example.com
        -- Password: TestPass123!
        v_test_user_3 := create_test_user(
                p_email := 'anna.weber@test.example.com',
                p_password := 'TestPass123!',
                p_first_name := 'Anna',
                p_last_name := 'Weber'
                         );

        UPDATE public.user_preferences
        SET
            theme_mode = 'dark',
            language = 'de',
            updated_at = NOW()
        WHERE user_profile_id IN (
            SELECT id FROM public.user_profiles WHERE user_id = v_test_user_3
        );

        RAISE NOTICE '============================================================================';
        RAISE NOTICE 'Test users created successfully!';
        RAISE NOTICE '';
        RAISE NOTICE 'Login Credentials:';
        RAISE NOTICE '-------------------';
        RAISE NOTICE '1. Dr. Maria Müller (Complete Profile)';
        RAISE NOTICE '   Email:    maria.mueller@test.example.com';
        RAISE NOTICE '   Password: TestPass123!';
        RAISE NOTICE '';
        RAISE NOTICE '2. Mag. Thomas Schmidt (Minimal Profile)';
        RAISE NOTICE '   Email:    thomas.schmidt@test.example.com';
        RAISE NOTICE '   Password: TestPass123!';
        RAISE NOTICE '';
        RAISE NOTICE '3. Anna Weber (New User - Incomplete)';
        RAISE NOTICE '   Email:    anna.weber@test.example.com';
        RAISE NOTICE '   Password: TestPass123!';
        RAISE NOTICE '============================================================================';
        RAISE NOTICE '';
        RAISE NOTICE 'IMPORTANT: These are TEST USERS for development only!';
        RAISE NOTICE 'Never use these credentials in production!';
        RAISE NOTICE '============================================================================';

    END $$;


CREATE OR REPLACE FUNCTION public.cleanup_test_users()
    RETURNS void AS $$
BEGIN
    DELETE FROM auth.users WHERE email LIKE '%@test.example.com';
    RAISE NOTICE 'All test users have been deleted.';
END;
$$ LANGUAGE plpgsql;

-- Usage: SELECT public.cleanup_test_users();

-- ============================================================================
-- Drop the helper function (Optional - cleanup after seeding)
-- ============================================================================
-- Uncomment if you want to remove the helper function after seeding:
-- DROP FUNCTION IF EXISTS create_test_user(VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR);