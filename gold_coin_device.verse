
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

gold_coin_device := class(creative_device):
    
    # Item granters
    @editable
    LargeGranter: item_granter_device = item_granter_device{}
    @editable
    MediumGranter: item_granter_device = item_granter_device{}
    @editable
    SmallGranter: item_granter_device = item_granter_device{}
    
    # Accolade device that grants a very small xp
    @editable
    CoinAccolade: accolades_device = accolades_device{}

    OnBegin<override>()<suspends>:void=
        # Find all the collectible objects in the level
        FoundGoldCoins := FindCreativeObjectsWithTag(Gold{})
        FoundSilverCoins := FindCreativeObjectsWithTag(Silver{})
        FoundBronzeCoins := FindCreativeObjectsWithTag(Bronze{})

        # Iterate through the generators, populate the class variable arrays, and subscribe to the events
        for (GoldCoin : FoundGoldCoins, CastedCollectible := collectible_object_device[GoldCoin]):
            CastedCollectible.CollectedEvent.Subscribe(GrantThree)
            CastedCollectible.CollectedEvent.Subscribe(GrantCoinXP)
                
        for (SilverCoin : FoundSilverCoins, CastedCollectible := collectible_object_device[SilverCoin]):
            CastedCollectible.CollectedEvent.Subscribe(GrantTwo)
            CastedCollectible.CollectedEvent.Subscribe(GrantCoinXP)
             
        for (BronzeCoin : FoundBronzeCoins, CastedCollectible := collectible_object_device[BronzeCoin]):
            CastedCollectible.CollectedEvent.Subscribe(GrantOne)
            CastedCollectible.CollectedEvent.Subscribe(GrantCoinXP)
        
    # Functions that grant items (1, 2, and 3 gold in this case)
    GrantOne(Agent:agent):void=
        SmallGranter.GrantItem(Agent)
    GrantTwo(Agent:agent):void=
        MediumGranter.GrantItem(Agent)
    GrantThree(Agent:agent):void=
        LargeGranter.GrantItem(Agent)
    
    # Function that grants the coin accolade
    GrantCoinXP(Agent:agent):void=
        CoinAccolade.Award(Agent)