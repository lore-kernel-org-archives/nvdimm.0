Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail2-relais-roc.national.inria.fr
 (mail2-relais-roc.national.inria.fr [192.134.164.83])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C83D4201B0403
 for <linux-nvdimm@lists.01.org>; Wed, 13 Feb 2019 00:12:16 -0800 (PST)
Subject: Re: [PATCH 5/5] dax: "Hotplug" persistent memory for use like normal
 RAM
References: <20190124231441.37A4A305@viggo.jf.intel.com>
 <20190124231448.E102D18E@viggo.jf.intel.com>
 <c4c6aca8-6ee8-be10-65ae-4cbe0aa03bfb@inria.fr>
 <26ac36f4-7391-5321-217b-50d67e2119d7@intel.com>
 <453f13cd-a7fe-33eb-9a27-8490825ca29c@inria.fr>
 <CAPcyv4jF7ZyKaFDw7nb04UvWkVWGJdLGkZDQ1g=X7i+kdu7JRg@mail.gmail.com>
From: Brice Goglin <Brice.Goglin@inria.fr>
Message-ID: <a3bfe739-228e-26fe-90f7-4a4f8ceb3a9a@inria.fr>
Date: Wed, 13 Feb 2019 09:12:14 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jF7ZyKaFDw7nb04UvWkVWGJdLGkZDQ1g=X7i+kdu7JRg@mail.gmail.com>
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
To: Dave Hansen <dave.hansen@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Takashi Iwai <tiwai@suse.de>, "Huang, Ying  <ying.huang@intel.com>, Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Borislav Petkov <bp@suse.de>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Fengguang Wu <fengguang.wu@intel.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

TGUgMTMvMDIvMjAxOSDDoCAwMTozMCwgRGFuIFdpbGxpYW1zIGEgw6ljcml0wqA6Cj4gT24gVHVl
LCBGZWIgMTIsIDIwMTkgYXQgMTE6NTkgQU0gQnJpY2UgR29nbGluIDxCcmljZS5Hb2dsaW5AaW5y
aWEuZnI+IHdyb3RlOgo+PiAjIG5kY3RsIGRpc2FibGUtcmVnaW9uIGFsbAo+PiAjIG5kY3RsIHpl
cm8tbGFiZWxzIGFsbAo+PiAjIG5kY3RsIGVuYWJsZS1yZWdpb24gcmVnaW9uMAo+PiAjIG5kY3Rs
IGNyZWF0ZS1uYW1lc3BhY2UgLXIgcmVnaW9uMCAtdCBwbWVtIC1tIGRldmRheAo+PiB7Cj4+ICAg
ImRldiI6Im5hbWVzcGFjZTAuMCIsCj4+ICAgIm1vZGUiOiJkZXZkYXgiLAo+PiAgICJtYXAiOiJk
ZXYiLAo+PiAgICJzaXplIjoiMTQ4OC4zNyBHaUIgKDE1OTguMTMgR0IpIiwKPj4gICAidXVpZCI6
ImFkMDA5NmQ3LTNmZTctNDQwMi1iNTI5LWFkNjRlZDBiZjc4OSIsCj4+ICAgImRheHJlZ2lvbiI6
ewo+PiAgICAgImlkIjowLAo+PiAgICAgInNpemUiOiIxNDg4LjM3IEdpQiAoMTU5OC4xMyBHQiki
LAo+PiAgICAgImFsaWduIjoyMDk3MTUyLAo+PiAgICAgImRldmljZXMiOlsKPj4gICAgICAgewo+
PiAgICAgICAgICJjaGFyZGV2IjoiZGF4MC4wIiwKPj4gICAgICAgICAic2l6ZSI6IjE0ODguMzcg
R2lCICgxNTk4LjEzIEdCKSIKPj4gICAgICAgfQo+PiAgICAgXQo+PiAgIH0sCj4+ICAgImFsaWdu
IjoyMDk3MTUyCj4+IH0KPj4gIyBuZGN0bCBlbmFibGUtbmFtZXNwYWNlIG5hbWVzcGFjZTAuMAo+
PiAjIGVjaG8gLW4gZGF4MC4wID4gL3N5cy9idXMvZGF4L2RyaXZlcnMvZGV2aWNlX2RheC9yZW1v
dmVfaWQKPj4gPGhhbmc+Cj4+Cj4+IEkgdHJpZWQgd2l0aCBhbmQgd2l0aG91dCBkYXhfcG1lbV9j
b21wYXQgbG9hZGVkLCBidXQgaXQgZG9lc24ndCBoZWxwLgo+IEkgdGhpbmsgdGhpcyBpcyBkdWUg
dG86Cj4KPiAgIGE5ZjFmZmRiNmEyMCBkZXZpY2UtZGF4OiBBdXRvLWJpbmQgZGV2aWNlIGFmdGVy
IHN1Y2Nlc3NmdWwgbmV3X2lkCj4KPiBJIG1pc3NlZCB0aGF0IHRoaXMgcGF0aCBpcyBhbHNvIGNh
bGxlZCBpbiB0aGUgcmVtb3ZlX2lkIHBhdGguIFRoYW5rcwo+IGZvciB0aGUgYnVnIHJlcG9ydCEg
SSdsbCBnZXQgdGhpcyBmaXhlZCB1cC4KCgpOb3cgdGhhdCByZW1vdmVfaWQgaXMgZml4ZWQsIHRo
aW5ncyBmYWlscyBsYXRlciBpbiBEYXZlJ3MgcHJvY2VkdXJlOgoKIyBlY2hvIC1uIGRheDAuMCA+
IC9zeXMvYnVzL2RheC9kcml2ZXJzL2RldmljZV9kYXgvcmVtb3ZlX2lkCiMgZWNobyAtbiBkYXgw
LjAgPiAvc3lzL2J1cy9kYXgvZHJpdmVycy9kZXZpY2VfZGF4L3VuYmluZAojIGVjaG8gLW4gZGF4
MC4wID4gL3N5cy9idXMvZGF4L2RyaXZlcnMva21lbS9uZXdfaWQKIyBlY2hvIC1uIGRheDAuMCA+
IC9zeXMvYnVzL2RheC9kcml2ZXJzL2ttZW0vYmluZAotYmFzaDogZWNobzogd3JpdGUgZXJyb3I6
IE5vIHN1Y2ggZGV2aWNlCgooQW5kIG5vdGhpbmcgc2VlbXMgdG8gaGF2ZSBjaGFuZ2VkIGluIC9z
eXMvZGV2aWNlcy9zeXN0ZW0vbWVtb3J5Lyovc3RhdGUpCgpCcmljZQoKCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxp
c3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFu
L2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
