From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [4.8 hang] xfstests generic/361 hangs on dax enabled filesystems
Date: Thu, 4 Aug 2016 12:54:25 -0600
Message-ID: <20160804185425.GC3128@linux.intel.com>
References: <20160803003354.GP16044@dastard>
	<20160804154805.GA24025@infradead.org>
	<20160804184658.GB3128@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20160804184658.GB3128@linux.intel.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, xfs@oss.sgi.com
List-Id: linux-nvdimm@lists.01.org

On Thu, Aug 04, 2016 at 12:46:58PM -0600, Ross Zwisler wrote:
> On Thu, Aug 04, 2016 at 08:48:05AM -0700, Christoph Hellwig wrote:
> > Just send a fix that you're Cc'ed on.  But now xfs/049 hangs, although
> > only on pmem devices, loop on non-pmem seems to be fine.  4.7 was fine
> > as well.
> 
> I don't think Mike's fix solves this issue.  I'm still able to reproduce the
> hang with linux/master + the patch he sent out.
> 
> Did you retest and get a different result?

Never mind, didn't see that you had sent out patches as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
