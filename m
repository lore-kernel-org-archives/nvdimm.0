Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C0E247299
	for <nvdimm@lists.linux.dev>; Mon, 14 Apr 2025 15:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744644561; cv=none; b=I62e2lde+3tZeRzT99CSSY4/36EPTSib/vhVtMW5YlRfcBY7Uatm+4eyHxmD+Mw756iNI+B88XGOMAK2J1V9kbugCyRf2Nv8oJl0d1UZh5Xv8+lqtKrYKIqTlI4ysdZWDlRWy20jDqw+j3ZMYrOGeFMkV/jTkWZn6yTAXi9XZQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744644561; c=relaxed/simple;
	bh=QZSysy87dYHtOp1kIeVLsXQQyhnG6n15AfE/rji7EWU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U+B2uwWg53hKhdonqWTuVucPw2WHRQvB35GKgnRAmseJ0PMWjYU5tKYC8Oop2PMY1jJK2HoDBwydpSe1bjC4M9brb65VVOTtU2JmUVQ8QKQ8opcIeYpO9RNKQNAmwjSPJIjS1AoHGdTMGbASn99lrrQ6XhuT08OpsMwQPAPRPK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Zbrh36Dw5z6K9XS;
	Mon, 14 Apr 2025 23:25:07 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id B32DC1401DC;
	Mon, 14 Apr 2025 23:29:16 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 14 Apr
 2025 17:29:16 +0200
Date: Mon, 14 Apr 2025 16:29:14 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Dan
 Williams" <dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 03/19] cxl/cdat: Gather DSMAS data for DCD partitions
Message-ID: <20250414162914.00006bb7@huawei.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-3-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
	<20250413-dcd-type2-upstream-v9-3-1d4911a0b365@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Sun, 13 Apr 2025 17:52:11 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

> Additional DCD partition (AKA region) information is contained in the
> DSMAS CDAT tables, including performance, read only, and shareable
> attributes.
> 
> Match DCD partitions with DSMAS tables and store the meta data.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 866a423d6125..c589d8a330bb 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1321,6 +1321,7 @@ static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_a
>  	part_array[index].start = le64_to_cpu(dev_part->base);
>  	part_array[index].size = le64_to_cpu(dev_part->decode_length);
>  	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;
> +	part_array[index].handle = le32_to_cpu(dev_part->dsmad_handle) & 0xFF;

Perhaps a comment on this.  Or a check that it is representable in
CDAT (where we only have the one byte) and a print + fail to carry on if not?

>  	len = le64_to_cpu(dev_part->length);
>  	blk_size = le64_to_cpu(dev_part->block_size);
>  
> @@ -1453,6 +1454,7 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
>  	/* Return 1st partition */
>  	dc_info->start = partitions[0].start;
>  	dc_info->size = partitions[0].size;
> +	dc_info->handle = partitions[0].handle;
>  	dev_dbg(dev, "Returning partition 0 %zu size %zu\n",
>  		dc_info->start, dc_info->size);
>  
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 057933128d2c..96d8edaa5003 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -104,6 +104,7 @@ struct cxl_dpa_info {
>  	struct cxl_dpa_part_info {
>  		struct range range;
>  		enum cxl_partition_mode mode;
> +		u8 handle;
>  	} part[CXL_NR_PARTITIONS_MAX];
>  	int nr_partitions;
>  };
> @@ -387,12 +388,14 @@ enum cxl_devtype {
>   * @coord: QoS performance data (i.e. latency, bandwidth)
>   * @cdat_coord: raw QoS performance data from CDAT
>   * @qos_class: QoS Class cookies
> + * @shareable: Is the range sharable
>   */
>  struct cxl_dpa_perf {
>  	struct range dpa_range;
>  	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
>  	struct access_coordinate cdat_coord[ACCESS_COORDINATE_MAX];
>  	int qos_class;
> +	bool shareable;

It feels a bit odd to have this in the dpa_perf structure as not really
a performance thing but I guess this is only convenient place to stash it.

>  };
>  
>  /**
> @@ -400,11 +403,13 @@ struct cxl_dpa_perf {
>   * @res: shortcut to the partition in the DPA resource tree (cxlds->dpa_res)
>   * @perf: performance attributes of the partition from CDAT
>   * @mode: operation mode for the DPA capacity, e.g. ram, pmem, dynamic...
> + * @handle: DMASS handle intended to represent this partition

DSMAS ?


>   */
>  struct cxl_dpa_partition {
>  	struct resource res;
>  	struct cxl_dpa_perf perf;
>  	enum cxl_partition_mode mode;
> +	u8 handle;
>  };
>  
>  /**
> @@ -881,6 +886,7 @@ struct cxl_mem_dev_info {
>  struct cxl_dc_partition_info {
>  	size_t start;
>  	size_t size;
> +	u8 handle;
>  };
>  
>  int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> 

