Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mailrelay104.isp.belgacom.be (mailrelay104.isp.belgacom.be
 [195.238.20.131])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9979B81F74
 for <linux-nvdimm@lists.01.org>; Sat,  3 Dec 2016 10:54:14 -0800 (PST)
From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2 3/3 libnvdimm-pending] libnvdimm,
 namespace: use octal for permissions
Date: Sat,  3 Dec 2016 19:54:06 +0100
Message-Id: <1480791246-21449-1-git-send-email-fabf@skynet.be>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: fabf@skynet.be, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

According to commit f90774e1fd27
("checkpatch: look for symbolic permissions and suggest octal instead")

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: applied on top of libnvdimm-pending
    Use calculated value instead of a | b (Suggested by Dan Williams)

 drivers/nvdimm/namespace_devs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 7569ba7..6bf60f3 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1132,7 +1132,7 @@ static ssize_t size_show(struct device *dev,
 	return sprintf(buf, "%llu\n", (unsigned long long)
 			nvdimm_namespace_capacity(to_ndns(dev)));
 }
-static DEVICE_ATTR(size, S_IRUGO, size_show, size_store);
+static DEVICE_ATTR(size, 0444, size_show, size_store);
 
 static u8 *namespace_to_uuid(struct device *dev)
 {
@@ -1456,7 +1456,7 @@ static umode_t namespace_visible(struct kobject *kobj,
 
 	if (is_namespace_pmem(dev) || is_namespace_blk(dev)) {
 		if (a == &dev_attr_size.attr)
-			return S_IWUSR | S_IRUGO;
+			return 0644;
 
 		if (is_namespace_pmem(dev) && a == &dev_attr_sector_size.attr)
 			return 0;
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
