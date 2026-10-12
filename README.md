<p align="center">

<!-- (site para ícones: https://shields.io/ ) -->

<img alt="Maintained" src="https://img.shields.io/badge/Maintained%3F-Yes-green">

<img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/arikcnovais/linuxmint-post-install">

<img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/arikcnovais/linuxmint-post-install">

<img alt="GitHub commit activity (branch)" src="https://img.shields.io/github/commit-activity/y/arikcnovais/linuxmint-post-install">

</p>

</br>

# 🍃 Pós-Instalação — Linux Mint 22.3 (Zena / base Ubuntu)

Roteiro de pós-instalação **automatizado e enxuto** para o Linux Mint 22.3.
As tarefas estão divididas em **categorias independentes**: você executa só o
que quer, na ordem que quiser — ou tudo de uma vez.

- **Só o essencial:** nada de duplicar o que o Mint já traz.
- **Sem apps proprietários:** sem navegadores extras, sem clientes de serviços fechados.
- **Gaming livre:** Prism Launcher, RetroArch e gamemode.
- **Automatizado:** cada categoria é um script idempotente (pode rodar várias vezes sem estragar nada).
- **Seu controle:** menu interativo ou chamada direta por categoria.

---

## 🚀 Uso rápido

```bash
git clone https://github.com/arikcnovais/linuxmint-post-install.git
cd linuxmint-post-install
./setup.sh
```

O `setup.sh` abre um menu. Também dá para ir direto ao ponto:

```bash
./setup.sh --list              # ver as categorias
./setup.sh all                 # rodar tudo, na ordem
./setup.sh jogos               # rodar só uma categoria
./setup.sh apt jogos artcraft  # rodar várias
```

Cada categoria também roda sozinha, o que facilita entender/auditar:

```bash
bash categories/10-artcraft.sh
```

> Não rode os scripts com `sudo`. Eles chamam `sudo` quando necessário.

---

## 📋 Categorias

| # | Categoria | Script | O que faz |
|---|---|---|---|
| 1 | `sistema` | `01-sistema.sh` | `apt update` + `upgrade` e instala `mint-meta-codecs` |
| 2 | `seguranca` | `02-seguranca.sh` | Ativa o **ufw** (opcionalmente libera Warpinator/KDE Connect) |
| 3 | `flathub` | `03-flathub.sh` | Registra o remoto **Flathub** |
| 4 | `comunicacao` | `04-flatpak-comunicacao.sh` | **Telegram** (cliente livre) |
| 5 | `criacao` | `05-flatpak-criacao.sh` | **GIMP**, **Inkscape**, **OBS Studio**, **Kdenlive** |
| 6 | `midia` | `06-flatpak-midia.sh` | **FreeTube** |
| 7 | `jogos` | `07-flatpak-jogos.sh` | **Prism Launcher** e **RetroArch** |
| 8 | `utilitarios` | `08-flatpak-utilitarios.sh` | **Flatseal** e **Gear Lever** |
| 9 | `apt` | `09-apt-ferramentas.sh` | **git, htop, p7zip-full, unrar, build-essential, neovim, gamemode** |
| 10 | `artcraft` | `10-artcraft.sh` | Baixa o **ArtCraft Launcher (AppImage)** e integra pelo **Gear Lever** |
| 11 | `limpeza` | `11-limpeza.sh` | `apt autoremove`/`autoclean` e `flatpak uninstall --unused` |

---

## 🔧 O que mudou em relação à versão anterior

**Navegadores — removidos por completo.** O Firefox nativo do Mint já cobre a
navegação. Saíram **Chrome**, **Edge** e **Zen**: os dois primeiros são
proprietários e o terceiro só duplicava função.

**Removido por serem proprietários ou dependerem de serviços fechados:**

- **Vesktop / Discord** — cliente de um serviço proprietário.
- **Spotube** — cliente ligado a serviços de streaming.
- **Lutris** — launcher pensado para lojas/clientes proprietários (Steam, Epic, Battle.net).

**Removido por já existir no Mint (redundância):**

- **Firefox** e **Thunderbird** — já vêm como pacotes nativos.
- **`curl` e `wget`** — já presentes no sistema base.

**Removido por estar obsoleto/bloat:**

- **`neofetch`** — abandonado há anos.

**Adicionado:**

- **`neovim`** e **`gamemode`** via apt (categoria `apt`).
- **Gear Lever** (`it.mijorus.gearlever`) para gerenciar/integrar AppImages.
- **ArtCraft Launcher** como AppImage, baixado do release oficial e integrado ao menu pelo Gear Lever (categoria `artcraft`).

**Mantido de propósito (mesmo não sendo livre):**

- **`mint-meta-codecs`** e **`unrar`** — necessários na prática para reprodução de
  mídia e extração de RAR. Decisão consciente de manter o sistema funcional.

> ℹ️ **Sobre o ArtCraft:** é um projeto novo, em desenvolvimento ativo e de
> licença “source-available”. O launcher é baixado direto das releases oficiais
> em `github.com/storytold/craft-launcher`, sempre com verificação de SHA-256.
> Avalie os aplicativos individualmente antes de adotá-los como substitutos do LibreOffice.

---

## 1. Atualização do sistema e codecs

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install mint-meta-codecs -y
```

## 2. Firewall e segurança

```bash
sudo apt install ufw -y
sudo ufw enable
```

> **Warpinator / KDE Connect / compartilhamento local:** libere as portas 1714:1764.
> No script: `LOCAL_SHARE=1 bash categories/02-seguranca.sh`
>
> ```bash
> sudo ufw allow 1714:1764/udp
> sudo ufw allow 1714:1764/tcp
> ```

## 3. Flathub

```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

## 4. Aplicativos Flatpak (por categoria)

### 💬 Comunicação

```bash
flatpak install flathub org.telegram.desktop -y
```

### 🎨 Criação e edição gráfica/vídeo

```bash
flatpak install flathub org.gimp.GIMP -y
flatpak install flathub org.inkscape.Inkscape -y
flatpak install flathub com.obsproject.Studio -y
flatpak install flathub org.kde.kdenlive -y
```

### 🎵 Mídia e entretenimento

```bash
flatpak install flathub io.freetubeapp.FreeTube -y
```

### 🎮 Jogos e emulação

```bash
flatpak install flathub org.prismlauncher.PrismLauncher -y
flatpak install flathub org.libretro.RetroArch -y
```

### 🛠️ Gerenciamento e utilitários

```bash
flatpak install flathub com.github.tchx84.Flatseal -y   # permissões de sandbox
flatpak install flathub it.mijorus.gearlever -y          # gestão de AppImages
```

## 5. Aplicativos e pacotes via APT

```bash
sudo apt install -y \
  git \
  htop \
  p7zip-full \
  unrar \
  build-essential \
  neovim \
  gamemode
```

## 6. ArtCraft Launcher (AppImage) + Gear Lever

O script `categories/10-artcraft.sh` faz tudo:

1. descobre a release mais recente do launcher (`storytold/craft-launcher`) para a sua arquitetura;
2. baixa o AppImage para `~/Applications/ArtCraft-Launcher.AppImage`;
3. confere o **SHA-256** publicado na release;
4. integra no menu de aplicativos com `flatpak run it.mijorus.gearlever --integrate <arquivo>`.

Manualmente, a integração fica assim:

```bash
flatpak run it.mijorus.gearlever --integrate ~/Applications/ArtCraft-Launcher.AppImage
```

## 7. Otimização e ajustes finos

### Permissões com o Flatseal

Acessos a HDs externos e partições (NTFS/ext4) para apps em sandbox como o
**OBS Studio** e o **Prism Launcher** podem ser liberados no **Flatseal**:

1. Abra o **Flatseal**.
2. Selecione o aplicativo na barra lateral.
3. Em **Filesystem**, habilite `All system files` ou adicione o caminho em `Other files`.

### GameMode

O `gamemode` é instalado via apt e é usado automaticamente por jogos que o
suportam. Em launchers manuais, inicie com `gamemoderun`.

### Limpeza de residuais

```bash
sudo apt autoremove -y
sudo apt autoclean
flatpak uninstall --unused -y
```

## 8. Considerações finais

**Reinicie** para que variáveis de ambiente, entradas de menu e serviços
carreguem corretamente:

```bash
sudo reboot
```

---

*Baseado no projeto original [debian-post-install](https://github.com/eddiecsilva/debian-post-install)
de Eddie Silva, adaptado e otimizado para o Linux Mint 22.3.*
