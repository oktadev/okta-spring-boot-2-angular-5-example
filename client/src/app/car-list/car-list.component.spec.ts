import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CarListComponent } from './car-list.component';
import { MatCardModule, MatListModule } from '@angular/material';
import { RouterTestingModule } from '@angular/router/testing';
import { CarService } from '../shared/car/car.service';
import { HttpClientModule } from '@angular/common/http';
import { GiphyService } from '../shared/giphy/giphy.service';

describe('CarListComponent', () => {
  let component: CarListComponent;
  let fixture: ComponentFixture<CarListComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [CarListComponent],
      imports: [HttpClientModule, MatCardModule, MatListModule, RouterTestingModule],
      providers: [CarService, GiphyService]
    })
      .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CarListComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
