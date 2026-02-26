Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640701F7569
	for <nvdimm@lists.linux.dev>; Thu, 26 Feb 2026 00:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772065477; cv=none; b=mT1xgikAlV36M7A+6BkNKmi+YfeNRr4cSxg/B4ik+D2Sk7RpWCkbHxzHOa9qNIN+1ZuDKvax70Qy/EbQbJbl2Z8UtY7e4vKzPNVzeFxwzartcKs5PmJNsh6M7hlDZa8tyE/Q1fWhFTJcaG2yLlojfOPbzMWfcbpKArlC1TyMHPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772065477; c=relaxed/simple;
	bh=BR4/DDTRCP+PSMlUvbid0ZhJZFXN8n48tGgmbkGikBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TOchpnXGq3hsp+cWkKPhwYb3oOqfvztUqwm54OEsVLq8evtMYlYYP3InivH8F2XTwFzB46SF0Yse25S6OukIzMzq9RpP/YM3h86dJ4pATbkCGjBFKODXz1SA8/ik5DXS8QEGB5bdNM+uVaO3rZOGmvl5RvKoVsY13p8J/A08Dtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5EBB41402D5;
	Thu, 26 Feb 2026 00:24:32 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf12.hostedemail.com (Postfix) with ESMTPA id D85B517;
	Thu, 26 Feb 2026 00:24:22 +0000 (UTC)
Date: Wed, 25 Feb 2026 18:24:21 -0600
From: John Groves <John@groves.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	John Groves <jgroves@fastmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V7 12/19] famfs_fuse: Plumb the GET_FMAP message/response
Message-ID: <aZ-NN0zvgOsVzhAA@groves.net>
References: <0100019bd33b1f66-b835e86a-e8ae-443f-a474-02db88f7e6db-000000@email.amazonses.com>
 <20260118223257.92539-1-john@jagalactic.com>
 <0100019bd33d8b0a-05af2fc2-66c2-45e7-9091-42ca2efa6780-000000@email.amazonses.com>
 <489212dc-7f99-4748-b631-218bf78737a7@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489212dc-7f99-4748-b631-218bf78737a7@intel.com>
X-Stat-Signature: a3fsth4cdppkwduyzs3afx844xaw9hyk
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: D85B517
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1+P0DD/oAQPEeburCePpnhu7YX4ZGy0bqE=
X-HE-Tag: 1772065462-728122
X-HE-Meta: U2FsdGVkX18I1zN977EFGyescpmOd0+vzyU4bblYmW9dHdAHtrCunKHxB7H6YpE3dRs0m6rqhYI4fDHnRpQYV2+zhY+fYowpiaX9waVhYvujs+PjM/6SqUslo50iapv4qamcw0BZ7HySUXuuvoPpJ4h3IHM/taOQizcD8/LpRRrWHRcR2+1dkpFQCMcY0+TYrgrz6MAvI6aryaML7RudUkfd8/u2zDqeO4wJ/K5gncS1Yyakp6BX8rM2hBbaXyE5BneuP2y2E1d3wUWObRaiyDFEzOWVD5slXY5Mo5zNr8HGZsnaDrkQSeDONFBCEpATXHto4wWrP+hIVkIEJnk+M69JdF3zg0AOAmKglcoWzaMBw6l+seUnuo0So67Ye/hvkPsHgcGSf1MsZmv+wtcDTDvQWL1j69/EndhSHSsoqNeudmS6CAP/qQYftgckyWZ2yFGftZzcGfNR7HGD43+PfeiaEb9yVt161hOGH2/WGTE=

On 26/02/19 10:12AM, Dave Jiang wrote:
> 
> 
> On 1/18/26 3:33 PM, John Groves wrote:
> > From: John Groves <john@groves.net>
> > 
> > Upon completion of an OPEN, if we're in famfs-mode we do a GET_FMAP to
> > retrieve and cache up the file-to-dax map in the kernel. If this
> > succeeds, read/write/mmap are resolved direct-to-dax with no upcalls.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  MAINTAINERS               |  8 +++++
> >  fs/fuse/Makefile          |  1 +
> >  fs/fuse/famfs.c           | 74 +++++++++++++++++++++++++++++++++++++++
> >  fs/fuse/file.c            | 14 +++++++-
> >  fs/fuse/fuse_i.h          | 70 +++++++++++++++++++++++++++++++++---
> >  fs/fuse/inode.c           |  8 ++++-
> >  fs/fuse/iomode.c          |  2 +-
> >  include/uapi/linux/fuse.h |  7 ++++
> >  8 files changed, 176 insertions(+), 8 deletions(-)
> >  create mode 100644 fs/fuse/famfs.c
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 10aa5120d93f..e3d0aa5eb361 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -10379,6 +10379,14 @@ F:	fs/fuse/
> >  F:	include/uapi/linux/fuse.h
> >  F:	tools/testing/selftests/filesystems/fuse/
> >  
> > +FUSE [FAMFS Fabric-Attached Memory File System]
> > +M:	John Groves <jgroves@micron.com>
> > +M:	John Groves <John@Groves.net>
> > +L:	linux-cxl@vger.kernel.org
> > +L:	linux-fsdevel@vger.kernel.org
> > +S:	Supported
> > +F:	fs/fuse/famfs.c
> > +
> >  FUTEX SUBSYSTEM
> >  M:	Thomas Gleixner <tglx@kernel.org>
> >  M:	Ingo Molnar <mingo@redhat.com>
> > diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
> > index 22ad9538dfc4..3f8dcc8cbbd0 100644
> > --- a/fs/fuse/Makefile
> > +++ b/fs/fuse/Makefile
> > @@ -17,5 +17,6 @@ fuse-$(CONFIG_FUSE_DAX) += dax.o
> >  fuse-$(CONFIG_FUSE_PASSTHROUGH) += passthrough.o backing.o
> >  fuse-$(CONFIG_SYSCTL) += sysctl.o
> >  fuse-$(CONFIG_FUSE_IO_URING) += dev_uring.o
> > +fuse-$(CONFIG_FUSE_FAMFS_DAX) += famfs.o
> >  
> >  virtiofs-y := virtio_fs.o
> > diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
> > new file mode 100644
> > index 000000000000..615819cc922d
> > --- /dev/null
> > +++ b/fs/fuse/famfs.c
> > @@ -0,0 +1,74 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * famfs - dax file system for shared fabric-attached memory
> > + *
> > + * Copyright 2023-2026 Micron Technology, Inc.
> > + *
> > + * This file system, originally based on ramfs the dax support from xfs,
> > + * is intended to allow multiple host systems to mount a common file system
> > + * view of dax files that map to shared memory.
> > + */
> > +
> > +#include <linux/cleanup.h>
> > +#include <linux/fs.h>
> > +#include <linux/mm.h>
> > +#include <linux/dax.h>
> > +#include <linux/iomap.h>
> > +#include <linux/path.h>
> > +#include <linux/namei.h>
> > +#include <linux/string.h>
> > +
> > +#include "fuse_i.h"
> > +
> > +
> > +#define FMAP_BUFSIZE PAGE_SIZE
> > +
> > +int
> > +fuse_get_fmap(struct fuse_mount *fm, struct inode *inode)
> 
> keep the return int on the same line?

Done, thanks

> 
> > +{
> > +	void *fmap_buf __free(kfree) = NULL;
> 
> Should do the variable declaration when you do the kzalloc(). That way you can avoid any potential use before check issues.

Done, thanks

> 
> > +	struct fuse_inode *fi = get_fuse_inode(inode);
> > +	size_t fmap_bufsize = FMAP_BUFSIZE;
> > +	u64 nodeid = get_node_id(inode);
> > +	ssize_t fmap_size;
> > +	int rc;
> > +
> > +	FUSE_ARGS(args);
> > +
> > +	/* Don't retrieve if we already have the famfs metadata */
> > +	if (fi->famfs_meta)
> > +		return 0;
> > +
> > +	fmap_buf = kzalloc(FMAP_BUFSIZE, GFP_KERNEL);
> > +	if (!fmap_buf)
> > +		return -EIO;
> 
> -ENOMEM?
> 
> DJ

Done, thanks!

John

