Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925F14681
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 14:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657723680; x=1689259680;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=BYVlM84a2TtiJmn2bpfMg0Iyn78oF7qMUkH/sA6bTpE=;
  b=jMiB3H/bhyIbWiD7t0JsvP48/BuK0jqkO+AzSwyQv8beEt3+iTZkPp9b
   qnmUFZzOgkGkLqTr693zeMVBEdM4G53i3gcAYc9MOYccUcePawFBx0y8U
   QGSkLFnjxGWpEY2UNjHKhCEApB1lgOaQbWGACAOcku5iIHwwv1tHwURYm
   sBzLa93Yv1KDBiy1BsI21LvmJsQDBwAc5tqxvg7uShLeAclbUb5k6vwCp
   59T7YiMwhQJxxsGeq2iWkEv0ubt2gU5TwIXhuesgn36gJcttuIxrzMWQh
   l2ZJ11UNWHso4ZyExjyX/vrR/T7/INYdrK43A+b/2oj89VAHlNKqWJT6s
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="265018307"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="265018307"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 07:48:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="737897769"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 13 Jul 2022 07:47:59 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 07:47:59 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Jul 2022 07:47:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Jul 2022 07:47:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=menXJnvuVLQ1F793diwJu01yHkPpS6YSJ7A/tstYIqBgUV6wVN1yHkCmRhYj+4I+vTk9UBCRW5MiLf5wAL9QJeyWsqhHZ21wMYnP80QqUTSo7rdgdtywuiuf04ZuFv6plRuNe+8jl8UGFCcOljGW8Up/CPHtVFswOc7vyPiGxfKYfw6iLh1JZtJeaAe1NJAuQ5mO2nVf1VwK4TiErnPoGk2U1emv7K7onofGP56LNoWxIObyR7zfVirQBFcHmpJgBxirLqJfk+O3d2CjXi0kGU8bHRI3LV2bo4c3cRvxmIiVIRFZA+PSDUjt7Bfjw3O+8ldkgJudRupkHubZVbz+bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jJbXjC2R+PANku9M8hFwpBH87vfrA8UH3l3HZf1/tg=;
 b=UsXCTmh9W+M3sAH6pHXzkSkHSPFUBdWTfnByGM/3krPE23jwyFT/MJgikClSHt1bicNwn74yeIQ93+3d9/KpS9fhbKEiVW2Mlcei96KopQ6SkH/0YnIW9KXjPlNDYqCPT06FwnwsoN/Z1s72s5SIv1wB7gnYfqxvjBq4Uiea1/p2XjFkGn1QkJuqftk3e4SJ2nuIHHvPX+dwMfnMt1I5CKSHLrcXk6lf9FZI7SEqjbgUApG76RK5PuADqI5yqiHi3584l8o0FDKMEIl7LIR12tlhZmH4IzPyeGwt6LGlnN7gfmXxMbHFh9/gEb9FUGL5MrfKEpE9JenYKrniYoe/rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by MWHPR11MB1919.namprd11.prod.outlook.com
 (2603:10b6:300:106::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Wed, 13 Jul
 2022 14:47:57 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5417.026; Wed, 13 Jul
 2022 14:47:57 +0000
Date: Wed, 13 Jul 2022 07:47:54 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 11/11] cxl/test: Checkout region setup/teardown
Message-ID: <62cedb1ad2457_6070c29451@dwillia2-xfh.jf.intel.com.notmuch>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
 <165765290724.435671.2335548848278684605.stgit@dwillia2-xfh>
 <4c3074a5393a5d3758ac58028e047edf43f84115.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4c3074a5393a5d3758ac58028e047edf43f84115.camel@intel.com>
X-ClientProxiedBy: MW4PR04CA0222.namprd04.prod.outlook.com
 (2603:10b6:303:87::17) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d544fa1a-f308-4da0-60c6-08da64deac97
X-MS-TrafficTypeDiagnostic: MWHPR11MB1919:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xZflQh7YTzJ6Qj9TV66+mTFOTnQlZawqg354FHvHRxj/2KLOCDBE+oGTDEqIF+WK1audLAFADKpO96c9F/kxfVElzWS3vX8FMuZqGGdUoLsrHzZl8d26hmP1CS4yw5L0a0uh0JyOOLZGNO/xTSxfbfjNCe7Q3uNC4tDacplnxh1am4YgOw7koT/qAgk3vZ7QposSH9DSCpkQD6mV+ZmWKHqJu27PL6lHHh0Pr+dbkRqj8g0aRdt/JygJspkU3NnnIus7THK5t0+daBszp3owLG32+q3sgm7fW56DicB5CBqcsGyPmYqp6WsW/XkSYylNhHwtrE00YiTaBFG8KQERSMBCfAgkDf9eVPK/YmrOeQX39z6I3Xf3pVtPDXEVSzMk7fn+LYsqPn0DFwlRT3MetL21+05U+zj4jjiWXq6ZhbBX2dDVy+DymUzREY88i6b6WMs3yvhoeQSjEiigCLZE9F8TqxjD9reagktpAbAsOfrvn8DYhkqqmR3EJbfQoU8huY2S+7oNaYSKWTReARRMUUnLCxcUIRQR75gSaxFNRbNTyzzsKyKBXb7haHYaTbPYN+enlUT4S+HEwzADImJ9Xir4GOIQq02JaAiObaDfAaFdEq1K7H/6UENPNbp+5hJaUbOwLilXfLKVBVHfuLEgzhPzLeHEjbyy90ZGgLZRPszzRAoybwdBmHhUHKPKMlXxVrywPWTJTthkdCVz9AEiTVbr9TS1Mp4DlZKkVFoJiv8BFkKTz6Ha9vX23TWhesyG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(136003)(39860400002)(346002)(376002)(8676002)(4326008)(66946007)(186003)(66556008)(66476007)(54906003)(110136005)(316002)(86362001)(6486002)(9686003)(478600001)(6512007)(26005)(6666004)(41300700001)(6506007)(2906002)(38100700002)(8936002)(82960400001)(5660300002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?uMHj/BLaN3YxwFpGztrEkfyejjeVyPLw5hlMSlClfqAlB9ebSzN4HhtXVK?=
 =?iso-8859-1?Q?Mp7RUQC9OsBZMjFru1iZ+eRF2InTiUIAqMINRRYnSvFVDKFi+LnL8QZQkw?=
 =?iso-8859-1?Q?ymfoVMnrQ7ehllcO8yZvuVWxKDruswRaSOcdXirh3NJrxqLJmYM2A8RqIi?=
 =?iso-8859-1?Q?OJZ9ieinhY0w9x6vykTKG7wh+rYQJYTG9XH5QvfsDcqO4aTlMgvLTHhkSy?=
 =?iso-8859-1?Q?rccJjDEC/FDlFOdQmfbMux62I4FR/cTCsKDg+/TpnK+IZJ1z/4aDDFXbMK?=
 =?iso-8859-1?Q?O0n8yPfgif4ggbykr2iDcuXA+zG0z31jTcMTE4KA+VYYxtHkyw5IvBtpJS?=
 =?iso-8859-1?Q?WMldOJ8tWvyY8QkVZXQU83iuLVYjYX47zI+1fgieXtF3KDV6vYR6NcrRwY?=
 =?iso-8859-1?Q?a9MJatN3S7QyyTlIC4eDpKB5XqPz2u3PHyujRvVqUX7ohC4046xDxhpJvw?=
 =?iso-8859-1?Q?Trt7iTIglBYqlI04nAaIHuLCn515I3PkZe83aw+AUgR2ngC92NTRINbV+t?=
 =?iso-8859-1?Q?cZz120sg5F6NTfhUNStFhTXs1PCg883dlhzV8ZFssYxTn8b46beUVQX+d5?=
 =?iso-8859-1?Q?yhN3NevjR1YITNePvfQ15YIbiHaCEeft3RNaUzNbZV9w8qDbCKYSxqVzVw?=
 =?iso-8859-1?Q?XXYDDpqQgFXjLMD6gxdyxipvkoXQYFMCizYTuY6/IRbzPEUBcaLbrZryXl?=
 =?iso-8859-1?Q?vSaJRiCzyrgwyCPaD/C2p4Rb4wV+650d+Eh86rpJJmEWTMgXG5G1zAwMkd?=
 =?iso-8859-1?Q?gFbtrCzJBFPcpz9S/hMHYlX1wxPhxX4PX3TXxAR8/lamUClfg2/o5RMQn1?=
 =?iso-8859-1?Q?xym72qKcT+NbVss1iwvbIq63Do99UqhHAcnHVKVLzewp/mZ1kRAU5AMXjF?=
 =?iso-8859-1?Q?UORwRLsS/qi2sA8b/t8kCk3dGaRFiqPNR9i4nujcKzB4cj9D0pbhuXwqLq?=
 =?iso-8859-1?Q?liLjXl1/LHRLhsEJyIvPcx7Oq8QTzns7bA3YpniZfuIed/Db+7GEPBKfgh?=
 =?iso-8859-1?Q?uqkUlCy0FvGkRd2wpj3dwpw46WRribd/fVT2dwDmbn+ZLKPd7EXXP+yXyi?=
 =?iso-8859-1?Q?gLzWjwZCFQQ09RydVdMSfgOKMQnVqemh9fgk3LGRtWISHWXA1YxD+ioHxN?=
 =?iso-8859-1?Q?mljsb7ibqxeJndypA5IvBv/PExN8/KWViFfvhzjeaMJdwQJBN9F8KG+Bfh?=
 =?iso-8859-1?Q?rUOMHEDc2IPNRZbUzym4nqv4IL327liDj4LilPwAQxPBAe8z42ua6zDsdB?=
 =?iso-8859-1?Q?N9nkDDdy0dQtJ0QG5jgubSfJX9vkLKkbY3ZYrYGxX3JhKgjiPXI6tklc+h?=
 =?iso-8859-1?Q?g/iyjV5B2qy5yiAjRng4lrS6h3Q6S87tlAgDf49FvWuFG6Rj7RhwVEbAjZ?=
 =?iso-8859-1?Q?CFrJHIJ20WUyhzS/k9FG7kWWsWXBwwUcPuCp6V95pf7zF6/bX395D2yuKE?=
 =?iso-8859-1?Q?ic/W2Z1OA8lVAjhfaLlfDaNg+D3GxR4H2PJAeX74B+/dXOgnrPaeGw1WcS?=
 =?iso-8859-1?Q?t6i8eXdBN8iZlz3I1UljvS2cZhaSZx5XAWOE7PR0G10Bzjrz4AQ8yPgHIu?=
 =?iso-8859-1?Q?0hc0toJK5rcZObUFjVRdgmJRLWL6w+XLDZXtcqfuAYWFmcxu7o7sT4noMu?=
 =?iso-8859-1?Q?e6RtqzavtHqVULINNXxYjQtt3RbevdTx3qGcdxrRfLwXFrLBv9WwXS7w?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d544fa1a-f308-4da0-60c6-08da64deac97
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 14:47:56.8871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zRpFj816WqkZMsh+nfuQKThimFc+ae8nqK+qN4t0Hj5X+g1IZ9cBZxLrcrTfTqbCGuRJhbVH1US4D8z05oGMb2VKSa9f5z0SpGiHk6bBcSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1919
X-OriginatorOrg: intel.com

Verma, Vishal L wrote:
> On Tue, 2022-07-12 at 12:08 -0700, Dan Williams wrote:
> > Exercise the fundamental region provisioning sysfs mechanisms of discovering
> > available DPA capacity, allocating DPA to a region, and programming HDM
> > decoders.
> > 
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  test/cxl-region-create.sh |  122 +++++++++++++++++++++++++++++++++++++++++++++
> >  test/meson.build          |    2 +
> >  2 files changed, 124 insertions(+)
> >  create mode 100644 test/cxl-region-create.sh
> 
> Since this isn't actually creating a region, should this be named
> cxl-reserve-dpa.sh ?

The test goes all the way to the point of registering a new region with
libnvdimm, so it is region creation.

> Alternatively - I guess this test could just be extended to do actual
> region creation once that is available in cxl-cli?

I was thinking that's a separate test that moves from just one hardcoded
pmem region via sysfs toggling to permuting all the possible cxl_test
region configurations across both modes via 'cxl create-region'. One is
a sysfs smoke test the other is a create-region unit test.

> 
> > 
> > diff --git a/test/cxl-region-create.sh b/test/cxl-region-create.sh
> > new file mode 100644
> > index 000000000000..389988759b08
> > --- /dev/null
> > +++ b/test/cxl-region-create.sh
> > @@ -0,0 +1,122 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (C) 2022 Intel Corporation. All rights reserved.
> > +
> > +. $(dirname $0)/common
> > +
> > +rc=1
> > +
> > +set -ex
> > +
> > +trap 'err $LINENO' ERR
> > +
> > +check_prereq "jq"
> > +
> > +modprobe -r cxl_test
> > +modprobe cxl_test
> > +udevadm settle
> > +
> > +# THEORY OF OPERATION: Create a x8 interleave across the pmem capacity
> > +# of the 8 endpoints defined by cxl_test, commit the decoders (which
> > +# just stubs out the actual hardware programming aspect, but updates the
> > +# driver state), and then tear it all down again. As with other cxl_test
> > +# tests if the CXL topology in tools/testing/cxl/test/cxl.c ever changes
> > +# then the paired update must be made to this test.
> > +
> > +# find the root decoder that spans both test host-bridges and support pmem
> > +decoder=$(cxl list -b cxl_test -D -d root | jq -r ".[] |
> 
> This and all following 'cxl' invocations should be "$CXL" which we get
> from test/common

Ah, yeah, missed that.
