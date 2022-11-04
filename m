Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E48C1856
	for <nvdimm@lists.linux.dev>; Fri,  4 Nov 2022 12:47:12 +0000 (UTC)
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4N3fx85Qy0z67gR6;
	Fri,  4 Nov 2022 20:26:04 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 4 Nov 2022 13:28:12 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 4 Nov
 2022 12:28:11 +0000
Date: Fri, 4 Nov 2022 12:28:10 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <bwidawsk@kernel.org>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH v2 03/19] tools/testing/cxl: Add "Get Security State"
 opcode support
Message-ID: <20221104122810.0000092c@Huawei.com>
In-Reply-To: <166377430503.430546.4463791056925632016.stgit@djiang5-desk3.ch.intel.com>
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
	<166377430503.430546.4463791056925632016.stgit@djiang5-desk3.ch.intel.com>
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
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Wed, 21 Sep 2022 08:31:45 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Add the emulation support for handling "Get Security State" opcode for a
> CXL memory device for the cxl_test. The function will copy back device
> security state bitmask to the output payload.
> 
> The security state data is added as platform_data for the mock mem device.
> 
> Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
FWIW LGTM

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  tools/testing/cxl/test/cxl.c       |   18 ++++++++++++++++++
>  tools/testing/cxl/test/mem.c       |   20 ++++++++++++++++++++
>  tools/testing/cxl/test/mem_pdata.h |   10 ++++++++++
>  3 files changed, 48 insertions(+)
>  create mode 100644 tools/testing/cxl/test/mem_pdata.h
> 
> diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
> index a072b2d3e726..6dd286a52839 100644
> --- a/tools/testing/cxl/test/cxl.c
> +++ b/tools/testing/cxl/test/cxl.c
> @@ -10,6 +10,7 @@
>  #include <linux/mm.h>
>  #include <cxlmem.h>
>  #include "mock.h"
> +#include "mem_pdata.h"
>  
>  #define NR_CXL_HOST_BRIDGES 2
>  #define NR_CXL_ROOT_PORTS 2
> @@ -629,8 +630,18 @@ static void mock_companion(struct acpi_device *adev, struct device *dev)
>  
>  static __init int cxl_test_init(void)
>  {
> +	struct cxl_mock_mem_pdata *mem_pdata;
>  	int rc, i;
>  
> +	/*
> +	 * Only a zeroed copy of this data structure is needed since no
> +	 * additional initialization is needed for initial state.
> +	 * platform_device_add_data() will make a copy of this data.
> +	 */
> +	mem_pdata = kzalloc(sizeof(*mem_pdata), GFP_KERNEL);
> +	if (!mem_pdata)
> +		return -ENOMEM;
> +
>  	register_cxl_mock_ops(&cxl_mock_ops);
>  
>  	cxl_mock_pool = gen_pool_create(ilog2(SZ_2M), NUMA_NO_NODE);
> @@ -735,6 +746,12 @@ static __init int cxl_test_init(void)
>  		pdev->dev.parent = &dport->dev;
>  		set_dev_node(&pdev->dev, i % 2);
>  
> +		rc = platform_device_add_data(pdev, mem_pdata, sizeof(*mem_pdata));
> +		if (rc) {
> +			platform_device_put(pdev);
> +			goto err_mem;
> +		}
> +
>  		rc = platform_device_add(pdev);
>  		if (rc) {
>  			platform_device_put(pdev);
> @@ -785,6 +802,7 @@ static __init int cxl_test_init(void)
>  	gen_pool_destroy(cxl_mock_pool);
>  err_gen_pool_create:
>  	unregister_cxl_mock_ops(&cxl_mock_ops);
> +	kfree(mem_pdata);
>  	return rc;
>  }
>  
> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> index aa2df3a15051..9002a3ae3ea5 100644
> --- a/tools/testing/cxl/test/mem.c
> +++ b/tools/testing/cxl/test/mem.c
> @@ -8,6 +8,7 @@
>  #include <linux/sizes.h>
>  #include <linux/bits.h>
>  #include <cxlmem.h>
> +#include "mem_pdata.h"
>  
>  #define LSA_SIZE SZ_128K
>  #define DEV_SIZE SZ_2G
> @@ -137,6 +138,22 @@ static int mock_partition_info(struct cxl_dev_state *cxlds,
>  	return 0;
>  }
>  
> +static int mock_get_security_state(struct cxl_dev_state *cxlds,
> +				   struct cxl_mbox_cmd *cmd)
> +{
> +	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(cxlds->dev);
> +
> +	if (cmd->size_in)
> +		return -EINVAL;
> +
> +	if (cmd->size_out != sizeof(u32))
> +		return -EINVAL;
> +
> +	memcpy(cmd->payload_out, &mdata->security_state, sizeof(u32));
> +
> +	return 0;
> +}
> +
>  static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>  {
>  	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
> @@ -230,6 +247,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
>  	case CXL_MBOX_OP_GET_HEALTH_INFO:
>  		rc = mock_health_info(cxlds, cmd);
>  		break;
> +	case CXL_MBOX_OP_GET_SECURITY_STATE:
> +		rc = mock_get_security_state(cxlds, cmd);
> +		break;
>  	default:
>  		break;
>  	}
> diff --git a/tools/testing/cxl/test/mem_pdata.h b/tools/testing/cxl/test/mem_pdata.h
> new file mode 100644
> index 000000000000..6a7b111147eb
> --- /dev/null
> +++ b/tools/testing/cxl/test/mem_pdata.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _MEM_PDATA_H_
> +#define _MEM_PDATA_H_
> +
> +struct cxl_mock_mem_pdata {
> +	u32 security_state;
> +};
> +
> +#endif
> 
> 

