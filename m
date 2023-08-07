Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9CE10781
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 13:02:15 +0000 (UTC)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RKGYg3hbGz6HJf4;
	Mon,  7 Aug 2023 20:57:11 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 7 Aug
 2023 14:02:07 +0100
Date: Mon, 7 Aug 2023 14:02:06 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Jehoon Park <jehoon.park@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "Kyungsan
 Kim" <ks0204.kim@samsung.com>, Junhyeok Im <junhyeok.im@samsung.com>
Subject: Re: [ndctl PATCH v2 1/3] libcxl: Update a revision by CXL 3.0
 specification
Message-ID: <20230807140206.00006232@Huawei.com>
In-Reply-To: <20230807063549.5942-2-jehoon.park@samsung.com>
References: <20230807063549.5942-1-jehoon.park@samsung.com>
	<CGME20230807063523epcas2p45f74891b764d920b2a9bd22ddf6b6998@epcas2p4.samsung.com>
	<20230807063549.5942-2-jehoon.park@samsung.com>
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
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Mon,  7 Aug 2023 15:35:47 +0900
Jehoon Park <jehoon.park@samsung.com> wrote:

> Update the predefined value for device temperature field when it is not
> implemented. (CXL 3.0.8.2.9.8.3.1)
> 
> Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
Hi Jehoon,

Key here is not that it was in 3.0, but that it was changed in 2.0 Errata F38
and as such software doesn't need to cope with the old (wrong) value.

Good to state that clearly in the patch description.  If it had been merely
a change for 3.0 there would have needed to be an enable bit to change the
default behavior (or something like that).

Otherwise LGTM
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  cxl/lib/private.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index a641727..a692fd5 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -360,7 +360,7 @@ struct cxl_cmd_set_partition {
>  #define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_PERSISTENT_WARNING		(1)
>  
>  #define CXL_CMD_HEALTH_INFO_LIFE_USED_NOT_IMPL				0xff
> -#define CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL			0xffff
> +#define CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL			0x7fff
>  
>  static inline int check_kmod(struct kmod_ctx *kmod_ctx)
>  {

