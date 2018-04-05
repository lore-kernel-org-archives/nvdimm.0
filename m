Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym03.jp.fujitsu.com (mgwym03.jp.fujitsu.com [211.128.242.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BBF5C226FAA78
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 14:09:05 -0700 (PDT)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 42994AC00AE
 for <linux-nvdimm@lists.01.org>; Fri,  6 Apr 2018 06:08:59 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [RFC PATCH v4] ndctl: monitor: add ndctl monitor daemon
Date: Thu, 5 Apr 2018 21:08:57 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222764C365@g01jpexmbkw01>
References: <20180313113308.2136-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jPghKyQ6AuVJ-R=fiKcQufzHs-DExzcyHTbshF-2bq1Q@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764A26E@g01jpexmbkw01>
 <x497epnnizi.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x497epnnizi.fsf@segfault.boston.devel.redhat.com>
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
To: 'Jeff Moyer' <jmoyer@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Jeff Moyer [mailto:jmoyer@redhat.com]
> Sent: Wednesday, April 4, 2018 11:29 PM
> To: Qi, Fuli/斉 福利 <qi.fuli@jp.fujitsu.com>
> Cc: 'Dan Williams' <dan.j.williams@intel.com>; linux-nvdimm
> <linux-nvdimm@lists.01.org>
> Subject: Re: [RFC PATCH v4] ndctl: monitor: add ndctl monitor daemon
> 
> "Qi, Fuli" <qi.fuli@jp.fujitsu.com> writes:
> 
> >> > In this implemention, when a ndctl monitor starts with [--daemon]
> >> > option, all the arguments will be saved into a temp file named as
> >> > daemon-name and placed under /etc/sysconfig/ndctl/ directory. The
> >> > temp file would be used as an EnvironmentFile by systemd, and it
> >> > would be deleted automatically when the systemd service is stopped.
> 
> IIRC, /etc/sysconfig is not present on non-Red Hat OSes.  Additionally, for Red Hat
> OSes, /etc/sysconfig/<app>/ does not replace daemon configuration files.
> 
Thank you very much for your information.
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
