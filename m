Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473C2D531
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 16:01:28 +0000 (UTC)
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4N5bWy6kDpz67njv;
	Mon,  7 Nov 2022 23:59:26 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:01:25 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 7 Nov
 2022 16:01:25 +0000
Date: Mon, 7 Nov 2022 16:01:24 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <bwidawsk@kernel.org>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH v2 18/19] libnvdimm: Introduce
 CONFIG_NVDIMM_SECURITY_TEST flag
Message-ID: <20221107160124.00005223@Huawei.com>
In-Reply-To: <166377439534.430546.10690686781480251163.stgit@djiang5-desk3.ch.intel.com>
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
	<166377439534.430546.10690686781480251163.stgit@djiang5-desk3.ch.intel.com>
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
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Wed, 21 Sep 2022 08:33:15 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> nfit_test overrode the security_show() sysfs attribute function in nvdimm
> dimm_devs in order to allow testing of security unlock. With the
> introduction of CXL security commands, the trick to override
> security_show() becomes significantly more complicated. By introdcing a
> security flag CONFIG_NVDIMM_SECURITY_TEST, libnvdimm can just toggle the
> check via a compile option. In addition the original override can can be
> removed from tools/testing/nvdimm/.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/Kconfig           |    9 +++++++++
>  drivers/nvdimm/dimm_devs.c       |    9 ++++++++-
>  drivers/nvdimm/security.c        |    4 ++++
>  tools/testing/nvdimm/Kbuild      |    1 -
>  tools/testing/nvdimm/dimm_devs.c |   30 ------------------------------
>  5 files changed, 21 insertions(+), 32 deletions(-)
>  delete mode 100644 tools/testing/nvdimm/dimm_devs.c
> 
> diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
> index 5a29046e3319..fd336d138eda 100644
> --- a/drivers/nvdimm/Kconfig
> +++ b/drivers/nvdimm/Kconfig
> @@ -114,4 +114,13 @@ config NVDIMM_TEST_BUILD
>  	  core devm_memremap_pages() implementation and other
>  	  infrastructure.
>  
> +config NVDIMM_SECURITY_TEST
> +	bool "Nvdimm security test code toggle"
> +	depends on NVDIMM_KEYS
> +	help
> +	  Debug flag for security testing when using nfit_test or cxl_test
> +	  modules in tools/testing/.
> +
> +	  Select Y if using nfit_test or cxl_test for security testing.

Probably want to say it if has any unfortunate side effects when not doing
such testing.  Distros will want guidance on whether to enable.

Jonathan

> +

