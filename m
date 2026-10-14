Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5351318BA8
	for <nvdimm@lists.linux.dev>; Wed, 14 Oct 2026 01:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791941315; cv=none; b=UB0rRXUqLtIeAj/SUFyGlR0YaVqPbRttIQv1UK2bE22wTtC5rlMcs8fx9aUYKoLyVeX2wakQOhfaVJJLgYTpTe12XFSw1nDRYWkw2n9xRRGD+Ww115mqQSw8zyQy6ZLgN18Ukyfwa96EZ79zV34Q7iD2tD/hMTJu+5CSXp90e6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791941315; c=relaxed/simple;
	bh=gmVQW4zvgK1RdCMOSrjGY3Z/g11AJJIEJYvUSmj2svQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HGgEI7LYxTGg3Hw4XO7OeORUOy9d0ztNMJXs/f6z7dikbVtyMbLP3pmeJltdEHhyx/RB7DDypE4foGeTEXVWJbgh31MieL0zn+nzo9hpFws6i++keqRvZtmSZ4o0zsFduJf/FRGbRIDliumHJevOage3tjcmSG7cdN1btRja24I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dh4pnbB6; arc=none smtp.client-ip=74.125.227.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dh4pnbB6"
Received: by mail-pj2-f2.google.com with SMTP id 98e67ed59e1d1-3a8c118e711so2029130a91.0
        for <nvdimm@lists.linux.dev>; Tue, 13 Oct 2026 18:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791941313; x=1792546113; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xF4abej4dYzWW64tGMfNwkdoR9vBgU7tCntIFYf9jb8=;
        b=Dh4pnbB6h+1zjC1KHC8Opp+tYFsQQ4evCRH7Z4CICKi8RxQksw+wSXFEAMmdInwWH8
         cTmxxfAa27idp6qtf2oOlej6NkhU7dzDUpY6nFzeneRx7zHJcIeCfokbyIMiaExqEaCm
         zrNrO7jokuxRU/cVjF0h9TAwDPV8axmt+n+pbjhoiXs6RQVftwAgO/4GH9y+brCPMd97
         2qg1LQgiUOBb06zPOpbqo4wjTI69C7D/EYtPoRIrau4uN0SS8mfyCsdI4p6lwNkJPena
         Dk5zuvzkbQjFh5nA2/U8RhT0gO3V8u1yhsehTXGdoBJN1sztWhEgsezoBmJg2wTWvLo1
         zIGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791941313; x=1792546113;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xF4abej4dYzWW64tGMfNwkdoR9vBgU7tCntIFYf9jb8=;
        b=dMI0Spn96/mzpau+4+3f58SaZGjG7P2kLG2M4axG5cpzDl83Ce1CN9o6JiN5W1+fAa
         wMlsLC8A+hyb3ctD2+ED3DxSDh5EpPU/HUkPINwpx2k8CIiJH+AsZaLi38wjRwCgQj0j
         IllkwD+qPcaywRpTGsYfCfBl6F9eYuiWDtDr/69NqQ97WvJhrwxn4W8pD2Z1By6Xp9Je
         7lyo3uJIPU7YdgU7ymX2ceTibnvTINXUGurxFo8BgFI8WtIDssSIHMP7xf7uVFlE969p
         z4pAWg2w++hu2ph2l3EElF2cqKWVsqmSCFwzrceiZ9cE6SHojbV5zClx4DbHLrTiFjpB
         1Kyg==
X-Forwarded-Encrypted: i=1; AKwUvBz9vCKiXPAVwNKrvJ29rzdsCYehj1kLJwOoBCh0K9nkOsbnXtAL/02N3cLG1jEVfnkbHeRrBNo=@lists.linux.dev
X-Gm-Message-State: AFq9FYIUXsAWf9LchWUzouoOohyxYn/ZDkGMpIGT9L0AgDxYfSw5CR45
	0H/sSXJQOEw2d7+u6dn4Dex+wspiTUelB2JcY21ae9uxADRMIgGXOxa7
X-Gm-Gg: AYBFou0sAU2PY03os8mtiiGYrsrnmxIrU1dfYXwEEXC/oY22sTICrcEe16nC5Vhb3YJ
	hV/RnW+P/XrHt+xUG5zRYh7XwIeMceN1cK2OuqUSsDBNbLUgHqkyMkzxLgeYvbgkyQDLgChjE3j
	ZzBZmyU+f3++uA5q4VYJF2LeW6nmQIuJODs3iSZGRu/3NcRfkWK6uOCFCxmENOsaNnabL21Aftm
	8pgdrzz36rwEPhhuxpAbWLvH+e6zmkl3HbOOjlMeVxD1QVXvAhHXdH8l1H1ydwqFjCqxW6FBFi6
	7GoMsSMle9ClDpuyYiC1ws/PkJx48aFA7lgWMo0c2wpRcHHVBkMf5lybRLNX3xRB0deMBmL+47h
	mgr/0EluPseTa/BiNpmVDNjhB39thfkvOkMP3QwgbkWvYFlXn4kuvX+aXU66a66OrODIctIvHK+
	ksZqI269OlDJe3a6pqo7ostTkvc72id7Qb0rmdCrO8x0mxOAgmqtMQSCx7oa6S2Fij8xkUw8KKh
	YO4HD9uguzw/Njm+mK0/M6A5avFSljMLxvUH+bN6DmmSpnOzi/i3DCQMjp4YqiCAPBwXNAyPV43
	DiWQrdeqdKPxaBBQfXWPAbL8BRuNGme6pP0=
X-Received: by 2002:a17:90a:1601:b0:3ab:884b:65b7 with SMTP id 98e67ed59e1d1-3ab884b6b8cmr5867485a91.25.1791941313156;
        Tue, 13 Oct 2026 18:28:33 -0700 (PDT)
Received: from localhost (ec2-35-77-45-43.ap-northeast-1.compute.amazonaws.com. [35.77.45.43])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac5f1fb257sm1953670a91.0.2026.10.13.18.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 18:28:32 -0700 (PDT)
From: jianyungao89@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	stable@vger.kernel.org,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev (open list:DEVICE DIRECT ACCESS (DAX)),
	linux-cxl@vger.kernel.org (open list:DEVICE DIRECT ACCESS (DAX))
Subject: [PATCH] dax/bus: fix dev_dax->ranges leak on device_add() failure
Date: Wed, 14 Oct 2026 09:28:23 +0800
Message-Id: <20261014012824.31468-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

In __devm_create_dev_dax(), when device_add() fails, the function calls
kill_dev_dax() and put_device() but does not free dev_dax->ranges.
At this point devm_add_action_or_reset() has not been registered yet,
so unregister_dev_dax() (which calls free_dev_dax_ranges()) will never
run.  put_device() triggers dev_dax_release() which frees pgmap and
dev_dax, but not ranges -- leaking the krealloc'd array and also
leaking the regions reserved via __request_region() in
alloc_dev_dax_range().

Add free_dev_dax_ranges() to the device_add() failure path, matching
the cleanup already done in the err_pgmap error path.

Fixes: 9567da0b408a2 ("device-dax: Introduce bus + driver model")
Cc: stable@vger.kernel.org
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 drivers/dax/bus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index b809e1a264af..83442430dc01 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1536,6 +1536,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	rc = device_add(dev);
 	if (rc) {
 		kill_dev_dax(dev_dax);
+		free_dev_dax_ranges(dev_dax);
 		put_device(dev);
 		return ERR_PTR(rc);
 	}
-- 
2.34.1

