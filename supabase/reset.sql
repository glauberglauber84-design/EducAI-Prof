-- Roda isso ANTES do schema.sql para limpar uma tentativa anterior incompleta
drop trigger if exists on_auth_user_created on auth.users;
drop function if exists public.handle_novo_usuario();
drop table if exists denuncias cascade;
drop table if exists diario_registros cascade;
drop table if exists prompts cascade;
drop table if exists ferramentas cascade;
drop table if exists professores cascade;
