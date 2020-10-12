Return-Path: <SRS0=VJky=DT=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.8 required=3.0 tests=BAYES_80,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	SUBJ_ALL_CAPS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B270AC43457
	for <linux-nvdimm@archiver.kernel.org>; Mon, 12 Oct 2020 12:48:44 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3711C20776
	for <linux-nvdimm@archiver.kernel.org>; Mon, 12 Oct 2020 12:48:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3711C20776
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=stemco.com.tw
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id B980F158EBC8A;
	Mon, 12 Oct 2020 05:48:43 -0700 (PDT)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=104.168.242.22; helo=stemco.com.tw; envelope-from=ybisale@stemco.com.tw; receiver=<UNKNOWN> 
Received: from stemco.com.tw (hwsrv-787319.hostwindsdns.com [104.168.242.22])
	by ml01.01.org (Postfix) with ESMTP id DC043158EBC87
	for <linux-nvdimm@lists.01.org>; Mon, 12 Oct 2020 05:48:35 -0700 (PDT)
From: Jerry Young <ybisale@stemco.com.tw>
To: linux-nvdimm@lists.01.org
Subject: RE: VACUUM VAVLE INQUIRY
Date: 12 Oct 2020 12:48:33 +0000
Message-ID: <20201012124832.4D6E966E16588F9A@stemco.com.tw>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_2E7864AD.31F813BC"
Message-ID-Hash: ZTPSCTVNV5NCPOLWQHMH7CGBWKQEIDMF
X-Message-ID-Hash: ZTPSCTVNV5NCPOLWQHMH7CGBWKQEIDMF
X-MailFrom: ybisale@stemco.com.tw
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/ZTPSCTVNV5NCPOLWQHMH7CGBWKQEIDMF/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0012_2E7864AD.31F813BC
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

------=_NextPart_000_0012_2E7864AD.31F813BC--
