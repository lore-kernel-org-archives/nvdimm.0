Return-Path: <SRS0=sp4a=4A=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E617C3B186
	for <linux-nvdimm@archiver.kernel.org>; Wed, 12 Feb 2020 17:07:57 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E5DB821734
	for <linux-nvdimm@archiver.kernel.org>; Wed, 12 Feb 2020 17:07:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DkoFj9Ce"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5DB821734
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C1B4C1007B18C;
	Wed, 12 Feb 2020 09:11:13 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=207.211.31.81; helo=us-smtp-delivery-1.mimecast.com; envelope-from=vgoyal@redhat.com; receiver=<UNKNOWN> 
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id F31F61007B1FC
	for <linux-nvdimm@lists.01.org>; Wed, 12 Feb 2020 09:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1581527273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qAHXFz29ZqKfWinL/vfbLZE3eUCyI3Z/8yBsq8fYK5M=;
	b=DkoFj9CeEik95tkPwBYPnqs8A7Hj1pU53lwie4lmn/AgStuvQiTdoRwZW1xsr7RCBqYnMF
	L8zC5vRWUiSTXliYkhz12SV/zOO6+8mvgCw/1mGilJdtunoSJsR7tCuEUatwvfWgEIArSu
	etABeRr98hInQYd6J8z6g+hhJPX2UhY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-3iXqSZYVPRmtc7AyYUbG7Q-1; Wed, 12 Feb 2020 12:07:51 -0500
X-MC-Unique: 3iXqSZYVPRmtc7AyYUbG7Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB896DBA3;
	Wed, 12 Feb 2020 17:07:49 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.18.25.35])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 26F8F5C1B2;
	Wed, 12 Feb 2020 17:07:47 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
	id B766D2257D5; Wed, 12 Feb 2020 12:07:46 -0500 (EST)
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-nvdimm@lists.01.org,
	dan.j.williams@intel.com,
	hch@infradead.org
Subject: [PATCH 3/6] fs/dax.c: Start using dax_pgoff() instead of bdev_dax_pgoff()
Date: Wed, 12 Feb 2020 12:07:30 -0500
Message-Id: <20200212170733.8092-4-vgoyal@redhat.com>
In-Reply-To: <20200212170733.8092-1-vgoyal@redhat.com>
References: <20200212170733.8092-1-vgoyal@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Message-ID-Hash: DYPKJMRVTYW2HCEY54UV5HTZMIHVXGQT
X-Message-ID-Hash: DYPKJMRVTYW2HCEY54UV5HTZMIHVXGQT
X-MailFrom: vgoyal@redhat.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: dm-devel@redhat.com, jack@suse.cz
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/DYPKJMRVTYW2HCEY54UV5HTZMIHVXGQT/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Replace usage of bdev_dax_pgoff() with dax_pgoff() in fs/dax.c

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/dax.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 35da144375a0..921042a81538 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -680,7 +680,7 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 	return __dax_invalidate_entry(mapping, index, false);
 }
 
-static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
+static int copy_user_dax(struct dax_device *dax_dev, sector_t dax_offset,
 		sector_t sector, size_t size, struct page *to,
 		unsigned long vaddr)
 {
@@ -689,7 +689,7 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
 	long rc;
 	int id;
 
-	rc = bdev_dax_pgoff(bdev, sector, size, &pgoff);
+	rc = dax_pgoff(dax_offset, sector, size, &pgoff);
 	if (rc)
 		return rc;
 
@@ -990,7 +990,7 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
 	int id, rc;
 	long length;
 
-	rc = bdev_dax_pgoff(iomap->bdev, sector, size, &pgoff);
+	rc = dax_pgoff(iomap->dax_offset, sector, size, &pgoff);
 	if (rc)
 		return rc;
 	id = dax_read_lock();
@@ -1065,7 +1065,7 @@ int __dax_zero_page_range(struct block_device *bdev,
 		long rc, id;
 		void *kaddr;
 
-		rc = bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
+		rc = dax_pgoff(get_start_sect(bdev), sector, PAGE_SIZE, &pgoff);
 		if (rc)
 			return rc;
 
@@ -1087,7 +1087,6 @@ static loff_t
 dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		struct iomap *iomap, struct iomap *srcmap)
 {
-	struct block_device *bdev = iomap->bdev;
 	struct dax_device *dax_dev = iomap->dax_dev;
 	struct iov_iter *iter = data;
 	loff_t end = pos + length, done = 0;
@@ -1132,7 +1131,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 			break;
 		}
 
-		ret = bdev_dax_pgoff(bdev, sector, size, &pgoff);
+		ret = dax_pgoff(iomap->dax_offset, sector, size, &pgoff);
 		if (ret)
 			break;
 
@@ -1312,7 +1311,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			clear_user_highpage(vmf->cow_page, vaddr);
 			break;
 		case IOMAP_MAPPED:
-			error = copy_user_dax(iomap.bdev, iomap.dax_dev,
+			error = copy_user_dax(iomap.dax_dev, iomap.dax_offset,
 					sector, PAGE_SIZE, vmf->cow_page, vaddr);
 			break;
 		default:
-- 
2.20.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
