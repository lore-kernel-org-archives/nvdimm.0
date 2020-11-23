Return-Path: <SRS0=IQ1B=E5=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9998C2D0E4
	for <linux-nvdimm@archiver.kernel.org>; Mon, 23 Nov 2020 12:37:45 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 72D7721D93
	for <linux-nvdimm@archiver.kernel.org>; Mon, 23 Nov 2020 12:37:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbYyFxYx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72D7721D93
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id F3538100EBBB2;
	Mon, 23 Nov 2020 04:37:44 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id BA97C100EBBA2
	for <linux-nvdimm@lists.01.org>; Mon, 23 Nov 2020 04:37:43 -0800 (PST)
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id B62BC22203;
	Mon, 23 Nov 2020 12:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1606135063;
	bh=CNiP+4Hj3vw6UmF5OummcB34I0ZbFbNNqimg2SA/Qck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbYyFxYx9zsF9B7BazhOEw5ZmzNUEg4LHSgHjn/D/1zs2tg84HMNVKljwA+Pxvi7F
	 uuK1nnGcUBLz8TeSK30E2PfHXdFGXQq4dH8EEq9qAX20/8lO/Hj/lpJdAFSLx0DPVp
	 Frg3dgdHs0n6cV+wsvdbInhJ6MK49xAQ5ADobgTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5.4 061/158] MIPS: export has_transparent_hugepage() for modules
Date: Mon, 23 Nov 2020 13:21:29 +0100
Message-Id: <20201123121822.882979950@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Message-ID-Hash: KXQ62RVOPCABCMMB26PJRJQ2GCUQ7J2Y
X-Message-ID-Hash: KXQ62RVOPCABCMMB26PJRJQ2GCUQ7J2Y
X-MailFrom: gregkh@linuxfoundation.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, kernel test robot <lkp@intel.com>, Randy Dunlap <rdunlap@infradead.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, linux-mips@vger.kernel.org, linux-nvdimm@lists.01.org, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sashal@kernel.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/KXQ62RVOPCABCMMB26PJRJQ2GCUQ7J2Y/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 31b4d8e172f614adc53ddecb4b6b2f6411a49b84 ]

MIPS should export its local version of "has_transparent_hugepage"
so that loadable modules (dax) can use it.

Fixes this build error:
ERROR: modpost: "has_transparent_hugepage" [drivers/dax/dax.ko] undefined!

Fixes: fd8cfd300019 ("arch: fix has_transparent_hugepage()")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/tlb-r4k.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index c13e46ced4252..60046445122b3 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -437,6 +437,7 @@ int has_transparent_hugepage(void)
 	}
 	return mask == PM_HUGE_MASK;
 }
+EXPORT_SYMBOL(has_transparent_hugepage);
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE  */
 
-- 
2.27.0


_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
