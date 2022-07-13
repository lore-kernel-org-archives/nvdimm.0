Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6884A0A
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 19:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657741684; x=1689277684;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=EB28zUaah4L5H4eLVl+0hPn4J3P1XZZ2HuNovFMA0eA=;
  b=DvlGEP0RTjsd8OyGTplxj69IYJfNkyph23zzRebV6xzduI7mscnyOauO
   gJwUDxcfe/BSVxedIRIOCXK8yqP/U2nqnfQLKaMSWSzH9c2cpAa+ttqXd
   WNGKyIZfKXVk6GXuHCMjCWHaejELIxyQ4fwXGzZchlkiIlt+MRl+M1bKS
   XjU780T/ALVfoq3M9TG0B7wlZqao16+nXC9Go4zMlJtlTXCi70Q7xFdSq
   Htg6HlK4SklaPTP20ms1iSgsZgV2tpWp0uJaA+ELVHgaAZ7xqn+0uqR6O
   6bSCMvzxC/tZMh64iyiIEbnixrfIM6k/TbXJzr/ynZXOBkm2oty0uj6mz
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="265118611"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="265118611"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 12:48:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="653544263"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga008.fm.intel.com with ESMTP; 13 Jul 2022 12:48:04 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 12:48:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 12:48:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Jul 2022 12:48:03 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Jul 2022 12:48:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjUhZx6WMAPd7M4OwCtmA4RO508WRIowXPYksNf7mgFyLBH+yDU9I5Cn+EfLNlkyUJf4Yx8M31l9k6KPl8/m0Gn8D/tk0p/tEytcuHm5GhuVjXCBBuPbA5A5FnfMd7wcvtVn3p5zD6jrzOo+3s7B8ofRTs/Au5WvszZ0LX45AJ+HYIAJbBuTG8gZh63LYkNDl4BoRoq/+U70OY6TGk3Fn0cn0uULbOvSKarBuUdLSDVqK4FWFdbDrBirsksMxdIxu2qbR/xlXMXwoQ6Wtqs6rS8S9me6RJdj7lUKrubROE5o3z1KaIBcFywtejrJ42oogRr7RpH8zh4VWJIAKJTRag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hkxu/vkfjRSrcQj3mxkdgg9T1dyFy+cVzv1A1Joncso=;
 b=U9VbrwSMbwOAujBWsZrMNo+IwdI2nUb+U6MAygpg+8tVkH2mvYEzaJJ7wgW2z6s+eWPU9Er8EG21DWlvbju7LdlDeaTESCT444NctOZYjZBHdlHUWK0/FmVVs9SI/YF2yQAcWWH4DqOsTopK2UfQMV0y4QgpeBs2m83T+j45UxgGo7my39qPJ4HuMtTGFgEeIYn4umIKgfDD+GRJlQ7Zr+48x8Vf2k3tV05mrhxUen3jXjz0JA6jmUa5JhYrUOeHZ1y/Mx7faiPSEKF49GvT8POQHhFHswfA3p1uede98y43n8yW78g7vZtUTecznlemW7HB0DeJjdLA+Pg3x217Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by BN6PR11MB1795.namprd11.prod.outlook.com
 (2603:10b6:404:101::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Wed, 13 Jul
 2022 19:48:01 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5417.026; Wed, 13 Jul
 2022 19:48:01 +0000
Date: Wed, 13 Jul 2022 12:47:59 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "dave@stgolabs.net"
	<dave@stgolabs.net>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "a.manzanares@samsung.com"
	<a.manzanares@samsung.com>
Subject: Re: [ndctl PATCH] cxl/test: add a test to {read,write,zero}-labels
Message-ID: <62cf216eec5d2_156c6529447@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220713075157.411479-1-vishal.l.verma@intel.com>
 <20220713185018.lfrq6uunaigpc6u2@offworld>
 <bc5a8df2dc71ce95c852c64f0323f2f79cba1d29.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bc5a8df2dc71ce95c852c64f0323f2f79cba1d29.camel@intel.com>
X-ClientProxiedBy: BY5PR17CA0024.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::37) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b617350a-818c-4383-084b-08da650897dc
X-MS-TrafficTypeDiagnostic: BN6PR11MB1795:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZBN4PQgwB+TPZqF4pYLnawv2s8RgLoAGf9A8wphWnYGWQ4EBOmjXVffSgQKaGxSJAa9Mb9oZ1kvhARx2j61rynmPwEz8tp7EW3l5pvGoINOpXCsLWGrgF+MzMd4TdvwGMIZoMh7MLZhuXwGOglYKyB+Eis2DCkDWNxCJY0/j2ZP/o84dNfz9i213R+CDo7ZRVdTSB4DPdU/phoCyNhFacc39HHeN7719b3FhOTYbCp/u59uughrWSTM/TgVb4ihiXQUauBzvK/R8xMN/7Ce9fJ4KghRNgRPMaMaKPSZX4rVtAMWQqnCNYYUCH1kJ6yhAvzg73ZcVmtjjRq/06m89kcADFI8TlQGJS/j74is0QeTn48Oqtluf0sevP75AQdUjlMOqTIWeKd3cA28OhYB9IhOoIEvT7VE4zJv2DiIWa+8uBup3nzkjrZ3D8/ulJUG+nZSxCENp1y7ZZlYj2UPkcqEHkTIiGmJuOeCvIDCQc38ktrnrH+/zjdn17Sn72bxZjneY7NVDvi5ZoMps5G9w8m374z6qBT4fWAQOf32yXzm84WEsOyJ1QmNiPioJiPk5xbjxKwdgwJ1+tdGgOVkPL7Br58B/7DYywJRTdmYIbJ5IaaB19cb9jBI3Lw06MIow+jeyp8fgvoTqvT/kI7Tz5eZnncyqoS9BDEtphaWiyPzifKWWnkUjA0LFCtmEKt918SIfllKLPD+d2w4bVxO9ghzhgGUXRhfqZf2H9SpjkjKf+U94wAznQQH3aY47LlDvqSYNsiPwzwC8KKMZsuFZ+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(396003)(39860400002)(346002)(376002)(2906002)(5660300002)(8936002)(4326008)(66476007)(66556008)(8676002)(66946007)(316002)(54906003)(110136005)(6486002)(41300700001)(478600001)(9686003)(6512007)(82960400001)(6506007)(186003)(86362001)(38100700002)(26005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?bHU7Tl7Heboa+WKFYbBkGHuecrIhUVktICM/hcUvgoeMBdxc+GC4SFlGwQ?=
 =?iso-8859-1?Q?Dz9BPP6B2tvn1StGIEa1hYJ5A8JyJ3hAAJ4KiLVB/AOBpheCEY1so2F4fN?=
 =?iso-8859-1?Q?1SWrs2DMafSUui7/TJaqp1VW3+NZ7q+KnBOL5KmcqMRnBPofZkV78M/MVe?=
 =?iso-8859-1?Q?fitoIypkvwJpomPANZkLkM3IlbFVLdljVdqgWyn3/+TaFmZKrOGXjgCOxA?=
 =?iso-8859-1?Q?2rjXU2KRLJzYaq4qGpMNW6KK/+ofkgmFqGjehjdt9nSZ91I2mvPUGFW7Po?=
 =?iso-8859-1?Q?js/cQ9fGMm9d/YioEXficgNs4a76iMqkZbyxKM8KwyVAMifzR4nE+X1gjQ?=
 =?iso-8859-1?Q?0Cw9mvmtXjAMDVY2+Z6jF0QyDZnEdZ+V8U/QlkjQfacgyx68TH5VTDmCNl?=
 =?iso-8859-1?Q?a3D5v0sln69O/FdXXOsS3tR5CzZkSZIkK7WPiJECTIFGsolstw1DI+SyUG?=
 =?iso-8859-1?Q?wrww89k6zeGOYURqHiBh/zTArHuagG3ghgpuRTdiFaMiPtXN94I6ZM7ZIu?=
 =?iso-8859-1?Q?lGmolG0hn9jKqaiHfoiULZ04xaFCrV7flpomZT1UHiz1oFvukR6Yoh2Hvn?=
 =?iso-8859-1?Q?LLQiglR/HTX06rahlfnQCyk653d7obdyR0I4ydUWLwlhhgQvjqu+Pk7f8Q?=
 =?iso-8859-1?Q?EJApt8R5Qwp5p8RPZoy8Klvaq/w6enxtABuajOzsSrejJ+gqHcaCPyi84b?=
 =?iso-8859-1?Q?Xapiix0SiieSBa/F1qWek1l9BixdOJC4H+GqYDDreKVuzil9bMayLnaOiG?=
 =?iso-8859-1?Q?3gYx3pnIuAhNZQe+qbtO0A/hcfULMQFHHZfdCSqJcxI044b1aKO4aeJiOf?=
 =?iso-8859-1?Q?1AES/wR4UuJIe1TEiizovlaS/wFE4qgrfZib9uSvkstam041DvfT2mmajE?=
 =?iso-8859-1?Q?ACeC8oTeOIu/JI7uueLhHWqJXO2O7ZtPcj9vguwCqqJ2KOQldGKsr9NtJY?=
 =?iso-8859-1?Q?hkqyucfvr6iYlcdeXmHUpy3A41vClQ9WYv1FzuI+Nc46EIHiwU5yWI7DsI?=
 =?iso-8859-1?Q?13p7YwMy84u9iaKRkMarnYQdltdwGG/f4mlZ7Fw9LMh+gfvFKYVjwZu2cb?=
 =?iso-8859-1?Q?fLh35fflSW0P5ontvp4JI3G4ZPNZcOCY47NrdQhWyl7z1+aRUc0eJJPV9Z?=
 =?iso-8859-1?Q?hrJR9oYk707PGAc2DyFmQu9ucnt5Blz8VpUishrattrPVqVgANUFI63UNo?=
 =?iso-8859-1?Q?M75CBXrS30Iw5306ovvJbfzLtSoDO5er7b7RBkQpfpJtsBqAa/2DBH9apE?=
 =?iso-8859-1?Q?8m33Up+WrVayGrolIxa5OPQtFq/BbUrzbRYJngQRawuPb1NY5tJeRDAXoG?=
 =?iso-8859-1?Q?+Nx+Da1nMWAyJuEtEsGK74eDl+ZY/2metCqo9As/pIk7hFukqLRvfkd5N8?=
 =?iso-8859-1?Q?TTsyE0N9+kmKbSbbz/7j0Y4ekX7Xgw93euoK8+E52Fd3+POXeb3YPOdiWU?=
 =?iso-8859-1?Q?mpLcyoEsTy3OQyttH29BOnKTnfz2de9P739EsuG2t7IwuTak+xkM0yFprr?=
 =?iso-8859-1?Q?yRsU+z2449OtVnzsgNXcXvNMnyYr6Jdj0Ym5aJO9ke2ERr4nUt6GB8bFrP?=
 =?iso-8859-1?Q?pYpoGSuzOXDJRcRypLjsiF/x1RzFBxa9PNrYtUldGhcNfRQlCfS1AZLnoY?=
 =?iso-8859-1?Q?1piFOR+Y+bj+foF4NNNpR5Xu3SBaJbrK9Op0W/j7Myk/hXbVoggNVW7g?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b617350a-818c-4383-084b-08da650897dc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 19:48:00.9519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4YisQ2DGAMa/3jKeTuLsYC1I61m+ekxRhXoSXItP6tlrPP3oDXGPwU4aigeBca+1I3czVATxIRoTlNajQ3byVT8l5AzbJ7LysG0tHldvj70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1795
X-OriginatorOrg: intel.com

Verma, Vishal L wrote:
> On Wed, 2022-07-13 at 11:50 -0700, Davidlohr Bueso wrote:
> > On Wed, 13 Jul 2022, Vishal Verma wrote:
> > 
> > > Add a unit test to test writing, reading, and zeroing LSA aread for
> > > cxl_test based memdevs using ndctl commands.
> > > 
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > > ---
> > > test/cxl-labels.sh | 53 ++++++++++++++++++++++++++++++++++++++++++++++
> > > test/meson.build   |  2 ++
> > > 2 files changed, 55 insertions(+)
> > > create mode 100644 test/cxl-labels.sh
> > > 
> > > diff --git a/test/cxl-labels.sh b/test/cxl-labels.sh
> > > new file mode 100644
> > > index 0000000..ce73963
> > > --- /dev/null
> > > +++ b/test/cxl-labels.sh
> > > @@ -0,0 +1,53 @@
> > > +#!/bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (C) 2022 Intel Corporation. All rights reserved.
> > > +
> > > +. $(dirname $0)/common
> > > +
> > > +rc=1
> > > +
> > > +set -ex
> > > +
> > > +trap 'err $LINENO' ERR
> > > +
> > > +check_prereq "jq"
> > > +
> > > +modprobe -r cxl_test
> > > +modprobe cxl_test
> > > +udevadm settle
> > > +
> > > +test_label_ops()
> > > +{
> > > +       nmem="$1"
> > > +       lsa=$(mktemp /tmp/lsa-$nmem.XXXX)
> > > +       lsa_read=$(mktemp /tmp/lsa-read-$nmem.XXXX)
> > > +
> > > +       # determine LSA size
> > > +       "$NDCTL" read-labels -o "$lsa_read" "$nmem"
> > > +       lsa_size=$(stat -c %s "$lsa_read")
> > > +
> > > +       dd "if=/dev/urandom" "of=$lsa" "bs=$lsa_size" "count=1"
> > > +       "$NDCTL" write-labels -i "$lsa" "$nmem"
> > > +       "$NDCTL" read-labels -o "$lsa_read" "$nmem"
> > > +
> > > +       # compare what was written vs read
> > > +       diff "$lsa" "$lsa_read"
> > > +
> > > +       # zero the LSA and test
> > > +       "$NDCTL" zero-labels "$nmem"
> > > +       dd "if=/dev/zero" "of=$lsa" "bs=$lsa_size" "count=1"
> > > +       "$NDCTL" read-labels -o "$lsa_read" "$nmem"
> > > +       diff "$lsa" "$lsa_read"
> > > +
> > > +       # cleanup
> > > +       rm "$lsa" "$lsa_read"
> > > +}
> > > +
> > > +# find nmem devices corresponding to cxl memdevs
> > > +readarray -t nmems < <("$NDCTL" list -b cxl_test -Di | jq -r '.[].dev')
> > 
> > s/$NDCTL/$CXL
> > 
> > Beyond sharing a repo, I would really avoid mixing and matching ndctl and cxl
> > tooling and thereby keep them self sufficient. I understand that there are cases
> > where pmem specific operations can can be done reusing relevant pmem/nvdimm/ndctl
> > machinery and interfaces, but I don't see this as the case for something like lsa
> > unit testing.
> > 
> > Thanks,
> > Davidlohr
> > 
> Hi David,
> 
> Thanks for the review - however this was intentional. cxl-cli may block
> LSA write access because libnvdimm could 'own' the label space.
> 
>   cxl memdev: action_write: mem0: has active nvdimm bridge, abort label write
> 
> So the test has to use ndctl for label writes. Reads could be done with
> 'cxl', but for now there isn't a good/predictable mapping between ndctl
> 'nmemX' and cxl 'memX'. Once that is solved, either by a shared id
> allocator, or by listings showing the nmem->mem mapping, I will at
> least add another cxl read-labels here which would validate the same
> LSA data through cxl-cli.

I do think this test should eventually do both to validate that the
nvdimm passthrough and the native CXL operations are working. However,
the native CXL case needs a bit more infrastructure to disconnect the
memdev from nvdimm.  Something like:

    cxl disable-pmem mem0
    cxl write-labels mem0 ...

You can add a "cxl read-labels" test though since that is not blocked
while the memdev is attached to nvdimm, only label writes.
