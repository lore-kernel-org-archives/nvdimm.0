Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC412C80
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 23:11:13 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so688842pjt.5
        for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 15:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nUAfe5k5e+O9VOxg05HBUCs0ZoR1vq/g20INw2GApW4=;
        b=qmvYEkdbgSm0MKddhofhmaAmaAImSOucN6ofDmMdVVbijHgeHWk29U0wos47F/RAFs
         3kZScef3ZNeCQE6SCiCUo+FV35hLZ8MZqXV7OgSGXfTLWZfjXoX0W++XirDG5ClhFSiH
         OJhHehDBdcY+Aom9512lN4IQOjiMpmz0wLf1IxzsmSFNWTqZfEvTD7yYzqki9yKO8ceF
         5Acjn2AQl3eJ8p5haKydk9V+uXPT1LP+Fpz/qiefhlFygNtzBVywvafP4LsyEp/K43jz
         o+wiDvJ1lC/IkUhwV3aCSeiiW/YYFah69/klqerK+hZGmJ9+EC5snJANignNBqUOEHa2
         E2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nUAfe5k5e+O9VOxg05HBUCs0ZoR1vq/g20INw2GApW4=;
        b=70IDZhPMlNm9AvtPbH2SwWFw+xheEffe2EW3OVQSBxCLrlHHxeuNLmHy1wysSoIBkb
         c9DClagow/L3PwAc6LHjbyVB6N/nrUfUILPqOiJUeJypyaPd/VU9p2Mg8tEHyVCJwWza
         2UN9cpOFBSpruyTshCcwRZCbF4XqGN+/StpWPKPKixPafp+G3/nbbCmp34krVI2jB86p
         7IFxFOCDjsDp0qXiK8zM6GQgvrkEpRaGMvEbAyt52NH1xhD4B5Io8r2VA8+yAMsfzjn/
         xEaGeLdCaAOepd48huyED4l4zkfD/tobBrxqt5hXA0YkZPYCSYZ0yQXXWxsT4uhjOjLs
         d98g==
X-Gm-Message-State: AOAM532t1SWij19p9/BQtldXp5kB5dJ2pevV3oCo6PY00nctrnvLl6Rh
	5iULeMJYxdiV0+vDhMQp7gXUxVJGDPzA92ZpDOpwIg==
X-Google-Smtp-Source: ABdhPJyzz80R6E7ToGcRvh4cwCJ5RQFQJXB+VaJmWkazPmjyCzehEf3VtKGOFrwbiLZxZurxqRIEI6shZkoJmDt5Hq8=
X-Received: by 2002:a17:902:d705:: with SMTP id w5mr22375544ply.34.1643670672853;
 Mon, 31 Jan 2022 15:11:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298412919.3018233.12491722885382120190.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220131222101.tckwbcxheuuorkiq@intel.com>
In-Reply-To: <20220131222101.tckwbcxheuuorkiq@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 31 Jan 2022 15:11:05 -0800
Message-ID: <CAPcyv4gGMsUbJ=Cu8U0B2Znz6+jE6PcDCALNfxJzvAHZZccVvQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/40] cxl/pci: Implement Interface Ready Timeout
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Linux PCI <linux-pci@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 31, 2022 at 2:21 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 22-01-23 16:28:49, Dan Williams wrote:
> > From: Ben Widawsky <ben.widawsky@intel.com>
> >
> > The original driver implementation used the doorbell timeout for the
> > Mailbox Interface Ready bit to piggy back off of, since the latter does
> > not have a defined timeout. This functionality, introduced in commit
> > 8adaf747c9f0 ("cxl/mem: Find device capabilities"), needs improvement as
> > the recent "Add Mailbox Ready Time" ECN timeout indicates that the
> > mailbox ready time can be significantly longer that 2 seconds.
> >
> > While the specification limits the maximum timeout to 256s, the cxl_pci
> > driver gives up on the mailbox after 60s. This value corresponds with
> > important timeout values already present in the kernel. A module
> > parameter is provided as an emergency override and represents the
> > default Linux policy for all devices.
> >
> > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > [djbw: add modparam, drop check_device_status()]
> > Co-developed-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/cxl/pci.c |   35 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> >
> > diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> > index 8dc91fd3396a..ed8de9eac970 100644
> > --- a/drivers/cxl/pci.c
> > +++ b/drivers/cxl/pci.c
> > @@ -1,7 +1,9 @@
> >  // SPDX-License-Identifier: GPL-2.0-only
> >  /* Copyright(c) 2020 Intel Corporation. All rights reserved. */
> >  #include <linux/io-64-nonatomic-lo-hi.h>
> > +#include <linux/moduleparam.h>
> >  #include <linux/module.h>
> > +#include <linux/delay.h>
> >  #include <linux/sizes.h>
> >  #include <linux/mutex.h>
> >  #include <linux/list.h>
> > @@ -35,6 +37,20 @@
> >  /* CXL 2.0 - 8.2.8.4 */
> >  #define CXL_MAILBOX_TIMEOUT_MS (2 * HZ)
> >
> > +/*
> > + * CXL 2.0 ECN "Add Mailbox Ready Time" defines a capability field to
> > + * dictate how long to wait for the mailbox to become ready. The new
> > + * field allows the device to tell software the amount of time to wait
> > + * before mailbox ready. This field per the spec theoretically allows
> > + * for up to 255 seconds. 255 seconds is unreasonably long, its longer
> > + * than the maximum SATA port link recovery wait. Default to 60 seconds
> > + * until someone builds a CXL device that needs more time in practice.
> > + */
> > +static unsigned short mbox_ready_timeout = 60;
> > +module_param(mbox_ready_timeout, ushort, 0600);
>
> Any reason not to make it 0644?
>

Are there any tooling scenarios where this information is usable by non-root?

> > +MODULE_PARM_DESC(mbox_ready_timeout,
> > +              "seconds to wait for mailbox ready status");
> > +
> >  static int cxl_pci_mbox_wait_for_doorbell(struct cxl_dev_state *cxlds)
> >  {
> >       const unsigned long start = jiffies;
> > @@ -281,6 +297,25 @@ static int cxl_pci_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *c
> >  static int cxl_pci_setup_mailbox(struct cxl_dev_state *cxlds)
> >  {
> >       const int cap = readl(cxlds->regs.mbox + CXLDEV_MBOX_CAPS_OFFSET);
> > +     unsigned long timeout;
> > +     u64 md_status;
> > +
> > +     timeout = jiffies + mbox_ready_timeout * HZ;
> > +     do {
> > +             md_status = readq(cxlds->regs.memdev + CXLMDEV_STATUS_OFFSET);
> > +             if (md_status & CXLMDEV_MBOX_IF_READY)
> > +                     break;
> > +             if (msleep_interruptible(100))
> > +                     break;
> > +     } while (!time_after(jiffies, timeout));
>
> Just pointing out the [probably] obvious. If the user specifies a zero second
> timeout, the code will still wait 100ms.

Sure, is that going to be a problem in practice? I expect the
overwhelming common case is that the mailbox is already ready by this
point, so it's a zero-wait.

>
> > +
> > +     if (!(md_status & CXLMDEV_MBOX_IF_READY)) {
> > +             dev_err(cxlds->dev,
> > +                     "timeout awaiting mailbox ready, device state:%s%s\n",
> > +                     md_status & CXLMDEV_DEV_FATAL ? " fatal" : "",
> > +                     md_status & CXLMDEV_FW_HALT ? " firmware-halt" : "");
> > +             return -EIO;
> > +     }
> >
> >       cxlds->mbox_send = cxl_pci_mbox_send;
> >       cxlds->payload_size =
> >
