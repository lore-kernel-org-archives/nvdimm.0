Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A16388E59;
	Thu,  6 Aug 2026 05:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785993296; cv=none; b=XVaN+VPRMggB7VfUuQi9aalh5ou5oWYJqPCduuPRaR/sMDQbzx+73px8pSIpxm7po4+eK7rhOfVW+mIhFs3dYtdCMAdP6xf3GQj6Lq49nqQYLe5aMqI5BG3fTUWr+A/rrcA6lCr993J54cP1G3DhgSkeFD0yTVYKSI72UnBZ6Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785993296; c=relaxed/simple;
	bh=LcLRm6dmTzCGdPFVd4nsYIRSCOP06w86sK/v/+38uW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQfvEu2pjOJFy2HnpdZDqLsLf7gT5hfprFPksUFiTnxlS5rtrgmTLl5DPn/HGlKLS5T6h76Hf5G2tP9YNTuF4lnWo/DNZgiSQGY7Y9QlSWZqudqJHaMe3ncxlic9WXnzB6+sPkROnovQ+me6SLBC9acGq/VEBTn6GLjZOMAq9L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gA0bkhIJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gA0bkhIJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EA2861F000E9;
	Thu,  6 Aug 2026 05:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785993295;
	bh=N/SLfiEGmWJkDxFQjJqzdkYmfs7S5eIEUWJd4xDkf1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gA0bkhIJCL3jmBJuHi5wTQiXGdtRkfdjzVahFTUrRIdGedNeZVlG7gs0hSIwUHn8H
	 esl+yqdPC2qUThlVEtStztCotFfRbifYDeHMwDWsA919I5tDtnY5GoyzBKOzg4vUvn
	 pEwCDr69H/+96GdwZ5pM+RPuZtur4JhVE82ZzsaKurrm5qaLk4ET4zkJ3jikPRhWoH
	 kT66H4/5ta999X8LiEKlB7YF170LKXp7SMBVrA9dse4i+M0YM69CEk9xN6XfsEFTS+
	 nujQ2E3AYzaT+ft4NXFKDbohmDTXM7Ny0AK5Krs/4f392x+Sgi/NIiWJWa4ihgqEl3
	 vhWgDonpwvmHQ==
Date: Wed, 5 Aug 2026 22:14:54 -0700
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
Subject: Re: [PATCH V12 05/12] famfs: Introduce file_operations read/write
Message-ID: <20260806051454.GE3560084@frogsfrogsfrogs>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022859.75838-1-john@jagalactic.com>
 <0100019fc5741536-d6b2c2f4-794a-43b4-abf4-f38f2d812e19-000000@email.amazonses.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019fc5741536-d6b2c2f4-794a-43b4-abf4-f38f2d812e19-000000@email.amazonses.com>

On Mon, Aug 03, 2026 at 02:29:07AM +0000, John Groves wrote:
> From: John Groves <john@groves.net>
> 
> This commit introduces fs/famfs/famfs_file.c and the famfs
> file_operations for read/write.
> 
> This is not usable yet because:
> 
> * It calls dax_iomap_rw() with NULL iomap_ops (which will be
>   introduced in a subsequent commit).
> * famfs_ioctl() is coming in a later commit, and it is necessary
>   to map a file to a memory allocation.
> 
> Signed-off-by: John Groves <john@groves.net>
> ---
>  fs/famfs/Makefile         |   2 +-
>  fs/famfs/famfs_file.c     | 138 ++++++++++++++++++++++++++++++++++++++
>  fs/famfs/famfs_inode.c    |   2 +-
>  fs/famfs/famfs_internal.h |   2 +
>  4 files changed, 142 insertions(+), 2 deletions(-)
>  create mode 100644 fs/famfs/famfs_file.c
> 
> diff --git a/fs/famfs/Makefile b/fs/famfs/Makefile
> index 62230bcd6793..8cac90c090a4 100644
> --- a/fs/famfs/Makefile
> +++ b/fs/famfs/Makefile
> @@ -2,4 +2,4 @@
>  
>  obj-$(CONFIG_FAMFS) += famfs.o
>  
> -famfs-y := famfs_inode.o
> +famfs-y := famfs_inode.o famfs_file.o
> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> new file mode 100644
> index 000000000000..e192b573c51f
> --- /dev/null
> +++ b/fs/famfs/famfs_file.c
> @@ -0,0 +1,138 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * famfs - dax file system for shared fabric-attached memory
> + *
> + * Copyright 2023-2024 Micron Technology, Inc.
> + *
> + * This file system, originally based on ramfs the dax support from xfs,
> + * is intended to allow multiple host systems to mount a common file system
> + * view of dax files that map to shared memory.
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/mm.h>
> +#include <linux/dax.h>
> +#include <linux/iomap.h>
> +
> +#include "famfs_internal.h"
> +
> +/*********************************************************************
> + * file_operations
> + */
> +
> +/* Reject I/O to files that aren't in a valid state */
> +static ssize_t
> +famfs_file_invalid(struct inode *inode)
> +{
> +	if (!IS_DAX(inode)) {
> +		pr_debug("%s: inode %llx IS_DAX is false\n",
> +			 __func__, (u64)inode);
> +		return -ENXIO;
> +	}
> +	return 0;
> +}
> +
> +static ssize_t
> +famfs_rw_prep(struct kiocb *iocb, struct iov_iter *ubuf)
> +{
> +	struct inode *inode = iocb->ki_filp->f_mapping->host;
> +	struct super_block *sb = inode->i_sb;
> +	struct famfs_fs_info *fsi = sb->s_fs_info;
> +	size_t i_size = i_size_read(inode);
> +	size_t count = iov_iter_count(ubuf);
> +	size_t max_count;
> +	ssize_t rc;
> +
> +	if (fsi->deverror)
> +		return -ENODEV;
> +
> +	rc = famfs_file_invalid(inode);
> +	if (rc)
> +		return rc;
> +
> +	/* Avoid unsigned underflow if position is past EOF */
> +	if (iocb->ki_pos >= i_size)
> +		max_count = 0;
> +	else
> +		max_count = i_size - iocb->ki_pos;
> +
> +	if (count > max_count)
> +		iov_iter_truncate(ubuf, max_count);
> +
> +	if (!iov_iter_count(ubuf))
> +		return 0;
> +
> +	return rc;
> +}
> +
> +static ssize_t
> +famfs_dax_read_iter(struct kiocb *iocb, struct iov_iter	*to)
> +{
> +	struct inode *inode = iocb->ki_filp->f_mapping->host;
> +	ssize_t rc;
> +
> +	/* dax_iomap_rw() requires i_rwsem held (shared for read) */
> +	inode_lock_shared(inode);
> +	rc = famfs_rw_prep(iocb, to);
> +	if (rc || !iov_iter_count(to)) {
> +		inode_unlock_shared(inode);
> +		return rc;
> +	}
> +
> +	rc = dax_iomap_rw(iocb, to, NULL /*&famfs_iomap_ops */);
> +	inode_unlock_shared(inode);
> +
> +	file_accessed(iocb->ki_filp);

Is it really accessed if rc != 0?

> +	return rc;
> +}
> +
> +/**
> + * famfs_dax_write_iter()
> + *
> + * We need our own write-iter in order to prevent append
> + *
> + * @iocb:
> + * @from: iterator describing the user memory source for the write
> + */
> +static ssize_t
> +famfs_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
> +{
> +	struct inode *inode = iocb->ki_filp->f_mapping->host;
> +	struct famfs_fs_info *fsi = inode->i_sb->s_fs_info;
> +	ssize_t rc;
> +
> +	if (!famfs_opt_enabled(fsi, FAMFS_OPT_WRITE))
> +		return -EPERM;
> +
> +	/* dax_iomap_rw() requires i_rwsem held (exclusive for write) */
> +	inode_lock(inode);
> +	rc = famfs_rw_prep(iocb, from);
> +	if (rc || !iov_iter_count(from)) {
> +		inode_unlock(inode);
> +		return rc;
> +	}
> +
> +	rc = dax_iomap_rw(iocb, from, NULL /*&famfs_iomap_ops*/);

What happens if you pass a null iomap ops?  TBH I was expecting you to
define the iomap ops with a dummy ->iomap_begin that returns EIO or
something.

> +	inode_unlock(inode);
> +	return rc;

Do you need to update mtime here?

--D

> +}
> +
> +const struct file_operations famfs_file_operations = {
> +	.owner             = THIS_MODULE,
> +
> +	/* Custom famfs operations */
> +	.write_iter	   = famfs_dax_write_iter,
> +	.read_iter	   = famfs_dax_read_iter,
> +	.unlocked_ioctl    = NULL /*famfs_file_ioctl*/,
> +	.mmap		   = NULL /* famfs_file_mmap */,
> +
> +	/* Force PMD alignment for mmap */
> +	.get_unmapped_area = thp_get_unmapped_area,
> +
> +	/* Generic Operations */
> +	.fsync		   = noop_fsync,
> +	.splice_read	   = filemap_splice_read,
> +	.splice_write	   = iter_file_splice_write,
> +	.llseek		   = generic_file_llseek,
> +};
> +
> diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> index efc6b852eca0..910a143dad30 100644
> --- a/fs/famfs/famfs_inode.c
> +++ b/fs/famfs/famfs_inode.c
> @@ -58,7 +58,7 @@ static struct inode *famfs_get_inode(
>  		break;
>  	case S_IFREG:
>  		inode->i_op = &famfs_file_inode_operations;
> -		inode->i_fop = NULL /* &famfs_file_operations */;
> +		inode->i_fop = &famfs_file_operations;
>  		break;
>  	case S_IFDIR:
>  		inode->i_op = &famfs_dir_inode_operations;
> diff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h
> index 485087588a11..26f5abda96dc 100644
> --- a/fs/famfs/famfs_internal.h
> +++ b/fs/famfs/famfs_internal.h
> @@ -15,6 +15,8 @@
>  #include <linux/bits.h>
>  #include <linux/build_bug.h>
>  
> +extern const struct file_operations famfs_file_operations;
> +
>  struct famfs_mount_opts {
>  	umode_t mode;
>  };
> -- 
> 2.53.0
> 
> 
