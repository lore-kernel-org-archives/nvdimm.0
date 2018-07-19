Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 401DF2097F55F
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jul 2018 17:43:00 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v13 0/5] ndctl, monitor: add ndctl monitor daemon
Date: Thu, 19 Jul 2018 00:42:56 +0000
Message-ID: <1531960975.7574.162.camel@intel.com>
References: <20180713233350.7148-1-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180713233350.7148-1-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
Content-ID: <8F16891460E59D4D9DF1EF6181FE55B9@intel.com>
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
Cc: "tokunaga.keiich@jp.fujitsu.com" <tokunaga.keiich@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>


On Sat, 2018-07-14 at 08:33 +0900, QI Fuli wrote:
> This is the v13 patch for ndctl monitor, a tiny daemon to monitor
> the smart events of nvdimm DIMMs. Since NVDIMM does not have a
> feature like mirroring, if it breaks down, the data will be
> impossible to restore. Ndctl monitor daemon will catch the smart
> events notify from firmware and outputs notification to logfile,
> therefore users can replace NVDIMM before it is completely broken.
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>

Hi Qi,

This looks great, thank you for all the updates!

I have applied the series to my local tree, and expect to push it out
to the pending branch soon. I will also add reviewed-by tags for Dan
(with his permission) since he has been integral to the review of this
series.

I'm also separately sending out the bash completion updates for the
monitor command.

Thank you,

	-Vishal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
