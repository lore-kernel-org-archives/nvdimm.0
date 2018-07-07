Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8BD5E21A143EF
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jul 2018 20:57:58 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id b15-v6so26984411oib.10
 for <linux-nvdimm@lists.01.org>; Fri, 06 Jul 2018 20:57:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180706052227.14393-1-qi.fuli@jp.fujitsu.com>
References: <20180706052227.14393-1-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Jul 2018 20:57:57 -0700
Message-ID: <CAPcyv4ghUrp5MGR7R3+SP59Gzqin4Vu4VsYddwnQuRekROg4Cw@mail.gmail.com>
Subject: Re: [ndctl PATCH v2] ndctl, test: add a new unit test for monitor
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

On Thu, Jul 5, 2018 at 10:22 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
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

I thought this was going to be changed to not use hard coded values?
For example on my platform nmem1 is on ACPI.NFIT

# ndctl list -BD -d nmem1
{
  "provider":"ACPI.NFIT",
  "dev":"ndbus1",
  "dimms":[
    {
      "dev":"nmem1",
      "id":"8680-57341200",
      "handle":2,
      "phys_id":0
    }
  ]
}


Are you looking to test one of DIMMs on nfit_test.0?

Why not just do this?

FILTER_DIMM=$(ndctl list -D -b nfit_test.0 | jq -r .[0].dev)
FILTER_REGION=$(ndctl list -R -b nfit_test.0 | jq -r .[0].dev)
FILTER_NAMESPACE=$(ndctl list -N -b nfit_test.0 | jq -r .[0].dev)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
