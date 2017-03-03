From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [LTP issues] MAP_LOCKED MS_INVALIDATE, dio rw odd count on DAX
Date: Fri, 3 Mar 2017 09:54:20 +0100
Message-ID: <20170303085420.GA4373@quack2.suse.cz>
References: <20170124052405.o7oz6xr3bwwmjxvo@XZHOUW.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170124052405.o7oz6xr3bwwmjxvo-E9dkjZ7ERC1QcClZ3XN9yxcY2uh10dtjAL8bYrjMMd8@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Hi,

going through some old email and found yours...

On Tue 24-01-17 13:24:05, Xiong Zhou wrote:
> LTP tests on DAX show 2 issues.
> 
> msync03 and diotest4, both xfs and ext4,
> 
> non-DAX  pass
> DAX      fail
> 
> 1, MAP_LOCKED && msync with MS_INVALIDATE, which should fail.
> 
> Flag checking code in msync looks ok but missing _LOCK vma falgs
> for DAX mapped vma ? i guess DAX now does not support that ?
> Tracking by LTP testcase "msync03"

So MAP_LOCKED doesn't have a good meaning in case of DAX as there's no page
to lock in memory. Whether we define this means automatic success, failure,
or something else is a question. I don't think anybody has put much thought
into this yet and so results are sometimes rather arbitrary... Thanks for
bringing this up, I'll think about it.

> 2. O_DIRECT rw odd counts on DAX
> 
> read/write 1 byte on file opened with O_DIRECT, EINVAL is
> expected but Success.
> I'm not sure whether this is an issue, please enlighten :)
> Tracking by LTP testcase "dio04 diotest4".

This is expected. Byte addressable memory can handle byte-aligned IOs...

								Honza

-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
