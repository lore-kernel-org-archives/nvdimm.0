From: Mimi Zohar <zohar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: [PATCH] security/keys/trusted: Allow operation without hardware
 TPM
Date: Tue, 19 Mar 2019 18:56:29 -0400
Message-ID: <1553036189.4899.136.camel@linux.ibm.com>
References: <155295271345.1945351.6465460744078693578.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1552955080.2785.26.camel@linux.ibm.com>
 <CAA9_cmcOD2zPaaNbkYAaH5DRDRAebPkW+hwPA0zPKY4kU8R-rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAA9_cmcOD2zPaaNbkYAaH5DRDRAebPkW+hwPA0zPKY4kU8R-rg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, James Bottomley <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

SGkgRGFuLAoKT24gTW9uLCAyMDE5LTAzLTE4IGF0IDE3OjMwIC0wNzAwLCBEYW4gV2lsbGlhbXMg
d3JvdGU6CgpTb3JyeSBmb3IgdGhlIGxhdGUgcmVwbHkuCgo+IE9uIE1vbiwgTWFyIDE4LCAyMDE5
IGF0IDU6MjQgUE0gSmFtZXMgQm90dG9tbGV5IDxqZWpiQGxpbnV4LmlibS5jb20+IHdyb3RlOgo+
ID4KPiA+IE9uIE1vbiwgMjAxOS0wMy0xOCBhdCAxNjo0NSAtMDcwMCwgRGFuIFdpbGxpYW1zIHdy
b3RlOgo+ID4gPiBSYXRoZXIgdGhhbiBmYWlsIGluaXRpYWxpemF0aW9uIG9mIHRoZSB0cnVzdGVk
LmtvIG1vZHVsZSwgYXJyYW5nZSBmb3IKPiA+ID4gdGhlIG1vZHVsZSB0byBsb2FkLCBidXQgcmVs
eSBvbiB0cnVzdGVkX2luc3RhbnRpYXRlKCkgdG8gZmFpbAo+ID4gPiB0cnVzdGVkLWtleSBvcGVy
YXRpb25zLgo+ID4KPiA+IFdoYXQgYWN0dWFsIHByb2JsZW0gaXMgdGhpcyBmaXhpbmc/ICBUbyBt
ZSBpdCB3b3VsZCBzZWVtIGxpa2UgYW4KPiA+IGVuaGFuY2VtZW50IHRvIG1ha2UgdGhlIHRydXN0
ZWQgbW9kdWxlIGZhaWwgYXQgbG9hZCB0aW1lIGlmIHRoZXJlJ3Mgbm8KPiA+IFRQTSByYXRoZXIg
dGhhbiB3YWl0aW5nIHVudGlsIGZpcnN0IHVzZSB0byBmaW5kIG91dCBpdCBjYW4gbmV2ZXIgd29y
ay4KPiA+IElzIHRoZXJlIHNvbWUgcGllY2Ugb2YgdXNlciBjb2RlIHRoYXQgZGVwZW5kcyBvbiB0
aGUgc3VjY2Vzc2Z1bAo+ID4gaW5zZXJ0aW9uIG9mIHRydXN0ZWQua28/Cj4gCj4gVGhlIG1vZHVs
ZSBkZXBlbmRlbmN5IGNoYWluIHJlbGllcyBvbiBpdC4gSWYgdGhhdCBjYW4gYmUgYnJva2VuIHRo
YXQKPiB3b3VsZCBhbHNvIGJlIGFuIGFjY2VwdGFibGUgZml4Lgo+IAo+IEkgZm91bmQgdGhpcyB0
aHJvdWdoIHRoZSBmb2xsb3dpbmcgZGVwZW5kZW5jeSBjaGFpbjogbGlibnZkaW1tLmtvIC0+Cj4g
ZW5jcnlwdGVkX2tleXMua28gLT4gdHJ1c3RlZC5rby4KPiAKPiAia2V5X3R5cGVfdHJ1c3RlZCIg
aXMgdGhlIHN5bWJvbCB0aGF0IGVuY3J5cHRlZF9rZXlzIG5lZWRzIHJlZ2FyZGxlc3MKPiBvZiB3
aGV0aGVyIHRoZSB0cG0gaXMgcHJlc2VudC4KCkNvbW1pdMKgOTgyZTYxN2EzMTNiICgiZW5jcnlw
dGVkLWtleXM6IHJlbW92ZSB0cnVzdGVkLWtleXMgZGVwZW5kZW5jeSIpCnJlbW92ZWQgdGhlIGRl
cGVuZGVuY3kgb24gdHJ1c3RlZCBrZXlzLiDCoG1hc3RlcmtleV90cnVzdGVkLmMgc2hvdWxkCm9u
bHkgYmUgaW5jbHVkZWQgaWYgIkNPTkZJR19UUlVTVEVEX0tFWVMiIGlzIGVuYWJsZWQuIMKgSXMK
Q09ORklHX1RSVVNURURfS0VZUyBlbmFibGVkPwoKTWltaQoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51
eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGlu
Zm8vbGludXgtbnZkaW1tCg==
