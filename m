Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BAB372194D3AE
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 13:43:37 -0800 (PST)
From: Jane Chu <jane.chu@oracle.com>
Subject: 23222f8f8dce6: acpi, nfit: Add function to look up nvdimm device and
 provide SMBIOS handle
Message-ID: <47b0eaaa-ad49-5062-5f1f-fb6f79b2448d@oracle.com>
Date: Fri, 11 Jan 2019 13:43:29 -0800
MIME-Version: 1.0
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: tony.luck@intel.com
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi, Tony,

I happen to be looking at the above patch, and noticed below change in
drivers/acpi/nfit/core.c

+       mutex_lock(&acpi_desc_lock);
+       list_for_each_entry(acpi_desc, &acpi_descs, list) {
+               mutex_lock(&acpi_desc->init_mutex);
+               list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
+                       memdev = __to_nfit_memdev(nfit_mem);
+                       if (memdev->device_handle == device_handle) {
+                               mutex_unlock(&acpi_desc->init_mutex);
+                               mutex_unlock(&acpi_desc_lock);
+                               *flags = memdev->flags;   <-----
+                               return memdev->physical_id;
+                       }
+               }
+               mutex_unlock(&acpi_desc->init_mutex);
+       }
+       mutex_unlock(&acpi_desc_lock);

Is there a reason to retrieve the memdev->flags value after releasing
the locks?

Thanks!
-jane

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
