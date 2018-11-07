Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com
 [209.85.214.194])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C80E02118A593
 for <linux-nvdimm@lists.01.org>; Tue,  6 Nov 2018 16:24:52 -0800 (PST)
Received: by mail-pl1-f194.google.com with SMTP id p6-v6so7002813pll.4
 for <linux-nvdimm@lists.01.org>; Tue, 06 Nov 2018 16:24:52 -0800 (PST)
Message-ID: <1541550290.196084.201.camel@acm.org>
Subject: Re: [driver-core PATCH v5 8/9] PM core: Use new async_schedule_dev
 command
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 06 Nov 2018 16:24:50 -0800
In-Reply-To: <154145234017.29224.9183571187943571535.stgit@ahduyck-desk1.jf.intel.com>
References: <154145223352.29224.8912797012647157172.stgit@ahduyck-desk1.jf.intel.com>
 <154145234017.29224.9183571187943571535.stgit@ahduyck-desk1.jf.intel.com>
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

On Mon, 2018-11-05 at 13:12 -0800, Alexander Duyck wrote:
> This change makes it so that we use the device specific version of the
> async_schedule commands to defer various tasks related to power management.
> By doing this we should see a slight improvement in performance as any
> device that is sensitive to latency/locality in the setup will now be
> initializing on the node closest to the device.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
