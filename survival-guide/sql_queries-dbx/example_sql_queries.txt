[epo_inputs]
connection = teledv50
host = teledv50
index = epo
interval = 3600
max_rows = 100000
mode = advanced
query = SELECT [EPOEvents].[ReceivedUTC] AS [timestamp],
         [EPOEvents].[AutoID],
         [EPOEvents].[ThreatName] AS [signature],
         [EPOEvents].[ThreatType] AS [threat_type],
         [EPOEvents].[ThreatEventID] AS [signature_id],
         [EPOEvents].[ThreatCategory] AS [category],
         [EPOEvents].[ThreatSeverity] AS [severity_id],
         [EPOEventFilterDesc].[Name] AS [event_description],
         [EPOEvents].[DetectedUTC] AS [detected_timestamp],
         [EPOEvents].[TargetFileName] AS [file_name],
         [EPOEvents].[AnalyzerDetectionMethod] AS [detection_method],
         [EPOEvents].[ThreatActionTaken] AS [vendor_action],
         CAST([EPOEvents].[ThreatHandled] AS int) AS [threat_handled],
         [EPOEvents].[TargetUserName] AS [logon_user],
         [EPOComputerProperties].[UserName] AS [user],
         [EPOComputerProperties].[DomainName] AS [dest_nt_domain],
         [EPOEvents].[TargetHostName] AS [dest_dns],
         [EPOEvents].[TargetHostName] AS [dest_nt_host],
         [EPOComputerProperties].[IPHostName] AS [fqdn],
         [dest_ip] = (convert(varchar(3),
         convert(tinyint,
        substring(convert(varbinary(4),
         convert(bigint,
        ([EPOComputerProperties].[IPV4x] + 2147483648))),
        1,
        1)))+'.'+ convert(varchar(3),convert(tinyint,substring(convert(varbinary(4), convert(bigint,([EPOComputerProperties].[IPV4x] + 2147483648))),2,1)))+'.'+ convert(varchar(3),convert(tinyint,substring(convert(varbinary(4), convert(bigint,([EPOComputerProperties].[IPV4x] + 2147483648))),3,1)))+'.'+ convert(varchar(3),convert(tinyint,substring(convert(varbinary(4), convert(bigint,([EPOComputerProperties].[IPV4x] + 2147483648))),4,1))) ), [EPOComputerProperties].[SubnetMask] AS [dest_netmask], [EPOComputerProperties].[NetAddress] AS [dest_mac], [EPOComputerProperties].[OSType] AS [os], [EPOComputerProperties].[OSServicePackVer] AS [sp], [EPOComputerProperties].[OSVersion] AS [os_version], [EPOComputerProperties].[OSBuildNum] AS [os_build], [EPOComputerProperties].[TimeZone] AS [timezone], [EPOEvents].[SourceHostName] AS [src_dns], [src_ip] = ( convert(varchar(3),convert(tinyint,substring(convert(varbinary(4), convert(bigint,([EPOEvents].[SourceIPV4] + 2147483648))),1,1)))+'.'+ convert(varchar(3),convert(tinyint,substring(convert(varbinary(4), convert(bigint,([EPOEvents].[SourceIPV4] + 2147483648))),2,1)))+'.'+ convert(varchar(3),convert(tinyint,substring(convert(varbinary(4), convert(bigint,([EPOEvents].[SourceIPV4] + 2147483648))),3,1)))+'.'+ convert(varchar(3),convert(tinyint,substring(convert(varbinary(4), convert(bigint,([EPOEvents].[SourceIPV4] + 2147483648))),4,1))) ), [EPOEvents].[SourceMAC] AS [src_mac], [EPOEvents].[SourceProcessName] AS [process], [EPOEvents].[SourceURL] AS [url], [EPOEvents].[SourceUserName] AS [source_logon_user], [EPOComputerProperties].[IsPortable] AS [is_laptop], [EPOEvents].[AnalyzerName] AS [product], [EPOEvents].[AnalyzerVersion] AS [product_version], [EPOEvents].[AnalyzerEngineVersion] AS [engine_version], [EPOEvents].[AnalyzerEngineVersion] AS [dat_version], [EPOProdPropsView_VIRUSCAN].[datver] AS [vse_dat_version], [EPOProdPropsView_VIRUSCAN].[enginever64] AS [vse_engine64_version], [EPOProdPropsView_VIRUSCAN].[enginever] AS [vse_engine_version], [EPOProdPropsView_VIRUSCAN].[hotfix] AS [vse_hotfix], [EPOProdPropsView_VIRUSCAN].[productversion] AS [vse_product_version], [EPOProdPropsView_VIRUSCAN].[servicepack] AS [vse_sp]
FROM [ePO_TELEAV438].[dbo].[EPOEvents] EPOEvents
LEFT JOIN [ePO_TELEAV438].[dbo].[EPOLeafNode] EPOLeafNode
    ON [EPOEvents].[AgentGUID] = [EPOLeafNode].[AgentGUID]
LEFT JOIN [ePO_TELEAV438].[dbo].[EPOProdPropsView_VIRUSCAN] EPOProdPropsView_VIRUSCAN
    ON [EPOLeafNode].[AutoID] = [EPOProdPropsView_VIRUSCAN].[LeafNodeID]
LEFT JOIN [ePO_TELEAV438].[dbo].[EPOComputerProperties] EPOComputerProperties
    ON [EPOLeafNode].[AutoID] = [EPOComputerProperties].[ParentID]
LEFT JOIN [ePO_TELEAV438].[dbo].[EPOEventFilterDesc] EPOEventFilterDesc
    ON [EPOEvents].[ThreatEventID] = [EPOEventFilterDesc].[EventId]
        AND (EPOEventFilterDesc.Language='0409')
WHERE [EPOvents].[AutoID] > ?
ORDER BY [EPOvents].[AutoID]
source = dbx
sourcetype = mcafee:epo
ui_query_catalog = ePO_TELEAV438
ui_query_schema = dbo
ui_query_table = EPOEvents
ui_query_mode = advanced
tail_rising_column_name = AutoID
