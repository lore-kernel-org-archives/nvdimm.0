Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA93A25561
	for <nvdimm@lists.linux.dev>; Sun,  4 Feb 2024 20:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707077986; cv=none; b=Ju1/2vB3mx1u9QS3kcQE58JxLwesoIYQflWQ/BKRZLIWZscr0Aymz15VqV/3h5hma4pFfpwxdjH5w2wkOddpv2Cz3prFZKart3mJqY1FSllUmt5JlNMzR5lJi6Xo5PwXTFfco+h9xntsLGMzelJzQi/dnptw/ATXcWKqadpqIPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707077986; c=relaxed/simple;
	bh=bKatmoqdunKK2koOFt4Ts7OAn4UR3Iu1KhzswWzA+jM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=pnQ3u/U0CIPJQAegiZVpG4+4mamkrmoA43ELpYNbeH8mJhxeRhqoJKOCjKPJGlHj0R/ivK/x5sQKZH1RHrL/kLrdReYp/LPVKc8AAZgztXunJ7j+hY6wAJWpN6eLqMTnkqyeQ//IVX6Pqj7Tjtkuj5Ex6+gzNvLu/YJso2nUX5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net; spf=pass smtp.mailfrom=gmail.com; dkim=fail (0-bit key) header.d=marliere.net header.i=@marliere.net header.b=TdafxswD reason="key not found in DNS"; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="TdafxswD"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-290ec261a61so2122067a91.0
        for <nvdimm@lists.linux.dev>; Sun, 04 Feb 2024 12:19:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707077984; x=1707682784;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:dkim-signature:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jazWVo/koidO1Bu5JbZ3m7Uo4qUL48I34Ovsctsv1BI=;
        b=cs79bm3ZTrY33QV4V86OZ8okOLtaU649DKRCOHTv5JE9ZWYu23bH7biPSEqP6KUYnS
         XVUoHpX+s7ve8M+PMf09xHM+p6ZYVbeX2K6fx2R/wSG+R3HpAKXsL3zQ46bSeSUo7TT3
         YqK2MR6nGpKRQxigS5QDtCF+OgeEEFBUqdHaTOiZyvofogfngeVreJ2O2ComCVCywwnv
         FczTT56UH0gTYFPz1m9cZjFjD2DRWAXKGbXHdgLWXBogQIDgSKVI2Q7eK0WrgsfA06NJ
         FDE/VeUm6WWpo5VxBYV1t5/kCjvMTFNLKznKGt6yPeftO+UirPS2XiCcPx/cWpJJq3JX
         sNfA==
X-Gm-Message-State: AOJu0YwsxAIF2NG5W3zIV5dC9RXYBt1Uq4Pa5oz36YrBGB+oyZuqM8MU
	O6etxU9dwQpOiRd2/gRVkzg37a9wxz/b2Jb78qL2Yonp0XpJOx2D
X-Google-Smtp-Source: AGHT+IEvIXCJA60sodSoe3W5jqoe50vIu2aryIiDYGR9XF/Dp1T5agVdwm5gHaQC0tQH1sdgYKzAGA==
X-Received: by 2002:a17:90a:55c9:b0:295:ff5d:cb1d with SMTP id o9-20020a17090a55c900b00295ff5dcb1dmr11176474pjm.4.1707077984138;
        Sun, 04 Feb 2024 12:19:44 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCX6JgS1oojOYVvxL6m3la2K0ILJQ8BeVU3xssWjT8wiFJtgyO6/mA8TYYWyJMwyjXE828dAV1M0liz7sLYRhCJ/Ey4z60qPW3jdPRLfsKUXNXkoQlPLw3wwKZf5t2OI4X9x+QHCSuFoAEwoBNO53prNjeksISBWCnW7sevgOSAUiEbqZWsKiGqKf1qHL4zJQTKdDuchvA3TvIiJro5gcxXhBWVfXuRa3r0Ncx8A6w==
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id sc8-20020a17090b510800b00296094e420fsm3793119pjb.10.2024.02.04.12.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Feb 2024 12:19:43 -0800 (PST)
From: "Ricardo B. Marliere" <ricardo@marliere.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1707077982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jazWVo/koidO1Bu5JbZ3m7Uo4qUL48I34Ovsctsv1BI=;
	b=TdafxswDRA47aF2HmlbNYUoVvS+4SmFFvcDq4RjGArVZTE7nH1UGqRQyCeND3fGvqrecU6
	2QqdIR5X6ZnAtQgw/l0VbWLiAW8UN4XSpmALaUu5i7aKwTlEg4Z2wMC3yncSUbt1qZ072V
	Jz3KjdivvVNniZhCrsIX+RZzQkiYhWJ6pBHDjbur7NOsQjOmNcrRtsjmaqCHfdq43DrDFz
	1taXAA+pdgUCsca6oJnGOAJiAWn9RBJQwq1hqzr4RZ66b8fQ//0PdyHb6MY2LuHtyFmMll
	biy4yAAhhi+IVGAMHG/up55ikyjIGfYMhlIICmupW0NOyScos024cAY8Lc4obw==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
Date: Sun, 04 Feb 2024 17:20:07 -0300
Subject: [PATCH] nvdimm: make nvdimm_bus_type const
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240204-bus_cleanup-nvdimm-v1-1-77ae19fa3e3b@marliere.net>
X-B4-Tracking: v=1; b=H4sIAHbxv2UC/x3MQQqAIBBA0avErBPUpLCrRITlVANloSiBdPek5
 Vv8nyGgJwzQVxk8Jgp0uQJRV7Dsxm3IyBaD5FJxyRWbY5iWA42LN3PJ0nkyLbpOtLqZrbJQwtv
 jSs8/Hcb3/QC3QM+vZAAAAA==
To: Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Ricardo B. Marliere" <ricardo@marliere.net>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1133; i=ricardo@marliere.net;
 h=from:subject:message-id; bh=bKatmoqdunKK2koOFt4Ts7OAn4UR3Iu1KhzswWzA+jM=;
 b=owEBbQKS/ZANAwAKAckLinxjhlimAcsmYgBlv/F8n0otFALEBJt9mqQK67FrObYYUEpE2Xt7u
 fZbitOKtliJAjMEAAEKAB0WIQQDCo6eQk7jwGVXh+HJC4p8Y4ZYpgUCZb/xfAAKCRDJC4p8Y4ZY
 pn7eEACpR0/cL8FutyLabrKGx2vx63fd7QqJhevHAwD+AVo5YhfcrfnOD4b2Jl7NDAAqHvRxlQ9
 7O2Z3XfFs77GVNUGaYdyODZDz8tbeqjhaP5sC+6loIYhLQRe+6o4D+u612hCBU9+So2vztr8ia6
 Saa+zMQBi/2Ay+oRdBxCVxafbNv2zpsfklED3GC4IzN8M8rzILzASbkSH/AlVWUfwAQIQoHHHur
 /SAJiSKXDLAUQKMvzWJ14H//8Vh8pQESwQC8ccAd+MsWXl06Nz/W3rj4BLmaSZHUrLgXRCnL9WO
 1FUis8eHG31IumD/lODgEdn75KoYdiNSUPRaBEuhlRpuu+Fm6flVCMxJY8B1sBgO3KnQrbibPL9
 C/9URByfgl4ad78xTtHjVrjJ2uK/GcbYxu5H18+VMt1ci7notn8OGDILjX6HZxJNuvuHVZOAOjo
 4i1b5WvMj/1HJCLqi4kv1sYn6Y7k2svpIMiut9sdXIsfuxA2eduC/KISiYHBRRCkbqCAFM+ItbD
 0yfPuBUWi9wevfrX/7ImPaYf+7Sn40P0JEovI8B2KwgMyF/qeyKW+ZYlQk7TuygiodmSCdpgMZA
 lyim8Y5HTMTs7rJGeuGS0vnSZS5L5Cay8k91tTmTyIBMyNnvPA5FQVsNxIvOfWN/Qr+oATH83u3
 P8OsbJEyfwCugnA==
X-Developer-Key: i=ricardo@marliere.net; a=openpgp;
 fpr=030A8E9E424EE3C0655787E1C90B8A7C638658A6

Now that the driver core can properly handle constant struct bus_type,
move the nvdimm_bus_type variable to be a constant structure as well,
placing it into read-only memory which can not be modified at runtime.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
---
 drivers/nvdimm/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index ef3d0f83318b..508aed017ddc 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -271,7 +271,7 @@ EXPORT_SYMBOL_GPL(nvdimm_clear_poison);
 
 static int nvdimm_bus_match(struct device *dev, struct device_driver *drv);
 
-static struct bus_type nvdimm_bus_type = {
+static const struct bus_type nvdimm_bus_type = {
 	.name = "nd",
 	.uevent = nvdimm_bus_uevent,
 	.match = nvdimm_bus_match,

---
base-commit: a085a5eb6594a3ebe5c275e9c2c2d341f686c23c
change-id: 20240204-bus_cleanup-nvdimm-91771693bd4d

Best regards,
-- 
Ricardo B. Marliere <ricardo@marliere.net>

