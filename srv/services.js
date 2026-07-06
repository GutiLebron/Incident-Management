const cds = require('@sap/cds');

class ProcessorService extends cds.ApplicationService {
  /** Registering custom event handlers */
  async init() {
    // Lógica de negocio sobre Incidents
    this.before('UPDATE', 'Incidents', req => this.onUpdate(req));
    this.before('CREATE', 'Incidents', req => this.changeUrgencyDueToSubject(req));

    // Ya no necesitamos conectar ni interceptar Customers:
    // - La lectura de Customers la hace CAP vía RemoteService.RemoteCustomers
    // - El JOIN y el email están definidos en remote.cds / ProcessorService.cds

    return super.init();
  }

  changeUrgencyDueToSubject(req) {
    if (req.data.title?.toLowerCase().includes('urgent')) {
      req.data.urgency_code = 'H';
    }
  }

  async onUpdate(req) {
    const { status_code } = await SELECT
      .one(req.subject, i => i.status_code)
      .where({ ID: req.data.ID });

    if (status_code === 'C') {
      return req.reject(400, `Can't modify a closed incident`);
    }
  }
}

module.exports = { ProcessorService };
