# Project Milestone 3: Feedback Session & Design Improvement

UBC MDS DSCI 532  
January 2019   
Team Members

| Name | Github |
|---|---|
| Harjyot Kaur | [HarjyotKaur](https://github.com/HarjyotKaur) |
| Shayne Andrews | [ShayneAndrews](https://github.com/shayne-andrews)|

## Reflection on the usefulness of the feedback you received

We interacted with two different teams in our cohort and exchanged feedback on the app designed. Receiving inputs from a fresh pair of eyes was vital for our project as it provided us a renewed perspective about app segments and engendered major improvements in the app.

#### App Usability and Feedback:

The session started with the other teams being a 'fly-on-the-wall' and exploring our app. The fact that the team had to explore the app with no prior knowledge about the app's functionality, aided us in viewing the app from the user's perspective. The app interface should be designed in a way that all the elements work in sync to fulfill user's primary purpose. The app should also be self-sufficient in a way that the user is able to sift through the entire app without getting confused or needing any extraneous explanation.

The teams were able to use the app as we had hoped. They expressed likeability for the following app features:
  - Chloropeth `World Map` with hover effect
  - `Histograms` on top of sliders, to view distribution of filter variables
  - Diverse set of filters to explore the data in depth
  - Multiple Selection widgets for `country and sport`
  - `Comparison of sports` over `time` the, plot

Both the teams came across certain weaknesses in the app. Following are the suggestions provided by the teams:
  - Making another tab for the `Word Cloud` and giving it a meaningful name so that the user is able to deduce its purpose
  - Changing the color scheme of the `World Map` and `Word Cloud`.
  - Changing or removing `No Medal` selection input in `Medals` widget
  - Moving the `Age`, `Height`, `Weight` selection widgets to the  top of the app so that the user is able to see the player characteristics with change in medal count. This would also evade the need to scroll down the side bar panel of filters.
  - Changing the `Sports line chart` such that the selection of multiple sports does not cause a clutter in the legend.


#### Changes made to the App:

The suggestions received from the teams for app improvement, proved to be extremely valuable. Given the time frame, we were able to implement the improvements suggested above.

- Suggestions Implemented:

  - Shifted the `Age`, `Height`, `Weight` selection widgets with their histograms to the top of the app. It is a more prominent place for these widgets as they also convey player characteristics. It fulfils multiple purposes now as the user can slide through the widget to make a selection and also view the change in other player characteristics simultaneously.

  - Changed the color scheme of the `World Map` to a sequential range of colors to encapsulate the frequency of medal count difference amongst countries

  - Moved `Word Cloud` to a new tab and gave that tab a meaningful name

  - Removed the `No Medal` selection input in `Medals` widget

  - Faceted the `Line Chart` to showcase top 5 countries and top 5 sports played in those countries. This would help avoid clutter in the line chart. This, also fulfils multiple purposes as now the user can compare any country/countries for any sport/sports over a time-period given any criterion for player characteristics.


#### Overall Review of the Feedback Session

The feedback received was pivotal in reshaping the app interface and making it more user-friendly. The session helped us in gauging the app from multiple perspectives which would not have been possible else. The `fly-on-the-wall`, part of the feedback session was extremely beneficial. It gave a two-fold view of the app, first inspecting the app of our peers with no prior-knowledge and then having them inspect ours. This paved the way for multiple discussion points in both the sessions. The discussion with peers who have been working on the same tool for the same amount of time was particularly engaging and useful. The feedback sessions helped us in reshaping the app interface to make it more easy to understand, convenient and feasible.

## Reflection on how your project has changed since Milestone 2, and why.

#### App Use Case and changes since Milestone 2:   

The app is primarily designed for a person associated to any National Sports Authority seeking to make budget allocation decision for sports committees. The app would provide the user the flexibility to overview the medals won in a sport by their nation and the trend of medals won overtime . It provides a deep insight to the user in terms of player characteristics such as height, weight, age, sex. The objective of the app did not change over Milestone3, rather the design choices suggested strengthened the use case further.

- App changes from `Milestone 2` to `Milestone 3`:

  - The feedback sessions helped us develop a better app design for use case. There was some restructuring done in terms of adding tabs and placement of selection widgets. The suggestions implemented have been outlined above.

  - We also added some `extra features:`

    - Earlier, if the medal selection boxes were unchecked, the world map would disappear. A continent borderline has now been added, thus if all the countries are deselected or all the medal boxes are unchecked it would still show the continent borders.

    - A `play button` has been added to the timeline. The user can now select a time-period, say 5 years and press play to dynamically view the change in medal count over time.
