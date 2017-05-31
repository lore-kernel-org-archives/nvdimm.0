Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E22782095A58F
 for <linux-nvdimm@lists.01.org>; Wed, 31 May 2017 11:15:37 -0700 (PDT)
Message-ID: <1496254594.28981.37.camel@linux.intel.com>
Subject: Re: [PATCH 15/24] block: remove blk_part_pack_uuid
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Wed, 31 May 2017 21:16:34 +0300
In-Reply-To: <20170531161826.23243-16-hch@lst.de>
References: <20170531161826.23243-1-hch@lst.de>
 <20170531161826.23243-16-hch@lst.de>
Mime-Version: 1.0
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
To: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-block@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE3LTA1LTMxIGF0IDE4OjE4ICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToKPiBUaGlzIGhlbHBlciB3YXMgb25seSB1c2VkIGJ5IElNQSBvZiBhbGwgdGhpbmdzLCB3aGlj
aCB3b3VsZCBnZXQKPiBzcHVyaW91cwo+IGVycm9ycyBpZiBDT05GSUdfQkxPQ0sgaXMgZGlzYWJs
ZWQuwqDCoEp1c3Qgb3BlbmNvZGUgdGhlIGNhbGwgdGhlcmUuCgo+IC0JCQlyZXN1bHQgPSBibGtf
cGFydF9wYWNrX3V1aWQoYXJnc1swXS5mcm9tLAo+IC0JCQkJCQnCoMKgwqDCoGVudHJ5LT5mc3V1
aWQpOwo+ICsJCQlyZXN1bHQgPSB1dWlkX3RvX2JpbihhcmdzWzBdLmZyb20sICh1dWlkX3QKPiAq
KSZlbnRyeS0+ZnN1dWlkKTsKPiAKCnV1aWRfcGFyc2UoKSA/CgotLSAKQW5keSBTaGV2Y2hlbmtv
IDxhbmRyaXkuc2hldmNoZW5rb0BsaW51eC5pbnRlbC5jb20+CkludGVsIEZpbmxhbmQgT3kKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1t
IG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEu
b3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
