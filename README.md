<div align="center">

# ⚡ QuantumIDE Native

**Next-Gen AI-Powered Mobile & Desktop Studio built with Flutter — Native ARM64 Userspace Edition (без Ubuntu и без PRoot)**

[![Build APK](https://github.com/Lesorub361/quantum_ide_native/actions/workflows/build-apk.yml/badge.svg)](https://github.com/Lesorub361/quantum_ide_native/actions/workflows/build-apk.yml)
[![Build Linux](https://github.com/Lesorub361/quantum_ide_native/actions/workflows/build-linux.yml/badge.svg)](https://github.com/Lesorub361/quantum_ide_native/actions/workflows/build-linux.yml)
[![Build Windows](https://github.com/Lesorub361/quantum_ide_native/actions/workflows/build-windows.yml/badge.svg)](https://github.com/Lesorub361/quantum_ide_native/actions/workflows/build-windows.yml)
[![Build macOS](https://github.com/Lesorub361/quantum_ide_native/actions/workflows/build-macos.yml/badge.svg)](https://github.com/Lesorub361/quantum_ide_native/actions/workflows/build-macos.yml)
[![Build iOS](https://github.com/Lesorub361/quantum_ide_native/actions/workflows/build-ios.yml/badge.svg)](https://github.com/Lesorub361/quantum_ide_native/actions/workflows/build-ios.yml)
[![Build Web](https://github.com/Lesorub361/quantum_ide_native/actions/workflows/build-web.yml/badge.svg)](https://github.com/Lesorub361/quantum_ide_native/actions/workflows/build-web.yml)

**Основная ветка:** `main` · **Релизы:** [`v1.0.0`](https://github.com/Lesorub361/quantum_ide_native/releases/latest) · **Package ID:** `com.example.quantum_ide_native`

</div>

---

## 🚀 Чем отличается QuantumIDE Native от обычного QuantumIDE

Эта редакция полностью избавлена от тяжёлого контейнера **Ubuntu 24.04** и прослойки **PRoot** (`libproot.so`, `libtalloc.so` удалены из сборки):

- **Чистый Native ARM64 Userspace (архитектура Leostryx)**: все команды и терминал работают напрямую на ядре Android в `$HOME/usr` (`$PREFIX`) без эмуляции системных вызовов PRoot.
- **Лёгкий старт (~44 МБ вместо ~500+ МБ Ubuntu)**: при первом запуске скачивается только компактный ARM64 Bionic bootstrap.
- **Встроенные нативные библиотеки `.so` из Leostryx**: `libtermux-exec.so`, `libquantum_loader.so`, `liblse_compat.so` + нативный запуск Bionic `bash` через `/system/bin/linker64` (совместимо с Android 10–16, `targetSdk 36`).
- **Встроенный пакетный менеджер `pkg`**: установка пакетов (`pkg update`, `pkg install git python nodejs ...`) напрямую в нативное окружение без Root и без Ubuntu.
- **Установка рядом с обычным QuantumIDE**: отдельный `applicationId` (`com.example.quantum_ide_native`) и имя **QuantumIDE Native** позволяют держать обе версии на одном устройстве одновременно.

---

## 📱 Поддерживаемые устройства и платформы

QuantumIDE Native собирается автоматически через GitHub Actions:

| Платформа | Архитектура / Формат | Статус | Примечание |
| :--- | :--- | :---: | :--- |
| **Android** | `arm64-v8a` (`.apk` / `.aab`) | ✅ Полная поддержка | **Native ARM64 Userspace** (Leostryx `.so` + `pkg`, ~44 МБ, без Ubuntu и PRoot) или Root-режим (`su`) |
| **Linux Desktop** | `x64`, `arm64` (`.tar.gz`) | ✅ Поддерживается | Открытие проектов на месте (in-place), автопоиск `flutter`/`agy`/SDK + нативный терминал |
| **Windows Desktop** | `x64`, `arm64` (`.zip`) | ✅ Поддерживается | Открытие проектов на месте, выбор папки проекта, автопоиск SDK, AI-агент и Git |
| **macOS** | Universal / Apple Silicon (`.zip`) | ✅ Поддерживается | Нативная работа с проектами, автопоиск Homebrew/Flutter SDK, AI-агент и Git |
| **iOS** | Unsigned `.ipa` | 🧪 Экспериментально | Доступна сборка без подписи через CI |
| **Web** | PWA / Static Web Bundle (`.tar.gz` / `.zip`) | ✅ Поддерживается | Веб-версия редактора и AI-ассистента |

> 📥 **Скачать готовые сборки:** [GitHub Releases](https://github.com/Lesorub361/quantum_ide_native/releases/latest)

---

## ✨ Что реализовано в проекте

### 🤖 AI-агент (Roxum Agent + MCP + Agent Skills)
- **Официальный Dart & Flutter MCP Server (`dart mcp-server`)**: подключение в 1 клик (Dart Analysis Server, DTD, `pub.dev`, тесты, Agentic Hot Reload).
- **Модульные Agent Skills (`RoxumSkillLoader`)**: динамическая подгрузка `.agents/skills/*/SKILL.md` и `.quantum/skills/*/SKILL.md` под конкретную задачу.
- **Flutter Widget Previews (`@Preview`)**: кнопка предпросмотра виджетов прямо в тулбаре редактора `.dart`.
- **Мультипровайдерность**: Google Gemini, DeepSeek, OpenAI, Anthropic Claude, OpenRouter, Groq, xAI Grok, Mistral и локальные OpenAI-совместимые серверы (Ollama / `llama.cpp`).

### 💻 Нативный ARM64 Терминал (Conduit Engine)
- **Движок [`conduit_vt`](packages/conduit_vt)**: быстрый VT-рендеринг, кликабельные URL, автокопирование и экранная лупа на мобильных устройствах.
- **Нативное Linux-окружение без PRoot**: мгновенный запуск `bash`, `pkg`, `git`, `python`, `node`, `curl` на нативной скорости процессора ARM64 без оверхеда `ptrace`.
- **Прямой доступ к проектам**: проекты хранятся в быстром внутреннем хранилище `$HOME/projects` без двойного маппинга PRoot.

### 📝 Редактор, Git и Инструменты
- **CodeCrafter Editor & LSP Bridge**: подсветка синтаксиса, фолдинг, диагностика, inline AI-дополнение и визуальные диффы.
- **Профессиональный Git-клиент**: граф коммитов, ветки, Stash, история изменений и интеграция с GitHub.
- **Плавные OTA-обновления**: троттлинг прогресса (250 мс) и потоковая проверка SHA-256 без лагов интерфейса.

---

## 🛠️ Технологический стек

- **Framework**: Flutter 3.47+ / Dart 3.11+ (Material 3, `flex_color_scheme`, `flutter_lucide`)
- **State Management**: `flutter_riverpod`
- **Routing**: `go_router`
- **Code Editor & AI Completion**: `re_editor`, `re_highlight`, `flutter_code_crafter`
- **Terminal & Runtime**: `conduit_vt`, `flutter_pty`, **Native ARM64 Userspace (Leostryx `.so` + `pkg` + `/system/bin/linker64`)**
- **AI & Markdown**: `roxum` Agentic Engine (`http`), `gpt_markdown`
- **Diagnostics & Logging**: `talker_flutter`, `dart analyze`
- **Localization**: `flutter_localizations` (RU / EN / ES / FR / ZH)

---

## 📂 Структура проекта

```text
quantum_ide_native/
├── android/app/src/main/jniLibs/arm64-v8a/
│   ├── libtermux-exec.so             # Перехват shebang (#!/usr/bin/env ...) в Bionic
│   ├── libquantum_loader.so          # Нативный ARM64 loader из Leostryx
│   └── liblse_compat.so              # ARMv8.0 LSE-совместимость из Leostryx
├── assets/native_env/pkg/            # Встроенный пакетный менеджер pkg + repo.conf
├── lib/
│   ├── main.dart                     # Точка входа приложения
│   ├── app.dart                      # Конфигурация MaterialApp, тем и GoRouter
│   ├── core/
│   │   ├── models/                   # Модели диагностики и AI-конфигураций
│   │   ├── providers/                # Глобальные провайдеры (тема, локаль)
│   │   ├── router/                   # Маршрутизация GoRouter
│   │   ├── services/                 # Native ARM64 Runtime, LSP, Git, MCP, Talker, OTA Update
│   │   ├── theme/                    # FlexColorScheme, палитры, glassmorphism
│   │   └── utils/                    # Утилиты путей и платформ
│   ├── features/
│   │   ├── ai_assistant/             # Roxum AI Agent (roxum/), чат-панель и MCP
│   │   ├── editor/                   # Редактор кода, вкладки, @Preview, диффы
│   │   ├── file_explorer/            # Дерево проекта, поиск, закладки
│   │   ├── git/ & github/            # Git-клиент, граф коммитов, интеграция с GitHub
│   │   ├── home/                     # Дашборд, шаблоны, System Cleaner
│   │   ├── preview/                  # Встроенный WebView-просмотр и консоль
│   │   └── terminal/                 # Conduit-терминал, палитры, виртуальная клавиатура
│   └── shared/                       # Общие виджеты и адаптивный split-screen
└── packages/
    ├── conduit_vt/                   # Vendored терминальный VT-движок + лупа выделения
    └── flutter_code_crafter/         # Vendored пакет AI-автодополнения и LSP-утилит
```

---

## 🔮 Планы на будущее (Roadmap)

- [x] **Conduit Terminal & Selection Loupe**: полная замена движка терминала, 16 тем оформления и экранная лупа выделения.
- [x] **Roxum AI Agent & CodeCrafter**: интеграция агентского чата с diff-ревью, визуальным таймлайном шагов в стиле Antigravity и inline-автодополнением кода.
- [x] **Native Root Kernel Mode (`su`)**: работа напрямую на ядре Android-устройства с Root-правами без скачивания Ubuntu 24.04 PRoot.
- [x] **4 встроенных нативных MCP-сервера & автопоиск SDK**: `quantum-code-intel`, `quantum-git-ops`, `quantum-pkg-manager`, `quantum-memory`, автообнаружение `flutter`/`agy`/SDK и работа с проектами на ПК по их реальным путям.
- [x] **System Cleaner & Auto Rootfs Upgrade**: встроенная очистка системы и автообновление Ubuntu 24.04 PRoot.
- [ ] **KVM MicroVM (Android 15+)**: аппаратная виртуализация Linux-ядра без ограничений PRoot.
- [ ] **Адаптация под складные экраны (Foldables)**: автоматическое разделение редактора, терминала и превью по линии сгиба.
- [ ] **Контейнеры и Docker**: запуск изолированных сервисов и баз данных внутри рабочего окружения.
- [ ] **Remote SSH**: полноценная разработка на удалённых серверах прямо из QuantumIDE.
- [ ] **Маркетплейс тем и плагинов**: установка пользовательских тем оформления и расширений в 1 клик.

---

## 🤝 Благодарности и лицензии

В проекте используются и адаптированы компоненты с открытым исходным кодом (MIT License):
- [Conduit](https://github.com/gwitko/Conduit) — терминальный движок `conduit_vt`
- [flutter_code_crafter](https://github.com/heckmon/flutter_code_crafter) — AI-автодополнение кода и LSP-утилиты
- [roxum-ide](https://github.com/heckmon/roxum-ide) — логика AI-агента, каталог инструментов и UI чата
