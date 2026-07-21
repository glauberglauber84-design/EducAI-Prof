-- EducAI Prof — Migração v4
-- Aponta os vídeos de Imersão para o YouTube (em vez de Supabase Storage)
-- e cria o registro da Imersão 3.

update materiais set arquivo_url = 'https://www.youtube.com/watch?v=tNlRVeqlKhk'
where titulo = 'Imersão 1';

update materiais set arquivo_url = 'https://youtu.be/uN94C2MXGYA'
where titulo = 'Imersão 2';

insert into materiais (titulo, tipo, disciplina, descricao, arquivo_url, arquivo_nome, autor_id)
select 'Imersão 3', 'video', null, 'Vídeo da terceira imersão sobre IA na Educação Básica.',
  'https://youtu.be/D6WtRrSjyZw', null,
  (select id from auth.users where email = 'glauberglauber84@gmail.com')
where not exists (select 1 from materiais m where m.titulo = 'Imersão 3');
