Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com
 [66.111.4.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CEE032120B104
 for <linux-nvdimm@lists.01.org>; Mon, 20 May 2019 13:25:53 -0700 (PDT)
From: Nikolaus Rath <Nikolaus@rath.org>
Subject: Re: [PATCH v2 02/30] fuse: Clear setuid bit even in cache=never path
References: <20190515192715.18000-1-vgoyal@redhat.com>
 <20190515192715.18000-3-vgoyal@redhat.com>
 <20190520144137.GA24093@localhost.localdomain>
 <20190520144437.GB24093@localhost.localdomain>
Date: Mon, 20 May 2019 21:25:49 +0100
In-Reply-To: <20190520144437.GB24093@localhost.localdomain> (Miklos Szeredi's
 message of "Mon, 20 May 2019 16:44:37 +0200")
Message-ID: <87k1ekub3m.fsf@vostro.rath.org>
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
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: kvm@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, dgilbert@redhat.com, stefanha@redhat.com, linux-fsdevel@vger.kernel.org, swhiteho@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

T24gTWF5IDIwIDIwMTksIE1pa2xvcyBTemVyZWRpIDxtaWtsb3NAc3plcmVkaS5odT4gd3JvdGU6
Cj4gT24gTW9uLCBNYXkgMjAsIDIwMTkgYXQgMDQ6NDE6MzdQTSArMDIwMCwgTWlrbG9zIFN6ZXJl
ZGkgd3JvdGU6Cj4+IE9uIFdlZCwgTWF5IDE1LCAyMDE5IGF0IDAzOjI2OjQ3UE0gLTA0MDAsIFZp
dmVrIEdveWFsIHdyb3RlOgo+PiA+IElmIGZ1c2UgZGFlbW9uIGlzIHN0YXJ0ZWQgd2l0aCBjYWNo
ZT1uZXZlciwgZnVzZSBmYWxscyBiYWNrIHRvIGRpcmVjdCBJTy4KPj4gPiBJbiB0aGF0IHdyaXRl
IHBhdGggd2UgZG9uJ3QgY2FsbCBmaWxlX3JlbW92ZV9wcml2cygpIGFuZCB0aGF0IG1lYW5zIHNl
dHVpZAo+PiA+IGJpdCBpcyBub3QgY2xlYXJlZCBpZiB1bnByaXZpbGlnZWQgdXNlciB3cml0ZXMg
dG8gYSBmaWxlIHdpdGggc2V0dWlkIGJpdCBzZXQuCj4+ID4gCj4+ID4gcGpkZnN0ZXN0IGNobW9k
IHRlc3QgMTIudCB0ZXN0cyB0aGlzIGFuZCBmYWlscy4KPj4gCj4+IEkgdGhpbmsgYmV0dGVyIHN1
bHV0aW9uIGlzIHRvIHRlbGwgdGhlIHNlcnZlciBpZiB0aGUgc3VpZCBiaXQgbmVlZHMgdG8gYmUK
Pj4gcmVtb3ZlZCwgc28gaXQgY2FuIGRvIHNvIGluIGEgcmFjZSBmcmVlIHdheS4KPj4gCj4+IEhl
cmUncyB0aGUga2VybmVsIHBhdGNoLCBhbmQgSSdsbCByZXBseSB3aXRoIHRoZSBsaWJmdXNlIHBh
dGNoLgo+Cj4gSGVyZSBhcmUgdGhlIHBhdGNoZXMgZm9yIGxpYmZ1c2UgYW5kIHBhc3N0aHJvdWdo
X2xsLgoKQ291bGQgeW91IGFsc28gc3VibWl0IHRoZW0gYXMgcHVsbCByZXF1ZXN0cyBhdCBodHRw
czovL2dpdGh1Yi5jb20vbGliZnVzZS9saWJmdXNlL3B1bGxzPwoKQmVzdCwKLU5pa29sYXVzCgot
LSAKR1BHIEZpbmdlcnByaW50OiBFRDMxIDc5MUIgMkM1QyAxNjEzIEFGMzggOEI4QSBEMTEzIEZD
QUMgM0M0RSA1OTlGCgogICAgICAgICAgICAgwrtUaW1lIGZsaWVzIGxpa2UgYW4gYXJyb3csIGZy
dWl0IGZsaWVzIGxpa2UgYSBCYW5hbmEuwqsKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1A
bGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgt
bnZkaW1tCg==
