using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

round_device := class(creative_device) :

    
    # @editable
    # PlayerCounter: player_counter_device = player_counter_device{}

    @editable
    Elimination:elimination_manager_device = elimination_manager_device{}
    
    @editable
    GameEnder: end_game_device = end_game_device{}  
    var PlayerCount : int = 0

    OnBegin<override>()<suspends>:void=
        Elimination.EliminatedEvent.Subscribe(OnPlayerEliminated)


        
    OnPlayerEliminated(Agent: agent) : void =
        PlayerList := GetPlayspace().GetPlayers()    
        set PlayerCount = PlayerList.Length
        if (PlayerCount = PlayerList.Length):

            Print("{PlayerCount}")

            if (PlayerCount = 1):
                Print("There is 1 player left. You win. Game over")
                # Activate the End Game Device with the agent
                GameEnder.Activate(Agent)