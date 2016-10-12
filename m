Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 12 Oct 2016 18:33:18 +0800
From: Haozhong Zhang <haozhong.zhang@intel.com>
Subject: Re: [Xen-devel] [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
Message-ID: <20161012103318.vq36ed5ebb5xxcom@hz-desktop>
References: <20161010003523.4423-1-haozhong.zhang@intel.com>
 <dde78bbd-4739-98a1-4b69-2c2dff0a9d71@citrix.com>
 <57FCF26A02000078000F15E0@prv-mh.provo.novell.com>
 <CAPcyv4gD3JTq93ET0SAYOxyPO9c0RTkPKSQKqZLo_8KPn53TiA@mail.gmail.com>
 <20161011165811.GO19349@localhost.localdomain>
 <CAPcyv4jX_xzj=gz=tfoNMx0qFtyeKwqttzCE5GrOi6Kz5anhiQ@mail.gmail.com>
 <20161011183259.GA23193@localhost.localdomain>
 <CAPcyv4gSfJM4jso17HdrGzG=rgzmuYkyH024=H4CnfqqVdw+PA@mail.gmail.com>
 <20161011194810.GD25907@localhost.localdomain>
 <CAPcyv4hBzGJeR=6bxa+DEwPGQFSCBGsQ1S18GR+y5_MMq6+f4g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hBzGJeR=6bxa+DEwPGQFSCBGsQ1S18GR+y5_MMq6+f4g@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Jan Beulich <jbeulich@suse.com>, Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Juergen Gross <JGross@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 10/11/16 13:17 -0700, Dan Williams wrote:
>On Tue, Oct 11, 2016 at 12:48 PM, Konrad Rzeszutek Wilk
><konrad.wilk@oracle.com> wrote:
>> On Tue, Oct 11, 2016 at 12:28:56PM -0700, Dan Williams wrote:
>>> On Tue, Oct 11, 2016 at 11:33 AM, Konrad Rzeszutek Wilk
>>> <konrad.wilk@oracle.com> wrote:
>>> > On Tue, Oct 11, 2016 at 10:51:19AM -0700, Dan Williams wrote:
>>> [..]
>>> >> Right, but why does the libnvdimm core need to know about this
>>> >> specific Xen reservation?  For example, if Xen wants some in-kernel
>>> >
>>> > Let me turn this around - why does the libnvdimm core need to know about
>>> > Linux specific parts? Shouldn't this be OS agnostic, so that FreeBSD
>>> > for example can also poke a hole in this and fill it with its
>>> > OS-management meta-data?
>>>
>>> Specifically the core needs to know so that it can answer the Linux
>>> specific question of whether the pfn returned by ->direct_access() has
>>> a corresponding struct page or not. It's tied to the lifetime of the
>>> device and the usage of the reservation needs to be coordinated
>>> against the references of those pages.  If FreeBSD decides it needs to
>>> reserve "struct page" capacity at the start of the device, I would
>>> hope that it reuses the same on-device info block that Linux is using
>>> and not create a new "FreeBSD-mode" device type.
>>
>> The issue here (as I understand, I may be missing something new)
>> is that the size of this special namespace may be different. That is
>> the 'struct page' on FreeBSD could be 256 bytes while on Linux it is
>> 64 bytes (numbers pulled out of the sky).
>>
>> Hence one would have to expand or such to re-use this.
>
>Sure, but we could support that today.  If FreeBSD lays down the info
>block it is free to make a bigger reservation and Linux would be happy
>to use a smaller subset.  If we, as an industry, want this "struct
>page" reservation to be common we can take it to a standards body to
>make as a cross-OS guarantee... but I think this is separate from the
>Xen reservation.
>
>>> To be honest I do not yet understand what metadata Xen wants to store
>>> in the device, but it seems the producer and consumer of that metadata
>>> is Xen itself and not the wider Linux kernel as is the case with
>>> struct page.  Can you fill me in on what problem Xen solves with this
>>
>> Exactly!
>>> reservation?
>>
>> The same as Linux - its variant of 'struct page'. Which I think is
>> smaller than the Linux one, but perhaps it is not?
>>
>
>If the hypervisor needs to know where it can store some metadata, can
>that be satisfied with userspace tooling in Dom0? Something like,
>"/dev/pmem0p1 == Xen metadata" and "/dev/pmem0p2 == DAX filesystem
>with files to hand to guests".  So my question is not about the
>rationale for having metadata, it's why does the Linux kernel need to
>know about the Xen reservation? As far as I can see it is independent
>/ opaque to the kernel.

Thank everyone for all these comments!

How about doing the reservation in the following way:

1. Create partition(s) on /dev/pmemX and make sure space besides the
   partition table and potential padding before the first partition is
   large enough to hold Xen's management structures and a super block
   introduced in step 2. The space besides the partition table,
   padding and the super block will be used as the reserved area.

2. Write a super block before above reserved area. The super block
   records the base address and the size of the reserved area. It also
   contains a signature and a checksum to identify itself.

The layout is shown as the following diagram.

+---------------+-----------+-------+----------+--------------+
| whatever used | Partition | Super | Reserved | /dev/pmem0p1 |
|  by kernel    |   Table   | Block | for Xen  |              |
+---------------+-----------+-------+----------+--------------+
                \_____________________ _______________________/
		                      V
				 /dev/pmem0

Above two steps can be done via a userspace program and do not need
Xen hypervisor running. The partitions on the device can be used
regardless of the existence of Xen hypervisor.

3. When Xen is running, implement a function in Dom0 Linux xen driver
   (drivers/xen/) to response to udevd events that notify the
   detection of the pmem regions.

   This function searches on the pmem region for the super block
   created in step 2. If one is found, it will know this pmem region
   has been prepared for Xen usage.

   Then it gets the base address and size of the reserved area (from
   super block) and the entire address ranges of the pmem region (from
   pmem driver), and reports them to Xen hypervisor.

The implementation of this step can be completely included in the
kernel Xen driver. (It may also be implemented as a udevd service in
userspace, if it's not considered as unsafe)

Thanks,
Haozhong
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
