#!/bin/bash
set -e

yum update -y
amazon-linux-extras install nginx1 -y
systemctl enable nginx
systemctl start nginx

cat > /usr/share/nginx/html/index.html << HTML
<!DOCTYPE html>
<html>
<head>
  <title>${project_name} — Instance ${instance_index}</title>
  <style>
    body { font-family: sans-serif; display: flex; justify-content: center;
           align-items: center; height: 100vh; background: #0f172a; color: #f8fafc; }
    .card { background: #1e293b; padding: 2rem 3rem; border-radius: 12px;
            text-align: center; border: 1px solid #334155; }
    h1 { color: #38bdf8; }
    .badge { background: #0ea5e9; padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; }
  </style>
</head>
<body>
  <div class="card">
    <h1>🚀 ${project_name}</h1>
    <p>Instância <strong>#${instance_index}</strong></p>
    <p><span class="badge">${environment}</span></p>
    <p>Provisionado com <strong>Terraform</strong></p>
  </div>
</body>
</html>
HTML

mkdir -p /usr/share/nginx/html/health
echo '{"status":"healthy","instance":"${instance_index}"}' > /usr/share/nginx/html/health/index.html
systemctl reload nginx
