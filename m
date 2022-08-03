Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B804D20E4
	for <nvdimm@lists.linux.dev>; Wed,  3 Aug 2022 17:16:01 +0000 (UTC)
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lydfx3P2dz688fw;
	Thu,  4 Aug 2022 01:11:05 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Wed, 3 Aug 2022 19:15:58 +0200
Received: from localhost (10.202.226.42) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 3 Aug
 2022 18:15:57 +0100
Date: Wed, 3 Aug 2022 18:15:56 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <bwidawsk@kernel.org>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH RFC 05/15] tools/testing/cxl: Add "Set Passphrase"
 opcode support
Message-ID: <20220803181556.000059ea@huawei.com>
In-Reply-To: <165791934143.2491387.18407792819271591669.stgit@djiang5-desk3.ch.intel.com>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
	<165791934143.2491387.18407792819271591669.stgit@djiang5-desk3.ch.intel.com>
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

On Fri, 15 Jul 2022 14:09:01 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Add support to emulate a CXL mem device supporting the "Set Passphrase"
> operation. The operation supports setting of either a user or a master
> passphrase.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Hi Dave,

A few comments inline.

Thanks,

Jonathan

> ---
>  tools/testing/cxl/test/mem.c |   76 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 76 insertions(+)
> 
> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> index 337e5a099d31..796f4f7b5e3d 100644
> --- a/tools/testing/cxl/test/mem.c
> +++ b/tools/testing/cxl/test/mem.c
> @@ -12,8 +12,14 @@
>  struct mock_mdev_data {
>  	void *lsa;
>  	u32 security_state;
> +	u8 user_pass[NVDIMM_PASSPHRASE_LEN];
> +	u8 master_pass[NVDIMM_PASSPHRASE_LEN];
> +	int user_limit;
> +	int master_limit;
>  };
>  
> +#define PASS_TRY_LIMIT 3
> +
>  #define LSA_SIZE SZ_128K
>  #define EFFECT(x) (1U << x)
>  
> @@ -162,6 +168,73 @@ static int mock_get_security_state(struct cxl_dev_state *cxlds,
>  	return 0;
>  }
>  
> +static int mock_set_passphrase(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
> +{
> +	struct mock_mdev_data *mdata = dev_get_drvdata(cxlds->dev);
> +	struct cxl_set_pass *set_pass;
> +
> +	if (cmd->size_in != sizeof(*set_pass)) {
> +		cmd->return_code = CXL_MBOX_CMD_RC_INPUT;

If it makes sense to set I think this should be invalid payload length.

> +		return -EINVAL;
> +	}
> +
> +	if (cmd->size_out != 0) {
> +		cmd->return_code = CXL_MBOX_CMD_RC_INPUT;

As before. I'm not 100% sure this is actually an error from
device point of view (it fills the buffer whatever).  Obviously
it's an error in the software so return -EINVAL makes sense.


> +		return -EINVAL;
> +	}
> +
> +	if (mdata->security_state & CXL_PMEM_SEC_STATE_FROZEN) {
> +		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
> +		return -ENXIO;
> +	}
> +
> +	set_pass = cmd->payload_in;
> +	switch (set_pass->type) {
> +	case CXL_PMEM_SEC_PASS_MASTER:
> +		if (mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PLIMIT) {
> +			cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
> +			return -ENXIO;
> +		}
> +		/*
> +		 * CXL spec v2.0 8.2.9.5.6.2, The master pasphrase shall only be set in
> +		 * the security disabled state when the user passphrase is not set.
> +		 */
> +		if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET) {
> +			cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
> +			return -ENXIO;
> +		}
> +		if (mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PASS_SET &&
> +		    memcmp(mdata->master_pass, set_pass->old_pass, NVDIMM_PASSPHRASE_LEN)) {
> +			if (++mdata->master_limit == PASS_TRY_LIMIT)
> +				mdata->security_state |= CXL_PMEM_SEC_STATE_MASTER_PLIMIT;
> +			cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
> +			return -ENXIO;
> +		}
> +		memcpy(mdata->master_pass, set_pass->new_pass, NVDIMM_PASSPHRASE_LEN);
> +		break;
> +
> +	case CXL_PMEM_SEC_PASS_USER:
> +		if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PLIMIT) {
> +			cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
> +			return -ENXIO;
> +		}
> +		if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET &&
> +		    memcmp(mdata->user_pass, set_pass->old_pass, NVDIMM_PASSPHRASE_LEN)) {
> +			if (++mdata->user_limit == PASS_TRY_LIMIT)
> +				mdata->security_state |= CXL_PMEM_SEC_STATE_USER_PLIMIT;
> +			cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
> +			return -ENXIO;
> +		}
> +		memcpy(mdata->user_pass, set_pass->new_pass, NVDIMM_PASSPHRASE_LEN);
> +		break;
> +
> +	default:
> +		cmd->return_code = CXL_MBOX_CMD_RC_INPUT;
> +		return -EINVAL;
> +	}

I would directly return rather than break; above as reduces the code someone following
either case needs to look at.  + saves a whole 1 line of code ;)

> +	return 0;
> +}
> +
>  static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>  {
>  	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
> @@ -257,6 +330,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
>  	case CXL_MBOX_OP_GET_SECURITY_STATE:
>  		rc = mock_get_security_state(cxlds, cmd);
>  		break;
> +	case CXL_MBOX_OP_SET_PASSPHRASE:
> +		rc = mock_set_passphrase(cxlds, cmd);
> +		break;
>  	default:
>  		break;
>  	}
> 
> 

