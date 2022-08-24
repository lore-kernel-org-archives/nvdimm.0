Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7AF1110
	for <nvdimm@lists.linux.dev>; Wed, 24 Aug 2022 09:50:28 +0000 (UTC)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MCLRt0kFRz683mQ;
	Wed, 24 Aug 2022 17:30:34 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Wed, 24 Aug 2022 11:30:57 +0200
Received: from localhost (10.202.226.42) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 24 Aug
 2022 10:30:57 +0100
Date: Wed, 24 Aug 2022 10:30:55 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Vishal Verma <vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>, Dan Williams
	<dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH v2 1/3] cxl/region: fix a dereferecnce after NULL
 check
Message-ID: <20220824103055.0000056f@huawei.com>
In-Reply-To: <20220823074527.404435-2-vishal.l.verma@intel.com>
References: <20220823074527.404435-1-vishal.l.verma@intel.com>
	<20220823074527.404435-2-vishal.l.verma@intel.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.42]
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Tue, 23 Aug 2022 01:45:25 -0600
Vishal Verma <vishal.l.verma@intel.com> wrote:

> A NULL check in region_action() implies that 'decoder' might be NULL, but
> later we dereference it during cxl_decoder_foreach(). The NULL check is
> valid because it was the filter result being checked, however, while
> doing this, the original 'decoder' variable was being clobbered.
> 
> Check the filter results independently of the original decoder variable.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Typo in patch title.

> ---
>  cxl/region.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index a30313c..334fcc2 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -686,9 +686,8 @@ static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
>  			continue;
>  
>  		cxl_decoder_foreach (port, decoder) {
> -			decoder = util_cxl_decoder_filter(decoder,
> -							  param.root_decoder);
> -			if (!decoder)
> +			if (!util_cxl_decoder_filter(decoder,
> +						     param.root_decoder))
>  				continue;
>  			rc = decoder_region_action(p, decoder, action, count);
>  			if (rc)

