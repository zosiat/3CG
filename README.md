# 3CG in LÖVE2D

A mythology card game made using Lua and the LÖVE2D framework.

---

## Programming Patterns Used

- **State Pattern**  
Used to manage the game phases, such as the title state, play state, and credits.
- **Event Queue Pattern**
Used for queueing and using card effects such as the "when revealed" and "end of turn" effects.
- **Flyweight Pattern**
Used to manage future card sprites.
- **Dirt Flag**
Used for UI updates when the card data changes.
---

## Peer Feedback

- **Leo Assimes**  
 *Feedback:* Liked the overall structure, but suggested to create global variables for the `ScreenHeight` and `ScreenWidth`, because they were being created locally in various functions in the `PlayState.lua` file. Additionally, he suggested creating a sort of visual grid to debug why cards were not being placed in the slots / color areas properly. Also suggested moving some code out of the `PlayState.lua` file, as it was quite long.
   *Response:* Tried to clear up some of the crowdedness of `PlayState`. I also took the advice to add that debugging grid, and it helped clarify some of the issues (although I am still debugging as of writing this README). Made those global variables.
---

**What went well:**  
Overall, I really liked how my organization with all of the different files went, and I really like how the states worked out. The structure of this project felt a lot better than how my Solitaire game was constructued. 

**What I would do differently:**  
In all honesty, I had a really hard time working on this project (and the previous ones in this class) because card games are one of my least favorite game genres. I've really succeeded in previous classes where we had more creative liberties on the types of games we can create, and a lot of the project constraints made it hard for me to feel like I had creative input, leading to me having a hard time working on it. With my other classes also being project based this quarter and my work schedule, I was quite overwhelmed, and struggled to organize my time. I know that the fact that there was no extension on this final assignment was mentioned various times, but because I took that extra week on the first iteration of 3CG, I struggled to catch up. I think that actually creating assets would have been really fun for me, and given me the opportunity to have more agency, I unfortunately spent all my time trying to get the turn structure working. In summary, better time management from me and finding ways to be more engaged would probably have saved this project.

---

## Assets

- **Audio Assets:** [https://kenney.nl/assets/interface-sounds](https://kenney.nl/assets/interface-sounds)  
  All card sprites were created by me.

  - **Libraries:**
  Uses the dkjson.lua library 
  [https://github.com/LuaDist/dkjson/blob/master/dkjson.lua]
