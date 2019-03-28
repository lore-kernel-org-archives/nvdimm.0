Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from Galois.linutronix.de (Galois.linutronix.de
 [IPv6:2a01:7a0:2:106d:700::1])
 (using TLSv1.2 with cipher AES128-SHA (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 95439211E9595
 for <linux-nvdimm@lists.01.org>; Thu, 28 Mar 2019 10:39:22 -0700 (PDT)
Date: Thu, 28 Mar 2019 18:38:59 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH RT] nvdimm: make lane acquirement RT aware
Message-ID: <20190328173858.hpbtoep42ucomav2@linutronix.de>
References: <20190306095709.23138-1-yongxin.liu@windriver.com>
 <20190307143344.ytsnbmot5tjzjhip@linutronix.de>
 <597B109EC20B76429F71A8A97770610D12A52669@ALA-MBD.corp.ad.wrs.com>
 <20190308094131.ge4wbsvz4p6xikdf@linutronix.de>
 <597B109EC20B76429F71A8A97770610D12A5643B@ALA-MBD.corp.ad.wrs.com>
 <20190315164236.rzbwe7reeprjv3um@linutronix.de>
 <597B109EC20B76429F71A8A97770610D12A63C81@ALA-MBD.corp.ad.wrs.com>
 <20190318114017.tazjaegln2obt3zg@linutronix.de>
 <597B109EC20B76429F71A8A97770610D12A649C1@ALA-MBD.corp.ad.wrs.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <597B109EC20B76429F71A8A97770610D12A649C1@ALA-MBD.corp.ad.wrs.com>
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
To: "Liu, Yongxin" <Yongxin.Liu@windriver.com>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "Gortmaker, Paul  <Paul.Gortmaker@windriver.com>, tglx@linutronix.de" <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

T24gMjAxOS0wMy0xOCAxMTo0ODoyOCBbKzAwMDBdLCBMaXUsIFlvbmd4aW4gd3JvdGU6Cj4gCj4g
PiAKPiA+IEJ1bW1lci4gVGhhdCB3b3VsZCBkZWFkIGxvY2sgaW5kZWVkLgo+ID4gSXMgaXQgZWFz
aWx5IHBvc3NpYmxlIHRvIHJlY29nbml6ZSB0aGUgcmVjdXJzaXZlIGNhc2U/Cj4gCj4gTm90IGVh
c2lseS4gSSBkb24ndCBoYXZlIHRlc3QgY2FzZSBmb3IgcmVjdXJzaXZlIGNhbGwuIAo+IEZvciBu
b3csIGp1c3QgY29kZSBhbmFseXNpcy4KClNvIEkndmUgYmVlbiBwbGF5aW5nIHdpdGggcWVtdSdz
IG52ZGltbSBkZXZpY2UuIFNvIEkgKnRoaW5rKiB0aGUKcmVjdXJzaXZlIGNhc2UgaXMgaGVyZSBu
b3QgcG9zc2libGUgYmVjYXVzZSBxZW11IG9ubHkgc3VwcG9ydHMgcG1lbQp3aGlsZSBpdCB3b3Vs
ZCByZXF1aXJlIHRoZSBibGsgbW9kZSB0byB0cmlnZ2VyIGl0LiBJdCBpcyBqdXN0IGEgd2lsZApn
dWVzc+KApgoKT24gdG9wIG9mIHFlbXUncyBudmRpbW0gZGV2aWNlIEkgY2FuIGNyZWF0ZSBhIGJs
b2NrIGRldmljZSB2aWEKCW5kY3RsIGNyZWF0ZS1uYW1lc3BhY2UgIG5hbWVzcGFjZTAuMCAtLW1v
ZGU9c2VjdG9yCgphbmQgdGhlbiBJIHRyaWdnZXIgdGhlIGNvZGUgcGF0aCBpbiBxdWVzdGlvbi4K
Ckkgd291bGQgKnJlYWxseSogcHJlZmVyIHRvIHVuZGVyc3RhbmQgdGhlIHJlY3Vyc2l2ZSBjYXNl
IGFuZCBhdm9pZCBpdC4KVGhhdCB3YXkgdGhlIHJlY3Vyc2l2ZSBjYXNlIGlzIGV4cGxpY2l0bHkg
a25vd24gYW5kIHVzZXMgYW5vdGhlciBwYXRoLgpUaGUgbG9jayBjYW4gdGhlbiBiZSBhbHdheXMg
YWNxdWlyZWQgd2hpY2ggZ2l2ZXMgeW91IGFsd2F5cyBsb2NrZGVwCmNvdmVyYWdlICh3aGljaCBp
cyBub3cgbWlzc2luZyB1bmxlc3MgeW91IGhhdmUgbW9yZSBMQU5FcyB0aGFuIENQVXMpLgoKVGhl
IGxvY2FsX2xvY2sgdGhpbmd5IGlzIGNvbXBsZXRlbHkgdW5uZWVkZWQ6IGEgc2ltcGxlIGdldF9j
cHVfbGlnaHQoKQp3b3VsZCBkbyB0aGUgam9iLgoKPiBZb25neGluCgpTZWJhc3RpYW4KX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1h
aWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3Jn
L21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
