Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EF5C321214944
 for <linux-nvdimm@lists.01.org>; Tue, 23 Apr 2019 22:21:45 -0700 (PDT)
Date: Wed, 24 Apr 2019 01:21:44 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1325148804.23168491.1556083304080.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190423142748.GE9910@quack2.suse.cz>
References: <20190423080612.15361-1-pagupta@redhat.com>
 <20190423080612.15361-6-pagupta@redhat.com>
 <20190423142748.GE9910@quack2.suse.cz>
Subject: Re: [Qemu-devel] [PATCH v6 5/6] ext4: disable map_sync for async flush
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
Cc: kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, david@fromorbit.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, linux-nvdimm@lists.01.org, david@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, lenb@kernel.org, kilobyte@angband.pl, riel@surriel.com, yuval shaia <yuval.shaia@oracle.com>, stefanha@redhat.com, imammedo@redhat.com, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, cohuck@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, pbonzini@redhat.com, darrick wong <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>


> 
> On Tue 23-04-19 13:36:11, Pankaj Gupta wrote:
> > Dont support 'MAP_SYNC' with non-DAX files and DAX files
> > with asynchronous dax_device. Virtio pmem provides
> > asynchronous host page cache flush mechanism. We don't
> > support 'MAP_SYNC' with virtio pmem and ext4.
> > 
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> 
> The patch looks good to me. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thank you. Will add this.

Best regards,
Pankaj

> 
> 								Honza
> 
> 
> > ---
> >  fs/ext4/file.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index 69d65d49837b..4b2ccaf1932e 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -360,15 +360,16 @@ static const struct vm_operations_struct
> > ext4_file_vm_ops = {
> >  static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
> >  {
> >  	struct inode *inode = file->f_mapping->host;
> > +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> > +	struct dax_device *dax_dev = sbi->s_daxdev;
> >  
> > -	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
> > +	if (unlikely(ext4_forced_shutdown(sbi)))
> >  		return -EIO;
> >  
> > -	/*
> > -	 * We don't support synchronous mappings for non-DAX files. At least
> > -	 * until someone comes with a sensible use case.
> > +	/* We don't support synchronous mappings for non-DAX files and
> > +	 * for DAX files if underneath dax_device is not synchronous.
> >  	 */
> > -	if (!IS_DAX(file_inode(file)) && (vma->vm_flags & VM_SYNC))
> > +	if (!daxdev_mapping_supported(vma, dax_dev))
> >  		return -EOPNOTSUPP;
> >  
> >  	file_accessed(file);
> > --
> > 2.20.1
> > 
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> 
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
