From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ndctl: add a BTT check utility
Date: Fri, 20 Jan 2017 18:14:23 -0500
Message-ID: <x49lgu52uk0.fsf@segfault.boston.devel.redhat.com>
References: <20170120031234.24226-1-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170120031234.24226-1-vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> (Vishal Verma's
 message of "Thu, 19 Jan 2017 20:12:34 -0700")
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

First, thanks a lot for tackling this!  Overall, the code looks pretty
clean.  I've got a few general comments, and then you can scroll down
for code review.  I didn't get through the whole thing, so I'll try to
pick up where I left off next week.

How was this tested?  Did you perturb the btt in ways that you expect
can and can't be fixed?  Can you add tests for that?

Checking should not be an optional feature.  Just always build it in.

Why should a user have to disable a namespace in order to run the
checker?  I guess that's the analog of unmounting an fs?  Still, seems
like we could just do that for the user.

Can this code in any way be shared with libpmemblk?  They have their own
checker (which does different things), and it seems like a lost
opportunity to not be able to leverage the same code in both places.

Overall, the code could use more comments.

Does this really all belong in builtin-xaction-namespace.c?  It seems
too btt specific for that.  Maybe it's time to create a new file.
I'll leave that up to Dan for his preference.

There seems to be a lot of repeated code sequences around reading and
verifying the btt info blocks.  Perhaps that can be factored out?  Maybe
get rid of the first_sb special snowflake and roll that into the arena
discovery?

> diff --git a/ndctl/btt-structs.h b/ndctl/btt-structs.h

> +#define IB_FLAG_ERROR 0x00000001
> +#define IB_FLAG_ERROR_MASK 0x00000001

IB_FLAG_ERROR is defined but never used/checked.  Of course, neither the
kernel nor this utility will set that flag.  We should probably decide
whether it makes sense to do so.

> +static int btt_read_info(struct btt_chk *bttc, struct btt_sb *btt_sb, __u64 off)
> +{
> +	int fd, rc = 0;
> +	ssize_t size;
> +
> +	fd = open(bttc->path, O_RDONLY);
> +	if (fd < 0) {
> +		error("unable to open %s: %s\n", bttc->path, strerror(errno));
> +		return -errno;
> +	}
> +
> +	size = pread(fd, btt_sb, sizeof(*btt_sb), off + SZ_4K);
> +	if (size != sizeof(*btt_sb)) {
> +		error("unable to read first info block: %s\n", strerror(errno));
> +		rc = -errno;

Short reads will not set errno, so you'll return 0 incorrectly, here.

> +	}
> +	close(fd);
> +	return rc;
> +}

I find it odd that the caller has to pass in the offset 4k before the
start of the info block.  It seems natural for the first info block, but
for the backup, it's totally bogus.  ;-)

> +static int btt_copy_to_info2(struct arena_info *a)
> +{
> +	if (dryrun) {
> +		error("Arena %d: BTT info2 needs to be restored\n", a->num);
> +		return dryrun_msg();
> +	}
> +	printf("Arena %d: Restoring BTT info2\n", a->num);
> +	memcpy(a->map.info2, a->map.info, BTT_PG_SIZE);

missing msync();

> +static int btt_map_read(struct arena_info *a, __u32 lba, __u32 *mapping,
> +			int *trim, int *error)
> +{
> +	__u32 raw_mapping, postmap, ze, z_flag, e_flag;
> +
> +	raw_mapping = le32toh(a->map.map[lba]);
> +	z_flag = (raw_mapping & MAP_TRIM_MASK) >> MAP_TRIM_SHIFT;
> +	e_flag = (raw_mapping & MAP_ERR_MASK) >> MAP_ERR_SHIFT;
> +	ze = (z_flag << 1) + e_flag;
> +	postmap = raw_mapping & MAP_LBA_MASK;
> +
> +	/* Reuse the {z,e}_flag variables for *trim and *error */
> +	z_flag = 0;
> +	e_flag = 0;
> +
> +	switch (ze) {
> +	case 0:
> +		/* Initial state. Return postmap = premap */
> +		*mapping = lba;
> +		break;
> +	case 1:
> +		*mapping = postmap;
> +		e_flag = 1;
> +		break;
> +	case 2:
> +		*mapping = postmap;
> +		z_flag = 1;
> +		break;
> +	case 3:
> +		*mapping = postmap;
> +		break;
> +	default:
> +		return -EIO;
> +	}
> +
> +	if (trim)
> +		*trim = z_flag;
> +	if (error)
> +		*error = e_flag;
> +
> +	return 0;
> +}

No caller uses z or e, so get rid of those args.  Also, your default
entry in the switch statement can never be hit.  Fixing those, the
function is just:

/*
 * btt_map_lookup
 *
 * Given a pre-map Arena Block Address, return the post-map ABA.
 */
static u32 btt_map_lookup(struct arena_info *a, __u32 lba)
{
        return (le32toh(a->map.map[lba]) & MAP_LBA_MASK);
}

You can take or leave the function name change.  Please keep the
comment, and maybe kernel-doc-ify it.

> +static int btt_map_write(struct arena_info *a, __u32 lba, __u32 mapping,
> +			__u32 z_flag, __u32 e_flag)
> +{

Again, z and e are unused.  Nuke 'em.

[snip]
> +	a->map.map[lba] = htole32(mapping);
> +	if (msync((void *)rounddown((__u64)&a->map.map[lba], BTT_PG_SIZE),
> +		BTT_PG_SIZE, MS_SYNC) < 0)
> +		return errno;

You are aligning msync calls to the BTT_PG_SIZE, which is wrong.  It
should be aligned to the system page size.

In fact, you abuse BTT_PG_SIZE all over the place.  You use it to mean:
- system page size
- size of the btt info block
- the btt page size ;-)

It would be nice if you could clean that up.

Should we perform a load of the info block after the msync to ensure it
was written (to trigger an MCE if one is going to happen)?  That same
question could be asked for each place where an update is made.

> +static void btt_parse_meta(struct arena_info *arena, struct btt_sb *btt_sb,
> +				__u64 arena_off)
> +{
> +	arena->internal_nlba = le32toh(btt_sb->internal_nlba);
> +	arena->internal_lbasize = le32toh(btt_sb->internal_lbasize);
> +	arena->external_nlba = le32toh(btt_sb->external_nlba);
> +	arena->external_lbasize = le32toh(btt_sb->external_lbasize);
> +	arena->nfree = le32toh(btt_sb->nfree);
> +	arena->version_major = le16toh(btt_sb->version_major);
> +	arena->version_minor = le16toh(btt_sb->version_minor);
> +
> +	arena->nextoff = (btt_sb->nextoff == 0) ? 0 : (arena_off +
> +			le64toh(btt_sb->nextoff));
> +	arena->infooff = arena_off;
> +	arena->dataoff = arena_off + le64toh(btt_sb->dataoff);
> +	arena->mapoff = arena_off + le64toh(btt_sb->mapoff);
> +	arena->logoff = arena_off + le64toh(btt_sb->logoff);
> +	arena->info2off = arena_off + le64toh(btt_sb->info2off);
> +
> +	arena->size = (le64toh(btt_sb->nextoff) > 0)
> +		? (le64toh(btt_sb->nextoff))
> +		: (arena->info2off - arena->infooff + BTT_PG_SIZE);
> +
> +	arena->flags = le32toh(btt_sb->flags);
> +}

Maybe it doesn't belong in the parse routine, but there is no sanity
checking on this data, and there really should be.

> +/* Check that log entries are self consistent */
> +static int btt_check_map_entries(struct arena_info *a)
> +{
> +	int rc = 0, z, e;
> +	unsigned int i;
> +	__u32 mapping;
> +
> +	for (i = 0; i < a->external_nlba; i++) {
> +		rc = btt_map_read(a, i, &mapping, &z, &e);
> +		if (rc)
> +			return rc;
> +		if (mapping >= a->internal_nlba)
> +			return BTT_MAP_OOB;
> +	}
> +	return 0;
> +}

libpmemblk's version of this keeps a bitmap of allocated blocks and free
blocks (from the flog), and then generates a warning if there are
duplicate blocks allocated or unreachable blocks.  I think we should do
the same.


> +/* Check that each flog entry has the correct corresponding map entry */
> +static int btt_check_log_map(struct arena_info *a)
> +{
> +	unsigned int i;
> +	__u32 mapping;
> +	int rc = 0;
> +
> +	for (i = 0; i < a->nfree; i++) {
> +		struct log_entry log;
> +
> +		rc = btt_log_read(a, i, &log);
> +		if (rc)
> +			return rc;
> +		rc = btt_map_read(a, log.lba, &mapping, NULL, NULL);
> +		if (rc)
> +			return rc;
> +
> +		/*
> +		 * Case where the flog was written, but map couldn't be updated.
> +		 * The kernel should also be able to detect and fix this condition
> +		 */
> +		if (log.new_map != mapping && log.old_map == mapping) {
> +			error("arena %d: log[%d].new_map (%#x) doesn't match map[%#x] (%#x)",
> +				a->num, i, log.new_map, log.lba, mapping);

This isn't an error.  We expect this to happen if power is suddenly
lost, and the format is built to recover from it.  If you log it at all,
I would make it an informational message.

I wonder whether we should even fix it.  I worry about having the same
recovery code in multiple places (the kernel and here).  What do you
think?

> +static int btt_recover_first_sb(struct btt_chk *bttc)
> +{
[snip]
> +	/*
> +	 * Attempt 2: From the very end of 'rawsize', try to copy the fields
> +	 * that are constant in every arena (only valid when multiple arenas
> +	 * are present)
> +	 */
> +	if (est_arenas > 1) {
> +		offset = rounddown(bttc->rawsize - remaining, BTT_PG_SIZE) -
> +			2 * BTT_PG_SIZE;
> +		printf("Attempting to recover info-block from end offset %#llx\n", offset);
> +		rc = btt_read_info(bttc, &btt_sb[1], offset);
> +		if (rc)
> +			goto out;

How about we verify the info block before blindlly copying in the data?
I know you verify the result, but it's weird.

> +		/* copy over the arena0 specific fields from btt_sb[0] */
> +		btt_sb[1].flags = btt_sb[0].flags;
> +		btt_sb[1].external_nlba = btt_sb[0].external_nlba;
> +		btt_sb[1].internal_nlba = btt_sb[0].internal_nlba;
> +		btt_sb[1].nextoff = btt_sb[0].nextoff;
> +		btt_sb[1].dataoff = btt_sb[0].dataoff;
> +		btt_sb[1].mapoff = btt_sb[0].mapoff;
> +		btt_sb[1].logoff = btt_sb[0].logoff;
> +		btt_sb[1].info2off = btt_sb[0].info2off;
> +		btt_sb[1].checksum = btt_sb[0].checksum;
> +		rc = btt_info_verify(bttc, &btt_sb[1]);
> +		if (rc == 0) {
> +			rc = btt_write_info(bttc, &btt_sb[1], 0);
> +			goto out;
> +		}
> +	}
> +
> +	/*
> +	 * Attempt 3: use info2off as-is, and check if we find a valid info
> +	 * block at that location.
> +	 */
> +	 offset = le32toh(btt_sb[0].info2off);
> +	 if (offset) {

Maybe do some bounds checking on offset?

> +		printf("Attempting to recover info-block from info2 offset (as-is) %#llx\n", offset);
> +		rc = btt_read_info(bttc, &btt_sb[1], offset);
> +		if (rc)
> +			goto out;
> +		rc = btt_info_verify(bttc, &btt_sb[1]);
> +		if (rc == 0) {
> +			rc = btt_write_info(bttc, &btt_sb[1], 0);
> +			goto out;
> +		}
> +	} else
> +		rc = -ENXIO;

You could also look for the primary info blocks for the other arenas.

> + out:
> +	free(btt_sb);
> +	return rc;
> +}
> +
> +static int namespace_check(struct ndctl_region *region,
> +		struct ndctl_namespace *ndns)
> +{

namespace_check sounds generic, but it really only works for the btt.
Also, should we verify that the namespace was configured with a btt
before even attempting to check it?

> +	raw_mode = ndctl_namespace_get_raw_mode(ndns);
> +	ndctl_namespace_set_raw_mode(ndns, 1);
> +	rc = ndctl_namespace_enable(ndns);
> +	if (rc != 0)
> +		error("%s: failed to enable raw mode\n", devname);
> +	ndctl_namespace_set_raw_mode(ndns, raw_mode);

What the heck do the above 6 lines do?  Please explain.

Thanks!
Jeff
