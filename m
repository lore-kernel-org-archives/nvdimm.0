Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDAB70
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 01:22:38 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id g12-20020a17090a7d0cb0290178f80de3d8so1914577pjl.2
        for <nvdimm@lists.linux.dev>; Tue, 10 Aug 2021 18:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4ZyGWWIIGp4ZeuUw+9jMqmcqoBt/aeDCHeXTO92s0/E=;
        b=fNK+U73QPEYUJnY6Vq5bJjARQRQyctWql7eKvKuEGLpvazbimajco0QQE5WXOrp3CW
         DTb+SM2ylMXxfkWoFqgKLh7A3Ux0v9AJMatMXcxSurbA+oUySipUkai4i2gNswUx/Ned
         OmbD1+Vjw/ad3sAaAsnGG9CoAS/GoM1cqHevMJ6V0ha6IvZ5h4daIfROcDtxnxZk9SE2
         xBT5loBVsHAoAKnenesdv3q1x5AP59GG6hCqgw1MsQbPkwgN0mx7FgCO1OMgGuxvv3SL
         bTfq52s2qXmfwpk2gXUFkyKeRagFPQiyDOjTdF/W+dhrDLej5H6ts2yT4NBNXXTDFS/Y
         1PBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4ZyGWWIIGp4ZeuUw+9jMqmcqoBt/aeDCHeXTO92s0/E=;
        b=L9GjricVuk6Iuyo95ss/sChphL7LLVrP5y6XAhvzOXpDRPCW96QC/AwZSFfj/K90SA
         lw9UXWs6veg7YkpDUNH5481psBNgBXHEdlQbWjRiHJRA7/Btcm4KaM2t0UeH7jo4VzVd
         32tsruNGPF+5fUuKGKi1EkzfdHAKWrltmILX9pmTXDDjCNEujOUHn1Rv8exdcy9Xz8H+
         ty573Y9XeXxDRWuuEUpie7ZeKA2/MQwos6jsV21jHkY0l6gRA3Ta/glLy22xl1gsxznP
         0+typEuz1Njef7tNQIg2b/qHte90/EReRNIwnXXYLK6dHjBljZy6rtkq3ZTalgzlb9EW
         xH0Q==
X-Gm-Message-State: AOAM533ZyU3aRj7kxlzT3Q0U5Z0ogdGovRjcyQzoIuxWwrsMctzorzzQ
	OBBF1yhXfB40VD5R4SZYiMSWZRmr9jskQVo5j7WKaw==
X-Google-Smtp-Source: ABdhPJzTiFtrnCC1j2LlytwivVerTN4cAXmY0Ok34P6lKEygTy2ZloN2aSt1myzAs5168TOjRY00Lij0MYUtDfN2M/s=
X-Received: by 2002:a17:90b:23d6:: with SMTP id md22mr7632069pjb.149.1628644958285;
 Tue, 10 Aug 2021 18:22:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162854815819.1980150.14391324052281496748.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210810213459.5zpvfrvbo2rztwmc@intel.com> <CAPcyv4iXZpeahdDxyRLd7ACS6vpV+VA3-J3MiLQvvV2Q6asBFg@mail.gmail.com>
 <20210810220654.nztok7mxvjzaizhk@intel.com>
In-Reply-To: <20210810220654.nztok7mxvjzaizhk@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Aug 2021 18:22:27 -0700
Message-ID: <CAPcyv4iLLPR+yijKNHceEKM4+fKQ4i6r+ZLYH+_b-ao6tznHLQ@mail.gmail.com>
Subject: Re: [PATCH 17/23] cxl/mbox: Add exclusive kernel command support
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	"Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 10, 2021 at 3:07 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 21-08-10 14:52:18, Dan Williams wrote:
> > On Tue, Aug 10, 2021 at 2:35 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
> > >
> > > On 21-08-09 15:29:18, Dan Williams wrote:
> > > > The CXL_PMEM driver expects exclusive control of the label storage area
> > > > space. Similar to the LIBNVDIMM expectation that the label storage area
> > > > is only writable from userspace when the corresponding memory device is
> > > > not active in any region, the expectation is the native CXL_PCI UAPI
> > > > path is disabled while the cxl_nvdimm for a given cxl_memdev device is
> > > > active in LIBNVDIMM.
> > > >
> > > > Add the ability to toggle the availability of a given command for the
> > > > UAPI path. Use that new capability to shutdown changes to partitions and
> > > > the label storage area while the cxl_nvdimm device is actively proxying
> > > > commands for LIBNVDIMM.
> > > >
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > > ---
> > > >  drivers/cxl/core/mbox.c |    5 +++++
> > > >  drivers/cxl/cxlmem.h    |    2 ++
> > > >  drivers/cxl/pmem.c      |   35 +++++++++++++++++++++++++++++------
> > > >  3 files changed, 36 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > > > index 23100231e246..f26962d7cb65 100644
> > > > --- a/drivers/cxl/core/mbox.c
> > > > +++ b/drivers/cxl/core/mbox.c
> > > > @@ -409,6 +409,11 @@ static int handle_mailbox_cmd_from_user(struct cxl_mem *cxlm,
> > > >               }
> > > >       }
> > > >
> > > > +     if (test_bit(cmd->info.id, cxlm->exclusive_cmds)) {
> > > > +             rc = -EBUSY;
> > > > +             goto out;
> > > > +     }
> > > > +
> > >
> > > This breaks our current definition for cxl_raw_allow_all. All the test machinery
> >
> > That's deliberate; this exclusion is outside of the raw policy. I
> > don't think raw_allow_all should override kernel self protection of
> > data structures, like labels, that it needs to maintain consistency.
> > If userspace wants to use raw_allow_all to send LSA manipulation
> > commands it must do so while the device is not active on the nvdimm
> > side of the house. You'll see that:
> >
> > ndctl disable-region all
> > <mutate labels>
> > ndctl enable-region all
> >
> > ...is a common pattern from custom label update flows.
> >
>
> I won't argue about raw_allow_all since we never did document its debugfs
> meaning (however, my intention was always to let userspace trump the kernel
> (which was why we tainted)).

Yeah we should document because the taint in my mind was for the
possibility of passing commands completely unknown to the kernel. If
someone really wants to subvert the kernel's label area coherency they
could simply have a vendor specific command that writes the labels.
Instead, if the kernel knows the opcode it is free to apply policy to
it as it sees fit, and if the opcode is unknown to the kernel then
raw_allow_all policy lets it through. We already have security
commands as another case of opcode that the kernel knows about and
thinks is a good idea to block. This is a dynamic version of the same.

> Either way, could you please move the actual check to
> cxl_validate_cmd_from_user() instead of handle...(). Validate is the main
> function to determine whether a command is allowed to be sent on behalf of the
> user.  I think just putting it next to the enabled cmd check would make a lot
> more sense. And please add the EBUSY meaning to the kdocs.

Sure, sounds good.

>
> > > for whether a command can be submitted was supposed to happen in
> > > cxl_validate_cmd_from_user(). Various versions of the original patches made
> > > cxl_mem_raw_command_allowed() grow more intelligence (ie. more than just the
> > > opcode). I think this check belongs there with more intelligence.
> > >
> > > I don't love the EBUSY because it already had a meaning for concurrent use of
> > > the mailbox, but I can't think of a better errno.
> >
> > It's the existing errno that happens from nvdimm land when the kernel
> > owns the label area, so it would be confusing to invent a new one for
> > the same behavior now:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/nvdimm/bus.c#n1013
> >
> > >
> > > >       dev_dbg(dev,
> > > >               "Submitting %s command for user\n"
> > > >               "\topcode: %x\n"
> > > > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > > > index df4f3636a999..f6cfe84a064c 100644
> > > > --- a/drivers/cxl/cxlmem.h
> > > > +++ b/drivers/cxl/cxlmem.h
> > > > @@ -102,6 +102,7 @@ struct cxl_mbox_cmd {
> > > >   * @mbox_mutex: Mutex to synchronize mailbox access.
> > > >   * @firmware_version: Firmware version for the memory device.
> > > >   * @enabled_cmds: Hardware commands found enabled in CEL.
> > > > + * @exclusive_cmds: Commands that are kernel-internal only
> > > >   * @pmem_range: Persistent memory capacity information.
> > > >   * @ram_range: Volatile memory capacity information.
> > > >   * @mbox_send: @dev specific transport for transmitting mailbox commands
> > > > @@ -117,6 +118,7 @@ struct cxl_mem {
> > > >       struct mutex mbox_mutex; /* Protects device mailbox and firmware */
> > > >       char firmware_version[0x10];
> > > >       DECLARE_BITMAP(enabled_cmds, CXL_MEM_COMMAND_ID_MAX);
> > > > +     DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
> > > >
> > > >       struct range pmem_range;
> > > >       struct range ram_range;
> > > > diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> > > > index 9652c3ee41e7..11410df77444 100644
> > > > --- a/drivers/cxl/pmem.c
> > > > +++ b/drivers/cxl/pmem.c
> > > > @@ -16,9 +16,23 @@
> > > >   */
> > > >  static struct workqueue_struct *cxl_pmem_wq;
> > > >
> > > > -static void unregister_nvdimm(void *nvdimm)
> > > > +static void unregister_nvdimm(void *_cxl_nvd)
> > > >  {
> > > > -     nvdimm_delete(nvdimm);
> > > > +     struct cxl_nvdimm *cxl_nvd = _cxl_nvd;
> > > > +     struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> > > > +     struct cxl_mem *cxlm = cxlmd->cxlm;
> > > > +     struct device *dev = &cxl_nvd->dev;
> > > > +     struct nvdimm *nvdimm;
> > > > +
> > > > +     nvdimm = dev_get_drvdata(dev);
> > > > +     if (nvdimm)
> > > > +             nvdimm_delete(nvdimm);
> > > > +
> > > > +     mutex_lock(&cxlm->mbox_mutex);
> > > > +     clear_bit(CXL_MEM_COMMAND_ID_SET_PARTITION_INFO, cxlm->exclusive_cmds);
> > > > +     clear_bit(CXL_MEM_COMMAND_ID_SET_SHUTDOWN_STATE, cxlm->exclusive_cmds);
> > > > +     clear_bit(CXL_MEM_COMMAND_ID_SET_LSA, cxlm->exclusive_cmds);
> > > > +     mutex_unlock(&cxlm->mbox_mutex);
> > > >  }
> > > >
> > > >  static int match_nvdimm_bridge(struct device *dev, const void *data)
> > > > @@ -39,6 +53,8 @@ static struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void)
> > > >  static int cxl_nvdimm_probe(struct device *dev)
> > > >  {
> > > >       struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
> > > > +     struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> > > > +     struct cxl_mem *cxlm = cxlmd->cxlm;
> > > >       struct cxl_nvdimm_bridge *cxl_nvb;
> > > >       unsigned long flags = 0;
> > > >       struct nvdimm *nvdimm;
> > > > @@ -52,17 +68,24 @@ static int cxl_nvdimm_probe(struct device *dev)
> > > >       if (!cxl_nvb->nvdimm_bus)
> > > >               goto out;
> > > >
> > > > +     mutex_lock(&cxlm->mbox_mutex);
> > > > +     set_bit(CXL_MEM_COMMAND_ID_SET_PARTITION_INFO, cxlm->exclusive_cmds);
> > > > +     set_bit(CXL_MEM_COMMAND_ID_SET_SHUTDOWN_STATE, cxlm->exclusive_cmds);
> > > > +     set_bit(CXL_MEM_COMMAND_ID_SET_LSA, cxlm->exclusive_cmds);
> > > > +     mutex_unlock(&cxlm->mbox_mutex);
> > > > +
> > >
> > > What's the concurrency this lock is trying to protect against?
> >
> > I can add a comment. It synchronizes against in-flight ioctl users to
> > make sure that any requests have completed before the policy changes.
> > I.e. do not allow userspace to race the nvdimm subsystem attaching to
> > get a consistent state of the persistent memory configuration.
> >
>
> Ah, so the expectation is that these things will be set not just on
> probe/unregister()? I would assume an IOCTL couldn't happen while
> probe/unregister is happening.

The ioctl is going through the cxl_pci driver. That driver has
finished probe and published the ioctl before this lockout can run in
cxl_nvdimm_probe(), so it's entirely possible that label writing
ioctls are in progress when cxl_nvdimm_probe() eventually fires.

The current policy for /sys/bus/nd/devices/nmemX devices are that
label writes are allowed as long as the nmemX device is not active in
any region. I was thinking the CXL policy is coarser. Label writes via
/sys/bus/cxl/devices/memX ioctls are disallowed as long as the bridge
for that device into the nvdimm subsystem is active.
