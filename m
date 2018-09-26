Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9669B21B02822
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 14:51:33 -0700 (PDT)
Subject: [RFC workqueue/driver-core PATCH 0/5] Add NUMA aware async_schedule
 calls
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 26 Sep 2018 14:51:32 -0700
Message-ID: <20180926214433.13512.30289.stgit@localhost.localdomain>
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
To: linux-nvdimm@lists.01.org, gregkh@linuxfoundation.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org, akpm@linux-foundation.org
Cc: len.brown@intel.com, rafael@kernel.org, jiangshanlai@gmail.com, pavel@ucw.cz, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This patch set provides functionality that will help to improve the
locality of the async_schedule calls used to provide deferred
initialization.

This patch set originally started out with me focused on just the one call
to async_schedule_domain in the nvdimm tree that was being used to
defer the device_add call however after doing some digging I realized the
scope of this was much broader than I had originally planned. As such I
went through and reworked the underlying infrastructure down to replacing
the queue_work call itself with a function of my own and opted to try and
provide a NUMA aware solution that would work for a broader audience.

I am submitting this an RFC to figure out just how far off I am from where
I need to be on this patch set and to determine which tree I should
ultimately be submitting this to.

---

Alexander Duyck (5):
      workqueue: Provide queue_work_near to queue work near a given NUMA node
      async: Add support for queueing on specific NUMA node
      driver core: Probe devices asynchronously instead of the driver
      driver core: Use new async_schedule_dev command
      nvdimm: Schedule device registration on node local to the device


 drivers/base/bus.c        |   23 +-------
 drivers/base/dd.c         |   44 +++++++++++++++
 drivers/base/power/main.c |   12 ++--
 drivers/nvdimm/bus.c      |   11 +++-
 include/linux/async.h     |   27 ++++++++-
 include/linux/workqueue.h |    2 +
 kernel/async.c            |   62 ++++++++++++++++------
 kernel/workqueue.c        |  129 ++++++++++++++++++++++++++++++++++++++++++++-
 8 files changed, 258 insertions(+), 52 deletions(-)

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
