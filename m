Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795707356;
	b=ihn8Qs5KPN5Wmnf9lnJZ72a5IJnuy/alcGa/CsNzTZ1BtOJ+ETFrj0Rou7i41fykdl01
	 SjViOdLHGSJmlZMMlMXZCduJJUGOp+NZjQoKIAAzG6AjPXXrIVJssaEAXzeIOW+QOigBl
	 FtJ2s+QUK1iFvV+X13Ac5apuOo/JvbUyREweFqQVgE9ZAKKDlDPNUKNUN9kHgt4qOYbZp
	 oh3YVOCz2GPCbCPPn7XVpcPqRmUUBsuWFzDoGtdZhy5cSdW5NVQu5ooaaT0HrPiF6v0+h
	 57Mjcut3xQ9dVqkdCDgapsfEQcyyeIQdgMsalYP4t8twRyL5odhccdm9t0KWEpqQ3yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795707356;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=V1Ma289SGeGGGvresElYKkyAzmMu4Dih+K08SNofEM4=;
	b=oTj6EHPgri9Jt5b4JieT8nrOgk5rZZZJeuoZuUbfNbsDUa3gL4+3nOfaQln9iFZ0FsVt
	 h7ITs9AjIH7SZ/9gCJkXG1aD1rwH2KWT69rP0DZlWCyc1exLjo7ugPuhDfo525eg22Gw7
	 fhCozsj8ULyLB3QPAQ1ELbNhTkiayYi93Ann5n7R0eoBj59/GThd6H5ozJoJYEjgtYXnX
	 K5AP1mpNXt4JTJNeh5Qx50vy6xZwsnFQNBP1x4q/bx0hRQ0hx6Rq1KBP+z9Ji7p0a8p5F
	 pSlWNMuoXUoDiQiSNOurXjPvhRMGEWF3PpoPYgy7LZC3lETYwgMXNq+tsIVhzqYpFTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fix7AjAo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CAA606A31C
	for <nvdimm@lists.linux.dev>; Thu, 26 Nov 2026 15:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fix7AjAo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5318A1F000C4;
	Thu, 26 Nov 2026 15:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795707356;
	bh=V1Ma289SGeGGGvresElYKkyAzmMu4Dih+K08SNofEM4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fix7AjAoeH361BOoZLfcbgB7bcAjMgQnxt7qkrpHtSoGsLVu+/sQNzIHQUP7bjukl
	 Ap6s/FRz5QZuoD/fIpm/WtxvRjK2VEr9qgeKk4UnsOheTGLFgxc2cn2yiIXxpKtqmK
	 HBDgV9/7AoYBzbGkmSTDUb2CXNvw5bAE+l8jll4UrGMjjXtZblzHo7KSiN2OjyfjVU
	 35RoDicwGmk0COPlyX4hKYmN5pKn/SDsgpJFIYTCz//7cKU2Ei+rloF+XjBKZzpsuv
	 5p5N7EULaZr8f7u4FmKEFWS/N5sN0D/zA6oI6SRL8dqmUMXlKQhIZklLoPT3p4uBnh
	 NtiHpiit3oODA==
Message-ID: <sashiko-outbox-235816@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 07/21] drbd: add DAX/PMEM support for metadata access
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Q2hyaXN0b3BoIELDtmhtd2FsZGVy?= <christoph.boehmwalder@linbit.com>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20261125153511.3060599-8-christoph.boehmwalder@linbit.com>
References: <20261125153511.3060599-1-christoph.boehmwalder@linbit.com>
 <20261125153511.3060599-8-christoph.boehmwalder@linbit.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 15:35:55 +0000
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 6 potential
issues to consider:
- [High] drbd: partition offset ignored in drbd_dax_open() and
  drbd_dax_map()
- [High] drbd: sub-page offset and page-count truncation when PAGE_SIZE
  > 4096
- [High] drbd: missing cache writeback and ordering in
  drbd_dax_al_initialize()
- [High] drbd: __LC_DIRTY never cleared in drbd_dax_al_begin_io_commit()
- [Medium] drbd: uncommitted and unlocked act_log read in
  drbd_dax_al_initialize()
- [Medium] drbd: signed 32-bit overflow of al_slots in
  drbd_dax_al_initialize()
--

commit 18328fa09c24a2177de466d63d0b03076b0a0aa1
Author: Christoph B=C3=B6hmwalder <christoph.boehmwalder@linbit.com>

drbd: add DAX/PMEM support for metadata access

This commit adds DAX/PMEM helpers to map DRBD metadata directly in
persistent memory and access the activity log and resync bitmap in place.

> diff --git a/drivers/block/drbd/drbd_dax_pmem.c b/drivers/block/drbd/drbd=
_dax_pmem.c
> new file mode 100644
> index 0000000000000..1fb22e57cf5d0
> --- /dev/null
> +++ b/drivers/block/drbd/drbd_dax_pmem.c
> @@ -0,0 +1,175 @@

[ ... ]

> +static pgoff_t md_sector_to_pgoff(sector_t sector)
> +{
> +	return sector >> (PAGE_SHIFT - SECTOR_SHIFT);
> +}
> +
> +static long md_sectors_to_pages(sector_t nr_sectors)
> +{
> +	return nr_sectors >> (PAGE_SHIFT - SECTOR_SHIFT);
> +}
> +
> +/* Signed, since the bitmap offset relative to the superblock may be neg=
ative. */
> +static long md_sector_offset_to_bytes(long sector_offset)
> +{
> +	return sector_offset * SECTOR_SIZE;
> +}
> +
> +static int map_superblock_for_dax(struct drbd_backing_dev *bdev, struct =
dax_device *dax_dev)
> +{
> +	long want =3D 1;
> +	pgoff_t pgoff =3D md_sector_to_pgoff(bdev->md.md_offset);
> +	void *kaddr;
> +	long len;
> +	int id;
> +
> +	id =3D dax_read_lock();
> +	len =3D dax_direct_access(dax_dev, pgoff, want, DAX_ACCESS, &kaddr, NUL=
L);
> +	dax_read_unlock(id);
> +
> +	if (len < want)
> +		return -EIO;
> +
> +	bdev->md_on_pmem =3D kaddr;
> +
> +	return 0;
> +}
> +
> +/**
> + * drbd_dax_open() - Open device for dax and map metadata superblock
> + * @bdev: backing device to be opened
> + */
> +int drbd_dax_open(struct drbd_backing_dev *bdev)
> +{
> +	struct dax_device *dax_dev;
> +	int err;
> +	u64 part_off;
> +
> +	dax_dev =3D fs_dax_get_by_bdev(bdev->md_bdev, &part_off, NULL, NULL);
> +	if (!dax_dev)
> +		return -ENODEV;
> +
> +	err =3D map_superblock_for_dax(bdev, dax_dev);
> +	if (!err)
> +		bdev->dax_dev =3D dax_dev;
> +	else
> +		put_dax(dax_dev);
> +
> +	return err;
> +}

[Severity: High]
Does drbd_dax_open() discard part_off, causing map_superblock_for_dax() and
drbd_dax_map() to access the wrong offset when bdev->md_bdev is a partition?

fs_dax_get_by_bdev() returns the dax_device for the whole disk and writes
the partition's byte offset into part_off.  Because bdev->md.md_offset and
drbd_md_first_sector(bdev) are relative to bdev->md_bdev, passing pgoff to
dax_direct_access() without adding part_off >> PAGE_SHIFT maps and writes
metadata relative to the beginning of the parent disk instead of the
partition, corrupting earlier partitions or the partition table.

[ ... ]

> +int drbd_dax_map(struct drbd_backing_dev *bdev)
> +{
> +	struct dax_device *dax_dev =3D bdev->dax_dev;
> +	sector_t first_sector =3D drbd_md_first_sector(bdev);
> +	sector_t al_sector =3D bdev->md.md_offset + bdev->md.al_offset;
> +	long want =3D md_sectors_to_pages(drbd_md_last_sector(bdev) + 1 - first=
_sector);
> +	pgoff_t pgoff =3D md_sector_to_pgoff(first_sector);
> +	long md_offset_byte =3D md_sector_offset_to_bytes(bdev->md.md_offset - =
first_sector);
> +	long al_offset_byte =3D md_sector_offset_to_bytes(al_sector - first_sec=
tor);
> +	void *kaddr;
> +	long len;
> +	int id;
> +
> +	id =3D dax_read_lock();
> +	len =3D dax_direct_access(dax_dev, pgoff, want, DAX_ACCESS, &kaddr, NUL=
L);
> +	dax_read_unlock(id);
> +
> +	if (len < want)
> +		return -EIO;
> +
> +	bdev->md_on_pmem =3D kaddr + md_offset_byte;
> +	bdev->al_on_pmem =3D kaddr + al_offset_byte;
> +
> +	return 0;
> +}

[Severity: High]
Can md_sector_to_pgoff() and md_sectors_to_pages() misalign bdev->md_on_pmem
and bdev->al_on_pmem or map too few pages when PAGE_SIZE is larger than 4K?

DRBD metadata offsets and sizes are 4K-aligned, not PAGE_SIZE-aligned (for
example, internal metadata places bdev->md.md_offset in the last 4K of the
device).  On a 64K-page kernel, md_sector_to_pgoff() rounds down to the 64K
page boundary, so kaddr points to the start of that page rather than
bdev->md.md_offset in map_superblock_for_dax() or first_sector in
drbd_dax_map().  In addition, md_sectors_to_pages() right-shifts the sector
count and truncates down, which yields 0 if the metadata region is smaller
than PAGE_SIZE or under-counts when the region crosses a page boundary.

[ ... ]

> +void drbd_dax_al_begin_io_commit(struct drbd_device *device)
> +{
> +	struct lc_element *e;
> +
> +	spin_lock_irq(&device->al_lock);
> +
> +	list_for_each_entry(e, &device->act_log->to_be_changed, list)
> +		drbd_dax_al_update(device, e);
> +
> +	lc_committed(device->act_log);
> +
> +	spin_unlock_irq(&device->al_lock);
> +}

[Severity: High]
Does drbd_dax_al_begin_io_commit() leave __LC_DIRTY set on device->act_log?

__lc_get() sets __LC_DIRTY when adding an entry to to_be_changed, and
lc_committed() does not clear it.  Unlike the non-DAX
drbd_al_begin_io_commit(), this function does not acquire
drbd_al_try_lock_for_transaction(), call lc_unlock() to clear __LC_DIRTY, or
wake device->al_wait.  Once __LC_DIRTY is set, lc_try_lock() always fails,
so disk_opts_check_al_size() hangs forever in
wait_event(device->al_wait, drbd_al_try_lock(device)) and
drbd_try_suspend_al() can never lock the activity log.

> +
> +int drbd_dax_al_initialize(struct drbd_device *device)
> +{
> +	struct al_on_pmem *al_on_pmem =3D device->ldev->al_on_pmem;
> +	__be32 *slots =3D al_on_pmem->slots;
> +	/* The activity log area holds the magic followed by the slots. */
> +	int i, al_slots =3D device->ldev->md.al_size_4k * (SZ_4K / sizeof(*slot=
s)) - 1;

[Severity: Medium]
Can al_slots overflow a signed 32-bit int when al_size_4k exceeds 2097152?

check_activity_log_stripe_size() allows al_size_4k up to 4194304 (16 GiB).
Multiplying by 1024 reaches 0xffffffff, which overflows signed int al_slots
to a negative value and causes the loop below to skip initializing all
activity log slots.  Using unsigned int for i and al_slots avoids the
overflow.

> +
> +	al_on_pmem->magic =3D cpu_to_be32(DRBD_AL_PMEM_MAGIC);
> +	/*
> +	 * Initialize all slots rather than just the configured number in case
> +	 * the configuration is later changed.
> +	 */
> +	for (i =3D 0; i < al_slots; i++) {\n> +		unsigned int extent_nr =3D i <=
 device->act_log->nr_elements ?
> +			lc_element_by_index(device->act_log, i)->lc_number :
> +			LC_FREE;
> +		slots[i] =3D cpu_to_be32(extent_nr);
> +	}

[Severity: Medium]
Does drbd_dax_al_initialize() read device->act_log without holding
device->al_lock or committing pending changes on to_be_changed?

When drbd_determine_dev_size() calls drbd_al_initialize(), uncommitted
entries on device->act_log->to_be_changed still hold their old lc_number
while the new extent is in lc_new_number.  Unlike the non-DAX path in
drbd_al_initialize(), which writes pending changes and calls lc_committed()
under device->al_lock, reading lc_number unlocked here can write stale
extent numbers to slots[] and race with concurrent activity log updates that
only serialize on device->al_lock.

> +
> +	return 0;
> +}

[Severity: High]
Should drbd_dax_al_initialize() flush the initialized activity log to
persistent memory with arch_wb_cache_pmem(), and write al_on_pmem->magic
only after the slots are persisted?

Unlike drbd_dax_al_update(), drbd_dax_al_initialize() never calls
arch_wb_cache_pmem(), so the magic and slot array can remain in volatile CPU
caches.  Writing al_on_pmem->magic before populating and flushing slots[]
also allows the valid magic header to reach persistent media before the
slots do, leaving uninitialized or stale slots marked valid across a crash.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125153511.3060=
599-1-christoph.boehmwalder@linbit.com?part=3D7
