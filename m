Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FD072
	for <nvdimm@lists.linux.dev>; Mon, 20 Sep 2021 22:51:26 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10113"; a="203398951"
X-IronPort-AV: E=Sophos;i="5.85,309,1624345200"; 
   d="scan'208";a="203398951"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2021 15:51:25 -0700
X-IronPort-AV: E=Sophos;i="5.85,309,1624345200"; 
   d="scan'208";a="511562553"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2021 15:51:25 -0700
Date: Mon, 20 Sep 2021 15:51:25 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH 2/3] nvdimm/pmem: move dax_attribute_group from dax to
 pmem
Message-ID: <20210920225125.GY3169279@iweiny-DESK2.sc.intel.com>
References: <20210920072726.1159572-1-hch@lst.de>
 <20210920072726.1159572-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920072726.1159572-3-hch@lst.de>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Mon, Sep 20, 2021 at 09:27:25AM +0200, Christoph Hellwig wrote:

...

> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index ef4950f808326..bbeb3f46db157 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -328,6 +328,49 @@ static const struct dax_operations pmem_dax_ops = {
>  	.zero_page_range = pmem_dax_zero_page_range,
>  };
>  
> +static ssize_t write_cache_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct pmem_device *pmem = dev_to_disk(dev)->private_data;

I want to say this should be dax_get_private()...  However, looking at the use
of dax_get_private() not a single caller checks for NULL!  :-(

So now I wonder why dax_get_private() exists...  :-/

A quick history search does not make anything apparent.  When the DAXDEV_ALIVE
check was added to dax_get_private() no callers were changed to account for a
potential NULL return.

Dan?

> +
> +	return sprintf(buf, "%d\n", !!dax_write_cache_enabled(pmem->dax_dev));
> +}
> +
> +static ssize_t write_cache_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct pmem_device *pmem = dev_to_disk(dev)->private_data;

Same here...

Ira

