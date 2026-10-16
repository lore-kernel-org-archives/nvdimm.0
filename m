Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FBD41A507
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 21:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792186987; cv=none; b=txb6H6m52f+7AAUdrbheV2THDVB6ITZRQdqK6NJepNsDLJithy/faZVu5UjamgTak83YmX4OPrngx7XsrO1iePOHinFuvg5T41216Av6TZJi0CCamW5TmkYdtFwAki1dDC/ocxSJFxQvIoRakKhOOYP992xH0wjVdcy6PLxKMgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792186987; c=relaxed/simple;
	bh=F/WfM57U0q+ZDXPsww2a9GAL1EnewK+UCthzDsiLWGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeApUM4EqUCNLXd6LEVOzV1+SO7oDzQM1dLypIHwwmmZlXNdOVurDOx+J4lDmoOCHTzBKeR181Sg2pE14FI23BhTNy2Xcn9msl7yjhkgbbnKyDbETZsRScxMkTK1ItQVsrm+LrTAa0OFzdRlAHTuLUW6R6/XAl2ruAG7I1lfcTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=lDChhkUY; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="lDChhkUY"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93e6eb77f0bso32485885a.3
        for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 14:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792186981; x=1792791781; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/+8JzaREQmzObVLMrQUhDLgZ0SUm0BdY4m5gZbFeHUk=;
        b=lDChhkUYVeF7AT2TpSrJRR+44N1Ho0BuqID4ow+d+rXzFwiSh7c65TQKGL2oWlb3pp
         5FWj7usuBvgzukQLX7aUnlQYkql01fz8Gwhs4naAqbbTK8aSsQ1vMvTlstHvzm5AyMkb
         3WG7unULzwzR9dd6XZRaTy3TRZlAKV1Qt94DLVoQZawYNqIkhPFyNlZH6vSi0YWQVi2M
         1AzCpe26hDp6LgFBwClaLk4gkcrjOsMQb+ewGy83239Z47HPhyNkUC4iUHqXOl1w88Th
         2f14/UES2LAJxFyUzWAFleg8K2ROeUFQufYyKSVzLQU4F1cyUfJEUl/gV8ptgbWuD3fR
         NN0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792186981; x=1792791781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/+8JzaREQmzObVLMrQUhDLgZ0SUm0BdY4m5gZbFeHUk=;
        b=tIFhUTKEx00GJsAOAUuU2PmRiFgGFu99LblKjIMyJIbBHHc30uEnmX1eAf3Ga/pDUc
         LZk9g1Gt71J24zog9EkdMk320EfWyGCG41MkYdJ0artD2H+hBAyBXZk8ChNVXDEbRkCa
         yBZulabIGQt0h8wbQeFRWZ3J8FDi7vzP6K0zXICm2lerilRQ47WUCLGmRWAw+tO7gdHx
         1hreHxfsOD5QOBDk2daN04zO6v3OqnGdkEmZs5L/l2eosJ7lL8vuAFdbB9GHB8bV6OTy
         ngTN/mxIMtRm5bmg8Qsr4YLpo4i6OowUAle0q1HB/1LX2l9g2Zxv8a2UIqeHjBteDlaf
         0J/g==
X-Gm-Message-State: AFq9FYJfG0JJeBYv37JtTjT2YniIRr4Fe5prwtg5uV/jhM2LMO5NTna3
	k+X6KyyMfXUGSVW1k7i6aSAmk0CP3GTeYVpz/42KCWjUfQY7bmIyRg6DiuIPRrXeKwzDuFKaBQA
	TwUgUj5E=
X-Gm-Gg: AYBFou3eG9w8ZdwH8LLZ7slKKoxpWtXh0RX/2r139Z332qnq3YNJSBBmAZWZoLPzAhR
	xTftysxoT3nlZziEVlQgDVMZ3Nj1m/rL+i5v46RcrJ503fiGVVyq5EseaTCYw2fHvrzlzBPHJmI
	K311MFC3aAf3SlbzBzNUe7g9hUK5dafpmMHOLkCu+8qSMyE+FNZdy9uHOUEbWRdQ8AJ1COaSACJ
	UWAw8aH7QtipTb3PcHmyrFpfR+jC4D+0AlscvrXCsix0iGJg9SgkcD6InFF8kalpnfHCkqYhCvC
	w05NmCma7bssYxn8AcMfxFxfMW7aj0X/FC1vjEUEhGjK/mWo66N2C+g5DlNcaMRUwhDciFH1zsG
	7pCfcp/G2I9lXcKvLlG7tjswpRliocTYcax3b7Jr9mhc1NEIY4wCtMAmf1PsGELADNNBnBZwpKT
	U53lvXio3+lwhXd19NQ8t/fzrT7RRC5vpQRoYV2icelECsrCtuaPkK+mleZKR3G59O5b3OYqwSW
	3Z9NR+BJ4biJaIkQMBMl0/yJ7psivoBlYwI5xwq3VnpWGDtO+LcvhMxSyICFYE6QGDTFs8=
X-Received: by 2002:a05:620a:2903:b0:93c:2c15:e510 with SMTP id af79cd13be357-93f29d37e3cmr198987285a.37.1792186981243;
        Fri, 16 Oct 2026 14:43:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1a8ee1sm312622985a.34.2026.10.16.14.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 14:43:00 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: alison.schofield@intel.com,
	Gregory Price <gourry@gourry.net>
Subject: [PATCH 5/6] Documentation: describe atomic whole-device hotplug in daxctl man pages
Date: Fri, 16 Oct 2026 17:42:47 -0400
Message-ID: <20261016214248.443247-6-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261016214248.443247-1-gourry@gourry.net>
References: <20261016214248.443247-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gregory Price <gourry@gourry.net>

Document that online-memory and offline-memory use daxX.Y/state where
available, that offlining always removes the memory blocks and how
that affects reconfigure-device, and the 'hotplug_state' attribute of
'daxctl list'.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 Documentation/daxctl/daxctl-list.txt               | 5 +++++
 Documentation/daxctl/daxctl-offline-memory.txt     | 5 +++++
 Documentation/daxctl/daxctl-online-memory.txt      | 5 +++++
 Documentation/daxctl/daxctl-reconfigure-device.txt | 5 ++++-
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/Documentation/daxctl/daxctl-list.txt b/Documentation/daxctl/daxctl-list.txt
index 5a6a98e..a2d0ede 100644
--- a/Documentation/daxctl/daxctl-list.txt
+++ b/Documentation/daxctl/daxctl-list.txt
@@ -22,6 +22,11 @@ list' with no options is equivalent to:
 [verse]
 daxctl list --devices
 
+On kernels that support atomic whole-device hotplug, 'hotplug_state'
+reports /sys/bus/dax/devices/daxX.Y/state for system-ram devices, or
+'inconsistent' if the device's memory blocks disagree with it (e.g.
+after blocks were onlined or offlined individually).
+
 EXAMPLE
 -------
 ----
diff --git a/Documentation/daxctl/daxctl-offline-memory.txt b/Documentation/daxctl/daxctl-offline-memory.txt
index ba06287..61a4301 100644
--- a/Documentation/daxctl/daxctl-offline-memory.txt
+++ b/Documentation/daxctl/daxctl-offline-memory.txt
@@ -41,6 +41,11 @@ to the system-ram mode. If one or more blocks are already offline, attempt to
 offline the remaining blocks. If all blocks were already offline, print a
 message and return success without actually doing anything.
 
+If the kernel supports atomic whole-device hotplug
+(/sys/bus/dax/devices/daxX.Y/state), the device is instead unplugged,
+even if its memory is already offline: the memory is offlined and
+removed in one atomic operation. 'daxctl-online-memory' restores it.
+
 This is complementary to the 'daxctl-online-memory' command, and may be used
 when it is wished to offline the memory sections, but not convert the device
 back to 'devdax' mode.
diff --git a/Documentation/daxctl/daxctl-online-memory.txt b/Documentation/daxctl/daxctl-online-memory.txt
index 08b45cc..adc8517 100644
--- a/Documentation/daxctl/daxctl-online-memory.txt
+++ b/Documentation/daxctl/daxctl-online-memory.txt
@@ -48,6 +48,11 @@ Online the memory sections associated with a device that has been converted
 to the system-ram mode. If one or more blocks are already online, print a
 message about them, and attempt to online the remaining blocks.
 
+If the kernel supports atomic whole-device hotplug
+(/sys/bus/dax/devices/daxX.Y/state), a fully offline device is onlined
+as a whole rather than block by block. An 'unplugged' device is re-added
+and onlined atomically; one with blocks present is unplugged first.
+
 This is complementary to the 'daxctl-reconfigure-device' command, when used with
 the '--no-online' option to skip onlining memory sections immediately after the
 reconfigure. In these scenarios, the memory can be onlined at a later time using
diff --git a/Documentation/daxctl/daxctl-reconfigure-device.txt b/Documentation/daxctl/daxctl-reconfigure-device.txt
index 9c3922d..d2b5bbf 100644
--- a/Documentation/daxctl/daxctl-reconfigure-device.txt
+++ b/Documentation/daxctl/daxctl-reconfigure-device.txt
@@ -230,6 +230,8 @@ include::region-option.txt[]
 	By default, memory sections provided by system-ram devices will be
 	brought online automatically and immediately with the 'online_movable'
 	policy. Use this option to disable the automatic onlining behavior.
+	A device unplugged by 'daxctl-offline-memory' has no memory blocks
+	to online; use 'daxctl-online-memory' to restore them.
 
 -C::
 --check-config::
@@ -248,7 +250,8 @@ include::movable-options.txt[]
 	that all the memory sections are first made offline. By default,
 	daxctl won't touch online memory. However with this option, attempt
 	to offline the memory on the NUMA node associated with the dax device
-	before converting it back to "devdax" mode.
+	before converting it back to "devdax" mode. This uses
+	'daxctl-offline-memory', so the device is unplugged where supported.
 
 	- Additionally, if a kernel policy to auto-online blocks is detected,
 	reconfiguration to system-ram fails. With this option, the failure can
-- 
2.53.0-Meta

