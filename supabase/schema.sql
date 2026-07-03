-- EducAI Prof — schema Supabase
-- Rode este script no SQL Editor do seu projeto Supabase (supabase.com/dashboard)

-- ═══════════════════════════════════
-- PROFESSORES (perfil complementar ao auth.users)
-- ═══════════════════════════════════
create table professores (
  id uuid primary key references auth.users(id) on delete cascade,
  nome text not null,
  criado_em timestamptz not null default now()
);

alter table professores enable row level security;

create policy "professor vê e edita o próprio perfil"
  on professores for all
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- cria automaticamente um registro em professores ao criar um usuário no auth
create function public.handle_novo_usuario()
returns trigger as $$
begin
  insert into public.professores (id, nome)
  values (new.id, coalesce(new.raw_user_meta_data->>'nome', new.email));
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_novo_usuario();

-- ═══════════════════════════════════
-- FERRAMENTAS (curadoria — leitura pública, escrita restrita)
-- ═══════════════════════════════════
create table ferramentas (
  id bigint generated always as identity primary key,
  nome text not null,
  disciplina text not null,
  anos text not null,
  icone text,
  nee boolean not null default false,
  open_source boolean not null default false,
  descricao text,
  nivel_unesco text,
  estrelas numeric(2,1) default 0,
  criterios jsonb not null default '[]',
  chips jsonb not null default '[]',
  badges jsonb not null default '[]',
  badge_labels jsonb not null default '[]',
  criado_em timestamptz not null default now()
);

alter table ferramentas enable row level security;

create policy "qualquer um pode ler ferramentas"
  on ferramentas for select
  using (true);

create policy "professor autenticado pode cadastrar ferramenta"
  on ferramentas for insert
  to authenticated
  with check (true);

-- ═══════════════════════════════════
-- PROMPTS VALIDADOS
-- ═══════════════════════════════════
create table prompts (
  id bigint generated always as identity primary key,
  autor_id uuid not null references professores(id) on delete cascade,
  titulo text not null,
  disciplina text not null,
  ano text not null,
  ferramenta text,
  inclusivo boolean not null default false,
  prompt text not null,
  curtidas int not null default 0,
  criado_em timestamptz not null default now()
);

alter table prompts enable row level security;

create policy "qualquer um pode ler prompts"
  on prompts for select
  using (true);

create policy "professor autenticado publica prompt"
  on prompts for insert
  to authenticated
  with check (auth.uid() = autor_id);

create policy "autor edita ou apaga o próprio prompt"
  on prompts for update using (auth.uid() = autor_id)
  with check (auth.uid() = autor_id);

create policy "autor apaga o próprio prompt"
  on prompts for delete using (auth.uid() = autor_id);

-- ═══════════════════════════════════
-- DIÁRIO DE REFLEXÃO (privado por professor)
-- ═══════════════════════════════════
create table diario_registros (
  id bigint generated always as identity primary key,
  professor_id uuid not null references professores(id) on delete cascade,
  ferramenta text not null,
  funcionou text,
  melhorar text,
  agencia_aluno text,
  barreiras_nee text,
  estrelas int not null check (estrelas between 1 and 5),
  criado_em timestamptz not null default now()
);

alter table diario_registros enable row level security;

create policy "professor vê apenas os próprios registros"
  on diario_registros for select using (auth.uid() = professor_id);

create policy "professor cria o próprio registro"
  on diario_registros for insert
  to authenticated
  with check (auth.uid() = professor_id);

-- ═══════════════════════════════════
-- DENÚNCIAS (reportar viés)
-- ═══════════════════════════════════
create table denuncias (
  id bigint generated always as identity primary key,
  ferramenta_id bigint references ferramentas(id) on delete set null,
  professor_id uuid references professores(id) on delete set null,
  tipo text not null,
  descricao text not null,
  criado_em timestamptz not null default now()
);

alter table denuncias enable row level security;

create policy "professor autenticado registra denúncia"
  on denuncias for insert
  to authenticated
  with check (auth.uid() = professor_id);

create policy "autor vê as próprias denúncias"
  on denuncias for select using (auth.uid() = professor_id);

-- ═══════════════════════════════════
-- SEED — ferramentas iniciais (mesmas do protótipo)
-- ═══════════════════════════════════
insert into ferramentas (nome, disciplina, anos, icone, nee, open_source, descricao, nivel_unesco, estrelas, criterios, chips, badges, badge_labels) values
('Khan Academy (Khanmigo)','Matemática','1-9','🧮',true,false,
 'Tutor de IA socrático que guia o aluno com perguntas, sem dar respostas prontas. Suporte de acessibilidade para diferentes ritmos de aprendizagem.',
 'Nível UNESCO: Adquirir → Aprofundar · Aspecto 4 (Pedagogia da IA)', 4.8,
 '[{"nome":"Segurança de Dados","val":90,"c":""},{"nome":"Adequação à Faixa Etária","val":95,"c":""},{"nome":"Agência do Aluno","val":85,"c":""},{"nome":"Sem Viés","val":80,"c":""},{"nome":"Transparência","val":70,"c":"media"},{"nome":"Acessibilidade NEE","val":82,"c":""}]',
 '["Gratuito","Português disponível","Sem anúncios","♿ Acessível"]',
 '["badge-mat","badge-inc"]', '["Matemática","Pró-Inclusão"]'),
('Canva IA','Artes','4-9','🎨',false,false,
 'Geração de imagens e layouts com IA. Ótimo para projetos visuais, mas requer supervisão ética — pode reproduzir estereótipos visuais.',
 'Nível UNESCO: Adquirir · Aspecto 3 (Fundamentos e Aplicações)', 4.3,
 '[{"nome":"Segurança de Dados","val":72,"c":"media"},{"nome":"Adequação à Faixa Etária","val":78,"c":"media"},{"nome":"Agência do Aluno","val":90,"c":""},{"nome":"Sem Viés","val":58,"c":"baixa"},{"nome":"Transparência","val":55,"c":"baixa"},{"nome":"Acessibilidade NEE","val":60,"c":"media"}]',
 '["Versão gratuita","Conta educacional","⚠️ Monitorar viés"]',
 '["badge-arte"]', '["Artes"]'),
('Scratch','Todas','4-9','🐱',true,true,
 'Programação criativa com blocos. Código aberto, sem coleta de dados comercial. Referência em agência do aluno e pensamento computacional.',
 'Nível UNESCO: Aprofundar → Criar · Aspecto 3 (Fundamentos e Aplicações)', 4.9,
 '[{"nome":"Segurança de Dados","val":95,"c":""},{"nome":"Adequação à Faixa Etária","val":95,"c":""},{"nome":"Agência do Aluno","val":98,"c":""},{"nome":"Sem Viés","val":95,"c":""},{"nome":"Transparência","val":90,"c":""},{"nome":"Acessibilidade NEE","val":80,"c":""}]',
 '["100% Gratuito","Código aberto","MIT License","♿ Acessível"]',
 '["badge-todos","badge-open","badge-nee"]', '["Todas as disciplinas","Código Aberto","NEE"]'),
('Book Creator IA','Português','1-5','📖',true,false,
 'Criação de livros digitais com suporte de IA. Perfeito para produção textual e narrativas criativas. Recursos de acessibilidade para leitores iniciantes.',
 'Nível UNESCO: Adquirir → Aprofundar · Aspecto 4 (Pedagogia da IA)', 4.6,
 '[{"nome":"Segurança de Dados","val":85,"c":""},{"nome":"Adequação à Faixa Etária","val":92,"c":""},{"nome":"Agência do Aluno","val":95,"c":""},{"nome":"Sem Viés","val":80,"c":""},{"nome":"Transparência","val":75,"c":"media"},{"nome":"Acessibilidade NEE","val":78,"c":"media"}]',
 '["Plano escola","COPPA compliant","Colaborativo","♿ Parcial"]',
 '["badge-port","badge-inc"]', '["Português","Pró-Inclusão"]'),
('Google Read Along','Português','1-3','📚',true,false,
 'App de leitura com tutor de IA que ouve a criança ler em voz alta. Foco na alfabetização. Disponível offline e em Português BR.',
 'Nível UNESCO: Adquirir · Aspecto 4 (Pedagogia da IA)', 4.4,
 '[{"nome":"Segurança de Dados","val":68,"c":"media"},{"nome":"Adequação à Faixa Etária","val":90,"c":""},{"nome":"Agência do Aluno","val":80,"c":""},{"nome":"Sem Viés","val":74,"c":"media"},{"nome":"Transparência","val":60,"c":"media"},{"nome":"Acessibilidade NEE","val":75,"c":"media"}]',
 '["Gratuito","Offline","Português BR","♿ Parcial"]',
 '["badge-port","badge-nee"]', '["Português","NEE"]'),
('Kolibri (LE)','Todas','1-9','🕊️',true,true,
 'Plataforma de aprendizagem offline de código aberto, pensada para contextos de baixa conectividade. Sem coleta de dados e totalmente personalizável.',
 'Nível UNESCO: Adquirir · Aspecto 5 (Desenvolvimento Profissional)', 4.7,
 '[{"nome":"Segurança de Dados","val":98,"c":""},{"nome":"Adequação à Faixa Etária","val":90,"c":""},{"nome":"Agência do Aluno","val":85,"c":""},{"nome":"Sem Viés","val":90,"c":""},{"nome":"Transparência","val":95,"c":""},{"nome":"Acessibilidade NEE","val":88,"c":""}]',
 '["100% Gratuito","Código aberto","Funciona offline","♿ Acessível"]',
 '["badge-todos","badge-open","badge-nee","badge-inc"]', '["Todas as disciplinas","Código Aberto","NEE","Pró-Inclusão"]');
