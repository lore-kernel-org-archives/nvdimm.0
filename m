Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw1-xc44.google.com (mail-yw1-xc44.google.com
 [IPv6:2607:f8b0:4864:20::c44])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0DB0621157438
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 14:53:10 -0700 (PDT)
Received: by mail-yw1-xc44.google.com with SMTP id v1-v6so233882ywv.6
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 14:53:10 -0700 (PDT)
Date: Wed, 26 Sep 2018 14:53:07 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC workqueue/driver-core PATCH 1/5] workqueue: Provide
 queue_work_near to queue work near a given NUMA node
Message-ID: <20180926215307.GA270328@devbig004.ftw2.facebook.com>
References: <20180926214433.13512.30289.stgit@localhost.localdomain>
 <20180926215138.13512.33146.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180926215138.13512.33146.stgit@localhost.localdomain>
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

On Wed, Sep 26, 2018 at 02:51:38PM -0700, Alexander Duyck wrote:
> This patch provides a new function queue_work_near which is meant to
> schedule work on the nearest unbound CPU to the requested NUMA node. The
> main motivation for this is to help assist asynchronous init to better
> improve boot times for devices that are local to a specific node.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Why not just use unbound workqueues, which are NUMA-affine by default?
Are there big enough advantages?

Thanks.

-- 
tejun
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
