Return-Path: <SRS0=dxRc=XM=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D4A5C49ED7
	for <linux-nvdimm@archiver.kernel.org>; Tue, 17 Sep 2019 02:42:18 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E5B3A20678
	for <linux-nvdimm@archiver.kernel.org>; Tue, 17 Sep 2019 02:42:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5B3A20678
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=qby.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 707AC202EA3F0;
	Mon, 16 Sep 2019 19:41:43 -0700 (PDT)
Received-SPF: None (no SPF record) identity=mailfrom; client-ip=27.20.61.124;
 helo=qby.com; envelope-from=gxiam@qby.com; receiver=linux-nvdimm@lists.01.org 
Received: from qby.com (unknown [27.20.61.124])
 by ml01.01.org (Postfix) with ESMTP id D28DA21962301
 for <linux-nvdimm@lists.01.org>; Mon, 16 Sep 2019 19:41:35 -0700 (PDT)
Message-ID: <DCA0AB78668BC3FFA23776CAAE283B3A@qby.com>
From: =?utf-8?B?5oKo5aW977ya?= <gxiam@qby.com>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?ICAg5YGaIOmHhyDotK3lv4Xpobvkuobop6PnmoQxNOWkp+S+m+W6lOW4guWcug==?=
 =?utf-8?B?5L+h5oGv?=
Date: Tue, 17 Sep 2019 10:41:57 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
X-Content-Filtered-By: Mailman/MimeDel 2.1.29
X-BeenThere: linux-nvdimm@lists.01.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

MTgxNDYxODUxNDYNCi0tLS0tLS0tIOi9rOWPkemCruS7tuS/oeaBryAtLS0tLS0tLQ0K5Y+RIOS7
tiDkurrvvJpneGlhbUBxYnkuY29tDQrlj5Eg6YCBIOaXpSDmnJ/vvJoyMDE5LTktMTcxMDo0Mjow
OQ0K5pS2IOS7tiDkurrvvJpsaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxp
c3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFu
L2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
