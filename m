Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com
 [209.85.210.193])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB44B211944CD
 for <linux-nvdimm@lists.01.org>; Mon, 10 Dec 2018 11:22:20 -0800 (PST)
Received: by mail-pf1-f193.google.com with SMTP id b7so5860140pfi.8
 for <linux-nvdimm@lists.01.org>; Mon, 10 Dec 2018 11:22:20 -0800 (PST)
Date: Mon, 10 Dec 2018 11:22:16 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [driver-core PATCH v8 0/9] Add NUMA aware async_schedule calls
Message-ID: <20181210192216.GJ28501@garbanzo.do-not-panic.com>
References: <154403054034.11544.3978949383914046587.stgit@ahduyck-desk1.jf.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <154403054034.11544.3978949383914046587.stgit@ahduyck-desk1.jf.intel.com>
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
Cc: len.brown@intel.com, bvanassche@acm.org, linux-pm@vger.kernel.org, gregkh@linuxfoundation.org, linux-nvdimm@lists.01.org, jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org, rafael@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 05, 2018 at 09:25:13AM -0800, Alexander Duyck wrote:
> This patch set provides functionality that will help to improve the
> locality of the async_schedule calls used to provide deferred
> initialization.
> 
> This patch set originally started out focused on just the one call to
> async_schedule_domain in the nvdimm tree that was being used to defer the
> device_add call however after doing some digging I realized the scope of
> this was much broader than I had originally planned. As such I went
> through and reworked the underlying infrastructure down to replacing the
> queue_work call itself with a function of my own and opted to try and
> provide a NUMA aware solution that would work for a broader audience.
> 
> In addition I have added several tweaks and/or clean-ups to the front of the
> patch set. Patches 1 through 4 address a number of issues that actually were
> causing the existing async_schedule calls to not show the performance that
> they could due to either not scaling on a per device basis, or due to issues
> that could result in a potential deadlock. For example, patch 4 addresses the
> fact that we were calling async_schedule once per driver instead of once
> per device, and as a result we would have still ended up with devices
> being probed on a non-local node without addressing this first.

No tests were added. Again, I think it would be good to add test
cases to showcase the old mechanisms, illustrate the new, and ensure
we don't regress both now and also help us ensure we don't regress
moving forward.

This is all too critical of a path for the kernel, and these changes
are rather instrusive. I'd readlly like to see test code for it now
rather than later.

  Luis
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
