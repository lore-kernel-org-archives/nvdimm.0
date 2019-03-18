Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from Galois.linutronix.de (Galois.linutronix.de
 [IPv6:2a01:7a0:2:106d:700::1])
 (using TLSv1.2 with cipher AES128-SHA (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB174211D2317
 for <linux-nvdimm@lists.01.org>; Mon, 18 Mar 2019 04:40:38 -0700 (PDT)
Date: Mon, 18 Mar 2019 12:40:17 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH RT] nvdimm: make lane acquirement RT aware
Message-ID: <20190318114017.tazjaegln2obt3zg@linutronix.de>
References: <20190306095709.23138-1-yongxin.liu@windriver.com>
 <20190307143344.ytsnbmot5tjzjhip@linutronix.de>
 <597B109EC20B76429F71A8A97770610D12A52669@ALA-MBD.corp.ad.wrs.com>
 <20190308094131.ge4wbsvz4p6xikdf@linutronix.de>
 <597B109EC20B76429F71A8A97770610D12A5643B@ALA-MBD.corp.ad.wrs.com>
 <20190315164236.rzbwe7reeprjv3um@linutronix.de>
 <597B109EC20B76429F71A8A97770610D12A63C81@ALA-MBD.corp.ad.wrs.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <597B109EC20B76429F71A8A97770610D12A63C81@ALA-MBD.corp.ad.wrs.com>
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
To: "Liu, Yongxin" <Yongxin.Liu@windriver.com>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "Gortmaker, Paul  <Paul.Gortmaker@windriver.com>, tglx@linutronix.de" <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

On 2019-03-18 01:41:10 [+0000], Liu, Yongxin wrote:
> 
> Consider the recursive call to nd_region_acquire_lane() in the following situation.
> Will there be a dead lock?
> 
> 
>     Thread A                    Thread B
>        |                           |
>        |                           |
>      CPU 1                       CPU 2
>        |                           |
>        |                           |
>  get lock for Lane 1         get lock for Lane 2
>        |                           |
>        |                           |
>  migrate to CPU 2            migrate to CPU 1
>        |                           |
>        |                           |
>  wait lock for Lane 2        wait lock for Lane 1 
>        |                           |
>        |                           |
>        _____________________________
>                    |
>                 dead lock ?

Bummer. That would dead lock indeed.
Is it easily possible to recognize the recursive case? 

> 
> Thanks,
> Yognxin

Sebastian
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
