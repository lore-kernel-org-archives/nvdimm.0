Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 34B9B1A1E34
 for <linux-nvdimm@lists.01.org>; Mon, 13 Jun 2016 15:32:21 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 5/6] dm, dm-linear: Add dax_supported to dm_target
Date: Mon, 13 Jun 2016 16:21:36 -0600
Message-Id: <1465856497-19698-6-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
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
To: agk@redhat.com, snitzer@redhat.com, dan.j.williams@intel.com
Cc: axboe@kernel.dk, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, viro@zeniv.linux.org.uk
List-ID: <linux-nvdimm@lists.01.org>

Extend 'struct dm_target' to have dax_supported bit, which allows
dm-table to check if a dm-target supports DAX.

Change dm-linear to set this bit when its target physical device
supports DAX.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/md/dm-linear.c        |    2 ++
 include/linux/device-mapper.h |    5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 49bd7d2..6fdbbc8 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -59,6 +59,8 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_write_same_bios = 1;
+	if (lc->dev->bdev->bd_disk->flags & GENHD_FL_DAX)
+		ti->dax_supported = 1;
 	ti->private = lc;
 	return 0;
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 16e6c8c..9b72989 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -290,6 +290,11 @@ struct dm_target {
 	 * Set if this target does not return zeroes on discarded blocks.
 	 */
 	bool discard_zeroes_data_unsupported:1;
+
+	/*
+	 * Set if the target supports DAX (direct access).
+	 */
+	bool dax_supported:1;
 };
 
 /* Each target can link one of these into the table */
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
