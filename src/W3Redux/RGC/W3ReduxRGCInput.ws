/**
 * extension of CPlayerInput meant to compartmentalize the drastic changes W3ReduxRGC makes to playerInput.ws
 * with the purpose of easier merging of the file with other mods.
 *
 * This class explicitly alters the behavior of the following buttons:
 * A, B, X, Y, LB, RB, RT, DPAD UP, DPAD DOWN
 * Other mods that try to react to these inputs may not see the input at all!!!
 * It is recommended to not use any other control mods that make use of these buttons
 * Author: Adam Sunderman
 */

 class W3ReduxRGCInput extends CPlayerInput
 {
	public function Initialize(isFromLoad : bool, optional previousInput : CPlayerInput)
	{
		//let Vanilla Input initialize with same parameters
		super.Initialize(isFromLoad, previousInput);

		//we never allow alt sign casting
		altSignCasting = false;

		//register listeners for new commands available in RGC
		theInput.RegisterListener( this, 'OnRGCRealtimeModifier', 'RGC_RealtimeModifier' );
		theInput.RegisterListener( this, 'OnRGCCastIgni', 'RGC_CastIgni' );
		theInput.RegisterListener( this, 'OnRGCCastAard', 'RGC_CastAard' );
		theInput.RegisterListener( this, 'OnRGCCastQuen', 'RGC_CastQuen' );
		theInput.RegisterListener( this, 'OnRGCCastYrden', 'RGC_CastYrden' );
		theInput.RegisterListener( this, 'OnRGCCastAxii', 'RGC_CastAxii' );
		theInput.RegisterListener( this, 'OnRGCCrossBow', 'RGC_CrossBow' );
		theInput.RegisterListener( this, 'OnRGCCrossBowHold', 'RGC_CrossBowHold' );
		theInput.RegisterListener( this, 'OnRGCEquipQuickItem', 'RGC_EquipQuickItem' );
		theInput.RegisterListener( this, 'OnRGCEquipBomb', 'RGC_EquipBomb' );
		theInput.RegisterListener( this, 'OnRGCNextBolt', 'RGC_NextBolt_V2' );
		theInput.RegisterListener( this, 'OnRGCInfiniteBolt', 'RGC_InfiniteBolt');
		theInput.RegisterListener( this, 'OnRGCSpawnHorse', 'RGC_SpawnHorse');
	}

	public function RGC_CastSign(sign : ESignType) : bool
	{
		//declare vars
		var signSkill : ESkill;

		//convert sign enumeration into actual Witcher Player skill
		signSkill = SignEnumToSkillEnum( sign );

		//validate skill is not undefined defined
		if( signSkill == S_SUndefined )
		{
			//Uh oh
			return false;
		}

		//immediately equip the desired sign
		GetWitcherPlayer().SetEquippedSign(sign);

		//can cast validation
		if( !IsActionAllowed(EIAB_Signs) )
		{
			thePlayer.DisplayActionDisallowedHudMessage(EIAB_Signs);
			return false;
		}
		if ( thePlayer.IsHoldingItemInLHand() && thePlayer.IsUsableItemLBlocked() )
		{
			thePlayer.DisplayActionDisallowedHudMessage(EIAB_Undefined, false, false, true);
			return false;
		}

		//skill validation
		if(!thePlayer.CanUseSkill(signSkill))
		{
			thePlayer.DisplayActionDisallowedHudMessage(EIAB_Signs, false, false, true);
			return false;
		}
		if(!thePlayer.HasStaminaToUseSkill( signSkill, false ) )
		{
			thePlayer.SoundEvent("gui_no_stamina");
			return false;
		}

		//Validated. Cast Sign!
		thePlayer.SetupCombatAction( EBAT_CastSign, BS_Pressed );
		return true;
	}

	event OnRGCRealtimeModifier(action : SInputAction)
	{
		//RGC doesn't affect Ciri and is only applicable to gamepad users
		if(thePlayer.IsCiri() || !theInput.LastUsedGamepad())
		{
			GetWitcherPlayer().RGC_SetInRealtimeEquipCastMode(false);
			return false;
		}

		if(IsPressed(action))
		{
			//realtime modifier was just pressed. This flag is utilized by most events to allow realtime
			//sign casting and item selection without the radial menu
			GetWitcherPlayer().RGC_SetInRealtimeEquipCastMode(true);
		}
		else if(IsReleased(action))
		{
			//realtime modifier was just released. Back to default actions
			GetWitcherPlayer().RGC_SetInRealtimeEquipCastMode(false);
		}
	}

	event OnRGCCastIgni(action : SInputAction)
	{
		//RGC doesn't affect Ciri and is only applicable to gamepad users
		if(thePlayer.IsCiri() || !theInput.LastUsedGamepad())
		{
			return false;
		}

		//must have realtime modifier active
		if(GetWitcherPlayer().RGC_IsInRealtimeEquipCastMode())
		{
			//make sure action is pressed
			if(IsPressed(action))
			{
				//cast igni
				RGC_CastSign(ST_Igni);
			}
		}
	}

	event OnRGCCastAard(action : SInputAction)
	{
		//RGC doesn't affect Ciri and is only applicable to gamepad users
		if(thePlayer.IsCiri() || !theInput.LastUsedGamepad())
		{
			return false;
		}

		//must have realtime modifier active
		if(GetWitcherPlayer().RGC_IsInRealtimeEquipCastMode())
		{
			//make sure action is pressed
			if(IsPressed(action))
			{
				//cast aard
				RGC_CastSign(ST_Aard);
			}
		}
	}

	event OnRGCCastQuen(action : SInputAction)
	{
		//RGC doesn't affect Ciri and is only applicable to gamepad users
		if(thePlayer.IsCiri() || !theInput.LastUsedGamepad())
		{
			return false;
		}

		//must have realtime modifier active
		if(GetWitcherPlayer().RGC_IsInRealtimeEquipCastMode())
		{
			//make sure action is pressed
			if(IsPressed(action))
			{
				//cast quen
				RGC_CastSign(ST_Quen);
			}
		}
	}

	event OnRGCCastYrden(action : SInputAction)
	{
		//RGC doesn't affect Ciri and is only applicable to gamepad users
		if(thePlayer.IsCiri() || !theInput.LastUsedGamepad())
		{
			return false;
		}

		//must have realtime modifier active
		if(GetWitcherPlayer().RGC_IsInRealtimeEquipCastMode())
		{
			//make sure action is pressed
			if(IsPressed(action))
			{
				//cast Yrden
				RGC_CastSign(ST_Yrden);
			}
		}
	}

	event OnRGCCastAxii(action : SInputAction)
	{
		//RGC doesn't affect Ciri and is only applicable to gamepad users
		if(thePlayer.IsCiri() || !theInput.LastUsedGamepad())
		{
			return false;
		}

		//must have realtime modifier active
		if(GetWitcherPlayer().RGC_IsInRealtimeEquipCastMode())
		{
			//make sure action is pressed
			if(IsPressed(action))
			{
				//cast Axii
				RGC_CastSign(ST_Axii);
			}
		}
	}

	event OnRGCCrossBow(action : SInputAction)
	{
		//NOTES: Used crossbow logic of OnCbtThrowItem as base
		var ret : bool;
		var itemId : SItemUniqueId;

		GetWitcherPlayer().RGC_Update();

		//On button press, select crossbow
		if(IsPressed(action))
		{
			GetWitcherPlayer().SelectQuickslotItem(EES_RangedWeapon);
		}

		//validation of player
		if(thePlayer.IsInAir() || thePlayer.GetWeaponHolster().IsOnTheMiddleOfHolstering())
		{
			return false;
		}
		if( thePlayer.IsSwimming() && !thePlayer.OnCheckDiving() && thePlayer.GetCurrentStateName() != 'AimThrow' )
		{
			return false;
		}

		//validation of item
		itemId = thePlayer.GetSelectedItemId();
		if(!thePlayer.inv.IsIdValid(itemId) || !thePlayer.inv.IsItemCrossbow(itemId))
		{
			return false;
		}

		//crossbow button press logic
		if ( IsActionAllowed(EIAB_Crossbow) )
		{
			//on press
			if( IsPressed(action))
			{
				//are we ready to aim crossbow immediately?
				if ( thePlayer.IsHoldingItemInLHand() && !thePlayer.IsUsableItemLBlocked() )
				{
					//setup restore action to interact with crossbow when its available
					thePlayer.SetPlayerActionToRestore ( PATR_Crossbow );
					thePlayer.OnUseSelectedItem( true );
					ret = true;
				}
				else if ( thePlayer.GetBIsInputAllowed() && !thePlayer.IsCurrentlyUsingItemL() )
				{
					//initialize player to state aiming, send combat action to start state machines
					thePlayer.SetIsAimingCrossbow( true );
					thePlayer.SetupCombatAction( EBAT_ItemUse, BS_Pressed );
					ret = true;
				}
			}
			//on release
			else if(IsReleased(action))
			{
				if ( thePlayer.GetIsAimingCrossbow() && !thePlayer.IsCurrentlyUsingItemL() )
				{
					//send combat action Release to trigger onRelease statemachine flow
					//and reset player to not aiming state
					thePlayer.SetupCombatAction( EBAT_ItemUse, BS_Released );
					thePlayer.SetIsAimingCrossbow( false );
					thePlayer.SetThrowHold(false);
					ret = true;
				}
			}
		}
		else
		{
			if ( !thePlayer.IsInShallowWater() )
			{
				//can't use crossbow feedback
				thePlayer.DisplayActionDisallowedHudMessage(EIAB_Crossbow);
			}
		}

		return ret;
	}

	event OnRGCCrossBowHold( action : SInputAction )
	{
		//NOTES: Used crossbow logic of OnCbtThrowItemHold as base
		var itemId : SItemUniqueId;

		GetWitcherPlayer().RGC_Update();

		//validation of player
		if(thePlayer.IsInAir() || thePlayer.GetWeaponHolster().IsOnTheMiddleOfHolstering() )
		{
			return false;
		}
		if( thePlayer.IsSwimming() && !thePlayer.OnCheckDiving() && thePlayer.GetCurrentStateName() != 'AimThrow' )
		{
			return false;
		}

		//validation of item
		itemId = thePlayer.GetSelectedItemId();
		if(!thePlayer.inv.IsIdValid(itemId) || !thePlayer.inv.IsItemCrossbow(itemId))
		{
			return false;
		}

		//validate press
		if(IsPressed(action))
		{
			if(!IsActionAllowed(EIAB_Crossbow))
			{
				thePlayer.DisplayActionDisallowedHudMessage(EIAB_Crossbow);
				return false;
			}
		}

		//on press
		if(IsPressed(action))
		{
			//set player state to throw hold
			thePlayer.SetThrowHold(true);
			return true;
		}
		else if(IsReleased(action) && thePlayer.IsThrowHold())
		{
			return true;
		}

		return false;
	}

	event OnRGCEquipQuickItem(action : SInputAction)
	{
		//RGC doesn't affect Ciri and is only applicable to gamepad users
		if(thePlayer.IsCiri() || !theInput.LastUsedGamepad())
		{
			return false;
		}

		//quickslot items are available while modifier is active
		if(RGC_IsQuickItemsInventory() && !thePlayer.GetIsAimingCrossbow() && !thePlayer.IsThrowHold())
		{
			//validate quickslot selection
			if(!IsActionAllowed(EIAB_QuickSlots))
			{
				thePlayer.DisplayActionDisallowedHudMessage(EIAB_QuickSlots);
				return false;
			}

			if(IsPressed(action))
			{
				GetWitcherPlayer().RGC_SelectItem(EES_Quickslot1);
				return true;
			}

			//no selection made
			return false;
		}
	}

	event OnRGCEquipBomb(action : SInputAction)
	{
		//RGC doesn't affect Ciri and is only applicable to gamepad users
		if(thePlayer.IsCiri() || !theInput.LastUsedGamepad())
		{
			return false;
		}

		//bomb items are available while modifier is active
		//quickslot items are available while modifier is active
		if(RGC_IsQuickItemsInventory() && !thePlayer.GetIsAimingCrossbow() && !thePlayer.IsThrowHold())
		{
			//validate quickslot selection
			if(!IsActionAllowed(EIAB_QuickSlots))
			{
				thePlayer.DisplayActionDisallowedHudMessage(EIAB_QuickSlots);
				return false;
			}

			//On press, set the held helper variable to false
			//Note: marked true in OnRGCEquipBombLowerHold()
			if(IsPressed(action))
			{
				GetWitcherPlayer().RGC_SelectItem(EES_Petard1);
				return true;
			}

			return false;
		}
	}

	event OnRGCNextBolt(action : SInputAction)
	{
		//RGC doesn't affect Ciri and is only applicable to gamepad users
		if(thePlayer.IsCiri() || !theInput.LastUsedGamepad())
		{
			return false;
		}

		if(GetWitcherPlayer().GetIsAimingCrossbow())
		{
			if(IsPressed(action))
			{
				GetWitcherPlayer().RGC_NextBolt();
				GetWitcherPlayer().RGC_Update();
				return true;
			}
		}
	}

	event OnRGCInfiniteBolt(action : SInputAction)
	{
		//RGC doesn't affect Ciri and is only applicable to gamepad users
		if(thePlayer.IsCiri() || !theInput.LastUsedGamepad())
		{
			return false;
		}

		if(GetWitcherPlayer().GetIsAimingCrossbow())
		{
			if(IsPressed(action))
			{
				GetWitcherPlayer().RGC_InfiniteBolt();
				GetWitcherPlayer().RGC_Update();
				return true;
			}
		}
	}

	event OnCommSprint( action : SInputAction )
	{
		if(GetWitcherPlayer().RGC_IsInRealtimeEquipCastMode() || thePlayer.GetLeftStickSprint())
		{
			//does not occur while modifier is active
			return false;
		}

		if( IsPressed( action ) )
		{
			if(RGCConfigIsImmersiveMotionEnabled())
			{
				if( rgcPressTimestamp + RGC_DOUBLE_TAP_WINDOW >= theGame.GetEngineTimeAsSeconds() && RGCConfigIsImmersiveMotionEnabled() )
				{
					thePlayer.SetSprintToggle( true );
					thePlayer.RgcSetSprintSpeed(1.5f);
				}
				else
				{
					if ( thePlayer.GetIsSprintToggled() )
					{
						thePlayer.SetSprintToggle( false );
					}
					else
					{
						thePlayer.SetSprintToggle( true );
					}
					thePlayer.RgcSetSprintSpeed(1.0f);
				}

				rgcPressTimestamp = theGame.GetEngineTimeAsSeconds();
			}
			else
			{
				thePlayer.SetSprintActionPressed(true);

				if ( thePlayer.rangedWeapon )
					thePlayer.rangedWeapon.OnSprintHolster();
			}
		}
	}


	private var rgcPressTimestamp : float;
	private const var RGC_DOUBLE_TAP_WINDOW	: float;
	default RGC_DOUBLE_TAP_WINDOW = 0.4;
	event OnCommSprintToggle( action : SInputAction )
	{
		if( IsPressed(action) )
		{
			if( theInput.LastUsedPCInput() || thePlayer.GetLeftStickSprint() )
			{
				if( rgcPressTimestamp + RGC_DOUBLE_TAP_WINDOW >= theGame.GetEngineTimeAsSeconds() && RGCConfigIsImmersiveMotionEnabled() )
				{
					thePlayer.SetSprintToggle( true );
					thePlayer.RgcSetSprintSpeed(1.5f);
				}
				else
				{
					if ( thePlayer.GetIsSprintToggled() )
					{
						thePlayer.SetSprintToggle( false );
					}
					else
					{
						thePlayer.SetSprintToggle( true );
					}
					thePlayer.RgcSetSprintSpeed(1.0f);
				}

				rgcPressTimestamp = theGame.GetEngineTimeAsSeconds();
			}
		}
	}

	event OnCommSpawnHorse( action : SInputAction ) {
		if(RGCConfigIsImmersiveMotionEnabled() && thePlayer.GetLeftStickSprint()) {
			//override
			return false;
		}

		//let default controls handle it
		return super.OnCommSpawnHorse(action);
	}

	event OnRGCSpawnHorse( action : SInputAction ) {
		if(!RGCConfigIsImmersiveMotionEnabled() || !thePlayer.GetLeftStickSprint()) {
			//let the default controls pick it up
			return false;
		}

		//reroute to super
		return super.OnCommSpawnHorse(action);
	}

	event OnCommDrinkpotionUpperHeld( action : SInputAction )
	{
		//modW3ReduxRGC++
		if(!RGC_IsQuickItemsPotions() || thePlayer.GetIsAimingCrossbow())
		{
			//does not occur while modifier is active
			return false;
		}
		//modW3ReduxRGC--

		return super.OnCommDrinkpotionUpperHeld(action);
	}

	event OnCommDrinkpotionLowerHeld( action : SInputAction )
	{
		//modW3ReduxRGC++
		if(!RGC_IsQuickItemsPotions() || thePlayer.GetIsAimingCrossbow())
		{
			//does not occur while modifier is active
			return false;
		}
		//modW3ReduxRGC--

		return super.OnCommDrinkpotionLowerHeld(action);
	}

	event OnCommDrinkPotion1( action : SInputAction )
	{
		//modW3ReduxRGC++
		if(!RGC_IsQuickItemsPotions() || thePlayer.GetIsAimingCrossbow())
		{
			//does not occur while modifier is active
			return false;
		}
		//modW3ReduxRGC--

		return super.OnCommDrinkPotion1(action);
	}

	event OnCommDrinkPotion2( action : SInputAction )
	{
		//modW3ReduxRGC++
		if(!RGC_IsQuickItemsPotions() || thePlayer.GetIsAimingCrossbow())
		{
			//does not occur while modifier is active
			return false;
		}
		//modW3ReduxRGC--

		return super.OnCommDrinkPotion2(action);
	}

	event OnCbtAttackLight( action : SInputAction )
	{
		//modW3ReduxRGC++
		if(GetWitcherPlayer().RGC_IsInRealtimeEquipCastMode())
		{
			//does not occur while modifier is active
			return false;
		}
		//modW3ReduxRGC--

		return super.OnCbtAttackLight(action);
	}

	event OnCbtAttackHeavy( action : SInputAction )
	{
		//modW3ReduxRGC++
		if(GetWitcherPlayer().RGC_IsInRealtimeEquipCastMode())
		{
			//does not occur while modifier is active
			return false;
		}
		//modW3ReduxRGC--

		return super.OnCbtAttackHeavy(action);
	}

	event OnCbtSpecialAttackLight( action : SInputAction )
	{
		//modW3ReduxRGC++
		if ( GetWitcherPlayer().RGC_IsInRealtimeEquipCastMode() )
		{
			//don't do attacks while casting
			return false;
		}
		//modW3ReduxRGC--

		return super.OnCbtSpecialAttackLight(action);
	}

	event OnCbtSpecialAttackHeavy( action : SInputAction )
	{
		//modW3ReduxRGC++
		if ( GetWitcherPlayer().RGC_IsInRealtimeEquipCastMode() )
		{
			//don't do attacks while casting
			return false;
		}
		//modW3ReduxRGC--

		return super.OnCbtSpecialAttackHeavy(action);
	}

	event OnCbtDodge( action : SInputAction )
	{
		//modW3ReduxRGC++
		if(GetWitcherPlayer().RGC_IsInRealtimeEquipCastMode())
		{
			//does not occur while modifier is active
			return false;
		}
		//modW3ReduxRGC--

		return super.OnCbtDodge(action);
	}

	event OnCbtRoll( action : SInputAction )
	{
		//modW3ReduxRGC++
		if(GetWitcherPlayer().RGC_IsInRealtimeEquipCastMode())
		{
			//does not occur while modifier is active
			return false;
		}
		//modW3ReduxRGC--

		return super.OnCbtRoll(action);
	}

	event OnCastSign( action : SInputAction )
	{
		var signSkill : ESkill;

		//modW3ReduxRGC++
		//there is no sign selection in RGC, thus casting a selected sign isn't a necessary action
		return false;
		//modW3ReduxRGC--
	}

	event OnCbtThrowItem( action : SInputAction )
	{
		var isUsableItem, isCrossbow, isBomb, ret : bool;
		var itemId : SItemUniqueId;

		//modW3ReduxRGC++
		if(GetWitcherPlayer().RGC_IsInRealtimeEquipCastMode())
		{
			//does not occur while modifier is active
			return false;
		}

		//make sure button is pressed before selecting non-crossbow item
		if(IsPressed(action))
		{
			thePlayer.OnRangedForceHolster(true);
			GetWitcherPlayer().SelectQuickslotItem(GetWitcherPlayer().RGC_GetLastUsedItemSlot());
		}
		//modW3ReduxRGC--

		if(thePlayer.IsInAir() || thePlayer.GetWeaponHolster().IsOnTheMiddleOfHolstering())
			return false;

		if( thePlayer.IsSwimming() && !thePlayer.OnCheckDiving() && thePlayer.GetCurrentStateName() != 'AimThrow' )
			return false;

		itemId = thePlayer.GetSelectedItemId();

		if(!thePlayer.inv.IsIdValid(itemId))
			return false;

		isCrossbow = thePlayer.inv.IsItemCrossbow(itemId);
		if(!isCrossbow)
		{
			isBomb = thePlayer.inv.IsItemBomb(itemId);
			if(!isBomb)
			{
				isUsableItem = true;
			}
		}

		//modW3ReduxRGC++
		if( isCrossbow )
		{
			return false;
		}
		//modW3ReduxRGC--

		return super.OnCbtThrowItem(action);
	}

	event OnCbtThrowItemHold( action : SInputAction )
	{
		var isBomb, isCrossbow, isUsableItem : bool;
		var itemId : SItemUniqueId;

		//modW3ReduxRGC++
		if(GetWitcherPlayer().RGC_IsInRealtimeEquipCastMode())
		{
			//does not occur while modifier is active
			return false;
		}
		//modW3ReduxRGC--

		if(thePlayer.IsInAir() || thePlayer.GetWeaponHolster().IsOnTheMiddleOfHolstering() )
			return false;

		if( thePlayer.IsSwimming() && !thePlayer.OnCheckDiving() && thePlayer.GetCurrentStateName() != 'AimThrow' )
			return false;

		itemId = thePlayer.GetSelectedItemId();

		if(!thePlayer.inv.IsIdValid(itemId))
			return false;

		isCrossbow = thePlayer.inv.IsItemCrossbow(itemId);

		//modW3ReduxRGC++
		if( isCrossbow )
		{
			return false;
		}
		//modW3ReduxRGC--

		return super.OnCbtThrowItemHold(action);
	}

	//Included from Better Torches
	event OnCbtLockAndGuard( action : SInputAction )
	{
		if(thePlayer.IsCiri() && !GetCiriPlayer().HasSword())
			return false;


		if( IsReleased(action) )
		{
			thePlayer.SetGuarded(false);
			thePlayer.OnGuardedReleased();
		}

		if( (thePlayer.IsWeaponHeld('fists') || thePlayer.GetCurrentStateName() == 'CombatFists') && !IsActionAllowed(EIAB_Fists))
		{
			thePlayer.DisplayActionDisallowedHudMessage(EIAB_Fists);
			return false;
		}

		if( IsPressed(action) )
		{
			/*if( !IsActionAllowed(EIAB_Parry) )
			{
				if ( IsActionBlockedBy(EIAB_Parry,'UsableItem') )
				{
					//thePlayer.DisplayActionDisallowedHudMessage(EIAB_Parry);
				}
				return false;
			}*/

			if ( thePlayer.GetCurrentStateName() == 'Exploration' )
				thePlayer.GoToCombatIfNeeded();

			if ( thePlayer.bLAxisReleased )
				thePlayer.ResetRawPlayerHeading();

			if ( thePlayer.rangedWeapon && thePlayer.rangedWeapon.GetCurrentStateName() != 'State_WeaponWait' )
				thePlayer.OnRangedForceHolster( true, true );

			thePlayer.AddCounterTimeStamp(theGame.GetEngineTime());
			thePlayer.SetGuarded(true);
			thePlayer.OnPerformGuard();
		}
	}
 }