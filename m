Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CF522A7E5
	for <nvdimm@lists.linux.dev>; Sat, 19 Jul 2025 07:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752910052; cv=none; b=aZUXdovvnpt9tm4aQKg8hFEkJRPhqfIJOPOKEYWJPYIHxLHkfG43oh3r8bLGNCwyYCqi9yPsh675h4mSay/JDkv+D8Axg8GWRFJWqkVBldyvmma4o29lsXP+Xj9x/TSf1ozaiGatrACXHs/aP/yr6Gz1AhnVx6+wBs9jQLllzXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752910052; c=relaxed/simple;
	bh=Ka8wbhGAtUXco/CEjaVgXQCExf5evykP9hZuaUlM4I8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=hHVGlQAAG8Pg3RRuA9jtemOajjdWHr17jnKN1jlSG6F6BRpOZdtw6cv+A3131TqKpnRtli2AzFCmMLpjB1kUvrgJjuRKxNqfPCjDhZlX8oSOI4HwMLT7/Ott0hlqaXdYxELJIJBFin2VSVukljFXp90Y+qEmZgkfY1v5oIFFNcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=mOUQ3TaM; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mOUQ3TaM"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250719071803epoutp029ed49f246971482271dc24c10022a514~TleNbF_uT0727807278epoutp02A
	for <nvdimm@lists.linux.dev>; Sat, 19 Jul 2025 07:18:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250719071803epoutp029ed49f246971482271dc24c10022a514~TleNbF_uT0727807278epoutp02A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1752909483;
	bh=6DSre2VwzDo1w+Z2wYHJq9YH5OUDEQqT3Hf+FS+cC/U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mOUQ3TaM1Ta7zSty8Hl+zEy8g3GaM6hscv54/kdz7qMNDW915tIAngxwGTZJmykZ4
	 ykAWKTR0t1H22buN+mc9KaTO6Yplx1dJVTUhPe8Edtgt/t6gTSECFSjjuDOlactt2N
	 4jJ3r/jJHuQMgI9LWW1QofsLN7APa8et8MJLS930=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250719071802epcas5p4c115f1ba86d86d744bef95836d949130~TleMgplGR0565305653epcas5p4s;
	Sat, 19 Jul 2025 07:18:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bkdKk4qzyz6B9mB; Sat, 19 Jul
	2025 07:18:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250718124523epcas5p41c5fbffd31f46267e94d73299d742851~TWStvua6C2913129131epcas5p4m;
	Fri, 18 Jul 2025 12:45:23 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250718124520epsmtip293563894362cd4d77a9588e4a5e37f37~TWSrUpOEx1708417084epsmtip2u;
	Fri, 18 Jul 2025 12:45:20 +0000 (GMT)
Date: Fri, 18 Jul 2025 18:15:15 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com, a.manzanares@samsung.com,
	nifan.cxl@gmail.com, anisa.su@samsung.com, vishak.g@samsung.com,
	krish.reddy@samsung.com, arun.george@samsung.com, alok.rathore@samsung.com,
	neeraj.kernel@gmail.com, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, gost.dev@samsung.com,
	cpgs@samsung.com
Subject: Re: [RFC PATCH 14/20] cxl/region: Add cxl pmem region creation
 routine for region persistency
Message-ID: <1296674576.21752909482669.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <fdc06026-c681-4dae-9202-ad89293931a5@intel.com>
X-CMS-MailID: 20250718124523epcas5p41c5fbffd31f46267e94d73299d742851
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_23494_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124046epcas5p16a45d2afe3b41ca08994a5cca09bfb68
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124046epcas5p16a45d2afe3b41ca08994a5cca09bfb68@epcas5p1.samsung.com>
	<1691538257.61750165382463.JavaMail.epsvc@epcpadp2new>
	<fdc06026-c681-4dae-9202-ad89293931a5@intel.com>

------kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_23494_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 10/07/25 08:59AM, Dave Jiang wrote:
>
>
>On 6/17/25 5:39 AM, Neeraj Kumar wrote:
>> Added exported cxl_create_pmem_region routine to create cxl pmem region
>> from LSA parsed cxl region information.
>> Inspirition for the function is taken from ndctl device attribute
>> (_store) call. It allocates cxlr and fills information parsed from LSA
>> and calls device_add(&cxlr->dev) to initiates further region creation
>> porbes
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/cxl/core/port.c   |   6 ++
>>  drivers/cxl/core/region.c | 208 ++++++++++++++++++++++++++++++++++++++
>>  drivers/cxl/cxl.h         |  11 ++
>>  3 files changed, 225 insertions(+)
>>
>> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
>> index bca668193c49..2452f7c15b2d 100644
>> --- a/drivers/cxl/core/port.c
>> +++ b/drivers/cxl/core/port.c
>> @@ -2150,6 +2150,12 @@ void cxl_bus_drain(void)
>>  }
>>  EXPORT_SYMBOL_NS_GPL(cxl_bus_drain, "CXL");
>>
>> +void cxl_wq_flush(void)
>> +{
>> +	flush_workqueue(cxl_bus_wq);
>> +}
>> +EXPORT_SYMBOL_NS_GPL(cxl_wq_flush, "CXL");
>> +
>>  bool schedule_cxl_memdev_detach(struct cxl_memdev *cxlmd)
>>  {
>>  	return queue_work(cxl_bus_wq, &cxlmd->detach_work);
>> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
>> index b98b1ccffd1c..8990e3c3474d 100644
>> --- a/drivers/cxl/core/region.c
>> +++ b/drivers/cxl/core/region.c
>> @@ -2522,6 +2522,214 @@ static ssize_t create_ram_region_show(struct device *dev,
>>  	return __create_region_show(to_cxl_root_decoder(dev), buf);
>>  }
>>
>> +static ssize_t update_region_size(struct cxl_region *cxlr, u64 val)
>
>Maybe call it resize_or_free_region_hpa()?
>
>Also rename 'val' to 'size'
>

Sure Dave, I will fix it next patch-set.

>> +{
>> +	int rc;
>> +
>> +	rc = down_write_killable(&cxl_region_rwsem);
>> +	if (rc)
>> +		return rc;
>> +
>> +	if (val)
>> +		rc = alloc_hpa(cxlr, val);
>> +	else
>> +		rc = free_hpa(cxlr);
>> +	up_write(&cxl_region_rwsem);
>> +
>> +	if (rc)
>> +		return rc;
>> +
>> +	return 0;
>> +}
>
>Share common code with core/region.c:size_store(). Please use helper function and not duplicate code.
>

Sure, I will try to minimize duplicate code as much as possible in next patch-set.

>> +
>> +static ssize_t update_region_dpa_size(struct cxl_region *cxlr,
>
>resize_or_free_dpa()
>

Sure, I will fix it in next patch-set

>> +		struct cxl_decoder *cxld,
>> +		unsigned long long size)
>
>u64 size
>

Sure, I will fix it in next patch-set

>> +{
>> +	int rc;
>> +	struct cxl_endpoint_decoder *cxled =
>> +		to_cxl_endpoint_decoder(&cxld->dev);
>> +
>> +	if (!IS_ALIGNED(size, SZ_256M))
>> +		return -EINVAL;
>> +
>> +	rc = cxl_dpa_free(cxled);
>> +	if (rc)
>> +		return rc;
>> +
>> +	if (size == 0)
>> +		return 0;
>> +
>> +	rc = cxl_dpa_alloc(cxled, size);
>> +	if (rc)
>> +		return rc;
>> +
>> +	return 0;
>> +}
>
>Share common code with core/port.c:dpa_size_store(). Please use helper function and not duplicate code.
>

Sure, I will try minimizing duplicate code as much as possible.

>> +
>> +static ssize_t update_region_dpa_mode(struct cxl_region *cxlr,
>> +		struct cxl_decoder *cxld)
>> +{
>> +	int rc;
>> +	struct cxl_endpoint_decoder *cxled =
>> +		to_cxl_endpoint_decoder(&cxld->dev);
>> +
>> +	rc = cxl_dpa_set_mode(cxled, CXL_DECODER_PMEM);
>
>Don't think CXL_DECODER_PMEM exists any longer. It's CXL_PARTMODE_PMEM. Just beware there have been some changes while you are rebasing to the latest upstream code.
>

Thanks, I will rebase and fix it with latest change

>> +	if (rc)
>> +		return rc;
>> +
>> +	return 0;
>> +}
>> +
>> +static size_t attach_region_target(struct cxl_region *cxlr,
>> +		struct cxl_decoder *cxld, int pos)
>> +{
>> +	int rc;
>> +	struct cxl_endpoint_decoder *cxled =
>> +		to_cxl_endpoint_decoder(&cxld->dev);
>> +
>> +	rc = attach_target(cxlr, cxled, pos, TASK_INTERRUPTIBLE);
>> +
>> +	if (rc < 0)
>> +		return rc;
>> +
>> +	return 0;
>> +}
>> +
>> +static ssize_t commit_region(struct cxl_region *cxlr)
>> +{
>> +	struct cxl_region_params *p = &cxlr->params;
>> +	ssize_t rc;
>> +
>> +	rc = down_write_killable(&cxl_region_rwsem);
>> +	if (rc)
>> +		return rc;
>> +
>> +	/* Already in the requested state? */
>> +	if (p->state >= CXL_CONFIG_COMMIT)
>> +		goto out;
>> +
>> +	/* Not ready to commit? */
>> +	if (p->state < CXL_CONFIG_ACTIVE) {
>> +		rc = -ENXIO;
>> +		goto out;
>> +	}
>> +
>> +	/*
>> +	 * Invalidate caches before region setup to drop any speculative
>> +	 * consumption of this address space
>> +	 */
>> +	rc = cxl_region_invalidate_memregion(cxlr);
>> +	if (rc)
>> +		goto out;
>> +
>> +	rc = cxl_region_decode_commit(cxlr);
>> +	if (rc == 0)
>> +		p->state = CXL_CONFIG_COMMIT;
>> +out:
>> +	up_write(&cxl_region_rwsem);
>> +	if (rc)
>> +		return rc;
>> +	return 0;
>> +}
>
>Sharing common code with core/region.c:commit_store()?
>

Sure, I will handle it in next patch-set

>> +
>> +static struct cxl_region *
>> +devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd,
>> +		struct cxl_decoder *cxld,
>> +		struct cxl_pmem_region_params *params, int id,
>> +		enum cxl_decoder_mode mode, enum cxl_decoder_type type)
>> +{
>> +	struct cxl_port *port;
>> +	struct cxl_region *cxlr;
>> +	struct cxl_region_params *p;
>> +	struct device *dev;
>> +	int rc;
>> +
>> +	if (!cxlrd)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	port = to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);
>> +
>> +	cxlr = cxl_region_alloc(cxlrd, id);
>> +	if (IS_ERR(cxlr))
>> +		return cxlr;
>> +	cxlr->mode = mode;
>> +	cxlr->type = type;
>> +
>> +	dev = &cxlr->dev;
>> +	rc = dev_set_name(dev, "region%d", id);
>> +	if (rc)
>> +		goto err;
>> +> +	p = &cxlr->params;
>> +	p->uuid = params->uuid;
>> +	p->interleave_ways = params->nlabel;
>> +	p->interleave_granularity = params->ig;
>> +
>> +	/* Update region size */
>Not sure what value this comment adds

Sure, I will remove these comments

>> +	if (update_region_size(cxlr, params->rawsize))
>> +		goto err;
>> +
>> +	/* Flush cxl wq */
>Can you explain here why a flush is needed?

These steps of region creation is taken from how ndctl creates region
using *_store(). I will re-look if its required here.

>> +	cxl_wq_flush();
>> +
>> +	/* Clear DPA Size */
>comment provides no value
>> +	if (update_region_dpa_size(cxlr, cxld, 0))
>> +		goto err;
>> +
>> +	/* Update DPA mode */
>same as above
>> +	if (update_region_dpa_mode(cxlr, cxld))
>> +		goto err;
>> +
>> +	/* Update DPA Size */
>same as above
>> +	if (update_region_dpa_size(cxlr, cxld, params->rawsize))
>> +		goto err;
>> +
>> +	/* Attach region targets */
>same as above
>> +	if (attach_region_target(cxlr, cxld, params->position))
>> +		goto err;
>> +
>> +	/* Commit Region */
>same as above

Sure, I will remove unwanted comments

>> +	if (commit_region(cxlr))
>> +		goto err;
>
>Can you please provide some verbose explanation as to what all these extra steps are doing for pmem versus devm_cxl_add_region() for dram?
>

These steps of region creation is taken from how ndctl creates region.
Sure I will update the comments accordingly.

>> +
>> +	rc = device_add(dev);
>> +	if (rc)
>> +		goto err;
>> +
>> +	rc = devm_add_action_or_reset(port->uport_dev, unregister_region, cxlr);
>> +	if (rc)
>> +		return ERR_PTR(rc);
>> +
>> +	dev_dbg(port->uport_dev, "%s: created %s\n",
>> +		dev_name(&cxlrd->cxlsd.cxld.dev), dev_name(dev));
>> +	return cxlr;
>> +
>> +err:
>> +	put_device(dev);
>> +	return ERR_PTR(rc);
>> +}
>> +
>> +struct cxl_region *cxl_create_pmem_region(struct cxl_root_decoder *cxlrd,
>> +		struct cxl_decoder *cxld,
>> +		struct cxl_pmem_region_params *params, int id)
>> +{
>> +	int rc;
>> +
>> +	rc = memregion_alloc(GFP_KERNEL);
>> +	if (rc < 0)
>> +		return ERR_PTR(rc);
>> +
>> +	if (atomic_cmpxchg(&cxlrd->region_id, id, rc) != id) {
>> +		memregion_free(rc);
>> +		return ERR_PTR(-EBUSY);
>> +	}
>> +
>> +	return devm_cxl_pmem_add_region(cxlrd, cxld, params, id,
>> +			CXL_DECODER_PMEM, CXL_DECODER_HOSTONLYMEM);
>> +}
>> +EXPORT_SYMBOL_NS_GPL(cxl_create_pmem_region, "CXL");
>
>Can __create_region() be modified to determine whether to create dram region or pmem?
>
>DJ

Sure, I will refactor it accordingly

Regards,
Neeraj

------kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_23494_
Content-Type: text/plain; charset="utf-8"


------kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_23494_--

