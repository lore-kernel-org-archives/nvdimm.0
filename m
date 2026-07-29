Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5247E4749E8;
	Wed, 29 Jul 2026 11:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785324497; cv=none; b=DNrNYTP4UftRhqU7tOn8+adzyOeALnTSiDPoJHjalA2rWzSm5NAAf3dHcWkjaA5k/I+Zz5h4iB8VWdnfVW6Yi0KtYFKJpHFL+f+aWNTA7eelKEhCtgGpIAIdbiRE9zrciCWwr2qxcw4HqO5vsPTEx8LWbaQH+hO6kOw5JkxqqQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785324497; c=relaxed/simple;
	bh=FG0Xr4TF/wNaYujwP0ZMU6WSH62NsX5c7PbtzdKAbvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=asm4F3dsCLXcQRQLWwh13EljT+n5UKf+QjPnOTXqQhrxqli9IMe3bPODgPzQVrw/Rll0Cbthb6ZSHK+f75G79QAZSJTjYERl1jgX/cHGoWhQ0AGk599nmOy71NJSGgTUfV9kxsrGA0khA2R1CtHrHfevjccPisrIC9fmbIP9nhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EB33568AFE; Wed, 29 Jul 2026 13:28:08 +0200 (CEST)
Date: Wed, 29 Jul 2026 13:28:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	David Sterba <dsterba@suse.com>, Ilya Dryomov <idryomov@gmail.com>,
	dm-devel@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v4 01/14] dma-buf: introduce initial file I/O
 infrastructure
Message-ID: <20260729112808.GA30851@lst.de>
References: <cover.1785274111.git.asml.silence@gmail.com> <bc20381e8daf85ac58811c344325d8192cde9d1e.1785274111.git.asml.silence@gmail.com> <20260729065927.GA9534@lst.de> <340dd033-2a45-49e7-afd6-95dbbbf624da@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <340dd033-2a45-49e7-afd6-95dbbbf624da@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 29, 2026 at 11:37:19AM +0100, Pavel Begunkov wrote:
> On 7/29/26 07:59, Christoph Hellwig wrote:
>> The method name feels a bit convoluted, but given all the
>> previous discussions I don't care too strongly.  I'll leave
>> the dma-buf side review to those who understand it.
>
> I assume you mean this:

Yes.

>
> +	int (*init_dma_buf_io_ctx)(struct file *, struct dma_buf_io_ctx *);
>
> I agree, and all dma_buf_io_[ctx,map] look clunky, but I don't
> see what I can drop out of the name. Suggestions? Maybe I at least
> should make the fs op sth like "register_dma_buf".

I just remember scares from the last discussion :)

register_dma_buf sounds fine to be, but unless I misremember there
were objections to that before.

>
> -- 
> Pavel Begunkov
---end quoted text---
