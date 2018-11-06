Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A172D2117CEBE
 for <linux-nvdimm@lists.01.org>; Tue,  6 Nov 2018 06:48:49 -0800 (PST)
Date: Tue, 6 Nov 2018 06:48:48 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: fsdax memory error handling regression
Message-ID: <20181106144848.GE3074@bombadil.infradead.org>
References: <118cae852d1dbcc582261ae364e75a7bdf3d43ed.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <118cae852d1dbcc582261ae364e75a7bdf3d43ed.camel@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 06, 2018 at 03:44:47AM +0000, Williams, Dan J wrote:
> Hi Willy,
> 
> I'm seeing the following warning with v4.20-rc1 and the "dax.sh" test
> from the ndctl repository:

I'll try to run this myself later today.

> I tried to get this test going on -next before the merge window, but
> -next was not bootable for me. Bisection points to:
> 
>     9f32d221301c dax: Convert dax_lock_mapping_entry to XArray
> 
> At first glance I think we need the old "always retry if we slept"
> behavior. Otherwise this failure seems similar to the issue fixed by
> Ross' change to always retry on any potential collision:
> 
>     b1f382178d15 ext4: close race between direct IO and ext4_break_layouts()
> 
> I'll take a closer look tomorrow to see if that guess is plausible.

If your thought is correct, then this should be all that's needed:

diff --git a/fs/dax.c b/fs/dax.c
index 616e36ea6aaa..529ac9d7c10a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -383,11 +383,8 @@ bool dax_lock_mapping_entry(struct page *page)
 		entry = xas_load(&xas);
 		if (dax_is_locked(entry)) {
 			entry = get_unlocked_entry(&xas);
-			/* Did the page move while we slept? */
-			if (dax_to_pfn(entry) != page_to_pfn(page)) {
-				xas_unlock_irq(&xas);
-				continue;
-			}
+			xas_unlock_irq(&xas);
+			continue;
 		}
 		dax_lock_entry(&xas, entry);
 		xas_unlock_irq(&xas);

I don't quite understand how we'd find a PFN for this page in the tree
after the page has had page->mapping removed.  However, the more I look
at this path, the more I don't like it -- it doesn't handle returning
NULL explicitly, nor does it handle the situation where a PMD is split
to form multiple PTEs explicitly, it just kind of relies on those bit
patterns not matching.

So I kind of like the "just retry without doing anything clever" situation
that the above patch takes us to.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
