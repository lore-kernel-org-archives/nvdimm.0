Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A36C02117D76C
 for <linux-nvdimm@lists.01.org>; Tue,  6 Nov 2018 08:25:56 -0800 (PST)
Message-ID: <9a6a3359da7b0c43b58efc5510fdaab109f3a393.camel@linux.intel.com>
Subject: Re: [driver-core PATCH v5 0/9] Add NUMA aware async_schedule calls
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Tue, 06 Nov 2018 08:25:56 -0800
In-Reply-To: <1541465425.196084.170.camel@acm.org>
References: <154145223352.29224.8912797012647157172.stgit@ahduyck-desk1.jf.intel.com>
 <1541465425.196084.170.camel@acm.org>
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
To: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: len.brown@intel.com, linux-pm@vger.kernel.org, rafael@kernel.org, jiangshanlai@gmail.com, linux-nvdimm@lists.01.org, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2018-11-05 at 16:50 -0800, Bart Van Assche wrote:
> On Mon, 2018-11-05 at 13:11 -0800, Alexander Duyck wrote:
> > This patch set provides functionality that will help to improve the
> > locality of the async_schedule calls used to provide deferred
> > initialization.
> 
> Hi Alexander,
> 
> Is this patch series perhaps available in a public git tree? That would make
> it easier for me to test my sd changes on top of your patches than applying
> this patch series myself on kernel v4.20-rc1.
> 
> Thanks,
> 
> Bart.

Hi Bart,

Unfortunately I don't have a public git tree to host this on.

You may want to see if you can just put the patches together as a
bundle in patchwork and download them off of lore.kernel.org at:
https://lore.kernel.org/patchwork/project/lkml/list/?series=371783

Thanks.

-Alex

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
