-- Adiciona ao Repositório o guia "A Bússola do Pedagogo — Um Guia Acolhedor
-- para a Inteligência Artificial na Educação"

insert into materiais (titulo, tipo, descricao, arquivo_url, arquivo_nome)
select
  'A Bússola do Pedagogo — Guia Acolhedor para a IA na Educação',
  'pdf',
  'Guia que situa o professor diante da IA na educação: dados sobre adoção e falta de formação docente, riscos como o "platô instrumental" (uso raso, sem alfabetização crítica), alucinações e vieses algorítmicos, e um plano para transformar a curiosidade autodidata em domínio profissional, com a mediação humana no centro do processo pedagógico.',
  'https://rksngxvidorksqkmjvwq.supabase.co/storage/v1/object/public/materiais/A_Bussola_do_Pedagogo.pdf',
  'A_Bussola_do_Pedagogo.pdf'
where not exists (
  select 1 from materiais where titulo = 'A Bússola do Pedagogo — Guia Acolhedor para a IA na Educação'
);
