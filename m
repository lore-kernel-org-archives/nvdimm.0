Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA7F538C
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 23:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657927364; x=1689463364;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wpS25EWcNIGZ113dQ5oXDwnxUJw90OdgW04v9z+/g24=;
  b=iq/yFstdifRiACRf171SpcgqbO3SIxfPXf5REcwnu9g82dXX0qSlFA1P
   JgtzM7pVEnpe3rj/gU0066LnLizIqzHTp/0T3ABb3yt9Fix7UVbij3942
   R0WXJP77O6l8BQQKwRsHGwYNT2WAE758IA9A8VXJiCahfdYO9/n51y90x
   1HJ/CbP0vdXBxJknR+72/Jv/JZBTKHzxJ0DJwS5FM4WAYr44ehBGflGKI
   FVp8p8Psi55Kd2CfORT+4b0qBDYrs7Dw0J8u3uN9KMlrYvqrQAbw3+Mkm
   H+yCmuGCV83zGR5AwWkJAh0OkgBE7qOVemuMTbFavXs14h6rqCmi7flmc
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="372235288"
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="372235288"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 16:22:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="842687704"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga006.fm.intel.com with ESMTP; 15 Jul 2022 16:22:43 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 15 Jul 2022 16:22:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 15 Jul 2022 16:22:43 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 15 Jul 2022 16:22:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LMGT9jLRYoJQ2wHTSmUufltmwBCaJrX8SP5elBOCKAkTlo3c1wMVE45Yx7AB4056FhYgbCo+XAmQYjx5dcClTT0GDAyHTxXXIR0iWLM0qMnFC594iUbxYzI7Y0H/baZpOTT4LL2sffbWz8MjYFERlZWGrpdFsTTpsrZBG/JeSHpV6az2AjoKpPufo2Q1HKPPQJpsoyvtJmYMHZ62W3kiQe/A92+u2c2aPQ+7EboGfdcVWR5kw/KLxI//2UOtqJPAiiKtVNHbVpCFRQn2LE+jkeDZlh6V8P+92k4y3nHX5P/DM/PtqzB06b2pi3m4MxbmI1dXHUzAMmHv1dvKe8FS/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A79V8SBZcGWRogfbUmMJ6x+Ngy73KBPONutvRkz3Mwo=;
 b=BbmBNgMsC6RmGjdbnMGVvQyR3+17wUNRGRmwbiM8ybaCNDCiou2Ih4nQumfbI7y5ue2MPwZo9D9QOFwW4caflEwWiDEoiYiveT+2dyLVao2LDXhbk8bjRiRvpJuEos5U+kQ2dBDzWehEhcsuDsjsjs8WKV8mjOGHo+1wBVTLhkTwwL6J0drBZhK7P5nt5UWY7NFLZLTb+M7CIw33Bcgu5cY6xSkkqLqg2gBg3IPUfvrYvc2njITU2RZJjRz9p1fvPARAHlr6moK/mhicpKmXVrmhTHVPEmuos5b0S+5uFI4Lqo6ZrSTCOWmFgBPwxKLvf3VdL4AhRg7mNM6mas0oKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CY4PR1101MB2118.namprd11.prod.outlook.com
 (2603:10b6:910:1f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21; Fri, 15 Jul
 2022 23:22:40 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5438.018; Fri, 15 Jul
 2022 23:22:40 +0000
Date: Fri, 15 Jul 2022 16:22:37 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"Dave Jiang" <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH 6/8] cxl: add a 'create-region' command
Message-ID: <62d1f6bdd215e_242d2945c@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220715062550.789736-1-vishal.l.verma@intel.com>
 <20220715062550.789736-7-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220715062550.789736-7-vishal.l.verma@intel.com>
X-ClientProxiedBy: BY3PR05CA0039.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::14) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f18dbc04-b42d-457f-4dcf-08da66b8e928
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2118:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rc0yG6qyMCzitzRc4SsSsnHzeFwcHxDZ6ZdHi5nND8JnLgBwX0Zunzk2C1iwOp8D2rb3jlN3EWq0LCE3zAp27NmcXKKDbz2WlKQ6At8hAV+Q7v0KyzPUw/2qG2o65hsySxZ185HD43xj3n2lYt4ydm65WFqm+xAuqjZcdP9xyyhezSKajHfze7Q1d3FIl7W3FwPLMzCAD1WMkrCK0oDU5ks0KbWRWZ8vySPbg18jaMjoLu4kc1IOFoHMEhBJxs3R7B/OLpzYZI5HkbsEPjQjajnfyKmv8HfF43fftMhbSmbQztere52SGyo9B0K10ZiDn6GDNFr9N5w4OnUcJqTAXe93efNLSGZb8+R9sKeQueETfdkEZtP+pfjQOqaEJT92WuVV5CCs4mzIlY/eAefTU8l8QKnSi23MRNFp5mOE/sdTCfQwGfvrqt4HESul1c0jrwQszM50nvDjZb6Ad1axdOOgPBW1dyUK30RB8tJTrSGTY5BPKM1MVUCF9Rz2zDD2+GCBrYcBcRoALs8CZsPLZHXODHkkUMDuaNYI76a29pj5L8gihKwXiTY+b0o/pDmTIiuAQfWLdiWIMVymZQg7N0YUZKdY6mgghlCEAvM4NfardK0FbFQkm+vID5UMyji5M6WPBMc6RJ8FdOBQG+FB16j4txkgArpyIGJIgVL7cwgAyrGWS9P3Vm2Dhv1NhrVEgZjY1DQLIzxjZID7Zyl0S+m/zxrsG675g30BhM9DtdU17lbreFl8G8hgqzRhQVbsAOiKd9B972IsgRwv4fPH3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(346002)(136003)(396003)(39860400002)(38100700002)(5660300002)(26005)(86362001)(6512007)(30864003)(82960400001)(316002)(6486002)(41300700001)(478600001)(66946007)(8676002)(66556008)(83380400001)(107886003)(6666004)(186003)(66476007)(8936002)(2906002)(9686003)(54906003)(4326008)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nfQS0XPuaMd+b1jjhel3qBVpnXeje+arcfLtJ9kJ9OFWWyV9WLoR3OnzT9Mk?=
 =?us-ascii?Q?Sl7FfrcYV/tThVSSL6iV9R0vq+daFBw4L3EbE9sOppXU/bbfTwm+8R57H7v2?=
 =?us-ascii?Q?NaMPFahgujeOMo/Pk9zWLIT4d3YLHuEt82xRrimxjK1Lkh5mnB8Sip5hWOq2?=
 =?us-ascii?Q?kNB6B8oW4NUnBlw5HHqLeVhQNUfkCPPoSeeAqi2Ld0b/EcJNxk9bx/7InZ4r?=
 =?us-ascii?Q?4I1CSEZfofQudLU4qfAzAkNm86wYmU8fkqhwrE6urPVngvMGNhEXA+ap3rhB?=
 =?us-ascii?Q?yuqBF39Q0FTOvd0aKP3jHxiqd3/XMZ2UW6+ZA+Tuj8BAj2jz/FAqd9U9CwEv?=
 =?us-ascii?Q?hqUV8k3Q/5Bb3SgKbR9afJDDaDrTBahWleIhl6deCL92613yfUCO46BbKpGJ?=
 =?us-ascii?Q?fZaGTYUM6dcFeNNqMDABDJuAcDti4bP2yf2cqZWuonHz+oK1xIlOsia5t/G8?=
 =?us-ascii?Q?7aXs7oPfiFJfkTnk8po0jbrt6KJhv5usKaiOoGFvvZLRK5uHxIxGoGfr+p+s?=
 =?us-ascii?Q?pVO4oo0jOXkhEio7P0SsauZ+4ZLb0wbVZ9uY1ZNjBGP6GEt8NtsI6Qx+x6jr?=
 =?us-ascii?Q?ttc4WGMjFg4e2jyuavT6jc//iw84NyVvXZkcEA269quQjEU9O1uc8fKEYeCp?=
 =?us-ascii?Q?bvm+2PtohuyS5YeEwHKnIvjOC1+2Y864Nxq4ZRafYIbYa9BND5c6puokbSiR?=
 =?us-ascii?Q?OvYjWV0L+3UetAKfm9JeVIvTJ8PcqkwmzzEWcgf1RiuVIvcRBzeqnH1oqQpZ?=
 =?us-ascii?Q?vNCnjh7uNfOztWWXGA2ewfp4cSz9Ude0hjYOZyEoecbGn2RMeq1d/J8uOCyo?=
 =?us-ascii?Q?myLwEMcGwNBTxaKYBI5arjCZPgG+yZSSCx/Nkm4DARb0CatErFj0za8VqsYo?=
 =?us-ascii?Q?qoKHPYvG1ejybx6aG2rv/BZTaFZNYVD9ZukS9xOxcf+lz3j6yNYoZJq9qA1+?=
 =?us-ascii?Q?OsrEflJ5gI28ILISSfw9VUOMidgCM7bXBgpEBw+krKqyBFpveL1le/dpKG20?=
 =?us-ascii?Q?79QgRWk/WxYOZVkApaySFmTa4y6hhqUN/N4wWEiafwnEn8R2eUYv9qNZBKbm?=
 =?us-ascii?Q?1g4JK/D1tfxiaRdcTFzE1mPtqHXUqF3tYKU5pr53VMgCYDnHcdjDFCkWwOFO?=
 =?us-ascii?Q?1bOT0WTTT0Pqv8woRLMn/HL3DEwrHihMOnhBuXJ85TAB6kavbBQnGm3cB3DC?=
 =?us-ascii?Q?aTbgtqM2CJNSqBjKlSO3+HMqWZR5ZWCcZDSOVbYqkXnEE4ZyPv6yOvSOLmsH?=
 =?us-ascii?Q?WgPeS9pBlIHb4ynuZQpaLb8u85ZAKb3wPEWbGtgyrbYqd8Om9PeiOP7YfXMJ?=
 =?us-ascii?Q?ArwNaKijGuXZzMGZIECUQpaRxmygqkqyD63Ft+peWdSEL10lJjThgK13u+FW?=
 =?us-ascii?Q?Pg5gZCgNAntNmizY8cwFdbMDyNK6KD8gOIEM6lUKSMenYfjEGzy+Rf2/Efb1?=
 =?us-ascii?Q?ZzivhcXkJ0p+T99v1qIWJRgQfg2HMpfELQSKCJKM7Gsk1sy8glttYE0BiuvY?=
 =?us-ascii?Q?ZCML8QmuMjXJGrO5FpBLh//4QWn04sC7tA2mmju8VI+RsDu8dqHmhHB0Dcee?=
 =?us-ascii?Q?AoykW25EjVqo9FarcFSDoU0nnpYPf16nM8LUu6e/oG8oJEQzNS76+bw6+FFE?=
 =?us-ascii?Q?bA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f18dbc04-b42d-457f-4dcf-08da66b8e928
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 23:22:40.0125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x/jBm2Jzsx3HFWQbhoPcaYdVcWXjjOTHmf/cTx6WklBVGqt8OJZ7iulYIX0acyivIfrQRLu0dKSrAEHR+SBIbP2zufein6IWmLzPO3ls25U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2118
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
> +			if (memdev_match_set_size(memdev, p->targets[i], p))
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
> +
> +	uuid_generate(uuid);
> +	try(cxl_region, set_interleave_granularity, region, granularity);
> +	try(cxl_region, set_interleave_ways, region, p->ways);
> +	try(cxl_region, set_size, region, size);
> +	try(cxl_region, set_uuid, region, uuid);

Will review the rest shortly, but just jumping in here to highlight an
incompatibility with the latest update of the kernel patches.

Latest version of the kernel implementation enforces that uuid must be
set before size. The rationale is that for pmem size allocations are
permanent and need to be "named" first with a uuid.
