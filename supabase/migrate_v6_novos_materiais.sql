-- Adiciona 2 novos materiais em PDF ao Repositório
-- (arquivos já enviados manualmente para o bucket "materiais")

insert into materiais (titulo, tipo, descricao, arquivo_url, arquivo_nome)
select
  'Guia Prático EDUCAÍ',
  'pdf',
  'Guia prático para professores dos Anos Iniciais sobre o uso pedagógico de IA em sala de aula.',
  'https://rksngxvidorksqkmjvwq.supabase.co/storage/v1/object/public/materiais/Guia%20Pratico%20EDUCAI.pdf',
  'Guia Pratico EDUCAI.pdf'
where not exists (
  select 1 from materiais where titulo = 'Guia Prático EDUCAÍ'
);

insert into materiais (titulo, tipo, descricao, arquivo_url, arquivo_nome)
select
  'Ficha de Autoavaliação da Monitoria',
  'pdf',
  'Ficha para autoavaliação dos professores participantes da monitoria do EducAI Prof.',
  'https://rksngxvidorksqkmjvwq.supabase.co/storage/v1/object/public/materiais/ficha-autoavaliacao-monitoria.pdf',
  'ficha-autoavaliacao-monitoria.pdf'
where not exists (
  select 1 from materiais where titulo = 'Ficha de Autoavaliação da Monitoria'
);
