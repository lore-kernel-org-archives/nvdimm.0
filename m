Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 24 Apr 2017 14:31:12 +0900
From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Subject: Re: [PATCH] libnvdimm, region: sysfs trigger for nvdimm_flush()
In-Reply-To: <149281853758.22910.2919981036906495309.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149281853758.22910.2919981036906495309.stgit@dwillia2-desk3.amr.corp.intel.com>
Message-Id: <20170424143104.4517.61FB500B@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 21 Apr 2017 16:48:57 -0700 Dan Williams wrote:
> The nvdimm_flush() mechanism helps to reduce the impact of an ADR
> (asynchronous-dimm-refresh) failure. The ADR mechanism handles flushing
> platform WPQ (write-pending-queue) buffers when power is removed. The
> nvdimm_flush() mechanism performs that same function on-demand.
> 
> When a pmem namespace is associated with a block device, an
> nvdimm_flush() is triggered with every block-layer REQ_FUA, or REQ_FLUSH
> request. However, when a namespace is in device-dax mode, or namespaces
> are disabled, userspace needs another path.
> 
> The new 'flush' attribute is visible when it can be determined that the
> interleave-set either does, or does not have DIMMs that expose WPQ-flush
> addresses, "flush-hints" in ACPI NFIT terminology. It returns "1" and
> flushes DIMMs, or returns "0" the flush operation is a platform nop.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/nvdimm/region_devs.c |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index 8de5a04644a1..3495b4c23941 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -255,6 +255,19 @@ static ssize_t size_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(size);
>  
> +static ssize_t flush_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct nd_region *nd_region = to_nd_region(dev);
> +
> +	if (nvdimm_has_flush(nd_region)) {

nvdimm_has_flush() also returns as -ENXIO, so

if (nvdimm_has_flush(nd_region) == 1)  

> +		nvdimm_flush(nd_region);
> +		return sprintf(buf, "1\n");
> +	}
> +	return sprintf(buf, "0\n");
> +}
> +static DEVICE_ATTR_RO(flush);
> +

I think separating show and store is better because
users may only check wheter the device has the flush capability or not.

The separate code is like as follows (not tested).

static ssize_t flush_show(struct device *dev,
	struct device_attribute *attr, char *buf)
{
	struct nd_region *nd_region = to_nd_region(dev);

	if (nvdimm_has_flush(nd_region) == 1) {
		return sprintf(buf, "1\n");
	} else {
		return sprintf(buf, "0\n");
	}
}

static ssize_t flush_store(struct device *dev,
	struct device_attribute *attr, const char *buf, size_t len)
{
	bool flush;
	int rc = strtobool(buf, &flush);
	struct nd_region *nd_region = to_nd_region(dev);

	if (rc)
		return rc;

	if (flush && (nvdimm_has_flush(nd_region) == 1)) {
		nvdimm_flush(nd_region);
		return 0;
	} else {
		return -1;
	}
}
static DEVICE_ATTR_RW(flush);

Regards,
Masayoshi Mizuma

>  static ssize_t mappings_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
> @@ -474,6 +487,7 @@ static DEVICE_ATTR_RO(resource);
>  
>  static struct attribute *nd_region_attributes[] = {
>  	&dev_attr_size.attr,
> +	&dev_attr_flush.attr,
>  	&dev_attr_nstype.attr,
>  	&dev_attr_mappings.attr,
>  	&dev_attr_btt_seed.attr,
> @@ -508,6 +522,9 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
>  	if (!is_nd_pmem(dev) && a == &dev_attr_resource.attr)
>  		return 0;
>  
> +	if (a == &dev_attr_flush.attr && nvdimm_has_flush(nd_region) < 0)
> +		return 0;
> +
>  	if (a != &dev_attr_set_cookie.attr
>  			&& a != &dev_attr_available_size.attr)
>  		return a->mode;
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
