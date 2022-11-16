Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DB22560
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 07:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668585472; x=1700121472;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=verj7hVUBInaUTF3sejWeZjrgjgv2y6v3Lf9mbwz5Qg=;
  b=eeKy3heDMO9Lh4mdH1jhW56IHjRTWECtmhn0kLwx2gJqTDrYw/jtET1d
   kwAVipq5bNXP14gp12CbvqCiuQRveB3/Olrip8mUJ8KbDnc82DFZGhg2a
   zgvrqO5oq/kITBpcTHCKmTrdzfiqvYHUovOYUvY5vIWdZE5+J2418h8Eb
   KzY7toLRNGMnGEPIiqudkHNvqHN2djkg74kAd+jghIktoQS83NAIEsEmY
   HGyAHJSgVJ/B+xtZGhUP0xsCuzqQE+x8bsVPCfS0YIQTJdfUgquwq5awG
   rCho6LQMNkxdLgESGPGkwzU2HxWCa39wPkEYhiBRgLoeo4vGrqvPMG9pa
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="292186382"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="292186382"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 23:57:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="702769368"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="702769368"
Received: from ake-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.189.231])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 23:57:48 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-acpi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	liushixin2@huawei.com,
	Vishal Verma <vishal.l.verma@intel.com>,
	Chris Piper <chris.d.piper@intel.com>,
	stable@vger.kernel.org,
	"Rafael J . Wysocki" <rafael@kernel.org>
Subject: [PATCH 2/2] ACPI: HMAT: Fix initiator registration for single-initiator systems
Date: Wed, 16 Nov 2022 00:57:36 -0700
Message-Id: <20221116075736.1909690-3-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116075736.1909690-1-vishal.l.verma@intel.com>
References: <20221116075736.1909690-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3279; h=from:subject; bh=verj7hVUBInaUTF3sejWeZjrgjgv2y6v3Lf9mbwz5Qg=; b=owGbwMvMwCXGf25diOft7jLG02pJDMkl0z9svJ/buO2c3Rtu9enxRRNuzgtbEmQ67VaDm8jbhSIb 5/RP7ShlYRDjYpAVU2T5u+cj4zG57fk8gQmOMHNYmUCGMHBxCsBECqIY/vs7MtucytbScuKRXbFYMr ro6v09R37KLFjgFX8/0Z2j8AnDH47sSynStb89puWtldx+bNK/fQLWPxZavtp/xEj2bdZzRjYA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

In a system with a single initiator node, and one or more memory-only
'target' nodes, the memory-only node(s) would fail to register their
initiator node correctly. i.e. in sysfs:

  # ls /sys/devices/system/node/node0/access0/targets/
  node0

Where as the correct behavior should be:

  # ls /sys/devices/system/node/node0/access0/targets/
  node0 node1

This happened because hmat_register_target_initiators() uses list_sort()
to sort the initiator list, but the sort comparision function
(initiator_cmp()) is overloaded to also set the node mask's bits.

In a system with a single initiator, the list is singular, and list_sort
elides the comparision helper call. Thus the node mask never gets set,
and the subsequent search for the best initiator comes up empty.

Add a new helper to sort the initiator list, and handle the singular
list corner case by setting the node mask for that explicitly.

Reported-by: Chris Piper <chris.d.piper@intel.com>
Cc: <stable@vger.kernel.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/acpi/numa/hmat.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index 144a84f429ed..cd20b0e9cdfa 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -573,6 +573,30 @@ static int initiator_cmp(void *priv, const struct list_head *a,
 	return ia->processor_pxm - ib->processor_pxm;
 }
 
+static int initiators_to_nodemask(unsigned long *p_nodes)
+{
+	/*
+	 * list_sort doesn't call @cmp (initiator_cmp) for 0 or 1 sized lists.
+	 * For a single-initiator system with other memory-only nodes, this
+	 * means an empty p_nodes mask, since that is set by initiator_cmp().
+	 * Special case the singular list, and make sure the node mask gets set
+	 * appropriately.
+	 */
+	if (list_empty(&initiators))
+		return -ENXIO;
+
+	if (list_is_singular(&initiators)) {
+		struct memory_initiator *initiator = list_first_entry(
+			&initiators, struct memory_initiator, node);
+
+		set_bit(initiator->processor_pxm, p_nodes);
+		return 0;
+	}
+
+	list_sort(p_nodes, &initiators, initiator_cmp);
+	return 0;
+}
+
 static void hmat_register_target_initiators(struct memory_target *target)
 {
 	static DECLARE_BITMAP(p_nodes, MAX_NUMNODES);
@@ -609,7 +633,9 @@ static void hmat_register_target_initiators(struct memory_target *target)
 	 * initiators.
 	 */
 	bitmap_zero(p_nodes, MAX_NUMNODES);
-	list_sort(p_nodes, &initiators, initiator_cmp);
+	if (initiators_to_nodemask(p_nodes) < 0)
+		return;
+
 	if (!access0done) {
 		for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
 			loc = localities_types[i];
@@ -643,7 +669,9 @@ static void hmat_register_target_initiators(struct memory_target *target)
 
 	/* Access 1 ignores Generic Initiators */
 	bitmap_zero(p_nodes, MAX_NUMNODES);
-	list_sort(p_nodes, &initiators, initiator_cmp);
+	if (initiators_to_nodemask(p_nodes) < 0)
+		return;
+
 	for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
 		loc = localities_types[i];
 		if (!loc)
-- 
2.38.1

