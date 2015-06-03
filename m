Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 2/3] acpi: Add export to acpi_map_pxm_to_node()
Date: Tue,  2 Jun 2015 18:26:51 -0600
Message-Id: <1433291212-23367-3-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1433291212-23367-1-git-send-email-toshi.kani@hp.com>
References: <1433291212-23367-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rjw@rjwysocki.net, dan.j.williams@intel.com
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

acpi_get_node() allows ACPI kernel modules to map a proximity ID
to a node ID from ACPI _PXM method.  Some ACPI static tables,
such as SRAT, DMAR, PMTT and NFIT, also contain proximity IDs.

This patch exports acpi_map_pxm_to_node() so that ACPI kernel
modules can call this function to map a proximity ID to a node ID
from an ACPI static table as well.

When CONFIG_ACPI_NUMA is not set, acpi_map_pxm_to_node() always
returns 0.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/numa.c  |    1 +
 include/linux/acpi.h |    5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 4898082..8f50d5d 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -90,6 +90,7 @@ int acpi_map_pxm_to_node(int pxm)
 
 	return node;
 }
+EXPORT_SYMBOL(acpi_map_pxm_to_node);
 
 static void __init
 acpi_table_print_srat_entry(struct acpi_subtable_header *header)
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index e4da5e3..7a76e51 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -289,8 +289,13 @@ extern void acpi_dmi_osi_linux(int enable, const struct dmi_system_id *d);
 extern void acpi_osi_setup(char *str);
 
 #ifdef CONFIG_ACPI_NUMA
+int acpi_map_pxm_to_node(int pxm);
 int acpi_get_node(acpi_handle handle);
 #else
+static inline int acpi_map_pxm_to_node(int pxm)
+{
+	return 0;
+}
 static inline int acpi_get_node(acpi_handle handle)
 {
 	return 0;
