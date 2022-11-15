Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4527D33C7
	for <nvdimm@lists.linux.dev>; Tue, 15 Nov 2022 11:08:42 +0000 (UTC)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NBNdw4yy6z6880b;
	Tue, 15 Nov 2022 19:06:12 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Tue, 15 Nov 2022 12:08:32 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 15 Nov
 2022 11:08:33 +0000
Date: Tue, 15 Nov 2022 11:08:31 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH v4 12/18] tools/testing/cxl: Add "passphrase secure
 erase" opcode support
Message-ID: <20221115110831.00001fa4@Huawei.com>
In-Reply-To: <166845805415.2496228.732168029765896218.stgit@djiang5-desk3.ch.intel.com>
References: <166845791969.2496228.8357488385523295841.stgit@djiang5-desk3.ch.intel.com>
	<166845805415.2496228.732168029765896218.stgit@djiang5-desk3.ch.intel.com>
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
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Mon, 14 Nov 2022 13:34:14 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Add support to emulate a CXL mem device support the "passphrase secure
> erase" operation.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
The logic in here gives me a headache but I'm not sure it's correct yet...

If you can figure out what is supposed to happen if this is called
with Passphrase Type == master before the master passphrase has been set
then you are doing better than me.

Unlike for the User passphrase, where the language " .. and the user passphrase
is not currently set or is not supported by the device, this value is ignored."
to me implies we wipe the device and clear the non existent user pass phrase,
the not set master passphrase case isn't covered as far as I can see.

The user passphrase question raises a futher question (see inline)

Thoughts?

Other than that some suggestions inline but nothing functional, so up to you.
Either way

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  tools/testing/cxl/test/mem.c |   65 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
> 
> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> index 90607597b9a4..fc28f7cc147a 100644
> --- a/tools/testing/cxl/test/mem.c
> +++ b/tools/testing/cxl/test/mem.c
> @@ -362,6 +362,68 @@ static int mock_unlock_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd
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
> +	if (mdata->security_state & CXL_PMEM_SEC_STATE_FROZEN) {
> +		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
> +		return -ENXIO;
> +	}
> +
> +	if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PLIMIT &&
> +	    erase->type == CXL_PMEM_SEC_PASS_USER) {
> +		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
> +		return -ENXIO;
> +	}
> +
> +	if (mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PLIMIT &&
> +	    erase->type == CXL_PMEM_SEC_PASS_MASTER) {
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
What to do if the masterpass phrase isn't set?
Even if we return 0, I'd slightly prefer to see that done locally so refactor as
	if (erase->type == CXL_PMEM_SEC_PASS_MASTER) {
		if (!(mdata->security_state & CXL_PMEM_SEC_STATATE_MASTER_PASS_SET)) {
			return 0; /* ? */
		if (memcmp)...
	} else { /* CXL_PMEM_SEC_PASS_USER */ //or make it a switch.

> +
> +	if (erase->type == CXL_PMEM_SEC_PASS_USER &&
> +	    mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET) {

Given we aren't actually scrambling the encryption keys (as we don't have any ;)
it doesn't make a functional difference, but to line up with the spec, I would
consider changing this to explicitly have the path for no user passphrase set.

	if (erase->type == CXL_PMEM_SEC_PASS_USER) {
		if (mdata->security_state & CXL_MEM_SEC_STATE_USER_PASS_SET) {
		    	if (memcmp(mdata->user_pass, erase->pass, NVDIMM_PASSPHRASE_LEN)) {
				user_plimit_check(mdata);
				cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
				return -ENXIO;
 			}	

			mdata->user_limit = 0;
			mdata->security_state &= ~CXL_PMEM_SEC_STATE_USER_PASS_SET;
			memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN);
		}
		/* Change encryption keys */
		return 0;
	}

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

With above changes you can never reach here.

> +}
> +
>  static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>  {
>  	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
> @@ -470,6 +532,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
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

