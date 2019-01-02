# Shop management system

[![Build Status](https://travis-ci.com/mcdobr/psbd.svg?branch=master)](https://travis-ci.com/mcdobr/psbd)

[![License](https://img.shields.io/github/license/mcdobr/psbd.svg)]

Ca să meargă diacriticele în SQL Developer:
```
Preferences>Environment>Encoding>UTF-8
```

Example request body for POST on /api/bills
```
{
    	"billDate": "2018/08/05",
	"otherPartyName": "Mircea Dobreanu",
	"billType": "incoming",
	"billedItems": [
		{
			"productId": 1,
			"quantity": 10
		},
		{
			"productId": 2,
			"quantity": 5
		},
		{
			"productId": 3,
			"quantity": 2
		}
	]
}
```
