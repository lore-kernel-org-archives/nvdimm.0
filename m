Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7EE36211B85EF
 for <linux-nvdimm@lists.01.org>; Fri,  1 Feb 2019 16:47:42 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id u18so7324487oie.10
 for <linux-nvdimm@lists.01.org>; Fri, 01 Feb 2019 16:47:42 -0800 (PST)
MIME-Version: 1.0
References: <PU1P153MB01690EDA138D3ABDE5B4A482BF970@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4jD1oRWzA4ZiMYZm1uxsbOdgqzbb9raH70-HBDqapcE_g@mail.gmail.com>
 <PU1P153MB0169977604493B82B662A01CBF920@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4haUouYs_Vfju2SMvjcwc7rqY06zqT8NJ-3uakGMZSu0w@mail.gmail.com>
 <PU1P153MB01694FCAF062E089059CD441BF920@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4gdWJ8qtiASU9ggz56Mkrm9OXfsO74RM9OOrXFmBw_A9Q@mail.gmail.com>
 <PU1P153MB0169D8F7C6E29C22FE122F3FBF930@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169D8F7C6E29C22FE122F3FBF930@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 1 Feb 2019 16:47:24 -0800
Message-ID: <CAPcyv4iqHTk8GoyfGB2-LHaMJmxDEb-7XQykeeoWcE--y-oR7Q@mail.gmail.com>
Subject: Re: [PATCH v2] nfit: add Hyper-V NVDIMM DSM command set to white list
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
To: Dexuan Cui <decui@microsoft.com>
Cc: Josh Poulson <jopoulso@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Haiyang Zhang <haiyangz@microsoft.com>, "driverdev-devel@linuxdriverproject.org" <driverdev-devel@linuxdriverproject.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Kelley <mikelley@microsoft.com>, Sasha Levin <Alexander.Levin@microsoft.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, Stephen Hemminger <sthemmin@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 1, 2019 at 4:34 PM Dexuan Cui <decui@microsoft.com> wrote:
>
> > From: Dan Williams <dan.j.williams@intel.com>
> > Sent: Friday, February 1, 2019 3:47 PM
> > To: Dexuan Cui <decui@microsoft.com>
> >
> > I believe it's the same reason. Without 11189c1089da the _LSR method
> > will fail, and otherwise it works and finds the label that it doesn't
> > like.
> Exactly.
>
> > I'm not seeing "invalid" data in your failure log. Could you double
> > check that it's just not the success of _LSR that causes the issue?
>
> acpi_label_read() never fails for me.
>
> By "invalid", I only mean the messages in the dmesg.bad.txt I previously
> attached (I'm just reading the specs to learn the details about NVDIMM
> namespace's labels, so my description might be inaccurate) :
>
> [    4.832367] nvdimm nmem1: nsindex0 labelsize 1 invalid
> [    4.832369] nvdimm nmem1: nsindex1 labelsize 1 invalid

Oh, those are benign. They are a side effect of Linux probing for v1.2
namespace labels vs v1.1. It will always find that one of those is
"invalid".

> ...
> [    5.259017] nd_pmem namespace0.0: 0x0000000000000000, too small must be at least 0x1000
>
> > > > The regression you are seeing is the fact that the patch enables the kernel
> > to
> > > > enable nvdimm-namespace-label reads.
> > > Yes.
> > >
> > > > Those reads find a namespace index block
> > > > and a label. Unfortunately the label has the LOCAL flag set and Linux
> > > > explicitly ignores pmem namespace labels with that bit set. The reason
> > > Can you please point out the function that ignores the flag?
> > >
> > > I checked where NSLABEL_FLAG_LOCAL is used, but it looks I can't find a
> > > related function.
> >
> > scan_labels() is where the namespace label is validated relative to
> > the region type:
> >
> >                 if (is_nd_blk(&nd_region->dev)
> >                                 == !!(flags & NSLABEL_FLAG_LOCAL))
> >                         /* pass, region matches label type */;
> >                 else
> >                         continue;
> >
> > It also has meaning for the namespace capacity allocation
> > implementation that needed that flag to distinguish aliased capacity
> > between Block Aperture Mode and PMEM Mode access.
> Thanks for the pointer! I'm looking at this function.
>
> > > > for that is due to the fact that the original definition of the LOCAL
> > > > bit from v1.1 of the namespace label implementation [1] explicitly
> > > > limited the LOCAL flag to "block aperture" regions. If you clear that
> > > > LOCAL flag I expect it will work. To my knowledge Windows pretends
> > > > that the v1.1 definition never existed.
> > > I'm trying to find out where the flag is used and how to clear it.
> >
> > Assuming Hyper-V implements _LSW, you can recreate / reinitialize the
> > label area:
>
> I think Hyper-V only implements _LSR:
> [    4.720623] nfit ACPI0012:00: device:00: has _LSR
> [    4.723683] nfit ACPI0012:00: device:01: has _LSR

That's unfortunate...

>
> > > > The UEFI 2.7 specification for v1.2 labels states that setting the
> > > > LOCAL flag is optional when "nlabel", number of labels in the set, is
> > > > 1. Linux makes that mandatory as LOCAL is redundant when nlabel is 1.
> > > >
> > > > That said, the Robustness Principle makes a case that Linux should
> > > > tolerate the bit being set. However, it's just a non-trivial amount of
> > > > work to unwind the ingrained block-aperture assumptions of that bit.
> > > Can you please explain this a bit more? Sorry, I'm new to this area...
> >
> > The short story is that Linux enforces that LOCAL == Block Mode
> > Namespaces. See section 2.2 Namespace Label Layout in the original
> > spec [1]. The EFI 2.7 definition tried to allow for LOCAL to be set
> > when an interleave-set was comprised of a single NVDIMM, but then also
> > states its optional when Nlabel is 1. It has zero functional use for
> > interleave-set based namespaces even when the interleave-set-width is
> > 1. So Linux takes the option to never set it, and goes further to
> > reject it if it's set and the region-type does not match, because that
> > follows the v1.1 meaning of the flag.
> >
> > [1]:
> Thanks for the link! I'll read it.
> BTW, it looks Hyper-V only supports PMEM namespace, at least so far.

I don't think it should bother. It only makes sense for bare metal and
even then I know of no NVDIMMs that are shipping it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
