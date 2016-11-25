Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
References: <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
 <20161125193252.GC16504@obsidianresearch.com>
 <a98185d9-ffb1-6469-4272-2d1222600825@vodafone.de>
From: Felix Kuehling <felix.kuehling@amd.com>
Message-ID: <e3c2640a-5dd9-7527-7db8-9b3219bb7625@amd.com>
Date: Fri, 25 Nov 2016 15:51:15 -0500
MIME-Version: 1.0
In-Reply-To: <a98185d9-ffb1-6469-4272-2d1222600825@vodafone.de>
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
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <deathsimple@vodafone.de>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Cc: Haggai Eran <haggaie@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Serguei Sagalovitch <serguei.sagalovitch@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Sander,, "Suravee  <Suravee.Suthikulpanit@amd.com>, linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Deucher,, "Paul  <Paul.Blinzer@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Ck9uIDE2LTExLTI1IDAzOjQwIFBNLCBDaHJpc3RpYW4gS8O2bmlnIHdyb3RlOgo+IEFtIDI1LjEx
LjIwMTYgdW0gMjA6MzIgc2NocmllYiBKYXNvbiBHdW50aG9ycGU6Cj4+IFRoaXMgYXNzdW1lcyB0
aGUgY29tbWFuZHMgYXJlIGZhaXJseSBzaG9ydCBsaXZlZCBvZiBjb3Vyc2UsIHRoZQo+PiBleHBl
Y3RhdGlvbiBvZiB0aGUgbW11IG5vdGlmaWVycyBpcyB0aGF0IGEgZmx1c2ggaXMgcmVhc29uYWJs
eSBwcm9tcHQKPgo+IENvcnJlY3QsIHRoaXMgaXMgYW5vdGhlciBwcm9ibGVtLiBHRlggY29tbWFu
ZCBzdWJtaXNzaW9ucyB1c3VhbGx5Cj4gZG9uJ3QgdGFrZSBsb25nZXIgdGhhbiBhIGZldyBtaWxs
aXNlY29uZHMsIGJ1dCBjb21wdXRlIGNvbW1hbmQKPiBzdWJtaXNzaW9uIGNhbiBlYXNpbHkgdGFr
ZSBtdWx0aXBsZSBob3Vycy4KPgo+IEkgY2FuIGVhc2lseSBpbWFnaW5lIHdoYXQgd291bGQgaGFw
cGVuIHdoZW4ga3N3YXBkIGlzIGJsb2NrZWQgYnkgYSBHUFUKPiBjb21tYW5kIHN1Ym1pc3Npb24g
Zm9yIGFuIGhvdXIgb3Igc28gd2hpbGUgdGhlIHN5c3RlbSBpcyB1bmRlciBtZW1vcnkKPiBwcmVz
c3VyZSA6KQo+Cj4gSSdtIHRoaW5raW5nIG9uIHRoaXMgcHJvYmxlbSBmb3IgYWJvdXQgYSB5ZWFy
IG5vdyBhbmQgZ29pbmcgaW4gY2lyY2xlcwo+IGZvciBxdWl0ZSBhIHdoaWxlLiBTbyBpZiB5b3Ug
aGF2ZSBpZGVhcyBvbiB0aGlzIGV2ZW4gaWYgdGhleSBzb3VuZAo+IHRvdGFsbHkgY3JhenksIGZl
ZWwgZnJlZSB0byBjb21lIHVwLgoKT3VyIEdQVXMgKGF0IGxlYXN0IHN0YXJ0aW5nIHdpdGggVkkp
IHN1cHBvcnQgY29tcHV0ZS13YXZlLXNhdmUtcmVzdG9yZQphbmQgY2FuIHN3YXAgb3V0IGNvbXB1
dGUgcXVldWVzIHdpdGggZmFpcmx5IGxvdyBsYXRlbmN5LiBZZXMsIHRoZXJlIGlzCnNvbWUgb3Zl
cmhlYWQgKGJvdGggbWVtb3J5IHVzYWdlIGFuZCB0aW1lKSwgYnV0IGl0J3MgYSBmYWlybHkgcmVn
dWxhcgp0aGluZyB3aXRoIG91ciBoYXJkd2FyZSBzY2hlZHVsZXIgKGZpcm13YXJlLCBhY3R1YWxs
eSkgd2hlbiB3ZSBuZWVkIHRvCnByZWVtcHQgcnVubmluZyBjb21wdXRlIHF1ZXVlcyB0byB1cGRh
dGUgcnVubGlzdHMgb3Igd2Ugb3ZlcmNvbW1pdCB0aGUKaGFyZHdhcmUgcXVldWUgcmVzb3VyY2Vz
LgoKUmVnYXJkcywKICBGZWxpeAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMu
MDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1t
Cg==
