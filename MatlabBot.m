classdef MatlabBot < handle
    %MBOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        botIsReady = false;
    end

    properties (Access = private)
        bot % Java bot
        scrSize
    end
    
    methods
        function obj = MatlabBot()
            % Get the screen size
            obj.scrSize = get(0,'ScreenSize');
            obj.scrSize = obj.scrSize(3:end);
            
            % Create the bot
            obj.bot = java.awt.Robot;
            obj.botIsReady = true;            
        end
        
        function delete(obj)
            % Close communcations
            obj.botIsReady = 0;
        end
        
        function moveMouse(obj,coord)
            % Moves the mouse to the coordinates vector [x y]
            %set(0,'PointerLocation',coord); % Use Matlab inbuilt function
            obj.bot.mouseMove(coord(1),coord(2)); % Use the bot function
        end
        
        function clickMouse(obj)
            obj.bot.mouseRelease(java.awt.event.InputEvent.BUTTON1_MASK);
            obj.bot.mousePress(java.awt.event.InputEvent.BUTTON1_MASK);
            obj.bot.mouseRelease(java.awt.event.InputEvent.BUTTON1_MASK);
        end

        function loopMoveMouse(obj, coord, timer)
            arguments
                obj MatlabBot
                coord (1, 2) double = [0, 0]
                timer (1,1) double = 10
            end

            fh = warndlg('Click ok to stop','Warning');
            while isvalid(fh)
                obj.moveMouse(coord)
                obj.moveMouse(coord + [10, 10])
                pause(timer)
            end

        end
        
        function doubleClickMouse(obj)
            obj.bot.mouseRelease(java.awt.event.InputEvent.BUTTON1_MASK);
            obj.bot.mousePress(java.awt.event.InputEvent.BUTTON1_MASK);
            obj.bot.mouseRelease(java.awt.event.InputEvent.BUTTON1_MASK);
            obj.bot.mousePress(java.awt.event.InputEvent.BUTTON1_MASK);
            obj.bot.mouseRelease(java.awt.event.InputEvent.BUTTON1_MASK);
        end
        
        function moveAndClickMouse(obj,coord)
            obj.moveMouse(coord);
            obj.clickMouse();
        end
        
        function moveAndDoubleClickMouse(obj,coord)
            obj.moveMouse(coord);
            obj.doubleClickMouse();
        end
        
        function pressKey(obj,keyChar)
            if keyChar == '.'
                javaKeyEvent = java.awt.event.KeyEvent.VK_PERIOD;
            else % Number or letter
                javaKeyEvent = eval(['java.awt.event.KeyEvent.VK_' eval('upper(keyChar)')]);
            end
            obj.bot.keyPress(javaKeyEvent);
            obj.bot.keyRelease(javaKeyEvent);
        end
    end

    methods (Access = private)
        
        function obj = prepareBot(obj)
            fh = warndlg('Move the app window on the top left corner of the screen, then click OK..','Warning');
            uiwait(fh);
            if ~ishandle(fh)
                obj.botIsReady = 1;
                disp('Bot is ready !')
            end
        end
    end


end

