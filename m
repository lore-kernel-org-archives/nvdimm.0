Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B774C2094554F
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 10:29:51 -0700 (PDT)
Subject: Re: [PATCH] Add support of NVDIMM memory error notification in ACPI
 6.2
References: <20170607184947.18733-1-toshi.kani@hpe.com>
 <CAPcyv4i7bLU17QEmdUBQrtWP3AZxPRyKK0NN105XrTj8K3nAAQ@mail.gmail.com>
 <1496869051.9288.1.camel@hpe.com>
 <CAPcyv4hwhRc6+JW8m3zVn_tKz__wE9BHOfpjy69RS6OwiqV-PA@mail.gmail.com>
 <1496871186.9288.3.camel@hpe.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <b91c4a7b-3e19-df5d-12e7-61cdf1bc2c84@hpe.com>
Date: Thu, 8 Jun 2017 13:30:51 -0400
MIME-Version: 1.0
In-Reply-To: <1496871186.9288.3.camel@hpe.com>
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiA2LzcvMjAxNyA1OjMzIFBNLCBLYW5pLCBUb3NoaW1pdHN1IHdyb3RlOgo+IE9uIFdlZCwg
MjAxNy0wNi0wNyBhdCAxNDowNiAtMDcwMCwgRGFuIFdpbGxpYW1zIHdyb3RlOgo+PiBPbiBXZWQs
IEp1biA3LCAyMDE3IGF0IDE6NTcgUE0sIEthbmksIFRvc2hpbWl0c3UgPHRvc2hpLmthbmlAaHBl
LmNvbT4KPj4gd3JvdGU6Cj4+PiBPbiBXZWQsIDIwMTctMDYtMDcgYXQgMTI6MDkgLTA3MDAsIERh
biBXaWxsaWFtcyB3cm90ZToKPj4+PiBPbiBXZWQsIEp1biA3LCAyMDE3IGF0IDExOjQ5IEFNLCBU
b3NoaSBLYW5pIDx0b3NoaS5rYW5pQGhwZS5jb20+Cj4+Pj4gd3JvdGU6Cj4+Pgo+Pj4gIDoKPj4+
Pj4gKwo+Pj4+PiArc3RhdGljIHZvaWQgYWNwaV9uZml0X3VjX2Vycm9yX25vdGlmeShzdHJ1Y3Qg
ZGV2aWNlICpkZXYsCj4+Pj4+IGFjcGlfaGFuZGxlIGhhbmRsZSkKPj4+Pj4gK3sKPj4+Pj4gKyAg
ICAgICBzdHJ1Y3QgYWNwaV9uZml0X2Rlc2MgKmFjcGlfZGVzYyA9Cj4+Pj4+IGRldl9nZXRfZHJ2
ZGF0YShkZXYpOwo+Pj4+PiArCj4+Pj4+ICsgICAgICAgYWNwaV9uZml0X2Fyc19yZXNjYW4oYWNw
aV9kZXNjKTsKPj4+Pgo+Pj4+IEkgd29uZGVyIGlmIHdlIHNob3VsZCBnYXRlIHJlLXNjYW5uaW5n
IHdpdGggYSBzaW1pbGFyOgo+Pj4+Cj4+Pj4gICAgIGlmIChhY3BpX2Rlc2MtPnNjcnViX21vZGUg
PT0gSFdfRVJST1JfU0NSVUJfT04pCj4+Pj4KPj4+PiAuLi5jaGVjayB0aGF0IHdlIGRvIGluIHRo
ZSBtY2Ugbm90aWZpY2F0aW9uIGNhc2U/IE1heWJlIG5vdCBzaW5jZQo+Pj4+IHdlCj4+Pj4gZG9u
J3QgZ2V0IGFuIGluZGljYXRpb24gb2Ygd2hlcmUgdGhlIGVycm9yIGlzIHdpdGhvdXQgYSByZXNj
YW4uCj4+Pgo+Pj4gSSB0aGluayB0aGlzIG1jZSBjYXNlIGlzIGRpZmZlcmVudCBzaW5jZSB0aGUg
TUNFIGhhbmRsZXIgYWxyZWFkeQo+Pj4ga25vd3Mgd2hlcmUgdGhlIG5ldyBwb2lzb24gbG9jYXRp
b24gaXMgYW5kIGNhbiB1cGRhdGUgYmFkYmxvY2tzCj4+PiBpbmZvcm1hdGlvbiBmb3IgaXQuICBT
dGFydGluZyBBUlMgaXMgYW4gb3B0aW9uYWwgcHJlY2F1dGlvbi4KPj4+Cj4+Pj4gSG93ZXZlciwg
YXQgYSBtaW5pbXVtIEkgdGhpbmsgd2UgbmVlZCBzdXBwb3J0IGZvciB0aGUgbmV3IFN0YXJ0Cj4+
Pj4gQVJTIGZsYWcgKCJJZiBzZXQgdG8gMSB0aGUgZmlybXdhcmUgc2hhbGwgcmV0dXJuIGRhdGEg
ZnJvbSBhCj4+Pj4gcHJldmlvdXMgc2NydWIsIGlmIGFueSwgd2l0aG91dCBzdGFydGluZyBhIG5l
dyBzY3J1YiIpIGFuZCB1c2UKPj4+PiB0aGF0IGZvciB0aGlzIGNhc2UuCj4+Pgo+Pj4gVGhhdCdz
IGFuIGludGVyZXN0aW5nIGlkZWEuICBCdXQgSSB3b25kZXIgaG93IHVzZXJzIGtub3cgaWYgaXQg
aXMKPj4+IE9LIHRvIHNldCB0aGlzIGZsYWcgYXMgaXQgcmVsaWVzIG9uIEJJT1MgaW1wbGVtZW50
YXRpb24gdGhhdCBpcyBub3QKPj4+IGRlc2NyaWJlZCBpbiBBQ1BJLi4uCj4+Cj4+IFVnaCwgeW91
J3JlIHJpZ2h0LiBXZSBtaWdodCBuZWVkIGEgcmV2aXNpb24taWQ9MiB2ZXJzaW9uIG9mIFN0YXJ0
IEFSUwo+PiBzbyBzb2Z0d2FyZSBrbm93cyB0aGF0IHRoZSBCSU9TIGlzIGF3YXJlIG9mIHRoZSBu
ZXcgZmxhZy4KPgo+IE15IGJhZC4gIExvb2tpbmcgYXQgQUNQSSA2LjIsIGl0IGFjdHVhbGx5IGRl
ZmluZXMgd2hhdCB5b3UgZGVzY3JpYmVkLgo+IFN0YXJ0IEFSUyBub3cgZGVmaW5lcyBiaXRbMV0g
aW4gRmxhZ3Mgd2hpY2ggY2FuIGJlIHNldCB0byBhdm9pZAo+IHNjYW5uaW5nIGZvciB0aGlzIG5v
dGlmaWNhdGlvbi4gIEkgd2lsbCB1cGRhdGUgdGhlIHBhdGNoIHRvIHNldCB0aGlzCj4gZmxhZyB3
aGVuIEhXX0VSUk9SX1NDUlVCX09OIGlzIG5vdCBzZXQuCgpXYXNuJ3QgRGFuIGNvbmNlcm5lZCBh
Ym91dCBob3cgdGhlIE9TIGNhbiBrbm93IHdoZXRoZXIgdGhlIEZXIHN1cHBvcnRzCnRoYXQgYml0
IGluIHRoZSBTdGFydCBBUlM/CgpUaGUgUXVlcnkgQVJTIENhcGFiaWxpdGllcyBEU00gaGFzIGEg
Yml0IHRoYXQgdGVsbHMgdGhlIE9TIHdoZXRoZXIgdGhlCnBsYXRmb3JtIHN1cHBvcnRzIHRoZSBu
b3RpZmljYXRpb24gYW5kIHRoZSBwb2ludCBvZiB0aGUgbm90aWZpY2F0aW9uIHdhcwp0byB0ZWxs
IHRoZSBPUyBpdCBjb3VsZCBkbyBhIFN0YXJ0IEFSUyB3aXRoIGJpdCAxIHNldC4gIE9mIGNvdXJz
ZSwgaWYKeW91IGdldCB0aGUgbm90aWZpY2F0aW9uIHRoZW4gdGhhdCBtZWFucyB0aGUgcGxhdGZv
cm0gaGFzIHRoZSBjYXBhYmlsaXR5CnRvIGRlbGl2ZXIgaXQsIGJ1dCBpdCBtaWdodCBub3QgaHVy
dCB0byBjaGVjayB0aGUgZmxhZyBmcm9tIHRoZSBRdWVyeQpDYXBhYmlsaXRpZXMgYml0LgoKSWYg
dGhlIHNwZWMgaXNuJ3QgY2xlYXIgYWJvdXQgdGhlIHJlbGF0aW9uc2hpcCBiZXR3ZWVuIHRoZSBi
aXRzLCB3ZSBjb3VsZApjbGFyaWZ5IHRoYXQgaW4gdGhlIHNwZWMgd2l0aG91dCBidW1waW5nIHRo
ZSByZXZpc2lvbiBudW1iZXIgZm9yIHRoZSBjYWxsLgoKV2UgY291bGQgYWxzbyBjaGVjayB0byBz
ZWUgd2hhdCBhIHBsYXRmb3JtIGRvZXMgaWYgaXQgZ2V0cyBhIGZsYWcgaXQKZG9lc24ndCBrbm93
IGFib3V0LiAgV291bGQgdGhhdCBiZSBhbiBJbnZhbGlkIElucHV0IFBhcmFtZXRlcj8KCi0tIGxq
awo+Cj4gVGhhbmtzLAo+IC1Ub3NoaRPvv73vv73subsc77+9Ju+/vX7vv70m77+9GO+/ve+/vSst
77+977+93bYX77+977+9d++/ve+/vcub77+977+977+9be+/vWLvv73vv71acu+/ve+/ve+/ve+/
vV5u77+9cu+/ve+/ve+/vXrvv70a77+977+9aO+/ve+/ve+/ve+/vSbvv73vv70e77+9R++/ve+/
ve+/vWjvv70DKO+/vemaju+/vd2iaiLvv73vv70a77+9G23vv73vv73vv73vv73vv71677+93pbv
v73vv73vv71m77+977+977+9aO+/ve+/ve+/vX7vv71t77+9Cj4KX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApM
aW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlz
dGluZm8vbGludXgtbnZkaW1tCg==
