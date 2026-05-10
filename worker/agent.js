// Claude Skill Pack — Sub-Agent Worker
// Deployed on skills.shegerpay.com/agent
// Matches user queries to exact Claude Code skill commands

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
  'Content-Type': 'application/json',
};

const KNOWLEDGE = [
  { kw: ['ui','component','button','modal','card','form','interface','screen','design','layout','frontend'],
    skills: ['ts:taste-skill', '/ui', '/impeccable audit', 'ts:redesign-skill', '/dg'],
    reply: 'For UI and design work — start with taste enforcement, then build' },
  { kw: ['review','pr','pull request','check code','code review','audit code'],
    skills: ['coderabbit:code-review', '/review', 'coderabbit:autofix'],
    reply: 'For code review' },
  { kw: ['debug','bug','error','fix','crash','broken','not working','issue'],
    skills: ['superpowers:systematic-debugging', '/investigate', '/health'],
    reply: 'For debugging — use the structured approach' },
  { kw: ['test','qa','testing','playwright','e2e','unit test','spec'],
    skills: ['superpowers:test-driven-development', '/qa', '/playwright-cli', '/qa-only'],
    reply: 'For testing' },
  { kw: ['seo','search engine','meta','sitemap','ranking','traffic','google','optimize'],
    skills: ['/seo', '/seo-audit', '/seo-technical', '/seo-content', '/seo-schema'],
    reply: 'For SEO — start with a full audit' },
  { kw: ['deploy','ship','release','production','push live','go live','launch'],
    skills: ['/guard', '/ship', '/canary', '/land-and-deploy'],
    reply: 'For deploying — always guard-check first' },
  { kw: ['memory','remember','codebase','learn','repo','knowledge','forget'],
    skills: ['claude-mem:learn-codebase', 'claude-mem:mem-search', '/graphify', 'claude-mem:timeline-report'],
    reply: 'For memory and codebase learning' },
  { kw: ['agent','swarm','parallel','multiple tasks','multi','many tasks','automate'],
    skills: ['/50', 'superpowers:dispatching-parallel-agents', '/pair-agent'],
    reply: 'For multi-agent parallel work' },
  { kw: ['plan','architecture','roadmap','spec','structure','system design'],
    skills: ['superpowers:writing-plans', 'superpowers:brainstorming', '/plan'],
    reply: 'For planning before coding' },
  { kw: ['database','supabase','sql','postgres','firestore','firebase','db','query'],
    skills: ['/supabase', '/firebase-basics', '/firebase-auth-basics'],
    reply: 'For database work' },
  { kw: ['stripe','payment','checkout','subscription','billing','pay','invoice'],
    skills: ['/stripe', '/supabase'],
    reply: 'For payment integration' },
  { kw: ['brand','logo','identity','color','palette','typography','visual'],
    skills: ['ts:brandkit', '/canvas-design', 'ts:soft-skill', 'ts:minimalist-skill'],
    reply: 'For branding and visual identity' },
  { kw: ['image','screenshot','photo','generate','picture','graphic'],
    skills: ['ts:imagegen-web', 'ts:image-to-code', '/image-enhancer', 'ts:imagegen-mobile'],
    reply: 'For image work' },
  { kw: ['resume','job','career','cv','interview','apply','hiring'],
    skills: ['/career-ops', '/tailored-resume-generator'],
    reply: 'For career and job search' },
  { kw: ['security','auth','permission','vulnerability','xss','injection','safe'],
    skills: ['/security-review', '/security-best-practices', '/guard'],
    reply: 'For security' },
  { kw: ['animation','motion','transition','gsap','framer','hover','micro'],
    skills: ['/dg', 'ts:gpt-tasteskill', '/remotion'],
    reply: 'For animations and motion design' },
  { kw: ['document','pdf','word','excel','spreadsheet','presentation','slides','report'],
    skills: ['/pdf', '/docx', '/xlsx', '/pptx', '/make-pdf'],
    reply: 'For document creation' },
  { kw: ['plugin','skill','create','build skill','new command'],
    skills: ['plugin-dev:create-plugin', 'plugin-dev:skill-development', '/skill-creator'],
    reply: 'For creating plugins and skills' },
  { kw: ['install','setup','new mac','fresh install','bootstrap'],
    skills: ['curl -fsSL https://raw.githubusercontent.com/black12-ag/claude-skill/main/bootstrap.sh | bash'],
    reply: 'To install all skills on a new machine — run this one command' },
  { kw: ['lsp','autocomplete','language server','typescript','swift','rust','go','python'],
    skills: ['/typescript-lsp', '/swift-lsp', '/rust-analyzer-lsp', '/gopls-lsp', '/pyright-lsp'],
    reply: 'For language server (code intelligence)' },
  { kw: ['all skills','every skill','menu','list','what skills','help'],
    skills: ['/menu', '/auto <describe your task>', 'claude-mem:smart-explore'],
    reply: 'To browse all skills' },
];

function findMatch(query) {
  const q = query.toLowerCase().trim();
  for (const entry of KNOWLEDGE) {
    if (entry.kw.some(k => q.includes(k))) {
      return entry;
    }
  }
  return null;
}

function buildResponse(query) {
  const match = findMatch(query);
  if (match) {
    return {
      success: true,
      query,
      reply: match.reply,
      skills: match.skills,
      tip: 'Type these exact commands in Claude Code after install.',
    };
  }
  return {
    success: true,
    query,
    reply: 'Use the smart auto-router — it picks the best skill for any task',
    skills: [`/auto ${query.slice(0, 60)}`, '/menu'],
    tip: 'Or type /menu in Claude Code to browse all 180+ skills visually.',
  };
}

export default {
  async fetch(request) {
    const url = new URL(request.url);

    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers: CORS });
    }

    // GET /agent?q=build+a+ui
    if (request.method === 'GET' && url.pathname === '/agent') {
      const q = url.searchParams.get('q') || '';
      if (!q) {
        return new Response(JSON.stringify({ error: 'Pass ?q=your+question' }), { status: 400, headers: CORS });
      }
      return new Response(JSON.stringify(buildResponse(q)), { status: 200, headers: CORS });
    }

    // POST /agent  { "query": "..." }
    if (request.method === 'POST' && url.pathname === '/agent') {
      let body;
      try { body = await request.json(); } catch { body = {}; }
      const q = (body.query || '').slice(0, 300);
      if (!q) {
        return new Response(JSON.stringify({ error: 'Send { "query": "your question" }' }), { status: 400, headers: CORS });
      }
      return new Response(JSON.stringify(buildResponse(q)), { status: 200, headers: CORS });
    }

    // GET / — health check
    if (url.pathname === '/' || url.pathname === '/health') {
      return new Response(JSON.stringify({
        name: 'Claude Skill Pack — Skill Agent',
        version: '1.0.0',
        endpoints: { agent_get: 'GET /agent?q=your+question', agent_post: 'POST /agent { "query": "..." }' },
        docs: 'https://github.com/black12-ag/claude-skill',
        site: 'https://skills.shegerpay.com',
      }), { status: 200, headers: CORS });
    }

    return new Response(JSON.stringify({ error: 'Not found' }), { status: 404, headers: CORS });
  },
};
