Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym03.jp.fujitsu.com (mgwym03.jp.fujitsu.com [211.128.242.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B735521E11D02
 for <linux-nvdimm@lists.01.org>; Sun, 27 Aug 2017 17:59:15 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 07AD0AC031C
 for <linux-nvdimm@lists.01.org>; Mon, 28 Aug 2017 10:01:37 +0900 (JST)
Date: Mon, 28 Aug 2017 10:01:32 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [ndctl PATCH 1/4] make interface to check device/nfit/dsm_mask
 flags
In-Reply-To: <CAPcyv4ha=aqoJmMH89uqVzaCcXhFXkWfCC1GxKk8zY35s0XA_A@mail.gmail.com>
References: <20170818133348.8EAE.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4ha=aqoJmMH89uqVzaCcXhFXkWfCC1GxKk8zY35s0XA_A@mail.gmail.com>
Message-Id: <20170828100130.9A52.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> On Thu, Aug 17, 2017 at 9:33 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> >
> > To check what feature can be called via ND_CMD_CALL, ndctl need to read
> > device/nfit/dsm_mask. This patch make an interface to check it in libndctl.c
> >
> >
> > Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> > ---
> >  ndctl/lib/libndctl.c | 13 +++++++++++++
> >  ndctl/libndctl.h.in  |  1 +
> >  2 files changed, 14 insertions(+)
> >
> > diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> > index c2e0efb..93692e5 100644
> > --- a/ndctl/lib/libndctl.c
> > +++ b/ndctl/lib/libndctl.c
> > @@ -102,6 +102,7 @@ struct ndctl_bus {
> >         size_t buf_len;
> >         char *wait_probe_path;
> >         unsigned long dsm_mask;
> > +       unsigned long bus_dsm_mask;
> >  };
> >
> >  /**
> > @@ -846,6 +847,12 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
> >                 bus->revision = strtoul(buf, NULL, 0);
> >         }
> >
> > +       sprintf(path, "%s/device/nfit/dsm_mask", ctl_base);
> > +       if (sysfs_read_attr(ctx, path, buf) < 0)
> > +               bus->bus_dsm_mask = 0;
> > +       else
> > +               bus->bus_dsm_mask = strtoul(buf, NULL, 16);
> > +
> >         sprintf(path, "%s/device/provider", ctl_base);
> >         if (sysfs_read_attr(ctx, path, buf) < 0)
> >                 goto err_read;
> > @@ -1101,6 +1108,12 @@ NDCTL_EXPORT int ndctl_bus_is_cmd_supported(struct ndctl_bus *bus,
> >         return !!(bus->dsm_mask & (1ULL << cmd));
> >  }
> >
> > +NDCTL_EXPORT int ndctl_bus_is_sub_cmd_supported(struct ndctl_bus *bus,
> 
> Looks good, let's call this ndctl_bus_is_passthru_cmd_supported()
> since ndctl_bus_is_cmd_supported() is telling you about native bus
> commands that Linux supports generically and "passthru" is for command
> payloads that Linux is just blindly passing through to the firmware
> implementation. As far as the libndctl user is concerned they should
> not be able to easily tell the difference between an ACPI defined
> NVDIMM bus or Open Firmware / some other platform.
> 

I see. I'll change it.



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
