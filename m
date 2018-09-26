Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw1-xc44.google.com (mail-yw1-xc44.google.com
 [IPv6:2607:f8b0:4864:20::c44])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2195021157438
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 15:10:00 -0700 (PDT)
Received: by mail-yw1-xc44.google.com with SMTP id y76-v6so262151ywd.2
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 15:10:00 -0700 (PDT)
Date: Wed, 26 Sep 2018 15:09:57 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC workqueue/driver-core PATCH 1/5] workqueue: Provide
 queue_work_near to queue work near a given NUMA node
Message-ID: <20180926220957.GB270328@devbig004.ftw2.facebook.com>
References: <20180926214433.13512.30289.stgit@localhost.localdomain>
 <20180926215138.13512.33146.stgit@localhost.localdomain>
 <20180926215307.GA270328@devbig004.ftw2.facebook.com>
 <9b002bbb-3e6d-9e99-d8f9-36df4306093e@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9b002bbb-3e6d-9e99-d8f9-36df4306093e@linux.intel.com>
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
To: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: len.brown@intel.com, linux-pm@vger.kernel.org, gregkh@linuxfoundation.org, linux-nvdimm@lists.01.org, jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, zwisler@kernel.org, pavel@ucw.cz, rafael@kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

Hello,

On Wed, Sep 26, 2018 at 03:05:17PM -0700, Alexander Duyck wrote:
> I am using unbound workqueues. However there isn't an interface that
> exposes the NUMA bits of them directly. All I am doing with this
> patch is adding "queue_work_near" which takes a NUMA node as an
> argument and then copies the logic of "queue_work_on" with the
> exception that I am doing a check to verify that there is an
> intersection between wq_unbound_cpumask and the cpumask of the node,
> and then passing a CPU from that intersection into "__queue_work".

Can it just take a cpu id and not feed that to __queue_work()?  That
looks like a lot of extra logic.

Thanks.

-- 
tejun
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
