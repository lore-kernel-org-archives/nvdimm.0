Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com
 [209.85.214.196])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DEC4A21A07A92
 for <linux-nvdimm@lists.01.org>; Mon,  5 Nov 2018 16:50:27 -0800 (PST)
Received: by mail-pl1-f196.google.com with SMTP id n4-v6so5307852plp.2
 for <linux-nvdimm@lists.01.org>; Mon, 05 Nov 2018 16:50:27 -0800 (PST)
Message-ID: <1541465425.196084.170.camel@acm.org>
Subject: Re: [driver-core PATCH v5 0/9] Add NUMA aware async_schedule calls
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 05 Nov 2018 16:50:25 -0800
In-Reply-To: <154145223352.29224.8912797012647157172.stgit@ahduyck-desk1.jf.intel.com>
References: <154145223352.29224.8912797012647157172.stgit@ahduyck-desk1.jf.intel.com>
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
To: Alexander Duyck <alexander.h.duyck@linux.intel.com>, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: len.brown@intel.com, linux-pm@vger.kernel.org, rafael@kernel.org, jiangshanlai@gmail.com, linux-nvdimm@lists.01.org, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2018-11-05 at 13:11 -0800, Alexander Duyck wrote:
> This patch set provides functionality that will help to improve the
> locality of the async_schedule calls used to provide deferred
> initialization.

Hi Alexander,

Is this patch series perhaps available in a public git tree? That would make
it easier for me to test my sd changes on top of your patches than applying
this patch series myself on kernel v4.20-rc1.

Thanks,

Bart.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
