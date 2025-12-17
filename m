Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010002.outbound.protection.outlook.com [52.101.85.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193F93D6F
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 21:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766007087; cv=fail; b=S9+5oa7PXJY6NrCqDjq0i2pehZlCSAt3R2SggBX6J133AFRLaFh7HBA7RyzZ/JvbWTOPUJv9NQsON0y71XUMtIK6RKXpgvc5ciZM0Neo57ayycoUS4Nw+Ww1CA8Hh6eK8KdaWZ0Ig0Jm9tq3FNgS42hHKCK1EJZ2jc1acXsc5tU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766007087; c=relaxed/simple;
	bh=bMDFDwhQfbm90wVAh5U3jTb95qyoZ453jd9bgzSOONw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=NDUpeeolIobDss9dPB7rX+P8Fw3l2eeJtXuLdkm+ZN3J85OmrCYKRFoJPYiEZTQdy1COTBT0FrRT7TyLWp0AiJcksiCTBQaT1qZS9m7a5L+RWsMRkwkKWuz/DPqQbH72pxneKYal8tcadO0yHbxQXfWGvVTQi10v+ulEP/WSf28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YGJvG7Yz; arc=fail smtp.client-ip=52.101.85.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YGJvG7Yz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iKJOlzuafxnNuwt/Ub4wQhrLoG19sHF89ONnyK48gQe/a/93VKsVrsUJNAtOq5ifCqSgdmjp4LMluHi5vbDFpaFYRhwzgZcBUTo2is4lZ36UsuDA5lVyjLhKWIQ25bdebasmBatAthZl+f4DF1LNG2si4xDLGSFkEYApL6Xgwe/5sGMz2BCLpirmcrLWlccLpDFI4X2HEMmdlBYrs3Sz6Wtry7n4qFfE7OPd0Ndsah2XB5EDabLMUUIjhVJdgTiJIVPCLWPwLnxEysDehyQ4B7lmRalDxDg3ToGvX8l9B0fqbKglDcWkhrquMRaPfx/c6r+3SQGUd3zqGh/QYqtQSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+rjBA62OJ3rcPE9R9vag5VouQfl2JwFkEZ5WRaYIS0=;
 b=es3HUsnEPkEJ1+55ZmuLE3WXyK+5hs5kRr/m2ySsqYowN0wO9UWUc8sKLoNLxVMutIAf5QT5CNm5bbV1z545DBpKBvbeRzu2M6G4oiJfEGuDIxPEAOg7PqjUsS09HDnlFoN4IFxtwRuivcOizOZn6/FjvzCElLVeScm/fWcjqtsGEQ1hilMV/Bf3g+gyJJe2yX3Eyo2LoHxyb4AxwX3o9b2FMRHIQyZI2zqKoZzfO0gAcRiNbq7mEIjs4cPirFc+1eAStI3ZjPq1gr1Om4yv0w19wzCCPJcd4F/ALiIJ4RN/wv8trXhL5X5sy5L3/QTx+q9x451FQpTK8oOthctuZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+rjBA62OJ3rcPE9R9vag5VouQfl2JwFkEZ5WRaYIS0=;
 b=YGJvG7YzvZbmIHFtv/7fxXCuY8ihkLA33uHAxArkirFKNHcXeMHO2tDWdzYqoa6D7NQApN5wYv7oZzaERFUHEs2NRpGYKwwENBYYtwPU5VpkEFnomaiAAx0aHV8yC4/6vKxT/JU9bC6+rdmNWt8e6u4YdKv4/m90m08TqGQ3zEM=
Received: from PH8P220CA0034.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:348::17)
 by DS0PR12MB7996.namprd12.prod.outlook.com (2603:10b6:8:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Wed, 17 Dec
 2025 19:56:22 +0000
Received: from SN1PEPF0002529F.namprd05.prod.outlook.com
 (2603:10b6:510:348:cafe::e7) by PH8P220CA0034.outlook.office365.com
 (2603:10b6:510:348::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.7 via Frontend Transport; Wed,
 17 Dec 2025 19:56:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002529F.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Wed, 17 Dec 2025 19:56:21 +0000
Received: from [10.236.188.135] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 17 Dec
 2025 13:56:15 -0600
Message-ID: <24dc9ebe-8b16-44b1-951d-db194b9bb80e@amd.com>
Date: Wed, 17 Dec 2025 13:56:14 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v5 5/7] cxl: Add clear-error command
To: Alison Schofield <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <20251215213630.8983-6-Benjamin.Cheatham@amd.com>
 <aUI0AEkt5BpNEq0T@aschofie-mobl2.lan>
Content-Language: en-US
In-Reply-To: <aUI0AEkt5BpNEq0T@aschofie-mobl2.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529F:EE_|DS0PR12MB7996:EE_
X-MS-Office365-Filtering-Correlation-Id: a809db9b-1798-42a8-a23d-08de3da65a18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?eURQeVNSV3lacjZSdldXdDhCWm1MM2R3UGlJdGJSL3lHdWRieTBpZDhKOTZR?=
 =?utf-8?B?bTZmZlhNTVZudFk0NDcrZ3VQK0xNRTFBb1h2UnRKZjJ3ZGpBcDlRcDJYT3dq?=
 =?utf-8?B?bENIb2RuUGRPSnlUY3h3NmoxZnltQ1JsK1kyYVhHY1M5NDFwU0p4SE9MZGxw?=
 =?utf-8?B?dThBTmg1UlFlN1NSN0hZUzN6dXJzN2JyV3JzMzAwQ1hoOWVYcEVkOEZRV3g4?=
 =?utf-8?B?Z1VnZDVOSjF5NzU2bEJ1STdqVUN4bWlrR1JMMjdObzRBMHFka2dKQzNIYnZn?=
 =?utf-8?B?Zy9GaWJxYzZ2eHRKeEJpOXEvZURkZUxlcmErMUZyQTMrRHBMeE9SZGNyOHRa?=
 =?utf-8?B?RzdCMmZMTlRydEcyR3hwdUFGWmVGREVRTC85MGxqNlVNb1k2Tm1Gd1NFTWhM?=
 =?utf-8?B?ejF4TDZmQ3UzMW9WdVRQamg5ZDE2YTZhQm94c1dZYW1TVXZlVzdtSDBKOUFI?=
 =?utf-8?B?OXk4TFJ5ODlYdy9MNmZOYTB1WmdacWtPalJkaUZEeU5JS0dUTWN0NE4ydzBq?=
 =?utf-8?B?cHlJNzVmSHZBOWJHZGR6bkVuMmkvM1BKMzNTSHdMUTVjK2JZL0d6RnRCYlF6?=
 =?utf-8?B?ZHltaUI1WGVDSU42OXp0SzZsbnFiNkNnL2o2QmgrSjB3d3pjcjNRbmJLb214?=
 =?utf-8?B?OXAxeGI4cFVkcWlLeXZBVThhUGMySFQyQVNObXhkbDVUUGdPam93d0cvYUhI?=
 =?utf-8?B?VFFsL1NlSEF1UHB0TmdIN3Z4eC9WclpnS1gwSlVMWlBoOXEwNkJRdlNFNmZ0?=
 =?utf-8?B?OWtRcjJNYzJwSCtSSkpLbm8rTUNGeXhaUExJQ3NaQ3RrVWNTYXZKOUMzSEhO?=
 =?utf-8?B?LzNPdlRuRHFmUUpEOHNmbkRndFJ3RUxkaWo0V3gza1I1dVZrcXFrMVgxVG5D?=
 =?utf-8?B?NTVLdHRteHB0S1BmcCtET0VVY1hyMUowUjNLam5Hd3I5c0dkcThWNC9lUVZQ?=
 =?utf-8?B?QlNBUGwxczZLOThaVENaOXJzSWw0OU1vejdDeFF6bTlaeWVheCtackx2ajN1?=
 =?utf-8?B?eW52cnNQaENZek9CZ0dFVWZacEw5VzZSMHdBYmZ0enRtRE5STjNNTnM5MDVI?=
 =?utf-8?B?bHh2QUdFQ1VWMy9lYTl6MkhoUlNVSEJjTDRYU0c1SEc3WnpnOE10eUZ0em9p?=
 =?utf-8?B?SklLV3crblgzeHBLdnJWTHJuWjg4OVhNeHdadHdIamZCNFEzalJzM1kwMGpR?=
 =?utf-8?B?bU5BRDNYblYxb3BzWWsvSnJEc0JlNFdvNEVUVTBkcUE5a2l2NEJDQmw2clg0?=
 =?utf-8?B?R1BKQUkxSG0zQkxLVHFRcWlpTDJvQ3Nadmh1clNHRGNKOVg1SEpZa3F4SkEw?=
 =?utf-8?B?MTVsa3liUWpEaWppYXJHYWhTK1BiRkJsazdNcXdLZmNvT2lYdWZITGljTFlK?=
 =?utf-8?B?M2VSa2ZjTmdZYkNTeTVGeERieW4yTE8wU2JTSzdJQUw4dDE3QUYvbFVqSnNR?=
 =?utf-8?B?cjR3Uk9WR2k4RGtOL0JkYk5BMFRycnkxeEJrT09VTXBrZzVwa1ZwMkNEbHYz?=
 =?utf-8?B?TDVSdEZaZ2psdzBTVHpIRnd6czdNalRWVVBUOTdiV2E4YjIwQURUQVVnbkNw?=
 =?utf-8?B?S016bWlEL2gvUHVLUkpnb3dTbURkTm9OWVpvZXRFS1hLMFRPdUlObmJPQ0pT?=
 =?utf-8?B?dkxsZjlBWjZtL3o5eGdFUnBuRGIxZStwUS9oUnFLVHlzbnNQRTI2Q0NXK0JF?=
 =?utf-8?B?ZTVSc1BmTnFZSUVHWXljTnRnK2tHWEhQT3FmVVZJb3BxdVJPR0Y5REF6ZVJ4?=
 =?utf-8?B?VTBWaUx6UmlvbFR5TTFKN1YwdSt2L2tuYWhDUmh3VlpNQmRXS1hKZ05zNDNQ?=
 =?utf-8?B?UWt3ODM3QSs1RmlCNi9LMGg0MGJGVUdZKzVLbmFSR3dXQ0J2djhZK1ZNekpL?=
 =?utf-8?B?WWFNS1VORk11OGdoZ1h2SkZmVzYrQUpKRmtFVGZjODNxWkZqcmFQTm9aaGpZ?=
 =?utf-8?B?a3JlcTNzYVVJY3lWNCtzNmUxYlJxMVBqMXNrTWF1U3RTd1cxeHlrVXRDOUpB?=
 =?utf-8?B?VVV5eWRYVFA1WkpaQXphSEthUmk3b3hJeHdNRGlxU2s3VWZiejlURmJCYXQ1?=
 =?utf-8?B?RS94NmhlRnZRUHVuT3p4Y3JlYlpmYXFENVV1WW9VczBqWXVFcUlCc3FqSE1x?=
 =?utf-8?Q?qHGo=3D?=
X-Forefront-Antispam-Report:
 CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 19:56:21.7921
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a809db9b-1798-42a8-a23d-08de3da65a18
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
 SN1PEPF0002529F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7996



On 12/16/2025 10:39 PM, Alison Schofield wrote:
> On Mon, Dec 15, 2025 at 03:36:28PM -0600, Ben Cheatham wrote:
> 
> snip
> 
>>  static int poison_action(struct cxl_ctx *ctx, const char *filter,
>> -			 const char *addr_str)
>> +			 const char *addr_str, bool clear)
>>  {
>>  	struct cxl_memdev *memdev;
>>  	size_t addr;
>> @@ -129,12 +142,18 @@ static int poison_action(struct cxl_ctx *ctx, const char *filter,
>>  		return -EINVAL;
>>  	}
>>  
>> -	rc = cxl_memdev_inject_poison(memdev, addr);
>> +	if (clear)
>> +		rc = cxl_memdev_clear_poison(memdev, addr);
>> +	else
>> +		rc = cxl_memdev_inject_poison(memdev, addr);
>> +
>>  	if (rc)
>> -		log_err(&iel, "failed to inject poison at %s:%s: %s\n",
>> +		log_err(&iel, "failed to %s %s:%s: %s\n",
>> +			clear ? "clear poison at" : "inject point at",
> 
> s/point/poison

Good catch, don't know how I did that :/.

> 
> snip
> 
>> +static int clear_action(int argc, const char **argv, struct cxl_ctx *ctx,
>> +			const struct option *options, const char *usage)
>> +{
>> +	const char * const u[] = {
>> +		usage,
>> +		NULL
>> +	};
>> +	int rc = -EINVAL;
>> +
>> +	log_init(&iel, "cxl clear-error", "CXL_CLEAR_LOG");
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
>> +
>> +	rc = poison_action(ctx, argv[0], clear_param.address, true);
>> +	if (rc) {
>> +		log_err(&iel, "Failed to inject poison into %s: %s\n",
> 
> s/inject/clear

Will fix.

> 
> 
>> +			argv[0], strerror(-rc));
>> +		return rc;
>> +	}
>> +
>> +	return rc;
>> +}
> 
> snip

