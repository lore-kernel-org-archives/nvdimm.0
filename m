Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x241.google.com (mail-qt0-x241.google.com
 [IPv6:2607:f8b0:400d:c0d::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BB83520958969
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 19:51:34 -0700 (PDT)
Received: by mail-qt0-x241.google.com with SMTP id c20so963458qte.0
 for <linux-nvdimm@lists.01.org>; Wed, 05 Jul 2017 19:53:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170706021118.GA14468@lst.de>
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
 <20170706021118.GA14468@lst.de>
From: Oliver <oohall@gmail.com>
Date: Thu, 6 Jul 2017 12:53:13 +1000
Message-ID: <CAOSf1CHFsYFuTTKVQahbBoNrEq7Oo3=iigEzBaQviRgDrmEg3w@mail.gmail.com>
Subject: Re: [PATCH v4 12/16] libnvdimm,
 nfit: enable support for volatile ranges
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
To: "hch@lst.de" <hch@lst.de>
Cc: "jack@suse.cz" <jack@suse.cz>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCBKdWwgNiwgMjAxNyBhdCAxMjoxMSBQTSwgaGNoQGxzdC5kZSA8aGNoQGxzdC5kZT4g
d3JvdGU6Cj4gT24gV2VkLCBKdWwgMDUsIDIwMTcgYXQgMDc6MDg6NTRQTSAtMDcwMCwgRGFuIFdp
bGxpYW1zIHdyb3RlOgo+PiBbIGFkZGluZyBKZWZmLCBhbmQgSm9oYW5uZXMgXQo+Pgo+PiBPbiBX
ZWQsIEp1bCA1LCAyMDE3IGF0IDY6MTcgUE0sIEthbmksIFRvc2hpbWl0c3UgPHRvc2hpLmthbmlA
aHBlLmNvbT4gd3JvdGU6Cj4+ID4gT24gV2VkLCAyMDE3LTA3LTA1IGF0IDE3OjA3IC0wNzAwLCBE
YW4gV2lsbGlhbXMgd3JvdGU6Cj4+IFsuLl0KPj4gPj4gV2UgaGF2ZSBzeW1saW5rcyBpbiAvZGV2
L2Rpc2svYnkqIHRvIG1ha2UgaXQgZWFzaWVyIHRvIGlkZW50aWZ5Cj4+ID4+IHN0b3JhZ2UgZGV2
aWNlcywgSSB0aGluayBpdCBtYWtlcyBzZW5zZSB0byBhZGQgdWRldiBydWxlcyBmb3IKPj4gPj4g
aWRlbnRpZnlpbmcgdm9sYXRpbGUgcG1lbSBhbmQgbm90IHRyeSB0byBkaWZmZXJlbnRpYXRlIHRo
aXMgaW4gdGhlCj4+ID4+IGRlZmF1bHQga2VybmVsIGRldmljZSBuYW1lLgo+PiA+Cj4+ID4gSSBh
bSBub3Qgc3VyZSB3aGF0IG1pZ2h0IGJlIGEgZ29vZCB3YXksIGJ1dCBJIGFtIGNvbmNlcm5lZCBi
ZWNhdXNlIGEKPj4gPiBzaW5nbGUgYmxvY2sgZGV2aWNlIG5hbWluZyBkbyBub3QgcmVwcmVzZW50
IGJvdGggdm9sYXRpbGUgYW5kCj4+ID4gcGVyc2lzdGVudCBtZWRpYSB0b2RheS4KPj4KPj4gV2Ug
ZG8gaGF2ZSB0aW1lIHRvIGNoYW5nZXMgdGhpcyBpZiB3ZSBmaW5kIG91dCB0aGlzIGlzIGNyaXRp
Y2FsLiBNYXliZQo+PiBpdCdzIGJlc3QgdG8gYXNrIExpbnV4IGRpc3RybyBmb2xrcyB3aGF0IHdv
dWxkIGJlIGVhc2llciBmb3IgdGhlbT8KPgo+IEknbSBub3QgcmVhbGx5IGNvbmNlcm5lZCBhYm91
dCBpdCwgYmVjYXVzZSBTQ1NJIGRldmljZXMgZm9yIGV4YW1wbGUKPiBtaWdodCBub3QgYmUgcGVy
c2lzdGVudCBhcyB3ZWxsIHdpdGgg0ZVjc2lfZGVidWcsIHRhcmdldF9jb3JlX3JkIG9yCj4gdm9s
YXRpbGUgcWVtdSBkZXZpY2VzLgo+Cj4gVGhhdCBiZWluZyBzYWlkIEkgcmVhbGx5IGRvbid0IHVu
ZGVyc3RhbmQgdGhlIHB1cnBvc2Ugb2YgdGhlc2Ugdm9sYXRpbGUKPiBuZml0IHJhbmdlcy4gIEFy
ZSB0aGV5IHNlZW4gaW4gdGhlIHdpbGQ/ICBJZiB5ZXMgd2hhdCdzIHRoZSB1c2UgY2FzZT8KPiBJ
ZiBub3Qgd2h5IGRvIHdlIGV2ZW4gbmVlZCB0byBzdXBwb3J0IHRoZW0/CgpUaGUgbWFpbiB1c2Ug
Y2FzZSBpcyBwcm92aXNpb25pbmcgaW5zdGFsbCBtZWRpYSBmb3IgYmFyZSBtZXRhbApzZXJ2ZXJz
LiBUcmFkaXRpb25hbGx5IHRoYXQncyBiZWVuIGhhbmRsZWQgYnkgaGF2aW5nIHRoZSBCTUMgZW11
bGF0ZSBhClVTQiBDRCBkcml2ZS4gVW5mb3J0dW5hdGVseSwgbW9zdCBCTUNzIGhhdmUgbGltaXRl
ZCBDUFUsIGxpbWl0ZWQKbWVtb3J5IGFuZCBhIHdldC1zdHJpbmcgbmV0d29yayBjb25uZWN0aW9u
IHNvIGEgaG9zdCBiYXNlZCBhbHRlcm5hdGl2ZQppcyBuaWNlIHRvIGhhdmUuCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5n
IGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWls
bWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
