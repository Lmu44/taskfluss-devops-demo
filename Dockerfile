# syntax=docker/dockerfile:1

# ---- Stufe 1: "base" -----------------------------------------------------
# Ein kleines, sicheres Basis-Image mit Node.js 24 (Alpine = sehr schlank).
# Node.js 20 wird seit Ende April 2026 nicht mehr mit Sicherheitsupdates versorgt.
FROM node:24-alpine AS base
WORKDIR /usr/src/app

# ---- Stufe 2: "dependencies" ----------------------------------------------
# Zuerst NUR die Abhaengigkeits-Dateien kopieren, damit Docker diesen
# Schritt zwischenspeichern kann, solange sich package.json nicht aendert.
FROM base AS dependencies
COPY package.json package-lock.json* ./
RUN npm install --omit=dev

# ---- Stufe 3: "release" ----------------------------------------------------
# Das eigentliche, schlanke Produktions-Image.
FROM base AS release
# npm wird nur zum Installieren gebraucht (Stufe 2), nicht zur Laufzeit.
# Das im Basis-Image mitgelieferte npm bringt eigene Abhaengigkeiten mit,
# in denen Trivy HIGH-Schwachstellen findet. Entfernen verkleinert die
# Angriffsflaeche, ohne die Anwendung zu beeintraechtigen.
RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx
COPY --from=dependencies /usr/src/app/node_modules ./node_modules
COPY package.json ./
COPY index.js ./

ENV NODE_ENV=production
EXPOSE 3000

# Nicht als Root laufen (Sicherheit) - das Image node:24-alpine bringt
# bereits einen Benutzer "node" mit.
USER node

CMD ["node", "index.js"]
