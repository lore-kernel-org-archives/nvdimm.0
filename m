Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B36384CFE;
	Thu,  6 Aug 2026 05:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785993618; cv=none; b=BaYnxslA55lkVL2QbQBhOjZb0i3ZmEeSOI0yOjMTJ8vbVfzc6gZjbX+dvUuRrxm4kFwv9Ar7BNEbykATGWvEjchHhehfB6Hw/0yy0E4EiQgdLwckW7/s0P5ozuSThDMdMGyaG3bYgZAsb+tLGIcw6Mk4sLg8dPi4q9izCpzUs8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785993618; c=relaxed/simple;
	bh=KNXZR/LVlhW7cqVwqDyYjIinH6uth2cyGvivFnDsnQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=doxTkN5HBl/jh4sBcl/Zu3Wc6lSCF0KsgH+XKNXT1anDt1ch9sSLv7oSBe6FeYh+vlphT9F90VmoS5AB1lV5g9/7trmuyMITLcOf7VO7jY0rkGcbMc24gEItZWlViG0hOiZ1LVBD/DVgG4Q8KUC/1ij7arERRWUUeOwW/mrQTkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qfAwWdfC; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qfAwWdfC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9eGhrP/4inubhemIuyuFEbzWNT9DRkOmrPt/GX3DiEA=; b=qfAwWdfCm4ONqMDxThsbXA5PTe
	LRjqFp/u9izIIkQ1LR5Lys8CpkYLm1rzq7rvvK7XoFHmznPBmHUoO242bm7MFqOZd8Ojwbpzu5xqq
	u//4IbWRHaUr0C7EWWmikxeapp3T1/QOJXSX/IEKyK7yK+Qa87Uvws/f9lBqpmyNiN004lF8SoRw9
	P12bqs0ALx57jf9WLG/hJ7ldczzE/5Jq3yLmDcgNJAHPVqaZicI3YbAd0/MfblS1QIvpV7Jy2KAIK
	J5IGCoJLKAUp/oj86Q3iL2rJlBS6+57im1sflLLXdnWmjyh7N0BB0U0X8+8YgjsBKTdRLH7REuRgQ
	eEl5/2AA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrqWD-00000008TwQ-1lbE;
	Thu, 06 Aug 2026 05:19:49 +0000
Date: Thu, 6 Aug 2026 06:19:49 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: John Groves <john@jagalactic.com>, John Groves <John@groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <djbw@kernel.org>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
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
Message-ID: <anQZdSsJSyoqJkCo@casper.infradead.org>
References: <20260803022730.75731-1-john@jagalactic.com>
 <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <CAOQ4uxhpkP7FsjaqqVO2aDSKCJ9yc3WKms6dncqnDuwGxqthng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhpkP7FsjaqqVO2aDSKCJ9yc3WKms6dncqnDuwGxqthng@mail.gmail.com>

On Mon, Aug 03, 2026 at 10:52:19AM +0200, Amir Goldstein wrote:
> > The most important thing to know about famfs is that it CANNOT be used as a
> > general purpose file system. It is for enabling file-based byte-level access
> > (including direct mmap) to very large (e.g. 100TB) shared/disaggregated
> > memory appliances - which have become available during this long process,
> > and which are in need of Linux support.
> >
> > So famfs cannot be used by anybody who doesn't know why they need it; Making
> > famfs standalone means it can't affect users who don't use it. And my super-
> > mega-corp employer (Micron), as well as other memory companies, need it.
> > We do not intend to abandon it, but imagine if we did: fs/famfs/ should be
> > removed if the memory companies can't be bothered to maintain it.
> 
> It does not work this way.
> When vfs maintainers accept standalone famfs they accept the burden of
> maintaining it whenever vfs internal APIs change even if the filesystem was
> abandoned by the mega-corps.
> That is the code of the push back for adding new filesystems.
> Removing the fs and breaking deployed systems is not an option for the vfs
> maintainers.

Sure it is.  We removed EFS just last month, because we decided that it
wasn't worth keeping any more.  Just like we removed Itanium architecture
support (and a number of other architectures before that).  We've removed
other filesystems in the past (xiafs, ext, surely a few others).

Yes, there are burdens on others by accepting this filesystem -- but if
it's a standalone VFS filesystem, those are felt by those who work on
the VFS.  If it's part of FUSE, then it's felt by those who work on FUSE.
And we've already determined that those who work on FUSE are even more
overburdened than those who work on the VFS.

famfs does not seem to be a natural fit for FUSE.  It has needs unlike any
other Linux filesystem, and quite possibly unlike any other filesystem
that is to come.  Rearchitecting FUSE to make famfs fit seems like a
very dodgy proposition to me.

