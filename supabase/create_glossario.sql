-- Tabela do Glossário de IAs (catálogo informativo, separado do repositório curado)
-- Rode este script ANTES do seed_glossario.sql

create table glossario (
  id bigint generated always as identity primary key,
  nome text not null,
  categoria text not null default 'Diversas',
  descricao text not null,
  criado_em timestamptz not null default now()
);

alter table glossario enable row level security;

create policy "qualquer um pode ler o glossário"
  on glossario for select
  using (true);

create policy "professor autenticado pode sugerir entrada"
  on glossario for insert
  to authenticated
  with check (true);
