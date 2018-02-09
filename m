Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85279223DB78E
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 22:25:35 -0800 (PST)
Received: by mail-ot0-x242.google.com with SMTP id f56so6694505otj.13
 for <linux-nvdimm@lists.01.org>; Thu, 08 Feb 2018 22:31:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180209053500.6871-3-vishal.l.verma@intel.com>
References: <20180209053500.6871-1-vishal.l.verma@intel.com>
 <20180209053500.6871-3-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 8 Feb 2018 22:31:20 -0800
Message-ID: <CAPcyv4jKE4iosbHq1NgemQTbdMev5zMsDagGa+kEA4APb8A_2w@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 3/4] ndctl: add a new command - inject-smart
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

On Thu, Feb 8, 2018 at 9:34 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Add an inject-smart command to ndctl to allow injection of smart fields,
> and setting of smart thresholds. If a field is injected that breaches
> the threshold, or sets a fatal flag, or if a new threshold is set that
> causes the same effect, generate an acpi health even notification.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/ndctl/ndctl-inject-smart.txt | 102 +++++++
>  builtin.h                                  |   1 +
>  ndctl/Makefile.am                          |   3 +-
>  ndctl/inject-smart.c                       | 436 +++++++++++++++++++++++++++++
>  ndctl/ndctl.c                              |   1 +
>  5 files changed, 542 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ndctl/ndctl-inject-smart.txt
>  create mode 100644 ndctl/inject-smart.c
>
> v2: Change inject-smart semantics to avoid sub-commands like --inject
> and --set. Instead allow injection and threshold setting all in one
> command by making each a distinct option. (Dan)
>
> diff --git a/Documentation/ndctl/ndctl-inject-smart.txt b/Documentation/ndctl/ndctl-inject-smart.txt
> new file mode 100644
> index 0000000..212bca0
> --- /dev/null
> +++ b/Documentation/ndctl/ndctl-inject-smart.txt
> @@ -0,0 +1,102 @@
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
> +ndctl-inject-smart can be used to set smart thresholds, and inject smart
> +attributes.
> +
> +EXAMPLES
> +--------
> +
> +Set smart controller temperature and spares threshold for DIMM-0 to 32C, spares
> +threshold to 8, and enable the spares alarm.
> +[verse]
> +ndctl inject-smart --ctrl-temperature-threshold=32 --spares-threshold=8 --spares-alarm nmem0
> +
> +Inject a media temperature value of 52 and fatal health status flag for DIMM-0
> +[verse]
> +ndctl inject-smart --media-temperature=52 --health=fatal nmem0
> +
> +
> +OPTIONS
> +-------
> +-b::
> +--bus=::
> +       Enforce that the operation only be carried on devices that are
> +       attached to the given bus. Where 'bus' can be a provider name or a bus
> +       id number.
> +
> +-m::
> +--media-temperature=::
> +       Inject <value> for the media temperature smart attribute.
> +
> +-M::
> +--media-temperature-threshold=::
> +       Set <value> for the smart media temperature threshold.
> +
> +--media-temperature-alarm=::
> +       Enable or disable the smart media temperature alarm. Options are
> +       'on' or 'off'.
> +
> +-c::
> +--ctrl-temperature=::
> +       Inject <value> for the controller temperature smart attribute.
> +
> +-C::
> +--ctrl-temperature-threshold=::
> +       Set <value> for the smart controller temperature threshold.
> +
> +--ctrl-temperature-alarm=::
> +       Enable or disable the smart controller temperature alarm. Options are
> +       'on' or 'off'.
> +
> +-s::
> +--spares=::
> +       Inject <value> for the spares smart attribute.
> +
> +-S::
> +--spares-threshold=::
> +       Set <value> for the smart spares threshold.
> +
> +--spares-alarm=::
> +       Enable or disable the smart spares alarm. Options are 'on' or 'off'.
> +
> +-H::
> +--health=::
> +       Smart attribute for health status. Provide either 'fatal' or 'nominal'
> +       to set the state of the attribute.
> +
> +-U::
> +--unsafe-shutdown=::
> +       Set the flag to spoof an unsafe shutdown on the next power down.
> +
> +-v::
> +--verbose::
> +       Emit debug messages for the error injection process

Nice, and I like your short option choices too.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
