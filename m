Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F65490C13;
	Thu,  6 Aug 2026 20:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786046607; cv=none; b=eBdYRCeQn5LdcsVUiroJWWbNSMO5EYX22a6LVCdilykAmcEcyIskdmVd6oJHcWQv7zaVZizRKiYfLL58cBnjmlWr03OxMO/X7JCJgr422NS7xxpDCbwLvp1NFG/93xZsJbxBUtlcwT3yad/i6ssU135gCiXV3YyqhM2QlVqmoKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786046607; c=relaxed/simple;
	bh=7JKyxC0lVhQOIrumF7ydzSJc5ZSRS+xdk/3yQU4vWvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WtN7AbHofmTZpU+AWh7wc5PlOEyY24QH9GM7iMwlrkk2qI6cMZiNNxc61aNUIbyR5Cx/w1poTlse+8fsTUkLjidZWn4yVXS7Hqaz/RXDesRNGtEE/XSIVIaI3sJjZVHhpS3ciFKQDjx7pHeDASed614QlSAqsscTDLMeXWWBAsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A013AA157C;
	Thu,  6 Aug 2026 20:03:18 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf10.hostedemail.com (Postfix) with ESMTPA id CAB693E;
	Thu,  6 Aug 2026 20:03:01 +0000 (UTC)
Date: Thu, 6 Aug 2026 15:03:00 -0500
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
Subject: Re: [PATCH V12 05/12] famfs: Introduce file_operations read/write
Message-ID: <anTfcB7thypyYosz@groves.net>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022859.75838-1-john@jagalactic.com>
 <0100019fc5741536-d6b2c2f4-794a-43b4-abf4-f38f2d812e19-000000@email.amazonses.com>
 <20260806051454.GE3560084@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806051454.GE3560084@frogsfrogsfrogs>
X-Stat-Signature: gm7ukas5jaj58ofp167htxxde8tqhqwn
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: CAB693E
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1+LXEKbbJ65PH0h4WQ/rVEovV2QmqmVb70=
X-HE-Tag: 1786046581-812498
X-HE-Meta: U2FsdGVkX1/q5xUraaNuYkBkOe9mViYAGWr7FuIimwMbrqtFOSLKir8hdx+AUb2/UEFIdoEY6U8kAf8GSXddDNosfoDtCfksrejeD+bW/uAGliqL9zjKCDm8qmTEKvpgrYiOcG2ooeac3dw6jx0F5Wy396jO3AcU7/LmLd8LastlQd/OkCYVVaOUM4rpVC5/NHUelf4vKma4j+O26TNskt5sXgMAJlbLCF7a0z1qrVPCUYMjwrnBZ1e0iJILsuDJj1LrZNjuXyySQ6Nc+FT98N+yfStaUB9Dl9i+oWZxnswBJo+brjduKginYQ6IuADNbVgn52Ydq+NnmRrXrGK4LPTmtgC2ghdIh9t57cQPcc5UKs+OEU3JgO985ZTLk62U

On 26/08/05 10:14PM, Darrick J. Wong wrote:
> On Mon, Aug 03, 2026 at 02:29:07AM +0000, John Groves wrote:
> > From: John Groves <john@groves.net>
> > 
> > This commit introduces fs/famfs/famfs_file.c and the famfs
> > file_operations for read/write.
> > 
> > This is not usable yet because:
> > 
> > * It calls dax_iomap_rw() with NULL iomap_ops (which will be
> >   introduced in a subsequent commit).
> > * famfs_ioctl() is coming in a later commit, and it is necessary
> >   to map a file to a memory allocation.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/famfs/Makefile         |   2 +-
> >  fs/famfs/famfs_file.c     | 138 ++++++++++++++++++++++++++++++++++++++
> >  fs/famfs/famfs_inode.c    |   2 +-
> >  fs/famfs/famfs_internal.h |   2 +
> >  4 files changed, 142 insertions(+), 2 deletions(-)
> >  create mode 100644 fs/famfs/famfs_file.c
> > 
> > diff --git a/fs/famfs/Makefile b/fs/famfs/Makefile
> > index 62230bcd6793..8cac90c090a4 100644
> > --- a/fs/famfs/Makefile
> > +++ b/fs/famfs/Makefile
> > @@ -2,4 +2,4 @@
> >  
> >  obj-$(CONFIG_FAMFS) += famfs.o
> >  
> > -famfs-y := famfs_inode.o
> > +famfs-y := famfs_inode.o famfs_file.o
> > diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> > new file mode 100644
> > index 000000000000..e192b573c51f
> > --- /dev/null
> > +++ b/fs/famfs/famfs_file.c
> > @@ -0,0 +1,138 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * famfs - dax file system for shared fabric-attached memory
> > + *
> > + * Copyright 2023-2024 Micron Technology, Inc.
> > + *
> > + * This file system, originally based on ramfs the dax support from xfs,
> > + * is intended to allow multiple host systems to mount a common file system
> > + * view of dax files that map to shared memory.
> > + */
> > +
> > +#include <linux/fs.h>
> > +#include <linux/mm.h>
> > +#include <linux/dax.h>
> > +#include <linux/iomap.h>
> > +
> > +#include "famfs_internal.h"
> > +
> > +/*********************************************************************
> > + * file_operations
> > + */
> > +
> > +/* Reject I/O to files that aren't in a valid state */
> > +static ssize_t
> > +famfs_file_invalid(struct inode *inode)
> > +{
> > +	if (!IS_DAX(inode)) {
> > +		pr_debug("%s: inode %llx IS_DAX is false\n",
> > +			 __func__, (u64)inode);
> > +		return -ENXIO;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static ssize_t
> > +famfs_rw_prep(struct kiocb *iocb, struct iov_iter *ubuf)
> > +{
> > +	struct inode *inode = iocb->ki_filp->f_mapping->host;
> > +	struct super_block *sb = inode->i_sb;
> > +	struct famfs_fs_info *fsi = sb->s_fs_info;
> > +	size_t i_size = i_size_read(inode);
> > +	size_t count = iov_iter_count(ubuf);
> > +	size_t max_count;
> > +	ssize_t rc;
> > +
> > +	if (fsi->deverror)
> > +		return -ENODEV;
> > +
> > +	rc = famfs_file_invalid(inode);
> > +	if (rc)
> > +		return rc;
> > +
> > +	/* Avoid unsigned underflow if position is past EOF */
> > +	if (iocb->ki_pos >= i_size)
> > +		max_count = 0;
> > +	else
> > +		max_count = i_size - iocb->ki_pos;
> > +
> > +	if (count > max_count)
> > +		iov_iter_truncate(ubuf, max_count);
> > +
> > +	if (!iov_iter_count(ubuf))
> > +		return 0;
> > +
> > +	return rc;
> > +}
> > +
> > +static ssize_t
> > +famfs_dax_read_iter(struct kiocb *iocb, struct iov_iter	*to)
> > +{
> > +	struct inode *inode = iocb->ki_filp->f_mapping->host;
> > +	ssize_t rc;
> > +
> > +	/* dax_iomap_rw() requires i_rwsem held (shared for read) */
> > +	inode_lock_shared(inode);
> > +	rc = famfs_rw_prep(iocb, to);
> > +	if (rc || !iov_iter_count(to)) {
> > +		inode_unlock_shared(inode);
> > +		return rc;
> > +	}
> > +
> > +	rc = dax_iomap_rw(iocb, to, NULL /*&famfs_iomap_ops */);
> > +	inode_unlock_shared(inode);
> > +
> > +	file_accessed(iocb->ki_filp);
> 
> Is it really accessed if rc != 0?

Good point; looks like only if rc > 0. Will update, thanks.

> 
> > +	return rc;
> > +}
> > +
> > +/**
> > + * famfs_dax_write_iter()
> > + *
> > + * We need our own write-iter in order to prevent append
> > + *
> > + * @iocb:
> > + * @from: iterator describing the user memory source for the write
> > + */
> > +static ssize_t
> > +famfs_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
> > +{
> > +	struct inode *inode = iocb->ki_filp->f_mapping->host;
> > +	struct famfs_fs_info *fsi = inode->i_sb->s_fs_info;
> > +	ssize_t rc;
> > +
> > +	if (!famfs_opt_enabled(fsi, FAMFS_OPT_WRITE))
> > +		return -EPERM;
> > +
> > +	/* dax_iomap_rw() requires i_rwsem held (exclusive for write) */
> > +	inode_lock(inode);
> > +	rc = famfs_rw_prep(iocb, from);
> > +	if (rc || !iov_iter_count(from)) {
> > +		inode_unlock(inode);
> > +		return rc;
> > +	}
> > +
> > +	rc = dax_iomap_rw(iocb, from, NULL /*&famfs_iomap_ops*/);
> 
> What happens if you pass a null iomap ops?  TBH I was expecting you to
> define the iomap ops with a dummy ->iomap_begin that returns EIO or
> something.

If we actually called dax_iomap_rw() with null iomap ops, it would
hork. However, if we called it with null iomap_ops->iomap_begin it
will also hork. I could introduce the dax_iomap_rw call later, when
sufficient code is in, but that might require (void) declarations
to squelch the compiler about unreferenced stuff.

So dummy iomap_ops won't actually work. My objective was to drop in
bite-sized chunks that were functionally coherent, until it's complete
(in commit 12).

I suspect multiple of these commits would do something bad if you
tried to run them before you had all.

Given all that, I'm inclined to leave it alone. 

Hmm, I could keep things where all commits compile, but cause 
module_init to fail until all commits are in. Then it couldn't do 
any harm to try to try running incomplete famfs.

I think I'll do that...

> 
> > +	inode_unlock(inode);
> > +	return rc;
> 
> Do you need to update mtime here?
> 
> --D

Yeah, I guess I should - will do.

FYI file times in famfs have limited usefulness, because they don't
propagate in the cluster.

<snip> 

