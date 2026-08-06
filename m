Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F61330B0B;
	Thu,  6 Aug 2026 05:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785994453; cv=none; b=Ohz+KNb5bBvEsVwmgVctbP5WHshuRCAG8DgcxGXIzNXVLkO/PAofeHQg6HgJMvW52ygCVaUg6l94VIJK1FMt9NUlAeoK+zy+ujWiO5o6pNKfmOGVZdEDrWPBgJj6N3Fpmc1fwJOjyqs7t9Dg1x38FJvw58kwGiCoatABK5+1B7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785994453; c=relaxed/simple;
	bh=qtFPb0PIesEz8aAUF8i75Bjty05zFqcGVFOo04ZMUH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XN5HHxdYFHjUyXpRguwtcQLWrf3AlH6EXrXfyhpLX5V7V859YSDjIxotNpLlMTfmiU+sbfMuQbG7kuqc7WuuIaHX6GqHkfxxmbnv6Gc68guTf0r9N5uEao2XM8g/M0J2wB2nm65lI9pDCpBJfpzXxXvQeAq9EoOay7qojnOPN+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ogJHBTtJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ogJHBTtJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 505941F000E9;
	Thu,  6 Aug 2026 05:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785994450;
	bh=n9gPSN0F4S7gbGqQFG/UTpug4iTvH7g11Ov/aHjBKs4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ogJHBTtJoWZzvQTbD8nhWh0CC0f1pSL85swyRaZ0kGtyBr0E7cqcM+TZNmhPHXBB8
	 ZeAaCIGWRKao4LHhcgf+w0E+gPjvhzHZ1o63szJwhL0B7UO/IgeoZ9YgocnAFYUfna
	 EiLPEedhLH6M9GzSFml27aiZVnxl/L1CvNOkYn7oCeP8ubURUh/ou+z2YENryINz0c
	 vnduVHhvys7+r6JKvz4paP+38lmXKBvbOkh4rcjHcySCxhNynGmRpoAchrflV/r6lX
	 N0tEPSGQPRcShLtYqnWk9c7q2WnU0ubN+KYauGOFA0VHZThVXRCfFu8nhuC/XJDVvN
	 R/NpqCIK8swhg==
Date: Wed, 5 Aug 2026 22:34:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Amir Goldstein <amir73il@gmail.com>, John Groves <john@jagalactic.com>,
	John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
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
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH V12 00/12] famfs: the Fabric-Attached Memory File System
 (standalone)
Message-ID: <20260806053409.GL3560084@frogsfrogsfrogs>
References: <20260803022730.75731-1-john@jagalactic.com>
 <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <CAOQ4uxhpkP7FsjaqqVO2aDSKCJ9yc3WKms6dncqnDuwGxqthng@mail.gmail.com>
 <anQZdSsJSyoqJkCo@casper.infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anQZdSsJSyoqJkCo@casper.infradead.org>

On Thu, Aug 06, 2026 at 06:19:49AM +0100, Matthew Wilcox wrote:
> On Mon, Aug 03, 2026 at 10:52:19AM +0200, Amir Goldstein wrote:
> > > The most important thing to know about famfs is that it CANNOT be used as a
> > > general purpose file system. It is for enabling file-based byte-level access
> > > (including direct mmap) to very large (e.g. 100TB) shared/disaggregated
> > > memory appliances - which have become available during this long process,
> > > and which are in need of Linux support.
> > >
> > > So famfs cannot be used by anybody who doesn't know why they need it; Making
> > > famfs standalone means it can't affect users who don't use it. And my super-
> > > mega-corp employer (Micron), as well as other memory companies, need it.
> > > We do not intend to abandon it, but imagine if we did: fs/famfs/ should be
> > > removed if the memory companies can't be bothered to maintain it.
> > 
> > It does not work this way.
> > When vfs maintainers accept standalone famfs they accept the burden of
> > maintaining it whenever vfs internal APIs change even if the filesystem was
> > abandoned by the mega-corps.
> > That is the code of the push back for adding new filesystems.
> > Removing the fs and breaking deployed systems is not an option for the vfs
> > maintainers.
> 
> Sure it is.  We removed EFS just last month, because we decided that it
> wasn't worth keeping any more.  Just like we removed Itanium architecture
> support (and a number of other architectures before that).  We've removed
> other filesystems in the past (xiafs, ext, surely a few others).

and freevxfs just this week because the one user/complainer said hch
could let it die.

--D

> Yes, there are burdens on others by accepting this filesystem -- but if
> it's a standalone VFS filesystem, those are felt by those who work on
> the VFS.  If it's part of FUSE, then it's felt by those who work on FUSE.
> And we've already determined that those who work on FUSE are even more
> overburdened than those who work on the VFS.
> 
> famfs does not seem to be a natural fit for FUSE.  It has needs unlike any
> other Linux filesystem, and quite possibly unlike any other filesystem
> that is to come.  Rearchitecting FUSE to make famfs fit seems like a
> very dodgy proposition to me.
> 
> 
