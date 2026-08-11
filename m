Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F0634678E;
	Tue, 11 Aug 2026 22:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786486701; cv=none; b=Rwn9XGH/gS7s+J0CbYSnHQCoXSkCJSmqLHHKd/ePSBpb/MgNKihRqbWwN6pHkeEEkfMMNSGSiSSYG5iaTkBYGPL5w6TP7drxtlxvDYZE4VLj7i9yy/Wb1q6aBHxbNMovvBhNdjNiqxkjBZi5NBl2T0RwLsSpFOG6HLjhpgiJpHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786486701; c=relaxed/simple;
	bh=GdqizPjNKUS/sESjWTPlE2DUDtjAaePnChP7exL3IAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iDYPnyT1aq1aTRlL135/dSicGgsETxnvRp975EYAQHtVeuFoPg7vF0lYXOgDDmxwoxB04DjJ6ZOAFz69KAiWddToTMXMjYIzxzLfuiX23UTzXTQL0fkpmeC0f17/jpqKUIk+xDXwQ/zFrAuCEtlOpvA9ITD7fpgBXCJwGxVWECg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F66040127;
	Tue, 11 Aug 2026 22:18:08 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf09.hostedemail.com (Postfix) with ESMTPA id 89AC620028;
	Tue, 11 Aug 2026 22:17:51 +0000 (UTC)
Date: Tue, 11 Aug 2026 17:17:50 -0500
From: John Groves <john@groves.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <jic23@kernel.org>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Ira Weiny <iweiny@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Haren Myneni <haren@linux.ibm.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Ethan Nelson-Moore <enelsonmoore@gmail.com>, Gabriel Whigham <gabewhigham@gmail.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH v13 07/12] famfs: MAP_CREATE ioctl and fmap ingest (ABI
 44)
Message-ID: <ant9osbVPJyUPdWB@groves.net>
References: <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com>
 <20260810202510.96332-1-john@jagalactic.com>
 <0100019fed59de28-dde6a382-affe-4bc6-a91d-d4054a7c61a5-000000@email.amazonses.com>
 <anrUDcyctLFe8dZL@MWDK4CY14F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anrUDcyctLFe8dZL@MWDK4CY14F>
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 89AC620028
X-Stat-Signature: ynebxmmcuweffp5fb4m4pjfzamtnzggb
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18Nyk1cH53UsnaHL+/i1VTMUr0fDQgLRiE=
X-HE-Tag: 1786486671-23516
X-HE-Meta: U2FsdGVkX1/UO05OxbgKtK/k8D2whFwfdTnxCJPhimnTNePAyb8qCaOvtXPU3Nla+lUST9sB7E8hR84T3m7kl92gNPsUlQ4Yd1RvjbeRFMqta4TgQ5VbpW+8FlrHADyN8qfCDmxKOVrEt4cDOhS5bOo3Uy8YiJF7DqFV8aMMReHjPmGg96EQxTC2mnuEmxnQnXy0BFOjEU9mddAGFL4aKxS4XLFsEIgnd6HYSmfee+DDMZbQzZsZSeUb4w/+2c6E1VZl42qwAUk+JQWaCKKTPFNuZxjBC5Z6BPII266sSBKBYYIO7+HwkPGXTbDWVqqkQq/Qug6vM6LUSi/Ul0jR2bxnmHo0PxgzpsAc3nYsTb4XQnWCBCdNDHCF/Pk0mb6G

On 26/08/11 04:03PM, Richard Cheng wrote:
> On Mon, Aug 10, 2026 at 08:25:17PM +0800, John Groves wrote:
> > From: John Groves <john@groves.net>
> >
> 
> Hi John,
> 
> I have some questions below.
>  
> > Add the famfs file ioctl handler (FAMFSIOC_NOP, FAMFSIOC_MAP_CREATE) and
> > the KABI-44 self-describing fmap message: the wire ABI in famfs_ioctl.h
> > (famfs_ioc_fmap_header plus the simple and interleaved extent structs), the
> > in-core famfs_file_meta, and famfs_file_init_dax(), which copies the
> > message in, parses both the simple-extent and interleaved (striped) wire
> > forms into inode->i_private, and sets S_DAX.
> > 
> > Resolving those mappings to dax-device offsets (iomap_begin) is added in
> > the following commit; the read/write/fault paths keep their NULL iomap_ops
> > stub until then.
> > 
> > Famfs now accepts extent and chunk alignment at either PMD or PTE. PMD
> > is the normal case, and it guarantees PMD faults - which is right for
> > large files, which are the original use case. But there are also active
> > use cases that use zillions of small files, and those need PTE support
> > to avoid big space amplification.
> > 
> > Also add famfs ioctls to ioctl-number.rst
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> > v13:
> >  - Renamed the read-only module parameter famfs_kabi_version -> kabi_version;
> >    it already lives under /sys/module/famfs/parameters/, so the famfs_ prefix
> >    was redundant. New path: /sys/module/famfs/parameters/kabi_version (same
> >    for =y and =m).
> >  - Dropped the proposed GET_GEOMETRY ioctl (Darrick suggested turning the NOP
> >    ioctl into one reporting the abi version and page/pmd sizes). The abi
> >    version and supported allocation units are module-wide and needed before
> >    mount, where an ioctl cannot reach; they are exposed as read-only module
> >    parameters instead (kabi_version already is; alloc-unit reporting will
> >    follow when sub-PMD support lands). FAMFSIOC_NOP is retained as the
> >    "is this famfs?" probe (Darrick).
> >  - Accept 4 KiB extent alignment, not only 2 MiB. Extent offset and length
> >    (simple extents and interleaved strips) must now be PAGE_SIZE-aligned
> >    instead of PMD_SIZE-aligned -- page alignment is a superset, so 2 MiB
> >    fmaps still pass, and a 4 KiB-granular fmap is now accepted and maps as
> >    PTEs (the fault path already falls back PMD -> PTE, while 2 MiB-aligned
> >    extents still get huge pages). The interleaved striping chunk_size must be
> >    exactly one supported allocation unit -- PAGE_SIZE (4 KiB) or PMD_SIZE
> >    (2 MiB) -- not an arbitrary page multiple. The alloc-unit module param to
> >    advertise supported granularities is deferred.
> > 
> >  .../userspace-api/ioctl/ioctl-number.rst      |   1 +
> >  fs/famfs/famfs_file.c                         | 328 +++++++++++++++++-
> >  fs/famfs/famfs_inode.c                        |   1 +
> >  fs/famfs/famfs_internal.h                     |  46 +++
> >  include/uapi/linux/famfs_ioctl.h              |  91 +++++
> >  5 files changed, 464 insertions(+), 3 deletions(-)
> >  create mode 100644 include/uapi/linux/famfs_ioctl.h
> > 
> > diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > index 3f0ef1e27eb0..5e244dec1b98 100644
> > --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > @@ -299,6 +299,7 @@ Code  Seq#    Include File                                             Comments
> >  'u'   00-2F  linux/ublk_cmd.h                                          conflict!
> >  'u'   20-3F  linux/uvcvideo.h                                          USB video class host driver
> >  'u'   40-4f  linux/udmabuf.h                                           userspace dma-buf misc device
> > +'u'   50-5F  linux/famfs_ioctl.h                                       famfs shared memory file system
> >  'v'   00-1F  linux/ext2_fs.h                                           conflict!
> >  'v'   00-1F  linux/fs.h                                                conflict!
> >  'v'   00-0F  linux/sonypi.h                                            conflict!
> > diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> > index 9c1cd2f67489..ba19b17e80b1 100644
> > --- a/fs/famfs/famfs_file.c
> > +++ b/fs/famfs/famfs_file.c
> > @@ -13,9 +13,315 @@
> >  #include <linux/mm.h>
> >  #include <linux/dax.h>
> >  #include <linux/iomap.h>
> > +#include <linux/capability.h>
> >  
> > +#include <linux/famfs_ioctl.h>
> >  #include "famfs_internal.h"
> >  
> > +/* Expose famfs kernel abi version as a read-only module parameter */
> > +static int kabi_version = FAMFS_KABI_VERSION;
> > +module_param(kabi_version, int, 0444);
> > +MODULE_PARM_DESC(kabi_version, "famfs kernel abi version");
> > +
> > +void
> > +famfs_meta_free(struct famfs_file_meta *map)
> > +{
> > +	if (map) {
> > +		switch (map->fm_extent_type) {
> > +		case FAMFS_IOC_EXT_SIMPLE:
> > +			kfree(map->se);
> > +			break;
> > +		case FAMFS_IOC_EXT_INTERLEAVE:
> > +			if (map->ie) {
> > +				u32 i;
> > +
> > +				for (i = 0; i < map->fm_niext; i++)
> > +					kfree(map->ie[i].ie_strips);
> > +			}
> > +			kfree(map->ie);
> > +			break;
> > +		default:
> > +			break;
> > +		}
> > +	}
> > +	kfree(map);
> > +}
> > +
> > +static int
> > +famfs_check_ext_alignment(struct famfs_meta_simple_ext *se)
> > +{
> > +	int errs = 0;
> > +
> > +	if (!IS_ALIGNED(se->ext_offset, PAGE_SIZE))
> > +		errs++;
> > +	if (!IS_ALIGNED(se->ext_len, PAGE_SIZE))
> > +		errs++;
> > +
> > +	return errs;
> > +}
> > +
> > +/**
> > + * famfs_file_init_dax() - FAMFSIOC_MAP_CREATE ioctl handler
> > + * @file: the un-initialized file
> > + * @arg:  user pointer to a self-describing fmap message
> > + *
> > + * The map-create ioctl carries the fmap as a self-describing message: a
> > + * struct famfs_ioc_fmap_header followed by an extent list. The message is
> > + * copied in, parsed into a famfs_file_meta, and published on inode->i_private.
> > + * Both the simple-extent and the interleaved (striped) wire forms are handled.
> > + * The wire layout byte-matches the fmap carried in a fuse famfs GET_FMAP reply.
> > + */
> > +static int
> > +famfs_file_init_dax(struct file *file, void __user *arg)
> > +{
> > +	struct famfs_ioc_fmap_header fmh;
> > +	struct famfs_file_meta *meta = NULL;
> > +	struct famfs_fs_info *fsi;
> > +	struct super_block *sb;
> > +	struct inode *inode;
> > +	void *fmap_buf = NULL;
> > +	size_t extent_total = 0;
> > +	size_t next_offset;
> > +	int errs = 0;
> > +	int rc;
> > +	u32 i, j;
> > +
> > +	inode = file_inode(file);
> > +	if (!inode)
> > +		return -EBADF;
> > +	if (inode->i_private)
> > +		return -EEXIST;
> > +
> > +	sb  = inode->i_sb;
> > +	fsi = sb->s_fs_info;
> > +	if (fsi->deverror)
> > +		return -ENODEV;
> > +	if (!famfs_opt_enabled(fsi, FAMFS_OPT_MAP_CREATE))
> > +		return -EPERM;
> > +
> 
> I think this only check whether MAP_CREATE is enabled for the mount ?
> 
> Does it check whether the caller is trusted or not ? I think no ?
> 
> Maybe we require more privilege such as CAP_SYS_RAWIO, FMODE_WRITE?

CAP_SYS_RAWIO is checked on DAXDEV_OPEN, so no daxdevs can be enabled
without it. But it's a fair point that if CAP_SYS_RAWIO is not checked
when initializing a file map (MAP_CREATE) files could be created 
that point where they shouldn't...within the set of daxdevs that were
provided with the CAP_SYS_RAWIO gate.

I'll add a CAP_SYS_RAWIO check here too.

Thanks!

> 
> 
> > +	if (copy_from_user(&fmh, arg, sizeof(fmh)))
> > +		return -EFAULT;
> > +
> > +	if (fmh.fmap_version != FAMFS_FMAP_VERSION)
> > +		return -EINVAL;
> > +	if (fmh.fmap_size < sizeof(fmh))
> > +		return -EINVAL;
> > +	if (fmh.fmap_size > FAMFS_FMAP_MSG_MAX)
> > +		return -EFBIG;
> > +	if (fmh.nextents < 1)
> > +		return -EINVAL;
> > +
> > +	fmap_buf = kvmalloc(fmh.fmap_size, GFP_KERNEL);
> > +	if (!fmap_buf)
> > +		return -ENOMEM;
> > +
> > +	if (copy_from_user(fmap_buf, arg, fmh.fmap_size)) {
> > +		rc = -EFAULT;
> > +		goto out;
> > +	}
> > +	next_offset = sizeof(fmh);	/* start of the extent list */
> > +
> > +	meta = kzalloc_obj(*meta, GFP_KERNEL);
> > +	if (!meta) {
> > +		rc = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> > +	meta->error = false;
> > +	meta->file_type = fmh.file_type;
> > +	meta->file_size = fmh.file_size;
> > +	meta->fm_extent_type = fmh.ext_type;
> > +
> > +	switch (fmh.ext_type) {
> > +	case FAMFS_IOC_EXT_SIMPLE: {
> > +		struct famfs_ioc_simple_ext *se_in = fmap_buf + next_offset;
> > +
> > +		next_offset += (size_t)fmh.nextents * sizeof(*se_in);
> > +		if (next_offset > fmh.fmap_size) {
> > +			rc = -EINVAL;
> > +			goto out;
> > +		}
> > +
> > +		meta->fm_nextents = fmh.nextents;
> > +		meta->se = kcalloc(meta->fm_nextents, sizeof(*meta->se),
> > +				   GFP_KERNEL);
> > +		if (!meta->se) {
> > +			rc = -ENOMEM;
> > +			goto out;
> > +		}
> > +
> > +		for (i = 0; i < fmh.nextents; i++) {
> > +			meta->se[i].dev_index  = se_in[i].se_devindex;
> > +			meta->se[i].ext_offset = se_in[i].se_offset;
> > +			meta->se[i].ext_len    = se_in[i].se_len;
> > +
> > +			if (meta->se[i].dev_index >= FAMFS_MAX_DAXDEVS) {
> > +				rc = -EINVAL;
> > +				goto out;
> > +			}
> > +			meta->dev_bitmap |= BIT_ULL(meta->se[i].dev_index);
> > +			errs += famfs_check_ext_alignment(&meta->se[i]);
> > +			extent_total += meta->se[i].ext_len;
> 
> offset + length + entent_total can overflow, and file_size can be larger
> than MAX_LFS_FILESIZE. And overflow can wrap the DAX address back to 0
> and map the wrong memory.
> 
> Maybe check_add_overflow() can be utilized ?

Good idea, thanks!

> 
> 
> > +		}
> > +		break;
> > +	}
> > +
> > +	case FAMFS_IOC_EXT_INTERLEAVE: {
> > +		s64 size_remainder = meta->file_size;
> > +		u32 niext = fmh.nextents;
> > +
> > +		meta->fm_niext = niext;
> > +		meta->ie = kcalloc(niext, sizeof(*meta->ie), GFP_KERNEL);
> > +		if (!meta->ie) {
> > +			rc = -ENOMEM;
> > +			goto out;
> > +		}
> > +
> > +		/* Outer loop is over the separate interleaved extents */
> > +		for (i = 0; i < niext; i++) {
> > +			struct famfs_ioc_iext *ie_in = fmap_buf + next_offset;
> > +			struct famfs_ioc_simple_ext *sie_in;
> > +			u64 nstrips;
> > +
> > +			next_offset += sizeof(*ie_in);
> > +			if (next_offset > fmh.fmap_size) {
> > +				rc = -EINVAL;
> > +				goto out;
> > +			}
> > +
> > +			/* chunk_size must be exactly one supported alloc unit */
> > +			if (ie_in->ie_chunk_size != PAGE_SIZE &&
> > +			    ie_in->ie_chunk_size != PMD_SIZE) {
> > +				rc = -EINVAL;
> > +				goto out;
> > +			}
> > +			if (ie_in->ie_nbytes == 0) {
> > +				rc = -EINVAL;
> > +				goto out;
> > +			}
> > +
> > +			nstrips = ie_in->ie_nstrips;
> > +			if (nstrips < 1) {
> > +				rc = -EINVAL;
> > +				goto out;
> > +			}
> > +
> > +			meta->ie[i].fie_chunk_size = ie_in->ie_chunk_size;
> > +			meta->ie[i].fie_nstrips    = ie_in->ie_nstrips;
> > +			meta->ie[i].fie_nbytes     = ie_in->ie_nbytes;
> > +
> > +			/* The strip extents follow the interleaved-ext header */
> > +			sie_in = fmap_buf + next_offset;
> > +			next_offset += nstrips * sizeof(*sie_in);
> > +			if (next_offset > fmh.fmap_size) {
> > +				rc = -EINVAL;
> > +				goto out;
> > +			}
> > +
> > +			meta->ie[i].ie_strips =
> > +				kcalloc(nstrips,
> > +					sizeof(meta->ie[i].ie_strips[0]),
> > +					GFP_KERNEL);
> > +			if (!meta->ie[i].ie_strips) {
> > +				rc = -ENOMEM;
> > +				goto out;
> > +			}
> > +
> > +			/* Inner loop is over the strips */
> > +			for (j = 0; j < nstrips; j++) {
> > +				struct famfs_meta_simple_ext *so =
> > +					&meta->ie[i].ie_strips[j];
> > +
> > +				so->dev_index  = sie_in[j].se_devindex;
> > +				so->ext_offset = sie_in[j].se_offset;
> > +				so->ext_len    = sie_in[j].se_len;
> > +
> > +				if (so->dev_index >= FAMFS_MAX_DAXDEVS) {
> > +					rc = -EINVAL;
> > +					goto out;
> > +				}
> > +				meta->dev_bitmap |= BIT_ULL(so->dev_index);
> > +				errs += famfs_check_ext_alignment(so);
> > +				extent_total += so->ext_len;
> > +				size_remainder -= so->ext_len;
> 
> We use physical allocation size here to check logical file coverage,
> it doesn't make sense to me.
> For example, file_size can be 1MB and ie_nbytes only 4KB, but a 1MB ext_len makes this check pass, and you access the area after the first 4 KB will fail,
> because it has no logical mapping.
> 
> Maybe we should make sure the sum of ie_nbytes covers file_size, and
> separately check that each strip's ext_len is large enough for its assigned
> chunks ?

Chapeau to you for actually studying this code. Not many have gone
there. It's arcane, but logically not too complicated.

You're right that famfs_file_init_dax() doesn't check for pathological
strip sizes or overflows. It does do some basic checking, but would
not catch a short strip followed by one or more "correct" strips.
That stuff would indicate a buggy or malicious caller, since it
violates the fmap logic.

However, the vma fault handler for interleaved files, 
famfs_meta_to_dax_offset_interleaved(), *does* check for strip 
overflows. It resolves a file offset to an offset in a specific
strip (based on strip count and chunk size), and then checks that 
it falls within the strip and not past the end.

Here is that code:

	/*
	 * MAP_CREATE only checks that the strips' combined
	 * length covers the file, not that each strip is large
	 * enough for the chunks striped onto it. Guard against a
	 * malformed fmap with an undersized strip so we never
	 * resolve to a dax offset past the strip's extent.
	 */
	if (strip_offset >= strip->ext_len)
		goto err_out;

	daxdev = famfs_daxdev_from_index(fsi, strip->dev_index, &rc);
	if (!daxdev) {
		meta->error = true;
		return rc;
	}

	iomap->addr    = strip->ext_offset + strip_offset;
	iomap->offset  = file_offset;
	iomap->length  = min_t(loff_t, len, chunk_remainder);
	iomap->length  = min_t(loff_t, iomap->length,
			       strip->ext_len - strip_offset);
	iomap->dax_dev = daxdev;
	iomap->type    = IOMAP_MAPPED;

	return 0;

Since this condition is an error or malice on the part of the 
MAP_CREATE caller, I'm comfortable with catching it at fault time.

> 
> 
> > +			}
> > +		}
> > +
> > +		if (size_remainder > 0) {
> > +			/* Strips do not cover the whole file */
> > +			rc = -EINVAL;
> > +			goto out;
> > +		}
> > +		break;
> > +	}
> > +
> > +	default:
> > +		rc = -EINVAL;
> > +		goto out;
> > +	}
> > +
> > +	if (errs > 0) {
> > +		rc = -EINVAL;
> > +		goto out;
> > +	}
> > +	if (extent_total < meta->file_size) {
> > +		rc = -EINVAL;
> > +		goto out;
> > +	}
> > +
> > +	/* Publish the famfs metadata on inode->i_private */
> > +	inode_lock(inode);
> > +	if (inode->i_private) {
> > +		rc = -EEXIST; /* file already has famfs metadata */
> > +	} else {
> > +		inode->i_private = meta;
> > +		i_size_write(inode, meta->file_size);
> > +		inode->i_flags |= S_DAX;
> > +		meta = NULL; /* owned by the inode now */
> > +		rc = 0;
> > +	}
> > +	inode_unlock(inode);
> > +
> > +out:
> > +	kvfree(fmap_buf);
> > +	if (meta)
> > +		famfs_meta_free(meta);
> > +	return rc;
> > +}
> > +
> > +/**
> > + * famfs_file_ioctl() - Top-level famfs file ioctl handler
> > + * @file: the file
> > + * @cmd:  ioctl opcode
> > + * @arg:  ioctl opcode argument (if any)
> > + */
> > +static long
> > +famfs_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> > +{
> > +	struct inode *inode = file_inode(file);
> > +	struct famfs_fs_info *fsi = inode->i_sb->s_fs_info;
> > +	long rc;
> > +
> > +	if (fsi->deverror && (cmd != FAMFSIOC_NOP))
> > +		return -ENODEV;
> > +
> > +	switch (cmd) {
> > +	case FAMFSIOC_NOP:
> > +		rc = 0;
> > +		break;
> > +
> > +	case FAMFSIOC_MAP_CREATE:
> > +		rc = famfs_file_init_dax(file, (void __user *)arg);
> > +		break;
> > +
> > +	default:
> > +		rc = -ENOTTY;
> > +		break;
> > +	}
> > +
> > +	return rc;
> > +}
> > +
> >  /*********************************************************************
> >   * vm_operations
> >   */
> > @@ -94,9 +400,25 @@ const struct vm_operations_struct famfs_file_vm_ops = {
> >  static ssize_t
> >  famfs_file_invalid(struct inode *inode)
> >  {
> > +	struct famfs_file_meta *meta = inode->i_private;
> > +	size_t i_size = i_size_read(inode);
> > +
> > +	if (!meta) {
> > +		pr_debug("%s: un-initialized famfs file\n", __func__);
> > +		return -EIO;
> > +	}
> > +	if (meta->error) {
> > +		pr_debug("%s: previously detected metadata errors\n", __func__);
> > +		return -EIO;
> > +	}
> > +	if (i_size != meta->file_size) {
> > +		pr_warn("%s: i_size overwritten from %ld to %ld\n",
> > +		       __func__, meta->file_size, i_size);
> > +		meta->error = true;
> > +		return -ENXIO;
> > +	}
> >  	if (!IS_DAX(inode)) {
> > -		pr_debug("%s: inode %llx IS_DAX is false\n",
> > -			 __func__, (u64)inode);
> > +		pr_debug("%s: inode %llx IS_DAX is false\n", __func__, (u64)inode);
> >  		return -ENXIO;
> >  	}
> >  	return 0;
> > @@ -233,7 +555,7 @@ const struct file_operations famfs_file_operations = {
> >  	/* Custom famfs operations */
> >  	.write_iter	   = famfs_dax_write_iter,
> >  	.read_iter	   = famfs_dax_read_iter,
> > -	.unlocked_ioctl    = NULL /*famfs_file_ioctl*/,
> > +	.unlocked_ioctl    = famfs_file_ioctl,
> >  	.mmap		   = famfs_file_mmap,
> > 
> 
> We don't have compat_ioctl handler, a 32-bit application on a 64-bit
> kernel will get ENOTTY, if we will have that scenario I think the handler
> should be added.
> 
> Best regards,
> Richard Cheng.

This one is simple but arcane. Here are the kconfig deps:

FAMFS -> FS_DAX -> ZONE_DEVICE -> MEMORY_HOTPLUG

And MEMORY_HOTPLUG is depends on 64BIT. So famfs is definitively 64BIT-only.

In this series I added a direct dependency on 64BIT, to make it more 
clear...

Thanks,
John

<snip>

