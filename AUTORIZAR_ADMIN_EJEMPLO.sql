-- Reemplazar el correo de ejemplo por el correo de LOGIN real de Supabase Auth.
-- Esta consulta debe ejecutarla el administrador del proyecto en SQL Editor.
INSERT INTO public.scao_administradores(user_id)
SELECT id FROM auth.users
WHERE lower(email) = lower('CAMBIAR_POR_CORREO_DE_LOGIN@empresa.com')
ON CONFLICT (user_id) DO NOTHING;

-- Confirmar que devuelve tu usuario autorizado (sin mostrar credenciales):
SELECT a.user_id, u.email, a.creado_en
FROM public.scao_administradores a JOIN auth.users u ON u.id=a.user_id;
