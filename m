Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D64236403D;
	Thu,  6 Aug 2026 20:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786049967; cv=none; b=R0Wm48XPAPY8rhJiKLZsnuaPOe3KNkXxRC04s4rVSYhkqlIPOvtB+Htx/zYj1LmXrvFqq+dYQODllHpyadvnFnvAk/ivifDT84L7txx5K1pptf4IoLze0RMp6XIvsMqSUcMXV36wiFTAp+AVb/ifdmAOyawhcrMmKL0S7bEpk1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786049967; c=relaxed/simple;
	bh=f+glLTwLHrgOx3n5kNTZD8gFaKG3d+0k50x/OseJ1k8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CmhHWHOjWPmi0FB59X4fXHxyCM4kZJQ7pKf0gqd/svUy8Epj0edD1vPd1KMM97y8ZrIgPeF7ELgkOqHhgGLfw+PCbSt638uEsZ+MqJo6NiIiKeN9OpWEjmYZOr3UnpR+jbb+Z4VfgiP9dwzO2QEyAoHm8hMF9WRx+9BAMOMBwTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A703A140134;
	Thu,  6 Aug 2026 20:53:31 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf06.hostedemail.com (Postfix) with ESMTPA id E2B4220010;
	Thu,  6 Aug 2026 20:53:14 +0000 (UTC)
Date: Thu, 6 Aug 2026 15:53:13 -0500
From: John Groves <John@groves.net>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <jic23@kernel.org>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
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
Subject: Re: [PATCH V12 07/12] famfs: MAP_CREATE ioctl and fmap ingest (ABI
 44)
Message-ID: <anTxt3qsUQuCKvMz@groves.net>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022919.75875-1-john@jagalactic.com>
 <0100019fc5746312-6cfe9a07-a658-4aba-b1e9-5233b0ddfcf4-000000@email.amazonses.com>
 <20260806052449.GG3560084@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806052449.GG3560084@frogsfrogsfrogs>
X-Stat-Signature: moa1cpj8pcs6f16nimka5m19rgobpa64
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: E2B4220010
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX19crjVaPOFBEHmKBC7wFurdodKMOgzBtgA=
X-HE-Tag: 1786049594-931971
X-HE-Meta: U2FsdGVkX1/4IpGuRLK5HgSSFcQqi44u6Z1DdtiGAfxjzuoLO+PsjuPjwAKirjJX7OtYtPChdy9wL09X/s9feMcatR6K08AJBqaEEKgLj0cZgyU6xLu2skbPALPZxqc3I0zKBjh/pX+ft5373sWXay0M/G93BVTmK4Ua99Oq1vRi65PTG46zEzA2S06wGD6DNn44Q0r7Itg69TuxX03OIdqfHmPwHysgpbJXfx+HzNk4bNPJk4fzzYszQ6XvrVDBxnDayxHngCtwX9tEB8SRI+JwDNbOB/nP1D+Pyvqcbb8rEuaW1mAV7p9IyWrEzDSAHu0wQ3adQFzxpvQXRQo6vSXrh2RW0ynyYuRFnp7qUraMUAUPT9guGQ7k/0W9zbVS

On 26/08/05 10:24PM, Darrick J. Wong wrote:
> On Mon, Aug 03, 2026 at 02:29:26AM +0000, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
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
> > Also add famfs ioctls to ioctl-number.rst
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  .../userspace-api/ioctl/ioctl-number.rst      |   1 +
> >  fs/famfs/famfs_file.c                         | 326 +++++++++++++++++-
> >  fs/famfs/famfs_inode.c                        |   1 +
> >  fs/famfs/famfs_internal.h                     |  46 +++
> >  include/uapi/linux/famfs_ioctl.h              |  91 +++++
> >  5 files changed, 462 insertions(+), 3 deletions(-)
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
> > index 678f2035fd5f..d710c8a0c923 100644
> > --- a/fs/famfs/famfs_file.c
> > +++ b/fs/famfs/famfs_file.c
> > @@ -13,9 +13,313 @@
> >  #include <linux/mm.h>
> >  #include <linux/dax.h>
> >  #include <linux/iomap.h>
> > +#include <linux/capability.h>
> >  
> > +#include <linux/famfs_ioctl.h>
> >  #include "famfs_internal.h"
> >  
> > +/* Expose famfs kernel abi version as a read-only module parameter */
> > +static int famfs_kabi_version = FAMFS_KABI_VERSION;
> > +module_param(famfs_kabi_version, int, 0444);
> > +MODULE_PARM_DESC(famfs_kabi_version, "famfs kernel abi version");
> 
> Maybe make the "NOP" ioctl a geometry ioctl that tells you the abi
> version and (I guess) the page and pmd size? :D

I like it - will do

> 
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
> 
> This kerneldoc is for the next function?

Oops, fixed thanks!

> 
> > +static int
> > +famfs_check_ext_alignment(struct famfs_meta_simple_ext *se)
> > +{
> > +	int errs = 0;
> > +
> > +	if (!IS_ALIGNED(se->ext_offset, PMD_SIZE))
> > +		errs++;
> > +	if (!IS_ALIGNED(se->ext_len, PMD_SIZE))
> > +		errs++;
> 
> Does this need to check the dax dev index is valid?  Or is it ok to just
> fail an IO if that index is garbage?

That is validated elsewhere

> 
> > +
> > +	return errs;
> > +}
> > +
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
> > +			if (ie_in->ie_chunk_size == 0 ||
> > +			    !IS_ALIGNED(ie_in->ie_chunk_size, PMD_SIZE)) {
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
> > +				kcalloc(nstrips, sizeof(meta->ie[i].ie_strips[0]),
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
> This is a lot of indenting, maybe each case should be a separate helper
> function?
> 
> --D

But I still fit it in 80 columns! :D

This one I think I will leave as-is unless somebody feels strongly.

Thank you!

John

<snip>

