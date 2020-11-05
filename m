Return-Path: <SRS0=r3pH=EL=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83FBDC4742C
	for <linux-nvdimm@archiver.kernel.org>; Thu,  5 Nov 2020 08:32:02 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DACD820729
	for <linux-nvdimm@archiver.kernel.org>; Thu,  5 Nov 2020 08:32:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fullbizgoal.com header.i=@fullbizgoal.com header.b="z86tqx0x"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DACD820729
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=fullbizgoal.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id ECB68166C6143;
	Thu,  5 Nov 2020 00:32:00 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=80.211.27.207; helo=server1.mail.fullbizgoal.com; envelope-from=ethan.smith@fullbizgoal.com; receiver=<UNKNOWN> 
Received: from server1.mail.fullbizgoal.com (mail.fullbizgoal.com [80.211.27.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 12B98166C6140
	for <linux-nvdimm@lists.01.org>; Thu,  5 Nov 2020 00:31:57 -0800 (PST)
Received: by server1.mail.fullbizgoal.com (Postfix, from userid 1001)
	id 6F309A5322; Thu,  5 Nov 2020 08:30:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fullbizgoal.com;
	s=mail; t=1604565115;
	bh=1A+RQztZunBjkjQlXgr2uQY18vlGaIq8j7jGOmWqiI0=;
	h=Date:From:To:Subject:From;
	b=z86tqx0xopwtsCSkI7qTOCb0Ja+Q3BAuOiLe1xd+NBQmvVuHVEKHMRyQ+9D5SMhMb
	 iVB2OBR+zsBkF9fGxzHXiPpiMjN2lIIOFimldb6TRfBWAg2xtLggYk1by+akAYpHuN
	 S8vHm7oQ7TKWXYOknIF1oLGmdH1Pw1C01T5WB071Sihzdn6EyHTk6jNOUhaTlgf+ha
	 9J/sA3doeiBINjiP56ADUHAVAWAE3aW2ILR6w774Jh478sS9kxmai9xjfUVf51cC4n
	 prQzBTwD5vL16i+S7TsrX7fadSyJz90GWeyDb1wiXjIJ0vP+nxW4BpD3uRYPPJHYlV
	 fh40/9/0Ol8iw==
Received: by mail.fullbizgoal.com for <linux-nvdimm@lists.01.org>; Thu,  5 Nov 2020 08:30:14 GMT
Message-ID: <20201105074501-0.1.2o.ezus.0.8nbs6nl4n6@fullbizgoal.com>
Date: Thu,  5 Nov 2020 08:30:14 GMT
From: "Ethan Smith" <ethan.smith@fullbizgoal.com>
To: <linux-nvdimm@lists.01.org>
Subject: Disinfectant
X-Mailer: mail.fullbizgoal.com
MIME-Version: 1.0
Message-ID-Hash: I5BQNA4VTOCXXWPTHTN7ICOZ2PXRTE47
X-Message-ID-Hash: I5BQNA4VTOCXXWPTHTN7ICOZ2PXRTE47
X-MailFrom: ethan.smith@fullbizgoal.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/I5BQNA4VTOCXXWPTHTN7ICOZ2PXRTE47/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Good morning,

looking for companies interested in raising additional capital by diversifying their offer in soaps, liquids and gels for hand disinfection and cosmetics for body and hair care.

The distribution of innovative products corresponding to the current preferences of customers in the field of hygiene and preventive healthcare allows our partners to gain new markets and achieve better economic results.

In addition to products with bactericidal action, our range includes shower gels, shampoos and hair conditioners, as well as efficient, concentrated detergents.

The versatility (suitable for all skin types) combined with an affordable price means that customers make an informed choice of a product among others available on the market.

Are you interested in cooperation?

Ethan Smith
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
