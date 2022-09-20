Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5D07C
	for <nvdimm@lists.linux.dev>; Tue, 20 Sep 2022 19:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663702268; x=1695238268;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3RfUi9G+6Ho3ZMd5A6HiCQFDMyBY361U8lgesaF3VHY=;
  b=IS4nM8a7cNYlLdy9bc1USQfJtdtc6Q0yLzrwuwW7M1F0ji34khbqa0qb
   BeL0729D8nvE38NRfd0cvQnSutWogEQU/Oq1QP/wzseXz54IUDH+cZfqi
   MAcPbjkPXs0e4dHXIgQe1KPgzoGfnoHm+hx7D2abrZDje6OO1w337Ua64
   awGfCnQoomxTjcvdHAXFi/c8498hL45vRJ55I4iWNPs1a8QSaB0pMLUR0
   n1R9yBM2RgO+RTT2z3VkJWZVaUpW/7Fp0ctTOyZ2ljnBgnKoALfKVsbEE
   darPK+DsWpk2TKjiB+YMZ/JvDTTejvjF6d6gD89y4ztf76zNhm69FOpPh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="279526638"
X-IronPort-AV: E=Sophos;i="5.93,331,1654585200"; 
   d="scan'208";a="279526638"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 12:31:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,331,1654585200"; 
   d="scan'208";a="794388708"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 20 Sep 2022 12:31:07 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 12:31:06 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 12:31:06 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 20 Sep 2022 12:31:06 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 20 Sep 2022 12:31:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbZgL9mBHSUsa++WGj89j2ABHZPfkDlzQTL8bBYvMf+6lJhWLUAeyE6e+VEMHyrpKVDrM5g8P7cUMazuXUmj5OY2Hi4IS0//Jl/xAsWieNLnA//5y0zvjIwflyxeG9QDvkHph8mr2febQ2H6DbUeuuZZ+QPnSqqUKU1qW3R10Gm7MjUGsAKaBIY97O9b/3K1DEo/eHhvNlKy2LhI9/SYYDVUpPjWg44yBTt1RRzjOpgB+vPtID9Jy/n5IudkN2jMq8Hn0pArAVZcdKxrojzY7bAlVkpTnil3hlESvR3pbHOn9EqIU23V/Abgf2NEQsPDv5aBe2dh/wC2JTVE1Knn3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Gp9DnVyAXRHf3/7u7idqRjPNFiG+WE9frqLlfSsQpI=;
 b=UbmC48+9oz416xB97ToOG/jQTrglHZGaG5oH1KpsCdXMyDijat81U/6rMyVQyyOzaccFKoqtpC29RLXP/00NuXtyf5wRxk3SY9gkrkQvljVJ7U/X2YpklvU9IfEz6iY+o2D36e6uqF2N4a4ybWDP2kcFdNZ1Zm/aoK/685cAQra3VugB0uLPKKCAls2RNsL2682M52Vx0kDIkwh6evbAGkLueMeLSQvjc4ANl/oo8ZYvtxlW7Ja+AHwJ9VrHC6BvonSn+uY1UzhC6IjgXApRBwV3/vGAWnFgEDitq9RvqvsfpiCVLjMwodKtcepjOuIRXXitDRuE6df/rlkDEG8dsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SJ0PR11MB6693.namprd11.prod.outlook.com
 (2603:10b6:a03:44b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Tue, 20 Sep
 2022 19:30:59 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 19:30:59 +0000
Date: Tue, 20 Sep 2022 12:30:57 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Christoph Hellwig <hch@infradead.org>, Dan Williams
	<dan.j.williams@intel.com>
CC: Christoph Hellwig <hch@infradead.org>, Dennis.Wu <dennis.wu@intel.com>,
	<nvdimm@lists.linux.dev>, <vishal.l.verma@intel.com>, <dave.jiang@intel.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH] ACPI/NFIT: Add no_deepflush param to dynamic control
 flush operation
Message-ID: <632a14f153dfd_2a6ded29444@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220629083118.8737-1-dennis.wu@intel.com>
 <YrxvR6zDZymsQCQl@infradead.org>
 <62ce1f0a57b84_6070c294a@dwillia2-xfh.jf.intel.com.notmuch>
 <YtefnyIvY9OdrVU5@infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YtefnyIvY9OdrVU5@infradead.org>
X-ClientProxiedBy: BYAPR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::41) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|SJ0PR11MB6693:EE_
X-MS-Office365-Filtering-Correlation-Id: c952a9aa-0dfe-4b09-f59b-08da9b3ea59f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v8S9KzE/TSlpN9sHd3aZR7U3MwmUmHEO8Dp0Ll1vmRHfyZdBZlXQto/Vlr9If4MCNNlFbNVo4vn+F0XV2YXr6IsPqJpDdjB4Tzl3dtpaBIDuPAFoCgbHVPO6GIpWBPPPLJn4VYgqCqamCU6gc8psBMzCdN5zC0X3ehMof7eKd+bbxguvN4P6CZdOaRof4OKz3RzerK9u36KDjDq7QxV7Jr0Zf6+9pH382GHlaej6m/sa2P/ETvKzhQyK3i6qq/zyPZQJSFF9N+2kwzJFqFia5CJRA3vDhV/hFx/qohwBTM8T6XSoIB+zdtLcQyCEiQahwjtpaa5uOuKS0RbEHwWW65anvhsJNPAbqmrJeaoEUUJpP3ECKY72Hf36GxZm1DNZRZ6WfY+gOg6fZXeAnFkbU+S1Q6TXYeJMgCqaR4aIJT4uEwN641nr8eKr/Q6Mwl5kXwlQe/wBkni+WIE+VkbI4qsUWcc9qQuc6fprvAbi6rPZ+jvs6jJenHejPA1uz/loVgj5NSjQmMQ1EC/2uDyD58bFkVCWnUZNn961ZhRyG0TvpCoGgmWaLrG91KwnB+lEfRk50tmMxlXRv4apadoHMN2h0RJJUHd9vj1uUhcbKvQIDpjBSw2dIPUeIyCvlJobTl0sgsFZ2MuQfACr8z+x48vniGmJhz0feYQmNQBAkDyugXT2JaDN9lHLQhdTloB9SmAhars3e3CQ0ReXfQE/1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(376002)(396003)(136003)(451199015)(38100700002)(186003)(82960400001)(83380400001)(5660300002)(2906002)(478600001)(8936002)(107886003)(6486002)(6506007)(6512007)(26005)(9686003)(41300700001)(66946007)(8676002)(66556008)(66476007)(316002)(110136005)(4326008)(86362001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8ZkuMU9GlrrSq4I/zcpdWNbTtcRRqIyW784pfoCYeso7EGj1MVqEPSf2SQ1u?=
 =?us-ascii?Q?WHivVWilPsB12joXpAoJ4kOTwhH2YHsUsRiOVdJJ2XG5g2gx0cl/9TRB/ncw?=
 =?us-ascii?Q?81phGxPtoI8N2Fj5vRzVeptYB0TZAx5xZ8e4M9UBbVCg8eHkvopqfiQpLz/J?=
 =?us-ascii?Q?/0p42SRCF9XOfVvk0f45BQVXzwBtMfWMDZ7iJm1HYWxa4uUUq1B+rIWbLlyX?=
 =?us-ascii?Q?YtnK6/Bi+pqEoEo+wopI/79ObLT3LudVgD4i4sA+VcMaAyjVcqnl1UbGgbYG?=
 =?us-ascii?Q?NroI06Lpsp9YdfouYiKk5WfY9mygFfo5bp5n4JnieAverP/vxT0fkhfiB4x9?=
 =?us-ascii?Q?cvgS+Q/T5TROD5rbW9cdTs384mfmzOFi8ERrSxPOkHgZWxq8O8cyI4Yp8N4E?=
 =?us-ascii?Q?RT6f/49/UVZtcqj5EJ3CZMrOrNcMQqDZ8VQF83cQ1iUcoxKV50WN61R8jLBp?=
 =?us-ascii?Q?YzoSmbdqbOHJ0PyLBd0yY1P+Iwd1DoWUMmX4/JW24mRrWnIRFM5+btFC0/EX?=
 =?us-ascii?Q?+aymOx3KdeetMuDDl2DYBiyeKnUW6Ov1YvX3oZnYI0QqqrjIrSTDEGBRRZF2?=
 =?us-ascii?Q?D2mxqTh+ltKsHGZgmaT8WCnec+M2g92hxQr/IlagutJgZppaQqeVj1dfhcbF?=
 =?us-ascii?Q?pgnF8bNK1EoghdrEvlE+lFNs16mO4hTAi6bbtX0Z09ze3tajF2D9ZE/ccQvS?=
 =?us-ascii?Q?S1uMBdLekuQLISOAiuyNBngcANXynkbYPeu6dc+pZKxUKXQvagCLnUpjqnfZ?=
 =?us-ascii?Q?/6d5jzkeXNM7l2I61qZBix9TUuW4JKBe05lPFqjPkvzysQbo1URkZM2j3LDT?=
 =?us-ascii?Q?gIF5+U8e+1jzpWnz07hfMWXi7+enoqDLtcK8RlpNWhFCL5ByGwqMSVao/IfR?=
 =?us-ascii?Q?sbLUF3ldB623kqyU1bdzZgmANtsotIx5PmdF/FSEJ4u1EP4eNIrymguWmj+V?=
 =?us-ascii?Q?hB2Ud0Ly9pYHnA1sgNCU5nZEVdm08mWn5IL5LxeqezbounjjM18uGRTQxlTJ?=
 =?us-ascii?Q?kPO4DNU81tDa/zhZoHUdL3jHe1ven9etVFhlxziipAkS5qQjiv6659T7YNvr?=
 =?us-ascii?Q?J0CrOKIjesHvauRHr3IhlESkWPT9TSgDS/ao5RCnpI4T1o027HpHC8En8Fde?=
 =?us-ascii?Q?EDAxyikJlAib3ZIIru5oBMpQQcoMh/hNHz0rzdRL8fY7bbJMmz2jQT9hPqb0?=
 =?us-ascii?Q?GWUqisFfaJZhM5VgpsbJ4jtT836tlnj/l/zxrWHuDWvjhH5y5nB4hLlnFhnc?=
 =?us-ascii?Q?XUN89BK4uSfaJAjnzsSjl1EGHcoeUzcsCJH1VI8MhB3+B09TDxXQ+Tk+/hMQ?=
 =?us-ascii?Q?m/oTJeyksjNUz6ElSiwxdw9+9JV7rOfPv4bAhIWzd3PbEyDAnsUShPghUt83?=
 =?us-ascii?Q?wJCbhGy4LH6atxrYh0QlO6pvhGJkf2xSsKjoEzzPqGO0NbpfLKlhBSiArAjx?=
 =?us-ascii?Q?CBZTAMSZCiPyfp11lF5f6/Cz7KYkVn1UPcOl3kIFfbgDk+1EXxYtBNhGJUvD?=
 =?us-ascii?Q?mkW0fy3kiHifBSlfrsfFvNQFFusM8RWmHSfCo0/SIKbUREOudCWje+YswemK?=
 =?us-ascii?Q?/ItlqpQ1S/ZMNjYlWcGlzLD4kKDrqjE2aCXURWcbufF/nEP/khvlbfdcMD6q?=
 =?us-ascii?Q?Tw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c952a9aa-0dfe-4b09-f59b-08da9b3ea59f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 19:30:59.7847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y2r0zGAC4ptsrPOw+63wkGAMKW/FZS7ZHJBx6WlHcJ3XhUpnKKiHB13YJ74AlnejTUFjfnmvaXy/xbRJQYejCfgkeaxqyntA1+8H9q8zFVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6693
X-OriginatorOrg: intel.com

Christoph Hellwig wrote:
[..]
> > Otherwise, by default the kernel should default to taking as much care
> > as possible to push writes to the smallest failure domain possible.
> 
> In which case we need remve the device dax direct map and MAP_SYNC.
> Reducing the failure domain is not what fsync or REQ_OP_FLUSH are
> about, they are about making changes durable.  How durable is up to
> your device implementation.  But if you trust it only a little you
> should not offer that half way option to start with.

That's a good point, but (with my Linux kernel developer hat on) I would
flip it around and make this the platform vendor's problem. If the
platform vendor has validated ADR* and that platform power supplies
maintain stable power in a powerloss scenario, then 'deepflush' is a
complete nop, why publish a flush mechanism?

In other words, unless the platform vendor has no confidence in the
standard durability model (persistence / durability at global visibility
outside the CPU cache) it should skip publishing these flush hints in
the ACPI NFIT table.

The recourse for an end user whose vendor has published this mechanism
in error is to talk to their BIOS vendor to turn off the flush
capability, or use the ACPI table override mechanism to edit out the
flush capability.

I will also note that CXL has done away with this software flush concept
and defines a standard Global Persistence Flush mechanism in the
protocol that fires at impending power-loss events.

* ADR: Asynchronous DRAM refresh, a platform signal to flush write
  buffers in the device upon detection of power-loss.
