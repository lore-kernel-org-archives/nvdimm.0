Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF43DF42
	for <nvdimm@lists.linux.dev>; Fri, 15 Mar 2024 03:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710473711; cv=fail; b=Bp6BGdnBdxFI6e7Puq9N6bl/lC1igeOcSbeNyiFqi9wPHTtUhaQYvnZArKFd9F1mQ7PfnPfN4M/LKBN17xzRGGjOGQD0JCM5XCek1qjh99bi9yh8QextQIXr+FtPgWh9lvLEoLx71oW5o3oFL4p6goLVOfx4yhdmLFPjAVTyOnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710473711; c=relaxed/simple;
	bh=LKkMUdHN2PK6G/BETmIqbVrJhbwgejafZbW/m1M5VJk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dQg6Lczvgt8zK+t4HzvtbCdL0pJTkpPOKUkT3BA0NibdY9Yrh4pGzsFhffUh0DJylva7dEebIeVjO+gPdm5QkgBF+A+97Zc5AnrXyCt2TUx5hvn3TMiYfExK4kKqDyZ/5dWf3nQ9TMQH892huy3AM0uQBAvDZAGJpQF+GlXN//Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fKim6k3A; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fKim6k3A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710473710; x=1742009710;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=LKkMUdHN2PK6G/BETmIqbVrJhbwgejafZbW/m1M5VJk=;
  b=fKim6k3ABEBLmO9F//kGEP52Q8DgMbX06ufl1Yj2Lu4to42ZJj0EXHLk
   /M+QlEoT4YZkDS5UWFDqJUpjk16rwtJ6qMZroi+5QIzu6ARXTcpyo7VPL
   3wfIpVhY/JTT95H/fV/87U5pwCSUcvBiCrw5zKjp4RNPK4CE12U7v5pRk
   /Ow5VQyjo7UhX/34rxGtWfKR9wJw92xhhry1DjcjtsTD6fIskyYV3bqZk
   S0oeJqgRxVemw/cv78bJXVkvnt1n5BdSi1PQJbAH+upqFNuDqrgWqNZ6M
   hR6D39IbLmpiQWaKiHT2f+vKNsCewjQGD7viaMpHvrn8ZBCN/Yudl0Rps
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="5929918"
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="5929918"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 20:35:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="12613122"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2024 20:35:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 20:35:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 20:35:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Mar 2024 20:35:08 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Mar 2024 20:35:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fm88Qv6mziNNwOO8CNTyoqgzrny6dSERX8jk/DQ8T2T0ZL4iiygSVhM0PAUEvB1Sc8P+Z2KutYiFxan0yKD7S53oaByn3LCt7T70jeO6iRqc+uVMnUhUDGJiexl1xkPghU9IARsipgl6ycn5N/6cLej8Z+TtsmLv7COpGznEF3Sc6XTvrsB7aFYo0z/6x0g1CJpZh04X243X2J9XFQC7bmgh7LuA/HdHeAl0xWpAYpztm46tXSylboGGXRQnd3KVZJU3tJMp/f6oMmek7Oz5lkzjlQ+Z0SbNLDdaZFfesfcohozhlCq4B+uWEqISJT30FM+fqVvviFfq8NSg4+MURQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iC/vttwCPaC7VTTJkeEH4WitP6Zmw2xyuAroly5PIjc=;
 b=oFvRclxC51goq3b0tYcPg2tccI24OnKPTnm4xMQvtxyfh5juVC9B3FMe9+KPTJCIiu0nn6Ok5ny+K0xBizjbNeR2OTfgII+z+6fpEx9TQTx419tMAuO4zEQGPUXTlo+5s/y69LvCJE5amUQqILNhu++VlI+NiSq6nlaXUBhE7GN9HVBzw1lpeC90Xz/ZfkBs22QiZQ/Zaz8QS4UOqkB15/rJxD0rL3xR5hkq4TUWXaOse7V84ybcsiYbJ/gfBHGqMgVjQNUAU7moQLdWBOmzxGipshIb9I1+Jql19f41v2oyr1wspsT1CzZABi59gzorbzrQjDtUFYw1jtJTE4desg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CY5PR11MB6510.namprd11.prod.outlook.com (2603:10b6:930:42::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.19; Fri, 15 Mar
 2024 03:35:04 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7386.015; Fri, 15 Mar 2024
 03:35:03 +0000
Date: Thu, 14 Mar 2024 20:35:01 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Wonjae Lee
	<wj28.lee@samsung.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Hojin Nam <hj96.nam@samsung.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v11 6/7] cxl/list: add --media-errors option to cxl
 list
Message-ID: <65f3c1e5448b2_aa222949e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <a6933ba82755391284368e4527154341bc4fd75f.1710386468.git.alison.schofield@intel.com>
 <cover.1710386468.git.alison.schofield@intel.com>
 <CGME20240314040548epcas2p3698bf9d1463a1d2255dc95ac506d3ae8@epcms2p4>
 <20240315010944epcms2p4de4dee2e69a2755aeab739152417d65b@epcms2p4>
 <ZfO0JPhdY6dp+nnq@aschofie-mobl2>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZfO0JPhdY6dp+nnq@aschofie-mobl2>
X-ClientProxiedBy: MW3PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:303:2b::8) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CY5PR11MB6510:EE_
X-MS-Office365-Filtering-Correlation-Id: 42f634f5-4ab6-464d-d867-08dc44a0e6b9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6eKDNpSqgFf3F1EN7NDIHYjEp2hOK20f/nXLb4zFeQJMfdExfaKENZaK6JjbAU0SuUrrzKYKIlntjy7RZcBwWAK+47xfh0lDiMuhaZEmwNcPQz5rjcRi7lZBmnHzbbp3cGFL788mDaY1+zI/grmsyvNZDDc29VZJqfXCRfuExQee15uEGJxnsHsrJWXdodqw112V/IE+W/1lTrDQ70Z8otv1RaFiECf/1y0kS2jh7Nzo1yVpspo7LbS1zcpB5YYXz8qMJoA7pYkPPyYnqtE0tAIHh3i7f05lGj8N2esnW0rjmNHBs5o/HhfHGtXskmodXaYcLU80bhkHLkMhciou9k2D+K/9+Uo56L42MWmJq6wyv+Vy0/ltx6/vnuokGjQagtZaaCoqr7VbZXTcKxYBp6zpj581FjFI+ruE+igIIIPtAcqViU+/vgyImymHSJhAPaGiaYNuzOANn/E0xuBl8vzcEPyK8Z3mivELBdOrl/MiOAP5XQecHbRVm7lN3Zl6RRaAZBHeN7ThljGfnWKgZ6HvVcaHo1uEMyxAsX9l+8C/acm2xf50Bj9e7nD1Yu0RhFr964PHtngwzHz6ZHHU0tt6x+kLH5q6j7S/35X0Jojyb/ZX/6U7Xy0/7sDEFxQaz903wrBr+G8Oo7nKKjLPw13vcdJVw0O5NIlFx45zmBI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?+FWF3+S0+kZvlxrJ7jAb9mJOvVHtKrQcOnxOmr2L/6wi0JyA/XHtJBa3ci?=
 =?iso-8859-1?Q?LJ05qF6WbhihfO4rN05dYJIWOsfx/CKA+Ig6MqY6UqATnYZEAEKQYfhfr8?=
 =?iso-8859-1?Q?14UptSHl4iOHWyrRbG1M9EWFssaJGiShA0DcbxcmcVSBERcdDfwj3cG2jX?=
 =?iso-8859-1?Q?OP9nubxDwpNLTOZrgKQM8QvsGR6KNlHQrPlPqk8l7hok6GgXlwx2Nsiz1h?=
 =?iso-8859-1?Q?0Co9VxEJxY+wP5wxLyCQvt7LQXVsJDR6XutOY0Zp4Ku0qY0EobBxS2J3MZ?=
 =?iso-8859-1?Q?xTvpsbjo1nCDtwBHj1GyUz25yV45SqtjPvb/g/0fTFBn6CXyZl8AOOOmci?=
 =?iso-8859-1?Q?Bulo/DNRvtUVFTdj9pVOBIr28bYuUgAELBgcj5FWy77NQGc/9xPwmBODtb?=
 =?iso-8859-1?Q?APnN8qXmok/t6c6D7aTY7B/8rOXVPCbHJj950uVFx928msvkAXno21a9IW?=
 =?iso-8859-1?Q?VrffaVMU3Zf3b7WtGFm9Y2wkXoFd3ac74CrLEbFHNzz3iy3Py7GWpMYhe5?=
 =?iso-8859-1?Q?qFfprTTmQF96erTwe/uj8mVwWNynF+QdA+C3shewQqPATeJawvX7OtlkPF?=
 =?iso-8859-1?Q?DDfMMl9Gw3ubjd7LYjvkugfhoowHLEDxR/Zhh33XIhX5X/2/hEM0rXZ2Dh?=
 =?iso-8859-1?Q?yLbcgjLQsyIkKZKkO9y6PK7hM7eidWUbmmcbR0lnGTM7I41I7dVSbsUMTl?=
 =?iso-8859-1?Q?HGNVJBcHEBTmlUOZ+vTzsqjUpxnps5t92yAAhdkGlxKLRH9XtnuGQSf1wO?=
 =?iso-8859-1?Q?7NZHHCGbcp9lrk+Jpz/H7BUjuMgLUBVhMVy6ab0EEKRBrFVKNXR8cpWPww?=
 =?iso-8859-1?Q?qzPztXqLPib12+2rQ6WD6+kcywHKtFoIcg+YRNjkQpsnsudJOW5FH9G8fE?=
 =?iso-8859-1?Q?flAHqHk3u3oCni65J/p+t4/hQmNC7lfarLXSugKzN9PnPaaDhW0dyo5WlU?=
 =?iso-8859-1?Q?AKK3vroE3Jx2uCNvu9BdeC17BCANDULqTeFPiVdsFEVwMDEck50b6/3fxr?=
 =?iso-8859-1?Q?y6jKDnykc2onOgTHiNBpP5ZvDMCR20LO2ucYzsUUdQ1zt6931KTTOd41Mh?=
 =?iso-8859-1?Q?jzedjsNfZYLjuaw9CESlJDHC6pwHZpakwwipRZhsBv7kv6kKJkWz9KXXSE?=
 =?iso-8859-1?Q?vyK/nMAqh7xa/2HlcuKNGu1rs1sxAKfpuV9Tp0z6KItO6cdxhHcf2eKd6U?=
 =?iso-8859-1?Q?1EfCITtAaiU3QJFBv8gMGZppYrOhZAwxg1dQdfAnqZyAoT9sH29CLX3/th?=
 =?iso-8859-1?Q?h2mLFtxld/wvThryiWn/yj9L6mcaBNUb0Z/kjKCGwAntEzpXcqd2sqx+hq?=
 =?iso-8859-1?Q?q9Dc3UlHPLvdXuTQlwTcwzpJ4SgaYe2E5Wcze6+ukTWeXBSSOhsml3N49d?=
 =?iso-8859-1?Q?jyURlReSWnn4lqlP5lghoOoVdnep9A/8gyoiyas2stJ9b+iG2R3LhrSVyy?=
 =?iso-8859-1?Q?K32FiV6JTaTdmi6WZaVXUKyGEMT91lj8LUB107Gekyulzqe82oIkF4Bbmr?=
 =?iso-8859-1?Q?uQtCm4YL2+C+vJUMwZmomJ15HOBcyc17LnI5+BPmZI6m2IK0zMN5x0RVXj?=
 =?iso-8859-1?Q?eG3ZjYfVf06FWKu4ba6Zp2Nl8A4ViGkDOqi0Kq0i985AIHf/yprcko7cah?=
 =?iso-8859-1?Q?GhUmTzhE33fyolHUiUq/u6md+rpoKZm+NWeIt/7GqsOhYouXiuvpZJGA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 42f634f5-4ab6-464d-d867-08dc44a0e6b9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2024 03:35:03.7877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9BOVTav4AEjr/qk1UIPC9OeFANoMkkDo3C07mbio0F3x2wFud6ouvl9OlxcJWVM1TGOT1WO6My/XJiF1dijKHhcK9CMRebSj5ptZR5mGEqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6510
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Fri, Mar 15, 2024 at 10:09:44AM +0900, Wonjae Lee wrote:
> > alison.schofield@intel.com wrote:
> > > From: Alison Schofield <alison.schofield@intel.com>
> > >
> > > The --media-errors option to 'cxl list' retrieves poison lists from
> > > memory devices supporting the capability and displays the returned
> > > media_error records in the cxl list json. This option can apply to
> > > memdevs or regions.
> > >
> > > Include media-errors in the -vvv verbose option.
> > >
> > > Example usage in the Documentation/cxl/cxl-list.txt update.
> > >
> > > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > > ---
> > > Documentation/cxl/cxl-list.txt 62 +++++++++++++++++++++++++++++++++-
> > > cxl/filter.h                    3 ++
> > > cxl/list.c                      3 ++
> > > 3 files changed, 67 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> > > index 838de4086678..6d3ef92c29e8 100644
> > > --- a/Documentation/cxl/cxl-list.txt
> > > +++ b/Documentation/cxl/cxl-list.txt
> > 
> > [snip]
> > 
> > +----
> > +In the above example, region mappings can be found using:
> > +"cxl list -p mem9 --decoders"
> > +----
> > 
> > Hi, isn't it '-m mem9' instead of -p? FYI, it's also on patch's
> > cover letter, too.
> 
> Thanks for the review! I went with -p because it gives only
> the endpoint decoder while -m gives all the decoders up to
> the root - more than needed to discover the region.

The first thing that comes to mind to list memory devices with their
decoders is:

    cxl list -MD -d endpoint

...however the problem is that endpoint ports connect memdevs to their
parent port, so the above results in:

  Warning: no matching devices found

I think I want to special case "-d endpoint" when both -M and -D are
specified to also imply -E, "endpoint ports". However that also seems to
have a bug at present:

# cxl list -EDM -d endpoint -iu
{
  "endpoint":"endpoint2",
  "host":"mem0",
  "parent_dport":"0000:34:00.0",
  "depth":2
}

That needs to be fixed up to merge:

# cxl list -ED -d endpoint -iu
{
  "endpoint":"endpoint2",
  "host":"mem0",
  "parent_dport":"0000:34:00.0",
  "depth":2,
  "decoders:endpoint2":[
    {
      "decoder":"decoder2.0",
      "interleave_ways":1,
      "state":"disabled"
    }
  ]
}

...and:

# cxl list -EMu
{
  "endpoint":"endpoint2",
  "host":"mem0",
  "parent_dport":"0000:34:00.0",
  "depth":2,
  "memdev":{
    "memdev":"mem0",
    "pmem_size":"512.00 MiB (536.87 MB)",
    "serial":"0",
    "host":"0000:35:00.0"
  }
}

...so that one can get a nice listing of just endpoint ports, their
decoders (with media errors) and their memdevs.

The reason that "cxl list -p mem9 -D" works is subtle because it filters
the endpoint decoders by an endpoint port filter, but I think most users
would expect to not need to enable endpoint-port listings to see their
decoders the natural key to filter endpoint decoders is by memdev.
