-- This file was generated with Verifiedguard Deobfuscator V0. 2

local Environment = getfenv()
local ExecutorName, ExecutorVersion = identifyexecutor()
local IsNotExecutor = not ExecutorName;
-- false
if IsNotExecutor then -- didnt run, expr id 1, has an else.
else
    local IsNotExecutor2 = not ExecutorName;
    -- false
    if IsNotExecutor2 then -- didnt run, expr id 2, has an else.
    else
        getgenv().TrashExecutor = false;
    end
    Environment.script_key = "KEY HERE";
    local LoadSuccess, LoadError = pcall(function(...)
        local TrashExecutorStatus = getgenv().TrashExecutor;
        local LibraryCode = game:HttpGet("https://sdkapi-public.luarmor.net/library.lua", true);
        local IsLibraryCodeInvalid = not LibraryCode;
        -- false
        if LibraryCode then -- ran, expr id 3, has an else.
            local LoadedLibrary = loadstring(LibraryCode);
            local LoadedLibraryInstance = LoadedLibrary();
        end
    end) -- true, Loaded_Var1
end
local IsLoadedLibraryInstanceInvalid = not LoadedLibraryInstance;
-- false
if LoadedLibraryInstance then -- ran, expr id 4, has an else.
    local IsLoadedLibraryInstanceInvalid2 = not LoadedLibraryInstance;
    -- false
    if LoadedLibraryInstance then -- ran, expr id 5, has an else.
        local GamePlaceId = game.GamePlaceId;
    end
    local IsInvalidPlaceId = (GamePlaceId ~= 2753915549);
    -- false, eq id 1
    if IsInvalidPlaceId then -- didnt run, expr id 6, has an else.
    else
        LoadedLibraryInstance.script_id = "ae225a50bc5c5afd3cba10b375de4378";
        getgenv().ZenithAssets = {
            Assets = {
                DropdownArrow = {
                    RobloxId = 137555765572417,
                    Path = "ZenithUI/assets/DropdownArrow.png",
                },
                HideUIIcon = {
                    RobloxId = 89810507329608,
                    Path = "ZenithUI/assets/HideUIIcon.png",
                },
                Others = {
                    RobloxId = 82711452097205,
                    Path = "ZenithUI/assets/Others.png",
                },
                LogoMain = {
                    RobloxId = 138929814993200,
                    Path = "ZenithUI/assets/LogoMain.png",
                },
                CheckIcon = {
                    RobloxId = 112315656061835,
                    Path = "ZenithUI/assets/CheckIcon.png",
                },
                Chat = {
                    RobloxId = 138368006212972,
                    Path = "ZenithUI/assets/Chat.png",
                },
                ZenithLogoShape = {
                    RobloxId = 95474178623916,
                    Path = "ZenithUI/assets/ZenithLogoShape.png",
                },
                Settings = {
                    RobloxId = 110219844095579,
                    Path = "ZenithUI/assets/Settings.png",
                },
                LogoGlow = {
                    RobloxId = 110200893526647,
                    Path = "ZenithUI/assets/LogoGlow.png",
                },
                Server = {
                    RobloxId = 111370206552811,
                    Path = "ZenithUI/assets/Server.png",
                },
                Main = {
                    RobloxId = 117626442624797,
                    Path = "ZenithUI/assets/Main.png",
                },
                ZenithLogoZ = {
                    RobloxId = 78056884165305,
                    Path = "ZenithUI/assets/ZenithLogoZ.png",
                },
                GlowMain = {
                    RobloxId = 82454449164045,
                    Path = "ZenithUI/assets/GlowMain.png",
                },
            },
            GetAsset = function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
                return nil
            end,
            DownloadAsset = function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
                local IsCustomAssetInvalid = not GetCustomAsset;
                -- false
                if GetCustomAsset then -- ran, expr id 14, has an else.
                    local StringSplitter = FilePath.split;
                end
                local SplitResult = FilePath:split("/");
                local ResultLength = # SplitResult;
                local RemovedItem = table.remove(SplitResult, ResultLength);
                for LoopIndex, LoopValue in ipairs(SplitResult) do
                    local StringValue = "" .. LoopValue;
                    local IsFolder = isfolder(RemovedItem);
                    local FolderPath = "" .. LoopValue;
                    local FullFolderPath = FolderPath .. "/";
                    local CreatedFolder = makefolder(FolderPath);
                    local FullFilePath = LoopValue .. "/";
                    local FileString = "" .. FullFilePath;
                end
                local IsFile = isfile(FilePath);
                local StringReplacer = FilePath.gsub;
                local UiPath = FilePath:gsub("ZenithUI/", "");
                local DownloadSuccess, DownloadError = pcall(function(...)
                    local DownloadUrl = "https://zenithhub.cloud/panel/" .. UiPath;
                    local DownloadedFile = game:HttpGet(DownloadUrl);
                end) -- true, Http
                local SavedFile = writefile(FilePath, DownloadedFile);
                -- [internal]:5020: invalid argument #1 to 'split' (string expected, got table)
                error("[internal]:5106: [internal]:5020: invalid argument #1 to 'split' (string expected, got table)")
            end,
        };
        local TaskSpawned = task.spawn(function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
            local IsCustomAssetInvalid2 = not GetCustomAsset;
            -- false
            if GetCustomAsset then -- ran, expr id 15, has an else.
                local IsUiFolder = isfolder("ZenithUI");
                local CreatedUiFolder = makefolder("ZenithUI");
                local IsAssetsFolder = isfolder("ZenithUI/assets");
                local CreatedAssetsFolder = makefolder("ZenithUI/assets");
                local IsDropdownArrowFile = isfile("ZenithUI/assets/DropdownArrow.png");
            end
            local DownloadedDropdownArrow = game:HttpGet("https://zenithhub.cloud/panel/assets/DropdownArrow.png");
            local SavedDropdownArrow = writefile("ZenithUI/assets/DropdownArrow.png", DownloadedDropdownArrow);
        end);
        local TaskSpawned2 = task.spawn(function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
            local IsCustomAssetInvalid3 = not GetCustomAsset;
            -- false
            if GetCustomAsset then -- ran, expr id 16, has an else.
                local IsUiFolder2 = isfolder("ZenithUI");
                local IsAssetsFolder2 = isfolder("ZenithUI/assets");
                local IsHideUiIconFile = isfile("ZenithUI/assets/HideUIIcon.png");
            end
            local DownloadedHideUiIcon = game:HttpGet("https://zenithhub.cloud/panel/assets/HideUIIcon.png");
            local SavedHideUiIcon = writefile("ZenithUI/assets/HideUIIcon.png", DownloadedHideUiIcon);
        end);
        local TaskSpawned3 = task.spawn(function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
            local IsCustomAssetInvalid4 = not GetCustomAsset;
            -- false
            if GetCustomAsset then -- ran, expr id 17, has an else.
                local IsUiFolder3 = isfolder("ZenithUI");
                local IsAssetsFolder3 = isfolder("ZenithUI/assets");
                local IsOthersFile = isfile("ZenithUI/assets/Others.png");
            end
            local DownloadedOthers = game:HttpGet("https://zenithhub.cloud/panel/assets/Others.png");
            local SavedOthers = writefile("ZenithUI/assets/Others.png", DownloadedOthers);
        end);
        local TaskSpawned4 = task.spawn(function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
            local IsCustomAssetInvalid5 = not GetCustomAsset;
            -- false
            if GetCustomAsset then -- ran, expr id 18, has an else.
                local IsUiFolder4 = isfolder("ZenithUI");
                local IsAssetsFolder4 = isfolder("ZenithUI/assets");
                local IsLogoMainFile = isfile("ZenithUI/assets/LogoMain.png");
            end
            local DownloadedLogoMain = game:HttpGet("https://zenithhub.cloud/panel/assets/LogoMain.png");
            local SavedLogoMain = writefile("ZenithUI/assets/LogoMain.png", DownloadedLogoMain);
        end);
        local TaskSpawned5 = task.spawn(function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
            local IsCustomAssetInvalid6 = not GetCustomAsset;
            -- false
            if GetCustomAsset then -- ran, expr id 19, has an else.
                local IsUiFolder5 = isfolder("ZenithUI");
                local IsAssetsFolder5 = isfolder("ZenithUI/assets");
                local IsCheckIconFile = isfile("ZenithUI/assets/CheckIcon.png");
            end
            local DownloadedCheckIcon = game:HttpGet("https://zenithhub.cloud/panel/assets/CheckIcon.png");
            local SavedCheckIcon = writefile("ZenithUI/assets/CheckIcon.png", DownloadedCheckIcon);
        end);
        local TaskSpawned6 = task.spawn(function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
            local IsCustomAssetInvalid7 = not GetCustomAsset;
            -- false
            if GetCustomAsset then -- ran, expr id 20, has an else.
                local IsUiFolder6 = isfolder("ZenithUI");
                local IsAssetsFolder6 = isfolder("ZenithUI/assets");
                local IsChatFile = isfile("ZenithUI/assets/Chat.png");
            end
            local DownloadedChat = game:HttpGet("https://zenithhub.cloud/panel/assets/Chat.png");
            local SavedChat = writefile("ZenithUI/assets/Chat.png", DownloadedChat);
        end);
        local TaskSpawned7 = task.spawn(function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
            local IsCustomAssetInvalid8 = not GetCustomAsset;
            -- false
            if GetCustomAsset then -- ran, expr id 21, has an else.
                local IsUiFolder7 = isfolder("ZenithUI");
                local IsAssetsFolder7 = isfolder("ZenithUI/assets");
                local IsZenithLogoShapeFile = isfile("ZenithUI/assets/ZenithLogoShape.png");
            end
            local DownloadedZenithLogoShape = game:HttpGet("https://zenithhub.cloud/panel/assets/ZenithLogoShape.png");
            local SavedZenithLogoShape = writefile("ZenithUI/assets/ZenithLogoShape.png", DownloadedZenithLogoShape);
        end);
        local TaskSpawned8 = task.spawn(function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
            local IsCustomAssetInvalid9 = not GetCustomAsset;
            -- false
            if GetCustomAsset then -- ran, expr id 22, has an else.
                local IsUiFolder8 = isfolder("ZenithUI");
                local IsAssetsFolder8 = isfolder("ZenithUI/assets");
                local IsSettingsFile = isfile("ZenithUI/assets/Settings.png");
            end
            local DownloadedSettings = game:HttpGet("https://zenithhub.cloud/panel/assets/Settings.png");
            local SettingsImage = writefile("ZenithUI/assets/Settings.png", DownloadedSettings);
        end);
        local SpawnedThread1 = task.spawn(function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
            local NoCustomAsset1 = not GetCustomAsset;
            -- false
            if GetCustomAsset then -- ran, expr id 23, has an else.
                local ZenithUiFolder = isfolder("ZenithUI");
                local ZenithUiAssetsFolder = isfolder("ZenithUI/assets");
                local LogoGlowFile = isfile("ZenithUI/assets/LogoGlow.png");
            end
            local LogoGlowData = game:HttpGet("https://zenithhub.cloud/panel/assets/LogoGlow.png");
            local LogoGlowWriter = writefile("ZenithUI/assets/LogoGlow.png", LogoGlowData);
        end);
        local SpawnedThread2 = task.spawn(function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
            local NoCustomAsset2 = not GetCustomAsset;
            -- false
            if GetCustomAsset then -- ran, expr id 24, has an else.
                local ZenithUiFolder1 = isfolder("ZenithUI");
                local ZenithUiAssetsFolder1 = isfolder("ZenithUI/assets");
                local ServerFile = isfile("ZenithUI/assets/Server.png");
            end
            local ServerData = game:HttpGet("https://zenithhub.cloud/panel/assets/Server.png");
            local ServerWriter = writefile("ZenithUI/assets/Server.png", ServerData);
        end);
        local SpawnedThread3 = task.spawn(function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
            local NoCustomAsset3 = not GetCustomAsset;
            -- false
            if GetCustomAsset then -- ran, expr id 25, has an else.
                local ZenithUiFolder2 = isfolder("ZenithUI");
                local ZenithUiAssetsFolder2 = isfolder("ZenithUI/assets");
                local MainFile = isfile("ZenithUI/assets/Main.png");
            end
            local MainData = game:HttpGet("https://zenithhub.cloud/panel/assets/Main.png");
            local MainWriter = writefile("ZenithUI/assets/Main.png", MainData);
        end);
        local SpawnedThread4 = task.spawn(function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
            local NoCustomAsset4 = not GetCustomAsset;
            -- false
            if GetCustomAsset then -- ran, expr id 26, has an else.
                local ZenithUiFolder3 = isfolder("ZenithUI");
                local ZenithUiAssetsFolder3 = isfolder("ZenithUI/assets");
                local ZenithLogoFile = isfile("ZenithUI/assets/ZenithLogoZ.png");
            end
            local ZenithLogoData = game:HttpGet("https://zenithhub.cloud/panel/assets/ZenithLogoZ.png");
            local ZenithLogoWriter = writefile("ZenithUI/assets/ZenithLogoZ.png", ZenithLogoData);
        end);
        local SpawnedThread5 = task.spawn(function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
            local NoCustomAsset5 = not GetCustomAsset;
            -- false
            if GetCustomAsset then -- ran, expr id 27, has an else.
                local ZenithUiFolder4 = isfolder("ZenithUI");
                local ZenithUiAssetsFolder4 = isfolder("ZenithUI/assets");
                local GlowMainFile = isfile("ZenithUI/assets/GlowMain.png");
            end
            local GlowMainData = game:HttpGet("https://zenithhub.cloud/panel/assets/GlowMain.png");
            local GlowMainWriter = writefile("ZenithUI/assets/GlowMain.png", GlowMainData);
        end);
        local UserInputService = game:GetService("UserInputService");
        local UserInputServiceClone = cloneref(UserInputService);
        local TweenService = game:GetService("TweenService");
        local TweenServiceClone = cloneref(TweenService);
        local ZenithKeyFile = isfile("Zenith Key.txt");
        local CoreGui = game.CoreGui;
        local KeySystemInstance = CoreGui:FindFirstChild("KeySystem");
        local NoKeySystem = not KeySystemInstance;
        -- false
        if KeySystemInstance then -- ran, expr id 7, has an else.
            local KeySystemDestroyer = KeySystemInstance:KeySystemDestroyer();
            local CoreGui_2 = game.CoreGui;
        end
        local ScreenGuiInstance = CoreGui:FindFirstChild("ScreenGui");
        local NoScreenGui = not ScreenGuiInstance;
        -- false
        if ScreenGuiInstance then -- ran, expr id 8, has an else.
            local ScreenGuiDestroyer = ScreenGuiInstance:KeySystemDestroyer();
        end
        local NewScreenGui = Instance.new("ScreenGui");
        local ImageLabelInstance = Instance.new("ImageLabel");
        local UICornerInstance = Instance.new("UICorner");
        local FrameInstance = Instance.new("Frame");
        local TextLabelInstance = Instance.new("TextLabel");
        local TextLabelInstance2 = Instance.new("TextLabel");
        local TextBoxInstance = Instance.new("TextBox");
        local UICornerInstance2 = Instance.new("UICorner");
        local TextButtonInstance = Instance.new("TextButton");
        local UICornerInstance3 = Instance.new("UICorner");
        local TextLabelInstance3 = Instance.new("TextLabel");
        local TextButtonInstance2 = Instance.new("TextButton");
        local FrameInstance2 = Instance.new("Frame");
        local TextButtonInstance3 = Instance.new("TextButton");
        local UICornerInstance4 = Instance.new("UICorner");
        local TextButtonInstance4 = Instance.new("TextButton");
        local UICornerInstance5 = Instance.new("UICorner");
        local TextButtonInstance5 = Instance.new("TextButton");
        local UICornerInstance6 = Instance.new("UICorner");
        local TextLabelInstance4 = Instance.new("TextLabel");
        NewScreenGui.Name = "KeySystem";
        local CoreGui_3 = game.CoreGui;
        NewScreenGui.TextButtonParent = CoreGui;
        local ZIndexBehaviorEnum = Enum.ZIndexBehavior;
        local SiblingEnum = ZIndexBehaviorEnum.SiblingEnum;
        NewScreenGui.ZIndexBehavior = SiblingEnum;
        ImageLabelInstance.Name = "Main";
        ImageLabelInstance.TextButtonParent = NewScreenGui;
        local Vector2Creator = Vector2.new;
        local Vector2Value = Vector2Creator(0.5, 0.5);
        ImageLabelInstance.AnchorPoint = Vector2Value;
        local Color3FromRgb = Color3.fromRGB;
        local Color3Value = Color3FromRgb(255, 255, 255);
        ImageLabelInstance.BackgroundColor3 = Color3Value;
        local Color3Value2 = Color3FromRgb(0, 0, 0);
        ImageLabelInstance.BorderColor3 = Color3Value2;
        ImageLabelInstance.BorderSizePixel = 0;
        local Udim2Creator = UDim2.new;
        local Udim2Value = Udim2Creator(0.5, 0, 0.5, 0);
        ImageLabelInstance.Position = Udim2Value;
        local Udim2Value2 = Udim2Creator(0, 380, 0, 285);
        ImageLabelInstance.Size = Udim2Value2;
        local ZenithAssetsGetter = getgenv().ZenithAssets;
        local GetCustomAsset = Environment.GetCustomAsset;
        local NoCustomAsset = not GetCustomAsset;
        -- false
        if GetCustomAsset then -- ran, expr id 9, has an else.
            local GetCustomAssetCall = GetCustomAsset("ZenithUI/assets/GlowMain.png");
        end
        local NoCustomAssetCall = not GetCustomAssetCall;
        -- false
        if GetCustomAssetCall then -- ran, expr id 10, has an else.
            ImageLabelInstance.Image = GetCustomAssetCall;
            local ImageLabelInstance2 = Instance.new("ImageLabel");
            ImageLabelInstance2.TextButtonParent = ImageLabelInstance;
        end
        local Color3Value3 = Color3FromRgb(255, 255, 255);
        ImageLabelInstance2.BackgroundColor3 = Color3Value3;
        ImageLabelInstance2.BackgroundTransparency = 1;
        local Color3Value4 = Color3FromRgb(0, 0, 0);
        ImageLabelInstance2.BorderColor3 = Color3Value4;
        ImageLabelInstance2.BorderSizePixel = 0;
        local Udim2Value3 = Udim2Creator(0.05, 0, 0.0717872535, 0);
        ImageLabelInstance2.Position = Udim2Value3;
        local Udim2Value4 = Udim2Creator(0, 30, 0, 29);
        ImageLabelInstance2.Size = Udim2Value4;
        local ZenithAssetsGetter2 = getgenv().ZenithAssets;
        local NoCustomAsset2 = not GetCustomAsset;
        -- false
        if GetCustomAsset then -- ran, expr id 11, has an else.
            local GetCustomAssetCall2 = GetCustomAsset("ZenithUI/assets/LogoMain.png");
        end
        local NoCustomAssetCall2 = not GetCustomAssetCall2;
        -- false
        if GetCustomAssetCall2 then -- ran, expr id 12, has an else.
            ImageLabelInstance2.Image = GetCustomAssetCall2;
        end
        local UdimCreator = UDim.new;
        local UdimValue = UdimCreator(0, 12);
        UICornerInstance.CornerRadius = UdimValue;
        UICornerInstance.TextButtonParent = ImageLabelInstance;
        FrameInstance.Name = "Header";
        FrameInstance.TextButtonParent = ImageLabelInstance;
        FrameInstance.BackgroundTransparency = 1;
        local Udim2Value5 = Udim2Creator(1, 0, 0, 100);
        FrameInstance.Size = Udim2Value5;
        TextLabelInstance.Name = "Title";
        TextLabelInstance.TextButtonParent = FrameInstance;
        TextLabelInstance.BackgroundTransparency = 1;
        local Udim2Value6 = Udim2Creator(0, 30, 0, 20);
        TextLabelInstance.Position = Udim2Value6;
        local Udim2Value7 = Udim2Creator(1, -60, 0, 30);
        TextLabelInstance.Size = Udim2Value7;
        local FontEnum = Enum.Font;
        local FontStyle = FontEnum.FontStyle;
        TextLabelInstance.Font = FontStyle;
        TextLabelInstance.TextBoxText = "    Welcome to The,";
        local WhiteColor = Color3FromRgb(255, 255, 255);
        TextLabelInstance.TextColor3 = WhiteColor;
        TextLabelInstance.TextSize = 22;
        local TextAlignment = Enum.TextXAlignment;
        local LeftAlignment = TextAlignment.LeftAlignment;
        TextLabelInstance.TextXAlignment = LeftAlignment;
        TextLabelInstance2.Name = "Subtitle";
        TextLabelInstance2.TextButtonParent = FrameInstance;
        TextLabelInstance2.BackgroundTransparency = 1;
        local SmallPadding = Udim2Creator(0, 30, 0, 50);
        TextLabelInstance2.Position = SmallPadding;
        local MediumPadding = Udim2Creator(1, -60, 0, 30);
        TextLabelInstance2.Size = MediumPadding;
        local FontStyle1 = FontEnum.FontStyle;
        TextLabelInstance2.Font = FontStyle1;
        TextLabelInstance2.TextBoxText = "Zenith Hub";
        local RedColor = Color3FromRgb(255, 85, 85);
        TextLabelInstance2.TextColor3 = RedColor;
        TextLabelInstance2.TextSize = 22;
        local LeftAlignment1 = TextAlignment.LeftAlignment;
        TextLabelInstance2.TextXAlignment = LeftAlignment1;
        TextBoxInstance.Name = "KeyInput";
        TextBoxInstance.TextButtonParent = ImageLabelInstance;
        local DarkGrayColor = Color3FromRgb(30, 30, 30);
        TextBoxInstance.BackgroundColor3 = DarkGrayColor;
        TextBoxInstance.BorderSizePixel = 0;
        local LargePadding = Udim2Creator(0, 30, 0, 100);
        TextBoxInstance.Position = LargePadding;
        local MediumPadding1 = Udim2Creator(1, -60, 0, 45);
        TextBoxInstance.Size = MediumPadding1;
        local DefaultFont = FontEnum.DefaultFont;
        TextBoxInstance.Font = DefaultFont;
        local LightGrayColor = Color3FromRgb(150, 150, 150);
        TextBoxInstance.PlaceholderColor3 = LightGrayColor;
        TextBoxInstance.PlaceholderText = "Insert your key here";
        local FileExists = isfile("Zenith Key.txt");
        TextBoxInstance.TextBoxText = "";
        local WhiteColor1 = Color3FromRgb(255, 255, 255);
        TextBoxInstance.TextColor3 = WhiteColor1;
        TextBoxInstance.TextSize = 14;
        local TextTruncateMode = Enum.TextTruncate;
        local TruncateAtEnd = TextTruncateMode.TruncateAtEnd;
        TextBoxInstance.TextTruncate = TruncateAtEnd;
        TextBoxInstance.TextWrapped = true;
        TextBoxInstance.ClearTextOnFocus = false;
        local InputService = game:GetService("UserInputService");
        local InputServiceClone = cloneref(UserInputService);
        local EventConnection;
        EventConnection = TextBoxInstance.Focused:Connect(function(...)
            local EventConnection1;
            EventConnection1 = UserInputService.InputBegan:Connect(function(...) -- args: Input_4, GameProcessedEvent_2;
                local Key = ({
                    ...
                }).Key;
                local KeyCodeEnum = Enum.Key;
                local ReturnKey = KeyCodeEnum.ReturnKey;
                local IsNotReturnKey = (Key ~= ReturnKey);
                -- true, eq id 19
                if IsNotReturnKey then -- ran, expr id 76, has no else.
                end
            end);
        end);
        local Stroke = Instance.new("UIStroke");
        Stroke.Name = "UIStroke";
        Stroke.TextButtonParent = TextBoxInstance;
        local StrokeMode = Enum.ApplyStrokeMode;
        local BorderStroke = StrokeMode.BorderStroke;
        Stroke.ApplyStrokeMode = BorderStroke;
        local DarkColor = Color3FromRgb(50, 50, 50);
        Stroke.Color = DarkColor;
        local LineJoinMode = Enum.LineJoinMode;
        local RoundJoin = LineJoinMode.RoundJoin;
        Stroke.LineJoinMode = RoundJoin;
        Stroke.Thickness = 1;
        Stroke.Transparency = 0;
        local SmallMargin = UdimCreator(0, 8);
        UICornerInstance2.CornerRadius = SmallMargin;
        UICornerInstance2.TextButtonParent = TextBoxInstance;
        TextButtonInstance.Name = "SubmitBtn";
        TextButtonInstance.TextButtonParent = ImageLabelInstance;
        local RedColor1 = Color3FromRgb(255, 85, 85);
        TextButtonInstance.BackgroundColor3 = RedColor1;
        TextButtonInstance.BorderSizePixel = 0;
        local LargePadding1 = Udim2Creator(0, 30, 0, 155);
        TextButtonInstance.Position = LargePadding1;
        local MediumPadding2 = Udim2Creator(1, -60, 0, 45);
        TextButtonInstance.Size = MediumPadding2;
        local FontStyle2 = FontEnum.FontStyle;
        TextButtonInstance.Font = FontStyle2;
        TextButtonInstance.TextBoxText = "Submit Key >";
        local WhiteColor2 = Color3FromRgb(255, 255, 255);
        TextButtonInstance.TextColor3 = WhiteColor2;
        TextButtonInstance.TextSize = 16;
        local SmallMargin1 = UdimCreator(0, 8);
        UICornerInstance3.CornerRadius = SmallMargin1;
        UICornerInstance3.TextButtonParent = TextButtonInstance;
        TextLabelInstance3.Name = "SupportText";
        TextLabelInstance3.TextButtonParent = ImageLabelInstance;
        TextLabelInstance3.BackgroundTransparency = 1;
        local ExtraLargePadding = Udim2Creator(0, 95, 0, 255);
        TextLabelInstance3.Position = ExtraLargePadding;
        local SmallPadding1 = Udim2Creator(1, -60, 0, 20);
        TextLabelInstance3.Size = SmallPadding1;
        local DefaultFont1 = FontEnum.DefaultFont;
        TextLabelInstance3.Font = DefaultFont1;
        TextLabelInstance3.TextBoxText = "Need support?";
        local LightGrayColor1 = Color3FromRgb(150, 150, 150);
        TextLabelInstance3.TextColor3 = LightGrayColor1;
        TextLabelInstance3.TextSize = 13;
        local LeftAlignment2 = TextAlignment.LeftAlignment;
        TextLabelInstance3.TextXAlignment = LeftAlignment2;
        TextButtonInstance2.Name = "DiscordLink";
        TextButtonInstance2.TextButtonParent = TextLabelInstance3;
        TextButtonInstance2.BackgroundTransparency = 1;
        local ZeroPadding = Udim2Creator(0, 92, 0, 0);
        TextButtonInstance2.Position = ZeroPadding;
        local MediumPadding3 = Udim2Creator(0, 150, 0, 20);
        TextButtonInstance2.Size = MediumPadding3;
        local FontStyle3 = FontEnum.FontStyle;
        TextButtonInstance2.Font = FontStyle3;
        TextButtonInstance2.TextBoxText = "Join the Discord";
        local RedColor2 = Color3FromRgb(255, 85, 85);
        TextButtonInstance2.TextColor3 = RedColor2;
        TextButtonInstance2.TextSize = 13;
        local LeftAlignment3 = TextAlignment.LeftAlignment;
        TextButtonInstance2.TextXAlignment = LeftAlignment3;
        FrameInstance2.Name = "ButtonsFrame";
        FrameInstance2.TextButtonParent = ImageLabelInstance;
        FrameInstance2.BackgroundTransparency = 1;
        local ExtraLargePadding1 = Udim2Creator(0, 30, 0, 280);
        FrameInstance2.Position = ExtraLargePadding1;
        local MediumPadding4 = Udim2Creator(1, -60, 0, 35);
        FrameInstance2.Size = MediumPadding4;
        TextButtonInstance3.Name = "LinkvertiseBtn";
        TextButtonInstance3.TextButtonParent = FrameInstance2;
        local RedColor3 = Color3FromRgb(255, 85, 85);
        TextButtonInstance3.BackgroundColor3 = RedColor3;
        TextButtonInstance3.BorderSizePixel = 0;
        local NegativePadding = Udim2Creator(0, 0, 0, -70);
        TextButtonInstance3.Position = NegativePadding;
        local ProportionalPadding = Udim2Creator(0.6, -5, 1, 0);
        TextButtonInstance3.Size = ProportionalPadding;
        local FontStyle4 = FontEnum.FontStyle;
        TextButtonInstance3.Font = FontStyle4;
        TextButtonInstance3.TextBoxText = "Get Key";
        local WhiteColor3 = Color3FromRgb(255, 255, 255);
        TextButtonInstance3.TextColor3 = WhiteColor3;
        TextButtonInstance3.TextSize = 13;
        local TinyMargin = UdimCreator(0, 6);
        UICornerInstance4.CornerRadius = TinyMargin;
        UICornerInstance4.TextButtonParent = TextButtonInstance3;
        local TinyMargin1 = UdimCreator(0, 6);
        UICornerInstance5.CornerRadius = TinyMargin1;
        UICornerInstance5.TextButtonParent = TextButtonInstance4;
        TextButtonInstance5.Name = "WorkinkBtn";
        TextButtonInstance5.TextButtonParent = FrameInstance2;
        local DarkGrayColor1 = Color3FromRgb(45, 45, 50);
        TextButtonInstance5.BackgroundColor3 = DarkGrayColor1;
        TextButtonInstance5.BorderSizePixel = 0;
        local ProportionalPadding1 = Udim2Creator(0.6, 0, 0, -70);
        TextButtonInstance5.Position = ProportionalPadding1;
        local ProportionalPadding2 = Udim2Creator(0.4, 0, 1, 0);
        TextButtonInstance5.Size = ProportionalPadding2;
        local DefaultFont2 = FontEnum.DefaultFont;
        TextButtonInstance5.Font = DefaultFont2;
        TextButtonInstance5.TextBoxText = "How to Get Key?";
        local WhiteColor4 = Color3FromRgb(255, 255, 255);
        TextButtonInstance5.TextColor3 = WhiteColor4;
        TextButtonInstance5.TextSize = 13;
        local TinyMargin2 = UdimCreator(0, 6);
        UICornerInstance6.CornerRadius = TinyMargin2;
        UICornerInstance6.TextButtonParent = TextButtonInstance5;
        local EventConnection2;
        EventConnection2 = TextButtonInstance.MouseEnter:Connect(function(...) -- args: X, Y;
            local TweenSettings = Environment.TweenSettings;
            local CreateTween = TweenSettings.new;
            local TweenInfo1 = CreateTween(0.2);
            local PinkColor = Color3FromRgb(200, 70, 70);
            local Tween = TweenService:Create(TextButtonInstance, TweenInfo1, {
                BackgroundColor3 = PinkColor,
            });
            local StartTween = Tween.StartTween;
            local StartTween1 = Tween:StartTween();
        end);
        local EventConnection3;
        EventConnection3 = TextButtonInstance.MouseLeave:Connect(function(...) -- args: X_2, Y_2;
            local CreateTween1 = TweenSettings.new;
            local TweenInfo2 = CreateTween1(0.2);
            local RedColor4 = Color3FromRgb(255, 85, 85);
            local Tween1 = TweenService:Create(TextButtonInstance, TweenInfo2, {
                BackgroundColor3 = RedColor4,
            });
            local StartTween2 = Tween1.StartTween;
            local StartTween3 = Tween1:StartTween();
        end);
        local EventConnection4;
        EventConnection4 = TextButtonInstance3.MouseEnter:Connect(function(...) -- args: X_3, Y_3;
            local CreateTween2 = TweenSettings.new;
            local TweenInfo3 = CreateTween2(0.2);
            local BrownColor = Color3FromRgb(175, 85, 85);
            local Tween2 = TweenService:Create(TextButtonInstance3, TweenInfo3, {
                BackgroundColor3 = BrownColor,
            });
            local StartTween4 = Tween2.StartTween;
            local StartTween5 = Tween2:StartTween();
        end);
        local EventConnection5;
        EventConnection5 = TextButtonInstance3.MouseLeave:Connect(function(...) -- args: X_4, Y_4;
            local CreateTween3 = TweenSettings.new;
            local TweenInfo4 = CreateTween3(0.2);
            local RedColor5 = Color3FromRgb(255, 85, 85);
            local Tween3 = TweenService:Create(TextButtonInstance3, TweenInfo4, {
                BackgroundColor3 = RedColor5,
            });
            local StartTween6 = Tween3.StartTween;
            local StartTween7 = Tween3:StartTween();
        end);
        local EventConnection6;
        EventConnection6 = TextButtonInstance2.MouseEnter:Connect(function(...) -- args: X_5, Y_5;
            local CreateTween4 = TweenSettings.new;
            local TweenInfo5 = CreateTween4(0.2);
            local PinkColor1 = Color3FromRgb(200, 70, 70);
            local Tween4 = TweenService:Create(TextButtonInstance2, TweenInfo5, {
                TextColor3 = PinkColor1,
            });
            local StartTween8 = Tween4.StartTween;
            local StartTween9 = Tween4:StartTween();
        end);
        local EventConnection;
        EventConnection = TextButtonInstance2.MouseLeave:Connect(function(...) -- args: X_6, Y_6;
            local TweenInfoConfig = TweenSettings.new;
            local TweenConfig = TweenInfoConfig(0.2);
            local ErrorColor = Color3FromRgb(255, 85, 85);
            local TextButtonTween = TweenService:Create(TextButtonInstance2, TweenConfig, {
                TextColor3 = ErrorColor,
            });
            local PlayTween = TextButtonTween.StartTween;
            local PlayTween = TextButtonTween:StartTween();
        end);
        getgenv().CheckingRN2 = false;
        local EventConnection1;
        EventConnection1 = TextButtonInstance3.MouseButton1Click:Connect(function(...)
            local CheckingRN = getgenv().CheckingRN2;
            getgenv().CheckingRN2 = true;
            local SetClipboardFunction = Environment.SetClipboardFunction;
            local SetClipboardConfig = SetClipboardFunction("https://discord.gg/zenithstudios");
            TextButtonInstance3.TextBoxText = "Copied!";
            local WaitTime = wait(1);
            TextButtonInstance3.TextBoxText = "Get Key";
            getgenv().CheckingRN2 = false;
        end);
        local EventConnection2;
        EventConnection2 = TextButtonInstance5.MouseButton1Click:Connect(function(...)
            getgenv().CheckingRN23 = true;
            local SetClipboardConfig1 = SetClipboardFunction("https://www.youtube.com/watch?v=91CgZmiMUiw");
            TextButtonInstance5.TextBoxText = "Copied!";
            local WaitTime1 = wait(1);
            TextButtonInstance5.TextBoxText = "How to Get Key?";
            getgenv().CheckingRN23 = false;
        end);
        local EventConnection3;
        EventConnection3 = TextButtonInstance2.MouseButton1Click:Connect(function(...)
            TextButtonInstance2.TextBoxText = "Copied!";
            local SetClipboardConfig2 = SetClipboardFunction("discord.gg/zenithstudios");
            local WaitTime2 = wait(2);
            TextButtonInstance2.TextBoxText = "Join the Discord!";
        end);
        Environment.LoadKey = function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
            local KeyFileExists = isfile("Zenith Key.txt");
        end;
        local HttpService = game:GetService("HttpService");
        local HttpServiceClone = cloneref(HttpService);
        local Players = game:GetService("Players");
        local PlayersClone = cloneref(Players);
        Environment.Check = function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
            local CheckingRN1 = getgenv().CheckingRN;
            getgenv().CheckingRN = true;
            local TweenSuccess, TweenError = pcall(function(...)
                local IsTextButtonHidden = not TextButtonInstance;
                -- false
                if TextButtonInstance then -- ran, expr id 28, has an else.
                    local TextButtonParent = TextButtonInstance.TextButtonParent;
                    local IsTextButtonParentless = not TextButtonParent;
                    -- false
                    if IsTextButtonParentless then -- didnt run, expr id 29, has an else.
                    else
                        TextButtonInstance.TextBoxText = "Checking Key..";
                        local TextBoxText = TextBoxInstance.TextBoxText;
                    end
                    local TextWithoutSpaces = string.gsub(TextBoxText, "%s", "");
                    Environment.currentkey = TextWithoutSpaces;
                end
                Environment.script_key = TextWithoutSpaces;
                local DelayedTask = task.delay(15, function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
                end);
                local CheckKeySuccess, CheckKeyError = pcall(function(...)
                    local CheckKeyFunction = LoadedLibraryInstance.check_key;
                    local IsTextWithoutSpacesEmpty = not TextWithoutSpaces;
                    -- false
                    if IsTextWithoutSpacesEmpty then -- didnt run, expr id 30, has an else.
                    else
                        local CheckKeyConfig = CheckKeyFunction(TextWithoutSpaces);
                    end
                end) -- true
                local IsCheckKeyConfigFailed = not CheckKeyConfig;
                -- false
                if IsCheckKeyConfigFailed then -- didnt run, expr id 31, has an else.
                else
                    local RequestSuccess, RequestError = pcall(function(...)
                        local RequestResponse = request({
                            Method = "GET",
                            Url = "https://zenithhub.cloud/keyless-status",
                        });
                        local ResponseStatus = RequestResponse.ResponseStatus2;
                        local IsRequestSuccessful = (ResponseStatus == 200);
                        -- false, eq id 3
                        if IsRequestSuccessful then -- didnt run, expr id 32, has an else.
                        else
                        end
                    end) -- true
                end
                local IsCheckKeyConfigFailed1 = not CheckKeyConfig;
                -- false
                if CheckKeyConfig then -- ran, expr id 33, has an else.
                    local ResponseCode = CheckKeyConfig.code;
                    local IsResponseCodeEmpty = not ResponseCode;
                    -- false
                    if IsResponseCodeEmpty then -- didnt run, expr id 34, has an else.
                    else
                        local ResponseCode1 = CheckKeyConfig.code;
                    end
                    local IsResponseCodeValid = (ResponseCode1 == "KEY_VALID");
                    -- false, eq id 4
                    if IsResponseCodeValid then -- didnt run, expr id 35, has an else.
                    else
                        local ResponseCode2 = CheckKeyConfig.code;
                        local IsResponseCodeHwidLocked = (ResponseCode2 == "KEY_HWID_LOCKED");
                        -- false, eq id 5
                        if IsResponseCodeHwidLocked then -- didnt run, expr id 36, has an else.
                        else
                            local ResponseCode3 = CheckKeyConfig.code;
                            local IsResponseCodeInvalid = (ResponseCode3 == "KEY_INVALID");
                            -- false, eq id 6
                            if IsResponseCodeInvalid then -- didnt run, expr id 37, has an else.
                            else
                                getgenv().Authenicated = false;
                                getgenv().CheckingRN = false;
                                local ResponseMessage = CheckKeyConfig.message;
                                local IsResponseMessageEmpty = not ResponseMessage;
                                -- false
                                if IsResponseMessageEmpty then -- didnt run, expr id 38, has an else.
                                else
                                    local ResponseMessageToString = tostring(ResponseMessage);
                                    local ResponseCode4 = CheckKeyConfig.code;
                                    local IsResponseCodeEmpty1 = not ResponseCode4;
                                    -- false
                                    if IsResponseCodeEmpty1 then -- didnt run, expr id 39, has an else.
                                    else
                                        local ResponseCodeToString = tostring(ResponseCode4);
                                        print("[KEY] Key check failed - Code:", ResponseCodeToString, "Message:", ResponseMessageToString) -- [KEY] Key check failed - Code: Code_5 Message: Message
                                        local ErrorMessage = "Error: " .. ResponseCodeToString;
                                        -- "Error: Code_5"
                                        local IsTextButtonHidden1 = not TextButtonInstance;
                                        -- false
                                        if TextButtonInstance then -- ran, expr id 40, has an else.
                                            local TextButtonParent1 = TextButtonInstance.TextButtonParent;
                                            local IsTextButtonParentless1 = not TextButtonParent1;
                                            -- false
                                            if TextButtonParent1 then -- ran, expr id 41, has an else.
                                                TextButtonInstance.TextBoxText = ErrorMessage;
                                            end
                                        end
                                        local WaitTime3 = task.wait(2);
                                        local IsTextButtonHidden2 = not TextButtonInstance;
                                        -- false
                                        if TextButtonInstance then -- ran, expr id 42, has an else.
                                            local TextButtonParent2 = TextButtonInstance.TextButtonParent;
                                            local IsTextButtonParentless2 = not TextButtonParent2;
                                            -- false
                                            if TextButtonParent2 then -- ran, expr id 43, has an else.
                                                TextButtonInstance.TextBoxText = "Submit Key >";
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end) -- true
        end;
        Environment.handleKeyStatus = function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
            local IsExt1Empty = not FilePath;
            -- false
            if FilePath then -- ran, expr id 44, has an else.
                local Ext1Code = FilePath.code;
                local IsExt1CodeEmpty = not Ext1Code;
                -- false
                if IsExt1CodeEmpty then -- didnt run, expr id 45, has an else.
                else
                    local Ext1Code1 = FilePath.code;
                    local IsExt1CodeValid = (Ext1Code1 == "KEY_VALID");
                    -- false, eq id 7
                    if IsExt1CodeValid then -- didnt run, expr id 46, has an else.
                    else
                        local Ext1Code2 = FilePath.code;
                        local IsExt1CodeHwidLocked = (Ext1Code2 == "KEY_HWID_LOCKED");
                        -- false, eq id 8
                        if IsExt1CodeHwidLocked then -- didnt run, expr id 47, has an else.
                        else
                            local Ext1Code3 = FilePath.code;
                            local IsExt1CodeInvalid = (Ext1Code3 == "KEY_INVALID");
                            -- false, eq id 9
                            if IsExt1CodeInvalid then -- didnt run, expr id 48, has an else.
                            else
                                getgenv().Authenicated = false;
                                getgenv().CheckingRN = false;
                                local Ext1Message = FilePath.message;
                                local IsExt1MessageEmpty = not Ext1Message;
                                -- false
                                if IsExt1MessageEmpty then -- didnt run, expr id 49, has an else.
                                else
                                    local Ext1MessageToString = tostring(Ext1Message);
                                    local Ext1Code4 = FilePath.code;
                                    local IsExt1CodeEmpty1 = not Ext1Code4;
                                    -- false
                                    if IsExt1CodeEmpty1 then -- didnt run, expr id 50, has an else.
                                    else
                                        local Ext1CodeToString = tostring(Ext1Code4);
                                        print("[KEY] Key check failed - Code:", Ext1CodeToString, "Message:", Ext1MessageToString) -- [KEY] Key check failed - Code: Code_10 Message: Message_2
                                        local Ext1ErrorMessage = "Error: " .. Ext1CodeToString;
                                        -- "Error: Code_10"
                                        local IsTextButtonHidden3 = not TextButtonInstance;
                                        -- false
                                        if TextButtonInstance then -- ran, expr id 51, has an else.
                                            local TextButtonParent3 = TextButtonInstance.TextButtonParent;
                                            local IsTextButtonParentless3 = not TextButtonParent3;
                                            -- false
                                            if TextButtonParent3 then -- ran, expr id 52, has an else.
                                                TextButtonInstance.TextBoxText = Ext1ErrorMessage;
                                                local WaitTime4 = task.wait(2);
                                                local IsTextButtonHidden4 = not TextButtonInstance;
                                                -- false
                                                if TextButtonInstance then -- ran, expr id 53, has an else.
                                                    local TextButtonParent4 = TextButtonInstance.TextButtonParent;
                                                    local IsTextButtonParentless4 = not TextButtonParent4;
                                                -- false
                                                    if TextButtonParent4 then -- ran, expr id 54, has an else.
                                                        TextButtonInstance.TextBoxText = "Submit Key >";
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end;
        getgenv().CheckingRN = false;
        local EventConnection4;
        EventConnection4 = TextButtonInstance.MouseButton1Click:Connect(function(...)
            local GetgenvSuccess, GetgenvError = pcall(function(...)
                local CheckingRN2 = getgenv().CheckingRN;
                getgenv().CheckingRN = true;
                local TextButtonSuccess, TextButtonError = pcall(function(...)
                    local IsTextButtonHidden5 = not TextButtonInstance;
                    -- false
                    if TextButtonInstance then -- ran, expr id 55, has an else.
                        local TextButtonParent5 = TextButtonInstance.TextButtonParent;
                        local IsTextButtonParentless5 = not TextButtonParent5;
                        -- false
                        if IsTextButtonParentless5 then -- didnt run, expr id 56, has an else.
                        else
                            TextButtonInstance.TextBoxText = "Checking Key..";
                            local TextBoxText1 = TextBoxInstance.TextBoxText;
                            local TextWithoutSpaces1 = string.gsub(TextBoxText1, "%s", "");
                            Environment.currentkey = TextWithoutSpaces1;
                            Environment.script_key = TextWithoutSpaces1;
                            local DelayedTask = task.delay(15, function(FilePath, FileExtension, FileData, FileMetadata, FileSettings, ...)
                            end);
                            local CheckResult, CheckError = pcall(function(...)
                                local KeyChecker = LoadedLibraryInstance.check_key;
                                local IsNotValid = not TextWithoutSpaces1;
                                -- false
                                if IsNotValid then -- didnt run, expr id 57, has an else.
                                else
                                    local ApiCall = KeyChecker(TextWithoutSpaces1);
                                end
                            end) -- true
                        end
                        local IsNotApiCall = not ApiCall;
                        -- false
                        if IsNotApiCall then -- didnt run, expr id 58, has an else.
                        else
                            local RequestResult, RequestError = pcall(function(...)
                                local ResponseData = request({
                                    Method = "GET",
                                    Url = "https://zenithhub.cloud/keyless-status",
                                });
                                local ResponseStatus = ResponseData.ResponseStatus2;
                                local IsValidStatus = (ResponseStatus == 200);
                                -- false, eq id 10
                                if IsValidStatus then -- didnt run, expr id 59, has an else.
                                else
                                end
                            end) -- true
                            local IsNotApiCall2 = not ApiCall;
                            -- false
                            if ApiCall then -- ran, expr id 60, has an else.
                                local ResponseCode = ApiCall.code;
                                local IsNotResponseCode = not ResponseCode;
                                -- false
                                if IsNotResponseCode then -- didnt run, expr id 61, has an else.
                                else
                                    local KeyCode = ApiCall.code;
                                    local IsKeyCodeValid = (KeyCode == "KEY_VALID");
                                    -- false, eq id 11
                                    if IsKeyCodeValid then -- didnt run, expr id 62, has an else.
                                    else
                                        local HwidCode = ApiCall.code;
                                        local IsHwidCodeLocked = (HwidCode == "KEY_HWID_LOCKED");
                                        -- false, eq id 12
                                        if IsHwidCodeLocked then -- didnt run, expr id 63, has an else.
                                        else
                                            local InvalidCode = ApiCall.code;
                                            local IsInvalidCode = (InvalidCode == "KEY_INVALID");
                                            -- false, eq id 13
                                            if IsInvalidCode then -- didnt run, expr id 64, has an else.
                                            else
                                                getgenv().Authenicated = false;
                                                getgenv().CheckingRN = false;
                                                local ResponseMessage = ApiCall.message;
                                                local IsNotResponseMessage = not ResponseMessage;
                                                -- false
                                                if IsNotResponseMessage then -- didnt run, expr id 65, has an else.
                                                else
                                                    local MessageString = tostring(ResponseMessage);
                                                    local ErrorCode = ApiCall.code;
                                                    local IsNotErrorCode = not ErrorCode;
                                                -- false
                                                    if IsNotErrorCode then -- didnt run, expr id 66, has an else.
                                                    else
                                                        local ErrorCodeString = tostring(ErrorCode);
                                                        print("[KEY] Key check failed - Code:", ErrorCodeString, "Message:", MessageString) -- [KEY] Key check failed - Code: Code_15 Message: Message_3
                                                        local ErrorMessage = "Error: " .. ErrorCodeString;
                                                -- "Error: Code_15"
                                                        local IsNotTextButton = not TextButtonInstance;
                                                -- false
                                                        if TextButtonInstance then -- ran, expr id 67, has an else.
                                                            local TextButtonParent = TextButtonInstance.TextButtonParent;
                                                            local IsNotTextButtonParent = not TextButtonParent;
                                                -- false
                                                            if TextButtonParent then -- ran, expr id 68, has an else.
                                                                TextButtonInstance.TextBoxText = ErrorMessage;
                                                                local WaitTime = task.wait(2);
                                                                local IsNotTextButton2 = not TextButtonInstance;
                                                -- false
                                                                if TextButtonInstance then -- ran, expr id 69, has an else.
                                                                    local TextButtonParent2 = TextButtonInstance.TextButtonParent;
                                                                    local IsNotTextButtonParent2 = not TextButtonParent2;
                                                -- false
                                                                    if TextButtonParent2 then -- ran, expr id 70, has an else.
                                                                        TextButtonInstance.TextBoxText = "Submit Key >";
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end) -- true
            end) -- true
        end);
        local InputService = game:GetService("UserInputService");
        local InputServiceClone = cloneref(UserInputService);
        local Connection1;
        Connection1 = TextBoxInstance.Focused:connect(function(...)
            local Connection2;
            Connection2 = UserInputService.InputBegan:connect(function(...) -- args: Input_5, GameProcessedEvent_3;
                local KeyCodeValue = ({
                    ...
                }).Key;
                local ReturnKey = KeyCodeEnum.ReturnKey;
                local IsNotReturnKey = (KeyCodeValue ~= ReturnKey);
                -- true, eq id 20
                if IsNotReturnKey then -- ran, expr id 77, has no else.
                end
            end);
        end);
        local Connection3;
        Connection3 = ImageLabelInstance.InputBegan:Connect(function(...) -- args: Input;
            local InputType = ({
                ...
            }).InputType;
            local UserInputTypeEnum = Enum.InputType;
            local MouseClick = UserInputTypeEnum.MouseClick;
            local IsNotMouseClick = (InputType ~= MouseClick);
            -- true, eq id 14
            if IsNotMouseClick then -- ran, expr id 71, has an else.
                local InputType2 = ({
                    ...
                }).InputType;
            end
            local TouchInput = UserInputTypeEnum.TouchInput;
            local IsNotTouchInput = (InputType2 ~= TouchInput);
            -- true, eq id 15
            if IsNotTouchInput then -- ran, expr id 72, has no else.
            end
        end);
        local Connection4;
        Connection4 = ImageLabelInstance.InputChanged:Connect(function(...) -- args: Input_2;
            local InputType3 = ({
                ...
            }).InputType;
            local MouseMotion = UserInputTypeEnum.MouseMotion;
            local IsNotMouseMotion = (InputType3 ~= MouseMotion);
            -- true, eq id 16
            if IsNotMouseMotion then -- ran, expr id 73, has an else.
                local InputType4 = ({
                    ...
                }).InputType;
                local TouchInput2 = UserInputTypeEnum.TouchInput;
                local IsNotTouchInput2 = (InputType4 ~= TouchInput2);
                -- true, eq id 17
                if IsNotTouchInput2 then -- ran, expr id 74, has no else.
                end
            end
        end);
        local Connection5;
        Connection5 = UserInputService.InputChanged:Connect(function(...) -- args: Input_3, GameProcessedEvent;
            local DoesExist = (... ~= nil);
            -- true, eq id 18
            if DoesExist then -- ran, expr id 75, has no else.
            end
        end);
        local RequestResponse = request({
            Method = "GET",
            Url = "https://zenithhub.cloud/keyless-status",
        });
        local ResponseStatus2 = RequestResponse.ResponseStatus2;
        local IsValidStatus2 = (ResponseStatus2 == 200);
        -- false, eq id 2
        if IsValidStatus2 then -- didnt run, expr id 13, has an else.
        else
        end
    end
end
