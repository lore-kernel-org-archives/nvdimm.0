From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 08/11] ext4: Convert DAX faults to iomap infrastructure
Date: Fri, 4 Nov 2016 01:02:30 +0100
Message-ID: <20161104000230.GH24234@quack2.suse.cz>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
 <1478034381-19037-9-git-send-email-jack@suse.cz>
 <20161102143006.GB18387@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161102143006.GB18387-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ted Tso <tytso-3s7WtUTddSA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Wed 02-11-16 07:30:06, Christoph Hellwig wrote:
> On Tue, Nov 01, 2016 at 10:06:18PM +0100, Jan Kara wrote:
> > Convert DAX faults to use iomap infrastructure. We would not have to start
> > transaction in ext4_dax_fault() anymore since ext4_iomap_begin takes
> > care of that but so far we do that to avoid lock inversion of
> > transaction start with DAX entry lock which gets acquired in
> > dax_iomap_fault() before calling ->iomap_begin handler.
> 
> So far I've tried to avoid the need to avoid having multiple iomap_ops
> for the same fs.  Would you be fine with a new IOMAP_FAULT flag for write
> faults?

Yes, that's another option. If that's better, I'll redo the patch like
that.
								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
