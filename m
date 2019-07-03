Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 393C5212AB4E6
 for <linux-nvdimm@lists.01.org>; Wed,  3 Jul 2019 10:01:49 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id r6so3113376oti.3
 for <linux-nvdimm@lists.01.org>; Wed, 03 Jul 2019 10:01:49 -0700 (PDT)
MIME-Version: 1.0
References: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190703121743.GH1729@bombadil.infradead.org>
In-Reply-To: <20190703121743.GH1729@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 3 Jul 2019 10:01:37 -0700
Message-ID: <CAPcyv4jgs5LTtTXR+2CyfbjJE85B_eoPFuXQsGBDnVMo41Jawg@mail.gmail.com>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Seema Pandit <seema.pandit@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Boaz Harrosh <openosd@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Robert Barror <robert.barror@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 3, 2019 at 5:17 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Wed, Jul 03, 2019 at 12:24:54AM -0700, Dan Williams wrote:
> > This fix may increase waitqueue contention, but a fix for that is saved
> > for a larger rework. In the meantime this fix is suitable for -stable
> > backports.
>
> I think this is too big for what it is; just the two-line patch to stop
> incorporating the low bits of the PTE would be more appropriate.

Sufficient, yes, "appropriate", not so sure. All those comments about
pmd entry size are stale after this change.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
