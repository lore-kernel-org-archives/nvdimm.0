From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Date: Mon, 26 Sep 2016 02:08:05 +0200
Message-ID: <20160926000805.GA32252@lst.de>
References: <1473438884-674-1-git-send-email-hch@lst.de>
 <1473438884-674-7-git-send-email-hch@lst.de> <20160909225557.GF30056@dastard>
 <20160910073646.GA18547@lst.de> <20160913155126.GA10622@linux.intel.com>
 <20160914070633.GA17278@lst.de> <20160923210237.GA23346@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160923210237.GA23346-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Fri, Sep 23, 2016 at 03:02:37PM -0600, Ross Zwisler wrote:
> I can just add a hack to hop over the writeback in generic_file_read_iter(),
> but I hesitate to do this because it seems like the correct thing to do is to
> separate the ext4 DAX & DIO paths, which I think you are already doing.

I've started on it, and the read path works fine.  I'm a bit stuck on
the write side as my attempts at it seems to corrupt data fairly easily
when running xfstests.

> I believe that my DAX PMD patches are ready to go, but because of this issue
> they currently only support XFS.  I'm tempted to send them out as they are
> right now since they add a bunch of complexity to DAX that we need to review,
> and that review can fully happen with only XFS support. We can add ext4
> support back in later when it's ready.

Yes, please send them out.  We really should move ext4 over to iomap for
DAX.  I'd love to get some help from someone more familar with ext4,
and can send my code dump to get started.
