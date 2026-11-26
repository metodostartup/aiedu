/* NEXORA AI — cliente Supabase (browser)
   Requer: config.js com window.NEXORA_CONFIG = { url, anonKey }  (NUNCA a service_role aqui) */
(function () {
  'use strict';
  if (!window.NEXORA_CONFIG || !window.NEXORA_CONFIG.url || !window.NEXORA_CONFIG.anonKey) {
    console.warn('[NEXORA] Preencha config.js com a URL e a anon key do projeto Supabase.');
    return;
  }
  const client = supabase.createClient(window.NEXORA_CONFIG.url, window.NEXORA_CONFIG.anonKey);
  window.db = client;

  /* ---------- sessão ---------- */
  window.auth = {
    async inscrever(email, senha, nome) {
      const { data, error } = await client.auth.signUp({
        email, password: senha,
        options: { data: { nome } }   // vai para perfis.nome pelo trigger
      });
      if (error) throw error; return data;
    },
    async entrar(email, senha) {
      const { data, error } = await client.auth.signInWithPassword({ email, password: senha });
      if (error) throw error; return data;
    },
    async sair() { await client.auth.signOut(); },
    async usuario() { const { data } = await client.auth.getUser(); return data?.user || null; }
  };

  /* ---------- catálogo (leitura) ---------- */
  window.catalogo = {
    async cursos()    { return (await client.from('cursos').select('*').eq('ativo', true).order('nota', { ascending: false })).data || []; },
    async skills()    { return (await client.from('skills').select('*').order('nome')).data || []; },
    async prompts()   { return (await client.from('prompts').select('*').eq('publico', true).order('nota', { ascending: false })).data || []; },
    async squads()    { return (await client.from('squads').select('*, squad_cursos(curso_id)')).data || []; },
    async apps()      { return (await client.from('aplicativos').select('*').order('nota', { ascending: false })).data || []; },
    async missoes()   { return (await client.from('missoes').select('*').order('xp')).data || []; },
    async cursoCompleto(slug) {
      const { data: c } = await client.from('cursos').select('*, modulos(*, aulas(*))').eq('slug', slug).single();
      return c;
    }
  };

  /* ---------- progresso (escrita com RLS: só o dono) ---------- */
  window.progresso = {
    async iniciarCurso(cursoId) {
      const u = (await client.auth.getUser()).data.user;
      return client.from('inscricoes').upsert({ usuario_id: u.id, curso_id: cursoId }, { onConflict: 'usuario_id,curso_id' });
    },
    async concluirAula(aulaId) {
      const u = (await client.auth.getUser()).data.user;
      return client.from('aulas_concluidas').insert({ usuario_id: u.id, aula_id: aulaId });
    },
    async salvarPrompt(promptId) {
      const u = (await client.auth.getUser()).data.user;
      return client.from('prompts_salvos').insert({ usuario_id: u.id, prompt_id: promptId });
    },
    async favoritar(itemTipo, itemId) {
      const u = (await client.auth.getUser()).data.user;
      return client.from('favoritos').insert({ usuario_id: u.id, item_tipo: itemTipo, item_id: itemId });
    },
    async concluirMissao(missaoId) {
      const u = (await client.auth.getUser()).data.user;
      return client.from('missao_progresso').upsert(
        { usuario_id: u.id, missao_id: missaoId, concluida: true },
        { onConflict: 'usuario_id,missao_id' }
      );
    },
    async meuPerfil() {
      const u = (await client.auth.getUser()).data.user;
      return (await client.from('perfis').select('*').eq('id', u.id).single()).data;
    },
    async meusCursos() {
      const u = (await client.auth.getUser()).data.user;
      return (await client.from('inscricoes').select('progresso_pct, cursos(*)').eq('usuario_id', u.id)).data || [];
    },
    async certificados() {
      const u = (await client.auth.getUser()).data.user;
      return (await client.from('certificados').select('*, cursos(titulo)').eq('usuario_id', u.id)).data || [];
    }
  };

  /* ---------- promoção de dados demo → banco (login opcional) ---------- */
  // Se não houver sessão, o front segue com window.DEMO; com sessão, hydramos do banco.
  document.addEventListener('DOMContentLoaded', async () => {
    const u = (await client.auth.getUser()).data?.user;
    if (u) window.dbUser = u;
  });
})();
