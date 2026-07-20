Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FACC2AD35;
	Mon, 20 Jul 2026 04:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784520141; cv=none; b=bijlCnqLnfTLn3iNVdlA0s9kxQyM1VI93du58I2c+PrldSCZML2ohHWj1AWGezeEddXkQaFGf4698xpcf8Fc2TrzJPqs/Z21+etLqgWM6+Y01xo4drSNpHt2A6jPoltOD2mQiFduf8cXkMQycqwJM4Gm3IKNDdX4IJ0v18qGjnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784520141; c=relaxed/simple;
	bh=s96FcwiKgi2W6+MDByCg0twpxxBQTKCCe6ZQGnNr8mE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Jw05/Bj78ozR4NrH61TtzXL2qjTqFsZDndcnVXwMbC0zEzpFBDuQ+ztMwUHt+wGvEB3AMvTh6YA6ngjyPDIE8R7YG5gS4u5kTv1mvLWkHixzxe4rWtqKUZHHaHnzrnltAE3p05M2zh1hDdV7b04hVnbPBt291hswWUubaVKpbZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XPPnR32G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XPPnR32G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60C31F000E9;
	Mon, 20 Jul 2026 04:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784520139;
	bh=awZKrSptN8SPmfGLEGmK9p80YTigQjZ3clv2kjMaz2I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XPPnR32GJ4uWNTwKFhSrUzShOdlYoliMs8fn6Fc4S+0MEgbzHQt+f9mRgQoUAQsZ3
	 3xL2hZeApnNX6E8dRQOyK9zVDSp7Y8G68QxwrfXxaIRGy1gqZqTEHhmjCHldFNCmy1
	 d+wOBp8DV+kguqlxBpskqZTYg2KY6Id1aq1WK9n0qyFN/IGLSe1kZbqqBqMHktxAB5
	 8eJhTn1ia+OR8Deebgh+xQB4gVtxftmjzhn2z0x7LjeoIOoR+Z1vDRKh1r4m55N+Q0
	 RHSe2f0TjdDTQ/M33TLQSoJgBZb1AB9yBReVfU05V5M9e6F3M/DIlvILqxGb1LPUmk
	 xCBEqs1ax/aFg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V11 5/9] famfs_fuse: register fs-dax daxdevs via
 FUSE_DEV_IOC_DAXDEV_OPEN
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <0100019f7da1a534-2fc6658c-4f30-4cc6-b010-5e3f8fd7164b-000000@email.amazonses.com>
References: <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
 <20260720034603.68815-1-john@jagalactic.com>
 <0100019f7da1a534-2fc6658c-4f30-4cc6-b010-5e3f8fd7164b-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 04:02:19 +0000
Message-Id: <20260720040219.A60C31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] Unconditional lock acquisition of a conditionally initialized =
semaphore causes a kernel crash on FUSE unmounts.
- [High] Missing bounds check on `se_devindex` leads to Undefined Behavior =
and validation bypass for out-of-bounds indices.
- [High] Race condition between famfs_teardown() and dax_holder_notify_fail=
ure() causes a NULL pointer dereference.
- [Medium] FUSE_DEV_IOC_DAXDEV_OPEN does not enforce that the reserved flag=
s field is zero.
- [Medium] Missing memory barriers around bitfield initialization leads to =
data races and acquiring an uninitialized semaphore.
--

--- Patch [5]: [PATCH V11 5/9] famfs_fuse: register fs-dax daxdevs via FUSE=
_DEV_IOC_DAXDEV_OPEN ---
commit 40109f7c2918c43160e80f34d0381f258354bbf2
Author: John Groves <john@groves.net>

famfs_fuse: register fs-dax daxdevs via FUSE_DEV_IOC_DAXDEV_OPEN

This commit introduces a new ioctl, FUSE_DEV_IOC_DAXDEV_OPEN, to register
devdax devices backing an fs-dax (famfs) filesystem. It reuses the
fuse_backing_map structure and handles device resolution and table storage.

> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 5763a7cd3b37f..3e6aa15e0346e 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
[ ... ]
> @@ -2330,6 +2330,34 @@ static long fuse_dev_ioctl_backing_close(struct fi=
le *file, __u32 __user *argp)
>  	return fuse_backing_close(fud->chan->conn, backing_id);
>  }
> =20
> +static long fuse_dev_ioctl_daxdev_open(struct file *file,
> +				       struct fuse_backing_map __user *argp)
> +{
> +	struct fuse_dev *fud =3D fuse_get_dev(file);
> +	struct fuse_backing_map map;
> +
> +	if (IS_ERR(fud))
> +		return PTR_ERR(fud);
> +
> +	if (!IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * The famfs-mode gate (fc->famfs_iomap) lives in famfs_daxdev_open(),
> +	 * which has the full fuse_conn definition. Here, re-check CAP_SYS_RAWIO
> +	 * against the task performing the registration: famfs mode being enabl=
ed
> +	 * only attests that the session founder held it at FUSE_INIT, and the
> +	 * fuse device fd may have been passed to a less-privileged process.
> +	 */
> +	if (!capable(CAP_SYS_RAWIO))
> +		return -EPERM;
> +
> +	if (copy_from_user(&map, argp, sizeof(map)))
> +		return -EFAULT;
> +
> +	return famfs_daxdev_open(fud->chan->conn, &map);
> +}
> +

[Severity: Medium]
Should there be a check to enforce that map.flags is zero?

If userspace passes uninitialized garbage in the flags field and it is
silently accepted, wouldn't that permanently burn the flags field and
prevent future ABI extensions using this field?

> diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
> index 8f7ee7d6151bb..a2a7dd631dc0f 100644
> --- a/fs/fuse/famfs.c
> +++ b/fs/fuse/famfs.c
[ ... ]
> @@ -22,6 +23,331 @@
>  #include "famfs_kfmap.h"
>  #include "fuse_i.h"
> =20
> +static void famfs_set_daxdev_err(
> +	struct fuse_conn *fc, struct dax_device *dax_devp);
> +
> +static int
> +famfs_dax_notify_failure(struct dax_device *dax_devp, u64 offset,
> +			u64 len, int mf_flags)
> +{
> +	struct fuse_conn *fc =3D dax_holder(dax_devp);
> +
> +	famfs_set_daxdev_err(fc, dax_devp);
> +
> +	return 0;
> +}

[Severity: High]
Can dax_holder() return NULL here and cause a crash?

If a DAX memory failure occurs concurrently with a FUSE unmount, the DAX
core could execute dax_holder_notify_failure() while famfs_teardown()
concurrently calls fs_put_dax().

Since fs_put_dax() clears holder_data without waiting for the active SRCU
read-side critical section, wouldn't dax_holder() return NULL, which is
then passed to famfs_set_daxdev_err() where it is dereferenced?

[ ... ]
> +static int
> +famfs_check_daxdev_table(
> +	struct fuse_mount *fm,
> +	const struct famfs_file_meta *meta)
> +{
> +	struct fuse_conn *fc =3D fm->fc;
> +	int nmissing =3D 0;
> +	int err;
> +
> +	err =3D famfs_devlist_alloc(fc);
> +	if (err)
> +		return err;
> +
> +	/* Count missing daxdevs while holding the reader lock */
> +	scoped_guard(rwsem_read, &fc->famfs_devlist_sem) {
> +		unsigned long i;
> +
> +		for_each_set_bit(i, (unsigned long *)&meta->dev_bitmap,
> +				 MAX_DAXDEVS) {
> +			struct famfs_daxdev *dd =3D &fc->dax_devlist->devlist[i];

[Severity: High]
Does this validation loop miss out-of-bounds indices?

In famfs_fuse_meta_alloc(), the dev_bitmap is populated directly from the
user-supplied index:

    meta->se[i].dev_index  =3D se_in[i].se_devindex;
    ...
    meta->dev_bitmap |=3D BIT_ULL(meta->se[i].dev_index);

If an untrusted FUSE server sends an fmap response where se_devindex is
between 24 and 63, the bit is set in meta->dev_bitmap. However, this
validation loop only scans up to MAX_DAXDEVS (24).=20

Would this silently ignore out-of-bounds indices, leaving nmissing as 0,
and accepting invalid metadata that could cause out-of-bounds array access
later? Additionally, if se_devindex is >=3D 64, wouldn't BIT_ULL() trigger
undefined behavior?

> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 78ffc5fd50d03..9fc37015fb111 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1021,6 +1021,9 @@ void fuse_conn_put(struct fuse_conn *fc)
>  		WARN_ON(atomic_read(&bucket->count) !=3D 1);
>  		kfree(bucket);
>  	}
> +	if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> +		famfs_teardown(fc);
> +

[Severity: Critical]
Does this unconditionally tear down a conditionally initialized structure?

When a regular user mounts a standard FUSE filesystem, if the server
does not negotiate FUSE_DAX_FMAP, famfs_init_devlist_sem(fc) is skipped
in process_init_reply().=20

However, when the filesystem is unmounted, this unconditionally calls
famfs_teardown() (which acquires fc->famfs_devlist_sem). Could this cause
a kernel panic or lockdep splat by locking an uninitialized rw_semaphore?

[ ... ]
> @@ -1427,8 +1430,10 @@ static void process_init_reply(struct fuse_args *a=
rgs, int error)
>  				u64 in_flags =3D FIELD_PREP(GENMASK_ULL(63, 32), ia->in.flags2)
>  						| ia->in.flags;
> =20
> -				if (in_flags & FUSE_DAX_FMAP)
> +				if (in_flags & FUSE_DAX_FMAP) {
> +					famfs_init_devlist_sem(fc);
>  					fc->famfs_iomap =3D 1;
> +				}
>  			}

[Severity: Medium]
Are there missing memory barriers here when publishing famfs_iomap?

The flag is published without a write barrier after initializing the
semaphore. In famfs_daxdev_open(), it is read locklessly:

    if (!fc->famfs_iomap)
        return -EOPNOTSUPP;

Without smp_store_release() here and smp_load_acquire() there, could a
reader observe famfs_iomap =3D=3D 1 before the semaphore initialization is
visible, and proceed to lock an uninitialized semaphore?

Also, since famfs_iomap is a bitfield, could concurrent non-atomic
modifications to adjacent bitfields cause a data race?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019f7d9fbe81-6c=
b16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com?part=3D5
