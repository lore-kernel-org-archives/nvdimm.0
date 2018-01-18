Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <1386805697.1758284.1516304161333.JavaMail.zimbra@redhat.com>
References: <1455443283.33337333.1500618150787.JavaMail.zimbra@redhat.com>
 <654f8935-258e-22ef-fae4-3e14e91e8fae@redhat.com>
 <336152896.34452750.1511527207457.JavaMail.zimbra@redhat.com>
 <f1ca60cc-5506-a161-b473-f0de363b7e95@redhat.com>
 <CAPcyv4j9b6ARvKcJkE25eNHatWACscMJTN_kCLSM6D+bfu_msA@mail.gmail.com>
 <72839100-7fdf-693c-e9c2-348a5add8a56@redhat.com>
 <1419599412.1747020.1516301689815.JavaMail.zimbra@redhat.com>
 <CAPcyv4hso5FYCyxYBHRhHvsU+M_wrkQBwVKurK-i6BQYzQduPw@mail.gmail.com>
 <1386805697.1758284.1516304161333.JavaMail.zimbra@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 18 Jan 2018 11:48:30 -0800
Message-ID: <CAPcyv4gO37neHvo_TktaNQHj9YK3dmpWJpDQ2iTDr_xv99y8jg@mail.gmail.com>
Subject: Re: KVM "fake DAX" flushing interface - discussion
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
To: Pankaj Gupta <pagupta@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, kvm-devel <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, Rik van Riel <riel@surriel.com>, Ross Zwisler <ross.zwisler@intel.com>, Qemu Developers <qemu-devel@nongnu.org>, Christoph Hellwig <hch@infradead.org>, Stefan Hajnoczi <stefanha@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 18, 2018 at 11:36 AM, Pankaj Gupta <pagupta@redhat.com> wrote:
>
>>
>> On Thu, Jan 18, 2018 at 10:54 AM, Pankaj Gupta <pagupta@redhat.com> wrote:
>> >
>> >>
>> >> >> I'd like to emphasize again, that I would prefer a virtio-pmem only
>> >> >> solution.
>> >> >>
>> >> >> There are architectures out there (e.g. s390x) that don't support
>> >> >> NVDIMMs - there is no HW interface to expose any such stuff.
>> >> >>
>> >> >> However, with virtio-pmem, we could make it work also on architectures
>> >> >> not having ACPI and friends.
>> >> >
>> >> > ACPI and virtio-only can share the same pmem driver. There are two
>> >> > parts to this, region discovery and setting up the pmem driver. For
>> >> > discovery you can either have an NFIT-bus defined range, or a new
>> >> > virtio-pmem-bus define it. As far as the pmem driver itself it's
>> >> > agnostic to how the range is discovered.
>> >> >
>> >>
>> >> And in addition to discovery + setup, we need the flush via virtio.
>> >>
>> >> > In other words, pmem consumes 'regions' from libnvdimm and the a bus
>> >> > provider like nfit, e820, or a new virtio-mechansim produce 'regions'.
>> >> >
>> >>
>> >> That sounds good to me. I would like to see how the ACPI discovery
>> >> variant connects to a virtio ring.
>> >>
>> >> The natural way for me would be:
>> >>
>> >> A virtio-X device supplies a memory region ("discovery") and also the
>> >> interface for flushes for this device. So one virtio-X corresponds to
>> >> one pmem device. No ACPI to be involved (also not on architectures that
>> >> have ACPI)
>> >
>> > I agree here if we discover regions with virtio-X we don't need to worry
>> > about
>> > NFIT ACPI. Actually, there are three ways to do it with pros and cons of
>> > these
>> > approaches:
>> >
>> > 1] Existing pmem driver & virtio for region discovery:
>> >   -----------------------------------------------------
>> >   Use existing pmem driver which is tightly coupled with concepts of
>> >   namespaces, labels etc
>> >   from ACPI region discovery and re-implement these concepts with virtio so
>> >   that existing
>> >   pmem driver can understand it. In addition to this, task of pmem driver
>> >   to send flush command
>> >   using virtio.
>>
>> It's not tightly coupled. The whole point of libnvdimm is to be
>> agnostic to ACPI, e820 or any other range discovery. The only work to
>> do beyond identifying the address range is teaching libnvdimm to pass
>> along a flush control interface to the pmem driver.
>
> o.k that means we can configure libnvdimm with virtio as well and use existing pmem
> driver. AFAICU it uses nvdimm bus?
>
> Do we need other features which ACPI provides?

No, to keep it simple use nvdimm_pmem_region_create without
registering any DIMM devices. I'd start with the e820 driver as a bus
driver reference (drivers/nvdimm/e820.c) rather than try to unwind the
complexity of the nfit driver.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
