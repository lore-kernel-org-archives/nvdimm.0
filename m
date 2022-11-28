Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B7DAD32
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 23:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669678965; x=1701214965;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wPP8KctMesIN2yTmDzezlF5N5YUi7qaJg3PZoPbUbUo=;
  b=LqWERNQEXMSlnIN6RYqnKl3A0oucBQAMFY7NjnpHe8qdWeiUcZkh0G6h
   6Tq5CLs080U5YmiF8CIm2eFnlVw7ydBSV/TM7w1U3Y7VNHA/adp6uJDU9
   u5xUyLSLPBNLuIR9j8oSfd8mQWPc/ABL3DxFZOp7PL2YTK4gE0gNbuxHP
   hhqtjKkeL/0gN1QCswLHZA+ukdbcuXxGNVRT9TsnKRmIKCiucIeCopK50
   H+TQujBcJCWAdHypXdkpSa6O5/IZgUdpaixYIEy/TdnGA2kOaaVqVbQl2
   xvpZNZSWXw/5Hhj6dVMp0Wd+oeTeln9OApeQdvPK+EWkOcsVarlYilgzm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="302560207"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="302560207"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 15:42:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="706985083"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="706985083"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 28 Nov 2022 15:42:43 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:42:43 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:42:43 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 15:42:43 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 15:42:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/aYuXu9YG7O+kviZst0WlXTzwdMC+pujf695AVJ0J3+r8uA2U8OVW//xCzaxbQGPNbKuh+OxfT0TDl1H10rrEY8ysfqLapN16+amZvHEFYsDrxTFsT/0Ev4w4YiPUWb3mWoEvZr25vXCEYZgWbx0DaOZ9KMgvg3unYVM7VEFcWsGDNxbj29GHlBt1ulaQ85bRVYgb1YNvCgHL/AVWFA/opOBkrgJIstLUSOOjMcm+7aG2Zsp0FTg5AxlqX/Du3mdqM6GFd5VkCtBi2zypIxTYbcgMnP1tw3Qa3To3u/3iHg8VaVJ/8GCXpp7tBkSEj5o/XMN1EVws2fpeuCiPfKKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HxV9+dY5vKIlc2QBQJyoodnMJejGsGxXrpepZ+lqHLs=;
 b=ctuNtKvqGGxYNk/8dmQF7blovrGzeF5I8K3RcFWNdjU7v8XJUZjqit+WfmZ+I15S80xSW+ZU3FHsKxU9wDUNrUTDrNtEiHeZYSLEi4igDL8cwLXLG+VJebBWKPPpEb2tbbc2AHiVhSdoC9Dy+XaxUtZjs50PloSkret9kk0brABw79CyvuoEFxCFpvYbzoJq2zBMvTYJnuYmwfDN/vqsw1GAdkRpklioivaIkmllILzr3m93I62Hq2mXmkTEXF1oEp8MLQgun+grmXST3NYXcrcOV9K0Wk5DL+HVMDbQ7Yh1ebvwer1hvX3SuKkAvyeuVtzt9F02lM2I1+vRY8N9QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SA2PR11MB5148.namprd11.prod.outlook.com
 (2603:10b6:806:11e::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Mon, 28 Nov
 2022 23:42:40 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:42:40 +0000
Date: Mon, 28 Nov 2022 15:42:38 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Robert Richter <rrichter@amd.com>, Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 09/12] cxl/mem: Move devm_cxl_add_endpoint() from
 cxl_core to cxl_mem
Message-ID: <6385476e94c0f_3cbe02944c@dwillia2-xfh.jf.intel.com.notmuch>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931492718.2104015.1866183528350401708.stgit@dwillia2-xfh.jf.intel.com>
 <Y4UQ85/KAmuaZXFq@rric.localdomain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y4UQ85/KAmuaZXFq@rric.localdomain>
X-ClientProxiedBy: SJ0PR13CA0186.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::11) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|SA2PR11MB5148:EE_
X-MS-Office365-Filtering-Correlation-Id: 84493fef-ab37-457f-5a57-08dad19a3d13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 830S/dUboWZjqvqCchklh78//lkxaG967+O7Ld8aTjcF535TtKPTt5fW3WveWWplhRpXcU4eHW9qeJ/lqmJOHn32Fs6Sbd1Ame8r+O4h60hjYrpE1VnqgQtDxgAf+bQ8R/O7P+szZDK3ezxdUy783ifrXEkmgYeDAwq48g6l8lnLPZln/IBvamWIcN3LK9UEQtx9f72/7kS8jpRKkn/V1d5fIiwiIMxk1mNgfJeJbRkg4Fht9JeJfXi49lpADuesEz8/xZVyU+sBy/hufg9K97U8R0AkAfiUOK1F0ulN2hyvN2OAQUOOVp2C7N6W8Ix/PjAexD/IP8LY+D7S7qufr6KbwfC/cy8ItrHpqYPL2//EwjviSCXGZrybDyhjK7qkfzSY2EP/wLt8RqLhj1yV8R2ly+B46HKN/K73W8BNOclKRWLuvndOF36HaiRMY1tVqnGfkiPrTW2QLLD192MWWgDQEOafB1+ZKPoa64+jeHg5Tq8y4ogpSxaY09D49jmKCRdlSJeA/hbiGDsLZyuozyhZZJYKFJOx3ih5iWuKduI5TIZrwPHegTbxy0cCoqxoAJRBbAsYIA2ALTAsBHEyBrATRNEEVG30yw8mkHOapzu5x3AyRqKl2KOqeIGcr46k0TJOj0PASv1hBG+FpZOhyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(396003)(366004)(376002)(451199015)(86362001)(8936002)(82960400001)(2906002)(5660300002)(186003)(83380400001)(38100700002)(110136005)(316002)(6486002)(66476007)(478600001)(4326008)(66946007)(66556008)(8676002)(9686003)(6506007)(6512007)(41300700001)(53546011)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uYUePYAj8a5CGExfbbarySyOLG0a2YkZd5P5V2kd7q/5jgHFrVMNBKjHgzoI?=
 =?us-ascii?Q?J81QlIDNUh/BR5WqXK1vOl2NF7hTx4OGbwWnSAhvWh+IpPLL+l4MzHGLRFZp?=
 =?us-ascii?Q?aeIwhSkbE/aV6gtClnS4a5kSw/MZmIdXXniOHTUEUev8c1GqO+jvdZWwF0bg?=
 =?us-ascii?Q?LUynmVbBQvUqGo+j/oLugl9m5GUD6Lv1dxIC+pNoNTntUD81UIwpvjY/h4fB?=
 =?us-ascii?Q?zOaejZxj2BOiJt6X8/ncYKeUIAvIizI5jT90MpEBcwsWeZXyhCt3iqtYUSSg?=
 =?us-ascii?Q?usXLXCfeGz3Fd0cNHZlVeE/ugO+sq8TBi0jx3PdMwGtm/4YUYrRGG4MA30qw?=
 =?us-ascii?Q?abtmwl5J59oD+mpUe9Y6GJ7QepfPtrVdwOTvKfJE8hk1GZtARNORPh7d5s/X?=
 =?us-ascii?Q?jNBEmxy4cSJ8PYlKhIJJaYjCchKiAK/Gau5dNqX2wb8ovg9F3UaKjBHz46YW?=
 =?us-ascii?Q?75LAJoAxQm0AxOxh9yMk5vpg3bhsdG4HG6TqFRUaqbzwz4O5hYJ0aGuy0K2I?=
 =?us-ascii?Q?+YYqLGYNZSqqqF7UiYY+yt+b9qLPjPMIFV24w7WIBlChSUWNBqVPn17ymm4g?=
 =?us-ascii?Q?6O5pPsUcofrG+6Gv7scPtYj6SMM6NuEy4+yygTLeKl1ipBMwoXjlsW/ZeHNW?=
 =?us-ascii?Q?v2HkunXNzf394oPnVihtz8qfiNHvBCB1C9Rv0ZCeFTLm3yGijoXPL+ZZ0C5n?=
 =?us-ascii?Q?8d+kyzazxPMkoQ/sQOIzUQqUCpmGBFPsy1rHArDkdNRl6PH300Qf6EijUzAi?=
 =?us-ascii?Q?m+Smpr50dHkGG+HJIc+mj2RVV97nXhG4iLjWmd9f9xUAd0laLCD+yZJIIQBI?=
 =?us-ascii?Q?3LjnisJsUb/GNizJffA7IQ94ww+rVRNukSHx5WU6dTaOAwS+bbqNlIKnr3AL?=
 =?us-ascii?Q?R4y6lh1NLy7lVvDC1U/8spreGLuB10R7VgeUKDdQPR7Zs8cdYm0HGgFyD+dI?=
 =?us-ascii?Q?e3UHZOX9WU2pQtxZwN5kpIhj8/WuDUPQbo/6PybMwqU6efuu5AIutoRqRoal?=
 =?us-ascii?Q?5wLul395Aln1k7pbqFfWeKoQn6YS/EdoOPpNHF/eWNXvyVNH+cGUqX85XXVs?=
 =?us-ascii?Q?9miqDjUkklTljQtIIn18iTloIS26Ga2rO+jCFPWTTzMBhZ0yrb/0Po6X57fF?=
 =?us-ascii?Q?xG6KzGsgqCnhh2C4DVO6C60Cm9cOq31/iI4k/0sPysjz2eWH+U/jEwJWo6Zl?=
 =?us-ascii?Q?C9hSAOwx22Upi6f2lDnWt9s3a6ZWPq4buRIDBi10SBz7U4HQyWq+htA2prUO?=
 =?us-ascii?Q?FNGmif2rqqgGK4W6fZ+DZrXW7MQIk6bGg1OXkMRjnSd0d3RPUdsyOOK9LWob?=
 =?us-ascii?Q?reYnDdR4UDStlsr0AR6Sq1s2x9Oo2gddOGIYGNb4H8OkmDHMTy3jSkC8gmh/?=
 =?us-ascii?Q?THpPS8+jZiJ835WdBYou+AQpOhwUY0FHl3Y9tS8GbwITOFKgWY7wrAOy98nj?=
 =?us-ascii?Q?hDbujqgkTeMyvKh9kUgi1Y4lWUoKBSck3nHA+LY401sYTJ7YKLPHk1fDjHL0?=
 =?us-ascii?Q?nb/VdCc52WbBpiQpr1mVt8WBXA9NmIGWM75Jqh5Tf+unaALHZ4sie1l7Aak6?=
 =?us-ascii?Q?3q9kRq80nN007i298XIWKDxVtCUJCBzuQpYK4nUomECpuCV7Q+7gjy5DkSC7?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84493fef-ab37-457f-5a57-08dad19a3d13
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:42:40.7912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SuNetXO86aaRPUdhBkh5NqRO52PkaE2Elods32kd62/TLP+pPo5kkUohY2VPDyKiWzCicAKI9aOOVpURP12469wMmc2zhcpsa1H6tsRww9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5148
X-OriginatorOrg: intel.com

Robert Richter wrote:
> On 24.11.22 10:35:27, Dan Williams wrote:
> > In preparation for devm_cxl_add_endpoint() to call out to
> > cxl_rcrb_to_component() to map the upstream port component registers,
> > move devm_cxl_add_endpoint() from the cxl_core to the cxl_mem driver.
> > This is due to the organization of cxl_test that mandates that the
> > cxl_core not call out to any mocked symbols. It also cleans up the
> > export of devm_cxl_add_endpoint() which is just a wrapper around
> > devm_cxl_add_port().
> 
> The last sentense is unclear to me? I see you just make it static as
> there is only a single user, do you mean that here? The change itself
> looks good.

Yeah, it does read strangely. I changed it to:

    cxl/mem: Move devm_cxl_add_endpoint() from cxl_core to cxl_mem
    
    tl;dr: Clean up an unnecessary export and enable cxl_test.
    
    An RCD (Restricted CXL Device), in contrast to a typical CXL device in
    a VH topology, obtains its component registers from the bottom half of
    the associated CXL host bridge RCRB (Root Complex Register Block). In
    turn this means that cxl_rcrb_to_component() needs to be called from
    devm_cxl_add_endpoint().
    
    Presently devm_cxl_add_endpoint() is part of the CXL core, but the only
    user is the CXL mem module. Move it from cxl_core to cxl_mem to not only
    get rid of an unnecessary export, but to also enable its call out to
    cxl_rcrb_to_component(), in a subsequent patch, to be mocked by
    cxl_test. Recall that cxl_test can only mock exported symbols, and since
    cxl_rcrb_to_component() is itself inside the core, all callers must be
    outside of cxl_core to allow cxl_test to mock it.

> Reviewed-by: Robert Richter <rrichter@amd.com>
