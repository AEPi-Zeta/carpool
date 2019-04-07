CREATE TABLE events (
  event_id INTEGER PRIMARY KEY,
  name TEXT
);

CREATE TABLE drivers (
  driver_id INTEGER PRIMARY KEY,
  event_id INTEGER NOT NULL,
  rider_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  seats INTEGER NOT NULL,
  leaving INTEGER NOT NULL,

  FOREIGN KEY (event_id) REFERENCES events(event_id),
  FOREIGN KEY (rider_id) REFERENCES riders(rider_id)
);

CREATE TABLE riders (
  rider_id INTEGER PRIMARY KEY,
  event_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  group_size INTEGER NOT NULL,
  leaving INTEGER NOT NULL,

  FOREIGN KEY (event_id) REFERENCES events(event_id)
);
