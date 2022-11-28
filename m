Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414C3AD27
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 22:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669675333; x=1701211333;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yVClKg6pIeYJNmx7Q3Xqv5gMfGGrAa/fAsa3EFCFB8k=;
  b=LRn0HnYN+v2WckmzW6AWk/f949VnUlWF8Oj+7mMNUTIwnkfesjYXsPey
   Vi7tAX+1RfeTRACIQb4ORZYyypxJIicOU6Ui/gUOr5Soz78Ky7CyGombH
   MgKal5NSOqiyrraFSuBfKriARimbIGyJjongDYATJlekEORDTWdvKr4k6
   /NmNnHBnlLsPAXUPkrmHfuFD4Yhszv9cT0tqo5E2J/3BFyt49sJ5OEwos
   nmSU7Gn+9wKRbcvEXFBg3B9NTPcR1kFEGJ2i4antqW13XOBm38voN04Uh
   uXVbI2Z1+mBFx6iVipvj7m06xzhT2d3z5BvhJJsszSQtelQXGx7E+BPvC
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="302548870"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="302548870"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 14:41:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="972444080"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="972444080"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 28 Nov 2022 14:41:54 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 14:41:53 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 14:41:53 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 14:41:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEa3A5VnLU0RHIXsozeynAhd3upNnRV5TCC+SSy7TNPEKiGfVbTHirJ25KIgqufurBFeCJLjwA+YT/gIvjOWV7ZU1yg8hxsqMH7pQBqUNzwF5l0GnI2YNG3DMMvvID9Wj2XJDL+egYfkRKZBSq6licLgSovVajVVSAGI1EONYoBPYAORE7ahGfD92bgB/MzTnGQpzhcjaS7YsfzVFxJh71bf5wbaxf3lm1RBhSaEA06C1NjIEDvNH6M+0ZZfj3cpnjCC0gEhmuVRMwbgHqvfLIal2UcXSQ2mmG6g4xlvEnAdIZMzYhEYeLzzp/SUUhaoMEQjOvM8AgHC1JhWq3rMbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSU/yvkYlsU/63QoP1P+R4MPeDfwxGtgl/51VI/d4rM=;
 b=IS2CTZ5T2NyvasSdCqKQ21U0L5IqUTi+MGY4Cq8tclzNz7nhslsZKbeS44HntLhyOzbgMG0CZnfetr/xwA1H7eOpMCB/EqLD5nkqFdML5tHQSnN/0QQi59+hAJnlz0sSYn/kXbwCK+p6i0bUiv6gd9g1nk3hnLWht7YR04L0N1A4wrzsQQBv7hBJZRee1OSDAp9iPdpUG0qS8yBKqos08Xn+/mDg0u6pqiJMpevtXNzgHied/sc11TzDoywN3D8y6KziUGp7HhdovXpTKFPmvvMaWT+Y9bLuQ/M4IBFNLw6a7KrtTj6xmUddDPVoSuwLxsoMuVJXFnf+ZW52WU9p/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CY5PR11MB6461.namprd11.prod.outlook.com
 (2603:10b6:930:33::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Mon, 28 Nov
 2022 22:41:51 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 22:41:51 +0000
Date: Mon, 28 Nov 2022 14:41:49 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <rrichter@amd.com>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 11/12] tools/testing/cxl: Add an RCH topology
Message-ID: <6385392d6bd_3cbe02945b@dwillia2-xfh.jf.intel.com.notmuch>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931493816.2104015.8749844490243672146.stgit@dwillia2-xfh.jf.intel.com>
 <Y4ULS+UsNiEeD97l@aschofie-mobl2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y4ULS+UsNiEeD97l@aschofie-mobl2>
X-ClientProxiedBy: BY3PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:a03:217::16) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|CY5PR11MB6461:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f4a64c0-6413-4d40-d888-08dad191bdda
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2mHUG4UsWg4DhEaid7V4GVSNr4DH8ap2cTiOAWHb9vHtdRXNQQMKeOThtrd5+0WGnO5f7w7YP087huGwkKmB46j2kaiSDHau8wXUoWQytnoA7CN1rhBe7jSf3ThJB9+VX7316hK498p/5+u/wirFKyun2BuvpPamkEW+CfnRieCGZMMfOg3OdmhkcdoVBGaVaszBEXBXQhp5LjWT9eZJdYnWDBhhYSowbY561C7eqGXmRYJ+FSvF6lQcgv4c72BRx3o57qnq94K050KLQFdp47rj0YK6lgCWPQS/j3TgOQNvhIIjHwRuTAQ+rVqEdS8zcgzESA/6YIr4uJbg5JoTtufxgiSaeBuSnGaSw4cD9x8/iHmu1xTegKLMBj7th8cPwNJsXCuiIg/8/SIURvDLIOOa4KVIIcz4NOt0vnLRdw69Z9mf+ksrBrjnDCoypyRvC1OwZoQSj1BoHF4rD77hxgnwwfJtFmRT3E82X48x8TtxIx9obij/d0OaLuyCiZGmqTijRexYWsBAESM28yYnJr4I/3KKgih6Icu0wZHdeETFS1Kl9LmDd80F29Qe6klJNLLNo7IkR5jiaat8pNPB5AWYYku6V4TpSM7lsXmF271k5XC73DSG+EXfzJEvH63NV9B7eTvwgnhKsLChd5uxdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(396003)(376002)(136003)(451199015)(478600001)(6486002)(186003)(41300700001)(316002)(38100700002)(6506007)(82960400001)(110136005)(26005)(9686003)(6512007)(8676002)(66476007)(66556008)(4326008)(66946007)(5660300002)(8936002)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tHUdEsTifaFK1yipXceQ8fq7Qpq5p6P/oCrWP0zV/74Igk8tnAWSDInHgTek?=
 =?us-ascii?Q?CY8kYhVyAml+CUfPbz5aEUOFm+uSDHnRqn5j5JxyJCv9LOn2XKAr5uypYY4O?=
 =?us-ascii?Q?RxWOwYvtbgXwaU5jGmAna6u4UnLA84PBmekB+tyU7DPyaRkHqvGND8qL5x6l?=
 =?us-ascii?Q?+lEMkvHX2ntaLTH1g7TQJ6tTzi817C8UJ8Vv73Hx5ICKT7eD37P4XDhfdLlX?=
 =?us-ascii?Q?D0sEGVXdrt7OsZ0SYFClwmmIcc9YqzKRb6Dz7OZu3E/59euyq/ACkgLG8hmH?=
 =?us-ascii?Q?/BJZECUVEy8/HDy5jNOPOcFUF6N9XJ4NUyeGxUgPi7mzmfDWb7Kie1c0U80M?=
 =?us-ascii?Q?GXyzlekC4OaNVkjx85Z8skatJk1MgIouTUKGEY+nBzfaKcNoExIUl9gYjrz1?=
 =?us-ascii?Q?9ZXMQSpNYmj+Uim7NpCXp6BTT4xfTGe9YouaVik25C8j9LRkmDGmpZfeD8fY?=
 =?us-ascii?Q?dFVIV/hdgyPEZWCKERL/ALPnuESHpjgM0kBg9oSBt0VXF7sTOxOQC7/pkccb?=
 =?us-ascii?Q?pEn2+wTSGFJjsclR4pQLn8KlMBwLy0egQxrKKaMpEHl1rJu5nshViddA9uBg?=
 =?us-ascii?Q?4rpwu51hD4WmMpY/GZZbqJMLB6542mPmI7TmqkqAVFOFEHFR1Kr//ikDqyFp?=
 =?us-ascii?Q?txJjN5MwXKXFCmm3/ZVei2CZCmDviQ8rE4F2+hzhnTCLP189PazNFCGRBcju?=
 =?us-ascii?Q?Zso9RpRF0DL6wPcj7XSm0UVyByA//rWOI2bzRv/suCfUC7W71aiyeeaL+XZM?=
 =?us-ascii?Q?gsHqtYZndECfrlntXOBfPjqWcWFS+c1Y1vAGn6E7LGL5q8SAB/ZgzZlHzMFB?=
 =?us-ascii?Q?MQUl6f3nQtek5g7tSrkLeVyOZ+W2zpL+E23o42eLPh6DvvkWi2Rw+idnlk12?=
 =?us-ascii?Q?plNiXtKpoms5NzoIEfmFAz2udf05jwEvMtN9vzGJTrx6rAYBeL14b3gfmj/K?=
 =?us-ascii?Q?EdRvt88a3Aw6V3VjvxW+Utbkc1eadd2puxDtRUOXX+mP/OtyGfACDa2n6jOb?=
 =?us-ascii?Q?lorfKinZKpy5QLQYmf0GkEby+yOJOi0mLJrE3Q/mMk3qRGYvujj0c5cqP+aM?=
 =?us-ascii?Q?F6JSbOei6dR+QoYmzUEfY0wvpZYAACXiKLG2iXAMRt+Bhy7hC2UXWr9EIm8y?=
 =?us-ascii?Q?8aH6kP2OFJiKJ8TnVPUQwMZPChdSkEUMW02dktSa7es0cVZtZ97sCt1Ee55m?=
 =?us-ascii?Q?eimnSIS8Co0P1unSvTYGG6nufdzoprRWzwXmQfbgLKf4YFN4K9f0CSVk75Bz?=
 =?us-ascii?Q?lHymga1DUR4o6URtkVD1DczG5QaJtGPiymtQ9l4tDFvuqAJ6EPpUjwadCQhu?=
 =?us-ascii?Q?RjdyvIMCzqPuxL6U3YGciwewzulZul73UFcsjn04N7AfiWXSfDcwp6yt6iw7?=
 =?us-ascii?Q?ZEU5AUfBBGy6qXUXdX91JYqIVTd+hRjwmcK6dBGA8gu2lBbC12z3NxtEU2sG?=
 =?us-ascii?Q?PPEuuUBdfdNYx+aeoYoKlnwsDIqiALV+CmWOrbPUae5dhZHHo3SbtqCIvXy7?=
 =?us-ascii?Q?BRiToMGdOQxODQ6W+NrDt5W6obYFlXo5hvjlMEeaF4iTBM0xcyjzzHC5+Iq+?=
 =?us-ascii?Q?pA9JCWABZr88Hk2O7XpVx57+8qkxwy6Sat8M7wZmiPl2muixXHriEJoVdu43?=
 =?us-ascii?Q?3g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f4a64c0-6413-4d40-d888-08dad191bdda
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 22:41:51.3608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OrqMavH4K6GtvozA77GcmxPYsFvMR/wb5kPJj3SZHDQu3TAbbyFMUGABaHwSM3NteuJfwW+LBxzk08zqmjYpyrrqNg9sZgqRKfuixYBgKxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6461
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Thu, Nov 24, 2022 at 10:35:38AM -0800, Dan Williams wrote:
> > In an RCH topology a CXL host-bridge as Root Complex Integrated Endpoint
> > the represents the memory expander. Unlike a VH topology there is no
> > CXL/PCIE Root Port that host the endpoint. The CXL subsystem maps this
> > as the CXL root object (ACPI0017 on ACPI based systems) targeting the
> > host-bridge as a dport, per usual, but then that dport directly hosts
> > the endpoint port.
> > 
> > Mock up that configuration with a 4th host-bridge that has a 'cxl_rcd'
> > device instance as its immediate child.
> > 
> 
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> 
> How can this host bridge and device be used?

Answering the direct question... it's not good for much more than
testing enumeration. The expectation is that RCH hosts will be
configured by BIOS and most likely Linux driver only ever needs to read
the configuration, not change it.  So most of the excitement from a
cxl_test perspective is in the enumeration. The rest of the RCH enabling
will be for error handling for errors that impact regions set up by
BIOS. That testing will need hardware, or QEMU, but I do not expect RCH
topologies to show up in QEMU any time soon, if ever.
