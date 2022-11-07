Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E05D527
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 15:35:41 +0000 (UTC)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4N5Zxz0b5Nz67y8F;
	Mon,  7 Nov 2022 23:33:27 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 16:35:38 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 7 Nov
 2022 15:35:38 +0000
Date: Mon, 7 Nov 2022 15:35:37 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <bwidawsk@kernel.org>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH v2 13/19] tools/testing/cxl: Add "passphrase secure
 erase" opcode support
Message-ID: <20221107153537.0000050e@Huawei.com>
In-Reply-To: <166377436599.430546.9691226328917294997.stgit@djiang5-desk3.ch.intel.com>
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
	<166377436599.430546.9691226328917294997.stgit@djiang5-desk3.ch.intel.com>
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
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Wed, 21 Sep 2022 08:32:46 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Add support to emulate a CXL mem device support the "passphrase secure
> erase" operation.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  tools/testing/cxl/test/mem.c |   56 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
> 
> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> index 840378d239bf..a0a58156c15a 100644
> --- a/tools/testing/cxl/test/mem.c
> +++ b/tools/testing/cxl/test/mem.c
> @@ -356,6 +356,59 @@ static int mock_unlock_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd
>  	return 0;
>  }
>  
> +static int mock_passphrase_erase(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
> +{
> +	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(cxlds->dev);
> +	struct cxl_pass_erase *erase;
> +
> +	if (cmd->size_in != sizeof(*erase))
> +		return -EINVAL;
> +
> +	if (cmd->size_out != 0)
> +		return -EINVAL;
> +
> +	if (mdata->security_state & CXL_PMEM_SEC_STATE_FROZEN) {
> +		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
> +		return -ENXIO;
> +	}
> +

I think we need to check also that the passphrase supplied is not the
master one in which case the lockout on user passphrase shouldn't matter.

> +	if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PLIMIT) {
> +		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
> +		return -ENXIO;
> +	}
> +
> +	erase = cmd->payload_in;
> +	if (erase->type == CXL_PMEM_SEC_PASS_MASTER &&
> +	    mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PASS_SET &&
> +	    memcmp(mdata->master_pass, erase->pass, NVDIMM_PASSPHRASE_LEN)) {
> +		if (++mdata->master_limit == PASS_TRY_LIMIT)

It's harmless, but I'm not sure I like the adding to this when we've already
hit the limit.  Maybe only increment if not?

> +			mdata->security_state |= CXL_PMEM_SEC_STATE_MASTER_PLIMIT;
> +		cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
> +		return -ENXIO;
> +	}
> +
> +	if (erase->type == CXL_PMEM_SEC_PASS_USER &&
> +	    mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET &&
> +	    memcmp(mdata->user_pass, erase->pass, NVDIMM_PASSPHRASE_LEN)) {
> +		if (++mdata->user_limit == PASS_TRY_LIMIT)
> +			mdata->security_state |= CXL_PMEM_SEC_STATE_USER_PLIMIT;
> +		cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
> +		return -ENXIO;
> +	}
> +
> +	if (erase->type == CXL_PMEM_SEC_PASS_USER) {
> +		mdata->security_state &= ~CXL_PMEM_SEC_STATE_USER_PASS_SET;
> +		mdata->user_limit = 0;

I think it would be more logical to set this to zero as part of the password
testing block above rather than down here.

I also 'think' the user passphrase is wiped even if the secure erase was
done with the master key. 
"The user passphrase shall be disabled after secure erase, but the master passphrase, if set, shall 
be unchanged" doesn't say anything about only if the user passphrase was the one used to
perform the erase.

> +		memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN);
> +	} else if (erase->type == CXL_PMEM_SEC_PASS_MASTER) {
> +		mdata->master_limit = 0;
> +	}
> +
> +	mdata->security_state &= ~CXL_PMEM_SEC_STATE_LOCKED;
> +
> +	return 0;
> +}
> +


