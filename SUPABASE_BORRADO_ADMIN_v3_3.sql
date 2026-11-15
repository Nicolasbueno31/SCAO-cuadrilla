-- NOVA SCAO v3.3 — permisos y eliminación definitiva de jornadas
-- EJECUTAR EN: Supabase -> SQL Editor, con permisos de administración.
-- Conserva registros actuales. No borra ninguna jornada al instalarlo.

CREATE TABLE IF NOT EXISTS public.scao_administradores (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  creado_en timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.scao_administradores ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.scao_administradores FROM PUBLIC, anon, authenticated;

CREATE TABLE IF NOT EXISTS public.scao_jornadas_eliminadas (
  id uuid PRIMARY KEY,
  fecha text,
  eliminado_por uuid NOT NULL,
  eliminado_en timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.scao_jornadas_eliminadas ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.scao_jornadas_eliminadas FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.scao_es_admin()
RETURNS boolean
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = ''
AS $$
 SELECT EXISTS(
  SELECT 1 FROM public.scao_administradores a
  WHERE a.user_id = (SELECT auth.uid())
 );
$$;

CREATE OR REPLACE FUNCTION public.scao_eliminar_jornada(p_jornada_id uuid)
RETURNS boolean
LANGUAGE plpgsql VOLATILE SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
 v_user uuid := auth.uid();
 v_fecha text;
BEGIN
 IF v_user IS NULL OR NOT EXISTS (
  SELECT 1 FROM public.scao_administradores a WHERE a.user_id = v_user
 ) THEN
  RAISE EXCEPTION 'Acceso denegado: administrador requerido' USING ERRCODE='42501';
 END IF;

 -- El borrado y la marca técnica se confirman o revierten juntos.
 DELETE FROM public.scao_jornadas
 WHERE id = p_jornada_id
 RETURNING fecha::text INTO v_fecha;
 IF NOT FOUND THEN
  RAISE EXCEPTION 'No se encontró la jornada; actualizá el historial antes de reintentar';
 END IF;
 INSERT INTO public.scao_jornadas_eliminadas(id,fecha,eliminado_por)
 VALUES (p_jornada_id,v_fecha,v_user)
 ON CONFLICT (id) DO NOTHING;
 RETURN true;
END;
$$;

REVOKE ALL ON FUNCTION public.scao_es_admin() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.scao_es_admin() TO authenticated;
REVOKE ALL ON FUNCTION public.scao_eliminar_jornada(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.scao_eliminar_jornada(uuid) TO authenticated;

-- NO OLVIDAR: autorizar explícitamente al administrador en un paso aparte.
-- Consultar LEEME_ADMIN.txt antes de asignarlo.
