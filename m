From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
Date: Tue, 28 Jun 2016 17:39:25 +0200
Message-ID: <20160628153925.GA2643@lst.de>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
 <20160623232446.GA12670@dastard> <20160624072612.GA22205@lst.de>
 <20160624230045.GG12670@dastard> <20160628131059.GA30475@lst.de>
 <57727B27.7060104@plexistor.com> <20160628133928.GB31283@lst.de>
 <5772820E.2080403@plexistor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5772820E.2080403-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Boaz Harrosh <boaz-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Tue, Jun 28, 2016 at 04:56:30PM +0300, Boaz Harrosh wrote:
> Actually with O_APPEND each write request should write a different region
> of the file, there are no overlapping writes. And no issue of which version of the
> write came last and got its data written.

You have one fd for multiple threads or processes (it doesn't matter if
you're using O_APPEND or not), and all of them write to it.

i_size is only updated once the write finishes, so having multiple
concurrent writes will mean multiple records go into the same regions.
Now to be fair in current XFS writes beyond i_size will always take
the lock exclusively, so for this case we will not get concurrent
writes and thus data corruption anyway.  But if you have a cycling
log that gets overwritten (say a database journal) we're back to
square one.

> I still don't see how an application can use the fact that two writers
> will not give them mixed records. And surly it does not work on a shared
> FS. So I was really wondering if you know of any such app

If it doesn't work for two threads using the same fd on a shared fs
the fs is broken.
