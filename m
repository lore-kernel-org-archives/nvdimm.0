Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4FF8B22526483
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 08:01:54 -0700 (PDT)
Date: Thu, 5 Apr 2018 09:01:49 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/3] Avoid filename truncation in numastat
Message-ID: <20180405150149.GA10615@linux.intel.com>
References: <20180322183322.23076-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180322183322.23076-1-ross.zwisler@linux.intel.com>
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
To: Andi Kleen <andi.kleen@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

UGluZyBvbiB0aGlzIHNlcmllcy4KCk9uIFRodSwgTWFyIDIyLCAyMDE4IGF0IDEyOjMzOjIwUE0g
LTA2MDAsIFJvc3MgWndpc2xlciB3cm90ZToKPiBnY2MgNy4zLjEgcHJvdmlkZXMgdGhlIGZvbGxv
d2luZyB3YXJuaW5nIHdoZW4gY29tcGlsaW5nIG51bWFzdGF0LmM6Cj4gCj4gbnVtYXN0YXQuYzog
SW4gZnVuY3Rpb24g4oCYYWRkX3BpZHNfZnJvbV9wYXR0ZXJuX3NlYXJjaOKAmToKPiBudW1hc3Rh
dC5jOjEzMTY6NDE6IHdhcm5pbmc6IOKAmCVz4oCZIGRpcmVjdGl2ZSBvdXRwdXQgbWF5IGJlIHRy
dW5jYXRlZCB3cml0aW5nCj4gdXAgdG8gMjU1IGJ5dGVzIGludG8gYSByZWdpb24gb2Ygc2l6ZSA1
OCBbLVdmb3JtYXQtdHJ1bmNhdGlvbj1dCj4gICAgc25wcmludGYoZm5hbWUsIHNpemVvZihmbmFt
ZSksICIvcHJvYy8lcy9jbWRsaW5lIiwgbmFtZWxpc3RbaXhdLT5kX25hbWUpOwo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXn4KPiBudW1hc3RhdC5jOjEzMTY6Mzog
bm90ZTog4oCYc25wcmludGbigJkgb3V0cHV0IGJldHdlZW4gMTUgYW5kIDI3MCBieXRlcyBpbnRv
IGEKPiBkZXN0aW5hdGlvbiBvZiBzaXplIDY0Cj4gICAgc25wcmludGYoZm5hbWUsIHNpemVvZihm
bmFtZSksICIvcHJvYy8lcy9jbWRsaW5lIiwgbmFtZWxpc3RbaXhdLT5kX25hbWUpOwo+ICAgIF5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fgo+IAo+IFRoaXMgaXMgdmFsaWQgLSBuYW1lbGlzdFtpeF0tPmRfbmFtZSBp
cyBzaXplIDI1NiBieXRlcywgd2UgaGF2ZSBzb21lIGV4dHJhCj4gYnl0ZXMgYXMgcGFydCBvZiBv
dXIgZm9ybWF0IHN0cmluZy4gIE91ciBkZXN0aW5hdGlvbiBidWZmZXIsICdmbmFtZScsIGlzCj4g
b25seSA2NCBieXRlcyB3aWRlLgo+IAo+IFNpZ25lZC1vZmYtYnk6IFJvc3MgWndpc2xlciA8cm9z
cy56d2lzbGVyQGxpbnV4LmludGVsLmNvbT4KPiAtLS0KPiAgbnVtYXN0YXQuYyB8IDIgKy0KPiAg
MSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCj4gCj4gZGlmZiAt
LWdpdCBhL251bWFzdGF0LmMgYi9udW1hc3RhdC5jCj4gaW5kZXggZTBhNTYzOS4uMmQ0MTNkZiAx
MDA2NDQKPiAtLS0gYS9udW1hc3RhdC5jCj4gKysrIGIvbnVtYXN0YXQuYwo+IEBAIC0xMzEyLDcg
KzEzMTIsNyBAQCB2b2lkIGFkZF9waWRzX2Zyb21fcGF0dGVybl9zZWFyY2goY2hhciAqcGF0dGVy
bikgewo+ICAJCX0KPiAgCQkvLyBOZXh0IGNvcHkgY21kbGluZSBmaWxlIGNvbnRlbnRzIG9udG8g
ZW5kIG9mIGJ1ZmZlci4gIERvIGl0IGEKPiAgCQkvLyBjaGFyYWN0ZXIgYXQgYSB0aW1lIHRvIGNv
bnZlcnQgbnVsbHMgdG8gc3BhY2VzLgo+IC0JCWNoYXIgZm5hbWVbNjRdOwo+ICsJCWNoYXIgZm5h
bWVbMjcyXTsKPiAgCQlzbnByaW50ZihmbmFtZSwgc2l6ZW9mKGZuYW1lKSwgIi9wcm9jLyVzL2Nt
ZGxpbmUiLCBuYW1lbGlzdFtpeF0tPmRfbmFtZSk7Cj4gIAkJRklMRSAqZnMgPSBmb3BlbihmbmFt
ZSwgInIiKTsKPiAgCQlpZiAoZnMpIHsKPiAtLSAKPiAyLjE0LjMKPiAKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlz
dApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4v
bGlzdGluZm8vbGludXgtbnZkaW1tCg==
