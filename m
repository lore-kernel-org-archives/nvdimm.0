Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 90B35213030B6
 for <linux-nvdimm@lists.01.org>; Fri,  2 Aug 2019 12:17:06 -0700 (PDT)
Date: Fri, 2 Aug 2019 12:14:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memremap: move from kernel/ to mm/
Message-Id: <20190802121431.3ef9d271c40703b4145d364e@linux-foundation.org>
In-Reply-To: <20190802083230.GB11000@lst.de>
References: <20190722094143.18387-1-hch@lst.de> <20190802083230.GB11000@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2 Aug 2019 10:32:30 +0200 Christoph Hellwig <hch@lst.de> wrote:

> Andrew,
> 
> I've seen you've queued this up in -mm, but the explicit intent here was
> to quickly merge this after -rc1 so that the move doesn't conflict with
> further development for 5.3.

Didn't know that.

>  Any chance you could send this patch on to Linus?

Sure, I'll add it to today's batch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
