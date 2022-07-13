Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD394681
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 15:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657725992; x=1689261992;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=aeo/k+v0l2nYih37ngdA0mP5bfvHDg3mWD1+Q8WH9EA=;
  b=K3Qz94oPR6luP4LtB/QBoW3IKI37Db5ipa4Pq5oxEfpmQMylUnoCHApD
   OW/8ZBCRSiPKwcz/lIXDKAw3Wt/Co1zzSoPQBkQLuzbhn58cpSuQJ5lnU
   GRMxn7Ylyc2r5sNVyujFV/wXaISS+eELkx/1DlGTXbV9C1YmS2ConvZvR
   H+9pE/gkctfHOrkPvSmj3mwx7kavRfpevfaSrAYHQxetjHoDZkEAvPhnL
   vMCyauwdfyrqCgBjeV7VHlujvvq7n1f5KHq+BnGkKrFhcBjJmKcCrlMP/
   1Xs21IfMJYzxjKucv7vZc4qWd4XpVJsj/U1cz0UbPK/sHMzNaUrhlpcuJ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="346925709"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="346925709"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 08:22:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="628342004"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga001.jf.intel.com with ESMTP; 13 Jul 2022 08:22:12 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 08:22:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Jul 2022 08:22:12 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Jul 2022 08:22:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOp6VjtAspRnCqy3mp7wy28OeXDNK3EtaPqOE9I+2PyNSyvZvtsRVKX3thCoVRNc1k8QVutihkImTNFHSLreIT66YcvvYSNe1Dul8fgWoOMB6AD6pTKeNO9wm9SxfM3Hb+qg4d5Q59MNDSrNbaNk4ICRsjvG4jOxOqrJf47k0eUKcruFSnOCa0KoRLvYCMXejrBjwwbPkyaDwoK3DMmrTw7DNdbhPr+jF4P6PBtfmh1ZXqw3UyqlmYUbk0qJ0Q7ryYgy6nnW9V/xS8vLe96A8v6UiP4mt1yqbxe4pM6Ryo8rEU/gJRifkbfR2v/BTV66xjh0uwIMoMDe9B4CQfwrdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hS60AQjrR3Twv7Zf/xeSOnCWL8E98oGZtERS9s++K+c=;
 b=b/+T8DaXBzMLDmIyp5V21PGW0B9sGl9Ny8I7pgbPPtJidcdeZAkXgDPW7l3EAW2PJgThTcLk8YTv75cln9RTH6FtLiE2BiFgfRpKX7Pa9uoxs7oGZkMneOQVZSpve+aN3awyFPaWPjJJf+DDyAxf1j8OJXt7hD5jX58YuSzH/22K4QazPIKiIAcNmS+tqZHMUa1c0kFS1QJC8cbg77O2tAoaP31BSVx5fuGeLY38hM+VhyULjfUTcEThPFmvLdtB9TVoxut9YbX/vr8203+sTD/4gPcZnVznJiqwPQZ1U5/3nTQ41+7VVh+54D9I4zdpadagxZyq7PpxPo/El79CEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CY4PR11MB1509.namprd11.prod.outlook.com
 (2603:10b6:910:11::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Wed, 13 Jul
 2022 15:22:08 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5417.026; Wed, 13 Jul
 2022 15:22:08 +0000
Date: Wed, 13 Jul 2022 08:22:06 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 09/11] cxl/memdev: Add {reserve,free}-dpa commands
Message-ID: <62cee31e25d52_156c65294f1@dwillia2-xfh.jf.intel.com.notmuch>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
 <165765289554.435671.7351049564074120659.stgit@dwillia2-xfh>
 <cac1d3a7a7e6515b2db0ce7ee73db812686d3407.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cac1d3a7a7e6515b2db0ce7ee73db812686d3407.camel@intel.com>
X-ClientProxiedBy: BYAPR08CA0066.namprd08.prod.outlook.com
 (2603:10b6:a03:117::43) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35673f8e-8462-4b0e-5068-08da64e3733c
X-MS-TrafficTypeDiagnostic: CY4PR11MB1509:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: avWTDHeTtEgAOn1gCDP7avKImDpMEL7haxexkroz4oGIRG+SlkDYuNTWIN4KoZOeCn+B/tpxITSrW41OcFstFTk1Zt0oL9Q2V78YKYebtv2HAwQreNVoTJpdpj7Zw//K/99sHjslnqFhynRSO/NbW6RbsUNRGv1yBlTpq103yI4eutMdmzjh7uT38eGPNw83gPIiciMch6q9G4Eo+rCa4BLycCCCf5aw4RxXQNZtR3TEA0jC0zbS4oNIAfjY82wNkoQiXLwlJFZ4lAD5RKVcXaScAsNsZct2Cc6XpO4CpEF8ZF+TxDPtJcDUoTavjrGmFdp+FZzJIBXCER0qL5aw/MV61oGRFzPcSNTP97D5LXG+oRYVV/cLuaQu+mbH5oKFAXBruikva+x1BDJo70We/RhHTp+jHJKdsUgN9q/qB/hqan4O7uOryOjMqv3MU68+lX+7+hA0cc+miraQg3GZKhsN6+nfKa7LiSv3d21OiZfRbMaRO6FZQG7kM+F2YZGFDXZn7EfLHJ4FvKCFNJZ5jn3UjJcnYRti0VIyPRmZ04SjrtulwwtAgzDMllj40mjNg9yMyOPqyIfviiIfNHspB22tcme03JKRF0UiM+wrhdYKhOGqVRlKZdap4A+gEU8yNzWyQUxZDJITdFTpwxjqAurykpj/V0slES+FOFEw6Hr6p+4QNnHCIqpkarAlhMwTWpdKxEE2QtpLlph+ZhHxdLZiri4YmJtomeBvVCztf2dSgDzn/o0ItyYt708OMiSTqYZH8avB3mI4FfaMEGCL9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(396003)(366004)(346002)(136003)(26005)(41300700001)(9686003)(66556008)(86362001)(6506007)(478600001)(66946007)(6512007)(186003)(66476007)(83380400001)(82960400001)(5660300002)(8936002)(6486002)(2906002)(38100700002)(316002)(8676002)(110136005)(4326008)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?WH3icQGcw463N1X9ZfUt9odnyTQglT8e3oY2jq97vVB8RsWo9GkP6sdCZC?=
 =?iso-8859-1?Q?XS9ZLJXiRw5i4jpARjBcqLYuBDRsEXoeDmpZUPwqribFfM8PGakNyw6hgc?=
 =?iso-8859-1?Q?b1jHD8GCsuhBfRM5eH2xUmK93rxCq5n6kcey1ODrMjW75+lVKgzgJdpedq?=
 =?iso-8859-1?Q?ZY2Q2owNAsM+0sGvJSC/R6Mwbif+YVqIU3b/r2NBnjN8eUfpacTOgbY/vm?=
 =?iso-8859-1?Q?+IVIyLh3wij6CRIX866Kwe+AbGnoYJ4VI56iRhXY17/vnO5bzZn1mD7KQp?=
 =?iso-8859-1?Q?ZZmFaE53U/1e/dyhfTozpNNQFl8teluuSvcovFB9U2ueiNsTU6tqmUHGSa?=
 =?iso-8859-1?Q?GJZ8ueUOZaIXgYpUAiLebeQ3PqG/efu+hftOYAHTDjnGpinjhgURUH0nIN?=
 =?iso-8859-1?Q?xqTdU+D+zZXd1T0T0lFnzt1H7CiFVWTpPby7qjTqgFB+LkmPp9t5XDBNgZ?=
 =?iso-8859-1?Q?yvUuO3g8zfcMHojF5I/WPViBLCaRfXixH1GPA7XT19u4d6rOxYhC6bsejT?=
 =?iso-8859-1?Q?iKs2hEbbpYYwiDstzR7V4ylc4U0OpoRuQ1k1N6GdTAr/inQ4zjqduvv1Ry?=
 =?iso-8859-1?Q?lmpMS3ff8HJ3YXHUYaGRCxsAnf4Wa45aD/wafacEwzws3Epr2/AYZMjLoK?=
 =?iso-8859-1?Q?nFKLuFbQ99rYboaya12Hv5jLfm/fUgYD1nvYXbZBRmLMyshkk3AB5/ghit?=
 =?iso-8859-1?Q?M/xINKS35kKJkJYTE78mv1Qs0kYUtO850rTYI0vLzFFjcK9kykXrYZflm8?=
 =?iso-8859-1?Q?JXKIBT0PlvW6CwE4gQU3j7MHMOD0L6cBXd4V7wXbL9jjjwQ55fB2XgSuAh?=
 =?iso-8859-1?Q?PwEaonopqDgoG3h3BOuRia6T2TaIYmHaba6L2lSVpPwRYdJgPh9jR7P/6O?=
 =?iso-8859-1?Q?q00EdLqpFP5zPnp/r2lYAWC4uFYCcM4fVVJbYR4n7q5ITWCZJYxVAalfW1?=
 =?iso-8859-1?Q?pdbaKIsxSdQ1hXonp/yUcPPfnceuW7bDM+B6N7t8baplW8fsiF15kX8NT0?=
 =?iso-8859-1?Q?eJ0avFPNs42gYwM6lcau6FS3gTiNX6JeynX96l7GEivMZ/OYiCMBdvKama?=
 =?iso-8859-1?Q?AsAWlid1FlgzCS1mmiul3APhHuDf94m9fB6rKopxm0DBl+Yh9D/dQajigY?=
 =?iso-8859-1?Q?Rw9gpedUtdI00Yak1STuRFljhc9jqNAh2+Cnp3kaFJgFQ9Gblk8lTB17cN?=
 =?iso-8859-1?Q?xmJ+S9meTvW2Kq21h3RH0v12v0TBJEjYJ6A2CulV4so6TREtw7wkr5bII5?=
 =?iso-8859-1?Q?mNbNGR03DsGDd14ERVqcytu+gRrbJzI5mstv5EpTZ6NCU9FtQsgQ0I2D5J?=
 =?iso-8859-1?Q?it3dqPwxEtHmG8QPt0h7EFlgQUzFbh6eGhEPLTs3tCyNAdcRhbsueLElZ1?=
 =?iso-8859-1?Q?bLeCNFev8/x1w9bxEy6CxVM5lruj1EnZaMsCTS3Smppg0eGQbaN9PFc+QB?=
 =?iso-8859-1?Q?lqwOcTU8h0x06odEK/k0nu8vkc4kAwAkcneYTlNTyO10ULfdLMqFBG6m66?=
 =?iso-8859-1?Q?A0g9yviy5RTqxSaRGihdv7Mwgs5s6Zeh8MPDJa4oP2xMEaGWsK+FqNF0Fz?=
 =?iso-8859-1?Q?2maZATnqFIzqzkRoj5N8mEFOYEQgwhXoAOVXfxI7D4xmSSYyV9K45d7grq?=
 =?iso-8859-1?Q?rIsq8ayUWnVRo0JAedMwBlLIPoz0LeEXAbsClfuDnnKK0T4HhsEmJZgw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35673f8e-8462-4b0e-5068-08da64e3733c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 15:22:08.2688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E5yUyv1U2EEOCdC+StKZd2U3vieTB3et2YYbDBrXAbI5SnK/H71cw++Bdfe5CR8mC069XafL3gpIv5dxt6lveyBpHGRA4rzbhXC4WquZzg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1509
X-OriginatorOrg: intel.com

Verma, Vishal L wrote:
> On Tue, 2022-07-12 at 12:08 -0700, Dan Williams wrote:
> > Add helper commands for managing allocations of DPA (device physical
> > address) capacity on a set of CXL memory devices.
> > 
> > The main convenience this command affords is automatically picking the next
> > decoder to allocate per-memdev.
> > 
> > For example, to allocate 256MiB from all endpoints that are covered by a
> > given root decoder, and collect those resulting endpoint-decoders into an
> > array:
> > 
> >   readarray -t mem < <(cxl list -M -d $decoder | jq -r ".[].memdev")
> >   readarray -t endpoint < <(cxl reserve-dpa -t pmem ${mem[*]} -s $((256<<20)) |
> >                             jq -r ".[] | .decoder.decoder")
> > 
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  .clang-format                    |    1 
> >  Documentation/cxl/lib/libcxl.txt |    2 
> 
> I guess the new commands are mostly for debug only - but should we add
> man pages for them?

Oh whoops, yes, I missed that, will add.

> 
> >  cxl/builtin.h                    |    2 
> >  cxl/cxl.c                        |    2 
> >  cxl/filter.c                     |    4 -
> >  cxl/filter.h                     |    2 
> >  cxl/lib/libcxl.c                 |   86 ++++++++++++
> >  cxl/lib/libcxl.sym               |    4 +
> >  cxl/libcxl.h                     |    9 +
> >  cxl/memdev.c                     |  276 ++++++++++++++++++++++++++++++++++++++
> >  10 files changed, 385 insertions(+), 3 deletions(-)
> > 
> 
> <snip>
> 
> > 
> > +
> > +       if (cxl_decoder_get_mode(target) != mode) {
> > +               rc = cxl_decoder_set_dpa_size(target, 0);
> > +               if (rc) {
> > +                       log_err(&ml,
> > +                               "%s: %s: failed to clear allocation to set mode\n",
> > +                               devname, cxl_decoder_get_devname(target));
> > +                       return rc;
> > +               }
> > +               rc = cxl_decoder_set_mode(target, mode);
> > +               if (rc) {
> > +                       log_err(&ml, "%s: %s: failed to set %s mode\n", devname,
> > +                               cxl_decoder_get_devname(target),
> > +                               mode == CXL_DECODER_MODE_PMEM ? "pmem" : "ram");
> > +                       return rc;
> > +               }
> > +       }
> > +
> > +       rc = cxl_decoder_set_dpa_size(target, size);
> > +       if (rc)
> > +               log_err(&ml, "%s: %s: failed to set dpa allocation\n", devname,
> 
> This patch adds some >80 col lines, which is fine by me - maybe we
> should update .clang-format to 100 to make it official?

.clang_format does not break up print format strings that span 80
columns. Same as the kernel. So those are properly formatted as the
non-format string portions of those print statements stay <= 80.
