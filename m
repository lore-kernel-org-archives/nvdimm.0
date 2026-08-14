Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D050A2F9DA1;
	Fri, 14 Aug 2026 07:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786691560; cv=none; b=NEdkA2egtGl1H763Zy1zI9U4TVFwwA9lvuvOvdmQFK/gbc/bFMXb/Mvpg8ZtBT3NrkNMR30+hattTU9TxhiYVgyr2uMqVmMSL+awv7VWLQKH/5BkLa3Ln3E3FKj130o7mwjFzAckasYg1vFLvmrAA68j8v80T4H4asNryDLhGl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786691560; c=relaxed/simple;
	bh=0R+rICBzr6spcVLpl5QzFLJOOJfP8i+kZaOnS9Vxi2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ue0w6Lvn5Bc+ignD4Kh4+1C3Q9Nbsk9Ph/pF/OZpBfLxS3LIfZMvqv/RuvnqJPrtLmgObU89htbIMvQ8vlgecI9Ii4/RseXzZ4kOdO9ezxa15QjrJIDd0oj73iOXwwBSTVHaEu/3FpwMruRTWxf3DtsL3HVGZ8Ky0tViRGZ2IS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D93C568B05; Fri, 14 Aug 2026 09:12:32 +0200 (CEST)
Date: Fri, 14 Aug 2026 09:12:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Yu Kuai <yukuai@fygo.io>, Christoph Hellwig <hch@lst.de>,
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
Message-ID: <20260814071232.GA9784@lst.de>
References: <20260811064744.1139446-1-yukuai@kernel.org> <20260811064744.1139446-3-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811064744.1139446-3-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 11, 2026 at 02:47:42PM +0800, Yu Kuai wrote:
> Keep q->blkg_list for ordered policy and scheduler walks. Initialize and
> destroy the hash with request_queue, and remove the radix-tree preload
> paths which are no longer needed.

Are these fast path operations?  Otherwise we can walk all rhashtable
entries without an extra list, but it might be slower.

> @@ -191,10 +198,15 @@ static void blkg_release(struct percpu_ref *ref)
>  {
>  	struct blkcg_gq *blkg = container_of(ref, struct blkcg_gq, refcnt);
>  	struct blkcg *blkcg = blkg->blkcg;
>  	int cpu;
>  
> +	if (!list_empty(&blkg->q_node))
> +		WARN_ON_ONCE(rhashtable_remove_fast(&blkg->q->blkg_hash,
> +						    &blkg->q_hash_node,
> +						    blkg_hash_params));
> +

The list_empty case is for initialization failure?  Or can we end up
with that by other means?

> + * Lookup a blkg for the @blkcg - @q pair, whether it is online or dying.
> + *
> + * Must be called in a RCU critical section.
> + */

Please add must_hold and/or lockdep annotations for this instead of just
a comment.

Also maybe mention that this does not acquire a reference and the caller
must already hold one?

