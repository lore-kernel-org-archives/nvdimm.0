Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012000.outbound.protection.outlook.com [52.101.48.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BCB3AE1BD
	for <nvdimm@lists.linux.dev>; Mon, 21 Sep 2026 08:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979108; cv=fail; b=DrnIT9ReKwo+2BeYLxRnWAFZQv46S99f4B3jvADcWhx7Q7qrJ/c/j/DipjaeoOimzRjPW9JLO/D2eo+qf0liTMwVshiQSjKtNliCp/huRCQZQoXETaiBgrcEHMo3RLy45D4IlFWqqxT35P4WXYJ5Gy6p+Auk5D82Gcrap4sK4Y8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979108; c=relaxed/simple;
	bh=w/0NCZU0Mv4mTWAqwjpbSN6osJk1uwUFIZnrdC+94Qo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GrKqSEsGkjjXZZAYzwVndAZ9BE3yXpBUrcGAUS2T0pLFPeYw5CLqBEWScDHj+aTVtuaiwHv6z2db7CjuVXKEicp6XsV4lR8xS5s49nd9oMegCNJha0mg1fYi83oYwavQbkPUqw30EfaQ5m2MXVYUJMY1KVYXvGqfC3GT+uqmlE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PILN91OP; arc=fail smtp.client-ip=52.101.48.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PILN91OP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iAQExMk6rTR9l4U9ZpsDWLsUkU1OrYuQ8Oyb3az06o6nkNvFO1KQvLUl9xyACvdLURM8mdyvoJxdGLPMIXhsLVFbN/2iWy5zArXipryfpfVcq+Ok5vQXkFy4r9AE+g0wFhZTWiKIqlYn5qRvY7XWdrrvv8BVGkqE65jVD/CVgYqhDpqwqmawuQJ6mF7Y/ybuLxKqIecowmjjTm+2iCAXgwIfw/PcyOFpvXEus2TBcHxHkCtRnMexb4HX7OPWVAJLVV7PHyyJmxagSbD3NjtGRMGdmxwvsfMb5+JuCO6Vk2bCZfr+vNHUMZnwdxvKfh8QiVZajyUvb5BTIW1wZAu7/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kgEuYGmggYuW7nCrGSpjwGbrvjWHzSAl61UPqvsqQc=;
 b=bE2I8kVH+TeKPcWmGSj6U0rSKPZuPE7syThs78/yE2zjyXlJyL+vesgqLw2Qe1bkQ7DKNGVbd7Qv59/A5fG0L8OyfaCyZjmSswYUXuNF17Ow5DkzgC/09Hf3tRYl4kpIB53moJBC0ADo8dJBR8MU3L4twW2Y1aE+4y1ltwyE029pY6HlyLvpc16MWeYjYOq/ENLXiC1XioOKdzmAfsJAAcO2dRLimkumzYUjt+ImzvrgLokFX5+nOG78N+O0UuIWWSRgu3AG0sdkkErVnpLTy9m1LHuiy1q+gTY0wHkQKqqh5mkA5UvMxz3kpsz5rFwgFgoNbdK0hPcWesdsMrkmVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1kgEuYGmggYuW7nCrGSpjwGbrvjWHzSAl61UPqvsqQc=;
 b=PILN91OPgwtX2HR5cd8rZ2q7eHHvA5AYL4bv1d2IJRADXBxDDvXBIpmm962ekvaZNsSJVjN7JrrWsI4gLBcDH6S7UM693fURONgTaP7Bd+PE1ufZhgMWlee+FXsBn6MOzJe+fYVFRxI+w9sUcYt90+LEQxHwg50GXwocHmutFjk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 PH7PR12MB7968.namprd12.prod.outlook.com (2603:10b6:510:272::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 08:25:01 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 08:25:01 +0000
Message-ID: <34be3233-87a7-4dbd-bf4a-56116f4e8cdb@amd.com>
Date: Mon, 21 Sep 2026 10:24:51 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dax: use assign_bit() where applicable
To: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: linux-kernel@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <20260919130750.3041470-1-peng.fan@oss.nxp.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20260919130750.3041470-1-peng.fan@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0111.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2ad::8) To DS0PR12MB7771.namprd12.prod.outlook.com
 (2603:10b6:8:138::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|PH7PR12MB7968:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fdb01c8-3c37-452f-dd66-08df17b9d462
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	90nSfKgU0G8MQOqUjgaffiEavGEKYZVs495D77rSz0Ly2KE7NYBfywkhnIGVshdmMMy2+sa50gfYl90X6GaeSPxZjBVTHNndjimqX+cpHMRb6ePX9G2L8tTObIYvumyfruV8FTlnUaZStmRYhlWoeOc7QFS0W8Q4EgomZ8LEifzTtgNsJb+doTYWJ79IGFa0mkmQh0p5ZHkHnepqFaRz7RkwbLZwW9yTvts//fVRzx03qAZwkw5aQdytms1G+sNhAMbjp5mxbs2tq/GwXM32+4L9EdbTF7P8GuHVqAKOnGALBRZrwr2oIOZUipkWsX5PQK0PmVb+U1Y9ev7CO9K39uzkF/e6ts5b6M2ph7EXTCZ6gpTT7Od5J/r7B0Efhhh/5LwI5rl1p4X11v0cLUqnF6okrE24Kc+lUuf3WmlKywNne59ucBu6M7RBWx/osulKGEkGwmrvQOpMYcWxZpCfRcDj0MbmVpNLSUSNgZqgl1vop/UM0o5P36bqoZfc/wOkzvOXpMckpuOePe908xaIr4I/ya5xDBQ0pKxKAADu4ocy1LE+1354pg0/ut0l4Qlizsq0N5Dfw26+989Fm6ljJ3s38MDg4b2nmoQaSJfb63UyqUH0QnQiapwyWF0uyesPRkIAk3l5wTbsPwqfFnYJfH52O7easjk4GyFaRm335hk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RnJYalFKZDgwcTBYWFYzOG9zaDNVQTU3bHc3dnFyNk9yWTlUMUhPTnJLMFR5?=
 =?utf-8?B?b3FGV3hvOU8weHdqbXdmQ2c5d0dHWU5USzR4ZFBWTFVlVzZMeWlZSnB6VldU?=
 =?utf-8?B?TjFYTTlpMXBPcCtvWGc2dTlEWVNPQ1g1SC9EK3JUTnFPWmpFNlJhbDRlZStu?=
 =?utf-8?B?b05FYUVnaEQrSjk0ME9FOHhaQVZGbEVkblpUNlh1VldxVFE3Q3RoaTI5M25K?=
 =?utf-8?B?S1FQdkp6dDM1ZTk2VnR5UGdha2c0aXJLa0d0VThEcWJJTUZQS05uQ3A5MlhV?=
 =?utf-8?B?T1dnODBjVE9NVENiMTZkMkt0NXkzZFBOc3I5Zm1ZQ2FoMUxJZDZjMXJkVlZx?=
 =?utf-8?B?VTFFZ090aWw1eUtMNGpYa0htb0IzUWdveklLck40ZlBRdkVsVmNBV2Ivbit4?=
 =?utf-8?B?V08vaWk5Z2FHUnVERFIzN0hFVUlyM0l2T0JFVWZZZnhWSU1oUytnWUJ0Y3Br?=
 =?utf-8?B?QWFZNUttalBzWkE2Yi92NHUxUUcxNkg0dzR1RFB4eUs2dzVibnFxRnIzc3Vv?=
 =?utf-8?B?SHMwNmE5R3V4ODFiNU4rZ3JBTkl3WjNCUXZiOVhieGd2WEdtQmtWMTRtTFRy?=
 =?utf-8?B?QUVLaStDaVZ0dU5tZ2dFYzZHNHVidzFERUgzOXlWWmxzY3NFbngxRUNqdy9E?=
 =?utf-8?B?L2Z4YitMa0t0aDdMNHBucTcvM2FsYnFSU0Q0aU9OVVJPbGdXZUJ6WDJRRDRX?=
 =?utf-8?B?NEJQck9PSlFKYzZQbmZvenhRVGUwV0t1bndjODIrUVBpRTJWWHpXb3hYNjgr?=
 =?utf-8?B?eUhwYlJQNkhSR2NOS0VZbnR6eWFEeWd1bVR6Tml5K0V4bmVqNXdGZ1NTMmlZ?=
 =?utf-8?B?eVpKeFdZWSt6MEdMd0RVTm9WUFI0ZDlXRnZlUmJValZXSTh4UUhBR0N3UkM1?=
 =?utf-8?B?S0xTdXp4VEpxdGRmQmpNQ21hUEU4emZBandPNzdkelphVHYrNkQ1b2RXUDIw?=
 =?utf-8?B?ZWNIZWErK1p4L2FLRzJtbHVvcjNVOTljQmxqZWMxNW9rVXVjcTZrNmJEUzJQ?=
 =?utf-8?B?d3lPRHhwWG53cTJROG5rd2k4Mkhabm95SEYvVDArS2VUWjZaNXdZQ0xkSExn?=
 =?utf-8?B?NkpBckplWWhBYTdUMG9vVVFvLzF5Y1NsQ0NqSUlYckxTc29ZQTBydG15c05h?=
 =?utf-8?B?eTQ2K2I4cmRHOEZoUkg0eFl3QlIyMVFRTlNMNmRVN1JJR3Q4Q3hDZzNkNXdo?=
 =?utf-8?B?UUV6bUMzOXFXUUVYNTZBSTFpNVREYlhjV1RnVUJlNkdRYlVyaUQ1NjlPaHRq?=
 =?utf-8?B?RkpmUXI4OFpiSWpzWUtSbmUycHQrcjJrbDY2VXNHd1l4dlFnWUV4WWNKRk9X?=
 =?utf-8?B?dnFramdxMUtyTTkrK09RZVYyNTBIakZUYzJaVkt0R0FmTGFXU2J1UTBCamU0?=
 =?utf-8?B?VlNYTEI4cjBCM3V1c3pHSEVFUnE2VEo1RFMrYnpWSit6VEZTaXV5bU5wRldT?=
 =?utf-8?B?dXFYR0dtbTVEbHhqT2FtbzdWaVZMaGNia2tPc3VjUnU2MkcvaHVTeFhwSXd0?=
 =?utf-8?B?Nk1KUlBRZ2NneVRtaU1idEJiczZtd1JvRStaY2lHM3YzVE9ZR1ZPLzV4anE3?=
 =?utf-8?B?Q0NOUmErMURUOXdRRHRmOVVOZWU4bzVUL1NpdVoyMm1lK09udzBLZDJubkt0?=
 =?utf-8?B?Nkc0Q1pEZE5MeDh1T21FRFNBNm9GcjJIOFZHRGFweEFjMUFja2tGS0dpNmpk?=
 =?utf-8?B?K3BMR29ETm5yTlFEMlJwYkNMeTZtdWFzZjFZN25TSjF1WDh1KzFCNUpBejU4?=
 =?utf-8?B?Z283bUQrYmxkMnQ4VHh5aDNaVnd0NFc1OE90UHRZSzBNRGxtdVBrbVpvUXd6?=
 =?utf-8?B?Tkk2YUh6bmhEOHhoeEtKV09aQUdYeHdydnZTUjZ2TmZtVklwaE4rcklDeWE5?=
 =?utf-8?B?ZGF4cks4dEx5bW1EZXJKN09WUFhFRVFNQkVxN2h1VFRzTGdQNG9zRnBuQjdi?=
 =?utf-8?B?TFE4TGZLNitTSVZJWUFxSWd4VjVONlk1eHNXZ3ZNNlpyMGpjVFVObE5KRXZB?=
 =?utf-8?B?WHBwdklPUW02dHRhSXdlY1h4aFN0ejFuQWVOemkwWXNkb3ZTbWpGRmdQcE5w?=
 =?utf-8?B?ZmlhM010cU01NTF4UmJiT2hVZGppSkoxZGZ2bFlZTmZyOTZDM2VyTktDZmVk?=
 =?utf-8?B?RHVnNm1yTVRIa3hldENDYS9SUVpJc284b2dZWlFuOHovL0ttVFJqWjFpUWJj?=
 =?utf-8?B?YXhCN2s1Yk9IdjZpd1U3Q1NUVUpIUUFIbElRbi9jbDFiUUtGTXRJVzNQYSs1?=
 =?utf-8?B?ZTI2RnlFN3RoMGhpVm1TN3hDUU5laVBnYisvL0MzMXRkYy90NGVJUGxzcTg0?=
 =?utf-8?B?bCtPN1NRbklSY2FnSWJOOHZPUUZsZzBqeVppMjVmTCtXcjBHTW1NQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fdb01c8-3c37-452f-dd66-08df17b9d462
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 08:25:01.2640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9WaCA4kurV8w/RFg+kqeA7FoL/iaBMQij9jDrQuN0WFwmf34kv7ACOfHgQR0amLzGhS/hUUi0niFjZndgz4KuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7968


> [You don't often get email from peng.fan@oss.nxp.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>
> From: Peng Fan <peng.fan@nxp.com>
>
> Convert open-coded if/else with set_bit/clear_bit to the assign_bit API.
>
> Signed-off-by: Peng Fan <peng.fan@nxp.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   drivers/dax/super.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 45f84b0eb909..60c4aec52ae1 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -385,10 +385,7 @@ EXPORT_SYMBOL_GPL(dax_flush);
>
>   void dax_write_cache(struct dax_device *dax_dev, bool wc)
>   {
> -       if (wc)
> -               set_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
> -       else
> -               clear_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
> +       assign_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags, wc);
>   }
>   EXPORT_SYMBOL_GPL(dax_write_cache);
>
> --
> 2.51.0
>
>
