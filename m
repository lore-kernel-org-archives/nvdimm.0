Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA84572
	for <nvdimm@lists.linux.dev>; Mon, 20 Sep 2021 22:52:51 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10113"; a="202744973"
X-IronPort-AV: E=Sophos;i="5.85,309,1624345200"; 
   d="scan'208";a="202744973"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2021 15:52:47 -0700
X-IronPort-AV: E=Sophos;i="5.85,309,1624345200"; 
   d="scan'208";a="556519969"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2021 15:52:47 -0700
Date: Mon, 20 Sep 2021 15:52:47 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH 3/3] block: warn if ->groups is set when calling add_disk
Message-ID: <20210920225246.GA3169279@iweiny-DESK2.sc.intel.com>
References: <20210920072726.1159572-1-hch@lst.de>
 <20210920072726.1159572-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920072726.1159572-4-hch@lst.de>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Mon, Sep 20, 2021 at 09:27:26AM +0200, Christoph Hellwig wrote:
> The proper API is to pass the groups to device_add_disk, but the code
> used to also allow groups being set before calling *add_disk.  Warn
> about that but keep the group pointer intact for now so that it can
> be removed again after a grace period.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Fixes: 52b85909f85d ("block: fold register_disk into device_add_disk")

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  block/genhd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 7b6e5e1cf9564..409cf608cc5bd 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -439,7 +439,8 @@ int device_add_disk(struct device *parent, struct gendisk *disk,
>  	dev_set_uevent_suppress(ddev, 1);
>  
>  	ddev->parent = parent;
> -	ddev->groups = groups;
> +	if (!WARN_ON_ONCE(ddev->groups))
> +		ddev->groups = groups;
>  	dev_set_name(ddev, "%s", disk->disk_name);
>  	if (!(disk->flags & GENHD_FL_HIDDEN))
>  		ddev->devt = MKDEV(disk->major, disk->first_minor);
> -- 
> 2.30.2
> 
