Return-Path: <SRS0=fBV/=63=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F33CC433DF
	for <linux-nvdimm@archiver.kernel.org>; Wed, 13 May 2020 16:28:50 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CEEED2064E
	for <linux-nvdimm@archiver.kernel.org>; Wed, 13 May 2020 16:28:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CEEED2064E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=ups.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A606F11820DC5;
	Wed, 13 May 2020 09:26:11 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=84.254.8.101; helo=ipa101.8.tellas.gr; envelope-from=underbrushinggsu6@njppsagent6.ups.com; receiver=<UNKNOWN> 
Received: from ipa101.8.tellas.gr (ipa101.8.tellas.gr [84.254.8.101])
	by ml01.01.org (Postfix) with ESMTP id 39C8E117DDD27
	for <linux-nvdimm@lists.01.org>; Wed, 13 May 2020 09:26:06 -0700 (PDT)
Received: from [218.86.79.157] (account eddyeih712@gaalplpclu00074.linux.us.ups.com HELO SUPUSIM.LIEEPUR.njppsagent6.ups.com)
	by ipa101.8.tellas.gr (Exim 4.89)
	with ESMTPA id Qka4j14rIIg31.567 for linux-nvdimm@lists.01.org; Wed, 13 May 2020 18:28:44 +0200
Received: from [130.122.146.55] (helo=QUKAROQ.HESAHED.website)
	by ipa101.8.tellas.gr with ESMTPA
	id 74a3c763
	for linux-nvdimm@lists.01.org; Wed, 13 May 2020 18:28:44 +0200
Date: Wed, 13 May 2020 18:28:44 +0200
Message-ID: <c455.9555.7c08EaDe98.A3a6E@neugidbhpz.vfapjtzacdc.biz>
From: "Invoice-notification@ups.com" <prvs=77085d3b66=noreply@ups.com>
To: linux-nvdimm@lists.01.org
Subject: UPS Invoice Notification
MIME-Version: 1.0
Message-ID-Hash: EUZE3LJY2PQANBJ32QULTWMFLGJINSMR
X-Message-ID-Hash: EUZE3LJY2PQANBJ32QULTWMFLGJINSMR
X-MailFrom: underbrushinggsu6@njppsagent6.ups.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/EUZE3LJY2PQANBJ32QULTWMFLGJINSMR/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Your most recent UPS invoice for your account  is now available.Please view and pay your invoice.For questions about your invoice, or invoice payment, please call (800) 811-1648 Monday through Friday 8:00 am to 9:00 pm Eastern Time.For technical support questions regarding your electronic invoicing, please call 877-289-6418.For more information about UPS billing options, visit http://www.ups.com/content/us/en/bussol/browse/billing.html.Thank you for using UPS.This is a post only email; please do not respond to this message.Notice:  This email message and all attachments transmitted with it may contain proprietary information intended solely for the use of the addressee.  If the reader of this message is not the intended recipient, you are hereby notified that any reading, dissemination, distribution, copying or other use of this message or its attachments is strictly prohibited.  If you have received this message in error, please notify the sender immediately by electronic mail at cu
 stomer.service@ups.com and delete this message and all copies and backups thereof.  Thank you.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
