Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE7910A3E
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 02:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745201197; cv=fail; b=Pv883XbxD4N86iFSNyxVEqo9xd4BJ3jHV5eZQV2KVYNxz0YZIo+QgGTZeOE6ZJYNoOPXrQg3ElEs3HDzkeUIgB1Hk4gfSrgLKQSLLdd/tAVMdXioTqLr1IloNwylL0trhRYkL55RXxcoA1AVFxTZ1+UeEYGFf9ZKrgZwBzCE8Ys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745201197; c=relaxed/simple;
	bh=g3IMCn66cfatjLoR37vg4+aaNRGgDzqPN4DwQ0I4rM4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cn67kPYMhTIg564u8uWXy1zl/4JaHk1SDbTxE4MuINeIfS79RGvJi8dUiGMJDGPnoPoM7HwFQSexScPbs/6pDfrg5jvM3z1vpuztxVF2nOTB2TEDy3eFLgnNHyqy6JBii+e7HBBRB7aQGP3oNcBfVKJZHlct/qIEqudT+fGlFiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jbFBPu55; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jbFBPu55"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745201196; x=1776737196;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=g3IMCn66cfatjLoR37vg4+aaNRGgDzqPN4DwQ0I4rM4=;
  b=jbFBPu55AeqRjSTO3tyjAummAxY1itDewnokchnm4DcydNmJEn7sS8Td
   KBH14J8Ul70vitCCLxEGLTosQY9n0lWt80iMwXu7XS/CP3rtX1L28YHDM
   mUxgGVtP8r09Xun1I7vPo26aB11XO7rSbxX7Nwl0bi4dHl9FCFsQitE+3
   hPHUbXbxN47icNkDpptHoxZO6zZENYoktzOLoAdipqq/Ap/L8xtg5McZQ
   kwRewWycSPgrsczejW6uHJJGmZPdxaDyWPzcIFH1iRKC9CqgkGMVc8Bkt
   Uv41IV5NF/EwfpuomSL3GaNCiCy3A43zKvO6ihRWekgSnfoc0AesVZXEE
   w==;
X-CSE-ConnectionGUID: O4Vp+pCGS2+Dh6rZAw4ORg==
X-CSE-MsgGUID: 0kfzcgAcRDqvV6YD3ejg/g==
X-IronPort-AV: E=McAfee;i="6700,10204,11409"; a="57390825"
X-IronPort-AV: E=Sophos;i="6.15,227,1739865600"; 
   d="scan'208";a="57390825"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2025 19:06:35 -0700
X-CSE-ConnectionGUID: LetVaNCtT1GQNnleqGZqFg==
X-CSE-MsgGUID: FHXeVSnJSZi6nTyYta7LDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,227,1739865600"; 
   d="scan'208";a="131342686"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2025 19:06:35 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 20 Apr 2025 19:06:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 20 Apr 2025 19:06:34 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 20 Apr 2025 19:06:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wxIvHs8NIKaTR6W/3drEKZVjFyyZbQozt93itWsf8T/yRTtdhuUYwH+fxJJlmxjwB3oKUGNqsonJWFWyaWsQzVIFdtlLNOIsCsVqPXoCisLrC6ClXEs/AHk0eqmam/0qjLFThZ3pKu4qH1kb3ug/HBvJdgXqpITUu8bBKrDhf//+Afen+TR7qSW33u8RkraSNrhjxeopKRqOGv/UtU0eK4f03ZVw8g6zFRDVb7wdBkNAMSFCLNLZm9d6IN6ZEoA81ITyPiyjx70N5GQw2k/c5wtJAQz6tZXC87sGkRjQRRDkHICRMoEgyOFVSIrCCGOvQ7qpCNLZwgg4Ah4OmC9sdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUMQ/futN0iCBbMvmGKZPrrxSB/nfyM+F1+fpuOQ6sQ=;
 b=LDx2OfVyMTiq8pXnSvUXUGSHuM4MogoTb6tj2eAuQbcW9fsD7cFV/EjuxlZ0SbpxOlwazR0NJKsgZfZ9sz3v1v1DWVHyLt7K3yeCRrIxu12Y8SUsBuZi4J9FykGLGN31yMm46OeK5puT3UaBxpxmBp+oqKWziWL+ujqcVVEiNiFlSJj2lOBcw/ETbpbnrutShJcj/lARp4SecaEaFTzGqtSPO33QYsFPXkFHOvg76PUHidI5dD4JqlWCpKXV/UASk6/rCrC1bKYvzxhY2TTZ7DPOYSseH9dJry/ltvJHuOmU8FnkBkcmqvoMnVf9WTvqTR5THIaVxUrqKNcgB117fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DM4PR11MB8090.namprd11.prod.outlook.com (2603:10b6:8:188::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.33; Mon, 21 Apr
 2025 02:06:17 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.8655.031; Mon, 21 Apr 2025
 02:06:17 +0000
Date: Sun, 20 Apr 2025 21:06:48 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Michal Clapinski <mclapinski@google.com>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Dan Williams <dan.j.williams@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Jonathan Corbet <corbet@lwn.net>
CC: <nvdimm@lists.linux.dev>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Michal Clapinski <mclapinski@google.com>
Subject: Re: [PATCH v2 1/1] libnvdimm/e820: Add a new parameter to configure
 many regions per e820 entry
Message-ID: <6805a8382627f_18b6012946a@iweiny-mobl.notmuch>
References: <20250417142525.78088-1-mclapinski@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250417142525.78088-1-mclapinski@google.com>
X-ClientProxiedBy: MW4PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:303:8f::6) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DM4PR11MB8090:EE_
X-MS-Office365-Filtering-Correlation-Id: f348d453-d708-4297-1d9e-08dd807919ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|10070799003|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?g6Wv2Dvx8j+6FVJIU+tSn0rl5v85pPnQMhUDU8ArFVtPdqT20NKtx3Z5GHww?=
 =?us-ascii?Q?F3t3+0X3/gVWEZlSSfDZ4Ot5FZS1qjWTaawccwuTHWEFEramVqzXo9uUMcie?=
 =?us-ascii?Q?zEYdz6ibwlC8ZlHbVtl4Ic5GeYtINfGN9ckRUulaSvUtcAeSqK77vDmebuxW?=
 =?us-ascii?Q?NaW7gLFptzMH1YcbJ2sUL37rF42zq6LnUnD0kufwRxvacKiO5ZOsEbd/1kDP?=
 =?us-ascii?Q?8Hfcd5tSRMVISVn7sO9gHVH2pXvOQaFbN2fuY5CEC/NrPoZiadanBrOQWy6I?=
 =?us-ascii?Q?iuN/AlImBh9jphh8d0jaGCpcSg3HXS4Det1O4aXLK0WbW6PzVj9P0XgP3ZCS?=
 =?us-ascii?Q?0Y+iOCNJwWmHoEQ/tnVwALo7wMDxJkdquvRQ1Pj76aMODcK/eY83e/uIuK56?=
 =?us-ascii?Q?D4oog8LMQ/aXkMb6OdHjdd1HV9nCbEknNb80SdJhNhUiN1LOwQ3Nj688nc0Q?=
 =?us-ascii?Q?jkUcLkjq1N753jkVQzxJFQ/wzrOgZTSUB9whX75j2tavddgBs/vueQa9oPM3?=
 =?us-ascii?Q?LKWS/NMBqxTPzLpwCyhoy5+r/xRqMTgXszMfurghvoPvfTjCXvTDiV3AAgeG?=
 =?us-ascii?Q?aR1CYrO50f74hJ+Ip/iPKihNw6+1khBNXKZw1syC7lVBVstuzyTe7Xmt/0d2?=
 =?us-ascii?Q?Sw0f03CdracAEPks7HQGR9nciNAeLxyHgaHijKAC1103PPcalHJEjMS+N68w?=
 =?us-ascii?Q?l7RS4Q+w1Q/AI3KLetDffP+YW1KGDGNRyCwYwO5uhWyok0WL3T89ONyiKnxm?=
 =?us-ascii?Q?ljXNigjdFlQsef/hTqfJy6VdsIXSO53ZWVocE66hgRIJ5roZ0O8obo/kwopG?=
 =?us-ascii?Q?++BXLlSJIpmmr+7o/Owr1w/JBkp0jqo8435fq8vjaIO0fP35B2TzhFEXuWSW?=
 =?us-ascii?Q?4UtQn4gLMeSFqprtLb9/ZSidSAzbo7MRvfdTkBtJINvz23+MgldRpTIeaueY?=
 =?us-ascii?Q?2GhEQBp0stzEPIT6b6rVDHQkQFBD/J2Qh+E3KUNF3ia9ysOqBK5r//pr+H96?=
 =?us-ascii?Q?2PZo3PCUsPdGUMyXkMprp0anXHmHTR3mmm3Sv1GOKeameEY5Vg0mTsWGb190?=
 =?us-ascii?Q?2ng/IDp1nW1NE3Aox2bxA3FzNNaT/3B2fNkwtizmSPtcOask7gw32dPIO017?=
 =?us-ascii?Q?r6vp7F7FqV0JQSxs8I7yNLz+mban3dJ4iqkoUe4XKd3OMSqlC7IsNZyQmHj1?=
 =?us-ascii?Q?re+0sA5vQ4nXh6+bFdE0DsS0O5b3dmAfNVst4VyxOBSr7UiPbhnE4gbvtQL0?=
 =?us-ascii?Q?10CV3evkbhZn+n6rwZmkYwzUkNNbtxqhZAmNsFd1AS5igY2gPDd+Q9Pr3CnD?=
 =?us-ascii?Q?LRHs5MN93EuPsWXzFFpCeiXOulxoATcOgpdU2e9LAmOHziT9+2kHa1q6ofLZ?=
 =?us-ascii?Q?oNzck+1sCG5+4V3DdjLHjahW63Tf31iIeqO3s7IRZztWewgjGnsmBma9rfWo?=
 =?us-ascii?Q?N88WEWBo06o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4GQIb3ilji8AGcKIWV2fE9PsjEUme21FfZQPIZTUZasawRuQOBjdYNMqO4ua?=
 =?us-ascii?Q?kVgLcStfMMdmURkKEiiJ4loDB66bVF3p1VWNe+XaduQTIegsNnnuWGGjiAXE?=
 =?us-ascii?Q?6h+RcJbUGL3smE6xHoaq7frVPkp8ubIjaRM/iG5rCUzhRtQFhW7wBHIqxgbR?=
 =?us-ascii?Q?8j7ogGmcBuDmq1U9K2LUvicJ2CenD5v6CcDLlhaqfc6HD4OiVx99yRi22iH4?=
 =?us-ascii?Q?ZYXgpR+6GYJ++u5KpljnYlKLP9JSI7Tw0a7MbP7QIk8qhbrHvTuSkcGWiqEg?=
 =?us-ascii?Q?yEl0G9TX4BY1C+mjcy9iKMlcxjurmekg98Z76AngbeAMKvsbRXE0pvq50bzJ?=
 =?us-ascii?Q?z2cEhj7oBze7qXDuliFoxt3VvaffGInKkQhhtN8Q2sQIyFmt9O54c7u94uVb?=
 =?us-ascii?Q?tqlPZvBqwCrAbj66Lo1M0nw6owBXdSAEAvk50mwwIq17EQzuE49QK9WeMZ1q?=
 =?us-ascii?Q?FEZC3apdn5nEHGy+SJ+qM1PZTL//Bn85UJGod1nOcLD2oWj+vMJ/Fl9B8uj0?=
 =?us-ascii?Q?qhuzJ8ANMLTGtQ9fe8bwqo8R+wO3WF9EIeNJoHKZ6FMC8TqqgsBi6RKY32+q?=
 =?us-ascii?Q?KvVnB1RhUqiwwR9b7sInqXxCOH+Dm6BVwPK5oWB37hgzzg6WGJnpXgcofpUp?=
 =?us-ascii?Q?Rj0Q/nXh+7zfpwHv50h7iR1z+NzoDqoZi9XT/QB8TQ/2y6EW3lvJeEGqtq55?=
 =?us-ascii?Q?GSWrnTzh+Dqnah3O8xVOXatTuito/OZ3ieB+TXkrSVJSLfVXFkfnGN12kZpK?=
 =?us-ascii?Q?oqTNvMzHdweG78AOTbOHgK6i5DxYac0sKwCCCEV2rrQmU81TjM0BM9NjH2FI?=
 =?us-ascii?Q?iOvW7NrCnN0ZvM6UzPEnq4hqzTbA0XPM7JNQy+m9nS3sYzlhIWdAXhzV+TNi?=
 =?us-ascii?Q?sjDMSbCOtiUfx6yQULVvyV4aApjgBbALUc5uvYSvPwb86YvLH7tGSqsZAtwc?=
 =?us-ascii?Q?xriUTXgXUHrJ/o5/wBsY9me2Wh2VKwPpKeNV2zRwpLm9hMPzqUTERJJWo5QB?=
 =?us-ascii?Q?AoYjGap4LVHLR/1XybDD1BnJSYaW46Mshd6OxR7rv7rLKWsu2LCAzLztgtwb?=
 =?us-ascii?Q?kcVBSDRJ+/KrsW8oedAxdS6We0cXxAIsSmji+nAT4swjtuo6b6p1cDXS33Ve?=
 =?us-ascii?Q?YKedCpS1kYMmFKmgUrP47bWnt6khbmqzWLc5LPddiVeS2wCGxWt2ebGKTG5l?=
 =?us-ascii?Q?hI2Q4f1Nq3PiAAo7AHoo+HP7WkGwAWsU4HpikrYu98TeaMLcz5D8abodCtv6?=
 =?us-ascii?Q?0G5xmPETpKbjeG99hfYguCTbzEBWCtPDbzu3j+0lttKP8nW58l2GYJ0yy+0S?=
 =?us-ascii?Q?cUMEgOUK9uhWDuaIrewu2lJ6+cBm8g0SUuWe+KiPIE1hw/yjvGcv2Wzee07u?=
 =?us-ascii?Q?YGbo5TWsftzyzFtf46u51AVNxtSdh1K/KPPBreMhP4wsqBYl7HK153B7kwYh?=
 =?us-ascii?Q?XQ+XJyCtNfyg6PkoJuLmmPsr37iNIiY/1za8tCactK8TMfG3dqBGUqpKHshd?=
 =?us-ascii?Q?2lu7S0A+CQU8B5ZCEsUxWMkduEIb+j5SAjkWyhupDSyPN/ZxRaiyM5g0KvQB?=
 =?us-ascii?Q?uVN7j3ybRX4QlxZcdLOELZTyt0P3y6Mm+3qmynvdIXECbaTyQaqAeEoqiQo+?=
 =?us-ascii?Q?mMvn7hDI1ZI5LlG1BNS7xzoeUmG8zzxg6stbPTSO4F+m?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f348d453-d708-4297-1d9e-08dd807919ad
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2025 02:06:16.9579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WBpjieFgvz86cYF38dSrqoNAm/6UsLDPx+dc2J7uDYL+wk99aNDuxmg2R7vLLz60AfEXJzomocsdjyjMivhqbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8090
X-OriginatorOrg: intel.com

Michal Clapinski wrote:
> Currently, the user has to specify each memory region to be used with
> nvdimm via the memmap parameter. Due to the character limit of the
> command line, this makes it impossible to have a lot of pmem devices.
> This new parameter solves this issue by allowing users to divide
> one e820 entry into many nvdimm regions.
> 
> This change is needed for the hypervisor live update. VMs' memory will
> be backed by those emulated pmem devices. To support various VM shapes
> I want to create devdax devices at 1GB granularity similar to hugetlb.

Why is it not sufficient to create a region out of a single memmap range
and create multiple 1G dax devices within that single range?

Ira

> 
> It's also possible to expand this parameter in the future,
> e.g. to specify the type of the device (fsdax/devdax).
> 
> Signed-off-by: Michal Clapinski <mclapinski@google.com>

[snip]
