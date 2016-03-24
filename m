Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4350C1A1EC1
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 08:27:06 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id r187so65787812oih.3
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 08:26:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1658644.DHCClzV6Cd@c203>
References: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
 <20160324012624.21436.9035.stgit@dwillia2-desk3.jf.intel.com>
 <1658644.DHCClzV6Cd@c203>
Date: Thu, 24 Mar 2016 08:26:00 -0700
Message-ID: <CAPcyv4gvrSeSYFdM2sRYKCKF79EjNKEoxou2T6EvVAsi9_Ef3A@mail.gmail.com>
Subject: Re: [PATCH 12/13] libnvdimm, pmem, pfn: move pfn setup to the core
From: Dan Williams <dan.j.williams@intel.com>
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCBNYXIgMjQsIDIwMTYgYXQgNzozNiBBTSwgSm9oYW5uZXMgVGh1bXNoaXJuIDxqdGh1
bXNoaXJuQHN1c2UuZGU+IHdyb3RlOgo+IE9uIE1pdHR3b2NoLCAyMy4gTcOkcnogMjAxNiAxODoy
NjoyNCBDRVQgRGFuIFdpbGxpYW1zIHdyb3RlOgo+PiBOb3cgdGhhdCBwbWVtIGludGVybmFscyBo
YXZlIGJlZW4gZGlzZW50YW5nbGVkIGZyb20gcGZuIHNldHVwLCB0aGF0IGNvZGUKPj4gY2FuIG1v
dmUgdG8gdGhlIGNvcmUuICBUaGlzIGlzIGluIHByZXBhcmF0aW9uIGZvciBhZGRpbmcgYW5vdGhl
ciB1c2VyIG9mCj4+IHRoZSBwZm4tZGV2aWNlIGNhcGFiaWxpdGllcy4KPj4KPj4gU2lnbmVkLW9m
Zi1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+ClsuLl0KPj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbnZkaW1tL3Bmbl9kZXZzLmMgYi9kcml2ZXJzL252ZGltbS9wZm5f
ZGV2cy5jCj4+IGluZGV4IGY4ZmQzNzk1MDFiZi4uNTFhMjE0ZWU3NWE3IDEwMDY0NAo+PiAtLS0g
YS9kcml2ZXJzL252ZGltbS9wZm5fZGV2cy5jCj4+ICsrKyBiL2RyaXZlcnMvbnZkaW1tL3Bmbl9k
ZXZzLmMKWy4uXQo+PiArc3RhdGljIGludCBuZF9wZm5faW5pdChzdHJ1Y3QgbmRfcGZuICpuZF9w
Zm4pCj4+ICt7Cj4+ICsgICAgIHN0cnVjdCBuZF9uYW1lc3BhY2VfY29tbW9uICpuZG5zID0gbmRf
cGZuLT5uZG5zOwo+PiArICAgICB1MzIgc3RhcnRfcGFkID0gMCwgZW5kX3RydW5jID0gMDsKPj4g
KyAgICAgcmVzb3VyY2Vfc2l6ZV90IHN0YXJ0LCBzaXplOwo+PiArICAgICBzdHJ1Y3QgbmRfbmFt
ZXNwYWNlX2lvICpuc2lvOwo+PiArICAgICBzdHJ1Y3QgbmRfcmVnaW9uICpuZF9yZWdpb247Cj4+
ICsgICAgIHN0cnVjdCBuZF9wZm5fc2IgKnBmbl9zYjsKPj4gKyAgICAgdW5zaWduZWQgbG9uZyBu
cGZuczsKPj4gKyAgICAgcGh5c19hZGRyX3Qgb2Zmc2V0Owo+PiArICAgICB1NjQgY2hlY2tzdW07
Cj4+ICsgICAgIGludCByYzsKPj4gKwo+PiArICAgICBwZm5fc2IgPSBkZXZtX2t6YWxsb2MoJm5k
X3Bmbi0+ZGV2LCBzaXplb2YoKnBmbl9zYiksIEdGUF9LRVJORUwpOwo+PiArICAgICBpZiAoIXBm
bl9zYikKPj4gKyAgICAgICAgICAgICByZXR1cm4gLUVOT01FTTsKPj4gKwo+PiArICAgICBuZF9w
Zm4tPnBmbl9zYiA9IHBmbl9zYjsKPj4gKyAgICAgcmMgPSBuZF9wZm5fdmFsaWRhdGUobmRfcGZu
KTsKPj4gKyAgICAgaWYgKHJjID09IC1FTk9ERVYpCj4+ICsgICAgICAgICAgICAgLyogbm8gaW5m
byBibG9jaywgZG8gaW5pdCAqLzsKPj4gKyAgICAgZWxzZQo+PiArICAgICAgICAgICAgIHJldHVy
biByYzsKPgo+IFdoeSBub3Q6Cj4gaWYgKHJjICE9IC1FTk9ERVYpCj4gICAgICAgICByZXR1cm4g
IHJjOwo+IC8qIG5vIGluZm8gYmxvY2ssIGRvIGluaXQgKi8KCkxvb2tzIGdvb2QgdG8gbWUsIHdp
bGwgZml4LgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpM
aW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6
Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
