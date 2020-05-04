Return-Path: <SRS0=kSDi=6S=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6257AC3A5A9
	for <linux-nvdimm@archiver.kernel.org>; Mon,  4 May 2020 06:39:31 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2955F20757
	for <linux-nvdimm@archiver.kernel.org>; Mon,  4 May 2020 06:39:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=vazkliza.ga header.i=manager@vazkliza.ga header.b="Jt3OqbOp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2955F20757
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=vazkliza.ga
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 3776F1150B89A;
	Sun,  3 May 2020 23:37:55 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=85.204.116.127; helo=slot0.vazkliza.ga; envelope-from=manager@vazkliza.ga; receiver=<UNKNOWN> 
Received: from slot0.vazkliza.ga (slot0.vazkliza.ga [85.204.116.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 7ECDF11472697
	for <linux-nvdimm@lists.01.org>; Sun,  3 May 2020 23:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; s=dkim; d=vazkliza.ga;
 h=Content-Type:MIME-Version:Subject:To:From:Date:Reply-To:Message-ID; i=manager@vazkliza.ga;
 bh=bPhOGqZm4IZEPsU+OFYsbyIOZdc=;
 b=Jt3OqbOpioWEsyUvzgCS1iRlMW8AZkQ043Y4UlicUO+z+IZYBZAksZ5C5TRw/XVdOnMe4zSEcDJi
   BKDggWYlPpNDTeXAzPsrK19DKiKDV4FBlWOVoB2qADS54usAAaQpnWTHEghMQ5ScaUZvMApMP98F
   Yyrk6zbRv2sdkBYnrUlCgr4KrY0t+JKDVs29QhbpYD36lRKOLcUjBuwSIqOB7Lk0Kg04EGSbRBCw
   h1W1i71qMriauV/azOXtLEGTcSkGu/026DmF7yuy95oq5LEWXXGqGs7iWUNhn5TaA+N5TGDW2eVX
   96uuds0injoix9yNsSvOyzIaxLn+HSfzHbc1uQ==
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns; s=dkim; d=vazkliza.ga;
 b=XanhxNiK+WvU9EBfcP8/45KMmpc9xR8bhI9mMaAoQ0720LV0MPrm1sLfs4XE0pynArtx8Qlvs4XB
   +ets6sw+4XJxyK5IknmwRL3q9Q2pCaJesPseERL/8SBf6rHLHOk1OBZYqXCoGcMnPmeN4SPrMyR4
   bksCT59z+6+HjkNfLfuVBPVKt9UDJHshBpGITS6jgxPRxMb3Yxn9OPvvneFA20eD7YeCwIXSylY+
   OB7RaMmXOAetXsAn0CUG42UCXWtF9wN9uXSCnDg1bwciHbuNonlWr7xvkGhUZ4bpIBnxNF9d2wDH
   AUTCDx2NThDVnZMltGt0QBmhl/wqXU07rsj7Bg==;
MIME-Version: 1.0
Subject: Full Proposal 
To: linux-nvdimm@lists.01.org
From: manager@vazkliza.ga
Date: Mon, 04 May 2020 09:39:23 +0300
Message-ID: <0.0.1.76A.1D621DEE79DA89A.0@slot0.vazkliza.ga>
Message-ID-Hash: Y7UTSWSF3G4JGE7D6LFFYAQHIQMXFCRY
X-Message-ID-Hash: Y7UTSWSF3G4JGE7D6LFFYAQHIQMXFCRY
X-MailFrom: manager@vazkliza.ga
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
Content-Description: Mail message body
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
Reply-To: bournetradinglimited@aol.com
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/Y7UTSWSF3G4JGE7D6LFFYAQHIQMXFCRY/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,
 I was wondering if you got a chance to review my previous email. 
Understandably, you must have been running a very busy schedule and could not connect earlier.
We are here to place our order kindly send us the available product with price tag and also confirm if the goods can be send earlier due to the current situation that is going on in the world.
 Best regards
 Bourne Lace
Phone:+1-202-555-0116
Office Address
14a Albany Road, Weymouth, Dorset, DT4 9TH
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
