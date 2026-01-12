Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012045.outbound.protection.outlook.com [40.93.195.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A0330DD0E
	for <nvdimm@lists.linux.dev>; Mon, 12 Jan 2026 17:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768238427; cv=fail; b=guD32pjcwpprsrLIOwI6RVBoxFzIXH/lHaLF0kQlz/OKnDCbwexyK2ipcsWf8wgVSlWJBdSlAsog1LNyk4ThyM9pWzRur+59ucOmaa2xN71iD9v8mFzP5pRuSPC4abVFlgZ3lsUO+qIH4D6J/NUj9XU4j3VE3/Iar18CftKu1iE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768238427; c=relaxed/simple;
	bh=fPdVCCdOFmO+BmeWFwV5r8pueeAskFBiSWeB0jliMSg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=R1bRvxdUVpisT+uVVDzscPVBMpGxfCaj4+z/SjLo8MbEqa0BkQDRFwP8BHZWJAOIxH6/lC7qG+loShG29gjn/Dsso061zV7kqINaR96s5rRBKzbXUNDEC+/hpOePtKJI5tB4NGB4BqNI/EHbmyuWxMEfLhc2PMmzRfMPtpuJZ6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aG50H8kS; arc=fail smtp.client-ip=40.93.195.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aG50H8kS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pojFfj6fQ2B4vnLcPNBknyyYtwSJyyZSqHz2XTKI1ywgZFskPCkbc/P7qDdwYdmfq87HIvfYbDMou6OtNGoGFd0Gvif+8AbHKB5YtFYbOnwnYJ0cGnkvhN3Im/da0IXdD2RNMuLsiavUS89kBkXD30+Lse/pK0ed82yC75WvyoRZunCvsqiq8Yg6uWg16KDV+t+z38PthYV0NOsGo/AHXOR5G23PA6VJmk80XC4mT5vk3L9e6NyD4GHHe3vBTeXc8OA6H57626X96bcoougXyBVhUHfFR8B3j+bpwdfQsGDcGmppc2R2yv1p/mUViAHNBDuXnwnR06YK4NcOWcxKFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1khWDXGJPbNVjdAcNk1as/i7vPBSHCF8LrLswdBXN1E=;
 b=mLaflmsHNnizMBHUlEofNi4iEREqT8iyaQ3TYLYjku7Yec4U89fTGaLjNucR5GpEdZDsQkX/Iou78fTNuhlDP37ZFSc0gNZtbx81+FFE/QD333juNDGW3/QjqqsgDsXMvNzbGG76Q6MwOgZO3E8ZeeOSdp/tpmXjXhd4JazXzVwRqWzEUyyTkKkZcGhIWJDzNXVkGvNteRw4huCkTEu+ASKX8yVUSl5eh0QPBQFGgCKIZl+0cPt+boTEOQVoi3fRhKPL0ayRL0aGk2edEHiWwuhOmmJqun0R+/f5NuAFFUBPbw/INQkeDwMoZLGK1nAPATbS/d/I20RKqN01kxtm4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1khWDXGJPbNVjdAcNk1as/i7vPBSHCF8LrLswdBXN1E=;
 b=aG50H8kSnZi/dYASN1JMU8l5lndnKzQHmpCo6gghzyc3eA2Xd66sa3RBojoAzoZ0lsdTipsRBTTfQkNJgD0f1bJ1hZOyOMIF28hVDvB72aJWcOgH0LtbAtSp9XNqkSmmcum6Vj4m5L1FYFVBwfZpmi6HkPnSifkzCPB1MNKrWRk=
Received: from BN9PR03CA0724.namprd03.prod.outlook.com (2603:10b6:408:110::9)
 by DM4PR12MB7646.namprd12.prod.outlook.com (2603:10b6:8:106::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 17:20:15 +0000
Received: from BN3PEPF0000B072.namprd04.prod.outlook.com
 (2603:10b6:408:110:cafe::ef) by BN9PR03CA0724.outlook.office365.com
 (2603:10b6:408:110::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.7 via Frontend Transport; Mon,
 12 Jan 2026 17:20:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B072.mail.protection.outlook.com (10.167.243.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Mon, 12 Jan 2026 17:20:15 +0000
Received: from [10.236.181.95] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 12 Jan
 2026 11:20:14 -0600
Message-ID: <76d122c5-d1f9-41a4-9303-c053de0f455e@amd.com>
Date: Mon, 12 Jan 2026 11:20:14 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [PATCH 3/7] libcxl: Add poison injection support
To: Dave Jiang <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<alison.schofield@intel.com>
CC: <linux-cxl@vger.kernel.org>
References: <20260109160720.1823-1-Benjamin.Cheatham@amd.com>
 <20260109160720.1823-4-Benjamin.Cheatham@amd.com>
 <187c3ad1-4fa0-4573-9848-484629d06217@intel.com>
Content-Language: en-US
In-Reply-To: <187c3ad1-4fa0-4573-9848-484629d06217@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B072:EE_|DM4PR12MB7646:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e6e5459-4b71-44cb-9890-08de51fed9f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a1NxUUdId1RjTGtaTXBEOUczL2F1NTl4MkxjdnpKVFJTOHNzdUxTM0YwcXhF?=
 =?utf-8?B?cFIrUUl5NUdaNzZJQjNJaHNpam1tNFA0K3QvdE5lRlhqaHF3NEtGYlIwakUw?=
 =?utf-8?B?VS9rbDRTb0FDaHM5dldvOVlNWUMxdFBwTkV0Q0Z0QS9jd1AxajZQRk5tcHg1?=
 =?utf-8?B?SkQvTXhrS1o1dk1OZUxCUm5LNDZVUGRCam1qWHVraW1CeHJIb3FTeFhJdlVa?=
 =?utf-8?B?SDZyOTlITVVZbTkyWXdzQmRGa0RCbzNiVDVqVGhBUVZIWmYxZlVuMmtqVFQ3?=
 =?utf-8?B?VHhGMGJkVXl2MVIwOHorNEVETTRlNGJRcGxDdkMybVh2L3h2RDh2TG1aTHo2?=
 =?utf-8?B?STNBUFdJNFkyNlR4cWY4M0JDTGk0S3paK1ZVaXJPSEZWaTh6T1FIbE9FWkdu?=
 =?utf-8?B?N1NZSnRQWS9ZUXFqdTJ6Um4rOEYxSHFuZkNOMmg5Q1I1WHg3VTdrVzhvRk1h?=
 =?utf-8?B?c2xFdi95YzlZY1h1WjRIYTVSY3pCdTlQd1pUVTg3N0J2d0Jnc2VhWitnaWdJ?=
 =?utf-8?B?WXd0NG02TVhoUWxkdjhiYitqL1YwWlc0SjdPZlVOaFhSanRWY2VIdDQyeUN0?=
 =?utf-8?B?OEUwMWJlL0lNeXl0VkFEQUtURkQzTkd2NU95TncyOUR3SzlkUjVPeHFrc3Ux?=
 =?utf-8?B?OE9EWDd2SERUWTBNeEN6MG1sc0F1R2VXS0lZVTR6L2pEN3NCYytUTVROZVY1?=
 =?utf-8?B?Qy95MHdxTFRLMVBwd3MrUUZMUVRLUURqbmxtUzNXdys1eHd6YjlVU2c3L21V?=
 =?utf-8?B?WWtYRzEzczgxcVFYcGYzdjdPQTN2ZEUrOE15RTBmbFY3bUp6eEJRMW1CUGJq?=
 =?utf-8?B?L2g2c21XWDRERmRQRitteDhzMnR3NmJDVmFPTDVUNGlLZWxNbVVLOUs4OVVV?=
 =?utf-8?B?WDRhUVNBUTFjWklnVk9LcXJlNU54RTNhcDAramhLRHN5MWJMR2d1MmhpL2pI?=
 =?utf-8?B?ampVN3Z2anJ6UElvQVcxYzAwSFZkRXB6MnZGdHNjKzhlSXFzaUlTeWNwYk5C?=
 =?utf-8?B?Ri80UXZJQ3FsVzBZaVM2NzZxZm9IQ0ZVM2pTTi8yMk0wWU5kMjVWUWhYUUJs?=
 =?utf-8?B?TnBCaVBPZjFUazJIK3M2WWdvRDlsRjF4R1pvUVFhYUhVRnY0cWMxWmhrd1dj?=
 =?utf-8?B?b051MUYrbld4RDd4Z1JycklSb2hPWFpubnhJTlBLSjhtUTVYODhRZ0x2cC9M?=
 =?utf-8?B?VFJLcE4zN3o0b29ldWZVK3doZHFOZGp3UDJhMHdtU2FHMVhQVVI0eW40elk2?=
 =?utf-8?B?a0FBN1M1SjFQazI3eXJGaElWcWNmT1g1c2wxSEpKenNBRi9TcDZBY2trbW9q?=
 =?utf-8?B?VCt6bENpdENYc2Q3TGhaZHZvVHdodEZQYjhHaG15UlR0cHlzcU9QY2lXUm1B?=
 =?utf-8?B?bWxTV3hWZ1gvSE5McTRnRDNkSWloV0R4KzN1QS9GT2o3dy82VStDc1B1VGtM?=
 =?utf-8?B?TU1DNEloVkIvRHlETWQweXBMOFU0QVZLbnNoOUl6dHJrRXZCNG5JOXo4WXND?=
 =?utf-8?B?RWJycWUzUzZHZVJtMmNDQk56cEpUcjhoSWpEZGRhbXVDNXcvYk5IV0JjQzM5?=
 =?utf-8?B?aFpTdlk0d1hvUmdSRTF1QVlSa1Irc3RvcEZZMG01QWJVUzBNR0o5VjdTN3dT?=
 =?utf-8?B?ZkkyRlhTMmczdk9obmlDcnJrYy9DaHRMZ1laRHkrdkh0YnhlWXFrZWcxdFBY?=
 =?utf-8?B?SmptaS9HaDlaVHZZN1huK01xdSsxK0hJamdENGQ0OTZuU1pKUis2Yk5WNlpQ?=
 =?utf-8?B?dUtMUkowMml6d1pEYStqUXFyQU5ZK1FJdklsZWtzc3lqRkg5MXphdi91ajdE?=
 =?utf-8?B?QlBacTQveFh5UWUxWVd4RHMyNlFkSmlwQ2VZM1JRT1BlSi91R2xjODFFMWNG?=
 =?utf-8?B?Q0xFSkgyS3F0VXRBYU0zaExPWXEyNllyWTgveTBVQmJkNytJcWsvbzhqbktF?=
 =?utf-8?B?aHN5a1BvTDlOTUpuaWp0MS8rTyt0eFNwOU05UW1uR0YyWTdwS3czaDc1bS8v?=
 =?utf-8?B?cDh1MFhLUGxxVnpHNVJMa09vYTFtcGFhbUpIOGtaenpiaVpvdUFKWUNYUTBT?=
 =?utf-8?B?MzBxZU9qeDlqV04vZVlNZVNTUm1tYXpNTTZlMENabUUva1IwbytLSVlOTXBN?=
 =?utf-8?Q?PJzc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 17:20:15.2855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e6e5459-4b71-44cb-9890-08de51fed9f2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7646

On 1/9/2026 12:03 PM, Dave Jiang wrote:
> 
> 
> On 1/9/26 9:07 AM, Ben Cheatham wrote:
>> Add a library API for clearing and injecting poison into a CXL memory
>> device through the CXL debugfs.
>>
>> This API will be used by the 'cxl-inject-error' and 'cxl-clear-error'
>> commands in later commits.
>>
>> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
>> ---
>>  cxl/lib/libcxl.c   | 83 ++++++++++++++++++++++++++++++++++++++++++++++
>>  cxl/lib/libcxl.sym |  3 ++
>>  cxl/libcxl.h       |  3 ++
>>  3 files changed, 89 insertions(+)
>>
>> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
>> index 27ff037..deebf7f 100644
>> --- a/cxl/lib/libcxl.c
>> +++ b/cxl/lib/libcxl.c
>> @@ -5046,3 +5046,86 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memde
>>  {
>>  	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_SET_ALERT_CONFIG);
>>  }
>> +
>> +CXL_EXPORT bool cxl_memdev_has_poison_injection(struct cxl_memdev *memdev)
>> +{
>> +	struct cxl_ctx *ctx = memdev->ctx;
>> +	size_t path_len, len;
>> +	bool exists = true;
>> +	char *path;
>> +	int rc;
>> +
>> +	if (!ctx->cxl_debugfs)
>> +		return false;
>> +
>> +	path_len = strlen(ctx->cxl_debugfs) + 100;
> 
> Same comment about PATH_MAX.

I'll change it (here and everywhere else).

> 
>> +	path = calloc(path_len, sizeof(char));
>> +	if (!path)
>> +		return false;
>> +
>> +	len = snprintf(path, path_len, "%s/%s/inject_poison", ctx->cxl_debugfs,
>> +		       cxl_memdev_get_devname(memdev));
>> +	if (len >= path_len) {
>> +		err(ctx, "%s: buffer too small\n",
>> +		    cxl_memdev_get_devname(memdev));
>> +		free(path);
>> +		return false;
> 
> I think I saw in an earlier patch that you were using goto to filter error exit point. So may as well make it consistent and do it here as well.

Sure, I'll update this and the function below. I already screwed up one of the return paths last revision so
it's probably warranted.
> 
>> +	}
>> +
>> +	rc = access(path, F_OK);
>> +	if (rc)
>> +		exists = false;
>> +
>> +	free(path);
>> +	return exists;
>> +}
>> +
>> +static int cxl_memdev_poison_action(struct cxl_memdev *memdev, size_t dpa,
>> +				    bool clear)
>> +{
>> +	struct cxl_ctx *ctx = memdev->ctx;
>> +	size_t path_len, len;
>> +	char addr[32];
>> +	char *path;
>> +	int rc;
>> +
>> +	if (!ctx->cxl_debugfs)
>> +		return -ENOENT;
>> +
>> +	path_len = strlen(ctx->cxl_debugfs) + 100;
> 
> same comment about path len
> 
>> +	path = calloc(path_len, sizeof(char));
>> +	if (!path)
>> +		return -ENOMEM;
>> +
>> +	len = snprintf(path, path_len, "%s/%s/%s", ctx->cxl_debugfs,
>> +		       cxl_memdev_get_devname(memdev),
>> +		       clear ? "clear_poison" : "inject_poison");
>> +	if (len >= path_len) {
>> +		err(ctx, "%s: buffer too small\n",
>> +		    cxl_memdev_get_devname(memdev));
>> +		free(path);
>> +		return -ENOMEM;
> 
> same comment about error paths
> 
> DJ
> 
>> +	}
>> +
>> +	len = snprintf(addr, sizeof(addr), "0x%lx\n", dpa);
>> +	if (len >= sizeof(addr)) {
>> +		err(ctx, "%s: buffer too small\n",
>> +		    cxl_memdev_get_devname(memdev));
>> +		free(path);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	rc = sysfs_write_attr(ctx, path, addr);
>> +	free(path);
>> +	return rc;
>> +}
>> +
>> +CXL_EXPORT int cxl_memdev_inject_poison(struct cxl_memdev *memdev, size_t addr)
>> +{
>> +	return cxl_memdev_poison_action(memdev, addr, false);
>> +}
>> +
>> +CXL_EXPORT int cxl_memdev_clear_poison(struct cxl_memdev *memdev, size_t addr)
>> +{
>> +	return cxl_memdev_poison_action(memdev, addr, true);
>> +}
>> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
>> index c683b83..c636edb 100644
>> --- a/cxl/lib/libcxl.sym
>> +++ b/cxl/lib/libcxl.sym
>> @@ -309,4 +309,7 @@ global:
>>  	cxl_protocol_error_get_num;
>>  	cxl_protocol_error_get_str;
>>  	cxl_dport_protocol_error_inject;
>> +	cxl_memdev_has_poison_injection;
>> +	cxl_memdev_inject_poison;
>> +	cxl_memdev_clear_poison;
>>  } LIBCXL_10;
>> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
>> index faef62e..4d035f0 100644
>> --- a/cxl/libcxl.h
>> +++ b/cxl/libcxl.h
>> @@ -105,6 +105,9 @@ int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf, size_t length,
>>  		size_t offset);
>>  int cxl_memdev_write_label(struct cxl_memdev *memdev, void *buf, size_t length,
>>  		size_t offset);
>> +bool cxl_memdev_has_poison_injection(struct cxl_memdev *memdev);
>> +int cxl_memdev_inject_poison(struct cxl_memdev *memdev, size_t dpa);
>> +int cxl_memdev_clear_poison(struct cxl_memdev *memdev, size_t dpa);
>>  struct cxl_cmd *cxl_cmd_new_get_fw_info(struct cxl_memdev *memdev);
>>  unsigned int cxl_cmd_fw_info_get_num_slots(struct cxl_cmd *cmd);
>>  unsigned int cxl_cmd_fw_info_get_active_slot(struct cxl_cmd *cmd);
> 

