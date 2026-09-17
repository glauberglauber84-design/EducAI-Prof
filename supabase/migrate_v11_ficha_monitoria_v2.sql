-- Substitui o conteúdo da "Ficha de Autoavaliação da Monitoria" pela nova versão
-- do instrumento MonitorIA (5 dimensões, 11 subcategorias, sistema de semáforo).
-- O arquivo antigo (ficha-autoavaliacao-monitoria.pdf) foi removido do bucket
-- "materiais" e o novo foi subido com o nome original do download
-- (monitoria-ficha-autoavaliacao-3d-v10.pdf) — por isso arquivo_url/arquivo_nome
-- também são atualizados aqui, não só titulo/descricao.

update materiais
set
  titulo = 'MonitorIA — Ficha de Autoavaliação e Diagnóstico de IA na Educação Básica',
  descricao = 'Instrumento de autoavaliação para professores e gestores mapearem, sem jargão teórico, o uso da IA e das tecnologias digitais na escola. Organizado em 5 dimensões e 11 subcategorias (infraestrutura, letramento conceitual, prática pedagógica, autoria/engenharia de prompts, ética e vieses), com sistema de semáforo (Alerta/Atenção/Consolidado) e roteiro de consolidação para orientar o plano de ação da instituição.',
  arquivo_url = 'https://rksngxvidorksqkmjvwq.supabase.co/storage/v1/object/public/materiais/monitoria-ficha-autoavaliacao-3d-v10.pdf',
  arquivo_nome = 'monitoria-ficha-autoavaliacao-3d-v10.pdf'
where id = 9
  and titulo = 'Ficha de Autoavaliação da Monitoria';
