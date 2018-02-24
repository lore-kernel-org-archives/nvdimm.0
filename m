Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x243.google.com (mail-lf0-x243.google.com
 [IPv6:2a00:1450:4010:c07::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5F21D222630D6
 for <linux-nvdimm@lists.01.org>; Fri, 23 Feb 2018 16:23:52 -0800 (PST)
Received: by mail-lf0-x243.google.com with SMTP id r80so14704617lfe.13
 for <linux-nvdimm@lists.01.org>; Fri, 23 Feb 2018 16:29:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180221232037.20165-1-vishal.l.verma@intel.com>
References: <20180221232037.20165-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 23 Feb 2018 16:29:51 -0800
Message-ID: <CAPcyv4hfXqkHCnXxkMbODeS-5Jv5ER6RQiUGTa5yJuLy2UrkjQ@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, test: fix tests that use error injection on
 older kernels
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "Zloch, Jacek" <jacek.zloch@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 21, 2018 at 3:20 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> When we updated from using canned badblocks to injected errors in
> nfit_test, we ended up breaking the tests for older kernels that didn't
> have error injection capabilities.
>
> Fix this by first checking if badblocks already exist. If they do, we
> have an older kernel with canned badblocks, and we can simply use those.
> If not, then apttempt to inject them as needed.
>
> Reported-by: Jacek Zolch <jacek.zloch@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  test/btt-errors.sh    | 2 +-
>  test/clear.sh         | 4 +++-
>  test/daxdev-errors.sh | 4 +++-
>  test/pmem-errors.sh   | 4 +++-
>  4 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/test/btt-errors.sh b/test/btt-errors.sh
> index 383abb6..ecc1282 100755
> --- a/test/btt-errors.sh
> +++ b/test/btt-errors.sh
> @@ -59,7 +59,7 @@ force_raw()
>         fi
>  }
>
> -check_min_kver "4.14" || { echo "kernel $KVER may lack BTT error handling"; exit $rc; }
> +check_min_kver "4.15" || { echo "kernel $KVER may lack BTT error handling"; exit $rc; }
>
>  set -e
>  mkdir -p $MNT
> diff --git a/test/clear.sh b/test/clear.sh
> index c22ff3b..9f16397 100755
> --- a/test/clear.sh
> +++ b/test/clear.sh
> @@ -57,7 +57,9 @@ eval $(echo $json | sed -e "$json2var")
>  # inject errors in the middle of the namespace, verify that reading fails
>  err_sector="$(((size/512) / 2))"
>  err_count=8
> -$NDCTL inject-error --block="$err_sector" --count=$err_count $dev
> +if [ ! -e /sys/block/$blockdev/badblocks ]; then
> +       $NDCTL inject-error --block="$err_sector" --count=$err_count $dev
> +fi
>  read sector len < /sys/block/$blockdev/badblocks
>  [ $((sector * 2)) -ne $((size /512)) ] && echo "fail: $LINENO" && exit 1
>  if dd if=/dev/$blockdev of=/dev/null iflag=direct bs=512 skip=$sector count=$len; then
> diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
> index d15bd82..4b7373e 100755
> --- a/test/daxdev-errors.sh
> +++ b/test/daxdev-errors.sh
> @@ -81,7 +81,9 @@ busdev=$dev
>  # inject errors in the middle of the namespace
>  err_sector="$(((size/512) / 2))"
>  err_count=8
> -$NDCTL inject-error --block="$err_sector" --count=$err_count $nsdev
> +if [ ! -e /sys/block/$blockdev/badblocks ]; then
> +       $NDCTL inject-error --block="$err_sector" --count=$err_count $nsdev
> +fi

I don't think this works at all. It seems what you want is to check if
there are *entries* in the badblocks file, not whether the file
exists.

This works for me:

-if [ ! -e /sys/block/$blockdev/badblocks ]; then
+if ! read sector len < /sys/block/$blockdev/badblocks; then
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
