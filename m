Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B1517F
	for <nvdimm@lists.linux.dev>; Tue, 10 Aug 2021 21:52:29 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id a20so23267837plm.0
        for <nvdimm@lists.linux.dev>; Tue, 10 Aug 2021 14:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ys7KUFx5I936uX4T8G+pLgnXnpZZICf8jh1FQAsoHl4=;
        b=wPGs3p1dNExaYFd9JshlCmJibc8w/YN+V2btMA4Xucgl5qGUWg51vSbD3LyzCZRF5e
         sICIoNcOP4pC9DGKoWSQuUiC65xOV2NEEeVqZGmAV1UelaDDd8+kz3DGmkgjjL9sX9fm
         qbe2njosfYhy7si3gPdszRdZU9hEmM7hkTnVs4qyOd9kTWMjk3x8NgANx2NMYWmOOcoA
         Iur/apYoxTEOUbg+C3aYYSMMa5W7Jn6wBDAnSqL4NYyz8F3LMlCqax85Evkb5gHnmFzl
         xQxOTyRWZkvQrx6L/5ZNhXnvtWppl6u9ziSJcdBTwIIITwdyGPLyrjRKqYhrbrnGQIx/
         Nb5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ys7KUFx5I936uX4T8G+pLgnXnpZZICf8jh1FQAsoHl4=;
        b=A6F3uYiXakvrijcys3kFAlgeuRmLtoHK5qniNRjuvUvJa/sM9v60pooYI71H692eIg
         3QtriDNgGPvPeP+UCQ5emD6/ODHNaA3OUEb9RCvuPKtQ1PtE8v2yWE9E0s7bzDeLSXvl
         4MavVkkOAqSX3yyPPMyeHDHMgzo3RzgL+SmhS7MjGk6pHNqdgA2CAmyiP3y29HxnDzN+
         QqEGjqAuDnXL5t2m6nGIr4qBaVrLTB+K2sPJLmJ4gpP7VQGl5tY070Isa99wtKGwWJni
         QmS69zjk7hmpzsHiT7o9rv6zk2ATSR0LpdAf0Ab6k7AC0ub/83lVM7zJ6VsV0iYROFnV
         E/VA==
X-Gm-Message-State: AOAM5313AOu0DXVuEfZn1Ye7hl8zFBp/6pG3hj2vA+GTZdCNfMvYR0Wo
	ih6rjZo2VShXyoY8c9n70xiqUbO0iLU9GxDVCqn0ew==
X-Google-Smtp-Source: ABdhPJxdHmi/B8eA60Z66dknlsVgWTYGPjaiK7OULm6hxMuYIbG6KMMRYamKVZ5o7kTnqjW0n5mBWy/i9GMrtT+BrCo=
X-Received: by 2002:a62:5f81:0:b029:3c6:abad:345 with SMTP id
 t123-20020a625f810000b02903c6abad0345mr25679812pfb.31.1628632348887; Tue, 10
 Aug 2021 14:52:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162854815819.1980150.14391324052281496748.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210810213459.5zpvfrvbo2rztwmc@intel.com>
In-Reply-To: <20210810213459.5zpvfrvbo2rztwmc@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Aug 2021 14:52:18 -0700
Message-ID: <CAPcyv4iXZpeahdDxyRLd7ACS6vpV+VA3-J3MiLQvvV2Q6asBFg@mail.gmail.com>
Subject: Re: [PATCH 17/23] cxl/mbox: Add exclusive kernel command support
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	"Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 10, 2021 at 2:35 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 21-08-09 15:29:18, Dan Williams wrote:
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
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/cxl/core/mbox.c |    5 +++++
> >  drivers/cxl/cxlmem.h    |    2 ++
> >  drivers/cxl/pmem.c      |   35 +++++++++++++++++++++++++++++------
> >  3 files changed, 36 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 23100231e246..f26962d7cb65 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -409,6 +409,11 @@ static int handle_mailbox_cmd_from_user(struct cxl_mem *cxlm,
> >               }
> >       }
> >
> > +     if (test_bit(cmd->info.id, cxlm->exclusive_cmds)) {
> > +             rc = -EBUSY;
> > +             goto out;
> > +     }
> > +
>
> This breaks our current definition for cxl_raw_allow_all. All the test machinery

That's deliberate; this exclusion is outside of the raw policy. I
don't think raw_allow_all should override kernel self protection of
data structures, like labels, that it needs to maintain consistency.
If userspace wants to use raw_allow_all to send LSA manipulation
commands it must do so while the device is not active on the nvdimm
side of the house. You'll see that:

ndctl disable-region all
<mutate labels>
ndctl enable-region all

...is a common pattern from custom label update flows.

> for whether a command can be submitted was supposed to happen in
> cxl_validate_cmd_from_user(). Various versions of the original patches made
> cxl_mem_raw_command_allowed() grow more intelligence (ie. more than just the
> opcode). I think this check belongs there with more intelligence.
>
> I don't love the EBUSY because it already had a meaning for concurrent use of
> the mailbox, but I can't think of a better errno.

It's the existing errno that happens from nvdimm land when the kernel
owns the label area, so it would be confusing to invent a new one for
the same behavior now:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/nvdimm/bus.c#n1013

>
> >       dev_dbg(dev,
> >               "Submitting %s command for user\n"
> >               "\topcode: %x\n"
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index df4f3636a999..f6cfe84a064c 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -102,6 +102,7 @@ struct cxl_mbox_cmd {
> >   * @mbox_mutex: Mutex to synchronize mailbox access.
> >   * @firmware_version: Firmware version for the memory device.
> >   * @enabled_cmds: Hardware commands found enabled in CEL.
> > + * @exclusive_cmds: Commands that are kernel-internal only
> >   * @pmem_range: Persistent memory capacity information.
> >   * @ram_range: Volatile memory capacity information.
> >   * @mbox_send: @dev specific transport for transmitting mailbox commands
> > @@ -117,6 +118,7 @@ struct cxl_mem {
> >       struct mutex mbox_mutex; /* Protects device mailbox and firmware */
> >       char firmware_version[0x10];
> >       DECLARE_BITMAP(enabled_cmds, CXL_MEM_COMMAND_ID_MAX);
> > +     DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
> >
> >       struct range pmem_range;
> >       struct range ram_range;
> > diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> > index 9652c3ee41e7..11410df77444 100644
> > --- a/drivers/cxl/pmem.c
> > +++ b/drivers/cxl/pmem.c
> > @@ -16,9 +16,23 @@
> >   */
> >  static struct workqueue_struct *cxl_pmem_wq;
> >
> > -static void unregister_nvdimm(void *nvdimm)
> > +static void unregister_nvdimm(void *_cxl_nvd)
> >  {
> > -     nvdimm_delete(nvdimm);
> > +     struct cxl_nvdimm *cxl_nvd = _cxl_nvd;
> > +     struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> > +     struct cxl_mem *cxlm = cxlmd->cxlm;
> > +     struct device *dev = &cxl_nvd->dev;
> > +     struct nvdimm *nvdimm;
> > +
> > +     nvdimm = dev_get_drvdata(dev);
> > +     if (nvdimm)
> > +             nvdimm_delete(nvdimm);
> > +
> > +     mutex_lock(&cxlm->mbox_mutex);
> > +     clear_bit(CXL_MEM_COMMAND_ID_SET_PARTITION_INFO, cxlm->exclusive_cmds);
> > +     clear_bit(CXL_MEM_COMMAND_ID_SET_SHUTDOWN_STATE, cxlm->exclusive_cmds);
> > +     clear_bit(CXL_MEM_COMMAND_ID_SET_LSA, cxlm->exclusive_cmds);
> > +     mutex_unlock(&cxlm->mbox_mutex);
> >  }
> >
> >  static int match_nvdimm_bridge(struct device *dev, const void *data)
> > @@ -39,6 +53,8 @@ static struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void)
> >  static int cxl_nvdimm_probe(struct device *dev)
> >  {
> >       struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
> > +     struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> > +     struct cxl_mem *cxlm = cxlmd->cxlm;
> >       struct cxl_nvdimm_bridge *cxl_nvb;
> >       unsigned long flags = 0;
> >       struct nvdimm *nvdimm;
> > @@ -52,17 +68,24 @@ static int cxl_nvdimm_probe(struct device *dev)
> >       if (!cxl_nvb->nvdimm_bus)
> >               goto out;
> >
> > +     mutex_lock(&cxlm->mbox_mutex);
> > +     set_bit(CXL_MEM_COMMAND_ID_SET_PARTITION_INFO, cxlm->exclusive_cmds);
> > +     set_bit(CXL_MEM_COMMAND_ID_SET_SHUTDOWN_STATE, cxlm->exclusive_cmds);
> > +     set_bit(CXL_MEM_COMMAND_ID_SET_LSA, cxlm->exclusive_cmds);
> > +     mutex_unlock(&cxlm->mbox_mutex);
> > +
>
> What's the concurrency this lock is trying to protect against?

I can add a comment. It synchronizes against in-flight ioctl users to
make sure that any requests have completed before the policy changes.
I.e. do not allow userspace to race the nvdimm subsystem attaching to
get a consistent state of the persistent memory configuration.

>
> >       set_bit(NDD_LABELING, &flags);
> >       nvdimm = nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags, 0, 0,
> >                              NULL);
> > -     if (!nvdimm)
> > -             goto out;
> > -
> > -     rc = devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
> > +     dev_set_drvdata(dev, nvdimm);
> > +     rc = devm_add_action_or_reset(dev, unregister_nvdimm, cxl_nvd);
> >  out:
> >       device_unlock(&cxl_nvb->dev);
> >       put_device(&cxl_nvb->dev);
> >
> > +     if (!nvdimm && rc == 0)
> > +             rc = -ENOMEM;
> > +
> >       return rc;
> >  }
> >
> >
