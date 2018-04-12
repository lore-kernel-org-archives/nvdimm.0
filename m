Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x234.google.com (mail-wm0-x234.google.com
 [IPv6:2a00:1450:400c:c09::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5C535226516CB
 for <linux-nvdimm@lists.01.org>; Thu, 12 Apr 2018 11:20:34 -0700 (PDT)
Received: by mail-wm0-x234.google.com with SMTP id b127so29560wmf.5
 for <linux-nvdimm@lists.01.org>; Thu, 12 Apr 2018 11:20:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180412142214.fcxw3g2jxv6bvn7d@quack2.suse.cz>
References: <20171101153648.30166-1-jack@suse.cz>
 <20171101153648.30166-20-jack@suse.cz>
 <CAKgNAkhsFrcdkXNA2cw3o0gJV0uLRtBg9ybaCe5xy1QBC2PgqA@mail.gmail.com>
 <20180412142214.fcxw3g2jxv6bvn7d@quack2.suse.cz>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 12 Apr 2018 20:20:12 +0200
Message-ID: <CAKgNAkgtVryFb81QgzwPq8SD241yKDN1xNxOWUUQH9QBYV13SA@mail.gmail.com>
Subject: Re: [PATCH] mmap.2: Add description of MAP_SHARED_VALIDATE and
 MAP_SYNC
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: mtk.manpages@gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jan Kara <jack@suse.cz>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-nvdimm@lists.01.org, Linux API <linux-api@vger.kernel.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

SmFuLCBSb3NzLgoKT24gMTIgQXByaWwgMjAxOCBhdCAxNjoyMiwgSmFuIEthcmEgPGphY2tAc3Vz
ZS5jej4gd3JvdGU6Cj4gSGVsbG8gTWljaGFlbCEKPgo+IE9uIFRodSAxMi0wNC0xOCAxNTowMDo0
OSwgTWljaGFlbCBLZXJyaXNrIChtYW4tcGFnZXMpIHdyb3RlOgo+PiBIZWxsbyBKYW4sCj4+Cj4+
IEkgaGF2ZSBhcHBsaWVkIHlvdXIgcGF0Y2gsIGFuZCB0d2Vha2VkIHRoZSB0ZXh0IGEgbGl0dGxl
LCBhbmQgcHVzaGVkCj4+IHRoZSByZXN1bHQgdG8gdGhlIGdpdCByZXBvLgo+Cj4gVGhhbmtzIQo+
Cj4+ID4gKy5CIE1BUF9TSEFSRUQKPj4gPiArdHlwZSB3aWxsIHNpbGVudGx5IGlnbm9yZSB0aGlz
IGZsYWcuCj4+ID4gK1RoaXMgZmxhZyBpcyBzdXBwb3J0ZWQgb25seSBmb3IgZmlsZXMgc3VwcG9y
dGluZyBEQVggKGRpcmVjdCBtYXBwaW5nIG9mIHBlcnNpc3RlbnQKPj4gPiArbWVtb3J5KS4gRm9y
IG90aGVyIGZpbGVzLCBjcmVhdGluZyBtYXBwaW5nIHdpdGggdGhpcyBmbGFnIHJlc3VsdHMgaW4K
Pj4gPiArLkIgRU9QTk9UU1VQUAo+PiA+ICtlcnJvci4gU2hhcmVkIGZpbGUgbWFwcGluZ3Mgd2l0
aCB0aGlzIGZsYWcgcHJvdmlkZSB0aGUgZ3VhcmFudGVlIHRoYXQgd2hpbGUKPj4gPiArc29tZSBt
ZW1vcnkgaXMgd3JpdGVhYmx5IG1hcHBlZCBpbiB0aGUgYWRkcmVzcyBzcGFjZSBvZiB0aGUgcHJv
Y2VzcywgaXQgd2lsbAo+PiA+ICtiZSB2aXNpYmxlIGluIHRoZSBzYW1lIGZpbGUgYXQgdGhlIHNh
bWUgb2Zmc2V0IGV2ZW4gYWZ0ZXIgdGhlIHN5c3RlbSBjcmFzaGVzIG9yCj4+ID4gK2lzIHJlYm9v
dGVkLiBUaGlzIGFsbG93cyB1c2VycyBvZiBzdWNoIG1hcHBpbmdzIHRvIG1ha2UgZGF0YSBtb2Rp
ZmljYXRpb25zCj4+ID4gK3BlcnNpc3RlbnQgaW4gYSBtb3JlIGVmZmljaWVudCB3YXkgdXNpbmcg
YXBwcm9wcmlhdGUgQ1BVIGluc3RydWN0aW9ucy4KPj4KPj4gSXQgZmVlbHMgbGlrZSB0aGVyZSdz
IGEgd29yZCBtaXNzaW5nL3VuY2xlYXIgd29yZGluZyBpbiB0aGUgcHJldmlvdXMKPj4gbGluZSwg
YmVmb3JlICJ1c2luZyIuIFdpdGhvdXQgdGhhdCB3b3JkLCB0aGUgc2VudGVuY2UgZmVlbHMgYSBi
aXQKPj4gYW1iaWd1b3VzLgo+Pgo+PiBTaG91bGQgaXQgYmU6Cj4+Cj4+IHBlcnNpc3RlbnQgaW4g
YSBtb3JlIGVmZmljaWVudCB3YXkgKnRocm91Z2ggdGhlIHVzZSBvZiogYXBwcm9wcmlhdGUKPj4g
Q1BVIGluc3RydWN0aW9ucy4KPj4KPj4gb3I6Cj4+Cj4+IHBlcnNpc3RlbnQgaW4gYSBtb3JlIGVm
ZmljaWVudCB3YXkgKnRoYW4gdXNpbmcqIGFwcHJvcHJpYXRlIENQVSBpbnN0cnVjdGlvbnMuCj4+
Cj4+ID8KPj4KPj4gSXMgc3VzcGVjdCB0aGUgZmlyc3QgaXMgY29ycmVjdCwgYnV0IG5lZWQgdG8g
Y2hlY2suCj4KPiBZZXMsIHRoZSBmaXJzdCBpcyBjb3JyZWN0LgoKVGhhbmtzIGZvciBib3RoIGNo
ZWNraW5nIHRoYXQgcGhyYXNpbmcuIEluIHRoZSBlbmQgSSBkZWNpZGVkIHRvIHJld29yZAp0aGUg
c2VudGVuY2UgYSBib3QgbW9yZSBzdWJzdGFudGlhbGx5OgoKICAgICAgICAgICAgICBJbiAgY29u
anVuY3Rpb24gIHdpdGggIHRoZSAgdXNlIG9mIGFwcHJvcHJpYXRlIENQVQogICAgICAgICAgICAg
IGluc3RydWN0aW9ucywgdGhpcyBwcm92aWRlcyB1c2VycyBvZiBzdWNoIG1hcHBpbmdzCiAgICAg
ICAgICAgICAgd2l0aCBhIG1vcmUgZWZmaWNpZW50IHdheSBvZiBtYWtpbmcgZGF0YSBtb2RpZmlj
YeKAkAogICAgICAgICAgICAgIHRpb25zIHBlcnNpc3RlbnQuCgpUaGFua3MsCgpNaWNoYWVsCgot
LSAKTWljaGFlbCBLZXJyaXNrCkxpbnV4IG1hbi1wYWdlcyBtYWludGFpbmVyOyBodHRwOi8vd3d3
Lmtlcm5lbC5vcmcvZG9jL21hbi1wYWdlcy8KTGludXgvVU5JWCBTeXN0ZW0gUHJvZ3JhbW1pbmcg
VHJhaW5pbmc6IGh0dHA6Ly9tYW43Lm9yZy90cmFpbmluZy8KX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51
eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGlu
Zm8vbGludXgtbnZkaW1tCg==
