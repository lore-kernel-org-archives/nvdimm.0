Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012017.outbound.protection.outlook.com [52.101.53.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CCE379C3B
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 08:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779957209; cv=fail; b=NHpiq/8ExfFRTiko6j5dq7rCsOj7hRUqo72XxryUUvK1rtRDGwSaz6e4gw1xmX23+wxGz0uLqye1SWMwaZeqIcyD/MxqsPRH1IGUprBP1QBR5WuOf8/DLju18QuxPMxP5eOkgfYP65DsZjJ/WmXphZgKDGS24ksMjhK3uu6ZcJ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779957209; c=relaxed/simple;
	bh=GTJ25p0KsHP1QuVnlpX/QFtqpZMPCHH6BOQk1/OipHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Yl3hbC2vwUW93lKJ/7eYam1d+AkINZghwZhLfeHzcQEcJh9DdV9aPNw74IIeuFR3H1J80T/ADOVeXGgdtX3PsudbLTsHu9DIt3U7CEWJTDIWe1CNm1zYtQrULaBUEOEk+SzfoU9l2c01TBNOreqSwnHFj7pYZsuIxRW3/apYSMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h/5FfWgu; arc=fail smtp.client-ip=52.101.53.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h/5FfWgu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=llv4VqcE2CM7D9g4pdImtz0SzH1Q4kSwthAUMZE6+6IiAxIJaxc7fCIur0WVw5/LN7X8SV5EDwVawMXwpXY94ukKt4T/ltrCeEiWavDacWwGGNnPrlNRBat2cM5S+tjEwbLMVLgj5orH9atT7iExPw4l5jhZ01JhijkmKI310gz1Gg33bJVzUJGh/y/yszldH98ODDa6eiW6QWm7E1a3Y1/ZuJc49d6njmKrlw5Jt104E61yPvNGqylXSmQ6OBMxBoY8vm/HO06mUGzgb7/OndyJwFXZI+VI+jgcX+bS36NG4nqvExKH1qhf4jm3qOsxss2+pANDIhpy6NEMxtt0PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1W5FgpjSQjzKpZ7DVgSFODrVV8lO9otGGuVrWp3wHhM=;
 b=wQrxEHdz8n669pYFL9as+cRVixoOlpK3MMXCabd1K90IiAnuFpgM+tP6p72VvkKme96Wb2XAgxRDy4hJi7lzuprkK0QGBvRUXW25375S7EzaXI4lzizUgez95F3O7dUUYvWrgCLn5yFfBNYvkIVx1Z+/Yfugf+cMnUdSumsXcyfDxwWjGZ84pZ+Wt4aORry50Xel19q3zhvhGlImDBGebrB00GKEu/zjjAi219S4BolaP0iFOGNVtvLPu5t4SWee738e5Mpn9XLL8VtUlGP85Z9AdTF86DV0sO6U9eEtmMyti1xxNMAuhzCWfcUelObX6wdx7zgRokY26gUu/1bkcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1W5FgpjSQjzKpZ7DVgSFODrVV8lO9otGGuVrWp3wHhM=;
 b=h/5FfWguHSekGicBlesfw7duZIuOO0qsYJdlZ9xhe4toMzrfDlaShkDGPLLAIDRlk7r3BIXEUXSyxROY25HhFkswnXKptmEBnpSFsWpywBpMwlhdyJBkNqDnwgjSPNSmUtFHx6SEADs7mZE+1rJV6V8+CBnnZB+KtbuGp1HXNaxs2D7ygRarmsuDlyGpLxiBmnS+wDgm4eB1zJqt/UWbkpxUWBORQ3ssFsRbWwV6hJUVGsB4zZ6rk9Ct379g4Vi2FOPXHGJg8NxCETU9UITgu78PmknvNmvImccZKhmiwRNxMLwWwpHXMcHvOEo8yGXijuKC/j57r75LG10+n4eNNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by SN7PR12MB7346.namprd12.prod.outlook.com (2603:10b6:806:299::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Thu, 28 May
 2026 08:33:24 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 08:33:24 +0000
Date: Thu, 28 May 2026 16:33:11 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Tomasz Wolski <tomasz.wolski@fujitsu.com>
Cc: smita.koralahallichannabasappa@amd.com, alison.schofield@intel.com, 
	dan.j.williams@intel.com, linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, nvdimm@lists.linux.dev, 
	ardb@kernel.org, benjamin.cheatham@amd.com, dave.jiang@intel.com, 
	jonathan.cameron@huawei.com
Subject: Re: [PATCH v3] dax/bus: Upgrade resource conflict message to
 dev_err() in alloc_dax_region()
Message-ID: <ahf9nC7CK3_1xZmZ@MWDK4CY14F>
References: <20260528064546.23362-1-tomasz.wolski@fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260528064546.23362-1-tomasz.wolski@fujitsu.com>
X-ClientProxiedBy: SI2P153CA0031.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::7)
 To BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|SN7PR12MB7346:EE_
X-MS-Office365-Filtering-Correlation-Id: af9a4179-2723-4701-d970-08debc93c579
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|11063799006|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	lNCuU+QRE7LCC7FQBHHS3Tvz2hHBHujdeb/ERjAZLidecZ2G5m1Jy4N5CsSYrHRkZUWUz/rjvMYQwk04maZaDj6cFTOOExAHnf1RJ5bu8w0N+rfN54T890bODXBII6WJk5eBFIK8FvwamMWzZMfvZkEhkmhbRq/oGyUThP7hWP43Zu1dX6DVRr3UE/8hvbjAxwHSkKgrQjnYFVbsEHnbN339g0gpKFM7qbK09rqm9ZlZZFNt5f7cCmlTEjB5caRGZTWuDkz05YBLa7ZeSAh3yPGF3xWzk+bY0RVm8zRgBBW+KwKsapSU3p7RTCde17IAoLeA+W0Kzk8qAu+YROBBrdZ+T18vevEdKWfVgA4xWZXEtMFxOG4a84DPPYnbNvoCBRbohz4VbCQRqjfnc0gKoKeJnh7nxO+4Bdj3b88yTMrANjCLXRh4Y7bVTjpV1x+yIOuHXhVw4livfOcJ99nqvVEXcPK6XMHZybIpQiaNlOM8k7Yhzqkx/Qy5VqeK5IUPUofVrmxacj564FA0Wu1A1ROjFr0alVQ5TrwdqPvfGBCaXHOw8EVz9UJHlLaZk5KFxUgRLTvV81Nik8+cV3W0Z9Kl5OvtR7j2kx7rSl2BHV4cncs0D+a00k9NtFtZcQP+HQTOSNb4/+GwJr8Dmrj+NPaU0qVDyjTWJAWyG3Dp9UAa31Z1IdpnB5gBZ/KGI5ZNOkmJF1HEI4NPCzDQFHXtLA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aWhTOU1EOEVkSmFPYzBEVlN0bHVrRkRyd3hsUzV1Q1RKa3FML1FyVWRuSFQy?=
 =?utf-8?B?TTcrZG5NbHBOSVJtUGViNE41bElUVU53N2hjU1hzMnNlKzNXZzVLa0k2eGlM?=
 =?utf-8?B?YUF1Q1hkNmVzaENrUmRLaHNMMHo2RkxUYTJHZDR4RnRzYWt4aDZEbEl4NElT?=
 =?utf-8?B?VCtBUUlIRVNMV21UWEYyYi9BaGlhamp3eVozOFBWdVk5NEl4eUFlaWRNejhq?=
 =?utf-8?B?dGVWQndNMjFhUGRqSHVtcjUySVBCOHY2eEJuVlB0OUY2aDBGdlFhT1gwYXk1?=
 =?utf-8?B?eVBMQUV1bkxWdkJLUEFsdWg4Q2VONTVhS21BNnVGRkppZW01UmxsTTliSFBs?=
 =?utf-8?B?allLVkZicWRzUWo5Wm5zdWhCdU5YZWcrMDlsN05OTDRrU2dZak1YaVRDTjYz?=
 =?utf-8?B?OWlYM1UwSFJuWmg2QWxsUjFMeHNUaElzbEJoemxoWllNUEE0VGdEOGNZVkVr?=
 =?utf-8?B?YmVzN3owQVhFYWlXTVdCUDJNUUJSWm15dm1rZTRYYU1KMXlNNndWSWpsaXlS?=
 =?utf-8?B?eHdDeEgvbEZqTmJjcndDVDVuSCtiRktYdnhZTFpWc1ZnNk1PMndHV0l3NXoz?=
 =?utf-8?B?R2p4K0oyaWFVS0tiMlRqWXZqbVNDTDFia2dieEpwbHAvNThvMXdPeHprMzdp?=
 =?utf-8?B?VjVQWG9UK0FwL3VUR1F3V21ENlhoWGZWRlhpK0J2ZVNCNVhFZ1lGSXV5VThX?=
 =?utf-8?B?L1VVQzBFQzRzTG5XOFpIbjdBMUdHTEwrZFQwYVV3cUZ1dWpBZk8vRXF5bFNY?=
 =?utf-8?B?MSt1dlFtQUNpQWR4a1VLcDVjeTdVbGJIVzRIRlpwVktFT3NxYUhHVTRFbnh0?=
 =?utf-8?B?bDlxb1Rqd2xJVjVHOXJRSTFjK3dOVURNeUUwL1BTdFV2WHU0UFJ3WUt4Z3Jy?=
 =?utf-8?B?VzB0czdZWFRDeTU5K2Q2V2tJVWI1aHB4UERtR25SRUx3dGh0UWFEZ1pLV2Ix?=
 =?utf-8?B?MmtBRUp6a21VV1dmVHdEOEZiRUd3VHNZMU9NdXB6NUFJK1RBT3hqbnQ4MUJl?=
 =?utf-8?B?ejkzOHRrOW13bjJEckNSRHFZK29yRHIrRVlYYjhCQWlXTGljQWtsN0thYmJF?=
 =?utf-8?B?WjZicWh2aVZYdEJiOWFONm0yWVFIUXRUTFdDb2E2aFVnVFlMTFlKNjV3UzNV?=
 =?utf-8?B?TytacVgwaGtTYjZyTklmY0MxanQxRThZejJwd3BpdlJ4ekkvbndSVmpPL0Z4?=
 =?utf-8?B?SC9UdlAvamRDUFpkbG9DQnBpMitHTngyK2tiWWV5YVZUNzZxR1pjc3RIbmww?=
 =?utf-8?B?T2FzRmtkdEVmZjVpcVhPVXFFeGFMQnNsL0ZzWU5DdFZwV2dSRTN5bVVJL1dQ?=
 =?utf-8?B?d3RpZHVYYmJCbEswcDZLVTRMUWkwQ2lRM0tmd1pUWDk4Nk1lSXE2clhGWWw0?=
 =?utf-8?B?bTlFb2hqQmJNRkpLTkVYRERGNzdQQTVmTi9CZmwrNUx2R0lNdXMwNGhqYWpr?=
 =?utf-8?B?T2tKUnlwcU9iU09qbnhueGFUV05naGE5RW85YzU2K1Qrdkw2Q2o1U3J4U2I0?=
 =?utf-8?B?ZVFpNDBSbE9nSm8xSUtXUU95bHNCMlVHSEUycEdLZmRkRjdyQ1l6WUZhUnk4?=
 =?utf-8?B?Ym9ja3FLaXdWQWw0NmJmbWJRTzBjNGwyV21Ud2xnd1V6SUpsbmIrN1QxcGRR?=
 =?utf-8?B?bElBeWl6WmN3M2hSU3RlYnhGL0hrLzFsTHVOcUhTamsyMTVDd1A3VGkrTzk4?=
 =?utf-8?B?eGZqWHVnT0YybzMrZVNubFRtemQwWDJZeVoxSGVFZml4OVNUdU45dUVjN1Yz?=
 =?utf-8?B?V1pCS0JwbUdSS1hkZ0xEZ0JRaXVTUkZlUGw4ZkRQcWZnQVVqcWpOTzZDTml4?=
 =?utf-8?B?RzZaMGxjclJEaFRBVlJ5cFkrMnNXWnR4Y3Y1bkdvc29weGxrV0lLeEVsSG1U?=
 =?utf-8?B?OUdva0NtR3RscGtqNmdyUTEyYkdZcEkrU2Y4bDc3bllZNUdMaE00SGhYUE5v?=
 =?utf-8?B?TWZGTUkvOU90dlVOMTg2Y1RRbWNPa3FON2YzQWp2bURPYlMzbnVDL1hIRUNL?=
 =?utf-8?B?N2RwQWRNTEQ0eGJNNElOTDlUKzBxUW5FTDhaTkJVRFZNU1hmRFJYYmQ4OVYz?=
 =?utf-8?B?VHNheExsdXlxR1dYS0hpd05pVGNoSVJNTWlLVVpUSitDOGtoWEowZkxxb3ZR?=
 =?utf-8?B?RUxoa0RXbXdKUm5yTGdrMnJra3g4MytPSUpqZU1MdzlBSGVuZWtJU1MvRC9W?=
 =?utf-8?B?S3NkSmZjTkxWYXVLL0dXQlpmRmFkK1FLaW9WYmxTcXZGQndOaWxQckF0L2FN?=
 =?utf-8?B?WHNZU1B1ZEF1aWtSUGFDeWZnbFhYM3VuN1NockhQcmdFenhMUnV0bVBKVTVj?=
 =?utf-8?B?cFNpd29PN3JsRU0yZ1UxdFBrVFJTbDY2WFpQckVVZmJFZjFvTllaQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af9a4179-2723-4701-d970-08debc93c579
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 08:33:23.7333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +37v8DQsfXB0cw8awawW0CL1kRBuccUynsZXFiZEPJBtC/eHtprFlkm44zy7+f+UaHGG7O476+VQE/UAtJgzeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7346

On Thu, May 28, 2026 at 08:45:46AM +0800, Tomasz Wolski wrote:
> The dax_region resource conflict in alloc_dax_region() indicates a
> serious configuration problem — two subsystems (e.g. dax_hmem and
> dax_cxl) are attempting to register overlapping address ranges. This is
> not a transient or debug-level condition; it represents a genuine
> resource conflict that an administrator needs to be aware of.
> 
> Promote the log level from dev_dbg() to dev_err() so that the conflict
> is visible by default without requiring dynamic debug to be enabled.
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Link: https://lore.kernel.org/linux-cxl/69c1a8d1c0fa9_7ee3100a1@dwillia2-mobl4.notmuch/
> Signed-off-by: Tomasz Wolski <tomasz.wolski@fujitsu.com>
> ---
>  drivers/dax/bus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 68437c05e21d..cd963eeeef7b 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -672,7 +672,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  
>  	rc = request_resource(&dax_regions, &dax_region->res);
>  	if (rc) {
> -		dev_dbg(parent, "dax_region resource conflict for %pR\n",
> +		dev_err(parent, "dax_region resource conflict for %pR\n",
>  			&dax_region->res);
>  		goto err_res;
>  	}
> -- 
> 2.47.3
>

Reviewed-by: Richard Cheng <icheng@nvidia.com>

Best regards,
Richard Cheng. 
