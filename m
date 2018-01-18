Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 18 Jan 2018 13:54:49 -0500 (EST)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1419599412.1747020.1516301689815.JavaMail.zimbra@redhat.com>
In-Reply-To: <72839100-7fdf-693c-e9c2-348a5add8a56@redhat.com>
References: <1455443283.33337333.1500618150787.JavaMail.zimbra@redhat.com>
 <d1df875c-5b64-67d9-2b3c-4ec14c03b85b@gmail.com>
 <CAPcyv4ip6m6e9Bh7weJNB3m3kpDpRkhHDZf0JYyr5UbkD41oLg@mail.gmail.com>
 <654f8935-258e-22ef-fae4-3e14e91e8fae@redhat.com>
 <336152896.34452750.1511527207457.JavaMail.zimbra@redhat.com>
 <f1ca60cc-5506-a161-b473-f0de363b7e95@redhat.com>
 <CAPcyv4j9b6ARvKcJkE25eNHatWACscMJTN_kCLSM6D+bfu_msA@mail.gmail.com>
 <72839100-7fdf-693c-e9c2-348a5add8a56@redhat.com>
Subject: Re: KVM "fake DAX" flushing interface - discussion
MIME-Version: 1.0
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
To: David Hildenbrand <david@redhat.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, kvm-devel <kvm@vger.kernel.org>, Rik van Riel <riel@surriel.com>, Stefan Hajnoczi <stefanha@gmail.com>, Ross Zwisler <ross.zwisler@intel.com>, Qemu Developers <qemu-devel@nongnu.org>, Christoph Hellwig <hch@infradead.org>, Stefan Hajnoczi <stefanha@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>


> 
> >> I'd like to emphasize again, that I would prefer a virtio-pmem only
> >> solution.
> >>
> >> There are architectures out there (e.g. s390x) that don't support
> >> NVDIMMs - there is no HW interface to expose any such stuff.
> >>
> >> However, with virtio-pmem, we could make it work also on architectures
> >> not having ACPI and friends.
> > 
> > ACPI and virtio-only can share the same pmem driver. There are two
> > parts to this, region discovery and setting up the pmem driver. For
> > discovery you can either have an NFIT-bus defined range, or a new
> > virtio-pmem-bus define it. As far as the pmem driver itself it's
> > agnostic to how the range is discovered.
> > 
> 
> And in addition to discovery + setup, we need the flush via virtio.
> 
> > In other words, pmem consumes 'regions' from libnvdimm and the a bus
> > provider like nfit, e820, or a new virtio-mechansim produce 'regions'.
> > 
> 
> That sounds good to me. I would like to see how the ACPI discovery
> variant connects to a virtio ring.
> 
> The natural way for me would be:
> 
> A virtio-X device supplies a memory region ("discovery") and also the
> interface for flushes for this device. So one virtio-X corresponds to
> one pmem device. No ACPI to be involved (also not on architectures that
> have ACPI)

I agree here if we discover regions with virtio-X we don't need to worry about
NFIT ACPI. Actually, there are three ways to do it with pros and cons of these 
approaches: 

1] Existing pmem driver & virtio for region discovery:
  -----------------------------------------------------
  Use existing pmem driver which is tightly coupled with concepts of namespaces, labels etc 
  from ACPI region discovery and re-implement these concepts with virtio so that existing
  pmem driver can understand it. In addition to this, task of pmem driver to send flush command
  using virtio.
  
2] Existing pmem driver & ACPI NFIT for region discovery:
  ----------------------------------------------------------------
- If we use NFIT ACPI, we need to teach existing ACPI driver to add this new memory
  type and teach existing pmem driver to handle this new memory type. Still we need 
  an asynchronous(virtio) way to send flush commands. We need virtio device/driver
  or arbitrary key/value like pair just to send commands from guest to host using virtio. 

3] New Virtio pmem driver & paravirt device:
 ----------------------------------------
  Third way is new virtio pmem driver with less work to support existing features of different protocols, 
  and with asynchronous way of sending flush commands.

  But this needs to duplicate some of the work which existing pmem driver does but as discussed 
  previously we can separate common code from existing pmem driver and reuse it.

Among these approaches I also prefer 3].

> 
> --
> 
> Thanks,
> 
> David / dhildenb
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
