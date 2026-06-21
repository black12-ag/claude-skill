import fs from 'fs';
import { execSync } from 'child_process';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const rootDir = path.resolve(__dirname, '..');

const templatePath = path.join(rootDir, 'templates/cv-template.html');
const template = fs.readFileSync(templatePath, 'utf-8');

const jobs = [
  {
    company: 'Deepgram',
    role: 'Backend Voice Agent',
    format: 'letter',
    summary: 'Full-Stack Software Engineer & Tech Entrepreneur specialized in building scalable backend systems, inference services, and voice-agent pipelines using TypeScript, Python, and C/C++. Proven track record of orchestrating AI models for low-latency concurrent workloads. Built and scaled interactive platforms. Now applying systems thinking to robust inference infrastructure at Deepgram.',
    competencies: ['Python & C++', 'Model Orchestration', 'Low-Latency Systems', 'Voice AI/Inference', 'Network & API Design', 'Concurrent Workloads'],
    projects: `
      <div class="project-item">
        <div class="project-header">
          <h3 class="project-title">Interactive 3D Developer Portfolio</h3>
          <span class="project-link"><a href="https://portfolio.ethio-viral.com">portfolio.ethio-viral.com</a></span>
        </div>
        <ul class="bullet-list">
          <li>Engineered a high-performance interactive developer portfolio using React and TypeScript.</li>
          <li>Integrated automated CI/CD pipelines via GitHub Actions for continuous deployment.</li>
        </ul>
      </div>
      <div class="project-item">
        <div class="project-header">
          <h3 class="project-title">Ethio Viral — AI Content Platform</h3>
        </div>
        <ul class="bullet-list">
          <li>Built a scalable backend platform that uses AI for image and video generation at scale.</li>
          <li>Engineered high-fidelity AI prompts to automate creative asset production efficiently.</li>
        </ul>
      </div>
    `,
    experience: `
      <div class="experience-item">
        <div class="experience-header">
          <h3 class="job-title">Lead Developer <span class="company-name">@ ShegerPay</span></h3>
          <span class="job-date">Current</span>
        </div>
        <ul class="bullet-list">
          <li>Architected the full fintech backend platform from scratch, handling concurrent transaction success metrics.</li>
          <li>Integrated multi-provider payment gateways with robust REST APIs and high-availability webhooks.</li>
        </ul>
      </div>
      <div class="experience-item">
        <div class="experience-header">
          <h3 class="job-title">Lead Developer <span class="company-name">@ Vehicle Inspection & OCR</span></h3>
          <span class="job-date">Previous</span>
        </div>
        <ul class="bullet-list">
          <li>Built a remote inspection system processing real-time USB camera feeds using computer vision and OCR.</li>
          <li>Designed low-latency cross-referencing tools for payment verification data streams.</li>
        </ul>
      </div>
    `
  },
  {
    company: 'Deepgram',
    role: 'Software Engineer Restaurants',
    format: 'letter',
    summary: 'Full-Stack Software Engineer & Tech Entrepreneur specialized in building scalable backend infrastructure and AI-driven automation for enterprise systems. Extensive experience with API design and integrating 3rd-party POS gateways. Built and sold robust payment platforms. Now focused on optimizing resilient voice pipelines and LLM deployments for restaurant tech at Deepgram.',
    competencies: ['Backend Infrastructure', 'Scalable Systems', 'API Design & Integration', 'AWS / Cloud', 'POS Integrations', 'Python / Kotlin'],
    projects: `
      <div class="project-item">
        <div class="project-header">
          <h3 class="project-title">ShegerPay — Fintech Platform</h3>
        </div>
        <ul class="bullet-list">
          <li>Architected the full platform from scratch, including a merchant dashboard for tracking revenue.</li>
          <li>Integrated multi-provider payment gateways including live ETB/USD currency conversion via APIs.</li>
        </ul>
      </div>
      <div class="project-item">
        <div class="project-header">
          <h3 class="project-title">Gey-Link Portal</h3>
        </div>
        <ul class="bullet-list">
          <li>Built a digital service portal featuring appointment scheduling and automated payment flows.</li>
        </ul>
      </div>
    `,
    experience: `
      <div class="experience-item">
        <div class="experience-header">
          <h3 class="job-title">Lead Developer <span class="company-name">@ Vehicle Inspection & OCR Systems</span></h3>
          <span class="job-date">Previous</span>
        </div>
        <ul class="bullet-list">
          <li>Built a remote vehicle inspection system processing real-world noisy environments and OCR data.</li>
          <li>Developed scalable verification tools for Telebirr and CBE using cross-referencing techniques.</li>
        </ul>
      </div>
    `
  },
  {
    company: 'Vapi',
    role: 'Agent Engineer',
    format: 'letter',
    summary: 'Full-Stack Software Engineer & AI Integration Specialist with a track record of designing scalable agent architectures and enterprise AI deployments. Expert in function calling, multi-step reasoning, and event-driven systems using TypeScript and Python. Engineered robust AI applications and automated content platforms. Now applying rapid prototyping to conversational agents at Vapi.',
    competencies: ['Agent Engineering', 'TypeScript & Python', 'Function Calling / LLMs', 'REST APIs & Webhooks', 'Event-Driven Architecture', 'Rapid Prototyping'],
    projects: `
      <div class="project-item">
        <div class="project-header">
          <h3 class="project-title">Ethio Viral — AI Content Platform</h3>
        </div>
        <ul class="bullet-list">
          <li>Built a social media content platform that uses AI for image and video generation at scale.</li>
          <li>Engineered high-fidelity AI prompts and agent workflows to automate creative asset production.</li>
        </ul>
      </div>
      <div class="project-item">
        <div class="project-header">
          <h3 class="project-title">Digital Projects Developer</h3>
        </div>
        <ul class="bullet-list">
          <li>Deployed multiple automated Telegram bots and mobile applications addressing local community needs.</li>
        </ul>
      </div>
    `,
    experience: `
      <div class="experience-item">
        <div class="experience-header">
          <h3 class="job-title">Lead Developer <span class="company-name">@ ShegerPay</span></h3>
          <span class="job-date">Current</span>
        </div>
        <ul class="bullet-list">
          <li>Architected the full platform from scratch, designing complex API integrations and webhook-based architectures.</li>
        </ul>
      </div>
    `
  }
];

const candidate = 'munir-ayub-mohammed';

jobs.forEach(job => {
  let html = template
    .replace(/\{\{LANG\}\}/g, 'en')
    .replace(/\{\{PAGE_WIDTH\}\}/g, job.format === 'letter' ? '8.5in' : '210mm')
    .replace(/\{\{NAME\}\}/g, 'Munir Ayub Mohammed')
    .replace(/\{\{PHONE\}\}/g, '<span class="separator">·</span><span>0907806267</span>')
    .replace(/\{\{EMAIL\}\}/g, 'munirayub011@gmail.com')
    .replace(/\{\{LINKEDIN_URL\}\}/g, 'https://linkedin.com/in/munirayub')
    .replace(/\{\{LINKEDIN_DISPLAY\}\}/g, 'linkedin.com/in/munirayub')
    .replace(/\{\{PORTFOLIO_URL\}\}/g, 'https://portfolio.ethio-viral.com')
    .replace(/\{\{PORTFOLIO_DISPLAY\}\}/g, 'portfolio.ethio-viral.com')
    .replace(/\{\{LOCATION\}\}/g, 'Addis Ababa, Ethiopia')
    .replace(/\{\{SECTION_SUMMARY\}\}/g, 'Professional Summary')
    .replace(/\{\{SUMMARY_TEXT\}\}/g, job.summary)
    .replace(/\{\{SECTION_COMPETENCIES\}\}/g, 'Core Competencies')
    .replace(/\{\{COMPETENCIES\}\}/g, job.competencies.map(c => `<span class="competency-tag">${c}</span>`).join(''))
    .replace(/\{\{SECTION_EXPERIENCE\}\}/g, 'Work Experience')
    .replace(/\{\{EXPERIENCE\}\}/g, job.experience)
    .replace(/\{\{SECTION_PROJECTS\}\}/g, 'Projects')
    .replace(/\{\{PROJECTS\}\}/g, job.projects)
    .replace(/\{\{SECTION_EDUCATION\}\}/g, 'Education')
    .replace(/\{\{EDUCATION\}\}/g, `
      <div class="education-item">
        <div class="education-header">
          <h3 class="degree">B.Sc. Track <span class="school-name">@ Lucee College, Addis Ababa</span></h3>
          <span class="edu-date">Current (4th Year)</span>
        </div>
      </div>
      <div class="education-item">
        <div class="education-header">
          <h3 class="degree">Prior Technical Coursework <span class="school-name">@ Haramaya & Aksum University</span></h3>
        </div>
      </div>
    `)
    .replace(/\{\{SECTION_CERTIFICATIONS\}\}/g, '')
    .replace(/\{\{CERTIFICATIONS\}\}/g, '')
    .replace(/\{\{SECTION_SKILLS\}\}/g, 'Skills')
    .replace(/\{\{SKILLS\}\}/g, `
      <div class="skill-category"><strong>Languages:</strong> TypeScript (Expert), JavaScript (ES6+), Python</div>
      <div class="skill-category"><strong>Frameworks:</strong> React, Next.js, Node.js, Express</div>
      <div class="skill-category"><strong>AI & Automation:</strong> Prompt Engineering, Model Workflows, Telegram Bots</div>
    `);

  const htmlPath = path.join(rootDir, `output/cv-${candidate}-${job.company.toLowerCase().replace(/ /g, '-')}-${job.role.toLowerCase().replace(/ /g, '-')}.html`);
  const pdfPath = path.join(rootDir, `output/cv-${candidate}-${job.company.toLowerCase().replace(/ /g, '-')}-${job.role.toLowerCase().replace(/ /g, '-')}.pdf`);
  
  fs.writeFileSync(htmlPath, html);
  
  try {
    console.log(`Generating PDF for ${job.company} - ${job.role}...`);
    execSync(`node generate-pdf.mjs "${htmlPath}" "${pdfPath}" --format=${job.format}`, { cwd: rootDir, stdio: 'inherit' });
  } catch(e) {
    console.error("Failed PDF generation for", job.role);
  }
});
