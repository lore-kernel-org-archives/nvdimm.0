Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EF63C1E
	for <nvdimm@lists.linux.dev>; Fri,  1 Jul 2022 16:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656692670; x=1688228670;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5k9snhEFiyeYGrHcBl5PyaXG5f1ofXUOU6C0YrfRgpY=;
  b=Dy8rT5vsYPp0Mk+HzBGXEWAUXVfADwcMzIv5EpY7pN/sSNCu9LCiN3Eb
   +AP1VopEkhuA09pH03wd+zg+UeaIb0sDDohlyGLx+oYA8ClBHJmZgJqyt
   CSVWPMnKO7GqqXbtNQByU60Xe2fQ6zf8N2TtvLjPUWXHCy8ZW8XsYZMRK
   Bhrz8XExzKA+riVqbw+iCYJKVDc+vByymZHth5nUUQXsV5VZDePYJ1Lwm
   5KAQYyRV5UX3Ty5o00mHZaW4wCyzk+jnR8jJ5bGhObn6m7af0jJDTUo8M
   5Y19GwR4JkL5+aLvOMR6+aTerldepoyN9xtDSMuZCySqFV5R+azBXgTeI
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10395"; a="281450910"
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="281450910"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 09:23:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="648404452"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 01 Jul 2022 09:23:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Jul 2022 09:23:55 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 1 Jul 2022 09:23:54 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 1 Jul 2022 09:23:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mxe3ZnoY0h6jNjdl+7ewznlPJeRs2upPw1EFA9/mN5d/T+DHmjd/g3/F5jNc/T+0lnlfqLmTCA+d+nxjQVfUIDH1b3UIfpkIQPXAJwN1zlqRSM+uY5Vccvxr5/U5eR8aQrl8J/lKkhPAx3E+zldP6q58lOMqLDktn7xDYSCXGbNxNCZNKPfOKT4QZgHmETw4Jk7u+Y5Bzo1wdVODubsXzcVsXXaL9B7ssyFXqYfl1XqmI2osZFvvGcw48gZgzfRQ1ye0oxGClLCmDJd4JGgyWC5DoHJrwBd6o004WTxWISutfVdr2lAJaxk9Xyxcrrl48iWlVlDKK+7qc6j8xbKtlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xmdq0oM0KomXg5kPXQ/QG9bIHmuHLIMvTxfq3LkdQLk=;
 b=ZiiiiEcMdvcKB1qKplHbhsHNkxehJqo5qMqzu0CbHnk8sbRfu+1yzVuHVvUEBQa9jMfatR6qulXRjaG8TMnujAzVaRva/u6lI7jNhKkOa2F3vNzdKyK8ygQCAUGd9gCAqjqzcSnMxEpdOxju1uUzCrYsYRCHkHNxIE/+4tg0Fiw/FMkdSsY4+1YJY91I0mxDPfhhbqO1ymVvlBJKNcnr9fqJa+xprXHKxoLBpV6eQdpCQBPKzkZ7jStCtnLDKB5rfmtEg2TfaFOUFEEsqQo7HdSNaKyZTal6c4iGUTSRgJ31MXWHrxgM1XvSrMaCS2Ccheux//XeA8vYnpZ67E/4cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6311.namprd11.prod.outlook.com (2603:10b6:8:a6::21) by
 DM6PR11MB2874.namprd11.prod.outlook.com (2603:10b6:5:c9::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.18; Fri, 1 Jul 2022 16:23:52 +0000
Received: from DM4PR11MB6311.namprd11.prod.outlook.com
 ([fe80::e912:6a38:4502:f207]) by DM4PR11MB6311.namprd11.prod.outlook.com
 ([fe80::e912:6a38:4502:f207%5]) with mapi id 15.20.5395.014; Fri, 1 Jul 2022
 16:23:52 +0000
Date: Fri, 1 Jul 2022 09:23:44 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: dennis.wu <dennis.wu@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>
Subject: Re: [PATCH] nvdimm: Add NVDIMM_NO_DEEPFLUSH flag to control btt data
 deepflush
Message-ID: <Yr8fkG0TeSNxB7QU@iweiny-desk3>
References: <20220629135801.192821-1-dennis.wu@intel.com>
 <Yr4kcIC/GaAdfm8V@iweiny-desk3>
 <ffb9a464-1055-2c74-89b7-c00505a1d957@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ffb9a464-1055-2c74-89b7-c00505a1d957@intel.com>
X-ClientProxiedBy: BY3PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:a03:254::11) To DM4PR11MB6311.namprd11.prod.outlook.com
 (2603:10b6:8:a6::21)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5404b50e-95f1-4b80-b5ab-08da5b7e1632
X-MS-TrafficTypeDiagnostic: DM6PR11MB2874:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S+W9s0wScDZv9kyAB9HkIsUtqwpKFvoofiHvA53AxXPx6Q68AUxpfXkX2kUSfulm7B0oesGF0+6LD7ICSNyHP6f1K4oIJzO5RYm2/qZf0G0M5dUJ+1E/kWpLso4YCoQicyQ1C1UTi7NEfx8MKs91yqbESdg1N66exp9IUcCL2fos+dfkO0z6QTO9UoXphnKCq1OJUWMdFS8bbWcieBTTuv26LuNQG3b3Iv+T71lVngkksuo9+l897WMrKH/fuznZL+o85lyXlvEnpRLDL0JnIucYxSDGD9dNdQ0pZBg1q07uL+Fk58q+i2Mf88aWdIFTpoMe4MxDvL/QgZmUTqjavZh2u/DvvHzdLc6oV2k7TRFZUwwdHgU+XkrsY1CsA6Og6bSm9MKwJ2EclWJT2jhEUgAwBGIiVUKDgW4u24DjttWi4i76CbIfcQ5O3cNTAYWxjxbzIoHROAg6hOWh2+o/lJhp5NnLz30tIIVUBzv7GTp2IKAbSSOP5NDfOQqI5PiaXLeoFbFqmt7UTl9OZ1kQ6d1K7DqNjQHtKYKGwVdtcftGcZSjQH07FB6eHyo4ahcKsM9y7rN/lmU9zcr26P8gZiDK9oPbJbCGmlHL3xc9EEOZYgnHbK4MQG7ebR1exByBx0l8kW/4TNS2hWmmPNqP8w4m5m6MyYD96zO8kX6rhFYajLSiZVx3tN17Oxsaz84kg4PH7X39cXUHH+w7Em4bLoWRGWHDSNRrIvrz8BGz9z+MuK9Pzs/P5VWFMZeRE+8b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6311.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(346002)(376002)(366004)(39860400002)(396003)(107886003)(66476007)(66556008)(38100700002)(8676002)(4326008)(33716001)(66946007)(86362001)(6666004)(186003)(8936002)(2906002)(5660300002)(82960400001)(83380400001)(44832011)(53546011)(6506007)(478600001)(6862004)(9686003)(6636002)(316002)(6486002)(6512007)(41300700001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QNlgdnZYMKOyZID8G3VgtWJCbiYqcOto7MoUZ272VNoq7SuKqVAn/VisFi1T?=
 =?us-ascii?Q?Bh/Th9uMUWKmSZLhCknRMGNvdYwUiBgJn8II+XEYZZzFnWDSywjwcRzMLgF8?=
 =?us-ascii?Q?f6nVt+iDVOl4gM6VrOw22sg9hh3hnv79ldPFRe1RhKHBv1ij2aGg0mdLrx9E?=
 =?us-ascii?Q?kO8PcnmLSJ+Q+0ufCv+HJ2hPaJDMmP2dp9OdfVvh5Lc/p4c8Tm79XKc4nNdg?=
 =?us-ascii?Q?z8kT82aTBkaC0brd1yceQT+1HbvEKF/j80yCvpWIbrjoh89fS59vU76tP89f?=
 =?us-ascii?Q?begLeGhUxjdBz2GaCGSu9zT9m6BYKGxsfWdevwLbx0osNWirUlmXxNk/wtXX?=
 =?us-ascii?Q?pbnGW7eQzg/RrRrf2VYSGdZRSbMj6VCj/GcCm85EBsOzufglkIu6wAzM1mQQ?=
 =?us-ascii?Q?jWsjwWcihchfJ7s1AHlO7yOQebMmb4BuglB0PNEzmV6t2lDshNHH0YRP5HAw?=
 =?us-ascii?Q?V5QlB2+VejPOxzFJO6qKZEJR5UpSzKI20DLhRGRBie8btn9TSutUqo+uN74X?=
 =?us-ascii?Q?KQilflHaTb8WByWClvb0IWGlQ4HoV2/7KzvB5ldLOxMvR1YU8cLCSA2cRy9t?=
 =?us-ascii?Q?QQuxZoSkDqVWC40qGRe9Iw9/vi2eWAJTRQ86Hg7VTIPNbyIsydJqiSTDn6Ut?=
 =?us-ascii?Q?aDKZn4XrL4S/Jb7OySUYrqdkd/Q2177Cyzi1ulyoufoxQOcr3rzK56oTqNHW?=
 =?us-ascii?Q?FitkKry9mNAsUTctW5Av3fEBQ8/YouiOXajiyw8SESFNL4ze8xHFnZoicTCn?=
 =?us-ascii?Q?HFkkAzucwNB4xt0zT/MObUWgSzaDhaHjKaIh/zLw98uUPGKQxFtstUJKf1y1?=
 =?us-ascii?Q?KytikYUO9OOls9sXLpxtphU2XFDTcluPfVIrwLpHrfWfx6qM8ZlniQ+WoCGy?=
 =?us-ascii?Q?LxNXTLjmaJ3myE2HbckW1O8tGvadddGXxcmLMNVx517+BRg2OKWS9XynsTze?=
 =?us-ascii?Q?I5yqVfhxEfnPLcrZYe3JfcHREsYMtIeHsX/A9By8dzoZBG4DpKfqD3WfuHdp?=
 =?us-ascii?Q?b+Ua+PoOpxYMlvbwEipj1xjKqdNE++7lL0nakf3AdhmyZLKVRoi/SHeQhq+b?=
 =?us-ascii?Q?YdVRRucGvMTeP/7W/4E8c3r8VzrAb/DYteFK/xxgDBXoxZf7yWJ/OmhC9KJE?=
 =?us-ascii?Q?q25ZiQGmyZJl1BP9EwO0Vn2xJn5Hwg/ajT7h6YDHrlsAzzAj4s42P48iWs0N?=
 =?us-ascii?Q?6NDIc+4Dqv00Z8H3H9b2+0JgvQ6Ij94GJCRBG4sAHbCdkMpSoR9uB9irPidH?=
 =?us-ascii?Q?mIFtv/p/xi/kYZvvkOlWBH5G3qOGRVtEXoXiWZNdBy5WdwObss7ZVMBuG9wK?=
 =?us-ascii?Q?iJ1NQE36JzNhZHtCFmarGJV+jWIVkxDK7YMPci0w36KvvxHrRoXVdo2G0Ohs?=
 =?us-ascii?Q?WLGuyp9gMrgS94RrAoyi2i9e8+YzvLhQPL8R5wyB/sSJRH6SpbwtmC/x6rV+?=
 =?us-ascii?Q?5nRcdDS7gZLbXGAU78UleJnTArZiqlKCl5ewruJWWSQBUn7+5tPvzIGZUaI+?=
 =?us-ascii?Q?Aaigp1RvxDVykNpL56kW1XFEO6iFwEOkjpHErRnpEFRCEFxEEcntNGQ89cZA?=
 =?us-ascii?Q?FQmICp57p7v3uH7sDGRcmkjOkdmtbdwFvWFvkg4E6/MWYgY4qrcnTw7L5y9y?=
 =?us-ascii?Q?fECqST3RmqoOb8muhohp3iaPiV38Bk0pqZ0aZtAkhGT+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5404b50e-95f1-4b80-b5ab-08da5b7e1632
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6311.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 16:23:52.4493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U1jGDH9gC6toBMHZt6k3rsD4W3bUjhwQUkw3cN/hctWN2tgr8dan5v4RVVjqzJMOWiOjAfoVNy9rYOMrYcyl7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2874
X-OriginatorOrg: intel.com

On Fri, Jul 01, 2022 at 12:38:16PM +0800, dennis.wu wrote:
> Thank you Ira! Sorry for duplicating the patch.

It's ok we all make mistakes.

> 
> The first patch is made on the kernel v5.17 and can't patch with the latest
> Linux master and the second one is made with the Linux master.

However, this should have indicated V2 with the changelog updated below the
'---' that V2 was required due to the original being on the wrong base.

That will help us reviewers to know that the previous one is not valid and to
spend our time reviewing this new version.  lore will also pick up the correct
version when Dan trys to merge the patch.

Hope this makes sense!  :-D

Ira

> 
> On 7/1/22 06:32, Weiny, Ira wrote:
> > On Wed, Jun 29, 2022 at 09:58:01PM +0800, Dennis.Wu wrote:
> > > Reason: we can have a global control of deepflush in the nfit module
> > > by "no_deepflush" param. In the case of "no_deepflush=0", we still
> > > need control data deepflush or not by the NVDIMM_NO_DEEPFLUSH flag.
> > > In the BTT, the btt information block(btt_sb) will use deepflush.
> > > Other like the data blocks(512B or 4KB),4 bytes btt_map and 16 bytes
> > > bflog will not use the deepflush. so that, during the runtime, no
> > > deepflush will be called in the BTT.
> > > 
> > > How: Add flag NVDIMM_NO_DEEPFLUSH which can use with NVDIMM_IO_ATOMIC
> > > like NVDIMM_NO_DEEPFLUSH | NVDIMM_IO_ATOMIC.
> > > "if (!(flags & NVDIMM_NO_DEEPFLUSH))", nvdimm_flush() will be called,
> > > otherwise, the pmem_wmb() called to fense all previous write.
> > > 
> > This looks like the same patch you sent earlier?  Did it change?  Is this a V2?
> > 
> > Ira
> > 
> > > Signed-off-by: Dennis.Wu <dennis.wu@intel.com>
> > > ---
> > >   drivers/nvdimm/btt.c   | 26 +++++++++++++++++---------
> > >   drivers/nvdimm/claim.c |  9 +++++++--
> > >   drivers/nvdimm/nd.h    |  4 ++++
> > >   3 files changed, 28 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> > > index 9613e54c7a67..c71ba7a1edd0 100644
> > > --- a/drivers/nvdimm/btt.c
> > > +++ b/drivers/nvdimm/btt.c
> > > @@ -70,6 +70,10 @@ static int btt_info_write(struct arena_info *arena, struct btt_sb *super)
> > >   	dev_WARN_ONCE(to_dev(arena), !IS_ALIGNED(arena->info2off, 512),
> > >   		"arena->info2off: %#llx is unaligned\n", arena->info2off);
> > > +	/*
> > > +	 * btt_sb is critial information and need proper write
> > > +	 * nvdimm_flush will be called (deepflush)
> > > +	 */
> > >   	ret = arena_write_bytes(arena, arena->info2off, super,
> > >   			sizeof(struct btt_sb), 0);
> > >   	if (ret)
> > > @@ -384,7 +388,8 @@ static int btt_flog_write(struct arena_info *arena, u32 lane, u32 sub,
> > >   {
> > >   	int ret;
> > > -	ret = __btt_log_write(arena, lane, sub, ent, NVDIMM_IO_ATOMIC);
> > > +	ret = __btt_log_write(arena, lane, sub, ent,
> > > +		NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
> > >   	if (ret)
> > >   		return ret;
> > > @@ -429,7 +434,7 @@ static int btt_map_init(struct arena_info *arena)
> > >   		dev_WARN_ONCE(to_dev(arena), size < 512,
> > >   			"chunk size: %#zx is unaligned\n", size);
> > >   		ret = arena_write_bytes(arena, arena->mapoff + offset, zerobuf,
> > > -				size, 0);
> > > +				size, NVDIMM_NO_DEEPFLUSH);
> > >   		if (ret)
> > >   			goto free;
> > > @@ -473,7 +478,7 @@ static int btt_log_init(struct arena_info *arena)
> > >   		dev_WARN_ONCE(to_dev(arena), size < 512,
> > >   			"chunk size: %#zx is unaligned\n", size);
> > >   		ret = arena_write_bytes(arena, arena->logoff + offset, zerobuf,
> > > -				size, 0);
> > > +				size, NVDIMM_NO_DEEPFLUSH);
> > >   		if (ret)
> > >   			goto free;
> > > @@ -487,7 +492,7 @@ static int btt_log_init(struct arena_info *arena)
> > >   		ent.old_map = cpu_to_le32(arena->external_nlba + i);
> > >   		ent.new_map = cpu_to_le32(arena->external_nlba + i);
> > >   		ent.seq = cpu_to_le32(LOG_SEQ_INIT);
> > > -		ret = __btt_log_write(arena, i, 0, &ent, 0);
> > > +		ret = __btt_log_write(arena, i, 0, &ent, NVDIMM_NO_DEEPFLUSH);
> > >   		if (ret)
> > >   			goto free;
> > >   	}
> > > @@ -518,7 +523,7 @@ static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
> > >   			unsigned long chunk = min(len, PAGE_SIZE);
> > >   			ret = arena_write_bytes(arena, nsoff, zero_page,
> > > -				chunk, 0);
> > > +				chunk, NVDIMM_NO_DEEPFLUSH);
> > >   			if (ret)
> > >   				break;
> > >   			len -= chunk;
> > > @@ -592,7 +597,8 @@ static int btt_freelist_init(struct arena_info *arena)
> > >   			 * to complete the map write. So fix up the map.
> > >   			 */
> > >   			ret = btt_map_write(arena, le32_to_cpu(log_new.lba),
> > > -					le32_to_cpu(log_new.new_map), 0, 0, 0);
> > > +					le32_to_cpu(log_new.new_map), 0, 0,
> > > +					NVDIMM_NO_DEEPFLUSH);
> > >   			if (ret)
> > >   				return ret;
> > >   		}
> > > @@ -1123,7 +1129,8 @@ static int btt_data_write(struct arena_info *arena, u32 lba,
> > >   	u64 nsoff = to_namespace_offset(arena, lba);
> > >   	void *mem = kmap_atomic(page);
> > > -	ret = arena_write_bytes(arena, nsoff, mem + off, len, NVDIMM_IO_ATOMIC);
> > > +	ret = arena_write_bytes(arena, nsoff, mem + off, len,
> > > +		NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
> > >   	kunmap_atomic(mem);
> > >   	return ret;
> > > @@ -1260,7 +1267,8 @@ static int btt_read_pg(struct btt *btt, struct bio_integrity_payload *bip,
> > >   		ret = btt_data_read(arena, page, off, postmap, cur_len);
> > >   		if (ret) {
> > >   			/* Media error - set the e_flag */
> > > -			if (btt_map_write(arena, premap, postmap, 0, 1, NVDIMM_IO_ATOMIC))
> > > +			if (btt_map_write(arena, premap, postmap, 0, 1,
> > > +				NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH))
> > >   				dev_warn_ratelimited(to_dev(arena),
> > >   					"Error persistently tracking bad blocks at %#x\n",
> > >   					premap);
> > > @@ -1393,7 +1401,7 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
> > >   			goto out_map;
> > >   		ret = btt_map_write(arena, premap, new_postmap, 0, 0,
> > > -			NVDIMM_IO_ATOMIC);
> > > +			NVDIMM_IO_ATOMIC|NVDIMM_NO_DEEPFLUSH);
> > >   		if (ret)
> > >   			goto out_map;
> > > diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
> > > index 030dbde6b088..c1fa3291c063 100644
> > > --- a/drivers/nvdimm/claim.c
> > > +++ b/drivers/nvdimm/claim.c
> > > @@ -294,9 +294,14 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
> > >   	}
> > >   	memcpy_flushcache(nsio->addr + offset, buf, size);
> > > -	ret = nvdimm_flush(to_nd_region(ndns->dev.parent), NULL);
> > > -	if (ret)
> > > +	if (!(flags & NVDIMM_NO_DEEPFLUSH)) {
> > > +		ret = nvdimm_flush(to_nd_region(ndns->dev.parent), NULL);
> > > +		if (ret)
> > > +			rc = ret;
> > > +	} else {
> > >   		rc = ret;
> > > +		pmem_wmb();
> > > +	}
> > >   	return rc;
> > >   }
> > > diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> > > index ec5219680092..a16e259a8cff 100644
> > > --- a/drivers/nvdimm/nd.h
> > > +++ b/drivers/nvdimm/nd.h
> > > @@ -22,7 +22,11 @@ enum {
> > >   	 */
> > >   	ND_MAX_LANES = 256,
> > >   	INT_LBASIZE_ALIGNMENT = 64,
> > > +	/*
> > > +	 * NVDIMM_IO_ATOMIC | NVDIMM_NO_DEEPFLUSH is support.
> > > +	 */
> > >   	NVDIMM_IO_ATOMIC = 1,
> > > +	NVDIMM_NO_DEEPFLUSH = 2,
> > >   };
> > >   struct nvdimm_drvdata {
> > > -- 
> > > 2.27.0
> > > 
