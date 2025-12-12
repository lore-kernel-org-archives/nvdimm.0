Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013060.outbound.protection.outlook.com [40.107.201.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459F723EA83
	for <nvdimm@lists.linux.dev>; Fri, 12 Dec 2025 16:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765555805; cv=fail; b=IDOdnfMR802z1jHfDpekmwWFJJB0iLJ0PPx9j6OZ8f4fsz8CLjOB6XNBhvdqZ3r5HmBshLvfv6GLcnXfpkn37AQDHWsZWMrSjUbcrMtUdEbRJW6FhggEkgPvRGt68LTJo1DiBwPFSHtSHjCrQpCoMFh6dvYoj+lqkOxyssWJnjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765555805; c=relaxed/simple;
	bh=BReOvI8UDlzMuqCD4r8DEskakXQM9/sCXeo2otkA6jM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=c/AcZwR977k81KSJdvayWZUFY6LoOWb2Dp6qZ0dBDTqmSAxR1cQViefVAF9bYGRoySAQR323u3gzEGZ304WepBShvamTS7DawPEVKfL4WBur5rnRVAgqNd8ItHVS8yPljk8tgOE2quiZ+wxRidbb13s+IV7k0EgO+6QWIeI7uR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kngIla2i; arc=fail smtp.client-ip=40.107.201.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kngIla2i"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VGryK258OH4Kb7Mx5zkkp7C9BDP84tMTtyvWZhgaHeCsT64ua1ntKA+bTYBG7DD7y1RSQjVmFWshVTC0T2lV19CP/8yFmccZQEJB/wfGbLlATsCiHPIt3P6RRExZ+2LfBKaYSqrYkm3jzPc5057A6mykprEsPdzPtahmur1xMV22+IWihWv4pSaPR699IhBNvT25YcvA7txHNJ8jSIzjX7Y+KC+dIYehOpyLTttVEd4IdnpYFmmQFVYHG8oGbZ463TD8KRLZOEwHIQ8eoiChjXHLeHhv/wefOPYDTqbcTuEaWe99J5A5bscJJn7O65cQ1DZ3SEosO+auhVivvF4ypg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WmxRhM1Ust07/9s+/sjRXb0CrFfBzgf1JHmnd3DoC0Y=;
 b=nkIJxfxjW0Gdz0JJAbf43/WuN0WPY/iefErJYrMe0T6Ts7cRwcaNnteKdEQPEoO7rynPieEdXeNCyIxWx/HCE0aHn3RwZCzeQAvSYIfeifoPsnPRryJBERCwbIYAVug/lAhXP+v4/CpQCo0g0V1xTEYF0PerpZjg91hEUxQUttfwegBGoKMzStS/SXiMR0s93ji8561RlAdt11xi+UaoqO6ZGzHxiLgISnfw//8YAOO5iwHwoOl6tcb8uPnS/cxz9Z7sW3rYFLzQxyxhl2Q5iMdWEWhBZjx0baZ7Cd71HcgTOwiEnEY3+s+E42kDmivEGxdyqlQBRDUfgXlYV4hT/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WmxRhM1Ust07/9s+/sjRXb0CrFfBzgf1JHmnd3DoC0Y=;
 b=kngIla2iCHSt5G1/5m6yzbOhNHgKpQOXeSJSgikGIhRWTPh9jdO+U3PppbKiDutcKyisfMHz6eLyiCvkPr48bt4JWehVLQNaDFs1+woO/9T5P+eJl3Qv+h0mdZW6i3yW45lGdNVR0esHBBZB7MksoQqn7/fAgGuFuymhU72H3kE=
Received: from CH0PR03CA0351.namprd03.prod.outlook.com (2603:10b6:610:11a::13)
 by MW3PR12MB4362.namprd12.prod.outlook.com (2603:10b6:303:5d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 16:09:58 +0000
Received: from CH2PEPF0000013D.namprd02.prod.outlook.com
 (2603:10b6:610:11a:cafe::4f) by CH0PR03CA0351.outlook.office365.com
 (2603:10b6:610:11a::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.16 via Frontend Transport; Fri,
 12 Dec 2025 16:09:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH2PEPF0000013D.mail.protection.outlook.com (10.167.244.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Fri, 12 Dec 2025 16:09:58 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 12 Dec
 2025 10:09:56 -0600
Received: from [10.254.59.95] (10.180.168.240) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 12 Dec
 2025 10:09:56 -0600
Message-ID: <91225c54-9f37-4145-9a26-eef673dd9a0c@amd.com>
Date: Fri, 12 Dec 2025 10:09:55 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/7] libcxl: Add debugfs path to CXL context
To: Dave Jiang <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>
References: <20251209171404.64412-1-Benjamin.Cheatham@amd.com>
 <20251209171404.64412-2-Benjamin.Cheatham@amd.com>
 <b7971d26-3108-4e31-9b7e-9b9d0e063012@intel.com>
Content-Language: en-US
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
In-Reply-To: <b7971d26-3108-4e31-9b7e-9b9d0e063012@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb10.amd.com
 (10.181.42.219)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013D:EE_|MW3PR12MB4362:EE_
X-MS-Office365-Filtering-Correlation-Id: e7c146e1-5da3-4aa5-e410-08de3998e583
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UkJ2QTJZcjkxdnVBdm9rQzhaNkVLaTR5N2ZYekFoMFprdEx6N1VYWjZwTVQw?=
 =?utf-8?B?d1ZoYi8wRHFBWnR1dFFvVjFBVDY0NEc2Z3hFZDJmTWczWjRKbk9naHhWVEFT?=
 =?utf-8?B?NGNTUHNWVkduOUtnTDNGSk1XUm1IcHZJMTlrTzRGbElKcEhETytJcHVRekdj?=
 =?utf-8?B?UVlWU0lCR3NOdnJqaUxmbXdnNzZMczVKWlNDY2twbmhOSURwRE1pL2ZGM0Q1?=
 =?utf-8?B?cHBIZFc1SHMxZUJJaUxnVExRTm1OQ2NVQkl1dEJReHVFbUlEdFZHSnJLSGdn?=
 =?utf-8?B?YzczdHBnaldEOGRzdC8zK1VwcVpnVHdZaytNVW0xd3Vsc2U4eldkcFZSMFdn?=
 =?utf-8?B?SWxzemxmMDVKMXpwZnN2dURwdTlmV3l2WTVYVzJYSkpIU1lMbWtwcXlpM1J3?=
 =?utf-8?B?dExLM3c2U0tuK2RYQzcvb3Btb20yTzFJekhMcTRHMlVlcGRETlZEQ0tEM1hw?=
 =?utf-8?B?azJsdUYxc3ZxZ2t5aGNMMit0bXQ5SzZNNk1CakxTUFByNzVKTHBaODllWTFa?=
 =?utf-8?B?QW10RitHQjBVcUFVQUdTdjhqaFkrV3lQdldsL0kzc01HMzVENlB1dXRxWWow?=
 =?utf-8?B?eHZOSjN2L2VORENRN0g3L1Q2QVRES050S09HbFhnbCt6anFTdHM5QnMzanl6?=
 =?utf-8?B?aHoxZVNhU0UwUnk1RDA3THVoZ0MwT3RORW4wWFJ0bEZkWTJqaEVUZ1lQVE83?=
 =?utf-8?B?MXdHdC9JMjV4VmpGeFA3UUNsYW83M2VkQnE5TW5OeVNaUko2RUQrVjc5Nlds?=
 =?utf-8?B?YWpqYU9GeDBRaXZIYzBnelFRcUs5R0tncnVSK2lBMzF6REpDL3kvOTBnZGhr?=
 =?utf-8?B?UUxCR3RlUi9Fc05Ea1F1RmpOa0hXcC9GSEdBNkJFenV6d0Y4RHJ0K1R3bE05?=
 =?utf-8?B?Z053UlROL1VpVVdkRjlBeGduTHl5bDhUS1VYNGdrL2NFVjZWMEpMSW95azV4?=
 =?utf-8?B?enk1clZ1bmdPNDEyK2JheGtEWFRxMEN3cFA5dlQ2Zll2UXN5Q0h5cEdsTzVV?=
 =?utf-8?B?c2ZzVDBhSzFNRmo2LytnNWRSVktYV3lFM3JzcmRqRDR1dFhoTkoyMG0wUGdu?=
 =?utf-8?B?VSt4R3JLVk90c25NVzRZN2ppUTJsZWZmS0cvOWJabC9qRktmOWJ3ZTlxanNH?=
 =?utf-8?B?dlZOZ2c0SlUvSXhYblk3K1lIazJPeTJLbjZDemkrWUxRZUZpUUFkNThrQmFC?=
 =?utf-8?B?bkdQQkhaT0IvcW90WjdCQVI2UjZXaDNUZ2pmMkRNd3FsZ1hPcmJJWVlRMUwy?=
 =?utf-8?B?bWE4T1kzcVNKbi9aQnM5VzdhLzM5aW5SaG0zVjFTTnhQT0xFekNmdTVtUm14?=
 =?utf-8?B?eXFkb0M2d2xMNlJDVytvbVEzakJvbUFiMmVPbUh3NzY3RTlVUjZYUzdPVmts?=
 =?utf-8?B?UWlKemdBREpOTjVjUklXTndtdWlxaDBsOW9LMm1jMEFNR0NYVWFDd1Y4Zjk1?=
 =?utf-8?B?VDNVVktWMXFOSVZxeDF0UXZaU2ZKbWZRL3ZrdXZwNHRKeWpuVld1Q1BpTmlZ?=
 =?utf-8?B?cjljdzA3QVFSVDBWdzR3WjBxTTVpZXIxWm04RWVOcHdZUjl4aTJ4MTlyZkRZ?=
 =?utf-8?B?a0NBWkIrcEFGSm44N0RvVDUwaXRlUkVVcE82bXA4d1NENk1DOUgvODFLOEVR?=
 =?utf-8?B?MDVQMzhMR1J1b2lnRVlnYjV4Und4OVVZb3JMREVOYVRuU0s2ankxY05xUnBo?=
 =?utf-8?B?Z3RqMytJY3VSYnlqV2ZQN2VOS0VYZkVKd1RDc05BZ0crUVhLN2FtSWx6M2s3?=
 =?utf-8?B?bExjWGFvZ21ONEdFcmZWMWpSZ0tsS1g1K2ZhY3FVa0RqVlNhQ29HbERESitB?=
 =?utf-8?B?Q0d3Ym93bkpKcmwrQnFHQlpRWG10eUJQZG1WMUs4bHJDdmZDRytSWVhHaHlP?=
 =?utf-8?B?MlN0UVM3UDJRR3NOWTlRdFY0TlNxSm9ISi9yWHBYZFBsMGFYZUZCMFo4VmFH?=
 =?utf-8?B?RGc3YUM1UmFqS21MNUwwczBmcXBGd0ZNeHJTSTVJdFpmZmQ2ZGpWb0Y0M2Rs?=
 =?utf-8?B?MU5wNDZQYmlUcEd1OGNnM1FvOHo0RWhJWkZxRU1JL0thdzdDYVM3ZnI5OGlT?=
 =?utf-8?B?VnpQUDJCNFozN1RrNlZpVjVjVTRnWDBwZmJaMlBuTkRyR0U1ZFRPb3dWSndr?=
 =?utf-8?Q?n7As=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 16:09:58.1095
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c146e1-5da3-4aa5-e410-08de3998e583
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4362

On 12/10/2025 12:19 PM, Dave Jiang wrote:
> 
> 
> On 12/9/25 10:13 AM, Ben Cheatham wrote:
>> Find the CXL debugfs mount point and add it to the CXL library context.
>> This will be used by poison and procotol error library functions to
>> access the information presented by the filesystem.
>>
>> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
>> ---
>>  cxl/lib/libcxl.c | 40 ++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 40 insertions(+)
>>
>> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
>> index cafde1c..3718b76 100644
>> --- a/cxl/lib/libcxl.c
>> +++ b/cxl/lib/libcxl.c
>> @@ -54,6 +54,7 @@ struct cxl_ctx {
>>  	struct kmod_ctx *kmod_ctx;
>>  	struct daxctl_ctx *daxctl_ctx;
>>  	void *private_data;
>> +	const char *debugfs;
>>  };
>>  
>>  static void free_pmem(struct cxl_pmem *pmem)
>> @@ -240,6 +241,43 @@ CXL_EXPORT void *cxl_get_private_data(struct cxl_ctx *ctx)
>>  	return ctx->private_data;
>>  }
>>  
>> +static const char *get_debugfs_dir(void)
> 
> I would suggest taking a look at setmntent()/getmntent() usages. Probably easier than trying to open code this and do it yourself here. You should be able to pass "/proc/mounts" to setmntent() and then do everything through a loop of getmntent().
> 

Yeah that seems easier. I'll take a look for v5.
