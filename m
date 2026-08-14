Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27CC3E3DB1;
	Fri, 14 Aug 2026 08:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786695372; cv=none; b=g49cwQ5O0FxZn7Kldfs5/x3c3Uf+F+3wda4w8aVlXOZI9n8bfKflKu3mC87y7wHeSRcjrW3X9pJY6rwToqhEJqPSJmJWzgX0ALmOwt4qOL1D/BdyKdQBq4Xyou2QlMOQzNawkNr+DbpmP+4sOY0eokaRASzc4i24IzxKF39qYlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786695372; c=relaxed/simple;
	bh=odumUnmQaOM9XlG4Bt+fltrLkUyY9uCrcGl/EvW/x0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xsex2CLUd/PhQN75mZk4XhdoCoAKV14IFK4vYf475HH0puWqmDaj9kYrgs0jP5DpTUzPwJ6k/T7ZmKpDGW9kbPGxuw38kyTYxFYlTtWbnermJZzIZRbG6nzG6XGCMoSMn5fg2lGw6ouyuyica5A0WxBoI77s+CddWKhSsnr8VAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 63B2B68B05; Fri, 14 Aug 2026 10:16:06 +0200 (CEST)
Date: Fri, 14 Aug 2026 10:16:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: yu kuai <yukuai@fygo.io>
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
Subject: Re: [RFC PATCH v2 0/4] blk-cgroup: store blkcg in bio before
 blkcg_mutex conversion
Message-ID: <20260814081606.GB13546@lst.de>
References: <20260811064744.1139446-1-yukuai@kernel.org> <20260814064537.GA9355@lst.de> <d1d47b32-b746-42d1-a391-5e37d4e373fb@fygo.io>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1d47b32-b746-42d1-a391-5e37d4e373fb@fygo.io>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 14, 2026 at 03:53:44PM +0800, yu kuai wrote:
> I'll rebase to the latest for-7.3/block branch in the next version.

Thanks.  For anything complicated a link to the git branch can also
be helpful.

