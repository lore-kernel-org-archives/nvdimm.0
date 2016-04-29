Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5424.austin.hp.com (g1t5424.austin.hp.com [15.216.225.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 15A7F1A1F61
 for <linux-nvdimm@lists.01.org>; Fri, 29 Apr 2016 13:48:26 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 0/3] Add alignment check for DAX mount
Date: Fri, 29 Apr 2016 14:39:32 -0600
Message-Id: <1461962375-3720-1-git-send-email-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com, david@fromorbit.com, jack@suse.cz
Cc: tytso@mit.edu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When a partition is not aligned by 4KB, mount -o dax succeeds,
but any read/write access to the filesystem fails, except for
metadata update.

Add alignment check to ext4, ext2, and xfs.

---
Toshi Kani (3):
 1/3 ext4: Add alignment check for DAX mount
 2/3 ext2: Add alignment check for DAX mount
 3/3 xfs: Add alignment check for DAX mount

---
 fs/ext2/super.c    | 6 ++++++
 fs/ext4/super.c    | 6 ++++++
 fs/xfs/xfs_super.c | 6 ++++++
 3 files changed, 18 insertions(+)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
