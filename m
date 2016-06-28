Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D26B1A1E06
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 12:38:00 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 0/2] Support DAX for device-mapper dm-linear devices
Date: Tue, 28 Jun 2016 13:37:14 -0600
Message-Id: <1467142636-21094-1-git-send-email-toshi.kani@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: snitzer@redhat.com
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

I noticed that dm-snap reloads DM table of target mapped-device, which
fails for dax-capable device after dax support is added.  Ideally,
adding dax support to dm-snap solves the issue, but it cannot be done
easily.  This patch-set allows dm-snap to work with dax-capable target
devices when bio-based operation is used.

dax operation is unsupported with dm-snap, such that:
 a) After snapshot is taken, mount with dax option to a target device
    or a snapshot device fails.  They can be mounted without dax.
 b) After snapshot is taken to a dax-mounted target device, any writes 
    to the target device fails (EIO).

b) can be protected by changing lvcreate to fail when snapshot is
requested to a dax-mounted target device. 

- Patch 1 solves an error when lvremove is made to a snapshot device.
- Patch 2 solves an error when lvcreate --snapshot is made to a dax-
  capable device.

---
Toshi Kani (2):
 1/2 dm: update table type check for dax
 2/2 dm snap: add fake origin_direct_access

---
 drivers/md/dm-ioctl.c | 11 ++++++++++-
 drivers/md/dm-snap.c  |  8 ++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
