Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B07C1C3BE6
	for <nvdimm@lists.linux.dev>; Wed, 22 Jan 2025 21:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737579785; cv=fail; b=N+BCe+sRpy8AKLBkP2GtaRVEFcMzR4rT6jrEYjt3iE3GPviCc3MiuMBeiu8AoNpSoUn8Odv5peDub3KyT3RKfjjZJCilclW+rmpG2YsNITFm1owP1TQH0vX7GaVNuT+kcboP/qchzAJh87k8gvW172MI4zPdG/JDNj6vk5+zO10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737579785; c=relaxed/simple;
	bh=HagUmxNowl8C8ew2TbaLy73tZA/iMPe21RCl8ia/Mk8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bIJDN5vxvgE9CF23mGmPJ7Fkah0blbsL8kwxR+NV4EOH6z36vR3ZQOv668tsEVEl9xo5h6zmdk6euvZzddtNFIOVvMweix5BVcE+2QcZk7Ld/P5FadrYrJIOSaDb0kwzZWcCUeOHZvg9yEpmO7lbBi99i3tTyQksbwFWym5Rxjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P0/1elhI; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P0/1elhI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737579783; x=1769115783;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HagUmxNowl8C8ew2TbaLy73tZA/iMPe21RCl8ia/Mk8=;
  b=P0/1elhIlmq+RzLnNcCZIYfFvAhWnhHwUzddSugVlcv04mz/CCNmEXAK
   6jaL5Ma4dAN/bzewfsrp8KYx4Fc498qSjXnV7cStv4Jcy3458cNf2nooL
   cRRTF0UsYYtyr3clRMPeZAQ68ns1+R+wViZbtbOU1KzTJzFcDcgu/lLJM
   ps8FBl4QAybWqhbOswuUyCwBxAsmc79Wh+JEjiPLSOrNCpBz18UXjq222
   ojw0AO1Q+fdyeZlIGFq4xnz9GWgcY/rxSPBgVfEgEgZYFkTCTfmHNnpmY
   LxJwyNZVB+8Gb+lzx495bu/6e/ZTsPCgw5BXPNOzsikXMnOxWB7Ot4JsJ
   Q==;
X-CSE-ConnectionGUID: fAw41XBQRLawD8npU8M+0g==
X-CSE-MsgGUID: 2w7xnEI5QFaeVb5z7xn0SQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11323"; a="49045535"
X-IronPort-AV: E=Sophos;i="6.13,226,1732608000"; 
   d="scan'208";a="49045535"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 13:03:02 -0800
X-CSE-ConnectionGUID: 4zspLYHdRW6VRJ01AQzlVQ==
X-CSE-MsgGUID: 9QSylmwBR7uTVGnoA4p0cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112356478"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Jan 2025 13:03:01 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 22 Jan 2025 13:02:59 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 22 Jan 2025 13:02:59 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 22 Jan 2025 13:02:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qLSnr2/IrUfCWphmSkP1rk4ldYMI9N+tVSr9+SzPL7J8sLZ3gYoT3gFVIchEpzCd2r3BkUPU4lBuqah0vDyah4eSx+qB7Joz5vsx30npU9aU/OZhxdjpdUVA92288QMOdEDXfPm7GYXqfyT9tLaVX6no2V3PFJ4AEcaapWK73cQ22eEIGl7Q/dYmg+RITJAcB2OtSagf3/2mPViOiOxgJr2obiivZAIMayweRNMC/d1T7yYJCWRL7Wi+44DF1TM3gloLcslcin/eCz0ASfqpYndEpyW146lK/gV3afVgSQUcPaVV5zSWWjbQIkL6tRGjIAEJK4d/R6vDAcqYGxfd7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rOpSoYoUAjUSvzt568RMBKdhMqOXV1Yb3aLeYS+VKqk=;
 b=fUros7UwSTkboPnKbIRsOBq8vsfaQYRYEYn1MXAbPTX07se4Giy7/2PIkfwJHcy/OZkKktIdgC39tk33mPUAk6MfMHgeSYR+hLSateH5eF3QiWD2A7UOYKKoGPjygT9bIRRfomwsIVU3ihw+RQ4s86keaVTcwuV46X3L1ceIe0AMaZJkE4T1v0GNGuPJod90s1b5D2SPXkVqW+KaydagBxMkkuvY7n1j9zBlsKmgCwCdpf/tV+9BWXKSdxai0EasWkDeVRVYbxaiVS3KeXPF/OhQdYqmZbeuKqLt6qSl+a6nIchndVFIfhPVOBDeWY/3VE941THCcEiWeM11H7jaCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA3PR11MB8118.namprd11.prod.outlook.com (2603:10b6:806:2f1::13)
 by LV3PR11MB8554.namprd11.prod.outlook.com (2603:10b6:408:1bb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Wed, 22 Jan
 2025 21:02:30 +0000
Received: from SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::c4e2:f07:bdaa:21ec]) by SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::c4e2:f07:bdaa:21ec%5]) with mapi id 15.20.8356.017; Wed, 22 Jan 2025
 21:02:30 +0000
Date: Wed, 22 Jan 2025 13:02:26 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, Fan Ni
	<fan.ni@samsung.com>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton
	<akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>, "Gustavo A. R.
 Silva" <gustavoars@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, "Alison
 Schofield" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-hardening@vger.kernel.org>, Li Ming
	<ming.li@zohomail.com>
Subject: Re: [PATCH v8 02/21] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <67915ce296030_20fa29457@dwillia2-xfh.jf.intel.com.notmuch>
References: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
 <20241210-dcd-type2-upstream-v8-2-812852504400@intel.com>
 <67871f05cd767_20f32947f@dwillia2-xfh.jf.intel.com.notmuch>
 <67881b606ca4e_1aa45f2948b@iweiny-mobl.notmuch>
 <678837fcc0ed_20f3294fb@dwillia2-xfh.jf.intel.com.notmuch>
 <20250116103207.00005461@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250116103207.00005461@huawei.com>
X-ClientProxiedBy: MW4PR03CA0301.namprd03.prod.outlook.com
 (2603:10b6:303:dd::6) To SA3PR11MB8118.namprd11.prod.outlook.com
 (2603:10b6:806:2f1::13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR11MB8118:EE_|LV3PR11MB8554:EE_
X-MS-Office365-Filtering-Correlation-Id: 300db4b6-7425-41a7-7789-08dd3b281566
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?TzJV4gZ73590aP4nDrE6X4WCFarxMbfq/yuhMGS+GZp2pyDVVWwuUNzry8DX?=
 =?us-ascii?Q?PFXD9QKz7yqitwbDN9VrKdWjyJCPIAk3CZg6qzJAc0tfXwne49hrRwQx0j5l?=
 =?us-ascii?Q?Ky2BO9LOULLFGD4lKF5aJ+GihYbNUt1nnvKUPBxdT5ET5PNdL3n1SPhW2Rdd?=
 =?us-ascii?Q?Nevg4Fkk8B+9vFVslG7vY/r7aVkZn94ySx5VIDru1kSoC3wsMuM9j9Mm2dM6?=
 =?us-ascii?Q?AznoY6PiM/pNHIUD1se1ebRaMch2FP4t6YXDMDljd/UA3r7SEfR+SHCmLGNc?=
 =?us-ascii?Q?vsCDV2Rj+21QJspHNWR2iaLXx+9tu2/3H3Vey6sIcYLmehdopoEMgJfbBNx1?=
 =?us-ascii?Q?YGSPZJMAU0rXzQ1X/HvHU7oZiTENghglZ/ZfF2w99xlL2rcr90LU9nARQ2pt?=
 =?us-ascii?Q?4OgcVAlfTaTKRn4f/CVd4XHynXciC3/5RPcshPr6AVV/P6EJPefvPqhUyEFt?=
 =?us-ascii?Q?zfi4K00bbEOG65tY3eVHwGcEMhUz3P4PiTjCpRcT7tt/lxbAiVzgcQyMzyXf?=
 =?us-ascii?Q?Az6AbKbaUK/bDo741VcgKVKtr+zK4Bjv5oheyj3o3X9r7iNg3ybKnVwOlmSp?=
 =?us-ascii?Q?W5MjcYRIaPvFbB3xh9DGbHb4Dj+0Dp38zX4MOJQnzHwSed4Z4f0WuV+GLZcA?=
 =?us-ascii?Q?8CHiix7i7UXSGswAWPvZQdCW5LzKsliweH6myM1g4Uo1kOfL4It5/x9J0uRY?=
 =?us-ascii?Q?AIXLX0Yz6LTrPQ2am7iKjBb3e7ZYDtmx2dy127CxnvT5y5bFB4Y/ORBlpTX9?=
 =?us-ascii?Q?xUuA/oJQ9n9TnJejX/podAiVy8ayWnrX50kpRWPlVNHUeEjPHQbfkEwFR+1U?=
 =?us-ascii?Q?Xr161T0BLelZo3vFvKVK3BA/KXfrnQqPXfg2990OJFre75/DQVJwcVoqz0Lo?=
 =?us-ascii?Q?yB9B7MmkM0EoH4STndSEry7kCHyPvCZwM5gZcnOfPVVnbvFNi+fEs5/niwiw?=
 =?us-ascii?Q?/5UFlnXlYPFtYEg6+5zwoYMk9FA/ntV+imQhiWmT4y1jaaNgR+wkAVbxEhTe?=
 =?us-ascii?Q?+zyBZPMKZugr4jf1da8SAMeeLzVDbXciTFZuk+rbZnXkZgYEdS4c7ntuxUO0?=
 =?us-ascii?Q?sBXkxtxfrRdL+Kx4NC8wFein1C0bxh7zSZfq3JH1xSrHBz92kJsIxbF+421p?=
 =?us-ascii?Q?jXSyzklUamA8PJxPfkIeRqhilkthkSeTrVCDl4FRf/JZvZdVihV5t5oVaL0b?=
 =?us-ascii?Q?auwouDSO313PYcAedCwBofe6KnXG1xGkXFWGD5K86NfcKqRnQTIyvBk6f1/D?=
 =?us-ascii?Q?wJWjpKyi28uyHeaT2ZaofVHAcpSVE/Wa0CjMIhtoj5QE8UseOJp4TZWlvwyr?=
 =?us-ascii?Q?h+qQdSjWUfTQ4skLsFlzx1Q5CHAd24s5KLDabZzDYklX6fvQEjqYClxjtk1M?=
 =?us-ascii?Q?W5U43S4m1E2XhGc8QwZ/ErTs8NeM?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8118.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HBBkauetN6zzrvyOw8HV0enwZedadi3n+tTjy0DsWtmNAm7g2cIIPYvqTy7m?=
 =?us-ascii?Q?bDmA1w2j0qs65wQH3pkKDSFYwRNVeGX07QK5cb7x+nHyITeCDGTRWQ4Ctipl?=
 =?us-ascii?Q?24CiZgvKVCqZ8lDn50jli44hhhjXrvOQ9RutfGXMgazedMA+Ysd/mnNc5X+X?=
 =?us-ascii?Q?OylZBD8b1oXuiSKSrf+cyhG4aXy/Q0De6VQ8WeDRKU2X8Hqo6zhBTfOOAdvT?=
 =?us-ascii?Q?pZlwEDfcdXbtOtadx4v81K6SIKOuGDOYC5gtBkvJ5H5RkpSIOyjVKCmuBMDT?=
 =?us-ascii?Q?Gw83zPCxMkapJVeYlq5RVWoN/G3HOajqaBo04qKruBq3dyh1SfLpgJHbDE4e?=
 =?us-ascii?Q?1qeL7fqQZ6BG26iALnTbYVWqky/ZuUDTvvgh52YPY3vlUBh6SKvCmPVfdeLx?=
 =?us-ascii?Q?IpIn9p1QYc78Cvc3R7yRNo7lSL6BSTyn3JrXFQkvcbaOAp5hmim+tG96eK9T?=
 =?us-ascii?Q?w7T4AePVItIsNYILm+A0zm1RmElZ2kGz1g5jMuLPE6DsXyFAqrVKLTs7QdJT?=
 =?us-ascii?Q?5iUVsxJ0k//5axiIbNgaGILw9Bf/gHo3Xqi8HhwJeRPsVLEcjHbAuNomqpoR?=
 =?us-ascii?Q?ZBom8CrtA6CSrSZSqZC5jIv9+HLAs5c+Wh9A/QbK8L1V6xUoPYFNVZ0bKftQ?=
 =?us-ascii?Q?G3KjSAqux+midO+AFze4xUxWVrpgzqs/krUfVnA4UyGgdeJX8J3pSHeqGqWN?=
 =?us-ascii?Q?KNIrp0ojNVOLgVqFUJ+WJbplNPCVNdqkuJR+Dr+dNTfdHx903krrMV4V7YaX?=
 =?us-ascii?Q?cI5UMKbjpty+TN5RIEYqE0pgGpQDMLVkhnfbAPNsmnkceG8DMySdlB04LnVT?=
 =?us-ascii?Q?DbfpSikpBDKIx9rt+fIdW/A/nnlJqeH4BEZK6lJalugvWDMi8iUh+Ia9a3zV?=
 =?us-ascii?Q?ndzHV6XyJqqcyjQYuTeFl+VFGreOQOJaa+xgBcawqSv0wxyGKhTzpqnDYgks?=
 =?us-ascii?Q?eoX6I+rGBhY9KU+YDYzs46VIWEicFry/fyUkFoKfHyP36rdEEYpXH9ZytIDF?=
 =?us-ascii?Q?iOjfKBvlgatVTWNabYYp0Marrg0sQuXdGRnfbnn+RRws2SaCHuSPNXIkKJ5C?=
 =?us-ascii?Q?VMcllpv2HHm9O5CiLu6bdyxpjaVZTpG/iyv/qhGeJqznKrmdLD0S/7N9vyap?=
 =?us-ascii?Q?rbfUBzM7xlvi9Bdp852cVhC1WuHb/Iyp3z11tmn150V14LnKlLAB9+hC07lK?=
 =?us-ascii?Q?80lG38hF8AxWWkuhhkSkBI7wiuYqGS3ajDRCQaMNSlanpMdRBUHTeoOxAmjy?=
 =?us-ascii?Q?359+M2zzjCwEMda5bEkYwtFnybBsqNn5PRglb2cgaxBYHHIdRpvsEdvCV3b+?=
 =?us-ascii?Q?E4tA4d2z5HXebnEEr0QuRvzgryd1OczzBe7W75YmkUuG+jd/eGiyEnCpfF+E?=
 =?us-ascii?Q?WzCTaf0wc9s6Pu0U8sAyBLh4V0jJS1NV8Jx4WJ7INV5SgeR17UgRQkR0x9vY?=
 =?us-ascii?Q?+rp6kTH7bR2LD4F2d9+qBHh4Xqb/V1xNYK/4OLkLT4W7RdnNvKLXPAn8mFqQ?=
 =?us-ascii?Q?D+ZUkxBS38WYQDaI0PYdHXSbAzPWiGbnRKX9xHoHZ3IDX1El4Y/6LFXHv19h?=
 =?us-ascii?Q?kGmydpmM4+bwans2qMHMH82m942/l2gAnRtrPn0BIehLXbj0LH9g2erzaXQw?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 300db4b6-7425-41a7-7789-08dd3b281566
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8118.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 21:02:30.2067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 62/N7fXhOpimxXPZ6g40G1YWn0RdAyPRqX873ATql4XqLwG514b4z/VolzUax3MU+qfUnL+NPkmOSx8EmJW8hZ7wS49c+qXvTtETgHdTBb0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8554
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> On Wed, 15 Jan 2025 14:34:36 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > Ira Weiny wrote:
> > > Dan Williams wrote:  
> > > > Ira Weiny wrote:  
> > > 
> > > [snip]
> > >   
> > > > > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > > > > index e8907c403edbd83c8a36b8d013c6bc3391207ee6..05a0718aea73b3b2a02c608bae198eac7c462523 100644
> > > > > --- a/drivers/cxl/cxlmem.h
> > > > > +++ b/drivers/cxl/cxlmem.h
> > > > > @@ -403,6 +403,7 @@ enum cxl_devtype {
> > > > >  	CXL_DEVTYPE_CLASSMEM,
> > > > >  };
> > > > >  
> > > > > +#define CXL_MAX_DC_REGION 8  
> > > > 
> > > > Please no, lets not sign up to have the "which cxl 'region' concept are
> > > > you referring to?" debate in perpetuity. "DPA partition", "DPA
> > > > resource", "DPA capacity" anything but "region".
> > > >   
> > > 
> > > I'm inclined to agree with Alejandro on this one.  I've walked this
> > > tightrope quite a bit with this series.  But there are other places where
> > > we have chosen to change the verbiage from the spec and it has made it
> > > difficult for new comers to correlate the spec with the code.
> > > 
> > > So I like Alejandro's idea of adding "HW" to the name to indicate that we
> > > are talking about a spec or hardware defined thing.  
> > 
> > See below, the only people that could potentially be bothered by the
> > lack of spec terminology matching are the very same people that are
> > sophisticated enough to have read the spec to know its a problem.
> 
> It's confusing me.  :)  I know the confusion source exists but
> that doesn't mean I remember how all the terms match up.

CXL 3.1 Figure 9-24 DCD DPA Space Example

In that one diagram it uses "space", "capacity", "partition", and
"region". Linux is free to say "let's just pick one term and stick to
it". "Region" is already oversubscribed.

I agree with Alejandro that a glossary of Linux terms added to the
Documentation is overdue and would help people orient to what maps
where. That would be needed even if the "continue to oversubscribe
'region'" proposal went through to explain "oh, no, not that 'region'
*this* 'region'".

[..]
> > Actually these buffers provide a buffer for the (struct
> > > resource)dc_res[x].name pointers to point to.  
> > 
> > I missed that specific detail, but I still challenge whether this
> > precision is needed especially since it makes the data structure
> > messier. Given these names are for debug only and multi-partition DCD
> > devices seem unlikely to ever exist, just use a static shared name for
> > adding to ->dpa_res.
> 
> Given the read only shared concept relies on multiple hardware dc regions
> (I think they map to partitions) then we are very likely to see
> multiples.  (maybe I'm lost in terminology as well).

Ah, good point. I was focusing on "devices with DPA partitions of
different performance characteristics within the same operation mode" as
being unlikely, but "devices with both shared and non-shared capacity"
indeed seems more likely.

Now, part of the code smell that made me fall out of love with 'enum
cxl_decoder_mode' was this continued confusion between mode names and
partition ids, where printing "dc%d" to the resource name was part of
that smell.

The proposal for what goes into the "name" field of partition resources
in the "DPA metadata is a mess..." series is to disconnect operation
modes from partition indices. A natural consequence of allowing "pmem"
to be partition 0, is that a dynamic device may also have 0 static
capacity, or other arrangements that make the partition-id less
meaningful to userspace.

So instead of needing to print "dc%d" into the resource name field, the
resource name is simply the operation mode: ram, pmem, dynamic ram,
dynamic pmem*, shared ram, shared pmem*.

The implication is that userspace does not need to care about partition
ids, unless and until a device shows up that ships multiple partitions
with the same operation mode, but different performance characteristics.
If that happens userspace would need a knob to disambiguate partitions
with the same operation mode. That does not feel like something that is
threatening to become real in the near term, and partition ids can
continue to be hidden from userspace.

* I doubt we will see dynamic pmem or shared pmem.

[..]
> > > > Linux is not obligated to follow the questionable naming decisions of
> > > > specifications.  
> > > 
> > > We are not.  But as Alejandro says it can be confusing if we don't make
> > > some association to the spec.
> > > 
> > > What do you think about the HW/SW line I propose above?  
> > 
> > Rename to cxl_dc_partition_info and drop the region_ prefixes, sure.
> > 
> > Otherwise, for this init-time only concern I would much rather deal with
> > the confusion of:
> > 
> > "why does Linux call this partition when the spec calls it region?":
> > which only trips up people that already know the difference because they read the
> > spec. In that case the comment will answer their confusion.
> > 
> > ...versus:
> > 
> > "why are there multiple region concepts in the CXL subsystem": which
> > trips up everyone that greps through the CXL subsystem especially those
> > that have no intention of ever reading the spec.
> 
> versus one time rename of all internal infrastructure to align to the spec
> and only keep the confusion at the boundaries where we have ABI.

That's just it, to date 'region' has always meant 'struct cxl_region' in
drivers/cxl/, so there is no one time rename to be had. The decision is
whether to decline new claimers of the 'region' moniker and create a
document to explain that term, or play the "dc region" ambiguity game
for the duration.

I vote "diverge from spec and document".

> Horrible option but how often are those diving in the code that bothered
> about the userspace /kernel interaction terminology?
> 
> Anyhow, they are all horrible choices.

Agree!
