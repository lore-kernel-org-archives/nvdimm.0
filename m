Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D1F3E314A;
	Thu, 13 Aug 2026 22:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786659690; cv=none; b=mxsRDKLsZse9OYgyLB62hqPjQWKlxhT/xgYF0JUMOyzX5+QShs9hU1SIJiy9LJY/dCwJLf/i0jDZTKrLbgKikOzEj+9ynwIIeC03QOAnGJnrR6UkPlOZcnU5c0nfLZRhWGdF6Xky3p42cWoDzoEZjP6yuioMDLajrKAfW+2Hj14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786659690; c=relaxed/simple;
	bh=cg5gTdCTYqvuADX/Ibhzt6HEUgkaMmQ6c+JRDI/AA9M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CJSjNqpeEmBF2emUC0sOB83rxTkEzxlQZIpov2DZtmRTJHSLX7ocHY9wJqY9lM9CA/z8zsJZuXIMcpZX46FNk/trGUn+jX44avcFA5Y1VW/1sNUa1QOU7uhLQEUjrfoRgCjwlMK2IwuM/QFHnBmFhJ5LTPMu/M1JC0w5R1Oc6sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bmNl+iBa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bmNl+iBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D19F1F000E9;
	Thu, 13 Aug 2026 22:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786659688;
	bh=qpbhhsEo7Vr+c9BGVnpg40QTo/EXkjJIEN8B5UJdaw8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bmNl+iBamXthOCgCg2vOiwzJ+aqklTLRa0IpMCNDd5x74LvPxzanu8OK9qtnwJRqP
	 TbTYjcJoGAlIZgsBqKK2bXd1OLGzzaxXp86SiVf6dZMzVzv5Lr/weIAbX0mT443gh5
	 24TM9mn1NDa8TfNlcmdstUIXNRI8HigReG7tJWazNP0Qi6v6jdeGnLX6yEouvUK02W
	 LczWc6VUO94yJIGCO6qd6chL34vZ7chBrajZbVD4Y6u2CSWTCZjR2SGCqDTg6lJK9N
	 s6c02hCkZjgPZFFWle8Q+onhvif97cA9oOdMCzzxWT2vBpJXfitEtqqTn4hYK/ogQV
	 haCCVDQWidwiQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V8 05/10] famfs_fuse: GET_DAXDEV message and
 daxdev_table
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <0100019d06402f14-3a614309-878f-4837-be72-e36fd75d74f6-000000@email.amazonses.com>
References: <0100019d06402f14-3a614309-878f-4837-be72-e36fd75d74f6-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 13 Aug 2026 22:21:27 +0000
Message-Id: <20260813222128.5D19F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] The FUSE server-provided string daxdev_out.name is not guaranteed =
to be null-terminated, causing out-of-bounds reads.
- [High] An untrusted device index from the FUSE payload is used in a bitwi=
se shift without prior bounds checking, causing Undefined Behavior.
- [High] The return value of famfs_update_daxdev_table() is ignored, allowi=
ng file initialization to proceed with uninitialized DAX devices.
- [Medium] FUSE_GET_DAXDEV ignores the defined input payload struct and inc=
orrectly uses the nodeid field.
- [Medium] Casting u64* to unsigned long* for for_each_set_bit() breaks on =
32-bit big-endian systems.
- [Medium] Unprotected plain read of fc->dax_devlist creates a data race wi=
th its atomic initialization.
--

--- Patch [5]: [PATCH V8 05/10] famfs_fuse: GET_DAXDEV message and daxdev_t=
able ---
commit 5e7c03f2362ee3cfd1a9cae3fbaaaeb19bced93d
Author: John Groves <john@groves.net>

famfs_fuse: GET_DAXDEV message and daxdev_table

The new GET_DAXDEV message/response is added. The famfs_teardown() function=
=20
is added as a primary teardown function for famfs. The command is triggered=
=20
by the update_daxdev_table() call, if there are any daxdevs in the subject=
=20
fmap that are not represented in the daxdev_table yet.

> diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
> index ac52e54e2cb59..0e9415aa63397 100644
> --- a/fs/fuse/famfs.c
> +++ b/fs/fuse/famfs.c
> @@ -21,6 +21,228 @@
[ ... ]
> +static int
> +famfs_fuse_get_daxdev(struct fuse_mount *fm, const u64 index)
> +{
> +	struct fuse_daxdev_out daxdev_out =3D { 0 };
> +	struct fuse_conn *fc =3D fm->fc;
> +	struct famfs_daxdev *daxdev;
> +	int rc;
> +
> +	FUSE_ARGS(args);
> +
> +	/* Store the daxdev in our table */
> +	if (index >=3D fc->dax_devlist->nslots) {
> +		pr_err("%s: index(%lld) > nslots(%d)\n",
> +		       __func__, index, fc->dax_devlist->nslots);
> +		return -EINVAL;
> +	}
> +
> +	args.opcode =3D FUSE_GET_DAXDEV;
> +	args.nodeid =3D index;
> +
> +	args.in_numargs =3D 0;

[Severity: Medium]
The UAPI defines struct fuse_get_daxdev_in with daxdev_num for the input
payload. Does this implementation intentionally ignore that struct, set
in_numargs =3D 0, and repurpose the nodeid field (which is normally for VFS
inode numbers) to pass the device index instead? This appears to break the
protocol format.

> +
> +	args.out_numargs =3D 1;
> +	args.out_args[0].size =3D sizeof(daxdev_out);
> +	args.out_args[0].value =3D &daxdev_out;
> +
> +	/* Send GET_DAXDEV command */
> +	rc =3D fuse_simple_request(fm, &args);
> +	if (rc) {
[ ... ]
> +		return rc;
> +	}
> +
> +	scoped_guard(rwsem_write, &fc->famfs_devlist_sem) {
> +		daxdev =3D &fc->dax_devlist->devlist[index];
> +
> +		/* Abort if daxdev is now valid (races are possible here) */
> +		if (daxdev->valid) {
> +			pr_debug("%s: daxdev already known\n", __func__);
> +			return 0;
> +		}
> +
> +		/* Verify dev is valid and can be opened and gets the devno */
> +		rc =3D famfs_verify_daxdev(daxdev_out.name, &daxdev->devno);

[Severity: High]
Is the FUSE server-provided string daxdev_out.name guaranteed to be
null-terminated?

If a FUSE server sends a response where the 256-byte name field contains no
null bytes, passing it to kern_path() (via famfs_verify_daxdev()) and
kstrdup() could read past the end of the stack-allocated daxdev_out struct
until a null byte is found, potentially causing an out-of-bounds memory rea=
d.

[ ... ]
> +static int
> +famfs_update_daxdev_table(
> +	struct fuse_mount *fm,
> +	const struct famfs_file_meta *meta)
> +{
> +	struct famfs_dax_devlist *local_devlist;
> +	struct fuse_conn *fc =3D fm->fc;
> +	int indices_to_fetch[MAX_DAXDEVS];
> +	int n_to_fetch =3D 0;
> +	int err;
> +
> +	/* First time through we will need to allocate the dax_devlist */
> +	if (!fc->dax_devlist) {

[Severity: Medium]
Could this unprotected plain read of fc->dax_devlist race with the atomic
cmpxchg() publication later in the function? Should this use READ_ONCE() to
prevent compiler optimization issues or KCSAN warnings?

> +		local_devlist =3D kcalloc(1, sizeof(*fc->dax_devlist), GFP_KERNEL);
> +		if (!local_devlist)
> +			return -ENOMEM;
> +
> +		local_devlist->nslots =3D MAX_DAXDEVS;
> +
> +		local_devlist->devlist =3D kcalloc(MAX_DAXDEVS,
> +						 sizeof(struct famfs_daxdev),
> +						 GFP_KERNEL);
> +		if (!local_devlist->devlist) {
> +			kfree(local_devlist);
> +			return -ENOMEM;
> +		}
> +
> +		/* We don't need famfs_devlist_sem here because we use cmpxchg */
> +		if (cmpxchg(&fc->dax_devlist, NULL, local_devlist) !=3D NULL) {
> +			kfree(local_devlist->devlist);
> +			kfree(local_devlist); /* another thread beat us to it */
> +		}
> +	}
> +
> +	/* Collect indices that need fetching while holding read lock */
> +	scoped_guard(rwsem_read, &fc->famfs_devlist_sem) {
> +		unsigned long i;
> +
> +		for_each_set_bit(i, (unsigned long *)&meta->dev_bitmap, MAX_DAXDEVS) {

[Severity: Medium]
Does casting a u64 * to unsigned long * here break on 32-bit big-endian
systems?

On those architectures, the loop might read the upper 32 bits (which are
zero) instead of the lower 32 bits, resulting in a failure to fetch any DAX
devices. Should meta->dev_bitmap use DECLARE_BITMAP to avoid endianness and
size mismatch bugs?

[ ... ]
> @@ -329,6 +551,9 @@ famfs_file_init_dax(
>  	if (rc)
>  		goto errout;
> =20
> +	/* Make sure this fmap doesn't reference any unknown daxdevs */
> +	famfs_update_daxdev_table(fm, meta);
> +

[Severity: High]
The return value of famfs_update_daxdev_table() is an error code, but it is
completely ignored here.

If it fails (e.g., due to an ENOMEM allocation failure or if the daxdev fet=
ch
fails), file initialization proceeds with uninitialized DAX devices. Could
this lead to invalid state and potential NULL pointer dereferences on
subsequent accesses?

>  	/* Publish the famfs metadata on fi->famfs_meta */
>  	inode_lock(inode);

[ ... ]

While reviewing famfs_fuse_meta_alloc() in the same file:

> 		for (i =3D 0; i < fmh->nextents; i++) {
> 			meta->se[i].dev_index  =3D se_in[i].se_devindex;
> 			meta->se[i].ext_offset =3D se_in[i].se_offset;
> 			meta->se[i].ext_len    =3D se_in[i].se_len;
>=20
> 			/* Record bitmap of referenced daxdev indices */
> 			meta->dev_bitmap |=3D (1 << meta->se[i].dev_index);

[Severity: High]
Is it possible for the untrusted device index from the FUSE payload
(se_devindex) to cause undefined behavior here?

If a FUSE server provides an se_devindex >=3D 31, the expression
1 << meta->se[i].dev_index shifts a 32-bit signed integer by an unvalidated
amount before famfs_check_ext_alignment() validates the index.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260318203054.4344=
.fuse@groves.net?part=3D5
