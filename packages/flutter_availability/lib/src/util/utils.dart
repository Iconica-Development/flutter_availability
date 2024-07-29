/// method to return if 2 dates are at the same time of the day
/// ignoring the date
bool isAtSameTime(DateTime date1, DateTime date2) =>
    date1.hour == date2.hour && date1.minute == date2.minute;
