Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C00823A9
	for <nvdimm@lists.linux.dev>; Tue, 12 Jul 2022 05:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657602380; x=1689138380;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=v9UVXG/s3nWhNT9LwXvsUSzQRWlD96ySo8iF7Pa8OJk=;
  b=BFYBQC2WixlXTeyRI2CoZwK4L0Ge21K9RRswyUwmlsWV2jf2A+VYjONg
   j6dapg58mtAf/0RWp1H0NmDncknnMVdyy/dUu3HhV3hA3Mea1IYW9XdRE
   ky6URz/mSpWkS+XYtM5PPqXWy6MvaZaKRemdAPSqdj6s3t8Gr+uptocxo
   gu516DrT7JKIsri6sDLiICI+GGeTnSGkyhwmF4vuItrqgosBMZQeze2I7
   QFOb7qDLnk0k2cUtvTXdaUS0Io7iOHL2xtf3A39l91BJQcLy/pzyMgRW8
   cdlAhad6BpZyZMio/LWLXUvA6es0H9CzUaCsD4E8iwp6gED3CEmQTgbB5
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="310453095"
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="310453095"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 22:06:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="652756870"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 11 Jul 2022 22:06:19 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 11 Jul 2022 22:06:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 11 Jul 2022 22:06:18 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 11 Jul 2022 22:06:18 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 11 Jul 2022 22:06:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dH6pGWG4hiBllz1Y/KlL0IoH6VqltdE63YiZr2GwNtdriRKeMwcDQ+7g2OKSTRZKivHfQSaAS/QAs9fIDYbM2wGveZgLLfBgJt2KrxToetjX1ixjUv0YSSWs4SOFKv2Lke3c8Y1RyAwUmZ2SWe/cqAw4TUq0yJppIVhrRbZY6jasJW1k6LgHPrtpR+3SwKAnwLehkYlDN6f/Ms8L/ZquPAzfZjR38ZjehY6KSqAWT5o5UrIEX6O0JmHTwj+hEVqy7xy3FxQT9DnuhZ9UgYeHurB09TXwpAXxENxkdzpX6Lims4e61Jww74YJcEkQXvVhKlJqqLEfMvnVT6X3fbH5LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FTH8wmUkPmzyS+MeC7gol3c2Nj/d1y+4TYnsZTer3i4=;
 b=i3B25FMqnYUFTT06coufwAowlD/WTeYJ9zsulaOpqiT4EIdSszG2sXmE/bn7OgkGVUBrRmcCeE/gcG6s4rC+y1I2X6d+C+eQHawCxE24F7sYuIJNmzc3+/WQHRy2pIio1UNyYYZlbBGbtm3kjbGceh1Xuh0hu8w4chNK+47as0C6XViPcGP/2+Oz66jmsHW18p8vN2Z7lx56REBo3IB3fwAOa0k45iHrxOGAt7ipI925xGAVNIZm21kEyW5Kv+aGWfPmmlPy1pNWnER1aWXU0lia/4SnxOlVPCd0tQ9JM++WbNBWtrbXrQiAasWfYutigEex8265Zx1bkGUJS7ZVyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CY5PR11MB6164.namprd11.prod.outlook.com
 (2603:10b6:930:27::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Tue, 12 Jul
 2022 05:06:17 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5417.026; Tue, 12 Jul
 2022 05:06:17 +0000
Date: Mon, 11 Jul 2022 22:06:14 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: dennis.wu <dennis.wu@intel.com>, <nvdimm@lists.linux.dev>
CC: <vishal.l.verma@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, dennis.wu <dennis.wu@intel.com>
Subject: RE: [PATCH] BTT: Use dram freelist and remove bflog to otpimize perf
Message-ID: <62cd01462c460_5c814294e@dwillia2-xfh.notmuch>
References: <20220630134244.685331-1-dennis.wu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220630134244.685331-1-dennis.wu@intel.com>
X-ClientProxiedBy: SJ0PR13CA0119.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::34) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77c7e551-c8ad-412b-d264-08da63c44011
X-MS-TrafficTypeDiagnostic: CY5PR11MB6164:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lcpGcT3CMMPTT+lIMXCtCxJ1iCaB/VigHjUgGT7Qws0cUlGHa31hvWMgSlQsVGTaMjLeGeAOKbxj3eQznwiCxQ19VFyTtvYbRPIDRXxPwOFZn5h/lF7fa0ljAyAmr8LK10fjMNJ6D/8SUZYqKSO5X2HxLOOzF9lLDu2yr9a+1JW74rP0LEzmFtZedg4NLy6sTaExQfe+iXHpJ+VNt58XS1ihTAjMbxXeYuyPdj7XBavTyRGmFYJtnPM49d36In/BSHZZAJDHH4hwXTGUrPQaiY6jOLVZUYukgRN3tyAmte7U5OV2YINyDVtIJnOZiRkA+HU8b+Jy4/66yE5E53LtofFshBfFuARQZjXJyofdILpC4jAnBm95CWTFLBR9O4hTF76fePwURRsBcVwMmiDzVSzI0qXW23OIzOEJq3Ds7EYbR40OeRO/PEHwjo+5IqbLpX4F9Rd1vFSq9o9zYu2aM3ejQA4QHO97b0bg+2Z9Eunwt11H0Cwnd0KCTB8XVbk9dh3ponoo5TVWXkWzUuf/Fcok3VP4fNc8/BZnhxeP3wTq6TcvMW/X2v2K2kR2RnoSjUEYxRulQA4bRw23OA4nhL6Oz4SiCciWpf3hgE+SMef2CmlHCbEqXk1EoLRTV8xD0MNFT9Sp2bFjHHyYGQObx/RUA/Oe4XMk5MWsrqel57N9C7QEUhw9sCmd93mOFYhlk87IMSqU9qTCU7R2oVJ4QdCZledFOa/qQah7StVeVZuecppRfybcfuOFBPCOPMKLl/xaabI3pfTOVdibSGL4POnRKtyNjLRKC9+F+PvSkJA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(39860400002)(366004)(396003)(136003)(26005)(6506007)(9686003)(6512007)(82960400001)(107886003)(86362001)(5660300002)(8936002)(41300700001)(2906002)(6666004)(478600001)(186003)(83380400001)(38100700002)(66946007)(316002)(66556008)(966005)(4326008)(66476007)(8676002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sslrFOZgEm69gNApWWWe+cfEuiIQXkOriYBc2V+9sQDzM7qgVB0EN1vQ2mkn?=
 =?us-ascii?Q?E1noBWLpgQQcC7/XgftTcmiLYvPS0p7QgwuoUhQXsGguADWJOaaB2QRSHaZB?=
 =?us-ascii?Q?Chao8PHPQ9k5Xf8WBKbFrhP7nQUlG3AEhivRZyMWh/eQ2HyCOWjQFcZd4HPt?=
 =?us-ascii?Q?j3GjFEfLC/efsIkTN8EZ3laUqQRXyWozwP//t9zGb4u+74LwNyUKUu6tp/KJ?=
 =?us-ascii?Q?mZ8iemAFmdttCWhqPCjPSlIzuxpFNxjpgcgDs4nHEARODuu2eI6FfZkasEKE?=
 =?us-ascii?Q?+kY6wCt7U4sVtvB/pNh2cvtgU+jKKVKEuW+8ZgUxWtjvmAgMxawiySPsbo6G?=
 =?us-ascii?Q?Z6mUHH/wc5T6dIu33uAzqR4M2OMB9+evr91+nczG5ZPCwj3LUiB4f9d8N0PC?=
 =?us-ascii?Q?YhnzF1yHRS2mojtxPpKjJt3q5z+t7QxA98qWpVQ4GKWtL+LjQKXb5dEJ5Vfx?=
 =?us-ascii?Q?GbEdllky7OCjik9tF5B8ANikYyStCYcp6XwKglHOxyy1hZ/YfMsihobMyxyN?=
 =?us-ascii?Q?tM7pFm48DHzFWdkEvbGftF2oQPbxOf6/xijEZDYOuc85jYTf1A47wvw33i8K?=
 =?us-ascii?Q?tj0yFABxudypnp5+ZoEUCoXmqK+qbS+KM8x7QMDvMRDuip+767BpRD9xRJu9?=
 =?us-ascii?Q?lr9St4w8j8/JI96KIvUMm7ALvzXNVdvXrQwaOicmGt67IaO92YmQ9AhEqJ39?=
 =?us-ascii?Q?6GGf1tjrbKu5PQxoU2O4RvMLDjCVV/PgetgkHoUkXgyZGl6P8wcQUjFIaaU0?=
 =?us-ascii?Q?ZqwDVeINfkGZ9ugvgfZaf25lOp22L5qzVxBe71g3T5kOP0++Cs5cMX1f+U6z?=
 =?us-ascii?Q?gBNKNevOJxjt0t2Ki04kkCNDTGJ/Xt4Fq3IWpPuCs3CHI1n8Is/sULdBLT8a?=
 =?us-ascii?Q?bA9PjsBSwCzBwdHZW/Ksm0XQVFCLHebPeGtDIdhTaZvE7x9xwbuMSaHgaTDV?=
 =?us-ascii?Q?dwPN/wUbpkinBKEZQCYZp+YWMDfFBJHNdpZwNM5b4F8bDdBgBoLUNO0eUsZ1?=
 =?us-ascii?Q?Gcb3gGSHFwURf98SXMYfZD+fY+tIS/PngGAUjPHJ0norrzE4259wo0T430U9?=
 =?us-ascii?Q?nAiI+II7eBhJye3TyZD2qxDZEW/+6psTc92gNGzpu53Z1RV+dQ9FzL9sa7kB?=
 =?us-ascii?Q?V8jmQS8HwUSA+vqORooie6MzPiBimNmfo6U5jW83JCeC1MI2gAFdZci5N/JW?=
 =?us-ascii?Q?zGvwjAZal4KwgpV6QaEAdU+sllc+LX8XFQnywkDmQYl+FslhMDHsvM8xNp3H?=
 =?us-ascii?Q?ZzYHId3/hmVD5EzGLOhTMnDWIRmGQWxPRrXYUZ5jmtImEZYoCPGF1LwsW5S0?=
 =?us-ascii?Q?5FPPHEz7Efn0mK5J2F2UlUBnnmv2iTABJH9Ay8IE4Xve5B9L3ZfU5g8zXFWk?=
 =?us-ascii?Q?EzmwQtadXzaQb35wezv8ZiZHDFJBhpnDoPDGBeLBobhiMvbdSbAhBp0bXurv?=
 =?us-ascii?Q?Wsjjs0/PEtX9JGpeDO4lv223BMv94vua+Czuz1g/M6gDpuGXah97uKal7ei2?=
 =?us-ascii?Q?E11RsUnQnEHnueMidvsiRjMGI0tj3tUuCESgmxotPsaFjxlGGWzvOCp6X/0Z?=
 =?us-ascii?Q?kLkbEvV3pt5NMKkKglghG0tAz2DP9ooa1MT7mZEf+09PY35pn5jxAcowtCRU?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 77c7e551-c8ad-412b-d264-08da63c44011
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 05:06:16.8964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OduYgzaQWk3U3Wgqg3ARjuYl9dlN1nkL0ai9I8rB5QDhJLaXvJxo6mnxJMn/EEiSvdH/fxgYq3QiNLRCf4F6jLh3x0KZDzO3oJxZxav0Z6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6164
X-OriginatorOrg: intel.com

dennis.wu wrote:
> Dependency:
> [PATCH] nvdimm: Add NVDIMM_NO_DEEPFLUSH flag to control btt
> data deepflush
> https://lore.kernel.org/nvdimm/20220629135801.192821-1-dennis.wu@intel.com/T/#u
> 
> Reason:
> In BTT, each write will write sector data, update 4 bytes btt_map
> entry and update 16 bytes bflog (two 8 bytes atomic write),the
> meta data write overhead is big and we can optimize the algorithm
> and not use the bflog. Then each write, we will update the sector
> data and then 4 bytes btt_map entry.
> 
> How:
> 1. scan the btt_map to generate the aba mapping bitmap, if one
> internal aba used, the bit will be set.
> 2. generate the in-memory freelist according the aba bitmap, the
> freelist is a array that records all the free ABAs like:
> | 340 | 422 | 578 |...
> that means ABA 340, 422, 578 are free. The last nfree(nlane)
> records in the array will be used for each lane at the beginning.
> 3. Get a free ABA of a lane, write data to the ABA. If the premap
> btt_map entry is initialization state (e_flag=0, z_flag=0), get
> an free ABA from the free ABA array for the lane. If the premap
> btt_map entry is not in initialization state, the ABA in the
> btt_map entry will be looked as the free ABA of the lane.Once
> the free ABAs = nfree that means the arena is fully written and
> we can free the whole freelist (not implimented yet).
> 4. In the code, "version_major ==2" is the new algorithm and
> the logic in else is the old algorithm.
> 
> Result:
> 1. The write performance can improve ~50% and the latency also
> reduce to 60% of origial algorithm.

How does this improvement affect a real-world workload vs a
microbenchmark?

> 2. During initialization, scan btt_map and generate the freelist
> will take time and lead namespace enable longer. With 4K sector,
> 1TB namespace, the enable time less than 4s. This will only happen
> once during initalization.
> 3. Take 4 bytes per sector memory to store the freelist. But once
> the arena fully written, the freelist can be freed. As we know,in
> the storage case, the disk always be fully written for usage, then
> we don't have memory space overhead.
> 
> Compatablity:
> 1. The new algorithm keep the layout of bflog, only ignore its
> logic, that means no update during new algorithm.
> 2. If a namespace create with old algorithm and layout, you can
> switch to the new algorithm seamless w/o any specific operation.
> 3. Since the bflog will not be updated if you move to the new
> algorithm. After you write data with the new algorithmyou, you
> can't switch back from the new algorithm to old algorithm.

Before digging deeper into the implementation, this needs a better
compatibility story. It is not acceptable to break the on-media format
like this.  Consider someone bisecting a kernel problem over this
change, or someone reverting to an older kernel after encountering a
regression. As far as I can see this would need to be a BTT3 layout and
require explicit opt-in to move to the new format.
