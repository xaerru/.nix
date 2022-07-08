import XMonad
import Data.Monoid
import Control.Monad (liftM2)
import System.Exit
import XMonad.Layout.NoBorders
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Actions.GroupNavigation
import XMonad.Util.EZConfig
import XMonad.Layout.ToggleLayouts
import XMonad.Actions.PerWorkspaceKeys
import           XMonad.Actions.CycleWS         ( Direction1D(..)
                                                , WSType(..)
                                                , moveTo
                                                , nextScreen
                                                , prevScreen
                                                , shiftTo
                                                , toggleWS
                                                )

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

myTerminal      = "alacritty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth   = 1

myModMask       = mod4Mask

myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

myNormalBorderColor  = "#181818"
myFocusedBorderColor = "#7cafc2"

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm,               xK_backslash), spawn "alacritty")
    , ((modm,               xK_Return),    spawn "alacritty -e tmux")
    , ((modm,               xK_b),         spawn "brave")
    , ((modm,               xK_i),         spawn "qutebrowser")
    , ((modm,               xK_z),         spawn "tabbed -c zathura -e")

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

    , ((modm,               xK_u     ), nextMatch History (return True))
    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Move to next non empty workspace
    , ((modm,               xK_n   ), moveTo Next NonEmptyWS)

    -- Move to previous non empty workspace
    , ((modm,               xK_o   ), moveTo Prev NonEmptyWS)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm,               xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm,               xK_period), sendMessage (IncMasterN (-1)))

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm,               xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
     [ ((modm, k), bindOn [("", windows $ W.greedyView n), (n, toggleWS)])
     | (n, k) <- zip myWorkspaces ([xK_1 .. xK_9] ++ [xK_0])
     ]
     ++
     [ ((m .|. modm, k), windows $ f i)
       | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
       , (f, m) <- [(W.shift, shiftMask)]
       ]

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w))
    ]

myLayout = tiled ||| Mirror tiled ||| Full
  where
     tiled   = Tall nmaster delta ratio

     nmaster = 1

     ratio   = 1/2

     delta   = 3/100

myManageHook = composeAll
    [ className =? "mpv"            --> doFullFloat
    , className =? "tabbed"         --> viewShift "4"
    , className =? "Zathura"        --> viewShift "4"
    , className =? "MComix"         --> viewShift "4"
    , className =? "Brave-browser"  --> doShift   "2"
    , className =? "Virt-manager"   --> viewShift "5"
    , title     =? "media"          --> viewShift "6"
    , className =? "qBittorrent"    --> viewShift "7"
    , className =? "zoom"           --> viewShift "8"
    , className =? "mpv"            --> viewShift "9"
    ]
  where
    viewShift = doF . liftM2 (.) W.greedyView W.shift

myEventHook = mempty

myLogHook = historyHook

myStartupHook = return ()

main = xmonad defaults

defaults = ewmh $ def {
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        focusedBorderColor = myFocusedBorderColor,
	normalBorderColor  = myNormalBorderColor,

        keys               = myKeys,
        mouseBindings      = myMouseBindings,

        layoutHook         = toggleLayouts (noBorders Full) $ smartBorders $ myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    } `additionalKeysP` [ ("<XF86AudioPlay>"       , spawn "playerctl play-pause")
  , ("M-s p"                 , spawn "playerctl play-pause")
  , ("<XF86AudioPrev>"       , spawn "playerctl previous")
  , ("M-s b"                 , spawn "playerctl previous")
  , ("<XF86AudioNext>"       , spawn "playerctl next")
  , ("M-s n"                 , spawn "playerctl next")
  , ("<XF86AudioMute>", spawn "pactl set-sink-mute 0 toggle")
  , ("<XF86AudioLowerVolume>", spawn "pactl -- set-sink-volume 0 -3%")
  , ("<XF86AudioRaiseVolume>", spawn "pactl -- set-sink-volume 0 +3%")
  , ("<XF86Calculator>"      , spawn "qalculate-gtk")
  , ("<Print>", spawn "maim -su | xclip -selection clipboard -t image/png")
  , ( "C-<Print>"
    , spawn "maim -u -i $(xdotool getactivewindow) | xclip -selection clipboard -t image/png"
    )
  , ("M-S-s", spawn "maim -u | xclip -selection clipboard -t image/png")]
