Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDB73FC9
	for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 22:47:26 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id q22so7413184pfu.0
        for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 15:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FAccf6OrsNm3eUiH8JmDkz4BW/d3XqteH8DeF8Wi55M=;
        b=A6wWAfvX1qE7HRUSuwkYrDXna73MLs5M/lSag4Azz+A4hMshiFdJhB5au1QioJefcU
         s/ucfr8rrlhatmVcLrmyooSX8MfJazr0Y9QYzLSOVohU3rPQpQaRZ8okvvo+Zd8misgN
         zyiCAzKdY5ygsKalMKC9bpyG7CV8ffAAenwZVdysBMXaGJlDXITWho2HL1wECLghbaiy
         QxDg6CpA7O0yV7tLyzDG/u2xwn8+P8hkNnsnulA/vJd2T7eigw9fnDDHbeFS9JsMuOc7
         C+mT5ChNgMRZLdpxg+vFXdukJqh4PfOMukN4OhruNijA9qFcN7vd7zp2gTiNJepM9/7x
         HHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FAccf6OrsNm3eUiH8JmDkz4BW/d3XqteH8DeF8Wi55M=;
        b=xiwt90BLqWhvY10XPqUet3dNJLe3oSRTQJkdPCiredNvDLKGvI0+7DqO80/LWUrweI
         UXT4FrW1tbC7YVz9gwwKr3nlGD1jspDQ576oHOSmAxQuyFdhr+RyMOY/dt0t+o6Hew88
         xoU3BedGO70AneIunIRVmEqomzqsddZ0v7XydKwigD/j5EB7GhTEcGI8dDnRuR0UZXVP
         8yVHgw+8FGwC2MBaaPN3uK7wVPKmGSS4PVQrX0/f1IweNNsaDl4p4eVmSbuqpeZJOs+9
         +H3yTlkJp+zwDHrqdSoRQGmmL565tBQ5PbQMPbn8QBMZn+6INFAwpFSn3sYF5cZ9CrQq
         jgwg==
X-Gm-Message-State: AOAM532Mtc3tAhAf8FCu/483/hJ/xXeoaFMGflqH+i1dQqpOXYf+rgtN
	MrwX+nmqftdafboZbhp/cvDNyLUWVBCP2Rcyj4vSfHkk3DqPPQ==
X-Google-Smtp-Source: ABdhPJw6WgKGw8kbcGPGH62owFI4a8R/cpD95wKiUgXC7jx0hwi3iOYtyWrYbTfHAZKJ0yRUgDdHXr3ZsekRa3IyxZQ=
X-Received: by 2002:a63:1262:: with SMTP id 34mr7045610pgs.356.1631832445707;
 Thu, 16 Sep 2021 15:47:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210831090459.2306727-1-vishal.l.verma@intel.com> <20210831090459.2306727-3-vishal.l.verma@intel.com>
In-Reply-To: <20210831090459.2306727-3-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Sep 2021 15:47:14 -0700
Message-ID: <CAPcyv4iACg+5v=T5sqarNEfR0qChMOG0y64gzY22mtaNZVJYWg@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/7] daxctl: Documentation updates for persistent reconfiguration
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 31, 2021 at 2:05 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add a man page update describing how daxctl-reconfigure-device(1) can
> be used for persistent reconfiguration of a daxctl device using a
> config file.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  .../daxctl/daxctl-reconfigure-device.txt      | 67 +++++++++++++++++++
>  1 file changed, 67 insertions(+)
>
> diff --git a/Documentation/daxctl/daxctl-reconfigure-device.txt b/Documentation/daxctl/daxctl-reconfigure-device.txt
> index f112b3c..1e2d380 100644
> --- a/Documentation/daxctl/daxctl-reconfigure-device.txt
> +++ b/Documentation/daxctl/daxctl-reconfigure-device.txt
> @@ -162,6 +162,15 @@ include::region-option.txt[]
>         brought online automatically and immediately with the 'online_movable'
>         policy. Use this option to disable the automatic onlining behavior.
>
> +-C::
> +--check-config::
> +       Get reconfiguration parameters from the global daxctl config file.
> +       This is typically used when daxctl-reconfigure-device is called from
> +       a systemd-udevd device unit file. The reconfiguration proceeds only
> +       if the UUID of the dax device passed in on the command line matches
> +       a UUID listed in the auto-online section of the config. See the
> +       'PERSISTENT RECONFIGURATION' section for more details.

There's going to be other match parameters in the future, so this can
probably say something like:

"The reconfiguration proceeds only if the match parameters in a
'reconfigure-device' section of the config match dax device specified
on the command line"

> +
>  include::movable-options.txt[]
>
>  -f::
> @@ -183,6 +192,64 @@ include::human-option.txt[]
>
>  include::verbose-option.txt[]
>
> +PERSISTENT RECONFIGURATION
> +--------------------------
> +
> +The 'mode' of a daxctl device is not persistent across reboots by default. This
> +is because the device itself may hold any metadata that hints at what mode it

s/may hold any/does not hold/

> +was set to, or is intended to be used in. The default mode for such a device

s/in//

> +is 'devdax', and on reboot, that is the mode devices appear in by default.

s/, that is the mode devices appear in by default//

i.e. redundant.

> +
> +The administrator may desire to configure the system in a way that certain

How about:

"The administrator may set policy such that certain dax devices are
always reconfigured into a target configuration every boot."

> +dax devices are always reconfigured into a certain mode every time on boot.
> +This is accomplished via a daxctl config file located at [location TBD].
> +
> +The config file may have multiple sections influencing different aspects of
> +daxctl operation. The section of interest for persistent reconfiguration is
> +'auto-online'. The format of this is as follows:
> +
> +----
> +[auto-online <subsection_name>]
> +uuid = <namespace uuid>
> +mode = <desired reconfiguration mode> (default: system-ram)
> +online = <true|false> (default: true)
> +movable = <true|false> (default: true)
> +----
> +
> +Here is an example of a config snippet for managing three devdax namespaces,
> +one is left in devdax mode, the second is changed to system-ram mode with
> +default options (online, movable), and the third is set to system-ram mode,
> +the memory is onlined, but not movable.
> +
> +Note that the 'subsection name' can be arbitrary, and is only used to
> +identify a specific config section. It does not have to match the 'device
> +name' (e.g. 'dax0.0' etc).
> +
> +----
> +[auto-online dax0]
> +uuid = ed93e918-e165-49d8-921d-383d7b9660c5
> +mode = devdax
> +
> +[auto-online dax1]
> +uuid = f36d02ff-1d9f-4fb9-a5b9-8ceb10a00fe3
> +mode = system-ram
> +
> +[auto-online dax2]
> +uuid = f36d02ff-1d9f-4fb9-a5b9-8ceb10a00fe3
> +mode = system-ram
> +online = true
> +movable = false

One of the tasks I envisioned with persistent configurations was
recalling resize and create device operations. Not saying that needs
to be included now, but I can assume that these reconfiguration steps
are performed in order... Hmm, as I ask that I realize it may depend
on device arrival. Ok, assuming the devices have all arrived by the
time this runs is there a guarantee that these are processed in order?

> +----
> +
> +The following example can be used to create a devdax mode namespace, and
> +simultaneously add the newly created namespace to the config file for
> +system-ram conversion.
> +
> +----
> +ndctl create-namespace --mode=devdax | \
> +       jq -r "\"[auto-online $(uuidgen)]\", \"uuid = \(.uuid)\", \"mode = system-ram\"" >> $config_path
> +----
> +
>  include::../copyright.txt[]
>
>  SEE ALSO
> --
> 2.31.1
>
