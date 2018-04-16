# Basic CRUD App with Angular 5.0 and Spring Boot 2.0
 
This example app shows how to build a basic CRUD app with Spring Boot 2.0, Spring Data, and Angular 5.0.

Please read [Build a Basic CRUD App with Angular 5.0 and Spring Boot 2.0](https://developer.okta.com/blog/2017/12/04/basic-crud-angular-and-spring-boot) to see how this app was created.

**Prerequisites:** [Java 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) and [Node.js](https://nodejs.org/).

> [Okta](https://developer.okta.com/) has Authentication and User Management APIs that reduce development time with instant-on, scalable user infrastructure. Okta's intuitive API and expert support make it easy for developers to authenticate, manage and secure users and roles in any application.

* [Getting Started](#getting-started)
* [Links](#links)
* [Help](#help)
* [License](#license)

## Getting Started

To install this example application, run the following commands:

```bash
git clone https://github.com/oktadeveloper/okta-spring-boot-2-angular-5-example.git
cd okta-spring-boot-2-angular-5-example
```

This will get a copy of the project installed locally. To install all of its dependencies and start each app, follow the instructions below.

To run the server, cd into the `server` folder and run:
 
```bash
./mvnw spring-boot:run
```

To run the client, cd into the `client` folder and run:
 
```bash
npm install && npm start
```

### Create an OIDC App in Okta

You will need to [create an OIDC App in Okta](https://developer.okta.com/blog/2017/12/04/basic-crud-angular-and-spring-boot#create-an-oidc-app-in-okta) to get your values to perform authentication. 

Log in to your Okta Developer account (or [sign up](https://developer.okta.com/signup/) if you don’t have an account) and navigate to **Applications** > **Add Application**. Click **Single-Page App**, click **Next**, and give the app a name you’ll remember. Change all instances of `localhost:8080` to `localhost:4200` and click **Done**.

#### Server Configuration

Set your domain and copy the `clientId` into `server/src/main/resources/application.yml`. 

**NOTE:** The value of `{yourOktaDomain}` should be something like `dev-123456.oktapreview`. Make sure you don't include `-admin` in the value!

```yaml
security:
    oauth2:
        client:
            access-token-uri: https://{yourOktaDomain}.com/oauth2/default/v1/token
            user-authorization-uri: https://{yourOktaDomain}.com/oauth2/default/v1/authorize
            client-id: {clientId}
            scope: openid profile email
        resource:
            user-info-uri: https://{yourOktaDomain}.com/oauth2/default/v1/userinfo
            token-info-uri: https://{yourOktaDomain}.com/oauth2/default/v1/introspect
            prefer-token-info: false
```

#### Client Configuration

For the client, set the `issuer` and copy the `clientId` into `client/src/app/app.module.ts`.

```typescript
const config = {
  issuer: 'https://{yourOktaDomain}.com/oauth2/default',
  redirectUri: window.location.origin + '/implicit/callback',
  clientId: '{clientId}'
};
```

## Links

This example uses the following open source libraries:

* [Spring Security OAuth](http://projects.spring.io/spring-security-oauth/)
* [Spring Security OAuth Boot 2 Autoconfig](https://github.com/spring-projects/spring-security-oauth2-boot)
* [Okta Angular SDK](https://github.com/okta/okta-oidc-js/tree/master/packages/okta-angular)

## Help

Please post any questions as comments on the [blog post](https://developer.okta.com/blog/2017/12/04/basic-crud-angular-and-spring-boot), or visit our [Okta Developer Forums](https://devforum.okta.com/). You can also email developers@okta.com if would like to create a support ticket.

## License

Apache 2.0, see [LICENSE](LICENSE).
