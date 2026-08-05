-- Adiciona ao Repositório o Guia de Prompts de IA alinhado à BNCC (Anos Iniciais)

insert into materiais (titulo, tipo, descricao, arquivo_url, arquivo_nome)
select
  'Guia de Prompts de IA — BNCC Anos Iniciais',
  'pdf',
  'Guia com sugestões de prompts de IA organizadas a partir das habilidades da BNCC para Língua Portuguesa, Matemática, Ciências, Geografia, História, Arte e Educação Física, do 1º ao 5º ano do Ensino Fundamental.',
  'https://rksngxvidorksqkmjvwq.supabase.co/storage/v1/object/public/materiais/Guia_Prompts_IA_BNCC_Anos_Iniciais.pdf',
  'Guia_Prompts_IA_BNCC_Anos_Iniciais.pdf'
where not exists (
  select 1 from materiais where titulo = 'Guia de Prompts de IA — BNCC Anos Iniciais'
);
