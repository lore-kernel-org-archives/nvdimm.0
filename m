Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012024.outbound.protection.outlook.com [52.101.43.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F91311C3D
	for <nvdimm@lists.linux.dev>; Fri, 20 Feb 2026 19:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771616120; cv=fail; b=ZDm5fcuiwA3+YiKPETYlfRwm60MEc1BLAc8JjTUQKW5TlOZGw06eHGU61e/MScfFqbI2X60wJsNPxAPQa8c7J2uxjzl3radj8x1Qvf/UPhwEW8vKpdslmPJvxddRyET32Ae/i0xHpBZhwjSE3f17z5jS6KRoq86y3zqb8DEcCKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771616120; c=relaxed/simple;
	bh=xkoWJsKl8OqSGA4kAFtfzVECuFik52m1khx8mBxsD8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=PEG/JlnrSGxDVDCXyCVxMYzJJKKRJdwhGDawJ4g1wlRjl2EGv/3MTBug0tw6VPkrxmS/9mAO36PORnsq2BhUrJoiKm34+MpG4/SYlpKk47I10ycHx6rXgaJ067EmnydZ8cxoAp6B4BYdLrn/rNotjFexMpHIvwi77BoUeHaJsRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xJPtsZZl; arc=fail smtp.client-ip=52.101.43.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xJPtsZZl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rRDbWTlT8INDT8t4mAkHN1oDNpldmLtrsxyP5XvL9zjwQts1bA65qfPBjF2y4DYxStpBnq7kJbkGvsqVcP8bwcwj6QKLZz2QkZu4RBaPVD02yTz5agxSna5paWT2DMmZ5XSXpMiCSYrMUMjiq+atGXrGo0CAFiANbN6dhZrmtPwCgOBNPxRutZWoZ/Xfj2CkCvcNXPmSEwjDSy8utbFmL9Nx6EkH4y5i3PmCRYuD9KmTAC0FmxFc3S7cVoTKZTvSkwrebC5TGiETiaHkhREiI4CwkGMlsUvFferVvycVmkdVV6LNN9p1EbFGvDfCJlpMckkm59PuXQw0lIfhO+/ufA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yd2QFIxRYmz+L0o0MgIYb8+2em3SSPK7+KEMTNHqPK0=;
 b=tbULLIKSZ4ceQxs+mLWPdQHnmsGujpLHueE8hp8CyGRaP/oUstEk9UcA9h8z0uuvpnlrUkp9ntj2GfhcjL2mSzZC4VwR4Sp7iwnzr+uIo2jYhlTnVMCW90zoMutJW86pFHPi+L7P+inysx8brDgmvKZWTkd1ksop6CarKeD99XrLFW7ys/mxGTCpjhGBe1fhNpQSb/LdFETFFmmMlv56CRPUnoTXnOF9VYzGVKFuCISju9pMx8/Dy7M1jVjuVhipDY5tFH+OO9yN7y8QgM9hhbQWo9BmToiHfYiqgyRQutUdP473+LyCRzV8YJSMRUFQdpQKjZELNCbFZ6NqgCWnVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=stgolabs.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yd2QFIxRYmz+L0o0MgIYb8+2em3SSPK7+KEMTNHqPK0=;
 b=xJPtsZZljkqxSTQb0EgAj2Md8JiIHjBeepwV7S3zGD0VB7UnJDPy5Y5KU7uP/hTAXsdVooI35TwNZyCkexX0Thj0M/gNfWKZUysDYeDI/2/nBzP1M9lMEvM9mFxcPU36zipXu9SMM1gG1o5+PtxYDOP9F8y5unLa3mpjOMOH0ro=
Received: from BN9PR03CA0315.namprd03.prod.outlook.com (2603:10b6:408:112::20)
 by SJ2PR12MB9242.namprd12.prod.outlook.com (2603:10b6:a03:56f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.16; Fri, 20 Feb
 2026 19:35:15 +0000
Received: from BN1PEPF00006000.namprd05.prod.outlook.com
 (2603:10b6:408:112:cafe::72) by BN9PR03CA0315.outlook.office365.com
 (2603:10b6:408:112::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.16 via Frontend Transport; Fri,
 20 Feb 2026 19:35:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN1PEPF00006000.mail.protection.outlook.com (10.167.243.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Fri, 20 Feb 2026 19:35:15 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 20 Feb
 2026 13:35:14 -0600
Received: from [10.236.185.70] (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 20 Feb
 2026 11:35:14 -0800
Message-ID: <88d3975b-e79a-4d0a-8ca9-a67d54cdfe14@amd.com>
Date: Fri, 20 Feb 2026 13:35:14 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dax/kmem: account for partial dis-contiguous resource
 upon removal
To: Davidlohr Bueso <dave@stgolabs.net>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>
References: <20260210224609.150112-1-dave@stgolabs.net>
Content-Language: en-US
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
In-Reply-To: <20260210224609.150112-1-dave@stgolabs.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006000:EE_|SJ2PR12MB9242:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b77df25-2523-4ca9-467a-08de70b72bf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VWV2UGdhVmN0VkowUjRvMGM0NGloK3RZcW1hTEhtMW5LZy9NWmxnWHorRnVL?=
 =?utf-8?B?NGd5ZkVIR0w4MDBabWRmK0diWU4rMTg4OU43RlhBaCtaQ3l1cnRtZitPdjVm?=
 =?utf-8?B?cFVrMjRkc3p4OVFGYzB5akpFcGNhZHo4N0NvQnVyejBBRmFxRzNxUTFJVXdl?=
 =?utf-8?B?Z1VwR1BnZG9MeElzOS95dXRCRVN3L09YeGV3eFJta3NJTHdNTzRMVXJuSllG?=
 =?utf-8?B?UkdVTEprbkQ1RWlyR3owSGRNUTVjMjZyV0pWRGJCQVRPR2M3MGdyUm5GcWlY?=
 =?utf-8?B?WnVzZ2gvYkdJZHUvVDJFUzBmc2loblZRVU1nN0E1STV1bnhaSnJvbGdZUnJE?=
 =?utf-8?B?aVBmWU05cnNBbWpoM0UrTDZQWXlHUEZzV3JyYm05emZvNTF2N094NE1hNkZp?=
 =?utf-8?B?VWo2TnFRNHZFbzVRcFR6VGQrQTVTUEQ5Z0FxRlFtWGk1OWhsc3VYYUFwaHNN?=
 =?utf-8?B?c1dDWWErSWV0dVhCNlZ6aUphbitlOVQ0T3hQZEpuZVplQm02L0wvQVZGZkVR?=
 =?utf-8?B?VHA3L2V4djFqWi9NY0d4bWRZTjdmUmM2ZmVsaStFdkplRk40YnJ3YkJweXRr?=
 =?utf-8?B?QythTTdXeUtMK3YyMEhBNzZ5TU9KVFV2RU0rN1lEcjBRVndEZUlLTi83aFo4?=
 =?utf-8?B?eDZsWTdiWmk4eVY1bThWWFNKRTR5SFNBRThaT3YxNE1PRnIxVG1UWlFObU53?=
 =?utf-8?B?Zk1QcnNOVjRJdzNyL0V1RVFUa1BudWw4bzNJMCtqL2g0UDFDK0luTzZSK3V3?=
 =?utf-8?B?UjZhN2YzOE5od3hSNmYyei9kZUREUkhkdktmSDFHdk9aZW1RajdMNWR4MitI?=
 =?utf-8?B?dld6MHJ5OTJjVlR3ZVBsOGJMZXBTenMvclZSZ0tNVllzYVBUQWdJWmZmd1kr?=
 =?utf-8?B?d0NZVy9YN1krMGlmNHRUWStvMCtHdm9iVlRRSXNoa1pzc2NLQjBtbWdiTi8w?=
 =?utf-8?B?TUY5eHRaYWVJdHV4OFdEVW9HZ1M2R0VKQWwwbysyb0F6U0dNRXRWc1NZZ1Rr?=
 =?utf-8?B?YURSQkE5Wk9UUmtRWWltaVgvdzlXTGhMUFZzdldSRXJlMGdxeWZjZkhnT1I3?=
 =?utf-8?B?TFR4SWtueXVZTWJ6YlkzajloM28xT2JFS0Y3OXRUZnNUSDlRNUk0S0hZZWt1?=
 =?utf-8?B?QjZlR3hnUGE0Z0s4V3pXaU9zU1Y3ZVZEOUNhYVgwUXlwR3JiSUNDdHJFQTgz?=
 =?utf-8?B?UE93blpXMzBSWVRFdlI1YjdsYjFxWE5XVXY0bzNCQVVzNkMzajB0end1RThP?=
 =?utf-8?B?Vm5YaVdqYlFoVTdpcWRYQmVlVnlhbkhUbkZSeElzSkk1M0J5cXRpWDhlYUdM?=
 =?utf-8?B?dDFuWDlRYlE4T1pDSVpDMWVNWnFLVEtHL1pqbklmQk5ld0loa3VScEFkcU5p?=
 =?utf-8?B?am5OejRJSElHWlpXbFFHb3VwaWZqdG5scVgzMFlCVUtLazUyUXV0NWFBN2xT?=
 =?utf-8?B?UVgrZnF3b2F3emcvMG9BY1poK0xiK3ZBUkNlL0lNbURTS1B1ci91UFIxNUto?=
 =?utf-8?B?MUJkQ1pjMy9UWUFwUVhiL2lTczVkbExDQ3M3ZmFOTVk1cDdKNDNyd0RZcFVC?=
 =?utf-8?B?Yy96ZlhIYm93Z1JUaDdueEFVT3oraUdJUzUzaGZ2dmVBdXJRMTV3cTdLTTF0?=
 =?utf-8?B?c2FLdWpXaXQ0UHVTOWJJMGtlOFRUeFVodjA4VFhKalVDMHZCZW4zZ3l6ZWQ1?=
 =?utf-8?B?SHRLMlBOa2o3S3ZFeUZqNWwyQWg5d1ErVDhOQ2tvREVJdVhKYlQ4amtNcmhW?=
 =?utf-8?B?d2JEL1IzS3lhR0liOWVnbzYybWVHdjM4a1dDeFk5ekZyb0lLeVZWWFVBRmwv?=
 =?utf-8?B?dklxaUlsUVI3TVVTMnE2djBmdnFFRnQ3V1NnaGx1K0VDdnFTTnlabWFOZElG?=
 =?utf-8?B?UThMblRkdk5kOXBmZDJpdWZxUFg1MGNzZk90ei82ME5DaTBhbjFnNFNDZS96?=
 =?utf-8?B?NzdjNSt1MmtKL2N1OVlNbFFUcHFEYmFVQXlnV0R0eGFmeHBUaGwvOVh6RjJ0?=
 =?utf-8?B?YVlTNFZFb1RPMlVobndJNm5HcERMMEsyS2VxZVZHUm1qM3R6dG5aK3AwYzRU?=
 =?utf-8?B?c2pZZWNtcElpMWt5Uy9KTWl2RzBYRnVDWCszSjJvT1ljcVh5Rk5wNWpuVG90?=
 =?utf-8?B?K052cStJQ1NmQUNyZU8zdlhVbHVTYnV0Q3llcDBxVHN4TWNoL3FIeldyN2Ex?=
 =?utf-8?B?a3VFN2liajhqa3cwL2RDdXJXT3p4VEFTUkpTai9GaVZ6akZqTDhLQ1Y0V1Jm?=
 =?utf-8?B?SUcvcEpWMVgxYmlpUU5VVklqSFZnPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hKIdHGk6xxFDbKq0wmafh3fJ2AaOayMdP6kuKugCIeFCgMwoJyZ8HSeWwA/2Hfu/05UlhQRep/d2bJ2h2ZGt32fJmKWcMHwmZIMIkJcgqeXFTZ7PGbnumjT2IrbP+j41mdtA+5lP6oyksSzdKU+E9X3dvB5xMfB1UmR9yohdMaOI4OWpsFKCFbuDr9QeCALY6ix1dkvOlEA39tHZSRW95M2jzXJK0DamOiDsZRJLExZ3xdaX51mqcsHoU8v2IwwzzdY0N+7KkV5vEmJjVdT+FCQ57mjrfX5+G4rvk5zIVDqoEy79ZZqaaO+8RV1rJIbtw4I63NkW81J+oBWMVdQbyUqutCl/zFF0GrbO4tn7w9Wmh7RAU8ch+yXXgugUouRnABnyaSL4xMgkH56LXKMLcR9/KcePwwpZ8M9hp+soRzZhc/0GT/G38tG8X5r4NG4X
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 19:35:15.1816
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b77df25-2523-4ca9-467a-08de70b72bf9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006000.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9242

On 2/10/2026 4:46 PM, Davidlohr Bueso wrote:
> When dev_dax_kmem_probe() partially succeeds (at least one range
> is mapped) but a subsequent range fails request_mem_region()
> or add_memory_driver_managed(), the probe silently continues,
> ultimately returning success.

I would mention the range resource gets NULL'ed out here. I think it would
make the below easier to follow.

> 
> However, dev_dax_kmem_remove() iterates care free on all ranges
> where that remove_memory() returns 0 for "never added memory";
> as walk_memory_blocks() will never see it in the memory_blocks
> xarray. So ultimately passing a nil pointer to remove_resource(),
> which can go boom.

Bit confusing imo. Maybe something like:

"dev_dax_kmem_remove() iterates over all dax_device ranges regardless of if the
underlying resource exists. When remove_memory() is called later it returns 0 because
the memory was never added which causes dev_dax_kmem_remove() to incorrectly assume the
(nonexistent) resource can be removed and attempts cleanup on a NULL pointer.

As for the actual fix:
Reviewed-by: Ben Cheatham <benjamin.cheatham@amd.com>

> 
> Fix this by skipping these ranges altogether, with the consideration
> that these are considered success, such that the cleanup is still
> reached when all actually-added ranges are successfully removed.
> 
> Fixes: 60e93dc097f7 ("device-dax: add dis-contiguous resource support")
> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
> ---
>  drivers/dax/kmem.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index c036e4d0b610..edd62e68ffb7 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -227,6 +227,12 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>  		if (rc)
>  			continue;
>  
> +		/* range was never added during probe */
> +		if (!data->res[i]) {
> +			success++;
> +			continue;
> +		}
> +
>  		rc = remove_memory(range.start, range_len(&range));
>  		if (rc == 0) {
>  			remove_resource(data->res[i]);

