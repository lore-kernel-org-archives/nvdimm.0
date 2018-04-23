Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE8F122512129
 for <linux-nvdimm@lists.01.org>; Mon, 23 Apr 2018 16:31:02 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Mon, 23 Apr 2018 17:30:37 -0600
Message-Id: <20180423233046.21476-6-logang@deltatee.com>
In-Reply-To: <20180423233046.21476-1-logang@deltatee.com>
References: <20180423233046.21476-1-logang@deltatee.com>
Subject: [PATCH v4 05/14] docs-rst: Add a new directory for PCI documentation
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
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Linus Walleij <linus.walleij@linaro.org>, Keith Busch <keith.busch@intel.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>, Vinod Koul <vinod.koul@intel.com>, Jason Gunthorpe <jgg@mellanox.com>, Thierry Reding <treding@nvidia.com>, Alex Williamson <alex.williamson@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Sagar Dharia <sdharia@codeaurora.org>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Sanyog Kale <sanyog.r.kale@intel.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>

Add a new directory in the driver API guide for PCI specific
documentation.

This is in preparation for adding a new PCI P2P DMA driver writers
guide which will go in this directory.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Sanyog Kale <sanyog.r.kale@intel.com>
Cc: Sagar Dharia <sdharia@codeaurora.org>
---
 Documentation/driver-api/index.rst         |  2 +-
 Documentation/driver-api/pci/index.rst     | 19 +++++++++++++++++++
 Documentation/driver-api/{ => pci}/pci.rst |  0
 3 files changed, 20 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/driver-api/pci/index.rst
 rename Documentation/driver-api/{ => pci}/pci.rst (100%)

diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
index 6d8352c0f354..9e4cd4e91a49 100644
--- a/Documentation/driver-api/index.rst
+++ b/Documentation/driver-api/index.rst
@@ -27,7 +27,7 @@ available subsections can be seen below.
    iio/index
    input
    usb/index
-   pci
+   pci/index
    spi
    i2c
    hsi
diff --git a/Documentation/driver-api/pci/index.rst b/Documentation/driver-api/pci/index.rst
new file mode 100644
index 000000000000..03b57cbf8cc2
--- /dev/null
+++ b/Documentation/driver-api/pci/index.rst
@@ -0,0 +1,19 @@
+============================================
+The Linux PCI driver implementer's API guide
+============================================
+
+.. class:: toc-title
+
+	   Table of contents
+
+.. toctree::
+   :maxdepth: 2
+
+   pci
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/driver-api/pci.rst b/Documentation/driver-api/pci/pci.rst
similarity index 100%
rename from Documentation/driver-api/pci.rst
rename to Documentation/driver-api/pci/pci.rst
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
