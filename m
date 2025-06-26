Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1337D28F93F
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750944188; cv=none; b=BHeHh+Z7vlruQW69hoU4AtdlJuZce1ZHufsJeefbMUGvBK5lJzw2F5uMaE+aMetm9zCE+6EZqIQ4b799jnPotI+AduOtrW+BJwhBAKvt4Z4q0Ze8ml9QzTSoUdzH2FasmiSxfXFkqpdXzt5tF5e41X3jnhqE53cBe9q+zkV6Vfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750944188; c=relaxed/simple;
	bh=mEk/sf4jMnWD4aVcoVAJS6jc/CXild9xsrSwlM/cZzg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=Ts5mwOuV3Qr9NlIHc8zzbdulGK5OOba8dh4XJPm71VLZsEJDGDmYS33AtXj6EbjHOAfPzEPwoNlIyRPzKrbX8qWGf98O8V1QH2h+UWujP4feIalKQ9fMcpfXeW9m6C7y2GqWL7CB4fjEAFeEtHgEsDkucSIO0TVDJ2UVcfLiMx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=jizbDCAa; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="jizbDCAa"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250626132304epoutp03b638682e4b589f08594ef5b04fa13a54~MmnVnDrPP1803518035epoutp03F
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:23:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250626132304epoutp03b638682e4b589f08594ef5b04fa13a54~MmnVnDrPP1803518035epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750944184;
	bh=iG2v36I614UfF86gO3Y0nL2ZXRImVmqXFsPGNNjYlyQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jizbDCAald6sUsl3uJMoZpktpv6TBe2YBfXWWe1729VobYyk9soQlPiZOn7wi62zN
	 y44H4K37rP3ruSmHxuCs4BHHFpdsRcjIIiG4hj5POCRbjrwv9FN9zKkvOlm6ZBRfnF
	 tgYuYvDDynHy9C3uCVsECoHVLEcxl8boW6oU9y7k=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250626132303epcas5p29fdbe25345b528a6fe52fed6331c4a2c~MmnVBVFRR1277112771epcas5p26;
	Thu, 26 Jun 2025 13:23:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bSfWW3Yphz6B9m9; Thu, 26 Jun
	2025 13:23:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250626102349epcas5p4a95657225d88573ba8f9161b236cf6ba~MkK1iieAO2060020600epcas5p47;
	Thu, 26 Jun 2025 10:23:49 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250626102346epsmtip23afa32e1113aea6cb7102ccdc1907203~MkKzICMCa0334403344epsmtip2R;
	Thu, 26 Jun 2025 10:23:46 +0000 (GMT)
Date: Thu, 26 Jun 2025 15:53:41 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
	a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: Re: [RFC PATCH 14/20] cxl/region: Add cxl pmem region creation
 routine for region persistency
Message-ID: <700072760.81750944183483.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250623104302.00004405@huawei.com>
X-CMS-MailID: 20250626102349epcas5p4a95657225d88573ba8f9161b236cf6ba
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_cd910_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124046epcas5p16a45d2afe3b41ca08994a5cca09bfb68
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124046epcas5p16a45d2afe3b41ca08994a5cca09bfb68@epcas5p1.samsung.com>
	<1691538257.61750165382463.JavaMail.epsvc@epcpadp2new>
	<20250623104302.00004405@huawei.com>

------K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_cd910_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/06/25 10:43AM, Jonathan Cameron wrote:
>On Tue, 17 Jun 2025 18:09:38 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> Added exported cxl_create_pmem_region routine to create cxl pmem region
>
>For function names always add () after and drop 'function/routine' etc.
>Ends up shorter and easier to read.
>

Sure, Will fix it accordingly

>> from LSA parsed cxl region information.
>> Inspirition for the function is taken from ndctl device attribute
>> (_store) call. It allocates cxlr and fills information parsed from LSA
>> and calls device_add(&cxlr->dev) to initiates further region creation
>> porbes
>Spell check.
>

Thanks, Will fix it up.

>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/cxl/core/port.c   |   6 ++
>>  drivers/cxl/core/region.c | 208 ++++++++++++++++++++++++++++++++++++++
>>  drivers/cxl/cxl.h         |  11 ++
>>  3 files changed, 225 insertions(+)
>>
>
>> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
>> index b98b1ccffd1c..8990e3c3474d 100644
>> --- a/drivers/cxl/core/region.c
>> +++ b/drivers/cxl/core/region.c
>> @@ -2522,6 +2522,214 @@ static ssize_t create_ram_region_show(struct device *dev,
>>  	return __create_region_show(to_cxl_root_decoder(dev), buf);
>>  }
>>
>> +static ssize_t update_region_size(struct cxl_region *cxlr, u64 val)
>> +{
>> +	int rc;
>> +
>> +	rc = down_write_killable(&cxl_region_rwsem);
>ACQUIRE() as mentioned below.
>

Sure, Let me look at Dan's new ACQUIRE() series. I will update it in V1

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
>
>	return rc;
>

Thanks, I will update it.

>> +
>> +	return 0;
>> +}
>> +
>> +static ssize_t update_region_dpa_size(struct cxl_region *cxlr,
>> +		struct cxl_decoder *cxld,
>> +		unsigned long long size)
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
>return cxl_dpa_alloc()
>
>Unless something more is getting added here in later patches in which case
>you can ignore this comment.
>

Thanks, Will fix it accordingly

>> +	if (rc)
>> +		return rc;
>> +
>> +	return 0;
>> +}
>> +
>> +static ssize_t update_region_dpa_mode(struct cxl_region *cxlr,
>> +		struct cxl_decoder *cxld)
>> +{
>> +	int rc;
>> +	struct cxl_endpoint_decoder *cxled =
>> +		to_cxl_endpoint_decoder(&cxld->dev);
>Maybe don't bother with local variable and just put this
>below as the parameter.

Sure, I will fix it.

>> +
>> +	rc = cxl_dpa_set_mode(cxled, CXL_DECODER_PMEM);
>
>return cxl_dpa_set_mode()
>
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
>No blank line here

Sure, I will fix it.

>> +	if (rc < 0)
>Can it ever be > 0 ?
>If not, return attach_target() should be fine.

Yes we can directly return from here, will fix it in V1

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
>
>Maybe look at Dan's new ACQUIRE() series. The last patch in there
>is targeting code similar to this.

Sure, Let me look at Dan's new ACQUIRE() series. I will update it in V1

>
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
>With AQUIRE() stuff you can just  do
>	if (rc)
>		return rc;
>
>here
>

Thanks, Will update it accordingly.

>> +		p->state = CXL_CONFIG_COMMIT;
>> +out:
>> +	up_write(&cxl_region_rwsem);
>> +	if (rc)
>> +		return rc;
>> +	return 0;
>> +}
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
>
>For a check like this, add a comment on why it might be NULL.
>If it can't be, then drop the check.
>

Sure, I will fix it in V1

>> +
>> +	port = to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);
>
>Maybe add a comment on which port this actually is.  These long indirections
>can make that hard to figure out!
>

Sure, I will fix it in V1

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
>> +
>> +	p = &cxlr->params;
>> +	p->uuid = params->uuid;
>> +	p->interleave_ways = params->nlabel;
>> +	p->interleave_granularity = params->ig;
>> +
>> +	/* Update region size */
>> +	if (update_region_size(cxlr, params->rawsize))
>> +		goto err;
>> +
>> +	/* Flush cxl wq */
>
>Much more useful to say 'why' you are flushing it.  It's obvious
>from the code that you are.
>

Sure Will update the comment properly

>> +	cxl_wq_flush();
>> +
>> +	/* Clear DPA Size */
>
>I'd look at all these comments and where they are obvious, drop the comment
>and let the code speak for itself.
>

Sure, Will update accordingly

>> +	if (update_region_dpa_size(cxlr, cxld, 0))
>> +		goto err;
>> +
>> +	/* Update DPA mode */
>> +	if (update_region_dpa_mode(cxlr, cxld))
>> +		goto err;
>> +
>> +	/* Update DPA Size */
>> +	if (update_region_dpa_size(cxlr, cxld, params->rawsize))
>> +		goto err;
>> +
>> +	/* Attach region targets */
>It's attaching just one by the look of it.  I'd just drop the comment.
>

Sure, Will update accordingly

>> +	if (attach_region_target(cxlr, cxld, params->position))
>> +		goto err;
>> +
>> +	/* Commit Region */
>> +	if (commit_region(cxlr))
>> +		goto err;
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
>I'm a little surprised not to see cleanup of the memregion via
>devm somewhere here.

Actually its cleanup is happening at cxl_region_release().
During cxl_region_alloc, cxlr is allocated whose dev->type is
cxl_region_type

  const struct device_type cxl_region_type = {
	.name = "cxl_region",
	.release = cxl_region_release,
	.groups = region_groups
  };

>> +
>> +	return devm_cxl_pmem_add_region(cxlrd, cxld, params, id,
>> +			CXL_DECODER_PMEM, CXL_DECODER_HOSTONLYMEM);
>> +}
>> +EXPORT_SYMBOL_NS_GPL(cxl_create_pmem_region, "CXL");
>> +
>>  static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
>>  					  enum cxl_decoder_mode mode, int id)
>>  {
>
>

------K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_cd910_
Content-Type: text/plain; charset="utf-8"


------K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_cd910_--

