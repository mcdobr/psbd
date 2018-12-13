# Shop management system
Example request body for POST on /api/bill
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