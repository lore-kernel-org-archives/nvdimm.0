Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 77E35211FB8AA
 for <linux-nvdimm@lists.01.org>; Wed, 10 Apr 2019 01:31:21 -0700 (PDT)
Date: Wed, 10 Apr 2019 04:31:19 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <299038321.20701113.1554885079188.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190410082504.GF1426@quack2.suse.cz>
References: <20190410040826.24371-1-pagupta@redhat.com>
 <20190410040826.24371-5-pagupta@redhat.com>
 <20190410082504.GF1426@quack2.suse.cz>
Subject: Re: [PATCH v5 4/6] dax: check synchronous mapping is supported
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
To: Jan Kara <jack@suse.cz>
Cc: cohuck@redhat.com, kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, david@fromorbit.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, linux-nvdimm@lists.01.org, david@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, lenb@kernel.org, kilobyte@angband.pl, riel@surriel.com, yuval shaia <yuval.shaia@oracle.com>, stefanha@redhat.com, pbonzini@redhat.com, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, darrick wong <darrick.wong@oracle.com>, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, imammedo@redhat.com
List-ID: <linux-nvdimm@lists.01.org>


> > This patch introduces 'daxdev_mapping_supported' helper
> > which checks if 'MAP_SYNC' is supported with filesystem
> > mapping. It also checks if corresponding dax_device is
> > synchronous. Virtio pmem device is asynchronous and
> > does not not support VM_SYNC.
> > 
> > Suggested-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > ---
> >  include/linux/dax.h | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> > 
> > diff --git a/include/linux/dax.h b/include/linux/dax.h
> > index b896706a5ee9..4a2a60ffec86 100644
> > --- a/include/linux/dax.h
> > +++ b/include/linux/dax.h
> > @@ -38,6 +38,24 @@ void kill_dax(struct dax_device *dax_dev);
> >  void dax_write_cache(struct dax_device *dax_dev, bool wc);
> >  bool dax_write_cache_enabled(struct dax_device *dax_dev);
> >  bool dax_synchronous(struct dax_device *dax_dev);
> > +
> > +/*
> > + * Callers check if synchronous mapping is enabled for DAX file
> > + * and attached dax device is also synchronous.
> > + *
> > + * dax_synchronous function verifies if dax device is synchronous.
> > + * Currently, only virtio pmem device supports asynchronous device
> > + * flush.
> > + */
> 
> Thanks for the patch! I'd restructure this comment like:
> 
> /*
>  * Check if given mapping is supported by the file / underlying device.
>  */

Sure.

> > +static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
> > +				struct dax_device *dax_dev)
> > +{
> 
> 	/* Everyone supports non-sync mappings */
> > +	if (!(vma->vm_flags & VM_SYNC))
> > +		return true;
> 	/* Sync mappings are supported only for files using DAX */
> > +	if (!IS_DAX(file_inode(vma->vm_file)))
> > +		return false;
> 	/* Underlying device must support persisting through CPU instructions */
> > +	return dax_synchronous(dax_dev);
> > +}
> >  #else
> >  static inline struct dax_device *dax_get_by_host(const char *host)
> >  {
> > @@ -69,6 +87,11 @@ static inline bool dax_synchronous(struct dax_device
> > *dax_dev)
> >  {
> >  	return true;
> >  }
> > +static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
> > +				struct dax_device *dax_dev)
> > +{
> > +	return true;
> 
> This looks wrong. Shouldn't it rather be:
> 
> 	return !(vma->flags & VM_SYNC);
> 
> ?

Right. I will correct this.

Thanks,
Pankaj

> 
> 								Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
