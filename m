Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 13 Apr 2018 13:17:48 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mmap.2: Add description of MAP_SHARED_VALIDATE and
 MAP_SYNC
Message-ID: <20180413111748.pnusziuap54hknrm@quack2.suse.cz>
References: <20171101153648.30166-1-jack@suse.cz>
 <20171101153648.30166-20-jack@suse.cz>
 <CAKgNAkhsFrcdkXNA2cw3o0gJV0uLRtBg9ybaCe5xy1QBC2PgqA@mail.gmail.com>
 <20180412142214.fcxw3g2jxv6bvn7d@quack2.suse.cz>
 <CAKgNAkgtVryFb81QgzwPq8SD241yKDN1xNxOWUUQH9QBYV13SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKgNAkgtVryFb81QgzwPq8SD241yKDN1xNxOWUUQH9QBYV13SA@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org, Linux-MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, "Darrick J . Wong" <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 12-04-18 20:20:12, Michael Kerrisk (man-pages) wrote:
> 
> Thanks for both checking that phrasing. In the end I decided to reword
> the sentence a bot more substantially:
> 
>               In  conjunction  with  the  use of appropriate CPU
>               instructions, this provides users of such mappings
>               with a more efficient way of making data modifica‐
>               tions persistent.

Great, thanks for the improvement!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
