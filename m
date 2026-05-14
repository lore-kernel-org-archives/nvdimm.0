Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012044.outbound.protection.outlook.com [52.101.48.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0883B1006
	for <nvdimm@lists.linux.dev>; Thu, 14 May 2026 10:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778753600; cv=fail; b=rD21aB1WwLVFYc28VDuAZKNKNzesbq/1UOYrbS3mB5N3l3EUSXZ2X4KPRsA0paVlRGeGoZGveo7Ej6WQt5VMlTWLRf/PCMauNM06w5gaHRN+7YGMhg5nYDQSgaWSglaeROUL1m1zThm89S2ME7dDutxx72+R0v/0rtD1tfnaxi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778753600; c=relaxed/simple;
	bh=nAZpjoOJc9o8+YcjnBCm8AlnUtCOJx4q/fyv7GBOc8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mbrYf8C8srOPJLpreaF6O4uTJytLHYiy7Fi7foa+GEuLxzVQuSAa1GF6I5SWXg003pojxuE5gQ0XaUlHXG8RJfrKDiDrmhOvn8jsKT/1TYnULDrs4CahrAdHwHc4W1M0RiJAxGjJxfv+FpoI5iYUC61TRnlei89DvEfbvJq57HU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ri/Q0fkk; arc=fail smtp.client-ip=52.101.48.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ri/Q0fkk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ndvrnvPyfgoZcoPE6/W5GwZc6yGNpOx6FRCAz6uGhnC6NLGcsRYF5NP5Po45gdS+xGOr02aSX6WWtPTWzVoYtEQSj+DCG7FXIT0MF/AjBldtaF8aCAC1bxjGlaWzebD8h84VSjymzS0Z/D1zyDVa3TZsKB+223jvFX/g5UuTOVA1REX8kN9qonOvKKL/dpCfRuj2KblR7Lg8e+TWOaH9NUXKyMBdVw0gYBOlxKengiA9iuOwnD/QaTNdlQVfO7pIGQWyrmf9ic1qQ4M1Xx7a6bqQzDQxIpRsxB3Dkym6bwItv5wzYL9cKwx6kybcrJjcGv/4sZVvOSiO3QA4+XMaHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q1U+UTcyD8zP3yjinm/AtATzgh+q9Q4nvohZr/FPu6Q=;
 b=mkvgTZc5iU8SiZjo2JKmJTiNlwucmSt6tbCysjzHivWFoH79ldDqR0hGUR8AzxFM9fQGrZ13H7eHKm0wDQDCuCdS4gz7YNYyXWmd9C4S5NURCY0m8JDPn8zNgpU3Z4xdjvfh8mxbj+fvVf+MHWSq4OfrNuZzxS44j3PmOm47qftPoTGS9W3bbq+f4HQHV4BijGarnxqN8U5Rf8W5AzEDC1EjIj3x9/XQvZsRZhULgg39IHaRcOGU6I4hdaXmrbJFv67WDNWwNH6mnYCpbZZxXJLh5l1fJYjCru+7bfqK4oOVrskENIOXMJEWzKVzlCGJ1cTrHLJ4HEW5u5R5cw3pVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1U+UTcyD8zP3yjinm/AtATzgh+q9Q4nvohZr/FPu6Q=;
 b=Ri/Q0fkkrdc6L318Hm2USEaTIveA/KZBv7MM7eMGfO2uaDgbu9SOYB4j1AcxKC3LW6RbB5+emfM+jMtl3S/9NxpsK25UNaa/4PeYorbKZGYEbFymEbg2+3LMZn8CwnI2VlIwPdpQnGMQE20nGa8GPSBPFv0tL9Mt67US7q97YzxzwcQhRiEQqPXbMnUJrg/KPE6Hs/xKZVXgnveV4E8h2C4VvItEyYryZIdPmPInGOh9sqyU8DU5FXEoAw59u7hl1EEfE/6Yd83C5adDtUL6ojrLIfWA/n9Ts6fltn/IMBdLqzgpb+NoNwQqCpMleLpxwHOFkuMj6eFJkBK0QXHiRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by PH7PR12MB7378.namprd12.prod.outlook.com (2603:10b6:510:20d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Thu, 14 May
 2026 10:13:11 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.20.9913.009; Thu, 14 May 2026
 10:13:11 +0000
Date: Thu, 14 May 2026 18:13:04 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Tomasz Wolski <tomasz.wolski@fujitsu.com>
Cc: smita.koralahallichannabasappa@amd.com, alison.schofield@intel.com, 
	dan.j.williams@intel.com, linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, nvdimm@lists.linux.dev, 
	ardb@kernel.org, benjamin.cheatham@amd.com, dave.jiang@intel.com, 
	jonathan.cameron@huawei.com
Subject: Re: [PATCH] dax/bus: Upgrade resource conflict message to dev_err()
 in alloc_dax_region()
Message-ID: <agWfgLxDeu_duejj@MWDK4CY14F>
References: <20260514093208.13110-1-tomasz.wolski@fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260514093208.13110-1-tomasz.wolski@fujitsu.com>
X-ClientProxiedBy: KL1P15301CA0064.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:3d::7) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|PH7PR12MB7378:EE_
X-MS-Office365-Filtering-Correlation-Id: 59957ad1-86e6-4de3-9483-08deb1a166f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|22082099003|56012099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	Tb5jBZ40tf+cNnZg9/OZYUKTXF8OVDyWlbNF4r6DQ65PLtqlf/2bvhBGqRU+Ebl1jLelHDpVkyo59FIk0OT+GyASVX2xKU8R99KIauBbSy7LVkIGd9ex0AUrfQPbw3xr3ntusGRLPa8ErUWcFFXBiaOiOCCwo+D7o9E3Xh1QFZY+rnVwvlI0E27xtgkys2VVKzVLg1cqwCTEaLx11oHmwfUU1skJantaP4Gnm5u0lVuar/CZMu/x8Lb1sSHT/81bhJeJ27Tw1KqkgcTsNiFxqU0QUSDeByvQ41e/tHNvqm44YIwgwoB+UQB8aIwThAFzU59QgVG78PtX2sw0c2qPZUxdI3oNdAsHsjO2BVOJzpbnxUCr3MdGwAOG3RO7uLvZfbfiO0quspAC3HSS2sNnCbE9hDHgybuW6klVgncdphKISaKI9t8byQBfdoUIWvn7b9Y1SEX7jinRMIXOKPceT52abY0bGOoopIZE67dq24ChEhwTLl7Dx+Kp8vxpZXjp5kDzY2bGwfPP9EO9v7JINvh46mL2w8L886+3Vy/k2gFS5+HGZpNgLfcgz8rWDPep+M7h8XpwavEKaHCbN12Tnh3LnQPRwjtSI4+amhAAlmVmoA2ecqknvp9cGDR/sUEENGdIau2NnLSxrCPrF9e8EHcRieuwGcCmBpaQuxSsVNEamB3jPhmzhPHuzE63QZeYDZ6NQOyZ5+esMzsZ7Ui/Tg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(22082099003)(56012099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUFBeWVoVDdKV0Y1aHNrdlhndWVLYkZsTmk2RSsxdWFRVXBST2VzR2xMTk4y?=
 =?utf-8?B?RmtiUWR0M3lJTjR5SDgxcmtQTnJ0TUV2dUVKeW94WlBpbnlNK3JaSXRUU2ZL?=
 =?utf-8?B?QWJ6OHVZbm91V00rV0pMVWo5ekVWRUN0T01TdlIwRXZFaEE4bTdSRWlObkp3?=
 =?utf-8?B?ek95OC9qN21obkJ0cmYzN3g4UjZmL0s2QXkreTdra3FvZkFkOEJlRVY2Zitm?=
 =?utf-8?B?UkZPZy9WOE5VTmxMNmhaTXBMS1NKYmF4R0JCaXVSV21iTkJwNVlXVDAxNUNY?=
 =?utf-8?B?Vm5UL2dSd1I2dXN4NWtMM0tWTEZpQVZOd01IOVZ4QjRWODA2MjVsb1hIVkly?=
 =?utf-8?B?WlRJbTFFU0F6OTJYdlR5OFNpMWIvOVlDRm5qNHNXQUNRN1ZNN3MxcE90SEo2?=
 =?utf-8?B?eWZrMDRLblE5dnFLTlFNYWVCYmMrTmRUZHhHeUIrd2p2R1lpSm5QdExUNmFs?=
 =?utf-8?B?NElsaWRkWEp4WHpNaGJnMVBWSEwvY0R6blcxaFFYRGE1dEROMDFDNS9xVUI0?=
 =?utf-8?B?YXhHbjZQcCtBbmdPSEtPZzJrMmt4SXdraWthTFdPeEVtVHp5NE1NcWpQRE00?=
 =?utf-8?B?Zm02L21Jc2xEYS95eklRNTZFZHZMaEY0TlRnM1RRc3lrQ0hqY3IwQWJRbURP?=
 =?utf-8?B?K3k3bjRDK2ZEMWhncnlwWmFuLy9pOEdybHJpakRoZjVaUlg1c01DZy9ZUDUy?=
 =?utf-8?B?djVWVXdJSHNqYjJtUzQ5VlExMEVEcERyOGJ2a3FpTFBJT1dhTXh2dHJkd283?=
 =?utf-8?B?R3FhaFJabFVsMDdyVGlCSURPMjd0bG03cm42Q211NmFyVlVtSGszVTZFam1z?=
 =?utf-8?B?Vmh6SmdBTUJ1V004eDVZYnFsSm43SnVSR0Z0WTNPVmdpRlJSSkpkVHB3Vndy?=
 =?utf-8?B?eXBkUjdJOXRPeVZ1YlFMeFhIYnRSdlZJYm85citWVUp2cDBpYUl3RmpZZlRz?=
 =?utf-8?B?c00wK1k4a3hkY1RrbU4wVXJ1MHJxckljZ0RPTDl0dWsvMWhqNUNEQVArZ1E0?=
 =?utf-8?B?NTJ4bXQxNG1qSWNjU005ajBHeklxOHN1Rm8yM3gzL0d6N2h4MFJOc1Eva2ow?=
 =?utf-8?B?NkErb2E3UmFQOWlOOHdTS3NMOTkvZ253MUZYdEJRaHZJYWFuT1F0WXdLNC9O?=
 =?utf-8?B?VmFzS2cwNjF6ZWZacE8xa1pvMTk5NEFPTWxEdkpHSTdDWkg2QklJa3BUQ3BO?=
 =?utf-8?B?YnVIYzNtVkRaZk1QcmxjeGE0Nno3aVdaM0NJSWNXNnQrSWNQMUc0bXh3MlE2?=
 =?utf-8?B?UklLdW5jOFhDNE1DQTFrUnNWNGpRekZseFZkck5JekdTbnpjZW9zNlV5d3Jo?=
 =?utf-8?B?SnVIVUt5NklzZklJQTFBTmExWGRvUHlCRGp0WW5ZUko0V1lBMTNSbEJ4RjV2?=
 =?utf-8?B?REpPRysvZ0hnUzEvSklod21FUDJDRDJwTWwyWWloQ2QvT3plblAzK21vVDJV?=
 =?utf-8?B?cjFoZXpSd3JIZnRzcmNGTmxDSThNY1JOQXpLTWJud1F5VHJCUnV0dnV2eU8x?=
 =?utf-8?B?dEZXbGpleFlhS0JJTXVIbHVUZEpZYlFUblpnaGl0U3pBMXZwalo2R3F4WC9s?=
 =?utf-8?B?RHVidGJscnlTa1orL0FYaHlqcEVUSlJYVSt6V3ZFb1NqbGtBNzM3akp2elJw?=
 =?utf-8?B?VnJaOHpwOEpJYmtpcE1nRHh2LzVDV3BqS0swbExycjNKaHRYdXhXNjRUeEZY?=
 =?utf-8?B?aEVrWHZjS1NnZ1JRV3AyRS8wakFONkNNZGNPVTVGVUpZTmRRQ2liMEJQTGZt?=
 =?utf-8?B?SGthRHoydEk1bDFDaHhIRmk5K0IvM0VxcENBMDdNbmlhNExwRUV3MW5sVUVC?=
 =?utf-8?B?SDl6TlhrTzg0U0wreW9xVXdSVHJZVTNFUVR6Yk1zbmJVc1pPQ2FoUzNKUUhV?=
 =?utf-8?B?blRZOVBlRVJ2ZkNCaVV0NGE0RzRCZ2xpR1pVY0xwdWJBd1JzZjlSNFE5bUZV?=
 =?utf-8?B?SjMzSlpBUFZYeWpHNVdaeWdZQjZidWR5K3NxT1VlSXNVL2o5VG9tTHozVWJo?=
 =?utf-8?B?aDZ5Z0YySzVGNXVrT3ltVXE3ekRnTFVWRGg1WEhvc2dpSElyT1F1RnJyRHly?=
 =?utf-8?B?enF4OGM1NkhYVGtHdi94aW5ucTVrcEhmcjNvV3dxTDVJUTE0U2lVTFJqSy9l?=
 =?utf-8?B?cWNBeWx5RUVKRUZzTCtpU1AyRkZGRVhCbHVtWkM2V2VYNW1VaWFFSmUvZGV2?=
 =?utf-8?B?TTlyandFNjUwUHF6S1lQcDVHV2RNalJzOTkrS1FPWFc4Q0FRK1pyMEs5Vi9y?=
 =?utf-8?B?UkRUakdTMDBDWHQ4djhtZHFUN2FBeWU1cDc1ZWx5SlpISFFXcGlMSFpMdzNr?=
 =?utf-8?B?ZGkzaEFZWlFXMTluN0tlM0hmaXZwRXBvZW1KbzlsR3ArSjJLSUk1Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59957ad1-86e6-4de3-9483-08deb1a166f2
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 10:13:11.1917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WTAfHg7xFI8sxUNHJvP2fXt3BbNQ5Lrv2anoZ/4+B9oAW3U1FpNkYUYeu5A1Yy8ljjz6Vp8kVPZik49SGEQxew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7378

On Thu, May 14, 2026 at 11:32:08AM +0800, Tomasz Wolski wrote:
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
> Fixes: 34f80bb969cc ("dax: Track all dax_region allocations under a global resource tree")
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
>

Hi Tomasz,

Did you run into any kind of error or even machine crashing from this ?
btw, though I am not against the change, I don't think this is a fix, maybe you can consider to remove the Fixes tag.

Best regards,
Richard Cheng.
