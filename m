Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD733B71D9;
	Thu,  6 Aug 2026 20:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786048888; cv=none; b=hRonwniX+s5RjAX9kacmKe/qUJpP8KTtyunuek0sLwx2n9ndinyzGZX2SxzrYhZobs4R1da2eI6cIR3CUeMpl1TC2rPhRD6f44POr7HM83lnj4dk4+uizAmccqQZwiKt4XH1m4VdmKGOZTv6Rf2BJ7bBZwq6+T+Mb5RqUi4gVCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786048888; c=relaxed/simple;
	bh=xR6HG6PiaFqYPWaSc0BbpGc+xguUSO7QguoVLPIuIIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cweuuNr+VPyffrwIlMSa1lo7mowd/Q4cq1AyEAOc0flOxZjl6QG7V4EtgZuS3eLTmBP5mTZXBzxhdZKXEgJXJRd/FypjfEP7Dn5b6ZjCDT3qPQdZgOk1pf/Fv7/FzoKropgHWu3MgUVrIdnBW6SFb0ctCzxxKjO4whWc+Rk24z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 811A9C0208;
	Thu,  6 Aug 2026 20:41:14 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf14.hostedemail.com (Postfix) with ESMTPA id 0254130;
	Thu,  6 Aug 2026 20:40:57 +0000 (UTC)
Date: Thu, 6 Aug 2026 15:40:56 -0500
From: John Groves <John@groves.net>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <jic23@kernel.org>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Ira Weiny <iweiny@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Haren Myneni <haren@linux.ibm.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Ethan Nelson-Moore <enelsonmoore@gmail.com>, Gabriel Whigham <gabewhigham@gmail.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH V12 06/12] famfs: Introduce mmap and VM fault handling
Message-ID: <anTwmJN1uDMt1_rS@groves.net>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022909.75856-1-john@jagalactic.com>
 <0100019fc5743aef-39284cf3-b235-4a69-832f-c51b2198e8da-000000@email.amazonses.com>
 <20260806051643.GF3560084@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806051643.GF3560084@frogsfrogsfrogs>
X-Rspamd-Queue-Id: 0254130
X-Stat-Signature: rgkrbshmb4e5xmnxcodmnkbtuy4zi1hh
X-Rspamd-Server: rspamout03
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1+E2Va6GuIuXSLukgenZUgCPOnJ1XdWtXg=
X-HE-Tag: 1786048857-712595
X-HE-Meta: U2FsdGVkX18tDPFgu0OyBXUVVFumMXeX6MI7yVjs5QcOa2qMbkCR4fyrWsOwrcAliP+/0VRtGY04vN7FfLDx9/+XWXXKl5CdWNwz3bxG5ZuP4FvGiy6zEOi5mxjRzx2Xj1FqlZbmKPsGML3hXhEEO/8b9pOIgxqy0pkbFbt9X3FXkjkHbSijiOq/00NE0yIsvJjky3qzKUB/tPcFW1L+7hNKSHFMKYvmK7EAjLoGD2UPQL7URStfeGlAScywurhpMu8zX5bn/ID3BeYLJzpv3sTzKPfML8DtspQw7HM7QrLAOCn6tlbwgGR9bfgtqQ6/1FysFaoFbkADyJqIRAd0nl8s5GJM1uAMr4DXkTgTXNa43IViI67fUGg1D8QiSYmw

On 26/08/05 10:16PM, Darrick J. Wong wrote:
> On Mon, Aug 03, 2026 at 02:29:16AM +0000, John Groves wrote:
> > From: John Groves <john@groves.net>
> > 
> > This commit adds vm_operations, plus famfs_mmap() and fault handlers.
> > It is still missing iomap_ops, iomap mapping resolution, and
> > famfs_ioctl() for setting up file-to-memory mappings.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/famfs/famfs_file.c | 101 +++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 100 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> > index e192b573c51f..678f2035fd5f 100644
> > --- a/fs/famfs/famfs_file.c
> > +++ b/fs/famfs/famfs_file.c
> > @@ -16,6 +16,75 @@
> >  
> >  #include "famfs_internal.h"
> >  
> > +/*********************************************************************
> > + * vm_operations
> > + */
> > +static vm_fault_t
> > +__famfs_filemap_fault(struct vm_fault *vmf, unsigned int order,
> > +		      bool write_fault)
> > +{
> > +	struct inode *inode = file_inode(vmf->vma->vm_file);
> > +	struct super_block *sb = inode->i_sb;
> > +	struct famfs_fs_info *fsi = sb->s_fs_info;
> > +	vm_fault_t ret;
> > +	unsigned long pfn;
> > +
> > +	if (fsi->deverror)
> > +		return VM_FAULT_SIGBUS;
> > +
> > +	if (!IS_DAX(file_inode(vmf->vma->vm_file))) {
> > +		pr_err("%s: file not marked IS_DAX!!\n", __func__);
> > +		return VM_FAULT_SIGBUS;
> > +	}
> > +
> > +	if (write_fault) {
> > +		sb_start_pagefault(inode->i_sb);
> > +		file_update_time(vmf->vma->vm_file);
> > +	}
> > +
> > +	ret = dax_iomap_fault(vmf, order, &pfn, NULL, NULL /*&famfs_iomap_ops */);
> > +	if (ret & VM_FAULT_NEEDDSYNC)
> > +		ret = dax_finish_sync_fault(vmf, order, pfn);
> > +
> > +	if (write_fault)
> > +		sb_end_pagefault(inode->i_sb);
> > +
> > +	return ret;
> > +}
> > +
> > +static inline bool
> > +famfs_is_write_fault(struct vm_fault *vmf)
> > +{
> > +	return (vmf->flags & FAULT_FLAG_WRITE) &&
> > +	       (vmf->vma->vm_flags & VM_SHARED);
> > +}
> > +
> > +static vm_fault_t
> > +famfs_filemap_fault(struct vm_fault *vmf)
> > +{
> > +	return __famfs_filemap_fault(vmf, 0, famfs_is_write_fault(vmf));
> > +}
> > +
> > +static vm_fault_t
> > +famfs_filemap_huge_fault(struct vm_fault *vmf, unsigned int order)
> > +{
> > +	return __famfs_filemap_fault(vmf, order, famfs_is_write_fault(vmf));
> > +}
> > +
> > +static vm_fault_t
> > +famfs_filemap_mkwrite(struct vm_fault *vmf)
> > +{
> > +	return __famfs_filemap_fault(vmf, 0, true);
> 
> Do neither of the conditions in famfs_is_write_fault apply here?

I'm confident this is correct. This is directly copied from xfs on the 
dax path:

	if (IS_DAX(inode))
		ret = xfs_dax_fault_locked(vmf, order, true);

Famfs never has to do COW or allocate a page or any of that sort of
sfuff; It ends up just looking at the fmap to resolve to a page,
which always exists unless out or range or bugs.

> 
> The rest of the patch looks ok to me.
> 
> --D

Thank you!

John

<snip>

