From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Date: Wed, 14 Sep 2016 09:06:33 +0200
Message-ID: <20160914070633.GA17278@lst.de>
References: <1473438884-674-1-git-send-email-hch@lst.de>
 <1473438884-674-7-git-send-email-hch@lst.de> <20160909225557.GF30056@dastard>
 <20160910073646.GA18547@lst.de> <20160913155126.GA10622@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160913155126.GA10622-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

On Tue, Sep 13, 2016 at 09:51:26AM -0600, Ross Zwisler wrote:
> I'm working on this right now.  I expect that most/all of the infrastructure
> between the bh+get_block_t version and the iomap version to be shared, it'll
> just be a matter of having a PMD version of the iomap fault handler.  This
> should be pretty minor.

Yes, I looked at it (although I didn't do any work yet), and the work
should be fairly easy.

> Let's see how it goes, but right now my plan is to have both - I'd like to
> keep feature parity between ext2/ext4 and XFS, and that means having PMD
> faults in ext4 via bh+get_block_t until they move over to iomap.
> 
> Regarding coordination, the PMD v2 series hasn't gotten much review so far, so
> I'm not sure it'll go in for v4.9.  At this point I'm planning on just
> rebasing on top of your iomap series, though if it gets taken sooner I
> wouldn't object.

So let's do iomap first.  I've got stable ext2 support, as well as support
for the block device, although I'm not sure what the proper testing
protocol for that is.  I've started ext4 and read / zero was easy, but
now I'm stuck in the convoluted mess that is the ext4 direct I/O and
DAX path.

Maybe we should get the iomap work into 4.9 and then convert over ext4
as well as adding PMD fault support in the next release.
