Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com
 [209.85.210.194])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4770821B02822
 for <linux-nvdimm@lists.01.org>; Mon,  5 Nov 2018 16:42:31 -0800 (PST)
Received: by mail-pf1-f194.google.com with SMTP id u13-v6so5258292pfm.4
 for <linux-nvdimm@lists.01.org>; Mon, 05 Nov 2018 16:42:31 -0800 (PST)
Message-ID: <1541464948.196084.168.camel@acm.org>
Subject: Re: [driver-core PATCH v5 1/9] workqueue: Provide queue_work_node
 to queue work near a given NUMA node
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 05 Nov 2018 16:42:28 -0800
In-Reply-To: <154145230445.29224.14651284855380723028.stgit@ahduyck-desk1.jf.intel.com>
References: <154145223352.29224.8912797012647157172.stgit@ahduyck-desk1.jf.intel.com>
 <154145230445.29224.14651284855380723028.stgit@ahduyck-desk1.jf.intel.com>
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
> +/**
> + * workqueue_select_cpu_near - Select a CPU based on NUMA node
> + * @node: NUMA node ID that we want to bind a CPU from
                                          ^^^^
                                          select?
> +	/* If CPU is valid return that, otherwise just defer */
> +	return (cpu < nr_cpu_ids) ? cpu : WORK_CPU_UNBOUND;

Please leave out the superfluous parentheses if this patch series would have to
be reposted.

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
