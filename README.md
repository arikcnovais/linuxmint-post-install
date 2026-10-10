<p align="center"> 
<!-- (site para ícones: https://shields.io/ ) -->
 
<img alt="Maintained" src="https://img.shields.io/badge/Maintained%3F-Yes-green">
<img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/arikcnovais/linuxmint-post-install">
<img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/arikcnovais/linuxmint-post-install">
<img alt="GitHub commit activity (branch)" src="https://img.shields.io/github/commit-activity/y/arikcnovais/linuxmint-post-install">

</p>
</br>

# 🍃 Roteiro de Pós-Instalação - Linux Mint 22.3 (Base Ubuntu)

Este repositório contém um guia prático, direto e organizado para a pós-instalação do **Linux Mint 22.3 (Zena / Base Ubuntu)**. O objetivo é transformar o sistema recém-instalado em um ambiente completo para produtividade, criação de conteúdo, comunicação e jogos, priorizando pacotes Flatpak mantidos e seguros do Flathub.

---

## 📋 Sumário
1. [Atualização do Sistema e Codecs](#1-atualização-do-sistema-e-codecs)
2. [Configuração do Firewall e Segurança](#2-configuração-do-firewall-e-segurança)
3. [Configuração do Flathub](#3-configuração-do-flathub)
4. [Instalação de Aplicativos Flatpak (por Categoria)](#4-instalação-de-aplicativos-flatpak-por-categoria)
   - [Navegadores Web](#navegadores-web)
   - [Comunicação e Produtividade](#comunicação-e-produtividade)
   - [Criação e Edição Gráfica/Vídeo](#criação-e-edição-gráficavídeo)
   - [Mídia e Entretenimento](#mídia-e-entretenimento)
   - [Jogos e Emulação](#jogos-e-emulação)
   - [Gerenciamento e Utilitários](#gerenciamento-e-utilitários)
5. [Instalação de Aplicativos e Pacotes via APT](#5-instalação-de-aplicativos-e-pacotes-via-apt)
6. [Otimização e Ajustes Finos](#6-otimização-e-ajustes-finos)
7. [Considerações Finais](#7-considerações-finais)

---

## 1. Atualização do Sistema e Codecs

Antes de qualquer coisa, atualize as listas de pacotes e aplique todas as atualizações de segurança e melhorias do sistema base.

```bash
sudo apt update && sudo apt upgrade -y
```

Para garantir a reprodução de formatos proprietários de áudio e vídeo (caso não tenha marcado a opção durante a instalação):

```bash
sudo apt install mint-meta-codecs -y
```

---

## 2. Configuração do Firewall e Segurança

Mantenha seu sistema protegido ativando o Firewall padrão (`ufw`).

```bash
sudo apt install ufw -y
sudo ufw enable
```

> **Nota para usuários do Warpinator / KDE Connect / Local Sharing:**  
> Caso utilize o Warpinator ou aplicativos de transferência local via rede, adicione as regras apropriadas:
> ```bash
> sudo ufw allow 1714:1764/udp
> sudo ufw allow 1714:1764/tcp
> ```

---

## 3. Configuração do Flathub

O Linux Mint 22.3 já vem com suporte nativo ao Flatpak ativado por padrão. Para garantir que o repositório Flathub principal esteja corretamente vinculado e atualizado, execute:

```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

---

## 4. Instalação de Aplicativos Flatpak (por Categoria)

Os comandos abaixo estão divididos em grupos funcionais. Você pode rodar a categoria inteira ou escolher individualmente o software desejado.

### 🌐 Navegadores Web
*(Nota: O Firefox já vem nativamente instalado e otimizado no Linux Mint via pacote de repositório, por isso foi omitido da lista Flatpak)*.

```bash
flatpak install flathub com.google.Chrome -y
flatpak install flathub com.microsoft.Edge -y
flatpak install flathub app.zen_browser.zen -y
```

### 💬 Comunicação e Produtividade
Ferramentas essenciais para conversas, e-mails e gerenciamento de tarefas.

```bash
flatpak install flathub org.telegram.desktop -y
flatpak install flathub dev.vencord.Vesktop -y
flatpak install flathub org.mozilla.Thunderbird -y
```

### 🎨 Criação e Edição Gráfica/Vídeo
Suíte para design vetorial, manipulação de imagens, gravação de tela e edição de vídeos.

```bash
flatpak install flathub org.gimp.GIMP -y
flatpak install flathub org.inkscape.Inkscape -y
flatpak install flathub com.obsproject.Studio -y
flatpak install flathub org.kde.kdenlive -y
```

### 🎵 Mídia e Entretenimento
Clientes alternativos e leves para reprodução de áudio e vídeo sem rastreamento ou anúncios intrusivos.

```bash
flatpak install flathub com.github.KRTirtho.Spotube -y
flatpak install flathub io.freetubeapp.FreeTube -y
```

### 🎮 Jogos e Emulação
Central completa para jogos nativos, launchers alternativos de Minecraft e suporte a emulação clássica.

```bash
flatpak install flathub net.lutris.Lutris -y
flatpak install flathub org.prismlauncher.PrismLauncher -y
flatpak install flathub org.libretro.RetroArch -y
```

### 🛠️ Gerenciamento e Utilitários
Ferramenta para gerenciamento granulado de permissões de privacidade dos aplicativos em sandbox.

```bash
flatpak install flathub com.github.tchx84.Flatseal -y
```

---

## 5. Instalação de Aplicativos e Pacotes via APT

Para ferramentas de linha de comando, manutenção e compressores de arquivos do sistema:

```bash
sudo apt install -y \
  git \
  curl \
  wget \
  htop \
  neofetch \
  p7zip-full \
  unrar \
  build-essential
```

---

## 6. Otimização e Ajustes Finos

### Gerenciando permissões com o Flatseal
Acessos a pastas secundárias, HDs externos e partições de dados (como discos formatados em NTFS/ext4) para o **Lutris**, **Prism Launcher** ou **OBS Studio** podem ser liberados facilmente usando o **Flatseal**:
1. Abra o **Flatseal**.
2. Selecione o aplicativo na barra lateral (ex: Lutris).
3. Na seção **Filesystem** (Sistema de Arquivos), habilite `All system files` ou adicione o caminho do seu disco secundário em `Other files`.

### Limpeza de pacotes residuais
Para remover dependências não utilizadas após a instalação completa:

```bash
sudo apt autoremove -y
flatpak uninstall --unused -y
```

---

## 7. Considerações Finais

Após concluir o roteiro, **reinicie o sistema** para garantir que todas as variáveis de ambiente, atalhos do menu do Cinnamon/XFCE/MATE e serviços em segundo plano sejam carregados corretamente:

```bash
sudo reboot
```

---

*Baseado no projeto original [debian-post-install](https://github.com/eddiecsilva/debian-post-install) de Eddie Silva, adaptado e otimizado para a distribuição Linux Mint 22.3.*
