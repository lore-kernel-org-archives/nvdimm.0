Return-Path: <SRS0=YGxs=6J=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0609FC55186
	for <linux-nvdimm@archiver.kernel.org>; Sat, 25 Apr 2020 11:32:22 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CD93A206EC
	for <linux-nvdimm@archiver.kernel.org>; Sat, 25 Apr 2020 11:32:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD93A206EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 99D0910106321;
	Sat, 25 Apr 2020 04:31:44 -0700 (PDT)
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A9E071010631A
	for <linux-nvdimm@lists.01.org>; Sat, 25 Apr 2020 04:31:42 -0700 (PDT)
MIME-Version: 1.0
Subject: Re: [PATCH v5 8/8] dax,
 iomap: Add helper dax_iomap_zero() to zero a range
From: neolift9@gmail.com
To: linux-nvdimm@lists.01.org
Date: Sat, 25 Apr 2020 11:31:42 -0000
Message-ID: <20200425113142.2763.82883@ml01.vlan13.01.org>
User-Agent: HyperKitty on https://lists.01.org/
References: <20200218214841.10076-9-vgoyal@redhat.com>
In-Reply-To: <20200218214841.10076-9-vgoyal@redhat.com>
Message-ID-Hash: NTQD3KCO3EPKF34RSXR7TEB3XEXJY62X
X-Message-ID-Hash: NTQD3KCO3EPKF34RSXR7TEB3XEXJY62X
X-MailFrom: neolift9@gmail.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/NTQD3KCO3EPKF34RSXR7TEB3XEXJY62X/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

We plan customized campaigns to meet your organizational requirements <a href="https://neolift.in/digital-marketing/seo/">seo services in pune</a> and campaign goals
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
