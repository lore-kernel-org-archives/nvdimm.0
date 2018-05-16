Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 44232203B85AA
 for <linux-nvdimm@lists.01.org>; Tue, 15 May 2018 19:42:38 -0700 (PDT)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id F0346AC00D8
 for <linux-nvdimm@lists.01.org>; Wed, 16 May 2018 11:42:33 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [PATCH v6 1/4] ndctl, util: add OPTION_FILENAME to parse_opt_type
Date: Wed, 16 May 2018 02:42:31 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222766C70A@g01jpexmbkw01>
References: <20180507050926.17243-1-qi.fuli@jp.fujitsu.com>
 <20180507050926.17243-2-qi.fuli@jp.fujitsu.com>
 <CAPcyv4hcq4jbsP=tSHJ2NqDVAFepmT0UQj-xJVt3KjauHw3ZVA@mail.gmail.com>
In-Reply-To: <CAPcyv4hcq4jbsP=tSHJ2NqDVAFepmT0UQj-xJVt3KjauHw3ZVA@mail.gmail.com>
Content-Language: ja-JP
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: 'Dan Williams' <dan.j.williams@intel.com>, "'vishal.l.verma@intel.com'" <vishal.l.verma@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYW4gV2lsbGlhbXMgW21haWx0
bzpkYW4uai53aWxsaWFtc0BpbnRlbC5jb21dDQo+IFNlbnQ6IFNhdHVyZGF5LCBNYXkgMTIsIDIw
MTggMTo0MiBBTQ0KPiBUbzogUWksIEZ1bGkv5paJIOemj+WIqSA8cWkuZnVsaUBqcC5mdWppdHN1
LmNvbT4NCj4gQ2M6IGxpbnV4LW52ZGltbSA8bGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZz4NCj4g
U3ViamVjdDogUmU6IFtQQVRDSCB2NiAxLzRdIG5kY3RsLCB1dGlsOiBhZGQgT1BUSU9OX0ZJTEVO
QU1FIHRvIHBhcnNlX29wdF90eXBlDQo+IA0KPiBPbiBTdW4sIE1heSA2LCAyMDE4IGF0IDEwOjA5
IFBNLCBRSSBGdWxpIDxxaS5mdWxpQGpwLmZ1aml0c3UuY29tPiB3cm90ZToNCj4gPiBUaGlzIHBh
dGNoIGJvcnJvd3MgdGhlIE9QVElPTl9GSUxFTkFNRSBmcm9tIGdpdCB0byBuZGN0bCB0byBtYWtl
IHN1cmUNCj4gPiBmaWxlbmFtZSBpcyBjb3JyZWN0LiBTb21lIHJlbGF0ZWQgcmVmYWN0b3Jpbmcg
aXMgYWxzbyBpbmNsdWRlZDoNCj4gPiAgIC0gYWRkcyBwYXJzZV9vcHRpb25zX3ByZWZpeCgpIGlu
dGVyZmFjZQ0KPiA+ICAgLSBtb3ZlcyBpc19hYnNvbHV0ZSBmcm9tIHV0aWwvaGVscC5jIHRvIHV0
aWwvdXRpbC5jDQo+ID4gICAtIGFkZHMgYSBuZXcgZmlsZSB1dGlsL2Fic3BhdGguYw0KPiA+DQo+
ID4gU2lnbmVkLW9mZi1ieTogUUkgRnVsaSA8cWkuZnVsaUBqcC5mdWppdHN1LmNvbT4NCj4gDQo+
IFJldmlld2VkLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4g
DQpTaW5jZSB0aGlzIHBhdGNoIGlzIGluZGVwZW5kZW50IGZyb20gdGhlIG90aGVycywgY291bGQg
eW91IHBsZWFzZSBtZXJnZSB0aGlzIG9uZSBmaXJzdD8NCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgt
bnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZv
L2xpbnV4LW52ZGltbQo=
