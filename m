Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EAAEE21F3C181
 for <linux-nvdimm@lists.01.org>; Tue, 10 Oct 2017 12:40:53 -0700 (PDT)
Date: Tue, 10 Oct 2017 12:44:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix mpage_writepage() for pages with buffers
Message-Id: <20171010124421.c545e6308fed5a585acd43cd@linux-foundation.org>
In-Reply-To: <20171006211541.GA7409@bombadil.infradead.org>
References: <20171006211541.GA7409@bombadil.infradead.org>
Mime-Version: 1.0
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
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 6 Oct 2017 14:15:41 -0700 Matthew Wilcox <willy@infradead.org> wrote:

> When using FAT on a block device which supports rw_page, we can hit
> BUG_ON(!PageLocked(page)) in try_to_free_buffers().  This is because we
> call clean_buffers() after unlocking the page we've written.  Introduce a
> new clean_page_buffers() which cleans all buffers associated with a page
> and call it from within bdev_write_page().

This is all pretty mature code (isn't it?).  Any idea why this bug
popped up now?

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
