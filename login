login

COMMAND:
curl -X POST http://localhost:5000/api/auth/login -H "Content-Type: application/json" -d '{"email":"test+1779465642@example.com","password":"Password123!"}'

OUTPUT:
{"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2YTEwN2RjODY0NWMyNTA0ZjM4ZmIwNzUiLCJlbWFpbCI6InRlc3QrMTc3OTQ2NTY0MkBleGFtcGxlLmNvbSIsImlhdCI6MTc3OTQ2NTY3MywiZXhwIjoxNzgwMDcwNDczfQ.YWaQNCto8F_QSnoQgk_AI00C7qYVrVRW9rSS4Rf-Iyg"}
