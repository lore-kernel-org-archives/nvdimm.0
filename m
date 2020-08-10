Return-Path: <SRS0=2RnD=BU=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC67C433E0
	for <linux-nvdimm@archiver.kernel.org>; Mon, 10 Aug 2020 21:10:56 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7436120716
	for <linux-nvdimm@archiver.kernel.org>; Mon, 10 Aug 2020 21:10:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7436120716
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id EC67E12ED9203;
	Mon, 10 Aug 2020 14:10:55 -0700 (PDT)
Received-SPF: Pass (helo) identity=helo; client-ip=211.29.132.53; helo=mail107.syd.optusnet.com.au; envelope-from=david@fromorbit.com; receiver=<UNKNOWN> 
Received: from mail107.syd.optusnet.com.au (mail107.syd.optusnet.com.au [211.29.132.53])
	by ml01.01.org (Postfix) with ESMTP id 1B2D712ED9201
	for <linux-nvdimm@lists.01.org>; Mon, 10 Aug 2020 14:10:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
	by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 924DAD5B48A;
	Tue, 11 Aug 2020 07:10:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1k5F49-0007Rd-HC; Tue, 11 Aug 2020 07:10:45 +1000
Date: Tue, 11 Aug 2020 07:10:45 +1000
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 0/8] fsdax: introduce FS query interface to support
 reflink
Message-ID: <20200810211045.GL2114@dread.disaster.area>
References: <20200807131336.318774-1-ruansy.fnst@cn.fujitsu.com>
 <20200807133857.GC17456@casper.infradead.org>
 <9673ed3c-9e42-3d01-000b-b01cda9832ce@cn.fujitsu.com>
 <20200810111657.GL17456@casper.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200810111657.GL17456@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
	a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
	a=IkcTkHD0fZMA:10 a=y4yBn9ojGxQA:10 a=7-415B0cAAAA:8
	a=_uXmcX_QWSfgQcGZoHUA:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Message-ID-Hash: MZ2G45ZL5MMF4TB5GAXVF5HRB6SW7CLE
X-Message-ID-Hash: MZ2G45ZL5MMF4TB5GAXVF5HRB6SW7CLE
X-MailFrom: david@fromorbit.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com, hch@lst.de, rgoldwyn@suse.de, qi.fuli@fujitsu.com, y-goto@fujitsu.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/MZ2G45ZL5MMF4TB5GAXVF5HRB6SW7CLE/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBBdWcgMTAsIDIwMjAgYXQgMTI6MTY6NTdQTSArMDEwMCwgTWF0dGhldyBXaWxjb3gg
d3JvdGU6DQo+IE9uIE1vbiwgQXVnIDEwLCAyMDIwIGF0IDA0OjE1OjUwUE0gKzA4MDAsIFJ1YW4g
U2hpeWFuZyB3cm90ZToNCj4gPiANCj4gPiANCj4gPiBPbiAyMDIwLzgvNyDkuIvljYg5OjM4LCBN
YXR0aGV3IFdpbGNveCB3cm90ZToNCj4gPiA+IE9uIEZyaSwgQXVnIDA3LCAyMDIwIGF0IDA5OjEz
OjI4UE0gKzA4MDAsIFNoaXlhbmcgUnVhbiB3cm90ZToNCj4gPiA+ID4gVGhpcyBwYXRjaHNldCBp
cyBhIHRyeSB0byByZXNvbHZlIHRoZSBwcm9ibGVtIG9mIHRyYWNraW5nIHNoYXJlZCBwYWdlDQo+
ID4gPiA+IGZvciBmc2RheC4NCj4gPiA+ID4gDQo+ID4gPiA+IEluc3RlYWQgb2YgcGVyLXBhZ2Ug
dHJhY2tpbmcgbWV0aG9kLCB0aGlzIHBhdGNoc2V0IGludHJvZHVjZXMgYSBxdWVyeQ0KPiA+ID4g
PiBpbnRlcmZhY2U6IGdldF9zaGFyZWRfZmlsZXMoKSwgd2hpY2ggaXMgaW1wbGVtZW50ZWQgYnkg
ZWFjaCBGUywgdG8NCj4gPiA+ID4gb2J0YWluIHRoZSBvd25lcnMgb2YgYSBzaGFyZWQgcGFnZS4g
IEl0IHJldHVybnMgYW4gb3duZXIgbGlzdCBvZiB0aGlzDQo+ID4gPiA+IHNoYXJlZCBwYWdlLiAg
VGhlbiwgdGhlIG1lbW9yeS1mYWlsdXJlKCkgaXRlcmF0ZXMgdGhlIGxpc3QgdG8gYmUgYWJsZQ0K
PiA+ID4gPiB0byBub3RpZnkgZWFjaCBwcm9jZXNzIHVzaW5nIGZpbGVzIHRoYXQgc2hhcmluZyB0
aGlzIHBhZ2UuDQo+ID4gPiA+IA0KPiA+ID4gPiBUaGUgZGVzaWduIG9mIHRoZSB0cmFja2luZyBt
ZXRob2QgaXMgYXMgZm9sbG93Og0KPiA+ID4gPiAxLiBkYXhfYXNzb2NhaXRlX2VudHJ5KCkgYXNz
b2NpYXRlcyB0aGUgb3duZXIncyBpbmZvIHRvIHRoaXMgcGFnZQ0KPiA+ID4gDQo+ID4gPiBJIHRo
aW5rIHRoYXQncyB0aGUgZmlyc3QgcHJvYmxlbSB3aXRoIHRoaXMgZGVzaWduLiAgZGF4X2Fzc29j
aWF0ZV9lbnRyeSBpcw0KPiA+ID4gYSBob3JyZW5kb3VzIGlkZWEgd2hpY2ggbmVlZHMgdG8gYmUg
cmlwcGVkIG91dCwgbm90IG1hZGUgbW9yZSBpbXBvcnRhbnQuDQo+ID4gPiBJdCdzIGFsbCBwYXJ0
IG9mIHRoZSBnZW5lcmFsIHByb2JsZW0gb2YgdHJ5aW5nIHRvIGRvIHNvbWV0aGluZyBvbiBhDQo+
ID4gPiBwZXItcGFnZSBiYXNpcyBpbnN0ZWFkIG9mIHBlci1leHRlbnQgYmFzaXMuDQo+ID4gPiAN
Cj4gPiANCj4gPiBUaGUgbWVtb3J5LWZhaWx1cmUgbmVlZHMgdG8gdHJhY2sgb3duZXJzIGluZm8g
ZnJvbSBhIGRheCBwYWdlLCBzbyBJIHNob3VsZA0KPiA+IGFzc29jaWF0ZSB0aGUgb3duZXIgd2l0
aCB0aGlzIHBhZ2UuICBJbiB0aGlzIHZlcnNpb24sIEkgYXNzb2NpYXRlIHRoZSBibG9jaw0KPiA+
IGRldmljZSB0byB0aGUgZGF4IHBhZ2UsIHNvIHRoYXQgdGhlIG1lbW9yeS1mYWlsdXJlIGlzIGFi
bGUgdG8gaXRlcmF0ZSB0aGUNCj4gPiBvd25lcnMgYnkgdGhlIHF1ZXJ5IGludGVyZmFjZSBwcm92
aWRlZCBieSBmaWxlc3lzdGVtLg0KPiANCj4gTm8sIGl0IGRvZXNuJ3QgbmVlZCB0byB0cmFjayBv
d25lciBpbmZvIGZyb20gYSBEQVggcGFnZS4gIFdoYXQgaXQgbmVlZHMgdG8NCj4gZG8gaXMgYXNr
IHRoZSBmaWxlc3lzdGVtLg0KDQpKdXN0IHRvIGFkZCB0byB0aGlzOiB0aGUgb3duZXIgdHJhY2tp
bmcgdGhhdCBpcyBjdXJyZW50IGRvbmUgZGVlcA0KaW5zaWRlIHRoZSBEQVggY29kZSBuZWVkcyB0
byBiZSBtb3ZlZCBvdXQgdG8gdGhlIG93bmVyIG9mIHRoZSBkYXgNCmRldmljZS4gVGhhdCBtYXkg
YmUgdGhlIGRheCBkZXZpY2UgaXRzZWxmLCBvciBpdCBtYXkgYmUgYSBmaWxlc3lzdGVtDQpsaWtl
IGV4dDQgb3IgWEZTLiBJbml0aWFsbHksIG5vdGhpbmcgd2lsbCBiZSBhYmxlIHRvIHNoYXJlIHBh
Z2VzIGFuZA0KcGFnZSBvd25lciB0cmFja2luZyBzaG91bGQgYmUgZG9uZSBvbiB0aGUgcGFnZSBp
dHNlbGYgYXMgdGhlIERBWA0KY29kZSBjdXJyZW50bHkgZG9lcy4NCg0KSGVuY2Ugd2hlbiBhIHBh
Z2UgZXJyb3Igb2NjdXJzLCB0aGUgZGV2aWNlIG93bmVyIGlzIGNhbGxlZCB3aXRoIHRoZQ0KcGFn
ZSBhbmQgZXJyb3IgaW5mb3JtYXRpb24sIGFuZCB0aGUgZGF4IGRldmljZSBvciBmaWxlc3lzdGVt
IGNhbg0KdGhlbiBsb29rIHVwIHRoZSBwYWdlIG93bmVyICh2aWEgbWFwcGluZy9pbmRleCBwb2lu
dGVycykgYW5kIHJ1biB0aGUNCkRpZSBVc2Vyc3BhY2UgRGllIGZ1bmN0aW9ucyBpbnN0ZWFkIG9m
IHJ1bm5pbmcgdGhpcyBhbGwgaW50ZXJuYWxseQ0KaW4gdGhlIERBWCBjb2RlLg0KDQpPbmNlIHRo
ZSBpbXBsZW1lbnRhdGlvbiBpcyBhYnN0cmFjdGVkIGFuZCBjb250cm9sbGVkIGJ5IHRoZSBkZXZp
Y2UNCm93bmVyLCB0aGVuIHdlIGNhbiBzdGFydCB3b3JraW5nIHRvIGNoYW5nZSB0aGUgWEZTIGlt
cGxlbWVudGF0aW9uIHRvDQpzdXBwb3J0IHNoYXJlZCBwYWdlcy4uLi4NCg0KQ2hlZXJzLA0KDQpE
YXZlLg0KLS0gDQpEYXZlIENoaW5uZXINCmRhdmlkQGZyb21vcmJpdC5jb20KX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcg
bGlzdCAtLSBsaW51eC1udmRpbW1AbGlzdHMuMDEub3JnClRvIHVuc3Vic2NyaWJlIHNlbmQgYW4g
ZW1haWwgdG8gbGludXgtbnZkaW1tLWxlYXZlQGxpc3RzLjAxLm9yZwo=
