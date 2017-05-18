Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8259B21A09132
 for <linux-nvdimm@lists.01.org>; Thu, 18 May 2017 00:57:25 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id w10so6137651oif.1
 for <linux-nvdimm@lists.01.org>; Thu, 18 May 2017 00:57:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170518062705.25902-24-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-24-hch@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 18 May 2017 10:57:24 +0300
Message-ID: <CAOQ4uxj+TH5vS5HoEFPJXUpneBqr+YwbVES0bsHzw9qmS8HzKg@mail.gmail.com>
Subject: Re: [PATCH 23/23] uuid: remove uuid_be
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
Cc: linux-xfs <linux-xfs@vger.kernel.org>, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Hugh Dickins <hughd@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 18, 2017 at 9:27 AM, Christoph Hellwig <hch@lst.de> wrote:
> Everything uses uuid_t now.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Excellent!
I reviewed the entire series. You may add
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

to any of the patches as you see fit.

Now let's talk about how this is going to be merged.
Do you intend to send Linus a pull request?
Get those patches merged via someone else's tree?
Is this branch listed for linux-next build?

The reason I am asking is because this last removal patch should probably
be applied near the end of the merge window (?).
Because maintainers cannot apply patches with code that uses the new
uuid_t to linux-next branches and we don't want linux-next build to fail
with new code that uses uuid_be...

More to the point, I would like to re-post the patch
("tmpfs: generate random sb->s_uuid") using uuid_gen()
instead of generate_random_uuid() as you proposed.
Hugh has already acked the intent "once fs is agreed on the way to go"
When and how would I have this patch applied?
Obvious solution.. can you apply this patch to your branch?
Do you need me to re-post it?

Thanks for working on this!
Amir.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
