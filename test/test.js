const request = require('supertest');
const assert = require('assert');
const app = require('../index');

describe('TaskFluss-Demo', () => {
  it('GET / antwortet mit Status 200 und einer Nachricht', async () => {
    const res = await request(app).get('/');
    assert.strictEqual(res.status, 200);
    assert.strictEqual(res.body.message, 'TaskFluss laeuft!');
  });

  it('GET /health antwortet mit "OK" (fuer den Kubernetes-Health-Check)', async () => {
    const res = await request(app).get('/health');
    assert.strictEqual(res.status, 200);
    assert.strictEqual(res.text, 'OK');
  });
});
