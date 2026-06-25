Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C9C3DB63D
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386961; cv=none; b=n9Ap5zbLEX/ribRJwrkJusptPGe/C/PD7L07BGZQ2SVJ8zwUFxQ6pJmnzIoreOtA37MM6gq0DmC9IeNy5MnWHIsVkxf5G1Xc46cpP5remlHBtgDAsoN7wQ/a8UgNfcuTDMrTC1hIF7shvsOLa0PdnIAt44L33wA9KfZE0g8zUME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386961; c=relaxed/simple;
	bh=phNb/Cv7MIb+nqtCqQ1+NhpCPbZrQpgvxiP2mqsDqT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lqe+qyKUBxGna1Zi2fb+fXeRiyFDDHy0AMHEgHXPq96pnDvrsHaoeqDexsIgqSFKnMf6Hawwx8i37HcKGKbBMYBNPbXCsaP4bQbRu4+qEla5kMzO3acWCj/4mpkvo0nWGzBEeRuqyafLk76uep5gD1eNwb91NtZkhff8Jc5ZRRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rS4VPnyC; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rS4VPnyC"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-30bf132969bso3018932eec.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386959; x=1782991759; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V8DekyuZFm8kNJKd8ijojgD5FjCszYptkn1mojUsymk=;
        b=rS4VPnyC8UJfZAn1zqltK1TM9Ayac904JLWU8+a+7F6wA07U5beB9Qa+Ft3SkY2oY0
         Q8m6g9W6kPvCYmms9z4JIp33UgNpjT7nuc0jtSCc2q+4FK1QmZVVJAbJ0VUUEZ3INf7F
         B5yDDRU9Dq2schCjWfFXhJ+cblbCwh8Q0qtG5USXAUya8yHGdYlu3VRSyecNR+T4gXXX
         ASrdnjaewTYVAXw3x8SF30PYftINPwhRQdHLJ8T67vpSYhSwy3N3u46YK0BC8zFhhSeZ
         u82UYX8xD+HfwEkdztawW6NZsxVj5DoDTjZJgCVrq+zGVw3rRXMdKOTV9GWQ7DXSnak/
         OpPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386959; x=1782991759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V8DekyuZFm8kNJKd8ijojgD5FjCszYptkn1mojUsymk=;
        b=CvmTFvB8/M5lVrXqo/wEc1Xgr8NUYxWPETZKanGVtaylQE1BVMuOvw9gyhhrpzOTHZ
         1VZCRaqyqjyGjl4SXMAbEr/I22UMmUkPWaZsPs+2srfuLRdnhELfCqvaD6Ra5A4xoRoj
         pqcMp/0mB0fwnFprA8oBY+pqnnAz3bhqFQqsFguSD30qaQrMpP048fmfZGp3t9X4d1PX
         vAKR4vZ5l6wxDTGfstBewa/waVCIPR+USbX4a1ZLQ4Cv6Ely46cbff6pwa67Y788wMPq
         vhJGf204WBuZqVfGkgmaKB6SilNIBMmCPs7+fZPhtc+Tn6akFp9Jh+YMEY2C0l2b0zBl
         yB5Q==
X-Gm-Message-State: AOJu0YyuerxCKMkH7qcMiWCS1Axzr3OJocunD1HtTpQu5CSPcGIFIsfM
	lNaoClri+seGT3IMi5WyoJ/gASokqlDnIe0DPEU/tTYXr2FbzIybrOGjL+J2jA==
X-Gm-Gg: AfdE7cnPvzk5rnLuUfmUXV3CeQcV17sOkL6FQhUimt39HnO1NjFaFJglvKjakDD4oC7
	HjhQrlTNfXfcik7Fh4Kpm3JSXXNG24aP3YciCM0nHAHs2c2afGWnm/h6hhCtXZLnrB5NZI3Lp8v
	phTsZl90AQ5vR+RxV/XSO/H99Amg3w0IlqJhoRMkycUa9ArhBjmPNE9udv8P50FHPNWPnXCMjUG
	zi6256MQQHsP9ADUcxJMGPI9+McN5tjXwTWJsLDiA2s4GjXG0SDqhJ+z8jlDjUO3SYzwBEdHsMb
	3jS79gmm6MrSV12UwDVwpoHKUlPlnFedCemh4F9NQ5hipWV6RIm1iQ/xaCacpq+oJ63IKkWhPZk
	jjffLf7b4/NaawCl4sX5m2gMbkRaQOtw11FOKXB6URqDkivqAwdJ7En3TzL7TsEOkDxY+cdt0+o
	fZz0BLuI/CKgV8TdsNMyhwhZjmUGcLm8rxHiP5vYcfP20Gpc0HUC65I0O2UrKWKc4eKT0T7Zzm4
	MA5o6w=
X-Received: by 2002:a05:7301:2a08:b0:307:e4fa:894b with SMTP id 5a478bee46e88-30c84ba3223mr2722276eec.8.1782386958440;
        Thu, 25 Jun 2026 04:29:18 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:29:18 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v11 31/31] Documentation/cxl: Document DCD extent handling and DC-backed DAX regions
Date: Thu, 25 Jun 2026 04:05:08 -0700
Message-ID: <20260625112638.550691-32-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112638.550691-1-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Extend the CXL and DAX driver-api documentation to cover Dynamic
Capacity Devices.

cxl-driver.rst gains a "Dynamic Capacity Extents" section describing
the conditions under which the CXL core accepts an offered extent
(per-extent: region resolution, full ED-range containment,
no-overlap, duplicate tolerance; per-tag-group: host-wide tag-uuid
uniqueness, sequence-number integrity, partition equality,
alignment) and the conditions under which a release request is
honoured (DPA-range containment in some member, tag match,
DAX-layer EBUSY deferral, whole-tag-group release).  The host-wide
uniqueness gate is enforced by the cxl_tag_register registry in
drivers/cxl/core/extent.c.  For sequence numbers the doc spells out
both regimes — device-stamped 0..n-1 on sharable allocations and
host-assigned arrival-order 0..n-1 (assigned by cxl_realize_group())
on non-sharable allocations — and notes that the DAX layer sees one
unified 0..n-1 dense invariant.

dax-driver.rst gains a "Dynamic Capacity (DC) Regions" section
that lays out the four-object layering device extent → dc_extent →
dax_resource → DAX device, with cardinalities: one tagged
allocation maps to one cxl_dc_tag_group containing N dc_extents and
N dax_resources, claimed into one DAX device with N range entries
in seq_num order; an untagged Add delivery becomes its own
single-member group.  Each dc_extent carries its own hpa_range —
there is no aggregated bounding-box range across siblings.
Tag-based DAX device creation, DC-only sizing rules (no non-zero
resize, size=0 to destroy), and the uuid attribute semantics are
documented alongside.

Signed-off-by: Anisa Su <anisa.su@samsung.com>
---
 .../driver-api/cxl/linux/cxl-driver.rst       | 149 +++++++++++++++
 .../driver-api/cxl/linux/dax-driver.rst       | 169 ++++++++++++++++++
 2 files changed, 318 insertions(+)

diff --git a/Documentation/driver-api/cxl/linux/cxl-driver.rst b/Documentation/driver-api/cxl/linux/cxl-driver.rst
index dd6dd17dc536..581dca271749 100644
--- a/Documentation/driver-api/cxl/linux/cxl-driver.rst
+++ b/Documentation/driver-api/cxl/linux/cxl-driver.rst
@@ -619,6 +619,155 @@ from HPA to DPA.  This is why they must be aware of the entire interleave set.
 Linux does not support unbalanced interleave configurations.  As a result, all
 endpoints in an interleave set must have the same ways and granularity.
 
+Dynamic Capacity Extents
+========================
+
+A `Dynamic Capacity Device (DCD)` advertises capacity in `DC partitions`
+and surfaces individual chunks of that capacity to the host as `extents`.
+The device may add an extent at any time (a `pending add`) and may
+request that a previously accepted extent be released (a `pending
+release`).  Each transition is mediated by a mailbox handshake whose
+state machine the CXL driver enforces in
+:code:`drivers/cxl/core/{mbox.c,extent.c}`.
+
+Extents that share a non-null tag form one logical allocation.  Each
+surviving member becomes its own :code:`struct dc_extent` (per-extent
+sysfs device, per-extent HPA range); their containing tag group is an
+internal-only :code:`struct cxl_dc_tag_group` keyed by UUID with no
+sysfs identity.  Each :code:`dc_extent` becomes one
+:code:`dax_resource` on the DAX side, and a tagged DAX device is built
+by claiming every :code:`dax_resource` that carries the tag.
+
+For DAX-side semantics — how accepted extents materialize into
+:code:`dax_resource` objects and DAX devices — see
+:doc:`dax-driver`.
+
+Accepting Extents
+-----------------
+Extents are made available to the host from the device through DC ADD events.
+Event records contain extents, which may be tagged or untagged, shared or
+not shared. Multiple event records can by chained together by the `More` flag.
+
+The unit of allocation is a `tag`.  All extents
+sharing a tag form one allocation; the More flag is a delivery boundary
+only, meaning when the More chain ends, the host can assume that all extents
+have been collected for each tag.
+A tag may be the null UUID (an `untagged` allocation, valid in
+non-sharable regions) or a non-null UUID identifying a sharable or
+non-sharable allocation.
+
+When a `More`-terminated chain of pending adds closes, the driver
+processes the pending list one tag group at a time.  A group is
+committed only if it passes every gate below; failing any gate drops
+the entire group with a firmware-bug warning, and the dropped extents
+do not appear in the :code:`ADD_DC_RESPONSE`.  There is no
+partial-extent acceptance — either an offered extent is accepted whole
+or it is dropped whole.
+
+Per-extent gates (applied in :code:`cxl_add_extent`,
+:code:`drivers/cxl/core/extent.c`):
+
+* The extent's DPA range must resolve to a CXL region via
+  :code:`cxl_dpa_to_region()`.  An extent with no owning region is
+  dropped; the device sees the omission from :code:`ADD_DC_RESPONSE`.
+* The extent's DPA range must be `fully contained` in the endpoint
+  decoder's DPA range.  An extent that straddles the decoder boundary
+  is rejected with :code:`-ENXIO`; the driver never clips an extent to
+  fit.
+* The extent must not overlap an extent already present in the same
+  region.  Overlap classification is done in
+  :code:`cxlr_dax_classify_extent()` using :code:`range_overlaps()`.
+  Exact duplicates of a previously-accepted range are tolerated —
+  accepting the same range twice is a no-op, which simplifies
+  probe-time scans of the device's existing accepted list.
+
+Per-group gates (applied in :code:`cxl_add_pending`,
+:code:`drivers/cxl/core/mbox.c`):
+
+* `Host-wide tag uniqueness`: a non-null tag must not already
+  correspond to a live :code:`cxl_dc_tag_group` anywhere on this host.
+  The orchestrator (FM) owns tag-UUID allocation per spec; the
+  registry in :code:`drivers/cxl/core/extent.c`
+  (:code:`cxl_tag_register` / :code:`cxl_tag_already_committed`)
+  catches firmware bugs and orchestrator misbehavior across every
+  region and memdev.  Skipped for the null UUID, which has no
+  cross-chain identity.
+* `Sequence-number integrity`: every member must carry the wire
+  field :code:`shared_extn_seq == 0` (non-sharable allocation), or
+  the group's sorted sequence numbers must be exactly
+  :code:`0, 1, …, n-1` (sharable allocation).  Mixed, gapped,
+  duplicate, or sets that do not start at 0 are rejected.
+* `Partition equality`: every tagged extent in the group must
+  resolve to the same DC partition.  A single allocation cannot span
+  partitions because CDAT describes sharable / writable / coherency
+  attributes per-partition.  Skipped for the null UUID.
+* `Alignment`: every extent's :code:`start_dpa` and :code:`length`
+  must be :code:`PMD_SIZE`-aligned.  Partial acceptance
+  of an aligned subset would leave an unusable DAX device, so the
+  group is dropped instead.
+
+Surviving extents are sorted by the wire field
+:code:`shared_extn_seq` — stable, so arrival order is preserved for
+the all-zero non-sharable case — and each becomes a
+:code:`dc_extent` inserted into a fresh :code:`cxl_dc_tag_group`
+keyed by the group's UUID.  Each :code:`dc_extent` carries its own
+:code:`hpa_range`; the tag group itself has no aggregate range.
+
+As each surviving extent is attached the host assigns it a 0..n-1
+:code:`seq_num`: for sharable allocations this equals the
+device-stamped :code:`shared_extn_seq` directly; for non-sharable
+allocations the device sends :code:`shared_extn_seq == 0` and the
+host fills in the arrival-order position (assigned in
+:code:`cxl_realize_group`).  The DAX layer enforces the same
+:code:`0..n-1` dense invariant in both cases.
+
+The tag group is brought online via :code:`online_tag_group()`,
+which registers every member :code:`dc_extent` as an
+:code:`extentX.Y` child of :code:`cxlr_dax->dev`, the DAX layer is
+notified with :code:`DCD_ADD_CAPACITY`, and the accepted extents are
+spliced into the response list for a single :code:`ADD_DC_RESPONSE`
+mailbox per More-chain.
+
+Releasing Extents
+-----------------
+
+A release may be initiated by the device (a pending release
+notification) or by the host (when destroying a DAX device or tearing
+down a region).  Both paths converge on :code:`cxl_rm_extent`
+(:code:`drivers/cxl/core/extent.c`).
+
+Per-extent gates:
+
+* The DPA range must resolve to a CXL region.  If it does not — for
+  example, an extent left over from a host crash that has not yet
+  been re-claimed, or a duplicate release racing region teardown —
+  the release is acknowledged via :code:`memdev_release_extent()` so
+  the device knows the host is not using the capacity, and the
+  operation returns :code:`-ENXIO`.
+* The DPA range must be `fully contained` in some member
+  :code:`dc_extent`'s :code:`dpa_range` on the region's
+  :code:`cxlr_dax`, and the tag (UUID) on that member's
+  :code:`cxl_dc_tag_group` must match the release request.  Releases
+  are keyed by :code:`(DPA range, tag)` rather than by pointer
+  because the device, not the host, supplies the identity.  A
+  request that matches no :code:`dc_extent` is rejected with
+  :code:`-EINVAL`.
+
+If those gates pass, the DAX layer is notified with
+:code:`DCD_RELEASE_CAPACITY` and consulted for permission to proceed.
+If the DAX layer returns :code:`-EBUSY` — the capacity is still mapped
+or otherwise in use — the release is deferred and
+:code:`cxl_rm_extent` returns success without unregistering anything.
+When the DAX layer ultimately grants release,
+:code:`rm_tag_group()` invalidates the backing memregion once for the
+whole group, then unregisters every member :code:`dc_extent` device,
+which cascades through the DAX layer to drop the corresponding
+:code:`dax_resource`\ s.
+
+The release path is always whole-tag-group: tagged allocations
+release atomically, and the kernel does not split a group in response
+to a sub-range release request.
+
 Example Configurations
 ======================
 .. toctree::
diff --git a/Documentation/driver-api/cxl/linux/dax-driver.rst b/Documentation/driver-api/cxl/linux/dax-driver.rst
index 10d953a2167b..d869bcad41f4 100644
--- a/Documentation/driver-api/cxl/linux/dax-driver.rst
+++ b/Documentation/driver-api/cxl/linux/dax-driver.rst
@@ -27,6 +27,175 @@ CXL capacity in the task's page tables.
 Users wishing to manually handle allocation of CXL memory should use this
 interface.
 
+Dynamic Capacity (DC) Regions
+=============================
+A region backed by a CXL `Dynamic Capacity Device (DCD)` is a `DC region`:
+its HPA window is fixed at probe time, but the DPA capacity that fills the
+window arrives and departs at runtime as the device offers and reclaims
+`extents`.  DC regions are distinguished from static regions by the
+:code:`IORESOURCE_DAX_DCD` flag on the :code:`dax_region`.
+
+For the CXL-side rules governing when an offered extent is accepted or a
+release request is honoured, see :doc:`cxl-driver`.  This section covers
+the DAX-side mapping between accepted extents and DAX devices.
+
+The Extent Layering Model
+-------------------------
+Four objects sit between the wire-level CXL extent and the
+user-visible DAX device.  Understanding the cardinality between them
+is the key to the DC-region model.
+
+::
+
+    device extents     dc_extent           dax_resource         DAX device
+    (CXL device)       (CXL core)          (DAX bus)            (/dev/daxN.Y)
+    -------------      -------------       -------------        ------------
+    e1 ─┐                ┌─► dc_e1 ──►     res_1 (seq=0) ──┐
+    e2 ─┼─── tag A ──►   ┼─► dc_e2 ──►     res_2 (seq=1) ──┼──►  daxN.0
+    e3 ─┘                └─► dc_e3 ──►     res_3 (seq=2) ──┘     (claimed by tag A,
+                                                                   size = Σ |e_i|)
+
+    e4 ─── tag B ────►     dc_e4 ──►       res_4 (seq=0) ────►   daxN.1
+
+    e5 ─── null tag ─►     dc_e5 ──►       res_5 (seq=0) ────►   daxN.2
+    e6 ─── null tag ─►     dc_e6 ──►       res_6 (seq=0) ────►   daxN.3
+
+The CXL core groups extents sharing a non-null tag into a single
+:code:`cxl_dc_tag_group` (internal-only, no sysfs identity), but each
+member extent stays a distinct :code:`dc_extent` with its own HPA
+range.  The DAX bridge creates one :code:`dax_resource` per
+:code:`dc_extent`, and userspace claims a DAX device by writing the
+tag's UUID to the seed device's :code:`uuid` attribute, which carves
+every matching :code:`dax_resource` (in :code:`seq_num` order) into
+the device's :code:`ranges[]` array.
+
+`Device extent`
+  The unit the CXL device delivers over the mailbox: a
+  :code:`(DPA, length, tag, shared_extn_seq)` tuple inside an
+  Add-Capacity event.  The tag is either a non-null UUID (a
+  `tagged allocation`) or the null UUID (`untagged`).
+
+:code:`dc_extent`
+  The CXL core's per-extent object, one per surviving device extent.
+  Each :code:`dc_extent` is registered as its own :code:`extentX.Y`
+  sysfs device under :code:`cxlr_dax->dev` and carries its own
+  :code:`hpa_range` — there is no aggregated / bounding-box HPA
+  range across siblings.  Members of one tag group point at a
+  shared :code:`cxl_dc_tag_group` (which holds the UUID and a
+  manual refcount on the surviving siblings) but otherwise exist as
+  independent kernel objects.
+
+  For a `non-null tag`, the host-wide tag-uniqueness gate
+  (:doc:`cxl-driver`) guarantees there is at most one
+  :code:`cxl_dc_tag_group` per UUID on the host, so the set of
+  :code:`dc_extent`\ s sharing that UUID is a single allocation.
+
+  For the `null tag` there is no cross-event identity — the spec is
+  silent on aggregating untagged extents across Add-Capacity events.
+  Each untagged device extent becomes its own :code:`dc_extent` in
+  its own single-member tag group; two untagged extents delivered
+  separately are two distinct allocations.
+
+:code:`dax_resource`
+  The DAX bus's per-extent view, one-to-one with :code:`dc_extent`.
+  When the CXL DAX driver receives a :code:`DCD_ADD_CAPACITY`
+  notification it iterates the tag group and calls
+  :code:`dax_region_add_resource()` once per member, creating one
+  :code:`dax_resource` per :code:`dc_extent`.  Each
+  :code:`dax_resource` carries that member's HPA range, the tag
+  UUID (copied from :code:`dc_extent->group->uuid`), and a 0..n-1
+  :code:`seq_num` so :code:`uuid_claim_tagged` can carve the matched
+  set into the device's :code:`ranges[]` array in the right order
+  (see :code:`drivers/dax/bus.c`).
+
+`DAX device` (:code:`/dev/daxN.Y`)
+  Created by userspace claiming a set of :code:`dax_resource`\ s via
+  the :code:`uuid` sysfs attribute.  Each DAX device corresponds to
+  exactly one allocation:
+
+  * A `tagged` DAX device is built from every :code:`dax_resource`
+    carrying the tag — one per :code:`dc_extent` in the allocation
+    — carved into the device's :code:`ranges[]` in :code:`seq_num`
+    order.  Its size equals the sum of every member's size.
+  * An `untagged` DAX device is built from one untagged
+    :code:`dax_resource` and its size equals that one extent.
+
+So the end-to-end rule is: **one tagged allocation = one
+cxl_dc_tag_group = N dc_extents = N dax_resources = one DAX device
+with N range entries**.  An untagged device extent becomes its own
+:code:`dc_extent` / :code:`dax_resource` / single-range DAX device,
+claimed one at a time.
+
+Release follows the same layering in reverse.  When the CXL core
+calls :code:`rm_tag_group()` (after the device asks for release and
+the DAX layer consents), the DAX bridge collects every matching
+:code:`dax_resource` and removes them as a set via
+:code:`dax_region_rm_resources()`.  The removal is refuse-all-or-none
+under :code:`dax_region_rwsem`: if any member is in use, the whole
+group stays.  When removal commits, the HPA capacity returns to the
+region's free pool and any DAX device that had claimed it is left
+with no backing capacity.  Userspace tears the DAX device down via
+:code:`daxctl destroy-device` (size=0, then write the device name to
+the region's :code:`delete` attribute).
+
+UUID-Based DAX Device Creation
+------------------------------
+A DAX device on a DC region is created by writing a UUID to the
+seed device's :code:`uuid` attribute
+(:code:`/sys/bus/dax/devices/daxN.Y/uuid`).  The seed starts at
+size 0; writing :code:`uuid` is a `claim` operation that resolves
+the layering above and populates the device:
+
+* A `non-null UUID` claims `every` :code:`dax_resource` whose tag
+  matches.  :code:`uuid_claim_tagged` (in
+  :code:`drivers/dax/bus.c`) collects them, sorts by
+  :code:`seq_num`, enforces the dense :code:`0..n-1` invariant, and
+  carves each via :code:`__dev_dax_resize` in :code:`seq_num` order
+  so the device's :code:`ranges[]` array is dense and ordered.
+  The resulting DAX device represents exactly the tagged
+  allocation: its size equals the sum of every member extent's
+  size.
+
+  The dense :code:`0..n-1` invariant is the unified rule the CXL
+  side maintains for both sharable and non-sharable allocations
+  (see :doc:`cxl-driver`); the match set has exactly one entry per
+  :code:`dc_extent` in the tag group.
+
+* The value :code:`"0"` is shorthand for the null UUID and claims
+  exactly `one` untagged :code:`dax_resource`.  Untagged
+  :code:`dax_resource`\ s correspond to independent untagged
+  allocations; collapsing several into one device would aggregate
+  unrelated capacity, so each :code:`uuid` write consumes a single
+  untagged resource.
+
+* A write that matches no :code:`dax_resource` returns
+  :code:`-ENOENT` and the device remains at size 0.
+
+* Writes to the :code:`uuid` attribute on non-DC regions return
+  :code:`-EOPNOTSUPP`; the attribute itself is read-only (0444) on
+  non-DC devices.
+
+The device's size is determined entirely by the backing allocation:
+users do not choose a size on DC regions.  Accordingly, the
+:code:`size` attribute on a DC DAX device rejects any non-zero resize
+(grow or partial shrink) with :code:`-EOPNOTSUPP`.  Writing :code:`0`
+is still permitted and is
+how :code:`daxctl destroy-device` returns each claimed extent to the
+region's available pool before the device's name is written to the
+region's :code:`delete` attribute.
+
+Reads of :code:`uuid` report the tag identifying the capacity
+backing the device:
+
+* For a non-null-UUID-claimed DC DAX device, :code:`uuid` reads
+  back the claimed UUID.
+* For a DC DAX device claimed via :code:`"0"`, or for any
+  non-DCD DAX device, :code:`uuid` reads back the null UUID
+  (:code:`00000000-0000-0000-0000-000000000000`).
+
+See :code:`Documentation/ABI/testing/sysfs-bus-dax` for the
+authoritative attribute contracts.
+
 kmem conversion
 ===============
 The :code:`dax_kmem` driver converts a `DAX Device` into a series of `hotplug
-- 
2.43.0

