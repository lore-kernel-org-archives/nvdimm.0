Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB482582
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 10:43:38 +0000 (UTC)
Received: from frapeml100003.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4N7wHC24DZz67DYv;
	Fri, 11 Nov 2022 18:41:27 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 frapeml100003.china.huawei.com (7.182.85.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 11:43:36 +0100
Received: from localhost (10.45.151.252) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 11 Nov
 2022 10:43:35 +0000
Date: Fri, 11 Nov 2022 10:43:34 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH v3 17/18] libnvdimm: Introduce
 CONFIG_NVDIMM_SECURITY_TEST flag
Message-ID: <20221111104334.00003fcf@Huawei.com>
In-Reply-To: <166792842000.3767969.18296572896453551207.stgit@djiang5-desk3.ch.intel.com>
References: <166792815961.3767969.2621677491424623673.stgit@djiang5-desk3.ch.intel.com>
	<166792842000.3767969.18296572896453551207.stgit@djiang5-desk3.ch.intel.com>
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
X-Originating-IP: [10.45.151.252]
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Tue, 08 Nov 2022 10:27:00 -0700
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
Trivial comment inline you may want to address.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/nvdimm/Kconfig           |   13 +++++++++++++
>  drivers/nvdimm/dimm_devs.c       |    9 ++++++++-
>  drivers/nvdimm/security.c        |    4 ++++
>  tools/testing/nvdimm/Kbuild      |    1 -
>  tools/testing/nvdimm/dimm_devs.c |   30 ------------------------------
>  5 files changed, 25 insertions(+), 32 deletions(-)
>  delete mode 100644 tools/testing/nvdimm/dimm_devs.c
> 
> diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
> index 5a29046e3319..0a13c53c926f 100644
> --- a/drivers/nvdimm/Kconfig
> +++ b/drivers/nvdimm/Kconfig
> @@ -114,4 +114,17 @@ config NVDIMM_TEST_BUILD
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
> +	  Accidentally selecting this option when not using cxl_test
I'd drop the "Accidentally"

Selecting this option when ...

> +	  introduces 1 mailbox request to the CXL device to get security
> +	  status for DIMM unlock operation or sysfs attribute "security"
> +	  read.
> +
>  endif
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index c7c980577491..1fc081dcf631 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -349,11 +349,18 @@ static ssize_t available_slots_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(available_slots);
>  
> -__weak ssize_t security_show(struct device *dev,
> +ssize_t security_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
>  	struct nvdimm *nvdimm = to_nvdimm(dev);
>  
> +	/*
> +	 * For the test version we need to poll the "hardware" in order
> +	 * to get the updated status for unlock testing.
> +	 */
> +	if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST))
> +		nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
> +
>  	if (test_bit(NVDIMM_SECURITY_OVERWRITE, &nvdimm->sec.flags))
>  		return sprintf(buf, "overwrite\n");
>  	if (test_bit(NVDIMM_SECURITY_DISABLED, &nvdimm->sec.flags))
> diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
> index 92af4c3ca0d3..12a3926f4289 100644
> --- a/drivers/nvdimm/security.c
> +++ b/drivers/nvdimm/security.c
> @@ -177,6 +177,10 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
>  			|| !nvdimm->sec.flags)
>  		return -EIO;
>  
> +	/* While nfit_test does not need this, cxl_test does */
> +	if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST))
> +		nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
> +
>  	/* No need to go further if security is disabled */
>  	if (test_bit(NVDIMM_SECURITY_DISABLED, &nvdimm->sec.flags))
>  		return 0;
> diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
> index 5eb5c23b062f..8153251ea389 100644
> --- a/tools/testing/nvdimm/Kbuild
> +++ b/tools/testing/nvdimm/Kbuild
> @@ -79,7 +79,6 @@ libnvdimm-$(CONFIG_BTT) += $(NVDIMM_SRC)/btt_devs.o
>  libnvdimm-$(CONFIG_NVDIMM_PFN) += $(NVDIMM_SRC)/pfn_devs.o
>  libnvdimm-$(CONFIG_NVDIMM_DAX) += $(NVDIMM_SRC)/dax_devs.o
>  libnvdimm-$(CONFIG_NVDIMM_KEYS) += $(NVDIMM_SRC)/security.o
> -libnvdimm-y += dimm_devs.o
>  libnvdimm-y += libnvdimm_test.o
>  libnvdimm-y += config_check.o
>  
> diff --git a/tools/testing/nvdimm/dimm_devs.c b/tools/testing/nvdimm/dimm_devs.c
> deleted file mode 100644
> index 57bd27dedf1f..000000000000
> --- a/tools/testing/nvdimm/dimm_devs.c
> +++ /dev/null
> @@ -1,30 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/* Copyright Intel Corp. 2018 */
> -#include <linux/init.h>
> -#include <linux/module.h>
> -#include <linux/moduleparam.h>
> -#include <linux/nd.h>
> -#include "pmem.h"
> -#include "pfn.h"
> -#include "nd.h"
> -#include "nd-core.h"
> -
> -ssize_t security_show(struct device *dev,
> -		struct device_attribute *attr, char *buf)
> -{
> -	struct nvdimm *nvdimm = to_nvdimm(dev);
> -
> -	/*
> -	 * For the test version we need to poll the "hardware" in order
> -	 * to get the updated status for unlock testing.
> -	 */
> -	nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
> -
> -	if (test_bit(NVDIMM_SECURITY_DISABLED, &nvdimm->sec.flags))
> -		return sprintf(buf, "disabled\n");
> -	if (test_bit(NVDIMM_SECURITY_UNLOCKED, &nvdimm->sec.flags))
> -		return sprintf(buf, "unlocked\n");
> -	if (test_bit(NVDIMM_SECURITY_LOCKED, &nvdimm->sec.flags))
> -		return sprintf(buf, "locked\n");
> -	return -ENOTTY;
> -}
> 
> 

