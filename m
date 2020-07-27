Return-Path: <SRS0=7ETp=BG=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B21A0C433EC
	for <linux-nvdimm@archiver.kernel.org>; Mon, 27 Jul 2020 16:30:49 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8898C206E7
	for <linux-nvdimm@archiver.kernel.org>; Mon, 27 Jul 2020 16:30:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="KtM0Agb5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8898C206E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5F017123E392D;
	Mon, 27 Jul 2020 09:30:49 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=rppt@kernel.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 4F97F123E3923
	for <linux-nvdimm@lists.01.org>; Mon, 27 Jul 2020 09:30:47 -0700 (PDT)
Received: from aquarius.haifa.ibm.com (nesher1.haifa.il.ibm.com [195.110.40.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 286AF2074F;
	Mon, 27 Jul 2020 16:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595867447;
	bh=/Qw/NeLTpR/6aCJ04huD3Mp72u1Bfe6uWLUqSL0Zn2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtM0Agb5HnPUkY+CbqIdR37o127nhQKSy5Dq+iFtbhAZ5rXOrCF/TCi/y9dVBPJgG
	 ESLcg0dYR67EEDk5MwOpPeS2zHrUXad+3m3RPRP3kklfQeu9q9pdGF6IS3dzaGLPnI
	 xswjDrT4XhuX8HarB2l6OUZFzMfxbAPY98Qdg+hQ=
From: Mike Rapoport <rppt@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] mm: secretmem: add ability to reserve memory at boot
Date: Mon, 27 Jul 2020 19:29:35 +0300
Message-Id: <20200727162935.31714-8-rppt@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200727162935.31714-1-rppt@kernel.org>
References: <20200727162935.31714-1-rppt@kernel.org>
MIME-Version: 1.0
Message-ID-Hash: YE7C5CXKONS6SP55HY4Y4KSD5TM4DQJQ
X-Message-ID-Hash: YE7C5CXKONS6SP55HY4Y4KSD5TM4DQJQ
X-MailFrom: rppt@kernel.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, Christopher Lameter <cl@linux.com>, Dave Hansen <dave.hansen@linux.intel.com>, Elena Reshetova <elena.reshetova@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Idan Yaniv <idan.yaniv@ibm.com>, Ingo Molnar <mingo@redhat.com>, James Bottomley <jejb@linux.ibm.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Tycho Andersen <tycho@tycho.ws>, Will Deacon <will@kernel.org>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-riscv@lists.infradead.org, x86@kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/YE7C5CXKONS6SP55HY4Y4KSD5TM4DQJQ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Mike Rapoport <rppt@linux.ibm.com>

Taking pages out from the direct map and bringing them back may create
undesired fragmentation and usage of the smaller pages in the direct
mapping of the physical memory.

This can be avoided if a significantly large area of the physical memory
would be reserved for secretmem purposes at boot time.

Add ability to reserve physical memory for secretmem at boot time using
"secretmem" kernel parameter and then use that reserved memory as a global
pool for secret memory needs.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index fb95fad81c79..6f3c2f28160f 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4548,6 +4548,10 @@
 			Format: integer between 0 and 10
 			Default is 0.
 
+	secretmem=n[KMG]
+			[KNL,BOOT] Reserve specified amount of memory to
+			back mappings of secret memory.
+
 	skew_tick=	[KNL] Offset the periodic timer tick per cpu to mitigate
 			xtime_lock contention on larger systems, and/or RCU lock
 			contention on all systems with CONFIG_MAXSMP set.
-- 
2.26.2
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
