Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012048.outbound.protection.outlook.com [52.101.48.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588A9310635
	for <nvdimm@lists.linux.dev>; Mon, 16 Feb 2026 14:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771252117; cv=fail; b=JnMiu+Xt3HER8hrvjlpT3R1m3u5v1pLJWUKyz/CbqPHYnDdGp7CpPJ2IUVhGBF86zNO8S8aUtS7dlkKaLkmwUz0ISrSon85m8fc4v+Y0WwQ45d8ekWExNZMKN+aq/EzduAL12iTrqs26d8lFpR3WUvf6Bigb34fx9DWZIxMbS2w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771252117; c=relaxed/simple;
	bh=y79lF+FJYD19sTOBZgZLsAcLiO43ZbboJf1fVVm/w2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=f62L7ikb8lP61SSwylBkRZlCE/BzH/qwyhtp4JGfNuVjgbmWJtRmOB1tSQx1vnMn495mGjhsBL1OXsukDEl16TBWT89YBQ06X7UQgIG9iJGhN1G26iuvB5aC9ltXbA9A+7H5sZDS8a/xV1dCkYcsDy6a/1kW/4VOwCSbX59ksHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=b4N7frkX; arc=fail smtp.client-ip=52.101.48.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="b4N7frkX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=smdSEKz3vtKVMCxZRpLD32VDtfMKW2W+GCWigRbX11vYT2XN3RfPpwRcthZUOpGbQdaUrCFH0NQPP+OPqp4RVKDFRorXZWlw1OXS3zea6TAhbbewQvfJAJUCufSttKvm3eURZK3VeDGyffmliKdpe52SC6ECTn75KpMmGqNwpgZnRvEI0dKONaft7fMZF8qpbMHd4xcT7yCgOpcTtzGGotL52E3O6t2qKux5u2PrDcH6xqfr2wdQvp5VbMOWSqG8jrkRqlwEF2kvn4ocszMhdTzo/5sE5TpbqVXLGfXtJCRYDy1lsrKeuLxM6k5bqA1dwEJkmZeyBbIrrVnPTQVGlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=npZGWGaOnskeOzrYc1/1mgWhmrUlxv/HdhxIK+jH/yM=;
 b=bxXrPMfXWMxb/m3aeBAr9qcWOVU9jBD4i373DnRw8oKcpnEAviDwmi0LqiemHXAmPFvPLbmAP2yTICxDvGdmNvacflc31lh1LdRLd8LvvMayeUxFlYUbbEGXQYY4GuvwMi6UZIJcPOlbrVRFSpcv1fTDXvUIxEVUwdYl2OwS29uh73LmRFsTDRNl4ZAVqZJJSy+T6uKRQEy4eXGlslxAwT+wCqR4RCmEtxEN5zG7vO/OqUdDuilvKeFIC2+DedjrhVlV8t0G2Y0FnoRhC9z+wTKbqY+ozs+v8JhxE+AwVvOGJuOoyMVkfcBqEp/sjc2/2MEdw3Mwi/8WJs6zdCbaXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npZGWGaOnskeOzrYc1/1mgWhmrUlxv/HdhxIK+jH/yM=;
 b=b4N7frkXy686jtai59ai5WAwWbJag9PMF5WPhEsehV05sTBzfU5A61PB3Gsu7Q+KooBDVKTcHmft2XqAn3wmCsrc7LO1jGeCa6np8ouBsNLVhnZzyCper4vQhTMD6MDTU+KfpqjfoUAFWpB6YOrO9e1AC74vXV1I6PYlmX7EQuY=
Received: from MN2PR06CA0007.namprd06.prod.outlook.com (2603:10b6:208:23d::12)
 by IA1PR12MB6209.namprd12.prod.outlook.com (2603:10b6:208:3e7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 14:28:29 +0000
Received: from BL02EPF0002992B.namprd02.prod.outlook.com
 (2603:10b6:208:23d:cafe::8a) by MN2PR06CA0007.outlook.office365.com
 (2603:10b6:208:23d::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.16 via Frontend Transport; Mon,
 16 Feb 2026 14:28:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992B.mail.protection.outlook.com (10.167.249.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 16 Feb 2026 14:28:29 +0000
Received: from [10.31.195.139] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 16 Feb
 2026 08:28:29 -0600
Message-ID: <32ad3973-57e1-4fee-8afe-5bc82f6d3d5f@amd.com>
Date: Mon, 16 Feb 2026 08:28:30 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v8 0/7] Add error injection support
To: Alison Schofield <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <dave.jiang@intel.com>,
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
References: <20260206215008.8810-1-Benjamin.Cheatham@amd.com>
 <aY5saAx5BOJ5jSyw@aschofie-mobl2.lan>
Content-Language: en-US
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
In-Reply-To: <aY5saAx5BOJ5jSyw@aschofie-mobl2.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992B:EE_|IA1PR12MB6209:EE_
X-MS-Office365-Filtering-Correlation-Id: 64cf6afb-bcb3-4f1f-3758-08de6d67a7d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?azV5aUlpZzQ4UmJ3K3QrMDBiSkJCejUwaURGaDcxOFRYcGdOWnJ4U0Vsdmxs?=
 =?utf-8?B?MUJkbjVPZmYva2IzZGZUck5KR3ZMK0R2dkdOYW9vL0pvVnBzSTFTQTJtbHNs?=
 =?utf-8?B?aHoreW53cTBkMG5ySVJoTlpLZ3RDQXRFM2hKUURBUVdMNDQ5ZjQxaUVXbGVz?=
 =?utf-8?B?NzVzQW9ycVk1YzFMOCt0RTdrVmZVaFFDTVNXZUlvcEFhZlZqenJiTXNwWG9E?=
 =?utf-8?B?dzNCNTBNeDR6eUNsb0VUMmxjZ3VDN2Q1ekJUQ1QzR3lYU2JlSGxpczAvci9X?=
 =?utf-8?B?NFFlOVJWcTNPd2lHNFI0SEVqUlQySXUxV0Yzb1ZUdVVjTi9nT1JXMDZadis1?=
 =?utf-8?B?a0tSWnBrUE8yVVJSYlJybnhiR3JmVDBVUWs4Nmt3MHE3ZXdhb29LcFZrRDNx?=
 =?utf-8?B?WlloaGxpOFlIVkk1YzVYMEppakd6VUNhNlE3ZkhQZUQyN1VCV0dnRkh5OS9j?=
 =?utf-8?B?cnlZMHZyWFdSWGZiMFh3V1dDS1psbDJYS1B4R212aWVtSDlQZzNESU1QYnEz?=
 =?utf-8?B?S1RYcU50ZVlyNjFVbVVIWkd4dUQ2S2FXTHk4Tm1IRkZuRG9kV0d3YXBmWjdG?=
 =?utf-8?B?bzhtV2s2eFVoTWZBT3dGOWpUSFZ0Qnk0eHdzaFpWL2o5RGl6MEVhR2J3ZUdr?=
 =?utf-8?B?c1c5SXlWQmI5NG4yakIvZkhGT2E3bVRRQ2M0a2dvQzc0eUMyenMwbWJGNDFw?=
 =?utf-8?B?VEs4QVV0TjNnOHRZVjdtNGJrb0h3NWczc3VHT0liRnd5c0dEUkpqbTU4V3ln?=
 =?utf-8?B?SkU5YVJSbjZud0FIKzAySkVPa1VLKzFybHo3SWltWHFpNm5nVitxQ1Vidkcv?=
 =?utf-8?B?SFFUNHpZSklqZ3UzaGszdmo4NUdrNmFQdittemo2YTZCLzMvSUhEVU1ZR3Mv?=
 =?utf-8?B?eGsxQnpraEpBNUhVYUxKS05mRlV3MFRQUkRjMGxCUjZFTHBjb2ZUa09YSHB2?=
 =?utf-8?B?RkJFZ2dPanR2L1pvRDJEUkdWcnh4emVoWk0wZUJ2T2JCK0RFVVFwVGJSN0dJ?=
 =?utf-8?B?MCtNT3JydjNIMkYzUzJoOUl6WTdlMlF5MzJoYkJRQnh0TVoyWUhUQ3BhQ1Ba?=
 =?utf-8?B?WFNPTTdSTWJtRGZ4d2RLcmxCa1VpbjVKYmR4ckc3dys3RHNxenpNTTlHNGtz?=
 =?utf-8?B?N1VYb2NvaldMeU11RzVueHNweFhtTUZERitLYWd0aW0zdnZ6bis1NFYxV0U3?=
 =?utf-8?B?MXN4UUQvSVdOQkhxV1JmZTZWTVArV083T0hFNjFoKytWOUVpcUlzbFFhQlUr?=
 =?utf-8?B?ZWMzZ0xWNWJadzQ5NzNKYzRCYlJWN2piMEU0dVp6UWdFdmc2RTVESXI1Z1Ex?=
 =?utf-8?B?cnhDTWFVNE5FUTRSbjB4Zy9mNElSTzAxb0VpVXREZWpYcXcybE4wQXEraUxJ?=
 =?utf-8?B?SE5iRDNXTm5RQlpFbDMyRjlvQkhTb0hRVjVvWGhieTI0MGRmaEhxZ0I5N3Mz?=
 =?utf-8?B?YlBjUkdjU2haL3JRWXlyQTdmMlRZRWR6WmNzRjBRZW1yUDJOc2lHcmV1cDNr?=
 =?utf-8?B?YWg1UGpNTFBENTVERTU5VHNuc1U5RHlMenJZTWNZV0hsdWdHNWRrYlR3RkFK?=
 =?utf-8?B?ZGFLaTlBWDY3QkdVUStUOHBxaDJVU1NpdndHRHRqYXRhZlEyQzEvSmtnMjNw?=
 =?utf-8?B?WUJRVGhraFdKR3E0TXVrTTFTOG5ZaktIWGN5eEwvd2xMZW1LaC9VbCtFbW1i?=
 =?utf-8?B?ZnhmV3BJZHQ4d3dyU1dmZXpBZ05rZ3F1TFhRK2NBNWpMSURrUm9TdzV4WDJP?=
 =?utf-8?B?ck91SGdUaUNUb1Q1Y0RGN1liRlNob0RFQWczYUY0RGdGNVBFQ0tpNlNFWG52?=
 =?utf-8?B?a2pnR3BFeituL0tKKy9FM2wvOFB6aGFyZUJURmtJeStMTTgzSVpkbWZNZldQ?=
 =?utf-8?B?VTc5YlVGcGJETzZycVN1d0VRUFZrdU9FRkUwajVqUlY4ZU9mRXcwZzJGSTJn?=
 =?utf-8?B?NmlUUmcrcSs4ZVJJOGxwZEtkSTY5V0MvUGNIVnJ6N0xCaXdaMzBrVEQranVU?=
 =?utf-8?B?NGdadzZ2QzRuM1lxRDVOSjJZdWpyUy9FWTgrNTcrNk0zaUJNUG9qeFgwY3pB?=
 =?utf-8?B?S3dtck5OcHpUSm1TeURjVEpTSHBpVHI3cDVtWnIxVmlRWlhVT25EV3NpSXJK?=
 =?utf-8?B?UjZYS3o0UGh4VmgrQmpZUm9Ic2hMOExGbTBkRGZmbktRcmtORWxYNkVXd2JR?=
 =?utf-8?Q?63dwDljUBnRoEzU4nqmjFEt7L0HwHI9qXp10MGzQOoBY?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FXaqvN+/aPDMXOLisCOotrmzSXY6RpfsjuNE5Ryy2B8LwDF+BsWbvnKsZ4J7TcEpTSHIMV5XX/s2w6X4iv6LiKMAFwQ08UZsVUOWZv/Y2bg0xoZRZztcyzBhLRcA6m6N1CQt36/NZaCGFilp4fSNU08n3ALceCJf6CH6XjyNyqD8KyWe4jxnyv4iAdCcPxAJ6TtWoRnkW6eyZKbIxkcSP+XgxwQzhqlzhf4twIcNOMIC8fBzYl2YjGy5NmW1LHhM4UT+mUbQiMoSELLLTCpYikb/QUUo4rtZchP1a9HHOjrqERhil+/XfYtGBc6RKRO/v6QBhKEL8SOSZfCtoe3/lsDDuPl/scRTIBMTMh+LPSYTZiEw/1/El7DOBc37xzvyuoTzLuKjMTZFICSLr3OkfCqOwEGgjFoCjo8mFN7xMV4Ysvw4c/MoGtMeoE4mPecl
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 14:28:29.7700
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64cf6afb-bcb3-4f1f-3758-08de6d67a7d7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6209



On 2/12/2026 6:12 PM, Alison Schofield wrote:
> On Fri, Feb 06, 2026 at 03:50:01PM -0600, Ben Cheatham wrote:
> 
> snip
>>
>> Ben Cheatham (7):
>>   libcxl: Add debugfs path to CXL context
>>   libcxl: Add CXL protocol errors
>>   libcxl: Add poison injection support
>>   cxl: Add inject-protocol-error command
>>   cxl: Add poison injection/clear commands
>>   cxl/list: Add injectable errors in output
>>   Documentation: Add docs for protocol and poison injection commands
> 
> Hi Ben,
> 
> Same concern touches 2 patches, so commenting here:
> 	libcxl: Add CXL protocol errors
> 	cxl/list: Add injectable errors in output
> 
> I'm seeing some unwanted complaining with cxl list when protocol inject
> is not supported. Here is a sample:
> 
> # cxl list -P -v
> libcxl: cxl_add_protocol_errors: failed to access /sys/kernel/debug/cxl/einj_types: No such file or directory
> libcxl: cxl_dport_get_einj_path: failed to access /sys/kernel/debug/cxl/cxl_host_bridge.0/einj_inject: No such file or directory
> libcxl: cxl_dport_get_einj_path: failed to access /sys/kernel/debug/cxl/cxl_root_port.0/einj_inject: No such file or directory
> libcxl: cxl_dport_get_einj_path: failed to access /sys/kernel/debug/cxl/cxl_switch_dport.0/einj_inject: No such file or directory
> 
> I believe it is not an error for the path not to exist. With the device poison,
> you already treat search for debugfs file as an existence test and no
> error is emitted on failure to find. 
> 
> If the diff below works for you, and nothing else comes up, I can fix it up
> when merging. Let me know -
> 

Sorry about that, below looks good to me!

Thanks,
Ben
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index d86884bc2de1..5e8deb6e297b 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -3496,10 +3496,8 @@ static void cxl_add_protocol_errors(struct cxl_ctx *ctx)
>         }
>  
>         rc = access(path, F_OK);
> -       if (rc) {
> -               err(ctx, "failed to access %s: %s\n", path, strerror(errno));
> +       if (rc)
>                 goto err;
> -       }
>  
>         rc = sysfs_read_attr(ctx, path, buf);
>         if (rc) {
> @@ -3593,7 +3591,6 @@ CXL_EXPORT char *cxl_dport_get_einj_path(struct cxl_dport *dport)
>  
>         rc = access(path, F_OK);
>         if (rc) {
> -               err(ctx, "failed to access %s: %s\n", path, strerror(errno));
>                 free(path);
>                 return NULL;
>         }
> 

