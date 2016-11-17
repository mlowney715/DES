function DESWindow

f = uifigure('Name', 'DES calculator');

hEncodebutton = uibutton( f, ...
    'Text', 'Encode', ...
    'Position', [100 10 60 25], ...
    'ButtonPushedFcn', @(btn, event)encodebutton_Callback);

hDecodebutton = uibutton( f, ...
    'Text', 'Decode', ...
    'Position', [165 10 60 25], ...
    'ButtonPushedFcn', @(btn, event)decodebutton_Callback);

hKeypanel = uipanel( f, ...
    'Position', [0 40 400 40]);
hKeylabel = uilabel( hKeypanel, ...
    'Text', 'Key:', ...
    'Position', [5 5 35 20]);
hKeyedit = uieditfield( hKeypanel, ...
    'Position', [40 5 275 20]);
hKeygenbutton = uibutton( hKeypanel,...
    'Text', 'Generate!', ...
    'Position', [320 5 70 20], ...
    'ButtonPushedFcn', @(btn, event)generatebutton_Callback);

hEncryptedpanel = uipanel( f, ...
    'Position', [0 80 400 40]);
hEncryptedlabel = uilabel( hEncryptedpanel, ...
    'Text', 'Encrypted', ...
    'Position', [5 5 60 20]);
hEncryptededit = uieditfield( hEncryptedpanel, ...
    'Position', [65 5 320 20]);

hPlaintextpanel = uipanel(f, ...
    'Position', [0 120 400 40] );
hPlaintextlabel = uilabel( hPlaintextpanel, ...
    'Text', 'Plaintext', ...
    'Position', [5 5 60 20]);
hPlaintextedit = uieditfield( hPlaintextpanel, ...
    'Position', [65 5 320 20]);

f.Position = [200 300 400 160];

    function encodebutton_Callback
        text = hPlaintextedit.Value;
        while length(text) < 8
            text = [text ' '];
        end
        k = hKeyedit.Value;
        M = [];
        Key = [];
         try
        for i = 1:8
            M = [M bitget(uint8(text(i)), 8:-1:1)];
            Key = [Key bitget(hex2dec(k(i*2-1:i*2)), 8:-1:1)];
        end   
       
            encrypted = DES(M, Key, 1);
        
        string = '';
        for i = 1:8:64
            byte = dec2hex(binarray2dec(encrypted(i:i+7)));
            if length(byte) < 2
                byte = ['0' byte];
            end
            string = [string byte];
        end
        hEncryptededit.Value = string;
        catch ME
            errordlg('Please Enter 16 hex characters for Key')
        end
    end

    function decodebutton_Callback
        code = hEncryptededit.Value;
        k = hKeyedit.Value;
        M = [];
        Key = [];
        try
        for i = 1:2:15
            M = [M bitget(hex2dec(code(i:i+1)), 8:-1:1)];
            Key = [Key bitget(hex2dec(k(i:i+1)), 8:-1:1)];
        end   
        
        decrypted = DES(M, Key, 2);
        
        string = '';
        for i = 1:8:64
            string = [string char(binarray2dec(decrypted(i:i+7)))];
        end
        hPlaintextedit.Value = string;
        catch ME
            errordlg('Please Enter 16 hex characters for Key and encrypted field')
        end
    end

    function generatebutton_Callback
        randkey = round(rand(1,64));
        
        hexkey = '';
        % We have to do this because hex2dec has a limit of 53-bit numbers:
        for i = 1:8:64
            byte = dec2hex(binarray2dec(randkey(i:i+7)));
            if length(byte) < 2
                byte = ['0' byte];
            end            
            hexkey = [hexkey byte];
        end
        hKeyedit.Value = hexkey;
    end


end

