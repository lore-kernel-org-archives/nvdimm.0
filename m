Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013037.outbound.protection.outlook.com [40.107.201.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F24142E83
	for <nvdimm@lists.linux.dev>; Thu, 23 Oct 2025 20:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761250529; cv=fail; b=pJ1ID7BFoBfvmvJeRE6qU3LriEMrI5m4QWx8l9dw51c3kP/VcrUrtAZCUQmaH4Cwka1s6GEBFVuns8E7iT/LB0Hlhv/IQlzfZE21puYFuTat8bx7O3w+BIIG5rSfr2r5Y1oOc1Y4iX3LHsng9A6kWMc1c1Uz8zvjxcb8INltGx4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761250529; c=relaxed/simple;
	bh=bf601mGDLlWcOSJNl91z66WJ6dzPPHzT1vSMHovjNLw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=KfBE4ZDDlHSFoxJKW36c++4dV6NBGawJJfMRnAyn3w6GcGBI3X/Am9sPbs4PiCpnLGspGOiOP15HyRq7dbFbf8qTfE7Qa0PGUUAVzd/CkuHdTNSBoY7EDSfHOX2wA+3l4XW9lJjxys2GI0eHcGeLBV9zxC2gjPsq8zk8ryx4WMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CP+X4NsX; arc=fail smtp.client-ip=40.107.201.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CP+X4NsX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UnHPc64vwM/J1sXXPDmifFiP+98IVdBrQhh6OYcUZjjfXlHkQGmAN0xl4wdaKZ+IrU5TGl5/NR7/++CRVAB+m3O2avie4n9sLHNEvpGxZM39kD1p7Wv1EaR84UivcYB7isEqYH/R31voIYz8Xz6qvnmYERNHL/pW2Ggls3vOjsvFqbuQEjLr67ZdqiJygcCnr+KL9ccBnP0swgTF+ybXM8yfjEUFV+j66/EZjlq5H/eQr5urq6gZXd746pyVwYyQcYyxZDHJ3WYbv9nPWQNNuqDmW8gHFPxqfL3fdRtTyIgyIIa81JX+u5f7riAPYH6PgoU8taqpAGGe3RaBhBzx9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jnVj+y7YkjhMVuP3sUzuve8xNO1ocOqeh3lmffQsSjw=;
 b=dy655lyjMrv6wR6h0Zbw5Ym68/6jZT/ktG9ywQq+BbYN2SwhVk/kwQqbt0zeGBWOOlOFrgvRWYSxcir/H6k4XR4fc0GjkRzS3lGmAk44KzY/gc95urFWBac2YtsOBFvqEP6Q6aRgqyY/aJDdbmXbzFxZvbPY9taSltN2Tcz2EWhUEjBRT37E+BCgE1PQgXzaZTudFJTXd3nRcxiqNW2UB9Sue7pME431l/kVVj/FQXOSSlTPB7eEDavyiVoXlPIWRDWlLrNRrDpf6N6FhkG6HVzisEA7pzgTqx1DRQkN6KTe1s7gOaXZAPdrmwfVnWyAyfjU3x8JSINkbFUJLM6d8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnVj+y7YkjhMVuP3sUzuve8xNO1ocOqeh3lmffQsSjw=;
 b=CP+X4NsX565BB7wsc/hZv2KzQ8qEkuV32FZLKdAycgYJPUZsPUfVTN9Ccd67hAf/a49wdpxBrqmMidqv9SBNtzjI9Vcywz06Hb4CCM1Y48sP+/Wg71tnEp5vwVoGIQP4PaBgAURMNrz0/DLAPxQxWqwzuCD8LkDp1kk9XXgF9l8=
Received: from CH0PR03CA0006.namprd03.prod.outlook.com (2603:10b6:610:b0::11)
 by MW4PR12MB6974.namprd12.prod.outlook.com (2603:10b6:303:207::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 20:15:25 +0000
Received: from DS2PEPF00003441.namprd04.prod.outlook.com
 (2603:10b6:610:b0:cafe::a) by CH0PR03CA0006.outlook.office365.com
 (2603:10b6:610:b0::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.13 via Frontend Transport; Thu,
 23 Oct 2025 20:15:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF00003441.mail.protection.outlook.com (10.167.17.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Thu, 23 Oct 2025 20:15:24 +0000
Received: from [10.254.54.138] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 23 Oct
 2025 13:15:23 -0700
Message-ID: <997cb265-bb16-4aa8-91d5-ac245f85fe29@amd.com>
Date: Thu, 23 Oct 2025 15:15:22 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [ndctl PATCH v3 3/7] libcxl: Add poison injection support
To: Dave Jiang <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>
References: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
 <20251021183124.2311-4-Benjamin.Cheatham@amd.com>
 <4c452ff5-bcd3-4a3e-9fc1-04fb741f9e14@intel.com>
Content-Language: en-US
In-Reply-To: <4c452ff5-bcd3-4a3e-9fc1-04fb741f9e14@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003441:EE_|MW4PR12MB6974:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bd3aa99-e31c-406d-180f-08de1270e689
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T1NvbGxSRkdYelhzUFh4QlhiNVJBb1RtVWJmdFk0eDZJUFMrWi9ZMU1ZUGw3?=
 =?utf-8?B?eDFXL3ZwUXZ5eGN6aDRHSUNvaHl4OTU0MXVtZW90b3NPSVdEcU5tcWRxRnQ3?=
 =?utf-8?B?WGNKRmhaay93NGtYTDhJdExRbHo2VWFtenh6ajJtQ1B3bGQ2Nnp6RTNIa2Ux?=
 =?utf-8?B?QUFSRHRod2Z1UjV0VExjQVBTYWZNMG1LQkVzQnRsWUpYNzhCVjZzdFlKaVRP?=
 =?utf-8?B?R1NQLzJrMlVqbG14SnZqRmNqMTQxc2Z4dHNnbWl2aUFPSmNOT09sOEo5NE5F?=
 =?utf-8?B?OE9RZXVDV3NPZHVRUjVFOFZxQmQ0RUVYcnZveGorRFVXZzZobzJoenJKeXhH?=
 =?utf-8?B?aXZHbWlFWmhqK2pndzZBUDNYSU1UcHVNelRYeUlQaTVwT2swcXd4aExwVVM2?=
 =?utf-8?B?MzQ5dVhSSXNuRTl4LzBablA3ZmZVT1o4ZHJ5bGNqZERPZW5sVkl6S2tEUzZE?=
 =?utf-8?B?TTRZNm1SSG91UVYrNWpHMW1KbWdNWUpZZkR1VFNpd2hQU3pkUXNqbUlUcjVn?=
 =?utf-8?B?b21GN29KbGt2L01WVkI5SHcxaTFVTWFHRldhTmRQVDV3RlhpSmtvb1h2cFd1?=
 =?utf-8?B?N2kzRnE2Qld5RmV0aWl1bFA1WXZZMWhJVkI3WmNZclBiWCtxSWVOZ2lrUzdL?=
 =?utf-8?B?TGgvMUFZQjNaeEVteE9pQjAzS1dyVmZvK3c3bTNSSUJ6Y3JIOUplbjM2eXRN?=
 =?utf-8?B?WnFlelE0anRRdE5zeEc3aDZ1dWJ0dzErRk9TSVllNFhpandVVExDK0NaUVgv?=
 =?utf-8?B?Z3ZJV1p3d2t0NVdMa1B0ZERQOFlmbUtBVHR4MFh6ZkRqV080bHZRU2liQUFo?=
 =?utf-8?B?blUwSGlCaTliOWIvVWx1YzhNa29PWXdMdUFHZStPTTd6Nkh4cEgzVVhJNnZw?=
 =?utf-8?B?aFlxK0lTeE5rdnZkMC9HNmwzNDNNT0dhbjVhSVJVb2hwUWQ0QXI3eVpFZkdE?=
 =?utf-8?B?Q3V5T3pOdXFxWi9XV1pUVWU5RjFBT0gyRGhVM3g3c1BkRE5IMTNvSFJCdWtX?=
 =?utf-8?B?WGJRbGp4NXNaRmtIOGI1UUJFZEVtM29KNGttcllSLzE5MmE3bWVoQUR4WUVU?=
 =?utf-8?B?OXlyeDhjNFZFR3FPYm1BZXVQZDhXdW9xWkdxOUc3dTlnc084RVZyZlNVcGEy?=
 =?utf-8?B?UWJzdVdEMnIrcndNQ0E0YmpZcXJOYkEwRzJJbzhrb2ZOWHNQemI4T1FYZ0Mx?=
 =?utf-8?B?L3hOZXRrOGpXTllNZDY3ci9PalNSQkpmOGJmUS9yRXhCdElleFNYOWtuc0kx?=
 =?utf-8?B?M2dSYnFBMTdqTklJdWxsOUhqdHd6U0JVVmx1cW44bENaZ3FFZ1dQQStvSTMz?=
 =?utf-8?B?WmgxaXFQMHdIeUs1aWZpaGl2aElJSE1zdHRFc1ErVWZ2NjZOc3lOOWtPYjky?=
 =?utf-8?B?QzNQUHU1UjVSQ2kyRVA2d1g2KzF3U3BCcjNxTi81TEhQN0VsOHg0alkwL1Bm?=
 =?utf-8?B?dzZUVzEwa0FSZUZmRHFZblJwd0dLYnlBT2svazVYN1I0cTBNWGl4RzZBS0lo?=
 =?utf-8?B?aFFlNTM5VEFMQTNvQW9TODA1aXEybnMyclpnSzJOUytIWmtGS29zMzVOaTZF?=
 =?utf-8?B?czVlUEIyMG0zSEV6ZGhYQ2c5S1pRQUp6a3V4N3k3YlpEMmlFU29iY1MyMDZF?=
 =?utf-8?B?MWg2M3RZalZjVzZPQTFMQTVaYUw4VmxMMnNVU2NRZ1RFQlRIQ053aVdsWlF1?=
 =?utf-8?B?WjZHN0YxV1JLSkZqVG5FUzc0REUzSTJEeFZ6NHNOeGpWekR6Zkx3NGtPVHM3?=
 =?utf-8?B?a0tkeXhhRWJ5YlZuTW9xYlA1RWFydVg1RHBuZCtHUUhTeTdBMk9FQVorM3Fs?=
 =?utf-8?B?c1FnaWdkV1JEdzBrOUlYVzl2TVpuZTJVbnNlWFFEdENoaFhMZ0JIdWhYQVBR?=
 =?utf-8?B?V2xxVGc1djFQWUN5TVo5NDRRTmFreENvczR5UnJNbUlPVWQrOW54OTF5U0Z4?=
 =?utf-8?B?SDk1Wm9XZHpMY1U3bXZvS05IRHFqdkNHVEFOV3VuTWpJMnRWWkdtUjlPWlo0?=
 =?utf-8?B?bXdraGpUU2Y1WjJuRitoa2dBSWJjS0hjaEdJSEx5cjF5Y0sySldEOTJ0d1E1?=
 =?utf-8?B?SWpIQmtNaXo1TFdsMklkalU3NFZzRVhLeDdHOU9xaXlhNC9JU25aNmhYMGNv?=
 =?utf-8?Q?Xgjk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 20:15:24.5775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bd3aa99-e31c-406d-180f-08de1270e689
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003441.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6974

On 10/21/2025 6:44 PM, Dave Jiang wrote:
> 
> 
> On 10/21/25 11:31 AM, Ben Cheatham wrote:
>> Add a library API for clearing and injecting poison into a CXL memory
>> device through the CXL debugfs.
>>
>> This API will be used by the 'cxl-inject-error' and 'cxl-clear-error'
>> commands in later commits.
>>
>> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
>> ---
>>  cxl/lib/libcxl.c   | 60 ++++++++++++++++++++++++++++++++++++++++++++++
>>  cxl/lib/libcxl.sym |  3 +++
>>  cxl/libcxl.h       |  3 +++
>>  3 files changed, 66 insertions(+)
>>
>> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
>> index 9486b0f..9d4bd80 100644
>> --- a/cxl/lib/libcxl.c
>> +++ b/cxl/lib/libcxl.c
>> @@ -5019,3 +5019,63 @@ CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memde
>>  {
>>  	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_SET_ALERT_CONFIG);
>>  }
>> +
>> +CXL_EXPORT bool cxl_memdev_has_poison_injection(struct cxl_memdev *memdev)
>> +{
>> +	struct cxl_ctx *ctx = memdev->ctx;
>> +	size_t path_len;
>> +	bool exists;
>> +	char *path;
>> +
>> +	if (!ctx->debugfs)
>> +		return false;
>> +
>> +	path_len = strlen(ctx->debugfs) + 100;
>> +	path = calloc(path_len, sizeof(char));
>> +	if (!path)
>> +		return false;
>> +
>> +	snprintf(path, path_len, "%s/cxl/%s/inject_poison", ctx->debugfs,
>> +		 cxl_memdev_get_devname(memdev));
> 
> check return value
> 
>> +	exists = access(path, F_OK) == 0;
> 
> While this works, it is more readable this way:
> 
> 	exists = true;
> 	...
> 	rc = access(path, F_OK);
> 	if (rc)
> 		exists = false;> +

Ok, I'll change it.

>> +	free(path);
>> +	return exists;
>> +}
>> +
>> +static int cxl_memdev_poison_action(struct cxl_memdev *memdev, size_t dpa,
>> +				    bool clear)
>> +{
>> +	struct cxl_ctx *ctx = memdev->ctx;
>> +	size_t path_len;
>> +	char addr[32];
>> +	char *path;
>> +	int rc;
>> +
>> +	if (!ctx->debugfs)
>> +		return -ENOENT;
>> +
>> +	path_len = strlen(ctx->debugfs) + 100;
>> +	path = calloc(path_len, sizeof(char));
>> +	if (!path)
>> +		return -ENOMEM;
>> +
>> +	snprintf(path, path_len, "%s/cxl/%s/%s", ctx->debugfs,
>> +		 cxl_memdev_get_devname(memdev),
>> +		 clear ? "clear_poison" : "inject_poison");
>> +	snprintf(addr, 32, "0x%lx\n", dpa);
> 
> check return values for both snprintf()
> 

Will do!
