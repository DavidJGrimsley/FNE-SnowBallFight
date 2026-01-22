using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Fortnite.com/Characters }

using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.
# A Verse-authored creative device that mucst be placed in a level for it to work

# This device will regenerate the player's health when they are grinding on a rail
# The amount of health to regenerate per second is chosen in the editor
# The rail that the player must grind on is chosen in the editor
health_regen_device := class(creative_device):
    
    # Grind rail in the level
    @editable
    GrindingRail:grind_rail_device = grind_rail_device{}
    
    # The cooldown period between health regen ticks
    @editable_number(float):
        MinValue:=option{0.1}
    Cooldown:float = 1.0

    # The amount of health to regenerate per second
    @editable_number(float):
        MinValue:=option{1.0}
    HealthRegenRate:float = 5.0
    
    OnBegin<override>()<suspends>:void=
        # Subscribe to the event that is fired when the player starts grinding
        GrindingRail.StartedGrindingEvent.Subscribe(OnGrindingStarted)

    OnGrindingStarted(Agent: agent):void=
        spawn:
            # Set the agent to regen health loop
             ManageGrinding(Agent)

    ManageGrinding(Agent: agent)<suspends>:void=
        race:
            # Wait for the agent to stop grinding or the health to be fully regenerated
            # does not start regenerating again if a player is hit while grinding and their helath was full. I think that's ok though. The player could easily jump on and off and it will keep people from staying on too long
            AwaitGrindingStopped(Agent)
            PeriodicallyGrantHealth(Agent)

    AwaitGrindingStopped(Agent: agent)<suspends>:void=
        # Equivalent to while true
        loop:
            # Wait for the agent to stop grinding
            Inst := GrindingRail.EndedGrindingEvent.Await()
            # If the agent is the same as the one that was grinding, break the loop
            if (Inst = Agent):
                break

    PeriodicallyGrantHealth(Agent: agent)<suspends>:void=
        # Get the FortCharacter of the agent
        if (FC := Agent.GetFortCharacter[]):
            loop:
                # Get the health of the Fortnite character and make sure it is not full
                if(FC.GetHealth() < FC.GetMaxHealth()):    
                    # Store current health plus regen rate variable in a new constant
                    var NewHealth:float = FC.GetHealth() + HealthRegenRate
                    if (NewHealth > FC.GetMaxHealth()):
                        set NewHealth = FC.GetMaxHealth()
                    # Set the player's health to the new health
                    FC.SetHealth(NewHealth)
                # Wait for the cooldown period
                Sleep(Cooldown)