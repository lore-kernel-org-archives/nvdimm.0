Return-Path: <SRS0=Or7U=6L=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_SPACE_RATIO autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D068C54FD0
	for <linux-nvdimm@archiver.kernel.org>; Mon, 27 Apr 2020 01:22:31 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E7D3E206A5
	for <linux-nvdimm@archiver.kernel.org>; Mon, 27 Apr 2020 01:22:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7D3E206A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=strabag.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 32DE4100A2D76;
	Sun, 26 Apr 2020 18:21:43 -0700 (PDT)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=199.43.204.175; helo=strabag.com; envelope-from=clara.heimsoth@strabag.com; receiver=<UNKNOWN> 
Received: from strabag.com (unknown [199.43.204.175])
	by ml01.01.org (Postfix) with ESMTP id 44177100A2D73
	for <linux-nvdimm@lists.01.org>; Sun, 26 Apr 2020 18:21:38 -0700 (PDT)
From: Clara Heimsoth <clara.heimsoth@strabag.com>
To: linux-nvdimm@lists.01.org
Subject: RFQ
Date: 26 Apr 2020 18:22:33 -0700
Message-ID: <20200426182233.366BAF4DA63B9106@strabag.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_E7FE553E.D6234F67"
Message-ID-Hash: SK3HZQISSX4YVQLUVEJNHWOB5UPEQTQL
X-Message-ID-Hash: SK3HZQISSX4YVQLUVEJNHWOB5UPEQTQL
X-MailFrom: clara.heimsoth@strabag.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/SK3HZQISSX4YVQLUVEJNHWOB5UPEQTQL/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0012_E7FE553E.D6234F67
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

------=_NextPart_000_0012_E7FE553E.D6234F67--
