Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010023.outbound.protection.outlook.com [52.101.201.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D82470EB3
	for <nvdimm@lists.linux.dev>; Thu,  8 Oct 2026 08:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448449; cv=fail; b=W11Ty9WpVIMnFnRr+zcq4lHkHm36LBMyvupe6rfazmOctqJxAh3779js9S5pt5PTQBiu4FNUr9rcjO95ptkExV1lCIOU0ccR2tTLDqyyk9SqhYyjcp/sDhx8BEiXBBIWrypOnpsyd0K5pviVQGuBaECRXR8aYhVKjyqBx1TXYWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448449; c=relaxed/simple;
	bh=x9K9dh3zltcbDmy6fhG5jp0EZnF7lNtDx80F0CBc7l0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eR/+mdEjHRrsxzN83Eu01b8YBt6Q8dwHjx3+x5bCuw19CNsPGbgKE3n+EXDnByqN01ARXBaBuv7gTUP8rWkQEzSGXCAqlsm+Y+2lCugGlkuH168J5Pud4leh1Y9IxnakrBCIlv+BuCuwRAnUAp02d+HWT3DADHPtHDJz429+7dg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Dc8jTJ/9; arc=fail smtp.client-ip=52.101.201.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Dc8jTJ/9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VMJv5fTduSGUZzeAcSlLe0xpCvfzE3BPiEC7aRY5qsTsa8TviXNbS556KHxjL1hIbs4bJ1PRPPnmfl4E11uZNVd08IAJlJyyE8i+8VwOpIZbdvHl+RB+4uUlPo2zJzFtZtd+efBwgh+y858YRT7spurCZ0Jfg3Qgc27Q29cDQuO5wnvd+xhJe5/I76vcMK7cseFiagdEWW+7FPxccmYE8all0WTGUbKjfhID4OuNIFMJiM10c9yMdExEcx8ltJ7gF/SL+w4Hvpbok+wXASCUhHbUgRpL/I20aP3qdc2q0rBai3B8lFZUGaPoC2CEmj9S6YYmM2CYf77dhGkQmIsYxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XnQ7ZkT6wjsSQZXnUttWqdKs1CEbsCnSYmVUwk3DKFc=;
 b=UifsmqkJsNMaZWVAnQpGkS24pPm7a/4EbBnSv9yljuOwLX0us5tVoYtw9AEpP8MgU+JClfOguj+Es1OjozLwi8WqTF+VgXzxSTR29yw7O5xQ2W0la+ETNuqTROgYDhzRpMyZorOF7DHeiV7LRfH9vABeYOsQwQfzoKdhJo5tMJa6iKNIdSpegQGeaSruaMU9ilbgl50TuLhCRWrEjtit4SFANDjhuQnRKK1xHMUDLp96bhjJ6NmTLrhiAlPpDyefoRLW1H9DCK4CTm/PQ8oIND+U4Pvd3AaxPsTc+o9QOK3/Udw7qzutemn1F+2FDGzU8zyQ5OZ5c0FAb9XPL3IMSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XnQ7ZkT6wjsSQZXnUttWqdKs1CEbsCnSYmVUwk3DKFc=;
 b=Dc8jTJ/9YS9ZAjDKW9q2qjvuIdKGZAFiXtFWb6QdQTHfVQuFBTzz3PXwVfONT7nwpg/oJ6XZA19qWXWE34kfth60EW6vWLTOgYisKhsSC4kZbNyubVUwXV+HHXNLlPrVjMDbkwXCeffnhDI3YD/FhYr3/q+aS+IhbBRFumnxWLDrNwCPP9dS1a9uRitdMnu8XACxxdZfazcinfi7eIP2IZf7kNGxG9066L5NRDwVn4Pn+CDY7M+pQKePXKggFHDQZiTY/G5MpdE74ziDBEx3nobjkYBLnMXvWyDhoGH6MwZl0JVV3AyavYyd2wVi2Pg1glC3VVw5YnqRkVula2wS5A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by BY5PR12MB4212.namprd12.prod.outlook.com (2603:10b6:a03:202::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 08:34:03 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0496.010; Thu, 8 Oct 2026
 08:34:00 +0000
Date: Thu, 8 Oct 2026 16:33:53 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Dan Williams <djbw@kernel.org>, 
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, 
	Ira Weiny <iweiny@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Fan Ni <nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>, 
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Gregory Price <gourry@gourry.net>, 
	Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v15 2/8] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <asdRsFS-Amd6IDws@MWDK4CY14F>
References: <20261007201828.952-1-anisa.su@samsung.com>
 <20261007201828.952-3-anisa.su@samsung.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007201828.952-3-anisa.su@samsung.com>
X-ClientProxiedBy: SI1PR02CA0024.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::12) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|BY5PR12MB4212:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e95c639-dd49-4915-72db-08df2516e6b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|6133799003|18002099003|22082099003|10067099003|3023799007|4143699003|11063799006|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	SRZgJZTZ8tgG4xXZojxBX4SF8MkbXLx9Bss4yz8B9BjRnvGSMdL1w7TBD0XsaZdIUdutUoN8VZZL/tsFcN5nvqZSquuUEBqnS5NexZ0DE43jb2Qz3sQSDSbpJ+d9/K+pHeGhgScxuNU3HCm/WUywOr0vQJpEKGOVDRsRdEg89DL0HsZYCPezlzbMWePXIfkM5DZKF9TuI/f8wfOkrUZtpJW9nHJMkKW4VMnsnRubcCzr5cd8HL41tYsQCPYKWKVjdYqW7jMJgf1kcTsf/zmn3dtO+3MeTCqTbRm6HPr21pofpoI7wiFj1wHsYmjSfMG0/8UaqoScU4cbjcrISZPzNyqae4hurHP6n3wLCKgpUOUShDQ4vAgrWIQIowRy4OM+VY7eweguUu9kvWWXs4vhfbovLDTU/7x4Ys6aWbselmd2UwhKc4ynH5LCsSmVQfJUjqpi30m73qyoB+LXXABjvMax7pqKRux2H5Oqle1W+4KKrDNJXBDSgk/HY/6ItN5t0X/iZkvp7FS+w5CrJnqz5DLkRoQuSpzD14xo2NUujZ9OLmgibMLoLrfShD7Yc7E0uAJaIacyM4Q0DI9LGMJGmzTygAyTFaW9MTntIPNqAR/3q+5OVJmFaVvYbSeoo/fB6uzZh0jwb5I6HPVs/yBrVtALahw2K22pVIdHJkwbXiE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(6133799003)(18002099003)(22082099003)(10067099003)(3023799007)(4143699003)(11063799006)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rC6xfkhPYBpNdATLP3IDCbTLoO9HcxVERXl3G9MvxmTZZx2J3ETXUr6TMm9m?=
 =?us-ascii?Q?J0qU/5/azAdKHBJRrPV1mAy/fQornr8QXFGCuj8leNgJ35qdA7cHVUyWsTUS?=
 =?us-ascii?Q?SYsDJfQSUdm8KFxXicAPzyrwko4qHgsoyrGbtg7b6PtfhY4zBMmy24PnfnJ2?=
 =?us-ascii?Q?m2+L2ZyTacs3FL2rNGAT6anOQWuz7nSFTyMQbX06oeL6NLEDcMKhBY6Z25vX?=
 =?us-ascii?Q?pd6jsSfqbK3OPmru2Fj7AUincBweh7gU1aEJMK5UEO6eix9p7JGwDOqG2MvZ?=
 =?us-ascii?Q?JOKyEge3J50gEZAs9XjIra7EUaNLNozRYgZ7qjStUyRAFxXQjaQrAmk5D0Vy?=
 =?us-ascii?Q?nP9uPvtSLG89ayB+QoTshy4SVMkai3ZU3jPa3msf7xfhUHhS6JYvm58qqF3i?=
 =?us-ascii?Q?nSmYH2poxWfZpZim8NXgGtt1U3Yf40tB1kgIprE+etlRtOT1uwuYVcqCUMl+?=
 =?us-ascii?Q?dUJDJMAcwfM7IrozujstJ6CFhZrg/09+vYSkSV+9B4QVK5zcGqrN1CLngJu5?=
 =?us-ascii?Q?pbdL8lhDYRu1RHy8JSVXdvXqVsGTSmRfgBtZM37Tul2MOCZ4/YKz4qme2h9A?=
 =?us-ascii?Q?dSNeGO1XRyGIKZu6tL9O/1p+koHRmmp+LGqG+l0fRQofwSIBWVqGibLQpH0d?=
 =?us-ascii?Q?V89aM8d2RMa3bS0ZjQ8/W8PCKnIrGAJOG+zzmrDjd/tDr6iDByVrCaPk0wUy?=
 =?us-ascii?Q?4ttHvIM9qjaR7YlEpHaYB9aFfcL1N+HmHhzaD66rK41XKsgZ6LxxQdYyF3rc?=
 =?us-ascii?Q?vwqR37FU3lrgimuiiaFQJMt44zNeQSEqxgV9vSxpEfw8Lt9JUP9j9m6C5+HS?=
 =?us-ascii?Q?a7x6Q2CNHWmYEpSZoBsfLY/fomnMnrX/KGoGIRhyoqKz7AnkE53gbZvKd+XM?=
 =?us-ascii?Q?/u66seUBn6aC8aiS08ZMlUpAmPGHCaRf+xn0L4seikaGDFsxvUoeDmTLxl8j?=
 =?us-ascii?Q?F+c6LIX2BRnPIFG4jH9YEwftOwac8YKzgEG/WlTUH2XiJCfU3WMlChd4SKnC?=
 =?us-ascii?Q?DVQL9qDtpTPbl1hkRBsnCUsD8APxc7X/69vIgIjOZTLGluzJi8FsUZ0RRb7k?=
 =?us-ascii?Q?MOghPOWL7sTVCOS+xii3ovI7Ig0Bl+XgNjhwtEakZDj1whYg7O1lC8Lbg8Qa?=
 =?us-ascii?Q?mjJ7ksK+7qHDzlZfCtH4D9WmwwlZqArDJW7McplP1+X4+aijGzTSxxkNVyPM?=
 =?us-ascii?Q?g6sMc5Ba+xq0dpoULPki36vOF13rGKnlnEK35+JYB2ufJCZfG2EtTccZE1HK?=
 =?us-ascii?Q?nH+3CBXSloefeXfkIFP0Dh1JhVt6Fu1Azvkur79M5LEoFtfp5RQBvKqwrSF7?=
 =?us-ascii?Q?n2WQq4EPXtFi8sOuQxo6ag75Q/EvFfSzcLXpgREwaSCRl4TF9WqikJV13RxS?=
 =?us-ascii?Q?DjvyZ+Hs+rPhZy1eqhyryVEL833LOz94UFrVrQ5+bbR0euZkeTO3SZh/QrWQ?=
 =?us-ascii?Q?KeELFYLfEg6cFtVphp4yD1MviLsrAU1oqJQVHB295Jza/SuVpXMIDLxeErLE?=
 =?us-ascii?Q?MKdLpJbA6PE/hrgmlKfnvck22T95GW8f7UExq+k3nqYqw1soWoB4Wdx3hAUN?=
 =?us-ascii?Q?UAbXzHBiH1lHYplbVzuChl2Mu7dFCm1hznpSISyLHkxQi/wSLhO4ct71ZHW4?=
 =?us-ascii?Q?sXPD3WgHt8wm56zExWE/VYZMGX3Sd6AB7ly3Q+MsmU6tPJRw+E7s5AFag+dy?=
 =?us-ascii?Q?pvlvWNNzsVjxUaX7EAGvOHbH6ytyiozvEUb/6IzI3dwoui1pmF27+akdpON/?=
 =?us-ascii?Q?Bo7ZAQ7blA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e95c639-dd49-4915-72db-08df2516e6b6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 08:34:00.3983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ERpn1cxDxDx9r89SJ/jc3JCE9lkMZbii72OJIw+ohFZFaQ+e21m4yPJeG1md1C5A0knjAhqKU1tGVc1jlKxUrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4212

On Wed, Oct 07, 2026 at 01:16:35PM +0800, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Devices which support Dynamic Capacity (DC) are configured via mailbox
> commands. CXL r4.0 section 9.13.3 describes the use of the Get DC
> Configuration command in order to obtain DCD partition characteristics.
> 
> Implement the DC mailbox commands as specified in CXL 4.0 section
> 8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
> information. Disable DCD if an invalid configuration is found.
> 
> Initial enablement for Linux only supports one dynamic capacity
> partition. Read all the partitions the device reports but validate
> only the first, and configure it as 'dynamic ram'.
> 
> The specification requires that volatile capacity starts at DPA 0 and
> pmem starts at the DPA immediately following it, but DC partitions only
> need to be 256MB aligned according to CXL r4.0 section 8.2.10.9.9.1
> Table 8-347. So a device could leave a gap between ram/pmem (static)
> capacity and its first DC partition, or between one DC partition and
> the next.
> 
> However, Linux chooses not to support gaps between static and dynamic
> capacity, and requires the first DC partition to begin at the DPA
> immediately following static capacity.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Co-developed-by: Anisa Su <anisa.su@samsung.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> 
> ---
> Changes:
> 1. Partition mode renamed CXL_PARTMODE_DYNAMIC_RAM: the mode says what
>    kind of capacity this is, not which partition. The DC partition's
>    resource name carries its position instead, dynamic_ram_1 for the
>    first, formatted in cxl_dpa_setup().
> ---
>  drivers/cxl/core/hdm.c    |  13 ++-
>  drivers/cxl/core/mbox.c   | 237 ++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/core/memdev.c |  47 ++++++++
>  drivers/cxl/cxlmem.h      |  55 +++++++++
>  drivers/cxl/pci.c         |   6 +
>  include/cxl/cxl.h         |   3 +-
>  6 files changed, 359 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 0c80b76a5f9b..5fa2177cefcc 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -446,6 +446,8 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
>  		return "ram";
>  	case CXL_PARTMODE_PMEM:
>  		return "pmem";
> +	case CXL_PARTMODE_DYNAMIC_RAM:
> +		return "dynamic_ram";
>  	default:
>  		return "";
>  	};
> @@ -455,6 +457,7 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
>  int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
>  {
>  	struct device *dev = cxlds->dev;
> +	int dc_nth = 0;
>  
>  	guard(rwsem_write)(&cxl_rwsem.dpa);
>  
> @@ -471,8 +474,16 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
>  
>  	for (int i = 0; i < info->nr_partitions; i++) {
>  		const struct cxl_dpa_part_info *part = &info->part[i];
> +		const char *name = cxl_mode_name(part->mode);
>  		int rc;
>  
> +		if (part->mode == CXL_PARTMODE_DYNAMIC_RAM) {
> +			name = devm_kasprintf(dev, GFP_KERNEL, "%s_%d", name,
> +					      ++dc_nth);
> +			if (!name)
> +				return -ENOMEM;
> +		}
> +
>  		cxlds->part[i].perf.qos_class = CXL_QOS_CLASS_INVALID;
>  		cxlds->part[i].mode = part->mode;
>  
> @@ -485,7 +496,7 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
>  		}
>  		rc = add_dpa_res(dev, &cxlds->dpa_res, &cxlds->part[i].res,
>  				 part->range.start, range_len(&part->range),
> -				 cxl_mode_name(part->mode));
> +				 name);
>  		if (rc)
>  			return rc;
>  		cxlds->nr_partitions++;
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 199bb986d674..72af23ba288e 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1349,6 +1349,243 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
>  	return -EBUSY;
>  }
>  
> +/*
> + * A partition unavailable for Dynamic Capacity reports zeros for decode_length,
> + * length, and block_size.
> + */
> +static bool cxl_dc_partition_unavailable(struct cxl_dc_partition *dev_part)
> +{
> +	return !le64_to_cpu(dev_part->decode_length) &&
> +	       !le64_to_cpu(dev_part->length) &&
> +	       !le64_to_cpu(dev_part->block_size);
> +}
> +
> +static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part,
> +			struct cxl_dc_partition *dev_part)
> +{
> +	u64 decode_len = le64_to_cpu(dev_part->decode_length);
> +	u64 blk_size = le64_to_cpu(dev_part->block_size);
> +	u64 len = le64_to_cpu(dev_part->length);
> +	u64 size;
> +
> +	/*
> +	 * Not an error; leave the entry empty. A partially zeroed partition
> +	 * is rejected by the checks below. CXL r4.0 Table 8-347.
> +	 */
> +	if (cxl_dc_partition_unavailable(dev_part)) {
> +		*part = (struct cxl_dc_partition_info) { };
> +		dev_dbg(dev, "Partition 0 unavailable for DC\n");
> +		return 0;
> +	}
> +
> +	/*
> +	 * Decode length is a count of 256M units, so a device reporting 2^36
> +	 * or more wraps.
> +	 */
> +	if (check_mul_overflow(decode_len, (u64)CXL_CAPACITY_MULTIPLIER, &size)) {
> +		dev_err(dev, "DC partition 0 decode length %#llx overflows\n",
> +			decode_len);
> +		return -EINVAL;
> +	}
> +
> +	*part = (struct cxl_dc_partition_info) {
> +		.start = le64_to_cpu(dev_part->base),
> +		.size = size,
> +	};
> +
> +	/*
> +	 * Block size is a power of 2 and a multiple of 40h. is_power_of_2()
> +	 * takes an unsigned long, which truncates blk_size on 32 bit.
> +	 */
> +	if (blk_size == 0 || (blk_size & (blk_size - 1)) ||
> +	    blk_size % CXL_DCD_BLOCK_LINE_SIZE) {
> +		dev_err(dev, "DC partition 0 invalid block size %#llx\n", blk_size);
> +		return -EINVAL;
> +	}
> +
> +	if (part->size == 0) {
> +		dev_err(dev, "DC partition 0 zero decode length\n");
> +		return -EINVAL;
> +	}
> +
> +	if (len == 0) {
> +		dev_err(dev, "DC partition 0 zero length\n");
> +		return -EINVAL;
> +	}
> +
> +	if (len > part->size) {
> +		dev_err(dev, "DC partition 0 length %#llx exceeds decode length %#llx\n",
> +			len, part->size);
> +		return -EINVAL;
> +	}
> +
> +	if (!IS_ALIGNED(len, blk_size)) {
> +		dev_err(dev, "DC partition 0 length %#llx not a multiple of block size %#llx\n",
> +			len, blk_size);
> +		return -EINVAL;
> +	}
> +
> +	if (!IS_ALIGNED(part->start, SZ_256M)) {
> +		dev_err(dev, "DC partition 0 base %#llx not aligned to 256M\n",
> +			part->start);
> +		return -EINVAL;
> +	}
> +
> +	dev_dbg(dev, "DC partition 0 start %#llx size %#llx blk_size: %#llx\n",
> +		part->start, part->size, blk_size);
> +
> +	return 0;
> +}
> +
> +/* Returns the number of partitions in dc_resp or -ERRNO */
> +static int cxl_get_dc_config(struct cxl_mailbox *mbox, u8 start_partition,
> +			     u8 partition_count,
> +			     struct cxl_mbox_get_dc_config_out *dc_resp,
> +			     size_t dc_resp_size)
> +{
> +	struct cxl_mbox_get_dc_config_in get_dc = (struct cxl_mbox_get_dc_config_in) {
> +		.partition_count = partition_count,
> +		.start_partition_index = start_partition,
> +	};
> +	struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {
> +		.opcode = CXL_MBOX_OP_GET_DC_CONFIG,
> +		.payload_in = &get_dc,
> +		.size_in = sizeof(get_dc),
> +		.size_out = dc_resp_size,
> +		.payload_out = dc_resp,
> +		/* The device must return at least the fixed header */
> +		.min_out = sizeof(*dc_resp),
> +	};
> +	size_t expected_sz;
> +	int rc;
> +
> +	rc = cxl_internal_send_cmd(mbox, &mbox_cmd);
> +	if (rc < 0)
> +		return rc;
> +
> +	if (dc_resp->partitions_returned > partition_count) {
> +		dev_err(mbox->host, "Device returned %u partitions, requested %u\n",
> +			dc_resp->partitions_returned, partition_count);
> +		return -EIO;
> +	}
> +
> +	/* The trailing extent/tag counts (CXL r4.0 Table 8-346) are not read */
> +	expected_sz = struct_size(dc_resp, partition,
> +				  dc_resp->partitions_returned);
> +
> +	if (mbox_cmd.size_out < expected_sz) {
> +		dev_err(mbox->host,
> +			"Payload size %zu less than expected %zu for %u partitions\n",
> +			mbox_cmd.size_out,
> +			expected_sz,
> +			dc_resp->partitions_returned);
> +		return -EIO;
> +	}
> +
> +	dev_dbg(mbox->host, "Read %d/%d DC partitions\n",
> +		dc_resp->partitions_returned, dc_resp->avail_partition_count);
> +	return dc_resp->partitions_returned;
> +}
> +
> +/**
> + * cxl_dev_dc_identify() - Reads the dynamic capacity information from the
> + *                         device.
> + * @mbox: Mailbox to query
> + * @dc_info: The dynamic partition information to return
> + *
> + * Read every partition the device reports, but validate only the first:
> + * Linux maps partition 0 and nothing else, so a defect in capacity the
> + * driver never touches is not a reason to refuse the device dynamic
> + * capacity.  The remaining partitions are read but not recorded.
> + *
> + * Return: 0 if identify was executed successfully, -ERRNO on error.
> + *         On error, @dc_info is left unchanged.
> + */
> +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> +			struct cxl_dc_partition_info *dc_info)
> +{
> +	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS] = { };
> +	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) = NULL;
> +	struct device *dev = mbox->host;
> +	u8 avail_partitions = 0;
> +	u8 start_partition;
> +	u8 num_partitions;
> +	u8 partition_count;
> +	size_t dc_resp_size;
> +
> +	/*
> +	 * Bound requested number of partitions by mailbox payload size. The
> +	 * 256 byte spec minimum, verified in cxl_pci_setup_mailbox(), keeps
> +	 * the subtraction below from underflowing.
> +	 */
> +	partition_count = min(CXL_MAX_DC_PARTITIONS,
> +			      (mbox->payload_size - sizeof(*dc_resp) -
> +			       sizeof(struct cxl_mbox_get_dc_config_tail)) /
> +			      sizeof(struct cxl_dc_partition));
> +	dc_resp_size = struct_size(dc_resp, partition, partition_count) +
> +		       sizeof(struct cxl_mbox_get_dc_config_tail);
> +
> +	dc_resp = kmalloc(dc_resp_size, GFP_KERNEL);
> +	if (!dc_resp)
> +		return -ENOMEM;
> +
> +	start_partition = 0;
> +	num_partitions = 0;
> +	do {
> +		int returned, rc;
> +
> +		returned = cxl_get_dc_config(mbox, start_partition,
> +					     partition_count, dc_resp,
> +					     dc_resp_size);
> +		if (returned < 0) {
> +			dev_err(dev, "Failed to get DC config: %d\n", returned);
> +			return returned;
> +		}
> +
> +		if (returned == 0) {
> +			dev_err(dev,
> +				"Device reported %u partitions available but returned none at index %u\n",
> +				dc_resp->avail_partition_count, start_partition);
> +			return -EIO;
> +		}
> +
> +		/* A DCD reports at least one partition (CXL r4.0 Table 8-346) */
> +		if (dc_resp->avail_partition_count == 0) {
> +			dev_err(dev, "Device reported no DC partitions\n");
> +			return -EIO;
> +		}
> +
> +		avail_partitions = min(dc_resp->avail_partition_count,
> +				       CXL_MAX_DC_PARTITIONS);
> +
> +		/*
> +		 * Only partition 0 is mapped, so it is the only one checked.
> +		 * The rest are read to complete the enumeration and dropped.
> +		 */
> +		if (start_partition == 0) {
> +			rc = cxl_dc_check(dev, &partitions[0],
> +					  &dc_resp->partition[0]);
> +			if (rc)
> +				return rc;
> +		}
> +
> +		num_partitions += returned;
> +		start_partition = num_partitions;
> +
> +	} while (num_partitions < avail_partitions);
> +
> +	/* Linux only supports the 1st partition; nothing to do if it is unavailable */
> +	if (partitions[0].size == 0)
> +		return -ENODEV;
> +
> +	*dc_info = partitions[0];
> +	dev_dbg(dev, "Returning partition 0 %#llx size %#llx\n",
> +		dc_info->start, dc_info->size);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
> +
>  int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count)
>  {
>  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> index b3419df586b9..def26c490dfe 100644
> --- a/drivers/cxl/core/memdev.c
> +++ b/drivers/cxl/core/memdev.c
> @@ -643,6 +643,53 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_mem_dpa_fetch, "CXL");
>  
> +int cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> +{
> +	struct cxl_dc_partition_info dc_info = { };
> +	struct device *dev = mds->cxlds.dev;
> +	u64 total;
> +	int rc;
> +
> +	if (!mds->cxlds.media_ready)
> +		return 0;
> +
> +	rc = cxl_dev_dc_identify(&mds->cxlds.cxl_mbox, &dc_info);
> +	if (rc) {
> +		dev_warn(dev,
> +			 "Failed to read Dynamic Capacity config: %d\n", rc);
> +		return rc;
> +	}
> +
> +	if (dc_info.start < info->size) {
> +		dev_err(dev,
> +			"DC partition 0 base %#llx overlaps static capacity ending at %#llx\n",
> +			dc_info.start, info->size);
> +		return -EINVAL;
> +	}
> +
> +	/* A gap between static capacity and the DC partition is not supported */
> +	if (dc_info.start > info->size) {
> +		dev_warn(dev,
> +			 "DC partition 0 base %#llx leaves a gap from static capacity ending at %#llx\n",
> +			 dc_info.start, info->size);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (check_add_overflow(info->size, dc_info.size, &total)) {
> +		dev_err(dev,
> +			"DC partition 0 size %#llx overflows DPA space ending at %#llx\n",
> +			dc_info.size, info->size);
> +		return -EINVAL;
> +	}
> +
> +	info->size = total;
> +	dev_dbg(dev, "Adding dynamic ram partition; %#llx size %#llx\n",
> +		dc_info.start, dc_info.size);
> +	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
> 

Hi Anisa,

This function uses info->size, which is Total Capacity, as the end of static
capacity, but now we require DC partition to start at the end of the last
static partition, which is RAM + PMEM. CXL r4.0 8.2.10.9.1.1 "Identify Memory
Device" only requires Total Capacity to be >= the sum of RAM + PMEM.
If they differ and device place DCD region base at Total, we can pass the check
here but cxl_dpa_setup() fails probe with -EINVAL, so a DCD config
quirk costs the whole memdev instead of just DCD.

Think of an example, Total capacity 12G, RAM has 8G, PMEM has 2G, now if
DC starts at 12G, this function check will be passed, but cxl_dpa_setup()
will see PMEM end at 10G, DC start at 12G, think of it as a hole.
If the DC start at 10G, we can pass cxl_dpa_setup(), but the test here will see
10G < 12 G and think DC region start inside the device memory and print
"overlaps"

Maybe derive the static end from info->part[nr_partitions - 1] and size
info->size from DC partition end ?

Best regards,
Richard Cheng.


>  /**
>   * cxl_set_capacity: initialize dpa by a driver without a mailbox.
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 0c8e23276dc6..4fac65dbb808 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -407,6 +407,8 @@ struct cxl_security_state {
>  	struct kernfs_node *sanitize_node;
>  };
>  
> +#define CXL_MAX_DC_PARTITIONS 8
> +
>  static inline resource_size_t cxl_pmem_size(struct cxl_dev_state *cxlds)
>  {
>  	/*
> @@ -689,6 +691,39 @@ struct cxl_mbox_set_shutdown_state_in {
>  	u8 state;
>  } __packed;
>  
> +/* See CXL r4.0 Table 8-345 get dynamic capacity config Input Payload */
> +struct cxl_mbox_get_dc_config_in {
> +	u8 partition_count;
> +	u8 start_partition_index;
> +} __packed;
> +
> +/* See CXL r4.0 Table 8-346 get dynamic capacity config Output Payload */
> +struct cxl_mbox_get_dc_config_out {
> +	u8 avail_partition_count;
> +	u8 partitions_returned;
> +	u8 rsvd[6];
> +	/* See CXL r4.0 Table 8-347 */
> +	struct cxl_dc_partition {
> +		__le64 base;
> +		__le64 decode_length;
> +		__le64 length;
> +		__le64 block_size;
> +		__le32 dsmad_handle;
> +		u8 flags;
> +		u8 rsvd[3];
> +	} __packed partition[] __counted_by(partitions_returned);
> +	/* Trailing extent/tag count fields unused */
> +} __packed;
> +
> +/* Trailing counts; cannot be a member after the flex array above */
> +struct cxl_mbox_get_dc_config_tail {
> +	__le32 num_extents_supported;
> +	__le32 num_extents_available;
> +	__le32 num_tags_supported;
> +	__le32 num_tags_available;
> +} __packed;
> +#define CXL_DCD_BLOCK_LINE_SIZE 0x40
> +
>  /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
>  struct cxl_mbox_set_timestamp_in {
>  	__le64 timestamp;
> @@ -812,9 +847,18 @@ enum {
>  int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
>  			  struct cxl_mbox_cmd *cmd);
>  int cxl_dev_state_identify(struct cxl_memdev_state *mds);
> +
> +struct cxl_dc_partition_info {
> +	u64 start;
> +	u64 size;
> +};
> +
> +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> +			struct cxl_dc_partition_info *dc_info);
>  int cxl_await_media_ready(struct cxl_dev_state *cxlds);
>  int cxl_enumerate_cmds(struct cxl_memdev_state *mds);
>  int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
> +int cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
>  struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
>  						 u16 dvsec);
>  void set_exclusive_cxl_commands(struct cxl_memdev_state *mds,
> @@ -828,6 +872,17 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
>  			    const uuid_t *uuid, union cxl_event *evt);
>  int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count);
>  int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds);
> +
> +static inline bool cxl_dcd_supported(struct cxl_memdev_state *mds)
> +{
> +	return mds->dcd_supported;
> +}
> +
> +static inline void cxl_disable_dcd(struct cxl_memdev_state *mds)
> +{
> +	mds->dcd_supported = false;
> +}
> +
>  int cxl_set_timestamp(struct cxl_memdev_state *mds);
>  int cxl_poison_state_init(struct cxl_memdev_state *mds);
>  int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index c7c91e8dc51d..2fe9db4b3d86 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -868,6 +868,12 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	if (rc)
>  		return rc;
>  
> +	if (cxl_dcd_supported(mds)) {
> +		rc = cxl_configure_dcd(mds, &range_info);
> +		if (rc)
> +			cxl_disable_dcd(mds);
> +	}
> +
>  	rc = cxl_dpa_setup(cxlds, &range_info);
>  	if (rc)
>  		return rc;
> diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
> index 802b143de83d..e07360849344 100644
> --- a/include/cxl/cxl.h
> +++ b/include/cxl/cxl.h
> @@ -133,6 +133,7 @@ struct cxl_dpa_perf {
>  enum cxl_partition_mode {
>  	CXL_PARTMODE_RAM,
>  	CXL_PARTMODE_PMEM,
> +	CXL_PARTMODE_DYNAMIC_RAM,
>  };
>  
>  /**
> @@ -147,7 +148,7 @@ struct cxl_dpa_partition {
>  	enum cxl_partition_mode mode;
>  };
>  
> -#define CXL_NR_PARTITIONS_MAX 2
> +#define CXL_NR_PARTITIONS_MAX 3
>  
>  /**
>   * struct cxl_dev_state - The driver device state
> -- 
> 2.43.0
> 
