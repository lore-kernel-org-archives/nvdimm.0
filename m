Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail2-relais-roc.national.inria.fr
 (mail2-relais-roc.national.inria.fr [192.134.164.83])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AB521202E53BC
 for <linux-nvdimm@lists.01.org>; Wed, 13 Feb 2019 00:43:22 -0800 (PST)
Subject: Re: [PATCH 5/5] dax: "Hotplug" persistent memory for use like normal
 RAM
References: <20190124231441.37A4A305@viggo.jf.intel.com>
 <20190124231448.E102D18E@viggo.jf.intel.com>
 <c4c6aca8-6ee8-be10-65ae-4cbe0aa03bfb@inria.fr>
 <26ac36f4-7391-5321-217b-50d67e2119d7@intel.com>
 <453f13cd-a7fe-33eb-9a27-8490825ca29c@inria.fr>
 <CAPcyv4jF7ZyKaFDw7nb04UvWkVWGJdLGkZDQ1g=X7i+kdu7JRg@mail.gmail.com>
 <a3bfe739-228e-26fe-90f7-4a4f8ceb3a9a@inria.fr>
 <CAPcyv4jJ=C7ZEsJqBxzBMsQWz4+C8BZmWuk7OkztOebprd2rMg@mail.gmail.com>
From: Brice Goglin <Brice.Goglin@inria.fr>
Message-ID: <057ad938-e745-02f7-edce-e19bd326da6a@inria.fr>
Date: Wed, 13 Feb 2019 09:43:20 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jJ=C7ZEsJqBxzBMsQWz4+C8BZmWuk7OkztOebprd2rMg@mail.gmail.com>
Content-Language: en-US
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
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Takashi Iwai <tiwai@suse.de>, "Huang, Ying  <ying.huang@intel.com>, Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Borislav Petkov <bp@suse.de>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

CkxlIDEzLzAyLzIwMTkgw6AgMDk6MjQsIERhbiBXaWxsaWFtcyBhIMOpY3JpdMKgOgo+IE9uIFdl
ZCwgRmViIDEzLCAyMDE5IGF0IDEyOjEyIEFNIEJyaWNlIEdvZ2xpbiA8QnJpY2UuR29nbGluQGlu
cmlhLmZyPiB3cm90ZToKPj4gTGUgMTMvMDIvMjAxOSDDoCAwMTozMCwgRGFuIFdpbGxpYW1zIGEg
w6ljcml0IDoKPj4+IE9uIFR1ZSwgRmViIDEyLCAyMDE5IGF0IDExOjU5IEFNIEJyaWNlIEdvZ2xp
biA8QnJpY2UuR29nbGluQGlucmlhLmZyPiB3cm90ZToKPj4+PiAjIG5kY3RsIGRpc2FibGUtcmVn
aW9uIGFsbAo+Pj4+ICMgbmRjdGwgemVyby1sYWJlbHMgYWxsCj4+Pj4gIyBuZGN0bCBlbmFibGUt
cmVnaW9uIHJlZ2lvbjAKPj4+PiAjIG5kY3RsIGNyZWF0ZS1uYW1lc3BhY2UgLXIgcmVnaW9uMCAt
dCBwbWVtIC1tIGRldmRheAo+Pj4+IHsKPj4+PiAgICJkZXYiOiJuYW1lc3BhY2UwLjAiLAo+Pj4+
ICAgIm1vZGUiOiJkZXZkYXgiLAo+Pj4+ICAgIm1hcCI6ImRldiIsCj4+Pj4gICAic2l6ZSI6IjE0
ODguMzcgR2lCICgxNTk4LjEzIEdCKSIsCj4+Pj4gICAidXVpZCI6ImFkMDA5NmQ3LTNmZTctNDQw
Mi1iNTI5LWFkNjRlZDBiZjc4OSIsCj4+Pj4gICAiZGF4cmVnaW9uIjp7Cj4+Pj4gICAgICJpZCI6
MCwKPj4+PiAgICAgInNpemUiOiIxNDg4LjM3IEdpQiAoMTU5OC4xMyBHQikiLAo+Pj4+ICAgICAi
YWxpZ24iOjIwOTcxNTIsCj4+Pj4gICAgICJkZXZpY2VzIjpbCj4+Pj4gICAgICAgewo+Pj4+ICAg
ICAgICAgImNoYXJkZXYiOiJkYXgwLjAiLAo+Pj4+ICAgICAgICAgInNpemUiOiIxNDg4LjM3IEdp
QiAoMTU5OC4xMyBHQikiCj4+Pj4gICAgICAgfQo+Pj4+ICAgICBdCj4+Pj4gICB9LAo+Pj4+ICAg
ImFsaWduIjoyMDk3MTUyCj4+Pj4gfQo+Pj4+ICMgbmRjdGwgZW5hYmxlLW5hbWVzcGFjZSBuYW1l
c3BhY2UwLjAKPj4+PiAjIGVjaG8gLW4gZGF4MC4wID4gL3N5cy9idXMvZGF4L2RyaXZlcnMvZGV2
aWNlX2RheC9yZW1vdmVfaWQKPj4+PiA8aGFuZz4KPj4+Pgo+Pj4+IEkgdHJpZWQgd2l0aCBhbmQg
d2l0aG91dCBkYXhfcG1lbV9jb21wYXQgbG9hZGVkLCBidXQgaXQgZG9lc24ndCBoZWxwLgo+Pj4g
SSB0aGluayB0aGlzIGlzIGR1ZSB0bzoKPj4+Cj4+PiAgIGE5ZjFmZmRiNmEyMCBkZXZpY2UtZGF4
OiBBdXRvLWJpbmQgZGV2aWNlIGFmdGVyIHN1Y2Nlc3NmdWwgbmV3X2lkCj4+Pgo+Pj4gSSBtaXNz
ZWQgdGhhdCB0aGlzIHBhdGggaXMgYWxzbyBjYWxsZWQgaW4gdGhlIHJlbW92ZV9pZCBwYXRoLiBU
aGFua3MKPj4+IGZvciB0aGUgYnVnIHJlcG9ydCEgSSdsbCBnZXQgdGhpcyBmaXhlZCB1cC4KPj4K
Pj4gTm93IHRoYXQgcmVtb3ZlX2lkIGlzIGZpeGVkLCB0aGluZ3MgZmFpbHMgbGF0ZXIgaW4gRGF2
ZSdzIHByb2NlZHVyZToKPj4KPj4gIyBlY2hvIC1uIGRheDAuMCA+IC9zeXMvYnVzL2RheC9kcml2
ZXJzL2RldmljZV9kYXgvcmVtb3ZlX2lkCj4+ICMgZWNobyAtbiBkYXgwLjAgPiAvc3lzL2J1cy9k
YXgvZHJpdmVycy9kZXZpY2VfZGF4L3VuYmluZAo+PiAjIGVjaG8gLW4gZGF4MC4wID4gL3N5cy9i
dXMvZGF4L2RyaXZlcnMva21lbS9uZXdfaWQKPiBJbiB0aGUgY3VycmVudCB2ZXJzaW9uIG9mIHRo
ZSBjb2RlIHRoZSBiaW5kIGlzIG5vdCBuZWNlc3NhcnksIHNvIHRoZQo+IGxhY2sgb2YgZXJyb3Ig
bWVzc2FnZXMgaGVyZSBtZWFucyB0aGUgYmluZCBzdWNjZWVkZWQuCj4KPj4gIyBlY2hvIC1uIGRh
eDAuMCA+IC9zeXMvYnVzL2RheC9kcml2ZXJzL2ttZW0vYmluZAo+PiAtYmFzaDogZWNobzogd3Jp
dGUgZXJyb3I6IE5vIHN1Y2ggZGV2aWNlCj4gVGhpcyBhbHNvIGhhcHBlbnMgd2hlbiB0aGUgZGV2
aWNlIGlzIGFscmVhZHkgYm91bmQuCj4KPj4gKEFuZCBub3RoaW5nIHNlZW1zIHRvIGhhdmUgY2hh
bmdlZCBpbiAvc3lzL2RldmljZXMvc3lzdGVtL21lbW9yeS8qL3N0YXRlKQo+IFdoYXQgZG9lcyAi
Y2F0IC9wcm9jL2lvbWVtIiBzYXk/CgoKMzA2MDAwMDAwMC0xYWE1ZmZmZmZmZiA6IFBlcnNpc3Rl
bnQgTWVtb3J5CsKgIDMwNjAwMDAwMDAtMzY0ODFmZmZmZiA6IG5hbWVzcGFjZTAuMArCoCAzNjgw
MDAwMDAwLTFhOWZmZmZmZmZmIDogZGF4MC4wCsKgwqDCoCAzNjgwMDAwMDAwLTFhOWZmZmZmZmZm
IDogU3lzdGVtIFJBTQoodGhlIGxhc3QgbGluZSB3YXNuJ3QgaGVyZSBiZWZvcmUgYXR0YWNoaW5n
IHRvIGttZW0pCgpJIHNhaWQgbm90aGluZyBjaGFuZ2VkIGluIG1lbW9yeS8qL3N0YXRlLCBJIGFj
dHVhbGx5IG1lYW50IHRoYXQgbm90aGluZwp3YXMgb2ZmbGluZS4gQnV0IHRoaW5ncyBhcmUgYWN0
dWFsbHkgd29ya2luZyEKCkZpcnN0LCBub2RlNCBhcHBlYXJlZCwgYWxsIG1lbW9yeSBpcyBhbHJl
YWR5IGF0dGFjaGVkIHRvIGl0IHdpdGhvdXQKaGF2aW5nIHRvIHdyaXRlIHRvIG1lbW9yeS8qL3N0
YXRlCgpOb2RlIDQgTWVtVG90YWw6wqDCoMKgwqDCoMKgIDE1NTgxODM5MzYga0IKTm9kZSA0IE1l
bUZyZWU6wqDCoMKgwqDCoMKgwqAgMTU1ODA2ODU2NCBrQgpOb2RlIDQgTWVtVXNlZDrCoMKgwqDC
oMKgwqDCoMKgwqAgMTE1MzcyIGtCCgpJIHdhc24ndCBleHBlY3Rpbmcgbm9kZTQgdG8gYXBwZWFy
IGJlY2F1c2UgdGhlIG1hY2hpbmUgaGFzIG5vCi9zeXMvZmlybXdhcmUvYWNwaS90YWJsZXMvSE1B
VCB3aGVuIHJ1bm5pbmcgaW4gMUxNICh0aGVyZSdzIG9uZSBpbiAyTE0pLgpJIHRob3VnaHQgeW91
IHNhaWQgaW4gdGhlIHBhc3QgdGhhdCBubyBITUFUIHdvdWxkIG1lYW4gbWVtb3J5IHdvdWxkIGJl
CmFkZGVkIHRvIHRoZSBleGlzdGluZyBERFIgbm9kZT8KClRoYW5rcyEKCkJyaWNlCgoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1h
aWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3Jn
L21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
