Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7B63C211DF222
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 18:21:08 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x2K18kth018947
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 21:21:07 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
 by mx0b-001b2d01.pphosted.com with ESMTP id 2rbavq23wv-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 21:21:07 -0400
Received: from localhost
 by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <zohar@linux.ibm.com>;
 Wed, 20 Mar 2019 01:21:01 -0000
Subject: Re: [PATCH 0/6] security/keys/encrypted: Break module dependency chain
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Tue, 19 Mar 2019 21:20:47 -0400
In-Reply-To: <1553029714.2932.43.camel@linux.ibm.com>
References: <155297557534.2276575.16264199708584900090.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4ij2nHD7JumKNcNYB4gAGujWzCPkcpoi=XafmG3EP2b0g@mail.gmail.com>
 <1553029714.2932.43.camel@linux.ibm.com>
Mime-Version: 1.0
Message-Id: <1553044847.4899.169.camel@linux.ibm.com>
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
To: James Bottomley <jejb@linux.ibm.com>, Dan Williams <dan.j.williams@intel.com>, keyrings@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, ecryptfs@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Tyler Hicks <tyhicks@canonical.com>, linux-integrity@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE5LTAzLTE5IGF0IDE0OjA4IC0wNzAwLCBKYW1lcyBCb3R0b21sZXkgd3JvdGU6
Cj4gT24gVHVlLCAyMDE5LTAzLTE5IGF0IDE0OjAxIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6
Cj4gPiBPbiBNb24sIE1hciAxOCwgMjAxOSBhdCAxMToxOCBQTSBEYW4gV2lsbGlhbXMgPGRhbi5q
LndpbGxpYW1zQGludGVsLmMKPiA+IG9tPiB3cm90ZToKPiA+ID4gCj4gPiA+IFdpdGggdjUuMS1y
YzEgYWxsIHRoZSBudmRpbW0gc3ViLXN5c3RlbSByZWdyZXNzaW9uIHRlc3RzIHN0YXJ0ZWQKPiA+
ID4gZmFpbGluZyBiZWNhdXNlIHRoZSBsaWJudmRpbW0gbW9kdWxlIGZhaWxlZCB0byBsb2FkIGlu
IHRoZSBxZW11LWt2bSAKPiA+ID4gdGVzdCBlbnZpcm9ubWVudC4gIENyaXRpY2FsbHkgdGhhdCBl
bnZpcm9ubWVudCBkb2VzIG5vdCBoYXZlIGEgVFBNLgo+ID4gPiBDb21taXQgMjQwNzMwNDM3ZGVi
ICJLRVlTOiB0cnVzdGVkOiBleHBsaWNpdGx5IHVzZSB0cG1fY2hpcAo+ID4gPiBzdHJ1Y3R1cmUu
Li4iIHN0YXJ0ZWQgdG8gcmVxdWlyZSBhIFRQTSB0byBiZSBwcmVzZW50IGZvciB0aGUKPiA+ID4g
dHJ1c3RlZC5rbyBtb2R1bGUgdG8gbG9hZCB3aGVyZSB0aGVyZSB3YXMgbm8gcmVxdWlyZW1lbnQg
Zm9yIHRoYXQKPiA+ID4gYmVmb3JlLgo+ID4gPiAKPiA+ID4gUmF0aGVyIHRoYW4gdW5kbyB0aGUg
ImZhaWwgaWYgbm8gaGFyZHdhcmUiIGJlaGF2aW9yIEphbWVzIHBvaW50cwo+ID4gPiBvdXQgdGhh
dCB0aGUgbW9kdWxlIGRlcGVuZGVuY2llcyBjYW4gYmUgYnJva2VuIGJ5IGxvb2tpbmcgdXAgdGhl
Cj4gPiA+IGtleS10eXBlIGJ5IG5hbWUuIFJlbW92ZSB0aGUgZGVwZW5kZW5jaWVzIG9uIHRoZSAi
a2V5X3R5cGVfdHJ1c3RlZCIKPiA+ID4gYW5kICJrZXlfdHlwZV9lbmNyeXB0ZWQiIHN5bWJvbCBl
eHBvcnRzLCBhbmQgY2xlYW4gdXAgb3RoZXIKPiA+ID4gYm9pbGVycGxhdGUgdGhhdCBzdXBwb3J0
ZWQgdGhvc2UgZXhwb3J0cyBpbiBkaWZmZXJlbnQKPiA+ID4gY29uZmlndXJhdGlvbnMuCj4gPiAK
PiA+IEFueSBmZWVkYmFjaz8gV2FzIGhvcGluZyB0byBnZXQgYXQgbGVhc3QgcGF0Y2gxIGluIHRo
ZSBxdWV1ZSBmb3IKPiA+IHY1LjEtcmMyIHNpbmNlIHRoaXMgZWZmZWN0aXZlbHkgZGlzYWJsZXMg
dGhlIG52ZGltbSBkcml2ZXIgb24gdHlwaWNhbAo+ID4gY29uZmlndXJhdGlvbnMuIEphcmtrbywg
d291bGQgeW91IGJlIHdpbGxpbmcgdG8gbWVyZ2UgaXQgc2luY2UgdGhlCj4gPiByZWdyZXNzaW9u
IGNhbWUgdGhyb3VnaCB5b3VyIHRyZWU/Cj4gCj4gVGhlIHJlYXNvbiBJIHNlbnQgb3V0IHRoZSBS
RkMgd2FzIHRvIHNlZSBpZiB0aGUgcGVvcGxlIHdobyBhY3R1YWxseQo+IHdyb3RlIHRoZSBjb2Rl
IGhhZCBhbnkgcmVhc29ucyB0aGV5IG5lZWRlZCB0aGUgY3VycmVudCB3YXkgb2YgZG9pbmcKPiB0
aGluZ3MgcHJlc2VydmluZy4KCk5vLCBpdCBsb29rcyBmaW5lLiDCoFRoZSBlcnJvciByZXR1cm4g
Y29kZXMgd2lsbCBjaGFuZ2UsIGJ1dCBJIGRvbid0CnRoaW5rIHRoYXQgaXMgYSBwcm9ibGVtLgoK
TWltaQoKPiAKPiBJIHRoaW5rIHlvdXIgc2VyaWVzIGxvb2tzIGZpbmUgZXhjZXB0IHlvdSBuZWVk
IHRvIGV4cG9ydAo+IGtleV90eXBlX2xvb2t1cCAocGF0Y2ggMikgYmVmb3JlIHlvdSB1c2UgaXQg
KHBhdGNoIDEpIHRvIHByZXNlcnZlCj4gYmlzZWN0YWJpbGl0eSBvZiBidWlsZHMuCj4gCj4gSmFt
ZXMKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4
LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xp
c3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
