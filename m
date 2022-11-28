Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D84DAD25
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 22:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669674521; x=1701210521;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Tu8S979iM/QiMOj0YhcZl2NAHDPFcvdoNF1eam6uWmo=;
  b=CXktgj6AOAMt8YWMUWikz9lfHBxWC7h4UaZAwkxAcX2/EMWnNGBdlusq
   7RoZ9FM90m4iJT04axL3SnEvHqwG6SlXTTHQ/+5HBLgocabx3eCIHzqqv
   +QjM6H6pmjNF7t7Rcrxy3f31D5sySojMH6Z9sX9aT6dXjMNMd8ntY3+bb
   MP/lY1nMHaMmI4zIXscnf+A2nR3VcxuyXzF+5ZnJ94QOjM43FrlwvW4sW
   kDAfuIdKUW/xqF8L1tjbjqQRh2EwJzyMNEzATpQGmMji3kgRghWQy7nlW
   drjrYFA38EgK3U0idz3ZOIw3d82UQ7L9zSWokQDucQa1jHeAoVRanIcT5
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="298312608"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="298312608"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 14:28:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="785807003"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="785807003"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 28 Nov 2022 14:28:29 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 14:28:27 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 14:28:27 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 14:28:27 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 14:28:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XazwUqOhPToRZ+X+7wGj+4aXVSS63tUCeIciAqw4yCxpRMJvF/6bmqBKn5a18gqv/R9Mo8BDKP8BKKXcLueQREWMfdJgW6r5QKFB1amhLAbjtlyBpimEGcOBC6TV7Qf0/JS5dkCGiqJsE9B+qNrxHyi1vPjAu3qDTPZqCv268rOOTje1P4uyIsgwc8id397Py8sxRYC6ZL0X3Av9zErFE19Oc5NTCX4vTPhw/NDTuOHZuwi1N6mrzrjEumrCLgGRJd2nyzufgEWj2y4zV9zV/yrv8JSRcaRBXKKUnVlHRqLM9QvCCeWGbzUAVRQNicXxpW8lwHkWsU0G5xkSiHNo5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qAcS7bAo6FohKLHqxVKNYqlv6YL9gdIrZc9wp/0B3yw=;
 b=Eqk5EyQYDsSWc8ZoExWyFSckAkmK6D7+g58wdO6+1dawHDO/IE8ed7plA2rIf87yb20UjeTW5I6U1MKCXeXDjefA8HAgOPSi5V5crEMCLqFVhMBbYZ6OsJmcUv+f95uwqfVrEgvKmZW4kZhbH5eqM5zKLpkSoRF7ZbGRG+43fMvIHbGE11Q7wcUpSsZnElesr5Q2/fDxziMdC7T7L+gQR4BwwostIsdifwuwWVoKu2WMgAcCqgBqvHfReWHN2OyhlQHL33GWTGXOaCbVICF5QQIby2ZF2lzirNbZ7EBOeoW6YOK6qjam3dfCBoTMqb5syvqcV6Az6Er6WYvpyBZkMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SJ0PR11MB4847.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 22:28:19 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 22:28:19 +0000
Date: Mon, 28 Nov 2022 14:28:17 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <rrichter@amd.com>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 11/12] tools/testing/cxl: Add an RCH topology
Message-ID: <6385360147c09_3cbe029425@dwillia2-xfh.jf.intel.com.notmuch>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931493816.2104015.8749844490243672146.stgit@dwillia2-xfh.jf.intel.com>
 <Y4ULS+UsNiEeD97l@aschofie-mobl2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y4ULS+UsNiEeD97l@aschofie-mobl2>
X-ClientProxiedBy: BYAPR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::35) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|SJ0PR11MB4847:EE_
X-MS-Office365-Filtering-Correlation-Id: 86db5b03-ec48-4626-6747-08dad18fd9d6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YdtdC4m2wYLIbxFLR+Beae429ZPVV8+0u45ZM4DFUoj6v6bYzuUJIhRFVfUeBTIUrRRlcprDOFoGXbcG7V8l0itNN1aX2CaBP3JLm1A1E9pdjTfKsyUBCM1RjMTK4DIzv1Ex+vtb0Wo6fnKc61s29DgJ473lPio6iwi4pVORgbdkX6hHCTzQRvNFG4m8UvrDu6Q+rqJIsGRqT8nlgVINfolkoGW6eFOFTWH3iR660UembEeHrvJxOjgxxe0geU+qsCJjcwmcyB2fhoFn3omvTuDNjcaUo1/S4ntE0uLpn7+Kp//+xgeEjPaK7V9vXphgpbnOrRUi4tQw2tQL1Kqf5HEfTM1L9jT58Ii4dKgMceT8aDJhlxmqhYqLMAaDwm4dahpKJkDE0ZLMNLPVEnmA46+qzoUCtPjHoAVEAsqGUoDUxObLXzIJJWxALp3lBGkNsRWmgY5KwC/25oKSMZWtEKxGFe4B27iZ7HLXTwVFjanJzDsNEcio9SHv6JDlVzbTtg4EiNU0WAkDziNolRqEEwNvlFvpxTiXGY3U1ptA9/FwcA5tbY0DYrTRWM6iXyeaXGP4scKwsEEGtiOQU2s5xY1PYC5/vxvExKe6HdwO4/dKJIho4bfbMnHh2j2XPNj4GJXUacKfo3kCd41jmeKMfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199015)(5660300002)(66556008)(66476007)(4326008)(8676002)(8936002)(41300700001)(110136005)(66946007)(6486002)(2906002)(316002)(478600001)(86362001)(9686003)(6512007)(26005)(6506007)(186003)(83380400001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0sNNTEzqdtarXGX81Tpk1//ujjKc5pOrz1pPv4M3/7vnYCw9D0tMZWqEB+x7?=
 =?us-ascii?Q?cSPPdJL3torBgpl3W+CxOxyp7bfU+ZbfGJuZcrQ774HMVjvWvYG62HPVJKzv?=
 =?us-ascii?Q?8XdXOvssMBwJhECWoKxRYNAvskgZWlRf3wROyz9IHb50YKm/z7UlPejLcY3/?=
 =?us-ascii?Q?nkqsEBTzcPzyRP6nM5twrDfuFpxnl9ML2caX2tfUx+ImClbuIXQ/wAGJyuLN?=
 =?us-ascii?Q?lb94QBlx7z8Fqfq/noncGVR857GwHtHtNgDswCPIBQ3sG9C8/NPfORC9EP5r?=
 =?us-ascii?Q?IG5Ip/uRoNjk253u7RaFpYrzPWDz/hjRGr1t1Xbq7Nkd6R92ZjdGpWf22bA9?=
 =?us-ascii?Q?HpGuiCH5+qfbhAuH/imtFGp3gGUJ46U0zoTah3mTpazLerV5ZcO2g1VIAZoi?=
 =?us-ascii?Q?nN6x5CchNBTmJIOnVH7yFUht2zmU6soJtaLBVtotyJ1huM/WswGCOJyxY+7y?=
 =?us-ascii?Q?3VRfxSzaC0Z6I5aQxpqXc35aTOoVnePxIFbvogetH0VwGX0Hmj5jBpZ9zXS1?=
 =?us-ascii?Q?tLLR5+GT300EGgS32/ZqNiQawJOkaOW3ER/aKiw52EiMh9jY47wqDGjyv1fw?=
 =?us-ascii?Q?gf+x5YbfkDwPHf6i1tl0LRoVj+x5Cca2gb+jzDBawwsfYi3oEK3xWcTZRn08?=
 =?us-ascii?Q?Hh4StOOpoAG9Y7P65h5+NIlSwaJOu1FgzO45qyaKrzSwvDJgY7pqSSaUl6ND?=
 =?us-ascii?Q?t/haUR0ByhMVIsglkv2W/xPlFhgisaPgU1n2X0ymSK0U1M1tF6FfEdu/ZjBV?=
 =?us-ascii?Q?1Z1iUIpLa7mY60jC6Fvu46r4x/pSS7NvyTluxVnhBWjvBny4iO+WX5XLj890?=
 =?us-ascii?Q?B28kf0jHX1SqxKn9jXEakA01DHD3u2JERljyb++Yu1mIJMtPpgLnuCR9SRQr?=
 =?us-ascii?Q?xtShxNFqo6l/scvmka8147MzbU39LXDP9NeDNgXbPMsOVO7iUxkIKdst4TlC?=
 =?us-ascii?Q?loaqTJgHl27wA9pXRcnEnrzDqnzaZj778nZ79IfEb92CxXW5VRoI27RqPxV/?=
 =?us-ascii?Q?xhYtM7hodkb6JqFTbxSLarG09e9/rmo6rF2CfiglCYizd4NYYXQFIfrBNe2n?=
 =?us-ascii?Q?GYmVwXwHHcEWxqNTvdYvwDOp3VwTe4WL/ax4E2rb0HqerD8hLMwAjLaDR47+?=
 =?us-ascii?Q?q6DUJgPjXFe3HYGfTyoGTaAydVbTLXZFpyYXgvmMPb1ZMG7RCjLvLNHPTfCx?=
 =?us-ascii?Q?aMre/9fDKm+WAgIvUCH6s6a5HMQjpPcZmd/RIUDJ/cLI2Gi23KhBZhzHv3rt?=
 =?us-ascii?Q?uslETVVBeLxNp0HtVqsZwqvMAEjqPXc4AjB9CNZBZCFSgmljBevdQuZjLDkA?=
 =?us-ascii?Q?owlUziH2V/mm2ZYOmMCk6Z4Gg+r5LqI2r8V2kA44HVgeP7xwalolaGfs/7mV?=
 =?us-ascii?Q?0exaoveprrpno3PpxtssYVINFxnBnCLE+DqkuqYrDdmooLB8BGCZoLk491pP?=
 =?us-ascii?Q?uTj0OAXaW7VVjV7kM+E/iCUh/zM7++537s7slTW/36rkptrhQo9uJLGc90f0?=
 =?us-ascii?Q?o2L26qRwtJd+DeCychYBt5FqTv/7Q44vXCzoF2D2NAbDTDZ1TqOxoM9+Hez/?=
 =?us-ascii?Q?VdnecqBOQKxNx1j2xx+ypCqzZ+VgcGeoSqyZD73kA0MuEG5NRVkf2shoOWoo?=
 =?us-ascii?Q?WA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 86db5b03-ec48-4626-6747-08dad18fd9d6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 22:28:19.2988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QEADOWfHv5KQOXrxrdSe/djfvcsIV01KsOj476LVF1xxuMK07XZcB6zABvWMPu0vfw0AtRHPG9DvaQFZjtFMpyvv+cH4XxC9rA0aagmbmdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4847
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Thu, Nov 24, 2022 at 10:35:38AM -0800, Dan Williams wrote:
> > In an RCH topology a CXL host-bridge as Root Complex Integrated Endpoint
> > the represents the memory expander. Unlike a VH topology there is no
> > CXL/PCIE Root Port that host the endpoint. The CXL subsystem maps this
> > as the CXL root object (ACPI0017 on ACPI based systems) targeting the
> > host-bridge as a dport, per usual, but then that dport directly hosts
> > the endpoint port.
> > 
> > Mock up that configuration with a 4th host-bridge that has a 'cxl_rcd'
> > device instance as its immediate child.
> > 
> 
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> 
> How can this host bridge and device be used? Should I be looking in
> the spec to see the limitations on a 1.1 usage?

Yes, CXL 3.0 9.11.8 "CXL Devices Attached to an RCH" is the best
starting point.

> Expect it to behave like VH topo? Expect graceful failure where it
> doesn't?  I'm just after a starting point for understanding how the
> 1.1 world fits in.

The expectation is that an RCH topology is a strict subset of a VH
topology. I think of it as VH minus device-interleaving and hotplug.
Once you have found the CXL component register block the enabling can be
shared between 1.1 and 2.0. So, for example see all the different
component registers listed in CXL 3.0 Table 8-22. Where that block is
available to "D1" and "D2" the driver enabling can be shared. The only
difference is how to find those component registers.
