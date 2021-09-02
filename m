Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C46172
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 17:34:52 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso1990748pjq.4
        for <nvdimm@lists.linux.dev>; Thu, 02 Sep 2021 10:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sxHy1Ki0umGtMNdW2SxanwkuzfBYs4r/jp8yCKul01A=;
        b=Lf+PGmfOQazocNaYQkV88AWRb9BrW60NN0XKTPNoRhEuY2U7hUOAO1KZ8zcX0IrtXp
         PrXRPMz9W7h5UVtPySRWCDhtVUUOTBu0Tjc28h00KhyOpNLOdPJGLoDIV1yyKnrfowMg
         mM+/6AbaMh85dp6GWlvR1kp6Sx/8EnhwnEVZAnXio7UtYzepW+GCiIALLphPEilnRNgR
         Cb1ZuyRuxc/mfYvL6n0wDWxiSU7CbcokQojEAsIuYujLFLh/xCFVUgMfH1EMkENjJ0VS
         D7GVWHcv0Tga4vl7uUbRnwVXMlXIBfPdB2f1u7vD0M4vvFblrJ7IlsKWrrSsETcMCGw0
         4sGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sxHy1Ki0umGtMNdW2SxanwkuzfBYs4r/jp8yCKul01A=;
        b=dBbwhitObFtLqyp3pYT13qHQ5834Bghhjd/3G6mRiMuw66aff0C9MdNfUaqhj2PKCN
         JDq+pLV/I/3oUSWHGiX1xXe8j5bZKIL3ckNFtiEMqLtOckhEVl5Ni+cwU7oyYCcSfbdN
         U4ee0o+hHsn9GQXQQ+yS3AualCswWsXMkdNNQIaPMe9lp08VyWV7lWtFlcnPbIE0X1ey
         0eGrbTR7htAiHakzpl08Zm8GCR8b6v9+rdHonADP3Vct04XJmvegyl7TEuO7aoY2rawW
         8cmYR7Rx9kEDRkh7+treQzPn7sC3lhyYuSaGmWhVe8QYCNN1Q9Cxv9PoEC2wjMPD+Ubh
         u+YA==
X-Gm-Message-State: AOAM532BP79ATsRcM6RCSBcabM+Zz4BSIX/oo2SkpRwSxsjD5jKNp9Tm
	kIWXknT9IK54QTpMQvCdA1d5amS0eiNOmrqNlbMlbQ==
X-Google-Smtp-Source: ABdhPJxL8L98/fmfDSFos0KiWqTEIKfeK2zDWySgMx87CVFNpn868pw9OnMkyYQLIRmYjk0jOHWVsxZzc13WURsLKFA=
X-Received: by 2002:a17:90a:2f23:: with SMTP id s32mr5074777pjd.168.1630604091430;
 Thu, 02 Sep 2021 10:34:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162982120696.1124374.11635718440690909189.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210902175559.00005da7@Huawei.com>
In-Reply-To: <20210902175559.00005da7@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 2 Sep 2021 10:34:40 -0700
Message-ID: <CAPcyv4jixb0A1cwUdRFb4bmqDfr2mx_C4k+dPvjRL5LmpXC3+g@mail.gmail.com>
Subject: Re: [PATCH v3 15/28] cxl/pci: Make 'struct cxl_mem' device type generic
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 2, 2021 at 9:56 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Tue, 24 Aug 2021 09:06:47 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > In preparation for adding a unit test provider of a cxl_memdev, convert
> > the 'struct cxl_mem' driver context to carry a generic device rather
> > than a pci device.
> >
> > Note, some dev_dbg() lines needed extra reformatting per clang-format.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > Acked-by: Ben Widawsky <ben.widawsky@intel.com>
>
> Hi Dan,
>
> Whilst it is obviously functionally correct, this had ended up places where
> it goes form cxlm to dev to pci_dev to dev which is a bit messy.
>
> Some places have it done the the more elegant form where we always
> get the dev from the cxlm and the pci_dev form the dev
> (and don't go back the other way).
>
> Jonathan
>
>
> > ---
> >  drivers/cxl/core/memdev.c |    3 +-
> >  drivers/cxl/cxlmem.h      |    4 ++-
> >  drivers/cxl/pci.c         |   60 ++++++++++++++++++++++-----------------------
> >  3 files changed, 32 insertions(+), 35 deletions(-)
> >
> > diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> > index a9c317e32010..40789558f8c2 100644
> > --- a/drivers/cxl/core/memdev.c
> > +++ b/drivers/cxl/core/memdev.c
> > @@ -149,7 +149,6 @@ static void cxl_memdev_unregister(void *_cxlmd)
> >  static struct cxl_memdev *cxl_memdev_alloc(struct cxl_mem *cxlm,
> >                                          const struct file_operations *fops)
> >  {
> > -     struct pci_dev *pdev = cxlm->pdev;
> >       struct cxl_memdev *cxlmd;
> >       struct device *dev;
> >       struct cdev *cdev;
> > @@ -166,7 +165,7 @@ static struct cxl_memdev *cxl_memdev_alloc(struct cxl_mem *cxlm,
> >
> >       dev = &cxlmd->dev;
> >       device_initialize(dev);
> > -     dev->parent = &pdev->dev;
> > +     dev->parent = cxlm->dev;
> >       dev->bus = &cxl_bus_type;
> >       dev->devt = MKDEV(cxl_mem_major, cxlmd->id);
> >       dev->type = &cxl_memdev_type;
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index 6c0b1e2ea97c..8397daea9d9b 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -68,7 +68,7 @@ devm_cxl_add_memdev(struct device *host, struct cxl_mem *cxlm,
> >
> >  /**
> >   * struct cxl_mem - A CXL memory device
> > - * @pdev: The PCI device associated with this CXL device.
> > + * @dev: The device associated with this CXL device.
> >   * @cxlmd: Logical memory device chardev / interface
> >   * @regs: Parsed register blocks
> >   * @payload_size: Size of space for payload
> > @@ -82,7 +82,7 @@ devm_cxl_add_memdev(struct device *host, struct cxl_mem *cxlm,
> >   * @ram_range: Volatile memory capacity information.
> >   */
> >  struct cxl_mem {
> > -     struct pci_dev *pdev;
> > +     struct device *dev;
> >       struct cxl_memdev *cxlmd;
> >
> >       struct cxl_regs regs;
> > diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> > index 651e8d4ec974..24d84b69227a 100644
> > --- a/drivers/cxl/pci.c
> > +++ b/drivers/cxl/pci.c
> > @@ -250,7 +250,7 @@ static int cxl_mem_wait_for_doorbell(struct cxl_mem *cxlm)
> >               cpu_relax();
> >       }
> >
> > -     dev_dbg(&cxlm->pdev->dev, "Doorbell wait took %dms",
> > +     dev_dbg(cxlm->dev, "Doorbell wait took %dms",
> >               jiffies_to_msecs(end) - jiffies_to_msecs(start));
> >       return 0;
> >  }
> > @@ -268,7 +268,7 @@ static bool cxl_is_security_command(u16 opcode)
> >  static void cxl_mem_mbox_timeout(struct cxl_mem *cxlm,
> >                                struct mbox_cmd *mbox_cmd)
> >  {
> > -     struct device *dev = &cxlm->pdev->dev;
> > +     struct device *dev = cxlm->dev;
> >
> >       dev_dbg(dev, "Mailbox command (opcode: %#x size: %zub) timed out\n",
> >               mbox_cmd->opcode, mbox_cmd->size_in);
> > @@ -300,6 +300,7 @@ static int __cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm,
> >                                  struct mbox_cmd *mbox_cmd)
> >  {
> >       void __iomem *payload = cxlm->regs.mbox + CXLDEV_MBOX_PAYLOAD_OFFSET;
> > +     struct device *dev = cxlm->dev;
> >       u64 cmd_reg, status_reg;
> >       size_t out_len;
> >       int rc;
> > @@ -325,8 +326,7 @@ static int __cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm,
> >
> >       /* #1 */
> >       if (cxl_doorbell_busy(cxlm)) {
> > -             dev_err_ratelimited(&cxlm->pdev->dev,
> > -                                 "Mailbox re-busy after acquiring\n");
> > +             dev_err_ratelimited(dev, "Mailbox re-busy after acquiring\n");
> >               return -EBUSY;
> >       }
> >
> > @@ -345,7 +345,7 @@ static int __cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm,
> >       writeq(cmd_reg, cxlm->regs.mbox + CXLDEV_MBOX_CMD_OFFSET);
> >
> >       /* #4 */
> > -     dev_dbg(&cxlm->pdev->dev, "Sending command\n");
> > +     dev_dbg(dev, "Sending command\n");
> >       writel(CXLDEV_MBOX_CTRL_DOORBELL,
> >              cxlm->regs.mbox + CXLDEV_MBOX_CTRL_OFFSET);
> >
> > @@ -362,7 +362,7 @@ static int __cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm,
> >               FIELD_GET(CXLDEV_MBOX_STATUS_RET_CODE_MASK, status_reg);
> >
> >       if (mbox_cmd->return_code != 0) {
> > -             dev_dbg(&cxlm->pdev->dev, "Mailbox operation had an error\n");
> > +             dev_dbg(dev, "Mailbox operation had an error\n");
> >               return 0;
> >       }
> >
> > @@ -399,7 +399,7 @@ static int __cxl_mem_mbox_send_cmd(struct cxl_mem *cxlm,
> >   */
> >  static int cxl_mem_mbox_get(struct cxl_mem *cxlm)
> >  {
> > -     struct device *dev = &cxlm->pdev->dev;
> > +     struct device *dev = cxlm->dev;
> >       u64 md_status;
> >       int rc;
> >
> > @@ -502,7 +502,7 @@ static int handle_mailbox_cmd_from_user(struct cxl_mem *cxlm,
> >                                       u64 in_payload, u64 out_payload,
> >                                       s32 *size_out, u32 *retval)
> >  {
> > -     struct device *dev = &cxlm->pdev->dev;
> > +     struct device *dev = cxlm->dev;
> >       struct mbox_cmd mbox_cmd = {
> >               .opcode = cmd->opcode,
> >               .size_in = cmd->info.size_in,
> > @@ -925,12 +925,12 @@ static int cxl_mem_setup_mailbox(struct cxl_mem *cxlm)
> >        */
> >       cxlm->payload_size = min_t(size_t, cxlm->payload_size, SZ_1M);
> >       if (cxlm->payload_size < 256) {
> > -             dev_err(&cxlm->pdev->dev, "Mailbox is too small (%zub)",
> > +             dev_err(cxlm->dev, "Mailbox is too small (%zub)",
> >                       cxlm->payload_size);
> >               return -ENXIO;
> >       }
> >
> > -     dev_dbg(&cxlm->pdev->dev, "Mailbox payload sized %zu",
> > +     dev_dbg(cxlm->dev, "Mailbox payload sized %zu",
> >               cxlm->payload_size);
> >
> >       return 0;
> > @@ -948,7 +948,7 @@ static struct cxl_mem *cxl_mem_create(struct pci_dev *pdev)
> >       }
> >
> >       mutex_init(&cxlm->mbox_mutex);
> > -     cxlm->pdev = pdev;
> > +     cxlm->dev = dev;
> >       cxlm->enabled_cmds =
> >               devm_kmalloc_array(dev, BITS_TO_LONGS(cxl_cmd_count),
> >                                  sizeof(unsigned long),
> > @@ -964,9 +964,9 @@ static struct cxl_mem *cxl_mem_create(struct pci_dev *pdev)
> >  static void __iomem *cxl_mem_map_regblock(struct cxl_mem *cxlm,
> >                                         u8 bar, u64 offset)
> >  {
> > -     struct pci_dev *pdev = cxlm->pdev;
> > -     struct device *dev = &pdev->dev;
> >       void __iomem *addr;
> > +     struct device *dev = cxlm->dev;
> > +     struct pci_dev *pdev = to_pci_dev(dev);
> >
> >       /* Basic sanity check that BAR is big enough */
> >       if (pci_resource_len(pdev, bar) < offset) {
> > @@ -989,7 +989,7 @@ static void __iomem *cxl_mem_map_regblock(struct cxl_mem *cxlm,
> >
> >  static void cxl_mem_unmap_regblock(struct cxl_mem *cxlm, void __iomem *base)
> >  {
> > -     pci_iounmap(cxlm->pdev, base);
> > +     pci_iounmap(to_pci_dev(cxlm->dev), base);
> >  }
> >
> >  static int cxl_mem_dvsec(struct pci_dev *pdev, int dvsec)
> > @@ -1018,7 +1018,7 @@ static int cxl_mem_dvsec(struct pci_dev *pdev, int dvsec)
> >  static int cxl_probe_regs(struct cxl_mem *cxlm, void __iomem *base,
> >                         struct cxl_register_map *map)
> >  {
> > -     struct pci_dev *pdev = cxlm->pdev;
> > +     struct pci_dev *pdev = to_pci_dev(cxlm->dev);
> >       struct device *dev = &pdev->dev;
>
> As below.
>
> >       struct cxl_component_reg_map *comp_map;
> >       struct cxl_device_reg_map *dev_map;
> > @@ -1057,7 +1057,7 @@ static int cxl_probe_regs(struct cxl_mem *cxlm, void __iomem *base,
> >
> >  static int cxl_map_regs(struct cxl_mem *cxlm, struct cxl_register_map *map)
> >  {
> > -     struct pci_dev *pdev = cxlm->pdev;
> > +     struct pci_dev *pdev = to_pci_dev(cxlm->dev);
> >       struct device *dev = &pdev->dev;
>
> That's going in circles.

Indeed, silly.

>
> struct device *dev = cxlm->dev;
> struct pci_dev *pdev = to_pci_dev(dev);
>
> or if you want to to maintain the order
> struct device *dev = clxm->dev;
> Also inconsistent with how you do it in
> cxl_mem_map_regblock()
>
> >
> >       switch (map->reg_type) {
> > @@ -1096,8 +1096,8 @@ static void cxl_decode_register_block(u32 reg_lo, u32 reg_hi,
> >   */
> >  static int cxl_mem_setup_regs(struct cxl_mem *cxlm)
> >  {
> > -     struct pci_dev *pdev = cxlm->pdev;
> > -     struct device *dev = &pdev->dev;
> > +     struct pci_dev *pdev = to_pci_dev(cxlm->dev);
> > +     struct device *dev = cxlm->dev;
>
> Trivial:
> Seems a bit odd to not reorder these two and have
> struct pci_dev *pdev = to_pci_dev(dev);

Agree, I'll create an incremental fixup.
