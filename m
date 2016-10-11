Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: [Xen-devel] [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
References: <20161010003523.4423-1-haozhong.zhang@intel.com>
 <dde78bbd-4739-98a1-4b69-2c2dff0a9d71@citrix.com>
 <57FCF26A02000078000F15E0@prv-mh.provo.novell.com>
 <CAPcyv4gD3JTq93ET0SAYOxyPO9c0RTkPKSQKqZLo_8KPn53TiA@mail.gmail.com>
 <20161011165811.GO19349@localhost.localdomain>
 <CAPcyv4jX_xzj=gz=tfoNMx0qFtyeKwqttzCE5GrOi6Kz5anhiQ@mail.gmail.com>
 <20161011183259.GA23193@localhost.localdomain>
 <CAPcyv4gSfJM4jso17HdrGzG=rgzmuYkyH024=H4CnfqqVdw+PA@mail.gmail.com>
 <20161011194810.GD25907@localhost.localdomain>
From: Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <c5cac9f8-0b09-a11e-3a3f-7d0f8cd1c486@citrix.com>
Date: Tue, 11 Oct 2016 21:18:51 +0100
MIME-Version: 1.0
In-Reply-To: <20161011194810.GD25907@localhost.localdomain>
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
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Juergen Gross <JGross@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, Jan Beulich <jbeulich@suse.com>, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 11/10/16 20:48, Konrad Rzeszutek Wilk wrote:
> On Tue, Oct 11, 2016 at 12:28:56PM -0700, Dan Williams wrote:
>> On Tue, Oct 11, 2016 at 11:33 AM, Konrad Rzeszutek Wilk
>> <konrad.wilk@oracle.com> wrote:
>>> On Tue, Oct 11, 2016 at 10:51:19AM -0700, Dan Williams wrote:
>> [..]
>>>> Right, but why does the libnvdimm core need to know about this
>>>> specific Xen reservation?  For example, if Xen wants some in-kernel
>>> Let me turn this around - why does the libnvdimm core need to know about
>>> Linux specific parts? Shouldn't this be OS agnostic, so that FreeBSD
>>> for example can also poke a hole in this and fill it with its
>>> OS-management meta-data?
>> Specifically the core needs to know so that it can answer the Linux
>> specific question of whether the pfn returned by ->direct_access() has
>> a corresponding struct page or not. It's tied to the lifetime of the
>> device and the usage of the reservation needs to be coordinated
>> against the references of those pages.  If FreeBSD decides it needs to
>> reserve "struct page" capacity at the start of the device, I would
>> hope that it reuses the same on-device info block that Linux is using
>> and not create a new "FreeBSD-mode" device type.
> The issue here (as I understand, I may be missing something new)
> is that the size of this special namespace may be different. That is
> the 'struct page' on FreeBSD could be 256 bytes while on Linux it is
> 64 bytes (numbers pulled out of the sky).
>
> Hence one would have to expand or such to re-use this.
>> To be honest I do not yet understand what metadata Xen wants to store
>> in the device, but it seems the producer and consumer of that metadata
>> is Xen itself and not the wider Linux kernel as is the case with
>> struct page.  Can you fill me in on what problem Xen solves with this
> Exactly!
>> reservation?
> The same as Linux - its variant of 'struct page'. Which I think is
> smaller than the Linux one, but perhaps it is not?

There is still a bootstrapping issue though, which looks (in its current
form) to cause data corruption.

I hope I am mistaken, and apologies if I am, but clearly we cannot build
a solution that has data corruption in anything other than an
exceptional circumstance.

So far, the sequence of boot operations appears to look like this:

Xen boots, and may find some NVDIMM SPA/MFN ranges via the NFIT table. 
Any ranges available only from AML need dynamically reporting back to
Xen at a later point, once OSPM is up and running.

The NVDIMMs must be mappable by dom0 so the contents can be inspected
and deemed to be safe by the nvdimm driver/host admin, before Xen starts
writing to any of it (for whatever reason).

If this isn't the case, then simply booting a Xen/dom0 combo will end up
corrupting a region before working out that it is safe to do so.

~Andrew
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
