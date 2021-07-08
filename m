Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1866168
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 13:11:30 +0000 (UTC)
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GLGn43RmPzbbZ4;
	Thu,  8 Jul 2021 21:08:08 +0800 (CST)
Received: from [10.174.179.57] (10.174.179.57) by
 dggeme755-chm.china.huawei.com (10.3.19.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 8 Jul 2021 21:11:20 +0800
Subject: Re: [PATCH v2] libnvdimm, badrange: replace div_u64_rem with
 DIV_ROUND_UP
From: Kemeng Shi <shikemeng@huawei.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
References: <194fed48-eaf3-065f-9571-7813ad35b098@huawei.com>
Message-ID: <8ebb412c-7978-5222-746e-1e35ff518275@huawei.com>
Date: Thu, 8 Jul 2021 21:11:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <194fed48-eaf3-065f-9571-7813ad35b098@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.57]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected


A gentle ping

on 2021/6/26 11:53, Kemeng Shi wrote:
> __add_badblock_range use div_u64_rem to round up end_sector and it
> will introduces unnecessary rem define and costly '%' operation.
> So clean it with DIV_ROUND_UP.
> 
> Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
> ---
> V1->V2:
> -- fix that end_sector is assigned twice, sorry for that.
> 
>  drivers/nvdimm/badrange.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/nvdimm/badrange.c b/drivers/nvdimm/badrange.c
> index aaf6e215a8c6..af622ae511aa 100644
> --- a/drivers/nvdimm/badrange.c
> +++ b/drivers/nvdimm/badrange.c
> @@ -187,12 +187,9 @@ static void __add_badblock_range(struct badblocks *bb, u64 ns_offset, u64 len)
>  	const unsigned int sector_size = 512;
>  	sector_t start_sector, end_sector;
>  	u64 num_sectors;
> -	u32 rem;
> 
>  	start_sector = div_u64(ns_offset, sector_size);
> -	end_sector = div_u64_rem(ns_offset + len, sector_size, &rem);
> -	if (rem)
> -		end_sector++;
> +	end_sector = DIV_ROUND_UP(ns_offset + len, sector_size);
>  	num_sectors = end_sector - start_sector;
> 
>  	if (unlikely(num_sectors > (u64)INT_MAX)) {
> 

-- 
Best wishes
Kemeng Shi
