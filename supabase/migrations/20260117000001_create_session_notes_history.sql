CREATE TABLE IF NOT EXISTS public.session_notes_his (
    history_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id UUID NOT NULL,
    user_profile_id UUID NOT NULL,
    patient_id UUID NOT NULL,

    -- Session metadata
    session_date DATE NOT NULL,
    session_start_time TIME NOT NULL,
    session_duration_minutes INTEGER NOT NULL,
    session_type VARCHAR(50) NOT NULL,

    -- Content
    content TEXT,

    -- Status management
    status VARCHAR(20) NOT NULL,
    finalized_at TIMESTAMPTZ,

    -- Unlock tracking
    unlock_reason TEXT,
    unlocked_at TIMESTAMPTZ,

    -- Original timestamps
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL,
    archived_at TIMESTAMPTZ,

    -- History metadata
    history_created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    history_created_by UUID REFERENCES auth.users(id),
    history_operation VARCHAR(10) NOT NULL CHECK (history_operation IN ('UPDATE', 'DELETE'))
);

-- Create indexes for performance
CREATE INDEX idx_session_notes_his_note_id ON public.session_notes_his(id);
CREATE INDEX idx_session_notes_his_patient ON public.session_notes_his(patient_id);
CREATE INDEX idx_session_notes_his_created_at ON public.session_notes_his(history_created_at DESC);

-- Enable Row Level Security
ALTER TABLE public.session_notes_his ENABLE ROW LEVEL SECURITY;

-- Create policy: Users can only see history for their own patients
CREATE POLICY session_notes_his_isolation_policy ON public.session_notes_his
    FOR ALL
    USING (patient_id IN (
        SELECT id FROM public.patients
        WHERE user_profile_id = (
            SELECT id FROM public.user_profiles
            WHERE user_id = auth.uid()
        )
    ));

-- Create trigger function to archive old versions before update
CREATE OR REPLACE FUNCTION archive_session_note_version()
RETURNS TRIGGER AS $$
BEGIN
    -- Only archive if actual content changed (not just updated_at)
    IF (OLD.session_date, OLD.session_start_time, OLD.session_duration_minutes,
        OLD.session_type, OLD.content, OLD.status) IS DISTINCT FROM
       (NEW.session_date, NEW.session_start_time, NEW.session_duration_minutes,
        NEW.session_type, NEW.content, NEW.status) THEN

        INSERT INTO public.session_notes_his (
            id,
            user_profile_id,
            patient_id,
            session_date,
            session_start_time,
            session_duration_minutes,
            session_type,
            content,
            status,
            finalized_at,
            unlock_reason,
            unlocked_at,
            created_at,
            updated_at,
            archived_at,
            history_created_by,
            history_operation
        ) VALUES (
            OLD.id,
            OLD.user_profile_id,
            OLD.patient_id,
            OLD.session_date,
            OLD.session_start_time,
            OLD.session_duration_minutes,
            OLD.session_type,
            OLD.content,
            OLD.status,
            OLD.finalized_at,
            OLD.unlock_reason,
            OLD.unlocked_at,
            OLD.created_at,
            OLD.updated_at,
            OLD.archived_at,
            auth.uid(),
            'UPDATE'
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to archive versions before update
CREATE TRIGGER session_notes_archive_trigger
    BEFORE UPDATE ON public.session_notes
    FOR EACH ROW
    EXECUTE FUNCTION archive_session_note_version();

-- Create trigger function to archive before soft delete
CREATE OR REPLACE FUNCTION archive_session_note_on_delete()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.archived_at IS NOT NULL AND OLD.archived_at IS NULL THEN
        INSERT INTO public.session_notes_his (
            id,
            user_profile_id,
            patient_id,
            session_date,
            session_start_time,
            session_duration_minutes,
            session_type,
            content,
            status,
            finalized_at,
            unlock_reason,
            unlocked_at,
            created_at,
            updated_at,
            archived_at,
            history_created_by,
            history_operation
        ) VALUES (
            OLD.id,
            OLD.user_profile_id,
            OLD.patient_id,
            OLD.session_date,
            OLD.session_start_time,
            OLD.session_duration_minutes,
            OLD.session_type,
            OLD.content,
            OLD.status,
            OLD.finalized_at,
            OLD.unlock_reason,
            OLD.unlocked_at,
            OLD.created_at,
            OLD.updated_at,
            NEW.archived_at,
            auth.uid(),
            'DELETE'
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to archive on soft delete
CREATE TRIGGER session_notes_archive_delete_trigger
    BEFORE UPDATE OF archived_at ON public.session_notes
    FOR EACH ROW
    EXECUTE FUNCTION archive_session_note_on_delete();
