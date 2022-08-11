Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48744A15
	for <nvdimm@lists.linux.dev>; Thu, 11 Aug 2022 19:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660246464; x=1691782464;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Oe8V1vv4cIvREL8UlQKdwtt5CC84Z23iNr5z5EGNQ8c=;
  b=kJLBWXDZupPGps9gOFi03HLi5GXTlMCllBxhGLwHa0C5nNZXZrzijgQd
   jhGQKTcDeo7aRbvHRENzvyd4d76z3udMNor1fRogzpqXjG8Qlqi/jijld
   KG9Q5eK3IubVo+O8gGPW0aPl975s+TcomLE83NSNz4R/fyh+ndulUUCIP
   eqt/PKMvEtSsPyQmSvQ+Q6Mexud3ZKH5mIKbwYrxnFXBmiIN+pVwE6wJQ
   E/cH3jdQwx/t5fuv2EjKbo/6RkOwvwwGCcV7s+e6lZSswjMh/BOnMGQ8O
   K1p4mGpK6gqc4hta2WCWPpljyp3mhtKE9GNLyvRJr2W64cadBGdlkw0+j
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="292239717"
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="292239717"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 12:34:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="638645349"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 11 Aug 2022 12:34:24 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 12:34:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 12:34:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 11 Aug 2022 12:34:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 11 Aug 2022 12:34:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fuNytt09cdxrWan6h3NP8VuUqZl90UkrGzjWDPYjhZ+4w6jxpOkABLFafpKYP6XcyHZeUBjZMfcj2MRzvF9kdgSIwrnWHqR/KYT0fS8fBtARrZMSj9gN+vcYD66SbSoO+mIDLyMyJrKeel9l0HTRKL77wULlLO6bqhWyT4nTYibrHxFVIHFvoF9JRl7vYuognFBpGhsTo/4w4npLPDoFV5UUZCdgY8kOzUOdammlvD6ddgllu9FgOo/ELPrNS0Rj1ukQdq6cUC5l8da+36ys3n1nC2pZfmeExwfqnNXD/jOBYo/MAUMzxPEbruwKywAn15//W9y4dXwbQIkJzteEGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gddGTUfyTx241uXeIGF9k6VzZ2C4JHv6C0WmBpnD9Fc=;
 b=iEYtgraOXdTf/f2x/MYM0uhRnWQhbXYo31GKokyIhTLOPF4BO6bd97HmTb1gVB8YmqAeREqSplrUODbFXhfd353/i3tg5oVwz/ObqMw3UAs7YHs574c5UNreB4KYhzybWk4wwovEWJAf7ikFYQCpSdGaQ5mG4i3dD0XHUXTiPbs/cECKb/unfAyp1D1NgFdXuEdE1MFn+VW0YKSn7qVsh4sWUIk7muIKoOoDQNYnNEovBCSBX7MaRRle/7wlYgMs1z4nsBBfmG+CFqkv/kH3v0W0+wFhWBSrg4wiccdpcrHSyZvYEIpcswG9uSi5niokopc8kbp4c0rqiTJuuTHVcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by MW3PR11MB4554.namprd11.prod.outlook.com
 (2603:10b6:303:5d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Thu, 11 Aug
 2022 19:34:19 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5504.024; Thu, 11 Aug 2022
 19:34:19 +0000
Date: Thu, 11 Aug 2022 12:34:16 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH v2 06/10] cxl: add a 'create-region' command
Message-ID: <62f559b843501_3ce6829439@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220810230914.549611-1-vishal.l.verma@intel.com>
 <20220810230914.549611-7-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220810230914.549611-7-vishal.l.verma@intel.com>
X-ClientProxiedBy: BYAPR11CA0049.namprd11.prod.outlook.com
 (2603:10b6:a03:80::26) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73537b2b-dc0e-479a-ee75-08da7bd07bfd
X-MS-TrafficTypeDiagnostic: MW3PR11MB4554:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FvrniTV/ws2rv3j4kYmX4tD/GHjUogEGSQiVMcXgmKLeBdui0kUohA3dF9ksFbleCNMzxAREN2yEykeW4yck233YuOiQ2wCghXHidIYM1CC+19qLSn5P974Qa2fZ4AyHrMH0WPEebNZWDeGDFC4h5OpZ0eOdlXhJvHXOl3Jggxpe9emG5xL6zxP3DIj/AbswkmQ8de0FXucPRBuNKA9r81Qtwj8kE9LxXjIIzueNo4LYvGj6lJs3UFmo0o7qjZuczlAxPUL0Wi8kqp21if7Ip237vfLEwPXnv5HK93Tf80Omftlh89IT2sDTaUYWLNQxJqrxZh52uQU2GV7l90DMSHMDBlN08GOZsLHpm+3E3AaiAm2z9Un0Ayzpj+4/px0oTlV5BVkePVvWJT0rC+z7x0Gr7oNRA6DSXDjaafYEE4Lmi4tQ5EkUtyNyfUZfeqohFe70ceUm57Fz9cklmEIrY49qXlQlFm8sLDw8VnvMg1KB7HaTnOLgT36KGDfbKIf+WkiVrVcC596hS75mjjfKWRFif2Id1LBLyceUPrehEk7mZRDCaD9/T2ru+zvYfjOB+tpuz9r+o+hG5/nz4eGgrrlM6nfZu0IcdsJafQC0rydWVI7Snu1OcDg1Lq0h89LJVISMQWv1LQ/4xIoq4SspyFSG732QkvTkuLOgw1XPxZ7vYlOhCo7O1y/GeiriqhOQZfszGHPPddT/lAtpwt/qtnvvPK+owPzpF/7ou33Qb1BV2Up1vzlJk8qB1M1QwTRdPgdAJ/1VYOqIEPkqA+OKgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(396003)(376002)(39860400002)(136003)(107886003)(30864003)(41300700001)(186003)(2906002)(6666004)(478600001)(8936002)(5660300002)(86362001)(6506007)(26005)(6512007)(9686003)(82960400001)(38100700002)(83380400001)(8676002)(54906003)(4326008)(66556008)(316002)(66476007)(66946007)(6486002)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tXGM6nNeg/vAtYCzKzAUR5gwJe4laPrFytlmQUlCOEVG+5Y3ULombSHuU8dK?=
 =?us-ascii?Q?4XW/NTpPIC2YN7VKB+Tky/pTqr0XRQ/y8/Zka9ADBCwkdJbtuOZpHAQ0Neoi?=
 =?us-ascii?Q?fWKIrjNRdpPjx0jJaiY2/EU3B/OJlyu5uj4AAWRs/a+RIhzEggEB7xQYIwpQ?=
 =?us-ascii?Q?4haTJ5063iGS4V2Wt9fZ7elIygF73MI1JtJT9VQ4btfHEIOy8mWpBNmRGDnT?=
 =?us-ascii?Q?nS80woI4DIP0I+OUFhnki5+8wIqfpWZ7Hi0McZaP+Xjk1svARElBCJL27tg5?=
 =?us-ascii?Q?3coiusPYZb3subJH+Aok0r/zKjTyUGjZdcm0tNNwKOrzp99suXtVa/jHM50A?=
 =?us-ascii?Q?lj7+xez1idYuYFMKAHvhRY/wyuCTGRbTK+UPbvwdfQE9K6xQ0se0zBq32F30?=
 =?us-ascii?Q?cz56XBjgy9eo8lN2KUVbZORI8sOUxqR6kAMd6sMLELVvnRJisnHg5uGG+2r0?=
 =?us-ascii?Q?eyXCaDDoBMR5rmh/jxVK6O0dD+ejSxEP/WYoN0szy01Z8kAft2dfHFXE8jSZ?=
 =?us-ascii?Q?h5ofMnKY+ERzHUKH7kccdjDQsAq2AYrr/riFy2cmO7W7hfYusy43/wzKBsk8?=
 =?us-ascii?Q?CtCyxlSzFcPXBBZQb0qM4J4LWkC6PsgWJZWkvnx6qLH2FO4p5Zt+Pl+soUoF?=
 =?us-ascii?Q?//f4aFV8E65q8uxaFx2nTRcmU9OcTYOEsDnEnnD/AtjeDcV/hgpxS3XHomy3?=
 =?us-ascii?Q?2vLGAm0udITkVy7dVb5YRJFjHXla2c0kl/xpvdcyA9UK8h9A/gx38FQtzKL2?=
 =?us-ascii?Q?m4hrRIEsnHuGJsixzqmTgFBH3yfRwx8k+fFL12NgXxGlhG2K+3i2gHWOj0Fh?=
 =?us-ascii?Q?i0Np2v1MSsAoK3HIalGw3dX/SuwxEo+8Q2wS9O4KYfEVrnnpx1tjzL4Gxys2?=
 =?us-ascii?Q?nLJsVmiT1qM2omUFzbRYEECjwk1bBaTHSeTuj7KVmiW9NZ4L1znf7m28fm7y?=
 =?us-ascii?Q?KQqMdZ8Sq1yYuAwLmDY9Nc2PFDyUmnRBoxgHeaWM+HnyiE9kbFopRguGIV41?=
 =?us-ascii?Q?WyZUGEqyPI/Jm3YHVsDXHlsJPB2i1Ci0ELC7FabcRU7HvURyXAW8FzPU1Kw7?=
 =?us-ascii?Q?0quG59AyWm5QqtJGLyDDF0oD55dA1uNwPPtUn9xrjDZ0i9cYB7vVOifLCOg9?=
 =?us-ascii?Q?u4FTKoTRHMvlw9R5Q2YTtD3wbwmcBh7yF1JMOmcqpKQXXxwxQsWXAVs64U2C?=
 =?us-ascii?Q?ZWJx4aAu3+OK+W7mEwGkiuOOpK6nCfNfdC0hGyJFQXk1kOdscxfu73MbhOs/?=
 =?us-ascii?Q?cChzRkxZ2gTeDVXmam3KM7A4qNXeDrYTBLBBf2X3DP09Siqbr66heI1d5kab?=
 =?us-ascii?Q?CqQwmcyiq2s0CAqfPL9Lwq2Jc6shkZ6XIMfPZ4kx6h+VwJo7H3HBb5DJyk04?=
 =?us-ascii?Q?v6c9ZHvNXeK/4pJQWvY0osMT/N6aXsaDUveAeMiILD8vypxGGS/i+hmmiNUG?=
 =?us-ascii?Q?2PUd/NWoCbl+CwwMZLD/fdq6ZzGgt/B/jgO7T8fnXGWQvVrdiYEjKAl56aiW?=
 =?us-ascii?Q?M1Fe8eEYc2oHdO8GoBB/OSfPQlkTqG5awTYPEX842R272clYORLkdbruzE3U?=
 =?us-ascii?Q?rLMJ/wu8zSB2+C61/7aVjzjqTUKvWWtK5jkC7VLjAg22xei+qJhjlhmcDH34?=
 =?us-ascii?Q?kA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 73537b2b-dc0e-479a-ee75-08da7bd07bfd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 19:34:19.2030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tpsE34AmatFVkyOpnT9EC74Bz88owart+BvW1Hq1IhyCaXDiV/M38NhXDxamoUpk0VFyP4izQni2DVWY18VXedjUrFj11kC/m8ps6/n4BQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4554
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Add a 'create-region' command to cxl-cli that walks the platform's CXL
> hierarchy to find an appropriate root decoder based on any options
> provided, and uses libcxl APIs to create a 'region' that is comprehended
> by libnvdimm and ndctl.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/cxl/bus-option.txt         |   5 +
>  Documentation/cxl/cxl-create-region.txt  | 114 +++++
>  Documentation/cxl/region-description.txt |   7 +
>  cxl/builtin.h                            |   1 +
>  cxl/filter.h                             |   4 +-
>  cxl/cxl.c                                |   1 +
>  cxl/region.c                             | 594 +++++++++++++++++++++++
>  Documentation/cxl/meson.build            |   2 +
>  cxl/meson.build                          |   1 +
>  9 files changed, 728 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/cxl/bus-option.txt
>  create mode 100644 Documentation/cxl/cxl-create-region.txt
>  create mode 100644 Documentation/cxl/region-description.txt
>  create mode 100644 cxl/region.c
> 
> diff --git a/Documentation/cxl/bus-option.txt b/Documentation/cxl/bus-option.txt
> new file mode 100644
> index 0000000..02e2f08
> --- /dev/null
> +++ b/Documentation/cxl/bus-option.txt
> @@ -0,0 +1,5 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +-b::
> +--bus=::
> +	Restrict the operation to the specified bus.
> diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
> new file mode 100644
> index 0000000..15dc742
> --- /dev/null
> +++ b/Documentation/cxl/cxl-create-region.txt
> @@ -0,0 +1,114 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +cxl-create-region(1)
> +====================
> +
> +NAME
> +----
> +cxl-create-region - Assemble a CXL region by setting up attributes of its
> +constituent CXL memdevs.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'cxl create-region [<options>]'
> +
> +include::region-description.txt[]
> +
> +For create-region, a size can optionally be specified, but if not, the maximum
> +possible size for each memdev will be used up to the available decode capacity
> +in the system for the given memory type. For persistent regions a UUID can
> +optionally be specified, but if not, one will be generated.
> +
> +If the region-creation operation is successful, a region object will be
> +emitted on stdout in JSON format (see examples). If the specified arguments
> +cannot be satisfied with a legal configuration, then an appropriate error will
> +be emitted on stderr.
> +
> +EXAMPLE
> +-------
> +----
> +# cxl create-region -m -d decoder0.1 -w 2 -g 1024 mem0 mem1
> +{
> +  "region":"region0",
> +  "resource":"0xc90000000",
> +  "size":"512.00 MiB (536.87 MB)",
> +  "interleave_ways":2,
> +  "interleave_granularity":1024,
> +  "mappings":[
> +    {
> +      "position":1,
> +      "decoder":"decoder4.0"
> +    },
> +    {
> +      "position":0,
> +      "decoder":"decoder3.0"
> +    }
> +  ]
> +}
> +created 1 region
> +----
> +
> +OPTIONS
> +-------
> +<target(s)>::
> +The CXL targets that should be used to form the region. This is optional,
> +as they can be chosen automatically based on other options chosen. The number of
> +'target' arguments must match the '--ways' option (if provided). The
> +targets may be memdevs, or endpoints. The options below control what type of
> +targets are being used.
> +
> +include::bus-option.txt[]
> +
> +-m::
> +--memdevs::
> +	Indicate that the non-option arguments for 'target(s)' refer to memdev
> +	names.

Are they names or filter parameters ala 'cxl list -m'? I.e. do you
foresee being able to do something like:

"cxl create-region -p $port -m all"

...to just select all the memdevs that are descendants of $port in the
future? More of a curiosity about future possibilities then a request
for change.

> +
> +-e::
> +--ep-decoders::
> +	Indicate that the non-option arguments for 'target(s)' refer to endpoint
> +	decoder names.

I wonder if this should have a note about it being for test-only
purposes? Given the strict CXL decoder allocation rules I wonder if
anyone can use this in practice? There might be some synergy with 'cxl
reserve-dpa' where this option could be used to say "do not allocate new
decoders, and do not reserve more DPA, just try to use the DPA that was
already reserved in the following decoders".

We might even delete this option for now unless I am missing the marquee
use case for it? Because unless someone knows what they are doing they
are almost always going to be wrong.

> +
> +-s::
> +--size=::
> +	Specify the total size for the new region. This is optional, and by
> +	default, the maximum possible size will be used.

How about add:

"The maximum possible size is gated by both the contiguous free HPA
space remaining in the root decoder, and the available DPA space in the
component memdevs."

> +
> +-t::
> +--type=::
> +	Specify the region type - 'pmem' or 'ram'. Defaults to 'pmem'.
> +
> +-U::
> +--uuid=::
> +	Specify a UUID for the new region. This shouldn't usually need to be
> +	specified, as one will be generated by default.
> +
> +-w::
> +--ways=::
> +	The number of interleave ways for the new region's interleave. This
> +	should be equal to the number of memdevs specified in --memdevs, if
> +	--memdevs is being supplied. If --memdevs is not specified, an
> +	appropriate number of memdevs will be chosen based on the number of
> +	ways specified.

The reverse is also true, right? That if -w is not specified then the
number of ways is determined by the number of targets specified, or by
other default target searches. I guess notes about those enhanced
default modes can wait until more 'create-region' porcelain arrives.

> +
> +-g::
> +--granularity=::
> +	The interleave granularity for the new region. Must match the selected
> +	root decoder's (if provided) granularity.

This just has me thinking that the kernel needs to up-level its code
comments and changelogs on the "why" for this restriction to somewhere
this man page can reference.

However second sentence should be:

"If the root decoder is interleaved across more than one host-bridge
then this value must match that granularity. Otherwise, for
non-interleaved decode windows, any granularity can be
specified as long as all devices support that setting."

As I type that it raises 2 questions:

1/ If someone does "cxl create-region -g 1024" with no other arguments,
will it fallback to a decoder that can support that setting if its first
choice can not?

2/ Per Dave's recent series [1], cxl-cli is missing any consideration
that a given endpoint may not have the support for the interleave
address bits that are necessary for a given 'create-region' request.
Does not need to be solved now, but should be queued up next.

2a/ Same for interleave-ways, there are endpoint capabilities that need
to be accounted.

[1]: https://lore.kernel.org/linux-cxl/165999244272.493131.1975513183227389633.stgit@djiang5-desk4.jf.intel.com/

> +
> +-d::
> +--decoder=::
> +	The root decoder that the region should be created under. If not
> +	supplied, the first cross-host bridge (if available), decoder that
> +	supports the largest interleave will be chosen.
> +
> +include::human-option.txt[]
> +
> +include::debug-option.txt[]
> +
> +include::../copyright.txt[]
> +
> +SEE ALSO
> +--------
> +linkcxl:cxl-list[1],
> diff --git a/Documentation/cxl/region-description.txt b/Documentation/cxl/region-description.txt
> new file mode 100644
> index 0000000..d7e3077
> --- /dev/null
> +++ b/Documentation/cxl/region-description.txt
> @@ -0,0 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +DESCRIPTION
> +-----------
> +A CXL region is composed of one or more slices of CXL memdevs, with configurable
> +interleave settings - both the number of interleave ways, and the interleave
> +granularity.
> diff --git a/cxl/builtin.h b/cxl/builtin.h
> index 9e6fc62..843bada 100644
> --- a/cxl/builtin.h
> +++ b/cxl/builtin.h
> @@ -18,4 +18,5 @@ int cmd_disable_port(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_enable_port(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_set_partition(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_disable_bus(int argc, const char **argv, struct cxl_ctx *ctx);
> +int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx);
>  #endif /* _CXL_BUILTIN_H_ */
> diff --git a/cxl/filter.h b/cxl/filter.h
> index 609433c..d22d8b1 100644
> --- a/cxl/filter.h
> +++ b/cxl/filter.h
> @@ -35,8 +35,10 @@ struct cxl_memdev *util_cxl_memdev_filter(struct cxl_memdev *memdev,
>  struct cxl_port *util_cxl_port_filter_by_memdev(struct cxl_port *port,
>  						const char *ident,
>  						const char *serial);
> -struct cxl_region *util_cxl_region_filter(struct cxl_region *region,
> +struct cxl_decoder *util_cxl_decoder_filter(struct cxl_decoder *decoder,
>  					    const char *__ident);
> +struct cxl_region *util_cxl_region_filter(struct cxl_region *region,
> +					  const char *__ident);
>  
>  enum cxl_port_filter_mode {
>  	CXL_PF_SINGLE,
> diff --git a/cxl/cxl.c b/cxl/cxl.c
> index ef4cda9..f0afcfe 100644
> --- a/cxl/cxl.c
> +++ b/cxl/cxl.c
> @@ -72,6 +72,7 @@ static struct cmd_struct commands[] = {
>  	{ "enable-port", .c_fn = cmd_enable_port },
>  	{ "set-partition", .c_fn = cmd_set_partition },
>  	{ "disable-bus", .c_fn = cmd_disable_bus },
> +	{ "create-region", .c_fn = cmd_create_region },
>  };
>  
>  int main(int argc, const char **argv)
> diff --git a/cxl/region.c b/cxl/region.c
> new file mode 100644
> index 0000000..8f455ab
> --- /dev/null
> +++ b/cxl/region.c
> @@ -0,0 +1,594 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2020-2022 Intel Corporation. All rights reserved. */
> +#include <stdio.h>
> +#include <errno.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <limits.h>
> +#include <util/log.h>
> +#include <uuid/uuid.h>
> +#include <util/json.h>
> +#include <util/size.h>
> +#include <cxl/libcxl.h>
> +#include <json-c/json.h>
> +#include <util/parse-options.h>
> +#include <ccan/minmax/minmax.h>
> +#include <ccan/short_types/short_types.h>
> +
> +#include "filter.h"
> +#include "json.h"
> +
> +static struct region_params {
> +	const char *bus;
> +	const char *size;
> +	const char *ways;
> +	const char *granularity;
> +	const char *type;
> +	const char *root_decoder;
> +	const char *region;
> +	bool memdevs;
> +	bool ep_decoders;
> +	bool force;
> +	bool human;
> +	bool debug;
> +} param;
> +
> +struct parsed_params {
> +	u64 size;
> +	u64 ep_min_size;
> +	unsigned int ways;
> +	unsigned int granularity;
> +	const char **targets;
> +	int num_targets;
> +	struct cxl_decoder *root_decoder;
> +	enum cxl_decoder_mode mode;
> +};
> +
> +enum region_actions {
> +	ACTION_CREATE,
> +};
> +
> +static struct log_ctx rl;
> +
> +#define BASE_OPTIONS() \
> +OPT_STRING('b', "bus", &param.bus, "bus name", \
> +	   "Limit operation to the specified bus"), \
> +OPT_STRING('d', "decoder", &param.root_decoder, "root decoder name", \
> +	   "Limit to / use the specified root decoder"), \
> +OPT_BOOLEAN(0, "debug", &param.debug, "turn on debug")
> +
> +#define CREATE_OPTIONS() \
> +OPT_STRING('s', "size", &param.size, \
> +	   "size in bytes or with a K/M/G etc. suffix", \
> +	   "total size desired for the resulting region."), \
> +OPT_STRING('w', "ways", &param.ways, \
> +	   "number of interleave ways", \
> +	   "number of memdevs participating in the regions interleave set"), \
> +OPT_STRING('g', "granularity", \
> +	   &param.granularity, "interleave granularity", \
> +	   "granularity of the interleave set"), \
> +OPT_STRING('t', "type", &param.type, \
> +	   "region type", "region type - 'pmem' or 'ram'"), \
> +OPT_BOOLEAN('m', "memdevs", &param.memdevs, \
> +	    "non-option arguments are memdevs"), \
> +OPT_BOOLEAN('e', "ep-decoders", &param.ep_decoders, \
> +	    "non-option arguments are endpoint decoders"), \
> +OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats")
> +
> +static const struct option create_options[] = {
> +	BASE_OPTIONS(),
> +	CREATE_OPTIONS(),
> +	OPT_END(),
> +};
> +
> +
> +
> +static int parse_create_options(int argc, const char **argv,
> +				struct parsed_params *p)
> +{
> +	int i;
> +
> +	if (!param.root_decoder) {
> +		log_err(&rl, "no root decoder specified\n");
> +		return -EINVAL;
> +	}
> +
> +	if (param.type) {
> +		if (strcmp(param.type, "ram") == 0)
> +			p->mode = CXL_DECODER_MODE_RAM;
> +		else if (strcmp(param.type, "volatile") == 0)
> +			p->mode = CXL_DECODER_MODE_RAM;
> +		else if (strcmp(param.type, "pmem") == 0)
> +			p->mode = CXL_DECODER_MODE_PMEM;
> +		else {
> +			log_err(&rl, "unsupported type: %s\n", param.type);
> +			return -EINVAL;

This probably wants a common helper that can be shared with
__reserve_dpa() and add_cxl_decoder() that do the same conversion. I.e.
cxl_decoder_mode_name() needs a buddy. That can be a follow on change.
ISTR I might have already noted that, so forgive the duplicate comment.

> +		}
> +	} else
> +		p->mode = CXL_DECODER_MODE_PMEM;
> +
> +	if (param.size) {
> +		p->size = parse_size64(param.size);
> +		if (p->size == ULLONG_MAX) {
> +			log_err(&rl, "Invalid size: %s\n", param.size);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (param.ways) {
> +		unsigned long ways = strtoul(param.ways, NULL, 0);
> +
> +		if (ways == ULONG_MAX || (int)ways <= 0) {
> +			log_err(&rl, "Invalid interleave ways: %s\n",
> +				param.ways);
> +			return -EINVAL;
> +		}
> +		p->ways = ways;
> +	} else if (argc) {
> +		p->ways = argc;

This is where:

    cxl create-region -p $port -m all

...would not work, but maybe requiring explicit targets is ok. There's
so many potential moving pieces in a CXL topology maybe we do not want
to go there with this flexibility.

> +	} else {
> +		log_err(&rl,
> +			"couldn't determine interleave ways from options or arguments\n");
> +		return -EINVAL;
> +	}
> +
> +	if (param.granularity) {
> +		unsigned long granularity = strtoul(param.granularity, NULL, 0);
> +
> +		if (granularity == ULONG_MAX || (int)granularity <= 0) {
> +			log_err(&rl, "Invalid interleave granularity: %s\n",
> +				param.granularity);
> +			return -EINVAL;
> +		}
> +		p->granularity = granularity;
> +	}
> +
> +
> +	if (argc > (int)p->ways) {
> +		for (i = p->ways; i < argc; i++)
> +			log_err(&rl, "extra argument: %s\n", p->targets[i]);
> +		return -EINVAL;
> +	}
> +
> +	if (argc < (int)p->ways) {
> +		log_err(&rl,
> +			"too few target arguments (%d) for interleave ways (%u)\n",
> +			argc, p->ways);
> +		return -EINVAL;
> +	}
> +
> +	if (p->size && p->ways) {
> +		if (p->size % p->ways) {
> +			log_err(&rl,
> +				"size (%lu) is not an integral multiple of interleave-ways (%u)\n",
> +				p->size, p->ways);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int parse_region_options(int argc, const char **argv,
> +				struct cxl_ctx *ctx, enum region_actions action,
> +				const struct option *options,
> +				struct parsed_params *p, const char *usage)
> +{
> +	const char * const u[] = {
> +		usage,
> +		NULL
> +	};
> +
> +	argc = parse_options(argc, argv, options, u, 0);
> +	p->targets = argv;
> +	p->num_targets = argc;
> +
> +	if (param.debug) {
> +		cxl_set_log_priority(ctx, LOG_DEBUG);
> +		rl.log_priority = LOG_DEBUG;
> +	} else
> +		rl.log_priority = LOG_INFO;
> +
> +	switch(action) {
> +	case ACTION_CREATE:
> +		return parse_create_options(argc, argv, p);
> +	default:
> +		return 0;
> +	}
> +}
> +
> +/**
> + * validate_memdev() - match memdev with the target provided,
> + *                     and determine its size contribution
> + * @memdev: cxl_memdev being tested for a match against the named target
> + * @target: target memdev from user (either directly, or deduced via
> + *          endpoint decoder
> + * @p:      params structure
> + *
> + * This is called for each memdev in the system, and only returns 'true' if
> + * the memdev name matches the target argument being tested. Additionally,
> + * it sets an ep_min_size attribute that always contains the size of the
> + * smallest target in the provided list. This is used during the automatic
> + * size determination later, to ensure that all targets contribute equally
> + * to the region in case of unevenly sized memdevs.
> + */
> +static bool validate_memdev(struct cxl_memdev *memdev, const char *target,
> +			    struct parsed_params *p)
> +{
> +	const char *devname = cxl_memdev_get_devname(memdev);
> +	u64 size;
> +
> +	if (strcmp(devname, target) != 0)
> +		return false;
> +
> +	size = cxl_memdev_get_pmem_size(memdev);
> +	if (!p->ep_min_size)
> +		p->ep_min_size = size;
> +	else
> +		p->ep_min_size = min(p->ep_min_size, size);
> +
> +	return true;
> +}
> +
> +static int validate_config_memdevs(struct cxl_ctx *ctx, struct parsed_params *p)
> +{
> +	unsigned int i, matched = 0;
> +
> +	for (i = 0; i < p->ways; i++) {
> +		struct cxl_memdev *memdev;
> +
> +		cxl_memdev_foreach(ctx, memdev)
> +			if (validate_memdev(memdev, p->targets[i], p))
> +				matched++;
> +	}
> +	if (matched != p->ways) {
> +		log_err(&rl,
> +			"one or more memdevs not found in CXL topology\n");
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int validate_config_ep_decoders(struct cxl_ctx *ctx,
> +				   struct parsed_params *p)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < p->ways; i++) {
> +		struct cxl_decoder *decoder;
> +		struct cxl_memdev *memdev;
> +
> +		decoder = cxl_decoder_get_by_name(ctx, p->targets[i]);
> +		if (!decoder) {
> +			log_err(&rl, "%s not found in CXL topology\n",
> +				p->targets[i]);
> +			return -ENXIO;
> +		}
> +
> +		memdev = cxl_ep_decoder_get_memdev(decoder);
> +		if (!memdev) {
> +			log_err(&rl, "could not get memdev from %s\n",
> +				p->targets[i]);
> +			return -ENXIO;
> +		}
> +
> +		if (!validate_memdev(memdev, cxl_memdev_get_devname(memdev), p))
> +			return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int validate_decoder(struct cxl_decoder *decoder,
> +			    struct parsed_params *p)
> +{
> +	const char *devname = cxl_decoder_get_devname(decoder);
> +
> +	switch(p->mode) {
> +	case CXL_DECODER_MODE_RAM:
> +		if (!cxl_decoder_is_volatile_capable(decoder)) {
> +			log_err(&rl, "%s is not volatile capable\n", devname);
> +			return -EINVAL;
> +		}
> +		break;
> +	case CXL_DECODER_MODE_PMEM:
> +		if (!cxl_decoder_is_pmem_capable(decoder)) {
> +			log_err(&rl, "%s is not pmem capable\n", devname);
> +			return -EINVAL;
> +		}
> +		break;
> +	default:
> +		log_err(&rl, "unknown type: %s\n", param.type);
> +		return -EINVAL;
> +	}
> +
> +	/* TODO check if the interleave config is possible under this decoder */
> +
> +	return 0;
> +}
> +
> +static int create_region_validate_config(struct cxl_ctx *ctx,
> +					 struct parsed_params *p)
> +{
> +	struct cxl_bus *bus;
> +	int rc;
> +
> +	cxl_bus_foreach(ctx, bus) {
> +		struct cxl_decoder *decoder;
> +		struct cxl_port *port;
> +
> +		if (!util_cxl_bus_filter(bus, param.bus))
> +			continue;
> +
> +		port = cxl_bus_get_port(bus);
> +		if (!cxl_port_is_root(port))
> +			continue;
> +
> +		cxl_decoder_foreach (port, decoder) {
> +			if (util_cxl_decoder_filter(decoder,
> +						    param.root_decoder)) {
> +				p->root_decoder = decoder;
> +				goto found;
> +			}
> +		}
> +	}
> +
> +found:
> +	if (p->root_decoder == NULL) {
> +		log_err(&rl, "%s not found in CXL topology\n",
> +			param.root_decoder);
> +		return -ENXIO;
> +	}
> +
> +	rc = validate_decoder(p->root_decoder, p);
> +	if (rc)
> +		return rc;
> +
> +	if (param.memdevs)
> +		return validate_config_memdevs(ctx, p);
> +
> +	return validate_config_ep_decoders(ctx, p);
> +}
> +
> +static struct cxl_decoder *
> +cxl_memdev_target_find_decoder(struct cxl_ctx *ctx, const char *memdev_name)
> +{
> +	struct cxl_endpoint *ep = NULL;
> +	struct cxl_decoder *decoder;
> +	struct cxl_memdev *memdev;
> +	struct cxl_port *port;
> +
> +	cxl_memdev_foreach(ctx, memdev) {
> +		const char *devname = cxl_memdev_get_devname(memdev);
> +
> +		if (strcmp(devname, memdev_name) != 0)
> +			continue;
> +
> +		ep = cxl_memdev_get_endpoint(memdev);
> +	}
> +
> +	if (!ep) {
> +		log_err(&rl, "could not get an endpoint for %s\n",
> +			memdev_name);
> +		return NULL;
> +	}
> +
> +	port = cxl_endpoint_get_port(ep);
> +	if (!port) {
> +		log_err(&rl, "could not get a port for %s\n",
> +			memdev_name);
> +		return NULL;
> +	}
> +
> +	cxl_decoder_foreach(port, decoder)
> +		if (cxl_decoder_get_size(decoder) == 0)
> +			return decoder;
> +
> +	log_err(&rl, "could not get a free decoder for %s\n", memdev_name);
> +	return NULL;
> +}
> +
> +#define try(prefix, op, dev, p) \
> +do { \
> +	int __rc = prefix##_##op(dev, p); \
> +	if (__rc) { \
> +		log_err(&rl, "%s: " #op " failed: %s\n", \
> +				prefix##_get_devname(dev), \
> +				strerror(abs(__rc))); \
> +		rc = __rc; \
> +		goto err_delete; \
> +	} \
> +} while (0)
> +
> +static int cxl_region_determine_granularity(struct cxl_region *region,
> +					    struct parsed_params *p)
> +{
> +	const char *devname = cxl_region_get_devname(region);
> +	unsigned int granularity, ways;
> +
> +	/* Default granularity will be the root decoder's granularity */
> +	granularity = cxl_decoder_get_interleave_granularity(p->root_decoder);
> +	if (granularity == 0 || granularity == UINT_MAX) {
> +		log_err(&rl, "%s: unable to determine root decoder granularity\n",
> +			devname);
> +		return -ENXIO;
> +	}
> +
> +	/* If no user-supplied granularity, just use the default */
> +	if (!p->granularity)
> +		return granularity;
> +
> +	ways = cxl_decoder_get_interleave_ways(p->root_decoder);
> +	if (ways == 0 || ways == UINT_MAX) {
> +		log_err(&rl, "%s: unable to determine root decoder ways\n",
> +			devname);
> +		return -ENXIO;
> +	}
> +
> +	/* For ways == 1, any user-supplied granularity is fine */

...modulo a future patch that checks the device's interleave capability.

Rest of the patch looks good. After fixing up the option descriptions
per above you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
