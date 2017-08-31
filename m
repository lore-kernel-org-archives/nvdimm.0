Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00F4620958BC1
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 15:10:37 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v7 9/9] libnvdimm: Add DMA based blk-mq pmem driver
Date: Thu, 31 Aug 2017 22:13:18 +0000
Message-ID: <1504216996.2042.182.camel@hpe.com>
References: <150412628764.69288.12074115435918322858.stgit@djiang5-desk3.ch.intel.com>
 <150412658373.69288.2856155675209269488.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <150412658373.69288.2856155675209269488.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <7315A83594177A408725107E794B3190@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>, "vinod.koul@intel.com" <vinod.koul@intel.com>
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE3LTA4LTMwIGF0IDEzOjU2IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KIDoN
CitzdGF0aWMgaW50IHBtZW1fYXR0YWNoX2Rpc2soc3RydWN0IGRldmljZSAqZGV2LA0KPiArCQlz
dHJ1Y3QgbmRfbmFtZXNwYWNlX2NvbW1vbiAqbmRucykNCj4gK3sNCj4gKwlzdHJ1Y3QgcG1lbV9k
ZXZpY2UgKnBtZW07DQo+ICsJaW50IHJjOw0KPiArCXN0cnVjdCBkbWFfY2hhbiAqY2hhbiA9IE5V
TEw7DQo+ICsJaW50IGhhc19kbWE7DQo+ICsNCj4gKwlwbWVtID0gcG1lbV9jb3JlX3NldHVwX3Bt
ZW0oZGV2LCBuZG5zKTsNCj4gKwlpZiAoIXBtZW0pDQo+ICsJCXJldHVybiAtRU5YSU87DQo+ICsN
Cj4gKwljaGFuID0gZG1hX2ZpbmRfY2hhbm5lbChETUFfTUVNQ1BZX1NHKTsNCj4gKwlpZiAoIWNo
YW4pDQo+ICsJCWRldl93YXJuKGRldiwgIkZvcmNlZCBiYWNrIHRvIENQVSwgbm8gRE1BXG4iKTsN
Cg0KSSBqdXN0IHRlc3RlZCB0aGlzIHNlcmllcyBvbiBhIEhhc3dlbGwgc3lzdGVtLiAgVGhlIGFi
b3ZlIHdhcm5pbmcNCm1lc3NhZ2VzIHdhcyBzaG93biBkdXJpbmcgYm9vdC11cCAoaXMgdGhpcyBl
eHBlY3RlZD8pLCBidXQgaXQgZGlkIG5vdA0KYXBwZWFyIHRvIHN3aXRjaCBiYWNrIHRvIENQVS4g
IEluaXRpYWwgSU8gcmVxdWVzdHMgdG8gcG1lbSAobWtmcykgaGl0DQp0aGUgV0FSTl9PTl9PTkNF
KCkgYmVsb3cuICBwbWVtLT5zZ19hbGxvY2F0ZWQgaXMgemVybyBzaW5jZSBpdCB3YXMgbm90DQpp
bml0aWFsaXplZCAoaGFzX2RtYSB3YXMgc2V0IHRvIDApLg0KDQpbwqDCoDg5Ny4xNDc1MjddIFdB
Uk5JTkc6IENQVTogMjMgUElEOiA3MDcgYXQNCmRyaXZlcnMvbnZkaW1tL3BtZW1fZG1hLmM6MTcx
IHBtZW1faGFuZGxlX2NtZF9kbWErMHg2NzUvMHg3MTANCg0KSXQgdGhlbiBkaXNwbGF5ZWQgc2Vl
bWVkLWZvcmV2ZXItcmVwZWF0ZWQgZXJyb3IgbWVzc2FnZXMgYmVsb3cuDQoNCiBpb2F0ZG1hIDAw
MDA6ODA6MDQuNzogaW9hdF90aW1lcl9ldmVudDogQ2hhbm5lbCBoYWx0ZWQgKDEpDQogaW9hdGRt
YSAwMDAwOjgwOjA0Ljc6IEVycm9yczoNCiBpb2F0ZG1hIDAwMDA6ODA6MDQuNzogRXJyKDApOiBE
TUEgVHJhbnNmZXIgU291cmNlIEFkZHJlc3MgRXJyb3INCiBpb2F0ZG1hIDAwMDA6ODA6MDQuNzog
UmVzZXQgY2hhbm5lbC4uLg0KIGlvYXRkbWEgMDAwMDo4MDowNC43OiBSZXN0YXJ0IGNoYW5uZWwu
Li4NCiBpb2F0ZG1hIDAwMDA6ODA6MDQuNzogaW9hdF90aW1lcl9ldmVudDogQ2hhbm5lbCBoYWx0
ZWQgKDEwMDApDQogaW9hdGRtYSAwMDAwOjgwOjA0Ljc6IEVycm9yczoNCiBpb2F0ZG1hIDAwMDA6
ODA6MDQuNzogRXJyKDEyKTogQ29tcGxldGlvbiBBZGRyZXNzIEVycm9yDQogaW9hdGRtYSAwMDAw
OjgwOjA0Ljc6IFJlc2V0IGNoYW5uZWwuLi4NCiBpb2F0ZG1hIDAwMDA6ODA6MDQuNzogUmVzdGFy
dCBjaGFubmVsLi4uDQogaW9hdGRtYSAwMDAwOjgwOjA0Ljc6IGlvYXRfdGltZXJfZXZlbnQ6IENo
YW5uZWwgaGFsdGVkICgxMDAwKQ0KICAgOg0KDQpBbnkgdGhvdWdodHM/ICBBbHNvLCBob3cgZG8g
SSBjaG9vc2UgdGhlIG1vZGUgYmV0d2VlbiBDUFUgYW5kIERNQT8NClRoYW5rcyENCi1Ub3NoaQ0K
DQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1u
dmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0
cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
