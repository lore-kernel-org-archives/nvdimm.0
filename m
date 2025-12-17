Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011063.outbound.protection.outlook.com [52.101.62.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47715AD24
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 20:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766003299; cv=fail; b=YKc74ly/H/rmFeNjHwr4l+SnzbpSu/fxuSNxAy3OzHBz8RFp9pWBz7hJi3PlwWwwS3Y9y4WbltQbwtrUJk59NecZq3/98K+jhQM4n/2mCJ4kUFVrKA4/0zetVAnXCuQh+LLPs4zfdB6yX6HEBWMzFgd5Jmc6ZO8gud/0U1YUXbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766003299; c=relaxed/simple;
	bh=q754MVKcK45NnRohFc+olkxOLWU2FzwWtwE6to3Yde8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=IT834TGJ4zUC0K2pDdxh/O2VexQ6u8rnJVdocwupbjC3PWtNh1up5Jv0CHakjFJ2Kfp+z7Whb0TFj18bVPSsPAZZ7h5wxzoAS0YSGakA9DlARU4tTnvmOovKvbZhL8/9uLEIC17C2qqboAWIxfir7PM56JtZDWiQsuzObC1ruNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mwPe2qBA; arc=fail smtp.client-ip=52.101.62.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mwPe2qBA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P8xwfYxfacVG7XTlZeV/AAks5s1UNl622ouq3lbi+R3aDekoDCPaPuaOVlPevDK0P88yPqYdvCs0mtL8wOx3tPRvjAC45qnnF7U0MuOLqQKGih9QiiXVHMYoK2OjUZ7uqVWXWZusU8DfqYByn3H37tLDYyjjn1imcqIpjBxWUU29wzbOG/x6zCpnkTSkBFkuRxWfIewcvSioRSFs8A9ZpvAeaUVdiiRfFLzYttawCkDDlziRzDzpnMBYt4cN5x/4UWtd7EBx1Uxuyyi/nSnfhBY6xIAGidyMGyYanauG59OwaijNooVUd4wwAMHDFJffP5ZwumnDfES/TWrqNDRtqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=496aCxEe3UWZaRLJYOgk5u5BxEL5IeCb8GhI+45/8Vw=;
 b=fm/WbIOnLnGosu8mLndWNfBGAES+oiDmm027PEQYND/jqbQQO3EMLwTYd2tH1vBsfpgRGYF2GgQBjuksB3VYvrbofr8WRaDmBLZBPwiajV7utLdqu3MVxrr7zFvHeYpXtYYEB8eiIgAAhSyU5yYc/IssPGPhZm/B12NpEzWPczfAU+5MKsZu09UATxAPTAGr+dK8pjZbHyMM9L+9Y4KfRWc5wBdF5jXy9gUG7xxUaapF/Pds2GS80wg/zyDHFReA+WQAlg6+V2UD/nkJFWDO3/Hb2upV2nICovLzzn/6cQWf2Lp4XvQdJ1mCctsaVVRGsbnuf1EJ5QG7Y/b1GJBVJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=496aCxEe3UWZaRLJYOgk5u5BxEL5IeCb8GhI+45/8Vw=;
 b=mwPe2qBAKsOtZAa6J6PLS7gK/SKXa5oDegdePyxZ9VoeVZReYMBsoaPIBqTvZm9xTN4Y1/WTBXFz8kvklEB37a0ocUOnEkaJMu8WgtXElg4JooWFfe+XhPYPOFLJfJpzAU1LSgZbhl+e3ADVd9VAWVuOM4u3ZfwHdunHdEBI8J4=
Received: from SA9P221CA0013.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::18)
 by SJ2PR12MB9164.namprd12.prod.outlook.com (2603:10b6:a03:556::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Wed, 17 Dec
 2025 19:55:50 +0000
Received: from SN1PEPF000252A4.namprd05.prod.outlook.com
 (2603:10b6:806:25:cafe::70) by SA9P221CA0013.outlook.office365.com
 (2603:10b6:806:25::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Wed,
 17 Dec 2025 19:55:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000252A4.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Wed, 17 Dec 2025 19:55:45 +0000
Received: from [10.236.188.135] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 17 Dec
 2025 13:55:44 -0600
Message-ID: <c6b5bf72-116f-47cf-b442-1fe9903c689c@amd.com>
Date: Wed, 17 Dec 2025 13:55:44 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v5 1/7] libcxl: Add debugfs path to CXL context
To: Alison Schofield <alison.schofield@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
 <20251215213630.8983-2-Benjamin.Cheatham@amd.com>
 <aUIw5jxb0JHNubOD@aschofie-mobl2.lan>
Content-Language: en-US
In-Reply-To: <aUIw5jxb0JHNubOD@aschofie-mobl2.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A4:EE_|SJ2PR12MB9164:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e5a9b11-32e3-49b7-b6ef-08de3da64449
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?YjhnMWcrWVVEOWpnVXJOZnUzckdwK3ROYzZTaVdVNm5UeW5vOVpUYjdmMkVD?=
 =?utf-8?B?M05aTXVDWjRlYUpTd3ozeXpmTkdqYlpQaWxIODRNU3ovYldoa21qUktFRWht?=
 =?utf-8?B?S1FPc0Y0Ry9DcjJDY2pvdFJiY2N2OUs4SmdrMjlVc0NuUWZPYUF4QW9ydU51?=
 =?utf-8?B?a1hTZWFEQmVEUXI4UFdyM2IwNmR4c1YrTGdMZWlmenQ0Q1pxRXg2bHVaYXdM?=
 =?utf-8?B?Q2JjQmtJenFiY1hwckZqQmV6SVpHblQwNWU1Y3dpR05sVmFZN2JTMVpQUEVN?=
 =?utf-8?B?TVV3SzFkUHpPc2VYYTBwWVVHOGk2RENaTVBJTWl0a3lkQjJGT0ZUZmx6dEJx?=
 =?utf-8?B?T3VTR0g3MVZseGl1R1UxbVhDd2d3QXlyU0lmUVB4NjJDRTdORzNRMlVSY2Nr?=
 =?utf-8?B?RXlDdDRFRitxQ1p5ck9udXZSb0MxQkdrSUJ2VkgxOGMzVFdXVFBsaGJaMW54?=
 =?utf-8?B?dGQ0cFZSallRM211TmprVTlyQm83SUUzZm15V3JWOGxzRk1lczJIZjZWMnpn?=
 =?utf-8?B?WWhmWnhkZWhTUkV4VjlXcWw3bkpiUlJ1ZjRNKzV0ZitGRXVCbkU2dk5xanZw?=
 =?utf-8?B?ZUtubXFPR21wYmRiTVI2ZWhxOUw5M1htK2g5aFNCRjUrUTNMNDhvQkozcmpS?=
 =?utf-8?B?SXdzS1FUeG9uWFZBOFJYQkhEOGdySm15dkFLTC9ldE13ZzgydnU0MGZSbjZN?=
 =?utf-8?B?Y2lEUDBaMS9WeU04b1NWNVdyYUZubWJwUWZndk4xL3lldW5FWFVzOTZkT1Nj?=
 =?utf-8?B?SVJIZlN5Q3JLN3U0YkRUM3FOV0FmOFliRk9vcFpMMnNNRDFNYnh2c3FzaDZK?=
 =?utf-8?B?QWJ3YS9EZkVOU29HOWNWTzlwYm54alhlb1pRVGNsOW4vUHRkQXlXSDAxWGR3?=
 =?utf-8?B?Mzd4Y0I5NXRrZmsvV3pQcHl2Y1FFRlY0U1ZncU5MRTgvSXNyUktDNHlmZFNV?=
 =?utf-8?B?cWhQOVBOY1RRbXdGS2Q3RXNOZUN0Z3FweDY1bXdkOVNVbE1BZGFhWUR4ZmlF?=
 =?utf-8?B?ZDI1bG1OWHBZQmFiQUI1bGIwOFJQUTB6dXJQb3B1VEtXMTgzN0dWREF1QWtl?=
 =?utf-8?B?VDkyV012TVBFRnFpWWw4MDlaWmkvd2xmaUZjdnc0QW5JR0huenhwMzM0c0NI?=
 =?utf-8?B?NmxnQTVDaHZQRDZLcENCRVVTV2RXb1VCd2prZU1ZelQ0bk1CTjJEVzR1Nk1o?=
 =?utf-8?B?RlNNTERVYmNkNjJrbmY4VzNUbXBCMHRnL0dveU10bFh4VDJPQi9YS2RMTVVr?=
 =?utf-8?B?WU13WlBuU1NWTkpmTk90RVZ1aGlvM1NlOUUzT0VnN0l2bDJVR3g1NjVZR3Mz?=
 =?utf-8?B?WFliS3RPUkVOV3dKTzY0Y1lSS3dadkFjeWc4dm15RmpLb3J4Zjd2S2pPVENP?=
 =?utf-8?B?ZVdSdGRsNkFYV1BKa3NqYm5Za1BaNXU4U2hBc1RUamVuTHVOSDhpYUVjUW03?=
 =?utf-8?B?K3BVOUM1VUExVTlGMnJwUEx4d05zM1dQSG9oaE00T0ZOWXBmUyt0MkJCT25t?=
 =?utf-8?B?ZEJwclpqNEhTbHNFc2JQaERQVUpLM3ZqT2xuZ3pjUmdUWVFTdzZQanVOREZm?=
 =?utf-8?B?bms4RlgrczdBRURMU3lsK3pIMkxuMmpYMWc4Q0xPSk42eG1udWVJeitWTDlS?=
 =?utf-8?B?TXBTUi9yUmt6Q1ZnMExCZEkxT1JBd1BXWGkvUHJicml4TUxFVGdjeGJLUWxH?=
 =?utf-8?B?aWlLNWVTUnlmcGo2a2IvcWxZUy9YSFE3RXFQK3hJVUU0K2JXdFlkNFJ6Tmlm?=
 =?utf-8?B?WkpLTmpSN1BhOGJOT3kxL2o1RUI2M3VScklLTFh2aFpWTzI4Y2tpalFxMUhM?=
 =?utf-8?B?ZUk0ZEt1SWJUTmR2QVN1TWk0V1BxU3dyQkQ0alFkQWZhMUgzd2xvZ05CekRM?=
 =?utf-8?B?Z0tqQ1pjdERZQnNOaTQySkNhRzdIQkdtQVo4TGJNbkVmL3BSc0NsUjlibkVK?=
 =?utf-8?B?U1BmSldQT24zR1dBdG1MTVpWL3F6cXkxYW93T2pIK3UyY2RGNngvNlQxNEJD?=
 =?utf-8?B?bkhGZmVSbEFqbHpTL3hLRXVHeXZYVkE4YjRoOGdWTHN5T3p5ZTRQeWxaekM3?=
 =?utf-8?B?SXdXUlE3dGZGek52YWcwM3plZVhxZW0veEN3cDBuMStsa2Yyc25vQUl1NjV6?=
 =?utf-8?Q?kCYw=3D?=
X-Forefront-Antispam-Report:
 CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 19:55:45.2106
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e5a9b11-32e3-49b7-b6ef-08de3da64449
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
 SN1PEPF000252A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9164

On 12/16/2025 10:26 PM, Alison Schofield wrote:
> On Mon, Dec 15, 2025 at 03:36:24PM -0600, Ben Cheatham wrote:
>> Find the CXL debugfs mount point and add it to the CXL library context.
>> This will be used by poison and procotol error library functions to
>> access the information presented by the filesystem.
>>
>> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
>> ---
>>  cxl/lib/libcxl.c | 26 ++++++++++++++++++++++++++
>>  1 file changed, 26 insertions(+)
>>
>> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
>> index cafde1c..71eff6d 100644
>> --- a/cxl/lib/libcxl.c
>> +++ b/cxl/lib/libcxl.c
>> @@ -8,6 +8,7 @@
>>  #include <stdlib.h>
>>  #include <dirent.h>
>>  #include <unistd.h>
>> +#include <mntent.h>
>>  #include <sys/mman.h>
>>  #include <sys/stat.h>
>>  #include <sys/types.h>
>> @@ -54,6 +55,7 @@ struct cxl_ctx {
>>  	struct kmod_ctx *kmod_ctx;
>>  	struct daxctl_ctx *daxctl_ctx;
>>  	void *private_data;
>> +	const char *debugfs;
> 
> Do you want this const?  Later we alloc and eventually free it.

I would expect it to only be initialized once, so my initial instinct was to mark
it const. The actual value it points to isn't const though, so it doesn't make too much
sense. I'll drop it.
> 
> 
>>  };
>>  
>>  static void free_pmem(struct cxl_pmem *pmem)
>> @@ -240,6 +242,28 @@ CXL_EXPORT void *cxl_get_private_data(struct cxl_ctx *ctx)
>>  	return ctx->private_data;
>>  }
>>  
>> +static const char* get_debugfs_dir(void)
> 
> drop const above?

Yeah, I'll get rid of it.

> 
> 
> 
>> +{
>> +	char *debugfs_dir = NULL;
>> +	struct mntent *ent;
>> +	FILE *mntf;
>> +
>> +	mntf = setmntent("/proc/mounts", "r");
>> +	if (!mntf)
>> +		return NULL;
>> +
>> +	while ((ent = getmntent(mntf)) != NULL) {
>> +		if (!strcmp(ent->mnt_type, "debugfs")) {
> 
> include <string.h>

Sure.

> 
> 
>> +			debugfs_dir = calloc(strlen(ent->mnt_dir) + 1, 1);
>> +			strcpy(debugfs_dir, ent->mnt_dir);
> 
> perhaps -
>         debugfs_dir = strdup(ent->mnt_dir);
> 

I forgot about strdup() (I rarely do userspace C). I'll update it.

> 
> 
> 
>> +			break;
>> +		}
>> +	}
>> +
>> +	endmntent(mntf);
>> +	return debugfs_dir;
>> +}
> 
> snip
> 

