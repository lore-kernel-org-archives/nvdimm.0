Return-Path: <SRS0=DAtX=7H=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B72C433DF
	for <linux-nvdimm@archiver.kernel.org>; Mon, 25 May 2020 11:30:41 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6A099207FB
	for <linux-nvdimm@archiver.kernel.org>; Mon, 25 May 2020 11:30:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ldwlZKv1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A099207FB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 1324F1221A1C4;
	Mon, 25 May 2020 04:26:44 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2607:7c80:54:e::133; helo=bombadil.infradead.org; envelope-from=batv+ab9bb8b38cf50d3a9241+6119+infradead.org+hch@bombadil.srs.infradead.org; receiver=<UNKNOWN> 
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id A3105121A5897
	for <linux-nvdimm@lists.01.org>; Mon, 25 May 2020 04:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6q0JZlv6yk8CHhGPFeT7uICF95ljL7cHdN6LUQXOkNk=; b=ldwlZKv1HI1TjI572L0NqiGrY5
	Dw+zIeRHjvNa1t18biM/jI9PjQwjir0TcLv1jyJSG/uAIYBeC3W1zJd+DRVX2rzmh9a3XNEquIWvq
	95P2v9xOuQWyvb4ggBjW79fYVsBTu6Al1JN9SczCfg2zt/kcDTVxJoTvPgtb7IjKlX+vAkQNEdZQ9
	ymFv7xBo8JaHLBqJD2XTmTiIjTHSvdRonnXUdTdCxxYPd2UvbvQUIJfw8WbCLUkLf0M/4kzxqMhZ/
	mntxpjRh0kJFMIb22sEo4gL/Bft/rHtRKS9yDmIDCjaadrkTss9FKqsoiitau1J2hAf58pojKEpjr
	GtYctC3Q==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1jdBJM-0002Oe-UX; Mon, 25 May 2020 11:30:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/16] lightnvm/pblk: use bio_{start,end}_io_acct
Date: Mon, 25 May 2020 13:30:02 +0200
Message-Id: <20200525113014.345997-5-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525113014.345997-1-hch@lst.de>
References: <20200525113014.345997-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Message-ID-Hash: UMSJHGYS7IIYN3KSFGWXZZIC4SLGAUOQ
X-Message-ID-Hash: UMSJHGYS7IIYN3KSFGWXZZIC4SLGAUOQ
X-MailFrom: BATV+ab9bb8b38cf50d3a9241+6119+infradead.org+hch@bombadil.srs.infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/UMSJHGYS7IIYN3KSFGWXZZIC4SLGAUOQ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Switch rsxx to use the nicer bio accounting helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/lightnvm/pblk-cache.c |  8 +++-----
 drivers/lightnvm/pblk-read.c  | 11 ++++-------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/lightnvm/pblk-cache.c b/drivers/lightnvm/pblk-cache.c
index 5c1034c22197c..f185f1a000083 100644
--- a/drivers/lightnvm/pblk-cache.c
+++ b/drivers/lightnvm/pblk-cache.c
@@ -21,16 +21,14 @@
 void pblk_write_to_cache(struct pblk *pblk, struct bio *bio,
 				unsigned long flags)
 {
-	struct request_queue *q = pblk->dev->q;
 	struct pblk_w_ctx w_ctx;
 	sector_t lba = pblk_get_lba(bio);
-	unsigned long start_time = jiffies;
+	unsigned long start_time;
 	unsigned int bpos, pos;
 	int nr_entries = pblk_get_secs(bio);
 	int i, ret;
 
-	generic_start_io_acct(q, REQ_OP_WRITE, bio_sectors(bio),
-			      &pblk->disk->part0);
+	start_time = bio_start_io_acct(bio);
 
 	/* Update the write buffer head (mem) with the entries that we can
 	 * write. The write in itself cannot fail, so there is no need to
@@ -79,7 +77,7 @@ void pblk_write_to_cache(struct pblk *pblk, struct bio *bio,
 	pblk_rl_inserted(&pblk->rl, nr_entries);
 
 out:
-	generic_end_io_acct(q, REQ_OP_WRITE, &pblk->disk->part0, start_time);
+	bio_end_io_acct(bio, start_time);
 	pblk_write_should_kick(pblk);
 
 	if (ret == NVM_IO_DONE)
diff --git a/drivers/lightnvm/pblk-read.c b/drivers/lightnvm/pblk-read.c
index 8efd14e683dc4..140927ebf41e9 100644
--- a/drivers/lightnvm/pblk-read.c
+++ b/drivers/lightnvm/pblk-read.c
@@ -187,12 +187,11 @@ static void pblk_end_user_read(struct bio *bio, int error)
 static void __pblk_end_io_read(struct pblk *pblk, struct nvm_rq *rqd,
 			       bool put_line)
 {
-	struct nvm_tgt_dev *dev = pblk->dev;
 	struct pblk_g_ctx *r_ctx = nvm_rq_to_pdu(rqd);
 	struct bio *int_bio = rqd->bio;
 	unsigned long start_time = r_ctx->start_time;
 
-	generic_end_io_acct(dev->q, REQ_OP_READ, &pblk->disk->part0, start_time);
+	bio_end_io_acct(int_bio, start_time);
 
 	if (rqd->error)
 		pblk_log_read_err(pblk, rqd);
@@ -263,17 +262,15 @@ static void pblk_read_rq(struct pblk *pblk, struct nvm_rq *rqd, struct bio *bio,
 
 void pblk_submit_read(struct pblk *pblk, struct bio *bio)
 {
-	struct nvm_tgt_dev *dev = pblk->dev;
-	struct request_queue *q = dev->q;
 	sector_t blba = pblk_get_lba(bio);
 	unsigned int nr_secs = pblk_get_secs(bio);
 	bool from_cache;
 	struct pblk_g_ctx *r_ctx;
 	struct nvm_rq *rqd;
 	struct bio *int_bio, *split_bio;
+	unsigned long start_time;
 
-	generic_start_io_acct(q, REQ_OP_READ, bio_sectors(bio),
-			      &pblk->disk->part0);
+	start_time = bio_start_io_acct(bio);
 
 	rqd = pblk_alloc_rqd(pblk, PBLK_READ);
 
@@ -283,7 +280,7 @@ void pblk_submit_read(struct pblk *pblk, struct bio *bio)
 	rqd->end_io = pblk_end_io_read;
 
 	r_ctx = nvm_rq_to_pdu(rqd);
-	r_ctx->start_time = jiffies;
+	r_ctx->start_time = start_time;
 	r_ctx->lba = blba;
 
 	if (pblk_alloc_rqd_meta(pblk, rqd)) {
-- 
2.26.2
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
