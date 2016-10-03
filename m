From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 4/6] xfs: Set BH_New for allocated DAX blocks in
 __xfs_get_blocks()
Date: Mon, 3 Oct 2016 09:39:46 -0700
Message-ID: <20161003163946.GA19832@infradead.org>
References: <1474994615-29553-1-git-send-email-jack@suse.cz>
 <1474994615-29553-5-git-send-email-jack@suse.cz>
 <20160927170118.GA15908@infradead.org>
 <20160927171707.GA30327@quack2.suse.cz>
 <20160928021350.GA11309@infradead.org>
 <20161003144246.GA14183@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161003144246.GA14183-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Mon, Oct 03, 2016 at 04:42:46PM +0200, Jan Kara wrote:
> Ah, you are right. After reading the code again this patch is not needed
> anymore because xfs_file_iomap_begin() returns IOMAP_F_NEW whenever we
> allocated block regardless whether it was zeroed-out or not. But if I get it
> right, all the IS_DAX checks in __xfs_get_blocks() can be dropped now, cannot
> they?

Right now the code is required to keep the pmd_fault handler (which
is always disabled though) compiling.  Once that one is gone the
DAX code in __xfs_get_blocks can be removed.  In fact Ross sent a
patch to do just that as part of his PMD fault rework.
