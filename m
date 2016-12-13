From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [ext4]  e2ae766c1b:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/rwsem.c
Date: Tue, 13 Dec 2016 09:47:48 +0100
Message-ID: <20161213084748.GA15362@quack2.suse.cz>
References: <20161212101321.GA37214@inn.lkp.intel.com>
 <20161212163518.GA20728@quack2.suse.cz>
 <20161212221329.GB3622@linux.intel.com>
 <20161212223735.t56oui7vlqhquaks@thunk.org>
 <20161212224851.GA691@linux.intel.com>
 <20161212230020.pbl5wnbqqdgcewlg@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161212230020.pbl5wnbqqdgcewlg-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, kernel test robot <xiaolong.ye-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkp-JC7UmRfGjtg@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Mon 12-12-16 18:00:20, Ted Tso wrote:
> On Mon, Dec 12, 2016 at 03:48:51PM -0700, Ross Zwisler wrote:
> > On Mon, Dec 12, 2016 at 05:37:36PM -0500, Theodore Ts'o wrote:
> > > Is this problem likely to happen in other file systems?  Should I take
> > > this path through the ext4 tree, or would it be better via some other
> > > git tree?
> > > 
> > > 					- Ted
> > 
> > The problem is in the generic DAX code and affects ext4 and xfs equally (ext2
> > doesn't support PMDs).
> 
> Any preferences about how to send this patch to Linus?  This issue is
> the only thing that was causing me to hold off on sending a pull
> request to Linus....

Yeah, just take it unless Dave already did.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
