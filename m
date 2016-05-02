Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AC5641A1EF4
 for <linux-nvdimm@lists.01.org>; Mon,  2 May 2016 09:01:59 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id k142so195529028oib.1
 for <linux-nvdimm@lists.01.org>; Mon, 02 May 2016 09:01:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5727753F.6090104@plexistor.com>
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>
 <1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>
 <5727753F.6090104@plexistor.com>
Date: Mon, 2 May 2016 09:01:58 -0700
Message-ID: <CAPcyv4jWPTDbbw6uMFEEt2Kazgw+wb5Pfwroej--uQPE+AtUbA@mail.gmail.com>
Subject: Re: [PATCH v4 5/7] fs: prioritize and separate direct_io from dax_io
From: Dan Williams <dan.j.williams@intel.com>
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
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew@wil.cx>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 2, 2016 at 8:41 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
> On 04/29/2016 12:16 AM, Vishal Verma wrote:
>> All IO in a dax filesystem used to go through dax_do_io, which cannot
>> handle media errors, and thus cannot provide a recovery path that can
>> send a write through the driver to clear errors.
>>
>> Add a new iocb flag for DAX, and set it only for DAX mounts. In the IO
>> path for DAX filesystems, use the same direct_IO path for both DAX and
>> direct_io iocbs, but use the flags to identify when we are in O_DIRECT
>> mode vs non O_DIRECT with DAX, and for O_DIRECT, use the conventional
>> direct_IO path instead of DAX.
>>
>
> Really? What are your thinking here?
>
> What about all the current users of O_DIRECT, you have just made them
> 4 times slower and "less concurrent*" then "buffred io" users. Since
> direct_IO path will queue an IO request and all.
> (And if it is not so slow then why do we need dax_do_io at all? [Rhetorical])
>
> I hate it that you overload the semantics of a known and expected
> O_DIRECT flag, for special pmem quirks. This is an incompatible
> and unrelated overload of the semantics of O_DIRECT.

I think it is the opposite situation, it us undoing the premature
overloading of O_DIRECT that went in without performance numbers.
This implementation clarifies that dax_do_io() handles the lack of a
page cache for buffered I/O and O_DIRECT behaves as it nominally would
by sending an I/O to the driver.  It has the benefit of matching the
error semantics of a typical block device where a buffered write could
hit an error filling the page cache, but an O_DIRECT write potentially
triggers the drive to remap the block.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
