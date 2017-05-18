Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 651F421A16EFD
 for <linux-nvdimm@lists.01.org>; Thu, 18 May 2017 01:56:31 -0700 (PDT)
Date: Thu, 18 May 2017 10:56:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 23/23] uuid: remove uuid_be
Message-ID: <20170518085629.GA6149@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-24-hch@lst.de>
 <CAOQ4uxj+TH5vS5HoEFPJXUpneBqr+YwbVES0bsHzw9qmS8HzKg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj+TH5vS5HoEFPJXUpneBqr+YwbVES0bsHzw9qmS8HzKg@mail.gmail.com>
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
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Hugh Dickins <hughd@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>, David Howells <dhowells@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 18, 2017 at 10:57:24AM +0300, Amir Goldstein wrote:
> I reviewed the entire series. You may add
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> to any of the patches as you see fit.

Thanks, done!

> Now let's talk about how this is going to be merged.
> Do you intend to send Linus a pull request?

Yes, that might be the best idea.  I'm also contemplating listing
me plus anyone volunteering (you?, Andy) as maintaines for the uuid
code.

But first I'll need a few more reviews, at least for the XFS bits.

> Get those patches merged via someone else's tree?
> Is this branch listed for linux-next build?

Not yet.

> The reason I am asking is because this last removal patch should probably
> be applied near the end of the merge window (?).
> Because maintainers cannot apply patches with code that uses the new
> uuid_t to linux-next branches and we don't want linux-next build to fail
> with new code that uses uuid_be...

Yeah, we can probably defer that one for now.

> More to the point, I would like to re-post the patch
> ("tmpfs: generate random sb->s_uuid") using uuid_gen()
> instead of generate_random_uuid() as you proposed.
> Hugh has already acked the intent "once fs is agreed on the way to go"
> When and how would I have this patch applied?
> Obvious solution.. can you apply this patch to your branch?

Yes.

> Do you need me to re-post it?

Please do.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
