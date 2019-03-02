Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 28DC6211D0C7F
 for <linux-nvdimm@lists.01.org>; Fri,  1 Mar 2019 19:50:13 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id u128so21255702oie.2
 for <linux-nvdimm@lists.01.org>; Fri, 01 Mar 2019 19:50:13 -0800 (PST)
MIME-Version: 1.0
References: <20190301191241.27842-1-willy@infradead.org>
In-Reply-To: <20190301191241.27842-1-willy@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 1 Mar 2019 19:50:01 -0800
Message-ID: <CAPcyv4j6cUpOktma8YRNiC51UZ5HzO_F8x5VzdP6A4HZrOfrrg@mail.gmail.com>
Subject: Re: [PATCH] dax: Flush partial PMDs correctly
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Piotr Balcer <piotr.balcer@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 1, 2019 at 11:12 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> The radix tree would rewind the index in an iterator to the lowest index
> of a multi-slot entry.  The XArray iterators instead leave the index
> unchanged, but I overlooked that when converting DAX from the radix tree
> to the XArray.  Adjust the index that we use for flushing to the start
> of the PMD range.
>
> Fixes: c1901cd33cf4 "page cache: Convert find_get_entries_tag to XArray"
> Reported-by: Piotr Balcer <piotr.balcer@intel.com>
> Tested-by: Dan Williams <dan.j.williams@intel.com>

Given this is a new patch my previous tested-by is invalid.

...that said, this one works.

Tested-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
