module Date (Date()) where

data Month = January 
  |February
  |March
  |April
  |May
  |June
  |July
  |August
  |September
  |October
  |November
  |December
  deriving (Eq, Show)

newtype Year = Year Integer
  deriving (Eq, Show)

data Date = Date Year Month Integer
  deriving (Eq, Show)

isLeapYear :: Year -> Bool
isLeapYear (Year n) = (mod n 4 == 0) && (not (mod n 100 == 0) || (mod n 400 == 0))


daysOf :: Year -> Month -> Integer
daysOf _ January = 31
daysOf y February = if isLeapYear y then 29 else 28
daysOf _ March = 31
daysOf _ April = 30
daysOf _ May = 31
daysOf _ June = 30
daysOf _ July = 31
daysOf _ August = 31
daysOf _ September = 30
daysOf _ October = 31
daysOf _ November = 30
daysOf _ December = 31

isValidDate :: Year -> Month -> Integer -> Bool
isValidDate y m d = 1 <= d && d <= daysOf y m 

date :: Year -> Month -> Integer -> Maybe Date
date y m d = if isValidDate y m d 
  then Just(Date y m d)
  else Nothing

nextMonth :: Month -> Month
nextMonth January = February
nextMonth February = March
nextMonth March = April
nextMonth April = May
nextMonth May = June
nextMonth June = July
nextMonth July = August
nextMonth August = September
nextMonth September = October
nextMonth October = November
nextMonth November = December

nextYear :: Year -> Year
nextYear (Year y) = Year (y + 1)



nextDate :: Date -> Date
nextDate (Date y m d) = if d == daysOf y m
  then if ( m == December)
    then Date (nextYear y)
      January 1
    else Date y (nextMonth m) 1    
  else Date y m (d+1)






