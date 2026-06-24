Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013061.outbound.protection.outlook.com [40.93.196.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF002D238F;
	Wed, 24 Jun 2026 16:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782318553; cv=fail; b=PxG7FYsFmGdZWI/CETZ9OyznSvnLspybxFn66Rl7q9k7Ef7xYWHMavIAleO1Jhg3YnMmf4dQDZ1lWmcXRA2Bx4QfM2j57xoGV8HELjlLAf6pqhSmWMD2QvZoT5u8CK2OwdBYTndisuALWDtnZCYpV+Vf38E4FN5f53XjgIMRHmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782318553; c=relaxed/simple;
	bh=NaaUjsLOAf5kDKHat+iuP5asxFlpxMTRRLMxCKu8Buk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XZdDhbPOL3BFweylDwKjAOPBr/F78vekWCfGTo6/eGa/lTZ4VACprECEn44U+L3EY0+tytMt000s8w68cV974HYmB9SIy860yM0z8lYvavySJr3CjA8wcqiO6m5hlAenOPKduYWQatwMaYxWrdWZnj+UvZdOlWcoMV8bUp+rlOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hFm3+vv4; arc=fail smtp.client-ip=40.93.196.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hFm3+vv4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K+dgckwmJXGP89po7QR/yCgVu3gsRtgeyFqr0O7sBgyeTteZfakm86TTAmAH1pq+p/VMp0oULQKFF/DQZp4qIAIVhNF19f4XxBuOQdFgM2WKn7WUnC16SlVEJYcxLzNAyTZw8jz+qrh7b8Qvw1oYZCb4Bq/EE1PLW+MKkCVym4EnTj22XEi7SFbp0bJnO2B0n/mRmUPyRG8WUi0BT3W2na0VnEN7i3so7Y6uEluFkkgP1Etg/+wscJvuO5r9Ypi1/T9dW6jJBDkZCBIaKezvks3luD6N9Zk/9wsCspyC3mqsemhIC3wdEy/7SfaPg7OzvaRzIOPLlij/yHcxJ5IiVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pYvpL7eYQk/wyQ/i+jCH3W7s7dTRghENXFikMoEecxU=;
 b=s3zXZkVa0x7h9dX/7MF6H/r8ek31YAEU/dEczD0DwjAFQrd1xHKT5qyLEKoW1MvaR04gYeGec5Jc37NdIEfYiW/E7i9H1CBmfFNQZFQVJZp5t2frfWp4wSQGo+quoBN8KLtNyAQfpUJ8J1jhdolgZ8c7BQob2n2X0aj7XKL8XlnLrzhJJN5TQtsrTtjS7Gdpd2bzOg0nEis/xab1V9xDRnrvCBVXFLoM9hAX0bWeWvPNgjRfynA9J8GfBcrxM0PRXcc105LOzL+BtzoxK2Tj9vaE5vLx3zSaFmAWQ7tR9Ty2TafxElcNcpxZdMY0tRW0Wz46UCIAqqbPIVdxRI7HBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pYvpL7eYQk/wyQ/i+jCH3W7s7dTRghENXFikMoEecxU=;
 b=hFm3+vv470cDTRF1rwHD2e2UkgmaSaIZQgIkoTKT1U6mvQnPosn1rk4cSfBk2rNUaxXCUnZPPb0JRCdXc1Z4j4T6jJ0/Iv0vC+hJLHQGhzLurYm08bwm3EwKcpbuOFP1XYbEuVwEQcfcZBUFsg7EPGTK8WQfxWOgK1b/C50nSQw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY8PR12MB7433.namprd12.prod.outlook.com (2603:10b6:930:53::22)
 by SN7PR12MB6840.namprd12.prod.outlook.com (2603:10b6:806:264::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Wed, 24 Jun
 2026 16:29:08 +0000
Received: from CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6]) by CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6%3]) with mapi id 15.21.0159.012; Wed, 24 Jun 2026
 16:29:08 +0000
Message-ID: <8b911825-ec90-4de0-ac92-cc7f69d421fe@amd.com>
Date: Wed, 24 Jun 2026 18:28:59 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/9] mm/memory_hotplug: pass online_type to
 online_memory_block() via arg
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
 kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
 djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, alison.schofield@intel.com,
 Smita.KoralahalliChannabasappa@amd.com, ira.weiny@intel.com,
 apopple@nvidia.com
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-3-gourry@gourry.net>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20260624145744.3532049-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0024.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::10) To CY8PR12MB7433.namprd12.prod.outlook.com
 (2603:10b6:930:53::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB7433:EE_|SN7PR12MB6840:EE_
X-MS-Office365-Filtering-Correlation-Id: e371f856-daff-4ac1-0a3c-08ded20db753
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|18002099003|22082099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	T8PE8bGlXIeE5DMfWh5egFJUP/FQQecH33Tmyz+gW3QQfTqC07D4OxRYXNONApg7IlKJ3WvhUBC0St3VfgW64am9LH+nR9/Wi4d7E4K2HWigKWdduzTBBDyG1E/6i+ffIzv+SZekeJf3hRFknLLy//0egRee9LECNdYHo1VpIVd/ovfyj/BkOF/SUe6lO/7Vw3YQY3KzlkqsL8jvBjEepHxXZNKs68wYPcSN08ksscglHk7Pl6WLcl8fDPStrIz+9q0s5zk7KJVd+8IUItF5YHki3QwTBnn9NNwo+tieMUiY46zb8stZTEwVyAxUVggd+mArQ6OxkwukzkYNs4gLhlh2FZXWMikdZh4Bt7EykvGhTZ4VV/K3BdePjP3KJREpveDJTwi/JhTtVv3CWnk+O4yPVa7kuChJwYdw4KpFegxSeKgKSu+Te4dXAZk0fMZAeBTIXnV2R/r1Lfg4vYHKcx0VkOYQhA9TLuhAcFsOfAzPvKWzRB+5fWlffKR1aR0/1qROsbw+lspg67SD0TEOdF/OMSCKS7e81K5UuKFySwxTIDOzb+UM92MrgV48PhgzeG/le/VA0D9mNQDxquNPSMWrO63xhgWuRS7fIaObrCVNJ6dVz/OPil0FsMIFW5iZMJdjfDfFMs6jXlG1e1INI5W75BYwq/gHCc0sj8w18/0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7433.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cTVYNWtoNkhQNFczZ3dBb09KS0lFZHRyQW9Cc3pzeU1ScTNMTk0zTm9FbXl0?=
 =?utf-8?B?L1BoRDNaRmZvZDhMaytqS0F6WjZoQnRrcmJEYzFpMkRWY3dWUGV0T3RkNVhi?=
 =?utf-8?B?MGFRVUd0SDJWbkhtNklIYmowUnVLWjNHVVZtcEoxSzNJb3EwUU93eGJUSGp2?=
 =?utf-8?B?MzBRclpDaTV5VE00Rzc3WjRpa2lyMkJ3dnNRVEVFdlhGRFV0cXN3anJoUHVj?=
 =?utf-8?B?UlJrNDR0SjBqRnk4T0pGZUYwN1VlWHVvd3JOL2R0V2xNZmtUTzNYS05MV3k3?=
 =?utf-8?B?NTdIeERoZGtoN0t1akd1OTRFdzZNVUVpL0pSdkVSdkZOOUYwYkhLUjNta2Ju?=
 =?utf-8?B?eHJQZWhsUnlQak9zVnFCYWplRmd6anVBcmwzc3BXVGozSi9GUE1mc2lNcHZB?=
 =?utf-8?B?Q1JOL0J2WC93R0c5UVh4RjI2WkU3R2pLaEFxSjJJV3hucy9HNkp4L1ljNEVS?=
 =?utf-8?B?V3lZbk5veEU1dGRJMUxKaWh1VmRMN3FDQk9NMWJ1STYwc0ZLQitDY0o0dDZ1?=
 =?utf-8?B?N0YvdGV1MVJCMDU1MklURDBpaEorWTlxQzJBNHV3QWlWd05HZWFBRmlBdXNz?=
 =?utf-8?B?cEZ5aFY5UUNYUEJ2RHJ6RTZ0OXdvSjRkRy9NSm42QXBVcDVJY3VFZVFRSjNS?=
 =?utf-8?B?TzgzSjMrdlJuQnBHeEtueVg5MVgwMHl6ZGZ5dmt6WEJtbmZjcmdTajNnbEVz?=
 =?utf-8?B?TC9wd0c1ZDZkKzZzOVBINm8weXkyaGozQzd0OEdNMzlnbnFVejZEVHpDRWZM?=
 =?utf-8?B?TThsU2JpOVI3eHZkWnVTbzd5cWFUejMxWitFajd4bzdXekVyb2dDSXFiSWFZ?=
 =?utf-8?B?Vyt5UmFyRnZrZkZnVHdGWjhYYzlkZVVEb213R2w5N0pseHpBRkgzNDNZZjMz?=
 =?utf-8?B?K3J4L3IrYWZwbVRnbDdMRU93eDI0WWZUSkJFMERZVUg4UFBBSlNORW1HeDhw?=
 =?utf-8?B?OEg4VCtPWWl4V2t0amc2bTQ3azlMUlc3OFovcU8zUURrRVcrbTJqQnZGNm40?=
 =?utf-8?B?YzVocUQ4RXZwL0ZTeUllc09aeEtMYllWNklKMVd4TG5aR1VsSDJzNWszRUlF?=
 =?utf-8?B?L09UK21icnFUWGtkOWNJdHVpUVNESnZXTkxVOFRweEVhZGNPT2xDckRmWEl3?=
 =?utf-8?B?WjlZcmZ4K2RVYkU5eU9Pc2wvRTBmNlJGOVQwbmdKajBoOUM1WGxTQ1g0clVk?=
 =?utf-8?B?Y0tuRjdiRmJIbWFFa3hReGNZdWJVcXZGN1lsSk94RzR6N1pOTHZVMFVQYm1C?=
 =?utf-8?B?VSsyc0tKczdpVTY2MzJyRkRTWmVueGZGN3pHK3kzZ3dWWnZLU3hhc2VXTWdr?=
 =?utf-8?B?VC9qZlZIbGd1cU5SRi84N3l6K1ptNU1XK3V2UVJtRDFFNExranh3eU1OZmcw?=
 =?utf-8?B?bkN4MTBmWnNkTFE0ZWZITEc2bzl3TUNqbEZRaFhnV0p5emxmQ2dDK1J6QUM0?=
 =?utf-8?B?blAyMm5icEFNR0pMQWk2bG1LaW5RTE1XZ3FnbVFBaERJcDg5L1l6Y3huU0Q3?=
 =?utf-8?B?Rnc0MWtleUt3ZnlFWWcrdnp2K0JiMTFicldNZzNDdVcveTc2S0srSWJPR1FL?=
 =?utf-8?B?UW9WSzIyWVBpZVF4bHQ3WTV2TzgvZW9XTlYybnltTEl5VlBpckZNRnZEaisy?=
 =?utf-8?B?bmN4K24zdmxpU25kU3FlODFMZHlwb2d0TXFNM1BpLyt1QTZEU3FnRk9PZkFh?=
 =?utf-8?B?S0Y4NkxaZGZPVjEvZUlnTUlaMU82L0NFdVQ4TkcvRVphMDRUNTdXc1U2cytP?=
 =?utf-8?B?Q05hRnhteHZTeEU3bTdiZHpBYVRBM3hpOCswSHNaYVNqV2FXR0h1M2h4a2gv?=
 =?utf-8?B?cHRjTmxmUzlrcFZIaVVVcGJVcnJvcGZKSk5oeGV0QjlhUjFIYktmd3NBaUlC?=
 =?utf-8?B?L1laR3RqWTBuSUt6bE1RMXBPOFhHNVlFdEdDNEpKWW80enRvVXZqK3UrNU1K?=
 =?utf-8?B?cUxYa1pZR0M2YVltbDJvdE9xSlZTY0RmbXM3U2tMSE9IUjZzQ2Y3K1QvK2hQ?=
 =?utf-8?B?cndCRmxJVDdKWjlXaGdCUi9VNHFnMG0xQ0NOUElhMXdpd2d6YTE0c2N1bDJp?=
 =?utf-8?B?RzhqMVFKUUZNMjh4WldNcC9VNzVCMUNoQndaTGFjMVlvR1JYL2syUG9INmt3?=
 =?utf-8?B?RyttN1NBWnNDZ3JhNXRlR2dHQTk0MWNCa01PZXZOaGdUU2lhK0NxUXBVWWUx?=
 =?utf-8?B?VHVQTFIyVFVoVE9CVEZQZlczVitzMkE4QSt2MXVEd0ZlWGttbDdhZnkzVXYx?=
 =?utf-8?B?dUl0MnRFS3BQN1FuUGtpRk9LZC91QzdBeGxxYy8rMnZIaG1vbWtYVDlEUG1L?=
 =?utf-8?B?SDdZd0NXMUpGT3NCdjhnUU5ieCszeEFqYXhuNzFoYm1FOFZBc05sUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e371f856-daff-4ac1-0a3c-08ded20db753
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB7433.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 16:29:08.7946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CzkX0WRzWyTeORPS1ycDMoz67e9OVQWCMenjRzKedWVh7p52+wKWo/7lF+fa+Msn6kWvhmj0H8P4snFhHVa97w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6840


> Modify online_memory_block() to accept the online type through its arg
> parameter rather than calling mhp_get_default_online_type() internally.
>
> This prepares for allowing callers to specify explicit online types.
>
> Update the caller in add_memory_resource() to pass the default online
> type via a local variable.
>
> No functional change.
>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>   mm/memory_hotplug.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 7ac19fab2263..6833208cc17c 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1337,7 +1337,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
>   
>   static int online_memory_block(struct memory_block *mem, void *arg)
>   {
> -	mem->online_type = mhp_get_default_online_type();
> +	enum mmop *online_type = arg;
> +
> +	mem->online_type = *online_type;
>   	return device_online(&mem->dev);
>   }
>   
> @@ -1494,6 +1496,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>   int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>   {
>   	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
> +	enum mmop online_type = mhp_get_default_online_type();
>   	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
>   	struct memory_group *group = NULL;
>   	u64 start, size;
> @@ -1582,7 +1585,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>   
>   	/* online pages if requested */
>   	if (mhp_get_default_online_type() != MMOP_OFFLINE)
> -		walk_memory_blocks(start, size, NULL, online_memory_block);
> +		walk_memory_blocks(start, size, &online_type,
> +				   online_memory_block);
>   
>   	return ret;
>   error:
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

