Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 89447210ED11D
 for <linux-nvdimm@lists.01.org>; Mon, 13 Aug 2018 02:49:55 -0700 (PDT)
Subject: Re: [PATCH V3 0/4] Fix kvm misconceives NVDIMM pages as reserved mmio
References: <cover.1533811181.git.yi.z.zhang@linux.intel.com>
 <20180809090208.GD5069@quack2.suse.cz>
From: "Zhang,Yi" <yi.z.zhang@linux.intel.com>
Message-ID: <154a783f-5aff-c910-b252-5a6a36b37907@linux.intel.com>
Date: Tue, 14 Aug 2018 01:33:57 +0800
MIME-Version: 1.0
In-Reply-To: <20180809090208.GD5069@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: yu.c.zhang@intel.com, kvm@vger.kernel.org, linux-nvdimm@lists.01.org, rkrcmar@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, hch@lst.de, yi.z.zhang@intel.com
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAyMDE45bm0MDjmnIgwOeaXpSAxNzowMiwgSmFuIEthcmEgd3JvdGU6Cj4gT24gVGh1IDA5
LTA4LTE4IDE4OjUyOjQ4LCBaaGFuZyBZaSB3cm90ZToKPj4gRm9yIGRldmljZSBzcGVjaWZpYyBt
ZW1vcnkgc3BhY2UsIHdoZW4gd2UgbW92ZSB0aGVzZSBhcmVhIG9mIHBmbiB0bwo+PiBtZW1vcnkg
em9uZSwgd2Ugd2lsbCBzZXQgdGhlIHBhZ2UgcmVzZXJ2ZWQgZmxhZyBhdCB0aGF0IHRpbWUsIHNv
bWUgb2YKPj4gdGhlc2UgcmVzZXJ2ZWQgZm9yIGRldmljZSBtbWlvLCBhbmQgc29tZSBvZiB0aGVz
ZSBhcmUgbm90LCBzdWNoIGFzCj4+IE5WRElNTSBwbWVtLgo+Pgo+PiBOb3csIHdlIG1hcCB0aGVz
ZSBkZXZfZGF4IG9yIGZzX2RheCBwYWdlcyB0byBrdm0gZm9yIERJTU0vTlZESU1NCj4+IGJhY2tl
bmQsIHNpbmNlIHRoZXNlIHBhZ2VzIGFyZSByZXNlcnZlZC4gdGhlIGNoZWNrIG9mCj4+IGt2bV9p
c19yZXNlcnZlZF9wZm4oKSBtaXNjb25jZWl2ZXMgdGhvc2UgcGFnZXMgYXMgTU1JTy4gVGhlcmVm
b3IsIHdlCj4+IGludHJvZHVjZSAyIHBhZ2UgbWFwIHR5cGVzLCBNRU1PUllfREVWSUNFX0ZTX0RB
WC9NRU1PUllfREVWSUNFX0RFVl9EQVgsCj4+IHRvIGluZGVudGlmeSB0aGVzZSBwYWdlcyBhcmUg
ZnJvbSBOVkRJTU0gcG1lbS4gYW5kIGxldCBrdm0gdHJlYXQgdGhlc2UKPj4gYXMgbm9ybWFsIHBh
Z2VzLgo+Pgo+PiBXaXRob3V0IHRoaXMgcGF0Y2gsIE1hbnkgb3BlcmF0aW9ucyB3aWxsIGJlIG1p
c3NlZCBkdWUgdG8gdGhpcwo+PiBtaXN0cmVhdG1lbnQgdG8gcG1lbSBwYWdlcy4gRm9yIGV4YW1w
bGUsIGEgcGFnZSBtYXkgbm90IGhhdmUgY2hhbmNlIHRvCj4+IGJlIHVucGlubmVkIGZvciBLVk0g
Z3Vlc3QoaW4ga3ZtX3JlbGVhc2VfcGZuX2NsZWFuKTsgbm90IGFibGUgdG8gYmUKPj4gbWFya2Vk
IGFzIGRpcnR5L2FjY2Vzc2VkKGluIGt2bV9zZXRfcGZuX2RpcnR5L2FjY2Vzc2VkKSBldGMuCj4+
Cj4+IFYxOgo+PiBodHRwczovL2xrbWwub3JnL2xrbWwvMjAxOC83LzQvOTEKPj4KPj4gVjI6Cj4+
IGh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDE4LzcvMTAvMTM1Cj4+Cj4+IFYzOgo+PiBbUEFUQ0gg
VjMgMS80XSBOZWVkcyBDb21tZW50cy4KPj4gW1BBVENIIFYzIDIvNF0gVXBkYXRlIHRoZSBkZXNj
cmlwdGlvbiBvZiBNRU1PUllfREVWSUNFX0RFVl9EQVg6IEphbgo+PiBbUEFUQ0ggVjMgMy80XSBB
Y2tlZC1ieTogSmFuIGluIFYyCj4gSHVtLCBidXQgaXQgaXMgbm90IHRoZSB0aGUgcGF0Y2guLi4K
Pgo+IAkJCQkJCQkJSG9uemEKU29ycnksIEkgbWlzc2VkIHRoYXQsIHdpbGwgYWRkIGluIHRoZSBu
ZXh0IHZlcnNpb24sIHRoYW5rcyBmb3IgeW91ciByZXZpZXcKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGlu
dXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL2xpbnV4LW52ZGltbQo=
