Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1519E20D77DC8
 for <linux-nvdimm@lists.01.org>; Wed,  5 Apr 2017 14:46:50 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id r203so31490794oib.3
 for <linux-nvdimm@lists.01.org>; Wed, 05 Apr 2017 14:46:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <149142121625.9379.9247880188079374114.stgit@djiang5-desk3.ch.intel.com>
References: <149142121625.9379.9247880188079374114.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 5 Apr 2017 14:46:48 -0700
Message-ID: <CAPcyv4h-J50qPF_dxgFKrJ+BLmtFxJMJ6i91rWmGnHw_wwfcKA@mail.gmail.com>
Subject: Re: [PATCH] ndctl: have daxdev-errors discover the ndbus
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 5, 2017 at 12:40 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Implementation had static config and made assumption that the region in
> nfit_test will be ndbus0. Adding code to discover the proper bus and also
> pass onto daxdev-errors.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  test/daxdev-errors.c  |    9 +++++----
>  test/daxdev-errors.sh |   11 ++++++++---
>  2 files changed, 13 insertions(+), 7 deletions(-)
>
[..]
> diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
> index 1777210..ee07f81 100755
> --- a/test/daxdev-errors.sh
> +++ b/test/daxdev-errors.sh
> @@ -5,6 +5,7 @@ NDCTL="../ndctl/ndctl"
>  DAXCTL="../daxctl/daxctl"
>  BUS="-b nfit_test.0"
>  BUS1="-b nfit_test.1"
> +json2var="s/[{}\",]//g; s/:/=/g"
>  rc=77
>
>  err() {
> @@ -52,15 +53,19 @@ chardev=$(echo $json | jq ". | select(.mode == \"dax\") | .daxregion.devices[0].
>  #    ]
>  #  }
>
> -read sector len < /sys/bus/platform/devices/nfit_test.0/ndbus0/region5/badblocks
> +json1=$($NDCTL list $BUS)
> +eval $(echo $json1 | sed -e "$json2var")
> +
> +echo "read /sys/bus/platform/devices/nfit_test.0/$dev/region5/badblocks"
> +read sector len < /sys/bus/platform/devices/nfit_test.0/$dev/region5/badblocks
>  echo "sector: $sector len: $len"
>
>  # run the daxdev-errors test
>  test -x ./daxdev-errors
> -./daxdev-errors
> +./daxdev-errors $dev
>
>  # check badblocks, should be empty
> -if read sector len < /sys/bus/platform/devices/nfit_test.0/ndbus0/region5/badblocks; then
> +if read sector len < /sys/bus/platform/devices/nfit_test.0/$dev/region5/badblocks; then

The region numbers are dynamic, so region5 might not be what you
expect depending on the system configuration and what buses get loaded
first. You can use ndctl list to find the expected region explicitly.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
