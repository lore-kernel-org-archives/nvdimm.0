Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym01.jp.fujitsu.com (mgwym01.jp.fujitsu.com [211.128.242.40])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD4DA2246801B
 for <linux-nvdimm@lists.01.org>; Fri, 16 Mar 2018 17:17:44 -0700 (PDT)
Received: from aks-ab1.gw.nic.fujitsu.com (aks-ab1.gw.nic.fujitsu.com
 [192.51.207.11])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id CD509AC01FC
 for <linux-nvdimm@lists.01.org>; Sat, 17 Mar 2018 09:24:02 +0900 (JST)
Date: Sat, 17 Mar 2018 09:23:53 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RFC PATCH v4] ndctl: monitor: add ndctl monitor daemon
In-Reply-To: <CAPcyv4i9QH1eJVXnc6cwaBGPW9nNJ8nGOeDyN2icGNNJ7+O9Bg@mail.gmail.com>
References: <20180316155515.7293.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4i9QH1eJVXnc6cwaBGPW9nNJ8nGOeDyN2icGNNJ7+O9Bg@mail.gmail.com>
Message-Id: <20180317092350.F0E7.E1E9C6FF@jp.fujitsu.com>
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> On Thu, Mar 15, 2018 at 11:55 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> > Hi,
> >
> >> > +static void log_syslog(struct ndctl_ctx *ctx, int priority, const char *file,
> >> > +       int line, const char *fn, const char *format, va_list args)
> >> > +{
> >> > +       char *buf = (char *)malloc(BUF_SIZE);
> >> > +       vsnprintf(buf, BUF_SIZE, format, args);
> >> > +       syslog(priority, "%s", buf);
> >> > +       free(buf);
> >> > +}
> >>
> >> This seems to be reinventing setting up a log file that I'm sure we
> >> could borrow or link to...
> >>
> >> ndctl borrows heavily from git, and git does logging in it's daemon.c,
> >> I'd be happier if you copied that.
> >
> > Maybe silly question...., but is it OK about OSS lisence?
> >
> > In my understanding,  basically the lisence of git is GPL2,
> > LGPL is used just for use xdiff/ or some libc code in git....
> > https://github.com/git/git/blob/master/COPYING
> > https://github.com/git/git/blob/master/LGPL-2.1
> >
> > However, the lisence of ndctl is LGPL2.1
> > https://github.com/pmem/ndctl/blob/master/COPYING
> >
> > If we copied from git to ndctl, then I suppose that ndctl
> > daemon may have to use GPL2 rather than LGPL2.1, right?
> 
> In the ndctl source tree the license of the code in ndctl/ is GPL-2,
> the license of the code in ndctl/lib/ is LGPL-2.1. So we can freely
> copy GPL-2 code into the utilities, but not the library.

Ok. I see.

Thanks,
---
Yasunori Goto




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
