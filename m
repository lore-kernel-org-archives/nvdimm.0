Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EED73876BA;
	Thu,  6 Aug 2026 05:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785993892; cv=none; b=IoWgVsDHGvTP5W/RnV28fUbqO7HSe6y7fvnPWxR1VfQNgO0+1osPTkfNVBRl/7XrKz9PT+0U5n9ECq3+TMgmXpssQxX3pjRykR7kX1Jf+zehPOh93EMQw0uxJQ4bZCFE+NrSvS6ZPbooNbHIvsBzqVqdDdSFYlf3AArwLj+kTFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785993892; c=relaxed/simple;
	bh=m4AiYVxLzSTdKgPcsDUD7fNjqKESQ9EX1BmCuInblps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kVv/l9MFHPZfGwdhlBwf00LmCzXjpC6n2iDn3UnLcaG9/3jh2RW8gVdkPBHTkBw5MplrUvFLb4F9nqthhAQguZxPlW1rI5R0VA2XZYH4M4A1kFPXiQ9ecTWXEZLjJBFpqA5csIdZoK1nPOZeGfQRCZwhCCY6OZ02+FlZG0RGJ24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g3WNmJkk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g3WNmJkk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C71EB1F000E9;
	Thu,  6 Aug 2026 05:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785993889;
	bh=F1J+hDxLJ0+emdzvqZFW9KihFBAmAAYMZb4CYh8BOlQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g3WNmJkk3P03I5fvLT4G3tACYxDVkynacZ8yby7PAQayuCBiEtsitD7EEy0iuOixW
	 jmTYJilozVsqswkEFPNZ8wl5xFAHUKZoXlTOyXPQnMl1chG/ssHrD39P+SwkjpJWs4
	 gMAeiy3iQjxU8s/Tcxh02bnXbjUyQZMZ0DlVSxKhWWMw0e6QW5bmTTDvihhI7xOYWk
	 JNfeJ9lhryWrmvGcPrnMtv5qex95yHApwArj+l4IH0ek5ynmOsmHorQxNRu26ckNDx
	 RXOq2QaTtMuQgUHwu0Y+pboBus28AHBU4OEp47+1+s8sD92XPqw2kcsq8Grly4ULq3
	 ZxqzxTttdJY9Q==
Date: Wed, 5 Aug 2026 22:24:49 -0700
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
Subject: Re: [PATCH V12 07/12] famfs: MAP_CREATE ioctl and fmap ingest (ABI
 44)
Message-ID: <20260806052449.GG3560084@frogsfrogsfrogs>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022919.75875-1-john@jagalactic.com>
 <0100019fc5746312-6cfe9a07-a658-4aba-b1e9-5233b0ddfcf4-000000@email.amazonses.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019fc5746312-6cfe9a07-a658-4aba-b1e9-5233b0ddfcf4-000000@email.amazonses.com>

On Mon, Aug 03, 2026 at 02:29:26AM +0000, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Add the famfs file ioctl handler (FAMFSIOC_NOP, FAMFSIOC_MAP_CREATE) and
> the KABI-44 self-describing fmap message: the wire ABI in famfs_ioctl.h
> (famfs_ioc_fmap_header plus the simple and interleaved extent structs), the
> in-core famfs_file_meta, and famfs_file_init_dax(), which copies the
> message in, parses both the simple-extent and interleaved (striped) wire
> forms into inode->i_private, and sets S_DAX.
> 
> Resolving those mappings to dax-device offsets (iomap_begin) is added in
> the following commit; the read/write/fault paths keep their NULL iomap_ops
> stub until then.
> 
> Also add famfs ioctls to ioctl-number.rst
> 
> Signed-off-by: John Groves <john@groves.net>
> ---
>  .../userspace-api/ioctl/ioctl-number.rst      |   1 +
>  fs/famfs/famfs_file.c                         | 326 +++++++++++++++++-
>  fs/famfs/famfs_inode.c                        |   1 +
>  fs/famfs/famfs_internal.h                     |  46 +++
>  include/uapi/linux/famfs_ioctl.h              |  91 +++++
>  5 files changed, 462 insertions(+), 3 deletions(-)
>  create mode 100644 include/uapi/linux/famfs_ioctl.h
> 
> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> index 3f0ef1e27eb0..5e244dec1b98 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -299,6 +299,7 @@ Code  Seq#    Include File                                             Comments
>  'u'   00-2F  linux/ublk_cmd.h                                          conflict!
>  'u'   20-3F  linux/uvcvideo.h                                          USB video class host driver
>  'u'   40-4f  linux/udmabuf.h                                           userspace dma-buf misc device
> +'u'   50-5F  linux/famfs_ioctl.h                                       famfs shared memory file system
>  'v'   00-1F  linux/ext2_fs.h                                           conflict!
>  'v'   00-1F  linux/fs.h                                                conflict!
>  'v'   00-0F  linux/sonypi.h                                            conflict!
> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> index 678f2035fd5f..d710c8a0c923 100644
> --- a/fs/famfs/famfs_file.c
> +++ b/fs/famfs/famfs_file.c
> @@ -13,9 +13,313 @@
>  #include <linux/mm.h>
>  #include <linux/dax.h>
>  #include <linux/iomap.h>
> +#include <linux/capability.h>
>  
> +#include <linux/famfs_ioctl.h>
>  #include "famfs_internal.h"
>  
> +/* Expose famfs kernel abi version as a read-only module parameter */
> +static int famfs_kabi_version = FAMFS_KABI_VERSION;
> +module_param(famfs_kabi_version, int, 0444);
> +MODULE_PARM_DESC(famfs_kabi_version, "famfs kernel abi version");

Maybe make the "NOP" ioctl a geometry ioctl that tells you the abi
version and (I guess) the page and pmd size? :D

> +void
> +famfs_meta_free(struct famfs_file_meta *map)
> +{
> +	if (map) {
> +		switch (map->fm_extent_type) {
> +		case FAMFS_IOC_EXT_SIMPLE:
> +			kfree(map->se);
> +			break;
> +		case FAMFS_IOC_EXT_INTERLEAVE:
> +			if (map->ie) {
> +				u32 i;
> +
> +				for (i = 0; i < map->fm_niext; i++)
> +					kfree(map->ie[i].ie_strips);
> +			}
> +			kfree(map->ie);
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +	kfree(map);
> +}
> +
> +/**
> + * famfs_file_init_dax() - FAMFSIOC_MAP_CREATE ioctl handler
> + * @file: the un-initialized file
> + * @arg:  user pointer to a self-describing fmap message
> + *
> + * The map-create ioctl carries the fmap as a self-describing message: a
> + * struct famfs_ioc_fmap_header followed by an extent list. The message is
> + * copied in, parsed into a famfs_file_meta, and published on inode->i_private.
> + * Both the simple-extent and the interleaved (striped) wire forms are handled.
> + * The wire layout byte-matches the fmap carried in a fuse famfs GET_FMAP reply.
> + */

This kerneldoc is for the next function?

> +static int
> +famfs_check_ext_alignment(struct famfs_meta_simple_ext *se)
> +{
> +	int errs = 0;
> +
> +	if (!IS_ALIGNED(se->ext_offset, PMD_SIZE))
> +		errs++;
> +	if (!IS_ALIGNED(se->ext_len, PMD_SIZE))
> +		errs++;

Does this need to check the dax dev index is valid?  Or is it ok to just
fail an IO if that index is garbage?

> +
> +	return errs;
> +}
> +
> +static int
> +famfs_file_init_dax(struct file *file, void __user *arg)
> +{
> +	struct famfs_ioc_fmap_header fmh;
> +	struct famfs_file_meta *meta = NULL;
> +	struct famfs_fs_info *fsi;
> +	struct super_block *sb;
> +	struct inode *inode;
> +	void *fmap_buf = NULL;
> +	size_t extent_total = 0;
> +	size_t next_offset;
> +	int errs = 0;
> +	int rc;
> +	u32 i, j;
> +
> +	inode = file_inode(file);
> +	if (!inode)
> +		return -EBADF;
> +	if (inode->i_private)
> +		return -EEXIST;
> +
> +	sb  = inode->i_sb;
> +	fsi = sb->s_fs_info;
> +	if (fsi->deverror)
> +		return -ENODEV;
> +	if (!famfs_opt_enabled(fsi, FAMFS_OPT_MAP_CREATE))
> +		return -EPERM;
> +
> +	if (copy_from_user(&fmh, arg, sizeof(fmh)))
> +		return -EFAULT;
> +
> +	if (fmh.fmap_version != FAMFS_FMAP_VERSION)
> +		return -EINVAL;
> +	if (fmh.fmap_size < sizeof(fmh))
> +		return -EINVAL;
> +	if (fmh.fmap_size > FAMFS_FMAP_MSG_MAX)
> +		return -EFBIG;
> +	if (fmh.nextents < 1)
> +		return -EINVAL;
> +
> +	fmap_buf = kvmalloc(fmh.fmap_size, GFP_KERNEL);
> +	if (!fmap_buf)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(fmap_buf, arg, fmh.fmap_size)) {
> +		rc = -EFAULT;
> +		goto out;
> +	}
> +	next_offset = sizeof(fmh);	/* start of the extent list */
> +
> +	meta = kzalloc_obj(*meta, GFP_KERNEL);
> +	if (!meta) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	meta->error = false;
> +	meta->file_type = fmh.file_type;
> +	meta->file_size = fmh.file_size;
> +	meta->fm_extent_type = fmh.ext_type;
> +
> +	switch (fmh.ext_type) {
> +	case FAMFS_IOC_EXT_SIMPLE: {
> +		struct famfs_ioc_simple_ext *se_in = fmap_buf + next_offset;
> +
> +		next_offset += (size_t)fmh.nextents * sizeof(*se_in);
> +		if (next_offset > fmh.fmap_size) {
> +			rc = -EINVAL;
> +			goto out;
> +		}
> +
> +		meta->fm_nextents = fmh.nextents;
> +		meta->se = kcalloc(meta->fm_nextents, sizeof(*meta->se),
> +				   GFP_KERNEL);
> +		if (!meta->se) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}
> +
> +		for (i = 0; i < fmh.nextents; i++) {
> +			meta->se[i].dev_index  = se_in[i].se_devindex;
> +			meta->se[i].ext_offset = se_in[i].se_offset;
> +			meta->se[i].ext_len    = se_in[i].se_len;
> +
> +			if (meta->se[i].dev_index >= FAMFS_MAX_DAXDEVS) {
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +			meta->dev_bitmap |= BIT_ULL(meta->se[i].dev_index);
> +			errs += famfs_check_ext_alignment(&meta->se[i]);
> +			extent_total += meta->se[i].ext_len;
> +		}
> +		break;
> +	}
> +
> +	case FAMFS_IOC_EXT_INTERLEAVE: {
> +		s64 size_remainder = meta->file_size;
> +		u32 niext = fmh.nextents;
> +
> +		meta->fm_niext = niext;
> +		meta->ie = kcalloc(niext, sizeof(*meta->ie), GFP_KERNEL);
> +		if (!meta->ie) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}
> +
> +		/* Outer loop is over the separate interleaved extents */
> +		for (i = 0; i < niext; i++) {
> +			struct famfs_ioc_iext *ie_in = fmap_buf + next_offset;
> +			struct famfs_ioc_simple_ext *sie_in;
> +			u64 nstrips;
> +
> +			next_offset += sizeof(*ie_in);
> +			if (next_offset > fmh.fmap_size) {
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +
> +			if (ie_in->ie_chunk_size == 0 ||
> +			    !IS_ALIGNED(ie_in->ie_chunk_size, PMD_SIZE)) {
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +			if (ie_in->ie_nbytes == 0) {
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +
> +			nstrips = ie_in->ie_nstrips;
> +			if (nstrips < 1) {
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +
> +			meta->ie[i].fie_chunk_size = ie_in->ie_chunk_size;
> +			meta->ie[i].fie_nstrips    = ie_in->ie_nstrips;
> +			meta->ie[i].fie_nbytes     = ie_in->ie_nbytes;
> +
> +			/* The strip extents follow the interleaved-ext header */
> +			sie_in = fmap_buf + next_offset;
> +			next_offset += nstrips * sizeof(*sie_in);
> +			if (next_offset > fmh.fmap_size) {
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +
> +			meta->ie[i].ie_strips =
> +				kcalloc(nstrips, sizeof(meta->ie[i].ie_strips[0]),
> +					GFP_KERNEL);
> +			if (!meta->ie[i].ie_strips) {
> +				rc = -ENOMEM;
> +				goto out;
> +			}
> +
> +			/* Inner loop is over the strips */
> +			for (j = 0; j < nstrips; j++) {
> +				struct famfs_meta_simple_ext *so =
> +					&meta->ie[i].ie_strips[j];
> +
> +				so->dev_index  = sie_in[j].se_devindex;
> +				so->ext_offset = sie_in[j].se_offset;
> +				so->ext_len    = sie_in[j].se_len;
> +
> +				if (so->dev_index >= FAMFS_MAX_DAXDEVS) {
> +					rc = -EINVAL;
> +					goto out;
> +				}
> +				meta->dev_bitmap |= BIT_ULL(so->dev_index);
> +				errs += famfs_check_ext_alignment(so);
> +				extent_total += so->ext_len;
> +				size_remainder -= so->ext_len;

This is a lot of indenting, maybe each case should be a separate helper
function?

--D

> +			}
> +		}
> +
> +		if (size_remainder > 0) {
> +			/* Strips do not cover the whole file */
> +			rc = -EINVAL;
> +			goto out;
> +		}
> +		break;
> +	}
> +
> +	default:
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (errs > 0) {
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +	if (extent_total < meta->file_size) {
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* Publish the famfs metadata on inode->i_private */
> +	inode_lock(inode);
> +	if (inode->i_private) {
> +		rc = -EEXIST; /* file already has famfs metadata */
> +	} else {
> +		inode->i_private = meta;
> +		i_size_write(inode, meta->file_size);
> +		inode->i_flags |= S_DAX;
> +		meta = NULL; /* owned by the inode now */
> +		rc = 0;
> +	}
> +	inode_unlock(inode);
> +
> +out:
> +	kvfree(fmap_buf);
> +	if (meta)
> +		famfs_meta_free(meta);
> +	return rc;
> +}
> +
> +/**
> + * famfs_file_ioctl() - Top-level famfs file ioctl handler
> + * @file: the file
> + * @cmd:  ioctl opcode
> + * @arg:  ioctl opcode argument (if any)
> + */
> +static long
> +famfs_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct famfs_fs_info *fsi = inode->i_sb->s_fs_info;
> +	long rc;
> +
> +	if (fsi->deverror && (cmd != FAMFSIOC_NOP))
> +		return -ENODEV;
> +
> +	switch (cmd) {
> +	case FAMFSIOC_NOP:
> +		rc = 0;
> +		break;
> +
> +	case FAMFSIOC_MAP_CREATE:
> +		rc = famfs_file_init_dax(file, (void __user *)arg);
> +		break;
> +
> +	default:
> +		rc = -ENOTTY;
> +		break;
> +	}
> +
> +	return rc;
> +}
> +
>  /*********************************************************************
>   * vm_operations
>   */
> @@ -93,9 +397,25 @@ const struct vm_operations_struct famfs_file_vm_ops = {
>  static ssize_t
>  famfs_file_invalid(struct inode *inode)
>  {
> +	struct famfs_file_meta *meta = inode->i_private;
> +	size_t i_size = i_size_read(inode);
> +
> +	if (!meta) {
> +		pr_debug("%s: un-initialized famfs file\n", __func__);
> +		return -EIO;
> +	}
> +	if (meta->error) {
> +		pr_debug("%s: previously detected metadata errors\n", __func__);
> +		return -EIO;
> +	}
> +	if (i_size != meta->file_size) {
> +		pr_warn("%s: i_size overwritten from %ld to %ld\n",
> +		       __func__, meta->file_size, i_size);
> +		meta->error = true;
> +		return -ENXIO;
> +	}
>  	if (!IS_DAX(inode)) {
> -		pr_debug("%s: inode %llx IS_DAX is false\n",
> -			 __func__, (u64)inode);
> +		pr_debug("%s: inode %llx IS_DAX is false\n", __func__, (u64)inode);
>  		return -ENXIO;
>  	}
>  	return 0;
> @@ -222,7 +542,7 @@ const struct file_operations famfs_file_operations = {
>  	/* Custom famfs operations */
>  	.write_iter	   = famfs_dax_write_iter,
>  	.read_iter	   = famfs_dax_read_iter,
> -	.unlocked_ioctl    = NULL /*famfs_file_ioctl*/,
> +	.unlocked_ioctl    = famfs_file_ioctl,
>  	.mmap		   = famfs_file_mmap,
>  
>  	/* Force PMD alignment for mmap */
> diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> index 910a143dad30..a6c3b4574e69 100644
> --- a/fs/famfs/famfs_inode.c
> +++ b/fs/famfs/famfs_inode.c
> @@ -300,6 +300,7 @@ static int famfs_show_options(struct seq_file *m, struct dentry *root)
>  
>  static void famfs_evict_inode(struct inode *inode)
>  {
> +	famfs_meta_free((struct famfs_file_meta *)inode->i_private);
>  	inode->i_private = NULL;
>  	dax_break_layout_final(inode);
>  	truncate_inode_pages_final(&inode->i_data);
> diff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h
> index 26f5abda96dc..b5f9c8d0349f 100644
> --- a/fs/famfs/famfs_internal.h
> +++ b/fs/famfs/famfs_internal.h
> @@ -15,8 +15,52 @@
>  #include <linux/bits.h>
>  #include <linux/build_bug.h>
>  
> +#include <linux/famfs_ioctl.h>
> +
>  extern const struct file_operations famfs_file_operations;
>  
> +/*
> + * Internal sanity bound on a FAMFSIOC_MAP_CREATE fmap message. The ABI does
> + * not advertise a maximum (the message is self-describing); this only guards
> + * the copy-in against an unreasonable allocation. Oversize is rejected with
> + * -EFBIG.
> + */
> +#define FAMFS_FMAP_MSG_MAX (4 * 1024 * 1024)
> +
> +struct famfs_meta_simple_ext {
> +	u64 dev_index;
> +	u64 ext_offset;
> +	u64 ext_len;
> +};
> +
> +struct famfs_meta_interleaved_ext {
> +	u64 fie_nstrips;
> +	u64 fie_chunk_size;
> +	u64 fie_nbytes;
> +	struct famfs_meta_simple_ext *ie_strips;
> +};
> +
> +/*
> + * Each famfs dax file has this hanging from its inode->i_private.
> + */
> +struct famfs_file_meta {
> +	bool                   error;
> +	enum famfs_file_type   file_type;
> +	size_t                 file_size;
> +	enum famfs_ioc_ext_type fm_extent_type;
> +	u64                    dev_bitmap; /* referenced daxdev indices */
> +	union { /* This will make code a bit more readable */
> +		struct {
> +			size_t         fm_nextents;
> +			struct famfs_meta_simple_ext  *se;
> +		};
> +		struct {
> +			size_t         fm_niext;
> +			struct famfs_meta_interleaved_ext *ie;
> +		};
> +	};
> +};
> +
>  struct famfs_mount_opts {
>  	umode_t mode;
>  };
> @@ -83,4 +127,6 @@ int famfs_devlist_alloc(struct famfs_fs_info *fsi);
>  int famfs_install_daxdev(struct famfs_fs_info *fsi, struct super_block *sb,
>  			 u64 index, dev_t devno, const char *name);
>  
> +void famfs_meta_free(struct famfs_file_meta *map);
> +
>  #endif /* FAMFS_INTERNAL_H */
> diff --git a/include/uapi/linux/famfs_ioctl.h b/include/uapi/linux/famfs_ioctl.h
> new file mode 100644
> index 000000000000..b4eb373c1ade
> --- /dev/null
> +++ b/include/uapi/linux/famfs_ioctl.h
> @@ -0,0 +1,91 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * famfs - dax file system for shared fabric-attached memory
> + *
> + * Copyright 2023-2024 Micron Technology, Inc.
> + *
> + * This file system, originally based on ramfs the dax support from xfs,
> + * is intended to allow multiple host systems to mount a common file system
> + * view of dax files that map to shared memory.
> + */
> +#ifndef FAMFS_IOCTL_H
> +#define FAMFS_IOCTL_H
> +
> +#include <linux/ioctl.h>
> +#include <linux/uuid.h>
> +
> +#define FAMFS_KABI_VERSION 44
> +
> +enum famfs_file_type {
> +	FAMFS_REG,
> +	FAMFS_SUPERBLOCK,
> +	FAMFS_LOG,
> +};
> +
> +/*
> + * Extent type in a famfs fmap message, and of the in-core map
> + * (famfs_file_meta.fm_extent_type).
> + */
> +enum famfs_ioc_ext_type {
> +	FAMFS_IOC_EXT_SIMPLE,
> +	FAMFS_IOC_EXT_INTERLEAVE,
> +};
> +
> +/*
> + * The FAMFSIOC_MAP_CREATE payload is a self-describing fmap message: a
> + * struct famfs_ioc_fmap_header immediately followed by @nextents extent
> + * records. @fmap_size gives the total message length, so a reader is
> + * self-delimiting.
> + *
> + * For ext_type == FAMFS_IOC_EXT_SIMPLE the records are an array of
> + * @nextents famfs_ioc_simple_ext. For ext_type == FAMFS_IOC_EXT_INTERLEAVE
> + * each of the @nextents records is a famfs_ioc_iext header immediately
> + * followed by ie_nstrips famfs_ioc_simple_ext strip extents.
> + *
> + * This wire layout is byte-identical to the fmap carried in a fuse famfs
> + * GET_FMAP reply, so the same userspace serializer emits both.
> + *
> + * The message is self-describing (@fmap_size bounds it), so neither the extent
> + * and strip counts nor the total size are capped by this ABI. The kernel
> + * applies an internal sanity limit to the copy-in and returns -EFBIG for a
> + * message larger than it will accept.
> + */
> +#define FAMFS_FMAP_VERSION 1
> +
> +struct famfs_ioc_simple_ext {
> +	__u32 se_devindex;
> +	__u32 reserved;
> +	__u64 se_offset;
> +	__u64 se_len;
> +};
> +
> +struct famfs_ioc_iext {		/* interleaved (striped) extent */
> +	__u32 ie_nstrips;
> +	__u32 ie_chunk_size;
> +	__u64 ie_nbytes;	/* total bytes mapped by this interleaved extent */
> +	__u64 reserved;
> +};
> +
> +struct famfs_ioc_fmap_header {
> +	__u8  file_type;	/* enum famfs_file_type */
> +	__u8  reserved;
> +	__u16 fmap_version;	/* FAMFS_FMAP_VERSION */
> +	__u32 ext_type;		/* enum famfs_ioc_ext_type */
> +	__u32 nextents;
> +	__u32 fmap_size;	/* total message bytes, including this header */
> +	__u64 file_size;
> +	__u64 reserved1;
> +};
> +
> +#define FAMFSIOC_MAGIC 'u'
> +
> +/* famfs file ioctl opcodes */
> +#define FAMFSIOC_NOP           _IO(FAMFSIOC_MAGIC,   0x50)
> +
> +/*
> + * MAP_CREATE carries the self-describing fmap message - struct
> + * famfs_ioc_fmap_header followed by the extent list (see above).
> + */
> +#define FAMFSIOC_MAP_CREATE    _IOW(FAMFSIOC_MAGIC,  0x51, struct famfs_ioc_fmap_header)
> +
> +#endif /* FAMFS_IOCTL_H */
> -- 
> 2.53.0
> 
> 
> 
