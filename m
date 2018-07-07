Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym03.jp.fujitsu.com (mgwym03.jp.fujitsu.com [211.128.242.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E53F521A143EF
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jul 2018 18:49:01 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 16D45AC03B1
 for <linux-nvdimm@lists.01.org>; Sat,  7 Jul 2018 10:48:56 +0900 (JST)
Message-ID: <5B401C00.6010100@jp.fujitsu.com>
Date: Sat, 07 Jul 2018 10:48:48 +0900
From: QI Fuli <qi.fuli@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [ndctl PATCH v2] ndctl, test: add a new unit test for monitor
References: <20180706052227.14393-1-qi.fuli@jp.fujitsu.com>
 <a1142e7a-c88c-7ae6-a229-da42dcff405c@gmail.com>
In-Reply-To: <a1142e7a-c88c-7ae6-a229-da42dcff405c@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Masa,

Thank you for your comments.

On 7/7/2018 12:08 AM, Masayoshi Mizuma wrote:
> Hi Qi,
>
> On 07/06/2018 01:22 AM, QI Fuli wrote:
>> Add a new unit test to test the following options of the monitor command.
>>     --dimm
>>     --bus
>>     --region
>>     --namespace
>>     --logfile
>>     --config-file
>>
>> Based-on-patch-by: Yasunori Goto <y-goto@jp.fujitsu.com>
>> Acked-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> I think this Acked-by is wrong because I'm not a maintainer :-)
I'm sorry for this mistake.
> Anyway, the monitor test looks good to me, however, the monitor has also
> '-D' option. Could you add '-D' option test? I believe you can emulate
> the situation for test by using ndctl inject-smart command.
I tried to test the '-D' option by using inject-smart command,
but I found the controller temperature cannot be injected.
https://lists.01.org/pipermail/linux-nvdimm/2018-June/016370.html

Also, I found the Alarm Trip bits of each dimm in nfit_test emulation
are set as 1 by default and I couldn't find any interface which can set 
them to 0.
> BTW, are you preparing the man page of monitor...?
> I believe the man page is needed for users.
Yes, I will add it.

Thank you very much.
QI
> Thanks,
> Masa
>
>> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
>> ---
>> v1 -> v2:
>>   - Add init()
>>   - Add get_filter_dimm() to get the filter dimms by ndctl list command
>>     instead of hard-cording
>>   - Add sleep to call_notify()
>>
>>   test/Makefile.am |   3 +-
>>   test/monitor.sh  | 131 +++++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 133 insertions(+), 1 deletion(-)
>>   create mode 100755 test/monitor.sh
>>
>> diff --git a/test/Makefile.am b/test/Makefile.am
>> index cd451e9..8c76462 100644
>> --- a/test/Makefile.am
>> +++ b/test/Makefile.am
>> @@ -21,7 +21,8 @@ TESTS =\
>>   	btt-pad-compat.sh \
>>   	firmware-update.sh \
>>   	ack-shutdown-count-set \
>> -	rescan-partitions.sh
>> +	rescan-partitions.sh \
>> +	monitor.sh
>>   
>>   check_PROGRAMS =\
>>   	libndctl \
>> diff --git a/test/monitor.sh b/test/monitor.sh
>> new file mode 100755
>> index 0000000..dbd2013
>> --- /dev/null
>> +++ b/test/monitor.sh
>> @@ -0,0 +1,131 @@
>> +#!/bin/bash -Ex
>> +
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright(c) 2018, FUJITSU LIMITED. All rights reserved.
>> +
>> +rc=77
>> +logfile=""
>> +conf_file=""
>> +filter_dimms=""
>> +monitor_pid=65536
>> +FILTER_DIMM="nmem1"
>> +FILTER_REGION="region1"
>> +FILTER_NAMESPACE="namespace1.0"
>> +CONF_FILE_SET_DIMM="nmem1:nmem3"
>> +
>> +. ./common
>> +
>> +trap 'err $LINENO' ERR
>> +
>> +check_min_kver "4.15" || do_skip "kernel $KVER may not support monitor service"
>> +
>> +start_monitor()
>> +{
>> +	logfile=$(mktemp)
>> +	$NDCTL monitor -l $logfile $1 &
>> +	monitor_pid=$!
>> +	truncate --size 0 $logfile #remove startup log
>> +}
>> +
>> +get_filter_dimm()
>> +{
>> +	jlist=$($NDCTL list -D -b $NFIT_TEST_BUS0 $1)
>> +	filter_dimms=$(jq '.[]."dev"?, ."dev"?' <<<$jlist | sort | uniq | sed -e ':loop; N; $!b loop; s/\n/:/g' | sed 's/\"//g')
>> +}
>> +
>> +call_notify()
>> +{
>> +	./smart-notify $NFIT_TEST_BUS0
>> +	sync; sleep 3
>> +}
>> +
>> +check_result()
>> +{
>> +	jlog=$(cat $logfile)
>> +	notify_dimms=$(jq ."dimm"."dev" <<<$jlog | sort | uniq | sed -e ':loop; N; $!b loop; s/\n/:/g' | sed 's/\"//g')
>> +	[[ $filter_dimms == $notify_dimms ]]
>> +}
>> +
>> +stop_monitor()
>> +{
>> +	kill $monitor_pid
>> +	rm $logfile
>> +}
>> +
>> +create_conf_file()
>> +{
>> +	conf_file=$(mktemp)
>> +	echo 'dimm=nmem1 nmem3' > $conf_file
>> +}
>> +
>> +test_filter_dimm()
>> +{
>> +	get_filter_dimm "-d $FILTER_DIMM"
>> +	start_monitor "-d $FILTER_DIMM"
>> +	call_notify
>> +	check_result
>> +	stop_monitor
>> +}
>> +
>> +test_filter_bus()
>> +{
>> +	get_filter_dimm
>> +	start_monitor "-b $NFIT_TEST_BUS0"
>> +	call_notify
>> +	check_result
>> +	stop_monitor
>> +}
>> +
>> +test_filter_region()
>> +{
>> +	get_filter_dimm "-r $FILTER_REGION"
>> +	start_monitor "-r $FILTER_REGION"
>> +	call_notify
>> +	check_result
>> +	stop_monitor
>> +}
>> +
>> +test_filter_namespace()
>> +{
>> +	$NDCTL create-namespace -r region1 -n $FILTER_NAMESPACE
>> +	get_filter_dimm "-n $FILTER_NAMESPACE"
>> +	start_monitor "-n $FILTER_NAMESPACE"
>> +	call_notify
>> +	check_result
>> +	stop_monitor
>> +	$NDCTL destroy-namespace $FILTER_NAMESPACE -f
>> +}
>> +
>> +test_conf_file()
>> +{
>> +	filter_dimms=$CONF_FILE_SET_DIMM
>> +	create_conf_file
>> +	start_monitor "-c $conf_file"
>> +	call_notify
>> +	check_result
>> +	stop_monitor
>> +	rm $conf_file
>> +}
>> +
>> +do_tests()
>> +{
>> +	test_filter_dimm
>> +	test_filter_bus
>> +	test_filter_region
>> +	test_filter_namespace
>> +	test_conf_file
>> +}
>> +
>> +init()
>> +{
>> +	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
>> +	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
>> +	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
>> +}
>> +
>> +modprobe nfit_test
>> +rc=1
>> +init
>> +do_tests
>> +_cleanup
>> +exit 0
>>
>


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
