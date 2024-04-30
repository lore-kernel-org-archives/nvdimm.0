Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E150DDC1
	for <nvdimm@lists.linux.dev>; Tue, 30 Apr 2024 03:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714446707; cv=none; b=FlQQmvKrL4XluKOhHNManrAqITaZmu9VSTfGoRBrSchIe8PtegZToineUJDVT5A7XOv2kZZ/nsYv5wWJWP5pfhhVekgE9P2dD4MGEkf0qc6eW8vnc6Q63Lq+e4F8rn+Z9KRhdkPsXNXzc2XQyly6r2946tCw+IjIudm84vQNNs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714446707; c=relaxed/simple;
	bh=Z8Gr90fEJ1GKKj2x22uk9ZTJNqg1lehHEtjXiDth6tg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AMwtqcMlYC2cP88YgUBIWov3ZIpPIl1K56QxPD5rrfdWObqgqX7eMbqyJw4kqYEz2f4m1yjRCr5XFeGtwjEk7t7gypjzU2IGiK77hWliJnu+MvWQdCpW/bmMGkUDp4UposUEyFKmyHdXeZbdLjnvEezcwvcGG7/FOfAlYT/AWxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qx7i8im+; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qx7i8im+"
Date: Mon, 29 Apr 2024 23:11:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714446702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EI4HmUwJEPBRTrRQTROmcu/O+eYA5pmkoiZh1idyL4A=;
	b=qx7i8im+4hQwZCeJa4irMcQULuMdYP1ZD7vSpbIPZ9bSB0UJeP5Kc0XWy9pVFR1lqvWj3u
	7s8I6tJK5hHHFYLVelTimit+rl7VNTmh2FjKHrgsDeNu/jNQk0FBQjQJtuGsNUU2hnm1i+
	Tc44WXIvUlNBnwLcZak84DPTGF9SP1s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: John Groves <John@groves.net>
Cc: Matthew Wilcox <willy@infradead.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	John Groves <jgroves@micron.com>, john@jagalactic.com, Dave Chinner <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, dave.hansen@linux.intel.com, gregory.price@memverge.com, 
	Randy Dunlap <rdunlap@infradead.org>, Jerome Glisse <jglisse@google.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	Eishan Mirakhur <emirakhur@micron.com>, Ravi Shankar <venkataravis@micron.com>, 
	Srinivasulu Thanneeru <sthanneeru@micron.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Chandan Babu R <chandanbabu@kernel.org>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Steve French <stfrench@microsoft.com>, Nathan Lynch <nathanl@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Julien Panis <jpanis@baylibre.com>, Stanislav Fomichev <sdf@google.com>, 
	Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: Re: [RFC PATCH v2 00/12] Introduce the famfs shared-memory file
 system
Message-ID: <h6tbyvdeq5hzkttsy4uyzq4v64xlkzeqfyo52ku3w4x3vvtpd7@4vxafcct62xh>
References: <cover.1714409084.git.john@groves.net>
 <Zi_n15gvA89rGZa_@casper.infradead.org>
 <bnkdeobpatyunljvujzvwydtixkkj3gfeyvk4pzgndfxo7uc32@y6lk7nplt3uk>
 <jklmoshdemmnv62nfvygkr5blz75jq6fhhaqaditws4hsj6glr@rkhdqze4d7un>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jklmoshdemmnv62nfvygkr5blz75jq6fhhaqaditws4hsj6glr@rkhdqze4d7un>
X-Migadu-Flow: FLOW_OUT

On Mon, Apr 29, 2024 at 09:24:19PM -0500, John Groves wrote:
> On 24/04/29 07:08PM, Kent Overstreet wrote:
> > On Mon, Apr 29, 2024 at 07:32:55PM +0100, Matthew Wilcox wrote:
> > > On Mon, Apr 29, 2024 at 12:04:16PM -0500, John Groves wrote:
> > > > This patch set introduces famfs[1] - a special-purpose fs-dax file system
> > > > for sharable disaggregated or fabric-attached memory (FAM). Famfs is not
> > > > CXL-specific in anyway way.
> > > > 
> > > > * Famfs creates a simple access method for storing and sharing data in
> > > >   sharable memory. The memory is exposed and accessed as memory-mappable
> > > >   dax files.
> > > > * Famfs supports multiple hosts mounting the same file system from the
> > > >   same memory (something existing fs-dax file systems don't do).
> > > 
> > > Yes, but we do already have two filesystems that support shared storage,
> > > and are rather more advanced than famfs -- GFS2 and OCFS2.  What are
> > > the pros and cons of improving either of those to support DAX rather
> > > than starting again with a new filesystem?
> > 
> > I could see a shared memory filesystem as being a completely different
> > beast than a shared block storage filesystem - and I've never heard
> > anyone talking about gfs2 or ocfs2 as codebases we particularly liked.
> 
> Thanks for your attention on famfs, Kent.
> 
> I think of it as a completely different beast. See my reply to Willy re:
> famfs being more of a memory allocator with the benefit of allocations 
> being accessible (and memory-mappable) as files.

That's pretty much what I expected.

I would suggest talking to RDMA people; RDMA does similar things with
exposing address spaces across machine, and an "external" memory
allocator is a basic building block there as well - it'd be great if we
could get that turned into some clean library code.

GPU people as well, possibly.

> The famfs user space repo has some good documentation as to the on-
> media structure of famfs. Scroll down on [1] (the documentation from
> the famfs user space repo). There is quite a bit of info in the docs
> from that repo.

Ok, looking through that now.

So youv've got a metadata log; that looks more like a conventional
filesystem than a conventional purely in-memory thing.

But you say it's a shared filesystem, and it doesn't say anything about
that. Inter node locking?

Perhaps the ocfs2/gfs2 comparison is appropriate, after all.
