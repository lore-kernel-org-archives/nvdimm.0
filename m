Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 938481A1F67
 for <linux-nvdimm@lists.01.org>; Fri, 27 May 2016 14:04:08 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: release v53
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 27 May 2016 14:03:10 -0700
Message-ID: <146438299063.39562.540320520493835866.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This release incorporates the capabilities of the 4.7-rc1 kernel (most
prominently in that kernel 'Device DAX', DAX error handling, and
third-party DSM support).  The ndctl updates include:

New commands / options:
    bash completion for ndctl commands
    DIMM SMART data retrieval (ndctl list --dimms --health)
    ndctl destroy-namespace
    ndctl read-labels

New tests:
    DAX error handling unit test (dax-errors.sh)

Command fixes:
    ndctl list
    ndctl create-namespace

New apis:
    ndctl_cmd_smart_get_alarm_flags
    ndctl_cmd_smart_get_flags
    ndctl_cmd_smart_get_health
    ndctl_cmd_smart_get_life_used
    ndctl_cmd_smart_get_shutdown_state
    ndctl_cmd_smart_get_spares
    ndctl_cmd_smart_get_temperature
    ndctl_cmd_smart_get_vendor_data
    ndctl_cmd_smart_get_vendor_size
    ndctl_cmd_smart_threshold_get_alarm_control
    ndctl_cmd_smart_threshold_get_spares
    ndctl_cmd_smart_threshold_get_temperature
    ndctl_dax_delete
    ndctl_dax_enable
    ndctl_dax_get_align
    ndctl_dax_get_bus
    ndctl_dax_get_ctx
    ndctl_dax_get_daxctl_region
    ndctl_dax_get_devname
    ndctl_dax_get_first
    ndctl_dax_get_id
    ndctl_dax_get_location
    ndctl_dax_get_namespace
    ndctl_dax_get_next
    ndctl_dax_get_region
    ndctl_dax_get_resource
    ndctl_dax_get_size
    ndctl_dax_get_uuid
    ndctl_dax_is_configured
    ndctl_dax_is_enabled
    ndctl_dax_is_valid
    ndctl_dax_set_align
    ndctl_dax_set_location
    ndctl_dax_set_namespace
    ndctl_dax_set_uuid
    ndctl_dimm_cmd_new_smart
    ndctl_dimm_cmd_new_smart_threshold
    ndctl_dimm_get_formatN
    ndctl_dimm_get_formats
    ndctl_dimm_get_subsystem_device
    ndctl_dimm_get_subsystem_revision
    ndctl_dimm_get_subsystem_vendor
    ndctl_dimm_get_unique_id
    ndctl_get_daxctl_ctx
    ndctl_namespace_get_dax
    ndctl_namespace_get_dax
    ndctl_region_get_dax_seed
    daxctl_dev_get_devname
    daxctl_dev_get_first
    daxctl_dev_get_id
    daxctl_dev_get_major
    daxctl_dev_get_minor
    daxctl_dev_get_next
    daxctl_dev_get_region
    daxctl_dev_get_size
    daxctl_get_log_priority
    daxctl_get_userdata
    daxctl_new
    daxctl_new_region
    daxctl_ref
    daxctl_region_get_ctx
    daxctl_region_get_id
    daxctl_region_get_uuid
    daxctl_region_ref
    daxctl_region_unref
    daxctl_region_unref
    daxctl_set_log_fn
    daxctl_set_log_priority
    daxctl_set_userdata
    daxctl_unref

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Makefile.am.in |    4 ++--
 git-version    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile.am.in b/Makefile.am.in
index f3dc8b48c890..7f3a5b283a75 100644
--- a/Makefile.am.in
+++ b/Makefile.am.in
@@ -35,9 +35,9 @@ SED_PROCESS = \
 	-e 's,@includedir\@,$(includedir),g' \
 	< $< > $@ || rm $@
 
-LIBNDCTL_CURRENT=7
+LIBNDCTL_CURRENT=8
 LIBNDCTL_REVISION=0
-LIBNDCTL_AGE=1
+LIBNDCTL_AGE=2
 
 LIBDAXCTL_CURRENT=1
 LIBDAXCTL_REVISION=0
diff --git a/git-version b/git-version
index ea6e26880aea..03b44a613a57 100755
--- a/git-version
+++ b/git-version
@@ -19,7 +19,7 @@ dirty() {
 	fi
 }
 
-DEF_VER=52
+DEF_VER=53
 
 LF='
 '

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
