Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com
 [209.85.214.196])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3BE122112FACC
 for <linux-nvdimm@lists.01.org>; Tue,  6 Nov 2018 15:51:17 -0800 (PST)
Received: by mail-pl1-f196.google.com with SMTP id w22-v6so3648865plk.0
 for <linux-nvdimm@lists.01.org>; Tue, 06 Nov 2018 15:51:17 -0800 (PST)
Message-ID: <1541548274.196084.197.camel@acm.org>
Subject: Re: [driver-core PATCH v5 5/9] driver core: Establish clear order
 of operations for deferred probe and remove
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 06 Nov 2018 15:51:14 -0800
In-Reply-To: <201811061228.iteFLO2p%fengguang.wu@intel.com>
References: <154145232484.29224.1635232599636954462.stgit@ahduyck-desk1.jf.intel.com>
 <201811061228.iteFLO2p%fengguang.wu@intel.com>
Mime-Version: 1.0
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
To: kbuild test robot <lkp@intel.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: len.brown@intel.com, linux-nvdimm@lists.01.org, gregkh@linuxfoundation.org, linux-pm@vger.kernel.org, jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, kbuild-all@01.org, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org, rafael@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-11-06 at 12:10 +0800, kbuild test robot wrote:
> Hi Alexander,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on driver-core/master]
> 
> url:    https://github.com/0day-ci/linux/commits/Alexander-Duyck/Add-NUMA-aware-async_schedule-calls/20181106-093800
> reproduce: make htmldocs
> 
> All warnings (new ones prefixed by >>):
> 
>    include/net/mac80211.h:1001: warning: Function parameter or member 'status.is_valid_ack_signal' not described in 'ieee80211_tx_info'
> [ ... ]

There are plenty of references in this report to header files not touched
by patch 5/9 in this series. I assume that this report indicates a bug in
the 0-day testing infrastructure?

Bart.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
