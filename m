Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997FA18872A;
	Sat, 22 Aug 2026 00:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787357846; cv=none; b=qlV+6BSzZAGFeL621dFgVWrMryOrdjqSM9TJBgSIOrdwLJEIfqGjtPYqpzLDz0HtmVIkKu7SflXM2Hw09ILpBq+VlCNtShV+F+uFhtQoSQomigRBdtOH0ks+jNAH9vpgsrm7BN0p2ldrdQC1mlBWdB7dLSCeO9c2m3ns54Dfvnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787357846; c=relaxed/simple;
	bh=b2v+1kQko+54MunS+4DuRLpDwsUjv3EooUF8DmQzuOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nHpuIgC4kuV6I/YOqt5h7V/lXh0tyd0aI6Zn2Vv0iHwEw5DPF2n4efEI8rAsHLVvHU/kV4z84bttNIaiFmg46KdkniqyAc21dDz91B1oCdNJ4wUcIHH5if5dtjP+UnWmOswNNKBlSGgAle8WmgUoBII9Lkbqnq2yFATTMwkcrO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GvbuSwfo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GvbuSwfo"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 017991F000E9;
	Sat, 22 Aug 2026 00:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787357844;
	bh=F2HxBnK4CoLmpD04FCfi4bep4tSRXd5ZiTPrW5WTOHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GvbuSwfocVevtP8pg9vBxw/83uqTg1LazmsO/q/AzBw1khiJ3lmCVDsSHtgO5TZ2q
	 jApGrqT+b/vCbEgVyH/YoyuuoTE8uWnr5Wd+DaqQSwJmsxtaueGwFQoVT1G8FH6BKt
	 d5+VGyU+Q2RUX9M94U4NUmptpwsYX2F55uOSnfAg7tAlYpAzIPOkTr3pByEzcjIQsT
	 MDL+wnyrRryV+vmHDbGZoDX+X3ECFhuLNkAN4ha/C2mf3yxq8EWr3sc1i+t35CwUHu
	 Iz19djv2LsPp02XU5BYzEI4ljTSNT9g2rUlSveztAxaC9A0WJk+cpNmU+7239yJHyv
	 dfaEhDChna9fg==
Date: Fri, 21 Aug 2026 17:17:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Groves <john@groves.net>
Cc: Richard Cheng <icheng@nvidia.com>, John Groves <john@jagalactic.com>,
	Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <djbw@kernel.org>,
	Bernd Schubert <bschubert@ddn.com>,
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
Subject: Re: [PATCH v13 07/12] famfs: MAP_CREATE ioctl and fmap ingest (ABI
 44)
Message-ID: <20260822001723.GC6047@frogsfrogsfrogs>
References: <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com>
 <20260810202510.96332-1-john@jagalactic.com>
 <0100019fed59de28-dde6a382-affe-4bc6-a91d-d4054a7c61a5-000000@email.amazonses.com>
 <anrUDcyctLFe8dZL@MWDK4CY14F>
 <ant9osbVPJyUPdWB@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ant9osbVPJyUPdWB@groves.net>

On Tue, Aug 11, 2026 at 05:17:50PM -0500, John Groves wrote:

<snip>

> > > +	switch (fmh.ext_type) {
> > > +	case FAMFS_IOC_EXT_SIMPLE: {
> > > +		struct famfs_ioc_simple_ext *se_in = fmap_buf + next_offset;
> > > +
> > > +		next_offset += (size_t)fmh.nextents * sizeof(*se_in);
> > > +		if (next_offset > fmh.fmap_size) {
> > > +			rc = -EINVAL;
> > > +			goto out;
> > > +		}
> > > +
> > > +		meta->fm_nextents = fmh.nextents;
> > > +		meta->se = kcalloc(meta->fm_nextents, sizeof(*meta->se),
> > > +				   GFP_KERNEL);
> > > +		if (!meta->se) {
> > > +			rc = -ENOMEM;
> > > +			goto out;
> > > +		}
> > > +
> > > +		for (i = 0; i < fmh.nextents; i++) {
> > > +			meta->se[i].dev_index  = se_in[i].se_devindex;
> > > +			meta->se[i].ext_offset = se_in[i].se_offset;
> > > +			meta->se[i].ext_len    = se_in[i].se_len;
> > > +
> > > +			if (meta->se[i].dev_index >= FAMFS_MAX_DAXDEVS) {
> > > +				rc = -EINVAL;
> > > +				goto out;
> > > +			}
> > > +			meta->dev_bitmap |= BIT_ULL(meta->se[i].dev_index);
> > > +			errs += famfs_check_ext_alignment(&meta->se[i]);
> > > +			extent_total += meta->se[i].ext_len;
> > 
> > offset + length + entent_total can overflow, and file_size can be larger
> > than MAX_LFS_FILESIZE. And overflow can wrap the DAX address back to 0
> > and map the wrong memory.
> > 
> > Maybe check_add_overflow() can be utilized ?
> 
> Good idea, thanks!

Yes, all those arithmetics should catch overflows.

> > 
> > 
> > > +		}
> > > +		break;
> > > +	}
> > > +
> > > +	case FAMFS_IOC_EXT_INTERLEAVE: {
> > > +		s64 size_remainder = meta->file_size;
> > > +		u32 niext = fmh.nextents;
> > > +
> > > +		meta->fm_niext = niext;
> > > +		meta->ie = kcalloc(niext, sizeof(*meta->ie), GFP_KERNEL);
> > > +		if (!meta->ie) {
> > > +			rc = -ENOMEM;
> > > +			goto out;
> > > +		}
> > > +
> > > +		/* Outer loop is over the separate interleaved extents */
> > > +		for (i = 0; i < niext; i++) {
> > > +			struct famfs_ioc_iext *ie_in = fmap_buf + next_offset;
> > > +			struct famfs_ioc_simple_ext *sie_in;
> > > +			u64 nstrips;
> > > +
> > > +			next_offset += sizeof(*ie_in);
> > > +			if (next_offset > fmh.fmap_size) {
> > > +				rc = -EINVAL;
> > > +				goto out;
> > > +			}
> > > +
> > > +			/* chunk_size must be exactly one supported alloc unit */
> > > +			if (ie_in->ie_chunk_size != PAGE_SIZE &&
> > > +			    ie_in->ie_chunk_size != PMD_SIZE) {
> > > +				rc = -EINVAL;
> > > +				goto out;
> > > +			}
> > > +			if (ie_in->ie_nbytes == 0) {
> > > +				rc = -EINVAL;
> > > +				goto out;
> > > +			}
> > > +
> > > +			nstrips = ie_in->ie_nstrips;
> > > +			if (nstrips < 1) {
> > > +				rc = -EINVAL;
> > > +				goto out;
> > > +			}
> > > +
> > > +			meta->ie[i].fie_chunk_size = ie_in->ie_chunk_size;
> > > +			meta->ie[i].fie_nstrips    = ie_in->ie_nstrips;
> > > +			meta->ie[i].fie_nbytes     = ie_in->ie_nbytes;
> > > +
> > > +			/* The strip extents follow the interleaved-ext header */
> > > +			sie_in = fmap_buf + next_offset;
> > > +			next_offset += nstrips * sizeof(*sie_in);
> > > +			if (next_offset > fmh.fmap_size) {
> > > +				rc = -EINVAL;
> > > +				goto out;
> > > +			}
> > > +
> > > +			meta->ie[i].ie_strips =
> > > +				kcalloc(nstrips,
> > > +					sizeof(meta->ie[i].ie_strips[0]),
> > > +					GFP_KERNEL);
> > > +			if (!meta->ie[i].ie_strips) {
> > > +				rc = -ENOMEM;
> > > +				goto out;
> > > +			}
> > > +
> > > +			/* Inner loop is over the strips */
> > > +			for (j = 0; j < nstrips; j++) {
> > > +				struct famfs_meta_simple_ext *so =
> > > +					&meta->ie[i].ie_strips[j];
> > > +
> > > +				so->dev_index  = sie_in[j].se_devindex;
> > > +				so->ext_offset = sie_in[j].se_offset;
> > > +				so->ext_len    = sie_in[j].se_len;
> > > +
> > > +				if (so->dev_index >= FAMFS_MAX_DAXDEVS) {
> > > +					rc = -EINVAL;
> > > +					goto out;
> > > +				}
> > > +				meta->dev_bitmap |= BIT_ULL(so->dev_index);
> > > +				errs += famfs_check_ext_alignment(so);
> > > +				extent_total += so->ext_len;
> > > +				size_remainder -= so->ext_len;
> > 
> > We use physical allocation size here to check logical file coverage,
> > it doesn't make sense to me.
> > For example, file_size can be 1MB and ie_nbytes only 4KB, but a 1MB ext_len makes this check pass, and you access the area after the first 4 KB will fail,
> > because it has no logical mapping.
> > 
> > Maybe we should make sure the sum of ie_nbytes covers file_size, and
> > separately check that each strip's ext_len is large enough for its assigned
> > chunks ?
> 
> Chapeau to you for actually studying this code. Not many have gone
> there. It's arcane, but logically not too complicated.
> 
> You're right that famfs_file_init_dax() doesn't check for pathological
> strip sizes or overflows. It does do some basic checking, but would
> not catch a short strip followed by one or more "correct" strips.
> That stuff would indicate a buggy or malicious caller, since it
> violates the fmap logic.
> 
> However, the vma fault handler for interleaved files, 
> famfs_meta_to_dax_offset_interleaved(), *does* check for strip 
> overflows. It resolves a file offset to an offset in a specific
> strip (based on strip count and chunk size), and then checks that 
> it falls within the strip and not past the end.
> 
> Here is that code:
> 
> 	/*
> 	 * MAP_CREATE only checks that the strips' combined
> 	 * length covers the file, not that each strip is large
> 	 * enough for the chunks striped onto it. Guard against a
> 	 * malformed fmap with an undersized strip so we never
> 	 * resolve to a dax offset past the strip's extent.
> 	 */
> 	if (strip_offset >= strip->ext_len)
> 		goto err_out;
> 
> 	daxdev = famfs_daxdev_from_index(fsi, strip->dev_index, &rc);
> 	if (!daxdev) {
> 		meta->error = true;
> 		return rc;
> 	}
> 
> 	iomap->addr    = strip->ext_offset + strip_offset;
> 	iomap->offset  = file_offset;
> 	iomap->length  = min_t(loff_t, len, chunk_remainder);
> 	iomap->length  = min_t(loff_t, iomap->length,
> 			       strip->ext_len - strip_offset);
> 	iomap->dax_dev = daxdev;
> 	iomap->type    = IOMAP_MAPPED;
> 
> 	return 0;
> 
> Since this condition is an error or malice on the part of the 
> MAP_CREATE caller, I'm comfortable with catching it at fault time.

I think you should reject *any* bad mapping data at MAP_CREATE time
because then you can catch application bugs early with an immediate
error being sent to the famfs server.  Don't let bad data into the
kernel.

> > > +			}
> > > +		}
> > > +
> > > +		if (size_remainder > 0) {
> > > +			/* Strips do not cover the whole file */
> > > +			rc = -EINVAL;
> > > +			goto out;
> > > +		}
> > > +		break;
> > > +	}
> > > +
> > > +	default:
> > > +		rc = -EINVAL;
> > > +		goto out;
> > > +	}
> > > +
> > > +	if (errs > 0) {
> > > +		rc = -EINVAL;
> > > +		goto out;
> > > +	}
> > > +	if (extent_total < meta->file_size) {
> > > +		rc = -EINVAL;
> > > +		goto out;
> > > +	}
> > > +
> > > +	/* Publish the famfs metadata on inode->i_private */
> > > +	inode_lock(inode);
> > > +	if (inode->i_private) {
> > > +		rc = -EEXIST; /* file already has famfs metadata */
> > > +	} else {
> > > +		inode->i_private = meta;
> > > +		i_size_write(inode, meta->file_size);
> > > +		inode->i_flags |= S_DAX;
> > > +		meta = NULL; /* owned by the inode now */
> > > +		rc = 0;
> > > +	}
> > > +	inode_unlock(inode);
> > > +
> > > +out:
> > > +	kvfree(fmap_buf);
> > > +	if (meta)
> > > +		famfs_meta_free(meta);
> > > +	return rc;
> > > +}
> > > +
> > > +/**
> > > + * famfs_file_ioctl() - Top-level famfs file ioctl handler
> > > + * @file: the file
> > > + * @cmd:  ioctl opcode
> > > + * @arg:  ioctl opcode argument (if any)
> > > + */
> > > +static long
> > > +famfs_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> > > +{
> > > +	struct inode *inode = file_inode(file);
> > > +	struct famfs_fs_info *fsi = inode->i_sb->s_fs_info;
> > > +	long rc;
> > > +
> > > +	if (fsi->deverror && (cmd != FAMFSIOC_NOP))
> > > +		return -ENODEV;
> > > +
> > > +	switch (cmd) {
> > > +	case FAMFSIOC_NOP:
> > > +		rc = 0;
> > > +		break;
> > > +
> > > +	case FAMFSIOC_MAP_CREATE:
> > > +		rc = famfs_file_init_dax(file, (void __user *)arg);
> > > +		break;
> > > +
> > > +	default:
> > > +		rc = -ENOTTY;
> > > +		break;
> > > +	}
> > > +
> > > +	return rc;
> > > +}
> > > +
> > >  /*********************************************************************
> > >   * vm_operations
> > >   */
> > > @@ -94,9 +400,25 @@ const struct vm_operations_struct famfs_file_vm_ops = {
> > >  static ssize_t
> > >  famfs_file_invalid(struct inode *inode)
> > >  {
> > > +	struct famfs_file_meta *meta = inode->i_private;
> > > +	size_t i_size = i_size_read(inode);
> > > +
> > > +	if (!meta) {
> > > +		pr_debug("%s: un-initialized famfs file\n", __func__);
> > > +		return -EIO;
> > > +	}
> > > +	if (meta->error) {
> > > +		pr_debug("%s: previously detected metadata errors\n", __func__);
> > > +		return -EIO;
> > > +	}
> > > +	if (i_size != meta->file_size) {
> > > +		pr_warn("%s: i_size overwritten from %ld to %ld\n",
> > > +		       __func__, meta->file_size, i_size);
> > > +		meta->error = true;
> > > +		return -ENXIO;
> > > +	}
> > >  	if (!IS_DAX(inode)) {
> > > -		pr_debug("%s: inode %llx IS_DAX is false\n",
> > > -			 __func__, (u64)inode);
> > > +		pr_debug("%s: inode %llx IS_DAX is false\n", __func__, (u64)inode);
> > >  		return -ENXIO;
> > >  	}
> > >  	return 0;
> > > @@ -233,7 +555,7 @@ const struct file_operations famfs_file_operations = {
> > >  	/* Custom famfs operations */
> > >  	.write_iter	   = famfs_dax_write_iter,
> > >  	.read_iter	   = famfs_dax_read_iter,
> > > -	.unlocked_ioctl    = NULL /*famfs_file_ioctl*/,
> > > +	.unlocked_ioctl    = famfs_file_ioctl,
> > >  	.mmap		   = famfs_file_mmap,
> > > 
> > 
> > We don't have compat_ioctl handler, a 32-bit application on a 64-bit
> > kernel will get ENOTTY, if we will have that scenario I think the handler
> > should be added.
> > 
> > Best regards,
> > Richard Cheng.
> 
> This one is simple but arcane. Here are the kconfig deps:
> 
> FAMFS -> FS_DAX -> ZONE_DEVICE -> MEMORY_HOTPLUG
> 
> And MEMORY_HOTPLUG is depends on 64BIT. So famfs is definitively 64BIT-only.
> 
> In this series I added a direct dependency on 64BIT, to make it more 
> clear...

compat_ioctl is for 32-bit programs calling into a 64-bit kernel.

Granted a 32-bit program is probably not a good contender for famfs due
to limited address space, and you could simply declare that you don't
support 32-bit programs.

--D
