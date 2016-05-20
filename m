Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from na01-bn1-obe.outbound.protection.outlook.com
 (mail-bn1bon0740.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fc10::1:740])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 172091A1E27
 for <linux-nvdimm@lists.01.org>; Fri, 20 May 2016 08:48:33 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] remove unused blkdev_dax_capable() function
Date: Fri, 20 May 2016 15:48:23 +0000
Message-ID: <1463758753.32042.26.camel@hpe.com>
References: <201605201900.FlOCWSKP%fengguang.wu@intel.com>
In-Reply-To: <201605201900.FlOCWSKP%fengguang.wu@intel.com>
Content-Language: en-US
Content-ID: <350B145B6DF2E044922F97B943D37633@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "lkp@intel.com" <lkp@intel.com>, "arnd@arndb.de" <arnd@arndb.de>
Cc: "hch@infradead.org" <hch@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "axboe@fb.com" <axboe@fb.com>, "david@fromorbit.com" <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Parrish, Micah \\ linux-block@vger.kernel.org (HP Servers Linux R&D)\" <micah.parrish@hpe.com>,)" <linux-block@vger.kernel.org>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>, "kbuild-all@01.org" <kbuild-all@01.org>
List-ID: <linux-nvdimm@lists.01.org>

RllJLCBmcy9ibG9ja19kZXYuYyBoYXMgbXVsdGlwbGUgdXBkYXRlcyBzaW5jZSB0aGVuIGluY2x1
ZGluZyB0aGUgY29kZSBpbg0KcXVlc3Rpb24uIEkganVzdCBidWlsdCB0b3QgLW5leHQgbTY0IGtl
cm5lbCB3aXRoIHRoZSBhdHRhY2hlZCBjb25maWcgZmlsZSwNCmFuZCBjb25maXJtZWQgbm8gY29t
cGlsZSBlcnJvciBvbiB0aGUgZmlsZS4NCi1Ub3NoaQ0KDQpPbiBGcmksIDIwMTYtMDUtMjAgYXQg
MTk6MzIgKzA4MDAsIGtidWlsZCB0ZXN0IHJvYm90IHdyb3RlOg0KPiBIaSwNCj4gDQo+IFthdXRv
IGJ1aWxkIHRlc3QgRVJST1Igb24gbmV4dC0yMDE2MDUxN10NCj4gW2Nhbm5vdCBhcHBseSB0byB2
NC42LXJjNyB2NC42LXJjNiB2NC42LXJjNSB2NC42XQ0KPiBbaWYgeW91ciBwYXRjaCBpcyBhcHBs
aWVkIHRvIHRoZSB3cm9uZyBnaXQgdHJlZSwgcGxlYXNlIGRyb3AgdXMgYSBub3RlIHRvDQo+IGhl
bHAgaW1wcm92ZSB0aGUgc3lzdGVtXQ0KPiANCj4gdXJsOsKgwqDCoMKgaHR0cHM6Ly9naXRodWIu
Y29tLzBkYXktY2kvbGludXgvY29tbWl0cy9Bcm5kLUJlcmdtYW5uL3JlbW92ZS11bnUNCj4gc2Vk
LWJsa2Rldl9kYXhfY2FwYWJsZS1mdW5jdGlvbi8yMDE2MDUxOC0xNTU3MjkNCj4gY29uZmlnOiBt
NjhrLWFsbHllc2NvbmZpZyAoYXR0YWNoZWQgYXMgLmNvbmZpZykNCj4gY29tcGlsZXI6IG02OGst
bGludXgtZ2NjIChHQ0MpIDQuOS4wDQo+IHJlcHJvZHVjZToNCj4gwqDCoMKgwqDCoMKgwqDCoHdn
ZXQgaHR0cHM6Ly9naXQua2VybmVsLm9yZy9jZ2l0L2xpbnV4L2tlcm5lbC9naXQvd2ZnL2xrcC10
ZXN0cy5nDQo+IGl0L3BsYWluL3NiaW4vbWFrZS5jcm9zcyAtTyB+L2Jpbi9tYWtlLmNyb3NzDQo+
IMKgwqDCoMKgwqDCoMKgwqBjaG1vZCAreCB+L2Jpbi9tYWtlLmNyb3NzDQo+IMKgwqDCoMKgwqDC
oMKgwqAjIHNhdmUgdGhlIGF0dGFjaGVkIC5jb25maWcgdG8gbGludXggYnVpbGQgdHJlZQ0KPiDC
oMKgwqDCoMKgwqDCoMKgbWFrZS5jcm9zcyBBUkNIPW02OGvCoA0KPiANCj4gQWxsIGVycm9ycyAo
bmV3IG9uZXMgcHJlZml4ZWQgYnkgPj4pOg0KPiANCj4gwqDCoMKgZnMvYmxvY2tfZGV2LmM6IElu
IGZ1bmN0aW9uICdfX2Jsa2Rldl9nZXQnOg0KPiA+IA0KPiA+ID4gDQo+ID4gPiBmcy9ibG9ja19k
ZXYuYzoxMjQyOjU6IGVycm9yOiBpbXBsaWNpdCBkZWNsYXJhdGlvbiBvZiBmdW5jdGlvbg0KPiA+
ID4gJ2Jsa2Rldl9kYXhfY2FwYWJsZScgWy1XZXJyb3I9aW1wbGljaXQtZnVuY3Rpb24tZGVjbGFy
YXRpb25dDQo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoIWJsa2Rldl9kYXhfY2FwYWJsZShiZGV2KSkN
Cj4gwqDCoMKgwqDCoMKgwqDCoF4NCj4gwqDCoMKgY2MxOiBzb21lIHdhcm5pbmdzIGJlaW5nIHRy
ZWF0ZWQgYXMgZXJyb3JzDQo+IA0KPiB2aW0gKy9ibGtkZXZfZGF4X2NhcGFibGUgKzEyNDIgZnMv
YmxvY2tfZGV2LmMNCj4gDQo+IGQzMzc0ODI1IE5laWxCcm93bsKgwqDCoMKgMjAwOS0wMS0wOcKg
wqAxMjM2wqDCoAkJCQkJDQo+IGdvdG8gcmVzdGFydDsNCj4gZDMzNzQ4MjUgTmVpbEJyb3duwqDC
oMKgwqAyMDA5LTAxLTA5wqDCoDEyMzfCoMKgCQkJCX0NCj4gMTE5NmY4YjggVGVqdW4gSGVvwqDC
oMKgwqAyMDExLTA0LTIxwqDCoDEyMzjCoMKgCQkJfQ0KPiA3ZTY5NzIzZiBUZWp1biBIZW/CoMKg
wqDCoDIwMTEtMDUtMjPCoMKgMTIzOcKgwqANCj4gNWEwMjNjZGIgRGFuIFdpbGxpYW1zIDIwMTUt
MTEtMzDCoMKgMTI0MMKgwqAJCQlpZiAoIXJldCkNCj4gew0KPiA3ZTY5NzIzZiBUZWp1biBIZW/C
oMKgwqDCoDIwMTEtMDUtMjPCoMKgMTI0McKgwqAJCQkJYg0KPiBkX3NldF9zaXplKGJkZXYsKGxv
ZmZfdClnZXRfY2FwYWNpdHkoZGlzayk8PDkpOw0KPiA1YTAyM2NkYiBEYW4gV2lsbGlhbXMgMjAx
NS0xMS0zMCBAMTI0MsKgwqAJCQkJaQ0KPiBmICghYmxrZGV2X2RheF9jYXBhYmxlKGJkZXYpKQ0K
PiA1YTAyM2NkYiBEYW4gV2lsbGlhbXMgMjAxNS0xMS0zMMKgwqAxMjQzwqDCoAkJCQkJDQo+IGJk
ZXYtPmJkX2lub2RlLT5pX2ZsYWdzICY9IH5TX0RBWDsNCj4gNWEwMjNjZGIgRGFuIFdpbGxpYW1z
IDIwMTUtMTEtMzDCoMKgMTI0NMKgwqAJCQl9DQo+IDdlNjk3MjNmIFRlanVuIEhlb8KgwqDCoMKg
MjAxMS0wNS0yM8KgwqAxMjQ1wqDCoA0KPiANCj4gOjo6Ojo6IFRoZSBjb2RlIGF0IGxpbmUgMTI0
MiB3YXMgZmlyc3QgaW50cm9kdWNlZCBieSBjb21taXQNCj4gOjo6Ojo6IDVhMDIzY2RiYTUwYzVm
NWYyYmMzNTE3ODNiMzEzMTY5OWRlYjM5MzcgYmxvY2s6IGVuYWJsZSBkYXggZm9yIHJhdw0KPiBi
bG9jayBkZXZpY2VzDQo+IA0KPiA6Ojo6OjogVE86IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlh
bXNAaW50ZWwuY29tPg0KPiA6Ojo6OjogQ0M6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNA
aW50ZWwuY29tPg0KPiANCj4gLS0tDQo+IDAtREFZIGtlcm5lbCB0ZXN0IGluZnJhc3RydWN0dXJl
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBPcGVuIFNvdXJjZSBUZWNobm9sb2d5DQo+
IENlbnRlcg0KPiBodHRwczovL2xpc3RzLjAxLm9yZy9waXBlcm1haWwva2J1aWxkLWFsbMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgSW50ZWwNCj4gQ29ycG9yYXRpb24KX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1t
IG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEu
b3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
