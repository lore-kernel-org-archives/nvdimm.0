Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A82286AC
	for <nvdimm@lists.linux.dev>; Fri,  8 Mar 2024 02:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709866411; cv=fail; b=HqJHNIATWveL+hyB1Le98Mawg5nV9w35IxsKrTnWu4Oz73col8qvTB2zZjXS+lxTmjjIGC39iMNIx8F774SP0O4xxXbybpVdPgwCFPL7o7YW+coYxBv3YLUHfp8bB/k52TRCmVeMzZHa6UtTR8I4lpJIUiPj4Iso+ziWXTOOxJM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709866411; c=relaxed/simple;
	bh=A4+WAkba1l6LOBpCVYoG3ahnValJxWv3PJ93CbE9ooI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=V4sblb1NRHcsXRdAQsii1bc+2CmUhvWNZHDJ7kTEoEcze0nxu8efS9+JjoNrpJeu15N4QRDIx0ecA/cA1BMRq/827EMW4MsSw3e9dkYn9oBV0tzd58DJKmIpf1yupAXuBgTkze279uYkHoWsQLODnSrGQiGvXSpeZDHTKYjJfhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iz3CbdRU; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iz3CbdRU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709866409; x=1741402409;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=A4+WAkba1l6LOBpCVYoG3ahnValJxWv3PJ93CbE9ooI=;
  b=iz3CbdRU1oIazZvqCsh4srCPS1go18DN/MbkU6O8riojvY6epzG/UXiY
   vrfPFV5r7MrvI74Fp2jkxQouMtb2OXc9IXcQ2MNDu8IXiOsMuL921XUAu
   mib5xWlj/thsgCVHvqQNlWO4L6siqFeEBh399CfxdntEu7rl29fZYbKlx
   KEiYxza092Dxi6PL6sxwhoJcvguasLgZYifF2cX9LCVKJ6Q1gtPRjlvSc
   mvw1zDLLw4SIuSNKaFnAIPbK2sr+6z3LwrC/RRIHq0Hq8sQRFsJx1Kahw
   23dlbE40xqfQSGV+6L0uquZJDrqLeip0YsudqbsdEB+E+H+ZUHSLztLYv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4432088"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="4432088"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 18:53:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="15010517"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 18:53:29 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 18:53:27 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 18:53:27 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 18:53:27 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 18:53:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G4vHKpZm7o4txS9HGpQCq8XT/+pl8jktlKCKBpJ8rK9Ty1K+OVTzrxzSsgvcpyntf7sAD8sDb13BBMz+RLUiToGTuhIyy4xaPgi6e//OruTIRxiyTw3HPhehRsAYUSZ/BRdyJCffujkD6IWv56QovDDYiD0fAo6JFsw48/PGG8VysP/aTuOTwjNWjBT2c4WjTxbWYpdgJ+iOQSLyGJ7QI+PJGkUzSU578KpbiHT9osVoyMyhQVskJAJh3JnuGA/3LyZVu7idrkzUGPgQINCKvKfMBsXrRCFmvdVzYN2qA9r4EwbZTG/nh97Vn7GvDN2zTYqfDnIrZS02SJbz5DPGFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cEnwiZ5jLnG9zg32aAPoTUpazBNeiNhrCbBahSaP0bw=;
 b=AIkZjs8g2po6sesMB7K3qGz794MzjAVcz4JUAqzF0hBV83L8kO08PQczYe9zmL+bV5h6n5ihjXaeickvsQ6qHhkSPDt2ZClI6wXDR3ISNK8Wf9LzaUCo8tn1RSrawUCyDSlFU1eLDd2IppthJ1sccHcnm0MfXwZGV5pTq+KwV9tLKnytSRzTtb0cCZi/yPFCl2GzkYjJ/wOaFNrUdZ75NYuvwfrWhiVA2qgtczQsEuR9r4/OB67YT19cueEvDTjjf7GMrU5/lTzgxYGDY/V6W58lO2vLEulkRBpLkCQMH0NIKoHwT5SWQJerhPv5xT0wmCRK7TKC0XP6XvBBw5KLTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH0PR11MB7493.namprd11.prod.outlook.com (2603:10b6:510:284::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.26; Fri, 8 Mar
 2024 02:53:18 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7362.019; Fri, 8 Mar 2024
 02:53:18 +0000
Date: Thu, 7 Mar 2024 18:53:16 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Jane Chu <jane.chu@oracle.com>, Dan Williams <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
CC: Linux-MM <linux-mm@kvack.org>, Joao Martins <joao.m.martins@oracle.com>,
	Jane Chu <jane.chu@oracle.com>
Subject: Re: Barlopass nvdimm as MemoryMode question
Message-ID: <65ea7d9c710c0_142a129493@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <a639e29f-fa99-4fec-a148-c235e5f90071@oracle.com>
 <65ea2c1a441d_12713294d9@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <a0f62478-94d5-4629-8a81-81d6876beaec@oracle.com>
 <65ea60971700e_1ecd29472@dwillia2-xfh.jf.intel.com.notmuch>
 <36816706-cdf5-4bd0-9be3-0521e2107f32@oracle.com>
 <0660501f-ae9f-48a3-a1c0-f19be8ca5f02@oracle.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0660501f-ae9f-48a3-a1c0-f19be8ca5f02@oracle.com>
X-ClientProxiedBy: MW4P221CA0013.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::18) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH0PR11MB7493:EE_
X-MS-Office365-Filtering-Correlation-Id: e98746e2-a9d5-45a6-8eac-08dc3f1ae8b1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7jBEnBHKJiGuLXecitiCHhFw6Bu+vmx3qQDOCbXRp9inJHA1UaDmZIcPUcaEGIZhmuLz614zL2vnsxOjgeKW9JBq6SZXJ0z9IDIt1WAtSV7uK7e8YVXQj6HHPLhts+1WmdVa9lYlFTe5uir0BAEwEC04ok6UOm6z3WNHFQWF/HvuItkenaj/9dY6/MXgMDJ+r9CgkCKcQNM+y2LKigXs5F6DzVBigY80D5cF8UqJS+ErXwLY3S2rsLgx7umw8o+natCzIPbiqORhn0zQ6SYBEaY60PUDRiOxsb6vrRWpurbbrq/LC6o7ybDXJU5rIqOvv4sxS8OTk2pMLuccfEWbIUJSlJ15By3/owHbJvPCTw3xgtKuSAs/2FlnlZclLMRy2NTgDSaTp40nVOeeZ7ugKcEXTsXJhfvNqXA16vEyNaYESUlAKoMxRAwokYe5rjtLfrJDBZnFOaPh1Vr0PoGnThaEAyV75mVuFf4+3zsHTrtENsqckpVG+IqHx/5Aoy3niJRLZGiEFLvf9iCEnbQmC2yyx3fgM1/lnSoSMqYDFMLKakejXSWH366kkN0JfGKpvQzWEwa8WlOvVc1nJZ32VrKpgwQBALAzuPrMWc4cp7U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?KRD2l1uE5NOr8JJMKMpEs8TMY9bHk1upIcU5/GDEfCbfzitgBejK6qZYNH?=
 =?iso-8859-1?Q?ADh2SnvOWFAkk9Q1ce0AsvEgi7A7ZtDe86yHWP1gnLgvk6IeSMoT8Uba6q?=
 =?iso-8859-1?Q?eHVqBiy4hY385oPXzXHDiwRwoAkfVT5PpB9mGRcQc88fP/Kv/xaQBmvpyU?=
 =?iso-8859-1?Q?OT/vKQsx+fG8Vq5uVFYiTWe48BH6cvtI2U9hBl/jWnsPY0+R2zcrYwWPEC?=
 =?iso-8859-1?Q?LyNfZYRQm94vBXxJLrH9i1PnPN9iyM67pMqHVDNoDEVqkqwVZVUPX6gMsw?=
 =?iso-8859-1?Q?8se94vGub+FxLjTwTPZzJMz2fmXzBc/7SMPtITnXTjF3eEkVjzIhOhjEOV?=
 =?iso-8859-1?Q?d2ADyPcjekwa5H3fZoh/kn3/vghfhqC8pyKq/v0iQjeb4GeBACBczreZLQ?=
 =?iso-8859-1?Q?E5ihrymS8W85z2sG8YJWDMhr2FPfplhCDI5OriJVSkkmgEyvF/9jmPIDtO?=
 =?iso-8859-1?Q?7sysqpycUfBLYDkuxIcXc9nC5uLdo4ZYTiB/k3j9TEBrLX/8WB9bQV/J3q?=
 =?iso-8859-1?Q?0S2jhRLbxjqIJtm6JrMarZIPYd6jCpRhfk/aO45XLjjvJaJCDyEJ/3ebGe?=
 =?iso-8859-1?Q?sBD6xhBNHa8+YYWELRSoHAvGYmOfJIcJ1+H0LjdWIpyltTvPFxXXB7x5Jv?=
 =?iso-8859-1?Q?9R4xZlLRWTnCVQYCinZOosH+AiCxKpDChXtFxHsi2+PAyImsVf11qFvSuU?=
 =?iso-8859-1?Q?60D7+wL/ZpxuDQW3X5lw+AVTT4SyLEEFWBydZ6fRBu9AUJ9VKsSAUJb2ab?=
 =?iso-8859-1?Q?X1pD7Ch2lQEcUwcm8ow+mRTWtms9Raq2zv6DO3qid9BDxxBPzeh+PyTfuG?=
 =?iso-8859-1?Q?qpXjK3WolnmM6X7zIQMQeh0ZzsMtkZf+x0VgyLf9z49sXQHwoay6gk8ecA?=
 =?iso-8859-1?Q?P2UVUC56yZq9bYVbV9Lm+F5/brgaRMzdyP9rafMyBD7EiArBq+CICgr2hz?=
 =?iso-8859-1?Q?ddkWSOn9k5GKUgi0ZCSoEDlnJHsn9dRgRSddXfK2qgv6vzKpaZxCPAiIgz?=
 =?iso-8859-1?Q?zpSLFBjh3EPHSpsVT6byNIcQjXNgqiptE+QuaZDzp5eqnoYG27tyaUEhby?=
 =?iso-8859-1?Q?VZhMkZQvbOm1bK+ZHlJyqQDC7SbFDdoN1hgs99+voXdhbX6todhK6JI2i2?=
 =?iso-8859-1?Q?BvLLXwBpoNOZr6gCUs0ragoP6Q8UJojm7paOqhprwwzdABJJDv+3Kn56Rw?=
 =?iso-8859-1?Q?gHA8W66ZyZcNr2jMW6VPkPJIJsgzi6u6ESPcaZd2BwhCFD0RxOB+1d38WS?=
 =?iso-8859-1?Q?rEvokx2PVYbJ0tVZUBsUD7vZx7/hNiUaCZ3bMtljtQkOwHqxKqoWUNBCYw?=
 =?iso-8859-1?Q?ZhpJQ/ipLy186J1NIhNDj9NOGmuxd+OerKQzm5rvKbTzxR4BLdj9s60i5H?=
 =?iso-8859-1?Q?2OyVgP1ymEIO8cjR8y3gjyX21VwoGZikszwIRDyHpB8vM0T92CXdiIEEct?=
 =?iso-8859-1?Q?8C/1MFMzTVrMXktllyzJ/fd70lEWCcY+nu0xVw3N7awgrPmqQ+dD6vy/kU?=
 =?iso-8859-1?Q?LYo6nefqQLRZSr+/MgKOLYS4XyZuHtnLsM9pRlpZNCf6Dwcdp6cWKekrHP?=
 =?iso-8859-1?Q?rVIfJqc5njeb8K4gpbsBDtRqm9qLMeIOh6acT4LY0gJMOT89NwR/+xoBvR?=
 =?iso-8859-1?Q?DsVOvzgljpDMWJzdEAnxUEebuLFxfWUttsUlnKRScaMt2Ap1+1mRitdg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e98746e2-a9d5-45a6-8eac-08dc3f1ae8b1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 02:53:18.7153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCIMHd0bAGnwb1u9BmkV3YXqEqPiFbFqeHPFCuiBam/Emk2hmhqsVfeGb6jpwlFf9Bl1VNCRMNXs2aC0fwAe3SV5GmsIrv65+WlfVCbES7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7493
X-OriginatorOrg: intel.com

Jane Chu wrote:
> On 3/7/2024 5:42 PM, Jane Chu wrote:
> 
> > On 3/7/2024 4:49 PM, Dan Williams wrote:
> >
> >> Jane Chu wrote:
> >>> Add Joao.
> >>>
> >>> On 3/7/2024 1:05 PM, Dan Williams wrote:
> >>>
> >>>> Jane Chu wrote:
> >>>>> Hi, Dan and Vishal,
> >>>>>
> >>>>> What kind of NUMAness is visible to the kernel w.r.t. SysRAM region
> >>>>> backed by Barlopass nvdimms configured in MemoryMode by impctl ?
> >>>> As always, the NUMA description, is a property of the platform not the
> >>>> media type / DIMM. The ACPI HMAT desrcibes the details of a
> >>>> memory-side-caches. See "5.2.27.2 Memory Side Cache Overview" in ACPI
> >>>> 6.4.
> >>> Thanks!  So, compare to dax_kmem which assign a numa node to a newly
> >>> converted pmem/SysRAM region,
> >> ...to be clear, dax_kmem is not creating a new NUMA node, it is just
> >> potentially onlining a proximity domain that was fully described by ACPI
> >> SRAT but offline.
> >>
> >>> w.r.t. pmem in MemoryMode, is there any clue that kernel exposes(or
> >>> could expose) to userland about the extra latency such that userland
> >>> may treat these memory regions differently?
> >> Userland should be able to interrogate the memory_side_cache/ property
> >> in NUMA sysfs:
> >>
> >> https://docs.kernel.org/admin-guide/mm/numaperf.html?#numa-cache
> >>
> >> Otherwise I believe SRAT and SLIT for that node only reflect the
> >> performance of the DDR fronting the PMEM. So if you have a DDR node and
> >> DDR+PMEM cache node, they may look the same from the ACPI SLIT
> >> perspective, but the ACPI HMAT contains the details of the backing
> >> memory. The Linux NUMA performance sysfs interface gets populated by
> >> ACPI HMAT.
> >
> > Thanks Dan.
> >
> > Please correct me if I'm mistaken:  if I configure some barlowpass 
> > nvdimms to MemoryMode and reboot, as those regions of memory is 
> > automatically two level with DDR as the front cache, so hmat_init() is 
> > expected to create the memory_side_cache/indexN interface, and if I 
> > see multiple indexN layers, that would be a sign that pmem in 
> > MemoryMode is present, right?
> >
> > I've yet to grab hold of a system to confirm this, but apparently with 
> > only DDR memory, memory_side_cache/ doesn't exist.
> 
> On each CPU socket node, we have
> 
> | |-memory_side_cache | | |-uevent | | |-power | | |-index1 | | | 
> |-uevent | | | |-power | | | |-line_size | | | |-write_policy | | | 
> |-size | | | |-indexing
> 
> where 'indexing' = 0, means direct-mapped cache?, so is that a clue that 
> slower/far-memory is behind the cache?

Correct.

Note that the ACPI HMAT may also populate data about the performance of
the memory range on a cache miss (see ACPI 6.4 Table 5.129: System
Locality Latency and Bandwidth Information Structure), but the Linux
enabling does not export that information.
