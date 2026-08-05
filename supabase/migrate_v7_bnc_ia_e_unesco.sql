-- Adiciona ao Repositório o guia BNC-Formação IA (produzido pelo EducAI Prof)
-- e o quadro de referência da UNESCO usado como uma das fontes.

insert into materiais (titulo, tipo, descricao, arquivo_url, arquivo_nome)
select
  'BNC-Formação IA — Guia de Competências Docentes em IA',
  'pdf',
  'Guia original que relaciona cada competência e habilidade da BNC-Formação Continuada de Professores com o Quadro de Competências de IA para Professores (UNESCO, 2024), nos três níveis Adquirir, Aprofundar e Criar.',
  'https://rksngxvidorksqkmjvwq.supabase.co/storage/v1/object/public/materiais/BNC-Formacao-IA.pdf',
  'BNC-Formacao-IA.pdf'
where not exists (
  select 1 from materiais where titulo = 'BNC-Formação IA — Guia de Competências Docentes em IA'
);

insert into materiais (titulo, tipo, descricao, arquivo_url, arquivo_nome)
select
  'Quadro de Competências de IA para Professores (UNESCO)',
  'pdf',
  'Publicação da UNESCO (2024) que define as competências, conhecimentos e valores que os professores devem dominar na era da IA, organizados em 5 dimensões e 3 níveis de progressão.',
  'https://rksngxvidorksqkmjvwq.supabase.co/storage/v1/object/public/materiais/UNESCO%20(2).pdf',
  'UNESCO (2).pdf'
where not exists (
  select 1 from materiais where titulo = 'Quadro de Competências de IA para Professores (UNESCO)'
);
