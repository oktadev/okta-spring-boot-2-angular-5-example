import { Injectable } from '@angular/core';
import { HttpRequest, HttpHandler, HttpEvent, HttpInterceptor } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { OktaAuthService } from '@okta/okta-angular';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {

  constructor(private oktaAuth: OktaAuthService) {
  }

  intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {

    // Only add to localhost requests since Giphy's API fails when the request include a token
    if (request.url.indexOf('localhost') > -1) {
      request = request.clone({
        setHeaders: {
          Authorization: `Bearer ${this.oktaAuth.getAccessToken().accessToken}`
        }
      });
    }

    return next.handle(request);
  }
}
