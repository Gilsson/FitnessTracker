# FitnessTracker

Fitness tracker is an application for catching your everyday data. It provide different kind of your statistics in the comfort form. It will include your history, will provide some basic plans(you can also add custom plan on your own), achievements, some basic tasks.


## Project Details

- **Name:** Hulis Anton
- **Group Number:** 253505

## Class Diagram

![Screenshot (83)](https://github.com/Gilsson/FitnessTracker/assets/86572717/197dec0e-2a31-44f7-a95c-6c41d8c54c84)

## Persistence layer
![image](https://github.com/Gilsson/FitnessTracker/assets/86572717/86818417-7dac-4213-aab6-5e5edc8c0141)

## Services
![image](https://github.com/Gilsson/FitnessTracker/assets/86572717/4285db60-3d0d-4938-a3a8-932d54632cae)

## Application Functions
All information gets from the database(example: your watches/phone collect information and save it as csv file, program get this file and create/update existing documents/tables of database.
1. **Track Heart Rate:**
   - *Description:* Allows users to log and track their heart rate data, including date and time. On the UI layer it appears as user statistic per day, week, month, year. Also it will participate in exercises plans for describing, in what exercise category are you now in. Indication of extremely low and/or extremely high peaks. 

2. **Record Steps:**
   - *Description:* Enables users to record the number of steps taken, along with the date and time. Read heart rate for usage in UI layer + achievements: cumulative achievements, exercise achievements. Steps also counts as plans. There would be some streaks per steps, that make boundary for day for counting. Also it provide statistics over other users(see 6).

3. **Monitor Sleep Patterns:**
   - *Description:* Tracks sleep data, including date, time, duration, and sleep stage (e.g., awake, light, deep, REM). In UI will have sleep statistic page as sequence of awake, light, deep, REM states. Also there would be plan(as 8 hours per day for a week straight) or some streaks of good sleep nights. Provide comparison among other users(see 6).

4. **Set Fitness Plans:**
   - *Description:* Allows users to set and monitor fitness plans, such as daily step targets or sleep duration objectives. Provide user to create his plan alongside default in-build plans. Provide comparison among other users(see 6).

5. **Get all user data:**
   - *Description:* Allow user to comfortably check all his statistic cummulatively/best statistic/meadian among his data.
  
6. **Allow to create different users**
   - *Description:* Create different user, pass to him some different information and application will pass that to your view as information in that form: you are among *some amount of users* in this plan / you are better then *some percent of users* in *some stat*.

7. **Predefined exercises sets:**
   - *Description:* Allows users to use some predefined sets of exercises, like: outdoor run, indoor run, walk, cycle, etc.

8. **Weekly reports:**
   - *Description:* Give user weekly report of their data in form: Daily average steps this week compared to the last week: *some number*.
  
9. **Authorisation:**
   - *Description:* User can set up personal account with name, mail and password and then use this credentials for log in. When user logs in application will take all information from database for that user that is displayed at home page and then, when user will go from page to page will create appropriate pages with appropriate information.
  
10. **Pages:**
   - *Description:* Application provide different pages:
      * Home page: Heart rate statistics, Sleep statistics, Steps Statistics
      * Exercise: Current plan and some predefined plans
      * Me: User page with it's information in it from previos points + settings
  
## Data Models
All models extends basic class entity that contain field Id.
### User Model

- **Attributes:**
  ```java
    public/ Name of user. Should not be exclusive
    public String mail; // Mail of user. should be exclusive(only one for user)
    public String hashPassword; // Password of user that hashed. When user input his password, it should be hashed and compared
    public List<Achievement> achieve String name; /ments; // User achivements, that it already collect. At first enter it is empty
    public List<Plan> plans; // User plans, that it already create or get. At first enter it is empty. Then user can create new Plan or acquire.
    public List<StepData> stepData; // User data that is only collected from application database.
    public List<SleepData> sleepData; // User data that is only collected from application database.
    public List<HeartRateData> heartRateData; // User data that is only collected from application database.
  ```
   ### Data Model:
Abstract class for all data that user have. All different data extends this basic class. It points to the user and check when data was measured.
- **Attributes:**
  ```java
    protected Integer userId;
    protected LocalDateTime dateMeasured = LocalDateTime.MIN;
    protected LocalTime timeDuration = LocalTime.of(0,0);
    protected Integer value = 0;
  ```

### Achievements:
This achievement model consist of tasks that should be completed to complete achievement. User has list of all it's achievements.
- **Attributes:**
  ```java
    public String name = "";
    public List<Task> tasksToAchieve;
    public String description = "";
    public AchievementType achievementType = AchievementType.BASIC;
    public LocalDateTime timeTaken = LocalDateTime.MIN;
  ```
  ### Plan:
Plan model include tasks(exercises) that should contain.
- **Attributes:**
  ```java
    public String name = "";
    // number from 0 to 100 in percents
    public Double planCompletion = 0.0;
    public List<Task> tasksToComplete;
    public LocalDateTime timeEnded = LocalDateTime.MIN;
  ```
  ### Meals:
You can add meals that you taken during the day. Including calories, nutrients, name and mealtype: breakfast, lunch, dinner, morning snack, afternoon snack, evening snack.
- **Attributes:**
  ```java
    public String name;
    public HashMap<String, Integer> nutrients;
    public String calories;
    public MealType mealType = MealType.DEFAULT;
    public LocalDateTime timeTaken = LocalDateTime.MIN;
  ```
