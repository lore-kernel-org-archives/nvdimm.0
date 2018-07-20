Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 01AF22098EAA8
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 23:25:36 -0700 (PDT)
Subject: Re: [PATCH V2 0/4] Fix kvm misconceives NVDIMM pages as reserved mmio
References: <cover.1531241281.git.yi.z.zhang@linux.intel.com>
From: "Zhang,Yi" <yi.z.zhang@linux.intel.com>
Message-ID: <c4e1c527-a372-bd6a-a101-5a8e9026e7c1@linux.intel.com>
Date: Fri, 20 Jul 2018 22:11:30 +0800
MIME-Version: 1.0
In-Reply-To: <cover.1531241281.git.yi.z.zhang@linux.intel.com>
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
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, pbonzini@redhat.com, dan.j.williams@intel.com, jack@suse.cz, hch@lst.de, yu.c.zhang@intel.com, dave.jiang@intel.com
Cc: linux-mm@kvack.org, yi.z.zhang@intel.com, rkrcmar@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

QWRkZWQgSmlhbmcsRGF2ZSwKClBpbmcgZm9yIGZ1cnRoZXIgcmV2aWV3LCBjb21tZW50cy4KClRo
YW5rcyBBbGwKClJlZ2FyZHMKWWkuCgoKT24gMjAxOOW5tDA35pyIMTHml6UgMDE6MDEsIFpoYW5n
IFlpIHdyb3RlOgo+IEZvciBkZXZpY2Ugc3BlY2lmaWMgbWVtb3J5IHNwYWNlLCB3aGVuIHdlIG1v
dmUgdGhlc2UgYXJlYSBvZiBwZm4gdG8KPiBtZW1vcnkgem9uZSwgd2Ugd2lsbCBzZXQgdGhlIHBh
Z2UgcmVzZXJ2ZWQgZmxhZyBhdCB0aGF0IHRpbWUsIHNvbWUgb2YKPiB0aGVzZSByZXNlcnZlZCBm
b3IgZGV2aWNlIG1taW8sIGFuZCBzb21lIG9mIHRoZXNlIGFyZSBub3QsIHN1Y2ggYXMKPiBOVkRJ
TU0gcG1lbS4KPgo+IE5vdywgd2UgbWFwIHRoZXNlIGRldl9kYXggb3IgZnNfZGF4IHBhZ2VzIHRv
IGt2bSBmb3IgRElNTS9OVkRJTU0KPiBiYWNrZW5kLCBzaW5jZSB0aGVzZSBwYWdlcyBhcmUgcmVz
ZXJ2ZWQuIHRoZSBjaGVjayBvZgo+IGt2bV9pc19yZXNlcnZlZF9wZm4oKSBtaXNjb25jZWl2ZXMg
dGhvc2UgcGFnZXMgYXMgTU1JTy4gVGhlcmVmb3IsIHdlCj4gaW50cm9kdWNlIDIgcGFnZSBtYXAg
dHlwZXMsIE1FTU9SWV9ERVZJQ0VfRlNfREFYL01FTU9SWV9ERVZJQ0VfREVWX0RBWCwKPiB0byBp
bmRlbnRpZnkgdGhlc2UgcGFnZXMgYXJlIGZyb20gTlZESU1NIHBtZW0uIGFuZCBsZXQga3ZtIHRy
ZWF0IHRoZXNlCj4gYXMgbm9ybWFsIHBhZ2VzLgo+Cj4gV2l0aG91dCB0aGlzIHBhdGNoLCBNYW55
IG9wZXJhdGlvbnMgd2lsbCBiZSBtaXNzZWQgZHVlIHRvIHRoaXMKPiBtaXN0cmVhdG1lbnQgdG8g
cG1lbSBwYWdlcy4gRm9yIGV4YW1wbGUsIGEgcGFnZSBtYXkgbm90IGhhdmUgY2hhbmNlIHRvCj4g
YmUgdW5waW5uZWQgZm9yIEtWTSBndWVzdChpbiBrdm1fcmVsZWFzZV9wZm5fY2xlYW4pOyBub3Qg
YWJsZSB0byBiZQo+IG1hcmtlZCBhcyBkaXJ0eS9hY2Nlc3NlZChpbiBrdm1fc2V0X3Bmbl9kaXJ0
eS9hY2Nlc3NlZCkgZXRjLgo+Cj4gVjE6Cj4gaHR0cHM6Ly9sa21sLm9yZy9sa21sLzIwMTgvNy80
LzkxCj4KPiBWMjoKPiAqQWRkIGRvY3VtZW50YXRpb24gZm9yIE1FTU9SWV9ERVZJQ0VfREVWX0RB
WCBtZW1vcnkgdHlwZSBpbiBjb21tZW50IGJsb2NrCj4gKkFkZCBpc19kYXhfcGFnZSgpIGluIG1t
LmggdG8gZGlmZmVyZW50aWF0ZSB0aGUgcGFnZXMgaXMgZnJvbSBEQVggZGV2aWNlLgo+ICpSZW1v
dmUgdGhlIGZ1bmN0aW9uIGt2bV9pc19uZF9wZm4oKS4KPgo+IFpoYW5nIFlpICg0KToKPiAgIGt2
bTogcmVtb3ZlIHJlZHVuZGFudCByZXNlcnZlZCBwYWdlIGNoZWNrCj4gICBtbTogaW50cm9kdWNl
IG1lbW9yeSB0eXBlIE1FTU9SWV9ERVZJQ0VfREVWX0RBWAo+ICAgbW06IGFkZCBhIGZ1bmN0aW9u
IHRvIGRpZmZlcmVudGlhdGUgdGhlIHBhZ2VzIGlzIGZyb20gREFYIGRldmljZQo+ICAgICBtZW1v
cnkKPiAgIGt2bTogYWRkIGEgY2hlY2sgaWYgcGZuIGlzIGZyb20gTlZESU1NIHBtZW0uCj4KPiAg
ZHJpdmVycy9kYXgvcG1lbS5jICAgICAgIHwgIDEgKwo+ICBpbmNsdWRlL2xpbnV4L21lbXJlbWFw
LmggfCAgOSArKysrKysrKysKPiAgaW5jbHVkZS9saW51eC9tbS5oICAgICAgIHwgMTIgKysrKysr
KysrKysrCj4gIHZpcnQva3ZtL2t2bV9tYWluLmMgICAgICB8IDE2ICsrKysrKysrLS0tLS0tLS0K
PiAgNCBmaWxlcyBjaGFuZ2VkLCAzMCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQo+Cgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRp
bW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4w
MS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
