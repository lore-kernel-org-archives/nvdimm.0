Return-Path: <linux-nvdimm-bounces@lists.01.org>
Message-ID: <583BC14B.2040809@amd.com>
Date: Mon, 28 Nov 2016 13:31:55 +0800
From: zhoucm1 <david1.zhou@amd.com>
MIME-Version: 1.0
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
 <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com>
 <0087fba9-7bcb-8bb3-c26e-4ef3e4970c34@amd.com>
In-Reply-To: <0087fba9-7bcb-8bb3-c26e-4ef3e4970c34@amd.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Haggai Eran  <haggaie@mellanox.com>, Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>, "Yu, Qiang" <Qiang.Yu@amd.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, Serguei Sagalovitch" <serguei.sagalovitch@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Sander, , "Suravee  <Suravee.Suthikulpanit@amd.com>, linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Deucher, Alexander  <Alexander.Deucher@amd.com>, Max Gurtovoy <maxg@mellanox.com>, Blinzer, Paul" <Paul.Blinzer@amd.com>, "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

K1FpYW5nLCB3aG8gaXMgd29ya2luZyBvbiBpdC4KCk9uIDIwMTblubQxMeaciDI35pelIDIyOjA3
LCBDaHJpc3RpYW4gS8O2bmlnIHdyb3RlOgo+IEFtIDI3LjExLjIwMTYgdW0gMTU6MDIgc2Nocmll
YiBIYWdnYWkgRXJhbjoKPj4gT24gMTEvMjUvMjAxNiA5OjMyIFBNLCBKYXNvbiBHdW50aG9ycGUg
d3JvdGU6Cj4+PiBPbiBGcmksIE5vdiAyNSwgMjAxNiBhdCAwMjoyMjoxN1BNICswMTAwLCBDaHJp
c3RpYW4gS8O2bmlnIHdyb3RlOgo+Pj4KPj4+Pj4gTGlrZSB5b3Ugc2F5IGJlbG93IHdlIGhhdmUg
dG8gaGFuZGxlIHNob3J0IGxpdmVkIGluIHRoZSB1c3VhbCB3YXksIAo+Pj4+PiBhbmQKPj4+Pj4g
dGhhdCBjb3ZlcnMgYmFzaWNhbGx5IGV2ZXJ5IGRldmljZSBleGNlcHQgSUIgTVJzLCBpbmNsdWRp
bmcgdGhlCj4+Pj4+IGNvbW1hbmQgcXVldWUgb24gYSBOVk1lIGRyaXZlLgo+Pj4+IFdlbGwgYSBw
cm9ibGVtIHdoaWNoIHdhc24ndCBtZW50aW9uZWQgc28gZmFyIGlzIHRoYXQgd2hpbGUgR1BVcyBk
byAKPj4+PiBoYXZlIGEKPj4+PiBwYWdlIHRhYmxlIHRvIG1pcnJvciB0aGUgQ1BVIHBhZ2UgdGFi
bGUsIHRoZXkgdXN1YWxseSBjYW4ndCByZWNvdmVyIAo+Pj4+IGZyb20KPj4+PiBwYWdlIGZhdWx0
cy4KPj4+PiBTbyB3aGF0IHdlIGRvIGlzIG1ha2luZyBzdXJlIHRoYXQgYWxsIG1lbW9yeSBhY2Nl
c3NlZCBieSB0aGUgR1BVIAo+Pj4+IEpvYnMgc3RheXMKPj4+PiBpbiBwbGFjZSB3aGlsZSB0aG9z
ZSBqb2JzIHJ1biAocHJldHR5IG11Y2ggdGhlIHNhbWUgcGlubmluZyB5b3UgZG8gCj4+Pj4gZm9y
IHRoZQo+Pj4+IERNQSkuCj4+PiBZZXMsIGl0IGlzIERNQSwgc28gdGhpcyBpcyBhIHZhbGlkIGFw
cHJvYWNoLgo+Pj4KPj4+IEJ1dCwgeW91IGRvbid0IG5lZWQgcGFnZSBmYXVsdHMgZnJvbSB0aGUg
R1BVIHRvIGRvIHByb3BlciBjb2hlcmVudAo+Pj4gcGFnZSB0YWJsZSBtaXJyb3JpbmcuIEJhc2lj
YWxseSB3aGVuIHRoZSBkcml2ZXIgc3VibWl0cyB0aGUgd29yayB0bwo+Pj4gdGhlIEdQVSBpdCAn
ZmF1bHRzJyB0aGUgcGFnZXMgaW50byB0aGUgQ1BVIGFuZCBtaXJyb3IgdHJhbnNsYXRpb24KPj4+
IHRhYmxlIChpbnN0ZWFkIG9mIHBpbm5pbmcpLgo+Pj4KPj4+IExpa2UgaW4gT0RQLCBNTVUgbm90
aWZpZXJzL0hNTSBhcmUgdXNlZCB0byBtb25pdG9yIGZvciB0cmFuc2xhdGlvbgo+Pj4gY2hhbmdl
cy4gSWYgYSBjaGFuZ2UgY29tZXMgaW4gdGhlIEdQVSBkcml2ZXIgY2hlY2tzIGlmIGFuIGV4ZWN1
dGluZwo+Pj4gY29tbWFuZCBpcyB0b3VjaGluZyB0aG9zZSBwYWdlcyBhbmQgYmxvY2tzIHRoZSBN
TVUgbm90aWZpZXIgdW50aWwgdGhlCj4+PiBjb21tYW5kIGZsdXNoZXMsIHRoZW4gdW5mYXVsdHMg
dGhlIHBhZ2UgKGJsb2NraW5nIGZ1dHVyZSBjb21tYW5kcykgYW5kCj4+PiB1bmJsb2NrcyB0aGUg
bW11IG5vdGlmaWVyLgo+PiBJIHRoaW5rIGJsb2NraW5nIG1tdSBub3RpZmllcnMgYWdhaW5zdCBz
b21ldGhpbmcgdGhhdCBpcyBiYXNpY2FsbHkKPj4gY29udHJvbGxlZCBieSB1c2VyLXNwYWNlIGNh
biBiZSBwcm9ibGVtYXRpYy4gVGhpcyBjYW4gYmxvY2sgdGhpbmdzIGxpa2UKPj4gbWVtb3J5IHJl
Y2xhaW0uIElmIHlvdSBoYXZlIHVzZXItc3BhY2UgYWNjZXNzIHRvIHRoZSBkZXZpY2UncyBxdWV1
ZXMsCj4+IHVzZXItc3BhY2UgY2FuIGJsb2NrIHRoZSBtbXUgbm90aWZpZXIgZm9yZXZlci4KPiBS
ZWFsbHkgZ29vZCBwb2ludC4KPgo+IEkgdGhpbmsgdGhpcyBtZWFucyB0aGUgYmFyZSBtaW5pbXVt
IGlmIHdlIGRvbid0IGhhdmUgcmVjb3ZlcmFibGUgcGFnZSAKPiBmYXVsdHMgaXMgdG8gaGF2ZSBw
cmVlbXB0aW9uIHN1cHBvcnQgbGlrZSBGZWxpeCBkZXNjcmliZWQgaW4gaGlzIAo+IGFuc3dlciBh
cyB3ZWxsLgo+Cj4gR29pbmcgdG8ga2VlcCB0aGF0IGluIG1pbmQsCj4gQ2hyaXN0aWFuLgo+Cj4g
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPiBkcmktZGV2
ZWwgbWFpbGluZyBsaXN0Cj4gZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwo+IGh0dHBz
Oi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0g
bWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5v
cmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
