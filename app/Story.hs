module Story where
import Types (PlayerChoice (PlayerChoice), ScenarioOutcome (ScenarioOutcome), StartWorld (StartWorld), Player (Player))
import Data.Map qualified as Map (fromList, lookup, keys)
import Data.Map.Internal as Internal (Map)

startScenario :: ScenarioOutcome
startScenario =
  ScenarioOutcome
    "What type of world would you like?"
    [ PlayerChoice "Swamp (dark and stormy)" ["1"] 0,
      PlayerChoice "Magical candy castle in the clouds (light and magical)" ["1"] 0,
      PlayerChoice "Desert (dry and windy and sunny)" ["1"] 0,
      PlayerChoice "Virtual world (futuristic, EDM music)" ["1"] 0
    -- To add a story world, add another PlayerChoice option here. Add a key to refer to your added world in allStoryWorldKeys 
    ]

-- each key here corresponds to the array in startScenario, of a matching index.
allStoryWorldKeys :: [String]
allStoryWorldKeys = ["swamp", "magical", "desert", "virtual"]

studioStartWorld :: StartWorld -- an example scenario
studioStartWorld =
  StartWorld
    "You are sitting in your studio apartment, watching youtube videos of cats, when you see you've received an email. It's the results for your job interview last week.\nYou slowly reach your mouse towards the email. Your hands tremble.\nBam! You get hit by a truck."
    [ "The truck thing was your real interview. You get the job!",  -- good outcome
      "It was actually a scam email",                               -- neutral outcome
      "The truck thing was your real interview. You didn't pass"    -- bad outcome
    ]
    [0.2, 0.2, 0.3, 0.3] -- probability of going to each story world based on your starting world. The size of this probability array corresponds to the number of story worlds (size of allStoryWorldKeys)

-- add more starting worlds here
startWorldsDict :: Internal.Map String StartWorld
startWorldsDict =
  Map.fromList
    [ ( "studio",
        studioStartWorld
      ),
      ( "countryside",
        StartWorld
          "You're in the countryside.\nThere's a barren feel to the place.\nYou stab your hoe at the ground, bored out of your mind.\nSuddenly, a truck comes up out of nowhere, and bam! You black out."
          [ "After your adventure, you come back to find your hoe has become magical. You become the best farmer in the galaxy",
            "You realize after your long adventure that farming is your one true passion.",
            "Your crops have all dried up. Now you are penniless."
          ]
          [0.2, 0.2, 0.5, 0.1]
      ),
      ( "teddy",
        StartWorld
          "On a dark and stormy night, you hug your teddy bear tightly. Thunder crackles outside your window. \"Dear Teddy,\" you say. \"At least I have you.\" \nAll of a sudden, a truck hits you. In an instant, everything went dark. You grasp around for your teddy. But it was too late. Teddy's stitches had come undone, his stuffing spilling out like a river of memories. With trembling hands, you gather Teddy's broken body, holding him close one last time. Tears stream down your cheeks as you feel Teddy's whispers words of apology and love. In that final moment, as the darkness of the truck engulfs you, you know that you have been truly loved, and that was all that mattered."
          [ "A tailor poofs in front of you, and fixes up your teddy bear. Your face shines in happiness, as you bring your teddy in for a long bear hug.",
            "You rise up in your kingdom, and order all trucks to be destroyed in your kingdom. You hold a funeral for your Teddy, and cry many buckets.",
            "You find out that your teddy hates you, and sent you on that adventure to take over your kingdom. Now you are a lowly subject, working for your cruel overlord, king Teddy."
          ]
          [0.5, 0.1, 0.2, 0.2]
      ),
      ( "jobsearch",
        StartWorld
          "One day after job searching, you are making your way back home when a truck sends you to another world. You must navigate this new world and try to make your way home back to job search."
          [ "You've made it back home! You see that your inbox has many new messages! It seems that some carry good news.",
            "You lie in bed, browsing through your emails. No good news, but there are some promising opportunities presenting themselves.",
            "You crash in through the door, the deadlines for the applications you have prepped have all passed, and there is nothing new in your inbox."
          ]
          [0.2, 0.2, 0.2, 0.3]
      ),
      ( "network",
        StartWorld
          "One day during a networking session, you begin to introduce yourself to an alumni while ordering at a cafe. Before you can even begin to express your admiration and respect, \nBANG! \nA truck appeared in the cafe where you were standing seconds before."
          [ "Your networking meeting has gone swimmingly. You have gained a valuable connection in the industry you hope to join.",
            "Shaken up, you stutter your way through your talk, but hey! The alumni still has a slightly positive impression of you.",
            "Oh no! You've spilled coffee all over the alumni and yourself. Mortified, you run away never to see this cafe or the alumni again."
          ]
          [0.2, 0.2, 0.3, 0.2]
      ),
      ( "recommendation",
        StartWorld
          "It is a dark and stormy night. While you are mustering up the courage to ask your professor for a recommendation letter, a truck has already recommended you to another world."
          [ "You wake up in your room to find that your professor wrote a glowing review, praising your performance in class and fervently recommending you.",
            "Your professor writes you a recommendation letter, while slightly struggling to remember who you are. Well, you've gotten the recommendation so don't forget to thank your professor.",
            "Recommendation letter? This professor doesn't even know you. Where have you gone?"
          ]
          [0.5, 0.1, 0.2, 0.2]
      ),
      ( "job",
        StartWorld
          "You've finally got a job! \nUnfortunately, it's a slightly sketchy job, but it's the only job that you've got at this point. As you navigate towards the alleyway they have directed you towards, a mass of fear and anticipation resting on your shoulders, you realize, \n\"Wait a second, this is a truck yard\". \nIt is a portal to another world."
          [ "You get a call as you leave the truck yard, and it turns out you made a wrong turn. Your job is actually at the high end place down the street.", -- good outcome
            "While your new job still seems sketchy, it is in fact a job.", -- neutral outcome
            "Huh! You don't actually have a job, it appears you were daydreaming." -- bad outcome
          ]
          [0.2, 0.1, 0.5, 0.2]
      )
      -- To create another starting world, create a StartWorld object (ex. above) here (startWorldsDict)
      -- It should have a good outcome, a neutral one, and a bad one, in that order. 
    ]

endScenario :: ScenarioOutcome
endScenario = ScenarioOutcome "end" []

-- add more scenarios here
scenariosDict :: Internal.Map String ScenarioOutcome
scenariosDict =
  Map.fromList
    [ ("end", ScenarioOutcome "end" []),
      ( "*",
        ScenarioOutcome
          "You've successfully avoided job search. You spend your days frolicking around with butterflies. But when will you get back to reality?"
          []
      ),
      ( "1",
        ScenarioOutcome
          "You open your eyes, and see butterflies fluttering all around you. They place a crown made of silk on your head. You push yourself up. They all bow down. \n\"Butterfly Monarch,\" they cry out. \"Save us from the evil frogs who have kidnapped our children.\""
          [ PlayerChoice "Throw away the crown. What rubbish!" ["2", "11"] 1,
            PlayerChoice "Love frogs, so you agree to save them, but secretly collect information about them so you can betray the butterflies later" ["4"] (-1),
            PlayerChoice "Point your sword to the sky, and declare you will save the butterflies, and destroy the frogs!" ["4", "10", "3", "5"] 9,
            PlayerChoice "As a seasoned ruler, you calmly order the butterflies to bring you a plate of jelly beans." ["2"] 7
          ]
      ),
      ( "2",
        ScenarioOutcome
          "Ouch! An apple hits your head. You open your eyes to a crowd of jeering frogs. You survey your surroundings. You are smack in the middle of an ancient roman gladiator stadium. Slop! A tomato splatters all over your face. Your worst nightmare has come true! But before the life seeps out of your eyes, darkness descends on the stadium. Amid the panicked croaks, you feel some tiny fluttering creatures drag you away. When you awake again, they ask you. \"Brave hero, will you take up our charitable cause to destroy the evil frogs?"
          [ PlayerChoice "\"Of course! They will pay for this great humiliation!\"" ["4", "3"] 7,
            PlayerChoice "\"Destroy them? Never! They've already destroyed me!\"" ["11", "9", "5"] 2,
            PlayerChoice "\"Will I be paid? Is this job? My greatest strength is that I will sell my soul to be employed.\"" ["3", "4", "5"] 5,
            PlayerChoice "\"DEATH TO THE FROGS. DEATH TO THE FROGS. DEATH TO THE FROGS. DEATH TO THE FROGS. DEATH TO THE FROGS. DEATH TO THE FROGS. DEATH TO THE FROGS. DEATH TO THE FROGS. DEATH TO THE FROGS.\"" ["3", "5"] 9
          ]
      ),
      ( "3",
        ScenarioOutcome
          "You find yourself at the edge of a dark and gloomy forest. What to do? You've got to cross it to get to Froglandia. What will you choose..."
          [ PlayerChoice "Turn back, nope, this dark forest is not for meeeee" ["1", "9", "11"] 2,
            PlayerChoice "Send butterfly scouts deep into the woods, but it does not seem likely that they will return" ["10.5"] (-3),
            PlayerChoice "Bravely forge ahead." ["5"] 8,
            PlayerChoice "The frogs will protect me I will be safe." ["5", "2"] 1,
            PlayerChoice "Scout around the area for tools that may be useful." ["4", "5"] 7
          ]
      ),
      ( "4",
        ScenarioOutcome
          "As you are preparing for the next step of your journey, you realize that you may need some tools. As you look around, you see some potentially useful items..."
          [ PlayerChoice "Wow, this lamp seems useful" ["3"] 8,
            PlayerChoice "I need nothing but my own courage and skills" ["5"] 6,
            PlayerChoice "Give me everything you offer" ["5"] 4,
            PlayerChoice "Money, money, money, MONEYYYYYYY!!!!!" ["5"] 10
          ]
      ),
      ( "5",
        ScenarioOutcome
          "You've run into a giant frog henchman. What will you do next?"
          [ PlayerChoice "Flee. My life is not worth this." ["11", "10.5", "9"] 1,
            PlayerChoice "Sacrifice the butterflies. Hey, I've got more important things to do" ["10.5", "10", "6", "8"] (-5),
            PlayerChoice "Prepare for battle. Even though I've spent everyday job searching... Wish me luck." ["6", "10", "7"] 8,
            PlayerChoice "Prepare for battle! I've got this!" ["8", "6", "7"] 8,
            PlayerChoice "I can convince this frog that I'm on his side." ["7", "6", "8"] 6
          ]
      ),
      ( "6",
        ScenarioOutcome
          "After a long and arduous confrontation, the frog henchman decides to flee and report back. How will you move forward?"
          [ PlayerChoice "No matter, I am prepared to move forward" ["10", "5", "10.5"] 8,
            PlayerChoice "Oh no, I've got to turn back and recoup" ["9", "11"] 4,
            PlayerChoice "Speed up to apprehend the henchman again" ["3", "5", "10", "10.5"] 7,
            PlayerChoice "I'm on the frogs' side? Why should I stop it. Pretend to accidentally let it go." ["10", "10.5"] (-1)
          ]
      ),
      ( "7",
        ScenarioOutcome
          "You've defeated the frog henchman with ease. How will you deal with it and what is your next course of action?"
          [ PlayerChoice "Dispose of it. That way, no one will be able to alert the frogs. And let's continue onwards" ["10"] 10,
            PlayerChoice "How could I forget? I am with the frogs. Let it go, but its defeat shall lure the butterflies into a false sense of security, Mwahhahahahahahah." ["3", "2", "10.5", "10"] (-2),
            PlayerChoice "I'll show it some mercy but just to be safe, I'll send it back to the butterflies." ["9", "10"] 7,
            PlayerChoice "I'll show some mercy, it will guide me to the frog monarch or else!" ["10"] 8
          ]
      ),
      ( "8",
        ScenarioOutcome
          "The frog henchman has defeated you. Despite your valiant efforts, the frog henchman has easily defeated you. Now it is thinking of capturing you. How are you to move forward?"
          [ PlayerChoice "Run away! The frogs are too scary!" ["9", "11"] 1,
            PlayerChoice "I was just pretending to be defeated, I'm  on the frogs' side, remember? This is also part of my plan" ["10.5"] (-2),
            PlayerChoice "Evade capture! The frogs may have won this battle, but I'll win the war!" ["10"] 6,
            PlayerChoice "I'll allow myself to be captured, but that just means I'll be brought right to the frog monarch, where I'll show it my might!" ["10.5"] 8
          ]
      ),
      ( "9",
        ScenarioOutcome
          "You've decided to retreat. The butterflies welcome you back disappointedly but resigned. They offer you the choice to try again or to give up."
          [ PlayerChoice "I'm going back home, it's not worth it! Send me home!" ["11", "end"] 1,
            PlayerChoice "I can keep going, let me try again." ["3", "5", "10"] 7,
            PlayerChoice "I guess I can keep going? Give me more money and I'll do it." ["4"] 8
          ]
      ),
      ( "10",
        ScenarioOutcome
          "You valiantly march onwards towards the frogs' lair, as prepared as you ever will be. The ominous castle looms closer and closer, increasing in size along with the pit of fear and anxiety in your chest. Wow, this may even be more scary than job search. But you've decided to do this and so you will. Now, you see the frog monarch, more intimidating than you ever thought. It snarls and offers you some choices, how will you respond?"
          [ PlayerChoice "Fight! I will never give up" ["end"] 7,
            PlayerChoice "Surrender, frogs are too scary. I'm sorry, butterflies, but I can't!" ["end"] (-10),
            PlayerChoice "Is it too late to run away?" ["end"] 2,
            PlayerChoice "I've prepared this long, I guess I'll do my best." ["end"] 7
          ]
      ),
      ( "10.5",
        ScenarioOutcome
          "You've failed to evade capture. A frog henchman found you and is now bringing you to the frog monarch. Scary scary. How will you respond?"
          [ PlayerChoice "Fight! I will never give up" ["end"] 7,
            PlayerChoice "Surrender, frogs are too scary. I'm sorry, butterflies, but I can't!" ["end"] (-100),
            PlayerChoice "Is it too late to run away?" ["end"] (-2),
            PlayerChoice "I've prepared this long, I guess I'll do my best." ["end"] 7
          ]
      ),
      ( "11",
        ScenarioOutcome
          "It's time to make a choice. You see a mysterious glowing portal appear two steps ahead. Will you take the wager and hope to go home?"
          [ PlayerChoice "Stay" ["*"] 1,                    -- game will end
            PlayerChoice "Continue the adventure" ["3"] 1,  -- game continues
            PlayerChoice "Go home" ["end"] 1                -- game will end
          ]
      ) 
      -- To create another scenario, choose a key for it, and create a ScenarioOutcome object (ex. above) here (scenariosDict)
      -- Check the Types.hs file for more details on how to create a ScenarioOutcome object
    ]

-- add any additional ending scenarios here
endScenariosDict :: Internal.Map String ScenarioOutcome
endScenariosDict =
  Map.fromList
    [ ( "*",
        ScenarioOutcome
          "You've successfully avoided job search. You spend your days frolicking around with butterflies. But when will you get back to reality?"
          []
      ),
      ( "end", endScenario)
    ]
