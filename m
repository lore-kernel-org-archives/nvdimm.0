Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2AD3F8DF2
	for <nvdimm@lists.linux.dev>; Fri, 27 Mar 2026 14:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774623168; cv=none; b=V6ilI/Z0S4FbhRA+dWtiaTj6pfjNqz6hMvCFgPrNgqOB9KTDFC7aQw7QhfzKKpjcJ4wFs97up7jNyQxKzGVLzmU78GiSXbAtVaAwiHOZoBWQlpf8ewY/p8EkkdvEVQJVQJvMBzt5yW4w/boozADRFMOD0Nzbq+ZiaPue2+RnPEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774623168; c=relaxed/simple;
	bh=b+o8RyCMAs22IAZgIJO84wgLfvydOGliYGSLwf391wM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OjqEU4nvFW6nfDBSdT27hogrJcAUHJ8toHiGORNA7FGhLeIZWWigPMr6DC1mNGINT0Ts89FtHTRyN98fCng+5nnLMAcDhmThRvVjx2gKaqDiw6q56CODOIIzaW1c9gbFoVpQs9BWwWt8CvQ09FUl4jtN/vyGu0gJ2lXY6/IxbA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A802E8DAF6;
	Fri, 27 Mar 2026 14:52:37 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf14.hostedemail.com (Postfix) with ESMTPA id 4F3E833;
	Fri, 27 Mar 2026 14:52:25 +0000 (UTC)
Date: Fri, 27 Mar 2026 09:52:22 -0500
From: John Groves <John@groves.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V9 01/10] famfs_fuse: Update macro
 s/FUSE_IS_DAX/FUSE_IS_VIRTIO_DAX/
Message-ID: <acaZRqeGO7P3iozd@groves.net>
References: <0100019d1d48b7e8-4468329f-b446-43f1-87db-3c7e1ff6f28b-000000@email.amazonses.com>
 <20260324004026.5170-1-john@jagalactic.com>
 <0100019d1d494e7b-2f01e83a-ebaa-4d1b-ae35-33b882a7bda4-000000@email.amazonses.com>
 <20260324151253.00006b86@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324151253.00006b86@huawei.com>
X-Rspamd-Queue-Id: 4F3E833
X-Rspamd-Server: rspamout06
X-Stat-Signature: 6yx58x5nfu7ffewnnsesr1btncocbd1q
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX189GkLpt1nECEgB1RZ5HV34VbGYITYpBXo=
X-HE-Tag: 1774623145-297233
X-HE-Meta: U2FsdGVkX1/iIrjepB/tOVe6pqP1Emyi9FiDGaVW2opQ9xrpLV/NzZ65/TqVjlU42C2XN/5jUr5yZ8aMwlnkv1Ln+XzuWUZgfn/Ae2umamlOUg+/ZYH0eLR2/RvO5JeVBV4BIWYn5ro9IfUFEk9RU46Kd6f9zHv7RWFxtvrwXQctw2gZO+Ee95ltuf8vFMkUBuxnJ2ACp1T2pU415hdCw/scUq9eyjusOTmR4fpAmDeJF0v5dwNl9vHdpV1tF13AuCxE+MiCCpTGBtxsewW/5ejApktdEdB+AFUwd1NcAbtCWZn4ASj6zwk9tdzyxEUJDUfM6U7o8kAjzPaj6BFQ/2tluwHT5f/595bYeN86qOA6xnHje4cKp2SGfUdgKIrIhlCACJDi9R5MUFJ2690GLOA4635KBFDDAxlAzVJyCznPoj47mtXb8wZXMdt/79s0AxE94h5CbxPBw1LuoL/vjXlpxlX4mHPiKZ5Qo2MmSGQQ282MJbar+A4FfSHT2abjLXz/+WIkGxjLnJI73lX5vPhVZb5GY9M/KizoTtfmHkj4hvVP5OlV+X87XKt2KLRZToHQHlQ9ayxxgdVASlFx0Ty7fOmjPsdt

On 26/03/24 03:12PM, Jonathan Cameron wrote:
> On Tue, 24 Mar 2026 00:40:36 +0000
> John Groves <john@jagalactic.com> wrote:
> 
> > From: John Groves <john@groves.net>
> > 
> > Virtio_fs now needs to determine if an inode is DAX && not famfs.
> FWIW patch bundles broke sashiko
> 
> https://sashiko.dev/#/message/0100019d1d46d094-cc0a4b79-3bd2-43e8-a08d-ab8cd21266a6-000000%40email.amazonses.com
> It only reviewed the fuse part.  (I was looking to see what it had found I missed
> in the DAX ones).
> > This relaces the FUSE_IS_DAX() macro with FUSE_IS_VIRTIO_DAX(),
> 
> replaces (Sashiko spell checks ;)

Derp. With v10 I will just post separate series'

> 
> > in preparation for famfs in later commits. The dummy
> > fuse_file_famfs() macro will be replaced with a working
> > function.
> > 
> > Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Signed-off-by: John Groves <john@groves.net>
> 
> 
> 
> > ---
> >  fs/fuse/dir.c    |  2 +-
> >  fs/fuse/file.c   | 13 ++++++++-----
> >  fs/fuse/fuse_i.h |  9 ++++++++-
> >  fs/fuse/inode.c  |  4 ++--
> >  fs/fuse/iomode.c |  2 +-
> >  5 files changed, 20 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> > index 7ac6b232ef12..c63f097bc697 100644
> > --- a/fs/fuse/dir.c
> > +++ b/fs/fuse/dir.c
> > @@ -2161,7 +2161,7 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> >  		is_truncate = true;
> >  	}
> >  
> > -	if (FUSE_IS_DAX(inode) && is_truncate) {
> > +	if (FUSE_IS_VIRTIO_DAX(fi) && is_truncate) {
> >  		filemap_invalidate_lock(mapping);
> >  		fault_blocked = true;
> >  		err = fuse_dax_break_layouts(inode, 0, -1);
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index b1bb7153cb78..4ee5065737d8 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -252,7 +252,7 @@ static int fuse_open(struct inode *inode, struct file *file)
> >  	int err;
> >  	bool is_truncate = (file->f_flags & O_TRUNC) && fc->atomic_o_trunc;
> >  	bool is_wb_truncate = is_truncate && fc->writeback_cache;
> > -	bool dax_truncate = is_truncate && FUSE_IS_DAX(inode);
> > +	bool dax_truncate = is_truncate && FUSE_IS_VIRTIO_DAX(fi);
> >  
> >  	if (fuse_is_bad(inode))
> >  		return -EIO;
> > @@ -1812,11 +1812,12 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
> >  	struct file *file = iocb->ki_filp;
> >  	struct fuse_file *ff = file->private_data;
> >  	struct inode *inode = file_inode(file);
> > +	struct fuse_inode *fi = get_fuse_inode(inode);
> >  
> >  	if (fuse_is_bad(inode))
> >  		return -EIO;
> >  
> > -	if (FUSE_IS_DAX(inode))
> > +	if (FUSE_IS_VIRTIO_DAX(fi))
> >  		return fuse_dax_read_iter(iocb, to);
> >  
> >  	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
> > @@ -1833,11 +1834,12 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >  	struct file *file = iocb->ki_filp;
> >  	struct fuse_file *ff = file->private_data;
> >  	struct inode *inode = file_inode(file);
> > +	struct fuse_inode *fi = get_fuse_inode(inode);
> >  
> >  	if (fuse_is_bad(inode))
> >  		return -EIO;
> >  
> > -	if (FUSE_IS_DAX(inode))
> > +	if (FUSE_IS_VIRTIO_DAX(fi))
> >  		return fuse_dax_write_iter(iocb, from);
> >  
> >  	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
> > @@ -2370,10 +2372,11 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
> >  	struct fuse_file *ff = file->private_data;
> >  	struct fuse_conn *fc = ff->fm->fc;
> >  	struct inode *inode = file_inode(file);
> > +	struct fuse_inode *fi = get_fuse_inode(inode);
> >  	int rc;
> >  
> >  	/* DAX mmap is superior to direct_io mmap */
> > -	if (FUSE_IS_DAX(inode))
> > +	if (FUSE_IS_VIRTIO_DAX(fi))
> >  		return fuse_dax_mmap(file, vma);
> >  
> >  	/*
> > @@ -2934,7 +2937,7 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
> >  		.mode = mode
> >  	};
> >  	int err;
> > -	bool block_faults = FUSE_IS_DAX(inode) &&
> > +	bool block_faults = FUSE_IS_VIRTIO_DAX(fi) &&
> >  		(!(mode & FALLOC_FL_KEEP_SIZE) ||
> >  		 (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)));
> >  
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index 7f16049387d1..45e108dec771 100644
> > --- a/fs/fuse/fuse_i.h
> > +++ b/fs/fuse/fuse_i.h
> > @@ -1508,7 +1508,14 @@ void fuse_free_conn(struct fuse_conn *fc);
> >  
> >  /* dax.c */
> >  
> > -#define FUSE_IS_DAX(inode) (IS_ENABLED(CONFIG_FUSE_DAX) && IS_DAX(inode))
> > +static inline bool fuse_file_famfs(struct fuse_inode *fuse_inode) /* Will be superseded */
> > +{
> > +	(void)fuse_inode;
> > +	return false;
> > +}
> > +#define FUSE_IS_VIRTIO_DAX(fuse_inode) (IS_ENABLED(CONFIG_FUSE_DAX)	\
> > +					&& IS_DAX(&fuse_inode->inode)  \
> > +					&& !fuse_file_famfs(fuse_inode))
> 
> The AI overlord pointed out you should probably have a few more brackets
> just in case someone passes something odd in as fuse_inode. Lets assume
> they don't pass things with side effects in.
> 
> #define FUSE_IS_VIRTIO_DAX(fuse_inode) (IS_ENABLED(CONFIG_FUSE_DAX)	\
> 					&& IS_DAX(&(fuse_inode)->inode)  \
> 					&& !fuse_file_famfs(fuse_inode))
> 

Thank you for your tokens ;)

Fixed - and now there is a change for the v10 fuse series

John

