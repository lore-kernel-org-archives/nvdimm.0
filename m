Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DC215AC
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 01:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657674635; x=1689210635;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5kBzHl30lFyyvuedLyiwV0dXsaaYJJ0Dp6b4XIF5hhE=;
  b=P4OxQzPge01h3ipZSg/GD6UWpXiA+fiq3XUckxXE6E25F79n7N1yXXQs
   2Z0BPjdZZj07aV6SjCeJdUdIE//oTP8m/HzV8eujyDpEl9/knXCttACfj
   zijF6a3MoI9IA20QsigI3KKr81f80TQEHB+hMZNqf8KOc/cQ16mKAwGC4
   boErXR31r0BVyNiD/EYVRzIH4Tqd7Sxk4KXNWH81sHYxHCYm9ui/stuFM
   s3Zll3gD7OxY/Gevt2uNl9xgHc+kH0aL4xmcraHD7eTmJM4w0G8/qrJIM
   p4uCmkUz5oNTkFJlDvOR5Lmi6N48o1s9ea2G8Pwl7p1wYqx3rH3s3Ryzi
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="349053178"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="349053178"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 18:10:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="570410568"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga006.jf.intel.com with ESMTP; 12 Jul 2022 18:10:30 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Jul 2022 18:10:30 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Jul 2022 18:10:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 12 Jul 2022 18:10:29 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 12 Jul 2022 18:10:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fpAmKLLuhi065WHfOTd/VFEi9DzCIC8zAc5vcTR5BUr26cvrd8uxUc1Vz2l0KIn9t7PEs2PbkAAwFE7ShrY/cgXaqE+KbrnnUQfG+u5yFQo53yk6J9pHWAQ1yUhVsB59woBmhEZSGOYpgUqEvl0mTC/P+g3mpfzt5+00fjEFMSQoflg9PIFsAiP9It4+iNy3gE83Njnn/fcO3cRkTSitk8jnB+1spDlE4PtcSoHW/HLS+9gFcyoTWrUU5nI4hZSQBqTBZxnqfW0k5V/ULHj95O4sGu8iKTFp+RU2MO+ey3t5iAXx4QrvD+NREH2Md4ALn+kQ5g+LRthnsdmus0V5Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5kBzHl30lFyyvuedLyiwV0dXsaaYJJ0Dp6b4XIF5hhE=;
 b=hJIBI/sMcU4OvkhnyUxqbYKi2Ti4pixcxepbs0DKaT3pVj5pNcihjqV+aaHXkZ9z4dyznTF+Za8rLaCLLCytovqSgYmKgndwJ3s5Boqo4JjexsvAsu9cEG1Fk4G6xvsNOZxugYag7GwaPHg3NaJec4MP1Qt21oBuIXcgPX1C+Ifv3MVwy9k+iP4+vg9qfvZCSyu/JMmeb1mxX2O6WPxwJl/BBRNeOITeHCQiExm1bXI27sU5mabesWM9e6z8lR+jppn4KDjZTycabDLTlwxvoAf/RS9OHfCTeudKTQ+Rop1vB6taG2mYGNeu6wd8Uk77EflzkW6LTS+QPPnGXFysuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM4PR11MB5472.namprd11.prod.outlook.com
 (2603:10b6:5:39e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Wed, 13 Jul
 2022 01:10:28 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5417.026; Wed, 13 Jul
 2022 01:10:28 +0000
Date: Tue, 12 Jul 2022 18:10:25 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Dennis.Wu <dennis.wu@intel.com>, <nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>, Dennis.Wu
	<dennis.wu@intel.com>
Subject: RE: [PATCH] nvdimm: Add NVDIMM_NO_DEEPFLUSH flag to control btt data
 deepflush
Message-ID: <62ce1b81a1607_6070c2944a@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220629135801.192821-1-dennis.wu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220629135801.192821-1-dennis.wu@intel.com>
X-ClientProxiedBy: SJ0PR03CA0199.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::24) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a26f26f-a509-4476-7d13-08da646c7939
X-MS-TrafficTypeDiagnostic: DM4PR11MB5472:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2GqT+2P/Dqjt8JvNd/69combgwKqUQ/jqERSXt7MjD6uYSSvkZ7NsQvaZtZ499HNOYCxNoihF30DmIRCVXUBd1CttwMwCzHHz8oIDWiW+Rk4kCpq9lywgx1ZTZNO/rALN2QHv9DwRF5v7wL3Yt2niIzFfIUs/bAoIxfwTBsc7ghG/ey/PTbSHDWwwmJL/hkkmRAFdk0tE5YAihOZjjtHbDacETlvIDAuDUwAIMOsTt65/zfFg3xbxCllLeTyMcdefYTweTBOp+0cP0d22C8zOqAk6ePnWi0IqqoB8SgVDhzr1LsJmaXpzuyugnH5DIQuKC58legHEznNvfp58tbXK5rWwq6lgGriCn7kgevwPxgBHkUsGVoc+83hxFarC/BCv6zg5poe/T+JmBetUuSO/j9tIzrJ2Mwf8EZq5nq2kwMsUALkX0LwXlZ+b3Lc1TK/QsuIlJ0D+5J6k8aHT7q1reLLq7rCMsu9+QQigr6JSnqaZ/4kgdSxWtoEUG6P6M6oo0neD50b3RMnqcdFngvDRMU3KyA9LGX1yEkc3xkjVZ907KN4NBnjUhf47qOmUBTQ2nHwUNcmvas0f/UA2vvt9c0K5+5IwwURTXf94aunqXPdo+7WqtB9boDAYHfuwMhBgbCexpysn7ENogyAPlfOL5RoPMFj0dLM/ivw/WgrZnhJ2e7Qv/XspsRB9V4nMOyQgPPcA8bbVUt7/+LxWSLh04Plyjp+IsQ7tOo/qCe4W7MPaIGY+TBwqv8BzrA+6d7IGErBRwHAq5OdjPYR2hK5ww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(366004)(136003)(39860400002)(346002)(2906002)(4744005)(38100700002)(8936002)(316002)(86362001)(5660300002)(9686003)(4326008)(8676002)(66946007)(66476007)(83380400001)(66556008)(107886003)(41300700001)(6512007)(6506007)(6486002)(82960400001)(6666004)(478600001)(186003)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O9H2QAHVyooURJmBOJJoXukeKJD31/tNElo7N9xxijiMaX6gg8N2SsS7es5j?=
 =?us-ascii?Q?rqWgb83yTYRGmBmq4POsJkpNnupTv6gKDlKnFJRRO1TmlVgqtv/Ds9ZF0rYC?=
 =?us-ascii?Q?vFKpfU4caZKk80+lAZhdGSVrgrmDBhMKYoGTlx727PG04TZXvDif1UoKakH/?=
 =?us-ascii?Q?Suh+LLtjoG3hzgqJxzy0zjDoK2dYOK9e85r2IogOfFYoZ5kdmRR0LTrMLRQT?=
 =?us-ascii?Q?IvVXQ+/Tl7GlSOMa3+lLEDLQ1LVD/0XuN8rj6s2W4qyvEvEBH3LQTPAR1VFl?=
 =?us-ascii?Q?WBeHWwrHDgTRCD9+3C10XyopiIUl/RICI3wYeKULRBv2eQ2ihBe3mlT7aBrR?=
 =?us-ascii?Q?3bJ+JqmEZUZ8mr4d8TMfpMniDypyGkmxJQoENO7wuZx2lyy4PwzASOpebKZL?=
 =?us-ascii?Q?nq3YXeJv9GxVWziZZpimnqhaqmlEGckZtDXKwRjea7ONBgmr5r2wtyS8dwyM?=
 =?us-ascii?Q?e667VszrOk2A1IX3LVPZu77f1Gc8y8jm8vLnfQdDbhmY6TMH0yFHLKHT7ta0?=
 =?us-ascii?Q?QsJD1NTlGJx1CQxJgfIAQ+OG3h7NkncLnBB4/UZzqTTIJVwp8kNz+06g86yc?=
 =?us-ascii?Q?Xbw3oVOBJJSfH4k3JUSfNp9j8YyeCLzGs2zdMGC+dzCESoe3Hmdd90mRyCA2?=
 =?us-ascii?Q?yHyGOqQT6nbHMj2FW9/ulW2PBAowaQ0U2IfJ39oJ1y3vqND/lQfS8qy2OihY?=
 =?us-ascii?Q?rOXUMGF1xYgxEULp6R+z1lu0aUwZGIc9jSE/o6AbWQ/hQo6cDYXGrVyf50ku?=
 =?us-ascii?Q?noUkFD48wovFajfnGP2iu4E/JOllZPJZ5ArsftDfVEPnLJ9JUaMOseRORNth?=
 =?us-ascii?Q?fXS0H4CfBA7wWLLs0UXzjZ9bHu18ykOfwL7XDZ2YbCUZjKDuXcMO+IjsrQ8B?=
 =?us-ascii?Q?kq7/yBAF2iIiaVryXDC5fNYDMGe+fOuFX+eOXZ7JUAQ6O9UxHeIVJidWeXez?=
 =?us-ascii?Q?rnEeMSzCo3y9wvSzQbxwm2WUJaCeWbQVLkbA/A8cS5OH5CplABHJy7LplkWm?=
 =?us-ascii?Q?jUUNZ6gEi6xgepao93budNBPrmFuSb+FJRW5QiEfZ45420R0K6HAth09U5wr?=
 =?us-ascii?Q?Fv5UuDE68uHwTU1MRQtxkpX+anosOhk1pdjBL5Bjerjno7g9q8/krKXpUvdI?=
 =?us-ascii?Q?hSYQxNwR8+JHY5m4sXxwst444JRnb1MzWvNfaUwM2lk/RGGV8rCwQEywvhn9?=
 =?us-ascii?Q?Adk+gsLvYz742RwdX83LXcnC9fIWRqOaww4oe7bF3blkpYA6yZL042nQeYVB?=
 =?us-ascii?Q?RVvswt9LhVPIol9UOSeS0Eqa9a5c3ydBXWg1L1HrZbwHYyGo5OfYpHZWPoye?=
 =?us-ascii?Q?pNaiTdSWyLpzE6PD2B5sdEXMP6ypTW2J99Nw+sP/kHZy2RrbffmLgfGk4B1l?=
 =?us-ascii?Q?7NjN0fdL1xNHeCedGF0J0CCwp7CCDLbR8pU0XtRQJ6IDQMC4oFjnKeBj62Yo?=
 =?us-ascii?Q?J7tojynejYFXjwptXiT0gEV2q1gsH6JQCgoRxSNCFJ/jH7xMOBUJB7Pue5aL?=
 =?us-ascii?Q?7lEwV4sIAMnQmJ812gpEtfHPbubp1Q2S5CPLXQwLT5ILJ9wwxnxSvueIAO+Z?=
 =?us-ascii?Q?97NSyQvyfEyPxD8lPLM4/fiwtpPTTLs5U/rgPGHyv9v4gLrP0m7N1U+/c5mR?=
 =?us-ascii?Q?Cg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a26f26f-a509-4476-7d13-08da646c7939
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 01:10:28.1121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4XIajKkCu25ue6ytbLXzZ/Fv6KnysJzB5TgTAQP+2NTiMHZTee5d2UFlwe/ZRdgJNadKtGs0lkO/e55QccttrOV/PgHOs0cCqUp9irhINCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5472
X-OriginatorOrg: intel.com

Dennis.Wu wrote:
> Reason: we can have a global control of deepflush in the nfit module
> by "no_deepflush" param. In the case of "no_deepflush=0", we still
> need control data deepflush or not by the NVDIMM_NO_DEEPFLUSH flag.
> In the BTT, the btt information block(btt_sb) will use deepflush.
> Other like the data blocks(512B or 4KB),4 bytes btt_map and 16 bytes
> bflog will not use the deepflush. so that, during the runtime, no
> deepflush will be called in the BTT.

Why do you need this in the BTT driver when deepflush is disabled
globally for all regions?

ADR only applies at global visibility of stores, so the pmem_wmb() is
still necessary.
