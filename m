Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8073E22106DC7
 for <linux-nvdimm@lists.01.org>; Wed, 28 Mar 2018 10:18:50 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id 126-v6so2828447oig.0
 for <linux-nvdimm@lists.01.org>; Wed, 28 Mar 2018 10:25:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL_Jsq+jC2mAXbKh9c8dbLXZmWbD-sFemrk+8p-oGMkXqSMfnQ@mail.gmail.com>
References: <20180323081209.31387-1-oohall@gmail.com>
 <20180323081209.31387-6-oohall@gmail.com>
 <20180326222448.l7ukrslvccvrjnjf@rob-hp-laptop>
 <CAOSf1CFpFwzLMx0xmM+JmbQCiOA=QU_S5g0uf-qx181vJ_Xc1w@mail.gmail.com>
 <CAL_Jsq+jC2mAXbKh9c8dbLXZmWbD-sFemrk+8p-oGMkXqSMfnQ@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Mar 2018 10:25:28 -0700
Message-ID: <CAPcyv4htpLN16d8JW+_pSy-ORwkQdVnv3guOS0FVmyy+ajvP=Q@mail.gmail.com>
Subject: Re: [PATCH 6/6] doc/devicetree: NVDIMM region documentation
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
To: Rob Herring <robh@kernel.org>
Cc: Device Tree <devicetree@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 28, 2018 at 10:06 AM, Rob Herring <robh@kernel.org> wrote:
[..]
> >> Are DIMMs always going to be the only form factor for NV memory?
> >>
> >> And if you have multiple DIMMs, does each DT node correspond to a DIMM?
> >
> > A nvdimm-region might correspond to a single NVDIMM, a set of
> > interleaved NVDIMMs, or it might just be a chunk of normal memory that
> > you want treated as a NVDIMM for some reason. The last case is useful
> > for provisioning install media on servers since it allows you do
> > download a DVD image, turn it into an nvdimm-region, and kexec into
> > the installer which can use it as a root disk. That may seem a little
> > esoteric, but it's handy and we're using a full linux environment for
> > our boot loader so it's easy to make use of.
>
> I'm really just asking if we should drop the "dimm" name because it is
> not always a DIMM. Maybe pmem instead? I don't know, naming is
> hard(TM).

The Linux enabling uses the term "memory device". The Linux device
object name for memory devices is "nmem".

[..]
> > special since the OS needs to know where it can allocate early in boot
> > and I don't see non-volatile memory as being similarly significant.
> > Fundamentally an NVDIMM is just a memory mapped storage device so we
> > should be able to defer looking at them until later in boot.
>
> It's not clear if 'platform' is just an example or random name or what
> the node is required to be called. In the latter case, we should be
> much more specific because 'platform' could be anything. In the former
> case, then we have no way to find or validate the node because the
> name could be anything and there's no compatible property either.
>
> "region" is pretty generic too.
>

The term "nvdimm-region" has specific meaning to the libnvdimm
sub-system. It is a contiguous physical address range backed by one or
more memory devices, DIMMs, in an interleaved configuration
(interleave set).

One feature that is currently missing from libnvdimm is a management
interface to change an interleave configuration. To date, Linux only
reads a static region configuration published by platform firmware.
Linux can provide dynamic provisioning of namespaces out of those
regions, but interleave configuration has been left to vendor specific
tooling to date. It would be great to start incorporating generic
Linux support for that capability across platform firmware
implementations.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
