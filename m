Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010011.outbound.protection.outlook.com [52.101.201.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE1B378D8D
	for <nvdimm@lists.linux.dev>; Mon, 12 Jan 2026 17:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768238429; cv=fail; b=t3cpUULFhTjhiFtLhRb6jq4TXVKQF1PtRJFaL5k1+NwDeaorEDReYGh3rqdvJG+wlf8kSopSsi6yem//IL+JfMHGEW0oRKAovmv1UR9DwTj+HBbWfrAXm606doahUf7UIVK8g1e0ZKZFh3TXhZMTMJmdbkDKomzJsnvmnug0rkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768238429; c=relaxed/simple;
	bh=KOcHFKvd2BE/n7Xxfpjrbo8I0ouKyklY3Fudp6wTaqI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=QXWhE1mefBv1/nXcZ1X4L/YbuW1VLCrpfhqjqL8gE3HGND7Q/AOy1rgKt6z/pl9m8xMohT+rmiuvBP/suzM+w8sFFpWZHmHmJryt8E1qj8oEbKTPdznYgmqQE/ySHIRsJwqOPWjA+aBsq/gWhxHOniAXtiBWRoSoRM8ZuyLTk0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mx0TJon4; arc=fail smtp.client-ip=52.101.201.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mx0TJon4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=szVme+MC/NCrw45p4UCW/xcNxfoCKEe8wz+/PcKj/lGld1Wtu5eN+MTL3XrqazReXVHFi+5fHE/yKU/HE0PWuhKxxtExnQPpxti0rZIyK3ouzwsCZgIKEtCPPkCUs/v+iGV8NXvv41uADuOqopp5BjYVBCRo0DDSbAieLGbwaqp8D9NlhtKVe4mPhecszIdxMn7xpWiIyu2uS1Xe4LkXXRj2RzS3MuvM6aUXkTpNRCHQUXi6kk7x5+4KHPVzilGZN5NTmvlfTNBbgqYfJoPWlfTZ/AaqYZ9g8tXbtPrITENwR9Cl0wUN4FBdR0JBxSAHoi+o6R2zAU0mJV4bB7M51g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AvuPOa8g1hew++/dtXj6SSgbaNyLgXUzbsZVUHUPMC8=;
 b=Eb3dgmmGoxhnNTnY8PzgOJ8Or01KOkkN22frasNXlrU+1TE8y8d2CBZ+OXf5ItAj3weQ4e1d/Wbl26KJKopNNs35NhNDh8DpubCKiQJ7qYoJooPVP0Z1IznYhwakNYgkdK/0EjOH0B5lcrHCvfxcmrvQIK0WdHDKgWNVAJBPzbfsgMqOyjBtvYIH2XCXqCCbCA8t7NsZOgnH3zb6HozHLHquHRth5tz1IEHMNdgYbij6Fz+DAMrDlHA7MBnE7zfPv63G2QlMkaBFpElr3YMpLapPeNgaEC1nArrVllEa8PWx8ZTETkWy+U2qzvZbt64ptYPWc1Lb4YyPUVmBRk/ABA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvuPOa8g1hew++/dtXj6SSgbaNyLgXUzbsZVUHUPMC8=;
 b=mx0TJon4g2AM8//xn2YovQqNT/NbsAHlo/idRf0uqx8uqTsPAXmQkzV+YIYAgXPYOqRwfPdonqWTz3z9uc4EztwHxiTwlh3Tp3h9FzAV0bgQqcLkB/7LkCWji/TEoz5DMkzBu9jcWFHfGF9GX9dg/urpEVbup9Fw7l9goaeM+pc=
Received: from BLAP220CA0010.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:32c::15)
 by DS0PR12MB8248.namprd12.prod.outlook.com (2603:10b6:8:f3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 17:20:25 +0000
Received: from BN3PEPF0000B073.namprd04.prod.outlook.com
 (2603:10b6:208:32c:cafe::38) by BLAP220CA0010.outlook.office365.com
 (2603:10b6:208:32c::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.7 via Frontend Transport; Mon,
 12 Jan 2026 17:20:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B073.mail.protection.outlook.com (10.167.243.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Mon, 12 Jan 2026 17:20:24 +0000
Received: from [10.236.181.95] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 12 Jan
 2026 11:20:23 -0600
Message-ID: <fe68340f-783d-47c7-a931-d469a32f003b@amd.com>
Date: Mon, 12 Jan 2026 11:20:23 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [PATCH 4/7] cxl: Add inject-error command
To: Dave Jiang <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<alison.schofield@intel.com>
CC: <linux-cxl@vger.kernel.org>
References: <20260109160720.1823-1-Benjamin.Cheatham@amd.com>
 <20260109160720.1823-5-Benjamin.Cheatham@amd.com>
 <1160bfba-eb39-4b77-b7ed-8409009f42e1@intel.com>
Content-Language: en-US
In-Reply-To: <1160bfba-eb39-4b77-b7ed-8409009f42e1@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B073:EE_|DS0PR12MB8248:EE_
X-MS-Office365-Filtering-Correlation-Id: 63453271-726b-4217-ba50-08de51fedf8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZnI3L0RsU09OUXY4SE9FR05RVGNDa0dkTEpoRUQ5UVVRK1JxSUhmQ2lvTlRi?=
 =?utf-8?B?dCtvSjBBa0FzWkJCdGh0V3ZFZDk0MmpPaWxuYWdKSWhpcHBCdFU4bWFnajgv?=
 =?utf-8?B?dmovVTJtRGtIbk9yeTY0bnE1T3lmdEsrZVlPNUM5MzhmdnF0U2hua2V3TTlZ?=
 =?utf-8?B?UHlMZTBqdmNzNk8rZWZ2NlZtWitzWkJDcFRCTzFCOXFvcm9wcXBJS2xnOFo4?=
 =?utf-8?B?dG9MVUhSV1NCcVNVODZXeDNSY3BJT3YvWjh6RzZzaFVHWitUTFNoRjkwTXVo?=
 =?utf-8?B?T2RIQjE4MUdnZS8xME50eGM2K21JeEVRdHVEZFpXeU9TTkRuOTk0dFg4RUFR?=
 =?utf-8?B?ekgxckF5KzlIaXlsTzJkVHVKUGdPNzlGdDB3d1pCS25ZQUFsVldDeDJ6dFF6?=
 =?utf-8?B?VG03WmgxbGhjWHdoTmY5cTFRVFdjeWRUSUxxK0ZSZ280cVRwNnBNNVM2UTVG?=
 =?utf-8?B?Um45M0xEYTFTVHhvQ1JYNWs0cC9GWmlSR2Z2WmtDV1VYaGhYUXgrL2hGUjMr?=
 =?utf-8?B?UkJUTExKVzVJV0JPdlBjMytublRRbXFOOGJ6dWxnSkR1UFhsRm4zTENOTDla?=
 =?utf-8?B?WlIrMVVFejZyREQydXE3RGtNc052dlYyNEltY3hHcjVOR2hHRG9YNUdBNlJQ?=
 =?utf-8?B?Zm81em9RcUtRTE1JSDc1dDd4Qmh6VjBqbk1rdEcycjVZREFENkZBT1Nmdmhs?=
 =?utf-8?B?V2c3Uk90NjE2ZWoyTDJoYTNLaSthUFRFVE5JNlhMNzV4OVVOa2dVQ3o5UGM3?=
 =?utf-8?B?Y3B1STFjd0JwQmdrTUhOQ2FsRUtqdFZ0eWdrc0ZPbGVINlVZY292MklVd3ha?=
 =?utf-8?B?SFg3RjhCSEhOUHNOWWp0M04xRE01RzZTeEwvMUpuUzZqY01RRGgvcDJsM3gr?=
 =?utf-8?B?TVoxRlgydjJpQmNhOEFWVzd1SFdIMDZhVkQ0SmQzM1g0MG5UcVUvYkw2NWpu?=
 =?utf-8?B?TXlyUjJoY01nZkVxak5jdnYxTi81cm8vNkJYa3ZOblRTWTduek1nZit3UjdY?=
 =?utf-8?B?TFlCbk9zdVpJMDh0cVlIWDRxR2lZK013SHVrNk9yaDk3YVBuTDNaTUtTTFdY?=
 =?utf-8?B?cTd1RUNQTWFIeHVQOXJXS09LUFUvU3FPOXBDakFHMzdCbXl1SEFheXh6Vk9T?=
 =?utf-8?B?QnhBM2wxRW5FaVVJZGtQY3ZsbjJVa1pPR2lQOForQkpaQ0VRcVcrTjJETlVx?=
 =?utf-8?B?VUJZb1JxSy9EdUlTZTAvNXRmbENocXFqQWZucXVIaXgxN0JSYzBNRTZQRG00?=
 =?utf-8?B?T2UrVUlDTHAzNVNXdFNFSWRMT1YxWXdhaW5JSy9kQ1hPZEl1T3RvTytuSXVz?=
 =?utf-8?B?ZHNQQVRVVkN3UC9nVEhIemZ0RkhKT1d4R3B6b2FvRDZqM3BHc0VXcVhjeGRP?=
 =?utf-8?B?OXhxUWdyWUVMUDZkaGFEVGVaOWNkeUJnMWtaWkdJbmpGdVduVGFJVjBCQjlK?=
 =?utf-8?B?cUpzVk05S3FNUmI3SzVFSlBMbm1pYlk4R29pYmR0SFBVYUR0NTFXM09WcXUz?=
 =?utf-8?B?ZE5TN2pId09PNEh0ZG11blJBK1BrbW5TRVdhNlViQlQ1enhLY1JvL29SQmh6?=
 =?utf-8?B?TlcxMkYrSkdpRTRwK3B1UEFBT0N5YllBMnRmcDRnWHJpU1ZHZEk2TFdnZzZG?=
 =?utf-8?B?RVhGRU9WQ3pubU9OR1VISGsvRmE3NCtoNmlXbTQwZVp3Y3NVMXU2Z09JMU5I?=
 =?utf-8?B?MXppTUREWWY3N0lkOXZIcTc5d0pMTWhTZFRxamZkNzRuay8rZUt2Y3A0a3BO?=
 =?utf-8?B?bG1IbnZiK3VKOXQzb0RNZW50Qmh6MkJRM1MrY0pHa2g5Vmc5Z0lVa0o1bjFp?=
 =?utf-8?B?dTFRWnBCMU5KSmFldytRNGl3YldGbEUrNjRKbktEaTI5NTRxOTYyeWxMT2gz?=
 =?utf-8?B?WGtrajBmSUJSL2lPNW9FQVVVejU3Qk8yeEFUR0lKS3AxbmltVUlBYWN4eTlU?=
 =?utf-8?B?VngwQjZNVFpINEpza3RCeHpyTmNQNzJnNCtWdFlYcVRNRDZ5Z3IyYnZScjNM?=
 =?utf-8?B?NWhlWEJuYXQ5c1UwQWl6b3ZhbkpBYzZaWUpaRWhBK1ZVQTdKQ1RrdzZsVTY2?=
 =?utf-8?B?OTFRaEFhTit0NlNFZkQ2bk9CMDdYVThqYUFpZG5TYjlwK3E2S0VFRm1tbEVL?=
 =?utf-8?Q?uvAM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 17:20:24.6842
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63453271-726b-4217-ba50-08de51fedf8c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B073.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8248

On 1/9/2026 3:53 PM, Dave Jiang wrote:
> 
> 
> On 1/9/26 9:07 AM, Ben Cheatham wrote:
>> Add the 'cxl-inject-error' command. This command will provide CXL
>> protocol error injection for CXL VH root ports and CXL RCH downstream
>> ports, as well as poison injection for CXL memory devices.
>>
>> Add util_cxl_dport_filter() to find downstream ports by device name.
>>
>> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
>> ---

[snip]

>> +
>> +static int poison_action(struct cxl_ctx *ctx, const char *filter,
>> +			 const char *addr_str)
>> +{
>> +	struct cxl_memdev *memdev;
>> +	unsigned long long addr;
>> +	int rc;
>> +
>> +	memdev = find_cxl_memdev(ctx, filter);
>> +	if (!memdev)
>> +		return -ENODEV;
>> +
>> +	if (!cxl_memdev_has_poison_injection(memdev)) {
>> +		log_err(&iel, "%s does not support error injection\n",
>> +			cxl_memdev_get_devname(memdev));
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (!addr_str) {
>> +		log_err(&iel, "no address provided\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	errno = 0;
> 
> Why does errno needs to be set here?

Alison suggested it last revision. It's been a while so my memory is a bit hazy,
but I think strtoull() doesn't reset errno and checking it below could cause a problem
if it was set to ERANGE by a previous function.

> 
>> +	addr = strtoull(addr_str, NULL, 0);
>> +	if (addr == ULLONG_MAX && errno == ERANGE) {
>> +		log_err(&iel, "invalid address %s", addr_str);
>> +		return -EINVAL;
>> +	}
>> +
>> +	rc = cxl_memdev_inject_poison(memdev, addr);
>> +	if (rc)
>> +		log_err(&iel, "failed to inject poison at %s:%s: %s\n",
>> +			cxl_memdev_get_devname(memdev), addr_str, strerror(-rc));
> 
> We don't error if poison fails to inject?

It does? The return code of cxl_memdev_inject_poison() is returned below, the only
thing that this if statement does is pick which message is emitted.

Thanks,
Ben

> 
> DJ
> 
>> +	else
>> +		log_info(&iel, "poison injected at %s:%s\n",
>> +			 cxl_memdev_get_devname(memdev), addr_str);
>> +
>> +	return rc;
>> +}
>> +
>> +static int inject_action(int argc, const char **argv, struct cxl_ctx *ctx,
>> +			 const struct option *options, const char *usage)
>> +{
>> +	struct cxl_protocol_error *perr;
>> +	const char * const u[] = {
>> +		usage,
>> +		NULL
>> +	};
>> +	int rc = -EINVAL;
>> +
>> +	log_init(&iel, "cxl inject-error", "CXL_INJECT_LOG");
>> +	argc = parse_options(argc, argv, options, u, 0);
>> +
>> +	if (debug) {
>> +		cxl_set_log_priority(ctx, LOG_DEBUG);
>> +		iel.log_priority = LOG_DEBUG;
>> +	} else {
>> +		iel.log_priority = LOG_INFO;
>> +	}
>> +
>> +	if (argc != 1 || inj_param.type == NULL) {
>> +		usage_with_options(u, options);
>> +		return rc;
>> +	}
>> +
>> +	if (strcmp(inj_param.type, "poison") == 0) {
>> +		rc = poison_action(ctx, argv[0], inj_param.address);
>> +		return rc;
>> +	}
>> +
>> +	perr = find_cxl_proto_err(ctx, inj_param.type);
>> +	if (perr) {
>> +		rc = inject_proto_err(ctx, argv[0], perr);
>> +		if (rc)
>> +			log_err(&iel, "Failed to inject error: %d\n", rc);
>> +	}
>> +
>> +	return rc;
>> +}
>> +
>> +int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx)
>> +{
>> +	int rc = inject_action(argc, argv, ctx, inject_options,
>> +			       "inject-error <device> -t <type> [<options>]");
>> +
>> +	return rc ? EXIT_FAILURE : EXIT_SUCCESS;
>> +}
>> diff --git a/cxl/meson.build b/cxl/meson.build
>> index b9924ae..92031b5 100644
>> --- a/cxl/meson.build
>> +++ b/cxl/meson.build
>> @@ -7,6 +7,7 @@ cxl_src = [
>>    'memdev.c',
>>    'json.c',
>>    'filter.c',
>> +  'inject-error.c',
>>    '../daxctl/json.c',
>>    '../daxctl/filter.c',
>>  ]
> 

