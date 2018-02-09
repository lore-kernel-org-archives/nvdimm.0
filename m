Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 38B8F2222C226
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 16:07:43 -0800 (PST)
Received: by mail-oi0-x241.google.com with SMTP id c189so4833783oib.12
 for <linux-nvdimm@lists.01.org>; Thu, 08 Feb 2018 16:13:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180208210428.7285-3-vishal.l.verma@intel.com>
References: <20180208210428.7285-1-vishal.l.verma@intel.com>
 <20180208210428.7285-3-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 8 Feb 2018 16:13:27 -0800
Message-ID: <CAPcyv4i_zTG92bhVpY18e2F6_bkPbJHfaB23tiEb6g8i7txKPw@mail.gmail.com>
Subject: Re: [ndctl PATCH 3/4] ndctl: add a new command - inject-smart
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

On Thu, Feb 8, 2018 at 1:04 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Add an inject-smart command to ndctl to allow injection of smart fields,
> and setting of smart thresholds. If a field is injected that breaches
> the threshold, or sets a fatal flag, or if a new threshold is set that
> causes the same effect, generate an acpi health even notification.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/ndctl/ndctl-inject-smart.txt |  90 +++++++
>  builtin.h                                  |   1 +
>  ndctl/Makefile.am                          |   3 +-
>  ndctl/inject-smart.c                       | 365 +++++++++++++++++++++++++++++
>  ndctl/ndctl.c                              |   1 +
>  5 files changed, 459 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ndctl/ndctl-inject-smart.txt
>  create mode 100644 ndctl/inject-smart.c
>
> diff --git a/Documentation/ndctl/ndctl-inject-smart.txt b/Documentation/ndctl/ndctl-inject-smart.txt
> new file mode 100644
> index 0000000..da20afe
> --- /dev/null
> +++ b/Documentation/ndctl/ndctl-inject-smart.txt
> @@ -0,0 +1,90 @@
> +ndctl-inject-smart(1)
> +=====================
> +
> +NAME
> +----
> +ndctl-inject-smart - perform smart threshold/injection operations on a DIMM
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl inject-smart' <dimm> [<options>]
> +
> +DESCRIPTION
> +-----------
> +A generic DIMM device object, named /dev/nmemX, is registered for each
> +memory device indicated in the ACPI NFIT table, or other platform NVDIMM
> +resource discovery mechanism.
> +
> +ndctl-inject-smart can be used to set smart thresholds, and inject smart errors.
> +
> +EXAMPLES
> +--------
> +
> +Set smart controller temperature and spares threshold for DIMM-0 to 32C, and 8
> +[verse]
> +ndctl inject-smart --set-threshold --ctrl-temperature=32 --spares=8 nmem0
> +
> +Inject the fatal health status flag for DIMM-0
> +[verse]
> +ndctl inject-smart --inject --fatal nmem0

I'd like to tweak this a bit to eliminate what appears to be a
"sub-command of a sub-command" calling convention. Either we need
separate commands for threshold setting and value injection, not my
first choice, *or* have explicit <set> and <set threshold> options
with the attribute included in the option directly. Where a <set>
operation is an injectable (writable) attribute and <set threshold> is
of course a threshold. We'd then end up with an option stream like:

--controller-temperature=<temp>
--controller-temperature-alarm
--no-controller-temperature-alarm
--controller-temperature-threshold=<temp>
--media-temperature=<temp>
--media-temperature-alarm
--no-media-temperature-alarm
--media-temperature-threshold=temp
--health={fatal,nominal}
--unsafe-shutdown-event

What this also might imply, for a future change, is the capability to
list the supported injections (perhaps annotate the output of ndctl
list -DH??). For example, "controller-temperature" injection should be
an option for completeness, but it will fail on Intel DIMMs that only
define a media temperature injection mechanism.

With this change you can inject, set alarms, and set thresholds all in
one command.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
