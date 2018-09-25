Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7AEA72114842B
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 13:53:02 -0700 (PDT)
Subject: [PATCH 1/2] nvdimm: Hold reference on parent while scheduling async
 init
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Tue, 25 Sep 2018 13:53:02 -0700
Message-ID: <20180925205301.6182.58728.stgit@localhost.localdomain>
In-Reply-To: <20180925204801.6182.73167.stgit@localhost.localdomain>
References: <20180925204801.6182.73167.stgit@localhost.localdomain>
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
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Unlike asynchronous initialization in the core we have not yet associated
the device with the parent, and as such the device doesn't hold a reference
to the parent.

In order to resolve that we should be holding a reference on the parent
until the asynchronous initialization has completed.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/nvdimm/bus.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 8aae6dcc839f..9148015ed803 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -488,6 +488,8 @@ static void nd_async_device_register(void *d, async_cookie_t cookie)
 		put_device(dev);
 	}
 	put_device(dev);
+	if (dev->parent)
+		put_device(dev->parent);
 }
 
 static void nd_async_device_unregister(void *d, async_cookie_t cookie)
@@ -507,6 +509,8 @@ void __nd_device_register(struct device *dev)
 	if (!dev)
 		return;
 	dev->bus = &nvdimm_bus_type;
+	if (dev->parent)
+		get_device(dev->parent);
 	get_device(dev);
 	async_schedule_domain(nd_async_device_register, dev,
 			&nd_async_domain);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
