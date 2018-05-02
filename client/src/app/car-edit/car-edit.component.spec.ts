import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CarEditComponent } from './car-edit.component';
import { MatCardModule, MatInputModule } from '@angular/material';
import { RouterTestingModule } from '@angular/router/testing';
import { FormsModule } from '@angular/forms';
import { CarService } from '../shared/car/car.service';
import { HttpClientModule } from '@angular/common/http';
import { GiphyService } from '../shared/giphy/giphy.service';
import { NoopAnimationsModule } from '@angular/platform-browser/animations';

describe('CarEditComponent', () => {
  let component: CarEditComponent;
  let fixture: ComponentFixture<CarEditComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [CarEditComponent],
      imports: [RouterTestingModule, MatCardModule, MatInputModule, FormsModule, HttpClientModule, NoopAnimationsModule],
      providers: [CarService, GiphyService]
    })
      .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CarEditComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
