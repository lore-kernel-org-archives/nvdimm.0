From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 10/12] xfs: use iomap to implement DAX
Date: Thu, 15 Sep 2016 07:14:20 +0200
Message-ID: <20160915051420.GF6188@lst.de>
References: <1473847291-18913-1-git-send-email-hch@lst.de>
 <1473847291-18913-11-git-send-email-hch@lst.de>
 <20160914173247.GC30852@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160914173247.GC30852-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Wed, Sep 14, 2016 at 11:32:47AM -0600, Ross Zwisler wrote:
> I think this should be xfs_setfilesize(ip, pos, ret)?  'count' and 'ret' are
> the same in non-error cases, but in error cases where iomap_dax_rw() does some
> work and then encounters an error, 'ret' could be smaller.  In error cases
> like this using 'ret' instead of 'count' will also keep the value we use in
> i_size_write() equal to what we write via xfs_setfilesize() because
> iocb->ki_pos == pos+ret, not pos+count.

True.  Now with DAX where we can actuall get short writes that
should be fixed.  I spent too much time with the direct I/O code where
this would not happen.
