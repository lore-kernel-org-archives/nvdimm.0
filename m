Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B5434CDD;
	Wed,  5 Nov 2025 23:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762386536; cv=none; b=AuByZ7OPXki5OHb1JzVgUEYVrkyxWO8NhXLWBeubGCx91KspHwN5VGBdDaBROplD7f4ZZdzbZH6L9HcZyyR/o+w36XSWEneysiPbf/QT/dPNAcHCODRvdLCDuZUHIlVHHqJFOLdcqC+v8qJg4/br0U0KQ6kkPVoTkC9kFmZR6+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762386536; c=relaxed/simple;
	bh=qZ1AxmbOT7SagUvfm9xGUfxuKJ1y/x/eabnQsAtZkwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgyPORPOtY+Jdb+TKrLfoAa3dpc7y9v6Jm2W32UE3+mNBulBrsDiz//T0Sa998dxo44vtG5UYY1gBbYbOG6Y8TrywVQ5ECvkNjSfb+KZ+jf9fFpmy6TtER7cFdSN67cB/7MDFeBVo1pxnmLzU2tI4y+p18T9DZaCoI538UtKwdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E11C4CEF5;
	Wed,  5 Nov 2025 23:48:56 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-acpi@vger.kernel.org
Cc: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	rafael@kernel.org
Subject: [PATCH v3 1/2] acpi/hmat: Return when generic target is updated
Date: Wed,  5 Nov 2025 16:48:47 -0700
Message-ID: <20251105234851.81589-2-dave.jiang@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251105234851.81589-1-dave.jiang@intel.com>
References: <20251105234851.81589-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the current code flow, once the generic target is updated
target->registered is set and the remaining code is skipped.
So return immediately instead of going through the checks and
then skip.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/numa/hmat.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index 5a36d57289b4..1dc73d20d989 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -888,12 +888,13 @@ static void hmat_register_target(struct memory_target *target)
 	 * Register generic port perf numbers. The nid may not be
 	 * initialized and is still NUMA_NO_NODE.
 	 */
-	mutex_lock(&target_lock);
-	if (*(u16 *)target->gen_port_device_handle) {
-		hmat_update_generic_target(target);
-		target->registered = true;
+	scoped_guard(mutex, &target_lock) {
+		if (*(u16 *)target->gen_port_device_handle) {
+			hmat_update_generic_target(target);
+			target->registered = true;
+			return;
+		}
 	}
-	mutex_unlock(&target_lock);
 
 	/*
 	 * Skip offline nodes. This can happen when memory
-- 
2.51.0

