Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D1E4499BB;
	Fri, 14 Aug 2026 08:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786695342; cv=none; b=EEhY3+Gz+tv5m6BRZIuQypc8G1H6TBzNfh6mLqiRFM4cmG2AcvXmsQ2i6Dx/3WSNPZBY5SVx9vNrYP2phvwF/Oz1SKsUQS7mQ1q5LX3SaJLipe1H2bI3q6JP3xAmWRq5pDsw78TyGlOgw5tiDUo3AwRCiUPf1ia/BvWV7GBo8mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786695342; c=relaxed/simple;
	bh=JB32DLYALZLS4AXuuV0NyWqb6KOX2SUFTZ+RIuKwbCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1sY7yPWlvKp8fdsmNCpyYT2VpC/k0UwsG7TkJYzOPBGfMmIBEouVcsz4i3DZ2qt0dFB0Z1fqIpNBmT1pBxwLNlYeOZEW5l13+UT7z5mtd3n5H2lzOgNH+6MFi5pDz8Pf0NIEFzeL5GuScvnKIMMbZ4yN/NVNsUIwxkEaraggr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CDE7568B05; Fri, 14 Aug 2026 10:15:31 +0200 (CEST)
Date: Fri, 14 Aug 2026 10:15:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: yukuai@fygo.io
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Tao Cui <cui.tao@linux.dev>, Jan Kara <jack@suse.cz>,
	Ming Lei <ming.lei@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/4] blk-cgroup: use a request_queue rhashtable
 for blkg lookup
Message-ID: <20260814081531.GA13546@lst.de>
References: <20260811064744.1139446-1-yukuai@kernel.org> <20260811064744.1139446-3-yukuai@kernel.org> <20260814071232.GA9784@lst.de> <f7350050-062a-4ced-9396-05ac33ac3e60@fnnas.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7350050-062a-4ced-9396-05ac33ac3e60@fnnas.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 14, 2026 at 03:50:04PM +0800, Yu Kuai wrote:
> > Are these fast path operations?  Otherwise we can walk all rhashtable
> > entries without an extra list, but it might be slower.
> 
> All users are from sysfs/cgroupfs API, I think they can be considered slow path,
> however currently spinlock is held in these procedures, I think it's better to
> convert them to blkg_lookup based iterate after spinlock is converted to the
> blkcg_mutex.

Sounds good.  Maybe put that into the commit log?

> > Please add must_hold and/or lockdep annotations for this instead of just
> > a comment.
> >
> > Also maybe mention that this does not acquire a reference and the caller
> > must already hold one?
> 
> Perhaps it's more accurate that the blkg is pinned by IO or caller already
> hold one?

Sounds good.

