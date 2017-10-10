Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x244.google.com (mail-it0-x244.google.com
 [IPv6:2607:f8b0:4001:c0b::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 08FB820945BB5
 for <linux-nvdimm@lists.01.org>; Tue, 10 Oct 2017 13:28:16 -0700 (PDT)
Received: by mail-it0-x244.google.com with SMTP id 72so204702itl.5
 for <linux-nvdimm@lists.01.org>; Tue, 10 Oct 2017 13:31:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171010124421.c545e6308fed5a585acd43cd@linux-foundation.org>
References: <20171006211541.GA7409@bombadil.infradead.org>
 <20171010124421.c545e6308fed5a585acd43cd@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Oct 2017 13:31:44 -0700
Message-ID: <CA+55aFxcMhj1TfBbk3G4XKzu8fjQDYPiFNS0W8pFqMJ6bdA46Q@mail.gmail.com>
Subject: Re: [PATCH] Fix mpage_writepage() for pages with buffers
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 10, 2017 at 12:44 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> This is all pretty mature code (isn't it?).  Any idea why this bug
> popped up now?

Also, while the patch looks sane, the

        clean_buffers(page, PAGE_SIZE);

line really threw me. That's an insane value to pick, it looks like
"bytes in page", but it isn't. It's just a random value that is bigger
than "PAGE_SIZE >> SECTOR_SHIFT".

I'd prefer to see just ~0u if the intention is just "bigger than
anything possible".

            Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
