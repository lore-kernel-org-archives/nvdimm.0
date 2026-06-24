Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3892C386C3B;
	Wed, 24 Jun 2026 06:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782281026; cv=none; b=m3RdZR2fooLIY9Q9Qc/+zMRH1sRn1qG5mEhRdu/5IY875sZYs1bwmpEz+aHa8lzHvXTOsahMaiZVZtqFh/FcUqkxfA54CDjn7fFqEsxyXzX8epekvg+MEFvOSxfLIFeIIoZkBod8HvYALyrkgrZ7MERrev1ExU7I/4h/zMkTmO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782281026; c=relaxed/simple;
	bh=L8Sqgnf8uN3wM5yGArKu/lhmaHR3yE4CYwBxApOTw/g=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ZvU3DFhSlHV6UXwbI339vdVlvfqdB00gvrHdnVMNQiJ/Hs/qgALXb3C9ZanGj768oRhFAvV/wjA1o9XaKHDB48k4c9BlavW4KK4ejBDlENrZr6q7sUmM7YkzU5m3cHZpYGWlFyZ9TyEo88YI+I+lgwWHhsIlUyZGNfEv1LVAH1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S5hsxPAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S5hsxPAK"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A14B1C2BCF4;
	Wed, 24 Jun 2026 06:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782281025;
	bh=L8Sqgnf8uN3wM5yGArKu/lhmaHR3yE4CYwBxApOTw/g=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=S5hsxPAKnG7QVKRXzj65Q4uwudDxn71hQQsATdm2hXvKdgIKRBFVsVyeDrc1jk32l
	 k2uCsziD4KmbpkCjkIzfhQ3yJWHTCv8OtAidELilhZErnMK3gEBTtVXaGD8pZlOIww
	 oap67GMJa10QZncUjBhz7u3Ad5tugE7yXDYcBR5JgHE3DqnUxDHmD/tqA7AaLiv4oT
	 S8VWhxLj4GYhKWvK5XO+mEDcTZsvt4bixvFMdjueArkLY9SCSpYiDypDJAIko3rRK9
	 4/Lyq66fShxHCCJ8df64M6/CU5paVV69mrldCBheZhtOWjCjsy9hcU7oH7kY3VHapt
	 mlyU4Grjv2szg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69015CDB47F;
	Wed, 24 Jun 2026 06:03:45 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Subject: [PATCH v3 0/2] libnvdimm/labels: two on-media validation fixes in
 __nd_label_validate()
Date: Wed, 24 Jun 2026 01:03:44 -0500
Message-Id: <20260624-b4-disp-d8279485-v3-0-cdb6cab28b41@proton.me>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEBzO2oC/x3MTQqAIBBA4avErBtIM3+6SrTInGo2JgoRRHdPW
 n6L9x4olJkKjM0DmS4ufMaKvm1gPZa4E3KoBtlJ3Wmp0CsMXBIGK41TdkDhB7d5vRgrHNQsZdr
 4/pfT/L4frMyAZ2IAAAA=
To: Dave Jiang <dave.jiang@intel.com>, Dan Williams <djbw@kernel.org>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
 David Laight <david.laight.linux@gmail.com>, linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782281024; l=2655;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=L8Sqgnf8uN3wM5yGArKu/lhmaHR3yE4CYwBxApOTw/g=;
 b=5RXIvnD8J7x5fbfvBUQb7P8JRbME0qUD7DDe60KUsqBq0d/qEMNQEyDgITlkTq5IkXxCC+5M0
 YNCs6EWDDECCCwZ3UfdGHMNo8N+nWwZjCgplBvJxidDKWZvqYo8p8WD
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

__nd_label_validate() reads several index fields straight from the label
storage medium.  This series fixes two of them.

Patch 1 (the original report): the bound multiplies the on-media nslot by the
label size in 32 bits, which wraps, so a crafted nslot passes the config_size
check and then drives an out-of-bounds memset in nd_label_data_init().
Evaluate the product in 64 bits.  Tagged for stable.

Patch 2: the v1.2 label size is computed as 1 << (7 + labelsize), where
labelsize is a u8 from the medium; a value of 24 or more makes the shift
undefined.  Reject labelsize > 1 before the shift.

v3: Drop the "cap nslot at 64K" patch from v2.  A closer reading -- and the
    Sashiko AI review -- showed it was wrong on both counts: the allocation in
    nd_label_data_init() is kvzalloc(config_size), not nslot-derived, so the
    cap shrinks nothing; and the kernel itself writes nslot =
    nvdimm_num_label_slots() on init, which exceeds 64K once config_size is
    above ~8.4MB, so the cap would reject a freshly-formatted large device on
    the next probe -- a self-brick.  Patch 1's exact 64-bit bound already
    closes the overflow.  Replaced it with the labelsize-shift fix the same
    review surfaced.
    v2: https://lore.kernel.org/all/20260623-b4-disp-1f2c537a-v2-0-59af73f1f090@proton.me/
    v1: https://lore.kernel.org/all/20260620-b4-disp-7f43b155-v1-1-0cfd8017f7a0@proton.me/

Verified -m64 and -m32: patch 1's 64-bit bound agrees with an exact
divide-based check, and an out-of-tree module mirroring nd_label_data_init()
reproduces the KASAN slab-out-of-bounds write unpatched and is clean when
patched.
A boundary truth table confirms the self-brick the v2 cap would have caused
(kernel nslot > 64K for config_size > ~8.4MB) and that rejecting labelsize > 1
removes the undefined shift while keeping the two valid sizes.  Harness
available on request.

A negative ndctl test (test/label-compat.sh) will follow separately, per
Alison's suggestion.  With the nslot cap dropped it now covers two vectors
rather than one: an oversize nslot for patch 1 and an oversize labelsize for
patch 2.

Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
Bryam Vargas (2):
      libnvdimm/labels: Prevent integer overflow in __nd_label_validate()
      libnvdimm/labels: Bound the on-media label size before the shift

 drivers/nvdimm/label.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)
---
base-commit: 502d801f0ab03e4f32f9a33d203154ce84887921
change-id: 20260624-b4-disp-d8279485-1b59fb6a7819

Best regards,
-- 
Bryam Vargas <hexlabsecurity@proton.me>


