--USE MOBILE_SERVICE

UPDATE MOBILE_PUSH_DEVICE_INFO
SET DeviceID = DeviceNewID
WHERE DeviceNewID IS NOT NULL  AND DeviceNewID <> '' AND DeviceID <> DeviceNewID
AND DeviceType = 'android'