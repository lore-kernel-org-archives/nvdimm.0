Return-Path: <SRS0=TDng=ET=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58595C2D0E4
	for <linux-nvdimm@archiver.kernel.org>; Fri, 13 Nov 2020 01:45:59 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 982E9216C4
	for <linux-nvdimm@archiver.kernel.org>; Fri, 13 Nov 2020 01:45:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=sysevienmarus.info header.i=info@sysevienmarus.info header.b="eT/qAnYG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 982E9216C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sysevienmarus.info
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 03AE4100EC1FB;
	Thu, 12 Nov 2020 17:45:58 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=51.68.149.168; helo=ceo8.sysevienmarus.info; envelope-from=info-linux+2dnvdimm=lists.01.org@sysevienmarus.info; receiver=<UNKNOWN> 
Received: from ceo8.sysevienmarus.info (ip168.ip-51-68-149.eu [51.68.149.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 7148F100EC1F7
	for <linux-nvdimm@lists.01.org>; Thu, 12 Nov 2020 17:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; s=default; d=sysevienmarus.info;
 h=Message-ID:Date:Subject:From:Reply-To:To:MIME-Version:Content-Type:List-Unsubscribe:List-Id; i=info@sysevienmarus.info;
 bh=haIX8TuyGEeFrMEmrA6mgSkreSs=;
 b=eT/qAnYGhQB9kKdaN0qoUtrCh1E+Vt5C6Ku3UY4akurbmPP/L4WV7MNJxQkXDgQBY6d8xEkDMoWJ
   ZNNIhZLbJ4w1OmB0uTGiWO89UC3SQw1PXhRp8yOKmvVex0ErB15TmfIKZdtm4KY/wq6CSlY1XarM
   f/1xMx/boXY8je1fJinBf83ZR84/Fb8U/o/MwF1pR+xETUiF/H9aJpycSlcIBCcP/522E74t+Jlf
   KEpl0NgrE4pcAwc/3E+vyn5trFxef1ElecO3VoI/oFcnfq9/sf/P6m2IC20F75QZ4d6NrP8neSru
   sCaaq1VPwvjjGVp4FoRQoHBCi25sZBw+TMajwQ==
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns; s=default; d=sysevienmarus.info;
 b=iriTu7CO6lljwnr/dgNkvheUbZB/+eNaT7AN/ntaObPlxWmMKIYe1faOoI+HO/8mmd5xkba1cMCH
   VpPtLkONGyJGLVCNevTkVxQwNBHMSjnTTbrt/yfyMyNtoqnzU2U7xZ7wPqd1S593doXosc9mW+LC
   yo6Q1t1iWL/L3/Jb5dUUssgeqQX//ECg7EoKXOkpKY40kASZFQtm02g2dg+HvhjYhiPfce80aRCA
   5h2F4zxX2kVnjzcR1kXHnk887Fg51Sr1172iDUAQw9bj0WjjSE8xEVL8VTzbK3aXjQohKHBLvakN
   nPtufexl2Eh89lKIKdQ1w0cenWFMNl0lofacNA==;
Received: from sysevienmarus.info (127.0.0.1) by ceo1.sysevienmarus.info id hlnil3i19tk4 for <linux-nvdimm@lists.01.org>; Fri, 13 Nov 2020 01:45:50 +0000 (envelope-from <info-linux+2Dnvdimm=lists.01.org@sysevienmarus.info>)
Message-ID: <b3b4ed09c7f7164529eb7ed42f02df97@sysevienmarus.info>
Date: Fri, 13 Nov 2020 01:45:50 +0000
Subject: RE: 10K LinkedIn Leads from your Target Audience at 500
From: Sara Miller <info@sysevienmarus.info>
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
MIME-Version: 1.0
X-Sender: info@sysevienmarus.info
X-Report-Abuse: Please report abuse for this campaign here:
 https://sysevienmarus.info/latest/index.php/campaigns/te858ltbyv792/report-abuse/eq656zn50v319/fh72061rdzd55
X-Receiver: linux-nvdimm@lists.01.org
X-Dggs-Tracking-Did: 0
X-Dggs-Subscriber-Uid: fh72061rdzd55
X-Dggs-Mailer: SwiftMailer - 5.4.x
X-Dggs-EBS: https://sysevienmarus.info/latest/index.php/lists/block-address
X-Dggs-Delivery-Sid: 1
X-Dggs-Customer-Uid: dl4746dylhbde
X-Dggs-Customer-Gid: 0
X-Dggs-Campaign-Uid: te858ltbyv792
Precedence: bulk
Feedback-ID: te858ltbyv792:fh72061rdzd55:eq656zn50v319:dl4746dylhbde
Message-ID-Hash: 4V3VSUPYZLTLA2445PW5IY6HW6CE4Q5Z
X-Message-ID-Hash: 4V3VSUPYZLTLA2445PW5IY6HW6CE4Q5Z
X-MailFrom: info-linux+2Dnvdimm=lists.01.org@sysevienmarus.info
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Reply-To: Sara Miller <sara@b2bcedmevent.info>
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/4V3VSUPYZLTLA2445PW5IY6HW6CE4Q5Z/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

QXJlIHlvdSBpbnRlcmVzdGVkIHRvIHB1cmNoYXNlIDEwMCUgYWNjdXJhdGUgMTAsMDAwIFRhcmdl
dGVkIExlYWRzDQpmcm9tIExpbmtlZEluIGF0ICQ1MDAoQW55IHRpdGxlcy9pbmR1c3RyeS9sb2Nh
dGlvbi9rZXl3b3Jkcyk/DQpJZiB5b3UgaGF2ZSBhIHZlcnkgdGFyZ2V0ZWQgZGF0YSByZXF1aXJl
bWVudCBhbmQgeW91IG5lZWQgTGlua2VkSW4NCmRhdGFiYXNlLCB3ZSB3aWxsIHB1bGwgdGFyZ2V0
ZWQgZGF0YWJhc2VzIGZvciB5b3Ugd2l0aCB0aGVpciBMaW5rZWRJbg0KcHJvZmlsZSBsaW5rLCBu
YW1lLCB0aXRsZSwgZW1haWwgYWRkcmVzcywgY29tcGFueSBuYW1lLCBjaXR5LCBjb21wYW55DQpz
aXplIGV0Yy4gUGxlYXNlIHNoYXJlIHlvdXIgdGFyZ2V0IGF1ZGllbmNlIGFuZCBJIHdpbGwgc3Vw
cGx5IHRoZQ0Kc2FtcGxlIHdpdGhpbiAxIGJ1c2luZXNzIGRheXPigJkgdGltZS4NClRoYW5rcyBh
bmQgbGV0IG1lIGtub3cuDQpTYXJhIE1pbGxlcg0KTGlua2VkSW4gRGF0YWJhc2UgUHJvdmlkZXIN
CisxLSg2NzgpIDc0NS04Mzg1DQpVbnN1YnNjcmliZQ0KaHR0cHM6Ly9zeXNldmllbm1hcnVzLmlu
Zm8vbGF0ZXN0L2luZGV4LnBocC9saXN0cy9lcTY1NnpuNTB2MzE5L3Vuc3Vic2NyaWJlL2ZoNzIw
NjFyZHpkNTUvdGU4NThsdGJ5djc5Mg0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdCAtLSBsaW51eC1udmRpbW1A
bGlzdHMuMDEub3JnClRvIHVuc3Vic2NyaWJlIHNlbmQgYW4gZW1haWwgdG8gbGludXgtbnZkaW1t
LWxlYXZlQGxpc3RzLjAxLm9yZwo=
