Return-Path: <SRS0=2TNe=57=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A440DC2BA2B
	for <linux-nvdimm@archiver.kernel.org>; Wed, 15 Apr 2020 21:17:22 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 27BB020787
	for <linux-nvdimm@archiver.kernel.org>; Wed, 15 Apr 2020 21:17:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27BB020787
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D116510106337;
	Wed, 15 Apr 2020 14:17:48 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=195.135.220.15; helo=mx2.suse.de; envelope-from=msuchanek@suse.de; receiver=<UNKNOWN> 
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C809C10106335
	for <linux-nvdimm@lists.01.org>; Wed, 15 Apr 2020 14:17:45 -0700 (PDT)
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 93013AC1D;
	Wed, 15 Apr 2020 21:17:15 +0000 (UTC)
From: Michal Suchanek <msuchanek@suse.de>
To: linux-nvdimm@lists.01.org
Subject: [PATCH] doc: nvdimm: remove reference to non-existent CONFIG_NFIT_TEST
Date: Wed, 15 Apr 2020 23:16:50 +0200
Message-Id: <20200415211654.10827-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Message-ID-Hash: 6LSZP5UVVLYO4LKHTK5I2KVM2GEKYYNT
X-Message-ID-Hash: 6LSZP5UVVLYO4LKHTK5I2KVM2GEKYYNT
X-MailFrom: msuchanek@suse.de
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Michal Suchanek <msuchanek@suse.de>, Jonathan Corbet <corbet@lwn.net>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/6LSZP5UVVLYO4LKHTK5I2KVM2GEKYYNT/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The test driver is in tools/testing/nvdimm and cannot be selected by a
config option.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 Documentation/driver-api/nvdimm/nvdimm.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/driver-api/nvdimm/nvdimm.rst b/Documentation/driver-api/nvdimm/nvdimm.rst
index 08f855cbb4e6..79c0fd39f2af 100644
--- a/Documentation/driver-api/nvdimm/nvdimm.rst
+++ b/Documentation/driver-api/nvdimm/nvdimm.rst
@@ -278,8 +278,8 @@ by a region device with a dynamically assigned id (REGION0 - REGION5).
        be contiguous in DPA-space.
 
     This bus is provided by the kernel under the device
-    /sys/devices/platform/nfit_test.0 when CONFIG_NFIT_TEST is enabled and
-    the nfit_test.ko module is loaded.  This not only test LIBNVDIMM but the
+    /sys/devices/platform/nfit_test.0 when the nfit_test.ko module from
+    tools/testing/nvdimm is loaded.  This not only test LIBNVDIMM but the
     acpi_nfit.ko driver as well.
 
 
-- 
2.26.0
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
