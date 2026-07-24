-- EducAI Prof — Migração v5
-- Adiciona Imersão 4, 5 e 6 (vídeos do YouTube) ao Repositório.

insert into materiais (titulo, tipo, disciplina, descricao, arquivo_url, arquivo_nome, autor_id)
select v.titulo, 'video', null, v.descricao, v.arquivo_url, null,
  (select id from auth.users where email = 'glauberglauber84@gmail.com')
from (values
  ('Imersão 4', 'Vídeo da quarta imersão sobre IA na Educação Básica.', 'https://youtu.be/ODUMO371r6A'),
  ('Imersão 5', 'Vídeo da quinta imersão sobre IA na Educação Básica.', 'https://youtu.be/_RZ_f8H9eOc'),
  ('Imersão 6', 'Vídeo da sexta imersão sobre IA na Educação Básica.', 'https://youtu.be/qDbHEpGdb8Q')
) as v(titulo, descricao, arquivo_url)
where not exists (select 1 from materiais m where m.titulo = v.titulo);
