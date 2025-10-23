Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011042.outbound.protection.outlook.com [52.101.62.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEA31411DE
	for <nvdimm@lists.linux.dev>; Thu, 23 Oct 2025 20:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761250528; cv=fail; b=Jw5vpOlBOaAwkROctFYKAEb5MuvQGEtfCd2+jsdicswvxP0JuTgMms6dwTJ4eFMmLxmx8ZbY2x6y4h078Ih1waiFg8EkQ9TgG/05TPWEHSZzjfMq7SWkpG45l1DRutKVmPJ+XrNwqYaUZ/ndo33g/2u4gXUSJYq0Mw4ZpZJdbdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761250528; c=relaxed/simple;
	bh=A0Z6zb9M3XyaQuCmZQx+MtFAAXfaW80qGK9IwMifHyA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=ZPazHF6hPYU83SfpL2S+VhRhZYFrNjUB5law7xe3U5X43oqgKfY2SSFHJBcz59AYp3aP9H4yeSX8vQxKtRRuQgp3HIfEsrYjlB8qLw9QFcbUt33pVoshgM+pihJFKvD7V3kyeydQbZi53BPUPPM7BDbdi1P/geFw7+NJUzioveo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=azSJjJIJ; arc=fail smtp.client-ip=52.101.62.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="azSJjJIJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k0jrw4qCJRUh9ZQygMffoEaIC1lgP6MKbP6ZETZUfH5HyQRbdbUPBMxdSzaqHhKjdrYbWU/3MjEmBRyeg/mmWhjuMW6S2Tan8lkJvSWnb2EihjxTCLggrZ7Ib/zFKPjNdL5c9/cKurG/742L4VOMmzwFEMG2DliC5FnctvzpR6cVpReZ6X1U8ZwMUU/gPDp6I0G4H50SaUv8A3I/Ca7jAj59ngBOrtqr1TTPi1KQj474L7ET6EDBH9AAWsxUAXqmc7ESlHkAqvmCYbuh+zdPx0j+a+PgNsn7eRt13zJob/z+hI0X+Yqc8mqE1YENZuMaW+0ewz9WmJHRH1kqHb5smg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9WPZxJL0h0ZHGYvIVidy0DsYV/F55aBRhojpccsGf50=;
 b=EgXFmbMig+dhz9SaiFRbBXXtZH3MrFnfAk1vyA/k07CUMfORylBNiF9EFxR5VNET4ibUYxypKEknfQrnjWb/Isfa9L55jmVEqFKj9Posd9BbRcEQ/8lxv0LcKbCrtxEpHXAjnzfcl7KuPdbOR84+8QzBtKFzqOivIuHMqkHS7vjdMd4hTL/4zGC0M/MANTMvbF1o6gWccTo7YVru62yTSmE8SJF7AJvm+cEtggcEXX9OaBzbbMWZ+aT68vMgtZZhLq+0MUDeGLUDZg/4W3pAkoaS51e1qrZVwpljljodbFnFdZ4eFNfq/ixgfCzEcdiZL8FbwqoiOxPy+KzbXuChwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9WPZxJL0h0ZHGYvIVidy0DsYV/F55aBRhojpccsGf50=;
 b=azSJjJIJk1PPOEBg2Yt4PrKzjfwBEah9zkhw7kO4YI5it05bkHvAs6mlJ8e3W+xyZTXIbVk7m2iQKfo7Q0VhbfQgHj06RxjxHF0weaJosFn5WCGqqg5YuE2v7M+mgH0go6PXQVjETSXEKe/pb3mZq1zxar80L68aGnDMtU7FAEY=
Received: from MW4PR03CA0281.namprd03.prod.outlook.com (2603:10b6:303:b5::16)
 by DS0PR12MB9445.namprd12.prod.outlook.com (2603:10b6:8:1a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 20:15:16 +0000
Received: from SJ1PEPF00002326.namprd03.prod.outlook.com
 (2603:10b6:303:b5:cafe::b2) by MW4PR03CA0281.outlook.office365.com
 (2603:10b6:303:b5::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.12 via Frontend Transport; Thu,
 23 Oct 2025 20:15:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002326.mail.protection.outlook.com (10.167.242.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Thu, 23 Oct 2025 20:15:15 +0000
Received: from [10.254.54.138] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 23 Oct
 2025 13:15:14 -0700
Message-ID: <d89d9d02-6b9a-4818-9f27-58f565237fe6@amd.com>
Date: Thu, 23 Oct 2025 15:15:14 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [ndctl PATCH v3 2/7] libcxl: Add CXL protocol errors
To: Dave Jiang <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>
References: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
 <20251021183124.2311-3-Benjamin.Cheatham@amd.com>
 <bd50a175-0e4b-4c65-910d-df2d1ae52be8@intel.com>
Content-Language: en-US
In-Reply-To: <bd50a175-0e4b-4c65-910d-df2d1ae52be8@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002326:EE_|DS0PR12MB9445:EE_
X-MS-Office365-Filtering-Correlation-Id: f3f77fa9-d573-4635-ee39-08de1270e16d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WjlVaTA2UXdpWmY1SjIra09pYWVsUlN1enFPKzN1Wnp3amZENlN1eWc4ZTBT?=
 =?utf-8?B?VzY2bWt6cXNvczJOcXM1SlZVckpRR3o1TnFTTk4vTjRGR3pCMkMwREcrZk9G?=
 =?utf-8?B?R3NyMmhUcVlsd2pPUnAvNGE0VUJxVVNSQmkxWFhvWUI5TjhHVDh0dEJhMnFp?=
 =?utf-8?B?VkNhQnkxQkNtN2l0eDFYbTdkdnJSMndZbTEvQ09tdkRrQ1Y2cVlBa0ZadmpB?=
 =?utf-8?B?Z0kxK3cxZmVYdEIyRm1KeGNrRllXczRpTFhzVm1ORHFmVHBtUzJNb0Z1SFJ3?=
 =?utf-8?B?b04vZi9VZFpFUzdLcG5wTFpML0tWU21aWGV1ZnZaOHFWR1Y0ODZTSFhuUXNT?=
 =?utf-8?B?UmNENE1qQmhLckUrVlhaY1BTL3haNkJMNnRQQkpJM29Ua0lpaG5YM3doNzlY?=
 =?utf-8?B?ZUpVZWI5TVYzc042ZnhPQ1NHY0ZqMjFqWlhPRFhGMDU4Mi81TlU0REVqZU5l?=
 =?utf-8?B?aEVicEpiSGdub21Xb3lseGhnVTRYd29KNEZDRXRYYzNUanZ2OXd2bzYwWXZY?=
 =?utf-8?B?bENCYnFDTE1vQkZpYXlNSjVYOGt2cXNRampFMEp0S3ZVcXVZQWgvbG5pcWR6?=
 =?utf-8?B?WUZ1MTlRNnF1amJpLzlVQ1I2UGJKMnpYRXdaV1VnTS8wN1hscURqY0ovQTU1?=
 =?utf-8?B?SWlGRzZBUmdnSFQrS2ttZzBndnhxUFlRbE91QjNleFN1VEl1bDNHRlRSRURX?=
 =?utf-8?B?UHpyMUwxTjhJZ1d5dTBTZlVrODkvdVY4aDRQeGRYY3hCdWJkK2lGaTg4R3Jz?=
 =?utf-8?B?ZVloQjF3R2JiRGUveUtkU2RJcGFwWlJhVHdXcTRRVE8yc3hHMXc3TE1iWDdB?=
 =?utf-8?B?cm01a0h2WGFIcW8vcWFtRWJCNnJ0cFFpZ2JUSzR3SjBVU0RLeU9FZEY5VkxO?=
 =?utf-8?B?NEhqbkd0TzJkZUtjVFA0YWk1MlN2QmcxM1pjWktORFBpNk9iYit1MHlPd3FM?=
 =?utf-8?B?ZjQzaWRra3J6eUhHUDBlbE9KTEhuemEreWpUUStIUS9HeFpQaFVIUkZJenJL?=
 =?utf-8?B?Qm9jejU2M2J5VEZUSG1PUThpWkZxV3o5NElRTWR2OVdDL0tWUmhtS2dRRzN3?=
 =?utf-8?B?bm5kU1A4WVoyYVRmU3ZFVU91YVRpVWZxN1pKekRqZlQyYnlCdjRmdUVQckRw?=
 =?utf-8?B?VWQ4YXZuM2lGOEpQNks1RXpYTHdTUjBLcnBJdEhDRDh0L3FtOTc5MkljMzNr?=
 =?utf-8?B?SFhVa1VGT0I0T3FnOUM3dEhCOEIrSVcyUzhidzZHdGNxUFAxTVdoZEJtcVYv?=
 =?utf-8?B?ZVYrR1hqc0hjMTFaNk1UWHQvaksrYXYxYlk4aUI1VWNTS25YYzhHc1JqLzhx?=
 =?utf-8?B?TnkrY3JYL2U0aFRRQTdiZWFlZG1LV0RlSlA1RVJUUW1lUWw5TStxN0ZKZVdk?=
 =?utf-8?B?d0V1MjhKTk0xKzlmTUtoRTl4V0h5QktlS3lhQktHUXJIMnBHYUkyN1NnN21q?=
 =?utf-8?B?WFJiZ0g1NHF1RVVUb1JEeUxzc3RlWXZNRG0yL3FZUnZJRytPVlp2cUZwbEky?=
 =?utf-8?B?aWZxUGpITXFtZm1SOWJ3ZWhXUzk5QXIzYjdzUUI0MUk5U3JpR2drZDlFdWxY?=
 =?utf-8?B?dm16ZWkwMTVsdTduZWFxbHg3TmtsaFkxQlllQTBRQTdpdkJLRDY0bXRxNnhI?=
 =?utf-8?B?bCsyNHZvdmMycmZYZm1temF2SGs4M2dKMW9VVUhYVlczODd0NkhEbnQ3TVpI?=
 =?utf-8?B?eHFaQnV5VlhaaDVmaysvS1FRR0x1OGxoL29LVmF1TTluMzBMRFQxWHFQT2oz?=
 =?utf-8?B?REZLVm5TNmd4T3MzaWZLN3crK3dtVWthZEpjL01ML3RlVjBOZEhYWVphcVly?=
 =?utf-8?B?Z3hHTHVrOXhTaklqbXhZa2FEdmRaMkFybVdySTFJb3JVY2JMaE1OQlRzd3py?=
 =?utf-8?B?LzhGVFkrTkt3cGJyRUlFUGVoNy9kSGk1bHlaendZS0NLZHFETmRMaGRtSVRz?=
 =?utf-8?B?V3AzSTZYdGZWWlVBTGMwL3hscDhrdFBTTFViZGEvSktURG04TENjNzZ2L2g3?=
 =?utf-8?B?ODJGS2xFQ3VKVVlzbnFVYUlNVjYxY1ZPa0MzbWRCeVNKUUYyYUdKYUFxTkQy?=
 =?utf-8?B?UFByM1MrU2VFbCtaS1ZlNVlkSlBXT2dqRlVoaDh2Wmd1SFplcS9ZenBzcG85?=
 =?utf-8?Q?VyXg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 20:15:15.9568
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3f77fa9-d573-4635-ee39-08de1270e16d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002326.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9445

On 10/21/2025 6:15 PM, Dave Jiang wrote:
> 
> 
> On 10/21/25 11:31 AM, Ben Cheatham wrote:
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
>> ---
>>  cxl/lib/libcxl.c   | 174 +++++++++++++++++++++++++++++++++++++++++++++
>>  cxl/lib/libcxl.sym |   5 ++
>>  cxl/lib/private.h  |  14 ++++
>>  cxl/libcxl.h       |  13 ++++
>>  4 files changed, 206 insertions(+)
>>
>> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
>> index ea5831f..9486b0f 100644
>> --- a/cxl/lib/libcxl.c
>> +++ b/cxl/lib/libcxl.c
>> @@ -46,11 +46,13 @@ struct cxl_ctx {
>>  	void *userdata;
>>  	int memdevs_init;
>>  	int buses_init;
>> +	int perrors_init;
>>  	unsigned long timeout;
>>  	struct udev *udev;
>>  	struct udev_queue *udev_queue;
>>  	struct list_head memdevs;
>>  	struct list_head buses;
>> +	struct list_head perrors;
>>  	struct kmod_ctx *kmod_ctx;
>>  	struct daxctl_ctx *daxctl_ctx;
>>  	void *private_data;
>> @@ -205,6 +207,14 @@ static void free_bus(struct cxl_bus *bus, struct list_head *head)
>>  	free(bus);
>>  }
>>  
>> +static void free_protocol_error(struct cxl_protocol_error *perror,
>> +				struct list_head *head)
>> +{
>> +	if (head)
>> +		list_del_from(head, &perror->list);
> 
> I would go if (!head) return;
> 

Would that work? I think I would still need to free perror below.

>> +	free(perror);
>> +}
>> +
>>  /**
>>   * cxl_get_userdata - retrieve stored data pointer from library context
>>   * @ctx: cxl library context
>> @@ -328,6 +338,7 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
>>  	*ctx = c;
>>  	list_head_init(&c->memdevs);
>>  	list_head_init(&c->buses);
>> +	list_head_init(&c->perrors);
>>  	c->kmod_ctx = kmod_ctx;
>>  	c->daxctl_ctx = daxctl_ctx;
>>  	c->udev = udev;
>> @@ -369,6 +380,7 @@ CXL_EXPORT struct cxl_ctx *cxl_ref(struct cxl_ctx *ctx)
>>   */
>>  CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
>>  {
>> +	struct cxl_protocol_error *perror, *_p;
>>  	struct cxl_memdev *memdev, *_d;
>>  	struct cxl_bus *bus, *_b;
>>  
>> @@ -384,6 +396,9 @@ CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
>>  	list_for_each_safe(&ctx->buses, bus, _b, port.list)
>>  		free_bus(bus, &ctx->buses);
>>  
>> +	list_for_each_safe(&ctx->perrors, perror, _p, list)
>> +		free_protocol_error(perror, &ctx->perrors);
>> +
>>  	udev_queue_unref(ctx->udev_queue);
>>  	udev_unref(ctx->udev);
>>  	kmod_unref(ctx->kmod_ctx);
>> @@ -3416,6 +3431,165 @@ CXL_EXPORT int cxl_port_decoders_committed(struct cxl_port *port)
>>  	return port->decoders_committed;
>>  }
>>  
>> +const struct cxl_protocol_error cxl_protocol_errors[] = {
>> +	CXL_PROTOCOL_ERROR(12, "cache-correctable"),
>> +	CXL_PROTOCOL_ERROR(13, "cache-uncorrectable"),
>> +	CXL_PROTOCOL_ERROR(14, "cache-fatal"),
>> +	CXL_PROTOCOL_ERROR(15, "mem-correctable"),
>> +	CXL_PROTOCOL_ERROR(16, "mem-uncorrectable"),
>> +	CXL_PROTOCOL_ERROR(17, "mem-fatal")
>> +};
>> +
>> +static struct cxl_protocol_error *create_cxl_protocol_error(struct cxl_ctx *ctx,
>> +							    unsigned long n)
> 
> why unsigned long instead of int? are there that many errors?
>

No there aren't. I'll change it over to unsigned int instead.

>> +{
>> +	struct cxl_protocol_error *perror;
>> +
>> +	for (unsigned long i = 0; i < ARRAY_SIZE(cxl_protocol_errors); i++) {
>> +		if (n != BIT(cxl_protocol_errors[i].num))
>> +			continue;
>> +
>> +		perror = calloc(1, sizeof(*perror));
>> +		if (!perror)
>> +			return NULL;
>> +
>> +		*perror = cxl_protocol_errors[i];
>> +		perror->ctx = ctx;
>> +		return perror;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +static void cxl_add_protocol_errors(struct cxl_ctx *ctx)
>> +{
>> +	struct cxl_protocol_error *perror;
>> +	char *path, *num, *save;
>> +	unsigned long n;
>> +	size_t path_len;
>> +	char buf[512];
> 
> Use SYSFS_ATTR_SIZE rather than 512

Wasn't aware of that, will do!

> 
>> +	int rc = 0;
>> +
>> +	if (!ctx->debugfs)
>> +		return;
>> +
>> +	path_len = strlen(ctx->debugfs) + 100;
>> +	path = calloc(1, path_len);
>> +	if (!path)
>> +		return;
>> +
>> +	snprintf(path, path_len, "%s/cxl/einj_types", ctx->debugfs);
>> +	rc = access(path, F_OK);
>> +	if (rc) {
>> +		err(ctx, "failed to access %s: %s\n", path, strerror(-rc));
> strerror(errno)? access() returns -1 and the actual error is in errno.

My bad, will update it (and elsewhere).

>> +		goto err;
>> +	}
>> +
>> +	rc = sysfs_read_attr(ctx, path, buf);
>> +	if (rc) {
>> +		err(ctx, "failed to read %s: %s\n", path, strerror(-rc));
>> +		goto err;
>> +	}
>> +
>> +	/*
>> +	 * The format of the output of the einj_types attr is:
>> +	 * <Error number in hex 1> <Error name 1>
>> +	 * <Error number in hex 2> <Error name 2>
>> +	 * ...
>> +	 *
>> +	 * We only need the number, so parse that and skip the rest of
>> +	 * the line.
>> +	 */
>> +	num = strtok_r(buf, " \n", &save);
>> +	while (num) {
>> +		n = strtoul(num, NULL, 16);
>> +		perror = create_cxl_protocol_error(ctx, n);
>> +		if (perror)
>> +			list_add(&ctx->perrors, &perror->list);
>> +
>> +		num = strtok_r(NULL, "\n", &save);
>> +		if (!num)
>> +			break;
>> +
>> +		num = strtok_r(NULL, " \n", &save);
>> +	}
>> +
>> +err:
>> +	free(path);
>> +}
>> +
>> +static void cxl_protocol_errors_init(struct cxl_ctx *ctx)
>> +{
>> +	if (ctx->perrors_init)
>> +		return;
>> +
>> +	ctx->perrors_init = 1;
>> +	cxl_add_protocol_errors(ctx);
>> +}
>> +
>> +CXL_EXPORT struct cxl_protocol_error *
>> +cxl_protocol_error_get_first(struct cxl_ctx *ctx)
>> +{
>> +	cxl_protocol_errors_init(ctx);
>> +
>> +	return list_top(&ctx->perrors, struct cxl_protocol_error, list);
>> +}
>> +
>> +CXL_EXPORT struct cxl_protocol_error *
>> +cxl_protocol_error_get_next(struct cxl_protocol_error *perror)
>> +{
>> +	struct cxl_ctx *ctx = perror->ctx;
>> +
>> +	return list_next(&ctx->perrors, perror, list);
>> +}
>> +
>> +CXL_EXPORT unsigned long
>> +cxl_protocol_error_get_num(struct cxl_protocol_error *perror)
>> +{
>> +	return perror->num;
>> +}
>> +
>> +CXL_EXPORT const char *
>> +cxl_protocol_error_get_str(struct cxl_protocol_error *perror)
>> +{
>> +	return perror->string;
>> +}
>> +
>> +CXL_EXPORT int cxl_dport_protocol_error_inject(struct cxl_dport *dport,
>> +					       unsigned long error)
>> +{
>> +	struct cxl_ctx *ctx = dport->port->ctx;
>> +	unsigned long path_len;
>> +	char buf[32] = { 0 };
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
>> +	snprintf(path, path_len, "%s/cxl/%s/einj_inject", ctx->debugfs,
>> +		 cxl_dport_get_devname(dport));
> 
> check return value

Yep, will do (elsewhere as well).

> 
>> +	rc = access(path, F_OK);
>> +	if (rc) {
>> +		err(ctx, "failed to access %s: %s\n", path, strerror(-rc));
> 
> errno
> 
>> +		free(path);
>> +		return rc;
> -errno instead of rc
> 
>> +	}
>> +
>> +	snprintf(buf, sizeof(buf), "0x%lx\n", error);
> 
> check return value?
> 
> DJ
>
