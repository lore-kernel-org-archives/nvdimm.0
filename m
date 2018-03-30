Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5D763225E4025
 for <linux-nvdimm@lists.01.org>; Fri, 30 Mar 2018 00:34:55 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 87F97AC00D0
 for <linux-nvdimm@lists.01.org>; Fri, 30 Mar 2018 16:34:48 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [RFC PATCH v4] ndctl: monitor: add ndctl monitor daemon
Date: Fri, 30 Mar 2018 07:34:46 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222764B6A2@g01jpexmbkw01>
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

> >> > In this implemention, when a ndctl monitor starts with [--daemon]
> >> > option, all the arguments will be saved into a temp file named as
> >> > daemon-name and placed under /etc/sysconfig/ndctl/ directory. The
> >> > temp file would be used as an EnvironmentFile by systemd, and it
> >> > would be deleted automatically when the systemd service is stopped.
> >>
> >> The monitors started by hand should be kept separate from the
> >> monitors started by systemd. The default monitor started by systemd
> >> should get its configuration from /etc/ndctl.conf, and we should
> >> otherwise have a --conf-file option to the monitor to override the
> >> default configuration. Any other monitors started outside of the
> >> systemd should remain independent.
> >>
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

Would you like to explain why it should be able to operate without requiring systemd?
The reason we want to add the configuration file is that when starting the monitors by systemd,
options and arguments cannot be passed by systemd.
When we start monitors by using "# ndctl monitor" command, we do not need any
configuration files, because options and arguments can be added directly.

Furthermore, if we choose configuration file implementation, we may encounter the following problem. 
If we start the monitor with command like "# ndctl monitor --dimm nmem1 --daemon --conf-file /etc/ndctl.conf",
when the variable of dimm in configuration file is not the same as the argument of [--dimm] option,
which argument should the filter_dimm() refer to?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
