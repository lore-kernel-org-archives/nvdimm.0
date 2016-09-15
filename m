From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Date: Wed, 14 Sep 2016 22:30:52 -0700
Message-ID: <20160915053052.GI9314@birch.djwong.org>
References: <1473438884-674-1-git-send-email-hch@lst.de>
 <1473438884-674-7-git-send-email-hch@lst.de>
 <20160913231039.GF26002@linux.intel.com>
 <20160914071910.GC17278@lst.de>
 <20160914170759.GA14196@linux.intel.com>
 <20160915051229.GD6188@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160915051229.GD6188-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Thu, Sep 15, 2016 at 07:12:29AM +0200, Christoph Hellwig wrote:
> On Wed, Sep 14, 2016 at 11:07:59AM -0600, Ross Zwisler wrote:
> > I'll bite - why do you think adding a space before labels is a "fairly
> > horrible style"?  Adding them gives a tangible benefit for unified diffs and
> > patches because it's much more useful to know that a change is in a given
> > function than that it follows a label called "out", which could be defined
> > many times in a given file.  Again, the example:
> 
> It's a space based indent in a tab based world.  And with git you can
> get your enhanced diff output with just a small tweak to the git setting.
> Which we're incidentally about to finally get for the kernel tree.

What setting /is/ that, by the way?

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
