Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DEB2C211F931B
 for <linux-nvdimm@lists.01.org>; Wed,  3 Apr 2019 23:12:33 -0700 (PDT)
Date: Thu, 4 Apr 2019 02:12:30 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1518295599.17367903.1554358350929.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190403220912.GB26298@dastard>
References: <20190403104018.23947-1-pagupta@redhat.com>
 <20190403104018.23947-6-pagupta@redhat.com> <20190403220912.GB26298@dastard>
Subject: Re: [PATCH v4 5/5] xfs: disable map_sync for async flush
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
To: Dave Chinner <david@fromorbit.com>, darrick wong <darrick.wong@oracle.com>
Cc: cohuck@redhat.com, jack@suse.cz, kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, linux-nvdimm@lists.01.org, david@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, lenb@kernel.org, riel@surriel.com, stefanha@redhat.com, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, imammedo@redhat.com
List-ID: <linux-nvdimm@lists.01.org>


Hi Dave,

> > Virtio pmem provides asynchronous host page cache flush
> > mechanism. we don't support 'MAP_SYNC' with virtio pmem
> > and xfs.
> > 
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > ---
> >  fs/xfs/xfs_file.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 1f2e2845eb76..dced2eb8c91a 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1203,6 +1203,14 @@ xfs_file_mmap(
> >  	if (!IS_DAX(file_inode(filp)) && (vma->vm_flags & VM_SYNC))
> >  		return -EOPNOTSUPP;
> >  
> > +	/* We don't support synchronous mappings with DAX files if
> > +	 * dax_device is not synchronous.
> > +	 */
> > +	if (IS_DAX(file_inode(filp)) && !dax_synchronous(
> > +		xfs_find_daxdev_for_inode(file_inode(filp))) &&
> > +					(vma->vm_flags & VM_SYNC))
> > +		return -EOPNOTSUPP;
> > +
> >  	file_accessed(filp);
> >  	vma->vm_ops = &xfs_file_vm_ops;
> >  	if (IS_DAX(file_inode(filp)))
> 
> All this ad hoc IS_DAX conditional logic is getting pretty nasty.
> 
> xfs_file_mmap(
> ....
> {
> 	struct inode	*inode = file_inode(filp);
> 
> 	if (vma->vm_flags & VM_SYNC) {
> 		if (!IS_DAX(inode))
> 			return -EOPNOTSUPP;
> 		if (!dax_synchronous(xfs_find_daxdev_for_inode(inode))
> 			return -EOPNOTSUPP;
> 	}
> 
> 	file_accessed(filp);
> 	vma->vm_ops = &xfs_file_vm_ops;
> 	if (IS_DAX(inode))
> 		vma->vm_flags |= VM_HUGEPAGE;
> 	return 0;
> }

Sure, this is better.

> 
> 
> Even better, factor out all the "MAP_SYNC supported" checks into a
> helper so that the filesystem code just doesn't have to care about
> the details of checking for DAX+MAP_SYNC support....

o.k. Will add one common helper function for both ext4 & xfs filesystems.

Thanks for the suggestion.

Best regards,
Pankaj

> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
