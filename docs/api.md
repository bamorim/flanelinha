# Driver API

## Signup and Signin

```
POST /accounts
Creates an account given email, password, document

POST /sessions
Sends email and password and receive some auth credentials
```

## Payments

```
POST /cards
Register a card to payment later

GET /cards
Get all cards (last digits only, of course)

GET /charges
Get all charges done to the
```

## Cars
```
POST /cars
Regiter a car giving a nickname (my car, dad's car, etc) and a plate number (ABC-1234)

GET /cars
Return registered cars
```

## Trips & Reservations
```
POST /trips
Register a destination intent and receives back some info regarding the near parking lots
and preferred parking lot

GET /trips/{trip_id}
Get trip status

POST /trips/{trip_id}/reserve
When getting closer to the destination, the app should confirm the reservation and that will
create a reservation that will be charged

POST /trips/{trip_id}/park
Confirm the car has parked

POST /trips/{trip_id}/renew
Update reservation time

POST /trips/{trip_id}/release
Release reservation
```
