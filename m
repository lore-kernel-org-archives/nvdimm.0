Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012066.outbound.protection.outlook.com [40.107.209.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5233A2367DC
	for <nvdimm@lists.linux.dev>; Thu, 23 Oct 2025 20:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761250518; cv=fail; b=uDSSwy0900x2rEH/0y+p/vWyThs/fw+LNGXKaqj20+GYJOaYNSzAktNdWeH60DFTstTrwa5WWMevaiOQDb0+QPnx7I/xv2IeeO65shr6/qxRvfykXR3JUM2X51hjKEg9Fa/gaCpA1wr6qpCjUaaenbc0r+hB4SlFea0g3C4ZtnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761250518; c=relaxed/simple;
	bh=zJqmCOfUOutUYxrTSLe/XpZQZWIcaP3b6eo3j+D+KPo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=KMflwLvHlCy8S6fb6OiMYbxcaRr6cWH4Uu73XvolbGymUtP/BIJDE7SYJJ2QgfUlOc76tKSDnfL5lvpIH4CQ8Y/3oSd1K512A+DqXuT9v9ZiaW+dIqX8AZDmhc47PkBR6tBZbSpeyon+aLT7+1WZaLOvH1qLW6WIMdjNDjLja4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=S75Bv93H; arc=fail smtp.client-ip=40.107.209.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="S75Bv93H"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BAlPtgBfRNmv9nXUflBlf2ROgrxqW3ZAZz4QgcqEzjc+Y1KdwgRnzwOee0Q/sxR1ZegFOTAln0T3e89zh6PLNHSn/QhgJSdEBCeU3QpKh98+cz500FaSVRa1MNGouYvBR7ykW3nmlCKE298cjYJwIXyFLDwtWNIZnamNywQ4Fs1Mtj7bKtffuL31te4+Cfg8oisXwOa2xVRPcDsCGeecquNXp9yfVYNoP4Vlmja4VqJ31OXNjfQyUxo1CJgCwZqdc8J7MdUk4XpYYkSsdrWVjEpMId5eHg1d1TckG3GtBjnHZteR5KEOJr73OVj/8BYvfchn+OPHk12AvhKAc92DkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NXXGvUm2R2biT6oFECAbBbnioYSZlkMvKuBAPEeeY10=;
 b=ijteUNdMY9PH/u59l5X0cbnSMyv1tkSeUL92fF1VQe/E+r5AnHYdqrjEuOWYVEGtqHPsvu+HRi3wk4IeqcoLQ1ZDeuLN88caahnjLeqDiWyf0VpKiXek8stnvB+m7K+ExCAr27hTYe/APdL2Yn8Of4CuUELisTiOctyeMF3oxrZJS860AUR2bYi+h6t2kSZ8dIRWtynG0Hw1JkC4Exu1pjzfeDFx0CIrllVE64w1jwW4sCowxDOTqAlOA1CCJE1GvWJ4UOaK/iljHM49gyCKJSifw59n8mYhFnmDV6AMsGjvRhf433mBIDaV+RwLIbi0vIYaO2pZ2lbYMrWx94X5WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXXGvUm2R2biT6oFECAbBbnioYSZlkMvKuBAPEeeY10=;
 b=S75Bv93HEKQLGDPmmzzovi+svLqCP7q3FJ86Qsq4TNqNK2hXwmknttVotaFjTStDKtxpXMMPBzTO5Ff37x321mi7QwLGdoQZkZCSrrW3ecSV66yoKhEub1zYs18gBXaacvec/+ogxdMADFVf8sPdseVd/svLyWvQCVAFTzBtcZg=
Received: from MW4PR03CA0284.namprd03.prod.outlook.com (2603:10b6:303:b5::19)
 by SA5PPFD911547FB.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8e4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 20:15:12 +0000
Received: from SJ1PEPF00002326.namprd03.prod.outlook.com
 (2603:10b6:303:b5:cafe::e1) by MW4PR03CA0284.outlook.office365.com
 (2603:10b6:303:b5::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.12 via Frontend Transport; Thu,
 23 Oct 2025 20:15:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002326.mail.protection.outlook.com (10.167.242.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Thu, 23 Oct 2025 20:15:11 +0000
Received: from [10.254.54.138] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 23 Oct
 2025 13:15:05 -0700
Message-ID: <b6d9fcba-3870-4944-ab07-a18279072820@amd.com>
Date: Thu, 23 Oct 2025 15:15:04 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [ndctl PATCH v3 1/7] libcxl: Add debugfs path to CXL context
To: Dave Jiang <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>
References: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
 <20251021183124.2311-2-Benjamin.Cheatham@amd.com>
 <fe8ab195-57bc-4569-bf0f-c8c2a93bc435@intel.com>
Content-Language: en-US
In-Reply-To: <fe8ab195-57bc-4569-bf0f-c8c2a93bc435@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002326:EE_|SA5PPFD911547FB:EE_
X-MS-Office365-Filtering-Correlation-Id: 313a0e56-bdb2-49fc-728d-08de1270ded3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QUQ3S3p3RW9GWVZReGlhUU1mV3JIVGwvR3VVUFRlUjJrbUpYSlhmUW8vOFhL?=
 =?utf-8?B?R1VROTlXSmw1cjV1THpFc0pOVWYvT3VvTGVqdjFvN0M1R1ZXQ1M3blpGeGJK?=
 =?utf-8?B?dlRIb3FScms3NThUTDhxL2s1cldBM3VYNDdUOTlKdzJlbE5HdnhmQW5ZWWFI?=
 =?utf-8?B?aXpxYzY0elVDalpQbjA2TXFzK0ovRzBrb2NTKy9uMlNBWnNZZHkvM1VMeFFH?=
 =?utf-8?B?bXdjNnVnNkQwWFMzOTF5NmQvWXJKYVgxbFFhVnFDNmxyU051bXdQZVg1ZHds?=
 =?utf-8?B?MHdYRU04V0tIc2ZBTUkzWmpwMjNHeDF2d1dMWmlCR2RkUEJTSnU2cTM3NTFj?=
 =?utf-8?B?OUdyYXhLU3pkbXFLYzhDOTBzUmxycjhlU3JSb09teFc5Mk1YWjhhK0E1bHZF?=
 =?utf-8?B?ZUpwSnlkdXhNY2ZVbksxV3RkU1pOTHVLV1BYN29vbU8zUk1reC9jRmFpVHdE?=
 =?utf-8?B?YVMwdjIwck9TdHBLVi9vKzJuZFA5QW9aODlmWWZnaERHZThVRjhQek03VXFx?=
 =?utf-8?B?L0N3aXdOVkRzU0MzTDB5TWo1bG9pQmlNQU05SmxiYktscHE0dU9RL1JrYk5N?=
 =?utf-8?B?MGpEcVNDTW0vYmZWaGluSlVZZEtFRWhaNjFoZ0p5OTluOVU2am5WeGQ5NzJB?=
 =?utf-8?B?TzV5UWQ3NUR5TFAyZDdyNjhWUWhhek9PeGxyaVNWSHBBYWNQSTI2VXMrR01i?=
 =?utf-8?B?a2dUNmRUTGxTZ3h6MXI2ZVdpemQvbUtPQWpySjAwaENTZEUydTJObm1Jb0lV?=
 =?utf-8?B?TzZRSkVXZjVmN0ZhbDZYU2Y2Vk94T3hNdVA5bE9mTkZMUmZSb05WaE5wTXBt?=
 =?utf-8?B?RFFaVTExZFlXRng3MTB5L0ZJeTdNWS9xTlVHSmpFZzk4NXV6RzNndVp2Wmtj?=
 =?utf-8?B?S0cwTWRUVUZ0ckFxODRnaXQzU2hOdkNIZWRLTGZEYjkrZnNJdVptYTJobTRR?=
 =?utf-8?B?REJYdXB1bUN4Q3NmUkt5bm5aMldsNVAyaUdhV0tOTDNmZEVnLzVUVjNFbjF0?=
 =?utf-8?B?MlNDdHFSOFNpd3RTN0JScldHcy9zYTVRbWtqS28rM2w3ZWhYenlxNEwxeGdH?=
 =?utf-8?B?c0FNeitWbklFT1NhVVdzUGN1NVVqTU91cEdzeFpHcjdSN3NuRmxDRUJ3VENU?=
 =?utf-8?B?WHRteHFIOGJtamVSb3NENVFwVmxTSTlMMUpqUFQzTklwRXhKV1pnT2VKWC9N?=
 =?utf-8?B?WTMrLzdnNVY1KytNNzFDVFB1RHptSkw2NXRKTzk1ajd4SHpVMkZ4RlZUZlZU?=
 =?utf-8?B?R0tmVWxqQlZYRHlqZ0tzMFBkM2ZBMzM4by8vNDRHeU5QUkx0aWVUWkZGVjVJ?=
 =?utf-8?B?ekQ2c0dVVjExVkZSTlJNbVRubUVhUkMzc1NWZ1UzZjlEd1BxYm10YXFaK1dM?=
 =?utf-8?B?bis0VXB6R1MxWC9lUlM5ZVk2dWRzK3lNWXU3cHdqenhYNHhtTzNXZHlpNXZs?=
 =?utf-8?B?b1cybWRpaFErQXgrbWVMc0FTQTNjdW05eGNxanR6TGRhdHVjaDF4VmdZRytG?=
 =?utf-8?B?ZURleE1ycVlpdVJ4c2tkSk0ydnJEY2VwMEwyWnFpWDlCMGVsZzJvOWFJNDBk?=
 =?utf-8?B?N01pNTAxWDZJbzFZRSsxREp1Zno3UFNKZFFWblFERmV1czB2TWJnTi8yZGs2?=
 =?utf-8?B?MTllL0g1VTRsRkhodmRiWHhCa3VieG5BdjRUV2hiVFIzY2xPcEVnVUlGT2V2?=
 =?utf-8?B?SEdDRWVhY1VxMXpCTzJaS3QybHpsWE51aHFEQWNVU0NPRWM0Mkc2dGg2bFdR?=
 =?utf-8?B?d3lnU3FXWDl3SFBZVHdHbGRjZkR6ODh3VnlMMGlESVFaUXYwa0xOaWpoMytQ?=
 =?utf-8?B?QXB2ZXQ3bXREMWcxcmhRbmQySnpkbk9Mc0ZrYW5LdHN6dGw2NUt5OEpEQzRs?=
 =?utf-8?B?aXgwQy91b3orMktYaWt5VjFpKzRoWjJSMm50NnZWSGE0emUxRzFBb2lDZjYy?=
 =?utf-8?B?ejdmakFFZDNaR0V3VURHTC9UaVc5K1dVb2txKzR4RUo2NzdzL1cxNTFrT2hR?=
 =?utf-8?B?eVVPMkFGOGFZQ3YyQXVpbnoyWVRRNG56dDBIa2FTL0hOK0hNYzhlaG1kUElj?=
 =?utf-8?B?VU5oa0VacWswcWRtQUNKQXRlbTdyUE0xeno5NkEya052YTVqM2ZVUFg2ZTZt?=
 =?utf-8?Q?MNw4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 20:15:11.5822
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 313a0e56-bdb2-49fc-728d-08de1270ded3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002326.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFD911547FB

Hi Dave, thanks for taking a look!

On 10/21/2025 5:55 PM, Dave Jiang wrote:
> 
> 
> On 10/21/25 11:31 AM, Ben Cheatham wrote:
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
>> index cafde1c..ea5831f 100644
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
>> +static char *get_debugfs_dir(void)
> 
> const char *?
> 

Will do

> 
> Also maybe get_debugfs_dir_path()
> 
>> +{
>> +	char *dev, *dir, *type, *ret = NULL;
> 
> 'debugfs_dir' rather than 'ret' would be clearer to read.
> 

Makes sense, I'll change it.
