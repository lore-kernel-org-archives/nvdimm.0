Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785E21FBB
	for <nvdimm@lists.linux.dev>; Wed,  3 Aug 2022 16:51:15 +0000 (UTC)
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lyd7B0pwkz67j7Z;
	Thu,  4 Aug 2022 00:47:02 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Wed, 3 Aug 2022 18:51:12 +0200
Received: from localhost (10.202.226.42) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 3 Aug
 2022 17:51:11 +0100
Date: Wed, 3 Aug 2022 17:51:10 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <bwidawsk@kernel.org>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH RFC 03/15] tools/testing/cxl: Add "Get Security State"
 opcode support
Message-ID: <20220803175110.000021e0@huawei.com>
In-Reply-To: <165791932983.2491387.13708346830998415266.stgit@djiang5-desk3.ch.intel.com>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
	<165791932983.2491387.13708346830998415266.stgit@djiang5-desk3.ch.intel.com>
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

On Fri, 15 Jul 2022 14:08:49 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Add the emulation support for handling "Get Security State" opcode for a
> CXL memory device for the cxl_test. The function will copy back device
> security state bitmask to the output payload.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  tools/testing/cxl/test/mem.c |   24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> index 723378248321..337e5a099d31 100644
> --- a/tools/testing/cxl/test/mem.c
> +++ b/tools/testing/cxl/test/mem.c
> @@ -11,6 +11,7 @@
>  
>  struct mock_mdev_data {
>  	void *lsa;
> +	u32 security_state;
>  };
>  
>  #define LSA_SIZE SZ_128K
> @@ -141,6 +142,26 @@ static int mock_id(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>  	return 0;
>  }
>  
> +static int mock_get_security_state(struct cxl_dev_state *cxlds,
> +				   struct cxl_mbox_cmd *cmd)
> +{
> +	struct mock_mdev_data *mdata = dev_get_drvdata(cxlds->dev);
> +
> +	if (cmd->size_in) {
> +		cmd->return_code = CXL_MBOX_CMD_RC_INPUT;

Interestingly I don't see invalid input as a possible return code for this command
in the spec.  Would it be an invalid payload length?
Also, is this based on current tree?  For other fail cases we don't set the
return code because the -EINVAL will presumably make the test fail anyway.

> +		return -EINVAL;
> +	}
> +
> +	if (cmd->size_out != sizeof(u32)) {
> +		cmd->return_code = CXL_MBOX_CMD_RC_INPUT;
Interesting corner. If this was a real device, I think this isn't actually
an error (it's just stupid as you ask a question and don't get an answer)
Makes sense to return -EINVAL from the test, but setting invalid input
in the return code probably doesn't.  Ignored anyway as we won't carry
on anyway because of the -EINVAL.

> +		return -EINVAL;
> +	}
> +
> +	memcpy(cmd->payload_out, &mdata->security_state, sizeof(u32));
> +
> +	return 0;
> +}
> +
>  static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>  {
>  	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
> @@ -233,6 +254,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
>  	case CXL_MBOX_OP_GET_HEALTH_INFO:
>  		rc = mock_health_info(cxlds, cmd);
>  		break;
> +	case CXL_MBOX_OP_GET_SECURITY_STATE:
> +		rc = mock_get_security_state(cxlds, cmd);
> +		break;
>  	default:
>  		break;
>  	}
> 
> 

