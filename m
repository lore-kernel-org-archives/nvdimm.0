Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9367438B157;
	Thu,  6 Aug 2026 05:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785994146; cv=none; b=SZUhbyWQTf+hCRo/LRjbNdlPVGwYMkvAtBfDwVI0jkuX6YkmS7dLiS+Njge4G0ig6iyYZOW8q999xBEhX+dshFWI77uci1aTmaFpVKDtru738CcaPMIfJFTt5S48a/Q3EyMOVAbfvbin54rOy3YeyPR1WuRe3XlyQWbymcVzfsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785994146; c=relaxed/simple;
	bh=WYMNSlQYvVGHI6wFkFdO5U+7q0JAEftTS9ZVKEuhaL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rpm/40+egT3lAscwUk0Wfij6qolnR6cI98lHMzihdki1k5P8fTcYy39SY9MrlC2qZOW9AzMa+f0L+g0LpQJYXu/BBLhch2u9fMwfPh5afaqCLz4+qTafxwZpeAaozVNJgNrL/eKbI8zCp653dF0KmtNDUyM+zQXj0TH1E2PN7eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g8nvEYMg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g8nvEYMg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1776E1F000E9;
	Thu,  6 Aug 2026 05:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785994145;
	bh=DgMjMqgRjih2aHWm51Ly96EGJqXWj4bwpPMZTXfd73Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g8nvEYMg+61iSmR5Fh2LQDoenWop2u21JWfb4h8quAwYCSYJCK+0hbuaL792q4B1J
	 xxbmym6suDAsKXE7liBt23JiZ3TKzZ6ul6GeGHsYLSPlNbobbLSAYny/2JXEjOUfVF
	 pbPb1r9SaA4BSs7B3/HjmeR+dCS2gDgcxOV3N3FDzKMzYpsgLvLaqV9Ht5vijq6+op
	 amZ/Pbs+tYhfUAx4QfbqHIP+1IzxjgNTEimD5FrYJpu7G0+dxv0jJxS/Qm6Vwu6B/5
	 z9Nh2jDUb9X2FCHCmCIR9hI2DipKFuoREZKIhyvheRgfh0ayLxvutcRZPXSqMfSz5l
	 YLk7gNyh2CVoQ==
Date: Wed, 5 Aug 2026 22:29:04 -0700
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
Subject: Re: [PATCH V12 09/12] famfs: Register secondary daxdevs by path
 (FAMFSIOC_DAXDEV_OPEN)
Message-ID: <20260806052904.GI3560084@frogsfrogsfrogs>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022940.75910-1-john@jagalactic.com>
 <0100019fc574b43d-effbc86f-dd35-4154-8c2e-17699ef0edb6-000000@email.amazonses.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019fc574b43d-effbc86f-dd35-4154-8c2e-17699ef0edb6-000000@email.amazonses.com>

On Mon, Aug 03, 2026 at 02:29:47AM +0000, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Famfs file maps (fmaps) may reference multiple daxdevs. Before passing
> an fmap that references a new daxdev, the daxdev is pushed into the
> kernel via FAMFSIOC_DAXDEV_OPEN). This adds daxdevs to daxdev_table for
> index-based resolution from famfs extents to daxdevs.
> 
> Signed-off-by: John Groves <john@groves.net>
> ---
>  fs/famfs/famfs_file.c            | 74 ++++++++++++++++++++++++++++++++
>  include/uapi/linux/famfs_ioctl.h | 24 +++++++++++
>  2 files changed, 98 insertions(+)
> 
> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> index e7f271ce6d03..e11a55ecf8d7 100644
> --- a/fs/famfs/famfs_file.c
> +++ b/fs/famfs/famfs_file.c
> @@ -287,6 +287,76 @@ famfs_file_init_dax(struct file *file, void __user *arg)
>  	return rc;
>  }
>  
> +/**
> + * famfs_daxdev_open() - FAMFSIOC_DAXDEV_OPEN ioctl handler
> + * @file: any file in the famfs mount (the table is per-superblock)
> + * @arg:  ptr to struct famfs_ioc_daxdev in user space
> + *
> + * Register a devdax device (identified by path) into the mount's daxdev table
> + * at the caller-specified index, so files whose extents reference that index
> + * can be mapped. The path is resolved by lookup_daxdev() - the same helper the
> + * mount uses for the primary daxdev - so every slot is resolved identically.
> + * Registering exposes raw device memory, so it requires CAP_SYS_RAWIO.
> + */
> +static int
> +famfs_daxdev_open(struct file *file, void __user *arg)
> +{
> +	struct super_block *sb = file_inode(file)->i_sb;
> +	struct famfs_fs_info *fsi = sb->s_fs_info;
> +	struct famfs_ioc_daxdev dd;
> +	dev_t devno;
> +	char *path;
> +	int rc;
> +
> +	if (!capable(CAP_SYS_RAWIO))
> +		return -EPERM;
> +
> +	if (copy_from_user(&dd, arg, sizeof(dd)))
> +		return -EFAULT;
> +
> +	/* @flags is reserved; reject non-zero so it stays available */
> +	if (dd.flags)
> +		return -EINVAL;
> +
> +	/*
> +	 * If this daxdev index is already populated there is nothing to do.
> +	 * The index is cluster-invariant, so a valid slot already names this
> +	 * device; skip the path resolution entirely. install_daxdev() rechecks
> +	 * ->valid under the write lock, so this is purely an optimization.
> +	 */
> +	scoped_guard(rwsem_read, &fsi->devlist_sem) {
> +		if (dd.daxdev_index >= fsi->dax_devlist->nslots)
> +			return -EINVAL;
> +		if (fsi->dax_devlist->devlist[dd.daxdev_index].valid)
> +			return 0;
> +	}
> +
> +	if (dd.daxdev_path_len == 0 || dd.daxdev_path_len >= PATH_MAX)
> +		return -EINVAL;
> +
> +	/* +1 so the terminating NUL is included within the bound */
> +	path = strndup_user((const char __user *)(uintptr_t)dd.daxdev_path,
> +			    dd.daxdev_path_len + 1);
> +	if (IS_ERR(path))
> +		return PTR_ERR(path);
> +
> +	rc = lookup_daxdev(path, &devno);
> +	if (rc)
> +		goto out;
> +
> +	/*
> +	 * The daxdev table is allocated at mount time (for the slot-0 primary),
> +	 * so it is always present here; no need to allocate it.
> +	 */
> +	rc = famfs_install_daxdev(fsi, sb, dd.daxdev_index, devno, path);
> +	if (rc)
> +		pr_debug("%s: failed to install daxdev index %llu (%s)\n",
> +		       __func__, dd.daxdev_index, path);
> +out:
> +	kfree(path);
> +	return rc;
> +}
> +
>  /**
>   * famfs_file_ioctl() - Top-level famfs file ioctl handler
>   * @file: the file
> @@ -308,6 +378,10 @@ famfs_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  		rc = 0;
>  		break;
>  
> +	case FAMFSIOC_DAXDEV_OPEN:
> +		rc = famfs_daxdev_open(file, (void __user *)arg);
> +		break;
> +
>  	case FAMFSIOC_MAP_CREATE:
>  		rc = famfs_file_init_dax(file, (void __user *)arg);
>  		break;
> diff --git a/include/uapi/linux/famfs_ioctl.h b/include/uapi/linux/famfs_ioctl.h
> index b4eb373c1ade..751d8b033c2e 100644
> --- a/include/uapi/linux/famfs_ioctl.h
> +++ b/include/uapi/linux/famfs_ioctl.h
> @@ -77,6 +77,29 @@ struct famfs_ioc_fmap_header {
>  	__u64 reserved1;
>  };
>  
> +/**
> + * struct famfs_ioc_daxdev - register an additional backing daxdev by path
> + * @daxdev_index:    the (cluster-invariant) index this daxdev occupies in
> + *                   extent dev_index fields. Index 0 is the mount-time primary.
> + * @daxdev_path:     userspace pointer to the devdax device path (e.g.
> + *                   "/dev/dax0.0"); resolved in the kernel the same way the
> + *                   mount primary is.
> + * @daxdev_path_len: length of the path string, not counting the NUL.
> + * @flags:           reserved; must be zero.
> + *
> + * Standalone famfs registers every daxdev by path: the mount primary comes in
> + * as the mount device name, and slots 1..n come in here. (This deliberately
> + * differs from fuse's fd-based FUSE_DEV_IOC_DAXDEV_OPEN; each side is uniform
> + * within itself.) Passing the path by pointer keeps the struct fixed-size, so
> + * longer paths never require an ABI change.
> + */
> +struct famfs_ioc_daxdev {
> +	__u64 daxdev_index;
> +	__u64 daxdev_path;
> +	__u32 daxdev_path_len;

Can't we just pass an open fd to a dax device and have it use that
rather than doing its own path operations?

--D

> +	__u32 flags;
> +};
> +
>  #define FAMFSIOC_MAGIC 'u'
>  
>  /* famfs file ioctl opcodes */
> @@ -87,5 +110,6 @@ struct famfs_ioc_fmap_header {
>   * famfs_ioc_fmap_header followed by the extent list (see above).
>   */
>  #define FAMFSIOC_MAP_CREATE    _IOW(FAMFSIOC_MAGIC,  0x51, struct famfs_ioc_fmap_header)
> +#define FAMFSIOC_DAXDEV_OPEN   _IOW(FAMFSIOC_MAGIC,  0x52, struct famfs_ioc_daxdev)
>  
>  #endif /* FAMFS_IOCTL_H */
> -- 
> 2.53.0
> 
> 
> 
