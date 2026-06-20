Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DF24369A;
	Sat, 20 Jun 2026 21:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781991692; cv=none; b=fiaKmubs4grMJqKHAwJgMwTueCbzi6+4DzkSjuKhKBRhds3t3/K+ObJrcJBZ6CiD8afGz9VCwKLuDMrqc8UX70UC88tRYc2jX7dkZ00qNCIbShplEqhHbBz6XKUjw6hMvulkOT9hxLJqqvX2Fmb8aOuehHc08fnKY8VhQ0TDFQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781991692; c=relaxed/simple;
	bh=+r2+fzXDk8IhArvRS1iU67VhC8WNUsQgcPKe2huKEFg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=q+rghnmKdFsFyxb4tpz6wpxR8Qkja1grFpC/hu8PuMzr4MEs1FsVqnY7PKni2ml70oaCsNKRqtyqhoBPtyFTewIpjJZoLx3Hci3BHo6rYx1GH/ASrJ5pTbqJiOqyBLLyVK3w/eD2RHp1IJYyf0D7EBIw6LYa6N2m3DnZL2iq4Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ftSHVT3b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ftSHVT3b"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0068C2BCB0;
	Sat, 20 Jun 2026 21:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781991691;
	bh=+r2+fzXDk8IhArvRS1iU67VhC8WNUsQgcPKe2huKEFg=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=ftSHVT3bYHFA1cnAp5JPANTA6OvkDn0dj17ejJyGAPTMljWZB4J42S2ChRtMsrYrw
	 J7Ye/9JyW6TdSNP3VIXdXWhyGOso9uaHh6quCZtRBgncW855gt8UMtZP5j9nZKYjO3
	 UAvLqQrvtFH7DOqMrdDnjeoC+GiwGVnbuCI9H6bIbkOa0KyPlBD0BmGC6OR+Bu1NaO
	 HOCu0Gxcyt7okI0reiTR+jDifPWsknH7hpmrlNl3djoc5dcTLkeznAWnY0UoHLynpF
	 kq7GcqjKKl+srkePhUA18FqO+l8i4jcIaGF6dTHfuvo+5r+h/3u37LIuBciP1smfAp
	 PoftU5gWL3Nzg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86411CD98F2;
	Sat, 20 Jun 2026 21:41:31 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sat, 20 Jun 2026 16:41:31 -0500
Subject: [PATCH] nvdimm/btt: reject an arena whose nfree is below the lane
 count
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260620-b4-disp-88b2514b-v1-1-3834e707d232@proton.me>
X-B4-Tracking: v=1; b=H4sIAAoJN2oC/x3MQQqAIBBA0avErBsYxcq6SrTQmmo2FgoRiHdPW
 r7F/xkSR+EEU5Mh8iNJrlCh2gbW04WDUbZq0KR76jWhN7hJutFarztlPK6DYuvIu2EkqNkdeZf
 3X85LKR/o3DTmYgAAAA==
To: Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>
Cc: linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781991690; l=2686;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=SRVc7PL0/UeJ4JAXyVEbfu4zyngcHm0zDEpZdxTj7Zg=;
 b=hI3LF2j8X5V6E7w7MIwo9J1GEp2W1PcpiPEvTvhGhFuuiF6Tb1S5I3qH7me12B2G1V+lnF6AU
 6/hccA7sC+5AZwY//v/eYHKlPQQy7yx+j6QU4LvpTbMhhjUVS/MNMFw
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

The BTT info block's nfree field, the number of reserve free blocks, is
read from the medium without validation.  btt_freelist_init() and
btt_rtt_init() size the per-lane freelist[] and rtt[] arrays by nfree,
but the I/O path indexes them by the lane from nd_region_acquire_lane(),
which is bounded by nd_region->num_lanes (ND_MAX_LANES), not by nfree.
A crafted or foreign arena whose nfree is below the lane count makes
freelist[lane]/rtt[lane] run past the allocation: an out-of-bounds write.

btt.rst documents the nlanes = min(nfree, num_cpus) invariant, which the
code does not currently honor: num_lanes is ND_MAX_LANES regardless of
nfree.  Reject an arena whose nfree is below num_lanes at discovery,
before the per-lane arrays are allocated, enforcing that invariant.

Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
nd_btt_arena_is_valid() checks the signature, parent_uuid and a fletcher
checksum, none of which constrain nfree; the checksum is keyless, so a
crafted arena recomputes it.  map_locks[] is indexed modulo nfree and is
unaffected; only the lane-indexed freelist[] and rtt[] are out of bounds.

Reproduced with an out-of-tree module that mirrors btt_rtt_init() ->
btt_read_pg() (kcalloc(nfree) then rtt[lane] across the lane range), since
the defect is the unchecked nfree vs the lane bound:

Build A (without this patch), nfree=2, num_lanes=8:
    rtt[lane] for lane >= nfree writes past the kcalloc'd array ->
      right of the 8-byte region (kmalloc-8) -> panic.
  Build B (with this patch): the arena is rejected, no array is used -> clean.
  Control (nfree >= num_lanes): every lane is in bounds -> clean.

BUG: KASAN: slab-out-of-bounds, Write of size 4, 0 bytes to the
---
 drivers/nvdimm/btt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index fdcb080a4314..25c609251f99 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -883,6 +883,14 @@ static int discover_arenas(struct btt *btt)
 		arena->external_lba_start = cur_nlba;
 		parse_arena_meta(arena, super, cur_off);
 
+		if (arena->nfree < btt->nd_region->num_lanes) {
+			dev_err(to_dev(arena),
+				"nfree %u smaller than lane count %d\n",
+				arena->nfree, btt->nd_region->num_lanes);
+			ret = -ENODEV;
+			goto out;
+		}
+
 		ret = log_set_indices(arena);
 		if (ret) {
 			dev_err(to_dev(arena),

---
base-commit: 8e65320d91cdc3b241d4b94855c88459b91abf66
change-id: 20260620-b4-disp-88b2514b-c71e8a0ba790

Best regards,
-- 
Bryam Vargas <hexlabsecurity@proton.me>


