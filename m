Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8368821C913DB
 for <linux-nvdimm@lists.01.org>; Tue,  7 Nov 2017 16:23:05 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Limitation in the badblocks routines
Date: Wed, 8 Nov 2017 00:27:03 +0000
Message-ID: <1510100688.6296.17.camel@intel.com>
Content-Language: en-US
Content-ID: <1ADDD7C5B5AC94418E14E6E779B130A1@intel.com>
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
To: "neilb@suse.com" <neilb@suse.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

SSB0aGluayBJJ3ZlIGZvdW5kIGEgbGltaXRhdGlvbiBpbiB0aGUgYmFkYmxvY2tzIGltcGxlbWVu
dGF0aW9uDQooYmxvY2svYmFkYmxvY2tzLmMpLCB3aGljaCB3ZSBub3cgYWxzbyB1c2UgZm9yIG52
ZGltbSBiYWRibG9ja3MuwqANCg0KQ29uc2lkZXIgdGhlIGZvbGxvd2luZyBvcGVyYXRpb25zOg0K
DQpiYWRibG9ja3Nfc2V0KGJiLCAzMiwgMSk7DQpiYWRibG9ja3Nfc2V0KGJiLCAzNCwgMSk7DQpi
YWRibG9ja3Nfc2V0KGJiLCAzNiwgMSk7DQoNCmJhZGJsb2Nrc19zaG93IHdpbGwgbm93IGNvcnJl
Y3RseSByZXBvcnQ6DQozMiAxDQozNCAxDQozNiAxDQoNCk5vdyBpZiBJIGRvOg0KYmFkYmxvY2tz
X3NldChiYiwgMzIsIDEyKTsNCg0KSWRlYWxseSwgdGhpcyBzaG91bGQgY29sbGFwc2UgYWxsIHJh
bmdlcyBpbnRvIGEgc2luZ2xlICgzMiwgMTIpLi4gQnV0DQpsb29rcyBsaWtlIGJhZGJsb2Nrc19z
ZXQgb25seSBtZXJnZXMgb25lIHNldCBvZiBhZGphY2VudCBtZXJnZWFibGUNCnJhbmdlcywgYW5k
IHRoZW4gcmV0dXJucywgcmVzdWx0aW5nIGluOg0KDQozMiAzDQozNiAxDQoNCk5vdyBpZiBJIGFk
ZCB0aGUgc2FtZSAoMzIsIDEyKSByYW5nZSBhZ2FpbiwgSSBnZXQ6DQoNCjMyIDUNCg0KYXMgb25l
IG1vcmUgc2V0IGlzIG1lcmdlZC4gQW5kIGZpbmFsbHkgYWZ0ZXIgYWRkaW5nICgzMiwgMTIpIG9u
ZSBmaW5hbA0KdGltZSwgSSBnZXQgdGhlIGV4cGVjdGVkDQoNCjMyIDEyLg0KDQpOZWlsIC0gZG8g
eW91IHRoaW5rIGl0IHdpbGwgYmUgcmVsYXRpdmVseSBzdHJhaWdodGZvcndhcmQgdG8gZXh0ZW5k
DQpiYWRibG9ja3Nfc2V0IHRvIGJlIGF3YXJlIG9mIG11bHRpLW92ZXJsYXAgcmFuZ2VzIGxpa2Ug
YWJvdmU/IEkgaGF2ZW4ndA0KcmVhbGx5IGxvb2tlZCBhdCB0aGUgaW50ZXJuYWxzIG9mIGl0IChJ
J2xsIHRha2UgYSBsb29rIHRvbW9ycm93KSwgYnV0IEkNCndhbnRlZCB0byBnZXQgdGhpcyBvdXQg
aW4gdGhlIG1lYW50aW1lLg0KDQpUaGFua3MsDQoJLVZpc2hhbApfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0Ckxp
bnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0
aW5mby9saW51eC1udmRpbW0K
