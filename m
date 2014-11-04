Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 1/4] pmem: Initial version of persistent memory driver
Date: Tue, 4 Nov 2014 16:26:32 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295936C4B1@G4W3202.americas.hpqcorp.net>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
 <1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>
 <94D0CD8314A33A4D9D801C0FE68B4029593548AB@G9W0745.americas.hpqcorp.net>
 <100D68C7BA14664A8938383216E40DE04082985D@FMSMSX114.amr.corp.intel.com>
 <5458AC75.3030207@plexistor.com>
In-Reply-To: <5458AC75.3030207@plexistor.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@kernel.dk>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "Knippers, Linda" <linda.knippers@hp.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Matthew Wilcox <willy@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQm9heiBIYXJyb3NoIFtt
YWlsdG86Ym9hekBwbGV4aXN0b3IuY29tXQ0KPiBTZW50OiBUdWVzZGF5LCAwNCBOb3ZlbWJlciwg
MjAxNCA0OjM4IEFNDQo+IFRvOiBXaWxjb3gsIE1hdHRoZXcgUjsgRWxsaW90dCwgUm9iZXJ0IChT
ZXJ2ZXIgU3RvcmFnZSk7IFJvc3MNCj4gWndpc2xlcjsgSmVucyBBeGJvZTsgTmljayBQaWdnaW47
IEthbmksIFRvc2hpbWl0c3U7IEtuaXBwZXJzLCBMaW5kYTsNCj4gbGludXgtZnNkZXZlbEB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBudmRp
bW1AbGlzdHMuMDEub3JnOyBNYXR0aGV3IFdpbGNveA0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDEv
NF0gcG1lbTogSW5pdGlhbCB2ZXJzaW9uIG9mIHBlcnNpc3RlbnQgbWVtb3J5DQo+IGRyaXZlcg0K
PiANCj4gT24gMTEvMDMvMjAxNCAwNjoxOSBQTSwgV2lsY294LCBNYXR0aGV3IFIgd3JvdGU6DQou
Li4NCj4gDQo+IEkgd2lzaCB5b3UgZ3V5cyB3b3VsZCBhY3R1YWxseSByZXZpZXcgdGhlIGNvcnJl
Y3QgY29kZS4NCj4gDQo+IEluIHRoZSBhY3R1YWwgZ29vZCBkcml2ZXIgdGhhdCBoYXMgYW55IHNo
YXBlIG9mIHByb3BlciBjb2RlIGFsbCB0aGVzZQ0KPiBpc3N1ZSBhcmUgZ29uZS4NCj4gDQo+ICog
Y29uZmlnIGRlZmF1bHRzIGdvbmUsIG11bHRpcGxlLWRldmljZXMgbXVsdGlwbGUtbWVtb3J5IHJh
bmdlcyBmdWxseQ0KPiAgICBzdXBwb3J0ZWQgaG90IHBsdWcgc3R5bGUuDQo+ICogYWJvdmUgc2hp
ZnRzIGNydWZ0IGNvbXBsZXRlbHkgZ29uZSBpdCBpcyBsZWZ0IG92ZXJzIGZyb20gYnJkLmMgYW5k
DQo+ICAgaXRzIHBhZ2UgdXNhZ2UuDQo+ICogZ2V0Z2VvIGZpeGVkIHRvIGRvIHdoYXQgd2UgcmVh
bHkgd2FudCBieSB0aGUgb25seSBhcHBsaWNhdGlvbiBvbiBlYXJ0aA0KPiAgIHRoYXQgc3RpbGwg
dXNlcyBpdCwgZmRpc2suIEFsbCBvdGhlciBwYXJ0aXRpb25lcnMgZG8gbm90IGNhbGwgaXQgYXQN
Cj4gICBhbGwuDQo+IA0KPiBXaHkgYXJlIHdlIHJldmlld2luZyBkZWFkIGNvZGUgPw0KPiANCj4g
Q2hlZXJzDQo+IEJvYXoNCg0KUm9zcywgd2hhdCdzIHRoZSBzdGF0dXMgb2YgQm9heicgcGF0Y2hl
cyAoYXZhaWxhYmxlIGluDQpnaXQ6Ly9naXQub3Blbi1vc2Qub3JnL3BtZW0uZ2l0KT8NCg0KaHR0
cHM6Ly9naXRodWIuY29tLzAxb3JnL3ByZC5naXQgZG9lc24ndCBpbmNsdWRlIGFueSBvZiANCnRo
ZW0geWV0Lg0KDQoNCg==
