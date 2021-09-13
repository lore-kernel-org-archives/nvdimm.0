Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDB63FD0
	for <nvdimm@lists.linux.dev>; Mon, 13 Sep 2021 23:46:59 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id m21-20020a17090a859500b00197688449c4so1352087pjn.0
        for <nvdimm@lists.linux.dev>; Mon, 13 Sep 2021 16:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8TwvnoN+pGz8Jz4tiU+XiCifdS6QZ/bX9QO88qy6Wek=;
        b=BN+ZyvmBBtE3LjudbZ6koqrBvuaCSN5gath3LrWLF6cdLUm+LaPNLipztkbS5Sg64+
         7DCOTwZ2u7SYaCMg2ZPgN8maJ2+fJrg5mOlYUJ1Dcd6EPIdR2VSaLtjcCtgPnRe1ZWei
         DO3ZBjGgdF4WdnIBRUOzad3o702vX1RlEFaANhTG2M3bco+IG7FmM2F8SCl8TwuEpDzZ
         npNCKn47IliylZGLFBDxQPTv1aFVgyALWuOaDylF27VzyB/cV8cTJ0Gx4+Os0wg212Gl
         pW8XnDUyvn2TenMsYKatqbErmDrSQHbKacopnG/fE01KUDrXx6eJFGUQdATUwpgIy8ln
         CeAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8TwvnoN+pGz8Jz4tiU+XiCifdS6QZ/bX9QO88qy6Wek=;
        b=UUgXreJrc9qV8RTpYpUr2xIvJdAw3ylZYMUbZWJxa/gIhtOQbLSBTAMTAdwflEV7Md
         wC3BLmfry5Bmex6x1U4+kHsBsCXVYotrBx21i5N5c2d8PsfnwStDxYvh6aCeFuEVJT+s
         /h6l646S9gE8ntCQA6vm2uJnuaNp0rxAZdkTIjNKX+diZEEg7QVzMbNB7Il0mzYOEwhX
         wgTVEo1T2Hfw5OnOoI+z1RxYpNB0F3wGLxzeAv1LodF99UM47pACgWBMwO5mj5XZeIIW
         +wneLJFYGyT6C4lul8Ub7JE8tBKBFZBXeUcd/uqm3wNaVxKm7J8hIqIcvDaM81of9MhH
         MZwQ==
X-Gm-Message-State: AOAM532iPsRKGACFA7zFMS+TNJC5iyt4RkPUv0D7DuIvZJ6sbU6Nmut5
	KmB2NpBNMg5Ktr2+l+INSvK8EN32ZnfQAJzs6KxNPA==
X-Google-Smtp-Source: ABdhPJwToQdeP+BcPUZeIxgU+0bGGvuuyhVkfJEMWwY5W6ICCD8SF4+LEoTFb7WED8QU2QNzPojMRyBhi4yoYZ6nswU=
X-Received: by 2002:a17:90a:d686:: with SMTP id x6mr2342419pju.8.1631576818483;
 Mon, 13 Sep 2021 16:46:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163116436926.2460985.1268688593156766623.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210910103348.00005b5c@Huawei.com>
In-Reply-To: <20210910103348.00005b5c@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 13 Sep 2021 16:46:47 -0700
Message-ID: <CAPcyv4i48AHtHOAJVsDKQ+Zg2QqnvQg1Ur8ekb6qR6cRDbkAzQ@mail.gmail.com>
Subject: Re: [PATCH v4 14/21] cxl/mbox: Add exclusive kernel command support
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	"Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Sep 10, 2021 at 2:34 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Wed, 8 Sep 2021 22:12:49 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > The CXL_PMEM driver expects exclusive control of the label storage area
> > space. Similar to the LIBNVDIMM expectation that the label storage area
> > is only writable from userspace when the corresponding memory device is
> > not active in any region, the expectation is the native CXL_PCI UAPI
> > path is disabled while the cxl_nvdimm for a given cxl_memdev device is
> > active in LIBNVDIMM.
> >
> > Add the ability to toggle the availability of a given command for the
> > UAPI path. Use that new capability to shutdown changes to partitions and
> > the label storage area while the cxl_nvdimm device is actively proxying
> > commands for LIBNVDIMM.
> >
> > Acked-by: Ben Widawsky <ben.widawsky@intel.com>
> > Link: https://lore.kernel.org/r/162982123298.1124374.22718002900700392.stgit@dwillia2-desk3.amr.corp.intel.com
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> In the ideal world I'd like to have seen this as a noop patch going from devm
> to non devm for cleanup followed by new stuff.  meh, the world isn't ideal
> and all that sort of nice stuff takes time!

It would also require a series resend since I can't use the in-place
update in a way that b4 will recognize.

> Whilst I'm not that keen on the exact form of the code in probe() it will
> be easier to read when not a diff so if you prefer to keep it as you have
> it I won't object - it just took a little more careful reading than I'd like.

I circled back to devm after taking out the cleverness as you noted,
and that makes the patch more readable.

>
> Thanks,
>
> Jonathan
>
>
> > ---
> >  drivers/cxl/core/mbox.c   |    5 +++++
> >  drivers/cxl/core/memdev.c |   31 +++++++++++++++++++++++++++++++
> >  drivers/cxl/cxlmem.h      |    4 ++++
> >  drivers/cxl/pmem.c        |   43 ++++++++++++++++++++++++++++++++-----------
> >  4 files changed, 72 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 422999740649..82e79da195fa 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -221,6 +221,7 @@ static bool cxl_mem_raw_command_allowed(u16 opcode)
> >   *  * %-EINVAL       - Reserved fields or invalid values were used.
> >   *  * %-ENOMEM       - Input or output buffer wasn't sized properly.
> >   *  * %-EPERM        - Attempted to use a protected command.
> > + *  * %-EBUSY        - Kernel has claimed exclusive access to this opcode
> >   *
> >   * The result of this command is a fully validated command in @out_cmd that is
> >   * safe to send to the hardware.
> > @@ -296,6 +297,10 @@ static int cxl_validate_cmd_from_user(struct cxl_mem *cxlm,
> >       if (!test_bit(info->id, cxlm->enabled_cmds))
> >               return -ENOTTY;
> >
> > +     /* Check that the command is not claimed for exclusive kernel use */
> > +     if (test_bit(info->id, cxlm->exclusive_cmds))
> > +             return -EBUSY;
> > +
> >       /* Check the input buffer is the expected size */
> >       if (info->size_in >= 0 && info->size_in != send_cmd->in.size)
> >               return -ENOMEM;
> > diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> > index df2ba87238c2..d9ade5b92330 100644
> > --- a/drivers/cxl/core/memdev.c
> > +++ b/drivers/cxl/core/memdev.c
> > @@ -134,6 +134,37 @@ static const struct device_type cxl_memdev_type = {
> >       .groups = cxl_memdev_attribute_groups,
> >  };
> >
> > +/**
> > + * set_exclusive_cxl_commands() - atomically disable user cxl commands
> > + * @cxlm: cxl_mem instance to modify
> > + * @cmds: bitmap of commands to mark exclusive
> > + *
> > + * Flush the ioctl path and disable future execution of commands with
> > + * the command ids set in @cmds.
>
> It's not obvious this function is doing that 'flush', Perhaps consider rewording?

Changed it to:

"Grab the cxl_memdev_rwsem in write mode to flush in-flight
invocations of the ioctl path and then disable future execution of
commands with the command ids set in @cmds."

>
> > + */
> > +void set_exclusive_cxl_commands(struct cxl_mem *cxlm, unsigned long *cmds)
> > +{
> > +     down_write(&cxl_memdev_rwsem);
> > +     bitmap_or(cxlm->exclusive_cmds, cxlm->exclusive_cmds, cmds,
> > +               CXL_MEM_COMMAND_ID_MAX);
> > +     up_write(&cxl_memdev_rwsem);
> > +}
> > +EXPORT_SYMBOL_GPL(set_exclusive_cxl_commands);
> > +
> > +/**
> > + * clear_exclusive_cxl_commands() - atomically enable user cxl commands
> > + * @cxlm: cxl_mem instance to modify
> > + * @cmds: bitmap of commands to mark available for userspace
> > + */
> > +void clear_exclusive_cxl_commands(struct cxl_mem *cxlm, unsigned long *cmds)
> > +{
> > +     down_write(&cxl_memdev_rwsem);
> > +     bitmap_andnot(cxlm->exclusive_cmds, cxlm->exclusive_cmds, cmds,
> > +                   CXL_MEM_COMMAND_ID_MAX);
> > +     up_write(&cxl_memdev_rwsem);
> > +}
> > +EXPORT_SYMBOL_GPL(clear_exclusive_cxl_commands);
> > +
> >  static void cxl_memdev_shutdown(struct device *dev)
> >  {
> >       struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index 16201b7d82d2..468b7b8be207 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -101,6 +101,7 @@ struct cxl_mbox_cmd {
> >   * @mbox_mutex: Mutex to synchronize mailbox access.
> >   * @firmware_version: Firmware version for the memory device.
> >   * @enabled_cmds: Hardware commands found enabled in CEL.
> > + * @exclusive_cmds: Commands that are kernel-internal only
> >   * @pmem_range: Active Persistent memory capacity configuration
> >   * @ram_range: Active Volatile memory capacity configuration
> >   * @total_bytes: sum of all possible capacities
> > @@ -127,6 +128,7 @@ struct cxl_mem {
> >       struct mutex mbox_mutex; /* Protects device mailbox and firmware */
> >       char firmware_version[0x10];
> >       DECLARE_BITMAP(enabled_cmds, CXL_MEM_COMMAND_ID_MAX);
> > +     DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
> >
> >       struct range pmem_range;
> >       struct range ram_range;
> > @@ -200,4 +202,6 @@ int cxl_mem_identify(struct cxl_mem *cxlm);
> >  int cxl_mem_enumerate_cmds(struct cxl_mem *cxlm);
> >  int cxl_mem_create_range_info(struct cxl_mem *cxlm);
> >  struct cxl_mem *cxl_mem_create(struct device *dev);
> > +void set_exclusive_cxl_commands(struct cxl_mem *cxlm, unsigned long *cmds);
> > +void clear_exclusive_cxl_commands(struct cxl_mem *cxlm, unsigned long *cmds);
> >  #endif /* __CXL_MEM_H__ */
> > diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> > index 9652c3ee41e7..a972af7a6e0b 100644
> > --- a/drivers/cxl/pmem.c
> > +++ b/drivers/cxl/pmem.c
> > @@ -16,10 +16,7 @@
> >   */
> >  static struct workqueue_struct *cxl_pmem_wq;
> >
> > -static void unregister_nvdimm(void *nvdimm)
> > -{
> > -     nvdimm_delete(nvdimm);
> > -}
> > +static __read_mostly DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
> >
> >  static int match_nvdimm_bridge(struct device *dev, const void *data)
> >  {
> > @@ -36,12 +33,25 @@ static struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void)
> >       return to_cxl_nvdimm_bridge(dev);
> >  }
> >
> > +static void cxl_nvdimm_remove(struct device *dev)
> > +{
> > +     struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
> > +     struct nvdimm *nvdimm = dev_get_drvdata(dev);
> > +     struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> > +     struct cxl_mem *cxlm = cxlmd->cxlm;
>
> Given cxlmd isn't used, perhaps combine the two lines above?

...gone with the return of devm.

>
> > +
> > +     nvdimm_delete(nvdimm);
> > +     clear_exclusive_cxl_commands(cxlm, exclusive_cmds);
> > +}
> > +
> >  static int cxl_nvdimm_probe(struct device *dev)
> >  {
> >       struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
> > +     struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> > +     struct cxl_mem *cxlm = cxlmd->cxlm;
>
> Again, clxmd not used so could save a line of code
> without loosing anything (unless it get used in a later patch of
> course!)

It is used... to grab cxlm, but it's an arbitrary style preference to
avoid de-reference chains longer than one. However, since I'm only
doing it once now perhaps you'll grant me this indulgence?

>
> >       struct cxl_nvdimm_bridge *cxl_nvb;
> > +     struct nvdimm *nvdimm = NULL;
> >       unsigned long flags = 0;
> > -     struct nvdimm *nvdimm;
> >       int rc = -ENXIO;
> >
> >       cxl_nvb = cxl_find_nvdimm_bridge();
> > @@ -50,25 +60,32 @@ static int cxl_nvdimm_probe(struct device *dev)
> >
> >       device_lock(&cxl_nvb->dev);
> >       if (!cxl_nvb->nvdimm_bus)
> > -             goto out;
> > +             goto out_unlock;
> > +
> > +     set_exclusive_cxl_commands(cxlm, exclusive_cmds);
> >
> >       set_bit(NDD_LABELING, &flags);
> > +     rc = -ENOMEM;
>
> Hmm. Setting rc to an error value even in the good path is a bit
> unusual.  I'd just add the few lines to set rc = -ENXIO only in the error
> path above and
> rc = -ENOMEM here only if nvdimm_create fails.
>
> What you have strikes me as a bit too clever :)

Agree, and devm slots in nicely again with that removed.
