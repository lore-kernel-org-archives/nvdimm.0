Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00157EB03
	for <nvdimm@lists.linux.dev>; Thu,  5 Jan 2023 16:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672937895; x=1704473895;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=nN1SsfDohqtoHwnPt9KTKsuCp2aZNLAoIEBsBmN04IM=;
  b=OmDvq2D2K8sFbyG5r/oDHCee2PWfnFiNK8CejDShWMl6UJoXFLbSKTpj
   jQ2rx9jD1Zt+pwq5NGfES48G1QlZRkcykUl4bUcqPWzlR+9mqZh8ZK8rV
   d75aQi99W8O/1PHiO0jHfyWwtj40RQ7g/y/r7Vzh8qQVcQvjP5RSvtHUk
   DvKzj1AMtpwx6sCYlbPCtfZ6yxpMrTd3rWUocxga+/eWFi2dk9Wt5l840
   LHtfJ48KGJAg3mGhzM+Nh494yD/vEQNebxDdD2NEd7TzCEFgLmnighKai
   TsO1aqMpO3PnxoB6xx7kDBI+TVOQtXmqAWuxdJfBPInlCBpp8UkF7eqL9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="323510444"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="323510444"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 08:58:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="687982924"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="687982924"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 05 Jan 2023 08:58:15 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 08:58:15 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 08:58:14 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 08:58:14 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 5 Jan 2023 08:58:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTey7uy/ljzU7FwXXlGLVCPnlHDNc1/bZRJY0SJ6DSBFk0l+aabMtfaafI+C/BDWTgFkY7ddTcL4NA7TgESJPcO/OudcjFhzpKsAvan3gY49sRZuLe8QeU4cZsW/ehX/aTYhguLYTC53b8it1l16TfguzChPWAlKsm1kKYnKVIEfOsbg17NEvavod9nVYJWuplmRviOqbhTyGx98hCuz0wxEN48IKHPPE2M59lKDZbF08xw1lgvngpS+shWicg8e+1XwFq1WqcVmx3hUXrruOe6l9TTlLaO3tVBGrtqpPpYLhi0bZpXpLDnZqBE+FMU5HoVswHOC7biXaGB0OYQjUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63e+floeCuo0HOypXfThbl8cUMnhMC/SBJBAwQDJcis=;
 b=N86qbV4XkYmjSfS+xYjPavQ/y6NpoWgRmaonjTl9RQztzu7VLkS7AX8YsQbZOd+wy/Mmvbl7eE17PnGQ/f5neoWwHYeygS+XDjK+R694AWIj2PEnidVoI9RD8nZ/tL/gpHCEsCETzi/j1YC7P+sbP37S81gl5RI4dcvQMtNvh8gvhfV+cgQy9c3LcaKUjzjx+sT/AyPRmYvXCWsQd5F7x7s5Kx+jkfH2T4SL43rb+bUcndWrrMORzWY+QoXxK4zqj8wMZ4D/R54ZIp9WWs6+cfQeGItxVMmUBnO39apOPPXlZ08sG8SeBsTkS1xVSB9pe3wyGPP5C4nf7F5TtZHNPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SA3PR11MB8021.namprd11.prod.outlook.com
 (2603:10b6:806:2fd::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 16:58:13 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::8dee:cc20:8c44:42dd]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::8dee:cc20:8c44:42dd%5]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 16:58:12 +0000
Date: Thu, 5 Jan 2023 08:58:10 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Eliot Moss <moss@cs.umass.edu>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: RE: nvdimm fsdax metadata
Message-ID: <63b701a2c1400_5178e2949c@dwillia2-xfh.jf.intel.com.notmuch>
References: <87ec52d6-23ba-48fb-8cc7-ffbb0738c305@cs.umass.edu>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87ec52d6-23ba-48fb-8cc7-ffbb0738c305@cs.umass.edu>
X-ClientProxiedBy: BYAPR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::49) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|SA3PR11MB8021:EE_
X-MS-Office365-Filtering-Correlation-Id: ce248a82-a912-4528-6a2b-08daef3e07f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qp9ZYlkVvtIDkLU5WCKBOBmgU5Rm3vPpME2sUT5+NVPDehPnm3J56nBnp58fJnqHnSWKvxQ2eNsFuAmrLnxaTiyHWIXPjsokx7/hjeDVGzFeznwvIldA6zsw3AwcH2QPgzGpp0xymMcIr/S3K/0FRH0gQXVmItUeMDMj23G+TS77TONhRPvO1A4Zj88OGsfmzf0urt3j0DMqBjmhvWeEjjYHITirh05kzmX0x4vs/zBFDVdv609QHF2diww4eXyZkxfvwQeunbz4XA9ELJmSS4JSekkTN/sp5+O0u/GMCdj+4F75GzkwAjMXioTmuvcJuR/rYLcHHE1fVHIXmf2PJKpzL/+Bs5BtiaswluPFzcvFJld4m9WdUWqEzGDlm9cIdw7zLS9nSPUFS2/ZJVR0kDwiQLuXhgtsgqxiFzVhovhUMD4JK8IWjThcXwWGpZZ9wwJcdZNj7NuVJeXqxXt35Y6pxl/JiHjH7p90jXmu8FyJthHO445dWnGxQBKWf+AtjC4VjhiXnUrLa6fsl4nb5SPdmP0jPuIVnQW5vXPYbu3eqvVjrUJRwbKPZicYESRmD6aqZQmQWgAdu2/UzO0U3kUdiqRChWmRJC9l7pXFOOtcMCRkF757VH9W2KjUc8dIOkZFEqPZU4jQNiUmAfu2Bd+CjWtr1BmypazGGDV3KQk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(8676002)(66946007)(8936002)(5660300002)(66476007)(316002)(110136005)(2906002)(66556008)(966005)(7116003)(6486002)(6506007)(478600001)(9686003)(41300700001)(186003)(6512007)(26005)(82960400001)(38100700002)(3480700007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SxUo6jE0+LffAS5+LTdIDs8LI/UPJpmHzyF6NuJfpCHH8s3mdglw2qb++V4b?=
 =?us-ascii?Q?SdNgnff/q8HSmMazFEhzV/cpwnpgM+hJ6k9b8G006PoP/osXqcYqhehC3GYf?=
 =?us-ascii?Q?fJUSPBYtQTtqTgeQc8RGmodVceez2NqZPRWBbQ/uCiE7IlVotWlCU5HOATzj?=
 =?us-ascii?Q?JuvGToYAbxKJF4nHRPpVxhX2ih7gL6OOK66ZtXEoHYoPi7UMLpr4ybkVZAXP?=
 =?us-ascii?Q?N+bVupx3Eano7KcXIMFpvq+YcXYQkC1FlZVRMlhVQm7gvRTO4o1sgo+VSl47?=
 =?us-ascii?Q?QDB2B9+c9VCVSSbaMQ+YHh0bTPtbdMfPrErB+37XxJNLTkuMSlnKY4ARNayj?=
 =?us-ascii?Q?mc8FHnVVQTNYM45qEzCKobdV3W2I0Zoc5CASRbdIZzTrQb6hU2nn30x5HusS?=
 =?us-ascii?Q?pWjW/LPwfP4SLs3C0gDWkDcMZZ06TPeMnbG8iYhcHsP0hkbsGt73vIajmers?=
 =?us-ascii?Q?ymH4x7n0yOG/zAWYfCkM0a7ZPoehTuOBQJFi8zkxbuVyD6ADdWvzxECwnWtZ?=
 =?us-ascii?Q?Tl3XXxv96dVu1VVHAYos4O/78PDtbxjCOcojvO3qvQPr3opWoI84czK7Cu+7?=
 =?us-ascii?Q?sJqbzuhuJGRGiyygfy2ndlvuU1U511Z25FHmKDO7hCbvnE6uZR2rEb4h3J4b?=
 =?us-ascii?Q?y7NWAFiflRS3qfZlDmDU5iyq32prmsyQoGSE76DgqMJQ/dU+u0qFQb2sZLaF?=
 =?us-ascii?Q?9Yb4fPY3G0MZkotHTL473j5Qg+nyq1Ri34kBffAgYAiWzbd70Suy0vfSFk04?=
 =?us-ascii?Q?exD0Nfna7ip9gG+ZFFHXIXtLWzlr8R1uVoNC/Z+Lz49jYepwCR1bWnxfi0HC?=
 =?us-ascii?Q?GJ/HEYAOVZc2lw8gSQcM/yZJtrzzTRm7GJ9UPK47+TvBZYY2ta4O8xkSCqBQ?=
 =?us-ascii?Q?44zLMCMQK9X619CezFpAms8i/hpaiR6fpLUvJ019BKEeiPlSZg29EO3dEove?=
 =?us-ascii?Q?ZfyYtjf98tomfsL2f0zOEVDot5ppznSNHfZZBZG2U8s18Zg2LdNsG+0bb8j2?=
 =?us-ascii?Q?LP0PjWOIUm2GKJEjEtQkm24Tvxb8IwF0awhZ1896q236MMkbxSsRHgL756RS?=
 =?us-ascii?Q?gYG6+PfTCBBkFADXwPt/JSFvlptCwFO3aJGj1yuN+l/F1PZ8uLbH0VdabLo6?=
 =?us-ascii?Q?y35KMHHAPVkSnFBN5nCrxi1saYTbziDl6vnOjEzlrEccT01FTnoBdCwQnvvI?=
 =?us-ascii?Q?xhTIfdc4xhWv/ZqmmYntVCFT7p3ZsymHBmTHUE8Oh0FUpvXGofgLGVKsRgii?=
 =?us-ascii?Q?4tA5u9UALciAgdK9U9SvtwmKqDjdY2IPi+84ae/IzB0hvftjume9f/iHo7cp?=
 =?us-ascii?Q?eRuUhYnCnGM1G21WRgF7Ttx1oYOFW42A2o5NS/B2fAo9lL5QviUxVq1GtquK?=
 =?us-ascii?Q?7L3Awn4s1zzk+Vcej5jDFCxtdWNzMBjqelKUxlSzcUDKhaWk6D/kQCb5tdpY?=
 =?us-ascii?Q?b4IysdeXYhiPfnLsdT9FJCezXDOZ/1UOCLj4xQ3LArArADbZe9U1N77vo0mm?=
 =?us-ascii?Q?3sMLlyCuGWjDffgclqAL4yE1Tk6vvacvRakJiBaL3iCXDTVSf4+6DKQ3vH8F?=
 =?us-ascii?Q?QKxWtwioICbxsuq2Wq3Ul8HLmblB3Ve7vZLNzFNTOgjHgOTt4irWDEv0yTHB?=
 =?us-ascii?Q?Vg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ce248a82-a912-4528-6a2b-08daef3e07f7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 16:58:12.9198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gY9aSOnbPGpMSOdbi9cjXKk7H7XtjcxAY06iqXdTfyxJwJcbweatFJfkxDg3a2o67UigVziM9o5xxw77B3R/heTipdPmJ8oj54S2dd9mqN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8021
X-OriginatorOrg: intel.com

Eliot Moss wrote:
> The configuration guidance for nvdimm indicates that fsdax mode requires 64
> byte of metadata per 4K bytes of nvdimm.  The map= command line argument can
> be used to control whether that metadata is stored in the nvdimm or regular
> (presumably DRAM) memory.  We were pondering this as wonder what the metadata
> is used for.  I am thinking someone on this list can clarify.  Thanks!

sizeof(struct page) == 64 (in most cases)

'struct page' is the object that describes the state of physical memory
pages to the rest of the kernel. Matthew wrote a useful summary of
'struct page' here:

https://blogs.oracle.com/linux/post/struct-page-the-linux-physical-page-frame-data-structure

> Eliot Moss
> 
> PS: Concerning that huge pages mapping question from a while back, is there an
> fsdax group / list to which I could post that for followup?  Thanks - EM

The 'fsdax' topic ties together linux-mm@kvack.org,
linux-fsdevel@vger.kernel.org, and nvdimm@lists.linux.dev. So it depends
on what aspect you're digging into. When in doubt you can start here on
nvdimm@lists.linux.dev and folks here can help route. IIRC you had a
question about storage allocation alignment and huge mappings? I forgot
the details of the questionover the holiday break.
