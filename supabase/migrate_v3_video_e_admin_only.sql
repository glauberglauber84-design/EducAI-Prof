-- EducAI Prof — Migração v3
-- 1) Repositório passa a aceitar também vídeos (.mp4)
-- 2) Inclusão de materiais fica restrita só a você (glauberglauber84@gmail.com)
--    por enquanto — a tela pública de upload foi removida do site.
-- 3) Insere os 3 materiais que você pediu (IA como Sócio Pedagógico, Imersão 1 e Imersão 2)
--
-- Antes de rodar o passo 3, envie os 3 arquivos pelo painel do Supabase em
-- Storage → bucket "materiais" → Upload files, dentro de uma pasta "admin/",
-- com estes nomes exatos (sem espaço/acento, pra não quebrar o link):
--   admin/ia-como-socio-pedagogico.pdf
--   admin/imersao-1.mp4
--   admin/imersao-2.mp4
--
-- IMPORTANTE: os vídeos têm ~87MB e ~168MB. O limite padrão de tamanho de
-- arquivo do Supabase é 50MB. Antes de subir os vídeos, vá em
-- Storage → Configuration (ou Settings → Storage) e aumente o
-- "Global file size limit" para pelo menos 200MB.

-- ═══════════════════════════════════
-- 1) Permitir tipo "video"
-- ═══════════════════════════════════
alter table materiais drop constraint if exists materiais_tipo_check;
alter table materiais add constraint materiais_tipo_check
  check (tipo in ('pdf','audio','podcast','video'));

-- ═══════════════════════════════════
-- 2) Restringir inclusão de materiais só a você
-- ═══════════════════════════════════
drop policy if exists "professor autenticado envia material" on materiais;
create policy "só o admin envia material"
  on materiais for insert
  to authenticated
  with check (
    autor_id = (select id from auth.users where email = 'glauberglauber84@gmail.com')
  );

drop policy if exists "professor autenticado envia arquivo de material" on storage.objects;
create policy "só o admin envia arquivo de material"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'materiais'
    and owner = (select id from auth.users where email = 'glauberglauber84@gmail.com')
  );

-- ═══════════════════════════════════
-- 3) Inserir os 3 materiais (rode só DEPOIS de subir os arquivos no Storage)
-- ═══════════════════════════════════
insert into materiais (titulo, tipo, disciplina, descricao, arquivo_url, arquivo_nome, autor_id)
select v.titulo, v.tipo, v.disciplina, v.descricao,
  'https://rksngxvidorksqkmjvwq.supabase.co/storage/v1/object/public/materiais/' || v.caminho,
  v.arquivo_nome,
  (select id from auth.users where email = 'glauberglauber84@gmail.com')
from (values
  ('IA como Sócio Pedagógico', 'pdf', null, 'Material de apoio sobre o uso da IA como parceira no planejamento e na prática docente.', 'admin/ia-como-socio-pedagogico.pdf', 'IA COMO SÓCIO PEDAGÓGICO (1).pdf'),
  ('Imersão 1', 'video', null, 'Vídeo da primeira imersão sobre IA na Educação Básica.', 'admin/imersao-1.mp4', 'Imersão 1.mp4'),
  ('Imersão 2', 'video', null, 'Vídeo da segunda imersão sobre IA na Educação Básica.', 'admin/imersao-2.mp4', 'IMERSÃO 2.mp4')
) as v(titulo, tipo, disciplina, descricao, caminho, arquivo_nome)
where not exists (select 1 from materiais m where m.titulo = v.titulo);
