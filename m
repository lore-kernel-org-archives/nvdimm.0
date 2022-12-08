Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5804362C
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 03:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670470597; x=1702006597;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BKKkfApDqv64mRhixd/k74By5Oiios0mlbJ0WG3QYwM=;
  b=bocM9Qqo8IpCU/sr3L2Wegulstg+rW49Il7AsrmBwpKph46lJyAFc35E
   ZCeenBmWLG94RsytsfTVfAvZy5cFny7eyuxdCTk80nwzjOVG3uwzBXI47
   prUpvIryf+gt3wrCgXNhJiA1rKNvLLobKbROie9bY7ZVNqZr5G1Azyxa9
   79zyMDEdmsd8ik1mAbm37diSTlP36BLU46OwLXM3p7uFHYGk/iJIpVGNV
   m8T0ruCspgzuydHaq3rbhI0TXcm/wOXS4zTqZCrZt3rZH0dogqbhR8fW6
   ubkW3vOMFGahurC795CkvrLm0EUSLOirAz8aKg38LHfLYOVlzSS8HOPaK
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="315781641"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="315781641"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 19:36:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="771332895"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="771332895"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 07 Dec 2022 19:36:36 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 19:36:35 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 19:36:35 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 7 Dec 2022 19:36:35 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 7 Dec 2022 19:36:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvng0tnn/lKCjs8j60AmuzYQo/XA0mWas8VloU02NfstvfZ7EG2q+mbxq4h6XepRtH9PxDtom1psCoU2v2AY1aEpQWwA3dNcim+dfrLawJfFob1/khoMZnDD8xzG7TAMifPlst3V94Y0tP8iR37DDTBY4FmCaIxFSPgyXsuqc4dMOlutyBFQSewuGxj1dch0vKyRyjnnAVGhkXskX/kdHHytbs50KYBPxjBjZ5K+1rapbrOTL01t+QVQ8fuFFHUlWDdNAwpEptcmo7EGNsLzhps9A26eiTbutLpkL2LY5eZktTfrjMeXH86yY2GLHME+lyP+hvaSwIpdlDpoBU/b+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJm2ffknxWvTF0rWidXNlBnTaCU7XFs43YAA//Pkjl4=;
 b=gP8RnH0WTpAa2faCh4pMp9YP5czuCbAJ01V+Fd1Ry9MG1Cml+wjzfrTMAEKqhpxbmNh5Yw1XAs4Nx7jZMqiY9FVmyl8p8qbYAoAc6I53MwgcnCUr+4ZxEpqplYBTsD3tmakCL62WZbrguAUe6Ul4nGr3sMUFistood5MPA0zRdZSXNIir6BmIUBLLMOKgda0TIVV7XRyoHGHmZECQ31M5HZbj81acLgDCl0p7IXuM0Bongwct48JN1CWsERnv+3xF/ChtS4UhGqjOD0+M4MRhQ3e/ASTfMTeZhvI7mlUjVEJ1tZHLPgoMyyxJSIKQaMSnW2BY3PyPXqd0QMinjac9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by PH7PR11MB7052.namprd11.prod.outlook.com
 (2603:10b6:510:20f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Thu, 8 Dec
 2022 03:36:33 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 03:36:33 +0000
Date: Wed, 7 Dec 2022 19:36:22 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 06/15] cxl/list: Skip emitting pmem_size when it is
 zero
Message-ID: <63915bb66e55_c957294d6@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
 <166777844020.1238089.5777920571190091563.stgit@dwillia2-xfh.jf.intel.com>
 <Y2lpS3COS9YdJnon@aschofie-mobl2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y2lpS3COS9YdJnon@aschofie-mobl2>
X-ClientProxiedBy: BYAPR02CA0042.namprd02.prod.outlook.com
 (2603:10b6:a03:54::19) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|PH7PR11MB7052:EE_
X-MS-Office365-Filtering-Correlation-Id: 9872acb2-3683-430e-f947-08dad8cd66cf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mOPG2TD4d04apOq/vaaDRY/WqTU/HbFkDJk+mZRy1YKUroT3RSCvzGcXChkiF7+gA7y68bdEhFVWHSFBM3Dfc0vN8au0avirZjxOkb22+RKg0IIJj//NBgf/4tetsXdFYKG0I2uLhuduxdNoRUc4v1rt1EdwEfREdiPMsHioNEprTp353U/mCdjLXW1KdKT/XrKfLnmlYi8C3M8sim097p+OpVMOT+aQr3o9Famulm2ETz8xQDnpmdfR4zRmdqgzJzAfU41G0t15zVW4U0f/Orpldd1Ip0RNnxIot4W/yi5rmry0QD9avclPOF5SryNWActO1GOD/80INdSdoQQrwSG+59Up1xQZuf9r7bHMqyuY6UOCsXa4m2Ha8QWpf2gOtOQbDh+YyQo16PS1/BddLLa5+vqUHnzT4zN4gOdmFnrejY7gU2yvdnCxqqh3PcFQiuwH7FwxlN3KSpAkoR/bJ88PK08VZA0XPWxOY2/dUqauEROpNknvkrK1n5Yen6AkcYKNdAT29qjZcvDvf6x5MeO8S4DhWe56TIaJjf0z5Jvz2ZbH4Ix1rttk3MmCq0cUv4azzVz34CoEEKMVsq2Fzxr7kt45zBwj9A3c+3/LpfK0WuHC3OSrLhk/runSqnigPEZdjlbLBHjXnNHazc5XHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199015)(316002)(4326008)(41300700001)(6512007)(186003)(86362001)(110136005)(38100700002)(5660300002)(26005)(9686003)(82960400001)(4744005)(2906002)(8936002)(66946007)(478600001)(6486002)(6506007)(6666004)(66476007)(8676002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RH8PZEB/gfHKJwLQBZVGkabx23C2ifWyLeFUESLYRmg9eoP69OvZBSlTjxeb?=
 =?us-ascii?Q?DuZl7386idd5QoI+fURqCo65YW8XLQnigXwdhKL+J5XnvxSOS92pGdqezOHs?=
 =?us-ascii?Q?/hR/OQ/z8JCJdA8Mqr6rlrRyb3QDz8eXEeQqozZKiOfpmNMJ17uI9Ek1igml?=
 =?us-ascii?Q?HIcXIoxCORXfUoqrMPh0iV0oJqXWbFvZVnxR/tKy6unod+5OmiUwMdrgZicw?=
 =?us-ascii?Q?H4DRnoUnHy+z7SVSECW6CgHtFMe+1Chis7CH/2Cs+uYfyeXIRzV+dLt4Nw3q?=
 =?us-ascii?Q?3grTBx22TQJaq2NBj/vIRJ+XClM4n4rdVtWvldocC2mNVKs9LtI30bVOajo/?=
 =?us-ascii?Q?iuMbbs5YuE5NMdw2taUhddOkMerN9M1kZFEM5kiLF1UHHUzkFY+9baqigVlr?=
 =?us-ascii?Q?E0s/Tv7/ZQHLKoTT2n+yo3s8pHIj993a99FIjH7ZU2Yt6RNetoAFD0LAOgNu?=
 =?us-ascii?Q?1bRbcBJcCWWfdlfg33EclSNmXrP/JnRdbHW8mqGLt4vns8z8ySxXrky1MvjF?=
 =?us-ascii?Q?2bY5ZdH8iI/tThFugxbMP8JtbVLzmsw+4SHV/s9Z1NFMxa9g4ig0iX5SXtL2?=
 =?us-ascii?Q?MSQjgu0S754SuNqVdcSocbzjyFwbthSuIsHencfymcnEaBSP6KB9zlq64bXs?=
 =?us-ascii?Q?sP9MYwm7NtddsMnF3n1g+lo00kS8SFbmJTq5r3eEmq4xz8LIC5etfpI1s1Uu?=
 =?us-ascii?Q?4ZP5+DfknXv8c1QkZYKvD1GalVBs78claAZ7drRkJrygNR4vanKrZp+iVC+4?=
 =?us-ascii?Q?++1ZsZzdNzzDqZanBDPQP7c30Xh1hyetnQ/0X6tIU/uCM6mb6uh8+ZabZweR?=
 =?us-ascii?Q?6ytTFHKVMUnJShD/MCZkEORtqj+OCy3raF1Q+TvHn686DZ/dHh5BNw6cCnwb?=
 =?us-ascii?Q?3Yd6ewv2WacCUK6b8pLRIx2bKtFIrRflJ12QxMVPwVUI7A4x6eqC39cg1sg8?=
 =?us-ascii?Q?bBjUjwLHGvMfR8deqyfdj4CJGxwG3pWTlY/pof5Ezex0Cj+CmpNiXXptl+Cd?=
 =?us-ascii?Q?b9jKlwmAF4JDwPUkn1SJj7JVCUmXJcsvcfPA9tHWQivl5ZWKnaFP1q5CirDF?=
 =?us-ascii?Q?JAQ+o1uTS7+nsJwI4BBPdWfZjnnfG/tNalIqeZf+UD7PUQqMLgGh/oNTQ8L4?=
 =?us-ascii?Q?qo/Al9UY6S1Yg1fe1r6WsgHJBljg++kfmocjA6/9Od/c06HRLQPisD6F74a/?=
 =?us-ascii?Q?QUtTnnT8dzFVIs07FG2ybvKMyjEiJjDAXuJawtS08N1LroT7rAy8wSlEu01k?=
 =?us-ascii?Q?xp2S9+I5M1+ysGI6DZ+Fo9KTa/MWIH+DmkHCI4svQzQntwTR9w3jsNdzYXyQ?=
 =?us-ascii?Q?d9rg0a09EEVRrtqe8Ie/XzkM+EupLTEakNk/F9f4j0rkQ7PnJePH7m9DnE0Q?=
 =?us-ascii?Q?MZeKCB/gxlNXQMgVXtNAT2PO7VVFuU9EbILgu9gtmNJuMh/XheS22Ex5TIyJ?=
 =?us-ascii?Q?9Z/apiNOOd9YG2PbWOG2oodXW0AudlODjEUZCj11vo871jUg5lY7BxhAWwYF?=
 =?us-ascii?Q?eGt2cpj5aZVTtEAzBn6BkIhuyQ4nX3E/IuusA1wbCvhWBKE6+IFKm1j9nbs7?=
 =?us-ascii?Q?O53nG9wgO/xDOeZOfTExlRlNSLd4cRmhAKwugLiU2eY1WVWvK3p9h6FJvTO4?=
 =?us-ascii?Q?Cw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9872acb2-3683-430e-f947-08dad8cd66cf
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 03:36:33.3959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2PHvbsyboT8G1lMSv9GaoUaggFcJBksF6/SRR5zZifSR5qzhA5xL2ELi2Im4hLyIbOzMmYnRY7Ct5Py5cnV+Fadzzz9OdDRBzSdQr/1Ztns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7052
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Sun, Nov 06, 2022 at 03:47:20PM -0800, Dan Williams wrote:
> > The typical case is that CXL devices are pure ram devices. Only emit
> > capacity sizes when they are non-zero to avoid confusion around whether
> > pmem is available via partitioning or not.
> > 
> > Do the same for ram_size on the odd case that someone builds a pure pmem
> > device.
> 
> Maybe a few more words around what confusion this seeks to avoid.
> The confusion being that a user may assign more meaning to the zero
> size value than it actually deserves. A zero value for either 
> pmem or ram, doesn't indicate the devices capability for either mode.
> Use the -I option to cxl list to include paritition info in the
> memdev listing. That will explicitly show the ram and pmem capabilities
> of the device.
> 

I went ahead and added this verbatim to the changelog, thanks!
