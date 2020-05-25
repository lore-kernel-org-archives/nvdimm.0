Return-Path: <SRS0=DAtX=7H=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A832C433E0
	for <linux-nvdimm@archiver.kernel.org>; Mon, 25 May 2020 11:30:30 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 24DBF2078B
	for <linux-nvdimm@archiver.kernel.org>; Mon, 25 May 2020 11:30:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hwt9IINn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24DBF2078B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 91DC2121EA1BE;
	Mon, 25 May 2020 04:26:32 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2607:7c80:54:e::133; helo=bombadil.infradead.org; envelope-from=batv+ab9bb8b38cf50d3a9241+6119+infradead.org+hch@bombadil.srs.infradead.org; receiver=<UNKNOWN> 
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 9D068121EA1BA
	for <linux-nvdimm@lists.01.org>; Mon, 25 May 2020 04:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=UF+mJ0+Cs0Lv3KwU8N/ssVHfdhiaXBBwzKToK1lfStc=; b=hwt9IINn+c7e0TQ5Vb7r4OAtsU
	QAlEQo2N7mTXfUby/97+fvfgsSnerxieE5v2HBe+1xqKCNsTHi8/0yMU6L/9Mj2LC3OshM6eRlbsB
	dlstA2Wlfh5mzl8WV5AxDHFVu9q0SXtqDbXBOvlZXPo1pQUssuScT3hL9mgbXLsR4lM8nM5NVFez0
	vSYqjmxcyRZjwKCdkoxDRM3FslVaTFpg9hgJpqGJkaoOveydcJNCxVcJC1PAXB4KI0ZrAAYjPcKUM
	e/Z4IIK/4EvJZOohJQm6sV/1dERY0rxhq9t1hkeGFLR2kYD1LoXorhdJXBCv65YuXq+xsm1YyTdQQ
	OkDNcpQQ==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1jdBJB-0002Mu-BA; Mon, 25 May 2020 11:30:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Subject: block I/O accounting improvements
Date: Mon, 25 May 2020 13:29:58 +0200
Message-Id: <20200525113014.345997-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Message-ID-Hash: 22KV6GJP4VAOG3RXLPQQ3H425DM3BSMQ
X-Message-ID-Hash: 22KV6GJP4VAOG3RXLPQQ3H425DM3BSMQ
X-MailFrom: BATV+ab9bb8b38cf50d3a9241+6119+infradead.org+hch@bombadil.srs.infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/22KV6GJP4VAOG3RXLPQQ3H425DM3BSMQ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Jens,

they series contains various improvement for block I/O accounting.  The
first bunch of patches switch the bio based drivers to better accounting
helpers compared to the current mess.  The end contains a fix and various
performanc improvements.  Most of this comes from a series Konstantin
sent a few weeks ago, rebased on changes that landed in your tree since
and my change to always use the percpu version of the disk stats.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
