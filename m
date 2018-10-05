Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 56F0921A00AE6
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 21:24:05 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id u74-v6so9329854oia.11
 for <linux-nvdimm@lists.01.org>; Thu, 04 Oct 2018 21:24:05 -0700 (PDT)
MIME-Version: 1.0
References: <20181005000057.30186-1-vishal.l.verma@intel.com>
 <20181005130821.2E72.E1E9C6FF@jp.fujitsu.com>
In-Reply-To: <20181005130821.2E72.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Oct 2018 21:23:53 -0700
Message-ID: <CAPcyv4hwLWGwChrqfc809Ckrh826ds2dLp_OfxMFagxAAVpE7A@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/2] ndctl, monitor: fix the severity of the "daemon
 started" message
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: andreas@canonical.com, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 4, 2018 at 9:09 PM Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>
> Hi, Vishal-san,
>
> > The above message was printed as an error, but it is just an
> > informational message. Change it to dbg().
>
> Hmmmmmmm.
>
> When I was a engineer for trouble-shooting of customer's Linux system,
> the starting time and the ending time of any daemon was very helpful
> for investigating their trouble.
>
> So, I think it is not only for developer, but also it is essential for
> trouble-shooter for custmer support.
> (It may be also same with system operator)
>
>
> >
> > Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  ndctl/monitor.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> > index d29e378..b44f946 100644
> > --- a/ndctl/monitor.c
> > +++ b/ndctl/monitor.c
> > @@ -660,7 +660,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
> >                       err((struct ndctl_ctx *)ctx, "daemon start failed\n");
> >                       goto out;
> >               }
> > -             err((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
> > +             dbg((struct ndctl_ctx *)ctx, "ndctl monitor daemon started\n");
>
> Though I agree its message is not "error" certainly,
> I would like to keep it as normal status level message.
>

Sounds good to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
