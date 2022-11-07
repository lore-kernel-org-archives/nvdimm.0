Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DED915C99
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 23:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667864930; x=1699400930;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Hgk2eVnO4+Fs+YJnEVsNoivvlc5BE2n4b97iY4DlG0o=;
  b=Uw08mtjL4i/9MwvXN+V3iUAq7JVnY3Yw4kgSHk20zxpiMT84jX/TRXe1
   tMYMyh7oSeFJkmfK5v5GEqyFh+OEfkTcEqOVvMbwxVAwPvV9YtlBguGhH
   amOe8/8HjNAiYHfJHxtJuFo9mXdJQbKv07k+uBxIuEhH1R5+Iad8Ao4mn
   r+2srnR7sG8gNhw3RHS+8MOyBKHiIE9UOZBvQ/fDKviSqiidWdiGFzlA8
   8qPWrlyuAwE64JZ+rJ7DOSCtjXumjRQmLdKB1x2Wr7mrVQqZYG0ReOUNp
   z+XSjRwxqmRVNavOaNdmPmIWV/Nh8LkOXYQStjaEF7S2/MzODRpanYmhO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="312340103"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="312340103"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 15:48:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="811028064"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="811028064"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 07 Nov 2022 15:48:47 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 15:48:47 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 7 Nov 2022 15:48:47 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 7 Nov 2022 15:48:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6x6dziySq/tA7wBG+CgmsJ1T7h5MGeCL47C8uwT+jXfMVuaSjslZ41ctfKbaYZdzO2/X4RtHNQkjF1xuszlNMCaE3cvuYtryPOqqCPie9mxfpIXN+E6BedcRiyX5TGg/yYr89TNrKR5NSC++RCae/fz4UfgWh613ccg0NEndViFXxJuogn/NwAnQlzyg0hBP3ES6iNTx73wqS+L0NVDPsMvkkBoCl8gbbd7gRtwJZf17/9YaGoEkLVorLStjWAFrA0tLy7uaeLVgcCVJ4F8V3y+sNo/FBsROjtcIbjpqySROEHTp92lwYuJnNsiL0TGBb7++TbquOCUbDE0BVl4Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RtfrkMqVDFncIJe6UZnMI4UlkCqhbetgg5BaZaosBCg=;
 b=KBLkViRhIgDG3bPV1dPJowtxjR3zK1Y/x3dzh94fxCaCmSa5CxNHYPKm+6DABduYZ6EYyMXczoNccLpKyO1FLVVmiS0E0Ghxh1dwtAuPq5q7KWGjfBWHA9BKDUVvTNpZaKO3W5MhybNuZJWR8FfHB24MEsUWBDB3nL31lss95ANgYw+szm7fuTFXwavEKBfDTJmcOSMSLknbCh7HKzqvt6gidKuaIhKuGKanBqdZe/o6LMGNSmgK29xqGf0yQMnPBEsSoHZiPicK47Jris/YK95nnhHomlnP9jDVP70RIJzmurXHvWUwfsyel5JMn5z3NoBFD135li+0DqUaPpA2sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SJ0PR11MB5120.namprd11.prod.outlook.com
 (2603:10b6:a03:2d1::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 23:48:45 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::11a0:d0ce:bdd:33e3]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::11a0:d0ce:bdd:33e3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 23:48:45 +0000
Date: Mon, 7 Nov 2022 15:48:43 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 13/15] cxl/region: Default to memdev mode for
 create with no arguments
Message-ID: <6369995b14772_18432294f0@dwillia2-xfh.jf.intel.com.notmuch>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
 <166777848122.1238089.2150948506074701593.stgit@dwillia2-xfh.jf.intel.com>
 <Y2lsYawI3eQayact@aschofie-mobl2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y2lsYawI3eQayact@aschofie-mobl2>
X-ClientProxiedBy: SJ0PR05CA0046.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::21) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|SJ0PR11MB5120:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d4db7d3-93ad-425d-89ee-08dac11a9b8d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oITom1wPr9wta75smi7oW9Suqw9MEVpB/b7zO5gtEMdzo7jetDsyzeHMsymWpcgsbsj7Vpso86L7h4LI0Moz0FGVRtSZfRn37rAtC8s+Nu8U5CFahemVFLDAKxUkGnyyFamNf0t2gW/AuSSdjk79ddQUQ9x2Iy0G2BruZF+4gVQkEKXcASPGLICPh2vMIyB/MjO0PzWyfmIiQFlNKi8LiPDqXS66qsJb4r1J6dWCQRpDABqEE3kVCNIAKUn+ytjN2YaGx5El6ljLl67s2mXE2khMDdee3xni2JLSbLnNjJpGe5DztSdh5Xd5Wrt08ZBKcZdclEcOCcLdKWOE9oS+XufawcGAfxrTPGvQYcmchua3cprsv5OqBz/Gkr2BN+Le3ZVb74jsVwJfPntUQ2VrqCnAFbHpHQd2Tq02PBwJbBHhSMLymT9+W8GXI1HjJ4yNDsth9iLiykVS6P21n3oPnLPTfZaHPkVbUT2Nv2TcT4iw9XD80YZp9Bvtnksfn3iTpC9GcuSydzyMebkDg0pXbCfHXmu9iOoklEGwrXnhyiyb4IzN77ZusHvR1biwG+stvDX5zlBwcy07cqD3KdKZ2d56Ob+jREX1Kd3NMryA3mgWFNb6fuXLsBDc3XfL24kopWJO+XKZExR2tyCzDHbNSZx2roksUqXOdg2r5waWkx0Gt/XlNhl79u6gnJH0JJSfpqC5MGAtVlSx6Ll1e6pKiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199015)(186003)(38100700002)(9686003)(6506007)(6512007)(26005)(83380400001)(2906002)(316002)(478600001)(110136005)(6486002)(41300700001)(5660300002)(8936002)(66946007)(66556008)(66476007)(4326008)(8676002)(86362001)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xdgQzrqzkfbzufRDXXLOmdRPL9TU2+w2Uum3hshMITUYQkk26amLw8lHT7cP?=
 =?us-ascii?Q?Zzl6njuj8c/zBwo1oddLE8WzbF7hOSiouGa/Hw9T8nv0OaIoBKj61RS5RCYm?=
 =?us-ascii?Q?W0powcAj4HFg6xxfEX6UPWPab+8tlqzwaCci/HDNCBlICd9+wgEGxaTNSw8C?=
 =?us-ascii?Q?RhIwR0k+W7MSBjXZ5vV7rkiX0UkxEoKstyw1cPbYtr9keMdirPnpmySfKi/r?=
 =?us-ascii?Q?x91RpQG5D5X1WdZFy+oA54wxgmY4aSh3QxNwNd00SwrAJWhBqlu60IONGUYC?=
 =?us-ascii?Q?3FyttPWarXNw3B9AZgUiT3WO6cxURDG6r1BgBO8CCti/irVaUsSlrdNuqc+J?=
 =?us-ascii?Q?VjcEvQ/re2bgPXb9OsrEvhds0ecSzfIiafVeYYN/RMU1ozHReCrS8lMsAR7t?=
 =?us-ascii?Q?9Se8tU8j8rCpG48b/9kdvA603bQeEjw8bKhgNtnH0OC9Qp579HN0VQ3zzjTb?=
 =?us-ascii?Q?Gg6xbICndRXh3TSsPASMSrA9lrP1clzma+hIyOQkbuLNKgZbmu9o0/h+dMtN?=
 =?us-ascii?Q?SSiGplcWt0/eiflDELY39Jr37UfzltUHnkN6xrHYMl2Yx7z3zV9lhoDPF4kZ?=
 =?us-ascii?Q?BjXZi6Pwhr+CXOPSdbPDXzkB2Q6SS37ICCQwwT5cr0ogpcNlSlSpFDYELP79?=
 =?us-ascii?Q?aE4PnZ2rUWMVmjyjyzGFLTciWbhoA7DaeGSPiOIwOHT1CgDAtA7u8WWvie9O?=
 =?us-ascii?Q?uB1Ma2C1lWey6RM66pfPUsIwe2rOZ+ajJ/R3wqM1Hznt1A6iDA9f7mz5mrT9?=
 =?us-ascii?Q?dJ+CqMHfzvKD2/eD30NGI+ooOqFeaSH1GsPyKcqts4H3/n3OlSw6Kh5K9Ww/?=
 =?us-ascii?Q?irMl1SKbDBSv9bdVGfc62U3KaDwTRsoh6FmPbvuHWZVfjAbf1gG9uxosKWTm?=
 =?us-ascii?Q?4RK+3KU7h1IfWj/Jy/3wsYAkYoT5/bQwx+QQR41gIxsAZaL6/TurxVTKfvXE?=
 =?us-ascii?Q?ysdGPM3XfBpu3CSKT4OwGjALbOsZZpteKnmIezNEPQqzr+V9Pj9WKJCdeThe?=
 =?us-ascii?Q?lu4zi09pYduG5OauiZShBnziCJI0FQhioJKJO3Roa8ZWT0p62TgpBNUTAcr0?=
 =?us-ascii?Q?ca5cLvryf3XfYt/4GT4hk53e39r/7zM7WfDMO2ycU69WBtIKOmh6VyMOzG9z?=
 =?us-ascii?Q?uDgGM5UUUdMPK6nXjrttugx7559ASUSO7sHcfjyCTTMeK6qY2RuEwNsgRQk1?=
 =?us-ascii?Q?2EKELo0Zg259/OeUhYw9lxBf/LCXJxQ/u5e4uZquLJndaHJzmCvEt1SeLxyZ?=
 =?us-ascii?Q?yIMWyJh/7tViNm9qUE7mCkyiE/dh7UsPaSoGXwMc/sRUsNMLL6+fJTv0fSvb?=
 =?us-ascii?Q?0louhS6Tgp4HDjNqJWwA514t6Wf37UURosNPGQ8ag5AWSdIhKDBr23Lyze6N?=
 =?us-ascii?Q?Goo2NZAvzS+x0vQ8htfdUHx6B8KtiJRiHxEtUusJQrnSGH/ma3jy3R5pKDjn?=
 =?us-ascii?Q?2WVtyjMeCBR2gQL/qS2zK8eal1wnrvRQ0pEBIxvBI8uNVRpKFPd7xn22bV8J?=
 =?us-ascii?Q?Wsx6BDFHJ1rpxCW2qBzqsdP2LHOSPQVf/9tJwtgYUkMklrgPf1fuqe7xm9fN?=
 =?us-ascii?Q?37tCUXALWXyIxijQYJWLt1sFFHslRC/QNXSaSNtLFt9N1vz4AUcvqK5v1yhk?=
 =?us-ascii?Q?mw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d4db7d3-93ad-425d-89ee-08dac11a9b8d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 23:48:45.1119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EQVEy0uKDmcwqMnVz0SQFa5oiNrOYIv/ShrAG1U1XRl9/qntLFrBj4HcYtNZ/BsK3bBf+zjs/4hd+zb2IXqjI8Y70JmaGgAQmMmejohREFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5120
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Sun, Nov 06, 2022 at 03:48:01PM -0800, Dan Williams wrote:
> > Allow for:
> > 
> >    cxl create-region -d decoderX.Y
> > 
> > ...to assume (-m -w $(count of memdevs beneath decoderX.Y))
> 
> I'm not understanding what the change is here. Poked around a bit
> and still didn't get it. Help!
> 
> Leaving out the -m leads to this:
> $ cxl create-region -d decoder3.3 mem0 mem1
> cxl region: parse_create_options: must specify option for target object types (-m)
> cxl region: cmd_create_region: created 0 regions
> 
> Leaving out the the -m and the memdevs fails because the memdev order is
> not correct. 
> $ cxl create-region -d decoder3.3
> cxl region: create_region: region5: failed to set target0 to mem1
> cxl region: cmd_create_region: created 0 regions
> 
> This still works, where I give the -m and the correct order of memdevs.
> cxl create-region -m -d decoder3.3 mem0 mem1

Oh, I was not expecting the lack of automatic memdev sorting to rear its
head so quickly, and thought that "cxl list" order was good enough for
most configurations.

Can provide more details on your configuration in this case? If this is
current cxl_test then I already do not expect it to work with anything
but decoder3.4 since the other decoders have more complicated ordering
constraints.

I.e. your:

cxl create-region -d decoder3.3

...worked as expected in that it found some memdevs to attempt to create
the region, but you got unlucky in the sense that the default order that
'cxl list' returns memdevs was incompatible with creating a region.
