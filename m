Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461953D905F
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386896; cv=none; b=lCpioLr63A/nkpbKOuumrrUj1J1TqXmcTVBeId6uDl+VRwjxcGIvwvyyiDFJeaRDlfmyaKPILZpMLcGsDaUx5r2IZRBLJQhQkAyXEbIE2V7kK86p1xjGg2tLZfUkVkh8+K5GCcV4L61w1wWyOSMimEib5JpdkeGJPQNuG3wq7jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386896; c=relaxed/simple;
	bh=ATkHmMP7MsH0mq/QlG9WJufW7IKZ4PYK2ldlb4TL8tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1IHMOWEYYTD9EGjB3Wu012la98VYqeZHlHO9PMhy0k9KwhIpjIc6JFqHXRY3bVcXjaka6eqtw/IQFCF3wyAWFITUwxOdH4f8QvheKF/Hu4Vsl69D2xFB1FF7jc6FuIGUJ6qixi9TpP3+9lm/jXLgEx5F6oGfKnyvNIiG0M5s5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LqjvgzKn; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LqjvgzKn"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-30c52cc5285so3247085eec.1
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386894; x=1782991694; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j9q+SAqx6fCfz13KEJXyzu0M/be87sqPxBXsY0JwlT8=;
        b=LqjvgzKn5L2Dg+SUFyA+iKPC0T4TCIr6bHlbyhq8gCTwraz8WZuNH7MimX2OiNoe/v
         kyYcL0XMtPrPUGPJhLAmSAvLC3Lqnnbztr6xetLHI+53K4KaTa/2uKk+qAmvchSCtn27
         wdFptWsqug932YrY8fDIFPtmGIpi0j458J9n7L/YBmIadzQUdVxw5vewoyGbcqFtmf85
         hRs10rHqw0VaDbxVhk9W1pNnWSSg8TpbyOEElm7PA7OCwulC6LLmX4X3dhWhFsVotvcJ
         r7tturHuPlpW5NSNiGPggxLvjoaTICfK3PTuoZHkqKtXjvegVgY8R8Y16QEnqP26D3iF
         lHdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386894; x=1782991694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j9q+SAqx6fCfz13KEJXyzu0M/be87sqPxBXsY0JwlT8=;
        b=fJxq390EtEss8c3la8pFnFMEoMfmaCbCNU3/OTGcnx/ItXF2Q6KljjFchIYjCEIDiX
         ejS2nozipFc6tixzb4qB7e4eeVXppeS6RfC2+XjPxTSTIRw5UArTAl6kkQg8u+XSum4k
         EYppkqyDJiX+ZSK23y65kc/lzOIHxUtSNTAPA9femJysmZ99xLCQgzjYYOVlfIceCq0e
         0Ky14QeFQn0l8XD4+Puut1vihn+6k/iGxQ4c8nGB60O9YOj2l8G96VOsI7x/xAcdUx+A
         6o06sO+3kwvs7yU8Z1p8bzTpCVl/ntjZ/+LYBKkuwBud6J9vhgKOUtDcNcUFLBD+/kWd
         +mjA==
X-Gm-Message-State: AOJu0YwGcoViNg0n6xP6U54zuIAhHOBrt61fYNMvU5c7AvS/yNmKlU46
	jJMNztUaQ6OAU1gKmPBAvUUK+F2CysmbLYr/k063fUGpvGuXhXYDgF1t
X-Gm-Gg: AfdE7cl13NHmCkDlRk/U4zBquXuPYNqrXw2uKDpSMJ40DxnlhGXiTU3ljnaWaStXQ7e
	gwIfRSNPJ4STtgo+dUAwuUVB6MEmPXu56XMdRfjs9h2JalNaDhYMrdm6ya01cYvJam3+A1QXRFr
	aizjDeWk4Kzg6ODu2aXhgCQAEVBJTZbqBmXnmuxYDbRhLXSr+L9g8u/Tk9Ia/avZ4yQRLjnTbSX
	afzlW3QutSNdaKyA0Cv04hufuN5DzEZWadkSAtyPXRtK5uog42K/A6KIBzNhP3FkToKxEyzDu9f
	0PZf3TBYwV2pJYs5YPL/QKZ9Vo5QmM7L0rx3Ru9PSWa/q3f2gZLwUX0d9XMKTcHR7lna/GmPBwf
	mjXRT1aiGRdAvqwgT1uxZN/pcc2HPo02fwYKYc7oWp45RHz4qkq4hT2/XehoVFzxntjqHrBFeiH
	Bmcz6Sw000W/HgieFgQfLf5D6wrNAptDDZwGwm4qTS8eExdZu5/IxB4QgrTH5uDNTzqlnb
X-Received: by 2002:a05:7300:8ca4:b0:30c:2932:dd36 with SMTP id 5a478bee46e88-30c84e1933dmr2589974eec.15.1782386894178;
        Thu, 25 Jun 2026 04:28:14 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:28:13 -0700 (PDT)
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
Subject: [PATCH v11 06/31] cxl/port: Add 'dynamic_ram_1' to endpoint decoder mode
Date: Thu, 25 Jun 2026 04:04:43 -0700
Message-ID: <20260625112638.550691-7-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112638.550691-1-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Endpoints can now support a single dynamic ram partition following the
persistent memory partition.

Expand the mode to allow a decoder to point to the first dynamic ram
partition.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

---
Changes:
1. Documentation: Bump kver to 7.3 and date to June 2026
2. Pick up Dave's reviewed-by tag
3. Rename dynamic_ram_a to dynamic_ram_1
---
 Documentation/ABI/testing/sysfs-bus-cxl | 18 +++++++++---------
 drivers/cxl/core/port.c                 |  4 ++++
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 435495de409c..499741cbb899 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -358,22 +358,22 @@ Description:
 
 
 What:		/sys/bus/cxl/devices/decoderX.Y/mode
-Date:		May, 2022
-KernelVersion:	v6.0
+Date:		May, 2022, June 2026
+KernelVersion:	v6.0, v7.3 (dynamic_ram_1)
 Contact:	linux-cxl@vger.kernel.org
 Description:
 		(RW) When a CXL decoder is of devtype "cxl_decoder_endpoint" it
 		translates from a host physical address range, to a device
 		local address range. Device-local address ranges are further
-		split into a 'ram' (volatile memory) range and 'pmem'
-		(persistent memory) range. The 'mode' attribute emits one of
-		'ram', 'pmem', or 'none'. The 'none' indicates the decoder is
-		not actively decoding, or no DPA allocation policy has been
-		set.
+		split into a 'ram' (volatile memory) range, 'pmem' (persistent
+		memory), and 'dynamic_ram_1' (first Dynamic RAM) range. The
+		'mode' attribute emits one of 'ram', 'pmem', 'dynamic_ram_1' or
+		'none'. The 'none' indicates the decoder is not actively
+		decoding, or no DPA allocation policy has been set.
 
 		'mode' can be written, when the decoder is in the 'disabled'
-		state, with either 'ram' or 'pmem' to set the boundaries for the
-		next allocation.
+		state, with either 'ram', 'pmem', or 'dynamic_ram_1' to set the
+		boundaries for the next allocation.
 
 
 What:		/sys/bus/cxl/devices/decoderX.Y/dpa_resource
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index c5aacd7054f1..57d0fc72023f 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -128,6 +128,7 @@ static DEVICE_ATTR_RO(name)
 
 CXL_DECODER_FLAG_ATTR(cap_pmem, CXL_DECODER_F_PMEM);
 CXL_DECODER_FLAG_ATTR(cap_ram, CXL_DECODER_F_RAM);
+CXL_DECODER_FLAG_ATTR(cap_dynamic_ram_1, CXL_DECODER_F_RAM);
 CXL_DECODER_FLAG_ATTR(cap_type2, CXL_DECODER_F_TYPE2);
 CXL_DECODER_FLAG_ATTR(cap_type3, CXL_DECODER_F_TYPE3);
 CXL_DECODER_FLAG_ATTR(locked, CXL_DECODER_F_LOCK);
@@ -222,6 +223,8 @@ static ssize_t mode_store(struct device *dev, struct device_attribute *attr,
 		mode = CXL_PARTMODE_PMEM;
 	else if (sysfs_streq(buf, "ram"))
 		mode = CXL_PARTMODE_RAM;
+	else if (sysfs_streq(buf, "dynamic_ram_1"))
+		mode = CXL_PARTMODE_DYNAMIC_RAM_1;
 	else
 		return -EINVAL;
 
@@ -327,6 +330,7 @@ static struct attribute_group cxl_decoder_base_attribute_group = {
 static struct attribute *cxl_decoder_root_attrs[] = {
 	&dev_attr_cap_pmem.attr,
 	&dev_attr_cap_ram.attr,
+	&dev_attr_cap_dynamic_ram_1.attr,
 	&dev_attr_cap_type2.attr,
 	&dev_attr_cap_type3.attr,
 	&dev_attr_target_list.attr,
-- 
2.43.0

