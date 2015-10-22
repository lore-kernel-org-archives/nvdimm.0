Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151022094502.GF14445@quack.suse.cz>
References: <20151022064142.12700.11849.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151022064205.12700.63495.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151022094502.GF14445@quack.suse.cz>
Date: Thu, 22 Oct 2015 08:41:22 -0700
Message-ID: <CAPcyv4jFBb+LN0j_8SNa3F6ET6iFvhURNoLn3EKrjKZiyCttbA@mail.gmail.com>
Subject: Re: [PATCH 4/5] block: introduce file_bd_inode()
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 22, 2015 at 2:45 AM, Jan Kara <jack@suse.cz> wrote:
> On Thu 22-10-15 02:42:05, Dan Williams wrote:
>> Similar to the file_inode() helper, provide a helper to lookup the inode for a
>> raw block device itself.
>
> So I somewhat dislike the name file_bd_inode() since for struct file
> pointing to a regular file, the result would be equivalent to file_inode()
> but the name suggests (at least to me) it should return block device inode.
> I'd name it like bdev_file_inode() to make it clear this is local to
> block device code...

I like it, will fix.
