Return-Path: <linux-nvdimm-bounces@lists.01.org>
Message-ID: <1500833428.4073.36.camel@redhat.com>
Subject: Re: KVM "fake DAX" flushing interface - discussion
From: Rik van Riel <riel@redhat.com>
Date: Sun, 23 Jul 2017 14:10:28 -0400
In-Reply-To: <CAPcyv4h5O4D2kp6SJhWiz4V=dOLDa_Q3pk2B=u-x7hKKQqdXsQ@mail.gmail.com>
References: <1455443283.33337333.1500618150787.JavaMail.zimbra@redhat.com>
 <945864462.33340808.1500620194836.JavaMail.zimbra@redhat.com>
 <20170721121241.GA18014@stefanha-x1.localdomain>
 <46101617.33460557.1500643755247.JavaMail.zimbra@redhat.com>
 <20170721155848.GO18014@stefanha-x1.localdomain>
 <CAPcyv4gtWYpzbmggsbdLocPiMzU2rVt-ee+kL24gbrPxKd5Eyw@mail.gmail.com>
 <1500818683.4073.31.camel@redhat.com>
 <CAPcyv4h5O4D2kp6SJhWiz4V=dOLDa_Q3pk2B=u-x7hKKQqdXsQ@mail.gmail.com>
Mime-Version: 1.0
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
Cc: Kevin Wolf <kwolf@redhat.com>, Pankaj Gupta <pagupta@redhat.com>, Jan Kara <jack@suse.cz>, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, kvm-devel <kvm@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Zwisler, Ross  <ross.zwisler@intel.com>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi" <stefanha@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, 2017-07-23 at 09:01 -0700, Dan Williams wrote:
> [ adding Ross and Jan ]
> 
> On Sun, Jul 23, 2017 at 7:04 AM, Rik van Riel <riel@redhat.com>
> wrote:
> > 
> > The goal is to increase density of guests, by moving page
> > cache into the host (where it can be easily reclaimed).
> > 
> > If we assume the guests will be backed by relatively fast
> > SSDs, a "whole device flush" from filesystem journaling
> > code (issued where the filesystem issues a barrier or
> > disk cache flush today) may be just what we need to make
> > that work.
> 
> Ok, apologies, I indeed had some pieces of the proposal confused.
> 
> However, it still seems like the storage interface is not capable of
> expressing what is needed, because the operation that is needed is a
> range flush. In the guest you want the DAX page dirty tracking to
> communicate range flush information to the host, but there's no
> readily available block i/o semantic that software running on top of
> the fake pmem device can use to communicate with the host. Instead
> you
> want to intercept the dax_flush() operation and turn it into a queued
> request on the host.
> 
> In 4.13 we have turned this dax_flush() operation into an explicit
> driver call. That seems a better interface to modify than trying to
> map block-storage flush-cache / force-unit-access commands to this
> host request.
> 
> The additional piece you would need to consider is whether to track
> all writes in addition to mmap writes in the guest as DAX-page-cache
> dirtying events, or arrange for every dax_copy_from_iter()
> operation()
> to also queue a sync on the host, but that essentially turns the host
> page cache into a pseudo write-through mode.

I suspect initially it will be fine to not offer DAX
semantics to applications using these "fake DAX" devices
from a virtual machine, because the DAX APIs are designed
for a much higher performance device than these fake DAX
setups could ever give.

Having userspace call fsync/msync like done normally, and
having those coarser calls be turned into somewhat efficient
backend flushes would be perfectly acceptable.

The big question is, what should that kind of interface look
like?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
