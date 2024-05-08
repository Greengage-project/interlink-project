package com.greengage.spi.authentication;

import org.keycloak.authentication.AuthenticationFlowContext;
import org.keycloak.authentication.Authenticator;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;
import org.keycloak.models.UserModel;


public class GreengageLoginForm implements Authenticator {

    private static final String FIRST_LOGIN_GREENGAGE = "first-login-greegage.ftl";

    /*
    String[] attributesToCheck = {
        //     "ageRange", "digitalToolsAcquaintance", "disadvantagedGroup",
        //     "educationLevel", "gender", "organizationType",
        //     "thematicRole", "workStatus", "zipCode"
        // };
    */
    private static final String[] ATTRIBUTES_TO_CHECK = {
        "ageRange", "digitalToolsAcquaintance", "disadvantagedGroup",
        "educationLevel", "gender", "organizationType",
        "thematicRole", "workStatus", "zipCode"
    };

    @Override
    public void authenticate(AuthenticationFlowContext context) {
        context.challenge(context.form().createForm(FIRST_LOGIN_GREENGAGE));
      
    }

    @Override
    public void action(AuthenticationFlowContext context) {
        // Implementation of what happens when the form action is triggered
        // For example, validate and save it as user attributes
        UserModel user = context.getUser();
        for (String attribute : ATTRIBUTES_TO_CHECK) {
            String value = context.getHttpRequest().getDecodedFormParameters().getFirst(attribute);
            if (value != null) {
                user.setSingleAttribute(attribute, value);
            }
        }
        
        context.success();
    }
    

    @Override
    public boolean requiresUser() {
        return false;
    }

    @Override
    public boolean configuredFor(KeycloakSession keycloakSession, RealmModel realmModel, UserModel userModel) {
        return false;
    }

    @Override
    public void setRequiredActions(KeycloakSession keycloakSession, RealmModel realmModel, UserModel userModel) {

    }

    @Override
    public void close() {

    }

}