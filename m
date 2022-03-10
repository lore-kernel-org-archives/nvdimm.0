Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398A47A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 13:30:38 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 3A6E221106
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 13:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1646919036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=IRU5WLo270Mo2VxtDXh2moJ7GOkd/Alv58g6Oqcx4YU=;
	b=UEnstYBhYnkrfot0+Dr+VWJQ3rfI0fJkHBbrAYoWWXBedGn9mjFxpsGtgH1vvObht+W+Gq
	F2q4DXxRVefYuEbIYZ8ovVoisodZWZtZ16EIts4HzuWiVDHVbGtUzs45TTZPDWVUM4czO7
	Rpl0CWrwp5wN2RmSCg0wK31ka4I1XbE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1646919036;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=IRU5WLo270Mo2VxtDXh2moJ7GOkd/Alv58g6Oqcx4YU=;
	b=QZQ4o2sW5cAYcobmrYUpnWbI3RVB5/4S0diEo/zbSfGvcgcdSoW85+g7bioltDE0/B0FkW
	CM6Bm55RBcJ6qwCQ==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 31D01A3B83
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 13:30:36 +0000 (UTC)
Date: Thu, 10 Mar 2022 14:30:35 +0100
From: Michal Suchanek <msuchanek@suse.de>
To: nvdimm@lists.linux.dev
Subject: [PATCH] daxctl: Fix kernel option typo in "Soft Reservation" theory
 of operation
Message-ID: <20220310133035.GA106666@kunlun.suse.cz>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)

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

