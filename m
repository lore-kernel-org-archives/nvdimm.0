Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013040.outbound.protection.outlook.com [40.107.201.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622E6378D85
	for <nvdimm@lists.linux.dev>; Mon, 12 Jan 2026 17:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768238414; cv=fail; b=sUsrpPKdMuF3Xd3yxOzP0QimVlzBCIMGD1YhxWPFZtHxHdAdy5YV+5h5XjQdve0Ckjqi58TWHwj94BX5vMRPgLANf0cu3Wn8WaV4S5JJ/ce5CIzIVVZCP53gkIJ7LVyo9nJHkb/h7DAetGtdl5MbErtiY2/XiOgL66T+DCEmVMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768238414; c=relaxed/simple;
	bh=ifmr0kLgSRna7PnF63Oxt0r92VgCP0UhA6m+S8/Z+fg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=MIMva6m8Gg3ch0DkRpdbQ/S4oJMyephThdsONJXwbJh170HtN6DCywv2s5+1mnkvAHoZ7PxMMX4q+StIdaHPvYMAG44oOaRO4bujB83tW+5593Hk9N4OR1zwu4UpM3NQ1XbtqBXF8wyUiG0wetefDU3EU0WSSSbCbPfqBzLOq94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rKCGNLiM; arc=fail smtp.client-ip=40.107.201.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rKCGNLiM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WWbcqScDpZyvkc86CVuI5eCFwiYiCecGvRNigpifMZr+02ZFvR1HVR32snEti1QdeGqpxerMjcyo7c7Jktf72vcdxcWU1Q5h/qt59PexaTLCgn9HpVkx5rCnZXVe3VF556yqZVg/HiyFlpL69m93VujjZsQPLtd01zPbwF+/ktE7WTWdSrd38oU/KLlpNvMRBdFP1/eBQmWpiqquMJ2Ybhf48jTeZshPeyYkkF5o7rgCtRMbyYxTtmO2nBt88Pf7n2eeAQfpyWXFD28aVWx0w2g/Dw9qnP3RH3qlOhsuHrwyRbvkY7bEiDpXbe2REKqkT5YvjGDEYL0/SHl+eTscDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LoyYytFDtXuiwN57TQCY4Db4vWQs+cMg6yZdMUGmyLU=;
 b=oI9pyH519Xz1w45kaWsefZcsKmdV4gct0hBEfc0fozmq9vhGMG2opMXmhC1Ko+Stdj56Keq9z6XfmCjhFLBKnZRZI5h6HurNVlLxlUfwdhoZbiYcsul+CILwjQjFktGOLxgGZMPvADxYWMjZij88JNYMAiO3LxvKNFLBYUj2Pb3uqEvZb6j4qn4c+a0DeFmSiyjIJ3gbmoHg0EW9P5o9+m2atJLMnW975pGjLSQnT0ywUoT8e7uyiaWFhLqqLxazxRSrbk5m+GEcNSvWV3kwBrCD8oDs3EEbx8vF6XKF0CGYtEzROgiaCY0ZKlo/YEYHdiOPOL5rZ0L7WFPt/gjOiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LoyYytFDtXuiwN57TQCY4Db4vWQs+cMg6yZdMUGmyLU=;
 b=rKCGNLiMH8YNItBv0FOkGg/s/h2aOEapGLd1piGiV1PcvCs3vumkYpXLgmipiNsAMsIdFHCUos2hfdtIxmuRRaYAib8ryrK8J9wQBnt/PYrhp4HfF820EiLFkADU21foQQhhcPzYSuQM2ampyAavPynNxDitrluDGhc6SNNnjrg=
Received: from BL0PR02CA0015.namprd02.prod.outlook.com (2603:10b6:207:3c::28)
 by SA0PR12MB7464.namprd12.prod.outlook.com (2603:10b6:806:24b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 17:20:07 +0000
Received: from BN3PEPF0000B071.namprd04.prod.outlook.com
 (2603:10b6:207:3c:cafe::b8) by BL0PR02CA0015.outlook.office365.com
 (2603:10b6:207:3c::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.7 via Frontend Transport; Mon,
 12 Jan 2026 17:20:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B071.mail.protection.outlook.com (10.167.243.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Mon, 12 Jan 2026 17:20:06 +0000
Received: from [10.236.181.95] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 12 Jan
 2026 11:20:06 -0600
Message-ID: <411cfbfd-c82d-480f-b2b1-1c4cc5b7b4ed@amd.com>
Date: Mon, 12 Jan 2026 11:20:05 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [PATCH 2/7] libcxl: Add CXL protocol errors
To: Dave Jiang <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<alison.schofield@intel.com>
CC: <linux-cxl@vger.kernel.org>
References: <20260109160720.1823-1-Benjamin.Cheatham@amd.com>
 <20260109160720.1823-3-Benjamin.Cheatham@amd.com>
 <c6f4f05b-b1b8-4b2b-b9d8-27be52b3e549@intel.com>
Content-Language: en-US
In-Reply-To: <c6f4f05b-b1b8-4b2b-b9d8-27be52b3e549@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B071:EE_|SA0PR12MB7464:EE_
X-MS-Office365-Filtering-Correlation-Id: dc0b12f9-3c40-4945-b42e-08de51fed4d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a21TK3J2NDhlV3JGaTlvcHFKbm95NVNCTkNHV0czcnR5dTBlRlBNd2g3WjJY?=
 =?utf-8?B?M0JNdDRLZlZUNG1EcVIzR2RhbkVGN1RpZWQyVXhpTTM4L25YMTVkRzZhbjFZ?=
 =?utf-8?B?NXdTekZ4czFSa29HQk8wMWxQNFh2WUJsOVhvdGZsUSt6M0h4TnlrTVo5eHZB?=
 =?utf-8?B?SHR6TGJDTzdoNnhkWjBnb3J0b2RMZi80TERSaFBVQnI1N0F1V0lieGQrWnN6?=
 =?utf-8?B?akFIT2Jwb1pqQ3JVbGs0OXJCQWh6Vk02YmFMNXhlV2FUSGZyZDduODhHOEUw?=
 =?utf-8?B?NWR5TkN0UkZ3TjZPcDBjbXlSbXRSY0paZWs2RW5jOHNaZEZaM3JiL3JJTmd2?=
 =?utf-8?B?ZzRtZjZIZXRrc0I4RjY3Tlgra2YybzMzRUlzM2tLTENuVVkvd0xsa0ptTWs0?=
 =?utf-8?B?cGVubkJJMHl6d1J1TW9mcmoyc25QUG9zZm4rZmtCZWlVRDljbmNzVnZFbnNV?=
 =?utf-8?B?R2NSbVphZVdnQzdTenprTnVKSm9tVk1NUjZENXU0SSt6MVk4OUpac3NISllW?=
 =?utf-8?B?OGJmYTBPSG5FcHYwTVJNQ1g4bnlNVnFwaVY3MDlRRHZobVhNZ0JnUHdBbWhv?=
 =?utf-8?B?bnZ6S1ZvS003Y2xnRUVhWURaL1lLQ3gzaWd5RTltVkk5OFFVbWd2ZmpTYy9k?=
 =?utf-8?B?MFNOU2M4UUd2ZGFONVVjaXRVbUYxOWxTNXVOdTRSU2NKeFRQUmRXZGdxb0tv?=
 =?utf-8?B?eWdUOGV1V3N1YUlOVllUVzZNMFhMazhCbnhZdkJWYzNpL2tpSXV2eld1aWlx?=
 =?utf-8?B?emNBTE5BYklqSjBjSU9EMTFhSXFHRFZJSVJzbTZUam1LNGxHMGRlNSttMTNm?=
 =?utf-8?B?Umt5T3ovYkFsMHNMYVhvZGlUcFlwN1pEeTdlOGtaRitDellOK0EzbjI3MHJq?=
 =?utf-8?B?ZWVlMEo2Z2FLTmpjTkVEK0NKa1JsdXVGeXhUWkJmWHNrYitWQndqRzB6OW81?=
 =?utf-8?B?d3Vqd3VRRklMakJoSVJjTEROUTZ6WkpSRWlPWUUxWTZwblZNcXJGSm9CMTFa?=
 =?utf-8?B?ZGpvbVBSbXlOcHY5bVVCMVdZOE5TdzFXSGJiSDlnVmZ1R21MbEZvSHA5RERr?=
 =?utf-8?B?a3FKaFhRZFZkYmNxa2t2TFVTbi9kM1NTcmxuZ3BoTXMxUDFYWlFVWGlKWklZ?=
 =?utf-8?B?UzM5QWR3VlhodG9NQk1yeWVLazBFMTQ5ZlNVMnNSRHdweGVCRVg5OVVVSmJ6?=
 =?utf-8?B?aXNkeXd1NjZuc3hhR21RbjlaSG5LMS85NU44K2ZlMWVqZjdQWFRaV2x2dXdx?=
 =?utf-8?B?RnRuSFg0U1NhalNrMEU5SEhraWx6ZjVpUEVIUklzanBGL3haa05KcGVKZmNs?=
 =?utf-8?B?UEdEWEk0NFFwVWpDTm5jTjZzbEZnMzB4RDF2ZGhYOHFLQU9HRVlMdkJIaUhY?=
 =?utf-8?B?YldQckpQVEtEaFI5cUNTUldNV09FRHdQOHE5eU44RitMU09NV0dpTTlzMjAx?=
 =?utf-8?B?SGVvU2xpR004UWlKTWNMbHJoT2xMRDNwUHF3Vi94VmVMRHlDaTZXeVRCc0lC?=
 =?utf-8?B?YTFtZEQrZ0tTWVpOWmZPRWRGb1d2SGJoNnJRcnN2VGlEQWFtVG5WWGtCaGZL?=
 =?utf-8?B?REVHLythelBnZTcxbG5sS2k4ZHhnMjV5Q1V1U1k2MS9XMjVGNEFXK1VITmpJ?=
 =?utf-8?B?RHk3dmtXbGJ3R080MzNSeXBRRFNEeG1XV29MaEtWLzBPR2tUWlNoNWsydE01?=
 =?utf-8?B?MGRMc1ltazVPQ21sRFRlZW9vWmdOQlhLV1V5UTRVT1dJRWRmQ0xDaFFiLzUx?=
 =?utf-8?B?VXh5TzIvUHVCWFVqL1MvcDNNYkRLbEZSd0EvOGFZdWRPOXJoOEkya0EzZm9v?=
 =?utf-8?B?d0QzOTRtclFmc1FpS3JQTStBeXJXMzlsY3Npd2hNZk1VSXJlY0lMb3NLdS9T?=
 =?utf-8?B?V1IxVjNwN2dMYUVBd1FVS08xb1JhUUdRTmIxQUdrWUdoVzNFQmxaL2dZUWNS?=
 =?utf-8?B?MVUraUtYNlpQS2pIOW9FekJENXR1a3RheXBaUzBCVFRGTVdNeFhCOHg3b1lT?=
 =?utf-8?B?dXp0alZEc0VvNFFyTlNDcllxWUlHL0VnT3E2N0VsQjVTMmNhc1RrRTRnSUJ4?=
 =?utf-8?B?djRkYitYWlFXbDlZU3JCVTBvN2t4QkVuM1Nac3Vrc3d4NFR2eE9qVWIvc1Bj?=
 =?utf-8?Q?vTRY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 17:20:06.6884
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc0b12f9-3c40-4945-b42e-08de51fed4d2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B071.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7464

Hey Dave, thanks for taking a look! Responses inline.

On 1/9/2026 11:54 AM, Dave Jiang wrote:
> 
> 
> On 1/9/26 9:07 AM, Ben Cheatham wrote:
>> The v6.11 Linux kernel adds CXL protocl (CXL.cache & CXL.mem) error
>> injection for platforms that implement the error types as according to
>> the v6.5+ ACPI specification. The interface for injecting these errors
>> are provided by the kernel under the CXL debugfs. The relevant files in
>> the interface are the einj_types file, which provides the available CXL
>> error types for injection, and the einj_inject file, which injects the
>> error into a CXL VH root port or CXL RCH downstream port.
>>
>> Add a library API to retrieve the CXL error types and inject them. This
>> API will be used in a later commit by the 'cxl-inject-error' and
>> 'cxl-list' commands.
>>
>> Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
> 
> Just a nit below. otherwise
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>

[snip]

>> +static void cxl_add_protocol_errors(struct cxl_ctx *ctx)
>> +{
>> +	struct cxl_protocol_error *perror;
>> +	char buf[SYSFS_ATTR_SIZE];
>> +	char *path, *num, *save;
>> +	size_t path_len, len;
>> +	unsigned long n;
>> +	int rc = 0;
>> +
>> +	if (!ctx->cxl_debugfs)
>> +		return;
>> +
>> +	path_len = strlen(ctx->cxl_debugfs) + 100;
>> +	path = calloc(1, path_len);
> 
> Maybe just use PATH_MAX from <linux/limits.h>.

Sounds good to me, I'll change it.
