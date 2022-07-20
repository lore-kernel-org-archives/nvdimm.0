Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3957B
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 02:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658282410; x=1689818410;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3EZiF2CEzfM7yrDOEt7SfC/LznP/OA4YtITw3pVGp3Q=;
  b=QJszeIG9lUXF6i/I5PmnVVmaBkhkvmVgGnfeTd8dWjXxyuTVx081ogWi
   R+PoeuG8eyL6UoOTu2RExs8FPUYkablqs/D8dq956kDOAjJNkhSEnn1wn
   aWNda8MI+QkCqCUo6HX2g3y5VY311FLDclHxNdAkqwszXiDLhT7LkOrUw
   DimYCm21qfWkQSuEZRbhgahAYOI9MnO0fRxSOTszKTmETKHvPX8SjMfti
   AufFMU7wInzDN1BQmpXtK5gN4kooHsVk58Cf4f91Dhw8cPY6i1j3AfMdX
   KuCYdiOqNVhMRDgYZEesV2c6Q7qoJ6ISIa0mTzM7FNHU4yUNEIRYcw6Ga
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="348349953"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="348349953"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 19:00:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="724481341"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 19 Jul 2022 19:00:09 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 19 Jul 2022 19:00:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 19 Jul 2022 19:00:09 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 19 Jul 2022 19:00:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GHF4lTXJg9LwyTm6SnzNX2gCWWwxt5B/quYhDV9Vd67K6hHsuihX1A4d0RucAjz4tqqp37s2hd66fuHlsq87Zmu3gQYodgNo8HmkWDeGSfoX2+Z5nfyw5Nc33eiM1yrOBqxId6GfKuacV/83hN8HuQy51n0XYwF/Wt+F1fCtCbQfzO1FokY4UlqNzhBQzJSOtP+Rtyhi/RcfXDv7IscsvkEz2KnDQ7YWMwGKkXFt15pef13f3co7c08ayQmpFMnBe1srBBDGxICO6WXYlT++56tn+kPv0NoXugPwjdwA0X2eVJcBoiil196SG5t5j97JW6iU1CXSAJvOQcCoOpZijw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UHSPeFbJoYjFbDOmotBoyYM2YCGHXICybCMFXFnSLzQ=;
 b=jcL1/jH6fm64cLIfYCdfHbCgT6BVcoODGdKJ0FovoY+pfis4EFZ0iXMZHnDhYgb+0QC4SrETAslKwEC40ej3EFJw+O8E7cPR7kqvlQ+EBcF2QBMC0ZqPMJtzL/q8xyYFyLOKM98Pb6eyywDx95ip8m73BcP8V3X0XFPieDPtBVj0V2Q/LvacHyDgq5iptHCrUGdMYd9dvwmph3ycbmLAfVMu8LES9odGohaV985xh2ARPJ9RRCh2SJYvXlh2LA/fEHtkYXDOgK3HPcKNiEDyd9FYnxLrNd/P1xiKgAUybH5KG6C3n+pnat5qay6FjrQxeyxl4qJ07dc5SwpuUZbUFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM6PR11MB2602.namprd11.prod.outlook.com
 (2603:10b6:5:c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Wed, 20 Jul
 2022 02:00:06 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5438.024; Wed, 20 Jul
 2022 02:00:06 +0000
Date: Tue, 19 Jul 2022 19:00:04 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"Dave Jiang" <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH 6/8] cxl: add a 'create-region' command
Message-ID: <62d761a43f30c_11a1662949a@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220715062550.789736-1-vishal.l.verma@intel.com>
 <20220715062550.789736-7-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220715062550.789736-7-vishal.l.verma@intel.com>
X-ClientProxiedBy: BYAPR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::35) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 391e1973-5455-437c-547f-08da69f3914f
X-MS-TrafficTypeDiagnostic: DM6PR11MB2602:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pTV3TGgNty883lUD1nLhIt7QkK8LVe7qmdJRjVz8C3P3fk84NY7aJB28QQ1EGPF90tLkTazsdzWdPMPKlEtvMmHaVvi5C7W1BzlZNz9bnqVpCEZqG64HYM+EZdlVFCZjfqk3vu1nHv9BZAZwbKfMgf4WaPqKvmJ5NSOvNTOa1LvGa7wWbDj/+yaOnO+dcnIcrh8i+kC302lDtJF3R1ee50qyiwlfQ3oLKi0UVO68xqzsXpjVczqWmYVbvYNP/sqj5s+2ClezDJJ94GS44WQjNARf0WVSTKmJd6kcWZFVLugb94Pm88vLllCylEdLOT/d+jcS6visLGHDxNw6GXDGnFn7TdHbyycmK+CE9lz3ssI0/MJwWwGcrUp0QwenJJMuGp62wdgNlYtHedgObcyQ1A1WqBKumwTgYLV0Sowz7PGQw+89LvGtTmG5p8JkqWH6ucECgH+bDgmsJBRdsX6cNTniWtHcLcjqNoRC5wMDEGZ8sA2Cd6QLpGx2VC8RM6SD4T75Z17e/KJQK2winaETbMueo6UADc65Bx6rO1Z3PCKxDhxvcIn5TZHZipFF+9AQXo98+kBjjV2t5JIh+BqdTlJWtGLe1k+kgnvIOMSNqTM7WlYsR/Qawto4w7M+j4k3z0e3dJkI2EHxwu67ILe2+Xx0IdBmrE8D64L3DaRSGRMbxDXIJbPpiNzE1cnYyugCFVIluuI3Kzk3eraeUMUYQFOg+oNfr3p63kjKWkVEz5VjzKcvUBbQk5K+l4A3RMln
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(376002)(366004)(39860400002)(396003)(107886003)(41300700001)(186003)(9686003)(316002)(26005)(6512007)(2906002)(6486002)(478600001)(30864003)(83380400001)(5660300002)(66946007)(8676002)(4326008)(66556008)(66476007)(8936002)(86362001)(82960400001)(38100700002)(54906003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yNvpd8lUa11eOIbZ9YCjCOrMqfEONwZLb1upRdhl51iLSBACbTVFNKZvY4ii?=
 =?us-ascii?Q?xvEfoWYepkmkRN7Zx27zBGq2rPX8mBDsuBmexn1ve/vcVvNFvEMPDt8L5F0Z?=
 =?us-ascii?Q?A5236LKsbNT2+FtWbhOiXWYD/kKn4Z9W0Cy07NRVS6pEOxpA0TRC/Se1+gcy?=
 =?us-ascii?Q?DDdJsA23yKVnDgrNHnf1KfMnV5eesb36+5JTmoBQ7iWu9/18BvH86jnvOCb6?=
 =?us-ascii?Q?H6uAUphb1IdLtQEz/HY73YFCTMIyKpxdcihmPdJYx/+pe8zTOO5DMoIzFim3?=
 =?us-ascii?Q?wXrvOqeROCishO0lgJRIUtiKfhrl6Lf89IPDCrdKeEnTqvBYFzNTbjf+Ug2J?=
 =?us-ascii?Q?I47wxireQcNwe/mE9GUT/tu3h8cTpJMhk10wqFZOwr6CXm0aE5zHBRInV58y?=
 =?us-ascii?Q?YntfYQK5swUeDQnxtrcfRtDoXT8V4KcWOlTo7kgEcogozwMP6mMLtWVnFZGR?=
 =?us-ascii?Q?1t6kF1AZ3Gh4i5OyXxAhodPFdiqOo0G4baYji0W/pKw7TCU+spZhFN5wSif/?=
 =?us-ascii?Q?A5QcDVe5Fatpu4vkkjvWlRRW5QG+GmSBAlPaux2CdCVT+mOzjtQ4A7vDhNQq?=
 =?us-ascii?Q?g0EaKZJEV5kI86GXwPbjkgXxbVb1eeuAlxv+FAVrU33gMad4hmj8ldZI+YjN?=
 =?us-ascii?Q?ee1KTibGVrEFnSL1ipIKIvf7UCRvCDB72eL8B8BDi0Aqlb7hyGxC/ufOBtwU?=
 =?us-ascii?Q?1gCDcdEX9GRWDmTSPWcgpmMqgD06r8fS1yTmxkvWAhH55s7qpXRxvPQhIkSb?=
 =?us-ascii?Q?A5ZuEZY8DMg5TAemCbXsnDZx3YSts1sRdcWbF1pnqZCj9NIZllJyowitpkzf?=
 =?us-ascii?Q?Gg2lfr5F0Wj8lfBR7Uh9L+GbyC364PkRg+4S2rwL1f0Gode+3n1b1YrIbgJp?=
 =?us-ascii?Q?LE+fJMlZ8aIqKHd38RWcZ/0VZdGQdTMC1T9WXZJAlqkk450apm/ABjkeTNr4?=
 =?us-ascii?Q?6aQSv8oYH6+6mzZy8+c+EDdebEva5Y5buCAUnBMNee4bjFI3AHThrD6Lk8R+?=
 =?us-ascii?Q?VNbggUscvkmGrnTBy5pnKhx8LgpPX5Or9Umw71ZNu/OSnOZ9CCCBQwvcCBfA?=
 =?us-ascii?Q?rHLyfOVLdd/If0a2rSQ3JQGPYam9FX5RrTIRg0zKPdetCYHG23XDuRdTbHBZ?=
 =?us-ascii?Q?R4KfZUDeXSY/tFuA4aNqbrzVVAru+4oxYIuMagE/N2QIPSxFq7oyT1tboyt6?=
 =?us-ascii?Q?xGvDuZ5qAsQoJUqcfAqe3z8iES6UHVsEOUNFGJ9Qyw3AiU44/cLHRQkPkIhz?=
 =?us-ascii?Q?kWuEREbrbFZKBDeT4IYJYQ7RhJI/khfKHC7AgTMO0T0dxaq3DwQSh4N8McAq?=
 =?us-ascii?Q?xrgRuBoqNKnDkWtHT96hCkTIzQpKd6i2klZsuFlCLIgMh8cjc0NBeq/4oNlg?=
 =?us-ascii?Q?wsPwDJBd2JSSbVaer+dRSgI5Lm/fcg76ezBweHq/0hFOwEkQ9EERJvFwsJLZ?=
 =?us-ascii?Q?FKpilH+ltsFau6f+efh2FmTM2yc1Lpd4yD1wWLyDno9mjBoaLh40XBYA/TLs?=
 =?us-ascii?Q?7uM0qRhVT3bk6iN3M/QAdTI6/fVY/5xAsx7xhKj8vj3A4RKf+sLzXeOsO4bx?=
 =?us-ascii?Q?887cBDBZ+e7INCbCG354NBhRdw+qByv8TnCpkXJwcfDgpE2H+cGIvYc4iPt5?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 391e1973-5455-437c-547f-08da69f3914f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 02:00:06.4398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nT+n0rgoYg1pbJQDq/TtamWzHlv5yFt3h3390X75hlj/9pWrkeyNhCd3mpmp1TQe4BxwF4gsYVfWQcd4QxFOzyBE16rJMVOsHy7bjuMFVLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2602
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
>  Documentation/cxl/cxl-create-region.txt  | 111 +++++
>  Documentation/cxl/region-description.txt |   7 +
>  cxl/builtin.h                            |   1 +
>  cxl/filter.h                             |   4 +-
>  cxl/cxl.c                                |   1 +
>  cxl/region.c                             | 527 +++++++++++++++++++++++
>  Documentation/cxl/meson.build            |   2 +
>  cxl/meson.build                          |   1 +
>  8 files changed, 653 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/cxl/cxl-create-region.txt
>  create mode 100644 Documentation/cxl/region-description.txt
>  create mode 100644 cxl/region.c
> 
> diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
> new file mode 100644
> index 0000000..d91d76a
> --- /dev/null
> +++ b/Documentation/cxl/cxl-create-region.txt
> @@ -0,0 +1,111 @@
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
> +'target' arguments must match the '--interleave-ways' option (if provided). The
> +targets may be memdevs, or endpoints. The options below control what type of
> +targets are being used.
> +
> +-m::
> +--memdevs::
> +	Indicate that the non-option arguments for 'target(s)' refer to memdev
> +	names.
> +
> +-e::
> +--ep-decoders::
> +	Indicate that the non-option arguments for 'target(s)' refer to endpoint
> +	decoder names.
> +
> +-s::
> +--size=::
> +	Specify the total size for the new region. This is optional, and by
> +	default, the maximum possible size will be used.
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
> +--interleave-ways=::
> +	The number of interleave ways for the new region's interleave. This
> +	should be equal to the number of memdevs specified in --memdevs, if
> +	--memdevs is being supplied. If --memdevs is not specified, an
> +	appropriate number of memdevs will be chosen based on the number of
> +	interleave-ways specified.
> +
> +-g::
> +--interleave-granularity=::
> +	The interleave granularity, for the new region's interleave.
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
> index 0000000..9fe99b2
> --- /dev/null
> +++ b/cxl/region.c
> @@ -0,0 +1,527 @@
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
> +OPT_STRING('d', "decoder", &param.root_decoder, "root decoder name", \
> +	   "Limit to / use the specified root decoder"), \
> +OPT_BOOLEAN(0, "debug", &param.debug, "turn on debug")
> +
> +#define CREATE_OPTIONS() \
> +OPT_STRING('s', "size", &param.size, \
> +	   "size in bytes or with a K/M/G etc. suffix", \
> +	   "total size desired for the resulting region."), \
> +OPT_STRING('w', "interleave-ways", &param.ways, \
> +	   "number of interleave ways", \
> +	   "number of memdevs participating in the regions interleave set"), \
> +OPT_STRING('g', "interleave-granularity", \

I think it's ok to drop 'interleave-' out of these 2 options.

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

Follow-on cleanup opportunity to have a string-mode-helper alongside
cxl_decoder_mode_name() as this same pattern appears in
add_cxl_decoder() and __reserve_dpa().

> +		else {
> +			log_err(&rl, "unsupported type: %s\n", param.type);
> +			return -EINVAL;
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
> +        argc = parse_options(argc, argv, options, u, 0);

clang-format escape?

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
> +static bool memdev_match_set_size(struct cxl_memdev *memdev, const char *target,
> +			    struct parsed_params *p)
> +{
> +	const char *devname = cxl_memdev_get_devname(memdev);
> +	u64 size = cxl_memdev_get_pmem_size(memdev);

Since the type option exists should this be gated by that now? Otherwise
just a reminder of a place to fixup when volatile region provisioning
arrives.

> +
> +	if (strcmp(devname, target) != 0)
> +		return false;
> +
> +	size = cxl_memdev_get_pmem_size(memdev);

Hmm double-init? It was already retrieved above.

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
> +			if (memdev_match_set_size(memdev, p->targets[i], p))

I am not sure memdev_match_set_size() is named properly for what it is
doing. It's also scanning for a min size? I think I'm just missing a
comment about where memdev_match_set_size() fits into the flow.

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
> +		if (!memdev_match_set_size(memdev,
> +					   cxl_memdev_get_devname(memdev), p))
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
> +static int create_region(struct cxl_ctx *ctx, int *count,
> +			 struct parsed_params *p)
> +{
> +	unsigned long flags = UTIL_JSON_TARGETS;
> +	struct json_object *jregion;
> +	unsigned int i, granularity;
> +	struct cxl_region *region;
> +	const char *devname;
> +	uuid_t uuid;
> +	u64 size;
> +	int rc;
> +
> +	rc = create_region_validate_config(ctx, p);
> +	if (rc)
> +		return rc;
> +
> +	if (p->size) {
> +		size = p->size;
> +	} else if (p->ep_min_size) {
> +		size = p->ep_min_size * p->ways;

Here is where it would help to pre-validate that the requested size is
<= the available root decoder capacity and <= the max available extent.

I also wonder if it is worth augmenting all checks with a --force
override to give the option of "yes, I expect the kernel will reject
this, but lets try and see if the kernel actually does". That can be
another item for the backlog.

> +	} else {
> +		log_err(&rl, "%s: unable to determine region size\n", __func__);
> +		return -ENXIO;
> +	}
> +
> +	if (p->mode == CXL_DECODER_MODE_PMEM) {
> +		region = cxl_decoder_create_pmem_region(p->root_decoder);
> +		if (!region) {
> +			log_err(&rl, "failed to create region under %s\n",
> +				param.root_decoder);
> +			return -ENXIO;
> +		}
> +	} else {
> +		log_err(&rl, "region type '%s' not supported yet\n",
> +			param.type);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	devname = cxl_region_get_devname(region);
> +
> +	/* Default granularity will be the root decoder's granularity */
> +	granularity = cxl_decoder_get_interleave_granularity(p->root_decoder);
> +	if (granularity == 0 || granularity == UINT_MAX) {
> +		log_err(&rl, "%s: unable to determine root decoder granularity\n",
> +			devname);
> +		return -ENXIO;
> +	}
> +
> +	/* If the user supplied granularity was > the default, use it instead */
> +	if (p->granularity && (p->granularity > granularity))
> +		granularity = p->granularity;

Where does this check that the granularity is not smaller than the
region granularity? The kernel, for now, will fail that.

> +
> +	uuid_generate(uuid);
> +	try(cxl_region, set_interleave_granularity, region, granularity);
> +	try(cxl_region, set_interleave_ways, region, p->ways);
> +	try(cxl_region, set_size, region, size);
> +	try(cxl_region, set_uuid, region, uuid);
> +
> +	for (i = 0; i < p->ways; i++) {
> +		struct cxl_decoder *ep_decoder = NULL;
> +
> +		if (param.ep_decoders) {
> +			ep_decoder =
> +				cxl_decoder_get_by_name(ctx, p->targets[i]);
> +		} else if (param.memdevs) {
> +			ep_decoder = cxl_memdev_target_find_decoder(
> +				ctx, p->targets[i]);
> +		}
> +		if (!ep_decoder) {
> +			rc = -ENXIO;
> +			goto err_delete;
> +		}
> +		if (cxl_decoder_get_mode(ep_decoder) != p->mode) {

This feels like it wants to be a --force operation rather than silently
fixing up the decoder if it was already set to something else.

> +			try(cxl_decoder, set_dpa_size, ep_decoder, 0);
> +			try(cxl_decoder, set_mode, ep_decoder, p->mode);
> +		}
> +		try(cxl_decoder, set_dpa_size, ep_decoder, size/p->ways);
> +		rc = cxl_region_set_target(region, i, ep_decoder);
> +		if (rc) {
> +			log_err(&rl, "%s: failed to set target%d to %s\n",
> +				devname, i, p->targets[i]);
> +			goto err_delete;
> +		}
> +	}
> +
> +	rc = cxl_region_commit(region);
> +	if (rc) {
> +		log_err(&rl, "%s: failed to commit: %s\n", devname,
> +			strerror(-rc));
> +		goto err_delete;
> +	}
> +
> +	rc = cxl_region_enable(region);
> +	if (rc) {
> +		log_err(&rl, "%s: failed to enable: %s\n", devname,
> +			strerror(-rc));
> +		goto err_delete;
> +	}
> +	*count = 1;
> +
> +	if (isatty(1))
> +		flags |= UTIL_JSON_HUMAN;
> +	jregion = util_cxl_region_to_json(region, flags);
> +	if (jregion)
> +		printf("%s\n", json_object_to_json_string_ext(jregion,
> +					JSON_C_TO_STRING_PRETTY));
> +
> +	return 0;
> +
> +err_delete:
> +	cxl_region_delete(region);
> +	return rc;
> +}
> +
> +static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
> +			 enum region_actions action,
> +			 const struct option *options, struct parsed_params *p,
> +			 int *count, const char *u)
> +{
> +	int rc = -ENXIO;
> +
> +	log_init(&rl, "cxl region", "CXL_REGION_LOG");
> +	rc = parse_region_options(argc, argv, ctx, action, options, p, u);
> +	if (rc)
> +		return rc;
> +
> +	if (action == ACTION_CREATE)

Missing '{'?

I guess this must be fixed in a later patch?

> +		return create_region(ctx, count, p);
> +	}
> +
> +	return rc;
> +}
> +
> +int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx)
> +{
> +	const char *u = "cxl create-region <target0> ... [<options>]";
> +	struct parsed_params p = { 0 };
> +	int rc, count = 0;
> +
> +	rc = region_action(argc, argv, ctx, ACTION_CREATE, create_options, &p,
> +			   &count, u);
> +	log_info(&rl, "created %d region%s\n", count, count == 1 ? "" : "s");
> +	return rc == 0 ? 0 : EXIT_FAILURE;
> +}
> diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
> index 423be90..340cdee 100644
> --- a/Documentation/cxl/meson.build
> +++ b/Documentation/cxl/meson.build
> @@ -23,6 +23,7 @@ filedeps = [
>    'memdev-option.txt',
>    'labels-options.txt',
>    'debug-option.txt',
> +  'region-description.txt',
>  ]
>  
>  cxl_manpages = [
> @@ -39,6 +40,7 @@ cxl_manpages = [
>    'cxl-set-partition.txt',
>    'cxl-reserve-dpa.txt',
>    'cxl-free-dpa.txt',
> +  'cxl-create-region.txt',
>  ]
>  
>  foreach man : cxl_manpages
> diff --git a/cxl/meson.build b/cxl/meson.build
> index d63dcb1..f2474aa 100644
> --- a/cxl/meson.build
> +++ b/cxl/meson.build
> @@ -3,6 +3,7 @@ cxl_src = [
>    'list.c',
>    'port.c',
>    'bus.c',
> +  'region.c',
>    'memdev.c',
>    'json.c',
>    'filter.c',
> -- 
> 2.36.1
> 


