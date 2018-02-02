Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A053D2237A4DC
 for <linux-nvdimm@lists.01.org>; Fri,  2 Feb 2018 14:34:11 -0800 (PST)
Received: by mail-ot0-x241.google.com with SMTP id v5so21792384oth.5
 for <linux-nvdimm@lists.01.org>; Fri, 02 Feb 2018 14:39:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180202223659.28413-1-vishal.l.verma@intel.com>
References: <20180202223659.28413-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 2 Feb 2018 14:39:48 -0800
Message-ID: <CAPcyv4hoJ64LZF0ch1GTB-aB1_awYrpgnVrSiRYTPeABtthm4Q@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, test: make btt-pad-compat dynamically detect
 a patched kernel
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 2, 2018 at 2:36 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The btt-pad-compat test can detect whether it is running on a patched
> kernel by checking for the two newly added debugfs files in the fix for
> this bug. Use that instead of hard coding a kernel version dependency.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  test/btt-pad-compat.sh | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
>
> diff --git a/test/btt-pad-compat.sh b/test/btt-pad-compat.sh
> index d10efe3..faa773c 100755
> --- a/test/btt-pad-compat.sh
> +++ b/test/btt-pad-compat.sh
> @@ -41,17 +41,6 @@ err()
>         exit "$rc"
>  }
>
> -check_min_kver()
> -{
> -       local ver="$1"
> -       : "${KVER:=$(uname -r)}"
> -
> -       [ -n "$ver" ] || return 1
> -       [[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
> -}
> -
> -check_min_kver "4.15" || { echo "kernel $KVER may not have btt padding compat fixes"; exit "$rc"; }
> -
>  check_prereq()
>  {
>         if ! command -v "$1" >/dev/null; then
> @@ -70,6 +59,10 @@ create()
>         [ $size -gt 0 ] || err "$LINENO" 2
>         bttdev=$(cat /sys/bus/nd/devices/$dev/holder)
>         [ -n "$bttdev" ] || err "$LINENO" 2
> +       if [ ! -e /sys/kernel/debug/btt/$bttdev/arena0/log_index_0 ]; then
> +               echo "kernel $(uname -r) seems to be missing the BTT compatibility fixes, skipping"
> +               exit 77
> +       fi
>  }

Looks good to me. The less hard coded kernel version checks the better.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
