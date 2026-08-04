Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F011368D5A;
	Tue,  4 Aug 2026 15:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785858451; cv=none; b=lzN5Pt0rWxpKAepR8BJ3HCNoyLsfhBHn0D4OMz7vBYustOKzbP8EGGw6fkI7/qD7QFo2m2ShgyzaEpxYuog3//mnTHKlfIVyV8ykllf8fyqwogqtE0MWp9bNP4ZJ1q5RunFV67/9jBq1mjmduj/TBTWe0fovYp0R02hQdjLyJNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785858451; c=relaxed/simple;
	bh=3INYlQKobLh4mMVUFvPghDpGiNw6y0KRfCXHtoDWGyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JiQFvfiOVpx1zl0/TmJQIA8n3TNUmZgYLhCuktk2J2larECkYa0UWsjPf5npMyZyKFXPkQOnsRw3KiKcUYqSG4dlot8wqmZxjtD1p1Q7XXtI3ThsGWw7zNeLoWXKDeTl4uRMRYm2WAqQ0pFPDwyHh1Ye3EIeqoLd1IhEUYyTIIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5789C6732A; Tue,  4 Aug 2026 17:47:22 +0200 (CEST)
Date: Tue, 4 Aug 2026 17:47:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: yu kuai <yukuai@fygo.io>
Cc: Christoph Hellwig <hch@lst.de>, Tao Cui <cui.tao@linux.dev>,
	Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Nilay Shroff <nilay@linux.ibm.com>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of
 blkg
Message-ID: <20260804154721.GA11379@lst.de>
References: <20260804065313.2092022-1-yukuai@kernel.org> <20260804065313.2092022-3-yukuai@kernel.org> <a677f581-344b-4d99-846d-a00801e26033@linux.dev> <20260804133208.GB8078@lst.de> <0fc5dd22-7a8d-43f0-8555-d2ca966efff6@fygo.io>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fc5dd22-7a8d-43f0-8555-d2ca966efff6@fygo.io>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 04, 2026 at 11:30:55PM +0800, yu kuai wrote:
> The problem here is that remove a cgroup can also remove the blkg from radix tree,
> even through it still has active refcounts. I think this can be fixed by checking
> the cgroup online_pin first, if it's zero, we can search the blkg from the
> request_queue blkg list, where blkg will not be removed until blkg_free_workfn().
> What's better, if we can convert the blkg list to hash table with key as blk-cgroup,
> it will be much better as we can lookup from this table instead of blkcg radix tree.

Yes, I think you can really easily do that with the rhashtable.

