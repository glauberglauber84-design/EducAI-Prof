-- Usa o "Guia de Prompts de IA — BNCC Anos Iniciais" para:
-- (A) melhorar 4 prompts já existentes, ancorando-os a um código de habilidade
--     específico da BNCC (rastreabilidade curricular); e
-- (B) acrescentar 12 prompts novos e curados (não copiados do guia — redigidos no
--     estilo socrático/reflexivo já usado no banco), incluindo a criação da
--     disciplina Educação Física, que ainda não tinha nenhum prompt cadastrado.

-- ═══ (A) MELHORIAS EM PROMPTS EXISTENTES ═══

update prompts set prompt = prompt ||
  ' (Ancorado na habilidade BNCC EF01LP15 — sinonímia e antonímia.)'
where titulo = 'Jogo de sinônimos e antônimos'
  and prompt not like '%BNCC%';

update prompts set prompt = prompt ||
  ' (Ancorado na habilidade BNCC EF02MA10 — descrever padrões e regularidades de sequências.)'
where titulo = 'Raciocínio lógico com blocos'
  and prompt not like '%BNCC%';

update prompts set prompt = prompt ||
  ' (Ancorado na habilidade BNCC EF03MA07 — problemas de multiplicação por 2, 3, 4, 5 e 10.)'
where titulo = 'Jogo de tabuada investigativo'
  and prompt not like '%BNCC%';

update prompts set prompt = prompt ||
  ' (Ancorado na habilidade BNCC EF01GE01 — descrever lugares de vivência: moradia, escola, bairro.)'
where titulo = 'Meu lugar no mundo'
  and prompt not like '%BNCC%';

-- ═══ (B) NOVOS PROMPTS, CURADOS A PARTIR DO GUIA ═══

with autor as (
  select id from auth.users where email = 'glauberglauber84@gmail.com' limit 1
)
insert into prompts (autor_id, titulo, disciplina, ano, ferramenta, inclusivo, prompt)
select autor.id, v.titulo, v.disciplina, v.ano, v.ferramenta, v.inclusivo, v.prompt
from autor, (values

-- Língua Portuguesa — EF01LP08 (sons e representação escrita)
('Caça-som: sílabas escondidas', 'Língua Portuguesa', '1º ano', 'ChatGPT, Gemini ou Copilot', false,
 'Crie um jogo de "caça-som" com 8 palavras do cotidiano de uma criança de [idade] anos, em que ela precisa bater palmas para cada sílaba antes de descobrir a palavra completa. Não revele a palavra antes das pistas sonoras. (Ancorado na habilidade BNCC EF01LP08 — relacionar sons a sua representação escrita.)'),

-- Matemática — EF02MA20 (sistema monetário)
('Mercadinho de moedas', 'Matemática', '2º ano', 'ChatGPT, Gemini ou Copilot', false,
 'Monte uma simulação de "mercadinho" com 6 produtos e preços em reais adequados a crianças de [idade] anos, e 4 desafios de troco crescentes em dificuldade, para praticar equivalência entre moedas e cédulas. Não resolva os desafios, só apresente-os. (Ancorado na habilidade BNCC EF02MA20 — equivalência de valores entre moedas e cédulas.)'),

-- Ciências — EF02CI05 (água e luz para as plantas)
('Detetive das plantas', 'Ciências', '2º ano', 'ChatGPT, Gemini ou Copilot', false,
 'Proponha uma investigação simples de uma semana em que a turma compara duas mudas (uma com água e luz, outra privada de um desses fatores) e registra observações diárias em um quadro. Traga só o roteiro de observação, sem revelar o resultado esperado. (Ancorado na habilidade BNCC EF02CI05 — importância da água e da luz para a vida das plantas.)'),

-- Geografia — EF03GE03 (modos de vida de povos e comunidades tradicionais)
('Modos de vida ao redor do mundo', 'Geografia', '3º ano', 'ChatGPT, Gemini ou Copilot', false,
 'Apresente, de forma respeitosa e sem estereótipos, 3 exemplos de modos de vida de povos ou comunidades tradicionais (indígena, ribeirinha, quilombola) e gere 4 perguntas comparativas com o modo de vida dos próprios alunos, sem hierarquizar qual é "melhor". (Ancorado na habilidade BNCC EF03GE03 — modos de vida de povos e comunidades tradicionais.)'),

-- História — EF03HI08 (cidade e campo, presente e passado)
('Cidade e campo: então e agora', 'História', '3º ano', 'ChatGPT, Gemini ou Copilot', false,
 'Gere 5 perguntas comparando o modo de vida na cidade e no campo hoje com o de 50 anos atrás (trabalho, transporte, lazer), para uma roda de conversa, sem apresentar as respostas prontas. (Ancorado na habilidade BNCC EF03HI08 — modos de vida na cidade e no campo, no presente e no passado.)'),

-- Arte — EF15AR01 (apreciação de artes visuais)
('Museu imaginário', 'Arte', '1º ao 5º ano', 'ChatGPT, Gemini ou Copilot', false,
 'Descreva 4 obras de arte visuais de estilos bem diferentes entre si (uma pintura clássica, uma arte popular brasileira, uma escultura, uma arte digital contemporânea), com uma pergunta de apreciação para cada uma, sem dizer qual é "a mais bonita". (Ancorado na habilidade BNCC EF15AR01 — apreciar formas distintas das artes visuais tradicionais e contemporâneas.)'),

-- Educação Física — EF12EF01 (brincadeiras e jogos da cultura popular)
('Brincadeiras que atravessam gerações', 'Educação Física', '1º ao 2º ano', 'ChatGPT, Gemini ou Copilot', false,
 'Sugira 3 brincadeiras populares de rua adequadas ao pátio da escola para crianças de [idade] anos, com variações de regras para incluir colegas com diferentes níveis de desempenho motor. Não inclua brincadeiras que exijam equipamentos caros. (Ancorado na habilidade BNCC EF12EF01 — brincadeiras e jogos da cultura popular.)'),

-- Educação Física — EF12EF06 (regras dos esportes de marca e precisão)
('Por que existem regras no esporte?', 'Educação Física', '1º ao 2º ano', 'ChatGPT, Gemini ou Copilot', false,
 'Gere 4 perguntas para uma roda de conversa sobre por que esportes de marca e precisão (como boliche ou arremesso) têm regras de segurança, ajudando a turma a chegar às próprias conclusões, sem listar as regras prontas. (Ancorado na habilidade BNCC EF12EF06 — importância das normas e regras dos esportes de marca e precisão.)'),

-- Educação Física — EF12EF11 (danças do contexto comunitário)
('Roda cantada da nossa região', 'Educação Física', '1º ao 2º ano', 'ChatGPT, Gemini ou Copilot', false,
 'Sugira 2 rodas cantadas ou danças de brincadeira típicas do contexto comunitário/regional brasileiro, com passos simples descritos em etapas, para crianças de [idade] anos experimentarem em roda. (Ancorado na habilidade BNCC EF12EF11 — danças do contexto comunitário e regional.)'),

-- Educação Física — EF35EF01 (jogos populares do Brasil e do mundo, matriz indígena e africana)
('Jogos do mundo, jogos do Brasil', 'Educação Física', '3º ao 5º ano', 'ChatGPT, Gemini ou Copilot', false,
 'Liste 4 brincadeiras ou jogos populares de origens diferentes (incluindo ao menos uma de matriz indígena e uma de matriz africana), com uma frase sobre sua origem cultural, para a turma experimentar e depois pesquisar a história de cada uma. (Ancorado na habilidade BNCC EF35EF01 — jogos populares do Brasil e do mundo, incluindo matriz indígena e africana.)'),

-- Educação Física — EF35EF06 (diferença entre jogo e esporte)
('Jogo ou esporte: qual a diferença?', 'Educação Física', '3º ao 5º ano', 'ChatGPT, Gemini ou Copilot', false,
 'Apresente 3 situações do dia a dia (uma pelada no bairro, um jogo de tabuleiro, um campeonato profissional) e gere perguntas que ajudem a turma a discutir o que diferencia "jogo" de "esporte", sem dar a definição pronta. (Ancorado na habilidade BNCC EF35EF06 — diferenciar os conceitos de jogo e esporte.)'),

-- Educação Física — EF35EF07 (ginástica geral e coreografias)
('Coreografia coletiva do cotidiano', 'Educação Física', '3º ao 5º ano', 'ChatGPT, Gemini ou Copilot', false,
 'Sugira uma estrutura simples de coreografia coletiva (4 blocos de movimento: equilíbrio, salto, giro e uma pose final) inspirada em um tema do cotidiano escolhido pela turma, com adaptações para alunos com mobilidade reduzida. (Ancorado na habilidade BNCC EF35EF07 — combinações de elementos da ginástica geral em coreografias.)')

) as v(titulo, disciplina, ano, ferramenta, inclusivo, prompt);
