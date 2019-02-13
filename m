Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E9F732194EB70
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 16:30:28 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id 98so1105470oty.1
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 16:30:28 -0800 (PST)
MIME-Version: 1.0
References: <20190124231441.37A4A305@viggo.jf.intel.com>
 <20190124231448.E102D18E@viggo.jf.intel.com>
 <c4c6aca8-6ee8-be10-65ae-4cbe0aa03bfb@inria.fr>
 <26ac36f4-7391-5321-217b-50d67e2119d7@intel.com>
 <453f13cd-a7fe-33eb-9a27-8490825ca29c@inria.fr>
In-Reply-To: <453f13cd-a7fe-33eb-9a27-8490825ca29c@inria.fr>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Feb 2019 16:30:17 -0800
Message-ID: <CAPcyv4jF7ZyKaFDw7nb04UvWkVWGJdLGkZDQ1g=X7i+kdu7JRg@mail.gmail.com>
Subject: Re: [PATCH 5/5] dax: "Hotplug" persistent memory for use like normal
 RAM
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
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Takashi Iwai <tiwai@suse.de>, "Huang, Ying  <ying.huang@intel.com>, Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Borislav Petkov <bp@suse.de>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCBGZWIgMTIsIDIwMTkgYXQgMTE6NTkgQU0gQnJpY2UgR29nbGluIDxCcmljZS5Hb2ds
aW5AaW5yaWEuZnI+IHdyb3RlOgo+Cj4gTGUgMTEvMDIvMjAxOSDDoCAxNzoyMiwgRGF2ZSBIYW5z
ZW4gYSDDqWNyaXQgOgo+Cj4gPiBPbiAyLzkvMTkgMzowMCBBTSwgQnJpY2UgR29nbGluIHdyb3Rl
Ogo+ID4+IEkndmUgdXNlZCB5b3VyIHBhdGNoZXMgb24gZmFrZSBoYXJkd2FyZSAobWVtbWFwPXh4
IXl5KSB3aXRoIGFuIG9sZGVyCj4gPj4gbnZkaW1tLXBlbmRpbmcgYnJhbmNoICh3aXRob3V0IEtl
aXRoJ3MgcGF0Y2hlcykuIEl0IHdvcmtlZCBmaW5lLiBUaGlzCj4gPj4gdGltZSBJIGFtIHJ1bm5p
bmcgb24gcmVhbCBJbnRlbCBoYXJkd2FyZS4gQW55IGlkZWEgd2hlcmUgdG8gbG9vayA/Cj4gPiBJ
J3ZlIHJ1biB0aGVtIG9uIHJlYWwgSW50ZWwgaGFyZHdhcmUgdG9vLgo+ID4KPiA+IENvdWxkIHlv
dSBzaGFyZSB0aGUgZXhhY3Qgc2VxdWVuY2Ugb2YgY29tbWFuZHMgeW91J3JlIGlzc3VpbmcgdG8K
PiA+IHJlcHJvZHVjZSB0aGUgaGFuZz8gIE15IGd1ZXNzIHdvdWxkIGJlIHRoYXQgdGhlcmUncyBz
b21lIG9kZCBpbnRlcmFjdGlvbgo+ID4gYmV0d2VlbiBEYW4ncyBsYXRlc3QgYnJhbmNoIGFuZCBt
eSBub3cgKHNsaWdodGx5KSBzdGFsZSBwYXRjaGVzLgo+ID4KPiA+IEknbGwgcmVmcmVzaCB0aGVt
IHRoaXMgd2VlayBhbmQgc2VlIGlmIEkgY2FuIHJlcHJvZHVjZSB3aGF0IHlvdSdyZSBzZWVpbmcu
Cj4KPiAjIG5kY3RsIGRpc2FibGUtcmVnaW9uIGFsbAo+ICMgbmRjdGwgemVyby1sYWJlbHMgYWxs
Cj4gIyBuZGN0bCBlbmFibGUtcmVnaW9uIHJlZ2lvbjAKPiAjIG5kY3RsIGNyZWF0ZS1uYW1lc3Bh
Y2UgLXIgcmVnaW9uMCAtdCBwbWVtIC1tIGRldmRheAo+IHsKPiAgICJkZXYiOiJuYW1lc3BhY2Uw
LjAiLAo+ICAgIm1vZGUiOiJkZXZkYXgiLAo+ICAgIm1hcCI6ImRldiIsCj4gICAic2l6ZSI6IjE0
ODguMzcgR2lCICgxNTk4LjEzIEdCKSIsCj4gICAidXVpZCI6ImFkMDA5NmQ3LTNmZTctNDQwMi1i
NTI5LWFkNjRlZDBiZjc4OSIsCj4gICAiZGF4cmVnaW9uIjp7Cj4gICAgICJpZCI6MCwKPiAgICAg
InNpemUiOiIxNDg4LjM3IEdpQiAoMTU5OC4xMyBHQikiLAo+ICAgICAiYWxpZ24iOjIwOTcxNTIs
Cj4gICAgICJkZXZpY2VzIjpbCj4gICAgICAgewo+ICAgICAgICAgImNoYXJkZXYiOiJkYXgwLjAi
LAo+ICAgICAgICAgInNpemUiOiIxNDg4LjM3IEdpQiAoMTU5OC4xMyBHQikiCj4gICAgICAgfQo+
ICAgICBdCj4gICB9LAo+ICAgImFsaWduIjoyMDk3MTUyCj4gfQo+ICMgbmRjdGwgZW5hYmxlLW5h
bWVzcGFjZSBuYW1lc3BhY2UwLjAKPiAjIGVjaG8gLW4gZGF4MC4wID4gL3N5cy9idXMvZGF4L2Ry
aXZlcnMvZGV2aWNlX2RheC9yZW1vdmVfaWQKPiA8aGFuZz4KPgo+IEkgdHJpZWQgd2l0aCBhbmQg
d2l0aG91dCBkYXhfcG1lbV9jb21wYXQgbG9hZGVkLCBidXQgaXQgZG9lc24ndCBoZWxwLgoKSSB0
aGluayB0aGlzIGlzIGR1ZSB0bzoKCiAgYTlmMWZmZGI2YTIwIGRldmljZS1kYXg6IEF1dG8tYmlu
ZCBkZXZpY2UgYWZ0ZXIgc3VjY2Vzc2Z1bCBuZXdfaWQKCkkgbWlzc2VkIHRoYXQgdGhpcyBwYXRo
IGlzIGFsc28gY2FsbGVkIGluIHRoZSByZW1vdmVfaWQgcGF0aC4gVGhhbmtzCmZvciB0aGUgYnVn
IHJlcG9ydCEgSSdsbCBnZXQgdGhpcyBmaXhlZCB1cC4KX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1u
dmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8v
bGludXgtbnZkaW1tCg==
