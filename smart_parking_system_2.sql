use SmartParking;

show tables;

select * from parkinglots;
select * from parkingrecords;
select * from parkingslots;
select * from vehicles;

# Query 1: Total number of vehicles
SELECT COUNT(*) AS total_vehicles FROM Vehicles;

# Query 2: Number of reserved slots
SELECT COUNT(slot_id) AS reserved_slots FROM ParkingSlots WHERE is_reserved = 1;

# Query 3: Unique vehicles that have parked
SELECT COUNT(DISTINCT vehicle_id) AS unique_vehicles_parked FROM ParkingRecords;

# Query 4: Vehicles parked per lot
SELECT pl.name AS lot_name,
       COUNT(DISTINCT pr.vehicle_id) AS vehicles_parked
FROM ParkingRecords pr
JOIN ParkingSlots ps ON pr.slot_id = ps.slot_id
JOIN ParkingLots pl ON ps.lot_id = pl.lot_id
GROUP BY pl.name;

# Query 5: Total revenue collected
SELECT SUM(fee) AS total_revenue FROM ParkingRecords;

# Query 6: Average parking fee
SELECT ROUND(AVG(fee),2) AS avg_fee FROM ParkingRecords;

# Query 7: Minimum and maximum parking fee
SELECT MIN(fee) AS min_fee, MAX(fee) AS max_fee FROM ParkingRecords;

# Query 8: Revenue collected by each parking lot
SELECT pl.name AS lot_name, SUM(pr.fee) AS total_revenue
FROM ParkingRecords pr
JOIN ParkingSlots ps ON pr.slot_id = ps.slot_id
JOIN ParkingLots pl ON ps.lot_id = pl.lot_id
GROUP BY pl.name;

# Query 9: Average parking fee by vehicle type
SELECT v.vehicle_type, ROUND(AVG(pr.fee),2) AS avg_fee
FROM ParkingRecords pr
JOIN Vehicles v ON pr.vehicle_id = v.vehicle_id
GROUP BY v.vehicle_type;

# Query 10: Top 5 recent parking records
SELECT record_id, vehicle_id, entry_time, fee
FROM ParkingRecords
ORDER BY entry_time DESC
LIMIT 5;

# Query 11: Daily revenue trend (last 7 days)
SELECT DATE(pr.entry_time) AS day,
       SUM(pr.fee) AS revenue
FROM ParkingRecords pr
GROUP BY DATE(pr.entry_time)
ORDER BY day DESC
LIMIT 7;

# Query 12: Frequent parkers (more than 3 times)
SELECT v.owner_name, COUNT(pr.record_id) AS visits
FROM Vehicles v
JOIN ParkingRecords pr ON v.vehicle_id = pr.vehicle_id
GROUP BY v.owner_name
HAVING COUNT(pr.record_id) > 3;

# Query 13: Highest revenue parking lot
SELECT pl.name, SUM(pr.fee) AS revenue
FROM ParkingRecords pr
JOIN ParkingSlots ps ON pr.slot_id = ps.slot_id
JOIN ParkingLots pl ON ps.lot_id = pl.lot_id
GROUP BY pl.name
ORDER BY revenue DESC
LIMIT 1;

# Query 14: Show all vehicles 
DELIMITER $$
CREATE PROCEDURE ShowAllVehicles()
BEGIN
    SELECT * FROM Vehicles;
END $$
DELIMITER ;

CALL ShowAllVehicles();

# Query 15: Show all vehicles
CREATE VIEW AllVehiclesView AS
SELECT * FROM Vehicles;

SELECT * FROM AllVehiclesView;

# Query 16: Indexes for Optimized Parking Records Access
CREATE INDEX idx_vehicle_id ON ParkingRecords(vehicle_id);
CREATE INDEX idx_slot_id ON ParkingRecords(slot_id);
CREATE INDEX idx_lot_id ON ParkingSlots(lot_id);


