Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F84C380FEC;
	Wed, 24 Jun 2026 04:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782274743; cv=none; b=quloaHQWKZuJi2hbbqTHz/YuPFo6JZnqk+rv0es/BNeJLTZT/oiBMX6v5ZV84oCW/rYFe9FzVBG9ShaeOL5O8iVyD1n18lqHpcoqlW9wnd+o1GvHEnBXG8tAWUvl5xoFA4qTwhObJb4VMwMKZgxsZyGT2CRwd7LDBml1Z16j7ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782274743; c=relaxed/simple;
	bh=XANCZNyCbG+Ly+jntP8fH38JNMbRF1f10/kOrgQxa0Y=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=RQTTEK+GQ25jrzX5b7K4Z0qgwHxgXp8C0gZ9CNEyJPx7pifOjmBSFgeXkoYwSljkc70RAPa4JCUbdmL9v9Qn38qJtUkzmeWJd8g1QwcRw3RsXGqhPpd80bt97pRjKK1fgduyL2nU+7S41ILfu/j5JBz9IJlfuPZU45N0LlIyuuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UeEdGfMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UeEdGfMa"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B76A9C2BCB7;
	Wed, 24 Jun 2026 04:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782274742;
	bh=XANCZNyCbG+Ly+jntP8fH38JNMbRF1f10/kOrgQxa0Y=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=UeEdGfMaZlNxcgjpdq2SJN7VV32NSXVkXDYi4PYqRVMWkvvDVUwy4G2U8GGqp8Ap+
	 H/puO/vPtm9T+92MIYV2BUCQMdbd4I7lALZhvOw4nimln7IcQ2YrNPU+4XD/K7WaUO
	 4Bt2wVHz5L3FBLmqXzJod1RfDCy4QtmKR8dZ04dI1g0dACOI2I+NNJzaMNW7fKrAcn
	 +Swju6VYOjgJmSpo8ogq1QBRDKFkIvNGYrPvdW7TSwVXrVZkKk0Yd0zYR96kVgNmGW
	 L27iIbwFgVOmBbpQjOO3L0bBUfuB7M9odoSQDd3e13I/FAxFx04snKke/n4/A4lPbh
	 4o+HnxHLHa1PQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E7C1CDB470;
	Wed, 24 Jun 2026 04:19:02 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Subject: [PATCH v2 0/2] libnvdimm/labels: fix the nslot product overflow
 and cap the slot count
Date: Tue, 23 Jun 2026 23:19:01 -0500
Message-Id: <20260623-b4-disp-1f2c537a-v2-0-59af73f1f090@proton.me>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALVaO2oC/x3MPQqAMAxA4atIZgM1av25ijjEmmqWKi2IIN7d4
 vgN7z2QJKokGIsHolya9AgZVBbgdg6boK7ZQIassVTj0uCq6cTKk2vrjrE1jnsaeBC2kLMzitf
 7X07z+359isKbYgAAAA==
To: Ira Weiny <iweiny@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dan Williams <djbw@kernel.org>, Dave Jiang <dave.jiang@intel.com>
Cc: David Laight <david.laight.linux@gmail.com>, 
 Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782274741; l=2193;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=XANCZNyCbG+Ly+jntP8fH38JNMbRF1f10/kOrgQxa0Y=;
 b=F32OGyjLZ5F7QLCAS0OR0iHEqX9zcJY6j6RY95ARQHiK8tW+o8y9AjzXAfaE64PF0PgoZL4O6
 8x7xeMRIqGmDEDY6kU9hqClsiY3MhREQEexFtuKdAoPAbsDkZkvklZe
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

The on-media namespace index nslot is a u32 read from the DIMM label area,
or written from userspace via ND_CMD_SET_CONFIG_DATA.  __nd_label_validate()
bounds nslot against config_size, but the product nslot * label_size is
evaluated in 32 bits and wraps, so a crafted nslot passes the check and then
drives an out-of-bounds memset in nd_label_data_init().

Patch 1 evaluates the product in 64 bits so the bound is exact; it is the
targeted fix, tagged for stable.  Patch 2 caps nslot, so a bogus
firmware-reported config_size cannot admit a large slot count -- and the large
allocation it implies -- even after the product is computed correctly.

The sibling multiply in sizeof_namespace_index() derives nslot from config_size
via nvdimm_num_label_slots(), not the on-media field, so it cannot overflow and
is left unchanged.

Verified on -m64 and -m32: the 64-bit bound agrees with an exact divide-based
check on the boundary and on randomized inputs, and the cap rejects every
wrapping one.  The same crafted nslot is an out-of-bounds write on -m32 but not
on -m64 before the fix.  An out-of-tree module mirroring nd_label_data_init()
reproduces the KASAN slab-out-of-bounds write unpatched and is clean with
either patch; harness available on request.

A negative ndctl test (test/label-compat.sh, oversize nslot) covering both
patches will follow separately, per Alison's suggestion.

v1 (single patch):
https://lore.kernel.org/all/20260620-b4-disp-7f43b155-v1-1-0cfd8017f7a0@proton.me/
v2: split the exact fix and the cap into two patches per review; the
    Reviewed-by and Suggested-by are recorded on the respective patches.

Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
Bryam Vargas (2):
      libnvdimm/labels: Prevent integer overflow in __nd_label_validate()
      libnvdimm/labels: reject an implausibly large on-media slot count

 drivers/nvdimm/label.c | 6 +++++-
 drivers/nvdimm/label.h | 7 +++++++
 2 files changed, 12 insertions(+), 1 deletion(-)
---
base-commit: 502d801f0ab03e4f32f9a33d203154ce84887921
change-id: 20260623-b4-disp-1f2c537a-50ca829a9ea6

Best regards,
-- 
Bryam Vargas <hexlabsecurity@proton.me>


