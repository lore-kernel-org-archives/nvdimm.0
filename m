Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B813B6BB5B;
	Thu,  6 Aug 2026 05:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785993404; cv=none; b=Zwcbj0sMr7YSJDv2V7MR5sGeshRTlCIJhHKqeYf6NyfJPxV4VN3sYzJCntcpcpbEFi3GxvP1IfBlbCpCr8Py+2fDyL4cEIz60HjlYtTfCGkOJYfrb01DCypE53jk7lfUDfsmSaoxZM7kuzyaydkZNM1vsTKCuAAPQmmPaVxaP64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785993404; c=relaxed/simple;
	bh=IMKkY6+RPGqKk1JKxRmAcuGz2uGb4lxGRMAog/cDfao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fi/nPFPoe1vIHRvkWYt+Gw3Lm9z3PeNEG6YTCItgSvkMdmTXevCnLyb11Rj/Rh0hCkyaX4XlsAT/mvP/vtYBObktGllq39Byl61D5XItTlXE1XIYeOOGjYPO/d/i9QUwOWTPM0T2xux40kCZqjqk2/S27AjeHV+BxggfoJm3TgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cTTElbcV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cTTElbcV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7911B1F000E9;
	Thu,  6 Aug 2026 05:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785993403;
	bh=y5x24NbwI2sYAVbQq47HgzpJhwny4gPz3P5FqYFl3JQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cTTElbcVBdx9z/4btUDKcwyAVxf5nA4+bXVtGud6IFgXEaAcoFFJhb5oW2hWQkG4X
	 hXrhTwdueYpLQxG++QPefBMhaewjNn/RB2+6Ont/Tb0I6DBpSQXusW/pdkIt1w5GIW
	 UWw/IcfzUCw/6+tWmUkqKY6GysaoWkA4KQlthXzxi9BFqNbmNv9sxb6ys+Dd9bicak
	 yWmLuxvOKXfPajL73YEcaUZtzJSjlSxvMvRvKt1F5kjEHgfVTZody+Uf9d05Oq7rHE
	 7xULcpn17I0A/DlzE63GrCfuXZAKfwUp1c6KoU+P0JtNVAhJs5YPEMJ629/KvEpLHP
	 EG4b/KyAaHgkQ==
Date: Wed, 5 Aug 2026 22:16:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Groves <john@jagalactic.com>
Cc: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ira Weiny <iweiny@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Haren Myneni <haren@linux.ibm.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Gabriel Whigham <gabewhigham@gmail.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH V12 06/12] famfs: Introduce mmap and VM fault handling
Message-ID: <20260806051643.GF3560084@frogsfrogsfrogs>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022909.75856-1-john@jagalactic.com>
 <0100019fc5743aef-39284cf3-b235-4a69-832f-c51b2198e8da-000000@email.amazonses.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019fc5743aef-39284cf3-b235-4a69-832f-c51b2198e8da-000000@email.amazonses.com>

On Mon, Aug 03, 2026 at 02:29:16AM +0000, John Groves wrote:
> From: John Groves <john@groves.net>
> 
> This commit adds vm_operations, plus famfs_mmap() and fault handlers.
> It is still missing iomap_ops, iomap mapping resolution, and
> famfs_ioctl() for setting up file-to-memory mappings.
> 
> Signed-off-by: John Groves <john@groves.net>
> ---
>  fs/famfs/famfs_file.c | 101 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 100 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> index e192b573c51f..678f2035fd5f 100644
> --- a/fs/famfs/famfs_file.c
> +++ b/fs/famfs/famfs_file.c
> @@ -16,6 +16,75 @@
>  
>  #include "famfs_internal.h"
>  
> +/*********************************************************************
> + * vm_operations
> + */
> +static vm_fault_t
> +__famfs_filemap_fault(struct vm_fault *vmf, unsigned int order,
> +		      bool write_fault)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct super_block *sb = inode->i_sb;
> +	struct famfs_fs_info *fsi = sb->s_fs_info;
> +	vm_fault_t ret;
> +	unsigned long pfn;
> +
> +	if (fsi->deverror)
> +		return VM_FAULT_SIGBUS;
> +
> +	if (!IS_DAX(file_inode(vmf->vma->vm_file))) {
> +		pr_err("%s: file not marked IS_DAX!!\n", __func__);
> +		return VM_FAULT_SIGBUS;
> +	}
> +
> +	if (write_fault) {
> +		sb_start_pagefault(inode->i_sb);
> +		file_update_time(vmf->vma->vm_file);
> +	}
> +
> +	ret = dax_iomap_fault(vmf, order, &pfn, NULL, NULL /*&famfs_iomap_ops */);
> +	if (ret & VM_FAULT_NEEDDSYNC)
> +		ret = dax_finish_sync_fault(vmf, order, pfn);
> +
> +	if (write_fault)
> +		sb_end_pagefault(inode->i_sb);
> +
> +	return ret;
> +}
> +
> +static inline bool
> +famfs_is_write_fault(struct vm_fault *vmf)
> +{
> +	return (vmf->flags & FAULT_FLAG_WRITE) &&
> +	       (vmf->vma->vm_flags & VM_SHARED);
> +}
> +
> +static vm_fault_t
> +famfs_filemap_fault(struct vm_fault *vmf)
> +{
> +	return __famfs_filemap_fault(vmf, 0, famfs_is_write_fault(vmf));
> +}
> +
> +static vm_fault_t
> +famfs_filemap_huge_fault(struct vm_fault *vmf, unsigned int order)
> +{
> +	return __famfs_filemap_fault(vmf, order, famfs_is_write_fault(vmf));
> +}
> +
> +static vm_fault_t
> +famfs_filemap_mkwrite(struct vm_fault *vmf)
> +{
> +	return __famfs_filemap_fault(vmf, 0, true);

Do neither of the conditions in famfs_is_write_fault apply here?

The rest of the patch looks ok to me.

--D

> +}
> +
> +const struct vm_operations_struct famfs_file_vm_ops = {
> +	.fault		= famfs_filemap_fault,
> +	.huge_fault	= famfs_filemap_huge_fault,
> +	.map_pages	= filemap_map_pages,
> +	.page_mkwrite	= famfs_filemap_mkwrite,
> +	.pfn_mkwrite	= famfs_filemap_mkwrite,
> +};
> +
>  /*********************************************************************
>   * file_operations
>   */
> @@ -117,6 +186,36 @@ famfs_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	return rc;
>  }
>  
> +static int
> +famfs_file_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct super_block *sb = inode->i_sb;
> +	struct famfs_fs_info *fsi = sb->s_fs_info;
> +	ssize_t rc;
> +
> +	if (fsi->deverror)
> +		return -ENODEV;
> +
> +	/*
> +	 * Gate shared-writable mappings on FAMFS_OPT_WRITE. This is best
> +	 * effort: clearing the bit blocks new writable mappings and write(),
> +	 * but does not revoke mappings that already exist.
> +	 */
> +	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE) &&
> +	    !famfs_opt_enabled(fsi, FAMFS_OPT_WRITE))
> +		return -EPERM;
> +
> +	rc = famfs_file_invalid(inode);
> +	if (rc)
> +		return (int)rc;
> +
> +	file_accessed(file);
> +	vma->vm_ops = &famfs_file_vm_ops;
> +	vm_flags_set(vma, VM_HUGEPAGE);
> +	return 0;
> +}
> +
>  const struct file_operations famfs_file_operations = {
>  	.owner             = THIS_MODULE,
>  
> @@ -124,7 +223,7 @@ const struct file_operations famfs_file_operations = {
>  	.write_iter	   = famfs_dax_write_iter,
>  	.read_iter	   = famfs_dax_read_iter,
>  	.unlocked_ioctl    = NULL /*famfs_file_ioctl*/,
> -	.mmap		   = NULL /* famfs_file_mmap */,
> +	.mmap		   = famfs_file_mmap,
>  
>  	/* Force PMD alignment for mmap */
>  	.get_unmapped_area = thp_get_unmapped_area,
> -- 
> 2.53.0
> 
> 
> 
