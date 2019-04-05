Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 154FD21B02822
 for <linux-nvdimm@lists.01.org>; Fri,  5 Apr 2019 09:56:34 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id x188so5391485oia.13
 for <linux-nvdimm@lists.01.org>; Fri, 05 Apr 2019 09:56:34 -0700 (PDT)
MIME-Version: 1.0
References: <155440490809.3190322.15060922240602775809.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155440492988.3190322.4475460421334178449.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190405121857.0000718a@huawei.com>
 <CAPcyv4hpKkWm0x2jecvmtLNgmwUnAZn3jM_9sKyBAUFaRLj=cQ@mail.gmail.com>
 <20190405172342.00006a56@huawei.com>
In-Reply-To: <20190405172342.00006a56@huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 5 Apr 2019 09:56:22 -0700
Message-ID: <CAPcyv4hxBFcJKbVVgNiE4UYXZS4XY9hfE8W9mN+VrcWS9AvJLw@mail.gmail.com>
Subject: Re: [RFC PATCH 4/5] acpi/hmat: Register special purpose memory as a
 device
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
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 5, 2019 at 9:24 AM Jonathan Cameron
<jonathan.cameron@huawei.com> wrote:
>
> On Fri, 5 Apr 2019 08:43:03 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > On Fri, Apr 5, 2019 at 4:19 AM Jonathan Cameron
> > <jonathan.cameron@huawei.com> wrote:
> > >
> > > On Thu, 4 Apr 2019 12:08:49 -0700
> > > Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > > Memory that has been tagged EFI_SPECIAL_PURPOSE, and has performance
> > > > properties described by the ACPI HMAT is expected to have an application
> > > > specific consumer.
> > > >
> > > > Those consumers may want 100% of the memory capacity to be reserved from
> > > > any usage by the kernel. By default, with this enabling, a platform
> > > > device is created to represent this differentiated resource.
> > > >
> > > > A follow on change arranges for device-dax to claim these devices by
> > > > default and provide an mmap interface for the target application.
> > > > However, if the administrator prefers that some or all of the special
> > > > purpose memory is made available to the core-mm the device-dax hotplug
> > > > facility can be used to online the memory with its own numa node.
> > > >
> > > > Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> > > > Cc: Len Brown <lenb@kernel.org>
> > > > Cc: Keith Busch <keith.busch@intel.com>
> > > > Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > >
> > > Hi Dan,
> > >
> > > Great to see you getting this discussion going so fast and in
> > > general the approach makes sense to me.
> > >
> > > I'm a little confused why HMAT has anything to do with this.
> > > SPM is defined either via the attribute in SRAT SPA entries,
> > > EF_MEMORY_SP or via the EFI memory map.
> > >
> > > Whether it is in HMAT or not isn't all that relevant.
> > > Back in the days of the reservation hint (so before yesterday :)
> > > it was relevant obviously but that's no longer true.
> > >
> > > So what am I missing?
> >
> > It's a good question, and an assumption I should have explicitly
> > declared in the changelog. The problem with EFI_MEMORY_SP is the same
> > as the problem with the EfiPersistentMemory type, it isn't precise
> > enough on its own for the kernel to delineate 'type' or
> > device/replaceable-unit boundaries. For example, I expect one
> > EFI_MEMORY_SP range of a specific type may be contiguous with another
> > range of a different type. Similar to the NFIT there is no requirement
> > in the specification that platform firmware inject multiple range
> > entries. Instead that precision is left to the SRAT + HMAT, or the
> > NFIT in the case of PMEM.
>
> Absolutely, as long as they are all SPM, they could be anywhere in
> the system.
>
> >
> > Conversely, and thinking through this a bit more, if a memory range is
> > "special", but the platform fails to enumerate it in HMAT I think
> > Linux should scream loudly that the firmware is broken and leave the
> > range alone. The "scream loudly" piece is missing in the current set,
> > but the "leave the range alone" functionality is included.
>
> I am certainly keen on screaming if the various entries are inconsistent
> but am not sure they necessarily are here.
>
> So there are a couple of ways we could get an SPM range defined.
> The key thing here is that firmware should be attempting to describe
> what it has to some degree somewhere.  If not it won't get a good
> result ;)  So if there is no SRAT then you are on your own. SCREAM!
>
> 1. Directly in the memory map.  If there is no other information then
>    tough luck the kernel can only sensibly handle it as one device.
>    Or not at all, which seems like a reasonable decision to me.
>    SCREAM
>
> 2. In memory map + a proximity domain entry in SRAT.  Given memory
>    with different characteristics should be in different proximity
>    domains anyway - this should be fairly precise. The slight snag
>    here is that the fine grained nature of SRAT is actually a side
>    effect of HMAT, so not sure well platforms have traditional
>    describe their more subtle differences.
>
> 3. In NFIT as NFIT SPA carries the memory attribute.  Not sure if
>    we should scream if this disagrees with the memory map.
>
> 4. In HMAT?  Now this changed in ACPI 6.3 to clean up the 'messy'
>    prior relationship between it and SRAT.  Now HMAT no longer has
>    memory address ranges as you observed.  That means, to describe
>    properties of memory, it has to use the proximity domains of
>    SRAT.  It provides lots of additional info about those domains
>    but it is SRAT that defines them.
>
> So I would argue that HMAT itself doesn't tell us anything useful.
> SRAT certainly does though so I think this should be coming from
> SRAT (or NFIT as that also defines the required precision)

I agree, yes, SRAT by itself is sufficient for this "precision"
concern. However, do we, core Linux developers, really want to
encourage platform vendors that they can ignore deploying HMAT data
and get Linux to honor that sub-case for EFI_MEMORY_SP? My personal
experience is that platform firmware will take advantage of almost any
opportunity to minimize the data it provides to the OS. The only hard
lever Linux has to encourage platform firmware to give complete data
is to decline to support configurations that have incomplete data.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
