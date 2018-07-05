Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x22b.google.com (mail-qt0-x22b.google.com
 [IPv6:2607:f8b0:400d:c0d::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 67FC8210C6682
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 14:06:35 -0700 (PDT)
Received: by mail-qt0-x22b.google.com with SMTP id a18-v6so8333089qtj.4
 for <linux-nvdimm@lists.01.org>; Thu, 05 Jul 2018 14:06:35 -0700 (PDT)
Subject: Re: [ndctl PATCH] ndctl, test: add a new unit test for monitor
References: <20180705112304.2656-1-qi.fuli@jp.fujitsu.com>
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <df891d44-5b43-3aef-da9a-df63a4b46aae@gmail.com>
Date: Thu, 5 Jul 2018 17:06:32 -0400
MIME-Version: 1.0
In-Reply-To: <20180705112304.2656-1-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
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
To: qi.fuli@jp.fujitsu.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Qi,

I tried this test after I applied your latest monitor patches [1].
I found some points. Could you check the following?

[1] https://lists.01.org/pipermail/linux-nvdimm/2018-June/016562.html

On 07/05/2018 07:23 AM, QI Fuli wrote:
> Add a new unit test to test the follow options of the monitor command.
>    --dimm
>    --bus
>    --region
>    --namespace
>    --logfile
>    --config-file
> 
> Based-on-patch-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  test/Makefile.am |   3 +-
>  test/monitor.sh  | 115 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 117 insertions(+), 1 deletion(-)
>  create mode 100755 test/monitor.sh
> 
> diff --git a/test/Makefile.am b/test/Makefile.am
> index cd451e9..8c76462 100644
> --- a/test/Makefile.am
> +++ b/test/Makefile.am
> @@ -21,7 +21,8 @@ TESTS =\
>  	btt-pad-compat.sh \
>  	firmware-update.sh \
>  	ack-shutdown-count-set \
> -	rescan-partitions.sh
> +	rescan-partitions.sh \
> +	monitor.sh
>  
>  check_PROGRAMS =\
>  	libndctl \
> diff --git a/test/monitor.sh b/test/monitor.sh
> new file mode 100755
> index 0000000..4f113c8
> --- /dev/null
> +++ b/test/monitor.sh
> @@ -0,0 +1,115 @@
> +#!/bin/bash -Ex
> +
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright(c) 2018, FUJITSU LIMITED. All rights reserved.
> +
> +rc=77
> +logfile=""
> +conf_file=""
> +monitor_pid=65536
> +FILTER_DIMM="nmem1"

> +FILTER_BUS="ndbus1"

Is this ndbus0?
because the dimms under nfit_test.1 are not supported smart.

# ./test/smart-notify nfit_test.1
nmem5: no smart command support
nmem4: no smart command support
libdaxctl: daxctl_unref: context 0x20d41e0 released
libndctl: ndctl_unref: context 0x20d4310 released
# 

> +FILTER_BUS_MAP_DIMM="nmem0:nmem1:nmem2:nmem3"

How about getting the dimms by ndctl list command instead of hard-cording?

> +FILTER_REGION="region1"

> +FILTER_REGION_MAP_DIMM="nmem0:nmem1"

Is this "nmem0:nmem1:nmem2:nmem3"?
Or why don't you getting the dimms by ndctl list command instead of hard-cording?

# ./ndctl/ndctl list -r region1 -D
[
  {
    "dev":"nmem1",
    "id":"cdab-0a-07e0-feffffff",
    "handle":1,
    "phys_id":1
  },
  {
    "dev":"nmem3",
    "id":"cdab-0a-07e0-fefeffff",
    "handle":257,
    "phys_id":3
  },
  {
    "dev":"nmem0",
    "id":"cdab-0a-07e0-ffffffff",
    "handle":0,
    "phys_id":0
  },
  {
    "dev":"nmem2",
    "id":"cdab-0a-07e0-fffeffff",
    "handle":256,
    "phys_id":2
  }
]
# 

> +FILTER_NAMESPACE="namespace1.0"

> +FILTER_NAMESPACE_MAP_DIMM="nmem0:nmem1"

Same as above.

> +CONF_FILE_SET_DIMM="nmem1:nmem3"
> +
> +. ./common
> +
> +trap 'err $LINENO' ERR
> +
> +check_min_kver "4.15" || do_skip "kernel $KVER may not support monitor service"
> +
> +start_monitor()
> +{
> +	logfile=$(mktemp)
> +	$NDCTL monitor -l $logfile $1 &
> +	monitor_pid=$!
> +	truncate --size 0 $logfile #remove startup log
> +}
> +
> +call_notify()
> +{
> +	./smart-notify $NFIT_TEST_BUS0

I think monitor daemon needs some time for writing out the log.
So why don't we have some sleep time? Like as:

sync; sleep 3

> +}
> +
> +check_result()
> +{
> +	json=$(cat $logfile)
> +	dimms=$(jq ."dimm"."dev" <<<$json | sort | uniq | sed -e ':loop; N; $!b loop; s/\n/:/g' | sed 's/\"//g')
> +	[[ $1 == $dimms ]]
> +}
> +
> +stop_monitor()
> +{
> +	kill $monitor_pid
> +	rm $logfile
> +}
> +
> +create_conf_file()
> +{
> +	conf_file=$(mktemp)
> +	echo 'dimm=nmem1 nmem3' > $conf_file
> +	cat $conf_file
> +}
> +
> +test_filter_dimm()
> +{
> +	start_monitor "-d $FILTER_DIMM"
> +	call_notify
> +	check_result "$FILTER_DIMM"
> +	stop_monitor
> +}
> +
> +test_filter_bus()
> +{
> +	start_monitor "-b $FILTER_BUS"
> +	call_notify
> +	check_result $FILTER_BUS_MAP_DIMM
> +	stop_monitor
> +}
> +
> +test_filter_region()
> +{
> +	start_monitor "-r $FILTER_REGION"
> +	call_notify
> +	check_result $FILTER_REGION_MAP_DIMM
> +	stop_monitor
> +}
> +
> +test_filter_namespace()
> +{
> +	$NDCTL create-namespace -r region1 -n $FILTER_NAMESPACE
> +	start_monitor "-n $FILTER_NAMESPACE"
> +	call_notify
> +	check_result $FILTER_NAMESPACE_MAP_DIMM
> +	stop_monitor
> +	$NDCTL destroy-namespace $FILTER_NAMESPACE -f
> +}
> +
> +test_conf_file()
> +{
> +	create_conf_file
> +	start_monitor "-c $conf_file"
> +	call_notify
> +	check_result $CONF_FILE_SET_DIMM
> +	stop_monitor
> +	rm $conf_file
> +}
> +
> +do_tests()
> +{
> +	test_filter_dimm
> +	test_filter_bus
> +	test_filter_region
> +	test_filter_namespace
> +	test_conf_file
> +}
> +
> +modprobe nfit_test
> +rc=1

Why don't you add initialize the region before testing?
like as follows.

init()
{
       $NDCTL disable-region -b $NFIT_TEST_BUS0 all
       $NDCTL zero-labels -b $NFIT_TEST_BUS0 all
       $NDCTL enable-region -b $NFIT_TEST_BUS0 all
}
init

Thanks,
Masa

> +do_tests
> +_cleanup
> +exit 0
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
