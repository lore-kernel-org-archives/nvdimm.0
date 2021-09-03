Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5943FCD
	for <nvdimm@lists.linux.dev>; Fri,  3 Sep 2021 20:47:52 +0000 (UTC)
Received: by mail-pg1-f173.google.com with SMTP id 8so239319pga.7
        for <nvdimm@lists.linux.dev>; Fri, 03 Sep 2021 13:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DHw/pVVdbdzwwn3y15Ex8UULwpy2006bO9yELcuTXcM=;
        b=YLWxpxLaw+vGt/GIVbNhG4caF32Owa/Oo9OpFd1/P1KbKouYjMfzm1rny2JQrD2KFw
         2MYPh87h4RmVt0HeHhnD7ON4nU1H7R355M2poBhDpqKF+M9HSqWxWQZHm0ZskjTXkNv5
         OMgrih95CzZT0YSJqsTc/VLhuBdRcs5m4O4/EjbPmUE2/Ho9y3QQchCYpyE2Ko9X0ZAQ
         rzWu63p4SKGgM1b9oTznrzr+HKPYms7/MrRFjT6HOCy2Z9izJjpPcIP0M8c6RddPZtcr
         P+OolQJyD+1x+dbIH+TeRc2jM+BTV2AyTOS/+J4cnVz97FUlNfQX+oRAVELiIBDsIkO8
         7RnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DHw/pVVdbdzwwn3y15Ex8UULwpy2006bO9yELcuTXcM=;
        b=RSbf3Ql/bQio43vArWvkkEgR0tdusAye9cQoNrT8hVHMyqBSu02+2KcC+XDVoeG9JJ
         0uTeBS7nzrmUWNusq5ii3NaZYSyGdjDbb8dn9HEiAoDgubqCwpV9pzPUaL1oxOhYrSVl
         GUGwO5I0SjJKaGGBcGaEk9mRUlX5f520LZjcqlqeZC6q5J6duK7Ok2lSrRsrBgF5D/x8
         eYQErSpOBkoZFWvwEvcVnUVw4T+MAkVnzbxcAPfo1jxL3olLID7FfrSpI4QLybQNhHrw
         vT/hG68e+4579j0uUk6QSgDTP8DOo85JOpHJCIkWbhDsmye0PpKk9CpXsT7D/DZWbeyZ
         8S3w==
X-Gm-Message-State: AOAM5325AiY078Ve0FCA5kMFUmYT+YBDWQyvnPwCaKvr3JZmwhVKu8vL
	AcUBaxOqQ9Jer6Zi+i6LpdkaJ93wwT73Owlfw633/Q==
X-Google-Smtp-Source: ABdhPJy4qey/eZUkwqWBCQn3omrMVvyeG4thuRj8tBSuY8qLovjOlEO+s9gLguDa2tCw0gFy55zgHKc7/cf0ww7X8Rs=
X-Received: by 2002:a63:1e0e:: with SMTP id e14mr784527pge.5.1630702072093;
 Fri, 03 Sep 2021 13:47:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162982123298.1124374.22718002900700392.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210902190941.0000590f@Huawei.com>
In-Reply-To: <20210902190941.0000590f@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 3 Sep 2021 13:47:41 -0700
Message-ID: <CAPcyv4hfHdcNpbubU6QBmbcnL8E=s8i9e54suY8GwrbfkwOniw@mail.gmail.com>
Subject: Re: [PATCH v3 20/28] cxl/mbox: Add exclusive kernel command support
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 2, 2021 at 11:09 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Tue, 24 Aug 2021 09:07:13 -0700
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
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/cxl/core/mbox.c   |    5 +++++
> >  drivers/cxl/core/memdev.c |   31 +++++++++++++++++++++++++++++++
> >  drivers/cxl/cxlmem.h      |    4 ++++
> >  drivers/cxl/pmem.c        |   35 ++++++++++++++++++++++++++++-------
> >  4 files changed, 68 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 73107b302224..6a5c4f3679ba 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -230,6 +230,7 @@ static bool cxl_mem_raw_command_allowed(u16 opcode)
> >   *  * %-EINVAL       - Reserved fields or invalid values were used.
> >   *  * %-ENOMEM       - Input or output buffer wasn't sized properly.
> >   *  * %-EPERM        - Attempted to use a protected command.
> > + *  * %-EBUSY        - Kernel has claimed exclusive access to this opcode
> >   *
> >   * The result of this command is a fully validated command in @out_cmd that is
> >   * safe to send to the hardware.
> > @@ -305,6 +306,10 @@ static int cxl_validate_cmd_from_user(struct cxl_mem *cxlm,
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
>
>
> >  #endif /* __CXL_MEM_H__ */
> > diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> > index 9652c3ee41e7..469b984176a2 100644
> > --- a/drivers/cxl/pmem.c
> > +++ b/drivers/cxl/pmem.c
> > @@ -16,9 +16,21 @@
> >   */
> >  static struct workqueue_struct *cxl_pmem_wq;
> >
> > -static void unregister_nvdimm(void *nvdimm)
> > +static __read_mostly DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
> > +
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
> > +     clear_exclusive_cxl_commands(cxlm, exclusive_cmds);
> >  }
> >
> >  static int match_nvdimm_bridge(struct device *dev, const void *data)
> > @@ -39,9 +51,11 @@ static struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void)
> >  static int cxl_nvdimm_probe(struct device *dev)
> >  {
> >       struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
> > +     struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> > +     struct cxl_mem *cxlm = cxlmd->cxlm;
> >       struct cxl_nvdimm_bridge *cxl_nvb;
> > +     struct nvdimm *nvdimm = NULL;
> >       unsigned long flags = 0;
> > -     struct nvdimm *nvdimm;
> >       int rc = -ENXIO;
> >
> >       cxl_nvb = cxl_find_nvdimm_bridge();
> > @@ -52,17 +66,20 @@ static int cxl_nvdimm_probe(struct device *dev)
> >       if (!cxl_nvb->nvdimm_bus)
> >               goto out;
> >
> > +     set_exclusive_cxl_commands(cxlm, exclusive_cmds);
> > +
> >       set_bit(NDD_LABELING, &flags);
> >       nvdimm = nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags, 0, 0,
> >                              NULL);
> > -     if (!nvdimm)
> > -             goto out;
> > -
> > -     rc = devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
> > +     dev_set_drvdata(dev, nvdimm);
> > +     rc = devm_add_action_or_reset(dev, unregister_nvdimm, cxl_nvd);
>
> I think this ends up less readable than explicit devm handling of each part
> rather than combining them.
>
>
>         set_exclusive...()
>         rc = devm_add_action_or_rset(dev, unset_exclusive, cxlm);
>         if (rc)
>                 goto out;
>
>         nvidimm = nvdim_create()
>         if (!nvdimm) //return value looks dubious in old code but I've not checked it properly.
>                 goto out;
>
>         rc = devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
>         if (rc)
>                 goto out;
>         dev_set_drvdata(dev, nvdimm);
>
> and two simpler unwinding functions doing just one thing each.

Taking it a step further, the unwind is so simple here, might as well
just have a typical cxl_nvdimm_remove() and drop the devm.
