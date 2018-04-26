From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v2 2/2] pmem: device flush over VIRTIO
Date: Thu, 26 Apr 2018 13:13:44 -0400 (EDT)
Message-ID: <1302242642.23016855.1524762824836.JavaMail.zimbra@redhat.com>
References: <20180425112415.12327-1-pagupta@redhat.com>
 <20180425112415.12327-3-pagupta@redhat.com>
 <20180426131517.GB30991@stefanha-x1.localdomain>
 <58645254.23011245.1524760853269.JavaMail.zimbra@redhat.com>
 <CAPcyv4jv-hJNKJxak98T7aCnWztVEDTE8o=8fjvOrVmrTfyjdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4jv-hJNKJxak98T7aCnWztVEDTE8o=8fjvOrVmrTfyjdA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, ross zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Qemu Developers <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Stefan Hajnoczi <stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nitesh Narayan Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kevin Wolf <kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Igor Mammedov <imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org


> >
> >>
> >> On Wed, Apr 25, 2018 at 04:54:14PM +0530, Pankaj Gupta wrote:
> >> > This patch adds functionality to perform
> >> > flush from guest to hosy over VIRTIO
> >> > when 'ND_REGION_VIRTIO'flag is set on
> >> > nd_negion. Flag is set by 'virtio-pmem'
> >> > driver.
> >> >
> >> > Signed-off-by: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> > ---
> >> >  drivers/nvdimm/region_devs.c | 7 +++++++
> >> >  1 file changed, 7 insertions(+)
> >> >
> >> > diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> >> > index a612be6..6c6454e 100644
> >> > --- a/drivers/nvdimm/region_devs.c
> >> > +++ b/drivers/nvdimm/region_devs.c
> >> > @@ -20,6 +20,7 @@
> >> >  #include <linux/nd.h>
> >> >  #include "nd-core.h"
> >> >  #include "nd.h"
> >> > +#include <linux/virtio_pmem.h>
> >> >
> >> >  /*
> >> >   * For readq() and writeq() on 32-bit builds, the hi-lo, lo-hi order is
> >> > @@ -1074,6 +1075,12 @@ void nvdimm_flush(struct nd_region *nd_region)
> >> >     struct nd_region_data *ndrd = dev_get_drvdata(&nd_region->dev);
> >> >     int i, idx;
> >> >
> >> > +       /* call PV device flush */
> >> > +   if (test_bit(ND_REGION_VIRTIO, &nd_region->flags)) {
> >> > +           virtio_pmem_flush(&nd_region->dev);
> >> > +           return;
> >> > +   }
> >>
> >> How does libnvdimm know when flush has completed?
> >>
> >> Callers expect the flush to be finished when nvdimm_flush() returns but
> >> the virtio driver has only queued the request, it hasn't waited for
> >> completion!
> >
> > I tried to implement what nvdimm does right now. It just writes to
> > flush hint address to make sure data persists.
> 
> nvdimm_flush() is currently expected to be synchronous. Currently it
> is sfence(); write to special address; sfence(). By the time the
> second sfence returns the data is flushed. So you would need to make
> this virtio flush interface synchronous as well, but that appears
> problematic to stop the guest for unbounded amounts of time. Instead,
> you need to rework nvdimm_flush() and the pmem driver to make these
> flush requests asynchronous and add the plumbing for completion
> callbacks via bio_endio().

o.k. 

> 
> > I just did not want to block guest write requests till host side
> > fsync completes.
> 
> You must complete the flush before bio_endio(), otherwise you're
> violating the expectations of the guest filesystem/block-layer.

sure!

> 
> >
> > be worse for operations on different guest files because all these
> > operations would happen
> > ultimately on same file at host.
> >
> > I think with current way, we can achieve an asynchronous queuing mechanism
> > on cost of not
> > 100% sure when fsync would complete but it is assured it will happen. Also,
> > its entire block
> > flush.
> 
> No, again,  that's broken. We need to add the plumbing for
> communicating the fsync() completion relative the WRITE_{FLUSH,FUA}
> bio in the guest.

Sure. Thanks Dan & Stefan for the explanation and review. 

Best regards,
Pankaj
