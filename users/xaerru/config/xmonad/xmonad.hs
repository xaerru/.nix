import XMonad
import Data.Monoid
import Control.Monad (liftM2)
import System.Exit
import           XMonad.Actions.MouseResize
import XMonad.Layout.NoBorders
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.ManageDocks            (ToggleStruts (..),
                                                      avoidStruts,
                                                      docksEventHook,
                                                      manageDocks)
import XMonad.Actions.GroupNavigation
import           XMonad.Util.NamedScratchpad
import XMonad.Util.EZConfig
import           Data.Maybe                          (fromJust, isJust)
import           XMonad.Layout.Accordion
import           XMonad.Layout.GridVariants          (Grid (Grid))
import           XMonad.Layout.ResizableTile
import           XMonad.Layout.SimplestFloat
import           XMonad.Layout.Spiral
import           XMonad.Layout.Tabbed
import           XMonad.Layout.ThreeColumns

    -- Layouts modifiers
import           XMonad.Layout.LayoutModifier
import           XMonad.Layout.LimitWindows          (decreaseLimit,
                                                      increaseLimit,
                                                      limitWindows)
import           XMonad.Layout.Magnifier
import           XMonad.Layout.MultiToggle           (EOT (EOT), mkToggle,
                                                      single, (??))
import qualified XMonad.Layout.MultiToggle           as MT (Toggle (..))
import           XMonad.Layout.MultiToggle.Instances (StdTransformers (MIRROR, NBFULL, NOBORDERS))
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Renamed
import           XMonad.Layout.Simplest
import           XMonad.Layout.Spacing
import           XMonad.Layout.SubLayouts
import qualified XMonad.Layout.ToggleLayouts         as T (ToggleLayout (Toggle),
                                                           toggleLayouts)
import           XMonad.Layout.WindowArranger        (WindowArrangerMsg (..),
                                                      windowArrange)
import XMonad.Layout.ToggleLayouts
import XMonad.Actions.PerWorkspaceKeys
import           XMonad.Actions.CycleWS         ( Direction1D(..)
                                                , WSType(..)
                                                , moveTo
                                                , nextScreen
                                                , prevScreen
                                                , shiftTo
                                                , toggleWS
                                                , emptyWS
                                                )

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Hooks.DynamicLog             (PP (..), dynamicLogWithPP,
                                                      shorten, wrap,
                                                      xmobarColor, xmobarPP)
import           XMonad.Util.Run                     (runProcessWithInput, hPutStrLn,
                                                      safeSpawn, spawnPipe)
myTerminal      = "alacritty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth   = 1

myModMask       = mod4Mask

myWorkspaces = ["dev", "web", "prac", "sys", "chat", "mus", "sch", "vir", "soc"]
myWorkspaceIndices = M.fromList $ zip myWorkspaces [1..] -- (,) == \x y -> (x,y)

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
    , ((modm,               xK_n   ), moveTo Next (Not emptyWS))

    -- Move to previous non empty workspace
    , ((modm,               xK_o   ), moveTo Prev (Not emptyWS))

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

--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall     = renamed [Replace "tall"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 2
           $ ResizableTall 1 (3/100) (1/2) []
magnify  = renamed [Replace "magnify"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ magnifier
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing' 8
           $ spiral (6/7)
threeCol = renamed [Replace "threeCol"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ ThreeCol 1 (3/100) (1/2)
threeRow = renamed [Replace "threeRow"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabTheme
tallAccordion  = renamed [Replace "tallAccordion"]
             Accordion
wideAccordion  = renamed [Replace "wideAccordion"]
           $ Mirror Accordion
myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"
-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def { fontName            = myFont
                 , activeColor         = "#88C0D0"
                 , inactiveColor       = "#2E3440"
                 , activeBorderColor   = "#88C0D0"
                 , inactiveBorderColor = "#2E3440"
                 , activeTextColor     = "#2E3440"
                 , inactiveTextColor   = "#d0d0d0"
                 }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               myDefaultLayout =     withBorder myBorderWidth tall
                                 ||| Main.magnify
                                 ||| noBorders monocle
                                 ||| floats
                                 ||| noBorders tabs
                                 ||| grid
                                 ||| spirals
                                 ||| threeCol
                                 ||| threeRow
                                 ||| tallAccordion
                                 ||| wideAccordion

myManageHook = composeAll
    [ className =? "mpv"            --> doFullFloat
    , className =? "tabbed"         --> viewShift "4"
    , className =? "MComix"         --> viewShift "4"
    , className =? "Brave-browser"  --> doShift   "2"
    , className =? "Anki"           --> viewShift "5"
    , className =? "Virt-manager"   --> viewShift "5"
    , title     =? "media"          --> viewShift "6"
    , className =? "qBittorrent"    --> viewShift "7"
    , className =? "zoom"           --> viewShift "8"
    , className =? "mpv"            --> viewShift "9"
    ]
  where
    viewShift = doF . liftM2 (.) W.greedyView W.shift

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myStartupHook = return ()

defaults xmproc0 = ewmh $ def {
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

        layoutHook         = myLayoutHook,
        manageHook         = myManageHook <+> manageDocks,
        handleEventHook    = docksEventHook <+> fullscreenEventHook,
                               -- Uncomment this line to enable fullscreen support on things like YouTube/Netflix.
                               -- This works perfect on SINGLE monitor systems. On multi-monitor systems,
                               -- it adds a border around the window if screen does not have focus. So, my solution
                               -- is to use a keybinding to toggle fullscreen noborders instead.  (M-<Space>)
        logHook            = dynamicLogWithPP
                      (namedScratchpadFilterOutWorkspacePP
                         $ xmobarPP
                             {ppOutput = hPutStrLn xmproc0,
                              ppCurrent = xmobarColor "#A3BE8C" "" . wrap "[" "]",
                              ppVisible = xmobarColor "#A3BE8C" "" . clickable,
                              ppHidden = xmobarColor "#81A1C1" "" . wrap "*" "" . clickable,
                              ppHiddenNoWindows = xmobarColor "#B48EAD" "" . clickable,
                              ppTitle = xmobarColor "#b3afc2" "" . shorten 60,
                              ppSep = "<fc=#666666> <fn=1>|</fn> </fc>",
                              ppUrgent = xmobarColor "#BF616A" "" . wrap "!" "!",
                              ppExtras = [windowCount],
                              ppOrder = \ (ws : l : t : ex) -> [ws, l] ++ ex ++ [t]
                             })
                      >> historyHook
,
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

main :: IO ()
main = do
    -- Launching three instances of xmobar on their monitors.
    xmproc0 <- spawnPipe "xmobar $HOME/xmobar.config"
    -- the xmonad, ya know...what the WM is named after!
    xmonad $ ewmh $ defaults xmproc0
