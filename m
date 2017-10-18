From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [Qemu-devel] [RFC 2/2] KVM: add virtio-pmem driver
Date: Wed, 18 Oct 2017 08:51:37 -0700
Message-ID: <CAPcyv4h6aFkyHhh4R4DTznbSCLf9CuBoszk0Q1gB5EKNcp_SeQ@mail.gmail.com>
References: <20171012155027.3277-1-pagupta@redhat.com> <20171012155027.3277-3-pagupta@redhat.com>
 <20171017071633.GA9207@infradead.org> <1441791227.21027037.1508226056893.JavaMail.zimbra@redhat.com>
 <20171017080236.GA27649@infradead.org> <670833322.21037148.1508229041158.JavaMail.zimbra@redhat.com>
 <20171018130339.GB29767@stefanha-x1.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171018130339.GB29767@stefanha-x1.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Pankaj Gupta <pagupta@redhat.com>, Christoph Hellwig <hch@infradead.org>, Kevin Wolf <kwolf@redhat.com>, haozhong zhang <haozhong.zhang@intel.com>, Jan Kara <jack@suse.cz>, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, KVM list <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>, linux-nvdimm <linux-nvdimm@ml01.01.org>, ross zwisler <ross.zwisler@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, Linux MM <linux-mm@kvack.org>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-Id: linux-nvdimm@lists.01.org

On Wed, Oct 18, 2017 at 6:03 AM, Stefan Hajnoczi <stefanha@gmail.com> wrote:
> On Tue, Oct 17, 2017 at 04:30:41AM -0400, Pankaj Gupta wrote:
>>
>> > > Are you saying do it as existing i.e ACPI pmem like interface?
>> > > The reason we have created this new driver is exiting pmem driver
>> > > does not define proper semantics for guest flushing requests.
>> >
>> > At this point I'm caring about the Linux-internal interface, and
>> > for that it should be integrated into the nvdimm subsystem and not
>> > a block driver.  How the host <-> guest interface looks is a different
>> > idea.
>> >
>> > >
>> > > Regarding block support of driver, we want to achieve DAX support
>> > > to bypass guest page cache. Also, we want to utilize existing DAX
>> > > capable file-system interfaces(e.g fsync) from userspace file API's
>> > > to trigger the host side flush request.
>> >
>> > Well, if you want to support XFS+DAX better don't make it a block
>> > devices, because I'll post patches soon to stop using the block device
>> > entirely for the DAX case.
>>
>> o.k I will look at your patches once they are in mailing list.
>> Thanks for the heads up.
>>
>> If I am guessing it right, we don't need block device additional features
>> for pmem? We can bypass block device features like blk device cache flush etc.
>> Also, still we would be supporting ext4 & XFS filesystem with pmem?
>>
>> If there is time to your patches can you please elaborate on this a bit.
>
> I think the idea is that the nvdimm subsystem already adds block device
> semantics on top of the struct nvdimms that it manages.  See
> drivers/nvdimm/blk.c.
>
> So it would be cleaner to make virtio-pmem an nvdimm bus.  This will
> eliminate the duplication between your driver and drivers/nvdimm/ code.
> Try "git grep nvdimm_bus_register" to find drivers that use the nvdimm
> subsystem.

This use case is not "Persistent Memory". Persistent Memory is
something you can map and make persistent with CPU instructions.
Anything that requires a driver call is device driver managed "Shared
Memory".
