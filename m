Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4FCDD20215F75
 for <linux-nvdimm@lists.01.org>; Tue, 27 Aug 2019 01:48:32 -0700 (PDT)
Date: Tue, 27 Aug 2019 10:46:09 +0200
From: Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH 04/19] virtio: Implement get_shm_region for PCI transport
Message-ID: <20190827104609.234a536b.cohuck@redhat.com>
In-Reply-To: <20190827103457.35927d9d.cohuck@redhat.com>
References: <20190821175720.25901-1-vgoyal@redhat.com>
 <20190821175720.25901-5-vgoyal@redhat.com>
 <20190827103457.35927d9d.cohuck@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kbuild test robot <lkp@intel.com>, kvm@vger.kernel.org, miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, dgilbert@redhat.com, virtio-fs@redhat.com, Sebastien Boeuf <sebastien.boeuf@intel.com>, stefanha@redhat.com, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 27 Aug 2019 10:34:57 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Wed, 21 Aug 2019 13:57:05 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:

> > +static bool vp_get_shm_region(struct virtio_device *vdev,
> > +			      struct virtio_shm_region *region, u8 id)
> > +{
> > +	struct virtio_pci_device *vp_dev = to_vp_device(vdev);  
> 
> This whole function looks like it is indented incorrectly.

Hmpf, it looks like my mail client is squashing tabs, so the
indentation looks off here, but is probably fine :) It's the function
above that seems to have a mix of spaces and tabs.

> 
> > +	struct pci_dev *pci_dev = vp_dev->pci_dev;
> > +	u8 bar;
> > +	u64 offset, len;
> > +	phys_addr_t phys_addr;
> > +	size_t bar_len;
> > +	char *bar_name;
> > +	int ret;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
