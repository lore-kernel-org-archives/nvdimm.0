Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794329750;
	b=OKVkjFlW4s4L3sZXVidknqH+QcmonGaoHCGreh7xNoAdF1nDy/v/EnglCjQIVXJmw39V
	 S7R4j/25yZePCGVsBISBmdZSD/e5i4OiRXjCUJqkIViw7PoB+ZK02mc/Mhx5rggrjnFm5
	 3qhiK05kFXrpECc5kUMby14PRB1ApVcKChdJyd/wFscBCLqNVLu+RdwL8JYC9+zeOT8sx
	 FDfdd4HuL9DdUZWp2n6YkpWVi8iUNR3bCL98Jr+8bwa6G5BU4IG8YYWKcKJl6Wn8I7smO
	 KobSA1vYG2qs/oUnpSADucQyK9U4cmK6YEJ/L+vDLfXknR5odYKSBOIASLimpjQu5UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794329750;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uQduXaViSCmTahO4UTFvyi6zMj/qzYBfWjrgirPGddQ=;
	b=xjR/0yUwDtaY9hkNA+u5wfkHOgtnNozfwf7GJlU9e7zVdQv14jOkyfnokwv01rPS7SH7
	 LkDgp9LaDQWCzOtbWDLv7+9s9He8jNKKzlVzf5y34n3EYaV7/hRB7PRt1QCsLeEDfF8R9
	 n4W43nW+t/bvlPHOLYJhUXdIVKtUD4gQlyIcR7F717d8TzMyN4rQYOwEVWfjPWBq3nVAe
	 PeHnpekYxTUgxAuVVrt++IlxRHEMnWbQ94lGm7ylWUKAWmcNaDtT2N9XWSRDh3pPmy5+4
	 Djbk69r7LKGghiIEU4I1EZjMwSgHx64bgXp9KoOmeWdxN3oz7/hX+QJN7s/Il+baFAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y64qPwNl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE0C606A325
	for <nvdimm@lists.linux.dev>; Tue, 10 Nov 2026 16:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y64qPwNl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577121F0089F;
	Tue, 10 Nov 2026 16:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794329750;
	bh=uQduXaViSCmTahO4UTFvyi6zMj/qzYBfWjrgirPGddQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y64qPwNlD9QoIjuowVoymNLVZ9tWYI3thPp401VaOEbp4wUvwOLthRAgjc2eEA3R0
	 JdNiTIDW5b6AJAA3ESPc50crhLXXrJdC6TrPIJl5Kd/MPbu1iqkAfLzal5GBmHV9X0
	 G48GiejU17i9mqNahcujDctIm3JhbCUfMQAiz0x0fDyZMYf9Y92OwZhQk5DQctIAR+
	 T2MIPCE8OcxgFRQSn+KLHGw/MTFvd45ih4VFM8OzitIf50aCCkcwHCFd+s3Ebz4gqg
	 N/KZ6QaXywC/+0Z57NacA7U+KG2qRA3quancoT2w4TJ9bTBdUszsK4d7faqx9ZBtLa
	 KQXcuLY0gbM5Q==
Message-ID: <sashiko-outbox-207430@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/20] drbd: add DAX/PMEM support for metadata access
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Q2hyaXN0b3BoIELDtmhtd2FsZGVy?= <christoph.boehmwalder@linbit.com>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20261110162646.3028472-7-christoph.boehmwalder@linbit.com>
References: <20261110162646.3028472-1-christoph.boehmwalder@linbit.com>
 <20261110162646.3028472-7-christoph.boehmwalder@linbit.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 16:55:49 +0000
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 7 potential
issues to consider:
- [High] drbd: partition offset ignored in drbd_dax_open() and
  drbd_dax_map()
- [High] drbd: sub-page offset and page-count truncation when PAGE_SIZE
  > 4096
- [High] drbd: missing cache writeback and ordering in
  drbd_dax_al_initialize()
- [High] drbd: __LC_DIRTY never cleared in drbd_dax_al_begin_io_commit()
- [High] drbd: link failure and wrong Kconfig dependency on
  CONFIG_DEV_DAX_PMEM
- [Medium] drbd: signed 32-bit overflow of al_slots in
  drbd_dax_al_initialize()
- [Medium] drbd: uncommitted and unlocked act_log read in
  drbd_dax_al_initialize()
--

commit 78fd73a53d10bb7aa94cbf5a0d1278098930c4df
Author: Christoph B=C3=B6hmwalder <christoph.boehmwalder@linbit.com>

drbd: add DAX/PMEM support for metadata access

This commit adds DAX/PMEM support for DRBD metadata access, allowing the
superblock, activity log, and resync bitmap to be mapped and updated
directly in persistent memory.

> diff --git a/drivers/block/drbd/Makefile b/drivers/block/drbd/Makefile
> index 9f05f74e619c1..8ec1ad3604499 100644
> --- a/drivers/block/drbd/Makefile
> +++ b/drivers/block/drbd/Makefile
> @@ -5,6 +5,7 @@ drbd-y +=3D drbd_main.o drbd_strings.o drbd_nl.o
>  drbd-y +=3D drbd_interval.o drbd_state.o
>  drbd-y +=3D drbd_nl_gen.o
>  drbd-y +=3D drbd_transport.o
> +drbd-$(CONFIG_DEV_DAX_PMEM) +=3D drbd_dax_pmem.o
>  drbd-$(CONFIG_DEBUG_FS) +=3D drbd_debugfs.o
> =20
>  obj-$(CONFIG_BLK_DEV_DRBD)     +=3D drbd.o

[Severity: High]
Does the build fail to link when CONFIG_BLK_DEV_DRBD=3Dy and
CONFIG_DEV_DAX_PMEM=3Dm?  In that configuration, this line expands to
drbd-m +=3D drbd_dax_pmem.o, which Kbuild ignores when linking built-in
drbd.o, while IS_ENABLED(CONFIG_DEV_DAX_PMEM) in drbd_dax_pmem.h still
evaluates to true and declares drbd_dax_*() as external functions instead
of stubs.

In addition, drbd_dax_open() looks up the DAX device via
fs_dax_get_by_bdev(), which is gated on CONFIG_FS_DAX rather than
CONFIG_DEV_DAX_PMEM (the /dev/daxX.Y character device driver), so
drbd_dax_open() always returns -ENODEV if CONFIG_FS_DAX is disabled.

> diff --git a/drivers/block/drbd/drbd_dax_pmem.c b/drivers/block/drbd/drbd=
_dax_pmem.c
> new file mode 100644
> index 0000000000000..1fb22e57cf5d0
> --- /dev/null
> +++ b/drivers/block/drbd/drbd_dax_pmem.c
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
> +
> +void drbd_dax_close(struct drbd_backing_dev *bdev)
> +{
> +	put_dax(bdev->dax_dev);
> +}
> +
> +/**
> + * drbd_dax_map() - Map metadata for dax
> + * @bdev: backing device whose metadata is to be mapped
> + */
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
Does discarding part_off in drbd_dax_open() cause DRBD to read and write
metadata at the wrong offset when bdev->md_bdev is a partition?

fs_dax_get_by_bdev() returns the dax_device for the whole disk and writes
the partition's starting byte offset into part_off.  Because
map_superblock_for_dax() and drbd_dax_map() pass partition-relative
pgoff values to dax_direct_access() without adding part_off, metadata
accesses hit the beginning of the parent PMEM disk instead of the
partition, corrupting the partition table or earlier partitions.

[Severity: High]
Can md_sector_to_pgoff() and md_sectors_to_pages() misalign pointers and
truncate the mapping when PAGE_SIZE > 4096 (such as on arm64 or powerpc
with 64 KiB pages)?

DRBD metadata offsets and sizes are 4 KiB-aligned, not PAGE_SIZE-aligned;
for example, internal metadata places the 4 KiB superblock in the last 8
sectors of the device.  In map_superblock_for_dax(), md_sector_to_pgoff()
shifts off the sub-page bits of bdev->md.md_offset, so kaddr points to the
start of the page rather than the superblock.  In drbd_dax_map(), kaddr
also starts at the page boundary pgoff << PAGE_SHIFT, but md_offset_byte
and al_offset_byte are calculated relative to first_sector instead of the
start of pgoff, and md_sectors_to_pages() right-shifts the sector count
down (yielding want =3D=3D 0 if the metadata region is smaller than a page).

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
Does leaving __LC_DIRTY set in device->act_log->flags after
drbd_dax_al_begin_io_commit() cause later activity log locking to hang?

When an activity log lookup misses, __lc_get() sets __LC_DIRTY in
lc->flags.  lc_committed() clears pending_changes, but __LC_DIRTY is only
cleared by lc_unlock().  Unlike drbd_al_begin_io_commit(), this function
does not acquire drbd_al_try_lock_for_transaction(), call
lc_unlock(device->act_log), or wake device->al_wait.  Once __LC_DIRTY is
set, lc_try_lock(device->act_log) (which requires lc->flags =3D=3D 0) always
fails, so check_al_extents() hangs forever in wait_event(device->al_wait,
drbd_al_try_lock(device)) and drbd_try_suspend_al() always fails.

> +int drbd_dax_al_initialize(struct drbd_device *device)
> +{
> +	struct al_on_pmem *al_on_pmem =3D device->ldev->al_on_pmem;
> +	__be32 *slots =3D al_on_pmem->slots;
> +	/* The activity log area holds the magic followed by the slots. */
> +	int i, al_slots =3D device->ldev->md.al_size_4k * (SZ_4K / sizeof(*slot=
s)) - 1;
> +
> +	al_on_pmem->magic =3D cpu_to_be32(DRBD_AL_PMEM_MAGIC);
> +	/*
> +	 * Initialize all slots rather than just the configured number in case
> +	 * the configuration is later changed.
> +	 */
> +	for (i =3D 0; i < al_slots; i++) {
> +		unsigned int extent_nr =3D i < device->act_log->nr_elements ?
> +			lc_element_by_index(device->act_log, i)->lc_number :
> +			LC_FREE;
> +		slots[i] =3D cpu_to_be32(extent_nr);
> +	}
> +
> +	return 0;
> +}

[Severity: High]
Does drbd_dax_al_initialize() need to flush the initialized activity log
with arch_wb_cache_pmem() and write al_on_pmem->magic only after slots[]
are persisted?

Unlike drbd_dax_al_update(), drbd_dax_al_initialize() never calls
arch_wb_cache_pmem(), and it stores DRBD_AL_PMEM_MAGIC before populating
slots[].  If a crash or power failure occurs before the slot cache lines
are evicted from volatile CPU caches, the activity log on PMEM can have a
valid magic header with uninitialized or stale slots.

[Severity: Medium]
Can al_slots overflow a signed 32-bit int when al_size_4k is larger than
8 GiB?

check_activity_log_stripe_size() allows al_size_4k up to 4,194,304
(16 GiB).  Multiplying by SZ_4K / sizeof(*slots) (1024) produces up to
0xffffffff, which becomes negative when stored in int al_slots and causes
the loop to be skipped without initializing any slots.

[Severity: Medium]
Can drbd_dax_al_initialize() write stale extent numbers to PMEM when
device->act_log->to_be_changed has uncommitted elements?

Unlike the non-DAX drbd_al_initialize() path, which holds device->al_lock,
writes lc_new_number for entries on to_be_changed, and calls
lc_committed(device->act_log), drbd_dax_al_initialize() reads lc_number
without holding device->al_lock or committing to_be_changed.  Any pending
element on to_be_changed has its old lc_number written to PMEM and remains
on to_be_changed after the caller unlocks device->act_log.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110162646.3028=
472-1-christoph.boehmwalder@linbit.com?part=3D6
