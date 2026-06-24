Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C535386C3D;
	Wed, 24 Jun 2026 06:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782281026; cv=none; b=G7TaIKjQfXUkbWmuzT+ElXYS3wsbIGonxPpuO9ZObQfgy4sUsAe3hKa47m59vGe3xtrQJMRYLd4b0bY4VN+qLc8HFTsAwSM8eN6HyImNV7HFoPTQ7hYJb49lxFErL5QqEvyMOTcJA6TM9UYQOq4hvG2oJyTcLZwis0ZlDFLlHdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782281026; c=relaxed/simple;
	bh=71wJOwJmMWs0vcnxWQcdHUJHn90LE6ORfjQ82/1YR5s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FFYQ7dTaP7gQ+g+RoTOt03FYmS324NWyXzOLgYHGY32QN0UlZyOmJUK2MC0HIuul5Sjh89pPR5sXwMzpoNe8Peqthn3WKmDLj8CJJICCtoHcqVSfnDauNFSt9akvVcQoNvjl6BUzcmZa0wY5Xd0ZPBfaoBkswfwH/7u0r4ogTEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AuqFmosx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AuqFmosx"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D79FCC4AF0B;
	Wed, 24 Jun 2026 06:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782281025;
	bh=71wJOwJmMWs0vcnxWQcdHUJHn90LE6ORfjQ82/1YR5s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=AuqFmosxONZjcUsS0NMnnilknekfqx78w0031cl4DmRVedJoBf1NE93HXLrHxhk0R
	 c6/zp+uWpO9E6CnFX0fq6aU+ko4gbBgD9EqkMCFnI7J5CBdOqz3cmtCL0THbyywW0m
	 oY36hJRuQcm5PJ4Yq99U4nTIwERVXo9Ui1NF/os+D2Z0AeBs9Sjok3FiX6G4Osm01n
	 m74X0hTma24089rwWutCy6wm0tE1cYDxxA6oJPX70QWcTP1Hc3x2xx+jxKuH+8aUaD
	 q7XBOXET61Zy4k81h6lisAKTRyL40pVrdrywvwQ2E/ZzFmanK9Hh6yII6v608zbG8b
	 dQClMOirH/8yQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE07DCDE000;
	Wed, 24 Jun 2026 06:03:45 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Wed, 24 Jun 2026 01:03:46 -0500
Subject: [PATCH v3 2/2] libnvdimm/labels: Bound the on-media label size
 before the shift
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260624-b4-disp-d8279485-v3-2-cdb6cab28b41@proton.me>
References: <20260624-b4-disp-d8279485-v3-0-cdb6cab28b41@proton.me>
In-Reply-To: <20260624-b4-disp-d8279485-v3-0-cdb6cab28b41@proton.me>
To: Dave Jiang <dave.jiang@intel.com>, Dan Williams <djbw@kernel.org>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
 David Laight <david.laight.linux@gmail.com>, linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782281024; l=1823;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=MCs2th/N4QIgCQZkHTxmp+qdeY/SC2RCINMmfLHg+qc=;
 b=F2z/lOJ7ISu1i4FzLpyEsruEoUCsY4nMfCTetttK5QlV4cktepaI+SOGuIMlvD/VopX4oaNjS
 /OP8hbkQj+qBc9B7S4YYjPa94wg+4etk/579Y2y5GlXT63WY6Z0TD7H
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

For a v1.2+ index, __nd_label_validate() computes the label size as
1 << (7 + nsindex[i]->labelsize), where labelsize is a u8 read from
the label storage medium.  A value of 25 or more makes the shift count
reach or exceed the width of int -- undefined behavior -- and 24 already
shifts into the sign bit.  Only 0 (128-byte) and 1 (256-byte) are valid.

Reject a labelsize above 1 before the shift.  The result was rejected by
the following size comparison anyway, so this only removes the undefined
shift on a crafted or corrupted medium; conforming labels are unaffected.

Fixes: 564e871aa66f ("libnvdimm, label: add v1.2 nvdimm label definitions")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/nvdimm/label.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index ec12ce72cfe2..dea2eee86d13 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -145,10 +145,21 @@ static int __nd_label_validate(struct nvdimm_drvdata *ndd)
 		/* label sizes larger than 128 arrived with v1.2 */
 		version = __le16_to_cpu(nsindex[i]->major) * 100
 			+ __le16_to_cpu(nsindex[i]->minor);
-		if (version >= 102)
+		if (version >= 102) {
+			/*
+			 * labelsize feeds the shift below; only 0 (128-byte)
+			 * and 1 (256-byte) are valid -- a larger value would
+			 * overflow or exceed the width of int.
+			 */
+			if (nsindex[i]->labelsize > 1) {
+				dev_dbg(dev, "nsindex%d labelsize: %d invalid\n",
+					i, nsindex[i]->labelsize);
+				continue;
+			}
 			labelsize = 1 << (7 + nsindex[i]->labelsize);
-		else
+		} else {
 			labelsize = 128;
+		}
 
 		if (labelsize != sizeof_namespace_label(ndd)) {
 			dev_dbg(dev, "nsindex%d labelsize %d invalid\n",

-- 
2.43.0


