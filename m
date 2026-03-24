Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51F34035C5
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 15:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774365180; cv=none; b=uCoGXMrFrsZUhBoP8fvZWQdcGyhrbmJzab1G0E2EKa4h0QhXJdURqHxHD2CTvsj4fCbz8pUlS6F/7xjo+BDRVAWVbCHqXIryHS5SdS4SoqhA04X6ZVatcRzPLxdpOwRGgVk7CUZUG21JWfkuzb3phb2q30teY9gBB/cgv9GgTS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774365180; c=relaxed/simple;
	bh=o1VBIWE+N6GLi7LTM8CwipxHM7Ni32sdzn0HUs5T0yU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rlDPfcOqkcNibWFGUGoVEwavpmhzzC0PMGf908OvDYWJ21n8r9KHMKxnxAyyAkmn4hc7FYvHfH9fDiIHZGhx9sueRTL48PK2flQGKBvFVmJ1ehRK+hwa/YMOeOCO0VoX2E2TuHm+ljrsr0/1VMHEAB0IlTT3evVAKjfp48wvxQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fgD6Z2x7qzHnGjS;
	Tue, 24 Mar 2026 23:12:22 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id EE6FA40569;
	Tue, 24 Mar 2026 23:12:55 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 24 Mar
 2026 15:12:54 +0000
Date: Tue, 24 Mar 2026 15:12:53 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: John Groves <john@jagalactic.com>
CC: John Groves <John@Groves.net>, Miklos Szeredi <miklos@szeredi.hu>, "Dan
 Williams" <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>, John Groves
	<jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, "David
 Hildenbrand" <david@kernel.org>, Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, Stefan
 Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, Josef
 Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, Chen
 Linxuan <chenlinxuan@uniontech.com>, "James Morse" <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>, "Sean Christopherson" <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>, Ajay
 Joshi <ajayjoshi@micron.com>, "venkataravis@micron.com"
	<venkataravis@micron.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V9 01/10] famfs_fuse: Update macro
 s/FUSE_IS_DAX/FUSE_IS_VIRTIO_DAX/
Message-ID: <20260324151253.00006b86@huawei.com>
In-Reply-To: <0100019d1d494e7b-2f01e83a-ebaa-4d1b-ae35-33b882a7bda4-000000@email.amazonses.com>
References: <0100019d1d48b7e8-4468329f-b446-43f1-87db-3c7e1ff6f28b-000000@email.amazonses.com>
	<20260324004026.5170-1-john@jagalactic.com>
	<0100019d1d494e7b-2f01e83a-ebaa-4d1b-ae35-33b882a7bda4-000000@email.amazonses.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Tue, 24 Mar 2026 00:40:36 +0000
John Groves <john@jagalactic.com> wrote:

> From: John Groves <john@groves.net>
> 
> Virtio_fs now needs to determine if an inode is DAX && not famfs.
FWIW patch bundles broke sashiko

https://sashiko.dev/#/message/0100019d1d46d094-cc0a4b79-3bd2-43e8-a08d-ab8cd21266a6-000000%40email.amazonses.com
It only reviewed the fuse part.  (I was looking to see what it had found I missed
in the DAX ones).
> This relaces the FUSE_IS_DAX() macro with FUSE_IS_VIRTIO_DAX(),

replaces (Sashiko spell checks ;)

> in preparation for famfs in later commits. The dummy
> fuse_file_famfs() macro will be replaced with a working
> function.
> 
> Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: John Groves <john@groves.net>



> ---
>  fs/fuse/dir.c    |  2 +-
>  fs/fuse/file.c   | 13 ++++++++-----
>  fs/fuse/fuse_i.h |  9 ++++++++-
>  fs/fuse/inode.c  |  4 ++--
>  fs/fuse/iomode.c |  2 +-
>  5 files changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 7ac6b232ef12..c63f097bc697 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -2161,7 +2161,7 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  		is_truncate = true;
>  	}
>  
> -	if (FUSE_IS_DAX(inode) && is_truncate) {
> +	if (FUSE_IS_VIRTIO_DAX(fi) && is_truncate) {
>  		filemap_invalidate_lock(mapping);
>  		fault_blocked = true;
>  		err = fuse_dax_break_layouts(inode, 0, -1);
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index b1bb7153cb78..4ee5065737d8 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -252,7 +252,7 @@ static int fuse_open(struct inode *inode, struct file *file)
>  	int err;
>  	bool is_truncate = (file->f_flags & O_TRUNC) && fc->atomic_o_trunc;
>  	bool is_wb_truncate = is_truncate && fc->writeback_cache;
> -	bool dax_truncate = is_truncate && FUSE_IS_DAX(inode);
> +	bool dax_truncate = is_truncate && FUSE_IS_VIRTIO_DAX(fi);
>  
>  	if (fuse_is_bad(inode))
>  		return -EIO;
> @@ -1812,11 +1812,12 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  	struct file *file = iocb->ki_filp;
>  	struct fuse_file *ff = file->private_data;
>  	struct inode *inode = file_inode(file);
> +	struct fuse_inode *fi = get_fuse_inode(inode);
>  
>  	if (fuse_is_bad(inode))
>  		return -EIO;
>  
> -	if (FUSE_IS_DAX(inode))
> +	if (FUSE_IS_VIRTIO_DAX(fi))
>  		return fuse_dax_read_iter(iocb, to);
>  
>  	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
> @@ -1833,11 +1834,12 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	struct file *file = iocb->ki_filp;
>  	struct fuse_file *ff = file->private_data;
>  	struct inode *inode = file_inode(file);
> +	struct fuse_inode *fi = get_fuse_inode(inode);
>  
>  	if (fuse_is_bad(inode))
>  		return -EIO;
>  
> -	if (FUSE_IS_DAX(inode))
> +	if (FUSE_IS_VIRTIO_DAX(fi))
>  		return fuse_dax_write_iter(iocb, from);
>  
>  	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
> @@ -2370,10 +2372,11 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
>  	struct fuse_file *ff = file->private_data;
>  	struct fuse_conn *fc = ff->fm->fc;
>  	struct inode *inode = file_inode(file);
> +	struct fuse_inode *fi = get_fuse_inode(inode);
>  	int rc;
>  
>  	/* DAX mmap is superior to direct_io mmap */
> -	if (FUSE_IS_DAX(inode))
> +	if (FUSE_IS_VIRTIO_DAX(fi))
>  		return fuse_dax_mmap(file, vma);
>  
>  	/*
> @@ -2934,7 +2937,7 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
>  		.mode = mode
>  	};
>  	int err;
> -	bool block_faults = FUSE_IS_DAX(inode) &&
> +	bool block_faults = FUSE_IS_VIRTIO_DAX(fi) &&
>  		(!(mode & FALLOC_FL_KEEP_SIZE) ||
>  		 (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)));
>  
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 7f16049387d1..45e108dec771 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -1508,7 +1508,14 @@ void fuse_free_conn(struct fuse_conn *fc);
>  
>  /* dax.c */
>  
> -#define FUSE_IS_DAX(inode) (IS_ENABLED(CONFIG_FUSE_DAX) && IS_DAX(inode))
> +static inline bool fuse_file_famfs(struct fuse_inode *fuse_inode) /* Will be superseded */
> +{
> +	(void)fuse_inode;
> +	return false;
> +}
> +#define FUSE_IS_VIRTIO_DAX(fuse_inode) (IS_ENABLED(CONFIG_FUSE_DAX)	\
> +					&& IS_DAX(&fuse_inode->inode)  \
> +					&& !fuse_file_famfs(fuse_inode))

The AI overlord pointed out you should probably have a few more brackets
just in case someone passes something odd in as fuse_inode. Lets assume
they don't pass things with side effects in.

#define FUSE_IS_VIRTIO_DAX(fuse_inode) (IS_ENABLED(CONFIG_FUSE_DAX)	\
					&& IS_DAX(&(fuse_inode)->inode)  \
					&& !fuse_file_famfs(fuse_inode))


>  
>  ssize_t fuse_dax_read_iter(struct kiocb *iocb, struct iov_iter *to);
>  ssize_t fuse_dax_write_iter(struct kiocb *iocb, struct iov_iter *from);
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index e57b8af06be9..1333b3ebb18a 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -162,7 +162,7 @@ static void fuse_evict_inode(struct inode *inode)
>  	/* Will write inode on close/munmap and in all other dirtiers */
>  	WARN_ON(inode_state_read_once(inode) & I_DIRTY_INODE);
>  
> -	if (FUSE_IS_DAX(inode))
> +	if (FUSE_IS_VIRTIO_DAX(fi))
>  		dax_break_layout_final(inode);
>  
>  	truncate_inode_pages_final(&inode->i_data);
> @@ -170,7 +170,7 @@ static void fuse_evict_inode(struct inode *inode)
>  	if (inode->i_sb->s_flags & SB_ACTIVE) {
>  		struct fuse_conn *fc = get_fuse_conn(inode);
>  
> -		if (FUSE_IS_DAX(inode))
> +		if (FUSE_IS_VIRTIO_DAX(fi))
>  			fuse_dax_inode_cleanup(inode);
>  		if (fi->nlookup) {
>  			fuse_queue_forget(fc, fi->forget, fi->nodeid,
> diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
> index 3728933188f3..31ee7f3304c6 100644
> --- a/fs/fuse/iomode.c
> +++ b/fs/fuse/iomode.c
> @@ -203,7 +203,7 @@ int fuse_file_io_open(struct file *file, struct inode *inode)
>  	 * io modes are not relevant with DAX and with server that does not
>  	 * implement open.
>  	 */
> -	if (FUSE_IS_DAX(inode) || !ff->args)
> +	if (FUSE_IS_VIRTIO_DAX(fi) || !ff->args)
>  		return 0;
>  
>  	/*

