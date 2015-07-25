Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 12/25] i915: switch from acpi_os_ioremap to ioremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 24 Jul 2015 22:39:04 -0400
Message-ID: <20150725023904.8664.84461.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>, dri-devel@lists.freedesktop.org, rmk+kernel@arm.linux.org.uk, Daniel Vetter <daniel.vetter@intel.com>, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

acpi_os_ioremap uses cached mappings, however it appears that i915
wants to read dynamic platform state.  Switch to ioremap() to prevent it
reading stale state from cache.

Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/gpu/drm/i915/intel_opregion.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index 481337436f72..16ba7c67410d 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -863,7 +863,7 @@ int intel_opregion_setup(struct drm_device *dev)
 	INIT_WORK(&opregion->asle_work, asle_work);
 #endif
 
-	base = acpi_os_ioremap(asls, OPREGION_SIZE);
+	base = ioremap(asls, OPREGION_SIZE);
 	if (!base)
 		return -ENOMEM;
 

