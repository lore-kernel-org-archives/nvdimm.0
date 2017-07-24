Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Mon, 24 Jul 2017 17:48:49 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: KVM "fake DAX" flushing interface - discussion
Message-ID: <20170724154849.GQ652@quack2.suse.cz>
References: <20170721155848.GO18014@stefanha-x1.localdomain>
 <CAPcyv4gtWYpzbmggsbdLocPiMzU2rVt-ee+kL24gbrPxKd5Eyw@mail.gmail.com>
 <1500818683.4073.31.camel@redhat.com>
 <CAPcyv4h5O4D2kp6SJhWiz4V=dOLDa_Q3pk2B=u-x7hKKQqdXsQ@mail.gmail.com>
 <1500833428.4073.36.camel@redhat.com>
 <CAPcyv4hpbk0jgp+mA=q05zVBV8ZSZvCvV68JJ4gjE3QhK70d1w@mail.gmail.com>
 <20170724102330.GE652@quack2.suse.cz>
 <1157879323.33809400.1500897967669.JavaMail.zimbra@redhat.com>
 <20170724123752.GN652@quack2.suse.cz>
 <CAPcyv4g-X8S95=uQBo5MzxpwKfqdTbmBis3B56i59wqWiPnCBA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4g-X8S95=uQBo5MzxpwKfqdTbmBis3B56i59wqWiPnCBA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Pankaj Gupta <pagupta@redhat.com>, Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@gmail.com>, Ross Zwisler <ross.zwisler@intel.com>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 24-07-17 08:10:05, Dan Williams wrote:
> On Mon, Jul 24, 2017 at 5:37 AM, Jan Kara <jack@suse.cz> wrote:
> > On Mon 24-07-17 08:06:07, Pankaj Gupta wrote:
> >>
> >> > On Sun 23-07-17 13:10:34, Dan Williams wrote:
> >> > > On Sun, Jul 23, 2017 at 11:10 AM, Rik van Riel <riel@redhat.com> wrote:
> >> > > > On Sun, 2017-07-23 at 09:01 -0700, Dan Williams wrote:
> >> > > >> [ adding Ross and Jan ]
> >> > > >>
> >> > > >> On Sun, Jul 23, 2017 at 7:04 AM, Rik van Riel <riel@redhat.com>
> >> > > >> wrote:
> >> > > >> >
> >> > > >> > The goal is to increase density of guests, by moving page
> >> > > >> > cache into the host (where it can be easily reclaimed).
> >> > > >> >
> >> > > >> > If we assume the guests will be backed by relatively fast
> >> > > >> > SSDs, a "whole device flush" from filesystem journaling
> >> > > >> > code (issued where the filesystem issues a barrier or
> >> > > >> > disk cache flush today) may be just what we need to make
> >> > > >> > that work.
> >> > > >>
> >> > > >> Ok, apologies, I indeed had some pieces of the proposal confused.
> >> > > >>
> >> > > >> However, it still seems like the storage interface is not capable of
> >> > > >> expressing what is needed, because the operation that is needed is a
> >> > > >> range flush. In the guest you want the DAX page dirty tracking to
> >> > > >> communicate range flush information to the host, but there's no
> >> > > >> readily available block i/o semantic that software running on top of
> >> > > >> the fake pmem device can use to communicate with the host. Instead
> >> > > >> you
> >> > > >> want to intercept the dax_flush() operation and turn it into a queued
> >> > > >> request on the host.
> >> > > >>
> >> > > >> In 4.13 we have turned this dax_flush() operation into an explicit
> >> > > >> driver call. That seems a better interface to modify than trying to
> >> > > >> map block-storage flush-cache / force-unit-access commands to this
> >> > > >> host request.
> >> > > >>
> >> > > >> The additional piece you would need to consider is whether to track
> >> > > >> all writes in addition to mmap writes in the guest as DAX-page-cache
> >> > > >> dirtying events, or arrange for every dax_copy_from_iter()
> >> > > >> operation()
> >> > > >> to also queue a sync on the host, but that essentially turns the host
> >> > > >> page cache into a pseudo write-through mode.
> >> > > >
> >> > > > I suspect initially it will be fine to not offer DAX
> >> > > > semantics to applications using these "fake DAX" devices
> >> > > > from a virtual machine, because the DAX APIs are designed
> >> > > > for a much higher performance device than these fake DAX
> >> > > > setups could ever give.
> >> > >
> >> > > Right, we don't need DAX, per se, in the guest.
> >> > >
> >> > > >
> >> > > > Having userspace call fsync/msync like done normally, and
> >> > > > having those coarser calls be turned into somewhat efficient
> >> > > > backend flushes would be perfectly acceptable.
> >> > > >
> >> > > > The big question is, what should that kind of interface look
> >> > > > like?
> >> > >
> >> > > To me, this looks much like the dirty cache tracking that is done in
> >> > > the address_space radix for the DAX case, but modified to coordinate
> >> > > queued / page-based flushing when the guest  wants to persist data.
> >> > > The similarity to DAX is not storing guest allocated pages in the
> >> > > radix but entries that track dirty guest physical addresses.
> >> >
> >> > Let me check whether I understand the problem correctly. So we want to
> >> > export a block device (essentially a page cache of this block device) to a
> >> > guest as PMEM and use DAX in the guest to save guest's page cache. The
> >>
> >> that's correct.
> >>
> >> > natural way to make the persistence work would be to make ->flush callback
> >> > of the PMEM device to do an upcall to the host which could then fdatasync()
> >> > appropriate image file range however the performance would suck in such
> >> > case since ->flush gets called for at most one page ranges from DAX.
> >>
> >> Discussion is : sync a range using paravirt device or flush hit addresses
> >> vs block device flush.
> >>
> >> >
> >> > So what you could do instead is to completely ignore ->flush calls for the
> >> > PMEM device and instead catch the bio with REQ_PREFLUSH flag set on the
> >> > PMEM device (generated by blkdev_issue_flush() or the journalling
> >> > machinery) and fdatasync() the whole image file at that moment - in fact
> >> > you must do that for metadata IO to hit persistent storage anyway in your
> >> > setting. This would very closely follow how exporting block devices with
> >> > volatile cache works with KVM these days AFAIU and the performance will be
> >> > the same.
> >>
> >> yes 'blkdev_issue_flush' does set 'REQ_OP_WRITE | REQ_PREFLUSH' flags.
> >> As per suggestions looks like block flushing device is way ahead.
> >>
> >> If we do an asynchronous block flush at guest side(put current task in
> >> wait queue till host side fdatasync completes) can solve the purpose? Or
> >> do we need another paravirt device for this?
> >
> > Well, even currently if you have PMEM device, you still have also a block
> > device and a request queue associated with it and metadata IO goes through
> > that path. So in your case you will have the same in the guest as a result
> > of exposing virtual PMEM device to the guest and you just need to make sure
> > this virtual block device behaves the same way as traditional virtualized
> > block devices in KVM in respose to 'REQ_OP_WRITE | REQ_PREFLUSH' requests.
> 
> This approach would turn into a full fsync on the host. The question
> in my mind is whether there is any optimization to be had by trapping
> dax_flush() and calling msync() on host ranges, but Jan is right
> trapping blkdev_issue_flush() and turning around and calling host
> fsync() is the most straightforward approach that does not need driver
> interface changes. The dax_flush() approach would need to modify it
> into a async completion interface.

If the backing device on the host is actually a normal block device or an
image file, doing full fsync() is the most efficient implementation
anyway...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
