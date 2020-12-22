Return-Path: <SRS0=AX0L=F2=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD4BC433E0
	for <linux-nvdimm@archiver.kernel.org>; Tue, 22 Dec 2020 11:27:33 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3479522A83
	for <linux-nvdimm@archiver.kernel.org>; Tue, 22 Dec 2020 11:27:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3479522A83
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ml01.01.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 9BE9C100EBB7B;
	Tue, 22 Dec 2020 03:27:32 -0800 (PST)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=156.247.12.180; helo=vpass.ne.jp; envelope-from=vlt@vpass.ne.jp; receiver=<UNKNOWN> 
Received: from vpass.ne.jp (unknown [156.247.12.180])
	by ml01.01.org (Postfix) with ESMTP id 9362F100EBB6C
	for <linux-nvdimm@lists.01.org>; Tue, 22 Dec 2020 03:27:30 -0800 (PST)
Sender: vlt@vpass.ne.jp
From: =?utf-8?B?5LiJ5LqV5L2P5Y+L44Kr44O844OJ?= <vpass.ne.jp@ml01.01.org>
To: linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?77yc6YeN6KaB77ye44CQ5LiJ5LqV5L2P5Y+L44Kr44O844OJ44CR44GU5Yip55So56K66KqN44Gu44GK?=
	=?utf-8?B?6aGY44GE?=
Date: Tue, 22 Dec 2020 19:27:23 +0800
Message-ID: <0099bfb1e903$7332acd4$a233654f$@vpass.ne.jp>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Message-ID-Hash: X23UP56DEBA5GO3N7JDWXZWDEB4OECZA
X-Message-ID-Hash: X23UP56DEBA5GO3N7JDWXZWDEB4OECZA
X-MailFrom: vlt@vpass.ne.jp
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/X23UP56DEBA5GO3N7JDWXZWDEB4OECZA/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

IA0KDQogDQogDQoNCiANCg0KIA0KIA0KDQogDQoNCiANCg0KDQrmnKzjgYTjgaTjgoLlvIrnpL7j
gqvjg7zjg4njgpLjgZTliKnnlKjjgYTjgZ/jgaDjgY3jgYLjgorjgYzjgajjgYbjgZTjgZbjgYTj
gb7jgZnjgIINCg0K5pio5LuK44Gu56ys5LiJ6ICF5LiN5q2j5Yip55So44Gu5oCl5aKX44Gr5Ly0
44GE44CB5byK56S+44Gn44Gv44CM5LiN5q2j5Yip55So55uj6KaW44K344K544OG44Og44CN44KS
5bCO5YWl44GX44CBMjTmmYLplpMzNjXml6XkvZPliLbjgafjgqvjg7zjg4njga7jgZTliKnnlKjj
gavlr77jgZnjgovjg6Ljg4vjgr/jg6rjg7PjgrDjgpLooYzjgaPjgabjgYrjgorjgb7jgZnjgIIN
Cg0K44GT44Gu44Gf44Gz44CB44GU5pys5Lq65qeY44Gu44GU5Yip55So44GL44Gp44GG44GL44KS
56K66KqN44GV44Gb44Gm44GE44Gf44Gg44GN44Gf44GE44GK5Y+W5byV44GM44GC44KK44G+44GX
44Gf44Gu44Gn44CB6Kqg44Gr5Yud5omL44Gq44GM44KJ44CB44Kr44O844OJ44Gu44GU5Yip55So
44KS5LiA6YOo5Yi26ZmQ44GV44Gb44Gm44GE44Gf44Gg44GN44CB44GU6YCj57Wh44GV44Gb44Gm
44GE44Gf44Gg44GN44G+44GX44Gf44CCDQoNCuOBpOOBjeOBvuOBl+OBpuOBr+OAgeS7peS4i+OB
uOOCouOCr+OCu+OCueOBruS4iuOAgeOCq+ODvOODieOBruOBlOWIqeeUqOeiuuiqjeOBq+OBlOWN
lOWKm+OCkuOBiumhmOOBhOiHtOOBl+OBvuOBmeOAgg0K44GU5Zue562U44KS44GE44Gf44Gg44GR
44Gq44GE5aC05ZCI44CB44Kr44O844OJ44Gu44GU5Yip55So5Yi26ZmQ44GM57aZ57aa44GV44KM
44KL44GT44Go44KC44GU44GW44GE44G+44GZ44Gu44Gn44CB5LqI44KB44GU5LqG5om/5LiL44GV
44GE44CCDQoNCuKUgeKUgeKUgeKUgeKUgeKUgeKUgeKWoCDjgZTliKnnlKjnorroqo3jga/jgZPj
gaHjgonilIHilIHilIHilIHilIHilIHilIFodHRwOi8vd3d3LnNtYmMtY2FyZC1qcC5jbG91ZOKU
geKUgeKUgeKUgeKUgeKUgeKUgeKWoCDms6jmhI/kuovpoIXilIHilIHilIHilIHilIHilIHilIHi
gLvjgqvjg7zjg4njga7lgIvkurrmg4XloLHjgavjgojjgaPjgabjga/pm7voqbHjgafpgKPntaHj
gZnjgovloLTlkIjjgoLjgZTjgZbjgYTjgb7jgZnjgILigLvmraPnorrjgarmg4XloLHjga/lv4Xj
gZroqJjlhaXjgZfjgabjgY/jgaDjgZXjgYTjgILilIHilIHilIHilIHilIHilIHilIHilqDnmbro
oYzogIXilIHilIHilIHilIHilIHilIHilIENCuS4ieS6leS9j+WPi+OCq+ODvOODieagquW8j+S8
muekvg0K44CAaHR0cDovL3NtYmMtY2FyZC5jb20NCuOAkjEwNS04MDExIOadseS6rOmDvea4r+WM
uua1t+WyuDHkuIHnm64y55WqMjDlj7cg5rGQ55WZ44OT44Or44OH44Kj44Oz44KwDQoNCg0KIA0K
Q29weXJpZ2h0IMKpIFN1bWl0b21vIE1pdHN1aSBCYW5raW5nIENvcnBvcmF0aW9uLkFsbCBSaWdo
dHMgUmVzZXJ2ZWQuDQogDQoNCg0KDQoNCiANCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QgLS0gbGludXgtbnZk
aW1tQGxpc3RzLjAxLm9yZwpUbyB1bnN1YnNjcmliZSBzZW5kIGFuIGVtYWlsIHRvIGxpbnV4LW52
ZGltbS1sZWF2ZUBsaXN0cy4wMS5vcmcK
