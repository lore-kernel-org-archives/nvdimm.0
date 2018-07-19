Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8F2BB2098EA8F
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 16:59:44 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 54BA8AC01EE
 for <linux-nvdimm@lists.01.org>; Fri, 20 Jul 2018 08:59:41 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [ndctl PATCH 0/4] misc fixups for ndctl-monitor
Date: Thu, 19 Jul 2018 23:59:39 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3223DA8C79D@g01jpexmbkw24>
References: <20180719225958.6814-1-vishal.l.verma@intel.com>
In-Reply-To: <20180719225958.6814-1-vishal.l.verma@intel.com>
Content-Language: en-US
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
To: 'Vishal Verma' <vishal.l.verma@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Vishal Verma [mailto:vishal.l.verma@intel.com]
> Sent: Friday, July 20, 2018 8:00 AM
> To: linux-nvdimm@lists.01.org
> Cc: Qi, Fuli/斉 福利 <qi.fuli@jp.fujitsu.com>; Vishal Verma
> <vishal.l.verma@intel.com>
> Subject: [ndctl PATCH 0/4] misc fixups for ndctl-monitor
> 
> Fix a couple of issues reported by static analysis, improve the error reporting,
> and add a missing option to the monitor man page
> 
> Vishal Verma (4):
>   ndctl, monitor: Add a config-file section to the man page
>   ndctl, monitor: fix memory leak in read_config_file
>   ndctl, monitor: Fix memory leak in monitor_event
>   ndctl, monitor: improve error reporting throughout monitor.c
> 

Hi Vishal,

Looks good to me.
Thank you very much.
Qi

>  Documentation/ndctl/ndctl-monitor.txt |   5 ++
>  ndctl/monitor.c                       | 129 +++++++++++++++++-----------------
>  2 files changed, 69 insertions(+), 65 deletions(-)
> 
> --
> 2.14.4
> 
> 


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
