# res_mods
My WoT res_mods (based on QB's modpack + JustForLolzFYI's icon as the 6th sense icon)

# Installation
```bash
$ ./get_latest.ps1 [-dev|-xvm X.Y.Z] [-verbose]
$ ./finalize.ps1 [-verbose]
```

# How To Extract Current Config Data
First copy our custom init-script in place:
`$ cp xvm_init.py xvm/py_macro/xvm/__init__.py`

Then launch the game and wait until you see a line containing the following in `python.log`:

`2019-06-03 08:51:33.020: INFO: ===> Config Data Dumped to C:\Games\World_of_Tanks\config_data.json`

# Overriding values
TBD

```json
{
    "autoReloadConfig": true,
    "minimapAlt": {
        "enabled": false,
    },
    "minimap": {
        "enabled": false,
    },
    "hangar": {
        "showReferralButton": false,
        "showGeneralChatButton": false,
        "showPromoPremVehicle": false,
        "crewReturnByDefault": true,
        "blockVehicleIfLowAmmo": true,
        "enableEquipAutoReturn": true,
        "combatIntelligence": {
            "showPopUpMessages": false
        },
        "carousel": {
            "small": {
                "extraFields": [
                    {
                        "enabled": false,
                        "when": {
                            "format": "<b><font face='$FieldFont' size='12' color='{{v.c_winrate|#C8C8B5}}'>{{v.winrate%2d~%}}</font></b>"
                        }
                    }
                ]
            }
        }
    },
    "battle": {
        "sixthSenseDuration": 5000,
        "camera": {
            "enabled": true,
            "arcade": {
                "distRange": [2, 100]
            },
            "postmortem": {
                "distRange": [2, 100]
            },
            "sniper": {
                "zooms": [2, 4, 8, 16, 25]
            }
        }
    },
    "battleLabels": {
        "formats": [
            {
                "enabled": false,
                "when": {
                    "updateEvent": "PY(ON_HIT_LOG), ON_PANEL_MODE_CHANGED"
                }
            },
            {
                "enabled": false,
                "when": {
                    "updateEvent": "PY(ON_TOTAL_EFFICIENCY), ON_PANEL_MODE_CHANGED"
                }
            },
            {
                "enabled": false,
                "when": {
                    "updateEvent": "PY(ON_UPDATE_HP)"
                }
            },
            {
                "enabled": false,
                "when": {
                    "updateEvent": "PY(ON_TOTAL_EFFICIENCY)"
                }
            },
            {
                "enabled": false,
                "when": {
                    "updateEvent": "PY(ON_HIT)"
                }
            },
            {
                "enabled": false,
                "when": {
                    "updateEvent": "PY(ON_LAST_HIT)"
                }
            },
        ]
    },
    "templates": {
        "clanIcon": {
            "enabled": false
        }
    },
    "sounds": {
        "enabled": true
    },
    "playersPanel": {
        "medium": {
            "standardFields": [
                "frags",
                "nick"
            ]
        }
    },
    "markers": {
        "enabled": false
    },
    "hotkeys": {
        "minimapZoom": {
            "enabled": false,
        }
    },
    "damageLog": {
        "enabled": false
    }
}
```