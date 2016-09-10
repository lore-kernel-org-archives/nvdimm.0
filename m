Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF5911A1DEC
 for <linux-nvdimm@lists.01.org>; Fri,  9 Sep 2016 18:00:15 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id c192so16603732oih.2
 for <linux-nvdimm@lists.01.org>; Fri, 09 Sep 2016 18:00:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <147318057109.30325.17721163157375660986.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147318056046.30325.5100892122988191500.stgit@dwillia2-desk3.amr.corp.intel.com>
 <147318057109.30325.17721163157375660986.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Sep 2016 18:00:14 -0700
Message-ID: <CAPcyv4jqsPuOMMbkjUtNSxd+vJXaoyJXvX_ttGfS12bCyRDtfg@mail.gmail.com>
Subject: Re: [PATCH 2/5] dax: fix offset to physical address translation
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 6, 2016 at 9:49 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> In pgoff_to_phys() 'pgoff' is already relative to base of the dax
> device, so we only need to compare if the current offset is within the
> current resource extent.  Otherwise, we are double accounting the
> resource start offset when translating pgoff to a physical address.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

On second look this results in the exact same translation, correct in
both cases.  This is also confirmed by a new ndctl unit test that does
data verification by writing through a /dev/pmem device and the
verifying via a /dev/dax device associated with the same namespace, so
I'm dropping this patch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
