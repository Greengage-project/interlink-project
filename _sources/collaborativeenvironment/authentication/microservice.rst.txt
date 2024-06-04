Auth microservice
---------------------

Authentication is managed by **auth** microservice, that exposes these endpoints:

* /auth/login: redirects to the OIDC provider where the users can log in. Accepts *redirect_on_callback*.

Login endpoint implementation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python
    :emphasize-lines: 3

    @router.get("/login")
    async def login(
        request: Request,
        redirect_on_callback: str,
        current_user: Union[dict, None] = Depends(deps.get_current_user),
    ):
        if not current_user:
            redirect_uri = f"{settings.COMPLETE_SERVER_NAME}/callback"
            response = await oauth.smartcommunitylab.authorize_redirect(request, redirect_uri)
            response.set_cookie(
                key="redirect_on_callback",
                value=redirect_on_callback,
                httponly=True,
                secure=settings.PRODUCTION_MODE,
            )
            return response
        else:
            # if user already logged in, redirect to redirect_on_callback
            return RedirectResponse(redirect_on_callback)

Callback code implementation 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Gets tokens returned by the OIDC provider and sets the access_token to *auth_token* cookie [samesite](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite). Then, redirects the browser to the path specified by the *redirect_on_callback* cookie after deleting it.

.. code-block:: python
    :emphasize-lines: 12, 13, 14, 15

    @router.get("/callback")
    async def callback(request: Request, redirect_on_callback: Optional[str] = Cookie(None), collection: AsyncIOMotorCollection = Depends(get_collection)):
        token = await oauth.smartcommunitylab.authorize_access_token(request)
        await crud.get_or_create(collection, token["access_token"])

        response = RedirectResponse(redirect_on_callback)        
        
        response.set_cookie(
            key="auth_token",
            value=token["access_token"],
            expires=token["expires_in"],
            httponly=True,
            samesite='strict',
            domain=settings.SERVER_NAME,
            secure=settings.PRODUCTION_MODE,
        )
        
        response.delete_cookie(key="redirect_on_callback")
        return response

Logout implementation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* /auth/logout: logouts user. Accepts *redirect_on_callback*.

.. code-block:: python
    :emphasize-lines: 3
    
    @router.get("/logout")
    async def logout(redirect_on_callback: str = "/"):
        response = RedirectResponse(url=redirect_on_callback)
        response.delete_cookie(key="auth_token")
        return response