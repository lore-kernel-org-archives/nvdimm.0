Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86C82F26
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 22:52:53 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id z5so16614508plg.8
        for <nvdimm@lists.linux.dev>; Tue, 01 Feb 2022 14:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8kU0XOUT2FjB6HiuChhnBEa47slyR6hjDe4I0/jSHDY=;
        b=ggi2Lw1H6x+MITtgL4Glf59B7IFSw0Pethefh56tsv5qIqUoIVf3OacMDMvL0McC3V
         8Axbe0jU3mdpdFbZ4W1KFnTYKol2n7YwJ6eFvtX9FCN336Ct4ROh7QFrjcngAMVq9nLz
         TecDkzf5805gqBjOQ2l54zc/acquOtjhi1C6aroNjw5SUD120OlUSvWpIvntvJ5a/x5b
         saajTw0GZUVy/Xag/nuImfPdcwOwW39bNNO5QqTb5un2CtrUVvsOrD3ZzYOd5lFD2WdP
         u931kPj+D23IIDts3yI1Si7Rd48805aMINO/NsG8ptHNfS0qdfUU6rCRM0nIzLVJliyG
         ffHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8kU0XOUT2FjB6HiuChhnBEa47slyR6hjDe4I0/jSHDY=;
        b=fFqUdZIyQjJBzkXpXbIz2SQ6TabCjikHuBaMgXlPyPouP+fE/+xnzGCNSmHhmrGZWO
         LX53iVfBA8MQopFi3SMjhZzd176rT8yXP+JVZKVBuUx/F+piDof3H7FGqMw/zb2AKRjp
         LR4+yjVmciYbgZH8ahQ8xP9vNOkk1kfcsHUNgINpQUD7VYg3916Zwu2vLaZKyO2yer23
         W57sKb+KaFvbonp9xMsqmfl9oU+bRZEljuNwAf9UW41nhvsdSxdQUrQrwIqEicuZ3Sz/
         qRLq3ynb2lYXw/nfdu9hVMOLjZ8r7JUKlryYkP3DB+c/XAw2yb8oH1BgFCmfRW2KxGaQ
         HcxA==
X-Gm-Message-State: AOAM531iHY3BVaz7FyHHb2diKJxx/2TdvSB1/K3EuLeExOd5GybvYu8G
	2Q66qQ9fR5VOmvd2ZhzAgcNFH+MyENX6GNt3U931Xw==
X-Google-Smtp-Source: ABdhPJwmBBffwtEJZZ8LKUM52kL53y9UOV9zdX4OrW/si3K/XbRxWKg9FPNI57CpI6to45HBhUgcM8cG/Px9h+B9kec=
X-Received: by 2002:a17:902:b20a:: with SMTP id t10mr27652487plr.132.1643755973230;
 Tue, 01 Feb 2022 14:52:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298426829.3018233.15215948891228582221.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220131182522.000049fb@Huawei.com>
In-Reply-To: <20220131182522.000049fb@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 1 Feb 2022 14:52:46 -0800
Message-ID: <CAPcyv4hXtosNpT9uctf1h_n4yfNzDXiQcYty+Wb+Ymz4ft=R5w@mail.gmail.com>
Subject: Re: [PATCH v3 28/40] cxl/pci: Retrieve CXL DVSEC memory info
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, kernel test robot <lkp@intel.com>, 
	Ben Widawsky <ben.widawsky@intel.com>, Linux PCI <linux-pci@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 31, 2022 at 10:25 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Sun, 23 Jan 2022 16:31:08 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > From: Ben Widawsky <ben.widawsky@intel.com>
> >
> > Before CXL 2.0 HDM Decoder Capability mechanisms can be utilized in a
> > device the driver must determine that the device is ready for CXL.mem
> > operation and that platform firmware, or some other agent, has
> > established an active decode via the legacy CXL 1.1 decoder mechanism.
> >
> > This legacy mechanism is defined in the CXL DVSEC as a set of range
> > registers and status bits that take time to settle after a reset.
> >
> > Validate the CXL memory decode setup via the DVSEC and cache it for
> > later consideration by the cxl_mem driver (to be added). Failure to
> > validate is not fatal to the cxl_pci driver since that is only providing
> > CXL command support over PCI.mmio, and might be needed to rectify CXL
> > DVSEC validation problems.
> >
> > Any potential ranges that the device is already claiming via DVSEC need
> > to be reconciled with the dynamic provisioning ranges provided by
> > platform firmware (like ACPI CEDT.CFMWS). Leave that reconciliation to
> > the cxl_mem driver.
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> > [djbw: clarify changelog]
> > [djbw: shorten defines]
> > [djbw: change precise spin wait to generous msleep]
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> The name change from previous patch wants cleaning up and a few
> more trivial suggestions inline.
>
> Thanks,
>
> Jonathan
>
> > ---
> >  drivers/cxl/cxlmem.h |   18 +++++++-
> >  drivers/cxl/cxlpci.h |   15 ++++++
> >  drivers/cxl/pci.c    |  116 ++++++++++++++++++++++++++++++++++++++++++++++++--
> >  3 files changed, 142 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index cedc6d3c0448..00f55f4066b9 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -89,6 +89,18 @@ struct cxl_mbox_cmd {
> >   */
> >  #define CXL_CAPACITY_MULTIPLIER SZ_256M
> >
> > +/**
> > + * struct cxl_endpoint_dvsec_info - Cached DVSEC info
> > + * @mem_enabled: cached value of mem_enabled in the DVSEC, PCIE_DEVICE
> > + * @ranges: Number of active HDM ranges this device uses.
> > + * @dvsec_range: cached attributes of the ranges in the DVSEC, PCIE_DEVICE
> > + */
> > +struct cxl_endpoint_dvsec_info {
> > +     bool mem_enabled;
> > +     int ranges;
> > +     struct range dvsec_range[2];
> > +};
> > +
> >  /**
> >   * struct cxl_dev_state - The driver device state
> >   *
> > @@ -98,7 +110,7 @@ struct cxl_mbox_cmd {
> >   *
> >   * @dev: The device associated with this CXL state
> >   * @regs: Parsed register blocks
> > - * @device_dvsec: Offset to the PCIe device DVSEC
> > + * @cxl_dvsec: Offset to the PCIe device DVSEC
>
> So soon?  Call it this in the previous patch!

Whoops, yes, rebase mistake.


>
> >   * @payload_size: Size of space for payload
> >   *                (CXL 2.0 8.2.8.4.3 Mailbox Capabilities Register)
> >   * @lsa_size: Size of Label Storage Area
> > @@ -118,6 +130,7 @@ struct cxl_mbox_cmd {
> >   * @next_volatile_bytes: volatile capacity change pending device reset
> >   * @next_persistent_bytes: persistent capacity change pending device reset
> >   * @component_reg_phys: register base of component registers
> > + * @info: Cached DVSEC information about the device.
> >   * @mbox_send: @dev specific transport for transmitting mailbox commands
> >   *
> >   * See section 8.2.9.5.2 Capacity Configuration and Label Storage for
> > @@ -127,7 +140,7 @@ struct cxl_dev_state {
> >       struct device *dev;
> >
> >       struct cxl_regs regs;
> > -     int device_dvsec;
> > +     int cxl_dvsec;
> >
> >       size_t payload_size;
> >       size_t lsa_size;
> > @@ -149,6 +162,7 @@ struct cxl_dev_state {
> >       u64 next_persistent_bytes;
> >
> >       resource_size_t component_reg_phys;
> > +     struct cxl_endpoint_dvsec_info info;
> >
> >       int (*mbox_send)(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd);
> >  };
> > diff --git a/drivers/cxl/cxlpci.h b/drivers/cxl/cxlpci.h
> > index 766de340c4ce..2c29d26af7f8 100644
> > --- a/drivers/cxl/cxlpci.h
> > +++ b/drivers/cxl/cxlpci.h
> > @@ -16,7 +16,20 @@
> >  #define PCI_DVSEC_VENDOR_ID_CXL              0x1E98
> >
> >  /* CXL 2.0 8.1.3: PCIe DVSEC for CXL Device */
> > -#define CXL_DVSEC_PCIE_DEVICE                                        0
> > +#define CXL_DVSEC                    0
> > +#define   CXL_DVSEC_CAP_OFFSET               0xA
> > +#define     CXL_DVSEC_MEM_CAPABLE    BIT(2)
> > +#define     CXL_DVSEC_HDM_COUNT_MASK GENMASK(5, 4)
> > +#define   CXL_DVSEC_CTRL_OFFSET              0xC
> > +#define     CXL_DVSEC_MEM_ENABLE     BIT(2)
> > +#define   CXL_DVSEC_RANGE_SIZE_HIGH(i)       (0x18 + (i * 0x10))
> > +#define   CXL_DVSEC_RANGE_SIZE_LOW(i)        (0x1C + (i * 0x10))
> > +#define     CXL_DVSEC_MEM_INFO_VALID BIT(0)
> > +#define     CXL_DVSEC_MEM_ACTIVE     BIT(1)
> > +#define     CXL_DVSEC_MEM_SIZE_LOW_MASK      GENMASK(31, 28)
> > +#define   CXL_DVSEC_RANGE_BASE_HIGH(i)       (0x20 + (i * 0x10))
> > +#define   CXL_DVSEC_RANGE_BASE_LOW(i)        (0x24 + (i * 0x10))
> > +#define     CXL_DVSEC_MEM_BASE_LOW_MASK      GENMASK(31, 28)
> >
> >  /* CXL 2.0 8.1.4: Non-CXL Function Map DVSEC */
> >  #define CXL_DVSEC_FUNCTION_MAP                                       2
> > diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> > index 76de39b90351..5c43886dc2af 100644
> > --- a/drivers/cxl/pci.c
> > +++ b/drivers/cxl/pci.c
> > @@ -386,6 +386,110 @@ static int cxl_setup_regs(struct pci_dev *pdev, enum cxl_regloc_type type,
> >       return rc;
> >  }
> >
> > +static int wait_for_valid(struct cxl_dev_state *cxlds)
> > +{
> > +     struct pci_dev *pdev = to_pci_dev(cxlds->dev);
> > +     int d = cxlds->cxl_dvsec, rc;
> > +     u32 val;
> > +
> > +     /*
> > +      * Memory_Info_Valid: When set, indicates that the CXL Range 1 Size high
> > +      * and Size Low registers are valid. Must be set within 1 second of
> > +      * deassertion of reset to CXL device. Likely it is already set by the
> > +      * time this runs, but otherwise give a 1.5 second timeout in case of
> > +      * clock skew.
> > +      */
> > +     rc = pci_read_config_dword(pdev, d + CXL_DVSEC_RANGE_SIZE_LOW(0), &val);
> > +     if (rc)
> > +             return rc;
> > +
> > +     if (val & CXL_DVSEC_MEM_INFO_VALID)
> > +             return 0;
> > +
> > +     msleep(1500);
> > +
> > +     rc = pci_read_config_dword(pdev, d + CXL_DVSEC_RANGE_SIZE_LOW(0), &val);
> > +     if (rc)
> > +             return rc;
> > +
> > +     if (val & CXL_DVSEC_MEM_INFO_VALID)
> > +             return 0;
>
> Prefer a blank line here.

Sure.

>
> > +     return -ETIMEDOUT;
> > +}
> > +
> > +static int cxl_dvsec_ranges(struct cxl_dev_state *cxlds)
> > +{
> > +     struct cxl_endpoint_dvsec_info *info = &cxlds->info;
> > +     struct pci_dev *pdev = to_pci_dev(cxlds->dev);
> > +     int d = cxlds->cxl_dvsec;
> > +     int hdm_count, rc, i;
> > +     u16 cap, ctrl;
> > +
> > +     rc = pci_read_config_word(pdev, d + CXL_DVSEC_CAP_OFFSET, &cap);
> > +     if (rc)
> > +             return rc;
>
> trivial but I'd like a blank line here as I find that slightly easier
> to parse after to many code reviews...

Done.

>
> > +     rc = pci_read_config_word(pdev, d + CXL_DVSEC_CTRL_OFFSET, &ctrl);
> > +     if (rc)
> > +             return rc;
> > +
> > +     if (!(cap & CXL_DVSEC_MEM_CAPABLE))
> > +             return -ENXIO;
> > +
> > +     /*
> > +      * It is not allowed by spec for MEM.capable to be set and have 0 HDM
> > +      * decoders. As this driver is for a spec defined class code which must
> > +      * be CXL.mem capable, there is no point in continuing.
>
> Comment should probably also talk about why > 2 not allowed.

Changed to:

        /*
         * It is not allowed by spec for MEM.capable to be set and have 0 legacy
         * HDM decoders (values > 2 are also undefined as of CXL 2.0). As this
         * driver is for a spec defined class code which must be CXL.mem
         * capable, there is no point in continuing to enable CXL.mem.
         */

>
> > +      */
> > +     hdm_count = FIELD_GET(CXL_DVSEC_HDM_COUNT_MASK, cap);
> > +     if (!hdm_count || hdm_count > 2)
> > +             return -EINVAL;
> > +
> > +     rc = wait_for_valid(cxlds);
> > +     if (rc)
> > +             return rc;
> > +
> > +     info->mem_enabled = FIELD_GET(CXL_DVSEC_MEM_ENABLE, ctrl);
> > +
> > +     for (i = 0; i < hdm_count; i++) {
> > +             u64 base, size;
> > +             u32 temp;
> > +
> > +             rc = pci_read_config_dword(
> > +                     pdev, d + CXL_DVSEC_RANGE_SIZE_HIGH(i), &temp);
> > +             if (rc)
> > +                     break;
>
> return rc; would be cleaner for these than break.
> Saves the minor review effort of going to look for what is done in the
> exit path (nothing :)

Done.

I had considered just dropping the error checking altogether since the
PCI core is not this paranoid, but might as well keep it at this
point.

>
> > +             size = (u64)temp << 32;
> > +
> > +             rc = pci_read_config_dword(
> > +                     pdev, d + CXL_DVSEC_RANGE_SIZE_LOW(i), &temp);
> > +             if (rc)
> > +                     break;
> > +             size |= temp & CXL_DVSEC_MEM_SIZE_LOW_MASK;
> > +
> > +             rc = pci_read_config_dword(
> > +                     pdev, d + CXL_DVSEC_RANGE_BASE_HIGH(i), &temp);
> > +             if (rc)
> > +                     break;
> > +             base = (u64)temp << 32;
> > +
> > +             rc = pci_read_config_dword(
> > +                     pdev, d + CXL_DVSEC_RANGE_BASE_LOW(i), &temp);
> > +             if (rc)
> > +                     break;
> > +             base |= temp & CXL_DVSEC_MEM_BASE_LOW_MASK;
> > +
> > +             info->dvsec_range[i] = (struct range) {
> > +                     .start = base,
> > +                     .end = base + size - 1
> > +             };
> > +
> > +             if (size)
> > +                     info->ranges++;
> > +     }
> > +
> > +     return rc;
> > +}
> > +
> >  static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >  {
> >       struct cxl_register_map map;
> > @@ -408,10 +512,9 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >       if (IS_ERR(cxlds))
> >               return PTR_ERR(cxlds);
> >
> > -     cxlds->device_dvsec = pci_find_dvsec_capability(pdev,
> > -                                                     PCI_DVSEC_VENDOR_ID_CXL,
> > -                                                     CXL_DVSEC_PCIE_DEVICE);
> > -     if (!cxlds->device_dvsec) {
> > +     cxlds->cxl_dvsec = pci_find_dvsec_capability(
> > +             pdev, PCI_DVSEC_VENDOR_ID_CXL, CXL_DVSEC);
> > +     if (!cxlds->cxl_dvsec) {
>
> I'm guessing a rebase went astray given this only came in one patch earlier.

Yes, sorry about that.

>
> >               dev_err(&pdev->dev,
> >                       "Device DVSEC not present. Expect limited functionality.\n");
> >               return -ENXIO;
> > @@ -452,6 +555,11 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >       if (rc)
> >               return rc;
> >
> > +     rc = cxl_dvsec_ranges(cxlds);
> > +     if (rc)
> > +             dev_err(&pdev->dev,
> > +                     "Failed to get DVSEC range information (%d)\n", rc);
> > +
> >       cxlmd = devm_cxl_add_memdev(cxlds);
> >       if (IS_ERR(cxlmd))
> >               return PTR_ERR(cxlmd);
> >
>
