Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 03D831A1E10
 for <linux-nvdimm@lists.01.org>; Tue, 18 Oct 2016 15:12:55 -0700 (PDT)
Date: Tue, 18 Oct 2016 16:12:54 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 20/20] dax: Clear dirty entry tags on cache flush
Message-ID: <20161018221254.GG7796@linux.intel.com>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <1474992504-20133-21-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1474992504-20133-21-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 27, 2016 at 06:08:24PM +0200, Jan Kara wrote:
> Currently we never clear dirty tags in DAX mappings and thus address
> ranges to flush accumulate. Now that we have locking of radix tree
> entries, we have all the locking necessary to reliably clear the radix
> tree dirty tag when flushing caches for corresponding address range.
> Similarly to page_mkclean() we also have to write-protect pages to get a
> page fault when the page is next written to so that we can mark the
> entry dirty again.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks great. 

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
