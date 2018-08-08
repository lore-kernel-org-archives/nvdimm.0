Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 60E9B210DC1A0
 for <linux-nvdimm@lists.01.org>; Wed,  8 Aug 2018 11:19:48 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v3] ndctl, test: add a new unit test for
 max_available_extent namespace
Date: Wed, 8 Aug 2018 18:19:46 +0000
Message-ID: <1533752384.7673.1.camel@intel.com>
References: <20180808013545.4541-1-msys.mizuma@gmail.com>
In-Reply-To: <20180808013545.4541-1-msys.mizuma@gmail.com>
Content-Language: en-US
Content-ID: <737ACCB7E95F1C418D51054F9E7477C3@intel.com>
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


On Tue, 2018-08-07 at 21:35 -0400, Masayoshi Mizuma wrote:
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
>  test/max_available_extent_ns.sh | 46 +++++++++++++++++++++++++++++++++
>  2 files changed, 48 insertions(+), 1 deletion(-)
>  create mode 100755 test/max_available_extent_ns.sh

Thanks for the update, looks good now.

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
> index 0000000..1c7e7bf
> --- /dev/null
> +++ b/test/max_available_extent_ns.sh
> @@ -0,0 +1,46 @@
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
> +	region=$($NDCTL list -b $NFIT_TEST_BUS0 -R -t pmem | jq -r 'sort_by(-.size) | .[].dev' | head -1)
> +
> +	available_sz=$($NDCTL list -r $region | jq -r .[].available_size)
> +	size=$(( available_sz/4 ))
> +
> +	NS=()
> +	for ((i=0; i<3; i++))
> +	do
> +		NS[$i]=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r .dev)
> +		[[ -n ${NS[$i]} ]]
> +	done
> +
> +	$NDCTL disable-namespace ${NS[1]}
> +	$NDCTL destroy-namespace ${NS[1]}
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
