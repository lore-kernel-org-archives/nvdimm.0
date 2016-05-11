Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 20E4B1A1EF0
 for <linux-nvdimm@lists.01.org>; Wed, 11 May 2016 10:47:04 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v6 4/5] dax: for truncate/hole-punch, do zeroing through
 the driver if possible
Date: Wed, 11 May 2016 17:47:00 +0000
Message-ID: <1462988808.29294.26.camel@intel.com>
References: <1462906156-22303-1-git-send-email-vishal.l.verma@intel.com>
 <1462906156-22303-5-git-send-email-vishal.l.verma@intel.com>
 <20160511081532.GB14744@quack2.suse.cz>
In-Reply-To: <20160511081532.GB14744@quack2.suse.cz>
Content-Language: en-US
Content-ID: <A1E995196763DE4E964EAE4A2FA3201C@intel.com>
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
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "axboe@fb.com" <axboe@fb.com>, "david@fromorbit.com" <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE2LTA1LTExIGF0IDEwOjE1ICswMjAwLCBKYW4gS2FyYSB3cm90ZToNCj4gT24g
VHVlIDEwLTA1LTE2IDEyOjQ5OjE1LCBWaXNoYWwgVmVybWEgd3JvdGU6DQo+ID4gDQo+ID4gSW4g
dGhlIHRydW5jYXRlIG9yIGhvbGUtcHVuY2ggcGF0aCBpbiBkYXgsIHdlIGNsZWFyIG91dCBzdWIt
cGFnZQ0KPiA+IHJhbmdlcy4NCj4gPiBJZiB0aGVzZSBzdWItcGFnZSByYW5nZXMgYXJlIHNlY3Rv
ciBhbGlnbmVkIGFuZCBzaXplZCwgd2UgY2FuIGRvIHRoZQ0KPiA+IHplcm9pbmcgdGhyb3VnaCB0
aGUgZHJpdmVyIGluc3RlYWQgc28gdGhhdCBlcnJvci1jbGVhcmluZyBpcyBoYW5kbGVkDQo+ID4g
YXV0b21hdGljYWxseS4NCj4gPiANCj4gPiBGb3Igc3ViLXNlY3RvciByYW5nZXMsIHdlIHN0aWxs
IGhhdmUgdG8gcmVseSBvbiBjbGVhcl9wbWVtIGFuZCBoYXZlDQo+ID4gdGhlDQo+ID4gcG9zc2li
aWxpdHkgb2YgdHJpcHBpbmcgb3ZlciBlcnJvcnMuDQo+ID4gDQo+ID4gQ2M6IERhbiBXaWxsaWFt
cyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg0KPiA+IENjOiBSb3NzIFp3aXNsZXIgPHJvc3Mu
endpc2xlckBsaW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IEplZmYgTW95ZXIgPGptb3llckByZWRo
YXQuY29tPg0KPiA+IENjOiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGluZnJhZGVhZC5vcmc+DQo+
ID4gQ2M6IERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4NCj4gPiBDYzogSmFuIEth
cmEgPGphY2tAc3VzZS5jej4NCj4gPiBSZXZpZXdlZC1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhj
aEBsc3QuZGU+DQo+ID4gU2lnbmVkLW9mZi1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJt
YUBpbnRlbC5jb20+DQo+IC4uLg0KPiANCj4gPiANCj4gPiArc3RhdGljIGJvb2wgZGF4X3Jhbmdl
X2lzX2FsaWduZWQoc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwNCj4gPiArCQkJCcKgc3RydWN0
IGJsa19kYXhfY3RsICpkYXgsIHVuc2lnbmVkDQo+ID4gaW50IG9mZnNldCwNCj4gPiArCQkJCcKg
dW5zaWduZWQgaW50IGxlbmd0aCkNCj4gPiArew0KPiA+ICsJdW5zaWduZWQgc2hvcnQgc2VjdG9y
X3NpemUgPSBiZGV2X2xvZ2ljYWxfYmxvY2tfc2l6ZShiZGV2KTsNCj4gPiArDQo+ID4gKwlpZiAo
IUlTX0FMSUdORUQoKCh1NjQpZGF4LT5hZGRyICsgb2Zmc2V0KSwgc2VjdG9yX3NpemUpKQ0KPiBP
bmUgbW9yZSBxdWVzdGlvbjogJ2RheCcgaXMgaW5pdGlhbGl6ZWQgaW4gZGF4X3plcm9fcGFnZV9y
YW5nZSgpIGFuZA0KPiBkYXgtPmFkZHIgaXMgZ29pbmcgdG8gYmUgYWx3YXlzIE5VTEwgaGVyZS4g
U28gZWl0aGVyIHlvdSBmb3Jnb3QgdG8NCj4gY2FsbA0KPiBkYXhfbWFwX2F0b21pYygpIHRvIGdl
dCB0aGUgYWRkciBvciB0aGUgdXNlIG9mIGRheC0+YWRkciBpcyBqdXN0IGJvZ3VzDQo+ICh3aGlj
aCBpcyB3aGF0IEkgY3VycmVudGx5IGJlbGlldmUgc2luY2UgSSBzZWUgbm8gd2F5IGhvdyB0aGUg
YWRkcmVzcw0KPiBjb3VsZA0KPiBiZSB1bmFsaWduZWQgd2l0aCB0aGUgc2VjdG9yX3NpemUpLi4u
DQo+IA0KDQpHb29kIGNhdGNoLCBhbmQgeW91J3JlIHJpZ2h0LiBJIGRvbid0IHRoaW5rIEkgYWN0
dWFsbHkgZXZlbiB3YW50IHRvIHVzZQ0KZGF4LT5hZGRyIGZvciB0aGUgYWxpZ25tZW50IGNoZWNr
IGhlcmUgLSBJIHdhbnQgdG8gY2hlY2sgaWYgd2UncmUNCmFsaWduZWQgdG8gdGhlIGJsb2NrIGRl
dmljZSBzZWN0b3IuIEknbSB0aGlua2luZyBzb21ldGhpbmcgbGlrZToNCg0KCWlmICghSVNfQUxJ
R05FRChvZmZzZXQsIHNlY3Rvcl9zaXplKSkNCg0KVGVjaG5pY2FsbHkgd2Ugd2FudCB0byBjaGVj
ayBpZiBzZWN0b3IgKiBzZWN0b3Jfc2l6ZSArIG9mZnNldCBpcw0KYWxpZ25lZCwgYnV0IHRoZSBm
aXJzdCBwYXJ0IG9mIHRoYXQgaXMgYWxyZWFkeSBhIHNlY3RvciA6KQpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0
CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9s
aXN0aW5mby9saW51eC1udmRpbW0K
