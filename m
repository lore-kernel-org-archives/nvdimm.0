Received: from mgamail.intel.com (unknown [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DB41DDC5
	for <nvdimm@lists.linux.dev>; Mon, 31 Jul 2023 22:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690841790; x=1722377790;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=UXHw9TiJ0y5jRog7jvANvbaExbHJHdv0BoY6Cm98B0A=;
  b=BIqixtGevDl9he3WJ1KaLb7qRykaRV9GXqvaxp2hmpGcGCkvAWr16gMt
   5kyzvZDXvhTBxAGIVT/8rzxZBrSVt7jgeSpfYrUidzS8oLqzgdxSBUz0l
   cjWZ7wTtZwMbg7Tx5jLRs6W1qmewBQpGVrTs3o7j7oMjgAVxUw9GhqtFx
   BPJxyg1pJFb0Ar0ay1q77GaSNR6fMPfYyT+Wdkt9ruk4xn62DuAdXu6o3
   kEidYGfiFcoY55LukMesnDY1fjSTTVhF4ZKjt3FzlM0cFzpgjHLsH1Ozn
   nqjvjrF6sh1eCAt3oakEcGRvf720PIxHXWL9SSXHyv6KwbReD4k5gFJ73
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="348734656"
X-IronPort-AV: E=Sophos;i="6.01,245,1684825200"; 
   d="scan'208";a="348734656"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 15:16:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="728437604"
X-IronPort-AV: E=Sophos;i="6.01,245,1684825200"; 
   d="scan'208";a="728437604"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 31 Jul 2023 15:16:25 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 15:16:25 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 31 Jul 2023 15:16:25 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 31 Jul 2023 15:16:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5N9fM7mFrUC6cEbTX4b2Rr+0b2Z2HdYA/t7vyyoJhMBZoerod0/bYdePX6lzBugJf06oH8VFPuhpv40hP9yi1ZXTI/KX8FNArpaj6rAHfsufYV+MZLSJz8AyUaPKarRlRx9mUd8SFWXR4rWB2wBFCl3cmGNXY81P4N4cVcEwh1a33fM2IV4ed8Qyg9E5W+Yl15M3CFGmDx0ZDNLI+lreMzjUfNycpUs0QozY3C9KSNFpj/PekRZ1vfeQrt8UUotYfA2OfEKJUUVyxJydTWTEIbKDIxtEMcqn4QXlk3veMnZpZtfuyBIrUN4Q8hHC2HIvHxgDvzwUtFpCpkGOaUVgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NmlQJH2OyKBvOqK0aEGPA4w520OoUVxumScF6Ig0uP8=;
 b=CU6LosqfyT6Vd+TGZhO5+SyfzHJwpRqW5PVL/nuOp77FYICi6pNxsmN8DwiO/vntaUobf5j5YVQAGnrjaTYXK6zS0cKCezl2PRX6/nRPY+RCAOsZMKgmydU2PxqoVsNYTYKQYEr6lBKGoF7P7fDtFOGTHVuOTIQteGvIUJEmKUMfEHKIpDSfd5Eq+QiAX7ZD6CeMriIXbmn8QDSvj6kc1sTSZH46GLi1rk42LFI6LTGmolBY8uz1Eqwlg8XK2i11XKqiUS1X+Hul3VNRNtHl575Fy+hr293FEgihEIQAHNR76f9oGL8SJmnlKY9bdhduq/UQbMXO0y2pxPUprkf/pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DS7PR11MB6222.namprd11.prod.outlook.com (2603:10b6:8:99::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.43; Mon, 31 Jul
 2023 22:16:21 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6da5:f747:ba54:6938]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6da5:f747:ba54:6938%6]) with mapi id 15.20.6631.043; Mon, 31 Jul 2023
 22:16:18 +0000
Date: Mon, 31 Jul 2023 15:16:15 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl] ndctl/cxl/test: Add CXL event test
Message-ID: <64c832af840d2_14b442949f@iweiny-mobl.notmuch>
References: <20230726-cxl-event-v1-1-1cf8cb02b211@intel.com>
 <03c94c0834e31035322299dd2c7952d97a70ebc3.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <03c94c0834e31035322299dd2c7952d97a70ebc3.camel@intel.com>
X-ClientProxiedBy: SJ0PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::34) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DS7PR11MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: af025c2b-7c83-4474-896b-08db9213c393
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /j/XeLY0rcBqyu3rQ2G1Anoo8txKEMtBM6lHQRrfGU+2a+sL3ygYFITfxwt7JqzehUIIVWQLvLvbb0nQEnHcL4VRUBHtSRnyrO30bDKVt3lj1PabHvAP4rZLirW95G/0Ct5wATULNkDjeZl6gzGezq/G4UMkXWoyIHWsI3UqA8ALAnenEkw7bq8b+1b2BG85sq7Z/GI4ZmOG1zSNVoDhZvWS73kjEEQ96j8x70KPIRgQ5QmqxzsglxGL3aNVT+oUMMFUNSYwjAtI5q0gktnOky/rr6L7rbOIZ4OE9mxXjrDVf51ACsjL3PK4OKkzADUmESoVpvby/Vf7XHBetMRzj6tMnx0j5zwDN4uyMcZ/yVbtCoc7NqlJr0bKYAnBC9s5HvGnetSq9jhCGBZQo5mI7hExW9J6jtTnzOS4tNAR6km5MvpJrg8x14quCXksBvn7PbGl4OA4ZeJelYfSDiKwWIHguMe/SRLGf3s/xBelwFVt+2YAdXAly0RtevWNF/qWcokn47jwTtKWSX09MZpa5TSPUN8ky65SUzA0v9Skncfj7SB3OeayGrNWpugJ45Dq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199021)(5660300002)(82960400001)(38100700002)(2906002)(44832011)(26005)(316002)(83380400001)(478600001)(6506007)(8676002)(8936002)(186003)(4326008)(6512007)(41300700001)(9686003)(6486002)(86362001)(6666004)(66946007)(66476007)(110136005)(66556008)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?8blOgGHCH4QnFsrNxmfWOpkc0D+nnokJGarFcFa1CCmQcsX737qH01hiKS?=
 =?iso-8859-1?Q?jGVxYsiD+oyqYENxiQWOe1W8BVupH1g3csblI1ZVwBfEtzXd+TVjlFwZD7?=
 =?iso-8859-1?Q?v2+M9XggagMBbq5ekRV3jWEcs3JZKOSN5RBwWq+B1mzkzveEjB7NllfVmB?=
 =?iso-8859-1?Q?exna3O4JlY7TKog6fsagOL+jHMYuADwVgXocf3zizGdrVxHXasMYJYCmDy?=
 =?iso-8859-1?Q?1ATV/2G4llw18VKD+44jPWZ1NO/r0FbCafeowfQ0C9Tfqr3fBRm0Pb5pFC?=
 =?iso-8859-1?Q?5qi0aHzs9+3ZVsKAroHStwbmO0WIHTe2f179tJsE1P0D6Hl3pK/m4DwKrb?=
 =?iso-8859-1?Q?/RC/DBxxoI2P5YHUZwWYEbXFuCzXc78fSqmBdeR0XJhEWMWDBi5QglBrVb?=
 =?iso-8859-1?Q?Ux7dyFSC7v0m6u4pkfmyEOg7Bjuk1E4RbZgpQLA2h7S18/u77vAs63pxzK?=
 =?iso-8859-1?Q?0yWy3Dz6/gKuibKw35ysWAI40heVBSoNxCZ9xDY5yedNnZc3ESGP25Cigy?=
 =?iso-8859-1?Q?AXgFwg/MNQ60v/Fvgk2LxoHX91GIap/mtOcIZMu3oQRS2B0Ali7NNcFPFX?=
 =?iso-8859-1?Q?P4lVjR8BRnx63So0yafg548BPLMUzcU/xLYjFBq/3VrAb8jiaiU8jc8JUV?=
 =?iso-8859-1?Q?gPCtQDz1Lo0FN7smfT9WbpnSya5w3pAqXDw5oTv0CGtuz20kqLOG0s/sO+?=
 =?iso-8859-1?Q?0VqGpKkPAxCccJYH/3X0OXckIEe9T/KDqcOFGlU/0TCTADDDc43r4VIR/J?=
 =?iso-8859-1?Q?EdKhy44idHZjcUVWpv7+ra0DF4KWKNdIpqe7lTCKGBVCyhP1GnT4mcHsv6?=
 =?iso-8859-1?Q?DYE/MAZp8oUTMq4JosG12syDKbuwOlSHW1BeXS6X4Xg9rQEsmfIyxeAWVl?=
 =?iso-8859-1?Q?RhdNcstZo/cE27CdsClHptv4ldZjAc3opNAi8y1YQbSiPiFyjJ8D8g6Pq/?=
 =?iso-8859-1?Q?ExG2gE5Nt+50AGMC/MAPAY4s4Zc7h7m0g7g1ioUaqYAqVX/q9Z9ehJxiCr?=
 =?iso-8859-1?Q?46fY+C6GznTj7IkJD5OO7P3M9qt2mHxhSUymc8bQ1oLUWO+G/UyJ2AMQJ3?=
 =?iso-8859-1?Q?iaXYPQTCbQFMzpAANYD68bk322Zp394wOKScFWlrdOltQ7GnMyDuwwbLAz?=
 =?iso-8859-1?Q?XiwiRzndUU9mmfRcjOubDHEf0QaxskzvW2alQIDx8kujtWdeFzW/nZzsdX?=
 =?iso-8859-1?Q?/Yg8lQkTZVhrAUyyKuwWfiq8nkx+DQZvBft1WrMOVPHtRGfqfsdo8LzhBN?=
 =?iso-8859-1?Q?a1PVuNYvqLPdVuzhfviaLstliXo9Vx0BM0wSKTyhpYJVcl10yuXU9LO1AE?=
 =?iso-8859-1?Q?u+oTcjVEYRUgqSY7Mn7ouIZfFYYigsXUyip8o9AqGtWkfQsrOCQggvzWWo?=
 =?iso-8859-1?Q?TsDcbH+164MSMf6wMr3IK2sLH6nyUkgXi7TBfxtS5DiJOBUQ2ZNUXNNDsD?=
 =?iso-8859-1?Q?oKRVvpR02lFZicr/Gtx0/bo83O5sFKF+uJrpOKAH6OiXZ3iE2FkiTjdqcx?=
 =?iso-8859-1?Q?o7mvQXND/HADNA4ySnnnsjlzXOSAAiUGEO9H7sRCv5mPQKfj1ie6Eq662W?=
 =?iso-8859-1?Q?MmnFLW648eArCu0Lxm/OF131spbNE8pYs8yPvl7Z4rzLWQQLgQREnt8dLZ?=
 =?iso-8859-1?Q?YYBX5ODYvDKJvg7M9oNIiNY2yxwK6MMIug?=
X-MS-Exchange-CrossTenant-Network-Message-Id: af025c2b-7c83-4474-896b-08db9213c393
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2023 22:16:18.7779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mPCdOEar+gn3FOLS1ZP+gLu05Z7IdccrMmh+uBFUMVh3cHGzMAe+ZZ1sdgzAUd397EHkze806o8UvKZfYeTUVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6222
X-OriginatorOrg: intel.com

Verma, Vishal L wrote:
> On Thu, 2023-07-27 at 14:21 -0700, Ira Weiny wrote:
> > Previously CXL event testing was run by hand.  This reduces testing
> > coverage including a lack of regression testing.
> > 
> > Add a CXL test as part of the meson test infrastructure.  Passing is
> > predicated on receiving the appropriate number of errors in each log.
> > Individual event values are not checked.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > ---
> >  test/cxl-events.sh | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  test/meson.build   |  2 ++
> >  2 files changed, 70 insertions(+)
> 
> Hi Ira,
> 
> Thanks for adding this test. Just a few minor comments below, otherwise
> looks good.

Thanks!

> 
> > 
> > diff --git a/test/cxl-events.sh b/test/cxl-events.sh
> > new file mode 100644
> > index 000000000000..f51046ec39ad
> > --- /dev/null
> > +++ b/test/cxl-events.sh
> > @@ -0,0 +1,68 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (C) 2023 Intel Corporation. All rights reserved.
> > +
> > +. $(dirname $0)/common
> > +
> > +set -ex
> > +
> > +trap 'err $LINENO' ERR
> > +
> > +check_prereq "jq"
> > +
> > +modprobe -r cxl_test
> > +modprobe cxl_test
> > +
> > +dev_path="/sys/bus/platform/devices"
> > +
> > +test_cxl_events()
> > +{
> > +       memdev="$1"
> > +
> > +       echo "TEST: triggering $memdev"
> > +       echo 1 > $dev_path/$memdev/event_trigger
> 
> Quote the "$variables" here. We don't expect spaces in the path in this
> case, so it will still work, but it is good practice to always quote
> everything.

Done.

> 
> We might also need a test to see if this file exists first. For kernels
> that don't have this support, we probably want to print a message and
> skip the test (return '77').

Good idea.

> 
> > +}
> > +
> > +readarray -t memdevs < <("$CXL" list -b cxl_test -Mi | jq -r '.[].host')
> > +
> > +echo "TEST: Prep event trace"
> > +echo "" > /sys/kernel/tracing/trace
> > +echo 1 > /sys/kernel/tracing/events/cxl/enable
> > +echo 1 > /sys/kernel/tracing/tracing_on
> > +
> > +# Only need to test 1 device
> > +#for memdev in ${memdevs[@]}; do
> > +#done
> 
> Probably just remove the commented out loop, if we need to test more
> than one memdev in the future, it is easy enough to add back then.

Done.

> 
> > +
> > +test_cxl_events "$memdevs"
> 
> Shouldn't use "$memdevs" here since it is an array. If you want to pass
> in just the first memdev, use "${memdevs[0]}"

Ah yea caught my hack ;-)  done.

> 
> > +
> > +echo 0 > /sys/kernel/tracing/tracing_on
> > +
> > +echo "TEST: Events seen"
> > +cat /sys/kernel/tracing/trace
> > +num_overflow=$(grep "cxl_overflow" /sys/kernel/tracing/trace | wc -l)
> > +num_fatal=$(grep "log=Fatal" /sys/kernel/tracing/trace | wc -l)
> > +num_failure=$(grep "log=Failure" /sys/kernel/tracing/trace | wc -l)
> > +num_info=$(grep "log=Informational" /sys/kernel/tracing/trace | wc -l)
> 
> Minor nit, but you can 'grep -c' instead of 'grep | wc -l'

Ok Done.

> 
> Also could put /sys/kernel/tracing/trace into a variable just for
> readability since it is used many times.

Done.

> 
> > +echo "     LOG     (Expected) : (Found)"
> > +echo "     overflow      ( 1) : $num_overflow"
> > +echo "     Fatal         ( 2) : $num_fatal"
> > +echo "     Failure       (16) : $num_failure"
> > +echo "     Informational ( 3) : $num_info"
> > +
> > +if [ "$num_overflow" -ne 1 ]; then
> > +       err "$LINENO"
> > +fi
> > +if [ "$num_fatal" -ne 2 ]; then
> > +       err "$LINENO"
> > +fi
> > +if [ "$num_failure" -ne 16 ]; then
> > +       err "$LINENO"
> > +fi
> > +if [ "$num_info" -ne 3 ]; then
> > +       err "$LINENO"
> > +fi
> 
> Perhaps define variables for each of the expected nums, that way there
> is only one spot to change in case the numbers change in the future.

Good idea, done.

V2 on it's way soon, thanks for looking,
Ira

> 
> > +
> > +check_dmesg "$LINENO"
> > +
> > +modprobe -r cxl_test
> > diff --git a/test/meson.build b/test/meson.build
> > index a956885f6df6..a33255bde1a8 100644
> > --- a/test/meson.build
> > +++ b/test/meson.build
> > @@ -155,6 +155,7 @@ cxl_sysfs = find_program('cxl-region-sysfs.sh')
> >  cxl_labels = find_program('cxl-labels.sh')
> >  cxl_create_region = find_program('cxl-create-region.sh')
> >  cxl_xor_region = find_program('cxl-xor-region.sh')
> > +cxl_events = find_program('cxl-events.sh')
> >  
> >  tests = [
> >    [ 'libndctl',               libndctl,                  'ndctl' ],
> > @@ -183,6 +184,7 @@ tests = [
> >    [ 'cxl-labels.sh',          cxl_labels,        'cxl'   ],
> >    [ 'cxl-create-region.sh',   cxl_create_region,  'cxl'   ],
> >    [ 'cxl-xor-region.sh',      cxl_xor_region,     'cxl'   ],
> > +  [ 'cxl-events.sh',          cxl_events,         'cxl'   ],
> >  ]
> >  
> >  if get_option('destructive').enabled()
> > 
> > ---
> > base-commit: 2fd570a0ed788b1bd0971dfdb1466a5dbcb79775
> > change-id: 20230726-cxl-event-dc00a2f94b60
> > 
> > Best regards,
> 


