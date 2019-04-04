Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 64E3B211EDB2A
 for <linux-nvdimm@lists.01.org>; Thu,  4 Apr 2019 08:50:05 -0700 (PDT)
Date: Thu, 4 Apr 2019 11:50:02 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <846216210.17971239.1554393002566.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190404150025.GN5147@magnolia>
References: <20190403104018.23947-1-pagupta@redhat.com>
 <20190403220912.GB26298@dastard> <20190403223921.GM5147@magnolia>
 <1508883801.17367965.1554358418550.JavaMail.zimbra@redhat.com>
 <651986267.17402634.1554368950178.JavaMail.zimbra@redhat.com>
 <20190404094029.GD16131@quack2.suse.cz>
 <527416483.17415178.1554372524196.JavaMail.zimbra@redhat.com>
 <20190404150025.GN5147@magnolia>
Subject: Re: [Qemu-devel] [PATCH v4 5/5] xfs: disable map_sync for async flush
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jan Kara <jack@suse.cz>, kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, Dave Chinner <david@fromorbit.com>, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, linux-nvdimm@lists.01.org, david@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, lenb@kernel.org, riel@surriel.com, stefanha@redhat.com, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, cohuck@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, imammedo@redhat.com
List-ID: <linux-nvdimm@lists.01.org>


> > > 
> > > So I would put the helper in include/linux/dax.h and have it like:
> > > 
> > > bool daxdev_mapping_supported(struct vm_area_struct *vma,
> 
> Should this be static inline if you're putting it in the header file?

yes. Thanks.

> 
> A comment ought to be added to describe what this predicate function
> does.

Sure, will add a comment describing the function.

> 
> > > 			      struct dax_device *dax_dev)
> > > {
> > > 	if (!(vma->vm_flags & VM_SYNC))
> > > 		return true;
> > > 	if (!IS_DAX(file_inode(vma->vm_file)))
> > > 		return false;
> > > 	return dax_synchronous(dax_dev);
> > > }
> > 
> > Sure. This is much better. I was also not sure what to name the helper
> > function.
> > I will go ahead with this unless 'Dave' & 'Darrick' have anything to add.
> 
> Jan's approach (modulo that one comment) looks good to me.

Sure. Thank you.

Best regards,
Pankaj

> 
> --D
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
