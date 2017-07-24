Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x236.google.com (mail-yw0-x236.google.com
 [IPv6:2607:f8b0:4002:c05::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E944A2095DB9C
 for <linux-nvdimm@lists.01.org>; Mon, 24 Jul 2017 16:33:55 -0700 (PDT)
Received: by mail-yw0-x236.google.com with SMTP id x125so58899812ywa.0
 for <linux-nvdimm@lists.01.org>; Mon, 24 Jul 2017 16:35:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <556dc70b-2759-b483-868e-041f1be772f7@hpe.com>
References: <556dc70b-2759-b483-868e-041f1be772f7@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 24 Jul 2017 16:35:54 -0700
Message-ID: <CAPcyv4jHi6UW+EHpotJyX+3CtY=_KqG3+84z8p6zLAWR5Z3BLQ@mail.gmail.com>
Subject: Re: don't control-c during ndctl create-namespace?
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 24, 2017 at 4:15 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> Hi Dan,
>
> I've got 4 NVDIMMs in an interleave set in a configuration that supports labels.
> I'm running a 4.12 kernel with the latest ndctl.
>
> I had three namespaces configured and all seemed well.  When I configured the
> fourth one, I made a mistake in the name so I hit control-c.  I wasn't sure what
> state I was in but according to what I could see with ndctl, it had created the
> namespace but not  enabled it, so I enabled it manually with ndctl and that
> seemed ok.
>
> Then I tried to use ndctl create-namespace to change the name, which failed
> because the namespace was enabled so I disabled it and tried again.  At some
> point, not really sure where, I got this kernel warning:
>
> # [ 5224.196085] nd namespace4.3: failed to track label: 4
>
> (details in the attached file)
>
> At this point I rebooted the system.  When it came back up, nmem0 was disabled.
> I dumped the labels (also attached) and I see that nmem0 has some extra labels
> that correspond to the namespace that I was struggling with.
>
> I think my troubles started with the control-c. It doesn't look like ndctl traps
> signals when creating namespaces so perhaps we can get into an inconsistent
> state.
>
> It also seems like that kernel warning is a bit more important than a
> WARN_ONCE would imply.  I think that was the beginning of the end of my
> configuration.  It might have been better to just panic.

In general if the system is even remotely recoverable we don't panic.
In this case it is recoverable. The WARN_ONCE() is really there as a
loud, "this is a kernel bug, but we'll do our best to keep going".

> I was trying to figure out if I could fix my configuration without
> losing the good namespaces but I don't see a way.  The check-labels option
> isn't very helpful because I think it only looks at the info blocks,
> which are fine, even though the labels on nmem0 are not.  The destroy-namespace
> option doesn't help because it only works with a good namespace.
>
> I'm going to wipe my nvdimms and start over.  I suspect the problem is
> reproducible but it could depend on the timing of the control-c, unless
> the root cause was actually trying to rename a namespace.  Maybe I'll try
> that again but not today.

The recovery method when the labels are corrupted is:

ndctl disable-region all
ndctl zero-labels all
ndctl enable-region all

...and that should get you back to square one.

If you are able to reproduce I'd like to see the state of the DIMM
label areas. You can dump them in json format with the following:

ndctl read-labels -j all
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
