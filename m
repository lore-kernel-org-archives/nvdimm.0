Return-Path: <SRS0=JqCw=64=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=DKIM_ADSP_DISCARD,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA4DC433E0
	for <linux-nvdimm@archiver.kernel.org>; Thu, 14 May 2020 13:36:36 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A7C7420727
	for <linux-nvdimm@archiver.kernel.org>; Thu, 14 May 2020 13:36:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7C7420727
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=fedex.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 2485710097593;
	Thu, 14 May 2020 06:33:52 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=190.61.42.178; helo=178.42.61.190.ufinet.com.co; envelope-from=foregoingsa0@prh22036.prod.fedex.com; receiver=<UNKNOWN> 
Received: from 178.42.61.190.ufinet.com.co (unknown [190.61.42.178])
	by ml01.01.org (Postfix) with ESMTP id 0DE5710097590
	for <linux-nvdimm@lists.01.org>; Thu, 14 May 2020 06:33:46 -0700 (PDT)
Received: from  (
 [95.54.75.15])        by 178.42.61.190.ufinet.com.co with SMTP id
 ow8nyaYMlLDte.976; Thu, 14 May 2020 08:36:31 -0500
Subject: FedEx Shipment 629519013765: Delivered
From: trackingemail@fedex.com
To: linux-nvdimm@lists.01.org
MIME-Version: 1.0
Message-ID: <002136.152481@meiyvawlcfdhruv.lpwmdqs.be>
X-Priority: 3
Date: Thu, 14 May 2020 08:36:31 -0500
Message-ID-Hash: V4VOQA2NX3JJM3WZMEGAA755XUMRYHSC
X-Message-ID-Hash: V4VOQA2NX3JJM3WZMEGAA755XUMRYHSC
X-MailFrom: foregoingsa0@prh22036.prod.fedex.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
Content-Disposition: inline
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/V4VOQA2NX3JJM3WZMEGAA755XUMRYHSC/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Your package has been delivered

 	Shipment Facts
	
	Our records indicate that the following package has been delivered.

Special handling/Services:
	Direct Signature Required

Please do not respond to this message. This email was sent from an unattended mailbox. This report was generated at approximately 05/14/2020.
		
	All weights are estimated.


(c) 2020 Federal Express Corporation. The content of this message is protected by copyright and trademark laws under U.S. and international law. Review our privacy policy. All rights reserved. 	
	
       Thank you for your business.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
