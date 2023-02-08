Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A0762F
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 05:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675835380; x=1707371380;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aCgFOFJlTPZhZXMb8gG6+c5kfv8PtBS/HJ2d2R2hFPw=;
  b=HSFmAZj0FzM66ORyH/2BzWqeFY3fFtyRDyfyek9qkwxgjY1YJzQ9t+qz
   HK1M5HhH4yOr4gTi4XuqsgX2FNl0vHXu37cV98n6NDxsedPUs5js+uwoo
   Do6A+8df3e3K6HqygfTL2DoE7f/Vi5Mbgz01EnA2XSp5Zj52zYja92hji
   n8OIcztcqlL6Cdy9IOGdqCQiHX9yZr5Cricaq2wrWFE/C53FwWQEVBtYv
   HCWfzTVD9fobqxrP31KHbkb/naasSPiazwt10i79a+/1qKKqcIRd+VIx7
   ysy2/aK+zVUyCx8Je+vg172jAwQSHeBK42ZBn2RPy7nWG6UYgaPis+W3p
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="317716381"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="317716381"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 21:49:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="791076735"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="791076735"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 07 Feb 2023 21:49:39 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 21:49:39 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 21:49:38 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 21:49:38 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 21:49:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgFxHb0lI/KBpHqM8D8Te7LXQTYjUY04jcICmFuBHbVYVTwOQ3rS8Nj5v68vf29dsNbcSTy/dG8XIfY1J804+/Z8vTEMZcs2QeJofmeuy6lxo8GEIVeB/ZnMmAuMvOs9C+C8YwICei7xMXDxpk7IVn+KzOamvkReciiYZ+ELo+6vW6ZVngFOpt+7fTvcpxWpfC+AJ5U72w6tCpgst+VEwFbyFKnMADD8O0LSFWrnP3CpR1zH3w4IF33kn4SfJ+F1V+Vq4WY0Jud8kI4SLU6ZKiP4SOeCtJQBj/8gfgIN3MPSCXgGHTU2mFkSTGMlR4esFY5QUl3tm8bFkdXUKJ4L4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U7L4JRqBQOMFxXOXYDgfwv6l0PUfSivhVf5FnXTvNCc=;
 b=l+vQ7loGehsbuMSnM5810lNc4v1tvslczUNdk2eFgVPx2yexZ8fYOgiLxO5wv5fkJOLWr17MYXfGs/ZwoxNHuDZkDiDsMDb2TFoSayzqvYynoNmmM8YJlBMcyTtlS5yTovM/QtsTybwfgnXI2F09jfkrJ9sGR9l/Mx4y63RKYHctquL/uHYTVf8Whueq6dcTIjCgzDPqYcI2k5/tHYEWVeJj9R1QYy3H/5nlro3pjC2GpZIom2/QpA0PMhHf0tGwsc8sO/broyaazipgVeMc/AW30j7wFd3FxkJSv7jDPFvBMJAGW4NMbn5dfpGkH/n4dxR6eLsc1TjDVGM6iBIU0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by BL3PR11MB6505.namprd11.prod.outlook.com (2603:10b6:208:38c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 05:49:37 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%6]) with mapi id 15.20.6064.036; Wed, 8 Feb 2023
 05:49:36 +0000
Date: Tue, 7 Feb 2023 21:49:32 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: Gregory Price <gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
Subject: RE: [PATCH ndctl 3/7] cxl: add core plumbing for creation of ram
 regions
Message-ID: <63e337ec8f2b6_e3dae29478@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
 <20230120-vv-volatile-regions-v1-3-b42b21ee8d0b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230120-vv-volatile-regions-v1-3-b42b21ee8d0b@intel.com>
X-ClientProxiedBy: BYAPR11CA0076.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::17) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|BL3PR11MB6505:EE_
X-MS-Office365-Filtering-Correlation-Id: f16b86cb-d479-437d-6cbb-08db0998425c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IGuch+RyyzPIwoQECwsNjswUWAXGU2IvwnVcgWQCmeghW500o2ImeZ6nc7IxNq9zfcks5ADiN8xrsDD52Xrcu1k964V3tHONGbPRMoeEGq+q/tACjkvoMkaJfw5M+xiaU/iIA64o6kMCVdZbZlJzxBuzlzmhf4m8GPk/RW+GGcWTX864GhkZ7+r26E6SMuGlWGiWnaLIP0rN/mofp8/UoSn75orOfv0SZjNeoKsYCZk9IkwwkuV86T5Xo91ES0m0ufTwo2aCMyDwga35YB7hHYMR+MMuENkslPEBR39TtQ4aHPUK29K5a1zMb5FK0Q1663R+Qhn97MqYRzAvWD+9wTac/xuFb+WTt+764FFgJ4JiCdXfZmYI6+5i8uQ4rDZP6UPW/Z+uNXWdPzVO7BpOmawO3lRTaCjLDi4xJESRzzXhea3ZAFiPqVVrUqhPnst61un+qPuZygf3BYt1Fi+Z3l/1hBtp8e5w2OVDK4A80WSR17gh6+TGmLRRUr74ZxJ4vE8ZUCCorn8zjIUjQ6M7Sciq/tLjpBexDXO8vaCsz+yeb9JKw9Gtyl2325wj4I0rX9ZUA2ZWfsFscuhy1dyCIpm7HOeQyRvYkg8DF5ae+La+RnBSmkyS7z11RHgdS2ta6RronrDpQmA34xHnIpEmJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(376002)(366004)(396003)(451199018)(5660300002)(6506007)(86362001)(9686003)(26005)(6512007)(4744005)(186003)(8936002)(6666004)(2906002)(82960400001)(8676002)(66946007)(66556008)(66476007)(4326008)(38100700002)(41300700001)(316002)(478600001)(6486002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?56i+1QcfoDymfgNDIAqyOl1hJrgFg5rljy41rklvgmIi8DRR7eioeUoJ8a+y?=
 =?us-ascii?Q?z9ddFK561NPOIc6U+0YO0/jYZ+TM0k2QSoF3uqXNVTAcIQn0TXoiYsNNRtRi?=
 =?us-ascii?Q?XxmEZA02MJb2fPktiPNL/tYlVGhKpyd2eruGglRCX62fo3Rycq30TQN8qyWP?=
 =?us-ascii?Q?p/LspdT2Fup6T19c+vPhrOlMhaupusR6zTqE6LrzD31HEnM3ARzjevX2KIY5?=
 =?us-ascii?Q?meTOXTb4Cy72HQfwsvQ7NWd9vp3Av4iqBZzIoWHx3Wc1vpNyBQLbiEFJYHQ6?=
 =?us-ascii?Q?eSDN7P41Y6/+emyaKKZGM9T5A3+QauruVpfJlc9ISZyAEjvWd79rTyiDy+bl?=
 =?us-ascii?Q?MlPXvksCYe8VgmuT4+pAkHZH//ZafeNBuLbVi5lssZxD3isQsy3RQIg1Q5mM?=
 =?us-ascii?Q?FnFOJe8RZ/X5FKglUyn0XRVJ2pnPl7Gpgz5gGvRSkNZn8p0ONbydYh38ms8i?=
 =?us-ascii?Q?0CnJ+0eOYI/RdiTEO1sKCMWFTAxCPsAJQCVupMWo5vE76AeNpGPi3NHGZ8nj?=
 =?us-ascii?Q?/jsrSTUqtqgu0JH+zzffPKYQA0ifKcxh9ynJf395+3lXskR53V6Dn30YJoSm?=
 =?us-ascii?Q?/4wLTHZX1vSUBZV5ZXl0toWlfqdcFPa59ehBlCFjnU4/bPYRK1xvK87smoyS?=
 =?us-ascii?Q?L9JwuBXC2k8qeXjRBst7pi3t3eo9840ArCTl3qgVmeC9X62jGViztZ5iL27x?=
 =?us-ascii?Q?FtzDlhgFFvjqew3laMP/+EqpL7PuDqXQZ1bWqDDIkYt6Ljyb1mujkkpql5EC?=
 =?us-ascii?Q?cKbfbvqtN75E4kjQPfkJ+jVp+zTvTTzkYEc79s5J4TbUaIQ7hPWJgIPVxk0z?=
 =?us-ascii?Q?7GZ8gwyXBl0b3cvJmcgABJnp04hUTX3u08hccg2ZSzjYXcFcpddj/pVIkY8T?=
 =?us-ascii?Q?gboji5lWaugU0nFvGpJk+lSlxRGKU2u/uF1nDY6iIg5M7MyFltsOBS1uQ7zj?=
 =?us-ascii?Q?ZIoWioq8zN4KQGI2jNouJ4GU5Suqc1sOAufrxj6rmt9xpdO1x9WzMcTIhTF2?=
 =?us-ascii?Q?+MEMEcRb4hiUUlmpZDWMtJHR6V2gbFkpMrnyMfOdzzf/5Jj/GwkMfTFF5HyB?=
 =?us-ascii?Q?luySC5jCeLtBbg8i9Gok3vmHEqB+PM5WIEdHDXFtPA/NUTXUuYakkGQtLmAP?=
 =?us-ascii?Q?cHF94hsm4LQ+VV5mj7kwldvLhDUMifEewtQMRvoAay2rNqpozLfiZWE6YoIe?=
 =?us-ascii?Q?EafY4voUIbnEjF6iXAGgGX86SuczVTRO+fGcdvvKN+Ui43A38rtTed6dw7qm?=
 =?us-ascii?Q?8H6oao/HE09vYhSRDaiuxKyrsNwnZjzvpNuvyqpsiJ3fwIRAHDXImcz2w/Y0?=
 =?us-ascii?Q?N/CzAYVEmylcAs963/63+r7wHpKYwn00KFBa0XL2CfOZbOtUKBVerMfYkchl?=
 =?us-ascii?Q?gS9VqfCvlpIWwVPhLApgqe6KCX9Nf2d5I2BW7L0Rm3qyvEM0ER6Twz6Dn3Rb?=
 =?us-ascii?Q?Rb1nJQbAR+0AIkzDqu1AZ5v3KLJqnfTbTO0LdpInp3EDz4AmV+K+a5XfFW8x?=
 =?us-ascii?Q?evdAJPntLLZi6Otq4/wsc8IH9Pq/Mu8lGVhIsuJqCqoaGj5/qRwW/q1M8nQw?=
 =?us-ascii?Q?Ouqqzar8TbQDwTsp/1U+CYsKqSeP65fLg+zbFEutfPsUabZLuuqqbzHgBa/j?=
 =?us-ascii?Q?YA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f16b86cb-d479-437d-6cbb-08db0998425c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 05:49:35.8902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SpXIJ+Qr66sr3OhlAuC8WBOg0grCVjk1GtY14/DRjzuJ4IRxZRXvsbV/IYy881ceeOsoXC0ZbY6s5Iu5Y2D/xw2O2yqicbG/Bv9sb1KVpIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6505
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Add support in libcxl to create ram regions through a new
> cxl_decoder_create_ram_region() API, which works similarly to its pmem
> sibling.
> 
> Enable ram region creation in cxl-cli, with the only differences from
> the pmem flow being:
>   1/ Use the above create_ram_region API, and
>   2/ Elide setting the UUID, since ram regions don't have one
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
