Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 91C60202E5483
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jul 2018 18:42:00 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id c6-v6so39634797oiy.0
 for <linux-nvdimm@lists.01.org>; Mon, 09 Jul 2018 18:42:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <TY2PR03MB3343CA3696614BA3B2D546CE925B0@TY2PR03MB3343.apcprd03.prod.outlook.com>
References: <TY2PR03MB3343CA3696614BA3B2D546CE925B0@TY2PR03MB3343.apcprd03.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 9 Jul 2018 18:41:59 -0700
Message-ID: <CAPcyv4hAQSSWoGRQMSZ9BtSEW_0M982YbSF0dR8x5zyquvMUpw@mail.gmail.com>
Subject: Re: A question about ndctl namespace
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
To: Huaisheng HS1 Ye <yehs1@lenovo.com>
Cc: NingTing Cheng <chengnt@lenovo.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCBKdWwgOSwgMjAxOCBhdCA2OjMzIFBNLCBIdWFpc2hlbmcgSFMxIFllIDx5ZWhzMUBs
ZW5vdm8uY29tPiB3cm90ZToKPiBIaSBBbGwsCj4KPiBJIHdhbnQgdG8gZGVzdHJveSBzb21lIHJl
ZHVuZGFudCBuYW1lc3BhY2VzIChuYW1lc3BhY2UwLjAgYW5kIDAuMSkgZnJvbQo+IG15IHN5c3Rl
bS4KPiBCdXQgaXQgc3RpbGwgZG9lc27igJl0IHdvcmsgZXZlbiBJIHVzZWQg4oCYZGVzdHJveS1u
YW1lc3BhY2XigJksIHRoZSByZXN1bHQKPiBvZiBjb21tYW5kIGxvb2tzIG9rLCBidXQgSSBzdGls
bCBjb3VsZCBmaW5kIHRoZW0gdGhlcmUuIEhvdyBjYW4gSSByZW1vdmUKPiB0aGVtIHNvIHRoZXkg
d291bGRuJ3QgYXBwZWFyIGluIG5leHQgY29tbWFuZCAnbmRjdGwgbGlzdCc/CgpTaG9ydCBhbnN3
ZXIsIHlvdSBjYW4ndC4KClRoaXMgaXMgYSBnZW5lcmFsIG1pc2NvbmNlcHRpb24gYWJvdXQgd2hh
dCB0aGUgJ2Rlc3Ryb3ktbmFtZXNwYWNlJwpjb21tYW5kIGRvZXMuIEl0IGRlc3Ryb3lzIGFueSBp
bmZvLWJsb2NrIG1ldGFkYXRhIGFuZCBpZiB0aGUgbmFtZXNwYWNlCmlzIG5vdCBhICdzZWVkJyBk
ZXZpY2Ugb3IgdGhlIDB0aCBkZXZpY2UgaXQgbWF5IGFkZGl0aW9uYWxseSBkZWxldGUKdGhlIGtl
cm5lbCBkZXZpY2Ugb2JqZWN0LiBTZWUgdGhpcyBjb21tZW50IGZyb20gdGhlIGtlcm5lbCBzb3Vy
Y2UuCgogICAgICAgIC8qCiAgICAgICAgICogVHJ5IHRvIGRlbGV0ZSB0aGUgbmFtZXNwYWNlIGlm
IHdlIGRlbGV0ZWQgYWxsIG9mIGl0cwogICAgICAgICAqIGFsbG9jYXRpb24sIHRoaXMgaXMgbm90
IHRoZSBzZWVkIG9yIDB0aCBkZXZpY2UgZm9yIHRoZQogICAgICAgICAqIHJlZ2lvbiwgYW5kIGl0
IGlzIG5vdCBhY3RpdmVseSBjbGFpbWVkIGJ5IGEgYnR0LCBwZm4sIG9yIGRheAogICAgICAgICAq
IGluc3RhbmNlLgogICAgICAgICAqLwogICAgICAgIGlmICh2YWwgPT0gMCAmJiBpZCAhPSAwICYm
IG5kX3JlZ2lvbi0+bnNfc2VlZCAhPSBkZXYgJiYgIW5kbnMtPmNsYWltKQogICAgICAgICAgICAg
ICAgbmRfZGV2aWNlX3VucmVnaXN0ZXIoZGV2LCBORF9BU1lOQyk7CgpUaGUgcmVhc29uIHdlIGRv
bid0IGRlbGV0ZSB0aGUgc2VlZCBkZXZpY2UgaXMgdGhhdCB3ZSBhbHdheXMgbmVlZCBhdApsZWFz
dCBvbmUgc2VlZCBkZXZpY2UgdG8gY29uZmlndXJlIHRoZSBuZXh0IG5hbWVzcGFjZSwgYW5kIHdl
IGtlZXAgdGhlCjB0aCBkZXZpY2UgYXJvdW5kIHRvIHRyeSB0byBtYWtlIHN1cmUgdGhlIGZpcnN0
IG5hbWVzcGFjZSBpbiBhIHJlZ2lvbgpnZXRzIHRoZSBuYW1lc3BhY2VYLjAgZGV2aWNlLgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0g
bWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5v
cmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
