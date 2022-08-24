Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1011110
	for <nvdimm@lists.linux.dev>; Wed, 24 Aug 2022 09:37:31 +0000 (UTC)
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MCLbX4bDNz67yqK;
	Wed, 24 Aug 2022 17:37:12 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 24 Aug 2022 11:37:28 +0200
Received: from localhost (10.202.226.42) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 24 Aug
 2022 10:37:28 +0100
Date: Wed, 24 Aug 2022 10:37:27 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Vishal Verma <vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>, Dan Williams
	<dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH v2 0/3] cxl: static analysis fixes
Message-ID: <20220824103727.0000282e@huawei.com>
In-Reply-To: <20220823074527.404435-1-vishal.l.verma@intel.com>
References: <20220823074527.404435-1-vishal.l.verma@intel.com>
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
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Tue, 23 Aug 2022 01:45:24 -0600
Vishal Verma <vishal.l.verma@intel.com> wrote:

> Changes since v1[1]:
> - Fix the decoder filter check in patch 1.
> - Fix a missed free(path) in patch 2.
> 
> [1]: https://lore.kernel.org/linux-cxl/20220823072106.398076-1-vishal.l.verma@intel.com
FWIW: Series looks fine to me.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> ---
> 
> Fix a small handful of issues reported by scan.coverity.com for the
> recent region management additions.
> 
> Vishal Verma (3):
>   cxl/region: fix a dereferecnce after NULL check
>   libcxl: fox a resource leak and a forward NULL check
>   cxl/filter: Fix an uninitialized pointer dereference
> 
>  cxl/lib/libcxl.c | 4 +++-
>  cxl/filter.c     | 2 +-
>  cxl/region.c     | 5 ++---
>  3 files changed, 6 insertions(+), 5 deletions(-)
> 
> 
> base-commit: 9a993ce24fdd5de45774b65211570dd514cdf61d

