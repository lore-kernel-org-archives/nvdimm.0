From: Stefan Hajnoczi <stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Qemu-devel] [RFC 2/2] KVM: add virtio-pmem driver
Date: Thu, 19 Oct 2017 10:01:46 +0200
Message-ID: <20171019080146.GA3503@stefanha-x1.localdomain>
References: <20171012155027.3277-1-pagupta@redhat.com>
 <20171012155027.3277-3-pagupta@redhat.com>
 <20171017071633.GA9207@infradead.org>
 <1441791227.21027037.1508226056893.JavaMail.zimbra@redhat.com>
 <20171017080236.GA27649@infradead.org>
 <670833322.21037148.1508229041158.JavaMail.zimbra@redhat.com>
 <20171018130339.GB29767@stefanha-x1.localdomain>
 <CAPcyv4h6aFkyHhh4R4DTznbSCLf9CuBoszk0Q1gB5EKNcp_SeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4h6aFkyHhh4R4DTznbSCLf9CuBoszk0Q1gB5EKNcp_SeQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Kevin Wolf <kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, ross zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Qemu Developers <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nitesh Narayan Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Oct 18, 2017 at 08:51:37AM -0700, Dan Williams wrote:
> On Wed, Oct 18, 2017 at 6:03 AM, Stefan Hajnoczi <stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On Tue, Oct 17, 2017 at 04:30:41AM -0400, Pankaj Gupta wrote:
> >>
> >> > > Are you saying do it as existing i.e ACPI pmem like interface?
> >> > > The reason we have created this new driver is exiting pmem driver
> >> > > does not define proper semantics for guest flushing requests.
> >> >
> >> > At this point I'm caring about the Linux-internal interface, and
> >> > for that it should be integrated into the nvdimm subsystem and not
> >> > a block driver.  How the host <-> guest interface looks is a different
> >> > idea.
> >> >
> >> > >
> >> > > Regarding block support of driver, we want to achieve DAX support
> >> > > to bypass guest page cache. Also, we want to utilize existing DAX
> >> > > capable file-system interfaces(e.g fsync) from userspace file API's
> >> > > to trigger the host side flush request.
> >> >
> >> > Well, if you want to support XFS+DAX better don't make it a block
> >> > devices, because I'll post patches soon to stop using the block device
> >> > entirely for the DAX case.
> >>
> >> o.k I will look at your patches once they are in mailing list.
> >> Thanks for the heads up.
> >>
> >> If I am guessing it right, we don't need block device additional features
> >> for pmem? We can bypass block device features like blk device cache flush etc.
> >> Also, still we would be supporting ext4 & XFS filesystem with pmem?
> >>
> >> If there is time to your patches can you please elaborate on this a bit.
> >
> > I think the idea is that the nvdimm subsystem already adds block device
> > semantics on top of the struct nvdimms that it manages.  See
> > drivers/nvdimm/blk.c.
> >
> > So it would be cleaner to make virtio-pmem an nvdimm bus.  This will
> > eliminate the duplication between your driver and drivers/nvdimm/ code.
> > Try "git grep nvdimm_bus_register" to find drivers that use the nvdimm
> > subsystem.
> 
> This use case is not "Persistent Memory". Persistent Memory is
> something you can map and make persistent with CPU instructions.
> Anything that requires a driver call is device driver managed "Shared
> Memory".

Dan, in that case do you have ideas regarding Christoph Hellwig's
comment that this driver should be integrated into the nvdimm subsystem
instead of a new block driver?

Stefan
