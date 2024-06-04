# Auth flow example

1. User has not logged in yet (there is no cookie).

  ![Auth1](images/auth1.png)

2. After making a GET request to /auth/login, if user is not logged in, browser redirects to the OIDC service where the user can log in with credentials or third party providers, such as Google.

  ![Login](images/login.png)

3. After a successful login, token is stored as a "samesite" cookie. Now, all requests made to the backend microservices behind **localhost** (or the site where is running the **auth** microservice) send the cookie together with the request.

  ![Auth2](images/merged.jpg)


### How do microservices check that a request is authenticated?

Each endpoint checks if the access token is present **as a cookie or as an authorization header** (being prioritized the cookie), checks its validity and decodes it to set the *user_data* (contained inside the access token, having name, email and profile image, for example) inside **request** data

  ![Auth deps](images/deps.png)


## Advantages and drawbacks of cookie authentication


To understand the advantages of this authentication we must really understand how the different services are integrated in the frontend. If we look again at the example of how the interlinker **googledrive** is integrated into the frontend, we will see that it is done through an iframe that loads the path "/googledrive/assets/{id}/instantiate".

![Googledrive interlinker integration](images/googledrive.png)

```html
<iframe src="/googledrive/assets/{id}/instantiate" frameBorder="0"></iframe>
```

### Alternatives ("authorization" header):

* That each service / interlinker integrate its own authentication flow (being complex both to develop and maintain). Likewise, it would entail that the user had to perform the login steps for and for each of the external services that are being injected into the main frontend. **In fact, it would not be possible, because the OIDC provider does not support its loading inside an iframe**.

* We should find a plausible way to pass the access token to the service contained in the iframe. One way to do this would be to inject it as a parameter in the iframe's src, which would expose the token:

```html
<iframe src="/forum/assets/{id}/viewer?access_token={access_token}"></iframe>
```

### Advantages of using cookie-based auth:

  * Once a user has logged in once, through any service (main frontend or interlinker GUIs), ALL the services can make authenticated requests.
  
  * Logic to implement authentication in any service is trivial and **not framework-dependant**. Given **forum** interlinker as an example, which is developed with NextJS framework, the logic to authenticate an user would be as simple as redirecting the user to the /auth/login route (the auth microservice is responsible to retrieve the token and to set it to a samesite cookie):

  * By the way, **authentication through authorization headers is also allowed (check AuthMiddleware)**

### Drawbacks:
  
  * All services MUST BE behind the same sitename (being allowed subdomains). In development, this is achieved by the **proxy** microservice, powered by Traefik (take a look in [ROUTING.md](/docs/ROUTING.md)).