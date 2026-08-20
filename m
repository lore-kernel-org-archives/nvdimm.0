Received: from mta1.migadu.com (out-245.mta1.migadu.com [95.215.58.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC023D411B
	for <nvdimm@lists.linux.dev>; Thu, 20 Aug 2026 09:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787219889; cv=none; b=UTe4ANmfK+ijqXV6xQi4KcJK7XScnQtQMhqmn++HSbsg91FqoqJVMtO4Z540/48KgsKH7sHNUZy5PmJQ0MYKtHWErk31wy8PM85Nx6VHmFz9TmZ9d4CMg5AxGz9dV601Pc1a0Au0YtPZjDVUk33qYXdhZAow+S3BkD+vI4/MUX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787219889; c=relaxed/simple;
	bh=ploZAqY/D2hnRbV7P/iJz6tixE4616igwYG3fSAUDUQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TA6bKmhK8yORzrmOp06YPSEm+BkyektKEV+n4LtJr1VOeypgM/ElLxE3B5hyv7LGU35JACe5TzuBm0fvGptbzoBo48+qMk4GosbDSmXAwIXnEYsCtAAFjHLarBqRpkDFVO4OGw+TgyfSl7xi1s3jFTOdL4wIcXzmje4sf8S7ow0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sfnF2BCp; arc=none smtp.client-ip=95.215.58.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sfnF2BCp"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ploZAqY/D2hnRbV7P/iJz6tixE4616igwYG3fSAUDUQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787219884; v=1; x=1787824684;
 b=sfnF2BCped+jyf3PRpPzWg9vqwTDJJt/G77kBAYEimhgBNMrXjAjpD9Y1q39Y7RVJZIgHVDF
 dP3uOTlhH0NWBOeZD26tkFr79yLOS8u50QQQsR79HARIiD5vn/XFm2aNigQbOJgSyK2sBQZDgh4
 YWHkgVFGG3nvg4rNpjKYEpBw=
X-Envelope-To: nvdimm@lists.linux.dev
Received: from [192.168.110.173] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id e22b78b065807185;
	Thu, 20 Aug 2026 09:58:04 +0000
X-Mizu-Trace-ID: e22b78b065807185
X-Migadu-Flow: FLOW_OUT
Message-ID: <f9ab386b-fe45-49ef-8e7a-c8544ef3241a@linux.dev>
Date: Thu, 20 Aug 2026 17:57:50 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, Yu Kuai <yukuai@fygo.io>,
 Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
 Ming Lei <ming.lei@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Coly Li <colyli@fygo.io>,
 Kent Overstreet <kent.overstreet@linux.dev>, Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>,
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
 virtualization@lists.linux.dev, gfs2@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 1/3] blk-cgroup: use a request_queue rhashtable for
 blkg lookup
To: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
References: <20260818070641.756747-1-yukuai@kernel.org>
 <20260818070641.756747-2-yukuai@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260818070641.756747-2-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/8/18 15:06, Yu Kuai 写道:
> blkg lookup currently uses a per-blkcg radix tree keyed by request queue
> ID, plus a lookup hint for the common case. This spreads the queue-local
> blkcg association index across every blkcg and requires radix-tree
> preloading before creating a blkg while holding q->queue_lock.
> 
> Replace the radix tree and lookup hint with a request_queue-owned
> rhashtable keyed by the blkcg CSS ID. Cache the ID in each blkg; the blkg
> holds a CSS reference until after it leaves the hash, so the ID cannot be
> reused while it is hash-visible. The integer key also reduces hashing and
> comparison work relative to a pointer-sized key on 64-bit systems.
> 
> Keep entries until blkg_release() and provide blkg_lookup_any() for callers
> which need to find dying entries. blkg_lookup() filters offline entries so
> existing lookup semantics remain unchanged.
> 
> Keep q->blkg_list for ordered policy and scheduler walks. All current
> walkers are cgroupfs or sysfs slow paths, so they can move to rhashtable
> iteration once the q->queue_lock to q->blkcg_mutex conversion lands.
> Initialize and destroy the hash with request_queue, and remove the
> radix-tree preload paths which are no longer needed.
> 
> blkg_release() removes the hash entry only when the blkg was successfully
> inserted into q->blkg_list; the list_empty case covers allocation or
> creation failure before insertion.

Reviewed-by: Tao Cui <cuitao@kylinos.cn>

