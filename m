Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6BA7520957465
 for <linux-nvdimm@lists.01.org>; Fri,  6 Apr 2018 07:40:34 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id l190-v6so1239093oig.9
 for <linux-nvdimm@lists.01.org>; Fri, 06 Apr 2018 07:40:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1523021334-9976-1-git-send-email-lukasz.plewa@intel.com>
References: <1523021334-9976-1-git-send-email-lukasz.plewa@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Apr 2018 07:40:32 -0700
Message-ID: <CAPcyv4h97ig8hRPPVPOA-kKTNpuciWHtMeT3s1xyqv=5wyDbcw@mail.gmail.com>
Subject: Re: [PATCH] ndctl: fix ndctl_persistence_domain declaration
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
To: "Plewa, Lukasz" <lukasz.plewa@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCBBcHIgNiwgMjAxOCBhdCA2OjI4IEFNLCAgPGx1a2Fzei5wbGV3YUBpbnRlbC5jb20+
IHdyb3RlOgo+IEZyb206IMWBdWthc3ogUGxld2EgPGx1a2Fzei5wbGV3YUBpbnRlbC5jb20+Cj4K
PiB0aGUgZGVjbGFyYXRpb24gb2YgbmRjdGxfcGVyc2lzdGVuY2VfZG9tYWluIHNob3VsZCBiZSBh
Ym92ZSBmaXJzdCB1c2UKPiBvZiB0aGlzIGVudW0KPgo+IFJlcG9ydGVkLWJ5OiBLYW1pbCBEaWVk
cmljaCA8a2FtaWwuZGllZHJpY2hAaW50ZWwuY29tPgo+IFNpZ25lZC1vZmYtYnk6IMWBdWthc3og
UGxld2EgPGx1a2Fzei5wbGV3YUBpbnRlbC5jb20+Cj4gLS0tCj4gIG5kY3RsL2xpYm5kY3RsLmgg
fCAxNCArKysrKysrLS0tLS0tLQo+ICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA3
IGRlbGV0aW9ucygtKQoKTG9va3MgZ29vZCwKClJldmlld2VkLWJ5OiBEYW4gV2lsbGlhbXMgPGRh
bi5qLndpbGxpYW1zQGludGVsLmNvbT4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlz
dHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZk
aW1tCg==
