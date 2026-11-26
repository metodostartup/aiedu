/* NEXORA AI — blocos HTML compartilhados (sidebar, topbar, capas SVG) */
(function () {
  'use strict';

  const ICONES = {
    inicio:'<path d="m3 10 9-7 9 7v10a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z"/>',
    coracao:'<path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7z"/>',
    apps:'<rect x="3" y="3" width="18" height="18" rx="3"/><path d="M3 9h18"/><path d="M9 21V9"/>',
    skills:'<path d="M12 2v4"/><path d="m16.2 7.8 2.9-2.9"/><path d="M18 12h4"/><path d="m16.2 16.2 2.9 2.9"/><path d="M12 18v4"/><path d="m4.9 19.1 2.9-2.9"/><path d="M2 12h4"/><path d="m4.9 4.9 2.9 2.9"/>',
    squads:'<circle cx="9" cy="7" r="4"/><path d="M2 21v-2a4 4 0 0 1 4-4h6a4 4 0 0 1 4 4v2"/><path d="M19 8v6"/><path d="M22 11h-6"/>',
    prompts:'<path d="M14 2v6h6"/><path d="M4 4v16a2 2 0 0 0 2 2h8"/><path d="M14 2l6 6v10a2 2 0 0 1-2 2"/><path d="M8 12h6"/><path d="M8 16h6"/>',
    cinema:'<rect x="2" y="4" width="20" height="14" rx="2"/><path d="M8 21h8"/><path d="m10 9 5 3-5 3z"/>',
    mcps:'<path d="M12 2 2 7l10 5 10-5z"/><path d="m2 17 10 5 10-5"/><path d="m2 12 10 5 10-5"/>',
    guias:'<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 1 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 1 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 1 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9c.22.49.7.86 1.26.97z"/>',
    plantas:'<path d="M12 22v-9"/><path d="M12 13c0-4 3-6 7-6 0 4-3 6-7 6z"/><path d="M12 13c0-4-3-6-7-6 0 4 3 6 7 6z"/>',
    missoes:'<circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="6"/><circle cx="12" cy="12" r="2"/>',
    guardados:'<rect x="3" y="4" width="18" height="16" rx="2"/><path d="M7 4v16l5-3 5 3V4"/>',
    certificados:'<path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>',
    conquistas:'<circle cx="12" cy="8" r="6"/><path d="M15.5 13 17 22l-5-3-5 3 1.5-9"/>'
  };

  function icones(nome) { return '<svg viewBox="0 0 24 24" aria-hidden="true">' + (ICONES[nome] || '') + '</svg>'; }

  const NAV = [
    { href:'index.html',     ic:'inicio',      t:'Início' },
    { href:'mais-curtidos.html', ic:'coracao', t:'Mais curtidos' },
    { sec:'Bibliotecas' },
    { href:'aplicativos.html', ic:'apps',    t:'Aplicativos' },
    { href:'skills.html',    ic:'skills',      t:'Skills' },
    { href:'squads.html',    ic:'squads',      t:'Squads' },
    { href:'prompts.html',   ic:'prompts',     t:'Prompts', count:'48' },
    { href:'cinema.html',    ic:'cinema',      t:'Cinema' },
    { href:'mcps.html',      ic:'mcps',        t:'Conexões e MCPs' },
    { href:'guias.html',     ic:'guias',       t:'Guias e tutoriais' },
    { href:'plantas.html',   ic:'plantas',     t:'Plantas' },
    { sec:'Percurso do aluno' },
    { href:'missoes.html',   ic:'missoes',     t:'Missões e progresso', count:'0/12' },
    { href:'cursos.html',    ic:'guardados',   t:'Cursos guardados', count:'3' },
    { href:'certificados.html', ic:'conquistas', t:'Certificados', count:'2' },
    { href:'conquistas.html', ic:'conquistas',  t:'Conquistas' }
  ];

  function capasSVG(kind, titulo) {
    const G = {
      synth:`<rect width="400" height="132" fill="url(#ceu1)"/><circle cx="200" cy="86" r="34" fill="#f3c6ff" opacity=".9"/><g fill="#2a0838"><path d="M0 112 L70 62 L130 112 Z"/><path d="M90 112 L180 44 L268 112 Z"/><path d="M230 112 L310 58 L400 112 Z"/></g><rect y="110" width="400" height="22" fill="#160a1c"/>`,
      onda:`<rect width="400" height="132" fill="#12061a"/><g fill="none" stroke-linecap="round"><path d="M-20 95 C 90 30, 180 130, 260 70 S 400 20, 430 60" stroke="url(#fita2)" stroke-width="14" opacity=".9"/><path d="M-20 85 C 80 20, 170 118, 250 58 S 400 8, 430 48" stroke="#d9cfe3" stroke-width="2.2" opacity=".5"/></g><circle cx="260" cy="70" r="7" fill="#fff"/>`,
      portal:`<rect width="400" height="132" fill="#160a1c"/><circle cx="200" cy="66" r="58" fill="url(#portal3)" opacity=".85"/><g fill="none" stroke="#d9a8ff" stroke-opacity=".5"><ellipse cx="200" cy="66" rx="88" ry="30" transform="rotate(-18 200 66)"/></g><circle cx="292" cy="42" r="5" fill="#e6c8ff"/>`,
      maleta:`<rect width="400" height="132" fill="#12061a"/><path d="M172 52 v-10 a10 10 0 0 1 10-10 h36 a10 10 0 0 1 10 10 v10" fill="none" stroke="#d9a8ff" stroke-width="6" opacity=".8"/><rect x="140" y="52" width="120" height="66" rx="12" fill="url(#maleta4)" stroke="#a23cff" stroke-opacity=".6"/><circle cx="262" cy="52" r="17" fill="#c026d3"/><path d="m254 52 6 6 11-12" fill="none" stroke="#fff" stroke-width="3.4" stroke-linecap="round"/>`,
      bussola:`<rect width="400" height="132" fill="#160a1c"/><circle cx="200" cy="66" r="52" fill="#1d0d23" stroke="#a23cff" stroke-opacity=".7" stroke-width="2.5"/><path d="M200 34 214 66 200 98 186 66 Z" fill="url(#agulha5)"/><circle cx="200" cy="66" r="5" fill="#fff"/>`,
      checklist:`<rect width="400" height="132" fill="#12061a"/><rect x="146" y="28" width="92" height="82" rx="10" fill="#1d0d23" stroke="#a23cff" stroke-opacity=".55"/><g stroke="#d9a8ff" stroke-width="3" fill="none" stroke-linecap="round"><path d="m158 48 5 5 9-10"/><path d="m158 70 5 5 9-10"/><path d="m158 92 5 5 9-10"/></g><path d="M292 40 l7 18 18 7 -18 7 -7 18 -7 -18 -18 -7 18 -7 Z" fill="url(#brilho6)"/>`
    };
    return '<svg viewBox="0 0 400 132" preserveAspectRatio="xMidYMid slice" role="img" aria-label="' + (titulo || 'Capa') + '">' + (G[kind] || G.onda) + '<rect width="400" height="132" filter="url(#grao)"/></svg>';
  }

  window.CAPAS = ['synth','onda','portal','maleta','bussola','checklist'];
  window.capaSVG = capasSVG;

  document.addEventListener('DOMContentLoaded', () => {
    const ativo = document.body.dataset.pagina;

    /* sidebar */
    const side = document.getElementById('sidebar');
    if (side) {
      side.innerHTML = NAV.map(n => n.sec
        ? '<div class="slabel">' + n.sec + '</div>'
        : '<a class="sitem' + (n.href === ativo ? ' active" aria-current="page' : '') + '" href="' + n.href + '"' + (side.classList.contains('compacta') ? ' data-tip="' + n.t + '"' : '') + '>' + icones(n.ic) + '<span>' + n.t + '</span>' + (n.count ? '<span class="count">' + n.count + '</span>' : '') + '</a>'
      ).join('') +
      '<div class="spacer"></div>' +
      '<div class="box-nivel"><svg class="ring" viewBox="0 0 34 34"><circle class="fundo" cx="17" cy="17" r="14"/><circle class="valor" cx="17" cy="17" r="14" stroke-dasharray="88" stroke-dashoffset="78"/></svg><div><b>Nível 1 — Recruta</b><span>Complete 12 missões para subir</span></div></div>';
    }

    /* topbar */
    const top = document.getElementById('topbar');
    if (top) {
      const onde = top.dataset.onde || '';
      top.innerHTML =
        '<div class="brand">' +
          '<button class="ic-btn menu-hamb" aria-label="Abrir menu">☰</button>' +
          '<a class="logo-badge" href="index.html"><span class="spark">✦</span>NEXORA AI</a>' +
          '<span class="onde">/ <em>' + onde + '</em></span>' +
        '</div>' +
        '<label class="busca"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round"><circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/></svg>' +
        '<input type="search" placeholder="Pesquisar cursos, prompts, skills…" aria-label="Pesquisar na plataforma"><span class="kbd">/</span></label>' +
        '<div class="userbox">' +
          '<button class="ic-btn" data-menu="menu-notif" aria-label="Notificações">🔔<span class="bola"></span></button>' +
          '<div class="menu-perfil" id="menu-notif"><a href="#">🎉 Nova masterclass amanhã às 19h</a><a href="#">✅ Missão “Assistir a 3 aulas” em progresso</a><a href="#">🏅 Certificado disponível: Fundamentos de IA</a></div>' +
          '<div class="xp-meta"><div class="nivel">Recruta</div><div class="trilha"><i style="width:12%"></i></div><div class="pontos">0 / 100 XP</div></div>' +
          '<button class="avatar" data-menu="menu-perfil" aria-label="Menu do perfil">JM</button>' +
          '<div class="menu-perfil" id="menu-perfil"><a href="#">Perfil</a><a href="missoes.html">Meu progresso</a><a href="certificados.html">Certificados</a><div class="sep"></div><button>Modo escuro ✓</button><button>Sair</button></div>' +
        '</div>';
    }
  });
})();
