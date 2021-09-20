Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E725272
	for <nvdimm@lists.linux.dev>; Mon, 20 Sep 2021 22:52:18 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10113"; a="223294443"
X-IronPort-AV: E=Sophos;i="5.85,309,1624345200"; 
   d="scan'208";a="223294443"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2021 15:52:18 -0700
X-IronPort-AV: E=Sophos;i="5.85,309,1624345200"; 
   d="scan'208";a="556519811"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2021 15:52:18 -0700
Date: Mon, 20 Sep 2021 15:52:18 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH 1/3] nvdimm/pmem: fix creating the dax group
Message-ID: <20210920225216.GZ3169279@iweiny-DESK2.sc.intel.com>
References: <20210920072726.1159572-1-hch@lst.de>
 <20210920072726.1159572-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920072726.1159572-2-hch@lst.de>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Mon, Sep 20, 2021 at 09:27:24AM +0200, Christoph Hellwig wrote:
> The recent block layer refactoring broke the way how the pmem driver
> abused device_add_disk.  Fix this by properly passing the attribute groups
> to device_add_disk.
> 
> Fixes: 52b85909f85d ("block: fold register_disk into device_add_disk")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/nvdimm/pmem.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 72de88ff0d30d..ef4950f808326 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -380,7 +380,6 @@ static int pmem_attach_disk(struct device *dev,
>  	struct nd_pfn_sb *pfn_sb;
>  	struct pmem_device *pmem;
>  	struct request_queue *q;
> -	struct device *gendev;
>  	struct gendisk *disk;
>  	void *addr;
>  	int rc;
> @@ -489,10 +488,8 @@ static int pmem_attach_disk(struct device *dev,
>  	}
>  	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
>  	pmem->dax_dev = dax_dev;
> -	gendev = disk_to_dev(disk);
> -	gendev->groups = pmem_attribute_groups;
>  
> -	device_add_disk(dev, disk, NULL);
> +	device_add_disk(dev, disk, pmem_attribute_groups);
>  	if (devm_add_action_or_reset(dev, pmem_release_disk, pmem))
>  		return -ENOMEM;
>  
> -- 
> 2.30.2
> 
