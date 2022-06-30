Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5575B3D7C;
	Thu, 30 Jun 2022 13:44:26 +0000 (UTC)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LYfbR1Z49z67JRZ;
	Thu, 30 Jun 2022 21:40:19 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 30 Jun 2022 15:44:23 +0200
Received: from localhost (10.81.200.250) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 30 Jun
 2022 14:44:22 +0100
Date: Thu, 30 Jun 2022 14:44:20 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>, <hch@lst.de>, "Ben
 Widawsky" <bwidawsk@kernel.org>
Subject: Re: [PATCH 36/46] cxl/region: Add interleave ways attribute
Message-ID: <20220630144420.000005b5@Huawei.com>
In-Reply-To: <20220624041950.559155-11-dan.j.williams@intel.com>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
	<20220624041950.559155-11-dan.j.williams@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.81.200.250]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 23 Jun 2022 21:19:40 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> From: Ben Widawsky <bwidawsk@kernel.org>
> 
> Add an ABI to allow the number of devices that comprise a region to be
> set.

Should at least mention interleave_granularity is being added as well!

> 
> Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
> [djbw: reword changelog]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Random diversion inline...

> ---
>  Documentation/ABI/testing/sysfs-bus-cxl |  21 ++++
>  drivers/cxl/core/region.c               | 128 ++++++++++++++++++++++++
>  drivers/cxl/cxl.h                       |  33 ++++++
>  3 files changed, 182 insertions(+)

> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index f75978f846b9..78af42454760 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -7,6 +7,7 @@


> +static ssize_t interleave_granularity_store(struct device *dev,
> +					    struct device_attribute *attr,
> +					    const char *buf, size_t len)
> +{
> +	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev->parent);
> +	struct cxl_decoder *cxld = &cxlrd->cxlsd.cxld;
> +	struct cxl_region *cxlr = to_cxl_region(dev);
> +	struct cxl_region_params *p = &cxlr->params;
> +	int rc, val;
> +	u16 ig;
> +
> +	rc = kstrtoint(buf, 0, &val);
> +	if (rc)
> +		return rc;
> +
> +	rc = granularity_to_cxl(val, &ig);
> +	if (rc)
> +		return rc;
> +
> +	/* region granularity must be >= root granularity */

In general I think that's an implementation choice.  Sure today
we only support it this way, but it's perfectly possible to build
setups where that's not the case.  Maybe the comment should say
that this code goes with an implementation choice inline with
the software guide (that argues you will always prefer small
ig for interleaving at the host to make best use of bandwidth etc).

Interestingly the code I was previously testing QEMU with
allowed that option (might have been only option that worked).
That code was a mixture of Ben's earlier version and my own hacks.
It probably doesn't make sense to support other ways of picking
the interleaving granularity until / if we ever get a request
to do so. 

I think it results in a different device ordering.

Ordering with this

    Host
     | 4k
    / \
   /   \  
  HB   HB  8k
  |     |
 / \   / \
0  2   1  3

Ordering with Larger granularity CFMWS over finer granularity HB

    Host
     | 8k
    / \
   /   \ 
  HB   HB 4k
  |     |
 / \   / \
0  1   2  3

Not clear why you'd do the second one though :)  So can ignore for now.


> +	if (val < cxld->interleave_granularity)
> +		return -EINVAL;
> +
> +	rc = down_write_killable(&cxl_region_rwsem);
> +	if (rc)
> +		return rc;
> +	if (p->state >= CXL_CONFIG_INTERLEAVE_ACTIVE) {
> +		rc = -EBUSY;
> +		goto out;
> +	}
> +
> +	p->interleave_granularity = val;
> +out:
> +	up_read(&cxl_region_rwsem);
> +	if (rc)
> +		return rc;
> +	return len;
> +}
> +static DEVICE_ATTR_RW(interleave_granularity);
> +
>  static struct attribute *cxl_region_attrs[] = {
>  	&dev_attr_uuid.attr,
> +	&dev_attr_interleave_ways.attr,
> +	&dev_attr_interleave_granularity.attr,
>  	NULL,
>  };
>  


