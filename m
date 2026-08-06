Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE55A499F27;
	Thu,  6 Aug 2026 22:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786054493; cv=none; b=nIDluweDe4RXZhXCT5WjSUukUN4SxZEhbTLBLBXHhL543uzdp7LOvKbxSBm7Xdbjh31d/tTqvLsyEt2oPs4IL0ul4a7flb+yn96GoSXLdpbgWuQBeIYJ/Gg+GxNa4GXYvUzMRVJ8CGK8bHNpIuPxf6qnpOuUFTK+7NlTMs9IHxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786054493; c=relaxed/simple;
	bh=SQ2wlFrtok/Wh1kWAEMVZ2zJPEiX4XfQ/pBSFWBAfB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pCdSzEO03bJrPrvoipaGSJFleF5Wpnezpopzdi9VFQZJh1tUJ6j7uQazAb/bqr01MadvhuN15ZospZzKF9nDZLtQ9fILFZfUTBVcFRXoxluL4RX9+X7Um/WKGeM5QWOyFzIresRvsIvLL9zkxcNrCaXs7/1/NqHf1QwfUQsBUbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 315F1140480;
	Thu,  6 Aug 2026 22:14:45 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf11.hostedemail.com (Postfix) with ESMTPA id BFA1C20029;
	Thu,  6 Aug 2026 22:14:28 +0000 (UTC)
Date: Thu, 6 Aug 2026 17:14:27 -0500
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
Subject: Re: [PATCH V12 08/12] famfs: iomap_begin and file-to-dax offset
 resolution
Message-ID: <anT_YW1vGr-9LtrY@groves.net>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022929.75893-1-john@jagalactic.com>
 <0100019fc5748c1e-45cb66a3-f847-4c3e-8a89-a04c89d24b32-000000@email.amazonses.com>
 <20260806052801.GH3560084@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806052801.GH3560084@frogsfrogsfrogs>
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: BFA1C20029
X-Stat-Signature: pigtyqpb6mehqi8mdy5a6cdba5frm1n7
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX194A+OryvcXO9dwYXu8Mq5itp260GreQU0=
X-HE-Tag: 1786054468-5431
X-HE-Meta: U2FsdGVkX1/q4XvTbJTJBpsJg7CvomZWOHYFCWZfVln/0uT+3fXc2pSQDNXlGm6ZNw8+dvmToSYAOllgGYneN7xN4Xm62lIfMgC4pI7uRxWtVsIVIyud5ivJbj5woNGXZg0UT8DQdHNOSkIa4oluhn2YLKLHPqtxwuLdf/EDNs3hykRllcWlYY9ToiT7UTZVnq9yX4s4vdpW7MUAFJGA7IR1D4+2FQMpu5Xor/Y3ag+c2Z0GiVWvGqYZKlg6MH+QiYVlaIBSosCasdmzldybpRNAiwYdp4QhNXfTNtlfM00aIEv2FdxHwOngrBsaNUaPKiG6PjnSX4iwldYwUOv/S1Rlpy+5RSsOsMbYKkjOyC4nD8Pk/ZUuKtLsMZcFvpc9

On 26/08/05 10:28PM, Darrick J. Wong wrote:
> On Mon, Aug 03, 2026 at 02:29:37AM +0000, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > Add the iomap resolver that maps a file offset to a (daxdev, offset) pair:
> > famfs_meta_to_dax_offset() for simple extent lists and
> > famfs_meta_to_dax_offset_interleaved() for striped files, backed by the
> > per-daxdev health check (famfs_dax_err) and table lookup
> > (famfs_daxdev_for_index), plus famfs_iomap_begin() and famfs_iomap_ops.
> > 
> > Wire it into the read, write and fault paths by replacing their
> > NULL /*&famfs_iomap_ops*/ stub with &famfs_iomap_ops, so dax_iomap_rw() and
> > dax_iomap_fault() now resolve through famfs.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/famfs/famfs_file.c | 298 +++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 295 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> > index d710c8a0c923..e7f271ce6d03 100644
> > --- a/fs/famfs/famfs_file.c
> > +++ b/fs/famfs/famfs_file.c
> > @@ -320,6 +320,298 @@ famfs_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> >  	return rc;
> >  }
> >  
> > +/*********************************************************************
> > + * iomap_operations
> > + *
> > + * This stuff uses the iomap (dax-related) helpers to resolve file offsets to
> > + * offsets within a dax device.
> > + */
> > +
> > +static ssize_t famfs_file_invalid(struct inode *inode);
> > +
> > +/* Check the health of a daxdev table slot */
> > +static int famfs_dax_err(struct famfs_daxdev *dd)
> > +{
> > +	if (!dd->valid) {
> > +		pr_debug("%s: daxdev=%s invalid\n", __func__, dd->name);
> > +		return -EIO;
> > +	}
> > +	if (dd->dax_err) {
> > +		pr_debug("%s: daxdev=%s dax_err\n", __func__, dd->name);
> > +		return -EIO;
> > +	}
> > +	if (dd->error) {
> > +		pr_debug("%s: daxdev=%s memory error\n", __func__, dd->name);
> > +		return -EHWPOISON;
> > +	}
> > +	return 0;
> > +}
> > +
> > +/*
> > + * famfs_daxdev_from_index() - resolve an extent's dev_index to a health-checked
> > + * dax_device from the table. On success returns the dax_device and sets
> > + * *errp = 0; on failure returns NULL and sets *errp (< 0).
> > + */
> > +static struct dax_device *
> > +famfs_daxdev_from_index(struct famfs_fs_info *fsi, u64 dev_index, int *errp)
> > +{
> > +	struct famfs_dax_devlist *devlist = fsi->dax_devlist;
> > +	struct famfs_daxdev *dd;
> > +	int rc;
> > +
> > +	if (!devlist || dev_index >= devlist->nslots) {
> > +		pr_debug("%s: dev_index %llu out of range\n",
> > +			__func__, dev_index);
> > +		*errp = -EIO;
> > +		return NULL;
> > +	}
> > +	dd = &devlist->devlist[dev_index];
> > +	rc = famfs_dax_err(dd);
> > +	if (rc) {
> > +		*errp = rc;
> > +		return NULL;
> > +	}
> > +	*errp = 0;
> > +	return dd->devp;
> > +}
> > +
> > +static int
> > +famfs_meta_to_dax_offset_interleaved(struct inode *inode, struct iomap *iomap,
> > +			 loff_t file_offset, off_t len, unsigned int flags)
> > +{
> > +	struct famfs_fs_info  *fsi = inode->i_sb->s_fs_info;
> > +	struct famfs_file_meta *meta = inode->i_private;
> > +	loff_t local_offset = file_offset;
> > +	int rc;
> > +	int i;
> > +
> > +	/* This function is only for extent_type FAMFS_IOC_EXT_INTERLEAVE */
> > +	if (meta->fm_extent_type != FAMFS_IOC_EXT_INTERLEAVE) {
> > +		pr_debug("%s: bad extent type\n", __func__);
> > +		goto err_out;
> > +	}
> > +
> > +	if (fsi->deverror || famfs_file_invalid(inode))
> > +		goto err_out;
> > +
> > +	iomap->offset = file_offset;
> > +
> > +	for (i = 0; i < meta->fm_niext; i++) {
> > +		struct famfs_meta_interleaved_ext *fei = &meta->ie[i];
> > +		u64 chunk_size = fei->fie_chunk_size;
> > +		u64 nstrips = fei->fie_nstrips;
> > +		u64 ext_size = fei->fie_nbytes;
> > +
> > +		ext_size = min_t(u64, ext_size, meta->file_size);
> > +
> > +		if (ext_size == 0)
> > +			goto err_out;
> > +
> > +		/* Is the data is in this striped extent? */
> > +		if (local_offset < ext_size) {
> > +			u64 chunk_num       = local_offset / chunk_size;
> > +			u64 chunk_offset    = local_offset % chunk_size;
> > +			u64 stripe_num      = chunk_num / nstrips;
> > +			u64 strip_num       = chunk_num % nstrips;
> > +			u64 chunk_remainder = chunk_size - chunk_offset;
> > +			u64 strip_offset    = chunk_offset + (stripe_num * chunk_size);
> > +			struct famfs_meta_simple_ext *strip = &fei->ie_strips[strip_num];
> > +			struct dax_device *daxdev;
> > +
> > +			/*
> > +			 * MAP_CREATE only checks that the strips' combined
> > +			 * length covers the file, not that each strip is large
> > +			 * enough for the chunks striped onto it. Guard against a
> > +			 * malformed fmap with an undersized strip so we never
> > +			 * resolve to a dax offset past the strip's extent.
> > +			 */
> > +			if (strip_offset >= strip->ext_len)
> > +				goto err_out;
> > +
> > +			daxdev = famfs_daxdev_from_index(fsi, strip->dev_index, &rc);
> 
> Ok so here you check the dax dev index is valid.

Right-o

> 
> > +			if (!daxdev) {
> > +				meta->error = true;
> > +				return rc;
> 
> What is rc at this point?

Passed by reference to famfs_daxdev_from_index(), just above, and always stored
by that function.

> 
> > +			}
> > +
> > +			iomap->addr    = strip->ext_offset + strip_offset;
> > +			iomap->offset  = file_offset;
> > +			iomap->length  = min_t(loff_t, len, chunk_remainder);
> > +			iomap->length  = min_t(loff_t, iomap->length,
> > +					       strip->ext_len - strip_offset);
> > +			iomap->dax_dev = daxdev;
> > +			iomap->type    = IOMAP_MAPPED;
> > +			iomap->flags   = flags;
> > +
> > +			return 0;
> > +		}
> > +		local_offset -= ext_size; /* offset is beyond this striped extent */
> > +	}
> > +
> > + err_out:
> > +	/*
> > +	 * We fell out the end of the extent list (access past EOF) or the file
> > +	 * is invalid. Return -EIO: iomap requires a non-zero-length mapping on
> > +	 * success (iomap_iter_done() warns on length == 0), so signal the error
> > +	 * rather than returning a zero-length IOMAP_MAPPED.
> > +	 */
> > +	pr_debug("%s: could not resolve file_offset %lld (past EOF?)\n",
> > +		 __func__, (long long)file_offset);
> > +
> > +	iomap->addr    = 0; /* there is no valid dax device offset */
> > +	iomap->offset  = file_offset; /* file offset */
> > +	iomap->length  = 0;
> > +	iomap->dax_dev = famfs_daxdev_from_index(fsi, 0, &rc);
> > +	iomap->type    = IOMAP_MAPPED;
> > +	iomap->flags   = flags;
> > +
> > +	return -EIO;
> 
> Ah ok this answers my question about what happens if there are sparse
> holes at the end.

Famfs files are never sparse, so the fmap size is always >= i_size unless
there's a bug. So this "doesn't happen", but if somebody got away with 
truncating longer or overwriting i_size, you could land here with EIO. 

> 
> > +}
> > +
> > +/**
> > + * famfs_meta_to_dax_offset() - Resolve (file, offset, len) to (daxdev, offset, len)
> > + *
> > + * This function is called by famfs_iomap_begin() to resolve an offset in a
> > + * file to an offset in a dax device. This is upcalled from dax from calls to
> > + * both  * dax_iomap_fault() and dax_iomap_rw(). Dax finishes the job resolving
> > + * a fault to a specific physical page (the fault case) or doing a memcpy
> > + * variant (the rw case)
> > + *
> > + * Pages can be PTE (4k), PMD (2MiB) or (theoretically) PuD (1GiB)
> > + * (these sizes are for X86; may vary on other cpu architectures
> > + *
> > + * @inode:  The file where the fault occurred
> > + * @iomap:       To be filled in to indicate where to find the right memory,
> > + *               relative  to a dax device.
> > + * @file_offset: Within the file where the fault occurred (will be page boundary)
> > + * @len:         The length of the faulted mapping (will be a page multiple)
> > + *               (will be trimmed in *iomap if it's disjoint in the extent list)
> > + * @flags:
> > + *
> > + * Return values: 0. (info is returned in a modified @iomap struct)
> > + */
> > +static int
> > +famfs_meta_to_dax_offset(struct inode *inode, struct iomap *iomap,
> > +			 loff_t file_offset, off_t len, unsigned int flags)
> > +{
> > +	struct famfs_fs_info  *fsi = inode->i_sb->s_fs_info;
> > +	struct famfs_file_meta *meta = inode->i_private;
> > +	loff_t local_offset = file_offset;
> > +	int rc;
> > +	int i;
> > +
> > +	if (fsi->deverror || famfs_file_invalid(inode))
> > +		goto err_out;
> > +
> > +	if (meta->fm_extent_type == FAMFS_IOC_EXT_INTERLEAVE)
> > +		return famfs_meta_to_dax_offset_interleaved(inode,
> > +					iomap, file_offset, len, flags);
> > +
> > +	if (meta->fm_extent_type != FAMFS_IOC_EXT_SIMPLE)
> > +		goto err_out;
> > +
> > +	iomap->offset = file_offset;
> > +
> > +	for (i = 0; i < meta->fm_nextents; i++) {
> > +		loff_t dax_ext_offset = meta->se[i].ext_offset;
> > +		loff_t dax_ext_len    = meta->se[i].ext_len;
> > +
> > +		if ((dax_ext_offset == 0) &&
> > +		    (meta->file_type != FAMFS_SUPERBLOCK))
> > +			pr_warn("%s: zero offset on non-superblock file!!\n",
> > +				__func__);
> > +
> > +		/* local_offset is the offset minus the size of extents skipped
> > +		 * so far; If local_offset < dax_ext_len, the data of interest
> > +		 * starts in this extent
> > +		 */
> > +		if (local_offset < dax_ext_len) {
> > +			loff_t ext_len_remainder = dax_ext_len - local_offset;
> > +			struct dax_device *daxdev;
> > +
> > +			daxdev = famfs_daxdev_from_index(fsi,
> > +						meta->se[i].dev_index, &rc);
> > +			if (!daxdev) {
> > +				meta->error = true;
> > +				return rc;
> > +			}
> > +
> > +			/*
> > +			 * OK, we found the file metadata extent where this
> > +			 * data begins
> > +			 * @local_offset      - The offset within the current
> > +			 *                      extent
> > +			 * @ext_len_remainder - Remaining length of ext after
> > +			 *                      skipping local_offset
> > +			 * Outputs:
> > +			 * iomap->addr:   the offset within the dax device where
> > +			 *                the  data starts
> > +			 * iomap->offset: the file offset
> > +			 * iomap->length: the valid length resolved here
> > +			 */
> > +			iomap->addr    = dax_ext_offset + local_offset;
> > +			iomap->offset  = file_offset;
> > +			iomap->length  = min_t(loff_t, len, ext_len_remainder);
> > +			iomap->dax_dev = daxdev;
> > +			iomap->type    = IOMAP_MAPPED;
> > +			iomap->flags   = flags;
> > +
> > +			return 0;
> > +		}
> > +		local_offset -= dax_ext_len; /* Get ready for the next extent */
> > +	}
> > +
> > + err_out:
> > +	/*
> > +	 * We fell out the end of the extent list (access past EOF) or the file
> > +	 * is in an invalid state. Return -EIO: iomap requires a non-zero-length
> > +	 * mapping on success (iomap_iter_done() warns on length == 0), so signal
> > +	 * the error rather than returning a zero-length IOMAP_MAPPED. dax turns
> > +	 * this into a short read/write or a SIGBUS.
> > +	 */
> > +	pr_debug("%s: could not resolve file_offset %lld (past EOF?)\n",
> > +		 __func__, (long long)file_offset);
> > +
> > +	iomap->addr    = 0; /* there is no valid dax device offset */
> > +	iomap->offset  = file_offset; /* file offset */
> > +	iomap->length  = 0;
> > +	iomap->dax_dev = famfs_daxdev_from_index(fsi, 0, &rc);
> > +	iomap->type    = IOMAP_MAPPED;
> > +	iomap->flags   = flags;
> 
> Er... iomap->flags is supposed to get IOMAP_F_ extent state flags, but
> are you passing the IOMAP_ operation flags into this function?
> 
> --D

Thank you! That's an actual bug which dates back years. The correct value 
here is 0, as none of the IOMAP_F flags apply to famfs. Guessing maybe 
flags was already, or didn't contain anything matching IOMAP_F bits that 
dax_iomap used...

Gonna delete the lines that set iomap->flags, since the struct has been 
zeroed in each case.

Apparently (Darrick > AI), because AI saw this a bunch of times and never
caught it!

Thanks!

John

<snip>

