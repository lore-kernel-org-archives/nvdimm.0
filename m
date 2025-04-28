Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BBB78F3A
	for <nvdimm@lists.linux.dev>; Mon, 28 Apr 2025 01:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745805007; cv=none; b=QBEcp1VuMA1c8WdDR7hzGAuxXt0CvyxY0IPJARtD39xz3MU0r8AEE3sd/6qdKIyiunCwAjg/UBDPHA7ihK5sAnQnu2OIRMsDzGAdmEXuw8ZsNcMpl2s/CdaN20ssZls4vPJqvTlknyX3h9xFit/RyeUtDFYn+Kf7c3nRXv6V4AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745805007; c=relaxed/simple;
	bh=doj6zOgc5VWWmm/qoFnhXtoIVGZlxDYg5PUinPuwuBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ElibRTLueDsIigd66oluvtP8IE0kgJJTdRU2mZplj3CG7dwmCw66kNtvnxT5GROcYS9TYg5vAB2x7Gg4xoYJG6R7jFAtpLKHfKeb4wgAeWWEhutEMsAi2wMSsjhPCYOGV9CD03rFy9WkIzRwkxBiun/ZBR2BqiNNA+Mndp0JBoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cjT+l/YD; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cjT+l/YD"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-2c759bf1b2eso2559300fac.1
        for <nvdimm@lists.linux.dev>; Sun, 27 Apr 2025 18:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745805005; x=1746409805; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q/ubERfRjdkzW5emP2ZZP5xPtJL9kCLbv4s5tOyr1d0=;
        b=cjT+l/YDsGP5nkaNF96G8WpaSHataafpuaLErga3YzMzdzXn2wQAw4g0/nWDVGokmZ
         it8eNqDbl6ZSQa1CSKYkP6zI9Tw1U6ym8cdKGLcLPMBv55gZd51tx/0OAIa9eejJgzHx
         dC1jNtx9nD3iwPfa6wa/crQeDbJgVJn4V2SwdTJCyqFxTwrLYuNhjLTV/gYYYWbpqfF5
         VAX/B5oBNhe5zGHaau1Fb0LYas/fiTTUI5ia/QZKkC0Jyfizy7m54ZAkb9CUCJRYhl+o
         gMyci3eWGZIlPOYlD//I6qYawuhD7UA+xtMr/aEGPKWFrQ2LrZ15eM3N5qDCgkW/zj21
         dv2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745805005; x=1746409805;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q/ubERfRjdkzW5emP2ZZP5xPtJL9kCLbv4s5tOyr1d0=;
        b=FV6ifEdrn0HeucJtY8u7VsT3rQsuAAsxA8k+cURgEhrOE9dGsKzQCQjAlk+KMCHgdO
         /OgErMzNUv9WXj0WFtLie9h8WeQ/59eYdVxfGa6lZr8xMTYluNlCdlYKNt2vNPhHARtw
         K7yBMMEnMDi0a60l+YjQiR/IKEktRJNwhGW/TbYNlAW8mMKwcFcceonR7ysncU8Snzyr
         b0QXQQHtYNmpEncYSMXRg4xGAneEFwtwOoT9EVN8BoU7A8X6bapBNTYZSaNFr8Ed2UcH
         mcrQw8bbS5QJWFw89k1Cy8p/kWdGAB5dLdWM0JpsBYzKVzH+QMYN9Xy8OTDWZxazxUZc
         G55w==
X-Forwarded-Encrypted: i=1; AJvYcCVvOoOsh5zTq1eHqZ7YixJRKfrbfOViIu7fYGe/0DfPyoMi7Qqvx7MrfF/nGhBNaXy3eUZwHtY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/kUpq4vkOu6rTuUpRryHfWdUVlCTH/ph2EO738b8YIpu89FvU
	l4If6eCb+MGZaFs0Iurb4iKAVamZ5YlSwGFJtFoY6773WzjlWxgy
X-Gm-Gg: ASbGnculoPxFKCx230tRap/gSckIEOAYumaPky3OxzIDkx2vaTxCmKPAdiZRhbXRcCd
	PmR1IzBcPQbkEQ00O0ytLypGprCcdbcUlYz3HYRWgwWolk+g558f2bGQX2D3GvbAOoHs9CLvOSL
	oZHJX19U7KHGVRixxPs3tfOyDHaAH6JKUbFId9XziKlLuk7ivoZUa5px4MwAFhsoRRkev6vK1g7
	8Eh/PRQ8v1UG02rxph93wxKl+k+Ki8vLk3WRsrBNQ/bA+ekNOGHmhQZfBsIzAyRaapL5LM4vnVm
	Zl4fD6oNVAAHz/rqLFZqiu4FMncM9/Rzzcvg/Mq+DL2INazbNhMTJqBxdYPjcQwJ2w==
X-Google-Smtp-Source: AGHT+IFAMuKE1EJyX06l+5odcVHGZDhKhFY+nBb5zJuOWKhWorN6ZVXS6F1/faYUmlVc/WvBl7O1dg==
X-Received: by 2002:a05:6870:a794:b0:2c1:6948:d57c with SMTP id 586e51a60fabf-2d99db0acc8mr6417200fac.28.1745805003074;
        Sun, 27 Apr 2025 18:50:03 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:14de:ab78:90c3:bb9a])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2d9737e73b7sm2071903fac.26.2025.04.27.18.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Apr 2025 18:50:02 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Sun, 27 Apr 2025 20:50:00 -0500
From: John Groves <John@groves.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Luis Henriques <luis@igalia.com>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Petr Vorel <pvorel@suse.cz>, Brian Foster <bfoster@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC PATCH 18/19] famfs_fuse: Add documentation
Message-ID: <bwazd4vbwj2c7flrrkizycvl22oflufawxdiaan674vqqkgumw@lt4zppeg4l7e>
References: <20250421013346.32530-1-john@groves.net>
 <20250421013346.32530-19-john@groves.net>
 <db2415e3-0ee7-4b72-ac6b-4c7cda875dd3@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db2415e3-0ee7-4b72-ac6b-4c7cda875dd3@infradead.org>

On 25/04/21 07:10PM, Randy Dunlap wrote:
> 
> 
> On 4/20/25 6:33 PM, John Groves wrote:
> > Add Documentation/filesystems/famfs.rst and update MAINTAINERS
> > 
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
> > index 000000000000..b6b3500b6905
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
> > +- Copyright (C) 2024-2025 Micron Technology, Inc.
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
> > +The famfs fuse file system is part of the famfs framework; User space
> 
>                                                               user
> 
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
> > +* Files must be pre-allocated by the famfs framework; Allocation is never
> 
>                                                          allocation
> 
> > +  performed on (or after) write.
> > +* Any operation that changes a file's size is considered to put the file
> > +  in an invalid state, disabling access to the data. It may be possible to
> > +  revisit this in the future. (Typically the famfs user space can restore
> > +  files to a valid state by replaying the famfs metadata log.)
> > +
> > +Famfs exists to apply the existing file system abstractions to shared
> > +memory so applications and workflows can more easily adapt to an
> > +environment with disaggregated shared memory.
> 
> 
> -- 
> ~Randy
> 

Both edits applied to the -next branch for the patch set. Thanks!

