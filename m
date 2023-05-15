Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121EA19518
	for <nvdimm@lists.linux.dev>; Mon, 15 May 2023 23:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684194843; x=1715730843;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=i41oN5Eti+rEVOQ6NvLStnAHEfvMAIvifVgYKqxzKYA=;
  b=CBBQsIL98CHVEsSz/oDTHTUiBABn9dpmcFkkZQqLx0EurGrXPO40qTZR
   p8Cqz9fj7sdVvrRD/743AkBR6U9J9dWePjm98JQVR9EU7fkXASVpLYpIM
   ehDVnZpcMmbiA0bzoSpdlQtOClRj2ju2qOOJCIxtJ7vq3/vutTeU6/R+Y
   XC/u287//Qdf0pd1w+KR4xMMKJ4LvsVgdkutbuJ2Ny528LZOsaCqbjODa
   RoR9F2u7gWorwuZPUjAwQf10nq+BdZkzIkNv5loesekwGmAH14F8tR3tt
   O77L6LPQmtDfhyacagw6z47XoZ3Kou70ycO4Qsr3azR7GVULDvqjcJe9M
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="331700475"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="331700475"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 16:54:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="770792882"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="770792882"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 15 May 2023 16:54:02 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 16:54:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 16:54:01 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 16:54:01 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 16:54:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfPqQfC08KEZynuiz6qiPe6EYbrxcseW31wteN7RBWvesb1WE7biY8M8uEo0So21Hiv36Wx6Axq559/Jz4V35ijbjfSFXXTtStF66qVIHF64TI1gGf+uiipR2Rg0iE4GTxTzWxJjQv9yeLddl/UxhMkvESM5xcwwzh5ERXX8ECRKcGYZG22NddheYHcxbfePcvZFh48z7LxEIA69IthScbdxbowcxRUvUjSIMRkjDqIXXKuvsBsUAiCyGDIeMU0LaEBxe/JwdcYDJcRzMFNlK0fnM1a9o2VOFs/kl3KRJOUp+tYY3xuNvTjnMve7JPZMJlkKkd82IdhIzii2+DJyzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=izuKPHErM4ZzN9CBKFAIqUN8i5SXvLs3ybINUNq4xw0=;
 b=bRxG24virohb37KFjG/xqFSv+tUOUSa/f/Fmjd8PDlT3GnNbZTmadMNQnCZFonHlUSRBdqDr1IXKOzvrVDdmDvjqHC6dS5K/yOMM2ZB+gSbjLE6ujN6D5mZKaBOzEVL49/FJ1W3pO6alcG7qRg5qBr7107n79Bf+cKfVbCLmKpF9uNYts64GgdYP4y9KcwEMxzlzCK2vkVH3bGn+UoYSh2diskbZTU08+nupEh+QAucQJgc2CjyBJ9nZ2A9RCjmxe9uDPuABssktzmbeTenP6UrskA2WiZ/bjvy1s3yYhiOcfAw2k8mxNy0gzLWKFL5DE0j3e2kk/7We/yvLr8zgEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB6769.namprd11.prod.outlook.com (2603:10b6:510:1af::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 23:53:54 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::95c6:c77e:733b:eee5]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::95c6:c77e:733b:eee5%7]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 23:53:54 +0000
Date: Mon, 15 May 2023 16:53:51 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Jane Chu <jane.chu@oracle.com>, Chaitanya Kulkarni <kch@nvidia.com>,
	<dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>
Subject: Re: [PATCH 1/1] pmem: allow user to set QUEUE_FLAG_NOWAIT
Message-ID: <6462c60f66188_163ae2948e@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230512104302.8527-1-kch@nvidia.com>
 <20230512104302.8527-2-kch@nvidia.com>
 <7d36645c-892d-33b1-18d9-73be5369a791@oracle.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7d36645c-892d-33b1-18d9-73be5369a791@oracle.com>
X-ClientProxiedBy: BYAPR05CA0086.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::27) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB6769:EE_
X-MS-Office365-Filtering-Correlation-Id: 29c64234-5eaf-4f0c-6dd5-08db559fa385
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /1QPubEmg2+mE5Qd7VVt6EYDzJ0J1rTSgDnunptmCbvf3Z80hlWlY8IVkfOTr2gymhuar8TAOKWk4OeFMgLdZovL6GjJaHvgWvCVisGieuChii+JVB+iGJIX1i+Ggd3dJciUkPAx0B5TbOYOe/BMPERVqe/lfnX1UhHIGMF5zkTk6CJUMK9Y2JvMugyN9oDn8Wdlz00TtSVrKbBXcGSLs27TnCxDCK/xHyx4zMjfOH967vR9+nFVTTObi+8pFUdh8oq16oMrDsPAzuIGuOikrViPi9THDY7TMxPay/og8MQIBwpmh8rJ0KUeqqjBc3N3kK0Yzd58WrxRmlEA6nKRQfgNGrzI4CSzAH+M4lg/JTonhCvtfqlr9XM2GGAR/nkfDu1rLF2kZFxCQQY8VsD3J1Btb0/hWtHZRzDBYpdzKYcLIID4UgQ4CBJcI8SiAtlf2N5hpu1UUh6hBpvkd6PCzQOH/d3lyi5J3oZ11VF+Nj7gEduvsNCxHa6iw0TuqD79wKW3+/k7rhbv9TYilbTG738w9AnP+R0CQEYfjYN9XPaimB4utCuWAokjl+oVK8WB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(396003)(39860400002)(376002)(451199021)(83380400001)(6636002)(66476007)(66946007)(9686003)(6486002)(6512007)(6506007)(26005)(66556008)(478600001)(86362001)(110136005)(6666004)(186003)(8676002)(8936002)(5660300002)(2906002)(4744005)(41300700001)(4326008)(316002)(82960400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R0Z/EUPG/XZuZT+QpooKA8Ex3tj0D2CdzK5Toek6qKDpuiehKlxdQOu3TaGm?=
 =?us-ascii?Q?NIGrcpPu7zTKp0XGLFuLF4cdWasa76MJZhjLaC2CMjxt5+rYzEEQdevmoWbv?=
 =?us-ascii?Q?ZTeIVr4EwgP9wNFKd5le4B/oIOwK7kMlVQeav8BudCTR6xHDxwTJIOcXjfJg?=
 =?us-ascii?Q?k2/poCewAHTzcSXw8ubUJp8mD7r3opsXO1DHfLoezc7g6H4eHw4iW5Sqx72w?=
 =?us-ascii?Q?/J+lg6u1GAWackfBKMp06BdJdLlbRH57bNwhV75QAbcL9s/K6+JdnMj8PZrj?=
 =?us-ascii?Q?KmT/QnwDrc4R683amtwZTK2L/wiK1lYuhSz1YP80VHyZnmVE0QhlcMapMKcf?=
 =?us-ascii?Q?f6KgRBbZykNxr/CxbPYCwydE465MvWvjsiqUHPe80KcxAMjqfNwocOD7Cq32?=
 =?us-ascii?Q?1j5a0+17glhbbEegXf9Pz5GgP4DCb14cBTNUTr0Bnq0esV7HkFUXjpcfMokf?=
 =?us-ascii?Q?Tn6gMTBDHxLeFixbMkUPzq/RL+PkKrlM7fDidUsProHBUtx/Qe7JGj9QHgGx?=
 =?us-ascii?Q?evCWWHtRdLHRWrbV2omJEj9ahtXkd8lc+aVdAfmYwm9k6HGtYvYZMKnv0PDz?=
 =?us-ascii?Q?x1uP/dVyUY0LzRLvJXSFjkS43925NOdYRfrdVrFnqL5i9PeQb+QuRi6R1kQx?=
 =?us-ascii?Q?TOdbvhRhif3zTSgBYi3RXdyH9iroPR7+HoCIUKy+iO7NOVVwklpE8cP3mi2j?=
 =?us-ascii?Q?dy/v1R67OErkLPxEUY2QHlFs18NkAxwJCZtDMLd3dKynqWlgk5Kf1zj19Uth?=
 =?us-ascii?Q?UbpAlHQeF5ik/hMmLqfewJf3RDQN/PVWReSnULqPYs/9MhH3/7ty09/Pndqn?=
 =?us-ascii?Q?0Ox1fm5AaQQVF0M2lyQZpqFkRCckVLTDY+rKyMZ57uXWkJQJqNVUB3R3av5q?=
 =?us-ascii?Q?3+Enq5vVLeplANWalI3sofwDX0pWiLII6KbUbaVWoXyILQw8p/5LeTkFoPe4?=
 =?us-ascii?Q?myOMJ1/O4Pk0G3KkzZyfAH9noEtPL/F+TrnWhDeRN4WJi2fKrVX6H8HpBLHJ?=
 =?us-ascii?Q?LqX3amXqdtSGeAk1GMOi0961s1InNfM5XPgJmXU5pEl4S85s1m7hLDj0oImy?=
 =?us-ascii?Q?K0odrWKPGy8mfj3IAz76JLLopIAhCiYprF6UkHtbPqggmwO+j1RCkBPx+Sak?=
 =?us-ascii?Q?MVGvaS56ypewx0L0E+kmzExBY7dtkDwJfjkc/aLACzn1jHwWihbsipMlKdU9?=
 =?us-ascii?Q?VFl55UsygQAfgCM0YWAR1Fx+CH/tPsUfuZ23kfs3SSMj9hoW9+vJkeaIn+qv?=
 =?us-ascii?Q?CTowtwcGmKHkXQzRxVchFnSrYny+Cm3b1hA4xsO3HZ4PleRY8Lx5zCZ1p6v/?=
 =?us-ascii?Q?f4uMpYSUNEBsrJnLyEIGdEaB+DI0mRWyVj0GLYZPI9hwxgSW+TMmfA+UXh4y?=
 =?us-ascii?Q?9x9TgSIBhKtDtBzP3l5U/Cnue7Ty+KXslctWscntNN639bdEfFyuI5DwJ3Eu?=
 =?us-ascii?Q?/YKlz4HDBlSU99YnjTBi7ZcmoVWAFoIA0znxlVFms6oIA8GYXptjAMLW2wLp?=
 =?us-ascii?Q?PGRFils/Rb9UCTkiggkm0Z9VsRMnfRR6oJjPZpCxArLCXgcN4ilVkYq2vZkJ?=
 =?us-ascii?Q?QFkMXicRWmgVxbBdFjvvCWoRuJv6suSXuRRUBHkwQbkyr+Ea+pcFucnaN5R8?=
 =?us-ascii?Q?ZA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 29c64234-5eaf-4f0c-6dd5-08db559fa385
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 23:53:53.7852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o44XnFMlwl8JS5S0G+al9+eYpHLZqMJFsxzJ+PG+/GK0Ut+LhFtTbRCif/9ha/jD5qT5Bw4qbBuEkSx6a9YHgC5mt7izxfafRTqzY3zRies=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6769
X-OriginatorOrg: intel.com

Jane Chu wrote:
> Hi,
> 
> Does it make sense to mark this patch a candidate for stable branch?

These numbers:

> * linux-block (for-next) # grep slat  pmem*fio | column -t
> nowait-off-1.fio:  slat  (nsec):  min=431,   max=50423k,  avg=9424.06
> nowait-off-2.fio:  slat  (nsec):  min=420,   max=35992k,  avg=9193.94
> nowait-off-3.fio:  slat  (nsec):  min=430,   max=40737k,  avg=9244.24
> 
> nowait-on-1.fio:   slat  (nsec):  min=1232,  max=40098k,  avg=7518.60
> nowait-on-2.fio:   slat  (nsec):  min=1303,  max=52107k,  avg=7423.37
> nowait-on-3.fio:   slat  (nsec):  min=1123,  max=40193k,  avg=7409.08

Show there is a potential for a regression for min latency. So I would
like to see this patch upstream and shipping for a while before flagging
it for backport.
