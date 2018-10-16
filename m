Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 58B072194D387
 for <linux-nvdimm@lists.01.org>; Mon, 15 Oct 2018 18:25:21 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id s69-v6so16663365oie.10
 for <linux-nvdimm@lists.01.org>; Mon, 15 Oct 2018 18:25:21 -0700 (PDT)
MIME-Version: 1.0
References: <153938316555.20740.14314691018876178251.stgit@djiang5-desk3.ch.intel.com>
 <153938334276.20740.14352246357588427406.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153938334276.20740.14352246357588427406.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Oct 2018 18:25:09 -0700
Message-ID: <CAPcyv4j0Si4_Ud4o43Cbjfo-3_uPmockMvqBUpVTupySV5c1Ew@mail.gmail.com>
Subject: Re: [PATCH v4 5/7] ndctl: add support for sanitize dimm
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

On Fri, Oct 12, 2018 at 3:29 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Add support to secure erase to libndctl and also command line option
> of "sanitize" for ndctl. This will initiate the request to crypto
> erase a DIMM. ndctl does not actually handle the verification of the
> security. That is handled by the kernel and the key upcall mechanism.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/ndctl/Makefile.am        |    3 +
>  Documentation/ndctl/ndctl-sanitize.txt |   52 ++++++++++++++++++++++++
>  builtin.h                              |    1
>  ndctl/dimm.c                           |   70 ++++++++++++++++++++++++++++++++
>  ndctl/lib/dimm.c                       |    9 ++++
>  ndctl/lib/libndctl.sym                 |    1
>  ndctl/libndctl.h                       |    1
>  ndctl/ndctl.c                          |    1
>  8 files changed, 137 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ndctl/ndctl-sanitize.txt
>
> diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
> index 3a761ba0..8c171ecb 100644
> --- a/Documentation/ndctl/Makefile.am
> +++ b/Documentation/ndctl/Makefile.am
> @@ -50,7 +50,8 @@ man1_MANS = \
>         ndctl-monitor.1 \
>         ndctl-update-security.1 \
>         ndctl-disable-security.1 \
> -       ndctl-freeze-security.1
> +       ndctl-freeze-security.1 \
> +       ndctl-sanitize.1
>
>  CLEANFILES = $(man1_MANS)
>
> diff --git a/Documentation/ndctl/ndctl-sanitize.txt b/Documentation/ndctl/ndctl-sanitize.txt
> new file mode 100644
> index 00000000..a02b4b31
> --- /dev/null
> +++ b/Documentation/ndctl/ndctl-sanitize.txt
> @@ -0,0 +1,52 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +ndctl-sanitize(1)
> +=================
> +
> +NAME
> +----
> +ndctl-sanitize - sanitize the data on the NVDIMM
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl sanitize' <dimm> [<options>]

Lets call it secure-erase-dimm since to leave room for per-namespace
security commands in the future.

> +DESCRIPTION
> +-----------
> +Provide a generic interface to crypto erase a NVDIMM.
> +The use of this depends on support from the underlying
> +libndctl, kernel, as well as the platform itself.

Similar comment about dependencies as patch 2 I think it goes without saying.

> +
> +For the reference passphrase setup, /etc/nvdimm.passwd is read for passphrase
> +retrieval:
> +
> +The nvdimm.passwd is formatted as:
> +<description id>:<passphrase with padded 0 to 32bytes>
> +cdab-0a-07e0-feffffff:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
> +
> +OPTIONS
> +-------
> +<dimm>::
> +include::xable-dimm-options.txt[]
> +
> +-m::
> +--method::
> +       The method for sanitizing the dimm content.
> +
> +       crypto-erase: replaces encryption keys. This does not change label data.

I assume this is to differentiate secure-erase vs overwrite? Given
overwrite is such an odd mechanism that needs to be monitored for
completion I'd put that off in its own command.

> +
> +-i::
> +--insecure::
> +       Using the default reference support to parse the nvdimm passphrase
> +       file, inject the key, and initiate disable operation. This is labeled
> +       as insecure as it just provides a reference to how to inject keys
> +       for the nvdimm. The passphrase is in clear text and is not considered
> +       as secure as it can be.
> +
> +-e::
> +--exec::
> +       The external binary module that would inject the passphrase and
> +       initiate the disable operation. Use this or -i, not both.

Same comments about taking key material over stdio.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
