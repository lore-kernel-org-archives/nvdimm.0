Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20161011194810.GD25907@localhost.localdomain>
References: <20161010003523.4423-1-haozhong.zhang@intel.com>
 <dde78bbd-4739-98a1-4b69-2c2dff0a9d71@citrix.com> <57FCF26A02000078000F15E0@prv-mh.provo.novell.com>
 <CAPcyv4gD3JTq93ET0SAYOxyPO9c0RTkPKSQKqZLo_8KPn53TiA@mail.gmail.com>
 <20161011165811.GO19349@localhost.localdomain> <CAPcyv4jX_xzj=gz=tfoNMx0qFtyeKwqttzCE5GrOi6Kz5anhiQ@mail.gmail.com>
 <20161011183259.GA23193@localhost.localdomain> <CAPcyv4gSfJM4jso17HdrGzG=rgzmuYkyH024=H4CnfqqVdw+PA@mail.gmail.com>
 <20161011194810.GD25907@localhost.localdomain>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 11 Oct 2016 13:17:14 -0700
Message-ID: <CAPcyv4hBzGJeR=6bxa+DEwPGQFSCBGsQ1S18GR+y5_MMq6+f4g@mail.gmail.com>
Subject: Re: [Xen-devel] [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jan Beulich <jbeulich@suse.com>, Juergen Gross <JGross@suse.com>, Haozhong Zhang <haozhong.zhang@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, andrew.cooper3@citrix.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, Johannes Thumshirn <jthumshirn@suse.de>, xen-devel@lists.xenproject.org, Andrew Morton <akpm@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 11, 2016 at 12:48 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Tue, Oct 11, 2016 at 12:28:56PM -0700, Dan Williams wrote:
>> On Tue, Oct 11, 2016 at 11:33 AM, Konrad Rzeszutek Wilk
>> <konrad.wilk@oracle.com> wrote:
>> > On Tue, Oct 11, 2016 at 10:51:19AM -0700, Dan Williams wrote:
>> [..]
>> >> Right, but why does the libnvdimm core need to know about this
>> >> specific Xen reservation?  For example, if Xen wants some in-kernel
>> >
>> > Let me turn this around - why does the libnvdimm core need to know about
>> > Linux specific parts? Shouldn't this be OS agnostic, so that FreeBSD
>> > for example can also poke a hole in this and fill it with its
>> > OS-management meta-data?
>>
>> Specifically the core needs to know so that it can answer the Linux
>> specific question of whether the pfn returned by ->direct_access() has
>> a corresponding struct page or not. It's tied to the lifetime of the
>> device and the usage of the reservation needs to be coordinated
>> against the references of those pages.  If FreeBSD decides it needs to
>> reserve "struct page" capacity at the start of the device, I would
>> hope that it reuses the same on-device info block that Linux is using
>> and not create a new "FreeBSD-mode" device type.
>
> The issue here (as I understand, I may be missing something new)
> is that the size of this special namespace may be different. That is
> the 'struct page' on FreeBSD could be 256 bytes while on Linux it is
> 64 bytes (numbers pulled out of the sky).
>
> Hence one would have to expand or such to re-use this.

Sure, but we could support that today.  If FreeBSD lays down the info
block it is free to make a bigger reservation and Linux would be happy
to use a smaller subset.  If we, as an industry, want this "struct
page" reservation to be common we can take it to a standards body to
make as a cross-OS guarantee... but I think this is separate from the
Xen reservation.

>> To be honest I do not yet understand what metadata Xen wants to store
>> in the device, but it seems the producer and consumer of that metadata
>> is Xen itself and not the wider Linux kernel as is the case with
>> struct page.  Can you fill me in on what problem Xen solves with this
>
> Exactly!
>> reservation?
>
> The same as Linux - its variant of 'struct page'. Which I think is
> smaller than the Linux one, but perhaps it is not?
>

If the hypervisor needs to know where it can store some metadata, can
that be satisfied with userspace tooling in Dom0? Something like,
"/dev/pmem0p1 == Xen metadata" and "/dev/pmem0p2 == DAX filesystem
with files to hand to guests".  So my question is not about the
rationale for having metadata, it's why does the Linux kernel need to
know about the Xen reservation? As far as I can see it is independent
/ opaque to the kernel.
