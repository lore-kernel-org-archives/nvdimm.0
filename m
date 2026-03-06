Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011041.outbound.protection.outlook.com [40.93.194.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFE73B4E83
	for <nvdimm@lists.linux.dev>; Fri,  6 Mar 2026 16:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772814502; cv=fail; b=rd3pX06vT+QPYtuEj9yYGG0guE4ce6pqXoGSlpa3cDhGH2OjaJizN0yQuXCjNXxPtHLfCvdNSsP0ZVErZvkFzAOLv+XzgqhBSQQ75b9xOTqwrm3OpoDNmi9p9eIex6S2cQWzZpcGLeJLbcBxW3rGFctGA9ppU00Qf4QgP/uuwRY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772814502; c=relaxed/simple;
	bh=ZeMOJbMQ3xoufWHuWFmdJIciJgbusUJcEa5pPbdRMBY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mNkWXS9rIKv3SuQdpATIzP0mEVE3FLQuHE66GKtsXtTn4NHF8ogDwcYb0SA2V4jTbE4yCK3UfMWMIgklGJNmN88X36X35PaNc0mxsz3BB8ybMu8TN1t2ILbylpyWeDP2wP2HEx4NLOLpsLPLWfQPM66Lj9+8RJ6xmvs6nRy3wII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Bhf+VMS2; arc=fail smtp.client-ip=40.93.194.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Bhf+VMS2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T29h1qcst6kb5I7tdPQ7Sj0olCRr/mj5AQhpHzZ0Ln+Mks1lAB429YxhRY2SPG1bKJAYA3fXXU2wxK53xDN6rQGP8zwCpqC7bZLSCAY5JhwS/No81UhXKDNLaUfA4QPSA9sbcWoVdRGJj2YZT1bMRv/0WfB63Puc423VFeeIdkoJ9gLH1yZRVo0cOyY23EPgWJmcRRIlTIDJ9E9pye/70c99I4VBg6GFhmGMZz6dZ63dXDVjtwVggGUnZ0+McPJgOAZN1sbHawH6TbgRqrSwRpI5L2jfa4r0yP5Pfwi7ZIyQAzt66RA/jgtMKm8Y2wRfWkR3UjAWXaF0VUIwmHvRPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3oYM8/xptE5RdfuOKAQY4YkipXPfYBLvoD7Ln05TwWI=;
 b=NaBTFIAfrLPX6AMNyzFqGUwBBUopKd8QBzDMavv2OGGx+WrAzHbHwhSdNIA3vWXAS6F8tAOrI0KfrWleKZzVvdbfBzS9z4rO6I09j+Tmi46jZooGTAuj+oqHPT4KWuW7I0q9xK/7gJfwbU4iaHlKsXr6Zk54pWumIGzSY2d2qzrp4KgRHWySjoVowZ8eLhDA8WZpgmixqAjp+b1JKxMlQeu0Ct29q8nmHP2spkRxJyxKvI4ALKi828va6KsYq0p8vmbvXqmWr3b2BnI7Xg3P06Lpl3q1M2A6TDJGb3jmD5jtVoaMAaJ6QLI+OPUd72aiMpNyXWzoHRsXipiMhuLLHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3oYM8/xptE5RdfuOKAQY4YkipXPfYBLvoD7Ln05TwWI=;
 b=Bhf+VMS2Sn6l2oR+u7sydFSlcHhRFOicJMg9BxwZcaoa/5wxQy5FtfUUtDB+EIKZ3b/7mAFAUeYreOpLbGF/hfO1A71Apx4tGAfinLycd4bLEuOcIu+xUg9RpCnBo2v3ykTWe3X1tQ2jZHgkJTad/hXoUjpiO1uHXljBKxOSSQI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by CY5PR12MB6276.namprd12.prod.outlook.com (2603:10b6:930:f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.6; Fri, 6 Mar
 2026 16:28:16 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::9e55:f616:6a93:7a3d]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::9e55:f616:6a93:7a3d%4]) with mapi id 15.20.9654.014; Fri, 6 Mar 2026
 16:28:16 +0000
Message-ID: <b73d47d4-333c-4b8e-8b4f-3a0a72902c3e@amd.com>
Date: Fri, 6 Mar 2026 16:28:11 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 12/18] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
Content-Language: en-US
To: Neeraj Kumar <s.neeraj@samsung.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, gost.dev@samsung.com,
 a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
 <CGME20260123113141epcas5p49a1eebff4401a7fc98381358162fde2b@epcas5p4.samsung.com>
 <20260123113112.3488381-13-s.neeraj@samsung.com>
 <a560c14c-410c-4ea8-9076-deeb9ba28fee@amd.com>
 <20260306102444.fkoqhyavd7cgorxy@test-PowerEdge-R740xd>
From: Alejandro Lucero Palau <alucerop@amd.com>
In-Reply-To: <20260306102444.fkoqhyavd7cgorxy@test-PowerEdge-R740xd>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0355.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:37c::24) To DM6PR12MB4202.namprd12.prod.outlook.com
 (2603:10b6:5:219::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4202:EE_|CY5PR12MB6276:EE_
X-MS-Office365-Filtering-Correlation-Id: b116c707-f892-46d9-ccd2-08de7b9d5ebe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	tuCyx84684YtyVWOwjHZgfnYVJ8uHBLkSmAWq4gbfFrI/QCGQcoC2hg3ueWYa54H4QPsD83z11AuuX5pLM50tdNHH5vuTUsXEFOvG1M6StWD7GcR5CRWXhOJWhWhGivEqVf3fii8ZRIBZmKBG4+CGX4tdAt3zC/P9e3M+lyF00jOLbpzILkvoYewwP9ERz0xHkgYkK61XXVKo7TQ9jpsghv8mnM9OPlqywMfW1jtXIUUhPMBnz4AZx8tpVGb3vb+Tjsyqgrq+OL2C0RsmNgoQIGFeFNi8Ch80n0J/cXIPZ2Xo05ygrG3hADaHgnB4FTbGjiDhpu6ll1Vaag+/IdN1SJHE7k7TueIDFgHVTu+azSiHvxD8y6LIwRabc2pPLSxCbd2OgHq615t8Bi0xOPV5sZhbB3FzXa2cx5dk1RDH++BI20nwDihqKJGpUDwFyS7rHqmmM7Y03flW4E8+ImiG21PjqJa6k5eAEJ3zp8vTzrlXPmGIpgPESc5dBgYgPAzrolDgwJKPI+DNtqmR81kkWYUJagjnZC2aSoEwn2Pr64ltQGUmg/0elEBIFMGAaRGEXQY11LRHpyGVq33Vx9gI+2rsZ1m5vE0NBgZTA3f6IoeIh0GhZsDBTnHMoaHu3mtEUY5hgI//9BmqBGNSAmaQx1yhyUfP9pwn8KSq4s3aVPdabcBezcuY1Cf6biVdOpM4WxQzQgN4EEXCDexxlGb9K4nuUiquX8dfBiqOFW9Isw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b09ZZi9GblhQQzdNc1ZJMnp0UmMvV1ZkTEhTQ1pkcGVkbVRKeTFiUmw5bzZU?=
 =?utf-8?B?dm1BWWlSbGlETTRJMUpCeWhBeDhycHgzb0l3L3QxencrK1NzQ2JrYTFzMXJR?=
 =?utf-8?B?bmd2aTNrZmFzaDhDYkJJMDMwTk14TVJYTFdMd0dIc3d4cXEycTliOGNKL2Ey?=
 =?utf-8?B?VWxPYWpSbXFBSXhkRG9wOVV0U3pvZ2UyVkYzTUVWT0ttVmNDNUE1Mk5KdGRW?=
 =?utf-8?B?YkgwOThOU211VzRFT3R2MDhSZjU1aTBBTm11K2ZKMzIzNFd1WVJmTjZDSm1U?=
 =?utf-8?B?aG9UK0tGSzlMT0VKRStQTERzRjgxOUcxTmtjNjQ4S21hc3VrZTNQa1BkYU1F?=
 =?utf-8?B?WldMb3NyMEcweGVTSGkwSGgwcUR5d3lTZ0cwNEpGdmt3ak9QMGJBQW92bkxs?=
 =?utf-8?B?YkZJQVIwMnRjeUw1WitTNWNWVHdTMUJZYjhCSndRaDF2YjV3VFYrKzQyQWRN?=
 =?utf-8?B?aW9wZ2lxOGdTaXo0b1hmbUJyc3JvUHF1ZmNjKzVhN20rRGh0M20ramdRWkZu?=
 =?utf-8?B?bi9FRThneUtOOXk3RG1iazVCVFk1bG9TNXhFbTYwVWdzTkVOYnh3Nlp6ZmRT?=
 =?utf-8?B?RWJ6VlBjQmplZ0VDWmR4RGUyQ0loaVBYL0taV3FrS0FhWURwWHBMWkpCYXdH?=
 =?utf-8?B?RFJDVlNpSWlWRlk3V2NGMXBMVmwvOXFwSkp6WW1yWm9wV0JuN3BYVTNDRllI?=
 =?utf-8?B?ZERHY0RmNjJndGtTZ1lTdEs4enNpa2txaXNodzNINzgvdmdxc0d0MXlmZ1Jk?=
 =?utf-8?B?UlFxOUNYZ1pRTUpXVjZpY2JwclMycEpZZFpiWS93QWZpMllDSXRGVEUvcVd5?=
 =?utf-8?B?c2EwVDNrcGN5VlJENi8wVlZ2cWhtN0szTklZRXR2cWgxRXNtbFgyKzRGdkZH?=
 =?utf-8?B?N1lrM2RYUU1zYWZTYWFUaGxjK0h5WTlzODRmQVIzb3RqRStteFVyQ1lZVW5m?=
 =?utf-8?B?bGxucHkwSlhxdFJMYkRaTEhUQjB0S3JVY2w5THFhMGd4MW9KQzNaK2VTdlBF?=
 =?utf-8?B?NisrS3VzQ1NVUklPdnF0bVFaRk5ibzJoQ29aVlJjY0lEeDBFaHZQQTRYSThJ?=
 =?utf-8?B?RGlXcHUweTVQTFJ6eVhYNHB0T3Zhakh3T2txcmJGblFvSFBDRjFpVkEvZXdr?=
 =?utf-8?B?Tit5U1YzUG5NMHpHbS9Iay85YTloeVgxZEl0eExIVFFSUkUvaEFlODNFSFlm?=
 =?utf-8?B?WUNPNExLRDVZT3dYRHc1S3pXK24xanBsM3RwaGh4Z1lOb1p2OEJHd2hEWHdu?=
 =?utf-8?B?ZTlDcEY3YnN3dFhnd21STk5wanVCeE41TytlNnRiZWVpOU5XNmVXS2hYbmdD?=
 =?utf-8?B?T2M5RWFHaGp2czVwTkp0a0loZUhQMU0wS1NtK1FFRlJFd2FNWGRLZmxCZjZZ?=
 =?utf-8?B?V1lLU2FaWTUvZlZTK2VUOFdJTXZzZ0poRGlpTkcyckhLNVc0ZG5keVJ0T1hO?=
 =?utf-8?B?bHFWaTFlNG10eEZ3V2FHbit3VkZUUUpZUGQzKy9IRDI3bDZRcU1LNzN6RTVH?=
 =?utf-8?B?MlA0M0VqZEl6YWc4VVFSa1JEbjlSUVV2N1lZdUltRHZlQWhvUWlFV2tYbC82?=
 =?utf-8?B?ZjMzMnUzRE1SeklWK1QyRWVZNzlpMjQ0Z1RreFFRakJVbVFuajFlL0VqQitI?=
 =?utf-8?B?Vm9adUNndURQYzdXblJ0VzVEVFZDV0lFVmowWlRnNEYwRTJKcUhCUjVyZzBV?=
 =?utf-8?B?aTNQd0JBWTdBcTlrckNjcUg3c0YzaXlqZTZwWUlDQVpIMXIxRGY4alR0VVBV?=
 =?utf-8?B?NlNtWUFxODZPQWxFSWVod3hNaTVXdFo2US9QQjR1dE1zbml1eVRMbCtXZDRO?=
 =?utf-8?B?aGRxb3UreDFkZHhaOFdiSys0RVdMbGw5ZHVaNGVEeldkNmhCN1UyUjFRNGFp?=
 =?utf-8?B?anBPb2g1MUxpTGdyODVtUnZ2VnpmOE9ka3dxMUNnbjBzOXB5eGVKSlZ3eEFX?=
 =?utf-8?B?VSsveWFBZ3IzOElGbWRZM3lWL0RQRUhaeExGdDJRWjlTby84SW04dmpXN04w?=
 =?utf-8?B?ZDV6VWlWdU4reTduK3RxbFRaUmE1Y3B5K25RdnZCREpsL3drY1BJa1ZhSW9a?=
 =?utf-8?B?QldVTFJSRkZnM3NMSUlrNHgxcWpzNXhleE9WdDczNTJFQzJYU2dvTUdGMVhR?=
 =?utf-8?B?M3BPbklmR014cWg1d0RGcUZWVDAxZVdxNEU1Sm5ZL0lGSDdWMmtydnU4WnVn?=
 =?utf-8?B?SWgvQ2x0M2UrUjA2RVZyZUJZK0ttVjU5MzRsT0JOTzZENFRXeVFEem93ZmZl?=
 =?utf-8?B?MTk1ajVMSlBXbnpsOWVTK0RZcTluajdEVFZKY2hNM1VsWlB4Y0x3cUZlNnNi?=
 =?utf-8?B?eXhKV2Y0a0xvSllHTEw5YXZzWTZEeDFReXJZQzVGUjRCWkVOdjdBUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b116c707-f892-46d9-ccd2-08de7b9d5ebe
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 16:28:16.5223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HGtLHickw43rs8qxULISX7CFPfpsW3/AsW/rBHGcNkE1hYhSfKU4kMBSFMNEinpgZgwCDEFagcVmyWgKLPO9+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6276

<snip>

On 3/6/26 10:24, Neeraj Kumar wrote:
>
> Actually I have created alloc_region_hpa() and alloc_region_dpa() taking
> inspiration from device attributes (_store*) calls used to create cxl
> region using cxl userspace tool.
>
> I am adding the support of multi interleave, there these routines will
> not be required as I would be re-using the existing auto region 
> assembly infra.
>
> Even though I will re-check any conflicts with Type2 changes.
>
>

I'm changing the current hpa_get_freespace based on this current need 
from pmem and some issues reported by Gregory regarding concurrency when 
several drivers try to get things done. The current implementation 
reports max free space and the allocation is done later on what with 
those concurrency issues seems to not be the right solution.


I will post a new version early next week.


