Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57F730FC1C;
	Thu, 13 Aug 2026 22:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786658919; cv=none; b=PHztLTtmLrPh86SFC/vtU5nH95k/N4q6dbty5SRKZFmTQlkrJIqAhQ1Xw5MaCbUeyzTGYhIVLSCWCuUFnjwUvm4mij7heLdn0j3UqBr8TxD//FebND9dndOU3tNPOdc1UkyonrW13lcWPmM0Yp4lsLt5cbDv6LBeXObiSwexd9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786658919; c=relaxed/simple;
	bh=rfDqCh0XTkwpFpeshfxTalwfJ53/zCN+FW8Bs0mc2+g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gZw3cJoQ4vKImpWqWkpFnSiHenXlDAYzZh1GFtZHGhUHPRisDjZyf01u1UAy8fibAUAr7Sg3qEN9T+KrwJS+wolDjs3N6vw8N6ha38mpJvtd8tZb4/dvXkYhVwqtwhVANCyhRr7Sz/IsmFpITkox9eO64D7hEN1X+l6A1vZotHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQ1JUzdk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQ1JUzdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F58E1F000E9;
	Thu, 13 Aug 2026 22:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786658917;
	bh=i0S/3ESuepP5OdidFiY+t4UP7mQlCDqOEdqCxdeN3KE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hQ1JUzdkd/pvs3Eju5udtKpUgMiJdxLWH8MRAaUwz6vIsQG82moCkRR08AhGZOYGY
	 fTI9XpH87glFemtVg5BkXCuq7SUv1fB880pYH0OeyGp1uLJqkC62MYPglBQjJ9JqeX
	 UM/s9tb4/F8x+HICsREY8ZDGh3Au0SwoW/LAyjm+/udwI6/EGOiZFzy0yNQNINYiOI
	 p4IPcg/E/cWyCVYiZSu8riiIH4wU9rx+1+px1KMj2Hd/HjUBJI2EY9CiY8qaXvF9mm
	 pJlnLoTby62xCykaCRRH2sGl95VsCtl6YeJNXuUgt+k1qWPVHRE6MBEIUeY0GU6pPB
	 RFYPXL7tUAnPw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V8 04/10] famfs_fuse: Create files with famfs fmaps
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <0100019d063ff336-a7f1bca1-63b7-497c-93dc-69155efd8a68-000000@email.amazonses.com>
References: <0100019d063ff336-a7f1bca1-63b7-497c-93dc-69155efd8a68-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 13 Aug 2026 22:08:33 +0000
Message-Id: <20260813220837.3F58E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:
- [High] Integer overflow and undefined behavior when calculating `dev_bitm=
ap` with a 32-bit signed shift.
- [High] Recursive `inode_lock()` deadlock on `O_TRUNC` file open.
- [Medium] Data truncation of file size and mapping size on 32-bit architec=
tures.
- [Medium] Dynamic toggling of `S_DAX` flag introduces a data race and viol=
ates VFS caching invariants.
- [Low] Dangling pointer window in `famfs_meta_free` due to incorrect clean=
up ordering.
- [Low] Meaningless local `cmpxchg` race check acts as dead code.
- [Low] Uninitialized variable accessed and printed in error message.
- [Low] Implicit cast of untrusted UAPI enum to internal enum.
--

--- Patch [4]: [PATCH V8 04/10] famfs_fuse: Create files with famfs fmaps -=
--
commit 588d2cb1a397d88983186c80e9fec874ef42a12e
Author: John Groves <john@groves.net>

famfs_fuse: Create files with famfs fmaps

This patch introduces the ability to allocate and initialize in-memory famfs
file metadata mapped to DAX memory. It adds structures for resolving file
maps and sets up the initialization path based on FUSE GET_FMAP responses.

> --- a/fs/fuse/famfs.c
> +++ b/fs/fuse/famfs.c

[ ... ]

> +static int
> +famfs_fuse_meta_alloc(
> +	void *fmap_buf,
> +	size_t fmap_buf_size,
> +	struct famfs_file_meta **metap)
> +{
> +	struct fuse_famfs_fmap_header *fmh;

[ ... ]

> +	meta->error =3D false;
> +	meta->file_type =3D fmh->file_type;
> +	meta->file_size =3D fmh->file_size;

[Severity: Medium]
Does this truncate the file size on 32-bit architectures?

The FUSE protocol correctly provides this as a 64-bit value, but the
famfs_file_meta structure declares file_size as a size_t. On 32-bit systems,
size_t is a 32-bit unsigned integer.

Any file size larger than 4GB will be silently truncated when assigned here,
which will later result in incorrect sizes passed to i_size_write().

> +	meta->fm_extent_type =3D fmh->ext_type;

[Severity: Low]
Is it safe to directly assign this FUSE UAPI enum to the internal kernel
enum?

The code assigns a UAPI uint32_t (enum famfs_ext_type) directly to a
kernel internal enum famfs_extent_type. While the integer values currently
align identically, this bypasses type safety and will fail silently if the
enumerated types ever diverge.

> +
> +	switch (fmh->ext_type) {
> +	case FUSE_FAMFS_EXT_SIMPLE: {
> +		struct fuse_famfs_simple_ext *se_in;

[ ... ]

> +		for (i =3D 0; i < fmh->nextents; i++) {
> +			meta->se[i].dev_index  =3D se_in[i].se_devindex;
> +			meta->se[i].ext_offset =3D se_in[i].se_offset;
> +			meta->se[i].ext_len    =3D se_in[i].se_len;
> +
> +			/* Record bitmap of referenced daxdev indices */
> +			meta->dev_bitmap |=3D (1 << meta->se[i].dev_index);

[Severity: High]
Can this shift operation invoke undefined behavior or corrupt the bitmap?

The FUSE server provides a dev_index which is used to set a bit in a 64-bit
bitmap. Because 1 is a signed 32-bit integer literal, a dev_index of 31
results in a negative value that sign-extends to 0xFFFFFFFF80000000 when
promoted to u64, incorrectly setting bits 32-63.

If dev_index is 32 or greater, the shift invokes undefined behavior. Using
1ULL would prevent this.

> +
> +			errs +=3D famfs_check_ext_alignment(&meta->se[i]);
> +
> +			extent_total +=3D meta->se[i].ext_len;
> +		}
> +		break;
> +	}
> +
> +	case FUSE_FAMFS_EXT_INTERLEAVE: {

[ ... ]

> +		for (i =3D 0; i < niext; i++) {
> +			u64 nstrips;
> +			struct fuse_famfs_simple_ext *sie_in;
> +
> +			/* ie_in =3D one interleaved extent in fmap_buf */
> +			ie_in =3D fmap_buf + next_offset;
> +
> +			/* Move past one interleaved extent header in fmap_buf */
> +			next_offset +=3D sizeof(*ie_in);
> +			if (next_offset > fmap_buf_size) {
> +				pr_err("%s:%d: fmap_buf underflow offset/size %ld/%ld\n",
> +				       __func__, __LINE__, next_offset,
> +				       fmap_buf_size);
> +				return -EINVAL;
> +			}
> +
> +			if (!IS_ALIGNED(ie_in->ie_chunk_size, PMD_SIZE)) {
> +				pr_err("%s: chunk_size %lld not PMD-aligned\n",
> +				       __func__, meta->ie[i].fie_chunk_size);

[Severity: Low]
Does this error message print an uninitialized value?

During the interleaved extent alignment checks, if ie_chunk_size is not
PMD-aligned, the error message attempts to log meta->ie[i].fie_chunk_size.

However, this field has not yet been assigned from the FUSE payload. The
assignment happens several lines below this check, so this will print 0
instead of the actual invalid chunk size.

> +				return -EINVAL;
> +			}

[ ... ]

> +			/* Inner loop is over strips */
> +			for (j =3D 0; j < nstrips; j++) {
> +				struct famfs_meta_simple_ext *strips_out;
> +				u64 devindex =3D sie_in[j].se_devindex;
> +				u64 offset   =3D sie_in[j].se_offset;
> +				u64 len      =3D sie_in[j].se_len;
> +
> +				strips_out =3D meta->ie[i].ie_strips;
> +				strips_out[j].dev_index  =3D devindex;
> +				strips_out[j].ext_offset =3D offset;
> +				strips_out[j].ext_len    =3D len;
> +
> +				/* Record bitmap of referenced daxdev indices */
> +				meta->dev_bitmap |=3D (1 << devindex);

[Severity: High]
As above, can this shift operation invoke undefined behavior or corrupt the
bitmap if devindex is 32 or greater?

> +
> +				extent_total +=3D len;
> +				errs +=3D famfs_check_ext_alignment(&strips_out[j]);
> +				size_remainder -=3D len;
> +			}
> +		}

[ ... ]

> +	if (cmpxchg(metap, NULL, meta) !=3D NULL) {
> +		pr_debug("%s: fmap race detected\n", __func__);
> +		return 0; /* fmap already installed */
> +	}

[Severity: Low]
Does this cmpxchg check accomplish its intended race detection?

The metap argument points to a purely local stack variable inside the caller
famfs_file_init_dax(). Since this variable is completely local to the
thread, the cmpxchg will always succeed.

This makes the race detection dead code. The actual functional race check
correctly occurs later via famfs_meta_set().

> +	retain_and_null_ptr(meta);
> +
> +	return 0;
> +}
> +
> +/**
> + * famfs_file_init_dax() - init famfs dax file metadata

[ ... ]

> +int
> +famfs_file_init_dax(
> +	struct fuse_mount *fm,
> +	struct inode *inode,
> +	void *fmap_buf,
> +	size_t fmap_size)
> +{
> +	struct fuse_inode *fi =3D get_fuse_inode(inode);
> +	struct famfs_file_meta *meta =3D NULL;
> +	int rc;

[ ... ]

> +	rc =3D famfs_fuse_meta_alloc(fmap_buf, fmap_size, &meta);
> +	if (rc)
> +		goto errout;
> +
> +	/* Publish the famfs metadata on fi->famfs_meta */
> +	inode_lock(inode);

[Severity: High]
Could this unconditional lock acquisition cause an A-A self-deadlock?

When a file is opened with O_TRUNC and writeback caching is enabled, the
fuse_open() path acquires the inode_lock to perform truncation.

If the filesystem is mounted with famfs iomap support, the open path calls
fuse_get_fmap(), which in turn calls famfs_file_init_dax().

This function unconditionally calls inode_lock() again to install the
metadata. Since the same thread already holds the lock, it will deadlock.

> +
> +	if (famfs_meta_set(fi, meta) =3D=3D NULL) {
> +		i_size_write(inode, meta->file_size);
> +		inode->i_flags |=3D S_DAX;

[Severity: Medium]
Is it safe to dynamically toggle the DAX flag on an active inode?

This modifies the flags using a read-modify-write without the standard
inode_set_flags() helper.

More importantly, changing S_DAX after an inode has been instantiated
breaks VFS invariants. If page cache pages were populated prior to this
flag change, subsequent I/O will use DAX paths while stale page cache pages
remain, potentially triggering VM_BUG_ON or silent data corruption.

> +	} else {
> +		pr_debug("%s: file already had metadata\n", __func__);
> +		__famfs_meta_free(meta);
> +		/* rc is 0 - the file is valid */
> +	}
> +
> +	inode_unlock(inode);
> +	return 0;

[ ... ]

> --- /dev/null
> +++ b/fs/fuse/famfs_kfmap.h
> @@ -0,0 +1,67 @@

[ ... ]

> +/*
> + * Each famfs dax file has this hanging from its fuse_inode->famfs_meta
> + */
> +struct famfs_file_meta {
> +	bool                   error;
> +	enum famfs_file_type   file_type;
> +	size_t                 file_size;

[Severity: Medium]
Should this be a u64 or loff_t?

As mentioned earlier, declaring file_size as a size_t on 32-bit systems
limits it to a 32-bit unsigned integer, causing truncation for files
larger than 4GB.

> +	enum famfs_extent_type fm_extent_type;
> +	u64 dev_bitmap; /* bitmap of referenced daxdevs by index */

[ ... ]

> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -1642,6 +1642,9 @@ extern void fuse_sysctl_unregister(void);
>  /* famfs.c */
> =20
>  #if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)

[ ... ]

>  static inline void famfs_meta_free(struct fuse_inode *fi)
>  {
> -	famfs_meta_set(fi, NULL);
> +	if (fi->famfs_meta !=3D NULL) {
> +		__famfs_meta_free(fi->famfs_meta);
> +		famfs_meta_set(fi, NULL);
> +	}
>  }

[Severity: Low]
Does this create a dangling pointer window?

The metadata memory is freed via __famfs_meta_free() before the pointer
is nullified by famfs_meta_set().

While this occurs during inode eviction where concurrency is limited, it
creates a brief use-after-free window and breaks the expected safety
guarantees of a cleanup helper. Reversing the order would be safer.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260318203054.4344=
.fuse@groves.net?part=3D4
