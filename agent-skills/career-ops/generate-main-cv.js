import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { execSync } from 'child_process';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const cvPath = path.join(__dirname, 'cv.md');
const templatePath = path.join(__dirname, 'templates/cv-template.html');

if (!fs.existsSync(cvPath)) {
  console.error('cv.md not found!');
  process.exit(1);
}

if (!fs.existsSync(templatePath)) {
  console.error('templates/cv-template.html not found!');
  process.exit(1);
}

const cvContent = fs.readFileSync(cvPath, 'utf-8');
const template = fs.readFileSync(templatePath, 'utf-8');

// Simple Markdown Parser
const lines = cvContent.split('\n');

let name = 'Munir Ayub Mohammed';
let title = '';
let contactInfo = '';
let summaryText = '';
let currentSection = '';

const skills = [];
const projects = [];
const experience = [];
const education = [];
let languagesStr = '';

let tempItem = null;

for (let i = 0; i < lines.length; i++) {
  const line = lines[i].trim();
  if (!line) continue;

  if (line.startsWith('# ')) {
    name = line.replace('# ', '').trim();
    continue;
  }

  if (line.startsWith('**') && line.endsWith('**') && !title) {
    title = line.replace(/\*\*/g, '').trim();
    continue;
  }

  if (line.includes('|') && !contactInfo && !line.startsWith('-') && !line.startsWith('|')) {
    contactInfo = line;
    continue;
  }

  if (line.startsWith('## ')) {
    currentSection = line.replace('## ', '').trim();
    tempItem = null;
    continue;
  }

  if (currentSection === 'PROFESSIONAL SUMMARY') {
    summaryText += (summaryText ? ' ' : '') + line;
    continue;
  }

  if (currentSection === 'TECHNICAL SKILLS') {
    if (line.startsWith('- ')) {
      // E.g., - **Languages:** TypeScript (Expert), JavaScript (ES6+), Python
      const match = line.match(/^-\s+\*\*(.*?):\*\*(.*)$/);
      if (match) {
        skills.push({
          category: match[1].trim(),
          items: match[2].trim()
        });
      }
    }
    continue;
  }

  if (line.startsWith('### ')) {
    // A header under a section, e.g. a project or experience item
    const headerText = line.replace('### ', '').trim();
    tempItem = {
      header: headerText,
      bullets: [],
      rawLines: []
    };

    if (currentSection === 'KEY TECHNICAL PROJECTS' || headerText.includes('ShegerPay') || headerText.includes('Ethio Viral') || headerText.includes('OCR Systems') || headerText.includes('Gey-Link') || headerText.includes('Portfolio')) {
      projects.push(tempItem);
    } else if (currentSection === 'PROFESSIONAL EXPERIENCE' || headerText.includes('Developer') || headerText.includes('Manager')) {
      experience.push(tempItem);
    } else {
      // Fallback
      experience.push(tempItem);
    }
    continue;
  }

  if (tempItem && line.startsWith('- ')) {
    tempItem.bullets.push(line.replace(/^-\s+/, '').trim());
    continue;
  }

  if (currentSection === 'EDUCATION') {
    if (line.startsWith('**')) {
      // E.g., **Lucee College, Addis Ababa** — Currently in 4th Year (B.Sc. Track)
      const parts = line.split('—');
      const schoolPart = parts[0].replace(/\*\*/g, '').trim();
      const descPart = parts[1] ? parts[1].trim() : '';
      education.push({ school: schoolPart, desc: descPart });
    }
    continue;
  }

  if (currentSection === 'LANGUAGES') {
    languagesStr += (languagesStr ? ' ' : '') + line;
    continue;
  }
}

// Build competencies (keyword tags) from skills list
const competencyTags = [];
skills.forEach(s => {
  const items = s.items.split(',').map(x => x.trim().split(' ')[0].replace(/[\(\),]/g, ''));
  items.forEach(item => {
    if (item && item.length > 1 && !competencyTags.includes(item)) {
      competencyTags.push(item);
    }
  });
});

// Map specific key competencies manually to look clean
const cleanCompetencies = [
  'TypeScript', 'React', 'Next.js', 'Node.js', 'Flutter',
  'AI Integration', 'REST APIs', 'Supabase', 'Figma', 'OCR Technology'
];

const competenciesHTML = cleanCompetencies.map(c => `<span class="competency-tag">${c}</span>`).join('\n      ');

// Format Experience HTML
const experienceHTML = experience.map(exp => {
  // E.g., "Digital Projects Developer | Remote / Part-time"
  const parts = exp.header.split('|');
  const role = parts[0].trim();
  const locationAndPeriod = parts[1] ? parts[1].trim() : '';
  
  // Hardcode cleaner period and location for standard CV formatting
  let period = '2024 - Present';
  let company = '';
  let displayRole = role;

  if (role.includes('Digital Projects Developer')) {
    company = 'Independent Freelance';
    period = '2024 - Present';
  } else if (role.includes('Business & Operations Manager')) {
    company = 'Hotel & Family Businesses';
    period = '2022 - 2024';
  } else if (role.includes('Portfolio')) {
    company = 'Personal Project';
    period = '2025';
  }

  return `
    <div class="job">
      <div class="job-header">
        <span class="job-company">${company ? company : role}</span>
        <span class="job-period">${period}</span>
      </div>
      <div class="job-role">${displayRole}</div>
      <ul>
        ${exp.bullets.map(b => `<li>${b}</li>`).join('\n        ')}
      </ul>
    </div>`;
}).join('\n');

// Format Projects HTML
const projectsHTML = projects.map(proj => {
  // E.g., "Lead Developer | ShegerPay — Fintech Platform"
  const parts = proj.header.split('|');
  const role = parts[0].trim();
  const nameAndDesc = parts[1] ? parts[1].trim() : '';
  
  const projName = nameAndDesc.split('—')[0].trim();
  const shortDesc = nameAndDesc.split('—')[1] ? nameAndDesc.split('—')[1].trim() : '';

  // Construct bullet points
  const bulletHTML = proj.bullets.map(b => `<li>${b}</li>`).join('\n        ');

  return `
    <div class="project">
      <div class="job-header">
        <span class="project-title">${projName ? projName : role}</span>
        <span class="job-period">${role}</span>
      </div>
      <p class="project-desc" style="margin-left: 0; padding-left: 0; list-style-type: none;">
        <ul style="padding-left: 18px; margin-top: 4px;">
          ${bulletHTML}
        </ul>
      </p>
    </div>`;
}).join('\n');

// Format Education HTML
const educationHTML = education.map(edu => {
  return `
    <div class="edu-item">
      <div class="edu-header">
        <span class="edu-title">${edu.school}</span>
        <span class="edu-year">${edu.desc.includes('Current') ? 'Current' : ''}</span>
      </div>
      <div class="edu-desc">${edu.desc}</div>
    </div>`;
}).join('\n');

// Format Skills HTML
const skillsHTML = skills.map(s => {
  return `<div class="skill-item"><strong>${s.category}:</strong> ${s.items}</div>`;
}).join('\n      ') + `\n      <div class="skill-item"><strong>Languages:</strong> ${languagesStr}</div>`;

// Combine into Template
const phoneStr = '0907806267';
const emailStr = 'munirayub011@gmail.com';
const linkedinUrl = 'https://www.linkedin.com/in/munir-m-3a23353a1';
const linkedinDisplay = 'linkedin.com/in/munir-m-3a23353a1';
const portfolioUrl = 'https://portfolio.ethio-viral.com';
const portfolioDisplay = 'portfolio.ethio-viral.com';
const locationStr = 'Addis Ababa, Ethiopia';

const finalHTML = template
  .replace(/\{\{LANG\}\}/g, 'en')
  .replace(/\{\{PAGE_WIDTH\}\}/g, '210mm') // A4
  .replace(/\{\{NAME\}\}/g, name)
  .replace(/\{\{PHONE\}\}/g, `<span>${phoneStr}</span>`)
  .replace(/\{\{EMAIL\}\}/g, `<span>${emailStr}</span>`)
  .replace(/\{\{LINKEDIN_URL\}\}/g, linkedinUrl)
  .replace(/\{\{LINKEDIN_DISPLAY\}\}/g, linkedinDisplay)
  .replace(/\{\{PORTFOLIO_URL\}\}/g, portfolioUrl)
  .replace(/\{\{PORTFOLIO_DISPLAY\}\}/g, portfolioDisplay)
  .replace(/\{\{LOCATION\}\}/g, locationStr)
  .replace(/\{\{SECTION_SUMMARY\}\}/g, 'Professional Summary')
  .replace(/\{\{SUMMARY_TEXT\}\}/g, summaryText)
  .replace(/\{\{SECTION_COMPETENCIES\}\}/g, 'Core Competencies')
  .replace(/\{\{COMPETENCIES\}\}/g, competenciesHTML)
  .replace(/\{\{SECTION_EXPERIENCE\}\}/g, 'Work Experience')
  .replace(/\{\{EXPERIENCE\}\}/g, experienceHTML)
  .replace(/\{\{SECTION_PROJECTS\}\}/g, 'Key Projects')
  .replace(/\{\{PROJECTS\}\}/g, projectsHTML)
  .replace(/\{\{SECTION_EDUCATION\}\}/g, 'Education')
  .replace(/\{\{EDUCATION\}\}/g, educationHTML)
  .replace(/\{\{SECTION_CERTIFICATIONS\}\}/g, '')
  .replace(/\{\{CERTIFICATIONS\}\}/g, '')
  .replace(/\{\{SECTION_SKILLS\}\}/g, 'Technical Skills')
  .replace(/\{\{SKILLS\}\}/g, skillsHTML);

const outputHtmlPath = path.join(__dirname, 'output/cv-main.html');
const outputPdfPath = path.join(__dirname, 'output/Munir_Ayub_CV.pdf');

fs.writeFileSync(outputHtmlPath, finalHTML);
console.log(`Generated HTML: ${outputHtmlPath}`);

// Run the PDF generator script
try {
  console.log('Generating PDF via playwright...');
  execSync(`node generate-pdf.mjs "${outputHtmlPath}" "${outputPdfPath}" --format=a4`, { cwd: __dirname, stdio: 'inherit' });
  console.log(`Successfully generated PDF: ${outputPdfPath}`);
} catch (e) {
  console.error('PDF generation failed:', e.message);
  process.exit(1);
}
