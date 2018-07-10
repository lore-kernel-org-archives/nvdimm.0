Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x244.google.com (mail-qt0-x244.google.com
 [IPv6:2607:f8b0:400d:c0d::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C9CFE2096FAB1
 for <linux-nvdimm@lists.01.org>; Tue, 10 Jul 2018 08:11:04 -0700 (PDT)
Received: by mail-qt0-x244.google.com with SMTP id l10-v6so18610635qtj.0
 for <linux-nvdimm@lists.01.org>; Tue, 10 Jul 2018 08:11:04 -0700 (PDT)
Subject: Re: [ndctl PATCH v4] ndctl, test: add a new unit test for monitor
References: <20180710100457.23505-1-qi.fuli@jp.fujitsu.com>
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <130ee464-169d-6ec2-9cbf-44a4395400d3@gmail.com>
Date: Tue, 10 Jul 2018 11:11:01 -0400
MIME-Version: 1.0
In-Reply-To: <20180710100457.23505-1-qi.fuli@jp.fujitsu.com>
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

Hi Qi

Thank you for creating the v4 test, but unfortunately the test has failed...

On 07/10/2018 06:04 AM, QI Fuli wrote:
> Add a new unit test to test the following options of the monitor command.
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
> v3 -> v4:
>    Add list-smart-dimm() helper to list and filter smart supported dimms
> v2 -> v3:
>  - Add filter_obj instead of hard-coded values
> v1 -> v2:
>  - Add init()
>  - Add get_filter_dimm() to get the filter dimms by ndctl list command
>    instead of hard-cording
>  - Add sleep to call_notify()
> 
>  .gitignore             |   1 +
>  test/Makefile.am       |  14 +++-
>  test/list-smart-dimm.c | 117 +++++++++++++++++++++++++++++++++
>  test/monitor.sh        | 146 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 276 insertions(+), 2 deletions(-)
>  create mode 100644 test/list-smart-dimm.c
>  create mode 100755 test/monitor.sh
> 
> diff --git a/.gitignore b/.gitignore
> index 1016b3b..0baace4 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -56,3 +56,4 @@ test/smart-notify
>  test/fio.job
>  test/local-write-0-verify.state
>  test/ack-shutdown-count-set
> +test/list-smart-dimm
> diff --git a/test/Makefile.am b/test/Makefile.am
> index cd451e9..8c55056 100644
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
> @@ -34,7 +35,8 @@ check_PROGRAMS =\
>  	smart-listen \
>  	hugetlb \
>  	daxdev-errors \
> -	ack-shutdown-count-set
> +	ack-shutdown-count-set \
> +	list-smart-dimm
>  
>  if ENABLE_DESTRUCTIVE
>  TESTS +=\
> @@ -151,3 +153,11 @@ multi_pmem_LDADD = \
>  		$(UUID_LIBS) \
>  		$(KMOD_LIBS) \
>  		../libutil.a
> +
> +list_smart_dimm_SOURCES = \
> +		list-smart-dimm.c \
> +		../util/json.c
> +list_smart_dimm_LDADD = \
> +		$(LIBNDCTL_LIB) \
> +		$(JSON_LIBS) \
> +		../libutil.a
> diff --git a/test/list-smart-dimm.c b/test/list-smart-dimm.c
> new file mode 100644
> index 0000000..c9982d5
> --- /dev/null
> +++ b/test/list-smart-dimm.c
> @@ -0,0 +1,117 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2018, FUJITSU LIMITED. All rights reserved. */
> +
> +#include <stdio.h>
> +#include <errno.h>
> +#include <util/json.h>
> +#include <util/filter.h>
> +#include <json-c/json.h>
> +#include <ndctl/libndctl.h>
> +#include <util/parse-options.h>
> +#include <ndctl.h>
> +
> +struct util_filter_params param;
> +static int did_fail;
> +static int jflag = JSON_C_TO_STRING_PRETTY;
> +
> +#define fail(fmt, ...) \
> +do { \
> +	did_fail = 1; \
> +	fprintf(stderr, "ndctl-%s:%s:%d: " fmt, \
> +			VERSION, __func__, __LINE__, ##__VA_ARGS__); \
> +} while (0)
> +
> +static bool filter_region(struct ndctl_region *region,
> +		struct util_filter_ctx *ctx)
> +{
> +	return true;
> +}
> +
> +static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *ctx)
> +{
> +	struct list_filter_arg *lfa = ctx->list;
> +	struct json_object *jdimm;
> +
> +	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART))
> +		return;
> +	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART_THRESHOLD))
> +		return;
> +	if (!ndctl_dimm_is_flag_supported(dimm, ND_SMART_ALARM_VALID))
> +		return;
> +
> +	if (!lfa->jdimms) {
> +		lfa->jdimms = json_object_new_array();
> +		if (!lfa->jdimms) {
> +			fail("\n");
> +			return;
> +		}
> +	}
> +
> +	jdimm = util_dimm_to_json(dimm, lfa->flags);
> +	if (!jdimm) {
> +		fail("\n");
> +		return;
> +	}
> +
> +	json_object_array_add(lfa->jdimms, jdimm);
> +}
> +
> +static bool filter_bus(struct ndctl_bus *bus, struct util_filter_ctx *ctx)
> +{
> +	return true;
> +}
> +
> +static int list_display(struct list_filter_arg *lfa)
> +{
> +	struct json_object *jdimms = lfa->jdimms;
> +
> +	if (jdimms)
> +		util_display_json_array(stdout, jdimms, jflag);
> +	return 0;
> +}
> +
> +int main(int argc, const char *argv[])
> +{
> +	struct ndctl_ctx *ctx;
> +	int i, rc;
> +	const struct option options[] = {
> +		OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by bus"),
> +		OPT_STRING('r', "region", &param.region, "region-id",
> +				"filter by region"),
> +		OPT_STRING('d', "dimm", &param.dimm, "dimm-id",
> +				"filter by dimm"),
> +		OPT_STRING('n', "namespace", &param.namespace, "namespace-id",
> +				"filter by namespace id"),
> +		OPT_END(),
> +	};
> +	const char * const u[] = {
> +		"list-smart-dimm [<options>]",
> +		NULL
> +	};
> +	struct util_filter_ctx fctx = { 0 };
> +	struct list_filter_arg lfa = { 0 };
> +
> +	rc = ndctl_new(&ctx);
> +	if (rc < 0)
> +		return EXIT_FAILURE;
> +        argc = parse_options(argc, argv, options, u, 0);
> +	for (i = 0; i < argc; i++)
> +		error("unknown parameter \"%s\"\n", argv[i]);
> +	if (argc)
> +		usage_with_options(u, options);
> +
> +	fctx.filter_bus = filter_bus;
> +	fctx.filter_dimm = filter_dimm;
> +	fctx.filter_region = filter_region;
> +	fctx.filter_namespace = NULL;
> +	fctx.list = &lfa;
> +	lfa.flags = 0;
> +
> +	rc = util_filter_walk(ctx, &fctx, &param);
> +	if (rc)
> +		return rc;
> +
> +	if (list_display(&lfa) || did_fail)
> +		return -ENOMEM;
> +	return 0;
> +}
> diff --git a/test/monitor.sh b/test/monitor.sh
> new file mode 100755
> index 0000000..1401983
> --- /dev/null
> +++ b/test/monitor.sh
> @@ -0,0 +1,146 @@
> +#!/bin/bash -Ex
> +
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright(c) 2018, FUJITSU LIMITED. All rights reserved.
> +
> +rc=77
> +logfile=""
> +conf_file=""
> +monitor_dimms=""
> +monitor_regions=""
> +monitor_namespace=""
> +monitor_pid=65536
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
> +get_monitor_dimm()
> +{
> +	jlist=$(./list-smart-dimm -b $smart_supported_bus $1)
> +	monitor_dimms=$(jq '.[]."dev"?, ."dev"?' <<<$jlist | sort | uniq | xargs)
> +}
> +
> +call_notify()
> +{
> +	./smart-notify $smart_supported_bus
> +	sync; sleep 3
> +}
> +
> +check_result()
> +{
> +	jlog=$(cat $logfile)
> +	notify_dimms=$(jq ."dimm"."dev" <<<$jlog | sort | uniq | xargs)
> +	[[ $monitor_dimms == $notify_dimms ]]
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
> +	echo "dimm = $1" > $conf_file
> +}
> +
> +test_filter_dimm()
> +{
> +	smart_supported_bus=$NFIT_TEST_BUS0
> +	monitor_dimms=$(./list-smart-dimm -b $smart_supported_bus | jq -r .[0].dev)
> +	if [ -z $monitor_dimms ]; then
> +		smart_supported_bus=$NFIT_TEST_BUS1
> +		monitor_dimms=$(./list-smart-dimm -b $smart_supported_bus | jq -r .[0].dev)
> +	fi
> +	start_monitor "-d $monitor_dimms"
> +	call_notify
> +	check_result
> +	stop_monitor
> +}
> +
> +test_filter_bus()
> +{
> +	monitor_dimms=""
> +	get_monitor_dimm
> +	start_monitor "-b $smart_supported_bus"
> +	call_notify
> +	check_result
> +	stop_monitor
> +}
> +
> +test_filter_region()
> +{
> +	monitor_dimms=""
> +	monitor_region=""
> +	count=$($NDCTL list -R -b $smart_supported_bus | jq -r .[].dev | wc -l)
> +	i=0
> +	while [ $i -lt $count ]; do
> +		monitor_region=$($NDCTL list -R -b $smart_supported_bus | jq -r .[$i].dev)
> +		get_monitor_dimm "-r $monitor_region"
> +		[ ! -z $monitor_dimms ] && break
> +		i=$[$i+1]
> +	done
> +	start_monitor "-r $monitor_region"
> +	call_notify
> +	check_result
> +	stop_monitor
> +}
> +
> +test_filter_namespace()
> +{
> +	monitor_dimms=""

> +	monitor_namespace=$($NDCTL list -N -b $smart_supported_bus | jq -r .[0].dev)
> +	[ -z $monitor_namespace ] && monitor_namespace="namespace1.0"
> +	$NDCTL create-namespace -b $smart_supported_bus -n $monitor_namespace

namespace1.0 may be used by the other bus. Actually my test failed because
namespace1.0 was used by the other bus.
How about the following instead?

-       monitor_namespace=$($NDCTL list -N -b $smart_supported_bus | jq -r .[0].dev)
-       [ -z $monitor_namespace ] && monitor_namespace="namespace1.0"
-       $NDCTL create-namespace -b $smart_supported_bus -n $monitor_namespace
+       init
+       monitor_namespace=$($NDCTL create-namespace -b $smart_supported_bus | jq -r .dev)

Thanks,
Masa

> +	get_monitor_dimm "-n $monitor_namespace"
> +	start_monitor "-n $monitor_namespace"
> +	call_notify
> +	check_result
> +	stop_monitor
> +	$NDCTL destroy-namespace $monitor_namespace -f
> +}
> +
> +test_conf_file()
> +{
> +	create_conf_file  "$monitor_dimms"
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
