From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v5 1/2] xfs: test per-inode DAX flag by IO
Date: Mon, 6 Feb 2017 12:13:18 -0700
Message-ID: <20170206191318.GA12290@linux.intel.com>
References: <1486221472-1007-1-git-send-email-ross.zwisler@linux.intel.com>
 <1486275704-18917-1-git-send-email-xzhou@redhat.com>
 <1486275704-18917-2-git-send-email-xzhou@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1486275704-18917-2-git-send-email-xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Sun, Feb 05, 2017 at 02:21:43PM +0800, Xiong Zhou wrote:
> In a DAX mountpoint, do IO betwen files with and
> without DAX per-inode flag. We do mmap, both
> O_DIRECT and buffered read/write IO in this case.
> Then test again in the same device without dax
> mountoption.
> 
> Add help _require_scratch_dax to make sure we can
> test DAX feature on SCRATCH_DEV.
> 
> Add mmap dio test programme to test read/write
> between a mmap area of one file and another file
> directly or buffered, with different size.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Yep, this fine. :)

> Signed-off-by: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

These changes all look good.

Reviewed-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
