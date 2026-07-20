Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A2D2E62B3;
	Mon, 20 Jul 2026 03:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784519989; cv=none; b=B3jPL5h8M0eHW+bXJL9uFocOYEJx+ea25LDZpkjIPUnNsJX9Pdy4xsow0BNj9mSrcc1f9NtFUD2Efjeg6YTc97ldDYeoTmiot4x8QoIGq72uvDya0PCWXZUilWq409BYMwTkp1//jfQjXKUdFoUexlvm6LZ+SBT3xCctyim8w0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784519989; c=relaxed/simple;
	bh=suP9phJOtkRNZmQBS5n7Y4F/PetVyMOwOc9xZr62waw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iH6DhxPtQRuPawbonrWyeaxItj3YPbfTRb/35UCvfAxG/YDpw3kFAEugme22BqnZyxMq0pMYhRgoE3mcgLP9i5F28eIheq4/dPEJoVqBT7z7ltQ3yyT6/bElCQAnVCZpdSJIHdwS2olW1Kqp6nwr758ykOuCVyUioHJ6nKUmLEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AcGBVPzZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AcGBVPzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBFA1F000E9;
	Mon, 20 Jul 2026 03:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784519987;
	bh=Is6uVOPHI3S1LTVsEalhveXaEtJ+ThxDXMEMjY7neOw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AcGBVPzZTBfhDRwUi4k2U+5DkuQ0FPZqvCMl+aHZThh85ocTUZGJribegBxEUJ/z7
	 YfBsSBatM2AWw5VF5I+/5npXIqOWNGz4yZd3XBNCgztDn2Bp/ypzIE+Sa3a2IunWx7
	 +l4N5E1GXEGbO9AhImDru/hG9OMmAr8PD5fsLhFVn7G0mnvn4TUrebihdqHYMSwZbq
	 fAi2UWklt8cV7NweZ9ySKhFby+sUSxLSEXD2ft6e4JtkZwAAlKhjgrBKHsbpjmOsZt
	 l+1d8aZ5rXz9zNfC7hixrHtRTHyEYOaAdo63ksH29aQniWtARGVgKlbOUub7ya8ja3
	 UlTNO0Ozq1B5g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V11 4/9] famfs_fuse: Create files with famfs fmaps
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <0100019f7da174eb-4cd0f3ae-59da-4533-b469-6eee009a22bd-000000@email.amazonses.com>
References: <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
 <20260720034553.68798-1-john@jagalactic.com>
 <0100019f7da174eb-4cd0f3ae-59da-4533-b469-6eee009a22bd-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 03:59:46 +0000
Message-Id: <20260720035947.3CBFA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [High] File size and extent lengths are truncated to 32 bits on 32-bit ar=
chitectures, leading to file size corruption and validation bypass.
- [High] Premature publication of DAX metadata allows concurrent threads to=
 observe an incomplete initialization state.
- [High] Modifying `inode->i_flags` directly with bitwise operations bypass=
es the required `inode->i_lock` spinlock, causing lost updates.
- [Medium] Unvalidated FUSE server input passed directly to `BIT_ULL()` cau=
ses a shift-out-of-bounds, leading to Undefined Behavior.
- [Medium] The `famfs_file_meta` and its extent array are allocated without=
 `__GFP_ACCOUNT`, allowing unbounded kernel memory consumption.
- [Low] `famfs_meta_set()` incorrectly returns `struct fuse_backing *` inst=
ead of `void *`.
- [Low] Ineffective concurrency check using `cmpxchg()` on a local stack va=
riable.
--

--- Patch [4]: [PATCH V11 4/9] famfs_fuse: Create files with famfs fmaps ---
commit 293d4aeecd8b2f11982375cde3643693ae41f5d0
Author: John Groves <john@groves.net>

famfs_fuse: Create files with famfs fmaps

This commit interprets the fmap retrieved by GET_FMAP into the in-memory
metadata that later patches use to resolve read/write/mmap directly to dax.
It adds the fmap wire format, in-memory structures, and metadata
allocation logic.

> diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
> index 80e6640ac970b..8f7ee7d6151bb 100644
> --- a/fs/fuse/famfs.c
> +++ b/fs/fuse/famfs.c
[ ... ]
> @@ -14,13 +14,244 @@
[ ... ]
> +	struct famfs_file_meta *meta __free(__famfs_meta_free) =3D kzalloc(size=
of(*meta), GFP_KERNEL);

[Severity: Medium]
Is it intentional to omit the __GFP_ACCOUNT flag here? A single DAX file can
have up to 32,768 extents, and unprivileged containerized processes could
repeatedly open FUSE DAX files to trigger these allocations. Adding
__GFP_ACCOUNT would ensure these allocations are charged to the memory cgro=
up.

> +
> +	if (!meta)
> +		return -ENOMEM;
> +
> +	meta->error =3D false;
> +	meta->file_type =3D fmh->file_type;
> +	meta->file_size =3D fmh->file_size;
> +
> +	switch (fmh->ext_type) {
> +	case FUSE_FAMFS_EXT_SIMPLE: {
> +		struct fuse_famfs_simple_ext *se_in;
> +
> +		se_in =3D fmap_buf + next_offset;
> +
> +		/* Move past simple extents */
> +		next_offset +=3D fmh->nextents * sizeof(*se_in);
> +		if (next_offset > fmap_buf_size) {
> +			pr_err("%s:%d: fmap_buf underflow offset/size %ld/%ld\n",
> +			       __func__, __LINE__, next_offset, fmap_buf_size);
> +			return -EINVAL;
> +		}
> +
> +		meta->fm_nextents =3D fmh->nextents;
> +
> +		meta->se =3D kcalloc(meta->fm_nextents, sizeof(*(meta->se)),
> +				   GFP_KERNEL);

[Severity: Medium]
Should this variable-length extent array allocation also include the
__GFP_ACCOUNT flag? It could consume substantial memory per file.

> +		if (!meta->se)
> +			return -ENOMEM;
> +
> +		for (i =3D 0; i < fmh->nextents; i++) {
> +			meta->se[i].dev_index  =3D se_in[i].se_devindex;
> +			meta->se[i].ext_offset =3D se_in[i].se_offset;
> +			meta->se[i].ext_len    =3D se_in[i].se_len;
> +
> +			/* Record bitmap of referenced daxdev indices */
> +			meta->dev_bitmap |=3D BIT_ULL(meta->se[i].dev_index);

[Severity: Medium]
Could this trigger a shift-out-of-bounds if the FUSE server provides a
dev_index >=3D 64? There doesn't appear to be a bounds check on
se_in[i].se_devindex prior to this bitwise shift operation.

[ ... ]
> +	/* More sanity checks */
> +	if (extent_total < meta->file_size) {
> +		pr_err("%s: file size %ld larger than map size %ld\n",
> +		       __func__, meta->file_size, extent_total);
> +		return -EINVAL;
> +	}

[Severity: High]
Can this comparison bypass validation on 32-bit architectures? In
struct famfs_file_meta, file_size is defined as a size_t, which is 32 bits
on those systems. The FUSE wire format provides it as a 64-bit integer,
so any file size > 4GB could be silently truncated. Would it be better
to declare file_size as a 64-bit type like loff_t or u64?

> +
> +	if (cmpxchg(metap, NULL, meta) !=3D NULL) {
> +		pr_debug("%s: fmap race detected\n", __func__);
> +		return 0; /* fmap already installed */
> +	}

[Severity: Low]
Is this race detection effective here? metap points to the local stack vari=
able
declared as struct famfs_file_meta *meta =3D NULL; in famfs_file_init_dax().
Because it is an unshared local variable, the cmpxchg will always succeed,
rendering this branch dead code.

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
> +
> +	if (fi->famfs_meta) {
> +		pr_notice("%s: i_no=3D%llu fmap_size=3D%zu ALREADY INITIALIZED\n",
> +			  __func__,
> +			  inode->i_ino, fmap_size);
> +		return 0;
> +	}

[Severity: High]
Can concurrent threads observe an incomplete initialization state here?

If thread A publishes the metadata pointer via famfs_meta_set() but has
not yet fully initialized i_size and S_DAX, thread B could evaluate
fi->famfs_meta as true and immediately return.

Thread B might then proceed to read() and locklessly evaluate IS_DAX(inode)
as false, falling back to the non-DAX page cache path.

[ ... ]
> +	/* Publish the famfs metadata on fi->famfs_meta */
> +	inode_lock(inode);
> +
> +	if (famfs_meta_set(fi, meta) =3D=3D NULL) {
> +		i_size_write(inode, meta->file_size);
> +		inode->i_flags |=3D S_DAX;

[Severity: High]
Can this direct bitwise modification of inode->i_flags cause lost updates?

The modification is performed without holding inode->i_lock. Since FUSE
can concurrently modify i_flags in fuse_change_attributes_common() while
holding fi->lock, this could result in a data race.

Should this use inode_set_flags() or set_mask_bits() instead?

> diff --git a/fs/fuse/famfs_kfmap.h b/fs/fuse/famfs_kfmap.h
> index 0000000000000..d87b065e8ac83
> --- /dev/null
> +++ b/fs/fuse/famfs_kfmap.h
[ ... ]
> +struct famfs_file_meta {
> +	bool                   error;
> +	enum famfs_file_type   file_type;
> +	size_t                 file_size;

[Severity: High]
Does this type cause truncation on 32-bit systems? The FUSE wire format
struct fuse_famfs_fmap_header provides file_size as a uint64_t, but size_t
is 32 bits on 32-bit architectures.

> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 5bacc50986203..46a7040b38dc4 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
[ ... ]
> @@ -1364,7 +1367,10 @@ static inline struct fuse_backing *famfs_meta_set(=
struct fuse_inode *fi,

[Severity: Low]
Does famfs_meta_set() return the wrong type? It is declared to return a
struct fuse_backing *, but cmpxchg(&fi->famfs_meta, NULL, meta) returns a
void *.

> =20
>  static inline void famfs_meta_free(struct fuse_inode *fi)
>  {
> -	famfs_meta_set(fi, NULL);
> +	if (fi->famfs_meta !=3D NULL) {
> +		__famfs_meta_free(fi->famfs_meta);
> +		WRITE_ONCE(fi->famfs_meta, NULL);
> +	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019f7d9fbe81-6c=
b16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com?part=3D4
