Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 247E5207DF296
 for <linux-nvdimm@lists.01.org>; Thu, 12 Jul 2018 13:02:07 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v11 5/5] ndctl, test: add a new unit test for monitor
Date: Thu, 12 Jul 2018 20:01:59 +0000
Message-ID: <1531425717.7574.63.camel@intel.com>
References: <20180711030012.9186-1-qi.fuli@jp.fujitsu.com>
 <20180711030012.9186-6-qi.fuli@jp.fujitsu.com>
 <a7036e1d-6ea1-9a4f-8a9d-82d88279dc81@gmail.com>
In-Reply-To: <a7036e1d-6ea1-9a4f-8a9d-82d88279dc81@gmail.com>
Content-Language: en-US
Content-ID: <7F10378846B4AE479B50B1DDCBA5A7BC@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>, "msys.mizuma@gmail.com" <msys.mizuma@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>


On Thu, 2018-07-12 at 15:51 -0400, Masayoshi Mizuma wrote:
> Hi Qi,
> 
> Nice work! Let me ask some comments.
> 
> On 07/10/2018 11:00 PM, QI Fuli wrote:
> [...]
> > diff --git a/test/monitor.sh b/test/monitor.sh
> > new file mode 100755
> > index 0000000..43cb11f
> > --- /dev/null
> > +++ b/test/monitor.sh
> > @@ -0,0 +1,177 @@
> > +#!/bin/bash -Ex
> > +
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright(c) 2018, FUJITSU LIMITED. All rights reserved.
> > +
> > +rc=77
> > +logfile=""
> > +conf_file=""
> > +monitor_dimms=""
> > +monitor_regions=""
> > +monitor_namespace=""
> > +monitor_pid=65536
> > +
> > +. ./common
> > +
> > +trap 'err $LINENO' ERR
> > +
> > +check_min_kver "4.15" || do_skip "kernel $KVER may not support monitor service"
> > +
> > +init()
> > +{
> > +	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
> > +	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
> > +	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
> > +}
> > +
> > +start_monitor()
> > +{
> > +	logfile=$(mktemp)
> > +	$NDCTL monitor -l $logfile $1 &
> > +	monitor_pid=$!
> > +	truncate --size 0 $logfile #remove startup log
> > +	sync; sleep 3
> 
> Should this sync be moved to before the truncate?
> 
> > +}
> > +
> > +get_monitor_dimm()
> > +{
> > +	jlist=$(./list-smart-dimm -b $smart_supported_bus $1)
> > +	monitor_dimms=$(jq '.[]."dev"?, ."dev"?' <<<$jlist | sort | uniq | xargs)
> > +}
> > +
> > +call_notify()
> > +{
> > +	./smart-notify $smart_supported_bus
> > +	sync; sleep 3
> > +}
> > +
> > +inject_smart()
> > +{
> > +	$NDCTL inject-smart $monitor_dimms $1
> > +	sync; sleep 3
> > +}
> > +
> > +check_result()
> > +{
> > +	jlog=$(cat $logfile)
> > +	notify_dimms=$(jq ."dimm"."dev" <<<$jlog | sort | uniq | xargs)
> > +	[[ $monitor_dimms == $notify_dimms ]]
> > +}
> > +
> > +stop_monitor()
> > +{
> > +	kill $monitor_pid
> > +	rm $logfile
> > +}
> > +
> > +create_conf_file()
> > +{
> > +	conf_file=$(mktemp)
> > +	echo "dimm = $1" > $conf_file
> > +}
> > +
> > +test_filter_dimm()
> > +{
> > +	smart_supported_bus=$NFIT_TEST_BUS0
> > +	monitor_dimms=$(./list-smart-dimm -b $smart_supported_bus | jq -r .[0].dev)
> > +	if [ -z $monitor_dimms ]; then
> > +		smart_supported_bus=$NFIT_TEST_BUS1
> > +		monitor_dimms=$(./list-smart-dimm -b $smart_supported_bus | jq -r .[0].dev)
> > +	fi
> > +	start_monitor "-d $monitor_dimms"
> > +	call_notify
> > +	check_result
> > +	stop_monitor
> > +}
> 
> I think the global variable "smart_supported_bus" configuration
> should be separated from this function.
> Like as:
> 
> set_smart_supported_bus()
> {
>         smart_supported_bus=$NFIT_TEST_BUS0
>         monitor_dimms=$(./list-smart-dimm -b $smart_supported_bus | jq -r .[0].dev)
>         if [ -z $monitor_dimms ]; then
>                 smart_supported_bus=$NFIT_TEST_BUS1
>         fi
> }
> 
> > +
> > +test_filter_bus()
> > +{
> > +	monitor_dimms=""
> > +	get_monitor_dimm
> > +	start_monitor "-b $smart_supported_bus"
> > +	call_notify
> > +	check_result
> > +	stop_monitor
> > +}
> > +
> > +test_filter_region()
> > +{
> > +	monitor_dimms=""
> > +	monitor_region=""
> > +	count=$($NDCTL list -R -b $smart_supported_bus | jq -r .[].dev | wc -l)
> > +	i=0
> > +	while [ $i -lt $count ]; do
> > +		monitor_region=$($NDCTL list -R -b $smart_supported_bus | jq -r .[$i].dev)
> > +		get_monitor_dimm "-r $monitor_region"
> > +		[ ! -z $monitor_dimms ] && break
> > +		i=$[$i+1]
> 
> i=$(( $i + 1 )) is better. $[...] is not described in the man page of bash...

.. and within the $(( )), you can forego the '$' for variables. So it
becomes: i=$((i + 1))

> 
> > +	done
> > +	start_monitor "-r $monitor_region"
> > +	call_notify
> > +	check_result
> > +	stop_monitor
> > +}
> > +
> > +test_filter_namespace()
> > +{
> > +	monitor_dimms=""
> > +	init
> > +	monitor_namespace=$($NDCTL create-namespace -b $smart_supported_bus | jq -r .dev)
> > +	get_monitor_dimm "-n $monitor_namespace"
> > +	start_monitor "-n $monitor_namespace"
> > +	call_notify
> > +	check_result
> > +	stop_monitor
> > +	$NDCTL destroy-namespace $monitor_namespace -f
> > +}
> > +
> > +test_conf_file()
> > +{
> > +	create_conf_file  "$monitor_dimms"
> > +	start_monitor "-c $conf_file"
> > +	call_notify
> > +	check_result
> > +	stop_monitor
> > +	rm $conf_file
> > +}
> > +
> > +test_filter_dimmevent()
> > +{
> > +	monitor_dimms="$(echo $monitor_dimms | awk '{print $1}')"
> > +
> > +	start_monitor "-d $monitor_dimms -D dimm-unclean-shutdown"
> > +	inject_smart "-U"
> > +	check_result
> > +	stop_monitor
> > +
> > +	inject_value=$($NDCTL list -H -d $monitor_dimms | jq -r ."health"."spares_threshold")
> > +	inject_value=$[$inject_value-1]
> 
> Same as above.
> 
> > +	start_monitor "-d $monitor_dimms -D dimm-spares-remaining"
> > +	inject_smart "-s $inject_value"
> > +	check_result
> > +	stop_monitor
> > +
> > +	inject_value=$($NDCTL list -H -d $monitor_dimms | jq -r ."health"."temperature_threshold")
> > +	inject_value=$[$inject_value+1]
> 
> Same as above.
> 
> Thanks,
> Masa
> 
> > +	start_monitor "-d $monitor_dimms -D dimm-media-temperature"
> > +	inject_smart "-s $inject_value"
> > +	check_result
> > +	stop_monitor
> > +}
> > +
> > +do_tests()
> > +{
> > +	test_filter_dimm
> > +	test_filter_bus
> > +	test_filter_region
> > +	test_filter_namespace
> > +	test_conf_file
> > +	test_filter_dimmevent
> > +}
> > +
> > +modprobe nfit_test
> > +rc=1
> > +init
> > +do_tests
> > +_cleanup
> > +exit 0
> > 
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
