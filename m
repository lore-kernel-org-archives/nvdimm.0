Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882503FC4
	for <nvdimm@lists.linux.dev>; Fri, 10 Sep 2021 09:39:23 +0000 (UTC)
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H5W4N2rq5z67jSH;
	Fri, 10 Sep 2021 17:37:24 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 10 Sep 2021 11:39:21 +0200
Received: from localhost (10.52.123.213) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 10 Sep
 2021 10:39:20 +0100
Date: Fri, 10 Sep 2021 10:39:18 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Ben Widawsky <ben.widawsky@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, <linux-cxl@vger.kernel.org>,
	Vishal L Verma <vishal.l.verma@intel.com>, Linux NVDIMM
	<nvdimm@lists.linux.dev>, "Schofield, Alison" <alison.schofield@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH v4 15/21] cxl/pmem: Translate NVDIMM label commands to
 CXL label commands
Message-ID: <20210910103918.00003648@Huawei.com>
In-Reply-To: <20210909203214.ldl5gtv7myxcfacf@intel.com>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
	<163116437437.2460985.13509423327603255812.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20210909172226.mwj6jdmmhmxir4je@intel.com>
	<CAPcyv4iwTSE2iV6d-56rwE7OhZno=oTwHk6N_XdvJMVObCO_WQ@mail.gmail.com>
	<20210909203214.ldl5gtv7myxcfacf@intel.com>
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
X-Originating-IP: [10.52.123.213]
X-ClientProxiedBy: lhreml710-chm.china.huawei.com (10.201.108.61) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 9 Sep 2021 13:32:14 -0700
Ben Widawsky <ben.widawsky@intel.com> wrote:

> On 21-09-09 12:03:49, Dan Williams wrote:
> > On Thu, Sep 9, 2021 at 10:22 AM Ben Widawsky <ben.widawsky@intel.com> wrote:  
> > >
> > > On 21-09-08 22:12:54, Dan Williams wrote:  
> > > > The LIBNVDIMM IOCTL UAPI calls back to the nvdimm-bus-provider to
> > > > translate the Linux command payload to the device native command format.
> > > > The LIBNVDIMM commands get-config-size, get-config-data, and
> > > > set-config-data, map to the CXL memory device commands device-identify,
> > > > get-lsa, and set-lsa. Recall that the label-storage-area (LSA) on an
> > > > NVDIMM device arranges for the provisioning of namespaces. Additionally
> > > > for CXL the LSA is used for provisioning regions as well.
> > > >
> > > > The data from device-identify is already cached in the 'struct cxl_mem'
> > > > instance associated with @cxl_nvd, so that payload return is simply
> > > > crafted and no CXL command is issued. The conversion for get-lsa is
> > > > straightforward, but the conversion for set-lsa requires an allocation
> > > > to append the set-lsa header in front of the payload.
> > > >
> > > > Acked-by: Ben Widawsky <ben.widawsky@intel.com>
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > > ---
> > > >  drivers/cxl/pmem.c |  125 ++++++++++++++++++++++++++++++++++++++++++++++++++--
> > > >  1 file changed, 121 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> > > > index a972af7a6e0b..29d24f13aa73 100644
> > > > --- a/drivers/cxl/pmem.c
> > > > +++ b/drivers/cxl/pmem.c
> > > > @@ -1,6 +1,7 @@
> > > >  // SPDX-License-Identifier: GPL-2.0-only
> > > >  /* Copyright(c) 2021 Intel Corporation. All rights reserved. */
> > > >  #include <linux/libnvdimm.h>
> > > > +#include <asm/unaligned.h>
> > > >  #include <linux/device.h>
> > > >  #include <linux/module.h>
> > > >  #include <linux/ndctl.h>
> > > > @@ -48,10 +49,10 @@ static int cxl_nvdimm_probe(struct device *dev)
> > > >  {
> > > >       struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
> > > >       struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> > > > +     unsigned long flags = 0, cmd_mask = 0;
> > > >       struct cxl_mem *cxlm = cxlmd->cxlm;
> > > >       struct cxl_nvdimm_bridge *cxl_nvb;
> > > >       struct nvdimm *nvdimm = NULL;
> > > > -     unsigned long flags = 0;
> > > >       int rc = -ENXIO;
> > > >
> > > >       cxl_nvb = cxl_find_nvdimm_bridge();
> > > > @@ -66,8 +67,11 @@ static int cxl_nvdimm_probe(struct device *dev)
> > > >
> > > >       set_bit(NDD_LABELING, &flags);
> > > >       rc = -ENOMEM;
> > > > -     nvdimm = nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags, 0, 0,
> > > > -                            NULL);
> > > > +     set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
> > > > +     set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
> > > > +     set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
> > > > +     nvdimm = nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags,
> > > > +                            cmd_mask, 0, NULL);
> > > >       dev_set_drvdata(dev, nvdimm);
> > > >
> > > >  out_unlock:
> > > > @@ -89,11 +93,124 @@ static struct cxl_driver cxl_nvdimm_driver = {
> > > >       .id = CXL_DEVICE_NVDIMM,
> > > >  };
> > > >
> > > > +static int cxl_pmem_get_config_size(struct cxl_mem *cxlm,
> > > > +                                 struct nd_cmd_get_config_size *cmd,
> > > > +                                 unsigned int buf_len, int *cmd_rc)
> > > > +{
> > > > +     if (sizeof(*cmd) > buf_len)
> > > > +             return -EINVAL;
> > > > +
> > > > +     *cmd = (struct nd_cmd_get_config_size) {
> > > > +              .config_size = cxlm->lsa_size,
> > > > +              .max_xfer = cxlm->payload_size,
> > > > +     };
> > > > +     *cmd_rc = 0;
> > > > +
> > > > +     return 0;
> > > > +}
> > > > +
> > > > +static int cxl_pmem_get_config_data(struct cxl_mem *cxlm,
> > > > +                                 struct nd_cmd_get_config_data_hdr *cmd,
> > > > +                                 unsigned int buf_len, int *cmd_rc)
> > > > +{
> > > > +     struct cxl_mbox_get_lsa {
> > > > +             u32 offset;
> > > > +             u32 length;
> > > > +     } get_lsa;
> > > > +     int rc;
> > > > +
> > > > +     if (sizeof(*cmd) > buf_len)
> > > > +             return -EINVAL;
> > > > +     if (struct_size(cmd, out_buf, cmd->in_length) > buf_len)
> > > > +             return -EINVAL;
> > > > +
> > > > +     get_lsa = (struct cxl_mbox_get_lsa) {
> > > > +             .offset = cmd->in_offset,
> > > > +             .length = cmd->in_length,
> > > > +     };
> > > > +
> > > > +     rc = cxl_mem_mbox_send_cmd(cxlm, CXL_MBOX_OP_GET_LSA, &get_lsa,
> > > > +                                sizeof(get_lsa), cmd->out_buf,
> > > > +                                cmd->in_length);
> > > > +     cmd->status = 0;
> > > > +     *cmd_rc = 0;
> > > > +
> > > > +     return rc;
> > > > +}
> > > > +
> > > > +static int cxl_pmem_set_config_data(struct cxl_mem *cxlm,
> > > > +                                 struct nd_cmd_set_config_hdr *cmd,
> > > > +                                 unsigned int buf_len, int *cmd_rc)
> > > > +{
> > > > +     struct cxl_mbox_set_lsa {
> > > > +             u32 offset;
> > > > +             u32 reserved;
> > > > +             u8 data[];
> > > > +     } *set_lsa;
> > > > +     int rc;
> > > > +
> > > > +     if (sizeof(*cmd) > buf_len)
> > > > +             return -EINVAL;
> > > > +
> > > > +     /* 4-byte status follows the input data in the payload */
> > > > +     if (struct_size(cmd, in_buf, cmd->in_length) + 4 > buf_len)
> > > > +             return -EINVAL;
> > > > +
> > > > +     set_lsa =
> > > > +             kvzalloc(struct_size(set_lsa, data, cmd->in_length), GFP_KERNEL);
> > > > +     if (!set_lsa)
> > > > +             return -ENOMEM;
> > > > +
> > > > +     *set_lsa = (struct cxl_mbox_set_lsa) {
> > > > +             .offset = cmd->in_offset,
> > > > +     };
> > > > +     memcpy(set_lsa->data, cmd->in_buf, cmd->in_length);
> > > > +
> > > > +     rc = cxl_mem_mbox_send_cmd(cxlm, CXL_MBOX_OP_SET_LSA, set_lsa,
> > > > +                                struct_size(set_lsa, data, cmd->in_length),
> > > > +                                NULL, 0);
> > > > +
> > > > +     /*
> > > > +      * Set "firmware" status (4-packed bytes at the end of the input
> > > > +      * payload.
> > > > +      */
> > > > +     put_unaligned(0, (u32 *) &cmd->in_buf[cmd->in_length]);
> > > > +     *cmd_rc = 0;
> > > > +     kvfree(set_lsa);
> > > > +
> > > > +     return rc;
> > > > +}
> > > > +
> > > > +static int cxl_pmem_nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd,
> > > > +                            void *buf, unsigned int buf_len, int *cmd_rc)
> > > > +{
> > > > +     struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
> > > > +     unsigned long cmd_mask = nvdimm_cmd_mask(nvdimm);
> > > > +     struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> > > > +     struct cxl_mem *cxlm = cxlmd->cxlm;
> > > > +
> > > > +     if (!test_bit(cmd, &cmd_mask))
> > > > +             return -ENOTTY;
> > > > +
> > > > +     switch (cmd) {
> > > > +     case ND_CMD_GET_CONFIG_SIZE:
> > > > +             return cxl_pmem_get_config_size(cxlm, buf, buf_len, cmd_rc);
> > > > +     case ND_CMD_GET_CONFIG_DATA:
> > > > +             return cxl_pmem_get_config_data(cxlm, buf, buf_len, cmd_rc);
> > > > +     case ND_CMD_SET_CONFIG_DATA:
> > > > +             return cxl_pmem_set_config_data(cxlm, buf, buf_len, cmd_rc);
> > > > +     default:
> > > > +             return -ENOTTY;
> > > > +     }
> > > > +}
> > > > +  
> > >
> > > Is there some intended purpose for passing cmd_rc down, if it isn't actually
> > > ever used? Perhaps add it when needed later?  
> > 
> > Ah true, copy-pasta leftovers from other similar routines. I'll clean this up.  
> 
> With that,
> Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
on basis you fixed the one thing I moaned about in v3 :)
