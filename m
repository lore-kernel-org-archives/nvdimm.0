Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 61B0F210EB4F9
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 13:43:15 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH 0/4] Some fixups and improvements ndctl monitor
Date: Fri, 10 Aug 2018 20:42:46 +0000
Message-ID: <1533933765.6054.20.camel@intel.com>
References: <20180807131756.23673-1-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180807131756.23673-1-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
Content-ID: <17C9E10E6E2C7A4CA1A991A2F6B79904@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2018-08-07 at 22:17 +0900, QI Fuli wrote:
> Fix a couple of issues about log collection, and add [Install] section
> to systemd unit file of ndclt-monitor.
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
> QI Fuli (4):
>   ndctl, monitor: fix the lack of detection of invalid path of log file
>   ndctl, monitor: set default log destination to syslog if "--daemon" is specified
>   ndctl, monitor: add timestamp and pid to log messages in log_file()
>   ndctl, monitor: add [Install] Section to systemd unit file of ndctl-monitor
> 
>  Documentation/ndctl/ndctl-monitor.txt | 16 +++++++++++++++-
>  ndctl/monitor.c                       | 27 ++++++++++++++++++++++++---
>  ndctl/monitor.conf                    |  2 ++
>  ndctl/ndctl-monitor.service           |  3 +++
>  4 files changed, 44 insertions(+), 4 deletions(-)
> 
Hi Qi,

These look good, applied.

Thanks,
	-Vishal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
