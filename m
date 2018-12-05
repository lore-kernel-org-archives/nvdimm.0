Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [driver-core PATCH v8 0/9] Add NUMA aware async_schedule calls
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 05 Dec 2018 09:25:13 -0800
Message-ID: <154403054034.11544.3978949383914046587.stgit@ahduyck-desk1.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: mcgrof@kernel.org, linux-nvdimm@lists.01.org, tj@kernel.org, akpm@linux-foundation.org, linux-pm@vger.kernel.org, jiangshanlai@gmail.com, rafael@kernel.org, len.brown@intel.com, pavel@ucw.cz, zwisler@kernel.org, dan.j.williams@intel.com, dave.jiang@intel.com, bvanassche@acm.org, alexander.h.duyck@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

This patch set provides functionality that will help to improve the
locality of the async_schedule calls used to provide deferred
initialization.

This patch set originally started out focused on just the one call to
async_schedule_domain in the nvdimm tree that was being used to defer the
device_add call however after doing some digging I realized the scope of
this was much broader than I had originally planned. As such I went
through and reworked the underlying infrastructure down to replacing the
queue_work call itself with a function of my own and opted to try and
provide a NUMA aware solution that would work for a broader audience.

In addition I have added several tweaks and/or clean-ups to the front of the
patch set. Patches 1 through 4 address a number of issues that actually were
causing the existing async_schedule calls to not show the performance that
they could due to either not scaling on a per device basis, or due to issues
that could result in a potential deadlock. For example, patch 4 addresses the
fact that we were calling async_schedule once per driver instead of once
per device, and as a result we would have still ended up with devices
being probed on a non-local node without addressing this first.

RFC->v1:
    Dropped nvdimm patch to submit later.
        It relies on code in libnvdimm development tree.
    Simplified queue_work_near to just convert node into a CPU.
    Split up drivers core and PM core patches.
v1->v2:
    Renamed queue_work_near to queue_work_node
    Added WARN_ON_ONCE if we use queue_work_node with per-cpu workqueue
v2->v3:
    Added Acked-by for queue_work_node patch
    Continued rename from _near to _node to be consistent with queue_work_node
        Renamed async_schedule_near_domain to async_schedule_node_domain
        Renamed async_schedule_near to async_schedule_node
    Added kerneldoc for new async_schedule_XXX functions
    Updated patch description for patch 4 to include data on potential gains
v3->v4
    Added patch to consolidate use of need_parent_lock
    Make asynchronous driver probing explicit about use of drvdata
v4->v5
    Added patch to move async_synchronize_full to address deadlock
    Added bit async_probe to act as mutex for probe/remove calls
    Added back nvdimm patch as code it relies on is now in Linus's tree
    Incorporated review comments on parent & device locking consolidation
    Rebased on latest linux-next
v5->v6:
    Drop the "This patch" or "This change" from start of patch descriptions.
    Drop unnecessary parenthesis in first patch
    Use same wording for "selecting a CPU" in comments added in first patch
    Added kernel documentation for async_probe member of device
    Fixed up comments for async_schedule calls in patch 2
    Moved code related setting async driver out of device.h and into dd.c
    Added Reviewed-by for several patches
v6->v7:
    Fixed typo which had kernel doc refer to "lock" when I meant "unlock"
    Dropped "bool X:1" to "u8 X:1" from patch description
    Added async_driver to device_private structure to store driver
    Dropped unecessary code shuffle from async_probe patch
    Reordered patches to move fixes up to front
    Added Reviewed-by for several patches
    Updated cover page and patch descriptions throughout the set
v7->v8:
    Replaced async_probe value with dead, only apply dead in device_del
    Dropped Reviewed-by from patch 2 due to significant changes
    Added Reviewed-by for patches reviewed by Luis Chamberlain

---

Alexander Duyck (9):
      driver core: Move async_synchronize_full call
      driver core: Establish order of operations for device_add and device_del via bitflag
      device core: Consolidate locking and unlocking of parent and device
      driver core: Probe devices asynchronously instead of the driver
      workqueue: Provide queue_work_node to queue work near a given NUMA node
      async: Add support for queueing on specific NUMA node
      driver core: Attach devices on CPU local to device node
      PM core: Use new async_schedule_dev command
      libnvdimm: Schedule device registration on node local to the device


 drivers/base/base.h       |    4 +
 drivers/base/bus.c        |   46 ++------------
 drivers/base/core.c       |   11 +++
 drivers/base/dd.c         |  152 ++++++++++++++++++++++++++++++++++++++-------
 drivers/base/power/main.c |   12 ++--
 drivers/nvdimm/bus.c      |   11 ++-
 include/linux/async.h     |   82 +++++++++++++++++++++++-
 include/linux/device.h    |    5 +
 include/linux/workqueue.h |    2 +
 kernel/async.c            |   53 +++++++++-------
 kernel/workqueue.c        |   84 +++++++++++++++++++++++++
 11 files changed, 362 insertions(+), 100 deletions(-)

--
