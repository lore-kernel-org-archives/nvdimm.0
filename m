Received: from mail108.syd.optusnet.com.au (mail108.syd.optusnet.com.au [211.29.132.59])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84CE2173
	for <nvdimm@lists.linux.dev>; Tue, 17 Aug 2021 03:04:06 +0000 (UTC)
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
	by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 995B41B4759;
	Tue, 17 Aug 2021 12:35:40 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1mFox0-001akg-CB; Tue, 17 Aug 2021 12:35:38 +1000
Date: Tue, 17 Aug 2021 12:35:38 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH v2.1 19/30] iomap: switch iomap_bmap to use iomap_iter
Message-ID: <20210817023538.GH3657114@dread.disaster.area>
References: <20210809061244.1196573-1-hch@lst.de>
 <20210809061244.1196573-20-hch@lst.de>
 <20210811191800.GH3601443@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811191800.GH3601443@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
	a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
	a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
	a=7-415B0cAAAA:8 a=PmpFC9ZAWq3O85gSWp8A:9 a=CjuIK1q_8ugA:10
	a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22

On Wed, Aug 11, 2021 at 12:18:00PM -0700, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Rewrite the ->bmap implementation based on iomap_iter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> [djwong: restructure the loop to make its behavior a little clearer]
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/iomap/fiemap.c |   31 +++++++++++++------------------
>  1 file changed, 13 insertions(+), 18 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
