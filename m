Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F261E5B7B
	for <nvdimm@lists.linux.dev>; Thu, 26 Feb 2026 00:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772065773; cv=none; b=LiLIgzP5bDQV9SrPXO9iM+VirnM5XIAxfGTnSA69EXZWrJcdkVrl5eJ3bxJcdMqf1yOvk2YJZ45uWzTA1l4lI5AE1owRcuG84Low3C3guGHKdw+sTdJ10y6k6GnS6bAdFIKPJHie6uiSK2xmaGRNduzzLgaYW+5j1UsSF4zzbRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772065773; c=relaxed/simple;
	bh=+7BsmtQ5iVXZanMMAoaBOnNHj3Z9QVTJ4Gaw4IIGRvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DvwYBGYdr0W8OSToUVLZ+2HackJAZRzM8Ju+ehm5ck5lEbf7rMSlh5wVnYUYomY2s0JG7GTlMfW9cCmnK0mJdxSinRKJpC68C1pl8RQ7UNBIWcLlSr9hTVJH4de4or9RK6KCYzuqbE1LF899tdeSqPBcyX2yJN7/xTA+4OXuK6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DBA18578AB;
	Thu, 26 Feb 2026 00:29:27 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf11.hostedemail.com (Postfix) with ESMTPA id 4843120029;
	Thu, 26 Feb 2026 00:29:18 +0000 (UTC)
Date: Wed, 25 Feb 2026 18:29:17 -0600
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
Subject: Re: [PATCH V7 19/19] famfs_fuse: Add documentation
Message-ID: <aZ-Tk62TJbTRnfeB@groves.net>
References: <0100019bd33b1f66-b835e86a-e8ae-443f-a474-02db88f7e6db-000000@email.amazonses.com>
 <20260118223420.92690-1-john@jagalactic.com>
 <0100019bd33ed831-615df3db-7b06-4137-9877-97c0d0fc0a05-000000@email.amazonses.com>
 <7facce73-688a-408a-bcf9-f16d5ff36349@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7facce73-688a-408a-bcf9-f16d5ff36349@intel.com>
X-Stat-Signature: e4brd93qdse8irtjpwokip6jthgpusrc
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 4843120029
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1/MAbFr2gZXLy0eo5qRcyuiG2lkZq54nO0=
X-HE-Tag: 1772065758-14810
X-HE-Meta: U2FsdGVkX1+x0I2cn6ZECcJvCeffIJ6JpirosHiTV51wjEmz00UjCIoh55g5Tyn6zysbWIHqXOsPhf6zCIyu1CMXr0YkF9BvHyL+v5HBbiNb8Y5oeuESDTQZh6wny1WRoCaRlIK0FcuLBDmldvL6VuHuC8/z6kClEyo60hSj0wIQahFVGTKV+oXadHuN4yr+t/ue8LSvOD1ZD5aUBTztAxZB20kMlLN/ISpZfBAN01I6FPIZOtTFmqng5mkCglBahnJ50poHId0iJkRqdoYgoc7rL9DTwrlaHI2cv99TpEbGdYXFk4OghNAOriXcMPhDY7vW1/gE5vpD25dIwLjg1qUYQ40enQF6KenGoK67kMP63USG8qnWf1mpdxHIoJBNQGkOGfjO3wACnkQdGnJLgtA+eTBeEoD1YThJQrZ4Ko8sehUgh+LYYPjYh/3XDmclx2KqUOaX1Ll/6HclL7yVRQ==

On 26/02/19 02:39PM, Dave Jiang wrote:
> 
> 
> On 1/18/26 3:34 PM, John Groves wrote:
> > From: John Groves <john@groves.net>
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
> > index 000000000000..bf0c0e6574bb
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
> 
> s/shard/share/?

Actually shard is correct here - talking about splitting data sets
into shards...

> 
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
> > +The famfs fuse file system is part of the famfs framework; user space
> > +components [1] handle metadata allocation and distribution, and provide a
> > +low-level fuse server to expose files that map directly to [presumably
> > +shared] memory.
> > +
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
> > +The famfs low-level fuse server daemon provides file maps (fmaps) and
> > +devdax device info to the fuse/famfs kernel component so that
> > +read/write/mapping faults can be handled without up-calls for all active
> > +files.
> > +
> > +The famfs user space is responsible for maintaining and distributing
> > +consistent metadata. This is currently handled via an append-only
> > +metadata log within the memory, but this is orthogonal to the fuse/famfs
> > +kernel code.
> > +
> > +Once instantiated, "the same file" on each host points to the same shared
> > +memory, but in-memory metadata (inodes, etc.) is ephemeral on each host
> > +that has a famfs instance mounted. Use cases are free to allow or not
> > +allow mutations to data on a file-by-file basis.
> > +
> > +When an app accesses a data object in a famfs file, there is no page cache
> > +involvement. The CPU cache is loaded directly from the shared memory. In
> > +some use cases, this is an enormous reduction read amplification compared
> 
> "reduction in read amplification"?

Good eye - thanks. Done.

> 
> > +to loading an entire page into the page cache.
> > +
> > +
> > +Famfs is Not a Conventional File System
> > +---------------------------------------
> > +
> > +Famfs files can be accessed by conventional means, but there are
> > +limitations. The kernel component of fuse/famfs is not involved in the
> > +allocation of backing memory for files at all; the famfs user space
> > +creates files and responds as a low-level fuse server with fmaps and
> > +devdax device info upon request.
> > +
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
> > +Possible memory errors include timeouts, poison and unexpected
> 
> s/poison and/poison, and/
> 
> DJ

Done, thanks!

John

