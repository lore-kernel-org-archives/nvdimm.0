Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DF2D51D
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 14:55:36 +0000 (UTC)
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4N5Z3y6xJRz685Z9;
	Mon,  7 Nov 2022 22:53:34 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Mon, 7 Nov 2022 15:55:33 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 7 Nov
 2022 14:55:33 +0000
Date: Mon, 7 Nov 2022 14:55:32 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <bwidawsk@kernel.org>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH v2 10/19] cxl/pmem: Add "Unlock" security command
 support
Message-ID: <20221107145532.000034e9@Huawei.com>
In-Reply-To: <166377434821.430546.18100037354899710663.stgit@djiang5-desk3.ch.intel.com>
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
	<166377434821.430546.18100037354899710663.stgit@djiang5-desk3.ch.intel.com>
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
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Wed, 21 Sep 2022 08:32:28 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Create callback function to support the nvdimm_security_ops() ->unlock()
> callback. Translate the operation to send "Unlock" security command for CXL
> mem device.
> 
> When the mem device is unlocked, arch_invalidate_nvdimm_cache() is called
> in order to invalidate all CPU caches before attempting to access the mem
> device.
> 
> See CXL 2.0 spec section 8.2.9.5.6.4 for reference.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

LGTM

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


