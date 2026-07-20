Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C5E391838;
	Mon, 20 Jul 2026 03:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784519776; cv=none; b=Y6enYf6hLcmIFHdL49Iv7Cdsdcx1T1Ff/fxdM89fDvdapIElkM9tcWoMfyHhZGv89D/t0qBcK4uAO1C36BceX7p8p3iVL7ikhbZKTvTFDrZpLVKW2i5PaUuVpAoglLDdmvG2TuZA5NjAcL3mUrSsYgfr5jK9X3pVWtb6Qv8Tm3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784519776; c=relaxed/simple;
	bh=K537+4v5xZ+UFttu3Y9zHLdLR2iQf92adR8aYxLJBuQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fkKbGfKlBckaaaA+4XSAAQbg+1VpTYhEW6qX+c/ujQK5MNOIQmImtb8eZG8pCDikwDJ2VFYy856IYcdIYRvKj/BEDIg8nVH5FRdMDhPv9nxw3YBRR5BYALhLeZE+47ue2OFQFYluQoEzVu1sGYv4OK6oBQ7TmLgWU3EmhlrqC7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gqj/c/da; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gqj/c/da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394531F000E9;
	Mon, 20 Jul 2026 03:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784519775;
	bh=6+b7+V+DewtMy8ADgLwDdJ/oemnR1FaN4Py97/lkQW0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gqj/c/da+crxixLIuptUKUCQPPtysh53nVZZ2ae0hxy6/Y7zBG/KuXAffmih+hUe0
	 v8wSA0Yc/6LQ85u0gpzhNSK81pptQrLUWu/pjY9jazm5w0WGwW1wJya/OHw7NDGDIC
	 b1uy3cCneeURT+dpCTx305UMpNr0IdEyIuq7d7S3dh/TFATfXGrsBll0ZZWtN1L1cV
	 +WgVTstenXRr3Vop/Bo4iF/eTKhCZpIt4MChQCJLJ8QVulKx4OpS3VaDtE8BlDrlb2
	 1ohixI9dMoGMSvNx2WW3Kqpa0nf7E+SBI8KQovuad1ORqCy11papncGnLaCZdBs639
	 lHGURGZhk4XCw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V11 3/9] famfs_fuse: Plumb the GET_FMAP message/response
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <0100019f7da14ceb-fbd4edd7-ce17-4770-8c58-1296ad3e3fbe-000000@email.amazonses.com>
References: <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
 <20260720034541.68781-1-john@jagalactic.com>
 <0100019f7da14ceb-fbd4edd7-ce17-4770-8c58-1296ad3e3fbe-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 03:56:14 +0000
Message-Id: <20260720035615.394531F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] famfs_meta_free() fails to free metadata memory and clear the poin=
ter, causing a memory leak, and famfs_meta_set() has an incorrect return ty=
pe.
- [Low] The struct fuse_famfs_fmap_header is incomplete and undefined, caus=
ing a build failure.
- [Low] Lockless read of shared pointer fi->famfs_meta without READ_ONCE().
--

--- Patch [3]: [PATCH V11 3/9] famfs_fuse: Plumb the GET_FMAP message/respo=
nse ---
commit d837c9b994af8cb48d023d1ff3ded4fc24c04e86
Author: John Groves <john@groves.net>

famfs_fuse: Plumb the GET_FMAP message/response
   =20
On completion of an OPEN in famfs mode, issue a GET_FMAP request to the
server to retrieve the file's file-offset-to-dax map (fmap) and cache it
on the fuse_inode (fi->famfs_meta). Once the map is cached, read, write
and mmap are resolved directly to dax with no further upcalls.

> diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
> new file mode 100644
> index 0000000000000..80e6640ac970b
> --- /dev/null
> +++ b/fs/fuse/famfs.c
[ ... ]
> @@ -0,0 +1,134 @@
> +int fuse_get_fmap(struct fuse_mount *fm, struct inode *inode)
> +{
> +	struct fuse_inode *fi =3D get_fuse_inode(inode);
> +	u64 nodeid =3D get_node_id(inode);
> +	size_t bufsize =3D FMAP_BUFSIZE_INIT;
> +	void *fmap_buf =3D NULL;
> +	ssize_t fmap_size;
> +	int attempt;
> +	int rc;
> +
> +	/* Don't retrieve if we already have the famfs metadata */
> +	if (fi->famfs_meta)
            ^^^^^^^^^^^^^^

[Severity: Low]
Does this lockless read need a READ_ONCE() wrapper?  Without it, we might r=
isk
compiler optimization issues, especially since this is a shared pointer that
can be concurrently modified by another thread.

> +		return 0;
> +
> +	/*
> +	 * The fmap size is not known in advance. Start with a modest buffer an=
d,
> +	 * if the server reports (via the returned header's fmap_size) that the
> +	 * whole fmap did not fit, reallocate exactly that size and retry once.
> +	 * The server learns our buffer size from the request's
> +	 * fuse_getxattr_in.size (GETXATTR-style size probe).
> +	 */
> +	for (attempt =3D 0; ; attempt++) {
> +		struct fuse_getxattr_in in =3D { .size =3D bufsize };
> +		struct fuse_famfs_fmap_header *fmh;
> +		u32 required;
> +
> +		FUSE_ARGS(args);
[ ... ]
> +		fmap_size =3D rc;
> +
> +		/* Need at least a header to learn the required size */
> +		if (fmap_size < (ssize_t)sizeof(*fmh)) {
                                          ^^^^^^^^^^^

[Severity: Low]
Will this cause a build failure?  It looks like struct fuse_famfs_fmap_head=
er
is declared as a pointer but never defined anywhere in the source tree, so
its size cannot be evaluated here.

> +			pr_err("%s: short fmap reply %zd\n", __func__, fmap_size);
> +			kvfree(fmap_buf);
> +			return -EIO;
> +		}
> +
> +		fmh =3D fmap_buf;
> +		required =3D fmh->fmap_size;
                             ^^^^^^^^^^^^

[Severity: Low]
this isn't a bug, but similar to the above, this dereference of fmh->fmap_s=
ize
might fail to compile because the struct is incomplete.

[ ... ]
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 9c354118c931e..5bacc50986203 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
[ ... ]
> @@ -1339,4 +1344,59 @@ extern void fuse_sysctl_unregister(void);
> +/* Set fi->famfs_meta iff the current value is NULL */
> +static inline struct fuse_backing *famfs_meta_set(struct fuse_inode *fi,
> +						  void *meta)
> +{
> +	return cmpxchg(&fi->famfs_meta, NULL, meta);
> +}
> +
> +static inline void famfs_meta_free(struct fuse_inode *fi)
> +{
> +	famfs_meta_set(fi, NULL);
        ^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: High]
Does this code leak the metadata?  When called from fuse_free_inode() on in=
ode
teardown to free the metadata, fi->famfs_meta is non-NULL. But famfs_meta_s=
et()
uses cmpxchg() against NULL, so the exchange will fail and the pointer will
never be cleared, bypassing any actual free operation.

Also, famfs_meta_set() returns a struct fuse_backing *, which looks like a
copy-paste error from passthrough code.

> +}
> +
> +static inline int fuse_file_famfs(struct fuse_inode *fi)
> +{
> +	return (READ_ONCE(fi->famfs_meta) !=3D NULL);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019f7d9fbe81-6c=
b16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com?part=3D3
