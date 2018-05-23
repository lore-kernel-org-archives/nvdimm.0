Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from tyo161.gate.nec.co.jp (tyo161.gate.nec.co.jp [114.179.232.161])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DCB63203BBBBD
 for <linux-nvdimm@lists.01.org>; Tue, 22 May 2018 23:48:26 -0700 (PDT)
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH 09/11] mm, memory_failure: pass page size to kill_proc()
Date: Wed, 23 May 2018 06:41:23 +0000
Message-ID: <20180523064123.GA22463@hori1.linux.bs1.fc.nec.co.jp>
References: <152699997165.24093.12194490924829406111.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152700001949.24093.5303974728568066054.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152700001949.24093.5303974728568066054.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: ja-JP
Content-ID: <1566589E8E7F89458BB8DF6F18C4B147@gisp.nec.co.jp>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "tony.luck@intel.com" <tony.luck@intel.com>, "hch@lst.de" <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 22, 2018 at 07:40:19AM -0700, Dan Williams wrote:
> Given that ZONE_DEVICE / dev_pagemap pages are never assembled into
> compound pages, the size determination logic in kill_proc() needs
> updating for the dev_pagemap case. In preparation for dev_pagemap
> support rework memory_failure() and kill_proc() to pass / consume the page
> size explicitly.
> 
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me.

Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
