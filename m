Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH 13/15] libnvdimm: flag libnvdimm block devices as
 non-rotational
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jun 2015 19:55:57 -0400
Message-ID: <20150617235557.12943.75518.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-nvdimm@lists.01.org
Cc: boaz@plexistor.com, toshi.kani@hp.com, Vishal Verma <vishal.l.verma@linux.intel.com>, linux-kernel@vger.kernel.org, hch@lst.de, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

...since they are effectively SSDs as far as userspace is concerned.

Reviewed-by: Vishal Verma <vishal.l.verma@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 99cf95af5f24..fa82f215990d 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -220,6 +220,7 @@ void nd_blk_queue_init(struct request_queue *q)
 	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
 	if (IS_ENABLED(CONFIG_ND_IOSTAT))
 		queue_flag_set_unlocked(QUEUE_FLAG_IO_STAT, q);
+	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
 }
 EXPORT_SYMBOL(nd_blk_queue_init);
 

