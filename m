From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 2/9] ext2: tell DAX the size of allocation holes
Date: Fri, 9 Sep 2016 10:48:08 -0600
Message-ID: <20160909164808.GC18554@linux.intel.com>
References: <20160823220419.11717-1-ross.zwisler@linux.intel.com>
 <20160823220419.11717-3-ross.zwisler@linux.intel.com>
 <20160825075728.GA11235@infradead.org>
 <20160826212934.GA11265@linux.intel.com>
 <20160829074116.GA16491@infradead.org>
 <20160829125741.cdnbb2uaditcmnw2@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160829125741.cdnbb2uaditcmnw2-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Mon, Aug 29, 2016 at 08:57:41AM -0400, Theodore Ts'o wrote:
> On Mon, Aug 29, 2016 at 12:41:16AM -0700, Christoph Hellwig wrote:
> > 
> > We're going to move forward killing buffer_heads in XFS.  I think ext4
> > would dramatically benefit from this a well, as would ext2 (although I
> > think all that DAX work in ext2 is a horrible idea to start with).
> 
> It's been on my todo list.  The only reason why I haven't done it yet
> is because I knew you were working on a solution, and I didn't want to
> do things one way for buffered I/O, and a different way for Direct
> I/O, and disentangling the DIO code and the different assumptions of
> how different file systems interact with the DIO code is a *mess*.
> 
> It may have gotten better more recently, but a few years ago I took a
> look at it and backed slowly away.....

Ted, what do you think of the idea of moving to struct iomap in ext2?

If ext2 stays with the current struct buffer_head + get_block_t interface,
then it looks like DAX basically has three options:

1) Support two I/O paths and two versions of each of the fault paths (PTE,
PMD, etc).  One of each of these would be based on struct iomap and would be
used by xfs and potentially ext4, and the other would be based on struct
buffer_head + get_block_t and would be used by ext2.

2) Only have a single struct iomap based I/O path and fault path, and add
shim/support code so that ext2 can use it, leaving the rest of ext2 to be
struct buffer_head + get_block_t based.

3) Only have a single struct buffer_head + get_block_t based DAX I/O and fault
path, and have XFS and potentially ext4 do the translation from their native
struct iomap interface.

It seems ideal for ext2 to switch along with everyone else, if getting rid of
struct buffer_head is a global goal.  If not, I guess barring technical issues
#2 above seems cleanest - move DAX to the new structure, and provide backwards
compatibility to ext2.  Thoughts?
