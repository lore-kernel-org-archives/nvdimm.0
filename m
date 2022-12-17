Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A40622
	for <nvdimm@lists.linux.dev>; Sat, 17 Dec 2022 01:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671241024; x=1702777024;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EyxDyTdWElyCWGTYJ2ezjSFp1UVdV0Zvzor+42+AXeE=;
  b=E3EgJQk+rE8HxY8yXUMMyj1G76IHqrbh4khe2BUx4U2Sfx9SLT72lq/i
   bbw4aL7EMNQp/dTOBfxxdNTy0D6qYkhcZMBCycw4YE4Nz48Kc8JGEYwwF
   sS2KM2ybj4AjKFQDonxNRakXzQ1vHHgN6syz66zetwjBso5WWgoltIc+E
   Sgwscw41OunnGBS4G6fDF/aDfIx5K4Fy08S/xPS2uc3yacbaync/E1WIe
   DSyy9yWdjjwgLi3YWIJES/2O5/7NMX0rF4xmxtyvNlIPr+tzPpaOfjl2M
   o+pjgb1j7mvRptPWyoDgQ5NZFjc3nMJ+lcsJ1Nj1Ja62p5srpgO/RC6y1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="320267047"
X-IronPort-AV: E=Sophos;i="5.96,251,1665471600"; 
   d="scan'208";a="320267047"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 17:37:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="895456943"
X-IronPort-AV: E=Sophos;i="5.96,251,1665471600"; 
   d="scan'208";a="895456943"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 16 Dec 2022 17:37:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 16 Dec 2022 17:37:04 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 16 Dec 2022 17:37:04 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 16 Dec 2022 17:37:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B6oBhOUiUjLWXNHZC4WiQvZo5h9w2REyp8OLJHHuChbA5fFWNDgm2MVaeCzVvmUKc46JV8LVdYoG99miBickw3AO+am7Vr/E8bODVCEwlBOeq/39YLEut0qGyewqIu1r3bejqdGqVHbFh7/3+5Yf3O+6+wfGy8JzhVmY/P2OrbcuE/QYMFDQuQKzJwE9iX7a4fDLDhEAy8jVHMm/kTJJa6VaJmr26+sAj/DgvmRWEv3MuZzgel8q1H0f+VBCk4yxOk5z009+Y9Yrp3t5WIB09kQKUPwIqfiz3TSANNmiypOnyJAFz+Okmx0DcIfjG5K4bJo1CQC3A6hBMzDgDm3udg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C6unTszqstyHpmtHteEMQhS67hge2hnseHay+f+AQU0=;
 b=WeMXJ81MiQttTagFXu9f7pRPvFSGtlMyNjW6FdBzxNq9S5B/G6Wjc59xpR6JaN/PDkHoUyQUGjmUOoy4hG4wESmzL+a63jeRjWvgtVUfIUNKmvY/sR+Z/oGdqObLmnuwWQIXEerAYO+U1xEkczUWb89vZpaMIVMgkB9XGAF3BTJvvQLEtXfCISCHfGOL2RLQ1MPowLZMuc5Z/yELZS1fkUd0o/1iubvUhEQRZ6DkEqMLTZOCBi+ii+LuV/yc1ScIQ7x3e6+v4jlzfEQTulaIkZYwmRlLc9LXHoIT2KmB+gkal4v/4j3noUTgn7oyt6sy7khXsXk6U/V6kWBNZJWnvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CO1PR11MB4916.namprd11.prod.outlook.com
 (2603:10b6:303:9c::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sat, 17 Dec
 2022 01:37:01 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5924.011; Sat, 17 Dec 2022
 01:37:01 +0000
Date: Fri, 16 Dec 2022 17:36:59 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, <linux-cxl@vger.kernel.org>
CC: <vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<nvdimm@lists.linux.dev>
Subject: RE: [ndctl PATCH v2 07/18] cxl/list: Add parent_dport attribute to
 port listings
Message-ID: <639d1d3bc99a_b41e32948@dwillia2-xfh.jf.intel.com.notmuch>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
 <167053491908.582963.7783814693644991382.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <167053491908.582963.7783814693644991382.stgit@dwillia2-xfh.jf.intel.com>
X-ClientProxiedBy: SJ0PR05CA0115.namprd05.prod.outlook.com
 (2603:10b6:a03:334::30) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|CO1PR11MB4916:EE_
X-MS-Office365-Filtering-Correlation-Id: 704cd5ae-7605-4c63-68fc-08dadfcf31b1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2L5pmdcZ85jwlkNvZpVyyHM3r99F2tj8QqXQ6JXbtAuUaPtjEnCy5hHB8IKH5dHJVnxcsYdGXxU0gLFGj7fNtPK0qeYfQH2WsHjZp/oJjstFm92GH8xpU0KykKEPiFwjt7Hyr8CdcadLaBAm/F5Jn8Z4qsY7Ct4lw2r42/Z8BwiZI0opH0uVGVZJ+Jogxt0mH0sZlz6Ob/ThbpQO1zI8xF8koiyqYbVICOwrSqYAVtNZm8rtzBXwJmsWjXJPYNyyq9ZCalBttoc8uHayHYBKupt+KuV/C85Pw95v8l1M+LtAujr64imY4ba4wvK32fAq77yQNzixeUo5X0pk4VIPua8doR7vFUwC1Q2ASyTlUnpvPPP9tI3lZ/GF8QHevhPwNgVv+3JDCSQLFUu30S4NkH4A2H9UxvYomWAMgrZx5PUdu1omjYVEDGjJLK8cUzsKqExXzFmk4z9D/KZTtKCcbIyi4Z8t1Q0TroLryDly87bVe6kljGXC7NsxB+dHq3Z3+HRlyUDiYwABgprNWQTNo4d1fH6OnZyeaiPIHIvCPjdiyJZQOWSYkesAx33fOp/kZG7X0CzSi6Wktgk6xS4QeqDKLokG8fLqA55Qlg9SOnnZJwdEqYE7nebO0ktbFuNeMwcxJfXfcOIlKOxC7sp9bW/gszb6T8E16ETz6bSiWYc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(396003)(376002)(346002)(451199015)(86362001)(478600001)(316002)(966005)(6486002)(4744005)(4326008)(66476007)(8676002)(66556008)(66946007)(5660300002)(41300700001)(8936002)(2906002)(38100700002)(82960400001)(9686003)(6506007)(6512007)(186003)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sGuFSLmNurLbXdUtUKdjTjmDpsdP5NNiGkjaeTQZLg5cIObmhER63IrldpR7?=
 =?us-ascii?Q?0vFYcDnhhB+1BMZhjfvUB+ewUinuOWIakqtTML/GVTLb+Nl2vnqJ57oj1PC0?=
 =?us-ascii?Q?XhWhW1WRykcBzBkbq3DNgH6SgnuJ4H49Z42byeK2ART0sdWVxoZY+qoeIYwy?=
 =?us-ascii?Q?HMf5bBRAdCOlM9hWhdos/g+rxCxffzedoWM0hmYnTes96ACxywlz50ykhFYv?=
 =?us-ascii?Q?nky0GdsL9eWMJkw7szYuyVV8iu7BwRd8HhSgowAK2zA4AEz+3UmPnycz8LCJ?=
 =?us-ascii?Q?QqBKCasPiyyYPKMdnYKsuc5YfkkhdtR3Kb7pMMuiMrruVagg/+gzvlbd46xy?=
 =?us-ascii?Q?+Dws2+o+0SmvwFAg06Jr6u2ufET508W8BUZIj3OWtRK4E0mNrzGZ/1UTtVY2?=
 =?us-ascii?Q?bPIqH9QR5wJ2pXRqocmmR4nVFsDEAGU204RiA5z5eBMZ4vqwikqm4vkWSLbh?=
 =?us-ascii?Q?8ZWVzdCES8AvEc1tpvnD0x+yT0rqphkyIILOcc4RI3XTaXdhRt6tDZxspFUx?=
 =?us-ascii?Q?+moSx7JlHIQehVYNOoJRXa9g0OjQxr67xRprQmIvQhVXpJ/r87wdDSsQ3RdC?=
 =?us-ascii?Q?pcQNqw/PiT5KvJsQlS//YS4jIzPN/QBqSMSvFm2E89iFKVoy4kCtSS8u+91l?=
 =?us-ascii?Q?ePhdsjyLvaMFRncWmihoLQhmLn38iavEKHFJ3wyQYHKmLlHKAblw+lRZsm2H?=
 =?us-ascii?Q?auXK37U5MZ8a3LvBUwxnNHtJVyUj6EGLHI2pBdswu4hvJXOu3Jz7G2UfI3JS?=
 =?us-ascii?Q?Rs7/EjbMYElFWKp6tjrVI00V3fjilMHpvQn/lRjjc2Laaj8DcxRu7grnc/qC?=
 =?us-ascii?Q?FODRFSScDbJdjo7Q5+sf0i583N89UZhAYDS/VhLOekX6FU6q3lrQj1VCIw8I?=
 =?us-ascii?Q?3bLuk1YSd2aMri4xWct9FATx2C1TZwGpIk3Iej/LW+3LLjXeHoJhmuYqi/VK?=
 =?us-ascii?Q?wYHp5SWQj1fVztBE4d/Pzd0b9wZYc2GEHMctBUKk4yVv3M9KSFUDQJ+5zE/P?=
 =?us-ascii?Q?qQrCs8a68Ha/e5CxPmsibbIQIJ1u1VdiaSBNAy9mF8IKETVHVrH7d3yvK99w?=
 =?us-ascii?Q?WNbPh6R5KiwVD07QGJ3CSJ9ZfOtwbLB7yfWlsXbd4lDopvmHedNJGtvmP010?=
 =?us-ascii?Q?mAMmq6qaEOHDThbW8dKe72ekda5uVFx0YWbq9ixsGcPuvXXfLVu6BEDe1xfN?=
 =?us-ascii?Q?gqKcjI/r1bHfzLKgcIA0NzOAtIci4v9boxackasD0nj+Grbx6FOc+WlZXbeO?=
 =?us-ascii?Q?cb5oxEAUvp8EIP8+BU43QDKfjs5fvetFjiONmIabUMbmhpDAaByflJu418EM?=
 =?us-ascii?Q?uDAEgLpMKvEEXJMh6lmee3r6Nj7mgeEuq94nmi/uKsFWTL4FQoowaEa1j1wE?=
 =?us-ascii?Q?lbBfUStv7T2hQ+dtMcS3fQJ0DLXJ6etQCsCpzt8RD1xtL4giDYaHO+6NQmox?=
 =?us-ascii?Q?DaAUGSDPfVmQvTJtCCH62Q4d4RKCNX4aEceOLxJ3B3ES8IVWeuUQY/n6SuU1?=
 =?us-ascii?Q?WYIJIQCpVHpeNF1CuBhgMA1T+mLzmIt8aWnukKl3LZTnrWtb9ShQd5k9xnXy?=
 =?us-ascii?Q?CC7MKkctCl67C85KL+eVtHHQ2q1rBvJMMvB1gThWwOUGH6lH8yx6NquSeKPB?=
 =?us-ascii?Q?dg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 704cd5ae-7605-4c63-68fc-08dadfcf31b1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2022 01:37:01.3780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lw9eea69H9SFPSLhk3KE756nVkjvlZJ2ixSZ34t8iTnqtIHKh63PNpQAhfKQTELiziZwHNSUYtoBeey/mYDzbz6MYYYKzM1DBwuii4TpP9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4916
X-OriginatorOrg: intel.com

Dan Williams wrote:
> 
> ---
>  cxl/json.c         |    8 ++++++++
>  cxl/lib/libcxl.c   |   38 ++++++++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym |    1 +
>  cxl/lib/private.h  |    2 ++
>  cxl/libcxl.h       |    1 +
>  5 files changed, 50 insertions(+)

I should not have sent this out. It was sitting in my development tree
for other work, but should have been held back until the kernel support
landed.

Drop this for now as the kernel support will not arrive until v6.3:

http://lore.kernel.org/r/167124082375.1626103.6047000000121298560.stgit@dwillia2-xfh.jf.intel.com
