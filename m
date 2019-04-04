Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 93865211F35F1
 for <linux-nvdimm@lists.01.org>; Thu,  4 Apr 2019 02:09:12 -0700 (PDT)
Date: Thu, 4 Apr 2019 05:09:10 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <651986267.17402634.1554368950178.JavaMail.zimbra@redhat.com>
In-Reply-To: <1508883801.17367965.1554358418550.JavaMail.zimbra@redhat.com>
References: <20190403104018.23947-1-pagupta@redhat.com>
 <20190403104018.23947-6-pagupta@redhat.com> <20190403220912.GB26298@dastard>
 <20190403223921.GM5147@magnolia>
 <1508883801.17367965.1554358418550.JavaMail.zimbra@redhat.com>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: jack@suse.cz, kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, linux-nvdimm@lists.01.org, david@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, lenb@kernel.org, riel@surriel.com, stefanha@redhat.com, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, cohuck@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, imammedo@redhat.com
List-ID: <linux-nvdimm@lists.01.org>


> > On Thu, Apr 04, 2019 at 09:09:12AM +1100, Dave Chinner wrote:
> > > On Wed, Apr 03, 2019 at 04:10:18PM +0530, Pankaj Gupta wrote:
> > > > Virtio pmem provides asynchronous host page cache flush
> > > > mechanism. we don't support 'MAP_SYNC' with virtio pmem
> > > > and xfs.
> > > > 
> > > > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_file.c | 8 ++++++++
> > > >  1 file changed, 8 insertions(+)
> > > > 
> > > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > > index 1f2e2845eb76..dced2eb8c91a 100644
> > > > --- a/fs/xfs/xfs_file.c
> > > > +++ b/fs/xfs/xfs_file.c
> > > > @@ -1203,6 +1203,14 @@ xfs_file_mmap(
> > > >  	if (!IS_DAX(file_inode(filp)) && (vma->vm_flags & VM_SYNC))
> > > >  		return -EOPNOTSUPP;
> > > >  
> > > > +	/* We don't support synchronous mappings with DAX files if
> > > > +	 * dax_device is not synchronous.
> > > > +	 */
> > > > +	if (IS_DAX(file_inode(filp)) && !dax_synchronous(
> > > > +		xfs_find_daxdev_for_inode(file_inode(filp))) &&
> > > > +					(vma->vm_flags & VM_SYNC))
> > > > +		return -EOPNOTSUPP;
> > > > +
> > > >  	file_accessed(filp);
> > > >  	vma->vm_ops = &xfs_file_vm_ops;
> > > >  	if (IS_DAX(file_inode(filp)))
> > > 
> > > All this ad hoc IS_DAX conditional logic is getting pretty nasty.
> > > 
> > > xfs_file_mmap(
> > > ....
> > > {
> > > 	struct inode	*inode = file_inode(filp);
> > > 
> > > 	if (vma->vm_flags & VM_SYNC) {
> > > 		if (!IS_DAX(inode))
> > > 			return -EOPNOTSUPP;
> > > 		if (!dax_synchronous(xfs_find_daxdev_for_inode(inode))
> > > 			return -EOPNOTSUPP;
> > > 	}
> > > 
> > > 	file_accessed(filp);
> > > 	vma->vm_ops = &xfs_file_vm_ops;
> > > 	if (IS_DAX(inode))
> > > 		vma->vm_flags |= VM_HUGEPAGE;
> > > 	return 0;
> > > }
> > > 
> > > 
> > > Even better, factor out all the "MAP_SYNC supported" checks into a
> > > helper so that the filesystem code just doesn't have to care about
> > > the details of checking for DAX+MAP_SYNC support....
> > 
> > Seconded, since ext4 has nearly the same flag validation logic.
> 

Only issue with this I see is we need the helper function only for supported
filesystems ext4 & xfs (right now). If I create the function in "fs.h" it 
will be compiled for every filesystem, even for those don't need it.  

Sample patch below, does below patch is near to what you have in mind?

=================

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 1f2e2845eb76..614995170cac 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1196,12 +1196,17 @@ xfs_file_mmap(
        struct file     *filp,
        struct vm_area_struct *vma)
 {
+       struct dax_device *dax_dev = xfs_find_daxdev_for_inode(file_inode(filp));
+
        /*
-        * We don't support synchronous mappings for non-DAX files. At least
-        * until someone comes with a sensible use case.
+        * We don't support synchronous mappings for non-DAX files and
+        * for DAX files if underneath dax_device is not synchronous.
         */
-       if (!IS_DAX(file_inode(filp)) && (vma->vm_flags & VM_SYNC))
-               return -EOPNOTSUPP;
+       if (vma->vm_flags & VM_SYNC) {
+               int err = is_synchronous(filp, dax_dev);
+               if (err)
+                       return err;
+       }
 
        file_accessed(filp);
        vma->vm_ops = &xfs_file_vm_ops;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8b42df09b04c..add017de3dd7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2162,6 +2162,20 @@ static inline void file_accessed(struct file *file)
                touch_atime(&file->f_path);
 }
 
+struct dax_device;
+extern bool dax_synchronous(struct dax_device *dax_dev);
+static inline int is_synchronous(struct file *filp, struct dax_device *dax_dev)
+{
+       struct inode *inode = file_inode(filp);
+
+       if (!IS_DAX(inode))
+               return -EOPNOTSUPP;
+       if (!dax_synchronous(dax_dev))
+               return -EOPNOTSUPP;
+
+       return 0;
+}
+
 int sync_inode(struct inode *inode, struct writeback_control *wbc);
 int sync_inode_metadata(struct inode *inode, int wait);
 
---------

Thanks,
Pankaj



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
