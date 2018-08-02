Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C7A16210C6427
 for <linux-nvdimm@lists.01.org>; Thu,  2 Aug 2018 13:16:54 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndclt PATCH] ndctl, monitor: Fix duplicate prefix in monitor.log
Date: Thu, 2 Aug 2018 20:16:52 +0000
Message-ID: <1533241011.8557.65.camel@intel.com>
References: <20180731051503.30719-1-qi.fuli@jp.fujitsu.com>
 <533dc62c-bac1-15aa-0e8d-bc444e8ef06b@gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3223DA9C5CB@g01jpexmbkw24>
 <9c43a608-321c-e227-f95e-74ad477d55c8@gmail.com>
In-Reply-To: <9c43a608-321c-e227-f95e-74ad477d55c8@gmail.com>
Content-Language: en-US
Content-ID: <380C81E513DFCE46B768ED66794ED527@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>, "msys.mizuma@gmail.com" <msys.mizuma@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>


On Thu, 2018-08-02 at 09:22 -0400, Masayoshi Mizuma wrote:
> Hi QI,
> 
> On 08/02/2018 05:42 AM, Qi, Fuli wrote:
> ...
> > > > diff --git a/ndctl/monitor.c b/ndctl/monitor.c index
> > > > c6419ad..4e5daf5
> > > > 100644
> > > > --- a/ndctl/monitor.c
> > > > +++ b/ndctl/monitor.c
> > > > @@ -614,7 +614,8 @@ int cmd_monitor(int argc, const char
> > > > **argv, void *ctx)
> > > >  		goto out;
> > > > 
> > > >  	if (monitor.log) {
> > > > -		fix_filename(prefix, (const char
> > > > **)&monitor.log);
> > > > +		if (strncmp(monitor.log, "./", 2) != 0)
> > > > +			fix_filename(prefix, (const char
> > > > **)&monitor.log);
> > > 
> > > prefix is not needed to 'syslog' and 'standard', so why don't you
> > > move the strncmp()
> > > before fix_filename(), like as:
> > > 
> > > @@ -614,13 +619,14 @@ int cmd_monitor(int argc, const char
> > > **argv, void *ctx)
> > >                 goto out;
> > > 
> > >         if (monitor.log) {
> > > -               fix_filename(prefix, (const char
> > > **)&monitor.log);
> > >                 if (strncmp(monitor.log, "./syslog", 8) == 0)
> > >                         ndctl_set_log_fn((struct ndctl_ctx *)ctx,
> > > log_syslog);
> > >                 else if (strncmp(monitor.log, "./standard", 10)
> > > == 0)
> > >                         ; /*default, already set */
> > > -               else
> > > +               else {
> > > +                       fix_filename(prefix, (const char
> > > + **)&monitor.log);
> > >                         ndctl_set_log_fn((struct ndctl_ctx *)ctx,
> > > log_file);
> > > +               }
> > >         }
> > > 
> > >         if (monitor.daemon) {
> > > 
> > > Thanks,
> > > Masa
> > 
> > Hi Masa,
> > 
> > Thank you very much for your comments.
> > 
> > There are two ways to set monitor.log.
> > a) setting the argument of [--log] option
> > b) setting the value of [log] key in configuration file
> > 
> > When users set monitor.log by b, the prefix will not be added to
> > monitor.log.
> > Therefore, we should do fix_filename() before strncmp().
> 
> Oh, my proposal patch does not cover in case of user set 'syslog' or
> 'standard'in config_file.
> I think your patch fixes the bug correctly, thanks.
> 
> Please feel free to add:
> 
> Reviewed-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

Thanks Qi, Masa - I've applied this.

> 
> Thanks,
> Masa
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
