Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF51C63D2
	for <nvdimm@lists.linux.dev>; Fri,  9 Dec 2022 18:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670609174; x=1702145174;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zizsUwsa/xUZ3I8vQgmE7uTyY49lePeL2818Dm2LgjA=;
  b=Q/cMwVxcc65UVGIyWbsNlpb/cZrz7GxnXWfXbMW9k45pVHAcO2JjjJph
   v2fFXPXxnSAJOpScZKulQj4WJSGGtOGOMCKgCRe1mPtAzBnDzNt1EzKag
   PQ56TG6DExdQeHDeiruDXY9M9eZ/6apgh+nifzIVWNUQpRoJ1Y5Kfldo1
   Yttcs/hO6atq7+83t7n8Zn0+SFiznqDLSlh7wLt0aJbWt0alodITzFGIP
   3ORUqzDVXrK0OCYMAh9B8LXF6kAWiD/nkKwaGUcNaSmbMqgrtCxr/H+X5
   vlUs+U9ZHUcxvnsOnBhAAHDg5HlliRndFB7gdJYiUTKBqMz68gTJRW2KX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="403771719"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="403771719"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 10:06:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="821803991"
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="821803991"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 09 Dec 2022 10:06:13 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 9 Dec 2022 10:06:13 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 9 Dec 2022 10:06:12 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 9 Dec 2022 10:06:12 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 9 Dec 2022 10:06:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fh0A1c/Kc0kIshLbrUDmj7PWGKtpavzQQUk7qkkOnklYMYm6oAc8Ys+IXzfo4oLN1Q16EtdIc8bmPJOcydDGY+a/Mw4jFGQcirrTZAOUZYgpJIxOHkIVMxAmU/fm/ey1dHFx6uyv5K8wimw3x4BOY2GHmVhIn9bQJN+avAElMDSvx3FhKY9p9JuBpEw+E/QDhtVYqKDgTdxgzQCdbocVwBH3tp0vK5tw16/EsZrvpDzCdYl161wWZeHjbha4qPi7aYK+Ivv2jRl881hPyoZ+8gCRnEBezlSWiWUn4sSFd6K6t8G7D+5eAvvBvzEko8+NQnNocFKXTnfJMgj6137qiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0yVVrdhiMPIRT8S6yV91E3iEeTtsbloP4b4ij3AzhA=;
 b=dGo5s9zyobRufl/we1F+GsBgzSOTxZ899ORxqYtbcNOdm1/zZf34+qHshkpXv89hOZ6J3zccrKFBNYKJ0pib8fRdLNWo7E23wfD7ucfhxYFg+dAchcs5/lVGJpi+Tv1yvB/Rd/b9O1gCBGhtTG6CUyYRm9dUhZIe4kf1td3sUbH9dKhid3NODoNVDlxTOH7az0oWMMHx5VFBmaNjfxPaWKqwv8IwlmBjZduqI7C07fZ/euA91f8B5miS6BAgZXvPyBgw8t4uIjaE0yBD9TGSOwAlOMrviqAmz5fi7bx1GA0wO93Naqky8PgMoPxzkLZr7CMNoJ2sntvN6iD//KKFog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SA1PR11MB5779.namprd11.prod.outlook.com
 (2603:10b6:806:232::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Fri, 9 Dec
 2022 18:06:10 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.019; Fri, 9 Dec 2022
 18:06:09 +0000
Date: Fri, 9 Dec 2022 10:06:07 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <vishal.l.verma@intel.com>,
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v2 15/18] cxl/Documentation: Fix whitespace typos
 in create-region man page
Message-ID: <6393790f8bc12_579c129434@dwillia2-xfh.jf.intel.com.notmuch>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
 <167053496662.582963.12739035781728195815.stgit@dwillia2-xfh.jf.intel.com>
 <Y5NxYqD7Bgo2nT0W@aschofie-mobl2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y5NxYqD7Bgo2nT0W@aschofie-mobl2>
X-ClientProxiedBy: BYAPR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::40) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|SA1PR11MB5779:EE_
X-MS-Office365-Filtering-Correlation-Id: 53732001-7a80-44c1-dddf-08dada100cb5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MpBaMs784gdHTaUzlllmGNOhf3Ekg9pp+jlxh69Z17hjIfPfiKsGhWhtfVBxi7O1vDteiRWztcBXy/EtZTHK5OdNe7F+A2YL98iD4GdjOWa5/jYy751F9zV4XAYW702F5Z1SQowty7Yse+R4aE7umtfrim7ig4Qa7/+EYNtFEspabDIDwZ0UWPpBMkGMaUNQfMk73m76LGs4PHAk30OY98FwxaQUMx7teNIT7jLUngITqC8X2347Bfcv8j4rbbwpvcbvKDJGB35y9xf0WJy0i/R22D4bfcpCCKoMIO3nnns9aTz/iIj5lNjVkuzqiCKIPC12tYfsAwDHPvpDaBz2J50WyanSzNKnJ8G3NdJK6cFdwwy2WYFu5SO9EbPfIRKxxIbC+2+3yE9nkTBvHn8348KUhWT+IPcJEKHc14ahAgYVDq/f9jlcv1MmQRblpKhAKPmPn02usrqQUlP5X7V/p1iS92IrsgRHw8FJK+hS3IyysCtf5S4rjOPy5oCUmVGkxz1CTj2z1Xgw2/h9ldmQsz6kPeCpgQ2qeWA/5gy4f0PVqKsKtswkFaeJ/ptfm92bsXnYcAnalfrXDrHiXb8wImEmoLTsif2y398HhyCVzFTaqHmoTRbMIeKNFsP7GZBpkoWOIZDfxoCmLv8Kw4bbGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(376002)(366004)(136003)(451199015)(478600001)(86362001)(6506007)(6486002)(66476007)(316002)(66556008)(2906002)(82960400001)(8936002)(8676002)(41300700001)(110136005)(4326008)(66946007)(9686003)(6512007)(26005)(4744005)(38100700002)(5660300002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M2lhUyiQeB9aSwZMjmha05K4MYvq5GX91ZuV2ZDHEhLHfC1VQxPSDDMxw3nc?=
 =?us-ascii?Q?QSdqOEfliLha6qu5Yu8xgiAEQ7PTePr/Ok6TZ/OMrOVEKOdwaQ+Ek1oELcXF?=
 =?us-ascii?Q?bmqOERMEnWxgExLqY7f9nzq9w/0HSwZdUM6xlZIXYeHB00CKjaEvIYeg7ij+?=
 =?us-ascii?Q?4jN6EgoYhrARZdGHh4lMPyDD9b55Qhk5nyfNIsrSBhMhUKuBN8GuAwr4au2L?=
 =?us-ascii?Q?m0jYrdjzGKXP9GzTzfB4LkFgMGaklR03vQaPpXImnYeAgnS6taaL8igO5W/f?=
 =?us-ascii?Q?2Z35Ne5/U9dd3pqknTpVTTYEjR0GvzpN07aOlzw9XyByoMyGK5KVhSaWTW6y?=
 =?us-ascii?Q?Huz94bumrfFW+p3Jh8sajcaf8+AcimNL4WSzUJGnDbRW+sUyo5xZossfowg5?=
 =?us-ascii?Q?E4TSzo64Ryfo+y4QFJ37KNJlGlzMSnF0zWD922eGAHZnOExWtbmTtuL3KCZi?=
 =?us-ascii?Q?MMbHEkiQgfqouRMgvEeNSniy/o/ilmBQLb7bmVVgmt94CE9nWBiKcWNsWwFb?=
 =?us-ascii?Q?qhl7Sx6U8oTxhK2rmGuIAwmLo7Lg2q3dKQ5iUV6k6F3deqcaPz0pKT+K5vfN?=
 =?us-ascii?Q?HyQbDoKQVFl6yHgIBLLWBUqYNK7ciYdpGfI6mwEAw+W3GGlCQhI0yX0BHHzQ?=
 =?us-ascii?Q?l9AWcEG8k4vJd4/1+Th+S/xH5y6aOglNa0erHBr5QJvjM+gkM2GP7nEbY8IY?=
 =?us-ascii?Q?HT25xiVxg9sHCqp+5i8l09IdlsIIVwMSR8wLHZcz9tSFTCG0TN134SBwrWSf?=
 =?us-ascii?Q?nyKvJOgq/s9g7Hm1+vnecv1BRR6PBM7Soi6wOfoz+be9Ec9aGNl47iS5I8M1?=
 =?us-ascii?Q?CLw+tVdxOMUNHD+BsiKOtf5olHJSEnOJnJNfwtoBZqoKJumiZ5yKRwSNZb7r?=
 =?us-ascii?Q?Y6jfPoo1hzQ0Atl6XrJ4Kwf/hCvGWtfBY+wDtfZYOaJzrsLcCNzsaccgOJ1r?=
 =?us-ascii?Q?bnYwPSxOEMFq7LgVX4J6nSyhwdpFTGZrSyQusdXpPS1ic7vqF/GbbWa0dMKc?=
 =?us-ascii?Q?HI5M9iMswnKu9Zpvdfylzs8xAR8O4clP5Q2hGSiqy5wXh4NRW+v/x26krLOn?=
 =?us-ascii?Q?z/kpiIMYHBh0VEry9qSahRxZ/chaV06mlbSFJbpfqdVTTer7EX0QHDu7rMnr?=
 =?us-ascii?Q?u5Pvw3wfMCZ5fMcFU6tDZCyMz7EoBa+IWmB2yo07uMesApJm1ozotXQJbMWI?=
 =?us-ascii?Q?Yt/hARSyD3yMOnsoCKI2CW6TuSuQYpnIT+dGUoFHDP2PCVh6nvQyMDErsQeY?=
 =?us-ascii?Q?sx4U2/upINgQpANBw2d8DJPeYLHlquMb1B4HgteGkp5YrFQjT2i2fejD+drH?=
 =?us-ascii?Q?b7p1IDY8Ezh5Thd8MifjHZ7ZAw1yTlyw0L179ixPhv/CPB6IQtGZBbDxi74f?=
 =?us-ascii?Q?F+D3p0F2JNBN3suvosijk86s6v/8Ip2xNnzvH+divvBBHgb5RZEEElFJggep?=
 =?us-ascii?Q?XV3UJ/xx3GogJT8NMIP/+RIXfRXlCODj/Iw5YVJnR9sF8ngKNtpRBR43ARSz?=
 =?us-ascii?Q?D7hs+cuu2td7i1hxGhGAfD7EmwsI8QCF2cXebyeQ5VnBiGT4EFiE9fJn4fk8?=
 =?us-ascii?Q?WFrOGcSRDRy25lgr2QExiiiwf6KLSJvN/T42WdPlfyD3tlDWsTHO7YlIb8CO?=
 =?us-ascii?Q?oA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53732001-7a80-44c1-dddf-08dada100cb5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 18:06:09.5798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7IZGxDvD/hE3CuzJ0kbg/NNA8kViV/k1HYbSIo3LISx8ZDG8/Ckpe+qJn4X6PLeLTNWZ1AobvkTfTjAaDw6s7POXhQPSs2DLmGRVN3GWuH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5779
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Thu, Dec 08, 2022 at 01:29:26PM -0800, Dan Williams wrote:
> 
> Missing SOB and commit log

Whoops, moved too fast and broke things.

Vishal, feel free to add:

---
The 'create-region' man page had some typos when it was first created.
Clean them up per syntax expectations.

Fixes: 21b089025178 ("cxl: add a 'create-region' command")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

...or let me know if you want a resend.
