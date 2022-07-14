Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF407E
	for <nvdimm@lists.linux.dev>; Thu, 14 Jul 2022 21:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657833252; x=1689369252;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Jk9+9H3qyw7mGM/Uw2RhL7u10Crj082M6nuWSFie+H0=;
  b=Qugkw/8MKP98b41jblABKr+Sm+SNGee9MidprObgd4BifsET6reOy2ft
   5cOSolA75fs0xg9hGB7w5FW/40mbYXRicfBuDEEXbJqPcFKEEotR8tePO
   sSg9VpuU8q0v8Cc6y4VWyYa4yKZ8wphzr24Ne/PZq8ZaG2M3hSa9aNZwi
   vt2OgHLw8nyU7B6zAnDvQkNNjo3Ab+2L9gXv6rdml/gjunjgTfIufbNVQ
   Jvb1Epo8xUJbniNxjuZ82/7e5+hb/x1LlvGa/ga5CgbCDPji7qV+KfYTF
   IerfhltDqKY1trmthjdkCRxqJ6BsFelqLmESy26o98UDd5KTOoTHBY7MX
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="265420236"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="265420236"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 14:14:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="738419212"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga001.fm.intel.com with ESMTP; 14 Jul 2022 14:14:12 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Jul 2022 14:14:11 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Jul 2022 14:14:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Jul 2022 14:14:11 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Jul 2022 14:14:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfnr9EQFZR0tfnOBePGXZ/TFe6T1Z2kLl3OmWMojLMfAPjy/JiV0QDx4e6HC8V7OxRaIyAJfYq/aMgjBzm4l1c/2lW3x7kjf160Gs7kh6o1yfIeEPSs/Wih9zXcViM9nu73kbR/B/zfQvTK18OIZVOrfLOL9Ytq2ilPaEstIuC8qkKUwQV9NlQAqjl1sCPBM+YiEnZnfxJm1HNRPGoYH2FYZMdLxq3vCBWchi8Its2jaqVYfrSbsVAlCnMuHBka9CWEiWSumnXR6sePaQL7K7gxwUEOgdmvu8xdg3CESKlu1k83ZVZTyT2FXrsbtUG4a36M4Hve+ngtrKLU3TmiYpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fYYeDBrWJI0vRe9wIqQ1RmyV7A3nypGj+gSvfFi55uM=;
 b=ZW5f19WPuQ8JLVpu2bprqo0YZCgX8XRCInNwvEpUPWweuk+v8wI9a7J1xTlIb36Pq4P/Tw9QfVfFUI4Qm+XCTCaJUkOvDY3tn9gR50Ouy/hvmlmWjP6c8+xi/n+l7zBc9+gAYgGK08HaZLWObfipTWJ3GqqGXkDezPFX64xxWZ4LGwtnYTlvJCaWuNZsJESnkBG72K5+8ZwyK1RY8+XaKo7k5ZxA+9AqEJXeaZOpOkHVOWzFkoMZoZUw94o5Xw9Fp4f+9wLXyOGTxAQfayvJhjOlAeNhgvB9FIf71FcjPeDfsCTpvcPXM2ciN+9m1hfxPfZ90CTTbZjyJafv3z4lpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by PH0PR11MB5045.namprd11.prod.outlook.com
 (2603:10b6:510:3f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 14 Jul
 2022 21:14:00 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5438.014; Thu, 14 Jul
 2022 21:14:00 +0000
Date: Thu, 14 Jul 2022 14:13:58 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v2 12/12] cxl/test: Checkout region setup/teardown
Message-ID: <62d08716674ca_1643dc29436@dwillia2-xfh.jf.intel.com.notmuch>
References: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
 <165781817516.1555691.3557156570639615515.stgit@dwillia2-xfh.jf.intel.com>
 <43e12941e3ca6310f18ce8c336a7ad038a1a0a5e.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43e12941e3ca6310f18ce8c336a7ad038a1a0a5e.camel@intel.com>
X-ClientProxiedBy: SJ0PR03CA0343.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::18) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 550f5ace-0a5e-4575-e93c-08da65ddc554
X-MS-TrafficTypeDiagnostic: PH0PR11MB5045:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UD/OUQPjZ8ksiH3jTIYgF/yseBkHlenTKeLB5GC6HCJnoblHtQJs2OMZ9Dm4JPITUX3b25ScvoQlxZrGZFzlkJAp8OnChxiJgBuYyLwYgZc3eOLYq8FXwDzGU9B/Hz8LIm/OCiwHm+7+VB/IJ3UGLtAImNoeaG4k8A3QtI7N7WdJf70U9YnYP9GmMVzMcNFa8dqR7WLlQk+1GU6HbkLWAx59X5wf05NVJo2hkistOEQV4jt9pS6eCdysuCkquweoPtpnv3M0cF4VWnl04rSo4pkNxYeo4mS2v7Gq8Hhnhy6C1C8F/vIiYm+F9xJVfUyv/8245tvdSZJFyQ8wfaa6h7t6zhnR038tXSRFxNsiefGgbCCq3yO+s+aIxsP7WnfqiS6KPVEjbyi8zNuR/cXBcUupgUyKzTUWRhPqyQOZz0k6rLX+p+NdHq3NsV20qKG+WD/7iOLf0nun/tLKQzFKgsKwz8F01Ru9XxcoZsnwt+9pWOkC6DtbIea9eXQ/t8Ib7XkAAit6Q0bBziE23YPy1uldrZms5615CaLYMHI5kn3gdVINyGQo2ohF8+R+4zBiA3vgYl/IEO9JQV2l6i2xxpmz/DPvvst46lkVmlf9Ceh4ijAhVfPHvad/sTSkxSBLch0lB9+ALOHEJ0b8dhzaTvFmIgYDnriYcC67Wq//T93fLXeqxXYXWfUf4K4rJ+9UWvW3S9nUfLlo+x+CQeP7baIsjmp7/tIXGX9BXhBjzePlBzfT/wuf662I24HthJLo6EHR6dInNAlrGQLq58bP2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(39860400002)(346002)(376002)(136003)(8676002)(316002)(6512007)(4326008)(66476007)(41300700001)(38100700002)(8936002)(2906002)(26005)(86362001)(478600001)(66556008)(186003)(83380400001)(6486002)(82960400001)(66946007)(5660300002)(9686003)(6506007)(54906003)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?WpepChAiH7HInti33yCM0CPPliIFretZgcm2yZMJeb3IWTpPvx1MMf62kK?=
 =?iso-8859-1?Q?keasypuFqxLNQhL89nSgk5OPfZ6rv6wtPOJBwtOO/fY6ilk5+wNs8MtA93?=
 =?iso-8859-1?Q?AVUURC12Jv3R4fJxG8c2pG7tKHbDGUokY6VIqKAAc/aU/RZe5p+BQmzfxL?=
 =?iso-8859-1?Q?ePsKTgdfnJU9Jv5VRNB29D9TSlb9mo+D9KtY85DH24XXkDJtxKapXQdIOM?=
 =?iso-8859-1?Q?axQuZYctYZUYARTXh8QsyRJGhchOq6wxTvhig1WLfaOOCV8sxNnNc0k06K?=
 =?iso-8859-1?Q?rd5vf6OQ4JjuZLyV+ZvtH08g1VbI3qhZgMFvWPwba9A3aWAWAJDryC0WT8?=
 =?iso-8859-1?Q?baQ75dh5Vz4LF7uwzy2XbCkOQX+2wxNMulY+LfSd6olqM/Y1nrPFfQmyXh?=
 =?iso-8859-1?Q?R8lSPtyJrknUh1lOaFc95r04xMKQB9G1OLy163+sZTiRecDwHrAn4yw9jl?=
 =?iso-8859-1?Q?IQzLJ1KAxmtVi1sY7W7p5PCfA9f3o7tI0kthT5wYppLi/zpjSTSRWEqa7B?=
 =?iso-8859-1?Q?DB/tk77BLokGS5prk60l9QWtOB+wuLRMQOYW2KFK21FvX9MnJQeDH+hvXi?=
 =?iso-8859-1?Q?DNDN7Rjozj89zy1e4rIs6RdIDKK1ENxuq2eHCCmzKSGgLJFI34k6wpOEtN?=
 =?iso-8859-1?Q?IBZnEh/ZfrVA382DKCkmwdh2YWVfEa9cGyiUMlSwbgjOScVk2AL9qA/LyW?=
 =?iso-8859-1?Q?T8qBYbBFaWlLQtIxTlJT24qhTf5QAf292cDphx8BZIXoKc9BreHtA12G2g?=
 =?iso-8859-1?Q?sHCl9a0jtOuPVECEVvuj9re9pHACm1AdHyA+DF410hfhRM1ZP3MeeHY9bb?=
 =?iso-8859-1?Q?k7+B3BVkNoe3sb4XeHPp39qM6mTZIk6ElT1/jL+uL9F+9rcVlhhL+4x7F1?=
 =?iso-8859-1?Q?OfqICk9IYCKrGsq7pJrKC4D+8Nx8zAC4VXoz8Y8E6moPbu9d1Aj0a8LyQM?=
 =?iso-8859-1?Q?xEPbK3Gzgb+5JNI+myqZegkwHIUvm9j/P6SeluC5VOKO8QXIvZcjDrLrQy?=
 =?iso-8859-1?Q?6UA68+FnxsYaMf/PIyJuWPxd7Z79JEldc9S2gM0XXI2YmocXm1F4roY7KT?=
 =?iso-8859-1?Q?z4aph8vIgUcet689wM/q/wlhi0gzTTqDbMiik3qgG/4UozsOLv1J0r2tKO?=
 =?iso-8859-1?Q?KpLAA36hO9BMAqUT4S/jI6L+HpAe2twIdEH7rLmqzR5ajeaVAk7zbj125G?=
 =?iso-8859-1?Q?NL6d4tc00GLFMgIqjueMrG9LkoYBl9VWC+lXMuroEbEDZx7MWojnG1lyj0?=
 =?iso-8859-1?Q?C0soJ6z8Q8aKsBIOoxi5wStQYtpX8KjUYg+D70O+67ZrURwc149vXxVNe7?=
 =?iso-8859-1?Q?E1RtGFrKEWipHW8aX0XdvuWDGeJaDYKijNKzbq5lbRvE0m8EEVM5mb5ja5?=
 =?iso-8859-1?Q?yBvcmCpv0x7KV8Ngl2mS5xyZ+ZFEET7UqYDnTcD9gGYYPKSU149uN/Swsx?=
 =?iso-8859-1?Q?UCK59/oVo16aCQb7LL7mlXkopD1uf3cIaBxltl7EkIpe1bqffpyANxKimT?=
 =?iso-8859-1?Q?wp2s/BQjMksvbOQT/Ljqd0u12dT2de2tRfHsGUOVPbk/vkJNwYoMdVrVFc?=
 =?iso-8859-1?Q?pQomZdBg+lTRN05PicGO/pcDJ8/gz1v1jJDlrw9/rLyZ2tFBq9tH1/kEzQ?=
 =?iso-8859-1?Q?hufem1kV1iLsYsdl8HxvWktLyUaA3k+8qRkcWDpqmjBCy87dDNQjOAMA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 550f5ace-0a5e-4575-e93c-08da65ddc554
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 21:14:00.0919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yi4aUUCeg2upQ/xrIPKCOj7agM29JcRYqDUbjYL7Vdgmc8FCEZPtsRRS3Or7CjsUnBFh0aFwoh/EQy/7cGNmTguoKnjDredkg4OHDvMm8cU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5045
X-OriginatorOrg: intel.com

Verma, Vishal L wrote:
> On Thu, 2022-07-14 at 10:02 -0700, Dan Williams wrote:
> > Exercise the fundamental region provisioning sysfs mechanisms of discovering
> > available DPA capacity, allocating DPA to a region, and programming HDM
> > decoders.
> > 
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  test/cxl-region-sysfs.sh |  122 ++++++++++++++++++++++++++++++++++++++++++++++
> >  test/meson.build         |    2 +
> >  2 files changed, 124 insertions(+)
> >  create mode 100644 test/cxl-region-sysfs.sh
> 
> Hi Dan,
> 
> This is mostly looking good - just one note below found in testing:
> 
> > 
> > diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
> > new file mode 100644
> > index 000000000000..2582edb3f306
> > --- /dev/null
> > +++ b/test/cxl-region-sysfs.sh
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
> > +decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
> > +         select(.pmem_capable == true) |
> > +         select(.nr_targets == 2) |
> > +         .decoder")
> > +
> > +# find the memdevs mapped by that decoder
> > +readarray -t mem < <($CXL list -M -d $decoder | jq -r ".[].memdev")
> > +
> > +# ask cxl reserve-dpa to allocate pmem capacity from each of those memdevs
> > +readarray -t endpoint < <($CXL reserve-dpa -t pmem ${mem[*]} -s $((256<<20)) |
> > +                         jq -r ".[] | .decoder.decoder")
> > +
> > +# instantiate an empty region
> > +region=$(cat /sys/bus/cxl/devices/$decoder/create_pmem_region)
> > +echo $region > /sys/bus/cxl/devices/$decoder/create_pmem_region
> > +uuidgen > /sys/bus/cxl/devices/$region/uuid
> > +
> > +# setup interleave geometry
> > +nr_targets=${#endpoint[@]}
> > +echo $nr_targets > /sys/bus/cxl/devices/$region/interleave_ways
> > +g=$(cat /sys/bus/cxl/devices/$decoder/interleave_granularity)
> > +echo $g > /sys/bus/cxl/devices/$region/interleave_granularity
> > +echo $((nr_targets * (256<<20))) > /sys/bus/cxl/devices/$region/size
> > +
> > +# grab the list of memdevs grouped by host-bridge interleave position
> > +port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
> > +           .targets | .[] | select(.position == 0) | .target")
> > +port_dev1=$($CXL list -T -d $decoder | jq -r ".[] |
> > +           .targets | .[] | select(.position == 1) | .target")
> 
> With my pending update to make memdevs and regions the default listing
> if no other top level object specified, the above listing breaks as it
> can't deal with the extra memdevs now listed.
> 
> I think it may make sense to fine tune the defaults a bit - i.e. if
> a -d is supplied, assume -D, but no other default top-level objects.

Yes, this is what I would expect.

> However I think this would be more resilient regardless, if it
> explicitly specified a -D:

True, but it's a bit redundant.

Why does the -RM default break:

   cxl list [-T] -d $decoder

...? Doesn't the final "num_list_flags() == 0" check come after:

   if (param.decoder_filter)
           param.decoders = true;

...has prevented the default?
