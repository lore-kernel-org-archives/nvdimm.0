Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [Linux-nvdimm] [PATCH v2 19/20] nd_btt: atomic sector updates
Date: Wed, 20 May 2015 17:20:47 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A917EC6@G9W0745.americas.hpqcorp.net>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150428182557.35812.38292.stgit@dwillia2-desk3.amr.corp.intel.com>
	<94D0CD8314A33A4D9D801C0FE68B40295A9097E5@G9W0745.americas.hpqcorp.net>
 <CAA9_cmfzm=u+OH6FicfMBQ_0p_BGNh6A49fEm8-QV3vnmrsYdQ@mail.gmail.com>
In-Reply-To: <CAA9_cmfzm=u+OH6FicfMBQ_0p_BGNh6A49fEm8-QV3vnmrsYdQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogZGFuLmoud2lsbGlhbXNA
Z21haWwuY29tIFttYWlsdG86ZGFuLmoud2lsbGlhbXNAZ21haWwuY29tXSBPbg0KPiBCZWhhbGYg
T2YgRGFuIFdpbGxpYW1zDQo+IFNlbnQ6IFNhdHVyZGF5LCBNYXkgMTYsIDIwMTUgMTA6MjIgUE0N
Cj4gVG86IEVsbGlvdHQsIFJvYmVydCAoU2VydmVyIFN0b3JhZ2UpDQo+IENjOiBsaW51eC1udmRp
bW1AbGlzdHMuMDEub3JnOyBOZWlsIEJyb3duOyBHcmVnIEtIOyBEYXZlIENoaW5uZXI7IGxpbnV4
LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyBBbmR5IEx1dG9taXJza2k7IEplbnMgQXhib2U7
IEguIFBldGVyIEFudmluOw0KPiBDaHJpc3RvcGggSGVsbHdpZzsgSW5nbyBNb2xuYXINCj4gU3Vi
amVjdDogUmU6IFtMaW51eC1udmRpbW1dIFtQQVRDSCB2MiAxOS8yMF0gbmRfYnR0OiBhdG9taWMg
c2VjdG9yDQo+IHVwZGF0ZXMNCj4gDQo+IE9uIFNhdCwgTWF5IDE2LCAyMDE1IGF0IDY6MTkgUE0s
IEVsbGlvdHQsIFJvYmVydCAoU2VydmVyIFN0b3JhZ2UpDQo+IDxFbGxpb3R0QGhwLmNvbT4gd3Jv
dGU6DQo+ID4NCi4uLg0KPiAyIGl0ZW1zIHRvIGNoZWNrOg0KPiANCj4gMS8gbWFrZSBzdXJlIHlv
dSBoYXZlIGEgeW91ciBidHQgc2VjdG9yIHNpemUgc2V0IHRvIDRrIHdoaWNoIGN1dHMgZG93bg0K
PiB0aGUgb3ZlcmhlYWQgYnkgYSBmYWN0b3Igb2YgOC4NCj4gDQo+IDIvIGJvb3Qgd2l0aCBucl9j
cHVzPTI1NiBvciBsb3dlci4NCj4gDQo+IFJvc3Mgbm90aWNlZCB0aGF0IENPTkZJR19OUl9DUFVT
IGlzIHNldCBxdWl0ZSBoaWdoIG9uIGRpc3RybyBrZXJuZWxzDQo+IHdoaWNoIHJldmVhbGVkIHRo
YXQgd2Ugc2hvdWxkIGhhdmUgYmVlbiB1c2luZyBucl9jcHVfaWRzIGFuZCBwZXJjcHUNCj4gdmFy
aWFibGVzIGZvciBuZF9yZWdpb25fYWNxdWlyZV9sYW5lKCkgZnJvbSB0aGUgb3V0c2V0LiAgVGhp
cyBmaXggaXMNCj4gY29taW5nIGluIHYzLg0KDQpNeSBzeXN0ZW0gZG9lcyBoYXZlIENPTkZJR19O
Ul9DUFVTPTgxOTIuICBJJ2xsIHRyeSB0aGUgaXRlbXMgeW91IA0Kc3VnZ2VzdGVkLg0KDQoNCg==
