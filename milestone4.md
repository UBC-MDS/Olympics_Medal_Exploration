# Project Milestone 4: Last Improvement

UBC MDS DSCI 532  
January 2019   
Team Members

| Name | Github |
|---|---|
| Harjyot Kaur | [HarjyotKaur](https://github.com/HarjyotKaur) |
| Shayne Andrews | [ShayneAndrews](https://github.com/shayne-andrews)|

#### Changes Implemented

We put in a lot of effort last week in milestone 3 to produce a fully functional dashboard that has a polished user experience and well documented code. So there's not a whole lot left to do this week without tackling big new features.

Having said that, we did manage to implement a few minor improvements:
- Button to reset all filters - after spending some time tweaking all the features on the dashboard, it can be quite tedious to reset them all manually. So we thought a `Reset All` button would be a nice feature to add.
- Help button - we realized there is no description of the dashboard anywhere, and so we tucked this inside a pop-up which is activated by a simple `Help` button. We didn't want the text to distract from the user experience. We also provided a link to the original dataset here.
- Added a new color coding feature, where if only a single medal type is selected (e.g. gold), the color scheme of the whole dashboard changes to align with that selection. We think this will improve the user experience by making it more intuitive when looking at different filter settings.
- Code quality and documentation was improved with some minor tweaks.

#### If we could start from scratch?

This is a difficult question as we are very proud of the final dashboard we've been able to build. We've received lots of positive feedback about it.

If we were to start again now, the only difference would be that could probably write the code a bit quicker (now that we've learned shiny) and might be able to put together a few more tabs. If we had more time some things we'd consider adding would be:
- The `World Map` is interactive with a hover, but what extra information could we show if it was clickable?
- The comparison tab/plot could be made interactive with a hover/click showing additional information.
- The event `WordCloud` could perhaps be linked to the interactivity on the other tabs in some way - maybe clicking on a country on the map produces a `WordCloud`  for that country?

Of course we would need to weigh the impact on user experience of these changes, with additional complexity perhaps less desirable versus improved usability. We really like the simplicity of the dashboard as it exists now.

#### Greatest Challenges

Sometimes working together as a team can present challenges, particularly when the entire code base is in a single file (as is the case here). But this was not an issue for us as we divided up the workload and managed to overcome all of the hurdles we faced efficiently.

The main hurdles we faced were:
- Getting the code for the map working, with an interactive hover. Also, getting the size, spacing, and colors just right proved a bit tricky.
- Using a single reactive object for our dataset. Initially it was easier to get everything working by copy-pasting the same filters for all the plots. Eventually we worked out how to make this a single reactive object and the app became much faster as a result.
- Simplifying the layout. We have quite a few filter variables and had lots of positive feedback about using histograms on the sliders, but they wouldn't all fit on the left sidebar without scrolling. We experimented with some ideas and settled on the final design with a top and sidebar filters, nicely separated by a title/logo in the corner.

Overall this was an excellent learning experience and took us from beginners with Shiny to being very competent.
