const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// Die Startseite von TaskFluss (Platzhalter fuer den Proof of Concept)
app.get('/', (req, res) => {
  res.json({ message: 'TaskFluss laeuft!', version: '1.0.0' });
});

// Der Health-Check-Endpunkt, den Kubernetes benutzt, um zu pruefen,
// ob der Container gesund ist (siehe k8s/deployment.yaml, readinessProbe)
app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

// Nur wirklich starten, wenn die Datei direkt ausgefuehrt wird
// (beim Testen mit Mocha wird nur "app" importiert, ohne zu starten)
if (require.main === module) {
  app.listen(port, () => {
    console.log(`TaskFluss-Demo laeuft auf Port ${port}`);
  });
}

module.exports = app;
