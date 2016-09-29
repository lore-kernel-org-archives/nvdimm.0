From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 00/11] re-enable DAX PMD support
Date: Thu, 29 Sep 2016 12:23:37 -0600
Message-ID: <20160929182337.GB20307@linux.intel.com>
References: <1475009282-9818-1-git-send-email-ross.zwisler@linux.intel.com>
 <20160928020842.GA4428@infradead.org>
 <20160928045550.GF27872@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160928045550.GF27872@dastard>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Sep 28, 2016 at 02:55:50PM +1000, Dave Chinner wrote:
> On Tue, Sep 27, 2016 at 07:08:42PM -0700, Christoph Hellwig wrote:
> > On Tue, Sep 27, 2016 at 02:47:51PM -0600, Ross Zwisler wrote:
> > > DAX PMDs have been disabled since Jan Kara introduced DAX radix tree based
> > > locking.  This series allows DAX PMDs to participate in the DAX radix tree
> > > based locking scheme so that they can be re-enabled.
> > > 
> > > Jan and Christoph, can you please help review these changes?
> > 
> > About to get on a plane, so it might take a bit to do a real review.
> > In general this looks fine, but I guess the first two ext4 patches
> > should just go straight to Ted independent of the rest?
> > 
> > Also Jan just posted a giant DAX patchbomb, we'll need to find a way
> > to integrate all that work, and maybe prioritize things if we want
> > to get bits into 4.9 still.
> 
> I'm not going to have time to do much review or testing of the DAX
> changes (apart from the cursor comments I've already made) because
> of the huge pile of XFS reflink changes I've got ot get through
> first. However, I've already got the iomap dax bits in the XFS tree
> so I can pull everything through there if review and testing is
> covered otherwise......

Frankly I'd love it if my changes could make it into v4.9 through the XFS
tree.  They've passed xfstests both with and without DAX, and they've passed
all the targeted testing I've been able to throw at them.  If that works, we
can integrate Jan's changes on top of them during the v4.9 cycle and merge for
v4.10.

I'll work on incorporating changes for your feedback, Dave, and hopefully have
a v4 out by the end of the day.
