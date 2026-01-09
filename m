Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F137A13A
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 14:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767969047; cv=none; b=X9i2DUidv/SULbpu3a3H57atihTuMyd2GDMyc34XhIst3g7gHYfvFD4mkFg9SdO3K/2WhmhrBOzxQxTJJgF7fEEJMg9QoF9i3bC/BKIKDMbolFwyoHu20Y30o2m+OQGjsWFPGzHoXeyt0eWW6EHAYaJmHBQCcABmFfUxd28r5Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767969047; c=relaxed/simple;
	bh=vSmoqaySVsgpjPHJZa4uQCQy1ps6mpAk+kz/vE/rfQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N6hWzFweAQIff7YlgNZEezHubPRbPZoZlfMi9mqbJueDo55tcAVj4/ixia6iwi4aLel52TLvJq1oATLNJnL3Vr5KCOVFsTEoPxEUOFPnwZYmrY4Sqv0JhZEOUKJgPn1RfLWkV+ehGvUCKiqP8zJK0X159zCdROVzfenuauXsXSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l+D5mx2A; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l+D5mx2A"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-3e7f68df436so2215108fac.1
        for <nvdimm@lists.linux.dev>; Fri, 09 Jan 2026 06:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767969044; x=1768573844; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/+b/pbin5O15LPdeXGYj8QlsRQG4OrGA/20XlRHryOQ=;
        b=l+D5mx2AcmcjRwqmVwxQnIHDUdCkc5Baf05pnw4uo1VJXsnxFToX68TsKTWRHybeOu
         7nlT6zw5JfXXyUYtjRb3e5L9LIWG0Qug7yfc+SJ/M3Jqyas5C9eqptaBwO49GzT/s6kl
         pclkwlNIuVVI0KHqMZwDkr6E3E3LlAEb3449NtNArS4Yx9dqVO6u35noNrtarfr0E72u
         4oeGkrgsI43UKBOMALh+WUtzbKPmo3dvgf0IVFJE/8QMKKJseyNGC15n1fJhnSY+B33d
         q0Fpd/DbgmNMlvZq6H3Xj3/syKf0+AVzGyU5aDFLxL0Q/bsyaUl15eQRjHZiC8m0WvFk
         s2WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767969044; x=1768573844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/+b/pbin5O15LPdeXGYj8QlsRQG4OrGA/20XlRHryOQ=;
        b=ipBTQkG/GoPVrU9sP8FiAHQPzEznXBg6wubM475Wti5Xner4/XKl1JOlhtcIfwCJBj
         +D4V/as27fkU0HtOzzjP6CYBTmSU6LgV5hY+HFYjTfTJR9kmX1Q+x5TEjV91IMRZfW7f
         41Z+4j/RlctNQMZ0gfBRuMoJlLCRRclEMXzUjiky8NyDu4IMEgoNXu+FXkG4F/aTfYDl
         tMgYsc82zVUswP2ej5wFg9cscrTmDOZAmWyaowgQvm2AQQ3m5Uk+OPbtzdGCJcwCtF32
         F6yd1Fi1fUJagwC2sMsfocRXZGJ4oNBSdotirX2C81YRG9f6xrHO50u5/QvjdXyemTH2
         stEg==
X-Forwarded-Encrypted: i=1; AJvYcCUMsZuuMtLx8JsoA71CcH4BT7tq5Gbx4oE3zz2igoEQLmnf+n08yipbkxuH+8bRJEwu+3htxy0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxF+FRT445HqND1dO01rZSdtmaT5YVsZykX1Rj/aZ4VYa4XP54q
	gPmeVsjv8Rh5pj0IrMFgldsqFnCkbGNctkyvwDfQkwT2AeulVHpuHBau
X-Gm-Gg: AY/fxX7AwlOAVO2uqeJVtxChp4aBsOe8J6UrsqtVpNicU0X+ZkhdxTRdxk7/BqnwngI
	nCa9Gz02cHETay3wgYyP7e6DdvhB83it+HnuUpzVWVmsN39s8Q8sBRua6AcYPgUenY08gtfGrL8
	gdPd8uIk4c1dtrq8NnNY9wMfa87RuuFw9Yrc6ZaDMZvSh4XplcWe3OPceTL32qGs2MG6Xpw+m2E
	OR3G3jyi0tc+3s+9j9W/lkTAoIrWqgN2HVb8d18eem9WicC0+q0mtecBl0iEUg/SlQmAtvXaSFg
	OcUpwo78WqSgsL8gnAn3Qeg/7sIeX6g5Bhvis1IDosc+/MxmsW0l0Gp0/mFHLKmVPNb7EkiZCaf
	ZjlD1wP2nhFQzlApsU86ZbWDGci8wXNdrVYLC0pJzZYoGzdCfVM31QtPoAXupZwZ1vw4oRmVli5
	+KkN8ymtSaa3zvyWt1wKwdcnHvkADJ/w==
X-Google-Smtp-Source: AGHT+IElG0AH+R/nz4iIoI5x/T09BXi9JWxi51uu3GRk0Q9RVWgdDkzftBBm8jsoFHiLP76eqmw9mw==
X-Received: by 2002:a05:6870:1753:b0:3e0:c368:e1cb with SMTP id 586e51a60fabf-3ffbf035077mr6307624fac.14.1767969043388;
        Fri, 09 Jan 2026 06:30:43 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:184d:823f:1f40:e229])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4e3e844sm7223039fac.9.2026.01.09.06.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 06:30:42 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Fri, 9 Jan 2026 08:30:39 -0600
From: John Groves <John@groves.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V3 15/21] famfs_fuse: Create files with famfs fmaps
Message-ID: <7jcdlgo7nddrm7phuhj37q2cwgmdal2es6qgswu4fu5sgpgc7v@dt7ltedbjhkq>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-16-john@groves.net>
 <20260108131400.000017f5@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108131400.000017f5@huawei.com>

On 26/01/08 01:14PM, Jonathan Cameron wrote:
> On Wed,  7 Jan 2026 09:33:24 -0600
> John Groves <John@Groves.net> wrote:
> 
> > On completion of GET_FMAP message/response, setup the full famfs
> > metadata such that it's possible to handle read/write/mmap directly to
> > dax. Note that the devdax_iomap plumbing is not in yet...
> > 
> > * Add famfs_kfmap.h: in-memory structures for resolving famfs file maps
> >   (fmaps) to dax.
> > * famfs.c: allocate, initialize and free fmaps
> > * inode.c: only allow famfs mode if the fuse server has CAP_SYS_RAWIO
> > * Update MAINTAINERS for the new files.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> 
> > diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
> > index 0f7e3f00e1e7..2aabd1d589fd 100644
> > --- a/fs/fuse/famfs.c
> > +++ b/fs/fuse/famfs.c
> > @@ -17,9 +17,355 @@
> >  #include <linux/namei.h>
> >  #include <linux/string.h>
> >  
> > +#include "famfs_kfmap.h"
> >  #include "fuse_i.h"
> >  
> >  
> > +/***************************************************************************/
> Who doesn't like stars?  Why have them here?
> 
> > +
> > +void
> > +__famfs_meta_free(void *famfs_meta)
> 
> Maybe a local convention, but if not one line.
> Same for other cases.

Done

> 
> > +{
> > +	struct famfs_file_meta *fmap = famfs_meta;
> > +
> > +	if (!fmap)
> > +		return;
> > +
> > +	if (fmap) {
> 
> Well that's never going to fail given 2 lines above.

Good eye. Thanks.

> 
> 
> > +		switch (fmap->fm_extent_type) {
> > +		case SIMPLE_DAX_EXTENT:
> > +			kfree(fmap->se);
> > +			break;
> > +		case INTERLEAVED_EXTENT:
> > +			if (fmap->ie)
> > +				kfree(fmap->ie->ie_strips);
> > +
> > +			kfree(fmap->ie);
> > +			break;
> > +		default:
> > +			pr_err("%s: invalid fmap type\n", __func__);
> > +			break;
> > +		}
> > +	}
> > +	kfree(fmap);
> > +}
> 
> > +/**
> > + * famfs_fuse_meta_alloc() - Allocate famfs file metadata
> > + * @metap:       Pointer to an mcache_map_meta pointer
> > + * @ext_count:  The number of extents needed
> 
> run kernel-doc over the file as that's not the parameters...

Not sure how I managed that; Fixed, thanks!

> 
> > + *
> > + * Returns: 0=success
> > + *          -errno=failure
> > + */
> > +static int
> > +famfs_fuse_meta_alloc(
> > +	void *fmap_buf,
> > +	size_t fmap_buf_size,
> > +	struct famfs_file_meta **metap)
> > +{
> > +	struct famfs_file_meta *meta = NULL;
> > +	struct fuse_famfs_fmap_header *fmh;
> > +	size_t extent_total = 0;
> > +	size_t next_offset = 0;
> > +	int errs = 0;
> > +	int i, j;
> > +	int rc;
> > +
> > +	fmh = (struct fuse_famfs_fmap_header *)fmap_buf;
> 
> void * so cast not needed and hence just assign it at the
> declaration.

Indeed, thanks.

> 
> > +
> > +	/* Move past fmh in fmap_buf */
> > +	next_offset += sizeof(*fmh);
> > +	if (next_offset > fmap_buf_size) {
> > +		pr_err("%s:%d: fmap_buf underflow offset/size %ld/%ld\n",
> > +		       __func__, __LINE__, next_offset, fmap_buf_size);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (fmh->nextents < 1) {
> > +		pr_err("%s: nextents %d < 1\n", __func__, fmh->nextents);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (fmh->nextents > FUSE_FAMFS_MAX_EXTENTS) {
> > +		pr_err("%s: nextents %d > max (%d) 1\n",
> > +		       __func__, fmh->nextents, FUSE_FAMFS_MAX_EXTENTS);
> > +		return -E2BIG;
> > +	}
> > +
> > +	meta = kzalloc(sizeof(*meta), GFP_KERNEL);
> 
> Maybe sprinkle some __free magic on this then you can return in
> all the goto error_out places which to me makes this more readable.


I like it, and I learned how to make __famfs_meta_free() into a
__free() handler.

Done

> 
> > +	if (!meta)
> > +		return -ENOMEM;
> > +
> > +	meta->error = false;
> > +	meta->file_type = fmh->file_type;
> > +	meta->file_size = fmh->file_size;
> > +	meta->fm_extent_type = fmh->ext_type;
> > +
> > +	switch (fmh->ext_type) {
> > +	case FUSE_FAMFS_EXT_SIMPLE: {
> > +		struct fuse_famfs_simple_ext *se_in;
> > +
> > +		se_in = (struct fuse_famfs_simple_ext *)(fmap_buf + next_offset);
> 
> void * so no need for cast. Though you could keep the cast but apply it to
> fmh + 1 to take advantage of that type.

done, thanks

> 
> 
> > +
> > +		/* Move past simple extents */
> > +		next_offset += fmh->nextents * sizeof(*se_in);
> > +		if (next_offset > fmap_buf_size) {
> > +			pr_err("%s:%d: fmap_buf underflow offset/size %ld/%ld\n",
> > +			       __func__, __LINE__, next_offset, fmap_buf_size);
> > +			rc = -EINVAL;
> > +			goto errout;
> > +		}
> > +
> > +		meta->fm_nextents = fmh->nextents;
> > +
> > +		meta->se = kcalloc(meta->fm_nextents, sizeof(*(meta->se)),
> > +				   GFP_KERNEL);
> > +		if (!meta->se) {
> > +			rc = -ENOMEM;
> > +			goto errout;
> > +		}
> > +
> > +		if ((meta->fm_nextents > FUSE_FAMFS_MAX_EXTENTS) ||
> > +		    (meta->fm_nextents < 1)) {
> > +			rc = -EINVAL;
> > +			goto errout;
> > +		}
> > +
> > +		for (i = 0; i < fmh->nextents; i++) {
> > +			meta->se[i].dev_index  = se_in[i].se_devindex;
> > +			meta->se[i].ext_offset = se_in[i].se_offset;
> > +			meta->se[i].ext_len    = se_in[i].se_len;
> > +
> > +			/* Record bitmap of referenced daxdev indices */
> > +			meta->dev_bitmap |= (1 << meta->se[i].dev_index);
> > +
> > +			errs += famfs_check_ext_alignment(&meta->se[i]);
> > +
> > +			extent_total += meta->se[i].ext_len;
> > +		}
> > +		break;
> > +	}
> > +
> > +	case FUSE_FAMFS_EXT_INTERLEAVE: {
> > +		s64 size_remainder = meta->file_size;
> > +		struct fuse_famfs_iext *ie_in;
> > +		int niext = fmh->nextents;
> > +
> > +		meta->fm_niext = niext;
> > +
> > +		/* Allocate interleaved extent */
> > +		meta->ie = kcalloc(niext, sizeof(*(meta->ie)), GFP_KERNEL);
> > +		if (!meta->ie) {
> > +			rc = -ENOMEM;
> > +			goto errout;
> > +		}
> > +
> > +		/*
> > +		 * Each interleaved extent has a simple extent list of strips.
> > +		 * Outer loop is over separate interleaved extents
> > +		 */
> > +		for (i = 0; i < niext; i++) {
> > +			u64 nstrips;
> > +			struct fuse_famfs_simple_ext *sie_in;
> > +
> > +			/* ie_in = one interleaved extent in fmap_buf */
> > +			ie_in = (struct fuse_famfs_iext *)
> > +				(fmap_buf + next_offset);
> 
> void * so no cast needed.

Right, thanks

> 
> > +
> > +			/* Move past one interleaved extent header in fmap_buf */
> > +			next_offset += sizeof(*ie_in);
> > +			if (next_offset > fmap_buf_size) {
> > +				pr_err("%s:%d: fmap_buf underflow offset/size %ld/%ld\n",
> > +				       __func__, __LINE__, next_offset,
> > +				       fmap_buf_size);
> > +				rc = -EINVAL;
> > +				goto errout;
> > +			}
> > +
> > +			nstrips = ie_in->ie_nstrips;
> > +			meta->ie[i].fie_chunk_size = ie_in->ie_chunk_size;
> > +			meta->ie[i].fie_nstrips    = ie_in->ie_nstrips;
> > +			meta->ie[i].fie_nbytes     = ie_in->ie_nbytes;
> > +
> > +			if (!meta->ie[i].fie_nbytes) {
> > +				pr_err("%s: zero-length interleave!\n",
> > +				       __func__);
> > +				rc = -EINVAL;
> > +				goto errout;
> > +			}
> > +
> > +			/* sie_in = the strip extents in fmap_buf */
> > +			sie_in = (struct fuse_famfs_simple_ext *)
> > +				(fmap_buf + next_offset);
> no cast needed.

Done, thanks

> 
> > +
> > +			/* Move past strip extents in fmap_buf */
> > +			next_offset += nstrips * sizeof(*sie_in);
> > +			if (next_offset > fmap_buf_size) {
> > +				pr_err("%s:%d: fmap_buf underflow offset/size %ld/%ld\n",
> > +				       __func__, __LINE__, next_offset,
> > +				       fmap_buf_size);
> > +				rc = -EINVAL;
> > +				goto errout;
> > +			}
> > +
> > +			if ((nstrips > FUSE_FAMFS_MAX_STRIPS) || (nstrips < 1)) {
> > +				pr_err("%s: invalid nstrips=%lld (max=%d)\n",
> > +				       __func__, nstrips,
> > +				       FUSE_FAMFS_MAX_STRIPS);
> > +				errs++;
> > +			}
> > +
> > +			/* Allocate strip extent array */
> > +			meta->ie[i].ie_strips = kcalloc(ie_in->ie_nstrips,
> > +					sizeof(meta->ie[i].ie_strips[0]),
> > +							GFP_KERNEL);
> 
> Align all lines after 1st one to same point.

Yeah

> 
> ...
> 
> > +
> > +/**
> > + * famfs_file_init_dax() - init famfs dax file metadata
> > + *
> > + * @fm:        fuse_mount
> > + * @inode:     the inode
> > + * @fmap_buf:  fmap response message
> > + * @fmap_size: Size of the fmap message
> > + *
> > + * Initialize famfs metadata for a file, based on the contents of the GET_FMAP
> > + * response
> > + *
> > + * Return: 0=success
> > + *          -errno=failure
> > + */
> > +int
> > +famfs_file_init_dax(
> > +	struct fuse_mount *fm,
> > +	struct inode *inode,
> > +	void *fmap_buf,
> > +	size_t fmap_size)
> > +{
> > +	struct fuse_inode *fi = get_fuse_inode(inode);
> > +	struct famfs_file_meta *meta = NULL;
> > +	int rc = 0;
> 
> Always set before use.

Roger that - and it went away with the __free thingy anyway

> 
> > +
> > +	if (fi->famfs_meta) {
> > +		pr_notice("%s: i_no=%ld fmap_size=%ld ALREADY INITIALIZED\n",
> > +			  __func__,
> > +			  inode->i_ino, fmap_size);
> > +		return 0;
> > +	}
> > +
> > +	rc = famfs_fuse_meta_alloc(fmap_buf, fmap_size, &meta);
> > +	if (rc)
> > +		goto errout;
> > +
> > +	/* Publish the famfs metadata on fi->famfs_meta */
> > +	inode_lock(inode);
> > +	if (fi->famfs_meta) {
> > +		rc = -EEXIST; /* file already has famfs metadata */
> > +	} else {
> > +		if (famfs_meta_set(fi, meta) != NULL) {
> > +			pr_debug("%s: file already had metadata\n", __func__);
> > +			__famfs_meta_free(meta);
> > +			/* rc is 0 - the file is valid */
> > +			goto unlock_out;
> > +		}
> > +		i_size_write(inode, meta->file_size);
> > +		inode->i_flags |= S_DAX;
> > +	}
> > + unlock_out:
> > +	inode_unlock(inode);
> > +
> > +errout:
> > +	if (rc)
> > +		__famfs_meta_free(meta);
> 
> For readability I'd split he good and bad exit paths even it unlock
> needs to happen in two places.

Done

> 
> 
> > +
> > +	return rc;
> > +}
> > +
> 
> > diff --git a/fs/fuse/famfs_kfmap.h b/fs/fuse/famfs_kfmap.h
> > new file mode 100644
> > index 000000000000..058645cb10a1
> > --- /dev/null
> > +++ b/fs/fuse/famfs_kfmap.h
> > @@ -0,0 +1,67 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * famfs - dax file system for shared fabric-attached memory
> > + *
> > + * Copyright 2023-2025 Micron Technology, Inc.
> > + */
> > +#ifndef FAMFS_KFMAP_H
> > +#define FAMFS_KFMAP_H
> > +
> > +/*
> > + * The structures below are the in-memory metadata format for famfs files.
> > + * Metadata retrieved via the GET_FMAP response is converted to this format
> > + * for use in  resolving file mapping faults.
> 
> bonus space after in

Removed

> 
> > + *
> > + * The GET_FMAP response contains the same information, but in a more
> > + * message-and-versioning-friendly format. Those structs can be found in the
> > + * famfs section of include/uapi/linux/fuse.h (aka fuse_kernel.h in libfuse)
> > + */
> 
> > +/*
> > + * Each famfs dax file has this hanging from its fuse_inode->famfs_meta
> > + */
> > +struct famfs_file_meta {
> > +	bool                   error;
> > +	enum famfs_file_type   file_type;
> > +	size_t                 file_size;
> > +	enum famfs_extent_type fm_extent_type;
> > +	u64 dev_bitmap; /* bitmap of referenced daxdevs by index */
> > +	union { /* This will make code a bit more readable */
> 
> Not sure what the comment is for. I'd drop it.

I'm sure it made sense to me at some point but not now. Gone.

> 
> 
> > +		struct {
> > +			size_t         fm_nextents;
> > +			struct famfs_meta_simple_ext  *se;
> > +		};
> > +		struct {
> > +			size_t         fm_niext;
> > +			struct famfs_meta_interleaved_ext *ie;
> > +		};
> > +	};
> > +};
> > +
> > +#endif /* FAMFS_KFMAP_H */

Thanks!
John
