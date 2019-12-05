Return-Path: <SRS0=dklJ=Z3=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.5 required=3.0 tests=CHARSET_FARAWAY_HEADER,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5BB9C43603
	for <linux-nvdimm@archiver.kernel.org>; Thu,  5 Dec 2019 23:58:21 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 63A4E2173E
	for <linux-nvdimm@archiver.kernel.org>; Thu,  5 Dec 2019 23:58:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63A4E2173E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zyaport.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 75FB010113508;
	Thu,  5 Dec 2019 16:01:43 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=122.225.234.46; helo=mail.zyanw.com; envelope-from=linyong@zyaport.com; receiver=<UNKNOWN> 
Received: from mail.zyanw.com (unknown [122.225.234.46])
	by ml01.01.org (Postfix) with ESMTP id 718741011330D
	for <linux-nvdimm@lists.01.org>; Thu,  5 Dec 2019 16:01:40 -0800 (PST)
Received: from wqihqpkgd (122.225.234.46) by mail.zyanw.com (10.1.0.101) with
 Microsoft SMTP Server id 8.2.176.0; Fri, 6 Dec 2019 07:58:14 +0800
Message-ID: <6194B9461D470C7258F0B6A13D386327@wqihqpkgd>
From: ndgpionql <linyong@zyaport.com>
To: <linux-nvdimm@lists.01.org>, <info@visahouse.net>,
	<elijah.njoroge@starcafe.co.ug>, <saler18@mark-ic.com>, <wxd@wxdgg.com>,
	<sales@offset.com.cn>, <kjtjaden@sktc.net>, <xuqiang@hgmri.com>,
	<kekuopin@yangming.com>, <akelly@usd239.org>, <info.cncan.tgf@tollgroup.com>,
	<rhogan@sabresys.com>, <scms@scmsgroup.com>, <wenyl@szemi.cn>,
	<wardl@ada.org>, <scott@ventures.com>, <yongci99@hoil.com>,
	<liblicense-l@lists.yale.edu>, <willis@kw.com>, <info@etop-light.com>,
	<hr@eastyida.com>
Subject: =?gb2312?B?zeLOp8TbxKPLvcXEz7XB0LyrxrfD58z1zfi67MPAxa7S+dPv19TOvw==?=
	=?gb2312?B?19TM8sPAxa7E/svAsrvH/LrzwLSxu8TQtcTKub6i08PBprGsstm5+g==?=
	=?gb2312?B?0+8=?=
Date: Fri, 6 Dec 2019 07:56:04 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: ZSAAVALJMOLDEJIM6X34ZDPTDUJGJCGN
X-Message-ID-Hash: ZSAAVALJMOLDEJIM6X34ZDPTDUJGJCGN
X-MailFrom: linyong@zyaport.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/ZSAAVALJMOLDEJIM6X34ZDPTDUJGJCGN/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: multipart/mixed; boundary="===============7135610347050851759=="

--===============7135610347050851759==
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: base64

PCFET0NUWVBFIEhUTUwgUFVCTElDICItLy9XM0MvL0RURCBIVE1MIDQuMCBUcmFuc2l0aW9uYWwv
L0VOIj4NCjxIVE1MPjxIRUFEPg0KPE1FVEEgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PWdi
MjMxMiIgaHR0cC1lcXVpdj1Db250ZW50LVR5cGU+DQo8TUVUQSBuYW1lPUdFTkVSQVRPUiBjb250
ZW50PSJNU0hUTUwgMTAuMDAuOTIwMC4xNzU1NiI+PC9IRUFEPg0KPEJPRFk+DQo8UD48QSBocmVm
PSJodHRwOi8vaGFkMjAxNS5jb20vIj5odHRwOi8vaGFkMjAxNS5jb20vPC9BPjwvUD4NCjxQPiZu
YnNwOzwvUD4NCjxQPs3izqfE28Sjy73FxM+1wdC8q8a3w+fM9c34uuzDwMWu0vnT79fUzr/X1Mzy
Jm5ic3A7IDwvUD4NCjxQPsPAxa7E/svAsrvH/LrzwLSxu8TQtcTKub6i08PBprGsstm5+tPvPC9Q
PjwvQk9EWT48L0hUTUw+DQo=


--===============7135610347050851759==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

--===============7135610347050851759==--
