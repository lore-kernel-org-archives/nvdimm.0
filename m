Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949292C21E6;
	Mon,  3 Aug 2026 02:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785725117; cv=none; b=WEuY6W+IY/NRls36S/aw7Bbzyzk8RzmvUDa/xzR8zMR2/usWD1uJOQZfXnkS0eo0Ifd/oVlUtnSPXHDmEULmzQLavAwZVYeKRNnUh7H2VFvy656LjSDjmSGU2dRDK+5E3b2tAbobifmKoz9biil6bRLJ394ZO1RaQPR3Wa2MN3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785725117; c=relaxed/simple;
	bh=WFoL8qhcW0qndnTuWnFF7DtZTUK21gcQnO6jkkYYmGU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B7XyrLSBBzF8UCmvlUyo2ln5X4rygL0BmvSEHYce+L7a4rMAqTZe0UniIVH2MFQW8FncWdK2cVRNdI7mebymx+uQl1dCC+Bob+oCvbsMvqrFmptVmj8rV5n9W+Kedg0pngLvTxvEZGgT7Mp8DbbEvi82aTWlPPhevmka3HJqBXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PDB44ivu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PDB44ivu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A061F000E9;
	Mon,  3 Aug 2026 02:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785725116;
	bh=HiYOsy7ISkLA+tL+ObGXhzZZfS6JG2UapTpGj9EhzaE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PDB44ivu7lyuFBUfW84qEPVPJioeUWZ3z7LYMbbnWpuueQWr6f2JVU6U5JBICS6i4
	 IzXXHANsUwzE63+SZYkxBXDa9SEwMFuYXks5AsrMOlGwgzljl3+ZlDdcS02C9ZmLRc
	 LrQrDaUUfa8unbxnOFoDwE0vAlHP0BHoI8q2yZv9yfsNgrK96EGGLqYK+dLpRWGoVN
	 KTc8ajtXs0cTKW6dipdOtJh+A1UeDVxMemEezo4Dv4DJ5Hu4nxM3ArzCTkr1ANuI4X
	 LbJddHxZ1cpuKuHsamWWFAITEsSv39iJaQQo4foaaYilEo7mwQvjQeV2+ZbPKcnRYT
	 D5gfEMUfv4xjA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V12 03/12] famfs: Add daxdev table and dax
 notify_failure support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <0100019fc573c7cd-d37cbc1c-7687-4b05-99e7-7d3624087b98-000000@email.amazonses.com>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022839.75794-1-john@jagalactic.com>
 <0100019fc573c7cd-d37cbc1c-7687-4b05-99e7-7d3624087b98-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 02:45:15 +0000
Message-Id: <20260803024516.15A061F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Race condition in `famfs_dax_notify_failure` causes NULL pointer d=
ereference or Use-After-Free during teardown.
- [Medium] famfs_install_daxdev silently returns success when a conflicting=
 device is installed at an already-populated index.
--

--- Patch [3]: [PATCH V12 03/12] famfs: Add daxdev table and dax notify_fai=
lure support ---
commit 6ec60105b0cea4058f8c078b72261124109aca1d
Author: John Groves <John@Groves.net>

famfs: Add daxdev table and dax notify_failure support

Famfs file systems can span multiple dax devices, and daxdevs are stored
in the daxdev_table. This adds the basic table structure, primtives and
serialization code. Famfs file extents reference daxdevs by index, which
is a cluster invariant maintained by user space.

diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
index c299a90912a5c..ad71e5e7a8e39 100644
--- a/fs/famfs/famfs_inode.c
+++ b/fs/famfs/famfs_inode.c
@@ -75,6 +75,225 @@ static struct inode *famfs_get_inode(
 /*
  * famfs dax_operations (for famfs-mode dax)
  */
[ ... ]
> +static int
> +famfs_dax_notify_failure(
> +		struct dax_device *dax_dev, u64 offset,
> +		u64 len, int mf_flags)
> +{
> +	struct super_block *sb =3D dax_holder(dax_dev);
> +	struct famfs_fs_info *fsi =3D sb->s_fs_info;

[Severity: High]
Can this race with a concurrent filesystem unmount?

If a memory failure triggers famfs_dax_notify_failure() concurrently with
famfs_kill_sb(), fs_put_dax() may clear the holder data asynchronously. If
dax_holder() returns NULL here, does this result in a NULL pointer derefere=
nce
when accessing sb->s_fs_info?

Furthermore, if dax_holder() fetches the superblock just before it is clear=
ed:

CPU1
famfs_dax_notify_failure()
    sb =3D dax_holder(dax_dev);
    fsi =3D sb->s_fs_info;

CPU2
famfs_kill_sb()
    famfs_devlist_free(fsi, sb);
    kill_char_super(sb);
    kfree(fsi);

CPU1
    famfs_set_daxdev_err(fsi, dax_dev);

Could this result in a use-after-free when famfs_set_daxdev_err() attempts
to acquire the freed fsi->devlist_sem?

[ ... ]
> +int famfs_install_daxdev(
> +		struct famfs_fs_info *fsi,
> +		struct super_block *sb,
> +		u64 index,
> +		dev_t devno,
> +		const char *name)
> +{
[ ... ]
> +	scoped_guard(rwsem_write, &fsi->devlist_sem) {
> +		daxdev =3D &fsi->dax_devlist->devlist[index];
> +
> +		/* Installed already by a concurrent (or repeated) open */
> +		if (daxdev->valid)
> +			return 0;

[Severity: Medium]
If userspace erroneously requests mapping a new or different dax device to =
an
index that is already populated, this path silently returns 0.

Should this verify that the requested devno matches the already installed
device's devno, and return an error like -EBUSY or -EEXIST if it does not, =
to
prevent misleading userspace about which mapping is actually active?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0100019fc572ca94-ec=
363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com?part=3D3
