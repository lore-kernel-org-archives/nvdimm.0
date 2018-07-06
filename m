Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x241.google.com (mail-qk0-x241.google.com
 [IPv6:2607:f8b0:400d:c09::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5F5D5202E53F4
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jul 2018 08:08:23 -0700 (PDT)
Received: by mail-qk0-x241.google.com with SMTP id c131-v6so6465448qkb.0
 for <linux-nvdimm@lists.01.org>; Fri, 06 Jul 2018 08:08:23 -0700 (PDT)
Subject: Re: [ndctl PATCH v2] ndctl, test: add a new unit test for monitor
References: <20180706052227.14393-1-qi.fuli@jp.fujitsu.com>
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <a1142e7a-c88c-7ae6-a229-da42dcff405c@gmail.com>
Date: Fri, 6 Jul 2018 11:08:20 -0400
MIME-Version: 1.0
In-Reply-To: <20180706052227.14393-1-qi.fuli@jp.fujitsu.com>
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

On 07/06/2018 01:22 AM, QI Fuli wrote:
> Add a new unit test to test the following options of the monitor command.
>    --dimm
>    --bus
>    --region
>    --namespace
>    --logfile
>    --config-file
> 
> Based-on-patch-by: Yasunori Goto <y-goto@jp.fujitsu.com>

> Acked-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

I think this Acked-by is wrong because I'm not a maintainer :-)

Anyway, the monitor test looks good to me, however, the monitor has also
'-D' option. Could you add '-D' option test? I believe you can emulate
the situation for test by using ndctl inject-smart command.
 
BTW, are you preparing the man page of monitor...?
I believe the man page is needed for users.

Thanks,
Masa

> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
> v1 -> v2:
>  - Add init()
>  - Add get_filter_dimm() to get the filter dimms by ndctl list command
>    instead of hard-cording
>  - Add sleep to call_notify()
> 
>  test/Makefile.am |   3 +-
>  test/monitor.sh  | 131 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 133 insertions(+), 1 deletion(-)
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
> index 0000000..dbd2013
> --- /dev/null
> +++ b/test/monitor.sh
> @@ -0,0 +1,131 @@
> +#!/bin/bash -Ex
> +
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright(c) 2018, FUJITSU LIMITED. All rights reserved.
> +
> +rc=77
> +logfile=""
> +conf_file=""
> +filter_dimms=""
> +monitor_pid=65536
> +FILTER_DIMM="nmem1"
> +FILTER_REGION="region1"
> +FILTER_NAMESPACE="namespace1.0"
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
> +get_filter_dimm()
> +{
> +	jlist=$($NDCTL list -D -b $NFIT_TEST_BUS0 $1)
> +	filter_dimms=$(jq '.[]."dev"?, ."dev"?' <<<$jlist | sort | uniq | sed -e ':loop; N; $!b loop; s/\n/:/g' | sed 's/\"//g')
> +}
> +
> +call_notify()
> +{
> +	./smart-notify $NFIT_TEST_BUS0
> +	sync; sleep 3
> +}
> +
> +check_result()
> +{
> +	jlog=$(cat $logfile)
> +	notify_dimms=$(jq ."dimm"."dev" <<<$jlog | sort | uniq | sed -e ':loop; N; $!b loop; s/\n/:/g' | sed 's/\"//g')
> +	[[ $filter_dimms == $notify_dimms ]]
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
> +}
> +
> +test_filter_dimm()
> +{
> +	get_filter_dimm "-d $FILTER_DIMM"
> +	start_monitor "-d $FILTER_DIMM"
> +	call_notify
> +	check_result
> +	stop_monitor
> +}
> +
> +test_filter_bus()
> +{
> +	get_filter_dimm
> +	start_monitor "-b $NFIT_TEST_BUS0"
> +	call_notify
> +	check_result
> +	stop_monitor
> +}
> +
> +test_filter_region()
> +{
> +	get_filter_dimm "-r $FILTER_REGION"
> +	start_monitor "-r $FILTER_REGION"
> +	call_notify
> +	check_result
> +	stop_monitor
> +}
> +
> +test_filter_namespace()
> +{
> +	$NDCTL create-namespace -r region1 -n $FILTER_NAMESPACE
> +	get_filter_dimm "-n $FILTER_NAMESPACE"
> +	start_monitor "-n $FILTER_NAMESPACE"
> +	call_notify
> +	check_result
> +	stop_monitor
> +	$NDCTL destroy-namespace $FILTER_NAMESPACE -f
> +}
> +
> +test_conf_file()
> +{
> +	filter_dimms=$CONF_FILE_SET_DIMM
> +	create_conf_file
> +	start_monitor "-c $conf_file"
> +	call_notify
> +	check_result
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
> +init()
> +{
> +	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
> +	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
> +	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
> +}
> +
> +modprobe nfit_test
> +rc=1
> +init
> +do_tests
> +_cleanup
> +exit 0
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
