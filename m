Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CC815C9A
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 23:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668642091; x=1700178091;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to;
  bh=453B5mw51T7IX+AXE0lYBsFPvcN1QxhgkLQ4Y5mYFRM=;
  b=KRYa9XGCWZ0eliOl0NrcdlqiW9fmdqoQfeu2YgsoiYhkQzJnQFJje5Em
   uF/LSITfYX0prLsqG4yj0L0C9+PENoSZYk9QeG6MUzEuHG5+44bg2u9oh
   NjiUU5fAkWISG8C2hZmTUPbPW9kZY6HwP3ut3MwN4a0btAPw4qoaOqlQE
   i83LeqBZiTrJVjaLxwZ6btHYSkISs407HZ34RE7A1X50L3ABrlHyBCFuH
   PTxNpweB9ejYyHd/r4PlRJrHyIoNfwbNwfw+ozko2nQivoKvxUWTdujlS
   +fNBUJr7PFuLjI4YFfPW9UEW3O9mLh79lQCTKwUA9l2ikqXTKvNbe/Lto
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="339519706"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="339519706"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 15:41:28 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="641848525"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="641848525"
Received: from jjeyaram-mobl1.amr.corp.intel.com (HELO [192.168.1.28]) ([10.212.1.223])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 15:41:28 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 16 Nov 2022 16:37:37 -0700
Subject: [PATCH v2 2/2] ACPI: HMAT: Fix initiator registration for single-initiator
 systems
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20221116-acpi_hmat_fix-v2-2-3712569be691@intel.com>
References: <20221116-acpi_hmat_fix-v2-0-3712569be691@intel.com>
In-Reply-To: <20221116-acpi_hmat_fix-v2-0-3712569be691@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
 linux-kernel@vger.kernel.org, Chris Piper <chris.d.piper@intel.com>, nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org,
 "Rafael J. Wysocki" <rafael@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Liu Shixin <liushixin2@huawei.com>, stable@vger.kernel.org
X-Mailer: b4 0.11.0-dev-d1636
X-Developer-Signature: v=1; a=openpgp-sha256; l=3352;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=453B5mw51T7IX+AXE0lYBsFPvcN1QxhgkLQ4Y5mYFRM=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmlpeqsYdp2c6xeZyWxh7anfNhvw1H+WbRO+Ayz2zwZr7Sk
 i787SlkYxLgYZMUUWf7u+ch4TG57Pk9ggiPMHFYmkCEMXJwCMJFb0gz/U172aH6qFWVgmvjmX+DGCo
 6b/u//7ddaqnris2xwmIJqOcM/s9eXn8WKzOXZu3v/G7uVJ4siwiUDNFq8lde3/XYJcs7nBgA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

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

Add a new helper to consume the sorted initiator list, and generate the
nodemask, decoupling it from the overloaded initiator_cmp() comparision
callback. This prevents the singular list corner case naturally, and
makes the code easier to follow as well.

Cc: <stable@vger.kernel.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Chris Piper <chris.d.piper@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/acpi/numa/hmat.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index 144a84f429ed..6cceca64a6bc 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -562,17 +562,26 @@ static int initiator_cmp(void *priv, const struct list_head *a,
 {
 	struct memory_initiator *ia;
 	struct memory_initiator *ib;
-	unsigned long *p_nodes = priv;
 
 	ia = list_entry(a, struct memory_initiator, node);
 	ib = list_entry(b, struct memory_initiator, node);
 
-	set_bit(ia->processor_pxm, p_nodes);
-	set_bit(ib->processor_pxm, p_nodes);
-
 	return ia->processor_pxm - ib->processor_pxm;
 }
 
+static int initiators_to_nodemask(unsigned long *p_nodes)
+{
+	struct memory_initiator *initiator;
+
+	if (list_empty(&initiators))
+		return -ENXIO;
+
+	list_for_each_entry(initiator, &initiators, node)
+		set_bit(initiator->processor_pxm, p_nodes);
+
+	return 0;
+}
+
 static void hmat_register_target_initiators(struct memory_target *target)
 {
 	static DECLARE_BITMAP(p_nodes, MAX_NUMNODES);
@@ -609,7 +618,10 @@ static void hmat_register_target_initiators(struct memory_target *target)
 	 * initiators.
 	 */
 	bitmap_zero(p_nodes, MAX_NUMNODES);
-	list_sort(p_nodes, &initiators, initiator_cmp);
+	list_sort(NULL, &initiators, initiator_cmp);
+	if (initiators_to_nodemask(p_nodes) < 0)
+		return;
+
 	if (!access0done) {
 		for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
 			loc = localities_types[i];
@@ -643,7 +655,9 @@ static void hmat_register_target_initiators(struct memory_target *target)
 
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
