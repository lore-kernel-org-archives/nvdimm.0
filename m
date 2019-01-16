Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 61149211B7F83
 for <linux-nvdimm@lists.01.org>; Tue, 15 Jan 2019 20:53:18 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id t5so124435otk.1
 for <linux-nvdimm@lists.01.org>; Tue, 15 Jan 2019 20:53:18 -0800 (PST)
MIME-Version: 1.0
References: <154749627829.63704.2987015129166185725.stgit@djiang5-desk3.ch.intel.com>
 <154749641859.63704.12807813922780466193.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154749641859.63704.12807813922780466193.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Jan 2019 20:53:06 -0800
Message-ID: <CAPcyv4jk1XhqJLChAT2O1JFBTxO96_w4je=xu=MXVnF9izkoWg@mail.gmail.com>
Subject: Re: [PATCH v8 04/12] ndctl: add support for freeze security
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

On Mon, Jan 14, 2019 at 12:07 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Add support for freeze security to libndctl and also command line option
> of "freeze-security" for ndctl. This will lock the ability to make changes
> to the NVDIMM security.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/ndctl/Makefile.am               |    3 ++-
>  Documentation/ndctl/ndctl-freeze-security.txt |   20 ++++++++++++++++++
>  ndctl/builtin.h                               |    1 +
>  ndctl/dimm.c                                  |   28 +++++++++++++++++++++++++
>  ndctl/lib/dimm.c                              |    5 ++++
>  ndctl/lib/libndctl.sym                        |    1 +
>  ndctl/libndctl.h                              |    1 +
>  ndctl/ndctl.c                                 |    1 +
>  8 files changed, 59 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ndctl/ndctl-freeze-security.txt
>
> diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
> index 31570a77..a97f193d 100644
> --- a/Documentation/ndctl/Makefile.am
> +++ b/Documentation/ndctl/Makefile.am
> @@ -50,7 +50,8 @@ man1_MANS = \
>         ndctl-monitor.1 \
>         ndctl-enable-passphrase.1 \
>         ndctl-update-passphrase.1 \
> -       ndctl-disable-passphrase.1
> +       ndctl-disable-passphrase.1 \
> +       ndctl-freeze-security.1
>
>  CLEANFILES = $(man1_MANS)
>
> diff --git a/Documentation/ndctl/ndctl-freeze-security.txt b/Documentation/ndctl/ndctl-freeze-security.txt
> new file mode 100644
> index 00000000..4e9d2d61
> --- /dev/null
> +++ b/Documentation/ndctl/ndctl-freeze-security.txt
> @@ -0,0 +1,20 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +ndctl-freeze-security(1)
> +========================
> +
> +NAME
> +----
> +ndctl-freeze-security - enabling or freeze the security for an NVDIMM

What is it "enabling"?

I would just say:

"Set the given DIMM(s) to reject future security operations"

> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl freeze-security' <dimm>

Code says:

    ndctl freeze-security <nmem0> [<nmem1>..<nmemN>] [<options>]

...I'm assuming the multiple nmem support is true, but there are no
extra options?

...and now that I say that out loud, I think all of these commands
should support -v/--verbose to turn on libndctl debug.

> +
> +DESCRIPTION
> +-----------
> +Provide a generic interface to freeze the security for NVDIMM.

That can go, it reads like a changelog, not a man page.

> Once security
> +is frozen, no other security operations can succeed until reboot happens.

"Prevent any further security operations on the given DIMMs until the
next reboot. This is used in scenarios where the administrator has
taken all expected security actions for the current boot and wants the
DIMM to enforce / lock the current state."

An example section might show some before and after "ndctl list" data
for the DIMM and perhaps the state changes of the /etc/ndctl/keys
directory.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
