From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ndctl PATCH v2 2/3] ndctl: add a BTT check utility
Date: Tue, 28 Feb 2017 16:11:40 -0500
Message-ID: <x49a89610mr.fsf@segfault.boston.devel.redhat.com>
References: <20170222224724.7696-1-vishal.l.verma@intel.com>
 <20170222224724.7696-3-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Hi, Vishal,

Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:

> Add the check-namespace command to ndctl. This will check the BTT
> metadata layout for the given namespace, and if requested, correct any
> errors found. Not all metadata corruption is detectable or fixable.

Thanks for the nice changelog in the 0th message, but it would be nice
to include relevant entries in the individual patches.

- Differentiate the use off BTT_PG_SIZE, sysconf(_SC_PAGESIZE), and SZ_4K
  (for the fixed start offset) in the different places they're used (Jeff)

I think you could go even further with this.  For example, you coud use
BTT_START_OFFSET for the initial offset from the beginning of the raw
namespace to the first btt info block.  Using the page size for the size
of the info block is also less informative than it could be.  Instead,
consider adding BTT_INFO_SIZE.  After that, all of your math starts to
look a bit more readable to my eye.

There's no support for parsing the badblocks list or handling
SIGBUS/SIGSEGV.  I think that's something that should be added, but it
could be done in a follow-up patch.

You go over 80 columns all over the place.  Would you mind fixing that
up?

More comments inlined below.

> Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Linda Knippers <linda.knippers-ZPxbGqLxI0U@public.gmane.org>
> Signed-off-by: Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  Documentation/Makefile.am               |   1 +
>  Documentation/ndctl-check-namespace.txt |  64 +++
>  Documentation/ndctl.txt                 |   1 +
>  Makefile.am                             |   4 +-
>  builtin.h                               |   1 +
>  ccan/bitmap/LICENSE                     |   1 +
>  ccan/bitmap/bitmap.c                    | 125 +++++
>  ccan/bitmap/bitmap.h                    | 243 +++++++++

I agree with Dan, please split out the bitmap code to a separate patch.

> +/**
> + * btt_write_info - write an info block to the given offset
> + * @bttc:	the main btt_chk structure for this btt
> + * @btt_sb:	struct btt_sb where the info block will be copied from
> + * @offset:	offset in the raw namespace to write the info block to
> + *
> + * The initial 4K offset will get added in by this routine. This will

Still not a fan of this.  :)

> + * also use 'pwrite' to write the info block, and not mmap+stores as this
> + * is used before the mappings are set up.
> + */
> +static int btt_write_info(struct btt_chk *bttc, struct btt_sb *btt_sb, u64 off)
> +{
> +	ssize_t size;
> +	int rc = 0;
> +
> +	if (!bttc->opts->repair) {
> +		error("BTT info block at offset %#lx needs to be restored\n", off);
> +		repair_msg();
> +		return -1;
> +	}
> +	printf("Restoring BTT info block at offset %#lx\n", off);

The offsets you print are off by 4k.  You do that in just about every
place you print out the offset of the btt info.

> +
> +	size = pwrite(bttc->fd, btt_sb, sizeof(*btt_sb), off + SZ_4K);
> +	if (size != sizeof(*btt_sb)) {
> +		error("unable to write the info block: %s\n", strerror(errno));
> +		rc = -errno;
> +	}

If you get a short write, errno will not be valid.  You could very well
return success from this routine when it should have failed.

I think you're missing an fsync() here.

> +	return rc;
> +}
> +
> +/**
> + * btt_copy_to_info2 - restore the backup info block using the main one
> + * @a:		the arena_info handle for this arena
> + *
> + * Called when a corrupted backup info block is detected. Copies the
> + * main info block over to the backup location. This is done using
> + * mmap + stores, and thus needs a msync.
> + */
> +static int btt_copy_to_info2(struct arena_info *a)
> +{
> +	void *ms_align;
> +	size_t ms_size;
> +
> +	if (!a->bttc->opts->repair) {
> +		error("Arena %d: BTT info2 needs to be restored\n", a->num);
> +		return repair_msg();
> +	}
> +	printf("Arena %d: Restoring BTT info2\n", a->num);
> +	memcpy(a->map.info2, a->map.info, BTT_PG_SIZE);
> +
> +	ms_align = (void *)rounddown((u64)a->map.info2,
> +			sysconf(_SC_PAGESIZE));
> +	ms_size = max(BTT_PG_SIZE, sysconf(_SC_PAGESIZE));

You call sysconf 4 times.  You might consider storing the result in a
global.

[snip]

> +/* Check that each flog entry has the correct corresponding map entry */
> +static int btt_check_log_map(struct arena_info *a)
> +{
> +	unsigned int i;
> +	u32 mapping;
> +	int rc = 0;
> +
> +	for (i = 0; i < a->nfree; i++) {
> +		struct log_entry log;
> +
> +		rc = btt_log_read(a, i, &log);
> +		if (rc)
> +			return rc;
> +		mapping = btt_map_lookup(a, log.lba);
> +
> +		/*
> +		 * Case where the flog was written, but map couldn't be updated.
> +		 * The kernel should also be able to detect and fix this condition
> +		 */
> +		if (log.new_map != mapping && log.old_map == mapping) {
> +			inform("arena %d: log[%d].new_map (%#x) doesn't match map[%#x] (%#x)",
> +				a->num, i, log.new_map, log.lba, mapping);
> +			rc = btt_map_write(a, log.lba, log.new_map);
> +			if (rc)
> +				return BTT_LOG_MAP_ERR;

What do you think about storing the return code but continuing to loop
through the rest of the log?

[snip]

> +static int btt_check_bitmap(struct arena_info *a)
> +{
> +	bitmap_t *bm;
> +	u32 i, mapping;
> +	int rc;
> +
> +	bm = bitmap_alloc0(a->internal_nlba);
> +	if (bm == NULL)
> +		return -ENOMEM;
> +
> +	/* map 'external_nlba' number of map entries */
> +	for (i = 0; i < a->external_nlba; i++) {
> +		mapping = btt_map_lookup(a, i);
> +		if (bitmap_test_bit(bm, mapping)) {
> +			inform("arena %d: internal block %#x is referenced by two map entries",
> +				a->num, mapping);
> +			rc = BTT_BITMAP_ERROR;
> +			goto out;
> +		}
> +		bitmap_set_bit(bm, mapping);
> +	}
> +
> +	/* map 'nfree' number of flog entries */
> +	for (i = 0; i < a->nfree; i++) {
> +		struct log_entry log;
> +
> +		rc = btt_log_read(a, i, &log);
> +		if (rc)
> +			goto out;
> +		if (bitmap_test_bit(bm, log.old_map)) {
> +			inform("arena %d: internal block %#x is referenced by two map/log entries",
> +				a->num, log.old_map);
> +			rc = BTT_BITMAP_ERROR;
> +			goto out;
> +		}
> +		bitmap_set_bit(bm, log.old_map);
> +	}
> +
> +	/* check that the bitmap is full */
> +	if (!bitmap_full(bm, a->internal_nlba))
> +		rc = BTT_BITMAP_ERROR;

This seems like a lost opportunity.  If a block isn't referenced,
shouldn't we link it back in?

[snip]

> +static int btt_create_mappings(struct btt_chk *bttc)
> +{
> +	struct arena_info *a;
> +	int mmap_flags;
> +	int i;
> +
> +	if (!bttc->opts->repair)
> +		mmap_flags = PROT_READ;
> +	else
> +		mmap_flags = PROT_READ|PROT_WRITE;
> +
> +	for (i = 0; i < bttc->num_arenas; i++) {
> +		a = &bttc->arena[i];
> +		a->map.info_len = BTT_PG_SIZE;
> +		a->map.info = mmap(NULL, a->map.info_len, mmap_flags,
> +			MAP_SHARED, bttc->fd, a->infooff + SZ_4K);

Is the offset in the mmap call correct for arenas other than the first?

Cheers,
Jeff
