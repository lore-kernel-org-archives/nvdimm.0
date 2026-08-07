Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCD03DEAF6;
	Fri,  7 Aug 2026 15:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115134; cv=none; b=NIXVYf13RqVIfh8T/+xtY6a2nc0qNbZ35MWxrQVIGEF4bvQ1sd1ALlKUM7GDOfsHJ0jV7eoRGNyBIO1K4Ub4/29Gv9frb034AY2bwgZ/GakkurMhMuSlcG0HjY5uXnYx2h/kixLRkiCphi/bUB33zLpmQxbwn9S+w/JVhHNkQEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115134; c=relaxed/simple;
	bh=glgKEem+6g70PraGqIwL/Po1kA8bdnkrVHo0WIwVe+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qVpEWivausssaHcF1F6caIRAB/HqWfMdi1AehwD6t/mpIAUlz075F2ZpGTPauxG/vIT4WW0b+vUPRVdO33zte0mFRWmOJ/sAgdmFAeGkjEP5wQaOI4hbtbGI4R5gKI4MwGNvpXDi4FzEbFIZ6uBtfFWyMTadmar+4xAtrx73c1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F0CF480214;
	Fri,  7 Aug 2026 15:05:24 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf01.hostedemail.com (Postfix) with ESMTPA id BC60A6000C;
	Fri,  7 Aug 2026 15:05:07 +0000 (UTC)
Date: Fri, 7 Aug 2026 10:05:06 -0500
From: John Groves <john@groves.net>
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
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>, Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [PATCH V12 12/12] famfs: Add documentation
Message-ID: <anXpf1JJYsV5cfYL@groves.net>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803023009.75966-1-john@jagalactic.com>
 <0100019fc5752a8f-df47f869-a29b-4b6d-936a-67dd521c0f5e-000000@email.amazonses.com>
 <20260806053852.GM3560084@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806053852.GM3560084@frogsfrogsfrogs>
X-Stat-Signature: wwskbdqhc3jzktyryshh4awcxi5ukaeg
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: BC60A6000C
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18b4zxH4gkowpJ5t9P02dhsJKnGhwZqyp8=
X-HE-Tag: 1786115107-833865
X-HE-Meta: U2FsdGVkX1/xIhMDbEBd8+CBNlywVoLemHpmYl/fPnh6lKjCc2JVy4c74zDaDkCO2uGhn6St9fhFdvYDhRuJ23fJys9OIJTD5Et6krB5GW4dqcpEdR7GikNbBR3R6zTWf9MACb1vtXepkUro47UJOKPy1RMf4Weanu6F2kWB4YE5cFyX5YU5ocWy+jXPHq90GTqdTHS8BEQhh2SWrHRjLJ8IAE88yLOzg/QGsQOULqMJZqFg/s/ha4sQ6SLAbYVkR7RzW6zioBI59jux6vj2AAlx5W4ozheg9lKV/v7wszwfwUWTYGsFmoWYpUVfo6h+/D9D+QCbnNewuw0zAGkxIjzO3jMPWcx6wod1RXQzlC7TZeEJPKt2xPG3iCyAUAhlIY/Xf0qLPTnRA9qKYS/mfGGpZdq2hZWtMEXZTZaGzCFd2tg/bDBZhO1HjhdzcDBtvwikOx/NBgQUMk/lll/sbw==

On 26/08/05 10:38PM, Darrick J. Wong wrote:
> On Mon, Aug 03, 2026 at 02:30:18AM +0000, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > Add Documentation/filesystems/famfs.rst and update MAINTAINERS
> > 
> > Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
> > Tested-by: Randy Dunlap <rdunlap@infradead.org>
> > Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  Documentation/filesystems/famfs.rst | 142 ++++++++++++++++++++++++++++
> >  Documentation/filesystems/index.rst |   1 +
> >  MAINTAINERS                         |   1 +
> >  3 files changed, 144 insertions(+)
> >  create mode 100644 Documentation/filesystems/famfs.rst
> > 
> > diff --git a/Documentation/filesystems/famfs.rst b/Documentation/filesystems/famfs.rst
> > new file mode 100644
> > index 000000000000..048791bcbcfd
> > --- /dev/null
> > +++ b/Documentation/filesystems/famfs.rst
> > @@ -0,0 +1,142 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +.. _famfs_index:
> > +
> > +==================================================================
> > +famfs: The fabric-attached memory file system
> > +==================================================================
> > +
> > +- Copyright (C) 2024-2026 Micron Technology, Inc.
> > +
> > +Introduction
> > +============
> > +Compute Express Link (CXL) provides a mechanism for disaggregated or
> > +fabric-attached memory (FAM). This creates opportunities for data sharing;
> > +clustered apps that would otherwise have to shard or replicate data can
> > +share one copy in disaggregated memory.
> > +
> > +Famfs, which is not CXL-specific in any way, provides a mechanism for
> > +multiple hosts to concurrently access data in shared memory, by giving it
> > +a file system interface. With famfs, any app that understands files can
> > +access data sets in shared memory. Although famfs supports read and write,
> > +the real point is to support mmap, which provides direct (dax) access to
> > +the memory - either writable or read-only.
> > +
> > +Shared memory can pose complex coherency and synchronization issues, but
> > +there are also simple cases. Two simple and eminently useful patterns that
> > +occur frequently in data analytics and AI are:
> > +
> > +* Serial Sharing - Only one host or process at a time has access to a file
> > +* Read-only Sharing - Multiple hosts or processes share read-only access
> > +  to a file
> > +
> > +The famfs file system is part of the famfs framework; user space
> > +components [1] handle metadata allocation and distribution, and populate
> > +the in-kernel files (via ioctls) so that they map directly to shared
> > +memory.
> 
> Ok, so maybe it is the famfs server that's supposed to go modify the
> directory tree after the metadata log updates.

Right, pretty much. With standalone famfs, there is currently no stateful
server per se (which is a benefit!). There is state in the log, and state in 
the kernel (dirs and files with fmaps). Periodically we replay the log to 
push up any new state into the kernel - at which point we add dirs and files 
if the log has been appended.  Since we don't delete or truncate stuff, 
logplay either adds files/dirs or does nothing.

> 
> > +The famfs framework manages coherency of its own metadata and structures,
> > +but does not attempt to manage coherency for applications.
> > +
> > +Famfs also provides data isolation between files. That is, even though
> > +the host has access to an entire memory "device" (as a devdax device), apps
> > +cannot write to memory for which the file is read-only, and mapping one
> > +file provides isolation from the memory of all other files. This is pretty
> > +basic, but some experimental shared memory usage patterns provide no such
> > +isolation.
> > +
> > +Principles of Operation
> > +=======================
> > +
> > +Famfs is a file system with one or more devdax devices as a first-class
> > +backing device(s). Metadata maintenance and query operations happen
> > +entirely in user space.
> > +
> > +The famfs user space provides each file's map (fmap) and its backing
> > +devdax devices to the kernel through ioctls (FAMFSIOC_MAP_CREATE and
> > +FAMFSIOC_DAXDEV_OPEN), after which read/write/mapping faults are handled
> > +entirely in the kernel with no up-calls for all active files.
> > +
> > +The famfs user space is responsible for maintaining and distributing
> > +consistent metadata. This is currently handled via an append-only
> > +metadata log within the memory, but this is orthogonal to the famfs
> > +kernel code.
> > +
> > +Once instantiated, "the same file" on each host points to the same shared
> > +memory, but in-memory metadata (inodes, etc.) is ephemeral on each host
> > +that has a famfs instance mounted. Use cases are free to allow or not
> > +allow mutations to data on a file-by-file basis.
> > +
> > +When an app accesses a data object in a famfs file, there is no page cache
> > +involvement. The CPU cache is loaded directly from the shared memory. In
> > +some use cases, this is an enormous reduction in read amplification
> > +compared to loading an entire page into the page cache.
> > +
> > +
> > +Famfs is Not a Conventional File System
> > +---------------------------------------
> > +
> > +Famfs files can be accessed by conventional means, but there are
> > +limitations. The famfs kernel module is not involved in the allocation of
> > +backing memory for files at all; the famfs user space creates files and
> > +supplies their fmaps and devdax device info to the kernel via ioctls.
> 
> ...and just to be clear, regular programs *do not* modify the directory
> tree, create files, or delete them?

Right, though I'm hesitant to say it should *never* be allowed. One recent
use case needed to create local-only symlinks within famfs, to make some 
app or benchmark happy...

But any mutability other than by the logplay machinery is severely or
completely restricted.

> 
> > +Famfs differs in some important ways from conventional file systems:
> > +
> > +* Files must be pre-allocated by the famfs framework; allocation is never
> > +  performed on (or after) write.
> > +* Any operation that changes a file's size is considered to put the file
> > +  in an invalid state, disabling access to the data. It may be possible to
> > +  revisit this in the future. (Typically the famfs user space can restore
> > +  files to a valid state by replaying the famfs metadata log.)
> > +
> > +Famfs exists to apply the existing file system abstractions to shared
> > +memory so applications and workflows can more easily adapt to an
> > +environment with disaggregated shared memory.
> > +
> > +Memory Error Handling
> > +=====================
> > +
> > +Possible memory errors include timeouts, poison, and unexpected
> > +reconfiguration of an underlying dax device. In all of these cases, famfs
> > +receives a call from the devdax layer via its
> > +dax_holder_operations->notify_failure() function. If any memory errors have
> > +been detected, access to the affected
> > +daxdev is disabled to avoid further errors or corruption.
> > +
> > +In all known cases, famfs can be unmounted cleanly. In most cases errors
> > +can be cleared by re-initializing the memory - at which point a new famfs
> > +file system can be created.
> 
> Should media failure notifications get passed to the new fserror
> framework (see xfs_verify_media.c)?
> 
> --D

I didn't know about fserror; Initial impression is I'm hesitant to jump in
immediately, but we should consider adding it later.

Famfs currently does not attempt to determine which files are affected by
a memory error - it just shuts down the mount. It's possible we'll attempt
this in the future, but I'm not yet convinced it's needed.

Famfs is not storage, and we advise users that it's a mistake to put your 
only copy of valuable data in famfs. But it's great for stuff like kv-cache 
blocks, which can be regenerated. So errors famfs memory, if you're using
it right, are not lost data in the same sense as with xfs.

Push back if you disagree. Otherwise I've noted it in our internal roadmap
docs...

Thanks!
John

<snip>

