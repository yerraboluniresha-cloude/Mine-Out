# MineOut 📖✨
> *"Your thoughts. Your world. Only yours."*

MineOut is a personal notebook web application crafted like a cozy digital library of authentic, pastel-colored physical notebooks arranged on a warm bookshelf.

---

## 🎨 Features & Design System

### 1. Physical Notebook Experience
- **Realistic Notebook Covers**: Handcrafted covers featuring rounded spine hinges, debossed gold/pastel emblem plates, bookmark ribbons, and stacked paper edge depth.
- **Aesthetic Pastel Palettes**:
  - 🌸 **Blush Pink** (`#FCE6EA` / `#F4B7C1` spine)
  - 💜 **Soft Lavender** (`#ECE3FA` / `#CBB9EB` spine)
  - ☕ **Warm Cream** (`#FAF3E7` / `#E5D6BD` spine)
  - 🌿 **Sage Green** (`#E2ECE9` / `#B3CFC6` spine)
  - 🌊 **Powder Blue** (`#DEECFA` / `#ADCDE8` spine)
  - 🍑 **Soft Peach** (`#FFE7DB` / `#F8BD9F` spine)
  - 🌹 **Dusty Rose** (`#F6E4E8` / `#E2B2BD` spine)
  - 🍃 **Mint Glow** (`#E3F4EA` / `#A6DCB8` spine)
- **Ambient Off-White Background**: Warm `#FAF7F2` parchment tone with smooth shadows and responsive grid layouts.

### 2. Pre-Loaded Preview Notebooks
1. **My Feelings** — Blush pink cover with a heart icon (emotional check-ins, gratitude).
2. **My Dreams** — Soft lavender cover with a star icon (ambitions, midnight sparks).
3. **Daily Journal** — Warm cream cover with a sun icon (morning coffee, daily musings).
4. **College Notes** — Powder blue cover with a graduation cap icon (lecture notes, study guides).
5. **Future Plans** — Sage green cover with a target icon (quarterly goals, roadmaps).
6. **Private Thoughts** — Soft peach cover with a flower icon (unfiltered personal sanctuary).

### 3. Interactive Capabilities
- **Create New Book**: Opens an elegant modal featuring a real-time live preview of the notebook cover as you type the title, pick pastel shades, and choose emblem symbols.
- **Dedicated Notebook Pages**: Click any notebook to open its dedicated view with note cards, note counts, search, and tag filters.
- **Note Editor**: Distraction-free markdown formatting (Bold, Italic, Headings, Bullet Lists, Quotes, Checkboxes), tags manager, pin to top, and word/char counters.
- **Context Actions**: Rename, Change Cover, Archive/Unarchive, and Delete (with confirmation dialog).
- **View Modes**: Switch effortlessly between physical Bookshelf Grid and Compact Journal List views.
- **Favorites & Search**: Real-time filtering across titles, descriptions, and tags.

### 4. Storage & Backend Architecture
- **Offline-First Prototype**: Automatically stores your books and notes in browser `localStorage`, ensuring data persists between reloads.
- **Supabase Cloud Sync Ready**: Built-in backend status guide with pre-configured PostgreSQL schema and Row Level Security (RLS) policies.

---

## 🚀 Getting Started

To run the application locally:

```bash
# 1. Install dependencies (already installed)
npm install

# 2. Start the Vite development server
npm run dev
```

Then open `http://localhost:5173` in your browser.

---

## 🗄️ Supabase Cloud Configuration (Optional)

When you are ready to connect a cloud Supabase database:
1. Create a project at [supabase.com](https://supabase.com).
2. Create a `.env` file in the project root:
   ```env
   VITE_SUPABASE_URL=https://your-project.supabase.co
   VITE_SUPABASE_ANON_KEY=your-anon-key-here
   ```
3. Run the PostgreSQL migration script provided in the in-app **"Backend Setup Guide"** modal.
