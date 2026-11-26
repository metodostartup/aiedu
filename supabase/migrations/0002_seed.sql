-- ============================================================
-- NEXORA AI — Seed inicial (idempotente: pode rodar N vezes)
-- ============================================================

-- cursos (espelham window.DEMO do front)
insert into public.cursos (slug,titulo,descricao,categoria,nivel,duracao_min,autor,nota,alunos,capa) values
 ('fundamentos','Fundamentos da Inteligência Artificial','Conceitos essenciais, modelos, limites e boas práticas para começar com o pé direito.','Fundamentos de IA','Iniciante',260,'Marina Costa',4.9,12400,'synth'),
 ('prompts','Engenharia de Prompts na Prática','Estruture prompts avançados com papéis, contexto, exemplos e avaliação.','Prompt Engineering','Iniciante',185,'Rafael Lima',4.8,9800,'onda'),
 ('chatgpt','ChatGPT para Produtividade','Rotinas de trabalho aceleradas com ChatGPT: e-mails, resumos, planos e relatórios.','Produtividade','Iniciante',130,'Ana Duarte',4.9,15100,'portal'),
 ('automacao','Automação com IA','Conecte IAs a webhooks, planilhas e CRMs e deixe o trabalho repetitivo por conta delas.','Automação','Intermédio',340,'Pedro Nunes',4.7,6200,'maleta'),
 ('conteudo','Criação de Conteúdo com IA','Posts, roteiros e newsletters gerados com sua própria voz de marca.','Marketing','Intermédio',210,'Bianca Rocha',4.8,8700,'bussola'),
 ('agentes','Agentes Autónomos','Agentes que planejam, usam ferramentas e executam tarefas de ponta a ponta.','Automação','Avançado',410,'Marina Costa',4.9,4300,'checklist'),
 ('negocios','IA para Negócios','Mapeie oportunidades, estime ROI e monte o plano de adoção de IA da empresa.','Negócios','Intermédio',245,'Carlos Meireles',4.6,5900,'maleta'),
 ('workflows','Construção de Workflows Inteligentes','Workflows com condições, memória e qualidade validada por avaliadores automáticos.','Automação','Avançado',315,'Pedro Nunes',4.8,3800,'onda')
on conflict (slug) do nothing;

-- skills
insert into public.skills (slug,nome,descricao,icone,aulas) values
 ('escrita','Escrita com IA','Textos claros e persuasivos com LLMs.','✍️',22),
 ('pesquisa','Pesquisa e análise','Sínteses e leitura crítica de fontes.','🔎',18),
 ('automacao','Automação','Workflows e agentes conectados.','⚡',26),
 ('design','Design generativo','Imagens e identidade visual com IA.','🎨',15),
 ('video','Vídeo com IA','Roteiro, edição e pós com IA.','🎬',19),
 ('audio','Áudio e voz','Clonagem, narração e dublagem.','🎙️',11),
 ('programacao','Programação com IA','Code review, testes e refactors.','💻',24),
 ('estrategia','Estratégia e negócios','Roadmaps e casos de uso com ROI.','📈',16)
on conflict (slug) do nothing;

-- prompts públicos (sem duplicar por título)
insert into public.prompts (categoria,titulo,conteudo,modelo,nivel,nota,autor)
select * from (values
 ('Copywriting','Estrutura AIDA em 30 segundos','Aja como um copywriter sênior. Crie um anúncio seguindo AIDA para o produto abaixo, com 3 variações de headline…','ChatGPT · GPT-4.1','Iniciante',4.9,'Marina Costa'),
 ('Produtividade','Resumo de reunião com action items','Resuma esta transcrição em decisões, responsáveis e prazos. Formato: tabela markdown…','ChatGPT · GPT-4.1','Iniciante',4.8,'Rafael Lima'),
 ('Marketing','Calendário de conteúdo mensal','Monte um calendário de 30 dias para Instagram + LinkedIn sobre o tema X, com gancho, formato e CTA…','Claude','Intermédio',4.7,'Bianca Rocha'),
 ('Programação','Revisão de código com checklist','Revise o código abaixo procurando bugs, riscos de segurança e pontos de complexidade. Priorize…','GPT · Claude','Avançado',4.9,'Pedro Nunes'),
 ('Vendas','Follow-up que responde','Escreva 3 follow-ups curtos e humanos para um orçamento enviado há 5 dias, sem soar desesperado…','ChatGPT · GPT-4.1','Iniciante',4.6,'Carlos Meireles'),
 ('Design','Briefing visual para gerador de imagens','Descreva uma cena com iluminação suave, lente 35mm, paleta análoga e foco no produto…','Midjourney','Intermédio',4.8,'Bianca Rocha')
) as v(categoria,titulo,conteudo,modelo,nivel,nota,autor)
where not exists (select 1 from public.prompts p where p.titulo = v.titulo);

-- squads
insert into public.squads (slug,nome,descricao,nivel,capa) values
 ('marketing-ia','Comercial com IA','Do roteiro ao comercial pronto.','Iniciante','synth'),
 ('editor-vsl','Editor de VSL','A VSL editada do bruto ao final.','Intermédio','onda'),
 ('piloto-automatico','Marketing no Piloto Automático','Posts criados e agendados.','Iniciante','portal'),
 ('cacador-clientes','Caçador de Clientes','Acha quem precisa do seu serviço.','Intermédio','maleta'),
 ('espiao-concorrentes','Espião de Concorrentes','O que funciona para eles.','Intermédio','bussola'),
 ('conselho','Conselho de Mentes Brilhantes','Decisões com outras cabeças.','Avançado','checklist')
on conflict (slug) do nothing;

-- squad_cursos: squad 'marketing-ia' usa os cursos de base (idempotente)
insert into public.squad_cursos (squad_id, curso_id)
select s.id, c.id from public.squads s, public.cursos c
where s.slug = 'marketing-ia' and c.slug in ('fundamentos','conteudo','prompts')
on conflict do nothing;

-- aplicativos
insert into public.aplicativos (slug,nome,categoria,descricao,nota,preco,dificuldade,url) values
 ('chatgpt','ChatGPT','Assistente','O assistente de propósito geral da OpenAI.',4.9,'Grátis · Plus $20','Iniciante','https://chat.openai.com'),
 ('claude','Claude','Assistente','Forte em análise longa e escrita.',4.8,'Grátis · Pro $20','Iniciante','https://claude.ai'),
 ('midjourney','Midjourney','Imagem','Geração de imagens com direção de arte.',4.7,'a partir de $10','Intermédio','https://midjourney.com'),
 ('n8n','n8n','Automação','Workflows self-hosted com nós de IA.',4.6,'Self-hosted grátis','Avançado','https://n8n.io'),
 ('elevenlabs','ElevenLabs','Voz','Narração e clonagem de voz realista.',4.8,'Grátis · a partir de $5','Iniciante','https://elevenlabs.io'),
 ('perplexity','Perplexity','Pesquisa','Busca com respostas citadas.',4.7,'Grátis · Pro $20','Iniciante','https://perplexity.ai')
on conflict (slug) do nothing;

-- missões da semana atual (idempotente por título+semana)
insert into public.missoes (titulo,descricao,meta,xp)
select * from (values
 ('Assistir a 3 aulas','Assista qualquer 3 aulas esta semana',3,50),
 ('Criar o primeiro prompt avançado','Salve um prompt com papel+contexto+formato',1,80),
 ('Concluir uma skill','Complete a trilha de uma skill',1,120),
 ('Guardar 5 prompts','Favoritos em Prompts',5,40),
 ('Criar um projeto com IA','Publique um projeto na plataforma',1,200)
) as v(titulo,descricao,meta,xp)
where not exists (select 1 from public.missoes m where m.titulo = v.titulo and m.semana = date_trunc('week', now()));
