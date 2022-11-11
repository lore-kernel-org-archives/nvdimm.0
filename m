Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A962582
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 10:37:53 +0000 (UTC)
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4N7w8Y2zXQz67D3d;
	Fri, 11 Nov 2022 18:35:41 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 11:37:50 +0100
Received: from localhost (10.45.151.252) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 11 Nov
 2022 10:37:49 +0000
Date: Fri, 11 Nov 2022 10:37:48 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH v3 12/18] tools/testing/cxl: Add "passphrase secure
 erase" opcode support
Message-ID: <20221111103748.000051c5@Huawei.com>
In-Reply-To: <166792839079.3767969.17718924625264191957.stgit@djiang5-desk3.ch.intel.com>
References: <166792815961.3767969.2621677491424623673.stgit@djiang5-desk3.ch.intel.com>
	<166792839079.3767969.17718924625264191957.stgit@djiang5-desk3.ch.intel.com>
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

On Tue, 08 Nov 2022 10:26:30 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Add support to emulate a CXL mem device support the "passphrase secure
> erase" operation.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Hi Dave,

My feedback in previous version was in the wrong place and I think that
led you to update the wrong error path.

See inline

Jonathan

> ---
>  tools/testing/cxl/test/mem.c |   59 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> index 90607597b9a4..aa6dda21bc5f 100644
> --- a/tools/testing/cxl/test/mem.c
> +++ b/tools/testing/cxl/test/mem.c
> @@ -362,6 +362,62 @@ static int mock_unlock_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd
>  	return 0;
>  }
>  
> +static int mock_passphrase_secure_erase(struct cxl_dev_state *cxlds,
> +					struct cxl_mbox_cmd *cmd)
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
> +	erase = cmd->payload_in;
> +	if (mdata->security_state & CXL_PMEM_SEC_STATE_FROZEN &&
> +	    erase->type != CXL_PMEM_SEC_PASS_MASTER) {
> +		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
> +		return -ENXIO;
> +	}

A stuck my comment in a rather odd location.  I was commenting not
on the block above, but rather the one below.

Frozen it's fixed by providing the master pass phrase - so the
above should just check if frozen.

The original comment was about the neck block.  Having failed user
passcode too many times isn't relevant if the one provided this
time is the master passcode - so add the 
erase->type != CXL_PMEM_SEC_PASS_MASTER to the next if block.

> +
> +	if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PLIMIT) {
> +		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
> +		return -ENXIO;
> +	}
> +
> +	if (erase->type == CXL_PMEM_SEC_PASS_MASTER &&
> +	    mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PASS_SET) {
> +		if (memcmp(mdata->master_pass, erase->pass, NVDIMM_PASSPHRASE_LEN)) {
> +			master_plimit_check(mdata);
> +			cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
> +			return -ENXIO;
> +		}
> +		mdata->master_limit = 0;
> +		mdata->user_limit = 0;
> +		mdata->security_state &= ~CXL_PMEM_SEC_STATE_USER_PASS_SET;
> +		memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN);
> +		mdata->security_state &= ~CXL_PMEM_SEC_STATE_LOCKED;
> +		return 0;
> +	}
> +
> +	if (erase->type == CXL_PMEM_SEC_PASS_USER &&
> +	    mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET) {
> +		if (memcmp(mdata->user_pass, erase->pass, NVDIMM_PASSPHRASE_LEN)) {
> +			user_plimit_check(mdata);
> +			cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
> +			return -ENXIO;
> +		}
> +
> +		mdata->user_limit = 0;
> +		mdata->security_state &= ~CXL_PMEM_SEC_STATE_USER_PASS_SET;
> +		memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN);
> +		return 0;
> +	}
> +
> +	return 0;
> +}
> +
>  static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>  {
>  	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
> @@ -470,6 +526,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
>  	case CXL_MBOX_OP_UNLOCK:
>  		rc = mock_unlock_security(cxlds, cmd);
>  		break;
> +	case CXL_MBOX_OP_PASSPHRASE_SECURE_ERASE:
> +		rc = mock_passphrase_secure_erase(cxlds, cmd);
> +		break;
>  	default:
>  		break;
>  	}
> 
> 

