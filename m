Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011016.outbound.protection.outlook.com [40.93.194.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122563B8111
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 10:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783591948; cv=fail; b=U9lFSAOmGQj5LkuEsK+VEsbptmBXFYOyBRJ3mnm81Ih+wQVQF/ff0qF1dDNTb+LrG3PmNXfr9ZbFJAzUK1VO4qqVZOA0ajc7/mRQTszJ4CRrgYAxHAixlAj24RfaJIN9AtAikCJoNPsspFzOtqDVPAgIIsKqw5LuXSFAHwq/Wec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783591948; c=relaxed/simple;
	bh=QyYlYybwC/gW0ZmPnP2Jjmfx6iAl1YLKZznNG4N+kuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TiQXNA4ydCENsA17/OQOgT31YE1WpUeihbGw/wAzQUSuR0vTjVphFhOpLPwzCUGd06TsXpL4QmSzO+GJ92DhakhM48FiW2VYcLq2eYqZZcJaIC3AAR278MC9UWDB4+hpDWsbiIBdZkYcOtGpGK8p0JuXkAfiFLi4WBqHBEwKY4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EZOmCONK; arc=fail smtp.client-ip=40.93.194.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EZOmCONK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=riUF5zSOTVPOs5Aw0g+D+6D1dCFVX2UZFPVFumGdhs1abNSKvFmM4xx4wNK6sKZMxQSOS7ASE2s6ql1HjkqutepkjRpnRLvtADYp4KXW3GQnEF9YSTpH8er1C6VRwE9DE3cX2p3FM7dRjhstywKuzVmP5TbICv+gWw//Fe6Y0eP6/1cE5tFPaHd86e74YEsLA1RShFDCfBE82ry5EKY/ntc4zP4E9/dN6JzLIGN8PBOnkwq1pqQdZdh6ooZcuIEoN8v3QXoLkOvSr5E8Gvptglv8di0B2bHLgIeS6MWxRUFc9pMoVirq5ddfj6gQ9ifMfrYO4i2vM6G4/jZFQ3DQ6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OLu9lORoWgTl+JhM0rTkHw/oKGnZ3CPFcFQS8qV6fic=;
 b=o1Ir6wuUd8uu6FrthWL/0rg1wnBPaqYK83HWhUVPfd3yxeA46wF/hT8TC0g7SEzgEi5AHJpDbybdsuq66bj9xqnpLMIpYAHq5NzsF3yps4gusyOXQ5HC0993ifOQ6f2ERkoX12ZIdX7QlQcbHKIi6/rmS1weVkFuWRO1FMX9kDSlYUoeQ5pOFU2mCto34cCkL7kWVTp3my5t9FQsvMuCcxsg0jYZ/HMo1Ft7QwD0+BN7gN3xZ+bHEazCB9i9xyWa6w07Bd/i+n94BL/uHtpJTqxAiHGf7Z1SbROmPq/1Guuj/X42SoiDIjeYDT+Ul3KOBXyjVpaJEYAf5xFnAX7NNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLu9lORoWgTl+JhM0rTkHw/oKGnZ3CPFcFQS8qV6fic=;
 b=EZOmCONKNr5ZP0ytTV5+S2vVhOSxvj0l6/kt9IvaOfUOjqJquFqucnunNt/8r1LzH+ULhmoYw0fpOK93mV0E0MS1BtdGn/bMMmbigNHn0SwfZk4i8fz5RSy6LehC7n5it9hZEEzuyhfdSbINF6hGYLT2qPvw8YuZ2Bt3wJIVenVsI9SuwR2Jw0b0rvQHVO8PXZDKarcXG3aDw4ZJRU920n+mHHiYN5TMC8r9607ur7MBATxk8SYw9eByLehe5FnODSJhJgF0Cb0xasnhDnlx+yOf1amisDhYIVz+CrooVVjKSLs21+O5QOFhgLaWa0UJkUPbUqan6KtSGGsH9+yf4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by DM6PR12MB4187.namprd12.prod.outlook.com (2603:10b6:5:212::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Thu, 9 Jul
 2026 10:12:22 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 10:12:22 +0000
Date: Thu, 9 Jul 2026 18:12:17 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH] test/cxl-poison.sh: test scanning past fully
 mapped partitions
Message-ID: <ak9yQtGEvMWruPhV@MWDK4CY14F>
References: <20260701044205.1589967-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701044205.1589967-1-alison.schofield@intel.com>
X-ClientProxiedBy: TP0P295CA0036.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::15) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|DM6PR12MB4187:EE_
X-MS-Office365-Filtering-Correlation-Id: 55172e93-be11-4aec-c5cd-08dedda290f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|5023799004|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Mt2L2fzRV1qRFs6Cb+2xkb0yY1CEVqjD3lx8dJo8cN+rLoMR5lAAlhHx0MlvOQqq6SAEZi1lLvRl4oQDwqm/npCxvBbCKwfYjo9YrXuq93nXJ6LVR5UszQXazqHvGyD0z3+ik1UQku8nh6c/846Bb2wecV4LRD+vXWD58EWzB0jTpAYbmSKxtrE69WjD+ViNFfruBvHr3S0E1gF5+iUWeAFE7ZqUbRFQrNyYHa+ie7J+TYjo3FemjA6L5wcvH233ErtKKm1+roGdc+Q/Zd1rkyVy116WzWxD40skkGTW0E3Zna/MPbsAzk35mjQ3kBBdu8b1IIasIfnDSvNcqVKxmOJ3LKKwaxmcYi+v3qEHi0v4kiQqqarJTHdG/98FJivLd/CahGeAizMJK9n3iKUnReOlYDQlMOvCamwje5ftQ41ZcFgSA5m/DTG3NsPiI7DdCyhjEGx+9G+dtIOgnIP9jmDkFUS1gnf1H4lKH2mWxLSDwmFv73kdm8B4jHgnE4v3naic3xGQ4ldDBRrlRuDrI/RJwA/Da4sYu1OoNigGn6jjaA+md4IhEXFmUthaR7qmt4RFayD71WnsPeo3faPXs8oHQL8Oi5yM7960uuJWYdS/+Pzom4mfcP+DEI9NaG2yOJfWSPw1OgEnOT9et3/A3tmNuVkuaN2LGLGgdHQvUYo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(5023799004)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8qR2c6jPoWQe9xq3zFufQSVGBh2sdrQMdBP3eD6ivlf/0wR5wmY8Ao3nr0Vl?=
 =?us-ascii?Q?2ad6B1xIJdcq18c0hVL3QlSZZxVtnQZsqsJi3SOOXzlB9pb5gfUkNVjnDIvE?=
 =?us-ascii?Q?FhmBUWw42NFZtpcLRJFsrxQ/IBJK0EfSyn76w5RETajwy3pcOnHFIoqUMLOA?=
 =?us-ascii?Q?xqmM77e2WtmvxLDz2/U56kFvdHhbYXUVPdWFe4jVswBznz7SZJSTpz4fcl6J?=
 =?us-ascii?Q?CGmX2UoHTsPCJ/YF+4+O+obGEwhdGGPxnxQCBwYJwxXrBA+1LalBoWD247N5?=
 =?us-ascii?Q?qC+jEIqcgdOmCdFOb08lFPH6kxoZz8bjBJtPIz+klw3n9cueldvLdN3EIClN?=
 =?us-ascii?Q?UmcDcFfQpGtfZyPbUOiYVJAS4ZsuRnNI9b3MFJVs4q2pj3E7V5r0VoE0WUYL?=
 =?us-ascii?Q?05WB0dyCM4mAx8U3gJQFmz4HxRWN+ptfMCd4Gf4/9aNjd586U1rxM/va/2rG?=
 =?us-ascii?Q?wzVSByEeKvEhcoNWcTqjnlR5tooTeA2minZFt3SfZwmge8uoSmMj6d/0mTep?=
 =?us-ascii?Q?y/r2iuuBQtj5q7F/jqK/pVlUp9iO7AfTWqoqwOtxM9sU9zAJzovXI7CYUR5+?=
 =?us-ascii?Q?axEvKqBAfZc3e+gGKq8pkJdbCT9CfxnVXLr/BtZfjcj3bpOj6e2PpvgdDKeN?=
 =?us-ascii?Q?K9wyDyYI7KFq1bFIXqqVLfUeukJLrnoUi+SJmheBYWfo1cB/een/7TFTxYJS?=
 =?us-ascii?Q?RLIG5H0FuKKDGXIt1pVdOD0DV3nCijfz56gQxQdLM1OVi9CVbL4ci7E31YS0?=
 =?us-ascii?Q?vx3IIVDckf4aZb1dAi9+jna3CvIsVhuCKk2O4WIkILIOAR8zBz1/08oarvdT?=
 =?us-ascii?Q?o/6JjkkyAwLamzOQV6Ljx9BXiJIjC8FCnYTlY8LZVvcLq+R430Kee+Bzporh?=
 =?us-ascii?Q?EgOnfv5QAMZ7loT1gdstvI/cRXmTaj5Uhr4u+teweIrwHdQKPQT0JYFfGCuf?=
 =?us-ascii?Q?rOy37+TT2jbb91ThhR9ILgr8C2WcbEvFWe7cRPtM0agfWNbZoOC+iH/SASpw?=
 =?us-ascii?Q?Rqr5gkiIWAXO6VwEhWz/hIrhPv+6dmbYmyjyVK4SEBCqJE97bK8BdoT/7lq9?=
 =?us-ascii?Q?IFAnXCW6GAjiND4O2+fDuiQxiCKNi/uwJpmkyREruwS+kbox2MWioSES3rQ+?=
 =?us-ascii?Q?L3PlX+fyBcTpNptdF9Co0HgAh+jVfE3eLTKCpZjDerh+HJ26b/31KLpbIZuB?=
 =?us-ascii?Q?Go9Q58PDEy9SpBroktiGu7FOZODzplBloHIO9Tn6R1mT025TpjYYKbN88qQj?=
 =?us-ascii?Q?Ymkn/50o7bPS3LHzrYJhCup4nttL9RdyAFteT6NMjMeD8V1YSTeyuFPFCxQm?=
 =?us-ascii?Q?I74T0rpbnxcNnSSoFOzFmTRiVzOMMP9yJNCxFHHKblVYRRhWn2EC722Trr3l?=
 =?us-ascii?Q?OuyW15TvwyLWouTmSEM79lDb/kx+yPpES4RnlTUiRVU9fM1MGcQQioneDgrH?=
 =?us-ascii?Q?AGTyODOf0bqwRq6sQzOd+lUAMKOBk0kBr9YDfG3PzL5dmx/dg5VF1Do/Kl+8?=
 =?us-ascii?Q?ldgoi8hotL9f4gEaDCC+goFbPJLAZco6uzIKgOhLVoDQEAwg60wMvZy84fq0?=
 =?us-ascii?Q?UXVSxZMtA7ZCU7ymSOCujBUCNl/NIl6Tug+yTm4HYCEGBGxQcbGdC5c18BcA?=
 =?us-ascii?Q?/MG6X2UK3HM5c/2XToaWX4i46ye+OuF5t1yFZKGhTqrHMz/igiOTyEeVTpmL?=
 =?us-ascii?Q?rpxFVCDZL2yIaxmLoh3Qzgh/W8DI6T3cZoU/e6fmcM5OxWpP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55172e93-be11-4aec-c5cd-08dedda290f9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 10:12:22.3276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XD+NW7/nXxlscHWxv2CkWGXsm9kHR8LT5qmGHTxy9debgCvpe3qQSgYmCpGv3YTpubq8JxuBokD0I62TGgVqHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4187

On Tue, Jun 30, 2026 at 09:42:02PM +0800, Alison Schofield wrote:
> Listing poison by memdev scans the unmapped tail of every partition.
> When an earlier partition is fully mapped, its tail is zero length, but
> the scan must continue to later partitions. A regression caused the
> scan to stop at the first fully-mapped partition, leaving later
> partitions unscanned.
> 
> Backstop that behavior with a test case that fully maps a memdev's RAM
> partition so its unmapped tail is zero length, then injects poison into
> the unmapped PMEM partition that follows. The PMEM poison is only
> reported if the scan continues past the fully-mapped RAM partition.
>

Hi Alison,

Thanks for this ! I ran it against cxl_test in the following ways.

On a kernel with the fix [1], the test passes in both run_poison_test passes:
1 poison record found after inject at the first pmem DPA, 0 after clear.

On a kernel without the fix, it fails exactly at the "1 poison records expected, 0 found"
assertion, so it catches the regression as intended.

Just one small thing below.

 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  test/cxl-poison.sh | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
> index 49aa1b68c5c1..a03e08084eb4 100644
> --- a/test/cxl-poison.sh
> +++ b/test/cxl-poison.sh
> @@ -219,6 +219,45 @@ test_poison_by_region_offset_negative()
>  	clear_poison "$region" "$large_offset" true
>  }
>  
> +# Backstop a driver fix where a fully mapped partition prematurely
> +# terminated the unmapped poison scan.
> +test_poison_unmapped_later_partition()
> +{
> +	local decoder ram_size pmem_dpa
> +

"region" is assigned below but not declared local like the others.
Does it have any reason for it to not be local var?
It might be harmless today but tests added after this one will inherit
a stale global region, if it ever uses one.

Tested-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Richard Cheng <icheng@nvidia.com>

[1]:
https://lore.kernel.org/linux-cxl/20260708074228.43654-3-icheng@nvidia.com/

Best regards,
Richard Cheng.

> +	check_min_kver "7.3" || return 0
> +
> +	# Free the auto region to use the ram capacity
> +	$CXL destroy-region -f -b "$CXL_TEST_BUS" all
> +
> +	find_memdev
> +
> +	# Fully map the ram partition so it has a zero-length unmapped tail
> +	decoder=$($CXL list -b "$CXL_TEST_BUS" -D -d root -m "$memdev" |
> +		  jq -r ".[] |
> +		  select(.volatile_capable == true) |
> +		  select(.nr_targets == 1) |
> +		  .decoder")
> +	[[ -n "$decoder" && "$decoder" != "null" ]] ||
> +		do_skip "no x1 volatile decoder found"
> +
> +	ram_size=$($CXL list -m "$memdev" | jq -r ".[0].ram_size")
> +	[[ -n "$ram_size" && "$ram_size" != "null" ]] || err "$LINENO"
> +
> +	region=$($CXL create-region -t ram -d "$decoder" -m "$memdev" \
> +		 -s "$ram_size" | jq -r ".region")
> +	[[ -n "$region" && "$region" != "null" ]] || err "$LINENO"
> +
> +	# Poison the unmapped pmem tail
> +	pmem_dpa=$ram_size
> +	inject_poison "$memdev" "$pmem_dpa"
> +	validate_poison_found "-m $memdev" 1
> +	clear_poison "$memdev" "$pmem_dpa"
> +	validate_poison_found "-m $memdev" 0
> +
> +	$CXL destroy-region -f -b "$CXL_TEST_BUS" "$region"
> +}
> +
>  is_unaligned() {
>  	local region=$1
>  	local hbiw=$2
> @@ -332,6 +371,7 @@ run_poison_test()
>  		do_skip "test cases requires inject by region kernel support"
>  	test_poison_by_region_offset
>  	test_poison_by_region_offset_negative
> +	test_poison_unmapped_later_partition
>  }
>  
>  modprobe -r cxl_test
> 
> base-commit: 15e932c4e1318a9608ad9b799ad83a32a8b5970d
> -- 
> 2.37.3
> 
