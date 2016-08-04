From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [4.8 hang] xfstests generic/361 hangs on dax enabled filesystems
Date: Thu, 4 Aug 2016 08:48:05 -0700
Message-ID: <20160804154805.GA24025@infradead.org>
References: <20160803003354.GP16044@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20160803003354.GP16044@dastard>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, xfs@oss.sgi.com
List-Id: linux-nvdimm@lists.01.org

Just send a fix that you're Cc'ed on.  But now xfs/049 hangs, although
only on pmem devices, loop on non-pmem seems to be fine.  4.7 was fine
as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
