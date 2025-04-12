# 🚀 Terraform AWS Networking Stack

Este projeto foi desenvolvido como prática de infraestrutura como código (IaC) utilizando Terraform para provisionar uma stack de rede completa na AWS.

## 📦 Recursos Provisionados

- **VPC** com CIDR `10.0.0.0/16`
- **3 Sub-redes Públicas**
- **3 Sub-redes Privadas**
- **Internet Gateway (IGW)**
- **Elastic IP para o NAT Gateway**
- **NAT Gateway** para permitir acesso externo das sub-redes privadas
- **Tabelas de Rotas** (Pública e Privada)
- **Associações das Subnets às Tabelas de Rotas**

## 📂 Estrutura do Projeto

```
.
├── main.tf                 # Código principal do Terraform
├── .gitignore              # Arquivos ignorados pelo Git
└── .terraform.lock.hcl     # Arquivo de lock do Terraform (controle de versão de providers)
```

## 💻 Pré-requisitos

- AWS CLI configurado com as credenciais
- Terraform instalado na máquina
- Git configurado
- Conta na AWS

## 🚀 Como usar

1. Clone o repositório:
   ```bash
   git clone https://github.com/bressanjp/terraform-aws-networking.git
   cd terraform-aws-networking
   ```

2. Inicialize o Terraform:
   ```bash
   terraform init
   ```

3. Verifique o plano de execução:
   ```bash
   terraform plan
   ```

4. Aplique a infraestrutura:
   ```bash
   terraform apply
   ```

5. (Opcional) Para destruir a infraestrutura:
   ```bash
   terraform destroy
   ```

## 📌 Observações

- Todos os recursos são criados na região **us-east-1** (Norte da Virgínia).
- Arquivos de estado e cache do Terraform estão protegidos no `.gitignore` para evitar problemas de versionamento.

## 👨‍💻 Autor

Feito com dedicação por **João Pedro Bressan** ☁️  
[LinkedIn](https://linkedin.com/in/bressanjp) 

