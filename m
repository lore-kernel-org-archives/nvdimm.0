From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: LTP rwtest01 blocks on DAX mountpoint
Date: Mon, 2 Jan 2017 11:05:46 +0100
Message-ID: <20170102100546.GA18058@quack2.suse.cz>
References: <20161224110714.mp2mevzwkhlxm7zw@xzhoul.usersys.redhat.com>
 <20161230093352.efidonh4btdbtaze@XZHOUW.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161230093352.efidonh4btdbtaze-E9dkjZ7ERC1QcClZ3XN9yxcY2uh10dtjAL8bYrjMMd8@public.gmane.org>
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
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Fri 30-12-16 17:33:53, Xiong Zhou wrote:
> On Sat, Dec 24, 2016 at 07:07:14PM +0800, Xiong Zhou wrote:
> > Hi lists,
> > 
> > Since around 20161129 tag, LTP rwtest01 on dax mountpoint blocks
> > on linux-next tree, now on Linus tree.
> > 
> > In "normal", rwtest01 subcase ends in a few minutes, now it keeps
> > running for hours on dax mountpoint, both ext4 and xfs. Ctrl + c
> > can interrupt it.
> 
> Test programme is waiting for a memcpy call to return.
> 
> From sysrq output, kernel code is not blocking on somewhere,
> it just wont return.

Thanks for report. I'll try to reproduce this. Looks like we are forever
retrying the fault or something like that.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
