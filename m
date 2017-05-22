Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3BFF321A134B8
 for <linux-nvdimm@lists.01.org>; Mon, 22 May 2017 11:49:22 -0700 (PDT)
Message-ID: <1495478957.6967.69.camel@linux.intel.com>
Subject: Re: [PATCH 10/23] afs: switch to use uuid_t and uuid_gen
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon, 22 May 2017 21:49:17 +0300
In-Reply-To: <20170518062705.25902-11-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-11-hch@lst.de>
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
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE3LTA1LTE4IGF0IDA4OjI2ICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToKCkNoYW5nZWxvZz8KCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBs
c3QuZGU+Cj4gUmV2aWV3ZWQtYnk6IERhdmlkIEhvd2VsbHMgPGRob3dlbGxzQHJlZGhhdC5jb20+
Cgo+IEBAIC00NTMsNyArNDUzLDcgQEAgc3RhdGljIGludCBhZnNfZGVsaXZlcl9jYl9wcm9iZShz
dHJ1Y3QgYWZzX2NhbGwKPiAqY2FsbCkKPiDCoHN0YXRpYyB2b2lkIFNSWEFGU0NCX1Byb2JlVXVp
ZChzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCj4gwqB7Cj4gwqAJc3RydWN0IGFmc19jYWxsICpj
YWxsID0gY29udGFpbmVyX29mKHdvcmssIHN0cnVjdCBhZnNfY2FsbCwKPiB3b3JrKTsKPiAtCXN0
cnVjdCB1dWlkX3YxICpyID0gY2FsbC0+cmVxdWVzdDsKPiArCXV1aWRfdCAqciA9IGNhbGwtPnJl
cXVlc3Q7Cj4gwqAKPiDCoAlzdHJ1Y3Qgewo+IMKgCQlfX2JlMzIJbWF0Y2g7Cj4gCgpKdXN0IHRv
IGRvdWJsZSBjaGVjayB0aGF0IHRoaXMgZG9lc24ndCBjcmVhdGUgYSB1bmlvbiBhbGlhc2luZy4K
Ci0tIApBbmR5IFNoZXZjaGVua28gPGFuZHJpeS5zaGV2Y2hlbmtvQGxpbnV4LmludGVsLmNvbT4K
SW50ZWwgRmlubGFuZCBPeQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5v
cmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
