From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 0/20 v3] dax: Clear dirty bits after flushing caches
Date: Mon, 17 Oct 2016 12:59:55 -0600
Message-ID: <20161017185955.GA13782@linux.intel.com>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <20160930091418.GC24352@infradead.org>
 <20161003075902.GG6457@quack2.suse.cz>
 <20161003080337.GA13688@infradead.org>
 <20161003081549.GH6457@quack2.suse.cz>
 <20161003093248.GA27720@infradead.org>
 <20161003111358.GQ6457@quack2.suse.cz>
 <20161013203434.GD26922@linux.intel.com>
 <20161017084732.GD3359@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161017084732.GD3359-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Mon, Oct 17, 2016 at 10:47:32AM +0200, Jan Kara wrote:

> This week I plan to rebase both series on top of rc1 + your THP patches so
> that we can move on with merging the stuff.

Yea...so how are we going to coordinate merging of these series for the v4.10
merge window?  My series mostly changes DAX, but it also changes XFS, ext2 and
ext4.  I think the plan right now is to have Dave Chinner take it through his
XFS tree.

Your first series is mostly mm changes with some DAX sprinkled in, and your
second series touches dax, mm and all 3 DAX filesystems.  

What is the best way to handle all this?  Have it go through one central tree
(-MM?), even though the changes touch code that exists outside of that trees
normal domain (like the FS code)?  Have my series go through the XFS tree and
yours through -MM, and give Linus a merge resolution patch?  Something else?
