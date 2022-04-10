Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB631361
	for <nvdimm@lists.linux.dev>; Sun, 10 Apr 2022 12:32:25 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 9B4091F37B
	for <nvdimm@lists.linux.dev>; Sun, 10 Apr 2022 12:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1649593943; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IRU5WLo270Mo2VxtDXh2moJ7GOkd/Alv58g6Oqcx4YU=;
	b=If4ozXmkPEYLtbt/Kl94pB1P6IYJZZhT3ckM1erxAdMzEVaW89d1+/5N6iiJyxgs/dAkiD
	rWaAx/vmJiS3PlMeg8vo+isreYGUEHTfo/OPZnvTd3QNjdsoYPAL3rS9ZCb7hZffOBx/iw
	SkVsNnDDb2xpyp3TvqK3cE1hlz943/A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1649593943;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IRU5WLo270Mo2VxtDXh2moJ7GOkd/Alv58g6Oqcx4YU=;
	b=IrnoVcQkPgz+v3pSQhJdfx83OMw+XCaAXYoN/zYAlyCZ9TwqzxWjcCuPtiG42uBcsEdoLM
	CSOseOLwJtQVEwCw==
Received: from naga.suse.cz (unknown [10.100.224.114])
	by relay2.suse.de (Postfix) with ESMTP id 7BEC5A3B82;
	Sun, 10 Apr 2022 12:32:23 +0000 (UTC)
From: Michal Suchanek <msuchanek@suse.de>
To: nvdimm@lists.linux.dev
Cc: Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH] daxctl: Fix kernel option typo in "Soft Reservation" theory of operation
Date: Sun, 10 Apr 2022 14:32:04 +0200
Message-Id: <20220410123205.6045-2-msuchanek@suse.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220410123205.6045-1-msuchanek@suse.de>
References: <20220410123205.6045-1-msuchanek@suse.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes: 8f4e42c ("daxctl: Add "Soft Reservation" theory of operation")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 Documentation/daxctl/daxctl-reconfigure-device.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/daxctl/daxctl-reconfigure-device.txt b/Documentation/daxctl/daxctl-reconfigure-device.txt
index 385c0c5..09691d2 100644
--- a/Documentation/daxctl/daxctl-reconfigure-device.txt
+++ b/Documentation/daxctl/daxctl-reconfigure-device.txt
@@ -91,8 +91,8 @@ details.
 Outside of the NUMA performance details linked above the other method to
 detect the presence of "Soft Reserved" memory is to dump /proc/iomem and
 look for "Soft Reserved" ranges. If the kernel was not built with
-CONFIG_EFI_SOFTRESERVE, predates the introduction of
-CONFIG_EFI_SOFTRESERVE (v5.5), or was booted with the efi=nosoftreserve
+CONFIG_EFI_SOFT_RESERVE, predates the introduction of
+CONFIG_EFI_SOFT_RESERVE (v5.5), or was booted with the efi=nosoftreserve
 command line then device-dax will not attach and the expectation is that
 the memory shows up as a memory-only NUMA node. Otherwise the memory
 shows up as a device-dax instance and DAXCTL(1) can be used to
-- 
2.35.1

