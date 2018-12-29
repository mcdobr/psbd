var request = require('request');


describe('Server', () => {
    var server;
    beforeAll(() => {
        server = require('../server');
        // console.log(server.address());
    });
    afterAll(() => {
        server.close();
    });


    describe('GET /', () => {
        let data = {};
        beforeAll((done) => {
            request.get('http://localhost:10000', (error, response, body) => {
                data.status = response.statusCode;
                data.body = body;
                done();
            });
        });

        it('Status 404 - Not Found', () => {
            expect(data.status).toBe(404);
        });
    });
});