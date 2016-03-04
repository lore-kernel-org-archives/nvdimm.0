Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx-out03.mykolab.com (mx01.mykolab.com [95.128.36.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0535D1A1ED4
 for <linux-nvdimm@lists.01.org>; Thu,  3 Mar 2016 20:28:06 -0800 (PST)
Message-ID: <1457065669.17916.1.camel@stellar.sh>
Subject: Re: [PATCH v2] nfit: Continue init even if ARS commands are
 unimplemented
From: Vishal Verma <vishal@stellar.sh>
Date: Thu, 03 Mar 2016 21:27:49 -0700
In-Reply-To: <20160304033451.GA6267@hz-desktop.sh.intel.com>
References: <1457044781-15443-1-git-send-email-vishal.l.verma@intel.com>
 <56D900EA.2060802@linux.intel.com>
 <20160304033451.GA6267@hz-desktop.sh.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Zhang, Haozhong" <haozhong.zhang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE2LTAzLTA0IGF0IDExOjM0ICswODAwLCBaaGFuZywgSGFvemhvbmcgd3JvdGU6
Cj4gT24gMDMvMDQvMTYgMTE6MjgsIFhpYW8gR3Vhbmdyb25nIHdyb3RlOgo+ID4gCj4gPiAKPiA+
IENDZWQ6IEhhb3pob25nLgo+ID4gCj4gPiBPbiAwMy8wNC8yMDE2IDA2OjM5IEFNLCBWaXNoYWwg
VmVybWEgd3JvdGU6Cj4gPiA+IAo+ID4gPiBJZiBmaXJtd2FyZSBkb2Vzbid0IGltcGxlbWVudCBh
bnkgb2YgdGhlIEFSUyBjb21tYW5kcywgdGFrZSB0aGF0Cj4gPiA+IHRvCj4gPiA+IG1lYW4gdGhh
dCBBUlMgaXMgdW5zdXBwb3J0ZWQsIGFuZCBjb250aW51ZSB0byBpbml0aWFsaXplIHJlZ2lvbnMK
PiA+ID4gd2l0aG91dAo+ID4gPiBiYWQgYmxvY2sgbGlzdHMuIFdlIGNhbm5vdCBtYWtlIHRoZSBh
c3N1bXB0aW9uIHRoYXQgQVJTIGNvbW1hbmRzCj4gPiA+IHdpbGwgYmUKPiA+ID4gdW5jb25kaXRp
b25hbGx5IHN1cHBvcnRlZCBvbiBhbGwgTlZESU1Ncy4KPiA+ID4gCj4gPiA+IENjOiBEYW4gV2ls
bGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4KPiA+ID4gUmVwb3J0ZWQtYnk6IFhpYW8g
R3Vhbmdyb25nIDxndWFuZ3JvbmcueGlhb0BsaW51eC5pbnRlbC5jb20+Cj4gPiBUaGFuayB5b3Ug
Zm9yIHRoZSBmaXgsIFZpc2hhbCEgaXQgbG9va3MgZ29vZCB0byBtZS4KPiA+IAo+ID4gSG93ZXZl
ciwgSXQgaXMgaGFvemhvbmcncyBjcmVkaXQgYXMgaGUgaXMgdGhlIG9uZSByZXBvcnRlZCB0aGUg
YnVnCj4gPiBub3QKPiA+IG1lLiA6KQo+ID4gCj4gVGhhbmtzISBJIGhhdmUgdGVzdGVkIG9uIFFF
TVUgd2hpY2ggaGFzIG5vdCBpbXBsZW1lbnRlZCBBUlMgeWV0IGFuZAo+IHRoaXMgcGF0Y2ggZG9l
cyB3b3JrLgo+IAo+IFRlc3RlZC1ieTogSGFvemhvbmcgWmhhbmcgPGhhb3pob25nLnpoYW5nQGlu
dGVsLmNvbT4KClRoYW5rcywgYm90aCBIYW96aG9uZyBhbmTCoEd1YW5ncm9uZy4gRGFuLCBjYW4g
eW91IHBsZWFzZSBmaXh1cCB0aGUKUmVwb3J0ZWQtYnkgdGFnIHdoZW4geW91IGFwcGx5LgoKCS1W
aXNoYWwKCj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
PiBMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0Cj4gTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwo+
IGh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0g
bWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5v
cmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
