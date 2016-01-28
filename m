Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1454009704-25959-2-git-send-email-ross.zwisler@linux.intel.com>
References: <1454009704-25959-1-git-send-email-ross.zwisler@linux.intel.com>
	<1454009704-25959-2-git-send-email-ross.zwisler@linux.intel.com>
Date: Thu, 28 Jan 2016 12:21:39 -0800
Message-ID: <CAPcyv4jMMYEoq6gHbcy_HGzVua4PonzQ+X+X4EHRE1X=qeAM0Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] dax: fix bdev NULL pointer dereferences
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 28, 2016 at 11:35 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> There are a number of places in dax.c that look up the struct block_device
> associated with an inode.  Previously this was done by just using
> inode->i_sb->s_bdev.  This is correct for inodes that exist within the
> filesystems supported by DAX (ext2, ext4 & XFS), but when running DAX
> against raw block devices this value is NULL.  This causes NULL pointer
> dereferences when these block_device pointers are used.
>
> Instead, for raw block devices we need to look up the struct block_device
> using I_BDEV().  This patch fixes all the block_device lookups in dax.c so
> that they work properly for both filesystems and raw block devices.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

It's a bit odd to check if it is a raw device inode in
dax_clear_blocks() since there's no use case to clear blocks in that
case, but I can't think of a better alternative.

Acked-by: Dan Williams <dan.j.williams@intel.com>
