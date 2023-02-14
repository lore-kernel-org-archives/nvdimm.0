Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490C6C0A3
	for <nvdimm@lists.linux.dev>; Tue, 14 Feb 2023 21:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676411540; x=1707947540;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=oDBNbqnOFpy0PSsFsf7116k4t4cT6husiw+QhXh6giE=;
  b=Jl6pmv86C/97a0jx6dxp4bE6bKCduk3cpSFovn0SHt2dr6GdBuTi3oY5
   YTQ842bCMA6mpZVlGGEzWY2LlUWBXdy0Lddun/ZBGhDg4HKls1Nnipe4O
   qX452aXFOzgPrQf/gBWsJQXW2z+amx7F5Hch/6dVOO4DlCsdQpKbPU6qx
   qI5kzuMbNwAz1K2j+CpjpJr27FNqEkwvMwW1VMGFWYxaIIpKwOHrbQTqT
   ttn2YC7sHvxZ9VMypSD9aUnAIJM5YqVtOvhg8NDm04f0Mw7zlamU+5UUj
   0H6Xc1QXZpQQQk6hOvH0/AehV4wFJWPW4BxFYEJWWlvVc2R7auft0d16u
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="395901285"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="395901285"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 13:52:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="998222273"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="998222273"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 14 Feb 2023 13:52:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 13:52:18 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 13:52:18 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 13:52:18 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 13:52:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mg4Z/73WUi6VuyTO/JKFbXWnsn9jHGT3BknNEmaqlmt6PUmZb/9ws/0CKJAFAP38Z6DPBv5OjYNJjWcsBu8vD3R694/G9YhHs2cLLAjwBIW6BmT2DLFuS23Fk2ocrpOsH9DXFu8djRungInCRRsYm91Af8ZHt4LvZ21kfaUJltoGslu9qhwPESLrD5fS5wNVaCYTt5sPCZzdb7m4P1DZ6aDeY28ByiQn/sO2h3bJEkxkVbP/QkdHBblgDWZpaKJ6WBgJtsGcIRZ0LREf3FGrgw1dZVQ6Jbxt5hoSqfXxHFqemPctOm1qxn4z6iLio1DlNanhLuYUSK9icu7HljSfiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BngIEh1M/ArGwm9koy5mRj6IAp1+skknN3smfQ0DG9w=;
 b=XJHhB0FBJQ5zy3GIE7Jek/Ma6hJeTWUneuZwmzAOxWocEwv8n/fIdJG4XzlYy3mFKGi4+gfuw+1AZ0GMjsRnDnh2Gvb0wG1vin3xyLPBsuE7UURgMF9zMYSTuTrP8uIW2Unc+UWGg8B9wiQYD/yZ3Nq/XsPGT7WewVRpUjGlu4Fig94X4UwfEmbxzMejwyxkOZuEtwpTcmKIBLbujPtC51RsPcpv1E3dkuMhxXJmLnfVxrXbSfZSpoDeyeEqubvaEWRoQr6T/cXuNQ/5BQxuZxC1ejdys9Z2VblNk/mZpZNn1zwyI/9BlCi4HczjsUkT8vRdBgiovpav1UP5KIr/fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB7499.namprd11.prod.outlook.com (2603:10b6:510:278::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 21:52:16 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%5]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 21:52:16 +0000
Date: Tue, 14 Feb 2023 13:52:13 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Adam Manzanares <a.manzanares@samsung.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, Fan Ni
	<fan.ni@samsung.com>, "dave@stgolabs.net" <dave@stgolabs.net>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] daxctl: Skip over memory failure node status
Message-ID: <63ec028d9bef1_c24a529499@dwillia2-xfh.jf.intel.com.notmuch>
References: <CGME20230213213916uscas1p2ee91a53c14ec5ddcb31322212af6cdaa@uscas1p2.samsung.com>
 <20230213213853.436788-1-a.manzanares@samsung.com>
 <63eac7427d994_27392429460@dwillia2-xfh.jf.intel.com.notmuch>
 <20230214065653.GA437651@bgt-140510-bm01>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230214065653.GA437651@bgt-140510-bm01>
X-ClientProxiedBy: BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42)
 To PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB7499:EE_
X-MS-Office365-Filtering-Correlation-Id: fbd38242-0d35-42ff-2794-08db0ed5bc7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DyP8oKdlz5IdXp0L5AOPk0NtLHzgA85Tr9xMCrIlBb24OtsS+4TkpxGta0W3Tb723TOKHnyScYoK3/uBiqjATbEeUeykYFMzaHHzXw50D/WSMTaTAoAPHurkbXZLL051SgPfEafaiGnKLfhALSi8c9Qgx2fiUeqKz8GF83ufhEb1ibevwUwP/508fXtoWXDEWMruPAFc8VeIFDkrVN37uKmZWi4Lfza6BXfj0RgPkLG7gKj4KWMsUtnZYFLsbVLt7j4WVN2HLPtR3hkwgSgzhgGSABJggESOyw9126/Sc0oNln+m7Rs5yCMTMOiYPov9ZSE4uP/jK3y7w/zO08olHoAe+88K4Zt7RWxQuKl1b9E3fhmOnPI+arp+CHMQnFk6A8/nHvV5+7EqSvTEdPlM95fNdCHoIPtPJpHngUZW9pyKzhdxB2VMnnPhZSEEYcdbxdPubssOcwQ3PAFisCjmJDy+eZr0cHkXBylPoxysUpt5LpAeP2rZFvBwO/IN/SIchEoJLoipIn6yDVHPKG9xt9aF2K+LPfCU1u8L9RiUS+sOEMVXYZpEwv0W8oos3CG+D7ywXistzM9PrsKJczRD5EuxeI1yPLExHHPM5zr2gAoWI7Hvm3brdY1620+gseBS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(376002)(396003)(136003)(366004)(451199018)(6506007)(6486002)(966005)(478600001)(9686003)(82960400001)(186003)(6512007)(8936002)(41300700001)(54906003)(316002)(110136005)(26005)(38100700002)(5660300002)(83380400001)(66556008)(66476007)(66946007)(2906002)(8676002)(4326008)(6666004)(107886003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YYTdMfTegdvbXrWS1aVWWRZCp3O7SHA/tASq0D7kbFAPtY/Qi0dz//Gli4RD?=
 =?us-ascii?Q?vBlhz/qVM5PLatF9DIJbGhR558QQQSWjqOJccT5J3EbTRIQKAlJzRcqAxg5d?=
 =?us-ascii?Q?31ZMo01RViihkwfhMK5DsX5F1r+htvg6JJ/+Mu4djTwD9PU4udA+xwII4xaL?=
 =?us-ascii?Q?ijAqhMGFZjg3bQjbN8hWkMgQKDtlJq4Uyp/Xiz0gkiSeYGUJyEK6HRoVcN3b?=
 =?us-ascii?Q?4ynQp15kr8XdCDHbwHTOrluBokL3cG5Z66ZG47g+d96KsmD5b5+JZdgMMtN8?=
 =?us-ascii?Q?yUlWpw0KiD+m6RwaWSL9Bz7pWv8ljFeFqfupO2i8PdlKbIAYdvCyTHJIjwp8?=
 =?us-ascii?Q?sD+A1UKptbwBtWEcqV/KtJWB+l5e4+6By7b8O6AHZxQQe/m/UqPsZMo8DZEM?=
 =?us-ascii?Q?gmspNjyeIi0T3KPnCCh9rd+GDfdtmInsPwDJx3AyDyZgJEJItzQl0HCL2DkA?=
 =?us-ascii?Q?65BKJpcgcdvc1yodE33q1T24bfR2DulBq0C51F1+GUFt+404eb1rrTXiPX4r?=
 =?us-ascii?Q?g0zWsoQf43Kqis6OOn330pSbYcpJEMzzkQlAjSJJPtHkmmT3iv2liPNHMNhV?=
 =?us-ascii?Q?IDd2uAEOnPo4kVi0QpBxbarT0oQlT4nyhFq7xkj2Jrg6hIhukoF9wE4yqRDu?=
 =?us-ascii?Q?DI2+7xl9zJd/VxeghHr2hrJMZ4jETdjuRIYnIuIfv0sMNV6v3MKWuChl1sD6?=
 =?us-ascii?Q?xkLyNnp1GhkyIHyAniJ6Y9a45trsRPEd2AzSttxC/BoIwqT9yAbgTu1MAt8u?=
 =?us-ascii?Q?s7PRcoX3zFVvfapvJyHmxAlFSBcq53ie0XTMMImhp7Jms7LuVKAZbPdvPrLC?=
 =?us-ascii?Q?f/h8xOa/5hY+S64MtoyAao6Da49Zpg9bJElZ1DRY+zRvD7Cahftxr2s8DSMf?=
 =?us-ascii?Q?VWikSzTbu9TisaQtE3rLqHlpuhNF9vjAA1a18jYcT+imbeNfxUfGopT945RE?=
 =?us-ascii?Q?6D7coPN80FF2ZzrO75c34TZWSDQTPlq6Q44ZWT7mK1piZftcsqAW8vIEiqwK?=
 =?us-ascii?Q?gi+nRYbac8kFUVQoxd2aN9VDqZriyFq+Asyf0gAkQA47Z+MJsUlgVq7sAxVX?=
 =?us-ascii?Q?6GQO6looIZjb0wOfq8e/UVWVavxOMG3gOhKBdfx/0tuQnOhYRfd8NjlEqa/k?=
 =?us-ascii?Q?5h1ce4k6mCs8r1znNExnEalf9PPbLHlp0J3T0LEgj+AJdR9r09E9T22cTM6q?=
 =?us-ascii?Q?58RHqnCDuwgo4DfR5uhWE66Ixk2GFnId3SXYe1XKTlGPNvwHohrHmcK+O/X9?=
 =?us-ascii?Q?rrr0yoeBrC5gsqS1GaE8YD6vwb2p6Xwc8XmRso2Q89dRSTbmy8+R3JGMjZNa?=
 =?us-ascii?Q?ZZGDehDrV4RSeZfYB3quKYRcNifE02KW9Dm/DJ2C7O2AiFPdROlIXLcs0UT8?=
 =?us-ascii?Q?FYrx7OdTiRsfFwZ9McoVw+XdNNxBksOfhAMwWYKxBejhEwRgrj9/LRbL8rJt?=
 =?us-ascii?Q?8Kenw2QwD4d7S1XOImN4ptZuiw8iLNIxryMolS8Wp4fXo0oHuNuRUu17JY2Y?=
 =?us-ascii?Q?uioDik0Umbkn3ac1fPOtc+1oIu6gvJ7vtJ8WHEI1gfsi49ctofoQNBW8njja?=
 =?us-ascii?Q?vNFw+kV1t8rHX793Ggkxqz+aIa+OH9WrohavgsbIInSxDAkBmb/AVLzYaigQ?=
 =?us-ascii?Q?kA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fbd38242-0d35-42ff-2794-08db0ed5bc7f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 21:52:15.7736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5iQhF75cZTExoNsKtrvmIv24+aJof+NDTy9KRntlhhlLf1OTowimtDycKDXVWHu6FsHlJebXxWuHfTvOUmLnGO2e7u3u8cJNvlKNtUN+ikI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7499
X-OriginatorOrg: intel.com

Adam Manzanares wrote:
> On Mon, Feb 13, 2023 at 03:26:58PM -0800, Dan Williams wrote:
> > Adam Manzanares wrote:
> > > When trying to match a dax device to a memblock physical address
> > > memblock_in_dev will fail if the the phys_index sysfs file does
> > > not exist in the memblock. Currently the memory failure directory
> > > associated with a node is currently interpreted as a memblock.
> > > Skip over the memory_failure directory within the node directory.
> > 
> > Oh, interesting, I did not know memory_failure() added entries to sysfs.
> > My grep-fu is failing me though... I only found node_init_cache_dev()
> > that creates a file named "memory_side_cache" under a node. This fix
> > will work for that as well, but I am still curious where the memory
> > failure file originates.
> 
> I found the issue on next-20230119, I have a suspicion your grep-fu will
> work fine there. 

Yup, thanks. For those following along at home, it's these patches:

https://lore.kernel.org/all/20230120034622.2698268-1-jiaqiyan@google.com

...which has some implications for interoperating with CXL Scan Media
which is distinct from a hardware patrol scrubber, but that's a
discussion for a different patch set.

For this patch though:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
