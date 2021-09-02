Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD3F72
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 18:09:43 +0000 (UTC)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H0pnK5YKRz67Tpc;
	Fri,  3 Sep 2021 02:08:05 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Thu, 2 Sep 2021 20:09:40 +0200
Received: from localhost (10.52.127.69) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 2 Sep 2021
 19:09:40 +0100
Date: Thu, 2 Sep 2021 19:09:41 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<nvdimm@lists.linux.dev>, <ira.weiny@intel.com>
Subject: Re: [PATCH v3 20/28] cxl/mbox: Add exclusive kernel command support
Message-ID: <20210902190941.0000590f@Huawei.com>
In-Reply-To: <162982123298.1124374.22718002900700392.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162982123298.1124374.22718002900700392.stgit@dwillia2-desk3.amr.corp.intel.com>
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
X-Originating-IP: [10.52.127.69]
X-ClientProxiedBy: lhreml715-chm.china.huawei.com (10.201.108.66) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Tue, 24 Aug 2021 09:07:13 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> The CXL_PMEM driver expects exclusive control of the label storage area
> space. Similar to the LIBNVDIMM expectation that the label storage area
> is only writable from userspace when the corresponding memory device is
> not active in any region, the expectation is the native CXL_PCI UAPI
> path is disabled while the cxl_nvdimm for a given cxl_memdev device is
> active in LIBNVDIMM.
> 
> Add the ability to toggle the availability of a given command for the
> UAPI path. Use that new capability to shutdown changes to partitions and
> the label storage area while the cxl_nvdimm device is actively proxying
> commands for LIBNVDIMM.
> 
> Acked-by: Ben Widawsky <ben.widawsky@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/core/mbox.c   |    5 +++++
>  drivers/cxl/core/memdev.c |   31 +++++++++++++++++++++++++++++++
>  drivers/cxl/cxlmem.h      |    4 ++++
>  drivers/cxl/pmem.c        |   35 ++++++++++++++++++++++++++++-------
>  4 files changed, 68 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 73107b302224..6a5c4f3679ba 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -230,6 +230,7 @@ static bool cxl_mem_raw_command_allowed(u16 opcode)
>   *  * %-EINVAL	- Reserved fields or invalid values were used.
>   *  * %-ENOMEM	- Input or output buffer wasn't sized properly.
>   *  * %-EPERM	- Attempted to use a protected command.
> + *  * %-EBUSY	- Kernel has claimed exclusive access to this opcode
>   *
>   * The result of this command is a fully validated command in @out_cmd that is
>   * safe to send to the hardware.
> @@ -305,6 +306,10 @@ static int cxl_validate_cmd_from_user(struct cxl_mem *cxlm,
>  	if (!test_bit(info->id, cxlm->enabled_cmds))
>  		return -ENOTTY;
>  
> +	/* Check that the command is not claimed for exclusive kernel use */
> +	if (test_bit(info->id, cxlm->exclusive_cmds))
> +		return -EBUSY;
> +
>  	/* Check the input buffer is the expected size */
>  	if (info->size_in >= 0 && info->size_in != send_cmd->in.size)
>  		return -ENOMEM;


>  #endif /* __CXL_MEM_H__ */
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index 9652c3ee41e7..469b984176a2 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -16,9 +16,21 @@
>   */
>  static struct workqueue_struct *cxl_pmem_wq;
>  
> -static void unregister_nvdimm(void *nvdimm)
> +static __read_mostly DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
> +
> +static void unregister_nvdimm(void *_cxl_nvd)
>  {
> -	nvdimm_delete(nvdimm);
> +	struct cxl_nvdimm *cxl_nvd = _cxl_nvd;
> +	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> +	struct cxl_mem *cxlm = cxlmd->cxlm;
> +	struct device *dev = &cxl_nvd->dev;
> +	struct nvdimm *nvdimm;
> +
> +	nvdimm = dev_get_drvdata(dev);
> +	if (nvdimm)
> +		nvdimm_delete(nvdimm);
> +
> +	clear_exclusive_cxl_commands(cxlm, exclusive_cmds);
>  }
>  
>  static int match_nvdimm_bridge(struct device *dev, const void *data)
> @@ -39,9 +51,11 @@ static struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void)
>  static int cxl_nvdimm_probe(struct device *dev)
>  {
>  	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
> +	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> +	struct cxl_mem *cxlm = cxlmd->cxlm;
>  	struct cxl_nvdimm_bridge *cxl_nvb;
> +	struct nvdimm *nvdimm = NULL;
>  	unsigned long flags = 0;
> -	struct nvdimm *nvdimm;
>  	int rc = -ENXIO;
>  
>  	cxl_nvb = cxl_find_nvdimm_bridge();
> @@ -52,17 +66,20 @@ static int cxl_nvdimm_probe(struct device *dev)
>  	if (!cxl_nvb->nvdimm_bus)
>  		goto out;
>  
> +	set_exclusive_cxl_commands(cxlm, exclusive_cmds);
> +
>  	set_bit(NDD_LABELING, &flags);
>  	nvdimm = nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags, 0, 0,
>  			       NULL);
> -	if (!nvdimm)
> -		goto out;
> -
> -	rc = devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
> +	dev_set_drvdata(dev, nvdimm);
> +	rc = devm_add_action_or_reset(dev, unregister_nvdimm, cxl_nvd);

I think this ends up less readable than explicit devm handling of each part
rather than combining them.


	set_exclusive...()
	rc = devm_add_action_or_rset(dev, unset_exclusive, cxlm);
	if (rc)
		goto out;

	nvidimm = nvdim_create()
	if (!nvdimm) //return value looks dubious in old code but I've not checked it properly.
		goto out;

	rc = devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
	if (rc)
		goto out;
	dev_set_drvdata(dev, nvdimm);

and two simpler unwinding functions doing just one thing each.

>  out:
>  	device_unlock(&cxl_nvb->dev);
>  	put_device(&cxl_nvb->dev);
>  
> +	if (!nvdimm && rc == 0)
> +		rc = -ENOMEM;
> +
>  	return rc;
>  }
>  
> @@ -194,6 +211,10 @@ static __init int cxl_pmem_init(void)
>  {
>  	int rc;
>  
> +	set_bit(CXL_MEM_COMMAND_ID_SET_PARTITION_INFO, exclusive_cmds);
> +	set_bit(CXL_MEM_COMMAND_ID_SET_SHUTDOWN_STATE, exclusive_cmds);
> +	set_bit(CXL_MEM_COMMAND_ID_SET_LSA, exclusive_cmds);
> +
>  	cxl_pmem_wq = alloc_ordered_workqueue("cxl_pmem", 0);
>  	if (!cxl_pmem_wq)
>  		return -ENXIO;
> 

