Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE1B6817B4
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jan 2017 01:01:40 -0800 (PST)
Date: Wed, 11 Jan 2017 10:01:36 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4: fix DAX write locking
Message-ID: <20170111090136.GE16116@quack2.suse.cz>
References: <1484063288-18255-1-git-send-email-hch@lst.de>
 <1484063288-18255-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1484063288-18255-2-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlIDEwLTAxLTE3IDE2OjQ4OjA3LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBVbmxp
a2UgT19ESVJFQ1QgREFYIGlzIG5vdCBhbiBvcHRpb25hbCBvcHQtaW4gZmVhdHVyZSBzZWxlY3Rl
ZCBieSB0aGUKPiBhcHBsaWNhdGlvbiwgc28gd2UnbGwgaGF2ZSB0byBwcm92aWRlIHRoZSB0cmFk
aXRpb25hbCBzeW5jaHJvbtGWemF0aW9uCj4gb2Ygb3ZlcmxhcHBpbmcgd3JpdGVzIGFzIHdlIGRv
IGZvciBidWZmZXJlZCB3cml0ZXMuCj4gCj4gVGhpcyB3YXMgYnJva2VuIGhpc3RvcmljYWxseSBm
b3IgREFYLCBidXQgZ290IGZpeGVkIGZvciBleHQyIGFuZCBYRlMKPiBhcyBwYXJ0IG9mIHRoZSBp
b21hcCBjb252ZXJzaW9uLiAgRml4IHVwIGV4dDQgYXMgd2VsbC4KPiAKPiBTaWduZWQtb2ZmLWJ5
OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KCk1ha2VzIHNlbnNlLiBZb3UgY2FuIGFk
ZDoKClJldmlld2VkLWJ5OiBKYW4gS2FyYSA8amFja0BzdXNlLmN6PgoKVGVkLCBjYW4geW91IHBs
ZWFzZSBwaWNrIGl0IHVwPyBUaGFua3MhCgoJCQkJCQkJCUhvbnphCgo+IC0tLQo+ICBmcy9leHQ0
L2ZpbGUuYyB8IDEwICstLS0tLS0tLS0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCA5IGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9mcy9leHQ0L2ZpbGUuYyBiL2ZzL2V4
dDQvZmlsZS5jCj4gaW5kZXggZDY2M2QzZC4uYTFlODhhYSAxMDA2NDQKPiAtLS0gYS9mcy9leHQ0
L2ZpbGUuYwo+ICsrKyBiL2ZzL2V4dDQvZmlsZS5jCj4gQEAgLTE3NSw3ICsxNzUsNiBAQCBleHQ0
X2RheF93cml0ZV9pdGVyKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IGlvdl9pdGVyICpmcm9t
KQo+ICB7Cj4gIAlzdHJ1Y3QgaW5vZGUgKmlub2RlID0gZmlsZV9pbm9kZShpb2NiLT5raV9maWxw
KTsKPiAgCXNzaXplX3QgcmV0Owo+IC0JYm9vbCBvdmVyd3JpdGUgPSBmYWxzZTsKPiAgCj4gIAlp
bm9kZV9sb2NrKGlub2RlKTsKPiAgCXJldCA9IGV4dDRfd3JpdGVfY2hlY2tzKGlvY2IsIGZyb20p
Owo+IEBAIC0xODgsMTYgKzE4Nyw5IEBAIGV4dDRfZGF4X3dyaXRlX2l0ZXIoc3RydWN0IGtpb2Ni
ICppb2NiLCBzdHJ1Y3QgaW92X2l0ZXIgKmZyb20pCj4gIAlpZiAocmV0KQo+ICAJCWdvdG8gb3V0
Owo+ICAKPiAtCWlmIChleHQ0X292ZXJ3cml0ZV9pbyhpbm9kZSwgaW9jYi0+a2lfcG9zLCBpb3Zf
aXRlcl9jb3VudChmcm9tKSkpIHsKPiAtCQlvdmVyd3JpdGUgPSB0cnVlOwo+IC0JCWRvd25ncmFk
ZV93cml0ZSgmaW5vZGUtPmlfcndzZW0pOwo+IC0JfQo+ICAJcmV0ID0gZGF4X2lvbWFwX3J3KGlv
Y2IsIGZyb20sICZleHQ0X2lvbWFwX29wcyk7Cj4gIG91dDoKPiAtCWlmICghb3ZlcndyaXRlKQo+
IC0JCWlub2RlX3VubG9jayhpbm9kZSk7Cj4gLQllbHNlCj4gLQkJaW5vZGVfdW5sb2NrX3NoYXJl
ZChpbm9kZSk7Cj4gKwlpbm9kZV91bmxvY2soaW5vZGUpOwo+ICAJaWYgKHJldCA+IDApCj4gIAkJ
cmV0ID0gZ2VuZXJpY193cml0ZV9zeW5jKGlvY2IsIHJldCk7Cj4gIAlyZXR1cm4gcmV0Owo+IC0t
IAo+IDIuMS40Cj4gCi0tIApKYW4gS2FyYSA8amFja0BzdXNlLmNvbT4KU1VTRSBMYWJzLCBDUgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRp
bW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4w
MS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
