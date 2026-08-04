Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71652459ACF;
	Tue,  4 Aug 2026 13:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785849933; cv=none; b=KVWN0XuaV0KAr8oCr4PEPYiMIzd4HzirgCRWxbnUwbWrET/mlqXv8ip7SQ6J1+TlWOOkwBW8vYYbC5NydAotQXqiQUFx9CcdXGo4dQ94bzaRlIsD9h+abSlFL8eITj3VcdFHO7ljHCqr7Z7VcdWWR70l2etRScOejFS4T47SQQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785849933; c=relaxed/simple;
	bh=kjAMYg37toYGozoeJPNOSg44izrSpZsfTtoBO0zeE0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F5nDXNl1DtiZwUCfkojj0NmgJH9zlG5zWRUUkn1dkUKMJ8TLfBS0LcqPB7JeTQSHPhymi3IDjfY0HyyLEs/ep7GKXIsfgjvTTeib20L+uXH9iazqrjQaqyy3Own0L+vm99g7dCQ1tg1eKZ7Q4JQX5b9Xi5z2GSAwKeUn7jaWTWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 353036732A; Tue,  4 Aug 2026 15:25:27 +0200 (CEST)
Date: Tue, 4 Aug 2026 15:25:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>, Yu Kuai <yukuai@fygo.io>,
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
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Christoph Hellwig <hch@lst.de>, Nilay Shroff <nilay@linux.ibm.com>,
	Tao Cui <cui.tao@linux.dev>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 1/3] blk-cgroup: add helpers for bio cgroup state
Message-ID: <20260804132527.GA8078@lst.de>
References: <20260804065313.2092022-1-yukuai@kernel.org> <20260804065313.2092022-2-yukuai@kernel.org> <prx5s4rwbgoeh7wtgyo7vwydh5iwqn6qc2utamowirsplspfmp@e3eteq5xwuyf>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <prx5s4rwbgoeh7wtgyo7vwydh5iwqn6qc2utamowirsplspfmp@e3eteq5xwuyf>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 04, 2026 at 12:52:16PM +0200, Jan Kara wrote:
> Mostly looks good. Just I think bio_blkcg() should gracefully handle the
> case where bio->bi_blkg is NULL (and return NULL in that case). That way
> you can also get rid of somewhat odd pattern:
> 
> 	if (!bio_blkg(bio))
> 		return ...;
> 	do something with bio_blkcg(bio)
> 
> You can then just check bio_blkcg(bio) directly which is much more obvious.

Yes.  Looking at the whole series I'm also not sure that this makes too
much sense as a split out patch as the next one touches more than half
of the callsite anyway.

