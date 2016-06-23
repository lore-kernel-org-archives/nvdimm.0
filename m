From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 0/4] Support DAX for device-mapper linear devices
Date: Thu, 23 Jun 2016 17:05:49 -0400
Message-ID: <1466715953-40692-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, toshi.kani-ZPxbGqLxI0U@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Jens, please pick up the first 2 block patches and I'll get the other
2 DM patches staged for 4.8.

v3:
 - fixed "warning: context imbalance in 'dm_blk_direct_access' -
   different lock contexts for basic block" due to missing
   dm_put_live_table in dm_blk_direct_access's dm_get_live_table error
   path
 - refactored dm-table.c code to centralize checking if all devices in
   a DM table support DAX (removed need for target to set
   ->dax_supported)
 - included Yigal Korman's patch to add 'dax' sysfs attribute

Toshi Kani (3):
  block: add QUEUE_FLAG_DAX for devices to advertise their DAX support
  dm: add infrastructure for DAX support
  dm linear: add DAX support

Yigal Korman (1):
  block: expose QUEUE_FLAG_DAX in sysfs

 block/blk-sysfs.c             | 11 +++++++++++
 drivers/block/brd.c           |  4 +++-
 drivers/md/dm-linear.c        | 21 ++++++++++++++++++++-
 drivers/md/dm-table.c         | 44 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm.c               | 38 +++++++++++++++++++++++++++++++++++--
 drivers/md/dm.h               |  1 +
 drivers/nvdimm/pmem.c         |  1 +
 drivers/s390/block/dcssblk.c  |  1 +
 fs/block_dev.c                |  5 +++--
 include/linux/blkdev.h        |  2 ++
 include/linux/device-mapper.h | 10 ++++++++++
 include/uapi/linux/dm-ioctl.h |  4 ++--
 12 files changed, 133 insertions(+), 9 deletions(-)

-- 
2.7.4 (Apple Git-66)
