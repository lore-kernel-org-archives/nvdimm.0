Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 56A5C21A09130
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 22:00:02 -0700 (PDT)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id A0A7CAC019C
 for <linux-nvdimm@lists.01.org>; Fri,  5 Oct 2018 13:59:55 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [ndctl PATCH 1/2] ndctl, monitor: fix the severity of the
 "daemon started" message
Date: Fri, 5 Oct 2018 04:59:53 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3223DAF8E58@g01jpexmbkw24>
References: <20181005000057.30186-1-vishal.l.verma@intel.com>
 <20181005130821.2E72.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4hwLWGwChrqfc809Ckrh826ds2dLp_OfxMFagxAAVpE7A@mail.gmail.com>
In-Reply-To: <CAPcyv4hwLWGwChrqfc809Ckrh826ds2dLp_OfxMFagxAAVpE7A@mail.gmail.com>
Content-Language: ja-JP
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: 'Dan Williams' <dan.j.williams@intel.com>, "Gotou, Yasunori" <y-goto@jp.fujitsu.com>, 'Vishal Verma' <vishal.l.verma@intel.com>
Cc: "andreas@canonical.com" <andreas@canonical.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of Dan
> Williams
> Sent: Friday, October 5, 2018 1:24 PM
> To: Gotou, Yasunori/五島 康文 <y-goto@jp.fujitsu.com>
> Cc: andreas@canonical.com; linux-nvdimm <linux-nvdimm@lists.01.org>
> Subject: Re: [ndctl PATCH 1/2] ndctl, monitor: fix the severity of the "daemon
> started" message
> 
> On Thu, Oct 4, 2018 at 9:09 PM Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> >
> > Hi, Vishal-san,
> >
> > > The above message was printed as an error, but it is just an
> > > informational message. Change it to dbg().
> >
> > Hmmmmmmm.
> >
> > When I was a engineer for trouble-shooting of customer's Linux system,
> > the starting time and the ending time of any daemon was very helpful
> > for investigating their trouble.
> >
> > So, I think it is not only for developer, but also it is essential for
> > trouble-shooter for custmer support.
> > (It may be also same with system operator)
> >
> >
> > >
> > > Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > > ---
> > >  ndctl/monitor.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/ndctl/monitor.c b/ndctl/monitor.c index
> > > d29e378..b44f946 100644
> > > --- a/ndctl/monitor.c
> > > +++ b/ndctl/monitor.c
> > > @@ -660,7 +660,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
> > >                       err((struct ndctl_ctx *)ctx, "daemon start failed\n");
> > >                       goto out;
> > >               }
> > > -             err((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
> > > +             dbg((struct ndctl_ctx *)ctx, "ndctl monitor daemon
> > > + started\n");
> >
> > Though I agree its message is not "error" certainly, I would like to
> > keep it as normal status level message.
> >
> 
> Sounds good to me.

In my original idea, I just wanted to log the "daemon started" message.
After thinking more about it, I agree that the message is not at "error" level.
However, considering this message will be helpful for some users like system operators,
how about changing this message level to "info" and meanwhile changing the default log level to "LOG_INFO" as following?

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index d29e378..10866b6 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -628,7 +628,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
        if (monitor.verbose)
                ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_DEBUG);
        else
-               ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_NOTICE);
+               ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_INFO);

        rc = read_config_file((struct ndctl_ctx *)ctx, &monitor, &param);
        if (rc)
@@ -657,7 +657,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
                if (!monitor.log || strncmp(monitor.log, "./", 2) == 0)
                        ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
                if (daemon(0, 0) != 0) {
-                       err((struct ndctl_ctx *)ctx, "daemon start failed\n");
+                       info((struct ndctl_ctx *)ctx, "daemon start failed\n");
                        goto out;
                }
                err((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");

Thank you very much,
QI Fuli
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
