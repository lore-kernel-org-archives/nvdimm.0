Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 93A43210D226B
 for <linux-nvdimm@lists.01.org>; Wed,  1 Aug 2018 12:40:39 -0700 (PDT)
Subject: Re: [RFC PATCH 1/1] device-dax: check for vma range while dax_mmap.
References: <e260d513ab831bfe1298374c87c6cca5f7dd3a6f.1533036772.git.yi.z.zhang@linux.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <12a2ebd8-0f15-7d0a-697c-172ed7f77f92@intel.com>
Date: Wed, 1 Aug 2018 12:40:36 -0700
MIME-Version: 1.0
In-Reply-To: <e260d513ab831bfe1298374c87c6cca5f7dd3a6f.1533036772.git.yi.z.zhang@linux.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Zhang Yi <yi.z.zhang@linux.intel.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, jack@suse.cz, zwisler@kernel.org, yu.c.zhang@intel.com
Cc: yi.z.zhang@intel.com
List-ID: <linux-nvdimm@lists.01.org>



On 07/31/2018 04:46 AM, Zhang Yi wrote:
> It should be prevent user map an illegal vma range which larger than
> dax device phiscal resourse, as we don't have swap logic while page
> faulting in dax device.

This patch prevents a user mapping an illegal vma range that is larger
than a dax device physical resource.

> 
> Applications, especailly qemu, map the /dev/dax for virtual nvdimm's
> backend device, we defined the v-nvdimm label area at the end of mapped
> rang. By using an illegal size that exceeds the physical resource of
> /dev/dax, then it will triger qemu a signal fault while accessing these
> label area.

When qemu maps the dax device for virtual nvdimm's backend device, the
v-nvdimm label area is defined at the end of mapped range. By using an
illegal size that exceeds the range of the device dax, it will trigger a
fault with qemu.

> 
> Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> ---
>  drivers/dax/device.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index aff2c15..c9a50cd 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -177,6 +177,32 @@ static const struct attribute_group *dax_attribute_groups[] = {
>  	NULL,
>  };
>  
> +static int check_vma_range(struct dev_dax *dev_dax, struct vm_area_struct *vma,
> +		const char *func)
> +{
> +	struct device *dev = &dev_dax->dev;
> +	struct resource *res;
> +	unsigned long size;
> +	int ret, i;
> +
> +	if (!dax_alive(dev_dax->dax_dev))
> +		return -ENXIO;
> +
> +	size = vma->vm_end - vma->vm_start + (vma->vm_pgoff << PAGE_SHIFT);
> +	ret = -EINVAL;
> +	for (i = 0; i < dev_dax->num_resources; i++) {
> +		res = &dev_dax->res[i];
> +		if (size > resource_size(res)) {
> +			dev_info(dev, "%s: %s: fail, vma range is overflow\n",
> +				current->comm, func);
> +			ret = -EINVAL;
> +			continue;
> +		} else
> +			return 0;
> +	}
> +	return ret;
> +}
> +
>  static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
>  		const char *func)
>  {
> @@ -465,6 +491,8 @@ static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
>  	 */
>  	id = dax_read_lock();
>  	rc = check_vma(dev_dax, vma, __func__);
> +	if (!rc)
> +		rc |= check_vma_range(dev_dax, vma, __func__);

I think you want to augment check_vma() rather than adding another
function? If this is added inside check_vma() then you can also skip the
!dax_alive() check. Do you expect this function to be called anywhere else?

>  	dax_read_unlock(id);
>  	if (rc)
>  		return rc;
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
