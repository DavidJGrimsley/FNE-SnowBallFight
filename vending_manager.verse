using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

vending_manager := class(creative_device):
    @editable
    CastleTransform : transform = transform{
        Translation := vector3{X := 100.0, Y := 200.0, Z := 0.0},
        Rotation := MakeRotationFromYawPitchRollDegrees(YawRightDegrees := 0.0, PitchUpDegrees := 0.0, RollClockwiseDegrees := 0.0),
        Scale := vector3{X := 1.0, Y := 1.0, Z := 1.0}
    }

    @editable
    IceHouseTransform : transform = transform{
        Translation := vector3{X := 300.0, Y := 200.0, Z := 0.0},
        Rotation := MakeRotationFromYawPitchRollDegrees(YawRightDegrees := 0.0, PitchUpDegrees := 0.0, RollClockwiseDegrees := 0.0),
        Scale := vector3{X := 1.0, Y := 1.0, Z := 1.0}
    }

    @editable
    IceChairTransform : transform = transform{
        Translation := vector3{X := 500.0, Y := 200.0, Z := 0.0},
        Rotation := MakeRotationFromYawPitchRollDegrees(YawRightDegrees := 0.0, PitchUpDegrees := 0.0, RollClockwiseDegrees := 0.0),
        Scale := vector3{X := 1.0, Y := 1.0, Z := 1.0}
    }

    @editable
    ArcticTransform : transform = transform{
        Translation := vector3{X := 700.0, Y := 200.0, Z := 0.0},
        Rotation := MakeRotationFromYawPitchRollDegrees(YawRightDegrees := 0.0, PitchUpDegrees := 0.0, RollClockwiseDegrees := 0.0),
        Scale := vector3{X := 1.0, Y := 1.0, Z := 1.0}
    }
    
    @editable
    var CastleVMs : []vending_machine_device = array{}
    @editable
    var IceHouseVMs : []vending_machine_device = array{}
    @editable
    var IceChairVMs : []vending_machine_device = array{}
    @editable
    var ArcticVMs : []vending_machine_device = array{}

    # Transform to send the vending machine to when 'hiding'
    @editable
    var HideTransform : transform = transform{
        Translation := vector3{X := 0.0, Y := 0.0, Z := -1000.0},
        Rotation := MakeRotationFromYawPitchRollDegrees(YawRightDegrees := 0.0, PitchUpDegrees := 0.0, RollClockwiseDegrees := 0.0),
        Scale := vector3{X := 1.0, Y := 1.0, Z := 1.0}
    }   
    
    # Meant to be called on the first wave.
    SpawnVendingMachines(Wave: int)<decides><transacts>: void =
        if (0 < Wave < 4):
            # Remove current vending machines
            # Bring in next round of vending machines
            if (Wave < CastleVMs.Length):
                CastleVMs[Wave - 1].TeleportTo[HideTransform]
                CastleVMs[Wave].TeleportTo[CastleTransform]
            
            if (Wave < IceHouseVMs.Length):
                IceHouseVMs[Wave - 1].TeleportTo[HideTransform]
                IceHouseVMs[Wave].TeleportTo[IceHouseTransform]
            
            if (Wave < IceChairVMs.Length):
                IceChairVMs[Wave - 1].TeleportTo[HideTransform]
                IceChairVMs[Wave].TeleportTo[IceChairTransform]
            
            if (Wave < ArcticVMs.Length):
                ArcticVMs[Wave - 1].TeleportTo[HideTransform]
                ArcticVMs[Wave].TeleportTo[ArcticTransform]

    TeleportTimer(Timer: timer_device)<decides><transacts>:void=
        Timer.TeleportTo[HideTransform]

    
    

