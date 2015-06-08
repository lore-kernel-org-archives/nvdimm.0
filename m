Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH v4 4/9] dax: fix mapping lifetime handling, convert to
 __pfn_t + kmap_atomic_pfn_t()
Date: Mon, 8 Jun 2015 16:29:39 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A973B07@G9W0745.americas.hpqcorp.net>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150605211924.20751.434.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150605211924.20751.434.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "arnd@arndb.de" <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, "hpa@zytor.com" <hpa@zytor.com>, "david@fromorbit.com" <david@fromorbit.com>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>, "mingo@kernel.org" <mingo@kernel.org>, "tj@kernel.org" <tj@kernel.org>, "paulus@samba.org" <paulus@samba.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "hch@lst.de" <hch@lst.de>, "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf
> Of Dan Williams
> Sent: Friday, June 05, 2015 3:19 PM
> Subject: [PATCH v4 4/9] dax: fix mapping lifetime handling, convert to
> __pfn_t + kmap_atomic_pfn_t()
...
> diff --git a/arch/powerpc/sysdev/axonram.c
> b/arch/powerpc/sysdev/axonram.c
> index e8657d3bc588..20725006592e 100644
> --- a/arch/powerpc/sysdev/axonram.c
> +++ b/arch/powerpc/sysdev/axonram.c
...
> @@ -165,9 +166,13 @@ static int axon_ram_probe(struct platform_device
> *device)
>  {
>  	static int axon_ram_bank_id = -1;
>  	struct axon_ram_bank *bank;
> -	struct resource resource;
> +	struct resource *resource;
>  	int rc = 0;
> 
> +	resource = devm_kzalloc(&device->dev, sizeof(*resource),
> GFP_KERNEL);
> +	if (!resource)
> +		return -ENOMEM;
> +

Since resource is now a pointer...

...
> @@ -184,13 +189,13 @@ static int axon_ram_probe(struct platform_device
> *device)
> 
>  	bank->device = device;
> 
> -	if (of_address_to_resource(device->dev.of_node, 0, &resource) != 0)
> {
> +	if (of_address_to_resource(device->dev.of_node, 0, resource) != 0) {
>  		dev_err(&device->dev, "Cannot access device tree\n");
>  		rc = -EFAULT;
>  		goto failed;
>  	}
...

... I'd expect to see a devm_kfree call added after the failed label, 
like was  done here:

> diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> index 2f1734ba0e22..a7b9743c546f 100644
> --- a/drivers/s390/block/dcssblk.c
> +++ b/drivers/s390/block/dcssblk.c
...
>  struct dcssblk_dev_info {
> @@ -520,12 +522,18 @@ static const struct attribute_group
> *dcssblk_dev_attr_groups[] = {
>  static ssize_t
>  dcssblk_add_store(struct device *dev, struct device_attribute *attr, const
> char *buf, size_t count)
>  {
> +	struct resource *res = devm_kzalloc(dev, sizeof(*res), GFP_KERNEL);
>  	int rc, i, j, num_of_segments;
>  	struct dcssblk_dev_info *dev_info;
>  	struct segment_info *seg_info, *temp;
>  	char *local_buf;
>  	unsigned long seg_byte_size;
> 
> +	if (!res) {
> +		rc = -ENOMEM;
> +		goto out_nobuf;
> +	}
> +
>  	dev_info = NULL;
>  	seg_info = NULL;
>  	if (dev != dcssblk_root_dev) {
> @@ -652,6 +660,13 @@ dcssblk_add_store(struct device *dev, struct
> device_attribute *attr, const char
>  	if (rc)
>  		goto put_dev;
> 
> +	res->start = dev_info->start;
> +	res->end = dev_info->end - 1;
> +	rc = devm_register_kmap_pfn_range(&dev_info->dev, res,
> +			(void *) dev_info->start);
> +	if (rc)
> +		goto put_dev;
> +
>  	get_device(&dev_info->dev);
>  	add_disk(dev_info->gd);
> 
> @@ -699,6 +714,8 @@ seg_list_del:
>  out:
>  	kfree(local_buf);
>  out_nobuf:
> +	if (res)
> +		devm_kfree(dev, res);
>  	return rc;
>  }


