Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA2115C8B
	for <nvdimm@lists.linux.dev>; Mon,  5 Dec 2022 20:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670271029; x=1701807029;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IPQyatyOhbtZFS4C2P+IDnYnvbshWI0XADXhRbWIZ00=;
  b=OsS+TOGC2isqG7odu7QfZ8OY2FHH+m2/O44n/sXHK9Am1yiHaTzmsmnS
   VTUAxiaIKqZ8XnnUEJRKaOIE7C4lGDEQCgjODDpjQ7ny3Uk/yw2xBtNmE
   Byp7/Af13iqjyhedvU2cXEVfSm/NFS+NZSC7lrI2pbH1M+ID1QvML2mkp
   0yxddxAMyVEa9rmpIHzMvatS1FTk9Opn68T6F0YZeFNEO2P1djydG4yPh
   kaOs/oeLVPdGrI+n7LvPqFlUSbjiteBFor8UfvxwnhTkoftoeGyuhKuan
   1grNZBcQ7DEdPKbFhb9IJYpyAMpq2OTM5Adgf5QZPm/kDNZlHBN5Hpwf5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="315159904"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="315159904"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 12:10:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="678488533"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="678488533"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 05 Dec 2022 12:10:27 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 5 Dec 2022 12:10:26 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 5 Dec 2022 12:10:26 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 5 Dec 2022 12:10:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXIQZgakLbb2K/P9lF90mNARgm1XbkTSiAGVEnbbjGFmlSn9pQE01eLhvNjgkVlrRG0pQ6Ne+01+7s4UqofqVs0zZg+PzQkxdu08g6CMXXKCBuIZl07eDWVO2nXFU40Lf7E91tNZpXP65217Ff0+QzDUmzePiihYL0dqf2zPjrCviuKWzlDO4kqFbhhKDGAAiDwmoLx5p1QhuiVKiSRUpcA9VeXXURC2MNP8cMtY19Db3G3CjwiZnrt/S7HqTjQAOADVnePS3XXQS53n1akOYeZLmXMjRSa7rYHshfDRo1p8g5MeegL+Xdkatayhr4XwKRoHrf3OlfYFgE55hnWkMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RQgIFzXt+GDDs/oFHuwpaenpP3mtptyVXS0nUAPgBBY=;
 b=MnSrzEpf6gYdsKK3/iIyUpQhyETkS1QuIQMNuAP/GgXn3dc9vxyWE4xBnNmPxCGSVaN37PdlfZY/L+efp1CKzrtv/DScFuR6vGqB/ZY1H8uxLidcCpEv7tuL0UwTT5Ojl75Gs/7rJf/meYLOvujUaVPq23bPc2KgxoegKSt+Lds6RrmhIudFu5S8NkLqmIdPlMXzauSqUGjNtv47igzU55XoT+EovRQqyRA6QJFqxzOH2OVhi/KupWlZbKSFes+55KQBBEMoO2LEEQOix0KR0z8mH+Q3aOUVfS0+ck0SysWf0TE4CIdGrY0T3zIT9bgIHd5KyIUALNL/b1xe/yioVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by PH8PR11MB7069.namprd11.prod.outlook.com
 (2603:10b6:510:217::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 20:10:24 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 20:10:24 +0000
Date: Mon, 5 Dec 2022 12:10:22 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Dan Williams
	<dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <Jonathan.Cameron@huawei.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/5] cxl/region: Manage CPU caches relative to DPA
 invalidation events
Message-ID: <638e502e1904a_3cbe0294e2@dwillia2-xfh.jf.intel.com.notmuch>
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
 <166993222098.1995348.16604163596374520890.stgit@dwillia2-xfh.jf.intel.com>
 <20221205192054.mwhzyjrfwfn3tma5@offworld>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221205192054.mwhzyjrfwfn3tma5@offworld>
X-ClientProxiedBy: BY5PR16CA0028.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::41) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|PH8PR11MB7069:EE_
X-MS-Office365-Filtering-Correlation-Id: daec0dc8-df89-4fba-8001-08dad6fcbe79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nkXjX+LJlep09C7mrLHG66sajEmxpD3H89JdOPst095WnwqZig2UWZRezwfUcHEKSzSjnrWTZ8X9W8hlNTR5qGL0iDoJEU6eWyr3C/HQgoqLf1IEQCQy+RBCjKszF0FmUlw5G2PacfRt5cVrTgah8NT2ClWo0eZRO37gQgnlhSA/2I+GmCCh+6N4uQGs2P/nszXOfk9dKKGP/+CpTKN8g1DWncMr7cY7mno972b8X1XVzF2bgApzqlhM6QEIC6BKmqZl6wjcdKsQKGdDa93fQxWwaStnr2o0vSew2h8K2DjUXgc3oYrSXjse1v4SB8S+woHOAbguWdbUO2hg3Ktqy7mIgTC1Zxx0BQI7wYwXSuA4hwMSAjYzwTk7T25pD7TphNF299ZPEXkRi51PycWZVUii8rQD7PYXvCixYf4vOjz0TYo2uGJ4n0C31A7lszYAzCeq/Eo6B2WrPIjUt6WJrKib9e2pADnTyd9QnuMowgQ617/45xsGRmngtDTTF/wUirR/qCdwYLDAQ4ApT9YcVVkSfyIDVn5cSyrJuPUqk1n7EdGnNVhxiaLhNpvi6Mj1+/EYmUBGWxBKJ0FzZXXyxIKzkAyghgdpaL97IRBVo5qqPrbi80y4U2p8Oqit5aNUFd+Veys5Xr6hrsi4aOursA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199015)(186003)(86362001)(6506007)(478600001)(6486002)(26005)(38100700002)(83380400001)(82960400001)(4326008)(41300700001)(5660300002)(8936002)(8676002)(6512007)(9686003)(66946007)(66556008)(66476007)(316002)(110136005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W7Vzhkycs/MflWJCg7Pco4qXDSeqbpAbZBoFO/IBf9BQ3UODXY4rtFAryRmD?=
 =?us-ascii?Q?wRrm5HS7FxM525E7opvL7UFABKVHgJcoT+tGKzolq5Ft8N8+h4Kpk0ifuF4X?=
 =?us-ascii?Q?5EbCnX8jZX2dM/k4msTDUmejkndjR/4glFA1R0a8lAHE3bzX5H8aQjHZ6/Z8?=
 =?us-ascii?Q?+xSj+u0UhoRa3uOb7TTtFw/GGTIsxZuDNcHMzgwj2zkWcwfRDB4doNgIiIZY?=
 =?us-ascii?Q?Diu0EJH6foti/5cCiGWg29k0yESOghQ8FvIi6U5p+/KRBbMOQUlrX02EHwwq?=
 =?us-ascii?Q?w94tPV4G1iqTSR3u+OhPn5fdaq6e1gQqG9W9cYzJ+7WZlE8xeCmnxRR0V0cs?=
 =?us-ascii?Q?8XEqzWNk7ht6G6Eql4VUOPJpH53yNcQqWOUy45QPItmqIfx3rEq2kRSHBK2u?=
 =?us-ascii?Q?q2tqu93LGxfI/xElGl+tmsgZ+dDrEhZZfJPPGnuDInJ/+VPhQRPvPkkLq0AS?=
 =?us-ascii?Q?q2OO5Na0nRZwbkONZigYKDLt9LwbGJKXIM9s8nmKEjTEy/SVcwvkVdCpa4F8?=
 =?us-ascii?Q?alYLZ1WGAjldy3TqWo3+7a8ddGgK8wiQk3ZqD5bpaimkmZbAws7Ym001UT/C?=
 =?us-ascii?Q?2AJToIyyDrC0QBJNRFclR2sjwtxZW4ra+CNhjuILyqQJ6WRHDfTvyvL5Jmn0?=
 =?us-ascii?Q?OBMc+wdVjnKebSodP+7NYZBFvDamArVBABAR0ip/JhUpyECRIEXI8ZIYe6wm?=
 =?us-ascii?Q?vgMlkGgEvBxAQq6pmt8t3HCGd3YcrVFa/O/NV22YPFrLYkR18GgXRdK459I6?=
 =?us-ascii?Q?ss2IEabuwpE/3pbQgelyOxdG7H+aUnQzqx5lojKdExM2SoVYBo5qjL1m6tfy?=
 =?us-ascii?Q?JPwr+AkC0tCBQ+dL2CSET4Ka69s28rpFWSRlyVvJ/BRmaK26tRubue7KL551?=
 =?us-ascii?Q?ojdljt1IbUVXNnnxVxzWw+qFJcsX8VcJP0PlznDxWQyQY7eCNPhGhk5ymm4G?=
 =?us-ascii?Q?MS26ovHaH3ZI12OcyuEoseXDTKCYAZQadnZVYeORJ4eZRNwdQ8rgNAKVr7zw?=
 =?us-ascii?Q?UXjR3WwRtE0Hf16l2z5BL+/XyxIck8tuB+zryUDScqXgkLECoXBi48Y6Hc4B?=
 =?us-ascii?Q?1gL9Yb6tPKobpBYvVR5gA2RiqpScd7nt4wcZu8EazRPkCu7meCDYu78lrNwJ?=
 =?us-ascii?Q?CQo8cQfoyT9ZkYqhP9MURihS92uUpH6lzQYkooUXidMsrvGok3e8BuEN8GzG?=
 =?us-ascii?Q?efoRLF3JNqIYy9Lq1A4LYhufCoNZKVxErbn03OGMZdonHYpjVLoeO6G5VA4d?=
 =?us-ascii?Q?K8ZSWk2x4tv9rBYM/0jlB8Gc8XKonjFOncL2FYeoXMwL50BU1siaxyTtJP1G?=
 =?us-ascii?Q?OXNGQmrTzsJxBYDhBvEgc5N1G6c06ybMTCR7luCtPkktfGi+Kc6Xf6/eBSVR?=
 =?us-ascii?Q?XRyefyhl2A32s3Ezu55VaqCgGKUNt4wQRpfGLmLSWCovOruqIzXg44brqxtM?=
 =?us-ascii?Q?XQ9jXQFmriAnADwZl+HuKnNQXBhey8WeVu37QXJui9RcvPh6bwFfFuVFi9c9?=
 =?us-ascii?Q?hYESTbU67M/fAP43T/cA4nXWdlUXNe660uPQUxiuSVtWuR3FwGx5eiAmaK3A?=
 =?us-ascii?Q?6JnamHDNkEb7nvey/wRT0dwiobLjUKyKrjEuzEi0AU2hiVRTHyUlOlRVwTXU?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: daec0dc8-df89-4fba-8001-08dad6fcbe79
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 20:10:24.4582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xzk3xUtjBa8zH2iEEHJAXn/S7YFRVQQgahYOX4KyorKob5SaLvcSWiHfZhDC98UCsTXOjl181jAgjq4BZecgbgjwuHUMBrsYEaUNRwkzsTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7069
X-OriginatorOrg: intel.com

[ add linux-arm-kernel@lists.infradead.org ]

Background for ARM folks, CXL can dynamically reconfigure the target
devices that back a given physical memory region. When that happens the
CPU cache can be holding cache data from a previous configuration. The
mitigation for that scenario on x86 is wbinvd, ARM does not have an
equivalent. The result, dynamic region creation is disabled on ARM. In
the near term, most CXL is configured pre-boot, but going forward this
restriction is untenable.

Davidlohr Bueso wrote:
> On Thu, 01 Dec 2022, Dan Williams wrote:
> 
> >A "DPA invalidation event" is any scenario where the contents of a DPA
> >(Device Physical Address) is modified in a way that is incoherent with
> >CPU caches, or if the HPA (Host Physical Address) to DPA association
> >changes due to a remapping event.
> >
> >PMEM security events like Unlock and Passphrase Secure Erase already
> >manage caches through LIBNVDIMM,
> 
> Just to be clear, is this is why you get rid of the explicit flushing
> for the respective commands in security.c?

Correct, because those commands can only be executed through libnvdimm.

> 
> >so that leaves HPA to DPA remap events
> >that need cache management by the CXL core. Those only happen when the
> >boot time CXL configuration has changed. That event occurs when
> >userspace attaches an endpoint decoder to a region configuration, and
> >that region is subsequently activated.
> >
> >The implications of not invalidating caches between remap events is that
> >reads from the region at different points in time may return different
> >results due to stale cached data from the previous HPA to DPA mapping.
> >Without a guarantee that the region contents after cxl_region_probe()
> >are written before being read (a layering-violation assumption that
> >cxl_region_probe() can not make) the CXL subsystem needs to ensure that
> >reads that precede writes see consistent results.
> 
> Hmm where does this leave us remaping under arm64 which is doesn't have
> ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION?
> 
> Back when we were discussing this it was all related to the security stuff,
> which under arm it could just be easily discarded as not available feature.

I can throw out a few strawman options, but really need help from ARM
folks to decide where to go next.

1/ Map and loop cache flushing line by line. It works, but for Terabytes
   of CXL the cost is 10s of seconds of latency to reconfigure a region.
   That said, region configuration, outside of test scenarios, is typically
   a "once per bare metal provisioning" event.

2/ Set a configuration dependency that mandates that all CXL memory be
   routed through the page allocator where it is guaranteed that the memory
   will be written (zeroed) before use. This restricts some planned use
   cases for the "Dynamic Capacity Device" capability.

3/ Work with the CXL consortium to extend the back-invalidate concept
   for general purpose usage to make devices capable of invalidating caches
   for a new memory region they joined, and mandate it for ARM. This one
   has a long lead time and a gap for every device in flight currently.
