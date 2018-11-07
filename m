Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it1-x141.google.com (mail-it1-x141.google.com
 [IPv6:2607:f8b0:4864:20::141])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5A7AC203B99BB
 for <linux-nvdimm@lists.01.org>; Tue,  6 Nov 2018 16:52:57 -0800 (PST)
Received: by mail-it1-x141.google.com with SMTP id h13so20696065itl.1
 for <linux-nvdimm@lists.01.org>; Tue, 06 Nov 2018 16:52:57 -0800 (PST)
MIME-Version: 1.0
References: <154145232484.29224.1635232599636954462.stgit@ahduyck-desk1.jf.intel.com>
 <201811061228.iteFLO2p%fengguang.wu@intel.com>
 <1541548274.196084.197.camel@acm.org>
In-Reply-To: <1541548274.196084.197.camel@acm.org>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Tue, 6 Nov 2018 16:52:45 -0800
Message-ID: <CAKgT0Ue61y6qMH3sKH6-M_eHy4Lc5p6k27LFXwmVooAL48KyYQ@mail.gmail.com>
Subject: Re: [driver-core PATCH v5 5/9] driver core: Establish clear order of
 operations for deferred probe and remove
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
To: bvanassche@acm.org
Cc: len.brown@intel.com, kbuild test robot <lkp@intel.com>, linux-pm@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>, linux-nvdimm@lists.01.org, jiangshanlai@gmail.com, LKML <linux-kernel@vger.kernel.org>, kbuild-all@01.org, pavel@ucw.cz, zwisler@kernel.org, Tejun Heo <tj@kernel.org>, alexander.h.duyck@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>, rafael@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 6, 2018 at 3:51 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On Tue, 2018-11-06 at 12:10 +0800, kbuild test robot wrote:
> > Hi Alexander,
> >
> > Thank you for the patch! Perhaps something to improve:
> >
> > [auto build test WARNING on driver-core/master]
> >
> > url:    https://github.com/0day-ci/linux/commits/Alexander-Duyck/Add-NUMA-aware-async_schedule-calls/20181106-093800
> > reproduce: make htmldocs
> >
> > All warnings (new ones prefixed by >>):
> >
> >    include/net/mac80211.h:1001: warning: Function parameter or member 'status.is_valid_ack_signal' not described in 'ieee80211_tx_info'
> > [ ... ]
>
> There are plenty of references in this report to header files not touched
> by patch 5/9 in this series. I assume that this report indicates a bug in
> the 0-day testing infrastructure?
>
> Bart.

It isn't a bug. It is pointing out the same thing you did. I didn't
document the async_probe value so it added a warning to the list.

>> include/linux/device.h:1056: warning: Function parameter or member 'async_probe' not described in 'device'

I'll fix it for the next version.

- Alex
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
