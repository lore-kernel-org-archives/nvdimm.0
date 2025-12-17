Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011034.outbound.protection.outlook.com [52.101.52.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB5C1E505
	for <nvdimm@lists.linux.dev>; Thu, 18 Dec 2025 00:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766017717; cv=fail; b=aEWm7pdiwnQdJlrmqOIxSz7a/fD9g2eCqqqD85UkzMfoVVf38zvYqebgOyrZDd7ub7yKKmGUxu+mT2v7klEtP10DWfxsuszQFqSBD9eo6mC1xL9rTdsEHvnJKxuaQg6jcWHAja4HB9BuOMS4B+nEui6GVMUFJ8L5YzfmR50q9Cw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766017717; c=relaxed/simple;
	bh=mJWOeXqYwoJzcFlHev8WFhnmwRTuK31HXR42FFu7vfU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=ZYMqKlsNRwei+Ik/8ZdmdO5rCrQZaJX8lpu2J2JONa81wVh5+qfXTfu+DrPvw8JQFEgoxnDZ2xYvKOXl1Dj1pbBwYJwOzQiYKnQhGtJ1Uxgec53bgP/pwXnc+fz/a0CdZUi8HrgBu6T5idtCwlROftVVcIGs+emaxCiLKqqIuWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vs3QfO0+; arc=fail smtp.client-ip=52.101.52.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vs3QfO0+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eQa4mcoj+AVjljbyNM1G7TWEVyjZ6EdToD8DIWl8oxH7mKLhogERe1LCLbp3JWnfeZVEbwhGfehuoW89To8pc7oYaSd9iItSfm7qItC+nP8faTcGDx82nHd2MTwJZmipZuS3GL1XFwnrbUbK5jOruPambqMwxbtAOTO/ElrCwfhDj61kbNx1yHaGmRx4SlS8tfa95sXy2rSBZNuNKdrA9JbN2zKaVuRtH4BLjTMCRDWvvWAoLfhu+MI271q8d/+qVBu9acgBteVfiVIbu9qhk+wgXYqDjruyHvSfkZTngSykfnnOurNuPmlJVIeCm+2E5NS4qmeJn0EGnADCV+2auw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TrLj+drk1rFQobeOaG+qEnQjP6gru7H5U0gs4Ox2fng=;
 b=AecHo0yp0vXltuI7nozO2du+3RvxYbS1bTupCj0XIsrxfp05aBGlAg5jMmP7Vf3H0j+Aefbm7OAjzSBwXZdUZhCBKWQUqgRcK/UA/Zu5WVaoVCVeJTY54Yth7wMPM1aBOkgd2j3fGHSbpNWoL4x5cV6QHpjXIOUfABIPya/kllnz1r1XIfAdTwW/MUmMP7uoWfy6NyvcF64RsQs3dq7VLY7/I9wy854hhWr7tQlwdZI4nyvDy2J3eNbQGxkbUGTQ/qVUte1Z+58zfpLTWahFe6VBFlzmT8xTNKjWxWgLIMs0CLTLAZpt4B56iNG3wPWD6TEL4Z+UFEF26dyCsDTcAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TrLj+drk1rFQobeOaG+qEnQjP6gru7H5U0gs4Ox2fng=;
 b=vs3QfO0+DI7CfP64hRjDDITrGGKLGv9dlDZVp2E8Wf32o6KC8u9zTrAoAg5X/ICOmFMOXnfhpeetutlvYU65G6A5J4qqoUpzgGk46SNyyEm0e5W05s8B3GVIMF2JMtDGgHLnOzDRiy2KWSSsmOcB9bq2eF1MbwLnLqpYRGbpJ3g=
Received: from SA9P221CA0027.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::32)
 by MN2PR12MB4141.namprd12.prod.outlook.com (2603:10b6:208:1d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 19:55:52 +0000
Received: from SN1PEPF000252A4.namprd05.prod.outlook.com
 (2603:10b6:806:25:cafe::13) by SA9P221CA0027.outlook.office365.com
 (2603:10b6:806:25::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.7 via Frontend Transport; Wed,
 17 Dec 2025 19:55:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000252A4.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Wed, 17 Dec 2025 19:55:52 +0000
Received: from [10.236.188.135] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 17 Dec
 2025 13:55:51 -0600
Message-ID: <6a43d006-8d08-49cc-be1d-ab40a128a76a@amd.com>
Date: Wed, 17 Dec 2025 13:55:51 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v5 2/7] libcxl: Add CXL protocol errors
To: Alison Schofield <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <20251215213630.8983-3-Benjamin.Cheatham@amd.com>
 <aUIyF08ItHTBoZ7A@aschofie-mobl2.lan>
Content-Language: en-US
In-Reply-To: <aUIyF08ItHTBoZ7A@aschofie-mobl2.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A4:EE_|MN2PR12MB4141:EE_
X-MS-Office365-Filtering-Correlation-Id: 66809812-7af0-4250-efa1-08de3da64884
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?TnVWMzVhOUo5V3NubFdZVzJSdDZydmRYVUk4Nklib0s3dTVpTHdtRVQxME81?=
 =?utf-8?B?Yi9GTitIcWhwNFdrQ29XZkptSjhXWWQ4Ny9DMmFBd0ZzeWp6UVd5cGxhOGY2?=
 =?utf-8?B?amJMNEJpVVBTd0pYenJNLzdxdFUrOWVSbWZjUG40L2ovaktsWkRNcFJna1VB?=
 =?utf-8?B?aDloc0N1cnpOQWlDbVZyWWIxVldMZytYT2FscFBuWlhINDFobGR5cmQ1ME81?=
 =?utf-8?B?dWk3aGRGNlFra2RUTzQxb1NyZ3BROWgrREFlWTdOdjhRb3F0eGZMTU9QZDc3?=
 =?utf-8?B?STlxY2Q0d3cwQjhrK1ZrajY5Qjd6blVxSE9HR1ptU1AwcjdhUjlyUU9kUG5v?=
 =?utf-8?B?MFJaSlRVcDc0Z2gvbUtBamUzQ29KZ2t3clFDU3pvRWpmdXlodUJLZ0p5bE8v?=
 =?utf-8?B?UWQ2S0d4TWg3a3U1RTdKV2NRYXFhMnB2Q3ZJaUlrcHRMdmdOcUp6S0xHajFS?=
 =?utf-8?B?OUg3Yis3Uk94U21ST1hrdDVLR0JFcEdqSzh3cEpQZFJHc3NlYWJDdk1RME41?=
 =?utf-8?B?M3BxVG5YS0NUNTZ6QU9LRnhXR3o5Z2MxNDRuSWpZeTduSlREUXY5RE51Ym9R?=
 =?utf-8?B?M1c0RXBZUjcxUXdoNWRDQk1yVmxPbmFtOVdMZ0tYaW1sbldEWDZLOEp3T2FS?=
 =?utf-8?B?R3hSN1gzcEtCNG4rb1F2UGh6U051VVBHK1BoU3NScm1PU21icTFURmlObmxH?=
 =?utf-8?B?bkFNUUk1dXNsV1FEcHgwTm83Z0JQaktrVmJWMVllbDFTUjFraEt6dHRSYXVC?=
 =?utf-8?B?L3VJOUI0akxJcHUvckFrVnFidTVkVUdOS09pdGVlYWF1WW04M3JkMk9kNTVQ?=
 =?utf-8?B?MGRhMHpMUEZqTzNvRnNlTXd6ZnFEU3p0eXdIS1phODVtdThOQ1MwMUoxRVZK?=
 =?utf-8?B?Ynd4ZmxNejk2djVtK1oyV3BvZFU1Qk1YUkw0R0tOb3M0bW03anVmV1lPVkFQ?=
 =?utf-8?B?cExLMzFQSENUdmFYdTVnN3p3cHpva3BpN3RQVHQzYzVjbkxiRDZqM0d0YlA1?=
 =?utf-8?B?VS9hdTZFQ0xHbHlxcFFOYzl6eTJoWSticXM1RGlKT2ZNRVQxWlhBenVDczVQ?=
 =?utf-8?B?SGFpeWVvRmJtZjY5TFZ3elFYdDRYY0l5Z1RMeG91YnF2YzlzOWVkQmwvbUJz?=
 =?utf-8?B?OFlpZG45aHNnU1lnOW5QNHM3Z2xsbXZWY21lNGlyWGoyd09UeGNsSURCeUR5?=
 =?utf-8?B?Z2xqTGNaejdvNUN6cFlrK1Zrbk1kRXU0b3lnMURHdHVLNFl0ZFhYQUR6YnJN?=
 =?utf-8?B?S1I0cWJCTCtYV0QrNnhQWTZhcTFrUm94UlpPZU8rK0RMUkN5L3k2U0E5Z045?=
 =?utf-8?B?b1k5ME53UXdLWWNCb3ZUQzRhdGpBOVpQSExNQUdJdWtZMXFmSXVRa1RuN2RB?=
 =?utf-8?B?SG1yakt2TEpYTDRadm9rYVdyNXA4eEVMRlVoc29wSEpFZkp6UmNLeVkxeEly?=
 =?utf-8?B?MzB1U2w4enhoRjdOMkM0VFFDMFZadDdXWU5mWUlVUVRzNFRicFlDWXdpMVMy?=
 =?utf-8?B?SGZUMHJWbisyU3J4Q2xYbXpHL2JWVnV0M2UwL25VMCt2M3F5UkVNMEZ2MGZ0?=
 =?utf-8?B?cThVWEZQQWttR0NaRG5FMFJjUzBST1R3Q2g0ZWlOaDhXNVI3dkxDcU92Y05i?=
 =?utf-8?B?d2t1c3NmQlNla0JqWmxYUi9kUFFUL2xiOHI0ZUROVDVpaWtCSGQ5cUliano4?=
 =?utf-8?B?WkRWN2liaWFkUzlzV2R6c1FJbkdzMWtMbnpaU3lzYkVKdnF2YWZyQkdaQzFz?=
 =?utf-8?B?RFpYODMwUjhxWUdoeGxwbDlmbnIzQi9xYnh6MEtqSlhtMXhGaUdINWg4Ri9s?=
 =?utf-8?B?YlVXTXc0eFl1cGFCMnA4cURodFp1TlVUa1lDMWVBV2g2RHpRRzc0UHFDYWlN?=
 =?utf-8?B?Vkp5U2NZRlZXSkNJMlZzODJBVC9KMzhRZkhOWHFrVDBjMmxyRWdtemVHTVlI?=
 =?utf-8?B?ZDFxS0VUN3ZKWHRKczJVZW85dXFObGMvRGphM2s1YjliR2VwYk9OM09UWUt6?=
 =?utf-8?B?Tno4S1E3ckxnR3R4OHp2Mit2T2kxb0t2Nm4zTW9NZ1VPZkcrQkFsby9UaFB6?=
 =?utf-8?B?RU9CRmJncEwwb1VyU1V2c3FiK3h2a2drdnVvSi9hTEZFWTR2dFVQMFA3R2kv?=
 =?utf-8?Q?XxkM=3D?=
X-Forefront-Antispam-Report:
 CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 19:55:52.3024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66809812-7af0-4250-efa1-08de3da64884
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
 SN1PEPF000252A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4141

On 12/16/2025 10:31 PM, Alison Schofield wrote:
> On Mon, Dec 15, 2025 at 03:36:25PM -0600, Ben Cheatham wrote:
> 
> snip
> 
>> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
>> index e01a676..02d5119 100644
>> --- a/cxl/lib/libcxl.sym
>> +++ b/cxl/lib/libcxl.sym
>> @@ -299,4 +299,9 @@ global:
>>  LIBCXL_10 {
>>  global:
>>  	cxl_memdev_is_port_ancestor;
>> +	cxl_protocol_error_get_first;
>> +	cxl_protocol_error_get_next;
>> +	cxl_protocol_error_get_num;
>> +	cxl_protocol_error_get_str;
>> +	cxl_dport_protocol_error_inject;
>>  } LIBCXL_9;
> 
> Please rebase on pending [1] so this merges nicely. These new symbols will
> land in LIBCXL_11 with the new ELC symbol, all destined for the ndctl v84
> release.

Sorry about that. I'll rebase on pending for v6 (assuming v84 isn't out by then).
> 
> [1] https://github.com/pmem/ndctl/tree/pending
> 
> Thanks!
> 
> snip
> 
> 

