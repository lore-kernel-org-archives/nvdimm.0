Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B85FA212108FB
 for <linux-nvdimm@lists.01.org>; Tue, 16 Apr 2019 09:52:24 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id v84so17565533oif.4
 for <linux-nvdimm@lists.01.org>; Tue, 16 Apr 2019 09:52:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190416164154.30390-1-rgoldwyn@suse.de>
 <20190416164154.30390-2-rgoldwyn@suse.de>
In-Reply-To: <20190416164154.30390-2-rgoldwyn@suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Apr 2019 09:52:12 -0700
Message-ID: <CAPcyv4gJ5A6OyNi2GC1SKfcAW2PGv=WBh7eEK=B2jJFYGNGUxA@mail.gmail.com>
Subject: Re: [PATCH 01/18] btrfs: create a mount option for dax
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
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: kilobyte@angband.pl, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, nborisov@suse.com, "Darrick J. Wong" <darrick.wong@oracle.com>, david <david@fromorbit.com>, dsterba@suse.cz, Matthew Wilcox <willy@infradead.org>, Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 16, 2019 at 9:42 AM Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> This sets S_DAX in inode->i_flags, which can be used with
> IS_DAX().
>
> The dax option is restricted to non multi-device mounts.
> dax interacts with the device directly instead of using bio, so
> all bio-hooks which we use for multi-device cannot be performed
> here. While regular read/writes could be manipulated with
> RAID0/1, mmap() is still an issue.
>
> Auto-setting free space tree, because dealing with free space
> inode (specifically readpages) is a nightmare.
> Auto-setting nodatasum because we don't get callback for writing
> checksums after mmap()s.
> Deny compression because it does not work with direct I/O.

I'd like to consider the dax mount option deprecated and require new
implementations to use a dynamic scheme that Darrick and I once
discussed where "dax" (or more specifically the MAP_SYNC semantic) is
an attribute that can be set on an empty directory and then inherited
by all files / directories created in that hierarchy.

Dax mappings are not always a performance win and enabling it for all
files in the filesystem is potentially overkill, and I'm of opinion
that we should step away from an filesystem-global mount option.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
