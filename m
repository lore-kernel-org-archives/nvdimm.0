Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2075.outbound.protection.outlook.com [40.107.7.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA648637
	for <nvdimm@lists.linux.dev>; Tue, 26 Sep 2023 01:46:31 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5PSpHL5E6m/rNtre8zIwBL0VPYJ07aXEWu4L/tXkssCEWIgT0AeMKWt8IdoVPW2gwUZY3BS4sHHSKEOtyWfJOI0mG5GOYPuzcpeDmn57u2cuJzv1JeYPu1UHUVDCnDqfgeGrvq1FApM+6y7KzCrBWyEKSE+zH8fq3mow8GxQlqhrnHQOd4dnBd41XuVdiWrz5G7i4J3dLDtr4fCtaOS2AL6OmEV1pmAfo7ZzNsreI6WKIuX0IX2BQsyRYKncvobyjbj/QropH3RmvXfxELg+Hmoqje+wZONIe2vEKkRXO7/vFDPh5zLnI4ruau3EobH+Y3qZKuzTq6X2MCbZ4MDsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6PK5bDpsYaXXxSeFUo3q1zbpGJ+97n1EefIPD070yMk=;
 b=NcW/RT6ECGG45p6M7OuZa+vjGMe/abFR5gGCRbHEsjjfw0giTy70KdhbR9D62tbPnf3YqwVayB74q9RxkJhsPkyWw0m412++/ew7RCvLVctQC/QWMg6Iky4WKRDlm4w1xXDjy3IxH946bc0ybeKQGdUKo+dY+5Vber213Mh4JMaYXZV5qy0oVlk1V3iwlxOFiVJR6hECcWNUT5y6qoji+QkZbUw89H6GbcKtbkDSR6LGGJIl8NHQlEFSv5Cg2ju1p7OW8TMgWB35m31OtyVLRY3TYZh7f9XLFlq36z1hyMuq26R1gO+OOVjScEZjO051gvwZFlXPvEEQcZoWIN0zGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6PK5bDpsYaXXxSeFUo3q1zbpGJ+97n1EefIPD070yMk=;
 b=c+l0eEIr7cm89PoUAw4/jKotKO7hdTxDvbEdipmqBSFPolP1FzzAbY5lRqnFLsosLucd2xKmMDS10bUqyaQCTAWoy0xJcvUvn/8m90qR3nP2pvcacGsNHRZNLZoQg3lON2qUlx/T1yXJhPUVuL/rWTeeK6OjfT9WJRqIKdqeQ3vT/no2c2tEB8YGYIT3guaphLtil/LTW3NfBZZcdQvMiXFJX9h7vbJgpvKfW1RV5gIlbIjHuoxLxTsbTZPqTk4zFDQXF22zk8NeWH/R7MZ0YHNe8ZwNfefM8DaU//FWM/CZWA1HJ2OvWwBHFpJTs1WhjIFPc+bE884biSbMMJaN+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
 by AM7PR04MB7176.eurprd04.prod.outlook.com (2603:10a6:20b:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Tue, 26 Sep
 2023 01:46:28 +0000
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::2867:7a72:20ac:5f71]) by HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::2867:7a72:20ac:5f71%3]) with mapi id 15.20.6813.027; Tue, 26 Sep 2023
 01:46:27 +0000
Date: Tue, 26 Sep 2023 09:47:19 +0800
From: Geliang Tang <geliang.tang@suse.com>
To: Coly Li <colyli@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
	Richard Fan <richard.fan@suse.com>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	Wols Lists <antlists@youngman.org.uk>, Xiao Ni <xni@redhat.com>,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v7 0/6] badblocks improvement for multiple bad block
 ranges
Message-ID: <20230926014719.GA5275@localhost>
References: <20230811170513.2300-1-colyli@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230811170513.2300-1-colyli@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: SI1PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::10) To HE1PR0402MB3497.eurprd04.prod.outlook.com
 (2603:10a6:7:83::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3497:EE_|AM7PR04MB7176:EE_
X-MS-Office365-Filtering-Correlation-Id: 3da4e727-eec9-45b9-378a-08dbbe326634
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CbSCAz4Qb4h7NMwBUKXx82qV9o+wfDHjCXK2Y64HCZW1kxsjkftEBtmPmNaZh/wSxJGrSCYwWeolXiq7XgMwP570Qd3auShDwcuLGOqYuTlp2Zc+jDasooEkze0GNV21+2rilNqCj/YD7uioBkGkeD8uGe8E21tZnNqYz/fnpppCFP+8Ep8iYq++/FrFo0ZewpgVEgFRhUHRG0hqLGpDWiAP80e+uR7sxo2qYdJL236jE1f/g1JhgijxO0Bnlx33sWt1/2AMw/Ph2gpAope3/ieu/SJe2N8v2X/Xzo4T0bDeqiCp3m5rYLk0HIE54fbz8hveOCLdgBTbi2ojQJZtcXRWbW6Zy06cB2auA2RtdlGxA+dYhiRtcAvd3HjU3duXP/CEqc024EcrA7RcUrH7hYoqxDxgVxu8II4vh4o+6V2EDh6gj1LqqFlUYD0vaLCCuvw9BNpN5p0Jsdbe2A/NUR3TbofMC7yCoLUmsKR4dxMi8XQ9isdWdyCZ5+fH0WMWbpm0UPzaFr9fZUIk+d923x0i6B/GJC9tfZnsGM1fYdO3syHl7cIjJSosTVm58Q73
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB3497.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(396003)(136003)(346002)(366004)(376002)(230922051799003)(186009)(451199024)(1800799009)(1076003)(83380400001)(5660300002)(8936002)(4326008)(44832011)(8676002)(6486002)(6506007)(9686003)(6512007)(26005)(478600001)(38100700002)(54906003)(6666004)(41300700001)(316002)(66556008)(66946007)(86362001)(66476007)(6916009)(7416002)(2906002)(33716001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?imu9rnouCpyeKopKGhXVg8/KdUeUnu7xJGXUN82Alz/1pQJmVkxdI8ssrJcR?=
 =?us-ascii?Q?5es5wtzBdqj7FntuaRKRvsD7WyNzyXDSGFYMJZrOEooSSi8Ys16f/24sUlsB?=
 =?us-ascii?Q?Udhk7Wcnn/hVax1cG+xDHDUwkcQh7CFBOYNxnTiwLMTPnYkVuN7izQdsXwVA?=
 =?us-ascii?Q?PBreqTzSJ29DifKFujcX0EK3brevHYNOqh3R10ILeUE7+E6Zg2OzKR7kCJ2w?=
 =?us-ascii?Q?oYoiMPBIEmbRab88wNSHtRlhg3LP3+e/1OrpJQI94yVCLJfyZRgOR4csZut0?=
 =?us-ascii?Q?YEJUnFT37IRZrPsjkowzDKwdtCYJX4KUG6vXfmF7OEmQz7xSQd+2uMjRsm5G?=
 =?us-ascii?Q?LCHieYOlreWpaHqMA8XxeX/KLN3ZKxbcB6keABoNpuIkNgT3gnz2R0M6VyKl?=
 =?us-ascii?Q?7wyypxRg8KC2Yay/Va6N3MR2gbs6wJZd4TreBW1vVyKmyB60tqM4mAdR9DO6?=
 =?us-ascii?Q?dseb/AVpZ563CwJ75RbyEGWZ+6m/GqgClQmo8N8eptL94mckx/pctbczh3VW?=
 =?us-ascii?Q?3BNR094cPl6NMvz1Gh99AZvvQXjOpXwLelCfUcxaqaaatIA49OKFaJ/HNrS3?=
 =?us-ascii?Q?DbTPraeukJ8rWGTUHt1NDpGutmZ3vp/D7cHtNvtXCOKodb5NE+ll3YWD6zgC?=
 =?us-ascii?Q?MVIXprKYddShbHrJv7SpwlEVlnMUhlDo6eCmF1wEkD++cGYF1UceovyyyuZN?=
 =?us-ascii?Q?HE6Kl90ckxSIddeHPBctE0gCpqYaz4tRIDTuymuKonVmzAm+F31eShYnLhoB?=
 =?us-ascii?Q?QqiPTyMwEP/mIf/NeAYYZ8L+w3/qrDsilP3dhpqPZHAVm/4VasFKXfPu01C7?=
 =?us-ascii?Q?yyZMnw63v451Gy9uS+A52we3D5LX+DqoLbLYGzAtLy/9zn+zx7nNKLLtWzS7?=
 =?us-ascii?Q?BppNiOKvTh42gdWllYE516cFR71KJC/lqo9tfAUSip2sZ7bTrsFvrCtj1v/t?=
 =?us-ascii?Q?9OU6SEdFGppIwl/uXy+ZCPGBkTwpRziGSF/nwtPAqd4QxOiIqvSFANnOSLaI?=
 =?us-ascii?Q?4os+k/6eKRs5ft2t3oPMAupVQJe8n2uqbCmZXHrdah0yzznD58pd5ck2Ybd8?=
 =?us-ascii?Q?q7wUmGuGUdN5HXIXruI+81nVl/7N2NpdsbkWJodjV/gf6DSu1jtv1zzTzyKm?=
 =?us-ascii?Q?TE0bNmqS5iqV+yBw43zBgV34ZoAgXIZI0EFUEY0aQ1i9v84umOM44DJT/Sgz?=
 =?us-ascii?Q?S+9AnvHLga2YbiZ2mP3CAo2DbEl4fNkNcaBxxfFrL/lK+T0SivuoB7NbPJuX?=
 =?us-ascii?Q?GnRokdf+psA48QwC+qgqgFrLMe4GYSqPpPk0RrG33KZVwbP1jzHPyW7f6FQ6?=
 =?us-ascii?Q?ZSpmI+qzrZv/SEV1qambqWkSInXh4aBBzhUr9FQ1HevmEONETugulWbFUxyj?=
 =?us-ascii?Q?tz/CRVFpRaWm77CuzT0P6YP11eNpcEAa/gjL66jMqo0KiqgqpOztXVsjg52T?=
 =?us-ascii?Q?zsJjpZpdFKcre5Sv9SbsbH7bxU9xpRfMVYHSG9G0yARnb0X8z30TaHmpnrXc?=
 =?us-ascii?Q?5PbK7dAAvGH2wukNLpiFCEMpHOPte1GYiKYYvRI8CNEVpykaZ2hc2Qw20QGm?=
 =?us-ascii?Q?UYwAcF7qQGB9pU5HS9lWwoCPc/EyTjnURQVRtXvF?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3da4e727-eec9-45b9-378a-08dbbe326634
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB3497.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 01:46:27.7467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j966831MrER+KghqBKoCD+XLYFpowffL7ix9q8tMcuvXxgd9NudfE5mFp++hEVe9q/83iY4sfNYV/G51dzwy1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7176

On Sat, Aug 12, 2023 at 01:05:06AM +0800, Coly Li wrote:
> This is the v7 version of the badblocks improvement series, which makes
> badblocks APIs to handle multiple ranges in bad block table.
> 
> The change comparing to previous v6 version is the modifications
> enlightened by the code review comments from Xiao Ni,
> - Typo fixes in code comments and commit logs.
> - Tiny but useful optimzation in prev_badblocks(), front_overwrite(),
>   _badblocks_clear().
> 
> There is NO in-memory or on-disk format change in the whole series, all
> existing API and data structures are consistent. This series just only
> improve the code algorithm to handle more corner cases, the interfaces
> are same and consistency to all existing callers (md raid and nvdimm
> drivers).
> 
> The original motivation of the change is from the requirement from our
> customer, that current badblocks routines don't handle multiple ranges.
> For example if the bad block setting range covers multiple ranges from
> bad block table, only the first two bad block ranges merged and rested
> ranges are intact. The expected behavior should be all the covered
> ranges to be handled.
> 
> All the patches are tested by modified user space code and the code
> logic works as expected. The modified user space testing code is
> provided in the last patch, which is not listed in the cover letter. The
> testing code is an example how the improved code is tested.
> 
> The whole change is divided into 6 patches to make the code review more
> clear and easier. If people prefer, I'd like to post a single large
> patch finally after the code review accomplished.
> 
> Please review the code and response. Thank you all in advance.
> 
> Coly Li
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Geliang Tang <geliang.tang@suse.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Richard Fan <richard.fan@suse.com>
> Cc: Vishal L Verma <vishal.l.verma@intel.com>
> Cc: Wols Lists <antlists@youngman.org.uk>
> Cc: Xiao Ni <xni@redhat.com>

This series LGTM, thanks Coly.

Acked-by: Geliang Tang <geliang.tang@suse.com>

> ---
> 
> Coly Li (6):
>   badblocks: add more helper structure and routines in badblocks.h
>   badblocks: add helper routines for badblock ranges handling
>   badblocks: improve badblocks_set() for multiple ranges handling
>   badblocks: improve badblocks_clear() for multiple ranges handling
>   badblocks: improve badblocks_check() for multiple ranges handling
>   badblocks: switch to the improved badblock handling code
> 
>  block/badblocks.c         | 1618 ++++++++++++++++++++++++++++++-------
>  include/linux/badblocks.h |   30 +
>  2 files changed, 1354 insertions(+), 294 deletions(-)
> 
> -- 
> 2.35.3
> 
