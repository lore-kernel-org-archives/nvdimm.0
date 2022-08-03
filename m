Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6919E1FBB
	for <nvdimm@lists.linux.dev>; Wed,  3 Aug 2022 16:36:24 +0000 (UTC)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LycnD3Bv0z688b3;
	Thu,  4 Aug 2022 00:31:28 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 3 Aug 2022 18:36:21 +0200
Received: from localhost (10.202.226.42) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 3 Aug
 2022 17:36:20 +0100
Date: Wed, 3 Aug 2022 17:36:19 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <bwidawsk@kernel.org>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH RFC 02/15] tools/testing/cxl: Create context for cxl
 mock device
Message-ID: <20220803173619.00002da7@huawei.com>
In-Reply-To: <165791932409.2491387.9065856569307593223.stgit@djiang5-desk3.ch.intel.com>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
	<165791932409.2491387.9065856569307593223.stgit@djiang5-desk3.ch.intel.com>
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
X-ClientProxiedBy: lhreml740-chm.china.huawei.com (10.201.108.190) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Fri, 15 Jul 2022 14:08:44 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Add context struct for mock device and move lsa under the context. This
> allows additional information such as security status and other persistent
> security data such as passphrase to be added for the emulated test device.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  tools/testing/cxl/test/mem.c |   29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> index 6b9239b2afd4..723378248321 100644
> --- a/tools/testing/cxl/test/mem.c
> +++ b/tools/testing/cxl/test/mem.c
> @@ -9,6 +9,10 @@
>  #include <linux/bits.h>
>  #include <cxlmem.h>
>  
> +struct mock_mdev_data {
> +	void *lsa;
> +};
> +
>  #define LSA_SIZE SZ_128K
>  #define EFFECT(x) (1U << x)
>  
> @@ -140,7 +144,8 @@ static int mock_id(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>  static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>  {
>  	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
> -	void *lsa = dev_get_drvdata(cxlds->dev);
> +	struct mock_mdev_data *mdata = dev_get_drvdata(cxlds->dev);
> +	void *lsa = mdata->lsa;
>  	u32 offset, length;
>  
>  	if (sizeof(*get_lsa) > cmd->size_in)
> @@ -159,7 +164,8 @@ static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>  static int mock_set_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>  {
>  	struct cxl_mbox_set_lsa *set_lsa = cmd->payload_in;
> -	void *lsa = dev_get_drvdata(cxlds->dev);
> +	struct mock_mdev_data *mdata = dev_get_drvdata(cxlds->dev);
> +	void *lsa = mdata->lsa;
>  	u32 offset, length;
>  
>  	if (sizeof(*set_lsa) > cmd->size_in)
> @@ -237,9 +243,12 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
>  	return rc;
>  }
>  
> -static void label_area_release(void *lsa)
> +static void cxl_mock_drvdata_release(void *data)
>  {
> -	vfree(lsa);
> +	struct mock_mdev_data *mdata = data;
> +
> +	vfree(mdata->lsa);
> +	vfree(mdata);
>  }
>  
>  static int cxl_mock_mem_probe(struct platform_device *pdev)
> @@ -247,13 +256,21 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
>  	struct device *dev = &pdev->dev;
>  	struct cxl_memdev *cxlmd;
>  	struct cxl_dev_state *cxlds;
> +	struct mock_mdev_data *mdata;
>  	void *lsa;
>  	int rc;
>  
> +	mdata = vmalloc(sizeof(*mdata));

It's tiny so why vmalloc?  I guess that might become apparent later.
devm_kzalloc() should be fine and lead to simpler error handling.

> +	if (!mdata)
> +		return -ENOMEM;
> +
>  	lsa = vmalloc(LSA_SIZE);
> -	if (!lsa)
> +	if (!lsa) {
> +		vfree(mdata);
In general doing this just makes things fragile in the long term. Better to
register one devm_add_action_or_reset() for each thing set up (or standard
allcoation).

>  		return -ENOMEM;
> -	rc = devm_add_action_or_reset(dev, label_area_release, lsa);
> +	}
> +
> +	rc = devm_add_action_or_reset(dev, cxl_mock_drvdata_release, mdata);
>  	if (rc)
>  		return rc;
>  	dev_set_drvdata(dev, lsa);
> 
> 

