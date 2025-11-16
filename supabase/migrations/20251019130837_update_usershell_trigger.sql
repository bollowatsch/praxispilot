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

    INSERT INTO public.user_practice_information (user_profile_id)
    VALUES (profile_id);

    INSERT INTO public.user_preferences (user_profile_id)
    VALUES (profile_id);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;