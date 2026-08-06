Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0B831F9A5;
	Thu,  6 Aug 2026 05:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785994734; cv=none; b=E4hINVvtsE2n4Lh7xkAtB4NL7xY5zaB/T1gZT3gcz5QzBjglpMuZpsBp6yjAtJkuimdUN11z1msxOEtdS91HMSmYvNaV9AVAeY3hS2W5JJe2y9n3XOWu9OjmrhT03wCF59tOMFgl8OnqiMtRkgcDXdIYUg5G6wkJHkLj9fFmtMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785994734; c=relaxed/simple;
	bh=L81Gr6P5a728WMvMFjKLgHLP45lr7qAP9Y0Aifk120U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ls12DGzNLtUjEUo2H6waOvTFHo6LtokwPIuqV/M0uX82dlTSryeDs1Zr1MvpkWOsO/BY1FpR3zjya0jrSgfUG6pWBffBYp0EFOpQdQ/yH8AHwL8Jr6XpJbyy+e1OGED4ClAMKk+X4oLf4bp10oTHAF86/EwCPkT25ydU23q62xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=edLsjiiz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="edLsjiiz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1A2401F000E9;
	Thu,  6 Aug 2026 05:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785994733;
	bh=S1IfjQLdDCOc5kDbzKWnjvR3WajSSqGNKDzYKfGSTgE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=edLsjiiz6/oX1ELsrLrTXtUabnLdZ3cD8XXabOMZQoPzMhzKjLOsPVFclMTOxZdk5
	 c1FlBtpYmLQqo7qCD0ud7WG1tD/LOTywCs9sbAZd4DvoT7z+LvWpbQUYGYgEQbnoDq
	 d3sIcHJ+KMZyRMrFfpoO5LqdQb6DqB3bRfnFktJrEsg27zycXkBygGNYtu0uSdu+0e
	 36ykJAgPOlpAfi0mUAh+gP9wx6ZAl01Aiy24VQ0/ke96/O32hP6idZE+iQE1rAD4O/
	 K7bKz+Sp+oVd4XUOM8OGUNPOUWeOYkyKADNEQqSOR1cLw0WxB2qbJvHwBRlW7M+rov
	 Rp2rKkfmQI05g==
Date: Wed, 5 Aug 2026 22:38:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Groves <john@jagalactic.com>
Cc: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ira Weiny <iweiny@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Haren Myneni <haren@linux.ibm.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Gabriel Whigham <gabewhigham@gmail.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>,
	Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [PATCH V12 12/12] famfs: Add documentation
Message-ID: <20260806053852.GM3560084@frogsfrogsfrogs>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803023009.75966-1-john@jagalactic.com>
 <0100019fc5752a8f-df47f869-a29b-4b6d-936a-67dd521c0f5e-000000@email.amazonses.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019fc5752a8f-df47f869-a29b-4b6d-936a-67dd521c0f5e-000000@email.amazonses.com>

On Mon, Aug 03, 2026 at 02:30:18AM +0000, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Add Documentation/filesystems/famfs.rst and update MAINTAINERS
> 
> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
> Tested-by: Randy Dunlap <rdunlap@infradead.org>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: John Groves <john@groves.net>
> ---
>  Documentation/filesystems/famfs.rst | 142 ++++++++++++++++++++++++++++
>  Documentation/filesystems/index.rst |   1 +
>  MAINTAINERS                         |   1 +
>  3 files changed, 144 insertions(+)
>  create mode 100644 Documentation/filesystems/famfs.rst
> 
> diff --git a/Documentation/filesystems/famfs.rst b/Documentation/filesystems/famfs.rst
> new file mode 100644
> index 000000000000..048791bcbcfd
> --- /dev/null
> +++ b/Documentation/filesystems/famfs.rst
> @@ -0,0 +1,142 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +.. _famfs_index:
> +
> +==================================================================
> +famfs: The fabric-attached memory file system
> +==================================================================
> +
> +- Copyright (C) 2024-2026 Micron Technology, Inc.
> +
> +Introduction
> +============
> +Compute Express Link (CXL) provides a mechanism for disaggregated or
> +fabric-attached memory (FAM). This creates opportunities for data sharing;
> +clustered apps that would otherwise have to shard or replicate data can
> +share one copy in disaggregated memory.
> +
> +Famfs, which is not CXL-specific in any way, provides a mechanism for
> +multiple hosts to concurrently access data in shared memory, by giving it
> +a file system interface. With famfs, any app that understands files can
> +access data sets in shared memory. Although famfs supports read and write,
> +the real point is to support mmap, which provides direct (dax) access to
> +the memory - either writable or read-only.
> +
> +Shared memory can pose complex coherency and synchronization issues, but
> +there are also simple cases. Two simple and eminently useful patterns that
> +occur frequently in data analytics and AI are:
> +
> +* Serial Sharing - Only one host or process at a time has access to a file
> +* Read-only Sharing - Multiple hosts or processes share read-only access
> +  to a file
> +
> +The famfs file system is part of the famfs framework; user space
> +components [1] handle metadata allocation and distribution, and populate
> +the in-kernel files (via ioctls) so that they map directly to shared
> +memory.

Ok, so maybe it is the famfs server that's supposed to go modify the
directory tree after the metadata log updates.

> +The famfs framework manages coherency of its own metadata and structures,
> +but does not attempt to manage coherency for applications.
> +
> +Famfs also provides data isolation between files. That is, even though
> +the host has access to an entire memory "device" (as a devdax device), apps
> +cannot write to memory for which the file is read-only, and mapping one
> +file provides isolation from the memory of all other files. This is pretty
> +basic, but some experimental shared memory usage patterns provide no such
> +isolation.
> +
> +Principles of Operation
> +=======================
> +
> +Famfs is a file system with one or more devdax devices as a first-class
> +backing device(s). Metadata maintenance and query operations happen
> +entirely in user space.
> +
> +The famfs user space provides each file's map (fmap) and its backing
> +devdax devices to the kernel through ioctls (FAMFSIOC_MAP_CREATE and
> +FAMFSIOC_DAXDEV_OPEN), after which read/write/mapping faults are handled
> +entirely in the kernel with no up-calls for all active files.
> +
> +The famfs user space is responsible for maintaining and distributing
> +consistent metadata. This is currently handled via an append-only
> +metadata log within the memory, but this is orthogonal to the famfs
> +kernel code.
> +
> +Once instantiated, "the same file" on each host points to the same shared
> +memory, but in-memory metadata (inodes, etc.) is ephemeral on each host
> +that has a famfs instance mounted. Use cases are free to allow or not
> +allow mutations to data on a file-by-file basis.
> +
> +When an app accesses a data object in a famfs file, there is no page cache
> +involvement. The CPU cache is loaded directly from the shared memory. In
> +some use cases, this is an enormous reduction in read amplification
> +compared to loading an entire page into the page cache.
> +
> +
> +Famfs is Not a Conventional File System
> +---------------------------------------
> +
> +Famfs files can be accessed by conventional means, but there are
> +limitations. The famfs kernel module is not involved in the allocation of
> +backing memory for files at all; the famfs user space creates files and
> +supplies their fmaps and devdax device info to the kernel via ioctls.

...and just to be clear, regular programs *do not* modify the directory
tree, create files, or delete them?

> +Famfs differs in some important ways from conventional file systems:
> +
> +* Files must be pre-allocated by the famfs framework; allocation is never
> +  performed on (or after) write.
> +* Any operation that changes a file's size is considered to put the file
> +  in an invalid state, disabling access to the data. It may be possible to
> +  revisit this in the future. (Typically the famfs user space can restore
> +  files to a valid state by replaying the famfs metadata log.)
> +
> +Famfs exists to apply the existing file system abstractions to shared
> +memory so applications and workflows can more easily adapt to an
> +environment with disaggregated shared memory.
> +
> +Memory Error Handling
> +=====================
> +
> +Possible memory errors include timeouts, poison, and unexpected
> +reconfiguration of an underlying dax device. In all of these cases, famfs
> +receives a call from the devdax layer via its
> +dax_holder_operations->notify_failure() function. If any memory errors have
> +been detected, access to the affected
> +daxdev is disabled to avoid further errors or corruption.
> +
> +In all known cases, famfs can be unmounted cleanly. In most cases errors
> +can be cleared by re-initializing the memory - at which point a new famfs
> +file system can be created.

Should media failure notifications get passed to the new fserror
framework (see xfs_verify_media.c)?

--D

> +Key Requirements
> +================
> +
> +The primary requirements for famfs are:
> +
> +1. Must support a file system abstraction backed by sharable devdax memory
> +2. Files must efficiently handle VMA faults
> +3. Must support metadata distribution in a sharable way
> +4. Must handle clients with a stale copy of metadata
> +
> +The famfs kernel component takes care of 1-2 above by caching each file's
> +mapping metadata in the kernel.
> +
> +Requirements 3 and 4 are handled by the user space components, and are
> +largely orthogonal to the functionality of the famfs kernel module.
> +
> +Requirements 3 and 4 cannot be met by conventional fs-dax file systems
> +(e.g. xfs) because they use write-back metadata; it is not valid to mount
> +such a file system on two hosts from the same in-memory image.
> +
> +
> +Famfs Usage
> +===========
> +
> +Famfs usage is documented at [1].
> +
> +
> +References
> +==========
> +
> +- [1] Famfs user space repository and documentation
> +      https://github.com/cxl-micron-reskit/famfs
> diff --git a/Documentation/filesystems/index.rst b/Documentation/filesystems/index.rst
> index 1f71cf159547..97a9a1f1e96a 100644
> --- a/Documentation/filesystems/index.rst
> +++ b/Documentation/filesystems/index.rst
> @@ -91,6 +91,7 @@ Documentation for filesystem implementations.
>     ext3
>     ext4/index
>     f2fs
> +   famfs
>     gfs2/index
>     hfs
>     hfsplus
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ca7b90a8f0a1..8c282857b103 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9910,6 +9910,7 @@ M:	John Groves <John@Groves.net>
>  L:	linux-fsdevel@vger.kernel.org
>  L:	linux-cxl@vger.kernel.org
>  S:	Supported
> +F:	Documentation/filesystems/famfs.rst
>  F:	fs/famfs/
>  
>  FANOTIFY
> -- 
> 2.53.0
> 
> 
> 
