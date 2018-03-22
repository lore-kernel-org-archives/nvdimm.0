Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1EDB522551BBD
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 11:26:54 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/3] Avoid filename truncation in numastat
Date: Thu, 22 Mar 2018 12:33:20 -0600
Message-Id: <20180322183322.23076-1-ross.zwisler@linux.intel.com>
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
To: Andi Kleen <ak@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Z2NjIDcuMy4xIHByb3ZpZGVzIHRoZSBmb2xsb3dpbmcgd2FybmluZyB3aGVuIGNvbXBpbGluZyBu
dW1hc3RhdC5jOgoKbnVtYXN0YXQuYzogSW4gZnVuY3Rpb24g4oCYYWRkX3BpZHNfZnJvbV9wYXR0
ZXJuX3NlYXJjaOKAmToKbnVtYXN0YXQuYzoxMzE2OjQxOiB3YXJuaW5nOiDigJglc+KAmSBkaXJl
Y3RpdmUgb3V0cHV0IG1heSBiZSB0cnVuY2F0ZWQgd3JpdGluZwp1cCB0byAyNTUgYnl0ZXMgaW50
byBhIHJlZ2lvbiBvZiBzaXplIDU4IFstV2Zvcm1hdC10cnVuY2F0aW9uPV0KICAgc25wcmludGYo
Zm5hbWUsIHNpemVvZihmbmFtZSksICIvcHJvYy8lcy9jbWRsaW5lIiwgbmFtZWxpc3RbaXhdLT5k
X25hbWUpOwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+Cm51bWFz
dGF0LmM6MTMxNjozOiBub3RlOiDigJhzbnByaW50ZuKAmSBvdXRwdXQgYmV0d2VlbiAxNSBhbmQg
MjcwIGJ5dGVzIGludG8gYQpkZXN0aW5hdGlvbiBvZiBzaXplIDY0CiAgIHNucHJpbnRmKGZuYW1l
LCBzaXplb2YoZm5hbWUpLCAiL3Byb2MvJXMvY21kbGluZSIsIG5hbWVsaXN0W2l4XS0+ZF9uYW1l
KTsKICAgXn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+CgpUaGlzIGlzIHZhbGlkIC0gbmFtZWxpc3RbaXhdLT5kX25h
bWUgaXMgc2l6ZSAyNTYgYnl0ZXMsIHdlIGhhdmUgc29tZSBleHRyYQpieXRlcyBhcyBwYXJ0IG9m
IG91ciBmb3JtYXQgc3RyaW5nLiAgT3VyIGRlc3RpbmF0aW9uIGJ1ZmZlciwgJ2ZuYW1lJywgaXMK
b25seSA2NCBieXRlcyB3aWRlLgoKU2lnbmVkLW9mZi1ieTogUm9zcyBad2lzbGVyIDxyb3NzLnp3
aXNsZXJAbGludXguaW50ZWwuY29tPgotLS0KIG51bWFzdGF0LmMgfCAyICstCiAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9udW1hc3Rh
dC5jIGIvbnVtYXN0YXQuYwppbmRleCBlMGE1NjM5Li4yZDQxM2RmIDEwMDY0NAotLS0gYS9udW1h
c3RhdC5jCisrKyBiL251bWFzdGF0LmMKQEAgLTEzMTIsNyArMTMxMiw3IEBAIHZvaWQgYWRkX3Bp
ZHNfZnJvbV9wYXR0ZXJuX3NlYXJjaChjaGFyICpwYXR0ZXJuKSB7CiAJCX0KIAkJLy8gTmV4dCBj
b3B5IGNtZGxpbmUgZmlsZSBjb250ZW50cyBvbnRvIGVuZCBvZiBidWZmZXIuICBEbyBpdCBhCiAJ
CS8vIGNoYXJhY3RlciBhdCBhIHRpbWUgdG8gY29udmVydCBudWxscyB0byBzcGFjZXMuCi0JCWNo
YXIgZm5hbWVbNjRdOworCQljaGFyIGZuYW1lWzI3Ml07CiAJCXNucHJpbnRmKGZuYW1lLCBzaXpl
b2YoZm5hbWUpLCAiL3Byb2MvJXMvY21kbGluZSIsIG5hbWVsaXN0W2l4XS0+ZF9uYW1lKTsKIAkJ
RklMRSAqZnMgPSBmb3BlbihmbmFtZSwgInIiKTsKIAkJaWYgKGZzKSB7Ci0tIAoyLjE0LjMKCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGlt
bSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAx
Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
