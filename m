Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 695A820958985
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 19:09:40 -0700 (PDT)
Date: Thu, 6 Jul 2017 04:11:18 +0200
From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH v4 12/16] libnvdimm, nfit: enable support for volatile
 ranges
Message-ID: <20170706021118.GA14468@lst.de>
References: <595580A6.9000004@hpe.com>
 <CAPcyv4gtTYEUELPtr9mi5QkGL+cm=jcFR-Oe07OCuNM9izh6jA@mail.gmail.com>
 <d545a1ea-0199-7462-58c5-067cdc22cacc@hpe.com>
 <CAPcyv4gnkpWXJ7jOJ7r0kWLKoLfuqJzdHTjANBUPztyTWUrOjA@mail.gmail.com>
 <595589CF.5010605@hpe.com>
 <CAPcyv4iTaXc92ggQcBnqJ=P0jsMF9HhnV4nAsr1Qos4pjrRDLA@mail.gmail.com>
 <1499297819.2042.5.camel@hpe.com>
 <CAPcyv4ixQFNT_8tGFyf2ABqxpPd-jmtXKVeLBRdzBW12u3TJbg@mail.gmail.com>
 <1499303324.2042.7.camel@hpe.com>
 <CAPcyv4gL25svXg=7dmftmxMoqd7Fns_JV1WsGx_iFXRGBJT-CA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gL25svXg=7dmftmxMoqd7Fns_JV1WsGx_iFXRGBJT-CA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCBKdWwgMDUsIDIwMTcgYXQgMDc6MDg6NTRQTSAtMDcwMCwgRGFuIFdpbGxpYW1zIHdy
b3RlOgo+IFsgYWRkaW5nIEplZmYsIGFuZCBKb2hhbm5lcyBdCj4gCj4gT24gV2VkLCBKdWwgNSwg
MjAxNyBhdCA2OjE3IFBNLCBLYW5pLCBUb3NoaW1pdHN1IDx0b3NoaS5rYW5pQGhwZS5jb20+IHdy
b3RlOgo+ID4gT24gV2VkLCAyMDE3LTA3LTA1IGF0IDE3OjA3IC0wNzAwLCBEYW4gV2lsbGlhbXMg
d3JvdGU6Cj4gWy4uXQo+ID4+IFdlIGhhdmUgc3ltbGlua3MgaW4gL2Rldi9kaXNrL2J5KiB0byBt
YWtlIGl0IGVhc2llciB0byBpZGVudGlmeQo+ID4+IHN0b3JhZ2UgZGV2aWNlcywgSSB0aGluayBp
dCBtYWtlcyBzZW5zZSB0byBhZGQgdWRldiBydWxlcyBmb3IKPiA+PiBpZGVudGlmeWluZyB2b2xh
dGlsZSBwbWVtIGFuZCBub3QgdHJ5IHRvIGRpZmZlcmVudGlhdGUgdGhpcyBpbiB0aGUKPiA+PiBk
ZWZhdWx0IGtlcm5lbCBkZXZpY2UgbmFtZS4KPiA+Cj4gPiBJIGFtIG5vdCBzdXJlIHdoYXQgbWln
aHQgYmUgYSBnb29kIHdheSwgYnV0IEkgYW0gY29uY2VybmVkIGJlY2F1c2UgYQo+ID4gc2luZ2xl
IGJsb2NrIGRldmljZSBuYW1pbmcgZG8gbm90IHJlcHJlc2VudCBib3RoIHZvbGF0aWxlIGFuZAo+
ID4gcGVyc2lzdGVudCBtZWRpYSB0b2RheS4KPiAKPiBXZSBkbyBoYXZlIHRpbWUgdG8gY2hhbmdl
cyB0aGlzIGlmIHdlIGZpbmQgb3V0IHRoaXMgaXMgY3JpdGljYWwuIE1heWJlCj4gaXQncyBiZXN0
IHRvIGFzayBMaW51eCBkaXN0cm8gZm9sa3Mgd2hhdCB3b3VsZCBiZSBlYXNpZXIgZm9yIHRoZW0/
CgpJJ20gbm90IHJlYWxseSBjb25jZXJuZWQgYWJvdXQgaXQsIGJlY2F1c2UgU0NTSSBkZXZpY2Vz
IGZvciBleGFtcGxlCm1pZ2h0IG5vdCBiZSBwZXJzaXN0ZW50IGFzIHdlbGwgd2l0aCDRlWNzaV9k
ZWJ1ZywgdGFyZ2V0X2NvcmVfcmQgb3IKdm9sYXRpbGUgcWVtdSBkZXZpY2VzLgoKVGhhdCBiZWlu
ZyBzYWlkIEkgcmVhbGx5IGRvbid0IHVuZGVyc3RhbmQgdGhlIHB1cnBvc2Ugb2YgdGhlc2Ugdm9s
YXRpbGUKbmZpdCByYW5nZXMuICBBcmUgdGhleSBzZWVuIGluIHRoZSB3aWxkPyAgSWYgeWVzIHdo
YXQncyB0aGUgdXNlIGNhc2U/CklmIG5vdCB3aHkgZG8gd2UgZXZlbiBuZWVkIHRvIHN1cHBvcnQg
dGhlbT8KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGlu
dXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8v
bGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
