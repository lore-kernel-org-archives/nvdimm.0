Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 010BC21F85E65
 for <linux-nvdimm@lists.01.org>; Sun,  1 Apr 2018 17:10:34 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 0EC0DAC0065
 for <linux-nvdimm@lists.01.org>; Mon,  2 Apr 2018 09:10:28 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [RFC PATCH v4] ndctl: monitor: add ndctl monitor daemon
Date: Mon, 2 Apr 2018 00:10:25 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222764B881@g01jpexmbkw01>
References: <20180313113308.2136-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jPghKyQ6AuVJ-R=fiKcQufzHs-DExzcyHTbshF-2bq1Q@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764A26E@g01jpexmbkw01>
 <CAPcyv4jGnJ7geYUsQxjnSiHnRwCOWx8HOYVcx+Bom7AfRYLsyA@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764B6A2@g01jpexmbkw01>
 <CAPcyv4gVxw8OCnm0PsbC0PrBxpUBupvkK=w4L4p=gWQRsk4ouQ@mail.gmail.com>
In-Reply-To: <CAPcyv4gVxw8OCnm0PsbC0PrBxpUBupvkK=w4L4p=gWQRsk4ouQ@mail.gmail.com>
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
To: 'Dan Williams' <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> >>
> >> This seems to needlessly tie ndctl to systemd, it should be able to
> >> operate without requiring systemd. I expect it would be
> >> straightforward to copy the configuration file implementation from git.
> >
> > Would you like to explain why it should be able to operate without requiring
> systemd?
> 
> systemd is not universally available in all distributions and it is useful to have custom
> configuration files for manually started daemons.
> 
> Another consideration is that a sub-set of monitoring activities can be done without
> root privileges. It would be unforunate if a user could not specify changes to the
> configuration because those files are root-only and owned by systemd.
> 
> > The reason we want to add the configuration file is that when starting
> > the monitors by systemd, options and arguments cannot be passed by systemd.
> > When we start monitors by using "# ndctl monitor" command, we do not
> > need any configuration files, because options and arguments can be added
> directly.
> >
> > Furthermore, if we choose configuration file implementation, we may encounter
> the following problem.
> > If we start the monitor with command like "# ndctl monitor --dimm
> > nmem1 --daemon --conf-file /etc/ndctl.conf", when the variable of dimm
> > in configuration file is not the same as the argument of [--dimm] option, which
> argument should the filter_dimm() refer to?
> 
> The command line option should union with the configuration file for filtering options.
> I.e. if the config file says to monitor nmem0 and the command line says to monitor
> nmem1 then the tool should monitor both. If there are other settings the might be
> in conflict then command line should override the configuration file.
> 
> This matches the policy of most daemons that I have encountered in Linux.

OK, I see. Thank you very much.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
