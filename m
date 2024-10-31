Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A680419D07E
	for <nvdimm@lists.linux.dev>; Thu, 31 Oct 2024 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730386147; cv=fail; b=AqLywH6XbW9JEBJE4USzCzNOw5TkpZPqostqTSEdadrcRpnjuSWsEjOSmeUDdkgNA5PlK1vDccM1aQOzv+Wfd0/umD6zZIzhjHPk0YiKr8N1WHHe+GjjYJBpebUsev0tsaWtKOBIwPVZZ8vpNogE+qC4ncj5CvAsXvWgAkNY9UU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730386147; c=relaxed/simple;
	bh=QuK1olTQdxzJQMF5lGc3QldY7lfKvlbXpz13DJQG83Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bs6CnkkktrF0n03fjlBStv6SUstXGSCal3DAGdAE4U/YMX8gZ4LEoJGZG+Ep3qSSbTBYMmAaDuKAEMUFoa5PFxHYn1WK4SomcNiUch8q15Wkfsz3PhMug8dYKfobohiW9ULIx7YoYGFXtDHu/+cBy8Xvgn61F2Q+sd9AHd6KAjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=evfPPMEK; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="evfPPMEK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730386145; x=1761922145;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QuK1olTQdxzJQMF5lGc3QldY7lfKvlbXpz13DJQG83Q=;
  b=evfPPMEKzPQiweUNCB7oNf+astzmfDgnrJxs6tUlhAbuwlwPg16wC2Zs
   AH8+OltADeLX7l0eO7bsVVluoclGbeB2yfobK5o4EL2xtU5Rafj36rHfW
   73SaJl/1Zi72FLnI4XpzVf3kV1jzhbq4oLNdjmOySVGKIaD1pZ+wumVD3
   J3S/X+Ib/xmWOe+VYWxweY1qYoEajV/mVTmxwqJ9LvrbyoxbjpEbY/lnw
   xMa79QSEWr8CGDqSGKEzqx/KC1muONDvkYPtVCzJRylC+TBCR4Bc43OEo
   ggyX3EIaex3fyZkIHYGKL5PnOtC/RdY2kVzi04O6Pi2FomuUGviyS4Tpv
   A==;
X-CSE-ConnectionGUID: ER3+DpZdSw+283v7BbOAsQ==
X-CSE-MsgGUID: LNeK/YKMSsmL0dLcIpZ4ug==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="47600519"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="47600519"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 07:49:03 -0700
X-CSE-ConnectionGUID: ILAajtqpQsuUq/YXRHg/Tw==
X-CSE-MsgGUID: 7FHBsGaCR++ycVQqU9QLeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="82806579"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2024 07:49:03 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 31 Oct 2024 07:49:02 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 31 Oct 2024 07:49:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 31 Oct 2024 07:49:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gorOw5HkKTQo7Jo8MC7A9q2HC4AbVK63V7NaJR7+a4U5Pc/IEzvuz1EKpwgwWcT9fQZNGuR+8Yp65JeF5yvj4iYntDOEGhUgsbvzrOBxP9xm93q+vzzha5n9Fp+lFUBvTi84aNDW4SC5ZKmprHVCJTPiF8ln4MT5y//Grag5MMM2TP5p8yFa34evNGTByGi1ffAHarmt8Aka4HOp7z1bq8ORKNoGuoqO9xAxg+b16q4ufKSTe5i0QALdOybpr78UJWsW3sNY4u5wh78fdmujiK4uAsgxDame9k3YmfQsQ6VPYGxjJ/FTvVia55D9W7rCvWLefCYHkT6qaJ0z4hh4Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uJ9X0Iiy/uKNDh/RiTEm6C+uMTW2Px1DUUhnAmVUPYo=;
 b=uiHcgnWs7bYb2gA49JoPTqX02FROEEkaDR8pU1FP7d6oSNwxSDXfNkZ04CdgZZIMrOGmj8xMDM7AWRH8Iyjh6lylX8pA8/RNf69i0sa6YCZNkMYYkCro766rCIQWf/Tqf5S9mOpTUUX4wA0ZudJ/KBGMWFRk645/ecC66Qo9An7cHCrn4TXd+4Y6BnshAjJ+z9TptYxPoryAaeWu3DB629Q2aBX/fW1nryqD2i07MDGM0qtaM/1aDH8pPj0glZZpmtlEDurCSJc1JibtDDQc+FgeaItoYKwNwvfem+chLJ2NmMG7AlYh1RYq0RMO4DYIWowXA423gYIsPxuiHuuAvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DM4PR11MB6263.namprd11.prod.outlook.com (2603:10b6:8:a6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.24; Thu, 31 Oct
 2024 14:48:59 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 14:48:58 +0000
Date: Thu, 31 Oct 2024 09:48:53 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>, <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>, Navneet Singh
	<navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton
	<akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Kees Cook <kees@kernel.org>, "Gustavo A. R.
 Silva" <gustavoars@kernel.org>, <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH v5 08/27] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <672398d5caa17_7b1f129472@iweiny-mobl.notmuch>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
 <20241029-dcd-type2-upstream-v5-8-8739cb67c374@intel.com>
 <20241031002422.cu53abpaimetzrdx@offworld>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241031002422.cu53abpaimetzrdx@offworld>
X-ClientProxiedBy: MW4PR04CA0213.namprd04.prod.outlook.com
 (2603:10b6:303:87::8) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DM4PR11MB6263:EE_
X-MS-Office365-Filtering-Correlation-Id: 44741af5-40ce-412c-7b24-08dcf9bb26da
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?w2vg3ZbWysjdAonfNvtyMFah6bNBPlkqd/LydpnislZ7Eij+bmfwXaSjtR9E?=
 =?us-ascii?Q?XI6s+Fg7npAE19t8aNSUH+sDTXT1MnGFcjJ290rKcKBG/2cPMEcc0tPIpvaq?=
 =?us-ascii?Q?WBOF1Q643uO1fQqkBhf46GddJHCRLyjB0Wd7w3Osz7fltGKfkzycA0qjWmtD?=
 =?us-ascii?Q?GJiA0om4rZorXUEOPRGmq7gLLTknSEAdDppZx9N9BlZo2sWKBinw2P9k0pvH?=
 =?us-ascii?Q?YIRjqLIT4ZM6B7EIQNLUq+ukhTXi+JXui+NG/cU8GvMXEYot/yU1FOjCT6dr?=
 =?us-ascii?Q?akqurMHSv8dDAJCHTV6H2NSVIiwgqHNhaFOzZuDmebn40QrueXQm7v6FNMJg?=
 =?us-ascii?Q?cj3nrXJL+kYpt8GzfJsO8Yq3M4FM7LQMMLyHZOb12A/aUh1zBRfCOm6AnVr5?=
 =?us-ascii?Q?HbZ7Gmof+/WO61nq4xaf7ff/j9qG4fDdP9tVTt2trO/bhV+xfZGirB6IeaIu?=
 =?us-ascii?Q?bEHXI1NA6biFeOGdLOrjIH+uH3swuvfAZNaMX+va/I16He1fn6kpllrl4HRL?=
 =?us-ascii?Q?n1Asyf6dBS5M62OInKG8zuK/bxm8WrHH8K2OtPYcfe1Kwge6TVMbPU+XoFzM?=
 =?us-ascii?Q?L2vZ2fIDGp3KbN5IHFrymCQe+sNcD1BewcYWIPevSNVzou3sOUT6RgkxsT/d?=
 =?us-ascii?Q?nPnpgFErnrlOOPf/KLSPDgMi1AmHsokCzpihxjYtzlgREOKUYyz4H4ObP/pk?=
 =?us-ascii?Q?rmTmId84UAfFe714iextu6yauNQhHvDvC/8o2OpLNHUBFP4pWCTsQmGrEdZs?=
 =?us-ascii?Q?0cH0XoRwe5JeTOxyRagGX19x4xsF/aVq/UopweMIh/Dqy0xDWYuqzv0berVW?=
 =?us-ascii?Q?uZs96op0qhjA8wRSyYxg3+ulYzG0UoxReN2wibL5aL9gkuaZpJY7/fIgLmhp?=
 =?us-ascii?Q?lDFDrL6bP9NsBOW6sO38TKiCKxNTY0d6dUJo8s6atQJZlOV8/yZ+h/RwOFlf?=
 =?us-ascii?Q?eIMrWWHb1G8AwQrrNY5XYnk7yobW4hXL27GrkyAQfdnE9njor+yjYjxW3UWR?=
 =?us-ascii?Q?jDeaRGIrJEgq0SfVuPkWCxILHnTR8d1K4O3iKrfZSHbC0v7o8DC/DkvTbk0H?=
 =?us-ascii?Q?re5WGbY5TLeFqD1RW9m71u819TKAUW7dk0QK8+PgfOCEYwX9b46d/FmCV52M?=
 =?us-ascii?Q?+TSfXNxKDvJiME76+45ua+xJnNnAd0qCLePgwl4QKbqAJ5fhGEqKNNqPQfUB?=
 =?us-ascii?Q?CQ+/dBMBsxRKAPOVPJMs97BIemelisS4Fc2KC0Gg/YnlzwU7kTayIjcXLTfS?=
 =?us-ascii?Q?Dx/nV24uGCAk/OhfSVHiTR6pMnzGyNBwkjQU60M+Oq/5pGiIh2POOWFOj4J1?=
 =?us-ascii?Q?ZG9jHZqoHJyh9w38yej2w+x6?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rfd1D2Wg5A6aHaAqM2vZOoJgeSDlZy/cWEibBpwczBq/H36LSMwGIhpVi4m6?=
 =?us-ascii?Q?r49ATNgKhpCLHulsbvQIxtqvlNZjvQEC58kNPhjgB6goUm0Pdgrg6zWlBum4?=
 =?us-ascii?Q?PbYTI7F9+OP8ZjKlZ/r/VIMkcXzGD2qRTERY3Jd0Bb/l1Xqdj9hAkaaa7xlO?=
 =?us-ascii?Q?5QOmHGltCfrsLgP5VsbXUI+tV7NXOK8g0TbdFaqD2qyjld1dH/06SOiiWaof?=
 =?us-ascii?Q?khvilGdA/oOvviJ/Ka1k3kCoI8p07auOTetG2+pXX8bLujx7x4WJ/PHUYvoH?=
 =?us-ascii?Q?LoBwQkWvNc6wpvKr7+k8YAQXi9WfUq7eJhy+c5Emza3aXuQYjpgnwkHCjl7z?=
 =?us-ascii?Q?vVW64wFIEUPU4GuGCN0y6sBka4IK0gVkjGy8cgtie0XFi/l2rJYm/Ysd9v0m?=
 =?us-ascii?Q?j2MKyZ1yC9E76B/cOQYe11ZgjtjjgXmbwfc+vZSkdNPGIwRsZd8iHMwfUBA8?=
 =?us-ascii?Q?kL0esRQWVj3hWxHSAZ1gzqmNztYWR1OnVyXQtoBGQ6qwjPcPHJ4WRBaoE2aE?=
 =?us-ascii?Q?alYpIv3vcmTMEnPmpFxsnovdqf4tbbyOecnsslDwcD6BjfHG3yeF9XXFtkaR?=
 =?us-ascii?Q?BH7g81wi7ACmrkulO8tumGTJL2l1J7vLOcwJoyJK1+GLhizDxPo489R3lubT?=
 =?us-ascii?Q?vLeDgINxo8PcIwp6a9KdXR/ZcnO3gRHixW/EbqMMKPpcfEnDImBbV5znFab2?=
 =?us-ascii?Q?p7p10qgebga/c2Q6Z9T/fSODMlqNcYQIY/ChD9SAipKAIbtY7/lpsaKWapR8?=
 =?us-ascii?Q?Gopb1NF2bwlgviJLw7k5saSDP+f9w0h4EkmqlW5vva8jtNBzOGtw+nhE/7om?=
 =?us-ascii?Q?NxM1/+c+MFvl8lKo2unfOsOA4xXR4+kHZr/6lSTGcq8QHUJDEdgRWvgzlUuR?=
 =?us-ascii?Q?RYE7Zp1DRa1GZy23Z2qsz5oRKRDXU6hLZGcPy3vf5esRlYBwg9RskPrbxdWK?=
 =?us-ascii?Q?9Jf2z8W8ncDicpGLTLQ1RJWIGO/1rUc2iot8VdKwrDOzfDJwdjWH5qs6OXxU?=
 =?us-ascii?Q?C0S2kLT98xvEI1lxOhbiWWQ46LpAVNZb/e79jCg6G7t7hji9XdLjVn0j+5tP?=
 =?us-ascii?Q?sFaa1kdh04noBHsAsMkJoKhlag5FnAmR153JRRI1peDV1lj+mt1VDWtSBylN?=
 =?us-ascii?Q?yE8xNmgjVb1L9kt3SJGlDIxI14M/Wu5E3SEq6/sM0eLzbs5clRuIF2cbseVy?=
 =?us-ascii?Q?aUU9/NjAPKgUOZKqeHq149wdHtaczs7GbnNUDaZALDbS/KDc9qOUXFgYg5et?=
 =?us-ascii?Q?eBLXpS4yXXGMWfUzooxoCddmMQNoyaOuL2Y2Urqa9I3PhWIyUqMGAOEd0isb?=
 =?us-ascii?Q?vWuiOj4zjMhYs5lKCYrRzGj1pVFdRZe9j00RaWMVw002FvblXqPk11sqxrwT?=
 =?us-ascii?Q?8Z1rt7AACAeEUDSrUoYyAqoi89Hi6aUxCzBsPcHpQ2JVbBUOfbWXhBVAHY+T?=
 =?us-ascii?Q?5GweBC9GwlrlvMJAxMtJtJhva1YrF9Gs5cAbAfWjXn/ZrJ6p9Uo1IdlkIE4S?=
 =?us-ascii?Q?d4bDy2tk308lzYeTE4HZuagT39HyfiXmMuPP9O7B+V08vNlewmEnEy5260aJ?=
 =?us-ascii?Q?nsxqMW9ImjW5p2QJzaVZpwBT97Rm9ROAVy4dmaNn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 44741af5-40ce-412c-7b24-08dcf9bb26da
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 14:48:58.8588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TDDGYIJFtwHcjF06DkDjOgmTTATq0ldZaD1kgoCjgEI2/nU2v22+gi9/vbtIqBnZDfSlXRaiUXb0dqOVmtho1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6263
X-OriginatorOrg: intel.com

Davidlohr Bueso wrote:
> On Tue, 29 Oct 2024, ira.weiny@intel.com wrote:
> 
> >Linux has no use for the trailing fields of the Get Dynamic Capacity
> >Configuration Output Payload (Total number of supported extents, number
> >of available extents, total number of supported tags, and number of
> >available tags).  Avoid defining those fields to use the more useful
> >dynamic C array.
> 
> More of a general question, if anyone knows: why does the spec define
> the fields in that order, and not put the region config structure(s)
> at the end, as with all other cmds, afaik.

Because the 3.0 spec only left 7 bytes of reserved space before the region
config structure array.  One might argue that no one would ever implement
the 3.0 spec for DCD but at the time it was seen as an unbreakable
structure.

While it is not impossible to utilize those fields they are not required
right now.  So in this implementation it was better to use the dynamic C
array's and leave the use of those fields for another day.

Ira
