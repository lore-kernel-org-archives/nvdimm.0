Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 36A4720212C8D
 for <linux-nvdimm@lists.01.org>; Tue, 27 Aug 2019 04:56:26 -0700 (PDT)
Date: Tue, 27 Aug 2019 07:54:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 05/19] virtio: Implement get_shm_region for MMIO transport
Message-ID: <20190827115409.GB30873@redhat.com>
References: <20190821175720.25901-1-vgoyal@redhat.com>
 <20190821175720.25901-6-vgoyal@redhat.com>
 <20190827103943.4c6c9342.cohuck@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190827103943.4c6c9342.cohuck@redhat.com>
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
To: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org, miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, dgilbert@redhat.com, virtio-fs@redhat.com, Sebastien Boeuf <sebastien.boeuf@intel.com>, stefanha@redhat.com, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 27, 2019 at 10:39:43AM +0200, Cornelia Huck wrote:
> On Wed, 21 Aug 2019 13:57:06 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > From: Sebastien Boeuf <sebastien.boeuf@intel.com>
> > 
> > On MMIO a new set of registers is defined for finding SHM
> > regions.  Add their definitions and use them to find the region.
> > 
> > Cc: kvm@vger.kernel.org
> > Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
> > ---
> >  drivers/virtio/virtio_mmio.c     | 32 ++++++++++++++++++++++++++++++++
> >  include/uapi/linux/virtio_mmio.h | 11 +++++++++++
> >  2 files changed, 43 insertions(+)
> > 
> > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> > index e09edb5c5e06..5c07985c8cb8 100644
> > --- a/drivers/virtio/virtio_mmio.c
> > +++ b/drivers/virtio/virtio_mmio.c
> > @@ -500,6 +500,37 @@ static const char *vm_bus_name(struct virtio_device *vdev)
> >  	return vm_dev->pdev->name;
> >  }
> >  
> > +static bool vm_get_shm_region(struct virtio_device *vdev,
> > +			      struct virtio_shm_region *region, u8 id)
> > +{
> > +	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
> > +	u64 len, addr;
> > +
> > +	/* Select the region we're interested in */
> > +	writel(id, vm_dev->base + VIRTIO_MMIO_SHM_SEL);
> > +
> > +	/* Read the region size */
> > +	len = (u64) readl(vm_dev->base + VIRTIO_MMIO_SHM_LEN_LOW);
> > +	len |= (u64) readl(vm_dev->base + VIRTIO_MMIO_SHM_LEN_HIGH) << 32;
> > +
> > +	region->len = len;
> > +
> > +	/* Check if region length is -1. If that's the case, the shared memory
> > +	 * region does not exist and there is no need to proceed further.
> > +	 */
> > +	if (len == ~(u64)0) {
> > +		return false;
> > +	}
> 
> I think the curly braces should be dropped here.

Will do.

Thanks
Vivek
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
