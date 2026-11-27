/* AI Edu — interações globais compartilhadas */
(function () {
  'use strict';

  /* ---------- dados de demonstração ---------- */
  window.DEMO = {
    cursos: [
      { id:'fundamentos', cat:'Fundamentos de IA', tit:'Fundamentos da Inteligência Artificial', desc:'Conceitos essenciais, modelos, limites e boas práticas para começar com o pé direito.', nivel:'Iniciante', aulas:14, dur:'4h 20m', prog:72, nota:4.9, alunos:'12.4k', autor:'Marina Costa' },
      { id:'prompts', cat:'Prompt Engineering', tit:'Engenharia de Prompts na Prática', desc:'Estruture prompts avançados com papéis, contexto, exemplos e avaliação.', nivel:'Iniciante', aulas:10, dur:'3h 05m', prog:41, nota:4.8, alunos:'9.8k', autor:'Rafael Lima' },
      { id:'chatgpt', cat:'Produtividade', tit:'ChatGPT para Produtividade', desc:'Rotinas de trabalho aceleradas com ChatGPT: e-mails, resumos, planos e relatórios.', nivel:'Iniciante', aulas:8, dur:'2h 10m', prog:100, nota:4.9, alunos:'15.1k', autor:'Ana Duarte' },
      { id:'automacao', cat:'Automação', tit:'Automação com IA', desc:'Conecte IAs a webhooks, planilhas e CRMs e deixe o trabalho repetitivo por conta delas.', nivel:'Intermédio', aulas:12, dur:'5h 40m', prog:15, nota:4.7, alunos:'6.2k', autor:'Pedro Nunes' },
      { id:'conteudo', cat:'Marketing', tit:'Criação de Conteúdo com IA', desc:'Posts, roteiros e newsletters gerados com sua própria voz de marca.', nivel:'Intermédio', aulas:9, dur:'3h 30m', prog:0, nota:4.8, alunos:'8.7k', autor:'Bianca Rocha' },
      { id:'agentes', cat:'Automação', tit:'Agentes Autónomos', desc:'Agentes que planejam, usam ferramentas e executam tarefas de ponta a ponta.', nivel:'Avançado', aulas:16, dur:'6h 50m', prog:0, nota:4.9, alunos:'4.3k', autor:'Marina Costa' },
      { id:'negocios', cat:'Negócios', tit:'IA para Negócios', desc:'Mapeie oportunidades, estime ROI e monte o plano de adoção de IA da empresa.', nivel:'Intermédio', aulas:11, dur:'4h 05m', prog:0, nota:4.6, alunos:'5.9k', autor:'Carlos Meireles' },
      { id:'workflows', cat:'Automação', tit:'Construção de Workflows Inteligentes', desc:'Workflows com condições, memória e qualidade validada por avaliadores automáticos.', nivel:'Avançado', aulas:13, dur:'5h 15m', prog:0, nota:4.8, alunos:'3.8k', autor:'Pedro Nunes' }
    ],
    prompts: [
      { id:'p1', cat:'Copywriting', tit:'Estrutura AIDA em 30 segundos', prev:'Aja como um copywriter sênior. Crie um anúncio seguindo AIDA para o produto abaixo, com 3 variações de headline…', modelo:'ChatGPT · GPT-4.1', nivel:'Iniciante', nota:4.9, autor:'Marina Costa' },
      { id:'p2', cat:'Produtividade', tit:'Resumo de reunião com action items', prev:'Resuma esta transcrição em decisões, responsáveis e prazos. Formato: tabela markdown com colunas…', modelo:'ChatGPT · GPT-4.1', nivel:'Iniciante', nota:4.8, autor:'Rafael Lima' },
      { id:'p3', cat:'Marketing', tit:'Calendário de conteúdo mensal', prev:'Monte um calendário de 30 dias para Instagram + LinkedIn sobre o tema X, com gancho, formato e CTA…', modelo:'Claude', nivel:'Intermédio', nota:4.7, autor:'Bianca Rocha' },
      { id:'p4', cat:'Programação', tit:'Revisão de código com checklist', prev:'Revise o código abaixo procurando bugs, riscos de segurança e pontos de complexidade. Priorize…', modelo:'GPT · Claude', nivel:'Avançado', nota:4.9, autor:'Pedro Nunes' },
      { id:'p5', cat:'Vendas', tit:'Follow-up que responde', prev:'Escreva 3 follow-ups curtos e humanos para um orçamento enviado há 5 dias, sem soar desesperado…', modelo:'ChatGPT · GPT-4.1', nivel:'Iniciante', nota:4.6, autor:'Carlos Meireles' },
      { id:'p6', cat:'Design', tit:'Briefing visual para gerador de imagens', prev:'Descreva uma cena com iluminação suave, lente 35mm, paleta análoga e foco no produto…', modelo:'Midjourney', nivel:'Intermédio', nota:4.8, autor:'Bianca Rocha' }
    ],
    skills: [
      { id:'s1', nome:'Escrita com IA', desc:'Textos claros e persuasivos com LLMs.', dominio:86, aulas:22, ico:'✍️' },
      { id:'s2', nome:'Pesquisa e análise', desc:'Sínteses e leitura crítica de fontes.', dominio:54, aulas:18, ico:'🔎' },
      { id:'s3', nome:'Automação', desc:'Workflows e agentes conectados.', dominio:31, aulas:26, ico:'⚡' },
      { id:'s4', nome:'Design generativo', desc:'Imagens e identidade visual com IA.', dominio:47, aulas:15, ico:'🎨' },
      { id:'s5', nome:'Vídeo com IA', desc:'Roteiro, edição e pós com IA.', dominio:22, aulas:19, ico:'🎬' },
      { id:'s6', nome:'Áudio e voz', desc:'Clonagem, narração e dublagem.', dominio:12, aulas:11, ico:'🎙️' },
      { id:'s7', nome:'Programação com IA', desc:'Code review, testes e refactors.', dominio:39, aulas:24, ico:'💻' },
      { id:'s8', nome:'Estratégia e negócios', desc:'Roadmaps e casos de uso com ROI.', dominio:58, aulas:16, ico:'📈' }
    ],
    squads: [
      { id:'q1', nome:'Marketing com IA', desc:'Campanhas, conteúdo e funil.', cursos:6, nivel:'Iniciante' },
      { id:'q2', nome:'Automação', desc:'Workflows e agentes em produção.', cursos:8, nivel:'Avançado' },
      { id:'q3', nome:'Criação de Conteúdo', desc:'Roteiros, posts e newsletters.', cursos:5, nivel:'Iniciante' },
      { id:'q4', nome:'Produtividade', desc:'Rotinas pessoais aceleradas.', cursos:4, nivel:'Iniciante' },
      { id:'q5', nome:'Programação com IA', desc:'Dev assistido por LLMs.', cursos:7, nivel:'Intermédio' },
      { id:'q6', nome:'Negócios Inteligentes', desc:'Estratégia e operação com IA.', cursos:6, nivel:'Intermédio' }
    ],
    apps: [
      { id:'a1', nome:'ChatGPT', cat:'Assistente', desc:'O assistente de propósito geral da OpenAI.', nota:4.9, preco:'Grátis · Plus $20', dificuldade:'Iniciante' },
      { id:'a2', nome:'Claude', cat:'Assistente', desc:'Forte em análise longa e escrita.', nota:4.8, preco:'Grátis · Pro $20', dificuldade:'Iniciante' },
      { id:'a3', nome:'Midjourney', cat:'Imagem', desc:'Geração de imagens com direção de arte.', nota:4.7, preco:'a partir de $10', dificuldade:'Intermédio' },
      { id:'a4', nome:'n8n', cat:'Automação', desc:'Workflows self-hosted com nós de IA.', nota:4.6, preco:'Self-hosted grátis', dificuldade:'Avançado' },
      { id:'a5', nome:'ElevenLabs', cat:'Voz', desc:'Narração e clonagem de voz realista.', nota:4.8, preco:'Grátis · a partir de $5', dificuldade:'Iniciante' },
      { id:'a6', nome:'Perplexity', cat:'Pesquisa', desc:'Busca com respostas citadas.', nota:4.7, preco:'Grátis · Pro $20', dificuldade:'Iniciante' }
    ],
    missoes: [
      { id:'m1', tit:'Assistir a 3 aulas', prog:2, meta:3, xp:50, estado:'Em andamento' },
      { id:'m2', tit:'Criar o primeiro prompt avançado', prog:0, meta:1, xp:80, estado:'Não iniciada' },
      { id:'m3', tit:'Concluir uma skill', prog:1, meta:1, xp:120, estado:'Completa' },
      { id:'m4', tit:'Guardar 5 prompts', prog:3, meta:5, xp:40, estado:'Em andamento' },
      { id:'m5', tit:'Criar um projecto com IA', prog:0, meta:1, xp:200, estado:'Não iniciada' }
    ]
  };

  /* ---------- utilidades ---------- */
  const $ = (s, r) => (r || document).querySelector(s);
  const $$ = (s, r) => Array.from((r || document).querySelectorAll(s));

  window.toast = function (msg, tipo) {
    let t = $('.toast');
    if (!t) { t = document.createElement('div'); t.className = 'toast'; document.body.appendChild(t); }
    t.textContent = msg;
    t.className = 'toast show ' + (tipo || 'ok');
    clearTimeout(t._timer);
    t._timer = setTimeout(() => t.classList.remove('show'), 2600);
  };

  window.confete = function () {
    const c = document.createElement('div'); c.className = 'confete';
    for (let i = 0; i < 40; i++) {
      const p = document.createElement('i');
      p.style.left = Math.random() * 100 + 'vw';
      p.style.animationDelay = Math.random() * .5 + 's';
      p.style.transform = 'rotate(' + Math.random() * 360 + 'deg)';
      c.appendChild(p);
    }
    document.body.appendChild(c);
    setTimeout(() => c.remove(), 2400);
  };

  /* ---------- copiar ---------- */
  document.addEventListener('click', async (e) => {
    const b = e.target.closest('[data-copiar]');
    if (!b) return;
    const txt = b.getAttribute('data-copiar') || b.closest('.card, .prompt-box, tr, li')?.querySelector('.prev-prompt, pre, code')?.textContent || '';
    try { await navigator.clipboard.writeText(txt); toast('Prompt copiado para a área de transferência ✓'); }
    catch { toast('Não foi possível copiar automaticamente', 'err'); }
  });

  /* ---------- favoritos ---------- */
  document.addEventListener('click', (e) => {
    const b = e.target.closest('.btn-fav');
    if (!b) return;
    b.classList.toggle('ativo');
    const on = b.classList.contains('ativo');
    b.setAttribute('aria-pressed', on);
    b.textContent = on ? '♥' : '♡';
    toast(on ? 'Adicionado aos guardados ♥' : 'Removido dos guardados');
  });

  /* ---------- tabs ---------- */
  document.addEventListener('click', (e) => {
    const chip = e.target.closest('.tabs .chip');
    if (!chip) return;
    $$('.tabs .chip', chip.parentElement).forEach(c => c.classList.remove('ativo'));
    chip.classList.add('ativo');
    const alvo = chip.dataset.tab;
    $$('.tab-conteudo').forEach(t => t.hidden = t.dataset.tab !== alvo);
  });

  /* ---------- chips de filtro (data-filtro) ---------- */
  document.addEventListener('click', (e) => {
    const chip = e.target.closest('.filtros .chip[data-valor]');
    if (!chip) return;
    const grupo = chip.closest('.filtros');
    $$('[data-valor]', grupo).forEach(c => c.classList.remove('ativo'));
    chip.classList.add('ativo');
    document.dispatchEvent(new CustomEvent('filtro:mudou', { detail: { grupo: grupo.id, valor: chip.dataset.valor } }));
  });

  /* ---------- modais ---------- */
  document.addEventListener('click', (e) => {
    const abre = e.target.closest('[data-modal]');
    if (abre) { $('#' + abre.dataset.modal)?.classList.add('aberto'); return; }
    if (e.target.closest('[data-fechar]') || e.target.classList.contains('modal-fundo')) {
      $$('.modal-fundo.aberto').forEach(m => m.classList.remove('aberto'));
    }
  });
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') $$('.modal-fundo.aberto').forEach(m => m.classList.remove('aberto'));
  });

  /* ---------- menu de perfil / notificações ---------- */
  document.addEventListener('click', (e) => {
    const toggle = e.target.closest('[data-menu]');
    if (toggle) { $('#' + toggle.dataset.menu)?.classList.toggle('aberto'); return; }
    if (!e.target.closest('.menu-perfil')) $$('.menu-perfil.aberto').forEach(m => m.classList.remove('aberto'));
  });

  /* ---------- sidebar: compacta + mobile ---------- */
  document.addEventListener('click', (e) => {
    if (e.target.closest('.menu-hamb')) { $('.side')?.classList.toggle('aberta'); }
    if (e.target.closest('[data-compactar]')) { $('.side')?.classList.toggle('compacta'); document.body.classList.toggle('compacta-side'); }
    if (e.target.closest('.side.aberta .sitem')) { $('.side').classList.remove('aberta'); }
  });

  /* ---------- barras animam quando entram na tela ---------- */
  const io = new IntersectionObserver((ents) => {
    ents.forEach(en => { if (en.isIntersecting) { const i = en.target; i.style.width = i.dataset.largura || i.style.width; io.unobserve(i); } });
  }, { threshold: .4 });
  $$('.barra i').forEach(i => { i.dataset.largura = i.style.width; i.style.width = '0'; io.observe(i); });

  /* ---------- busca global simples ---------- */
  document.addEventListener('input', (e) => {
    if (!e.target.matches('.busca input')) return;
    document.dispatchEvent(new CustomEvent('busca:mudou', { detail: { q: e.target.value.toLowerCase() } }));
  });
})();
