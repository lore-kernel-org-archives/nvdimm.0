Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A658A2117D76C
 for <linux-nvdimm@lists.01.org>; Tue,  6 Nov 2018 08:27:19 -0800 (PST)
Message-ID: <c7f9e6b6b3d7e2217f93bb23b16589dd5dc0b092.camel@linux.intel.com>
Subject: Re: [driver-core PATCH v5 1/9] workqueue: Provide queue_work_node
 to queue work near a given NUMA node
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Tue, 06 Nov 2018 08:27:19 -0800
In-Reply-To: <1541464948.196084.168.camel@acm.org>
References: <154145223352.29224.8912797012647157172.stgit@ahduyck-desk1.jf.intel.com>
 <154145230445.29224.14651284855380723028.stgit@ahduyck-desk1.jf.intel.com>
 <1541464948.196084.168.camel@acm.org>
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

On Mon, 2018-11-05 at 16:42 -0800, Bart Van Assche wrote:
> On Mon, 2018-11-05 at 13:11 -0800, Alexander Duyck wrote:
> > +/**
> > + * workqueue_select_cpu_near - Select a CPU based on NUMA node
> > + * @node: NUMA node ID that we want to bind a CPU from
> 
>                                           ^^^^
>                                           select?
> > +	/* If CPU is valid return that, otherwise just defer */
> > +	return (cpu < nr_cpu_ids) ? cpu : WORK_CPU_UNBOUND;
> 
> Please leave out the superfluous parentheses if this patch series would have to
> be reposted.
> 
> Anyway:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

I will incorporate you suggestions and add your Reviewed-by for the
next submission.

Thanks.

- Alex

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
