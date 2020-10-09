Return-Path: <SRS0=cB0/=DQ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52EE6C84630
	for <linux-nvdimm@archiver.kernel.org>; Fri,  9 Oct 2020 19:53:12 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0E4DC224D3
	for <linux-nvdimm@archiver.kernel.org>; Fri,  9 Oct 2020 19:53:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E4DC224D3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id E8991159A284F;
	Fri,  9 Oct 2020 12:53:11 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.100; helo=mga07.intel.com; envelope-from=ira.weiny@intel.com; receiver=<UNKNOWN> 
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C8F551594D300
	for <linux-nvdimm@lists.01.org>; Fri,  9 Oct 2020 12:53:09 -0700 (PDT)
IronPort-SDR: jrfaJkarRXX8wfI8ANHk5cvuWKyi8PTl6JCUnr4wAR9YGLkznn6lDC24vkg/MW7TeSUL6mWH7b
 URlZZuntEvOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="229715301"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400";
   d="scan'208";a="229715301"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:53:09 -0700
IronPort-SDR: FciD93oXa6TN5PQF74JzeuCyRYkWBlT2lC/7ncntBELjkiuqMo1u2JSAhMViBtfJLu9YdFEYCB
 Wo/5PMHidIaw==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400";
   d="scan'208";a="317147397"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:53:08 -0700
From: ira.weiny@intel.com
To: Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH RFC PKS/PMEM 39/58] fs/jffs2: Utilize new kmap_thread()
Date: Fri,  9 Oct 2020 12:50:14 -0700
Message-Id: <20201009195033.3208459-40-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Message-ID-Hash: 3F2MKGALWH7J3STXEHB4UHHWSUVWGJ7P
X-Message-ID-Hash: 3F2MKGALWH7J3STXEHB4UHHWSUVWGJ7P
X-MailFrom: ira.weiny@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Fenghua Yu <fenghua.yu@intel.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, kexec@lists.infradead.org, linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org, devel@driverdev.osuosl.org, linux-efi@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-aio@kvack.org, io-uring@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-um@lists.infradead.org, linux-ntfs-dev@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, cluster-devel@redhat.com, ecryptfs@vger.kernel.org, linux-cifs@vger.kernel.org
 , linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, xen-devel@lists.xenproject.org, linux-cachefs@redhat.com, samba-technical@lists.samba.org, intel-wired-lan@lists.osuosl.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/3F2MKGALWH7J3STXEHB4UHHWSUVWGJ7P/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Ira Weiny <ira.weiny@intel.com>

These kmap() calls are localized to a single thread.  To avoid the over head of
global PKRS updates use the new kmap_thread() call.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/jffs2/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index 3e6d54f9b011..14dd2b18cc16 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -287,13 +287,13 @@ static int jffs2_write_end(struct file *filp, struct address_space *mapping,
 
 	/* In 2.4, it was already kmapped by generic_file_write(). Doesn't
 	   hurt to do it again. The alternative is ifdefs, which are ugly. */
-	kmap(pg);
+	kmap_thread(pg);
 
 	ret = jffs2_write_inode_range(c, f, ri, page_address(pg) + aligned_start,
 				      (pg->index << PAGE_SHIFT) + aligned_start,
 				      end - aligned_start, &writtenlen);
 
-	kunmap(pg);
+	kunmap_thread(pg);
 
 	if (ret) {
 		/* There was an error writing. */
-- 
2.28.0.rc0.12.gb6a658bd00c9
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
