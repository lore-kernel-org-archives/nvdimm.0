Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 227F321BADAB2
 for <linux-nvdimm@lists.01.org>; Fri,  3 Aug 2018 14:35:27 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2] ndctl, test: add a new unit test for
 max_available_extent namespace
Date: Fri, 3 Aug 2018 21:35:14 +0000
Message-ID: <1533332112.8557.98.camel@intel.com>
References: <20180803185219.16242-1-msys.mizuma@gmail.com>
In-Reply-To: <20180803185219.16242-1-msys.mizuma@gmail.com>
Content-Language: en-US
Content-ID: <CBE16070B2F6D3498A458D77D267CBC0@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "msys.mizuma@gmail.com" <msys.mizuma@gmail.com>
Cc: "m.mizuma@jp.fujitsu.com" <m.mizuma@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2018-08-03 at 14:52 -0400, Masayoshi Mizuma wrote:
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> 
> Add a new unit test to test max_available_extent namespace.
> This feature is implemented by the following patches.
> 
>   kernel side:
>     https://lists.01.org/pipermail/linux-nvdimm/2018-July/016731.html
>     https://lists.01.org/pipermail/linux-nvdimm/2018-July/016732.html
> 
>   ndctl side:
>     https://lists.01.org/pipermail/linux-nvdimm/2018-July/017176.html
> 
> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> ---
>  test/Makefile.am                |  3 ++-
>  test/max_available_extent_ns.sh | 43 +++++++++++++++++++++++++++++++++
>  2 files changed, 45 insertions(+), 1 deletion(-)
>  create mode 100755 test/max_available_extent_ns.sh
> 
> diff --git a/test/Makefile.am b/test/Makefile.am
> index 8c55056..9af2464 100644
> --- a/test/Makefile.am
> +++ b/test/Makefile.am
> @@ -22,7 +22,8 @@ TESTS =\
>  	firmware-update.sh \
>  	ack-shutdown-count-set \
>  	rescan-partitions.sh \
> -	monitor.sh
> +	monitor.sh \
> +	max_available_extent_ns.sh
>  
>  check_PROGRAMS =\
>  	libndctl \
> diff --git a/test/max_available_extent_ns.sh b/test/max_available_extent_ns.sh
> new file mode 100755
> index 0000000..beea3bd
> --- /dev/null
> +++ b/test/max_available_extent_ns.sh
> @@ -0,0 +1,43 @@
> +#!/bin/bash -Ex
> +
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright(c) 2018, FUJITSU LIMITED. All rights reserved.
> +
> +rc=77
> +
> +. ./common
> +
> +trap 'err $LINENO' ERR
> +
> +check_min_kver "4.19" || do_skip "kernel $KVER may not support max_available_size"
> +
> +init()
> +{
> +	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
> +	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
> +	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
> +}
> +
> +do_test()
> +{
> +	region=$($NDCTL list -b $NFIT_TEST_BUS0 -R -t pmem | jq -r .[].dev | head -1)

On my test setup, this fails because the region returned is the 32M
one. This causes the namespaces requested to be 8M sized, which is too
small, and hence rejected (16M minimum).

The following jq query sorts it in descending size order and lets it
choose the 64M region:

	jq -r 'sort_by(-.size) | .[].dev'

> +
> +	available_sz=$($NDCTL list -r $region | jq -r .[].available_size)
> +	size=$(( available_sz/4 ))
> +
> +	NS1=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r .dev)
> +	NS2=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r .dev)
> +	NS3=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r .dev)

Since these happen in a subshell, errors are lost.
Running in a subshell is fine, but we should test that the variables
weren't blank:

	test -n "$NS1"

And so on.

> +
> +	$NDCTL disable-namespace $NS2
> +	$NDCTL destroy-namespace $NS2
> +
> +	$NDCTL create-namespace -r $region -t pmem
> +}
> +
> +modprobe nfit_test
> +rc=1
> +init
> +do_test
> +_cleanup
> +exit 0
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
