Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5AE20E4
	for <nvdimm@lists.linux.dev>; Wed,  3 Aug 2022 17:23:05 +0000 (UTC)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lydsw5xz4z689NW;
	Thu,  4 Aug 2022 01:20:36 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 3 Aug 2022 19:23:02 +0200
Received: from localhost (10.202.226.42) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 3 Aug
 2022 18:23:01 +0100
Date: Wed, 3 Aug 2022 18:23:00 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <bwidawsk@kernel.org>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH RFC 07/15] tools/testing/cxl: Add "Disable" security
 opcode support
Message-ID: <20220803182300.000028c7@huawei.com>
In-Reply-To: <165791935297.2491387.8950514630973579122.stgit@djiang5-desk3.ch.intel.com>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
	<165791935297.2491387.8950514630973579122.stgit@djiang5-desk3.ch.intel.com>
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

On Fri, 15 Jul 2022 14:09:12 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Add support to emulate a CXL mem device support the "Disable Passphrase"
> operation. The operation supports disabling of either a user or a master
> passphrase. The emulation will provide support for both user and master
> passphrase.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Similar comments as for earlier test patches.

Thanks,

Jonathan

> ---
>  tools/testing/cxl/test/mem.c |   80 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 80 insertions(+)
> 
> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> index 796f4f7b5e3d..5f87a94d92ae 100644
> --- a/tools/testing/cxl/test/mem.c
> +++ b/tools/testing/cxl/test/mem.c
> @@ -235,6 +235,83 @@ static int mock_set_passphrase(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd
>  	return 0;
>  }
>  
> +static int mock_disable_passphrase(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
> +{
> +	struct mock_mdev_data *mdata = dev_get_drvdata(cxlds->dev);
> +	struct cxl_disable_pass *dis_pass;
> +
> +	if (cmd->size_in != sizeof(*dis_pass)) {
> +		cmd->return_code = CXL_MBOX_CMD_RC_INPUT;

Same as in earlier patches.  I think return code is wrong and not seeing why it's useful
to set it.

> +		return -EINVAL;
> +	}
> +
> +	if (cmd->size_out != 0) {
> +		cmd->return_code = CXL_MBOX_CMD_RC_INPUT;
> +		return -EINVAL;
> +	}
> +
> +	if (mdata->security_state & CXL_PMEM_SEC_STATE_FROZEN) {
> +		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
> +		return -ENXIO;
> +	}
> +
> +	dis_pass = cmd->payload_in;
> +	switch (dis_pass->type) {
> +	case CXL_PMEM_SEC_PASS_MASTER:
> +		if (mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PLIMIT) {
> +			cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
> +			return -ENXIO;
> +		}
> +
> +		if (!(mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PASS_SET)) {
> +			cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
> +			return -ENXIO;
> +		}
> +
> +		if (memcmp(dis_pass->pass, mdata->master_pass, NVDIMM_PASSPHRASE_LEN)) {
> +			if (++mdata->master_limit == PASS_TRY_LIMIT)
> +				mdata->security_state |= CXL_PMEM_SEC_STATE_MASTER_PLIMIT;
> +			cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
> +			return -ENXIO;
> +		}
> +
> +		mdata->master_limit = 0;
> +		memset(mdata->master_pass, 0, NVDIMM_PASSPHRASE_LEN);
> +		mdata->security_state &= ~CXL_PMEM_SEC_STATE_MASTER_PASS_SET;
> +		break;
> +
> +	case CXL_PMEM_SEC_PASS_USER:
> +		if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PLIMIT) {
> +			cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
> +			return -ENXIO;
> +		}
> +
> +		if (!(mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET)) {
> +			cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
> +			return -ENXIO;
> +		}
> +
> +		if (memcmp(dis_pass->pass, mdata->user_pass, NVDIMM_PASSPHRASE_LEN)) {
> +			if (++mdata->user_limit == PASS_TRY_LIMIT)
> +				mdata->security_state |= CXL_PMEM_SEC_STATE_USER_PLIMIT;
> +			cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
> +			return -ENXIO;
> +		}
> +
> +		mdata->user_limit = 0;
> +		memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN);
> +		mdata->security_state &= ~(CXL_PMEM_SEC_STATE_USER_PASS_SET |
> +					   CXL_PMEM_SEC_STATE_LOCKED);
> +		break;
Similar comment to before. I'd return 0 here and in above case to slightly improve
readability.

> +
> +	default:
> +		cmd->return_code = CXL_MBOX_CMD_RC_INPUT;
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>  {
>  	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
> @@ -333,6 +410,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
>  	case CXL_MBOX_OP_SET_PASSPHRASE:
>  		rc = mock_set_passphrase(cxlds, cmd);
>  		break;
> +	case CXL_MBOX_OP_DISABLE_PASSPHRASE:
> +		rc = mock_disable_passphrase(cxlds, cmd);
> +		break;
>  	default:
>  		break;
>  	}
> 
> 

