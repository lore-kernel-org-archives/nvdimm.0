Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BAFFC226FAA9A
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 16:17:30 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id F417FAC0171
 for <linux-nvdimm@lists.01.org>; Fri,  6 Apr 2018 08:17:25 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [RFC PATCH v4] ndctl: monitor: add ndctl monitor daemon
Date: Thu, 5 Apr 2018 23:17:23 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222764C387@g01jpexmbkw01>
References: <20180313113308.2136-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jPghKyQ6AuVJ-R=fiKcQufzHs-DExzcyHTbshF-2bq1Q@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764A26E@g01jpexmbkw01>
 <CAPcyv4jGnJ7geYUsQxjnSiHnRwCOWx8HOYVcx+Bom7AfRYLsyA@mail.gmail.com>
In-Reply-To: <CAPcyv4jGnJ7geYUsQxjnSiHnRwCOWx8HOYVcx+Bom7AfRYLsyA@mail.gmail.com>
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

> >
> > I prefer to add an EnvironmentFile like /etc/sysconfig/ndctl/monitor
> > to systemd rather than add a configuration file. According to [1],
> > environment variable substitution is supported in systemd.service, so
> > we can define the variables through
> "EnvironmentFile=/etc/sysconfig/ndctl/monitor".
> > In this fashion, we do not need to add any extra codes to parse the configuration
> file.
> >
> > In this case, [--conf-file] option is not necessary either.
> > According to [2], sytemd units can be instantiated from a template
> > file, thus we only need to add a template unit file in advance.
> > If user wants to run multiple monitors with different configurations,
> > they can differentiate them by adding multiple EnvironmentFiles, like
> /etc/sysconfig/ndctl/<monitor1...n>.
> > Then the monitors can be started by command like "# systemctl start
> > ndctl-monitor@<monitor1...n>.service".
> >
> > When the monitors started by hand, it will do not need any
> > configuration files, because we can add options and parameters directly.
> >
> > [1]https://www.freedesktop.org/software/systemd/man/systemd.service.ht
> > ml
> > [2]https://www.freedesktop.org/software/systemd/man/systemd.unit.html
> 
> This seems to needlessly tie ndctl to systemd, it should be able to operate without
> requiring systemd. I expect it would be straightforward to copy the configuration file
> implementation from git.

I have read the configuration file implementation of git, my understanding is that git daemon does not
have any options used to override default configuration. 
I want to confirm if the configuration file is only used for ndctl monitor.
If yes, I do not think copy the configuration file implementation from git is a good choice,
because only getting keys and values from configuration file is needed for us and the structure of
configuration file implementation in git is too complexity. 
I prefer to borrow from udev[1], because the implementation in udev is simpler and it seems ndctl also borrows a lot from udev.

[1] https://git.kernel.org/pub/scm/linux/hotplug/udev.git/tree/src/libudev.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
