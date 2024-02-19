Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1675D2E642
	for <nvdimm@lists.linux.dev>; Mon, 19 Feb 2024 12:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708346805; cv=none; b=sG0Hqt9nxKtDZmSH0P8sct8i+VshaLjlRxH3PNQiLbqJ0mhqsnf/EqGFTFXAU3Q6gdcmtp/ap4WbAcan9DD4pPCgEwiK5emOmkAe5msiHI55FNGqHYr2SGstOZElCUePCV1oq5BHPPSnFufbsJBvcKj2nwYQCzosC1HXTwzp//4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708346805; c=relaxed/simple;
	bh=v2tFgPh2DhrAkjf4HRKnQQBDaVpePm8Gb5zL34pd/k4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=C8z0kQueI743SWtoyg1kCP3rYCZo6z2xzC4HLrDRTYvxBy4cwWsyMfkM1v2DaxBqmN7GH/G4AHWvQGAWVnSDoHuh65WsYEqN7DnFlWUAMa48vPjNzewnFI3O3gKz7b4CiDe70YwfB2Ao2atY9df2ExqKEautZqnfdgVx+RfnrNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marliere.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=marliere.net header.i=@marliere.net header.b=catl75rC; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marliere.net header.i=@marliere.net header.b="catl75rC"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7c48ef54d9bso72129939f.2
        for <nvdimm@lists.linux.dev>; Mon, 19 Feb 2024 04:46:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708346803; x=1708951603;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:dkim-signature:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uFMPdkgeHy68/bLzT3L6tHn2KP/MczRpQvVLvaFtrj4=;
        b=xN/ZdRAqcqxunjgCORNhVP4Gtd6d2wUj3zaX0re+ZmOyOc6IqoOxQiT8slTHCgrv3t
         w5vKwC+7cVjYNVxOkZfY7CN3hGWiFZ6OebfgiDPwTfk4psJIe3Xa3QOdJvgf/toCo5eH
         bwzrwHwk/pWVTnsd95bARXhqEhMIModBxUxqEJg0oUH0E1+12vbH+sX0iAXgZGnECVQJ
         8T2aRzLgzsMV0e1kI+85rDuzdCpHF9I4/vr2TtXPu5uMs87BEJPnB/uxC75bS24pqKnY
         Oc8Mt9aabwB1kGzpzCuF4IxhCDVm+n1rTuM6qoh0HlHogjpK0/sRulP2GtxXv7YpzVFv
         IqVA==
X-Gm-Message-State: AOJu0YxG6Efrqyk5WBwpA3cgF4251GdoR9LwpXUT2gfTg/LvTuSmWVpC
	kjA3gSmYfqM2HZCosH6x6qA4uuScGdxD51RGGj83Q0HsiHVraERU3mKSpWSTokFecg==
X-Google-Smtp-Source: AGHT+IGCLb6KiMGde4xcC/pcOu5ZQ5eZTdo8F9PXSJUMlMi1DIS656NNPvo+M7N9oD6G3/0AN4wV/g==
X-Received: by 2002:a92:d9d0:0:b0:365:1a08:2425 with SMTP id n16-20020a92d9d0000000b003651a082425mr6005967ilq.30.1708346803092;
        Mon, 19 Feb 2024 04:46:43 -0800 (PST)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id p11-20020a63fe0b000000b005c6617b52e6sm4651467pgh.5.2024.02.19.04.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 04:46:42 -0800 (PST)
From: "Ricardo B. Marliere" <ricardo@marliere.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2024; t=1708346801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uFMPdkgeHy68/bLzT3L6tHn2KP/MczRpQvVLvaFtrj4=;
	b=catl75rCpA3toE3p0fHkprvVKneWaZCOU7brSeB3gor/XcnDh8ijmqR8qvfFqVEqhdnDad
	/FG1GcrHSaUWt++fd2w78wmSgHqATrWE4oCpmd/ejSUIfBGXpqCCQeAF6IsWZVHDNqfRJP
	m8Bm1z7AaEWddZ+HMBEoNXb+qXHgsunNYDIpTLcaaRi4qLLotE9n+jjHKxVX6IzgUEuNET
	l/aDI2T0iVeRdzEAqnzV0awaFK0Qk2BvHji9IykrAF6vnPayHttZjj1xItzLDWDxCJIFv0
	njvxqEeQ8Bd/3b0QwkcsseYd31a0xloL9ugMUt7SrWhkippENRj+JvDpDiWPaw==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
Date: Mon, 19 Feb 2024 09:47:28 -0300
Subject: [PATCH] dax: constify the struct device_type usage
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240219-device_cleanup-dax-v1-1-6b319ee89dc2@marliere.net>
X-B4-Tracking: v=1; b=H4sIAN9N02UC/x2MWwqAIBAArxL7naASva4SEeKutRAWSiGId0/6H
 JiZDJECU4S5yRDo5ciXr6DaBuxh/E6CsTJoqTup1SSwSpY2e5Lxzy3QJIGjdihtPziHUMM7kOP
 0T5e1lA8JX5ViZAAAAA==
To: Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Ricardo B. Marliere" <ricardo@marliere.net>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1091; i=ricardo@marliere.net;
 h=from:subject:message-id; bh=v2tFgPh2DhrAkjf4HRKnQQBDaVpePm8Gb5zL34pd/k4=;
 b=owEBbQKS/ZANAwAKAckLinxjhlimAcsmYgBl003g5CgCqz1cWBx3Zxb+sX1z9Z+uaNXXOTgy5
 1W4BWp+ppOJAjMEAAEKAB0WIQQDCo6eQk7jwGVXh+HJC4p8Y4ZYpgUCZdNN4AAKCRDJC4p8Y4ZY
 pnSLEACmZxs7VJKZM72/T20LHsunB6H4bUV+m0RZ/lbzFoFhbDObaggtHyGNu1iza6xLAChmrC+
 /QREKrtEBMJi7SJoMDD5dZhVKDgE9BGr5ZhO1DOsq8JoUR/wn20ye9Nm1T8swWDSPCINWyXPJGT
 Pe4J68RIUOjHiFFoeguH7Bo5JSa8sOnIXw1pw4wJae4JkK3ncYETMdGf2cV6k6hT4Ua//NCcIpR
 xOJwYinwmBZBkqFE1pvTmMqTA2AlCbpq+ytSJDHA/ZOGFoEMGf66SOnyCqmLPZLIv6o7nxilvm5
 ZHFj7V+fi0HPQRO2GFCQs8EazGWkAF6HHNqAi8nf31Gt2Av21JTF/0rOcT//drrEySLH4by/bd6
 KwoCC2eolwzbmTElVjucQNoDYKIp2mSt71YhbCf1e5v3rbo61AOCFstHxkVkf96S+AYQP4sHKpD
 ZYpN9WHQYO81CNDAkYxl5OIvnnnKJpGk0htxkXm95dMrhRkqdPbnsBNIDTKmPEL0EGHcZlHKPjU
 8lAmibOXThQCo4qmm6nN7l91pGhcrQ2MU1PbJOW+KyVx0cu0mfaIQYM3ZI/DhYpPjYFxaybSY8Z
 PtW3whftEHjCgtNyIjiO0hZh0/690D00zdBUShL6BHjN2+4Yopn0cCVJaohZFne36LRvjXX0Ncc
 OQIS0zz2f2t1p+g==
X-Developer-Key: i=ricardo@marliere.net; a=openpgp;
 fpr=030A8E9E424EE3C0655787E1C90B8A7C638658A6

Since commit aed65af1cc2f ("drivers: make device_type const"), the driver
core can properly handle constant struct device_type. Move the
dax_mapping_type variable to be a constant structure as well, placing it
into read-only memory which can not be modified at runtime.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
---
 drivers/dax/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 1ff1ab5fa105..e265ba019785 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -763,7 +763,7 @@ static const struct attribute_group *dax_mapping_attribute_groups[] = {
 	NULL,
 };
 
-static struct device_type dax_mapping_type = {
+static const struct device_type dax_mapping_type = {
 	.release = dax_mapping_release,
 	.groups = dax_mapping_attribute_groups,
 };

---
base-commit: b401b621758e46812da61fa58a67c3fd8d91de0d
change-id: 20240219-device_cleanup-dax-d82fd0c67ffd

Best regards,
-- 
Ricardo B. Marliere <ricardo@marliere.net>

