Received: from mail108.syd.optusnet.com.au (mail108.syd.optusnet.com.au [211.29.132.59])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B89A5173
	for <nvdimm@lists.linux.dev>; Tue, 17 Aug 2021 02:37:05 +0000 (UTC)
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
	by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id F26771B4722;
	Tue, 17 Aug 2021 12:37:03 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1mFoyN-001amD-2Z; Tue, 17 Aug 2021 12:37:03 +1000
Date: Tue, 17 Aug 2021 12:37:02 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 31/30] iomap: move iomap iteration code to iter.c
Message-ID: <20210817023702.GJ3657114@dread.disaster.area>
References: <20210809061244.1196573-1-hch@lst.de>
 <20210811191926.GJ3601443@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811191926.GJ3601443@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
	a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
	a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
	a=7-415B0cAAAA:8 a=q_jVzwUvvCIIwZNgioUA:9 a=CjuIK1q_8ugA:10
	a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22

On Wed, Aug 11, 2021 at 12:19:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've moved iomap to the iterator model, rename this file to be
> in sync with the functions contained inside of it.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/iomap/Makefile |    2 +-
>  fs/iomap/iter.c   |    0 
>  2 files changed, 1 insertion(+), 1 deletion(-)
>  rename fs/iomap/{apply.c => iter.c} (100%)
> 
> diff --git a/fs/iomap/Makefile b/fs/iomap/Makefile
> index e46f936dde81..bb64215ae256 100644
> --- a/fs/iomap/Makefile
> +++ b/fs/iomap/Makefile
> @@ -26,9 +26,9 @@ ccflags-y += -I $(srctree)/$(src)		# needed for trace events
>  obj-$(CONFIG_FS_IOMAP)		+= iomap.o
>  
>  iomap-y				+= trace.o \
> -				   apply.o \
>  				   buffered-io.o \
>  				   direct-io.o \
>  				   fiemap.o \
> +				   iter.o \
>  				   seek.o
>  iomap-$(CONFIG_SWAP)		+= swapfile.o
> diff --git a/fs/iomap/apply.c b/fs/iomap/iter.c
> similarity index 100%
> rename from fs/iomap/apply.c
> rename to fs/iomap/iter.c

LGTM,

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
