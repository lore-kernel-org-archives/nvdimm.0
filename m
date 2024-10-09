Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771F9194096
	for <nvdimm@lists.linux.dev>; Wed,  9 Oct 2024 12:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728477732; cv=none; b=rVQuAwbGxsKZlaZ2c/IiS11AsSjKBlEjCL26WYdurR9GYNsP57Y45OWb88MRKn9pkQNuWEcp71OnYu/dKfEpWk2+HJA0ST0XxWYTq58Tu/apDE6CsnFkfbKz5hvSHaBae9C9Zs+0wCgFZxqnQAgLuKpn4y4VgSkGkC2lp0F+0b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728477732; c=relaxed/simple;
	bh=FBeCe84ePWum+frqJl3ahOPHsMe4Ua2FWQMYnIXwT+Q=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Am7H/fX052fPKHQuT+PI7vlJVeLMDCpNkeJGDXkmVLjHy+ufTrrqajUE1rQUtsGrq3ysQank+Ytf17ojTuB4YM4Lj2KeJiImRl+pHNDe1Dwqsy0GRLNGuETDdYKh88PzoQtWJ5JDeJGOz0PEiVSdzJCLSQ1Wjx7nEl00PMsu3+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XNstm1QhBz6K70v;
	Wed,  9 Oct 2024 20:40:48 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id D819D140133;
	Wed,  9 Oct 2024 20:42:05 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 9 Oct
 2024 14:42:03 +0200
Date: Wed, 9 Oct 2024 13:42:01 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, "Alison Schofield"
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-btrfs@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 05/28] dax: Document dax dev range tuple
Message-ID: <20241009134201.000011b4@Huawei.com>
In-Reply-To: <20241007-dcd-type2-upstream-v4-5-c261ee6eeded@intel.com>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
	<20241007-dcd-type2-upstream-v4-5-c261ee6eeded@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Mon, 07 Oct 2024 18:16:11 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

> The device DAX structure is being enhanced to track additional DCD
> information.
> 
> The current range tuple was not fully documented.  Document it prior to
> adding information for DC.
> 
> Suggested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
Isn't this a nested struct?
https://docs.kernel.org/doc-guide/kernel-doc.html#nested-structs-unions

I'm not quite sure how we document when it's a nested pointer to a
a structure.  Is it the same as for a 'normal' nested struct?
  
> ---
> Changes:
> [iweiny: move to start of series]
> ---
>  drivers/dax/dax-private.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index 446617b73aea..ccde98c3d4e2 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -58,7 +58,10 @@ struct dax_mapping {
>   * @dev - device core
>   * @pgmap - pgmap for memmap setup / lifetime (driver owned)
>   * @nr_range: size of @ranges
> - * @ranges: resource-span + pgoff tuples for the instance
> + * @ranges: range tuples of memory used
> + * @pgoff: page offset
      @ranges.pgoff?
etc

> + * @range: resource-span
> + * @mapping: device to assist in interrogating the range layout
>   */
>  struct dev_dax {
>  	struct dax_region *region;
> 

