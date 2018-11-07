Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B6A1B21A07A82
 for <linux-nvdimm@lists.01.org>; Wed,  7 Nov 2018 15:42:37 -0800 (PST)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 7/8] device-dax: Add support for a dax override driver
Date: Wed, 7 Nov 2018 23:42:35 +0000
Message-ID: <3501c074cf14f6a671632c6a6aaffe77cc5b9512.camel@intel.com>
References: <154095556915.3271337.12581429676272726902.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154095560594.3271337.11620109886861134971.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154095560594.3271337.11620109886861134971.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <26905435016A1943B616359192FCFA31@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-10-30 at 20:13 -0700, Dan Williams wrote:
> Introduce the 'new_id' concept for enabling a custom device-driver attach
> policy for dax-bus drivers. The intended use is to have a mechanism for
> hot-plugging device-dax ranges into the page allocator on-demand. With
> this in place the default policy of using device-dax for performance
> differentiated memory can be overridden by user-space policy that can
> arrange for the memory range to be managed as 'System RAM' with
> user-defined NUMA and other performance attributes.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/dax/bus.c    |  145 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  drivers/dax/bus.h    |   10 +++
>  drivers/dax/device.c |   11 ++--
>  3 files changed, 156 insertions(+), 10 deletions(-)
> 
> 

Here's an incremental fixup for the string matching in this patch, I'll
send a v2 if other review comments come in:

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 178d76504f79..17af6fbc3be5 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -39,7 +39,7 @@ static struct dax_id *__dax_match_id(struct dax_device_driver *dax_drv,
 	lockdep_assert_held(&dax_bus_lock);
 
 	list_for_each_entry(dax_id, &dax_drv->ids, list)
-		if (strcmp(dax_id->dev_name, dev_name) == 0)
+		if (sysfs_streq(dax_id->dev_name, dev_name))
 			return dax_id;
 	return NULL;
 }
@@ -60,6 +60,7 @@ static ssize_t do_id_store(struct device_driver *drv, const char *buf,
 {
 	struct dax_device_driver *dax_drv = to_dax_drv(drv);
 	unsigned int region_id, id;
+	char devname[DAX_NAME_LEN];
 	struct dax_id *dax_id;
 	ssize_t rc = count;
 	int fields;
@@ -67,8 +68,8 @@ static ssize_t do_id_store(struct device_driver *drv, const char *buf,
 	fields = sscanf(buf, "dax%d.%d", &region_id, &id);
 	if (fields != 2)
 		return -EINVAL;
-
-	if (strlen(buf) + 1 > DAX_NAME_LEN)
+	sprintf(devname, "dax%d.%d", region_id, id);
+	if (!sysfs_streq(buf, devname))
 		return -EINVAL;
 
 	mutex_lock(&dax_bus_lock);
@@ -99,7 +100,6 @@ static ssize_t new_id_store(struct device_driver *drv, const char *buf,
 }
 static DRIVER_ATTR_WO(new_id);
 
-
 static ssize_t remove_id_store(struct device_driver *drv, const char *buf,
 		size_t count)
 {


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
