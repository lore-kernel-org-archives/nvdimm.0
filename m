Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9DFB920337362
 for <linux-nvdimm@lists.01.org>; Sat,  7 Jul 2018 11:56:16 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id w126-v6so29252285oie.7
 for <linux-nvdimm@lists.01.org>; Sat, 07 Jul 2018 11:56:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180707053555.3192-1-qi.fuli@jp.fujitsu.com>
References: <20180707053555.3192-1-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 7 Jul 2018 11:56:14 -0700
Message-ID: <CAPcyv4hTAXyOdfB0UuNPUD-LxrXbMFBvnvpcY4qUuM0042EDHg@mail.gmail.com>
Subject: Re: [ndctl PATCH v3] ndctl, test: add a new unit test for monitor
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
To: QI Fuli <qi.fuli@jp.fujitsu.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 6, 2018 at 10:35 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
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
> v2 -> v3:
>  - Add filter_obj instead of hard-coded values
> v1 -> v2:
>  - Add init()
>  - Add get_filter_dimm() to get the filter dimms by ndctl list command
>    instead of hard-cording
>  - Add sleep to call_notify()
>
>  test/Makefile.am |   3 +-
>  test/monitor.sh  | 134 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 136 insertions(+), 1 deletion(-)
>  create mode 100755 test/monitor.sh

This test is still failing for me, here is the tail of the
test/test-suite.log output:

+ sync
+ sleep 3
+ check_result
++ cat /tmp/tmp.dT3TJ4l5IE
+ jlog='nmem0: no smart support

no dimms to monitor'
++ jq .dimm.dev
++ sort
++ uniq
++ sed -e ':loop; N; $!b loop; s/\n/:/g'
++ sed 's/\"//g'
parse error: Invalid literal at line 1, column 6
+ notify_dimms=
+ [[ '' == '' ]]
+ stop_monitor
+ kill 39414
./monitor.sh: line 48: kill: (39414) - No such process
++ err 48
+++ basename ./monitor.sh
++ echo test/monitor.sh: failed at line 48
test/monitor.sh: failed at line 48
++ '[' -n '' ']'
++ exit 1
FAIL monitor.sh (exit status: 1)

I notice errors around get_filter_dimm(). Why is that function needed,
it seems redundant now that $filter_obj is being used?

Hmm, if I just delete get_filter_dimm() I get this;

++ jq .dimm.dev
++ sort
++ uniq
++ sed -e ':loop; N; $!b loop; s/\n/:/g'
++ sed 's/\"//g'
+ notify_dimms=nmem3
+ [[ '' == nmem3 ]]
++ err 34
+++ basename ./monitor.sh
++ echo test/monitor.sh: failed at line 34
test/monitor.sh: failed at line 34
++ '[' -n '' ']'
++ exit 1
FAIL monitor.sh (exit status: 1)

I assume this test is passing for you? Can you try running it inside a
virtual machine that has a virtual NVDIMM so you can debug the
collisions between the nfit_test.0 bus objects and the ACPI.NFIT ones?

Here is my test environment where this unit test is failing:

https://gist.github.com/djbw/144dc5ddaf5e935ad58bd66a702a5ea8

>
> diff --git a/test/Makefile.am b/test/Makefile.am
> index cd451e9..8c76462 100644
> --- a/test/Makefile.am
> +++ b/test/Makefile.am
> @@ -21,7 +21,8 @@ TESTS =\
>         btt-pad-compat.sh \
>         firmware-update.sh \
>         ack-shutdown-count-set \
> -       rescan-partitions.sh
> +       rescan-partitions.sh \
> +       monitor.sh
>
>  check_PROGRAMS =\
>         libndctl \
> diff --git a/test/monitor.sh b/test/monitor.sh
> new file mode 100755
> index 0000000..4a7d733
> --- /dev/null
> +++ b/test/monitor.sh
> @@ -0,0 +1,134 @@
> +#!/bin/bash -Ex
> +
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright(c) 2018, FUJITSU LIMITED. All rights reserved.
> +
> +rc=77
> +logfile=""
> +conf_file=""
> +filter_dimms=""
> +filter_obj=""
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
> +       logfile=$(mktemp)
> +       $NDCTL monitor -l $logfile $1 &
> +       monitor_pid=$!
> +       truncate --size 0 $logfile #remove startup log
> +}
> +
> +get_filter_dimm()
> +{
> +       jlist=$($NDCTL list -D -b $NFIT_TEST_BUS0 $1)
> +       filter_dimms=$(jq '.[]."dev"?, ."dev"?' <<<$jlist | sort | uniq | sed -e ':loop; N; $!b loop; s/\n/:/g' | sed 's/\"//g')
> +}

Can we just remove this?

> +
> +call_notify()
> +{
> +       ./smart-notify $NFIT_TEST_BUS0
> +       sync; sleep 3
> +}
> +
> +check_result()
> +{
> +       jlog=$(cat $logfile)
> +       notify_dimms=$(jq ."dimm"."dev" <<<$jlog | sort | uniq | sed -e ':loop; N; $!b loop; s/\n/:/g' | sed 's/\"//g')

Can you add a comment here about that sed script is trying to do? If
it's just filtering json I'd rather it just jq directly.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
