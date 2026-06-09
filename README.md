# Lab 9: Offensive Security & Penetration Testing

---

## Requirements

- Kali Linux
- Docker + Docker Compose
- Python 3
- Nmap, Netcat, Searchsploit

---

## Setup

### 1. Start Metasploit

```bash
mkdir -p orion-system/offensive-security
cd orion-system/offensive-security
```

`docker-compose.yml`:
```yaml
services:
  metasploit:
    image: metasploitframework/metasploit-framework
    container_name: metasploit
    stdin_open: true
    tty: true
```

```bash
docker compose up -d
```

### 2. Deploy Webmin 

```bash
git clone https://github.com/vulhub/vulhub.git
cd vulhub/webmin/CVE-2019-15107
docker compose up -d
docker network connect cve-2019-15107_default metasploit
```

### 3. Deploy Apache Struts

```bash
cd vulhub/struts2/s2-045
docker compose up -d
docker network connect s2-045_default metasploit
```

---

## Targets

| Target | CVE | Port |
|---|---|---|
| Webmin 1.910 | CVE-2019-15107 | 10000 (HTTPS) |
| Apache Struts 2.3.30 | CVE-2017-5638 | 8080 (HTTP) |

---

## Repository Structure

```
.
├── README.md
├── screenshots/
└── notes/
    └── manual_webmin_exploit.py
```
