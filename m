Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012065.outbound.protection.outlook.com [52.101.48.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E86307AE9
	for <nvdimm@lists.linux.dev>; Fri, 30 Jan 2026 19:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769803187; cv=fail; b=GGEqNGZcuWVfZAW1VJ9iotYAvvwJeX2Y1wZfW1xnzhHYGSrlveS7PIYIL5EpX2SD20ehWZ+Oek9oonWarRIlW3ejmmzLzt5HAVH+BDMLrPrklpRlq22hSPoQUwrWOMh79X+MN2pkEt63+wmt93G3JONpwVn8Jd3aOlR39x59uKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769803187; c=relaxed/simple;
	bh=YHSqE6vil03eujiJ62Cp6XWxsEOHdjugCGpHJbOLzyU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=EuVkyJErWeT+yrrofiplQCl5NZ9smiyK4+egwh9bIxXhgAlRvbTEGC3Nd5wLGBT2W3Gwf0KQvOYckPzvtT7L5L6b8o04mYci8crDULDrIAFKwEylMviHvsttO9m7uIdF35l/japRPcCVQSQ606RFfKwXNdDAie4kAsfgPJD7wpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=f7gI9pEw; arc=fail smtp.client-ip=52.101.48.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="f7gI9pEw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P62/gBIzG2RhnFa28wMip/Qr5iu1j8znHAf8q3z+z/84XjSdrsOMEMGXbCKVlvan3XraAqW9vDhdxaklCctenXubMfijoDYAa4JbzBTJv5mhf3CGZuncUoatxvUodcFzRdp/POCDqUV71MBY8ql9ZnL0JMqyvcgK3QQriBYCj2tQipNYGY503m79DsBlm+7XVIfI/L7x194Do7t2lihRQlzGLhZKROGaHUUOS4hYNxzzAogqDDNtLsJNSwExRKbJ+Yv9ytUiemhj/UMN/K8jRGrp8dFPRsCNbCEPGsesgWFcU7TemjDqzi2iibA0uD5TqplgIw9wVrRCINMazahTIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8i+GUL2aNMAm1SDLXecR0wsmLeAINU5TsJ90n2dZFlM=;
 b=A9/GuOXuj3Dpmy3gGXcBqmZkaDdoCUPI9C/sYcR/hMqYJiKB+n0M61xGg7Zk92dbIkgNEXwNBZwGj61DBj3xH3f+ZXC4q5k6kWUeEnBUoa1RIzDZmnQZIzRX16/xZvpSicE33O6HO+BJ/kvlG9P7fmjDjqlZIfZQ1RB2HxVooBoJbvI3Kd1QTvq3dgcudVJ0egKQDuPC+1b9J9UJqyhDwJHB6Onqd5DW3kUfhIW0heHXo5r69M8heh4dKIKSVF5dcDNzHAJayJXaMroHbz4KoZvyg9vKrvxPNCtWF91LPPcvxnpJhK4u5lomaLYEYRHj+OZHb5ajZTRJ5xK0K1kz8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8i+GUL2aNMAm1SDLXecR0wsmLeAINU5TsJ90n2dZFlM=;
 b=f7gI9pEw6QSw4cV7Bt228arfMMSUUO//rOAG2UyrDMC71sLrzQrhEWv192OjBu5UuDqYX1Gh0OB6kRBclC470eHuKNgdaxJGaFLWeNuYzHVL1XTsVenXiS3LKqpeJx8Xz54E8T4BGl0LruKEUFZ5trsa6VOk7p+15clTL3VKviA=
Received: from BY5PR20CA0035.namprd20.prod.outlook.com (2603:10b6:a03:1f4::48)
 by PH7PR12MB7842.namprd12.prod.outlook.com (2603:10b6:510:27a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 19:59:38 +0000
Received: from SJ1PEPF000023CB.namprd02.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::b8) by BY5PR20CA0035.outlook.office365.com
 (2603:10b6:a03:1f4::48) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.10 via Frontend Transport; Fri,
 30 Jan 2026 19:59:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000023CB.mail.protection.outlook.com (10.167.244.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Fri, 30 Jan 2026 19:59:37 +0000
Received: from [10.236.189.18] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 30 Jan
 2026 13:59:36 -0600
Message-ID: <dead69ac-86ee-46ff-ab38-c964935cda13@amd.com>
Date: Fri, 30 Jan 2026 13:59:36 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] Documentation: Add docs for inject/clear-error
 commands
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "Schofield,
 Alison" <alison.schofield@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>
References: <20260122203728.622-1-Benjamin.Cheatham@amd.com>
 <20260122203728.622-8-Benjamin.Cheatham@amd.com>
 <4e3cf71a568f98a8349416874a7f08a5e5099799.camel@intel.com>
Content-Language: en-US
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
In-Reply-To: <4e3cf71a568f98a8349416874a7f08a5e5099799.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CB:EE_|PH7PR12MB7842:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a940dad-2b87-4d0d-79ad-08de603a1913
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VkpjZ3lsQnkxS0FoSEFGV2RsMjVCeHJRMHJtTDlYbHJpWWpDZ1RIbHZjRWFL?=
 =?utf-8?B?VktIWmJCM3ZSSHJyN3R1cWxlZHMxWDJxYlJwNEhEbjdBT0oraEpaa0FoNTFv?=
 =?utf-8?B?S0krODB5WllFTFpNVXo2NXRZYmxXNzV5TXhmb3lXaDVwbG9NVnJHUzA4UHdV?=
 =?utf-8?B?NnpwRjJKVHNQcnJuaHBxUnpVdlQvdUR5WXRNYjBRWEJITEwwcFo1QTUwN1RE?=
 =?utf-8?B?YSs1OUlZak9nd0dBbVdKY2MxWGJOeTNRdUdyNVdHdTBkNFFxV2NEcmtKVFFj?=
 =?utf-8?B?TzlsM25ibm05WlZyRG9pdk1yQ0ZydEgvUFRieFhNSjNPUVlNeVBFTlBmSFpK?=
 =?utf-8?B?WENBdFJycHltOHBGOGRraER2NDBud25NUG12VUR2ZlAvQ1FQc290M0ZSZUpR?=
 =?utf-8?B?T0V2L1R2L2lvcElXRE1ndlYwU3pFVXFxMXNleEpuZzU5VE5PZStPT0JBMndj?=
 =?utf-8?B?eHRwK2RCN3phYmNGSjRIZDAreHkyL09rT1Y5dWxPVitSSDllZGlRYnZyRVF2?=
 =?utf-8?B?dnRyd3FDV1JySXNnYWpyMFFuTldzaWFTNUpmR2Y4UVJ4V28wb0RBS2xWQ2Y5?=
 =?utf-8?B?K25Hc0J2aHJzOGs3YmpFRTQ5QThWK1BFcGdPbUZNd3UxWUMyLzdVNEtIZlFo?=
 =?utf-8?B?Q0h3emJranMyeGdKcVdXc3hVdTR6cmpDdXhXV3NKYS82TnN6VVpCVXFyc21R?=
 =?utf-8?B?ekozdGlCNFJUejlKSStDaU5XUzlQUVpHOUNqbWE1elJmVlFHcEU2RjNMWGhi?=
 =?utf-8?B?TzY3NUswNVBra0NweXNJdG80bGROY1lOZXVZY3c3RjlWRGJVTWZQRWszd3Ew?=
 =?utf-8?B?RVFxYzFDT2xORXE3c0RHRW5OQkM4dTQ2UU9Ja1VUQWFJSVNmTk5PUFlVUWVD?=
 =?utf-8?B?MGtsVktHN1E5NVdSWThzektVWnF3Z2dlSEFKQSthdXdlM1NGWUx5T0htTkJC?=
 =?utf-8?B?L0FoWWU2RmwyRmUxNmgrR1MvKzJWSVZWZmNJT2RNVjFoS1duUEV6TVl5eGxV?=
 =?utf-8?B?OUpUcHpnNGZXSHRPOGMvSmpFTUpkOE53K1hlN3NwUHNlWUhSVElmVEVhSUZU?=
 =?utf-8?B?TjJwWTVSZ0lFQTN0Yk9OdUY1ek9IU2VmSVhzd3dNZEtVK3VIOCs0RGtvNlJF?=
 =?utf-8?B?Q2xJWVI2M3JRRzJwS2dlWnVXRHVZNHlqbkNBTWtRT0dmMTRESFdxeTllTzZI?=
 =?utf-8?B?dmZuKzlpcURsOHhYa0szKytHY1ptR1F6UmVOZENSemZ1bUxMcnNPdWVkMC9H?=
 =?utf-8?B?dXlLZk40SWZ0Tks3TW4zTDFieC9WM0duNWN3dkZrd1NXVy9oQXRzOS9wUHN3?=
 =?utf-8?B?c3YvZ01yLytuRkU2eUpNRGlxRTNLWEJPWGJTRTVyNHRWVUJiOXF0aFVYck1H?=
 =?utf-8?B?TE1DU01ldVFGakJ4cVZFUW9qTnk4SE9tNnBYV1pjcFB0d3ViR2NyZmwzNkNz?=
 =?utf-8?B?VytoOWFxa2xhRnlhay96SG0vS2VvQUcreDUyVUd0TXlyYXR5SEFCMjJhdmNm?=
 =?utf-8?B?RmMxQ29RVDRydnhlN050Q2YwY2hzTWI5UDJVbnpSbnFHbVU2NEF5UG8wMVYy?=
 =?utf-8?B?ODJjcW84bVMrYlVKM1h5enRjaDIzZEZIUDZWTEQwTGVhQnRJMnhYZUNSak1S?=
 =?utf-8?B?TGEvZ1Bxd2tlWkVXck1WUDJNaFFhWUNNTUt3QmIyOEJCVXVVWkpKVVVsZXpT?=
 =?utf-8?B?TW9abHpZM3dXTUIwZ0NzTnk2THpOZnAzR2xrTDlxQSsxcEsrOHNKc05qenEx?=
 =?utf-8?B?RXdCdkZheWlEMGRsRkVVV0w1WTRBVzkzQVg1OHpyR01Ka1BuVTAxY2xPL2hH?=
 =?utf-8?B?OTNLQ05WZzhZWmNrMXNkU3BrMDJOTkVLTFN1UllJdXNQOVB0azNKQXYxSzJv?=
 =?utf-8?B?QjhuRGJlS0JWVE5Kd1ZuemUvZXZycjFXVXE2L0taYjJLMzg1alN0RTgwT09R?=
 =?utf-8?B?WkJCMGNiMnFRQzZIai82SHhRYW1Lek1SRThCTUpMdy9DbEg0V0pDMEg4czR6?=
 =?utf-8?B?aXZReGszaStoZk9jckN0bkZqaUFGeTVOazdCQjFBMlRybUFhd09VQlJvQVlZ?=
 =?utf-8?B?RGNXMlZoWkNtZXZrOGUwT0dVS3VPcGhScVd2Mldnb2ZJZ2ozVGUzUVdZb0dh?=
 =?utf-8?B?TzRTRitJN3d2ZUgrMmFPZmlIbkdRZTZjdUE1b1RrZTJUNDVzNE9mY0dMVTdU?=
 =?utf-8?B?TzA5T0dvWXkxREluN2tJbUw2enhvQzBab2h6NkxXN1JMSmxlbVJnTFhUL292?=
 =?utf-8?B?R1lEdXJXbklSZ3ZtclBBZG8wWDNRPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RGcK5eZRCaFOh9SqGHMKCDjhOPo1AsppPgWJcs7QUrMHKFvC4ciAUEDbTFyik7uwKL5rKTSX89DpyDw/22DUp3mMl30jZlB2xSIp7hP9Y0oDlaAuzXp8DKtnFSx2pcoCZbEgrdm4cE71t54lbACO/l5/eCGN2XnTrWAbfbhmuYTTWTfMFAd6GBVD5bH5CCl8ouDJYAjBNcwi7WD/ZfvUHDShVgfs4XjdiQgVr26t1of3HdctDxEcMfDlZNZzzpsymPF875jglJ2TcoGWu4RaRHJE6PSfeg8BNStUvixItFuFLQNxM/U/Z5fMMoZ0e48e/F0cKuAy/MqOvYEZMfB5SBXa9TTbkifd53BUVfoHXsvH/QECnXBCCiGipqLWehiFXbO6kbebrhkDiixO5GszmNEdzQlxtpNBRcleHUxasw49W6euG2VM5/ocyRiiDybt
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 19:59:37.7494
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a940dad-2b87-4d0d-79ad-08de603a1913
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7842

> 
> It feels to me like the two injection 'modes' should really be two
> separate commands, especially since they act on different classes of
> targets.
> 
> So essentially, split both the injection and clear commands into:
> 
> inject-protocol-error
> inject-media-error
> clear-protocol-error
> clear-media-error.

This seems reasonable but I should clarify it would only be 3 commands,
clear-protocol-error wouldn't be a thing since there's only an injection
action for protocol errors.

Should I keep this all in one file or split into two separate files
on protocol/media error lines? Could also do inject/clear files if that
seems more logical.
> 
> That way the target operands for them are well defined - i.e. port
> objects for protocol errors and memdevs for media errors.
> 
> 
> Another thing - and I'm not too attached to either way for this -
> 
> The -t 'long-string' feels a bit awkward. Could it be split into
> something like:
> 
>   --target={mem,cache} --type={correctable,uncorrectable,fatal}
> 
> And then 'compose' the actual thing being injected from those options?
> Or is that unnecessary gymnastics?
> 

No, I like that idea. I do think the argument names could be better though.
What about:

	# inject-protocol-error <port> --protocol={mem,cache} --severity={correctable,uncorrectable,fatal}

with the short flags for --protocol and --severity being -p and -s, respectively?

For inject/clear-media-error it could stay as-is, i.e.:

	# inject-media-error <memdev> -t={poison} -a=<device physical address>

or I could update it to be something like:

	# inject-media-error <memdev> --poison -a=<device physical address>

Thanks,
Ben
