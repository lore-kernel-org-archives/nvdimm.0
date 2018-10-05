Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0F0BA21962301
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 23:15:26 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id A3F71AC0176
 for <linux-nvdimm@lists.01.org>; Fri,  5 Oct 2018 15:15:22 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [ndctl PATCH 1/2] ndctl, monitor: fix the severity of the
 "daemon started" message
Date: Fri, 5 Oct 2018 06:15:20 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3223DAF910F@g01jpexmbkw24>
References: <20181005000057.30186-1-vishal.l.verma@intel.com>
 <20181005130821.2E72.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4hwLWGwChrqfc809Ckrh826ds2dLp_OfxMFagxAAVpE7A@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3223DAF8E58@g01jpexmbkw24>
 <4adb62046776c34d28172a94aa95157774e41644.camel@intel.com>
In-Reply-To: <4adb62046776c34d28172a94aa95157774e41644.camel@intel.com>
Content-Language: ja-JP
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
To: "'Verma, Vishal L'" <vishal.l.verma@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Gotou, Yasunori" <y-goto@jp.fujitsu.com>
Cc: "andreas@canonical.com" <andreas@canonical.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> > > >
> > >
> > > Sounds good to me.
> >
> > In my original idea, I just wanted to log the "daemon started" message.
> > After thinking more about it, I agree that the message is not at "error" level.
> > However, considering this message will be helpful for some users like system
> operators,
> > how about changing this message level to "info" and meanwhile changing the
> default log level to "LOG_INFO" as following?
> >
> > diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> > index d29e378..10866b6 100644
> > --- a/ndctl/monitor.c
> > +++ b/ndctl/monitor.c
> > @@ -628,7 +628,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
> >         if (monitor.verbose)
> >                 ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_DEBUG);
> >         else
> > -               ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_NOTICE);
> > +               ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_INFO);
> >
> >         rc = read_config_file((struct ndctl_ctx *)ctx, &monitor, &param);
> >         if (rc)
> > @@ -657,7 +657,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
> >                 if (!monitor.log || strncmp(monitor.log, "./", 2) == 0)
> >                         ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
> >                 if (daemon(0, 0) != 0) {
> > -                       err((struct ndctl_ctx *)ctx, "daemon start failed\n");
> > +                       info((struct ndctl_ctx *)ctx, "daemon start failed\n");
> >                         goto out;
> >                 }
> >                 err((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
> 
> Yes, this looks good to me. Will you send a proper patch for this, and I
> can replace my patch with yours.
> 
> Thanks,
> 	-Vishal
> 

Ok, I will send a patch.

> >
> > Thank you very much,
> > QI Fuli
> > > _______________________________________________
> > > Linux-nvdimm mailing list
> > > Linux-nvdimm@lists.01.org
> > > https://lists.01.org/mailman/listinfo/linux-nvdimm
> >
> >
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
