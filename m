Return-Path: <SRS0=et3t=EU=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.3 required=3.0 tests=BAYES_95,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D36C5519F
	for <linux-nvdimm@archiver.kernel.org>; Sat, 14 Nov 2020 18:05:36 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 40A7622254
	for <linux-nvdimm@archiver.kernel.org>; Sat, 14 Nov 2020 18:05:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40A7622254
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lonasign.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id EAAA7100EF255;
	Sat, 14 Nov 2020 10:05:34 -0800 (PST)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=137.135.72.67; helo=smtp1722017.edmapp5.xyz; envelope-from=sent64627@spread5engine1.com; receiver=<UNKNOWN> 
Received: from smtp1722017.edmapp5.xyz (smtp1722017.edmapp5.xyz [137.135.72.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 29D13100EF251
	for <linux-nvdimm@lists.01.org>; Sat, 14 Nov 2020 10:05:31 -0800 (PST)
Received: from WIN-C7GO3PG7NLH (unknown [103.95.56.255])
	by smtp1722017.edmapp5.xyz (Postfix) with ESMTPA id 9272984664
	for <linux-nvdimm@lists.01.org>; Sun, 15 Nov 2020 02:05:29 +0800 (HKT)
From: "Eason" <lona@lonasign.com> 
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Date: Sun, 15 Nov 2020 02:05:27 +0800
Subject: Scarf for man
MIME-Version: 1.0
X-Mailer: aspNetEmail ver 3.7.0.19
X-Spread-CampaignId: 473759
X-Spread-SubscriberId: 114799120
X-Spread-SpreaderId: 64627
X-Spread-Engine-Build: 4.0.7172.26848
Message-ID: <WIN-C7GO3PG7NLH9ac40288beb245389f3f6ef6e6aa9542@WIN-C7GO3PG7NLH>
Message-ID-Hash: WWXL2NEXTFF6TRSLO6FY2IKIFXHDKVQA
X-Message-ID-Hash: WWXL2NEXTFF6TRSLO6FY2IKIFXHDKVQA
X-MailFrom: sent64627@spread5engine1.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/WWXL2NEXTFF6TRSLO6FY2IKIFXHDKVQA/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: multipart/mixed; boundary="===============5379142753857357540=="

--===============5379142753857357540==
Content-Type: multipart/alternative;
	boundary="_=aspNetEmail=_39db9972527a4876850d198355b44e3d"

--_=aspNetEmail=_39db9972527a4876850d198355b44e3d

--_=aspNetEmail=_39db9972527a4876850d198355b44e3d--

--===============5379142753857357540==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

--===============5379142753857357540==--
