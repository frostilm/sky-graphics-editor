-- version 0.10.5 (153939) - 1.1, updated on 08 January 2021
-- Written by @Crericper 酷安 http://www.coolapk.com/u/2868027
-- GG help https://gameguardian.net/help/classgg.html
-- main sequence
main = function()
    graphics = ask_choose_graphics()
    fps = get_fps(graphics)
    graphics_val = get_graphics_val(graphics)

    -- debug info
    menu = gg.choice({'继续'}, nil,
                     '已选择画质：' .. get_graphics_name(graphics) ..
                         '\nfps: ' .. fps .. '\ngraphics_val: ' .. graphics_val ..
                         '\n列表内应有5项，第3项为画质，第5项为帧率')
    if menu == nil then main() end

    -- gg.setRanges(gg.REGION_C_ALLOC)
    -- gg.clearResults()
    -- gg.searchAddress('7A???31444', -1, gg.TYPE_DWORD)
    -- gg.addListItems(gg.getResults(1))

    -- gg.clearResults()
    -- gg.searchAddress('7A???3144C', -1, gg.TYPE_DWORD)
    -- gg.addListItems(gg.getResults(1))
    -- os.exit()
    -- -- 内存地址 = 帧率Dword 画质Dword
    -- addressList = {'7A24B31444', '7A2353144C'}
    -- for i, address in ipairs(addressList) do
    --     search(address)
    -- end
    -- os.exit()

    gg.setRanges(gg.REGION_C_ALLOC)
    gg.clearResults()
    -- 2000~10000F;0D;0~3D;0~4D;帧率D::21
    search = get_val_1(graphics) .. 'F;0D;' .. graphics_val .. 'D;' ..
                 get_val_4(graphics) .. 'D;' .. fps .. 'D::24'
    gg.searchNumber(search, gg.TYPE_DWORD)
    os.exit()
end

-- alert if nil
check_nil = function(input, promptText)
    if input == nil then
        gg.alert(promptText)
        os.exit()
    end
end

quit_alert = function(promptText) check_nil(nil, promptText) end

error_in = function(stubName)
    error_alert('在 ' .. stubName .. ' 中发生错误')
end

error_no_item_chosen = function() error_alert('未选择任何项目') end

error_invalid_parameter = function() error_alert('参数无效') end

-- error handler
error_alert = function(promptText)
    menu = gg.choice({'重新开始', '帮助', '退出'}, nil, promptText)
    if menu == 1 then main() end
    if menu == 2 then
        alert_help()
        error_alert(promptText)
    end
    if menu == 3 then os.exit() end
    error_alert(promptText)
end

-- alert containing help information on graphics combinations
alert_help = function()
    text = ''
    text = text .. '帮助\n'
    text = text .. '\n'
    text = text .. '高配手机（最高画质为⚡⚡⚡）：\n'
    text = text .. '节能渲染模式🔋\n'
    text = text .. '  画质=1 帧率=20\n'
    text = text .. '正常渲染模式⚡\n'
    text = text .. '  画质=0 帧率=30\n'
    text = text .. '高流畅渲染模式⚡⚡\n'
    text = text .. '  画质=0 帧率=60\n'
    text = text .. '高分辨率渲染模式⚡⚡⚡\n'
    text = text .. '  画质=2 帧率=30\n'
    text = text .. '\n'
    text = text .. '低配手机（最高画质为⚡⚡）：\n'
    text = text .. '节能渲染模式🔋\n'
    text = text .. '  画质=1 帧率=20\n'
    text = text .. '正常渲染模式⚡\n'
    text = text .. '  画质=0 帧率=30\n'
    text = text .. '高分辨率渲染模式⚡⚡\n'
    text = text .. '  画质=2 帧率=30\n'
    gg.alert(text)
end

-- choose the maximum graphics on your phone
ask_choose_spec = function()
    menu = gg.choice({
        '高配手机（最高⚡⚡⚡）', '低配手机（最高⚡⚡）',
        '帮助'
    }, nil, '选择手机配置')
    if menu == 1 then return 'high-end' end
    if menu == 2 then return 'low-end' end
    if menu == 3 then
        alert_help()
        return ask_choose_spec()
    end
    -- if menu == nil then stub() end
    error_no_item_chosen()
end

-- choose the current graphics setting your game is currently running at
ask_choose_graphics = function()
    menu = gg.choice({'🔋', '⚡', '⚡⚡', '⚡⚡⚡', '帮助'}, nil,
                     '选择当前画质')
    if menu == 1 then return 'battery' end
    if menu == 2 then return 'normal' end
    if menu == 3 then
        spec = ask_choose_spec()
        if spec == 'high-end' then return 'hfr' end
        if spec == 'low-end' then return 'hd' end
        error_no_item_chosen()
    end
    if menu == 4 then return 'hd' end
    if menu == 5 then
        alert_help()
        return ask_choose_graphics()
    end
    os.exit()
    -- error_no_item_chosen()
end

-- return fps value based on graphics setting
get_fps = function(graphics)
    -- 节能渲染模式
    if graphics == 'battery' then return 20 end
    -- 正常渲染模式
    if graphics == 'normal' then return 30 end
    -- 高流畅渲染模式
    if graphics == 'hfr' then return 60 end
    -- 高分辨率渲染模式
    if graphics == 'hd' then return 30 end
    -- 其它
    error_invalid_parameter()
end

-- return graphics value based on graphics setting
get_graphics_val = function(graphics)
    -- 节能渲染模式
    if graphics == 'battery' then return 1 end
    -- 正常渲染模式
    if graphics == 'normal' then return 0 end
    -- 高流畅渲染模式
    if graphics == 'hfr' then return 0 end
    -- 高分辨率渲染模式
    if graphics == 'hd' then return 2 end
    -- 原画
    if graphics == 'fhd' then return 3 end
    -- 其它
    error_invalid_parameter()
end

-- return graphics names based on graphics setting
get_graphics_name = function(graphics)
    -- 节能渲染模式
    if graphics == 'battery' then return '节能渲染模式' end
    -- 正常渲染模式
    if graphics == 'normal' then return '正常渲染模式' end
    -- 高流畅渲染模式
    if graphics == 'hfr' then return '高流畅渲染模式' end
    -- 高分辨率渲染模式
    if graphics == 'hd' then return '高分辨率渲染模式' end
    -- 原画
    if graphics == 'fhd' then return '原画' end
    -- 其它
    error_invalid_parameter()
end

-- return value 1 based on graphics setting
get_val_1 = function(graphics)
    -- 节能渲染模式
    if graphics == 'battery' then return 2000 end
    -- 正常渲染模式
    if graphics == 'normal' then return 2000 end
    -- 高流畅渲染模式
    if graphics == 'hfr' then return 10000 end
    -- 高分辨率渲染模式
    if graphics == 'hd' then return 10000 end
    -- 原画
    if graphics == 'fhd' then return '2000~10000' end
    -- 其它
    error_invalid_parameter()
end

-- return value 4 based on graphics setting
get_val_4 = function(graphics)
    -- 节能渲染模式
    if graphics == 'battery' then return 4 end
    -- 正常渲染模式
    if graphics == 'normal' then return 0 end
    -- 高流畅渲染模式
    if graphics == 'hfr' then return 0 end
    -- 高分辨率渲染模式
    if graphics == 'hd' then return 0 end
    -- 原画
    if graphics == 'fhd' then return '0~4' end
    -- 其它
    error_invalid_parameter()
end

-- execution starts
main()
os.exit()
-- execution ends

-- drafts

-- fps=gg.prompt('输入当前帧率',{[1]=20(省电)/30(正常/高分)/60(高帧)})
-- resolution=gg.prompt('输入当前画质',{[1]=0(正常/高帧),1(省电),2(高分)})

menu = gg.choice({
    '使用特征码（未完成）', '修改帧率', '修改画质', '2倍速',
    '退出'
})

if menu == 1 then
    input1 = gg.prompt({'使用特征码'}, {
        [1] = '2000~10000F;0D;0~3D;0~4D;将当前帧率替换本文D::21'
    })
    if input == nil then
        gg.alert('搜索失败')
        os.exit()
    end
end

if menu == 2 then
    input2 = gg.prompt({'输入当前帧率'}, {[1] = 20})
    gg.alert('修改帧率')
    gg.searchNumber('5', gg.TYPE_FLOAT)
    gg.getResults(100)
    gg.editAll('60', gg.TYPE_FLOAT)
end

if menu == 3 then gg.alert('修改画质') end

if menu == 4 then gg.setSpeed(2) end

if menu == 5 then os.exit() end
