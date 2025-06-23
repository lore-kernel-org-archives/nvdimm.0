Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76A91F3BB0
	for <nvdimm@lists.linux.dev>; Mon, 23 Jun 2025 09:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750671789; cv=none; b=qM5Tx9V/qCJihWJXLNDT6r64nOE2E+2Oje5aY0UfARQXmzy/H5UTqbNx5U+KoZpG4JBZ+M2JwwhOAXujwB1U+MRvuayFNeJ2zMcZt7rUkxgaCU8v3DLkOeW1eX7ADx5Vd2fF/rhDyoa30Oj+lK7Kyh5p46SHL9G/S+HU4K+PRz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750671789; c=relaxed/simple;
	bh=kMlmjHwx3oiFn5F7q3Vxcu7mVmKsw4P94pgJNSLCTaQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iw/PAyuRXiedCwgooA5IGWL9hFvNSG0qvL06vblOf9EitoL245GktortTkn7O2K3NRXrlY1WMaJW1mtENnBHi/OAXgsjXf2M+20spBT3ceIUcnHfmlIl9sg9YShlX0UzoBoVVl7LicO+6l+ow0MAjqxKUq0bNAm75GaSqDDleUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bQjgP0698z6L5dQ;
	Mon, 23 Jun 2025 17:38:09 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id B89FE140446;
	Mon, 23 Jun 2025 17:43:04 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 23 Jun
 2025 11:43:03 +0200
Date: Mon, 23 Jun 2025 10:43:02 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <dan.j.williams@intel.com>, <dave@stgolabs.net>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <a.manzanares@samsung.com>, <nifan.cxl@gmail.com>,
	<anisa.su@samsung.com>, <vishak.g@samsung.com>, <krish.reddy@samsung.com>,
	<arun.george@samsung.com>, <alok.rathore@samsung.com>,
	<neeraj.kernel@gmail.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<gost.dev@samsung.com>, <cpgs@samsung.com>
Subject: Re: [RFC PATCH 14/20] cxl/region: Add cxl pmem region creation
 routine for region persistency
Message-ID: <20250623104302.00004405@huawei.com>
In-Reply-To: <1691538257.61750165382463.JavaMail.epsvc@epcpadp2new>
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124046epcas5p16a45d2afe3b41ca08994a5cca09bfb68@epcas5p1.samsung.com>
	<1691538257.61750165382463.JavaMail.epsvc@epcpadp2new>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 17 Jun 2025 18:09:38 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Added exported cxl_create_pmem_region routine to create cxl pmem region

For function names always add () after and drop 'function/routine' etc.
Ends up shorter and easier to read.

> from LSA parsed cxl region information.
> Inspirition for the function is taken from ndctl device attribute
> (_store) call. It allocates cxlr and fills information parsed from LSA
> and calls device_add(&cxlr->dev) to initiates further region creation
> porbes
Spell check.

> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/core/port.c   |   6 ++
>  drivers/cxl/core/region.c | 208 ++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h         |  11 ++
>  3 files changed, 225 insertions(+)
> 

> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index b98b1ccffd1c..8990e3c3474d 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -2522,6 +2522,214 @@ static ssize_t create_ram_region_show(struct device *dev,
>  	return __create_region_show(to_cxl_root_decoder(dev), buf);
>  }
>  
> +static ssize_t update_region_size(struct cxl_region *cxlr, u64 val)
> +{
> +	int rc;
> +
> +	rc = down_write_killable(&cxl_region_rwsem);
ACQUIRE() as mentioned below.

> +	if (rc)
> +		return rc;
> +
> +	if (val)
> +		rc = alloc_hpa(cxlr, val);
> +	else
> +		rc = free_hpa(cxlr);
> +	up_write(&cxl_region_rwsem);
> +
> +	if (rc)
> +		return rc;

	return rc;

> +
> +	return 0;
> +}
> +
> +static ssize_t update_region_dpa_size(struct cxl_region *cxlr,
> +		struct cxl_decoder *cxld,
> +		unsigned long long size)
> +{
> +	int rc;
> +	struct cxl_endpoint_decoder *cxled =
> +		to_cxl_endpoint_decoder(&cxld->dev);
> +
> +	if (!IS_ALIGNED(size, SZ_256M))
> +		return -EINVAL;
> +
> +	rc = cxl_dpa_free(cxled);
> +	if (rc)
> +		return rc;
> +
> +	if (size == 0)
> +		return 0;
> +
> +	rc = cxl_dpa_alloc(cxled, size);
return cxl_dpa_alloc()

Unless something more is getting added here in later patches in which case
you can ignore this comment.

> +	if (rc)
> +		return rc;
> +
> +	return 0;
> +}
> +
> +static ssize_t update_region_dpa_mode(struct cxl_region *cxlr,
> +		struct cxl_decoder *cxld)
> +{
> +	int rc;
> +	struct cxl_endpoint_decoder *cxled =
> +		to_cxl_endpoint_decoder(&cxld->dev);
Maybe don't bother with local variable and just put this
below as the parameter.
> +
> +	rc = cxl_dpa_set_mode(cxled, CXL_DECODER_PMEM);

return cxl_dpa_set_mode()

> +	if (rc)
> +		return rc;
> +
> +	return 0;
> +}
> +
> +static size_t attach_region_target(struct cxl_region *cxlr,
> +		struct cxl_decoder *cxld, int pos)
> +{
> +	int rc;
> +	struct cxl_endpoint_decoder *cxled =
> +		to_cxl_endpoint_decoder(&cxld->dev);
> +
> +	rc = attach_target(cxlr, cxled, pos, TASK_INTERRUPTIBLE);
> +
No blank line here
> +	if (rc < 0)
Can it ever be > 0 ?
If not, return attach_target() should be fine.
> +		return rc;
> +
> +	return 0;
> +}
> +
> +static ssize_t commit_region(struct cxl_region *cxlr)
> +{
> +	struct cxl_region_params *p = &cxlr->params;
> +	ssize_t rc;
> +
> +	rc = down_write_killable(&cxl_region_rwsem);

Maybe look at Dan's new ACQUIRE() series. The last patch in there
is targeting code similar to this.

> +	if (rc)
> +		return rc;
> +
> +	/* Already in the requested state? */
> +	if (p->state >= CXL_CONFIG_COMMIT)
> +		goto out;
> +
> +	/* Not ready to commit? */
> +	if (p->state < CXL_CONFIG_ACTIVE) {
> +		rc = -ENXIO;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Invalidate caches before region setup to drop any speculative
> +	 * consumption of this address space
> +	 */
> +	rc = cxl_region_invalidate_memregion(cxlr);
> +	if (rc)
> +		goto out;
> +
> +	rc = cxl_region_decode_commit(cxlr);
> +	if (rc == 0)
With AQUIRE() stuff you can just  do
	if (rc)
		return rc;

here

> +		p->state = CXL_CONFIG_COMMIT;
> +out:
> +	up_write(&cxl_region_rwsem);
> +	if (rc)
> +		return rc;
> +	return 0;
> +}
> +
> +static struct cxl_region *
> +devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd,
> +		struct cxl_decoder *cxld,
> +		struct cxl_pmem_region_params *params, int id,
> +		enum cxl_decoder_mode mode, enum cxl_decoder_type type)
> +{
> +	struct cxl_port *port;
> +	struct cxl_region *cxlr;
> +	struct cxl_region_params *p;
> +	struct device *dev;
> +	int rc;
> +
> +	if (!cxlrd)
> +		return ERR_PTR(-EINVAL);

For a check like this, add a comment on why it might be NULL.
If it can't be, then drop the check.

> +
> +	port = to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);

Maybe add a comment on which port this actually is.  These long indirections
can make that hard to figure out!

> +
> +	cxlr = cxl_region_alloc(cxlrd, id);
> +	if (IS_ERR(cxlr))
> +		return cxlr;
> +	cxlr->mode = mode;
> +	cxlr->type = type;
> +
> +	dev = &cxlr->dev;
> +	rc = dev_set_name(dev, "region%d", id);
> +	if (rc)
> +		goto err;
> +
> +	p = &cxlr->params;
> +	p->uuid = params->uuid;
> +	p->interleave_ways = params->nlabel;
> +	p->interleave_granularity = params->ig;
> +
> +	/* Update region size */
> +	if (update_region_size(cxlr, params->rawsize))
> +		goto err;
> +
> +	/* Flush cxl wq */

Much more useful to say 'why' you are flushing it.  It's obvious
from the code that you are.

> +	cxl_wq_flush();
> +
> +	/* Clear DPA Size */

I'd look at all these comments and where they are obvious, drop the comment
and let the code speak for itself.

> +	if (update_region_dpa_size(cxlr, cxld, 0))
> +		goto err;
> +
> +	/* Update DPA mode */
> +	if (update_region_dpa_mode(cxlr, cxld))
> +		goto err;
> +
> +	/* Update DPA Size */
> +	if (update_region_dpa_size(cxlr, cxld, params->rawsize))
> +		goto err;
> +
> +	/* Attach region targets */
It's attaching just one by the look of it.  I'd just drop the comment.

> +	if (attach_region_target(cxlr, cxld, params->position))
> +		goto err;
> +
> +	/* Commit Region */
> +	if (commit_region(cxlr))
> +		goto err;
> +
> +	rc = device_add(dev);
> +	if (rc)
> +		goto err;
> +
> +	rc = devm_add_action_or_reset(port->uport_dev, unregister_region, cxlr);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	dev_dbg(port->uport_dev, "%s: created %s\n",
> +		dev_name(&cxlrd->cxlsd.cxld.dev), dev_name(dev));
> +	return cxlr;
> +
> +err:
> +	put_device(dev);
> +	return ERR_PTR(rc);
> +}
> +
> +struct cxl_region *cxl_create_pmem_region(struct cxl_root_decoder *cxlrd,
> +		struct cxl_decoder *cxld,
> +		struct cxl_pmem_region_params *params, int id)
> +{
> +	int rc;
> +
> +	rc = memregion_alloc(GFP_KERNEL);
> +	if (rc < 0)
> +		return ERR_PTR(rc);
> +
> +	if (atomic_cmpxchg(&cxlrd->region_id, id, rc) != id) {
> +		memregion_free(rc);
> +		return ERR_PTR(-EBUSY);
> +	}
I'm a little surprised not to see cleanup of the memregion via
devm somewhere here.
> +
> +	return devm_cxl_pmem_add_region(cxlrd, cxld, params, id,
> +			CXL_DECODER_PMEM, CXL_DECODER_HOSTONLYMEM);
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_create_pmem_region, "CXL");
> +
>  static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
>  					  enum cxl_decoder_mode mode, int id)
>  {


