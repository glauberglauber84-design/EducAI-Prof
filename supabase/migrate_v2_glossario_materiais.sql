-- EducAI Prof — Migração v2
-- Glossário passa a ter a mesma riqueza de informação do antigo Repositório
-- (critérios, chips, badges, grátis/pago) e recebe as 6 ferramentas que
-- estavam no Repositório. O Repositório passa a ser o banco de materiais
-- (PDFs, áudios e podcasts) enviados pelos professores.
--
-- Rode este script no SQL Editor do Supabase DEPOIS de já ter rodado
-- schema.sql, create_glossario.sql e seed_glossario.sql.

-- ═══════════════════════════════════
-- 1) AMPLIAR GLOSSÁRIO com os campos ricos que o Repositório tinha
-- ═══════════════════════════════════
alter table glossario
  add column if not exists disciplina text,
  add column if not exists anos text,
  add column if not exists icone text,
  add column if not exists nee boolean not null default false,
  add column if not exists open_source boolean not null default false,
  add column if not exists nivel_unesco text,
  add column if not exists estrelas numeric(2,1),
  add column if not exists criterios jsonb,
  add column if not exists chips jsonb,
  add column if not exists badges jsonb,
  add column if not exists badge_labels jsonb,
  add column if not exists preco text not null default 'Não informado';

update glossario set preco = 'Não informado' where preco is null;

-- ═══════════════════════════════════
-- 2) MIGRAR as 6 ferramentas do antigo Repositório para o Glossário
-- (só insere se ainda não existir, pra poder rodar o script mais de uma vez)
-- ═══════════════════════════════════
insert into glossario (nome, categoria, descricao, disciplina, anos, icone, nee, open_source, nivel_unesco, estrelas, criterios, chips, badges, badge_labels, preco)
select * from (values
('Khan Academy (Khanmigo)','Matemática',
 'Tutor de IA socrático que guia o aluno com perguntas, sem dar respostas prontas. Suporte de acessibilidade para diferentes ritmos de aprendizagem.',
 'Matemática','1-9','🧮',true,false,
 'Nível UNESCO: Adquirir → Aprofundar · Aspecto 4 (Pedagogia da IA)', 4.8::numeric,
 '[{"nome":"Segurança de Dados","val":90,"c":""},{"nome":"Adequação à Faixa Etária","val":95,"c":""},{"nome":"Agência do Aluno","val":85,"c":""},{"nome":"Sem Viés","val":80,"c":""},{"nome":"Transparência","val":70,"c":"media"},{"nome":"Acessibilidade NEE","val":82,"c":""}]'::jsonb,
 '["Gratuito","Português disponível","Sem anúncios","♿ Acessível"]'::jsonb,
 '["badge-mat","badge-inc"]'::jsonb, '["Matemática","Pró-Inclusão"]'::jsonb, 'Grátis'),
('Canva IA','Artes',
 'Geração de imagens e layouts com IA. Ótimo para projetos visuais, mas requer supervisão ética — pode reproduzir estereótipos visuais.',
 'Artes','4-9','🎨',false,false,
 'Nível UNESCO: Adquirir · Aspecto 3 (Fundamentos e Aplicações)', 4.3::numeric,
 '[{"nome":"Segurança de Dados","val":72,"c":"media"},{"nome":"Adequação à Faixa Etária","val":78,"c":"media"},{"nome":"Agência do Aluno","val":90,"c":""},{"nome":"Sem Viés","val":58,"c":"baixa"},{"nome":"Transparência","val":55,"c":"baixa"},{"nome":"Acessibilidade NEE","val":60,"c":"media"}]'::jsonb,
 '["Versão gratuita","Conta educacional","⚠️ Monitorar viés"]'::jsonb,
 '["badge-arte"]'::jsonb, '["Artes"]'::jsonb, 'Freemium'),
('Scratch','Todas',
 'Programação criativa com blocos. Código aberto, sem coleta de dados comercial. Referência em agência do aluno e pensamento computacional.',
 'Todas','4-9','🐱',true,true,
 'Nível UNESCO: Aprofundar → Criar · Aspecto 3 (Fundamentos e Aplicações)', 4.9::numeric,
 '[{"nome":"Segurança de Dados","val":95,"c":""},{"nome":"Adequação à Faixa Etária","val":95,"c":""},{"nome":"Agência do Aluno","val":98,"c":""},{"nome":"Sem Viés","val":95,"c":""},{"nome":"Transparência","val":90,"c":""},{"nome":"Acessibilidade NEE","val":80,"c":""}]'::jsonb,
 '["100% Gratuito","Código aberto","MIT License","♿ Acessível"]'::jsonb,
 '["badge-todos","badge-open","badge-nee"]'::jsonb, '["Todas as disciplinas","Código Aberto","NEE"]'::jsonb, 'Grátis'),
('Book Creator IA','Português',
 'Criação de livros digitais com suporte de IA. Perfeito para produção textual e narrativas criativas. Recursos de acessibilidade para leitores iniciantes.',
 'Português','1-5','📖',true,false,
 'Nível UNESCO: Adquirir → Aprofundar · Aspecto 4 (Pedagogia da IA)', 4.6::numeric,
 '[{"nome":"Segurança de Dados","val":85,"c":""},{"nome":"Adequação à Faixa Etária","val":92,"c":""},{"nome":"Agência do Aluno","val":95,"c":""},{"nome":"Sem Viés","val":80,"c":""},{"nome":"Transparência","val":75,"c":"media"},{"nome":"Acessibilidade NEE","val":78,"c":"media"}]'::jsonb,
 '["Plano escola","COPPA compliant","Colaborativo","♿ Parcial"]'::jsonb,
 '["badge-port","badge-inc"]'::jsonb, '["Português","Pró-Inclusão"]'::jsonb, 'Freemium'),
('Google Read Along','Português',
 'App de leitura com tutor de IA que ouve a criança ler em voz alta. Foco na alfabetização. Disponível offline e em Português BR.',
 'Português','1-3','📚',true,false,
 'Nível UNESCO: Adquirir · Aspecto 4 (Pedagogia da IA)', 4.4::numeric,
 '[{"nome":"Segurança de Dados","val":68,"c":"media"},{"nome":"Adequação à Faixa Etária","val":90,"c":""},{"nome":"Agência do Aluno","val":80,"c":""},{"nome":"Sem Viés","val":74,"c":"media"},{"nome":"Transparência","val":60,"c":"media"},{"nome":"Acessibilidade NEE","val":75,"c":"media"}]'::jsonb,
 '["Gratuito","Offline","Português BR","♿ Parcial"]'::jsonb,
 '["badge-port","badge-nee"]'::jsonb, '["Português","NEE"]'::jsonb, 'Grátis'),
('Kolibri (LE)','Todas',
 'Plataforma de aprendizagem offline de código aberto, pensada para contextos de baixa conectividade. Sem coleta de dados e totalmente personalizável.',
 'Todas','1-9','🕊️',true,true,
 'Nível UNESCO: Adquirir · Aspecto 5 (Desenvolvimento Profissional)', 4.7::numeric,
 '[{"nome":"Segurança de Dados","val":98,"c":""},{"nome":"Adequação à Faixa Etária","val":90,"c":""},{"nome":"Agência do Aluno","val":85,"c":""},{"nome":"Sem Viés","val":90,"c":""},{"nome":"Transparência","val":95,"c":""},{"nome":"Acessibilidade NEE","val":88,"c":""}]'::jsonb,
 '["100% Gratuito","Código aberto","Funciona offline","♿ Acessível"]'::jsonb,
 '["badge-todos","badge-open","badge-nee","badge-inc"]'::jsonb, '["Todas as disciplinas","Código Aberto","NEE","Pró-Inclusão"]'::jsonb, 'Grátis')
) as novos(nome, categoria, descricao, disciplina, anos, icone, nee, open_source, nivel_unesco, estrelas, criterios, chips, badges, badge_labels, preco)
where not exists (select 1 from glossario g where g.nome = novos.nome);

-- ═══════════════════════════════════
-- 3) REAPONTAR denúncias para o Glossário (em vez do Repositório)
-- ═══════════════════════════════════
alter table denuncias drop constraint if exists denuncias_ferramenta_id_fkey;
alter table denuncias add constraint denuncias_ferramenta_id_fkey
  foreign key (ferramenta_id) references glossario(id) on delete set null;

-- ═══════════════════════════════════
-- 4) REMOVER a antiga tabela de ferramentas (Repositório antigo)
-- ═══════════════════════════════════
drop table if exists ferramentas cascade;

-- ═══════════════════════════════════
-- 5) NOVA TABELA: materiais (Repositório = PDFs, áudios e podcasts)
-- ═══════════════════════════════════
create table if not exists materiais (
  id bigint generated always as identity primary key,
  titulo text not null,
  tipo text not null check (tipo in ('pdf','audio','podcast')),
  disciplina text,
  descricao text,
  arquivo_url text not null,
  arquivo_nome text,
  autor_id uuid references professores(id) on delete set null,
  criado_em timestamptz not null default now()
);

alter table materiais enable row level security;

create policy "qualquer um pode ler materiais"
  on materiais for select
  using (true);

create policy "professor autenticado envia material"
  on materiais for insert
  to authenticated
  with check (auth.uid() = autor_id);

create policy "autor apaga o próprio material"
  on materiais for delete
  to authenticated
  using (auth.uid() = autor_id);

-- ═══════════════════════════════════
-- 6) STORAGE — bucket público para os arquivos dos materiais
-- ═══════════════════════════════════
insert into storage.buckets (id, name, public)
values ('materiais', 'materiais', true)
on conflict (id) do nothing;

create policy "leitura pública dos arquivos de materiais"
  on storage.objects for select
  using (bucket_id = 'materiais');

create policy "professor autenticado envia arquivo de material"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'materiais');

create policy "autor apaga o próprio arquivo de material"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'materiais' and owner = auth.uid());
