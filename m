Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D5CFA210D851B
 for <linux-nvdimm@lists.01.org>; Fri,  3 Aug 2018 10:09:34 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCHv4] ndctl: Use max_available_extent for namespace
Date: Fri, 3 Aug 2018 17:09:33 +0000
Message-ID: <1533316172.8557.70.camel@intel.com>
References: <20180724223125.14288-1-keith.busch@intel.com>
 <8f57ae0d-3ab0-f3ce-160c-9d02cf9fe062@gmail.com>
 <1533239603.8557.64.camel@intel.com>
 <50ef3aee-097a-d9f2-cc2a-1c8773106073@gmail.com>
 <c8fdf822-edd6-f87f-f191-965fff9f5f36@gmail.com>
In-Reply-To: <c8fdf822-edd6-f87f-f191-965fff9f5f36@gmail.com>
Content-Language: en-US
Content-ID: <DFFAD1D8EB110B4E9D9AE76D9F879EE9@intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "msys.mizuma@gmail.com" <msys.mizuma@gmail.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2018-08-03 at 12:26 -0400, Masayoshi Mizuma wrote:
> Hi Vishal,
> 
> On 08/02/2018 04:42 PM, Masayoshi Mizuma wrote:
> ...
> > > If you also wanted to package up this script as a unit test, I'd be
> > > happy to include it. Would be gated on KVER=4.19
> > 
> > Sounds great :-) 
> > Here is the patch for unit test:
> > 
> > --------
> > From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> > Date: Thu, 2 Aug 2018 16:20:45 -0400
> > Subject: [PATCH] ndctl, test: add a new unit test for max_available_extent
> >  namespace
> > 
> > Add a new unit test to test max_available_extent namespace.
> > This function is implemented by the following patches.
> > 
> >   kernel side:
> >     https://lists.01.org/pipermail/linux-nvdimm/2018-July/016731.html
> >     https://lists.01.org/pipermail/linux-nvdimm/2018-July/016732.html
> > 
> >   ndctl side:
> >     https://lists.01.org/pipermail/linux-nvdimm/2018-July/017176.html
> > 
> > Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> > ---
> >  test/Makefile.am                |  3 ++-
> >  test/max_available_extent_ns.sh | 43 +++++++++++++++++++++++++++++++++
> >  2 files changed, 45 insertions(+), 1 deletion(-)
> >  create mode 100755 test/max_available_extent_ns.sh
> > 
> > diff --git a/test/Makefile.am b/test/Makefile.am
> > index 8c55056..9af2464 100644
> > --- a/test/Makefile.am
> > +++ b/test/Makefile.am
> > @@ -22,7 +22,8 @@ TESTS =\
> >  	firmware-update.sh \
> >  	ack-shutdown-count-set \
> >  	rescan-partitions.sh \
> > -	monitor.sh
> > +	monitor.sh \
> > +	max_available_extent_ns.sh
> >  
> >  check_PROGRAMS =\
> >  	libndctl \
> > diff --git a/test/max_available_extent_ns.sh b/test/max_available_extent_ns.sh
> > new file mode 100755
> > index 0000000..4a44625
> > --- /dev/null
> > +++ b/test/max_available_extent_ns.sh
> > @@ -0,0 +1,43 @@
> > +#!/bin/bash -Ex
> > +
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright(c) 2018, FUJITSU LIMITED. All rights reserved.
> > +
> > +rc=77
> > +
> > +. ./common
> > +
> > +trap 'err $LINENO' ERR
> > +
> > +check_min_kver "4.19" || do_skip "kernel $KVER may not support max_available_size"
> > +
> > +init()
> > +{
> > +	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
> > +	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
> > +	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
> > +}
> > +
> > +do_test()
> > +{
> > +	region=$($NDCTL list -b nfit_test.0 -R -t pmem | jq -r .[].dev | head -1)
> 
> nfit_test.0 here should be changed to $NFIT_TEST_BUS0.
> Please let me know if I should send the v2 patch.

Ah yes good catch. I hadn't gotten around to applying it yet, so yeah
please send a v2

Thanks,
	-Vishal

> 
> Thanks!
> Masa
> 
> > +
> > +	available_sz=$($NDCTL list -r $region | jq -r .[].available_size)
> > +	size=$(( available_sz/4 ))
> > +
> > +	NS1=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r .dev)
> > +	NS2=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r .dev)
> > +	NS3=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r .dev)
> > +
> > +	$NDCTL disable-namespace $NS2
> > +	$NDCTL destroy-namespace $NS2
> > +
> > +	$NDCTL create-namespace -r $region -t pmem
> > +}
> > +
> > +modprobe nfit_test
> > +rc=1
> > +init
> > +do_test
> > +_cleanup
> > +exit 0
> > 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
