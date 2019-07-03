Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 868C2212ACEBD
 for <linux-nvdimm@lists.01.org>; Wed,  3 Jul 2019 05:17:46 -0700 (PDT)
Date: Wed, 3 Jul 2019 05:17:43 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
Message-ID: <20190703121743.GH1729@bombadil.infradead.org>
References: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Seema Pandit <seema.pandit@intel.com>, linux-nvdimm@lists.01.org, Boaz Harrosh <openosd@gmail.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Robert Barror <robert.barror@intel.com>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 03, 2019 at 12:24:54AM -0700, Dan Williams wrote:
> This fix may increase waitqueue contention, but a fix for that is saved
> for a larger rework. In the meantime this fix is suitable for -stable
> backports.

I think this is too big for what it is; just the two-line patch to stop
incorporating the low bits of the PTE would be more appropriate.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
