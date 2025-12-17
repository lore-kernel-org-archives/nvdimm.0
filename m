Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012047.outbound.protection.outlook.com [52.101.48.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1933A1E8B
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 23:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766014352; cv=fail; b=oNIlKwDyUTZ1uaRnrX+p2M6RSFoQ4EP4dn9Ju2YnrQCU5lg0dzqtguTjoW35EegG8HCT1c7aaei8Jrn5Bfh30xnj4uoJ7uxpLDJAew5o/A6O7SaylCbp7vPn96yDFYfKuoC9mlGU8Rk5WLVeIE19tRbEbGwSkDvXXffrbLScGnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766014352; c=relaxed/simple;
	bh=vOuDOxf9hiNWH+obP7CvCI0EQlOcf0N6EUcyE4hMxjo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=OfTaiVwo/iLRuBJ6lTBEDj7Q4SJfeQT0kb5anxFQRXNfDPtuzo9nVcgrv3G3bOEgHAnhKQXydycJwbWlRBhm6cbprsTEgszpfyrcnGgjhbQ5l0iuQQY4CmkfxoS2VvEMi4YGMJRkh6NiQUMMpCf1+nZIj9NiNYMOTRYCK327DyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=a/g0QOUg; arc=fail smtp.client-ip=52.101.48.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="a/g0QOUg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EFd/YGfvwB0DIBgCOimeUJiX6KBDtyf+FYlKS6X0h96b91jeLhJPkyrIN4TuzCyo3lro5Ks0GQl8BieIut6VXXbaZWxW3wndHrWqmdbRXXb1mZBo7hBHkFRH8ObbzkvXDq0t6ZSzrMLVJe2rwUrg5EIqhfuYXggYO0KFXKKH1eHPHy8HXHChGy+WnL7M38tbljFyjArE9Ezfm8aD2l7b+n+tHcJzTwxxJxVmbhQzDYa9FtShmpJE1EENhfY1larNnD3UHg/7QwQyQu3v1Gww5rX7Sr1EmVPmePo8vc9f/BngK3QPRd9Rj1EI370ftHE8FuG/OpOEakyiuSlqw1MIww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1I4+M+9cQgka7X/EhnpTLM45rNFfYbRCYsaKifDIzag=;
 b=Mzo/Z9Nroj6s/ItqnpYTR335T4bs8IXbHqfLq506GmBlucUYyj9Zt49NGhQYJ2J44UmrEhIT/ds4iCdv1mNpUCnncQllomHf9WVEaveFm40QQ+sSO49gVtFxvnsq8UDV/AFGAmyaVccAbzCoOoZR4e0cLcZ0h1Yzl4+KqrE8PkZlWegN9lpnMH/4jIv+ItKasI7ZC6Ufr542zQDUL0d6yk1aWPkLPAM55C3UVsK2ceplI8sYzB/P+etg5OKNBAJXYTps3+8OU9qjkYTKICWQkNisBA7Tv90oJgSPH6hfNrVZX4fE15dBIm0BnQ9zntuhPCyJ/vGgE73G7XKatNHPxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1I4+M+9cQgka7X/EhnpTLM45rNFfYbRCYsaKifDIzag=;
 b=a/g0QOUgiQTD0nwI5Ag91b/vHDk+4XCxQxhvCw2pjQM7ed0004SDEdM6P5BL1Gnvrd6+LbLXt0KupQgMfD7NSjO0q277sVjHjmFlU2hGVEoS3DEZO/LIePr70FLApivWeRJJdMqOFaHXrXKNDbjXtX904t44VRnkSvqca9pPPho=
Received: from PH8P220CA0036.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:348::16)
 by BL3PR12MB6619.namprd12.prod.outlook.com (2603:10b6:208:38e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 19:56:19 +0000
Received: from SN1PEPF0002529F.namprd05.prod.outlook.com
 (2603:10b6:510:348:cafe::53) by PH8P220CA0036.outlook.office365.com
 (2603:10b6:510:348::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.7 via Frontend Transport; Wed,
 17 Dec 2025 19:56:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002529F.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Wed, 17 Dec 2025 19:56:18 +0000
Received: from [10.236.188.135] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 17 Dec
 2025 13:56:07 -0600
Message-ID: <474e2821-7ab4-4092-9376-87f311fab25b@amd.com>
Date: Wed, 17 Dec 2025 13:56:02 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v5 4/7] cxl: Add inject-error command
To: Alison Schofield <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <20251215213630.8983-5-Benjamin.Cheatham@amd.com>
 <aUIzVWxpu_nHBKVo@aschofie-mobl2.lan>
Content-Language: en-US
In-Reply-To: <aUIzVWxpu_nHBKVo@aschofie-mobl2.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529F:EE_|BL3PR12MB6619:EE_
X-MS-Office365-Filtering-Correlation-Id: 1283fd77-d994-48bf-2def-08de3da6582e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?dlZMZ24xQzhSTnNiZWlHZDY3RUlGNjI0ak1EVzc3aVp3bnhOeDR4bzF3WlYx?=
 =?utf-8?B?ZHVFdFVlYVJKRTRPbDNpUlZlNHZ5VDkwaE14dVphWVh1dG5kMHZvMDVJMTR2?=
 =?utf-8?B?SjNhMEVKQSsyb2ZlYktmYkNqZm1LUHRxTGlmeFlYdCt4a3g0MHZxcHNBYnN4?=
 =?utf-8?B?WHVvaE41V1o0eG9LN0IydTcrMFBiV2xuYitncXZpOEF3KzUxQ29PL283QkQ2?=
 =?utf-8?B?TTJHbEZSdC9Cak9oYVgweFhERktzNDMvNzkyQVprZHhxQUZrTFFUYkl2bWRL?=
 =?utf-8?B?UDJ4NGcwSHgzL1I0cktmeE1JckU2ODcvL1dHZFVLUVZQb1cvN2Q2RzFhZHpQ?=
 =?utf-8?B?OWljZi9ySS9WZFRmZ3dpME5hMDJ0UlhhcXdSS0NOUkYzbGd0T0tnVHY5VlJX?=
 =?utf-8?B?eTRPR09lTmUwd2p6aHltQ1pRR3RTWHFWNjB4Z1lnU0Y2cDhKY2JtY2s1TWRj?=
 =?utf-8?B?VDhNYTk0NUorSklFSlZxMTQ1UGV1ZlNkR3ROdDRlT0tZQzQ2eEJ3TlJwbmZ2?=
 =?utf-8?B?L0V5dlZPS2pySXB3VlVabi9vWHprSTVlbUZOUlRCODNXNlE5STBSQ3lDWUht?=
 =?utf-8?B?WEIwVDFoRmc0a2JIdXNWaStHOVh0dVBlRGR5Y3BXSzVudC96VHpxalN2eURJ?=
 =?utf-8?B?dGhLR1l4Q1Jqa1FEcnphNlAwZ2cvNWFoenRxUkhTN1RhYldRajk0L0loZ0VL?=
 =?utf-8?B?Yy9raFlhQmNHZlppVDMzUVU0VE9uQW5Qc1NIc0c0SEttV3gyb2lHUkJXSjN6?=
 =?utf-8?B?NndreDI5KzJBbHYrRjNETVFHQ0VYVkVrRUsvK25yT0pyYXRuZmZGdHh2Y3hK?=
 =?utf-8?B?c083U1BwNGo0Z0hKdGFRMlZJTm8zSU1qcVE3UlZDVHY5cFpyejlUVWVscUVv?=
 =?utf-8?B?VG9qUlpreUxnbHZDeVQ4VXZYTnZnU1ZNRkxnSzN6ZW40UGQvTDZsZndSR0Fx?=
 =?utf-8?B?THRuQ0lwWURTKzRWODJBTUcvNFlLeThjWkNPR3dyT2p1eUp0L3JiNURhQzha?=
 =?utf-8?B?QkxjbzVJNjZCVzBwNysxeUF6UXByUWFhU2VGdnlKaTBHV1lkUGFDOWRqZlJq?=
 =?utf-8?B?TUdzRS9UOGNSSEkyVTlkYWV0bFJUcFBnWEsxVHhxdlQzc05zSlFoN1R2akRW?=
 =?utf-8?B?WGxkbktuRnNJQVpxMUpIcFF4SlVNS3JPcDA4MzN3d1BiYitXSmhmUklRRVZa?=
 =?utf-8?B?YzFCRWk5WXpRNlhBcENTbzVVZUNCSHFwNVNDQ01sQnZhbm9kUmtpUVFIS2Vm?=
 =?utf-8?B?N1BETHlCODFCYzFDaE01MC93eG5DWUJZNXZJMXA3RjVaZjhLcmZJVEdPbmhP?=
 =?utf-8?B?SGcyZXkzUUJkZjlGc1g3VDM2Rjl0bTdsSktPL01hVGVySmpwNkNWbS9iOEkz?=
 =?utf-8?B?ZHpyRzF2NkI0OTRWNStmeXJnaFhSRUdCeGNLeW5oWVJHUmswSitMeGdRVm56?=
 =?utf-8?B?L25jZE9oZzhtd3RlbjJWQVJHVC9iejU3RjhMV2xMSW1FZFRJeFE4cjcyM3pl?=
 =?utf-8?B?M0tPb1NpTHJ4OVRJeGlpaTFyVllLUW9xdndoOFVqaGhsbDB4Z0Nnb1h4RTJ0?=
 =?utf-8?B?OHhwR0dtMXZJZVlxdDhGQ1BnUzV1bVJ0WmViRDhZSmJsN1VlTHpMSTFrbEZL?=
 =?utf-8?B?QmduWS9CbGcvcnRrRk9Icnpwc1U0ZGxKT2IvZG8zOUJsbTZINkNBWFcvWktF?=
 =?utf-8?B?YWFrWFVLLy8wRHYyb2RBUkhKWlJqNmtid1BYMjI4dS9yZWwvekFxK0JudW41?=
 =?utf-8?B?M2Eyb2JSVm0vYkowb2FWQnBCMndNeW9iMzNieC9ad0MvK1RZUW9heVVSNVBK?=
 =?utf-8?B?QjRXTDZ2ZmRkc3ljV0F2bHl3VVVXb0Y3UGRJbEFzd1E1ZDV1OVlnMFNjM1NM?=
 =?utf-8?B?ZnFMaXlLMlZDbWFKMUdLdC9RallQUDNMTmhMOE5ZeUFFOUkxVUpFUm5hWEpX?=
 =?utf-8?B?bWhGZm9hVkhsLzBJYnhrNWhrbDA1ZmFvRHRIQzVZaTFmN24wRGcrWm9taEF1?=
 =?utf-8?B?Q1Rlc3c2aVpVUGFkc2NRcmt0YU9iSFFaOTN3a1JNOGZKMnBTS3I0eTNaUmFx?=
 =?utf-8?B?YVVacDcvWEdzR0NJODhVV2VDWG9lWEUydGNXdnJhbXNoM3VmWG90aFNTV0I3?=
 =?utf-8?Q?TnLc=3D?=
X-Forefront-Antispam-Report:
 CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 19:56:18.5812
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1283fd77-d994-48bf-2def-08de3da6582e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
 SN1PEPF0002529F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6619

On 12/16/2025 10:36 PM, Alison Schofield wrote:
> On Mon, Dec 15, 2025 at 03:36:27PM -0600, Ben Cheatham wrote:
>> Add the 'cxl-inject-error' command. This command will provide CXL
>> protocol error injection for CXL VH root ports and CXL RCH downstream
>> ports, as well as poison injection for CXL memory devices.
>>
>> Add util_cxl_dport_filter() to find downstream ports by either dport id
>> or device name.
> 
> Does above comment match code? Does util_cxl_dport_filter() match by
> 'id' or 'name' ?

It should just be 'name'; I forgot to update the commit message from v4.

> 
> 
> snip
> 
>> +#define EINJ_TYPES_BUF_SIZE 512
> 
> above appears unused

It is, I replaced it with SYSFS_ATTR_SIZE IIRC. I'll remove it.

> 
> 
> snip
> 
>> +static int poison_action(struct cxl_ctx *ctx, const char *filter,
>> +			 const char *addr_str)
>> +{
>> +	struct cxl_memdev *memdev;
>> +	size_t addr;
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
>> +	addr = strtoull(addr_str, NULL, 0);
>> +	if (addr == ULLONG_MAX && errno == ERANGE) {
>> +		log_err(&iel, "invalid address %s", addr_str);
>> +		return -EINVAL;
>> +	}
> 
> errno best set to 0 before strtoull
> there is a type mismatch btw addr of size_t and strtoull

Got it, I'll fix those.

> 
> snip
> 
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
>> +	if (argc != 1) {
>> +		usage_with_options(u, options);
>> +		return rc;
>> +	}
> 
> The above catches bad syntax like this where I omit type:
> # cxl inject-error mem10 -t -a 0x0
> 
> We also need to catch this where I omit the option altogether:
> # cxl inject-error mem10  -a 0x0
> Segmentation fault (core dumped)

Good point. I'll change it to catch omitted required options as well.

> 
>> +
>> +	if (strcmp(inj_param.type, "poison") == 0) {
>> +		rc = poison_action(ctx, argv[0], inj_param.address);
>> +		return rc;
>> +	}
> 
> snip
> 

