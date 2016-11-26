Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 94E4081D3E
 for <linux-nvdimm@lists.01.org>; Sat, 26 Nov 2016 09:27:26 -0800 (PST)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm fixes for 4.9-rc7
Date: Sat, 26 Nov 2016 17:27:25 +0000
Message-ID: <1480181243.3767.8.camel@intel.com>
Content-Language: en-US
Content-ID: <E302886DD3E62C47AE2C751FD391ADA7@intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: base64
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

SGkgTGludXMsIHBsZWFzZSBwdWxsIGZyb206CgogIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9z
Y20vbGludXgva2VybmVsL2dpdC9udmRpbW0vbnZkaW1tIGxpYm52ZGltbS1maXhlcwoKLi4udG8g
cmVjZWl2ZToKCiogRml4IGEgY3Jhc2ggdGhhdCBvY2N1cnMgYXQgZHJpdmVyIGluaXRpYWxpemF0
aW9uIGlmIHRoZSBtZW1vcnkgcmVnaW9uCmlzIGFscmVhZHkgYnVzeSAocmVxdWVzdF9tZW1fcmVn
aW9uKCkgZmFpbHMpLgoKKiBGaXggYSB2bWEgdmFsaWRhdGlvbiBjaGVjayB0aGF0IG1pc3Rha2Vu
bHkgYWxsb3dzIGEgcHJpdmF0ZSBkZXZpY2UtCmRheCBtYXBwaW5nIHRvIGJlIGVzdGFibGlzaGVk
LiArQUtBLURldmljZS1kYXggZXhwbGljaXRseSBmb3JiaWRzIHByaXZhdGUKbWFwcGluZ3Mgc28g
aXQgY2FuIGd1YXJhbnRlZSBhIGdpdmVuIGZhdWx0IGdyYW51bGFyaXR5IGFuZCBiYWNraW5nCm1l
bW9yeSB0eXBlLgoKQm90aCBvZiB0aGVzZSBmaXhlcyBoYXZlIHNvYWtlZCBpbiAtbmV4dCBhbmQg
YXJlIHRhZ2dlZCBmb3IgLXN0YWJsZS4KCi0tLQoKVGhlIGZvbGxvd2luZyBjaGFuZ2VzIHNpbmNl
IGNvbW1pdCBlZDk5ZDM2NzNlMDgyYjc4YjIwMjA4ZjM0NmQyY2QzNzU0ODNhNzc5OgoKICBNZXJn
ZSBicmFuY2ggJ2xpYm52ZGltbS1maXhlcycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L252ZGltbS9udmRpbW0gKDIwMTYtMTAtMjggMTE6NDc6NDUgLTA3
MDApCgphcmUgYXZhaWxhYmxlIGluIHRoZSBnaXQgcmVwb3NpdG9yeSBhdDoKCiAgZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L252ZGltbS9udmRpbW0gbGlibnZk
aW1tLWZpeGVzCgpmb3IgeW91IHRvIGZldGNoIGNoYW5nZXMgdXAgdG8gNGNiMTkzNTVlYTE5OTk1
OTQxY2NhYWQxMTVkYmZhYzZiNzUyMTVjYToKCiAgZGV2aWNlLWRheDogZmFpbCBhbGwgcHJpdmF0
ZSBtYXBwaW5nIGF0dGVtcHRzICgyMDE2LTExLTE2IDA5OjAwOjM4IC0wODAwKQoKLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpE
YW4gV2lsbGlhbXMgKDIpOgogICAgICBkZXZpY2UtZGF4OiBjaGVjayBkZXZtX25zaW9fZW5hYmxl
KCkgcmV0dXJuIHZhbHVlCiAgICAgIGRldmljZS1kYXg6IGZhaWwgYWxsIHByaXZhdGUgbWFwcGlu
ZyBhdHRlbXB0cwoKIGRyaXZlcnMvZGF4L2RheC5jICB8IDQgKy0rLS0tCiBkcml2ZXJzL2RheC9w
bWVtLmMgfCA0ICstKy0rLS0KK0FLQS0yIGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrLSks
IDMgZGVsZXRpb25zKC0pCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9y
ZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
