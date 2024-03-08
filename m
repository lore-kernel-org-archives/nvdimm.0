Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98179BA4D
	for <nvdimm@lists.linux.dev>; Fri,  8 Mar 2024 00:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709858976; cv=fail; b=W3NcUY096x8QnJMbzUKU8cXtbYLZzQ3N28XCTyvbQJ4bdVp38NK3cyKu4oCEooBTYF5ytggshI3b1MwNKySWRsbwsGsTLntUOviwvCDlOn2xr/EmA5dBgumheHteFYx+jZnufuPmAZqlcrT009MEnvMBBjzk9Mq3Y5hDPB33wCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709858976; c=relaxed/simple;
	bh=y6mD6WnYeDrjUcQ9skwEljpABm408ZoRA8rQwE/BaQQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GJu68yD3P5iIeM8kYgGIAo32Ci9KhoDjeERpLaw4+tnEd5V033a1X1VlMmLBkxolviwfazSuPtn8oGcq3c0ApNY/hN62GJq8tX4UYJlo0voXopA/vF1tdAxdDdmOCXj1bnw7BcHwQq6bEcP0EwyeXsUtns+sh1/t0uSqiBMNLO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=foo305kW; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="foo305kW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709858975; x=1741394975;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=y6mD6WnYeDrjUcQ9skwEljpABm408ZoRA8rQwE/BaQQ=;
  b=foo305kWS0XhkSAL2SPdmQb/p7WXlyRdVnOgbkEiCZLKDTCELfc53RHs
   /BI0hJ4EYqQjnc9CvE9uBSOKRoejLK2wKWUwx3Y+ZNvoJEHBRSkOdC3V5
   VN19oNldUuRcB3djYuOdII6CwO1b/sbPTk3grQ2GQM98WLrmLYvLczTP3
   6sj0fBytvXkclIXoOx94KVZasHQSrjb9xPL+cqLZfLL0Y7+K2eQXtq+K/
   TAsGTyBTJk8OCP5h0FXdZCUMzB09rhXNja+aSHGB/qXwuF/ADrJqxZQbr
   7Ek7UuqsN8G4QSgF6RbNy2dQAAVLmAIgm9auZn92w+HZ/JCGv1X/pzpat
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4408700"
X-IronPort-AV: E=Sophos;i="6.07,107,1708416000"; 
   d="scan'208";a="4408700"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 16:49:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="10273239"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 16:49:34 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 16:49:33 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 16:49:33 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 16:49:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpvGDtBDA3/CRxeC9AAkMunroFgNN4rmazgghSAvJ1wi6qbXDdhC3rsKtT4hQypDf+JmwH/aiJ9EiYlmWWkcenMBFXPOVfXYQHjxY2Y87Aa0txjqnnl5Slc7A6ujquxukDCyZ8x1l1Ae43u7PZt37JoxUgWu9D4S7EQDGpkkVkDtBFe1YoBnRXukTQCwkP6Nth9Xp65MbMzDl2IBmr1Eu1GD4sCEttmaNnpAu5NvpkGm7y2QtU0nBoQtmUtPhVAW6IFrZMqPni+3VgHWY5FKn09VpCq9PV2z4gM7qToqHUqSYTgwCxmlGJd2OngNs4Nkk1RQ8FCCrHC44/9irl+WLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q90tiaL/D+vLn0KGcVqSQSPo62MR/ZYcALXIua2ukI8=;
 b=FtU8pbJ6ig+Qk6YfvtPcYry7toPQwv7V86+wZOOTJIbR15p2YQNP1/gxv3pMLwiC05Cv27kIm2v0GqSpX6DwlMjkO83YkJ5GjDfS5nWqlhAbmszcSv+zcyI69L+ghCu9itZsr1+74xupucINsODaH/kwELSJkXzcmMu9zusGByzcq8pNs7Bam8TG7y+WHex1oyXWTzfqpzGHhKmsvr6fQ9KNf2VjRX2W8vf0OQjRhTqHVeieU1keA/BfsuiC9fr4xzQ+4B9TuIQQWCmYGPNTPfqT2UAyz1Th8+315a044PdrmZw9eiuDEQqgKwbtRRGj32Edp86x2iFJin0s/hLu3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS7PR11MB6064.namprd11.prod.outlook.com (2603:10b6:8:77::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Fri, 8 Mar
 2024 00:49:29 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7362.019; Fri, 8 Mar 2024
 00:49:29 +0000
Date: Thu, 7 Mar 2024 16:49:27 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Jane Chu <jane.chu@oracle.com>, Dan Williams <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
CC: Linux-MM <linux-mm@kvack.org>, Joao Martins <joao.m.martins@oracle.com>
Subject: Re: Barlopass nvdimm as MemoryMode question
Message-ID: <65ea60971700e_1ecd29472@dwillia2-xfh.jf.intel.com.notmuch>
References: <a639e29f-fa99-4fec-a148-c235e5f90071@oracle.com>
 <65ea2c1a441d_12713294d9@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <a0f62478-94d5-4629-8a81-81d6876beaec@oracle.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a0f62478-94d5-4629-8a81-81d6876beaec@oracle.com>
X-ClientProxiedBy: MW2PR16CA0009.namprd16.prod.outlook.com (2603:10b6:907::22)
 To PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS7PR11MB6064:EE_
X-MS-Office365-Filtering-Correlation-Id: 19e79aa1-cb8e-4b3a-a626-08dc3f099c66
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4xfzK7sgE17qPYVUPq1OzE0R/JUJ2aeJ49V49KXEygydbL9ECOEoT+WQOqLXp5u4RaHUyruFARc3R+pWowKY7baWf+xciSzQXFrmGXYX4a75YjCqolzQhPU+lceJdZcHxm7YhC6zeKSaVVIRsxt/dUX2uW0jbR28Nw0pHBilNsfPuwmTPWUm1K6LhfKmQOJIXz4s/txCTke5cv9mRv3oHmUetBwNL6H6wnbbKgCAvuXhmMHMZw4NxoTSJrBUGKKBfI8EKD98GOH5xFGEICf62/jEtFmuv6ByE1JuksVMWP2fVECu2azXwf5z6Q5cCPel94fzDPXTweXxk9NbSo/wLHtxIuRWO5Kg+HwBuMuMBV0CCLOs1MfMYGE264wClf+v1btBNZGk+TI+SpHr63vw39rTOlXnNla9ih2EIoBZmUt2sdrdmLFK4IT9WX/iaosCwZwde+MLpKZWVSOe67/FKGCLtnyMjw8dJuETFOcW1KJjxqdsKzBkBtjEefzwBBfSjdwTiJRby8dnOtVAhiwcSacq7boe+KfoMx2RgeWM6WTHF7q6Z+/Gjvhul9SM5Rqok7ZbBuEgFe/55OHbqWK5tRvd+FfcgwIaIpURPPadMdI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?pNlBEu/8wYnU8EovE2cEFuQDDT5VJjSczZCaLN12PawplI3vZiCCiz8xiZ?=
 =?iso-8859-1?Q?AZmgnKgA1h09KOFFdc7VS4zHIaqx/Mdd7GjdkjS/9W+NBBoPMDhRwyEBRk?=
 =?iso-8859-1?Q?cLWv39bzdF2kSw/zjFr94DR4jx2WDMcL+Umqz+XOOmQgKJ7tDZQ2/Q2/uo?=
 =?iso-8859-1?Q?HLElEFzg3rHr9DblTlYPXMG7p7kU+szJtnO2sCBKKEfouUAnl1il/ro+9e?=
 =?iso-8859-1?Q?/hpBD1T8cYX2898RctuvyUb9pnYOL2mofQ0CP5hovr8UBy/f/HrbN0STAu?=
 =?iso-8859-1?Q?7/6GVrzg8NnglKz3sRZEiCQNyC08Gb/TSe8GQ1eLO9iSteLPYP1MsbWomo?=
 =?iso-8859-1?Q?Qvhoppp+5nNmgbmazdCKLnYSn0DqWKrICXycxz5PsznwVBfbgQXQqwUQ7h?=
 =?iso-8859-1?Q?489cTjbROL0EBmHBYAgDb5zmco8pizfFPbmdZZtvh/0Pde4ie/3/YgC6md?=
 =?iso-8859-1?Q?A7KRyEX8y6s5d/tu+WLokIIo7omL1gGo5GVuf06LCIH4ExQpGHgC33Qj8A?=
 =?iso-8859-1?Q?AsRqHF0li8otr4wa+rjBPUKKcB3baYFAKauU0iDBfBCU5i1YGWwcgZ2VJx?=
 =?iso-8859-1?Q?G1PPWqgM1ekTRapjErW+H2NZVI8lATP6km1HyfAiX6ZZCUAZtHFq9NernY?=
 =?iso-8859-1?Q?LFfDLGdryqgraabh/i7V9omAXpQcbQNxTOibc1kX6PKR0/5aEaM3R5flpK?=
 =?iso-8859-1?Q?WPuU1Eeu/Jdxd/IanShv45H4U3LRNvhAmewh8Fvm98vETDjEqq3izrZ+8x?=
 =?iso-8859-1?Q?1BthOzLxBDNQaVtINbD2AvKIXf91cft2dF6Zvgo5aYOeVhCcFL+KCuoOVp?=
 =?iso-8859-1?Q?LvKBSM9LpANYusNMCJiZQLHOv68/QRScbFVKqjh/IdO1/lQZyL+q9APPds?=
 =?iso-8859-1?Q?1szGsfKiO916ah4UQGrm7iG0RDeFeZHnWeldg5Ab+up6g8jjbUDWH7J+/r?=
 =?iso-8859-1?Q?rnsjzEnl/XkptLzfnTsPUMT5tAmchJPF2JtNDdirDEItt3s5KsY8v/47xI?=
 =?iso-8859-1?Q?wpOcvP+F7F2qc4Xa42JiBHMOfw0aHkvuU6Qn5GfheJuZ87D1JLYFGM3z5h?=
 =?iso-8859-1?Q?NLVUXcQh+7vxd+ggzBEzVsbMmxeqinyaKWbXiyGNExF/uC0+VCqe4rRQ9B?=
 =?iso-8859-1?Q?DRayz1jt/ymmEer05J6hNtwRDcvJl6zw7rxtiz3eqAX2JQSoD72fuRbBBO?=
 =?iso-8859-1?Q?MSHmeaak6CpqdPuy+VxRsHmsSs103CP33+UiZZsbjC/C1OqmOp3WPA0PGd?=
 =?iso-8859-1?Q?Idi6gdlWuBFN9ZzNl4DANICzqu0OPOCpF623V4JSqoE7hHs4KK1EXSKgCD?=
 =?iso-8859-1?Q?OE06lVVDbPV+DTaRhMIIY5BoZnypooSwqXfEvm8Il3CbVu4SqHcMuQzCaG?=
 =?iso-8859-1?Q?/7oDj9YV87Xrsn1YOvdXDw1dRK1LcGyw6EKaF6RE9MnYclDBhVs0UC9rZt?=
 =?iso-8859-1?Q?JSsDDDEsANHWnR14WDC0JZQHIF0r3EqFX8g6/eqroOMPqw/HWWOy7Z2l8r?=
 =?iso-8859-1?Q?JuhHahCRUd5QxLTHBxhSM+i7psNVWy5/jYjn1U3vgcAwcSdjqDkb0XqMEu?=
 =?iso-8859-1?Q?sHWXWWXNnqo/mBNiDoM9vdZ/dmWIMhL5cD6L7vHAYQrj6hZ2wsDZcYqwer?=
 =?iso-8859-1?Q?qYacEXbOuPid94gtPGPGDwnlxgYPwMhFbzA9lKJS6Avb9fgwedNdewUw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 19e79aa1-cb8e-4b3a-a626-08dc3f099c66
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 00:49:29.3136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0bhN9FIDihG1ah9vYDYOmaMnj0MUm8LR8igsH6Oal4PidURyDddWxSb8zUSCDWw8QIAGGffckW2pbCLGbACd9wi9qPxc4EwUBPZE3zf4oFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6064
X-OriginatorOrg: intel.com

Jane Chu wrote:
> Add Joao.
> 
> On 3/7/2024 1:05 PM, Dan Williams wrote:
> 
> > Jane Chu wrote:
> >> Hi, Dan and Vishal,
> >>
> >> What kind of NUMAness is visible to the kernel w.r.t. SysRAM region
> >> backed by Barlopass nvdimms configured in MemoryMode by impctl ?
> > As always, the NUMA description, is a property of the platform not the
> > media type / DIMM. The ACPI HMAT desrcibes the details of a
> > memory-side-caches. See "5.2.27.2 Memory Side Cache Overview" in ACPI
> > 6.4.
> 
> Thanks!  So, compare to dax_kmem which assign a numa node to a newly 
> converted pmem/SysRAM region, 

...to be clear, dax_kmem is not creating a new NUMA node, it is just
potentially onlining a proximity domain that was fully described by ACPI
SRAT but offline.

> w.r.t. pmem in MemoryMode, is there any clue that kernel exposes(or
> could expose) to userland about the extra latency such that userland
> may treat these memory regions differently?

Userland should be able to interrogate the memory_side_cache/ property
in NUMA sysfs:

https://docs.kernel.org/admin-guide/mm/numaperf.html?#numa-cache

Otherwise I believe SRAT and SLIT for that node only reflect the
performance of the DDR fronting the PMEM. So if you have a DDR node and
DDR+PMEM cache node, they may look the same from the ACPI SLIT
perspective, but the ACPI HMAT contains the details of the backing
memory. The Linux NUMA performance sysfs interface gets populated by
ACPI HMAT.
