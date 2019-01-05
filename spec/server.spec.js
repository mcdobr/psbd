var request = require('request');


describe('Endpoints', () => {

    /*
    var server;
    beforeAll(() => {
        server = require('../server');
    });

    afterAll(() => {
        console.log('Closing test server');
        server.close();
    });*/ 

    describe('GET /', () => {
        let responseData = {};
        beforeAll((done) => {
            request.get('http://localhost:10000', (error, response, body) => {
                responseData.status = response.statusCode;
                responseData.body = body;
                done();
            });
        });

        it('Status 404 - Not Found', () => {
            expect(responseData.status).toBe(404);
        });
    });


    describe('Bill endpoints', () => {
        const postBody = {
            "billDate": "2019-01-03T16:09:13.032Z",
            "otherPartyName": "Mircea Dobreanu",
            "billType": "incoming",
            "billedItems": [
                {
                    "productId": 1,
                    "quantity": 5
                },
                {
                    "productId": 2,
                    "quantity": 2
                },
                {
                    "productId": 3,
                    "quantity": 7
                }
            ]
        };

        describe('GET /api/bills', () => {
            const responseData = {};
            beforeAll((done) => {
                request({
                    method: 'GET',
                    uri: 'http://localhost:10000/api/bills'
                }, (error, response, body) => {
                    responseData.error = error;
                    responseData.response = response;
                    responseData.body = body;
                    done();
                });
            });

            it ('Status 200 OK', () => {
                expect(responseData.response.statusCode).toBe(200);
            });
        });


        describe('POST /api/bills', () => {
            let responseData = {};
            beforeAll((done) => {
                request({
                    method: 'POST',
                    uri: 'http://localhost:10000/api/bills',
                    json: true,
                    body: postBody
                }, (error, response, body) => {

                    responseData.error = error;
                    responseData.response = response;
                    responseData.body = body;
                    done();
                });
            });

            it('Status 201 Created', () => {
                expect(responseData.response.statusCode).toBe(201);
            });

            it ('Body is json', () => {
                expect(typeof responseData.body).toBe('object');
            });
        });

        describe('PUT /api/bills/:id', () => {
            beforeAll((done) => {                
                request({
                    method: 'POST',
                    uri: 'http://localhost:10000/api/bills',
                    json: true,
                    body: postBody
                }, (error, response, body) => {});

                request({
                    method: 'PUT',
                    uri: 'http://localhost:10000/api/bills/1'
                }, (error, response, body) => {
                    responseData = {error: error, response: response, body: body};
                    done();
                });
            });

            it ('Status 204 No Content', () => {
                expect(responseData.response.status).toBe(204);
            });
        });
    });
});