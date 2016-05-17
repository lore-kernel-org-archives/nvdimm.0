Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 93BCF1A1FEF
 for <linux-nvdimm@lists.01.org>; Tue, 17 May 2016 10:56:08 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 3/7] ext2: Avoid DAX zeroing to corrupt data
Date: Tue, 17 May 2016 17:56:02 +0000
Message-ID: <1463507749.29294.71.camel@intel.com>
References: <1462960733-29634-1-git-send-email-jack@suse.cz>
 <1462960733-29634-4-git-send-email-jack@suse.cz>
 <20160512184522.GA19851@linux.intel.com>
 <20160516152206.GC21714@quack2.suse.cz> <1463467967.3069.3.camel@intel.com>
 <20160517071950.GA31991@quack2.suse.cz>
In-Reply-To: <20160517071950.GA31991@quack2.suse.cz>
Content-Language: en-US
Content-ID: <D74D37CF48F4D745ABCC4847A668DBE0@intel.com>
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
To: "jack@suse.cz" <jack@suse.cz>
Cc: "tytso@mit.edu" <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE2LTA1LTE3IGF0IDA5OjE5ICswMjAwLCBKYW4gS2FyYSB3cm90ZToNCj4gT24g
VHVlIDE3LTA1LTE2IDA2OjUyOjQ3LCBWZXJtYSwgVmlzaGFsIEwgd3JvdGU6DQoNClsuLi5dDQoN
Cj4gPiANCj4gPiANCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyID0gZGF4
X2NsZWFyX3NlY3RvcnMoaW5vZGUtPmlfc2ItPnNfYmRldiwNCj4gPiAtwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBsZTMyX3RvX2Nw
dShjaGFpbltkZXB0aC0xXS5rZXkpIDw8DQo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKGlub2RlLT5pX2Jsa2JpdHMgLSA5
KSwNCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAxIDw8IGlub2RlLT5pX2Jsa2JpdHMpOw0KPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBlcnIgPSBzYl9pc3N1ZV96ZXJvb3V0KGlub2RlLT5pX3NiLA0KPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGxlMzJfdG9fY3B1KGNoYWluW2RlcHRoLTFdLmtleSksDQo+ID4gY291bnQsIEdGUF9O
T0ZTKTsNCj4gPiANCj4gPiBJZiBzbywgSSdsbCB1cGRhdGUgbXkgc2VyaWVzIHRvbW9ycm93IHRv
IGluY2x1ZGUgaW4gYm90aCBvZiB0aGVzZQ0KPiA+IGNoYW5nZXMuDQo+IEknZCBwcmVmZXIgdGhl
c2UgdHdvIHRvIHN0YXkgc2VwYXJhdGUgY29tbWl0cyAodGhleSBhcmUgcmVhbGx5DQo+IGluZGVw
ZW5kZW50KS7CoMKgU2luY2UgeW91IGFscmVhZHkgZGVwZW5kIG9uIG90aGVyIHBhdGNoZXMgZnJv
bSB0aGUgREFYDQo+IGNsZWFudXAgc2VyaWVzLCBqdXN0IGFkZCB0aGlzIHBhdGNoIHRvIHRoZSBs
aXN0IG9mIGRlcGVuZGVuY2llcyBhbmQNCj4gYmFzZQ0KPiB5b3VyIGNoYW5nZSBvbiB0aGF0Li4u
IEhtbT8NCg0KWWVzIEkgYWdyZWUuIEknbSBwcmVwYXJpbmcgYSBicmFuY2ggdGhhdCBhZGRzIHlv
dXIgZml4LCBhbmQgbW9kaWZ5aW5nIG15DQpzYl9pc3N1ZV96ZXJvb3V0IHRvIHVzZSB0aGUgc2Ft
ZSBmaXguIEkndmUgdmVyaWZpZWQgdGhhdCB0aG9zZSB0ZXN0cw0KcGFzcyBhZnRlciBib3RoIGNo
YW5nZXMuDQoNClRoYW5rcyENCgktVmlzaGFsDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGlt
bUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51
eC1udmRpbW0K
