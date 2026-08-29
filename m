Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34902335091;
	Sat, 29 Aug 2026 17:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788024639; cv=none; b=KWmrLsXNdyWjXZfrwDT4JabpAsbl1oxf2TstDw2zVX6k08ff1YwXpoMQFFKc6x5ZFMcCS6tULLwe0Z64uptiVLh4rF2r39nD38dBgI8hijO88Y/skBDi3Cx246dgL3p+/HCfd54sc9UjzEYKws85NRe1y1H9iFhQbpgAB3RWLlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788024639; c=relaxed/simple;
	bh=mS1cYgN7QLfEkWUb6idglcFhpLqrPewULK/YpczjHgc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tz3aHH/E3OGJsvDVPIm1V1AwGQzN/T2hbUDP+w0RLT0ySE/2wXPvb6CC0JJKc0Vo+dzPF/bDBAz9o7pL2VBjcCraJo14iVapGz7wjC4jstn8HIvspMzhEHGIywPHmC6kyDWBIYQ6DD58rh2vOIcR+czJHHgmP+Iufeg/D+K4JMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gNPX3nFL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gNPX3nFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FABD1F000E9;
	Sat, 29 Aug 2026 17:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788024637;
	bh=3liRpF3WMkSu+Ln0RlNseSZMI7RWfnmTePaxyhzprlI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gNPX3nFL/kmB9bA7fqVfjG/HV8V792642vaA5sfZSC4tK2RFHyWhqIHmGnfoqrBUa
	 XJ0He1YOlQAxhJah1jJHHKILYJ2Ujwsya1HnIrtFQZ4oaxDOooLlZb9UbBtV08gpF+
	 Ek+DW6iro2kZ6NOHQ1sVlil+RMP4jDLgLTOfydK5guANh9vL/qggnciOWOAlRo0Ddw
	 SD3FTUCzJSdURSkxrq9YxgPqsHFQ+Wf5rxaZxx7rFgACLUBwFxstLK1E3Zk8cyMpLF
	 BNVOLe1VT9kGlYkW/DArbGkpdxD9UhxTVYCIDqBH+xSSf++Fzmoh1IQTDSim1xidDs
	 F75EH3S41Qp9w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V14 11/12] famfs: Report device capacity via statfs so
 df works
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Groves" <john@jagalactic.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <010001a04e82df10-e266ce13-d8e7-42f0-ae64-0b2df6e94be5-000000@email.amazonses.com>
References: <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com>
 <20260829171307.7532-1-john@jagalactic.com>
 <010001a04e82df10-e266ce13-d8e7-42f0-ae64-0b2df6e94be5-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 29 Aug 2026 17:30:37 +0000
Message-Id: <20260829173037.9FABD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Use-after-free race condition in `dax_fsdev_size()` due to missing=
 SRCU read lock (`dax_read_lock()`).
- [Medium] The statfs `used_capacity` counter grows monotonically but is ne=
ver decremented when files are evicted, causing `df` to permanently show 0 =
available space.
- [Low] Mixing goto-based error handling with scope-based cleanup helpers (=
`scoped_guard`) in the same function violates kernel cleanup guidelines.
--

commit dd30d0d60f5f3c8708d001e5e982ce4519316fdc
Author: John Groves <John@Groves.net>

    famfs: Report device capacity via statfs so df works
   =20
    Replace simple_statfs(), which reports zero blocks (so df omits the mou=
nt),
    with famfs_statfs() reporting real capacity and usage.

> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index 188b2526bee45..a5b4b2d794286 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
[ ... ]
> @@ -104,6 +104,25 @@ static size_t fsdev_dax_recovery_write(struct dax_de=
vice *dax_dev, pgoff_t pgoff
>  	return _copy_from_iter_flushcache(addr, bytes, i);
>  }
> =20
> +/**
> + * dax_fsdev_size() - total size in bytes of an fsdev dax device
> + * @dax_dev: the dax device (must be bound to this driver)
> + *
> + * Returns the size cached at probe time (sum of all ranges); it cannot =
change
> + * while the driver is bound. Only valid for fsdev dax devices - callers
> + * ensure that (e.g. fs_dax_get() enforces DAXDRV_FSDEV_TYPE). Returns 0=
 if the
> + * device is not alive.
> + */
> +u64 dax_fsdev_size(struct dax_device *dax_dev)
> +{
> +	struct dev_dax *dev_dax =3D dax_get_private(dax_dev);
> +
> +	if (!dev_dax)
> +		return 0;
> +	return dev_dax->cached_size;
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: High]
Does this code introduce a use-after-free race condition?

dax_fsdev_size() retrieves the dev_dax pointer via dax_get_private(dax_dev)
and accesses dev_dax->cached_size without acquiring the SRCU read lock
(dax_read_lock()).

If an asynchronous device unplug or sysfs unbind occurs concurrently,
kill_dax() could clear the DAXDEV_ALIVE flag and call synchronize_srcu().
Since the SRCU read lock is not held here, synchronize_srcu() would return
immediately, and the unplug path could free the dev_dax structure before
cached_size is read.

> +}
> +EXPORT_SYMBOL_GPL(dax_fsdev_size);
> +
>  static const struct dax_operations dev_dax_ops =3D {
>  	.direct_access =3D fsdev_dax_direct_access,
>  	.zero_page_range =3D fsdev_dax_zero_page_range,
[ ... ]
> diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> index 0a6d0392794c5..965b6732f52c4 100644
> --- a/fs/famfs/famfs_file.c
> +++ b/fs/famfs/famfs_file.c
[ ... ]
> @@ -344,6 +344,11 @@ famfs_file_init_dax(struct file *file, void __user *=
arg)
>  	}
>  	inode_unlock(inode);
> =20
> +	/* Account the mapped device bytes for statfs (only on success) */
> +	if (!rc) {
> +		scoped_guard(rwsem_write, &fsi->stats_sem)
> +			fsi->used_capacity +=3D extent_total;
> +	}
        ^^^^^

[Severity: Low]
This isn't a bug, but does mixing scope-based cleanup helpers (scoped_guard)
with goto-based error handling in this function violate kernel cleanup
guidelines?

famfs_file_init_dax() heavily relies on goto labels (out:) for error
handling. The kernel guidelines suggest either converting all resources
that need cleanup to scope-based cleanup, or converting none of them, to
avoid confusing ownership semantics.

>  out:
>  	kvfree(fmap_buf);
>  	if (meta)
[ ... ]
> diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> index 2f1938adbfbc3..61b668b299ef5 100644
> --- a/fs/famfs/famfs_inode.c
> +++ b/fs/famfs/famfs_inode.c
[ ... ]
> @@ -348,8 +349,38 @@ famfs_evict_inode(struct inode *inode)
>  	clear_inode(inode);
>  }
        ^^^^^^^^^^^^^^^^^^

[Severity: Medium]
Will this cause the fsi->used_capacity counter to grow monotonically and
eventually report zero available space?

When a user creates and maps a famfs file, fsi->used_capacity is permanently
incremented in famfs_file_init_dax(). However, famfs_evict_inode() frees the
metadata but does not appear to decrement fsi->used_capacity to reflect the
freed space.

If users repeatedly create and unlink files, won't fsi->used_capacity
double-count the space until df permanently shows 0 available blocks?

> =20
> +/*
> + * famfs_statfs() - report device capacity and consumption so 'df' works.
> + * @total_capacity is the sum of installed daxdev sizes; @used_capacity =
is the
> + * sum of device bytes mapped by fmaps (superblock + log + data files). =
Free is
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/010001a04e801a4e-8e=
b212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com?part=3D11
