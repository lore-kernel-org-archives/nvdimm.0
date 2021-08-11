Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6290B17F
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 17:45:03 +0000 (UTC)
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GlGw55Hr3z6GBj4;
	Thu, 12 Aug 2021 01:27:01 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 11 Aug 2021 19:27:37 +0200
Received: from localhost (10.52.123.85) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 11 Aug
 2021 18:27:36 +0100
Date: Wed, 11 Aug 2021 18:27:06 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<ben.widawsky@intel.com>, <vishal.l.verma@intel.com>,
	<alison.schofield@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH 03/23] libnvdimm/labels: Introduce label setter helpers
Message-ID: <20210811182706.00003bee@Huawei.com>
In-Reply-To: <162854808363.1980150.11628345983283480967.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162854808363.1980150.11628345983283480967.stgit@dwillia2-desk3.amr.corp.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.123.85]
X-ClientProxiedBy: lhreml716-chm.china.huawei.com (10.201.108.67) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Mon, 9 Aug 2021 15:28:03 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> In preparation for LIBNVDIMM to manage labels on CXL devices deploy
> helpers that abstract the label type from the implementation. The CXL
> label format is mostly similar to the EFI label format with concepts /
> fields added, like dynamic region creation and label type guids, and
> other concepts removed like BLK-mode and interleave-set-cookie ids.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Hi Dan,

Only thing on this patch is whether it might be better to put get /set pairs
together rather than all the get functions, then all the set functions?

If looking at this code in future it would make it a little easier to quickly
see they are match pairs.

Your code though, so if you prefer it like this, I don't really care!

Fine either way with me.
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/nvdimm/label.c          |   61 +++++++++++++++++------------------
>  drivers/nvdimm/namespace_devs.c |    2 +
>  drivers/nvdimm/nd.h             |   68 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 98 insertions(+), 33 deletions(-)
> 

...
  
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index b3feaf3699f7..416846fe7818 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -47,6 +47,14 @@ static inline u8 *nsl_get_name(struct nvdimm_drvdata *ndd,
>  	return memcpy(name, nd_label->name, NSLABEL_NAME_LEN);
>  }
>  
> +static inline u8 *nsl_set_name(struct nvdimm_drvdata *ndd,
> +			       struct nd_namespace_label *nd_label, u8 *name)
> +{
> +	if (!name)
> +		return name;

Nitpick: Obviously same thing, but my eyes parse 
		return NULL;

more easily as a clear "error" return.

> +	return memcpy(nd_label->name, name, NSLABEL_NAME_LEN);
> +}
> +
...
