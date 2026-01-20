
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
# using { VendingModule }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
snow_device := class(creative_device):

    @editable IN_Vending_Manager : vending_manager = vending_manager{}
       

    @editable
    SnowTime: float = 90.0
    @editable
    SnowMeltingTime: float = 5.0
    @editable
    SnowFormingTime: float = 7.0
    @editable_number(float):
        MinValue:=option{30.0}
    SnowMeltedTime: float = 60.0

    # Phase counter 
    var Phase: int = 1
    
    # Messages to show when the snow is forming, snowing, melting, and melted
    SnowFormingMessage<localizes>: message = "Snowpiles are forming!"
    SnowMessage<localizes>: message = "Scoop some snow!"
    SnowMeltingMessage<localizes>: message = "Snow is melting!"
    SnowMeltedMessage<localizes>: message = "Snow is gone for now!"

    @editable
    HUD: hud_message_device = hud_message_device{}

    # Arrays to store the buttons, piles, spawners, and vending machines
    var SnowButtons : []button_device = array{}
    var SnowPiles : []creative_prop = array{}
    var SnowSpawners : []vfx_spawner_device = array{}
    var Timers : []timer_device = array{} 
    var Billboards : []billboard_device = array{}
   

    OnBegin<override>()<suspends>:void=
        # Find all the buttons in the level that have the snowButton tag
        FoundSpawners := FindCreativeObjectsWithTag(snowVFX{})
        FoundButtons := FindCreativeObjectsWithTag(snowButton{})
        FoundPiles := FindCreativeObjectsWithTag(snowPile{})
        FoundTimersAndBillBoards := FindCreativeObjectsWithTag(SnowLaunchVendTimer{})
        # Cast and populate Items
        for (Item : FoundTimersAndBillBoards):
            if (Timer := timer_device[Item]):
                set Timers = Timers + array{Timer}
            if (Billboard := billboard_device[Item]):
                set Billboards = Billboards + array{Billboard}
        Print("Found {Timers.Length} timers")
        Print("Found {Billboards.Length} billboards")
        for (Button : FoundButtons, CastedItem := button_device[Button]):
            set SnowButtons = SnowButtons + array{CastedItem}


        for (Pile : FoundPiles, CastedItem := creative_prop[Pile]):
            set SnowPiles = SnowPiles + array{CastedItem}
    
        for (Spawner : FoundSpawners, CastedItem := vfx_spawner_device[Spawner]):
            set SnowSpawners = SnowSpawners + array{CastedItem}
            # CastedItem.EffectEnabledEvent.Subscribe(EnableSnowButtons)
            # CastedItem.EffectDisabledEvent.Subscribe(DisableSnowButtons)
       
        # DEBUG: Print the number of buttons found
        Print("Found {SnowButtons.Length} snow buttons")
        Print("Found {SnowPiles.Length} snow piles")
        Print("Found {SnowSpawners.Length} snow spawners")
        Print("Phase: {Phase}.")

        DisableSnowButtons()
        DisableSnowSpawners()
        spawn:
            SnowPhase()
                
        
    SnowPhase()<suspends>:void=
        loop:
            if (Phase <= 2):
                ResetTimers(SnowTime+SnowMeltedTime)
            else:
                DestroyTimers()
            Snow()
            Melted()
    
# Cool Down functions
    Snow()<suspends>:void=
        EnableSnowSpawners()
        spawn:
            SnowForming()
        Sleep(SnowTime)
        DisableSnowSpawners()
        spawn:
            SnowMelting()

    SnowForming()<suspends>:void=
        HUD.Show(SnowFormingMessage, ?DisplayTime:=SnowFormingTime/2.0)
        Sleep(SnowFormingTime)
        EnableSnowButtons()
        HUD.Show(SnowMessage, ?DisplayTime:=SnowTime/2.0)
    
        
    SnowMelting()<suspends>:void=
        HUD.Show(SnowMeltingMessage, ?DisplayTime:=SnowMeltingTime/2.0)
        Sleep(SnowMeltingTime)
        DisableSnowButtons()  
        HUD.Show(SnowMeltedMessage, ?DisplayTime:=SnowMeltedTime/2.0)
        
    Melted()<suspends>:void=
        Sleep(SnowMeltedTime)
        if (Phase >= 1):
            if (IN_Vending_Manager.SpawnVendingMachines[Phase]):
                Print("Vending Machines Spawned")
            else:
                Print("Vending Machines Not Spawned")
        set Phase += 1
        Print("Phase: {Phase}.")
        
    
# Enable/Disable functions
    EnableSnowSpawners():void=
        for (Spawner : SnowSpawners):
            Spawner.Enable()
            Spawner.Restart()
            Print("Snow spawner enabled")

    DisableSnowSpawners():void=
        for (Spawner : SnowSpawners):
            Spawner.Disable()
            Print("Snow spawner disabled")

    EnableSnowButtons():void=
        for (Button : SnowButtons):
            Button.Enable()
        for (SnowPile : SnowPiles):
            SnowPile.Show()

    DisableSnowButtons():void=
        for (Button : SnowButtons):
            Button.Disable()
        for (SnowPile : SnowPiles):
            SnowPile.Hide()

#Reset Timers
    ResetTimers(Duration: float):void=
        for (Timer : Timers):
            Timer.ResetForAll()     
            Timer.SetMaxDuration(Duration)
            Timer.StartForAll()
    
    DestroyTimers():void=
        for (Timer : Timers):
            Timer.Disable()
            if (IN_Vending_Manager.TeleportTimer[Timer]) {}
        for (Billboard : Billboards):
            Billboard.HideText()