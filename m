Return-Path: <SRS0=7ETp=BG=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=BAYES_50,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA14C433DF
	for <linux-nvdimm@archiver.kernel.org>; Mon, 27 Jul 2020 09:57:08 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9083320786
	for <linux-nvdimm@archiver.kernel.org>; Mon, 27 Jul 2020 09:57:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9083320786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 598F11232DCC3;
	Mon, 27 Jul 2020 02:57:08 -0700 (PDT)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=37.49.224.50; helo=gmail.com; envelope-from=anisa.uclswift@gmail.com; receiver=<UNKNOWN> 
Received: from gmail.com (unknown [37.49.224.50])
	by ml01.01.org (Postfix) with ESMTP id 769C412214714
	for <linux-nvdimm@lists.01.org>; Mon, 27 Jul 2020 02:57:02 -0700 (PDT)
From: anisa.uclswift@gmail.com
To: linux-nvdimm@lists.01.org
Subject: Re: Pocketing order 1-3
Date: 27 Jul 2020 11:56:56 +0200
Message-ID: <20200727115655.28729A90728BF0A1@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_785FB9BE.31BA721B"
Message-ID-Hash: FVN5NLXPS7FIZKZ4CMJDD4ULRKHIWOLN
X-Message-ID-Hash: FVN5NLXPS7FIZKZ4CMJDD4ULRKHIWOLN
X-MailFrom: anisa.uclswift@gmail.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/FVN5NLXPS7FIZKZ4CMJDD4ULRKHIWOLN/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0012_785FB9BE.31BA721B
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

------=_NextPart_000_0012_785FB9BE.31BA721B--
