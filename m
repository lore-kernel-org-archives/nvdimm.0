Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC40C72
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 18:22:29 +0000 (UTC)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H0q434mNJz67N2l;
	Fri,  3 Sep 2021 02:20:51 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 2 Sep 2021 20:22:26 +0200
Received: from localhost (10.52.127.69) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 2 Sep 2021
 19:22:25 +0100
Date: Thu, 2 Sep 2021 19:22:27 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<nvdimm@lists.linux.dev>, <ira.weiny@intel.com>
Subject: Re: [PATCH v3 21/28] cxl/pmem: Translate NVDIMM label commands to
 CXL label commands
Message-ID: <20210902192227.00006dc8@Huawei.com>
In-Reply-To: <162982123813.1124374.3721946437291753388.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162982123813.1124374.3721946437291753388.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Tue, 24 Aug 2021 09:07:18 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> The LIBNVDIMM IOCTL UAPI calls back to the nvdimm-bus-provider to
> translate the Linux command payload to the device native command format.
> The LIBNVDIMM commands get-config-size, get-config-data, and
> set-config-data, map to the CXL memory device commands device-identify,
> get-lsa, and set-lsa. Recall that the label-storage-area (LSA) on an
> NVDIMM device arranges for the provisioning of namespaces. Additionally
> for CXL the LSA is used for provisioning regions as well.
> 
> The data from device-identify is already cached in the 'struct cxl_mem'
> instance associated with @cxl_nvd, so that payload return is simply
> crafted and no CXL command is issued. The conversion for get-lsa is
> straightforward, but the conversion for set-lsa requires an allocation
> to append the set-lsa header in front of the payload.
> 
> Acked-by: Ben Widawsky <ben.widawsky@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Minor query inline.

> ---
>  drivers/cxl/pmem.c |  121 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 117 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index 469b984176a2..6cc76302c8f8 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -52,10 +52,10 @@ static int cxl_nvdimm_probe(struct device *dev)

> +static int cxl_pmem_get_config_size(struct cxl_mem *cxlm,
> +				    struct nd_cmd_get_config_size *cmd,
> +				    unsigned int buf_len, int *cmd_rc)
> +{
> +	if (sizeof(*cmd) > buf_len)
> +		return -EINVAL;
> +
> +	*cmd = (struct nd_cmd_get_config_size) {
> +		 .config_size = cxlm->lsa_size,
> +		 .max_xfer = cxlm->payload_size,
> +	};
> +	*cmd_rc = 0;
> +
> +	return 0;
> +}
> +
> +static int cxl_pmem_get_config_data(struct cxl_mem *cxlm,
> +				    struct nd_cmd_get_config_data_hdr *cmd,
> +				    unsigned int buf_len, int *cmd_rc)
> +{
> +	struct cxl_mbox_get_lsa {
> +		u32 offset;
> +		u32 length;
> +	} get_lsa;
> +	int rc;
> +
> +	if (sizeof(*cmd) > buf_len)
> +		return -EINVAL;
> +	if (struct_size(cmd, out_buf, cmd->in_length) > buf_len)
> +		return -EINVAL;
> +
> +	get_lsa = (struct cxl_mbox_get_lsa) {
> +		.offset = cmd->in_offset,
> +		.length = cmd->in_length,
> +	};
> +
> +	rc = cxl_mem_mbox_send_cmd(cxlm, CXL_MBOX_OP_GET_LSA, &get_lsa,
> +				   sizeof(get_lsa), cmd->out_buf,
> +				   cmd->in_length);
> +	cmd->status = 0;
> +	*cmd_rc = 0;
> +
> +	return rc;
> +}
> +
> +static int cxl_pmem_set_config_data(struct cxl_mem *cxlm,
> +				    struct nd_cmd_set_config_hdr *cmd,
> +				    unsigned int buf_len, int *cmd_rc)
> +{
> +	struct cxl_mbox_set_lsa {
> +		u32 offset;
> +		u32 reserved;
> +		u8 data[];
> +	} *set_lsa;
> +	int rc;
> +
> +	if (sizeof(*cmd) > buf_len)
> +		return -EINVAL;
> +
> +	/* 4-byte status follows the input data in the payload */
> +	if (struct_size(cmd, in_buf, cmd->in_length) + 4 > buf_len)
> +		return -EINVAL;
> +
> +	set_lsa =
> +		kvzalloc(struct_size(set_lsa, data, cmd->in_length), GFP_KERNEL);
> +	if (!set_lsa)
> +		return -ENOMEM;
> +
> +	*set_lsa = (struct cxl_mbox_set_lsa) {
> +		.offset = cmd->in_offset,
> +	};
> +	memcpy(set_lsa->data, cmd->in_buf, cmd->in_length);
> +
> +	rc = cxl_mem_mbox_send_cmd(cxlm, CXL_MBOX_OP_SET_LSA, set_lsa,
> +				   struct_size(set_lsa, data, cmd->in_length),
> +				   NULL, 0);
> +
> +	/* set "firmware" status */
> +	*(u32 *) &cmd->in_buf[cmd->in_length] = 0;

Are we guaranteed this is aligned? Not 'locally' obvious so maybe a comment?

> +	*cmd_rc = 0;
> +	kvfree(set_lsa);
> +
> +	return rc;
> +}
> +


