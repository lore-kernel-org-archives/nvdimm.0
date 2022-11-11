Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F5D20E7
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 10:28:05 +0000 (UTC)
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4N7vx01hv8z688hZ;
	Fri, 11 Nov 2022 18:25:40 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Fri, 11 Nov 2022 11:27:57 +0100
Received: from localhost (10.45.151.252) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 11 Nov
 2022 10:27:56 +0000
Date: Fri, 11 Nov 2022 10:27:53 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <bwidawsk@kernel.org>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH v2 09/19] tools/testing/cxl: Add "Freeze Security State"
 security opcode support
Message-ID: <20221111102753.00001a26@Huawei.com>
In-Reply-To: <57305aec-2d39-ce5a-0d47-ee1110834d26@intel.com>
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
	<166377434213.430546.16329545604946404040.stgit@djiang5-desk3.ch.intel.com>
	<20221107144411.000079eb@Huawei.com>
	<57305aec-2d39-ce5a-0d47-ee1110834d26@intel.com>
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
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Mon, 7 Nov 2022 11:01:45 -0800
Dave Jiang <dave.jiang@intel.com> wrote:

> On 11/7/2022 6:44 AM, Jonathan Cameron wrote:
> > On Wed, 21 Sep 2022 08:32:22 -0700
> > Dave Jiang <dave.jiang@intel.com> wrote:
> >   
> >> Add support to emulate a CXL mem device support the "Freeze Security State"
> >> operation.
> >>
> >> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> >> ---
> >>   tools/testing/cxl/test/mem.c |   27 +++++++++++++++++++++++++++
> >>   1 file changed, 27 insertions(+)
> >>
> >> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> >> index 40dccbeb9f30..b24119b0ea76 100644
> >> --- a/tools/testing/cxl/test/mem.c
> >> +++ b/tools/testing/cxl/test/mem.c
> >> @@ -290,6 +290,30 @@ static int mock_disable_passphrase(struct cxl_dev_state *cxlds, struct cxl_mbox_
> >>   	return 0;
> >>   }
> >>   
> >> +static int mock_freeze_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
> >> +{
> >> +	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(cxlds->dev);
> >> +
> >> +	if (cmd->size_in != 0)
> >> +		return -EINVAL;
> >> +
> >> +	if (cmd->size_out != 0)
> >> +		return -EINVAL;
> >> +
> >> +	if (mdata->security_state & CXL_PMEM_SEC_STATE_FROZEN) {  
> > 
> > There are list of commands that should return invalid security state in
> > 8.2.9.8.6.5 but doesn't include Freeze Security state.
> > Hence I think this is idempotent and writing to frozen when frozen succeeds
> > - it just doesn't change anything.  
> 
> Ok will return 0.
> 
> >   
> >> +		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
> >> +		return -ENXIO;
> >> +	}
> >> +
> >> +	if (!(mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET)) {  
> > 
> > This needs a spec reference.  (which is another way of saying I'm not sure
> > why it is here).  
> 
> Will remove. It feels like the spec around this area is rather sparse 
> and missing a lot of details. i.e. freezing security w/o security set.

Agreed on it being too sparse: Well volunteered to poke relevant standards groups ;)

Jonathan

> 
> >   
> >> +		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
> >> +		return -ENXIO;
> >> +	}
> >> +
> >> +	mdata->security_state |= CXL_PMEM_SEC_STATE_FROZEN;
> >> +	return 0;
> >> +}
> >> +
> >>   static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
> >>   {
> >>   	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
> >> @@ -392,6 +416,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
> >>   	case CXL_MBOX_OP_DISABLE_PASSPHRASE:
> >>   		rc = mock_disable_passphrase(cxlds, cmd);
> >>   		break;
> >> +	case CXL_MBOX_OP_FREEZE_SECURITY:
> >> +		rc = mock_freeze_security(cxlds, cmd);
> >> +		break;
> >>   	default:
> >>   		break;
> >>   	}
> >>
> >>  
> > 
> >   

