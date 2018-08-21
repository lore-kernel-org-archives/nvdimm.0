Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB946210EFAED
 for <linux-nvdimm@lists.01.org>; Tue, 21 Aug 2018 00:38:19 -0700 (PDT)
Date: Wed, 22 Aug 2018 00:16:57 +0800
From: Yi Zhang <yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH V2 1/1] device-dax: check for vma range while dax_mmap.
Message-ID: <20180821161657.GA22028@tiger-server>
References: <46441800c43f029757c70d8386e3112701081503.1534160958.git.yi.z.zhang@linux.intel.com>
 <1534787638.13739.52.camel@intel.com>
 <89e7bd54-4afa-614d-ec54-49af7928d6c7@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <89e7bd54-4afa-614d-ec54-49af7928d6c7@intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "Zhang, Yu C" <yu.c.zhang@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "zwisler@kernel.org" <zwisler@kernel.org>Zhang,
List-ID: <linux-nvdimm@lists.01.org>

On 2018-08-20 at 12:50:31 -0700, Dave Jiang wrote:
> 
> 
> On 08/20/2018 10:53 AM, Verma, Vishal L wrote:
> > 
> > On Mon, 2018-08-13 at 20:02 +0800, Zhang Yi wrote:
> >> This patch prevents a user mapping an illegal vma range that is larger
> >> than a dax device physical resource.
> >>
> >> When qemu maps the dax device for virtual nvdimm's backend device, the
> >> v-nvdimm label area is defined at the end of mapped range. By using an
> >> illegal size that exceeds the range of the device dax, it will trigger a
> >> fault with qemu.
> >>
> >> Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> >> ---
> >>  drivers/dax/device.c | 29 +++++++++++++++++++++++++++++
> >>  1 file changed, 29 insertions(+)
> >>
> > 
> > Looks good to me:
> > Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> 
> Applied.
Thanks Dava and Vishal's kindly review. Thank you.
> 
> > 
> >> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> >> index 108c37f..6fe8c30 100644
> >> --- a/drivers/dax/device.c
> >> +++ b/drivers/dax/device.c
> >> @@ -177,6 +177,33 @@ static const struct attribute_group *dax_attribute_groups[] = {
> >>  	NULL,
> >>  };
> >>  
> >> +static int check_vma_range(struct dev_dax *dev_dax, struct vm_area_struct *vma,
> >> +		const char *func)
> >> +{
> >> +	struct device *dev = &dev_dax->dev;
> >> +	struct resource *res;
> >> +	unsigned long size;
> >> +	int ret, i;
> >> +
> >> +	if (!dax_alive(dev_dax->dax_dev))
> >> +		return -ENXIO;
> >> +
> >> +	size = vma->vm_end - vma->vm_start + (vma->vm_pgoff << PAGE_SHIFT);
> >> +	ret = -EINVAL;
> >> +	for (i = 0; i < dev_dax->num_resources; i++) {
> >> +		res = &dev_dax->res[i];
> >> +		if (size > resource_size(res)) {
> >> +			dev_info_ratelimited(dev,
> >> +				"%s: %s: fail, vma range overflow\n",
> >> +				current->comm, func);
> >> +			ret = -EINVAL;
> >> +			continue;
> >> +		} else
> >> +			return 0;
> >> +	}
> >> +	return ret;
> >> +}
> >> +
> >>  static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
> >>  		const char *func)
> >>  {
> >> @@ -469,6 +496,8 @@ static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
> >>  	 */
> >>  	id = dax_read_lock();
> >>  	rc = check_vma(dev_dax, vma, __func__);
> >> +	if (!rc)
> >> +		rc = check_vma_range(dev_dax, vma, __func__);
> >>  	dax_read_unlock(id);
> >>  	if (rc)
> >>  		return rc;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
