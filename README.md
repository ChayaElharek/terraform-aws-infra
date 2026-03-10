# 🏗️ terraform-aws-infra

Infraestrutura AWS provisionada com Terraform, organizada em módulos reutilizáveis.

## Arquitetura

```
Internet
    │
    ▼
┌─────────────────────────────┐
│   Application Load Balancer  │  ← Porta 80/443
│   (ALB)                      │
└────────────┬────────────────┘
             │ distribui tráfego
    ┌────────┴────────┐
    ▼                 ▼
┌────────┐       ┌────────┐
│  EC2   │       │  EC2   │   ← NGINX + health check
│  AZ-1a │       │  AZ-1b │
└────────┘       └────────┘
    │                 │
    └────────┬────────┘
             ▼
    ┌─────────────────┐
    │       VPC        │
    │  10.0.0.0/16    │
    └─────────────────┘
```

## Recursos criados

| Módulo           | Recursos                                              |
|------------------|-------------------------------------------------------|
| `vpc`            | VPC, 2 Subnets públicas, Internet Gateway, Route Table |
| `security-groups`| ALB SG (HTTP/HTTPS), EC2 SG (só do ALB + SSH)         |
| `ec2`            | 2x EC2 t2.micro com NGINX (user_data)                 |
| `alb`            | ALB, Target Group, Listener HTTP:80, Health Check     |

## Pré-requisitos

- [Terraform >= 1.5](https://developer.hashicorp.com/terraform/downloads)
- [AWS CLI](https://aws.amazon.com/cli/) configurado
- Credenciais AWS com permissões de EC2, VPC e ELB

## Como usar

### 1. Configure as credenciais AWS

```bash
aws configure
# AWS Access Key ID: xxxxxx
# AWS Secret Access Key: xxxxxx
# Default region name: us-east-1
```

### 2. Clone o repositório

```bash
git clone https://github.com/ChayaElharar/terraform-aws-infra
cd terraform-aws-infra
```

### 3. Inicialize o Terraform

```bash
terraform init
```

### 4. Visualize o plano de execução

```bash
terraform plan -var-file="environments/dev/terraform.tfvars"
```

### 5. Aplique a infraestrutura

```bash
terraform apply -var-file="environments/dev/terraform.tfvars"
```

### 6. Acesse a aplicação

Após o apply, copie o `alb_dns_name` exibido nos outputs e acesse no browser.

### 7. Destrua quando não precisar mais (evite cobranças)

```bash
terraform destroy -var-file="environments/dev/terraform.tfvars"
```

## Estrutura do projeto

```
terraform-aws-infra/
├── main.tf                          # Módulo raiz — orquestra tudo
├── variables.tf                     # Variáveis globais
├── outputs.tf                       # Outputs (ALB DNS, IPs, etc.)
├── .gitignore                       # Ignora tfstate e arquivos sensíveis
├── modules/
│   ├── vpc/                         # VPC, subnets, IGW, route table
│   ├── security-groups/             # SGs do ALB e das EC2
│   ├── ec2/                         # Instâncias + user_data.sh (NGINX)
│   └── alb/                         # Load Balancer + Target Group
└── environments/
    ├── dev/terraform.tfvars         # Variáveis do ambiente dev
    └── prod/terraform.tfvars        # Variáveis do ambiente prod
```

## Decisões de arquitetura

**Por que módulos separados?**
Facilita reuso, testes isolados e manutenção. Cada módulo tem responsabilidade única (SRP).

**Por que o EC2 SG só aceita tráfego do ALB?**
Segurança por princípio de menor privilégio — as instâncias nunca ficam expostas diretamente.

**Por que health check em `/health`?**
Separa o endpoint de saúde da aplicação, permitindo que o ALB detecte falhas sem interferir na rota principal.

## Melhorias futuras

- [ ] Backend S3 para tfstate remoto
- [ ] HTTPS com ACM (certificado SSL)
- [ ] Auto Scaling Group (ASG) no lugar de EC2 fixas
- [ ] Módulo RDS para banco de dados
- [ ] GitHub Actions para CI/CD do Terraform (plan no PR, apply no merge)

---

Feito com por [Chaya Elharar](https://chayacode.com.br) | DevOps & Cloud Infrastructure
