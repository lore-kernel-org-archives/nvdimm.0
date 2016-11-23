Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam01on0712.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe42::712])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8F80881E88
 for <linux-nvdimm@lists.01.org>; Tue, 22 Nov 2016 16:07:01 -0800 (PST)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3] libnvdimm: clear poison in mem map metadata
Date: Wed, 23 Nov 2016 00:07:00 +0000
Message-ID: <1479859481.20881.158.camel@hpe.com>
References: <147976134582.93357.14661800715988484489.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <147976134582.93357.14661800715988484489.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <4DC540E917D76748969DD52AD8FD0E7E@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE2LTExLTIxIGF0IDEzOjQ5IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBD
bGVhcmluZyBvdXQgdGhlIHBvaXNvbiBpbiB0aGUgbWV0YWRhdGEgYmxvY2sgb2YgdGhlIG5hbWVz
cGFjZSBiZWZvcmUNCj4gd2UgdXNlIGl0LiBSYW5nZSBmcm9tIHN0YXJ0ICsgOGsgdG8gcGZuX3Ni
LT5kYXRhb2ZmLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRGF2ZSBKaWFuZyA8ZGF2ZS5qaWFuZ0Bp
bnRlbC5jb20+DQoNClRoYW5rcyBmb3IgdGhlIHVwZGF0ZS4gwqBUaGlzIGxvb2tzIGdvb2QgdG8g
bWUuDQoNClJldmlld2VkLWJ5OiBUb3NoaSBLYW5pIDx0b3NoaS5rYW5pQGhwZS5jb20+DQoNCi1U
b3NoaQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51
eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9s
aXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
