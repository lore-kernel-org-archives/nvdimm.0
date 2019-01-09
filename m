Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 724F5211B5A56
 for <linux-nvdimm@lists.01.org>; Wed,  9 Jan 2019 15:00:00 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id 32so8224818ota.12
 for <linux-nvdimm@lists.01.org>; Wed, 09 Jan 2019 15:00:00 -0800 (PST)
MIME-Version: 1.0
References: <154705633843.23227.15903675663299735878.stgit@djiang5-desk3.ch.intel.com>
 <154705647045.23227.7733373111052687524.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154705647045.23227.7733373111052687524.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Jan 2019 14:59:47 -0800
Message-ID: <CAPcyv4i5b57DoL_m72=W4kaKEav-Gsso-hD1DjkBhKqpfJXQUQ@mail.gmail.com>
Subject: Re: [PATCH v7 07/12] ndctl: setup modprobe rules
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jan 9, 2019 at 9:55 AM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Adding reference config file for modprobe.d in order to trigger the
> reference script that will inject keys associated with the nvdimms into
> the kernel user ring for unlock.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Makefile.am                  |   10 ++++++++++
>  contrib/ndctl-loadkeys.sh    |   25 +++++++++++++++++++++++++
>  contrib/nvdimm_modprobe.conf |    1 +
>  3 files changed, 36 insertions(+)
>  create mode 100755 contrib/ndctl-loadkeys.sh
>  create mode 100644 contrib/nvdimm_modprobe.conf

This file is installed to /etc/modprobe.d, so no need to duplicate
"modprobe" in the name. I'd prefer "nvidimm-security.conf" to make it
explicit.

>
> diff --git a/Makefile.am b/Makefile.am
> index e0c463a3..5a3f03aa 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -42,6 +42,16 @@ bashcompletiondir = $(BASH_COMPLETION_DIR)
>  dist_bashcompletion_DATA = contrib/ndctl
>  endif
>
> +load_key_file = contrib/ndctl-loadkeys.sh
> +load_keydir = $(sysconfdir)/ndctl/
> +load_key_DATA = $(load_key_file)
> +EXTRA_DIST += $(load_key_file)

No need for EXTRA_DIST,  _DATA will do this.

> +
> +modprobe_file = contrib/nvdimm_modprobe.conf
> +modprobedir = $(sysconfdir)/modprobe.d/
> +modprobe_DATA = $(modprobe_file)
> +EXTRA_DIST += $(modprobe_file)

ditto.

> +
>  noinst_LIBRARIES = libccan.a
>  libccan_a_SOURCES = \
>         ccan/str/str.h \
> diff --git a/contrib/ndctl-loadkeys.sh b/contrib/ndctl-loadkeys.sh
> new file mode 100755
> index 00000000..bc2c94df
> --- /dev/null
> +++ b/contrib/ndctl-loadkeys.sh
> @@ -0,0 +1,25 @@
> +#!/bin/bash -Ex
> +
> +# This script assumes a single master key for all DIMMs
> +
> +key_path=/etc/ndctl/keys

Hard coded path, this should be constructed from the variables from
the Makefile.

Where is this shell script installed? I think this should become an
actual ndctl command rather than an on-the side shell script. It
otherwise seems odd to name it under "contrib" since this seems
generic enough to be the "official" solution. I think contrib should
be reserved for things that are not fundamental to the operation of
the utility. This seems integral to the security implementation.

The git command harness had support for optionally calling built-in C
routines or shell scripts, would just need to resurrect the support to
route "ndctl load-keys" to this script, likely installed to
/usr/libexec/ndctl.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
