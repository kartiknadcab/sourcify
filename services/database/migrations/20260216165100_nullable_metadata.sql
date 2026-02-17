-- migrate:up

ALTER TABLE sourcify_matches ALTER COLUMN metadata DROP NOT NULL;

CREATE OR REPLACE FUNCTION public.validate_compilation_artifacts(obj jsonb) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN
        is_jsonb_object(obj) AND
        validate_json_object_keys(
            obj,
            array ['abi', 'sources'],
            array ['userdoc', 'devdoc', 'storageLayout']
        ) AND
        validate_compilation_artifacts_abi(obj -> 'abi') AND
        validate_compilation_artifacts_sources(obj -> 'sources');
END;
$$;

-- migrate:down

ALTER TABLE sourcify_matches ALTER COLUMN metadata SET NOT NULL;

CREATE OR REPLACE FUNCTION public.validate_compilation_artifacts(obj jsonb) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN
        is_jsonb_object(obj) AND
        validate_json_object_keys(
            obj,
            array ['abi', 'userdoc', 'devdoc', 'sources', 'storageLayout'],
            array []::text[]
        ) AND
        validate_compilation_artifacts_abi(obj -> 'abi') AND
        validate_compilation_artifacts_sources(obj -> 'sources');
END;
$$;
